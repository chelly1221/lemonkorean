/**
 * Deploy Page
 *
 * 웹 배포 관리 페이지
 */

const DeployPage = (() => {
  let currentDeploymentId = null;
  let statusInterval = null;
  let logsInterval = null;
  let lastLogId = 0;
  let deployStartTime = null;

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('웹 배포')}
          <div class="content-container">

            <!-- Deploy Button -->
            <div class="mb-4">
              <button id="deploy-btn" class="btn btn-primary btn-lg" onclick="DeployPage.startDeploy()">
                <i class="fas fa-rocket me-2"></i>
                웹 앱 배포
              </button>
              <p class="text-muted mt-2">
                Flutter 웹 앱을 빌드하고 배포합니다. 약 9-10분 소요됩니다.
              </p>
            </div>

            <!-- Current Deployment Progress -->
            <div id="current-deployment" style="display: none;">
              <div class="table-card mb-4">
                <div class="card-header">
                  <h5 class="card-title">배포 진행 중</h5>
                </div>
                <div class="card-body">
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-2">
                      <span>진행 상황: <strong id="deploy-status-text">초기화 중...</strong></span>
                      <span id="deploy-progress-percent">0%</span>
                    </div>
                    <div class="progress" style="height: 25px;">
                      <div id="deploy-progress-bar" class="progress-bar progress-bar-striped progress-bar-animated"
                           role="progressbar" style="width: 0%;">
                      </div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <small class="text-muted">경과 시간: <span id="deploy-elapsed">0s</span></small>
                  </div>
                  <div class="mb-3">
                    <button class="btn btn-sm btn-danger" onclick="DeployPage.cancelDeploy()">
                      <i class="fas fa-times me-1"></i>
                      배포 취소
                    </button>
                  </div>

                  <!-- Live Logs -->
                  <h6>실시간 로그</h6>
                  <div id="deploy-logs" style="
                    background: #1e1e1e;
                    color: #d4d4d4;
                    padding: 15px;
                    border-radius: 5px;
                    height: 300px;
                    overflow-y: auto;
                    font-family: 'Courier New', monospace;
                    font-size: 13px;
                  ">
                    <div class="text-muted">로그를 불러오는 중...</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Deployment History -->
            <div class="table-card">
              <div class="card-header">
                <h5 class="card-title">배포 이력</h5>
              </div>
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>관리자</th>
                      <th>상태</th>
                      <th>진행률</th>
                      <th>소요 시간</th>
                      <th>시작 시간</th>
                      <th>작업</th>
                    </tr>
                  </thead>
                  <tbody id="deploy-history-tbody">
                    <tr>
                      <td colspan="7" class="text-center">
                        <div class="spinner-border text-primary"></div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

          </div>
        </div>
      </div>
    `;

    Router.render(layout);
    Sidebar.updateActive();

    // Check if there's an active deployment
    await checkActiveDeployment();

    // Load history
    await loadDeploymentHistory();
  }

  async function startDeploy() {
    Modal.confirm(
      '웹 앱을 배포하시겠습니까?<br><small class="text-muted">약 9-10분이 소요됩니다.</small>',
      {
        onConfirm: async () => {
          try {
            const deployBtn = document.getElementById('deploy-btn');
            deployBtn.disabled = true;
            deployBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>시작 중...';

            const response = await API.deploy.startWeb();
            currentDeploymentId = response.data.deploymentId;
            deployStartTime = Date.now();
            lastLogId = 0;

            Toast.info('배포가 시작되었습니다.');

            // Show progress section
            document.getElementById('current-deployment').style.display = 'block';

            // Start polling
            startPolling();

          } catch (error) {
            Toast.error(error.message || '배포 시작 실패');
            const deployBtn = document.getElementById('deploy-btn');
            deployBtn.disabled = false;
            deployBtn.innerHTML = '<i class="fas fa-rocket me-2"></i>웹 앱 배포';
          }
        }
      }
    );
  }

  async function cancelDeploy() {
    Modal.confirm(
      '배포를 취소하시겠습니까?',
      {
        onConfirm: async () => {
          try {
            await API.deploy.cancel(currentDeploymentId);
            Toast.warning('배포가 취소되었습니다.');
            stopPolling();
            await loadDeploymentHistory();
          } catch (error) {
            Toast.error('배포 취소 실패');
          }
        }
      }
    );
  }

  async function checkActiveDeployment() {
    try {
      const history = await API.deploy.listHistory({ limit: 1 });

      if (history.data.length > 0) {
        const latest = history.data[0];

        // If latest deployment is still running
        if (['pending', 'building', 'syncing', 'restarting', 'validating'].includes(latest.status)) {
          currentDeploymentId = latest.id;
          deployStartTime = new Date(latest.started_at).getTime();
          document.getElementById('current-deployment').style.display = 'block';
          document.getElementById('deploy-btn').disabled = true;
          startPolling();
        }
      }
    } catch (error) {
      console.error('Failed to check active deployment:', error);
    }
  }

  function startPolling() {
    // Poll status every 2 seconds
    statusInterval = setInterval(async () => {
      try {
        const status = await API.deploy.getStatus(currentDeploymentId);

        // Update UI
        updateProgressUI(status);

        // Update elapsed time
        if (deployStartTime) {
          const elapsed = Math.floor((Date.now() - deployStartTime) / 1000);
          document.getElementById('deploy-elapsed').textContent = formatDuration(elapsed);
        }

        // Check if completed
        if (['completed', 'failed', 'cancelled'].includes(status.status)) {
          stopPolling();

          const deployBtn = document.getElementById('deploy-btn');
          deployBtn.disabled = false;
          deployBtn.innerHTML = '<i class="fas fa-rocket me-2"></i>웹 앱 배포';

          if (status.status === 'completed') {
            Toast.success('✅ 배포가 완료되었습니다!');
          } else if (status.status === 'failed') {
            Toast.error('❌ 배포가 실패했습니다.');
          } else {
            Toast.warning('배포가 취소되었습니다.');
          }

          // Reload history
          await loadDeploymentHistory();
        }
      } catch (error) {
        console.error('Failed to fetch status:', error);
      }
    }, 2000);

    // Poll logs every 2 seconds
    logsInterval = setInterval(async () => {
      try {
        const logs = await API.deploy.getLogs(currentDeploymentId, lastLogId);

        if (logs.data.length > 0) {
          appendLogs(logs.data);
          lastLogId = logs.data[logs.data.length - 1].id;
        }
      } catch (error) {
        console.error('Failed to fetch logs:', error);
      }
    }, 2000);
  }

  function stopPolling() {
    if (statusInterval) {
      clearInterval(statusInterval);
      statusInterval = null;
    }
    if (logsInterval) {
      clearInterval(logsInterval);
      logsInterval = null;
    }
  }

  function updateProgressUI(status) {
    const statusText = {
      'pending': '대기 중',
      'building': '빌드 중',
      'syncing': '동기화 중',
      'restarting': '재시작 중',
      'validating': '검증 중',
      'completed': '완료',
      'failed': '실패',
      'cancelled': '취소됨'
    };

    document.getElementById('deploy-status-text').textContent = statusText[status.status] || status.status;
    document.getElementById('deploy-progress-percent').textContent = `${status.progress}%`;

    const progressBar = document.getElementById('deploy-progress-bar');
    progressBar.style.width = `${status.progress}%`;

    if (status.status === 'completed') {
      progressBar.classList.remove('progress-bar-animated', 'progress-bar-striped');
      progressBar.classList.add('bg-success');
    } else if (status.status === 'failed') {
      progressBar.classList.remove('progress-bar-animated', 'progress-bar-striped');
      progressBar.classList.add('bg-danger');
    }
  }

  function appendLogs(logs) {
    const logsContainer = document.getElementById('deploy-logs');

    // Clear "loading" message on first log
    if (logsContainer.children.length === 1 &&
        logsContainer.children[0].textContent.includes('로그를 불러오는 중')) {
      logsContainer.innerHTML = '';
    }

    logs.forEach(log => {
      const logLine = document.createElement('div');
      logLine.style.marginBottom = '2px';

      // Color based on log type
      let color = '#d4d4d4'; // info
      if (log.log_type === 'error') color = '#f48771';
      if (log.log_type === 'warning') color = '#dcdcaa';

      const timestamp = new Date(log.created_at).toLocaleTimeString('ko-KR');
      logLine.innerHTML = `<span style="color: #808080;">[${timestamp}]</span> <span style="color: ${color};">${escapeHtml(log.message)}</span>`;

      logsContainer.appendChild(logLine);
    });

    // Auto-scroll to bottom
    logsContainer.scrollTop = logsContainer.scrollHeight;

    // Limit to 500 lines
    while (logsContainer.children.length > 500) {
      logsContainer.removeChild(logsContainer.firstChild);
    }
  }

  async function loadDeploymentHistory() {
    try {
      const history = await API.deploy.listHistory({ limit: 20 });

      const tbody = document.getElementById('deploy-history-tbody');

      if (history.data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">배포 이력이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = history.data.map(deploy => {
        const statusBadge = getStatusBadge(deploy.status);
        const duration = deploy.duration_seconds
          ? formatDuration(deploy.duration_seconds)
          : '-';
        const startedAt = new Date(deploy.started_at).toLocaleString('ko-KR');

        return `
          <tr>
            <td>${deploy.id}</td>
            <td>${escapeHtml(deploy.admin_email)}</td>
            <td>${statusBadge}</td>
            <td>${deploy.progress}%</td>
            <td>${duration}</td>
            <td>${startedAt}</td>
            <td>
              <button class="btn btn-sm btn-outline-primary" onclick="DeployPage.viewLogs(${deploy.id})">
                <i class="fas fa-file-alt"></i>
              </button>
            </td>
          </tr>
        `;
      }).join('');

    } catch (error) {
      console.error('Failed to load history:', error);
      Toast.error('배포 이력을 불러올 수 없습니다.');
    }
  }

  function getStatusBadge(status) {
    const badges = {
      'completed': '<span class="badge bg-success">완료</span>',
      'failed': '<span class="badge bg-danger">실패</span>',
      'cancelled': '<span class="badge bg-warning">취소</span>',
      'building': '<span class="badge bg-primary">빌드 중</span>',
      'syncing': '<span class="badge bg-info">동기화 중</span>',
      'restarting': '<span class="badge bg-info">재시작 중</span>',
      'validating': '<span class="badge bg-info">검증 중</span>',
      'pending': '<span class="badge bg-secondary">대기</span>'
    };
    return badges[status] || `<span class="badge bg-secondary">${status}</span>`;
  }

  function formatDuration(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}m ${secs}s`;
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  async function viewLogs(deploymentId) {
    try {
      const logs = await API.deploy.getLogs(deploymentId, 0);

      const logsHtml = logs.data.map(log => {
        const time = new Date(log.created_at).toLocaleTimeString('ko-KR');
        return `[${time}] ${escapeHtml(log.message)}`;
      }).join('\n');

      Modal.show({
        title: `배포 로그 #${deploymentId}`,
        body: `<pre style="max-height: 400px; overflow-y: auto; background: #1e1e1e; color: #d4d4d4; padding: 15px; border-radius: 5px; font-family: 'Courier New', monospace; font-size: 13px;">${logsHtml}</pre>`,
        size: 'lg'
      });
    } catch (error) {
      Toast.error('로그를 불러올 수 없습니다.');
    }
  }

  function cleanup() {
    stopPolling();
  }

  return {
    render,
    cleanup,
    startDeploy,
    cancelDeploy,
    viewLogs
  };
})();
