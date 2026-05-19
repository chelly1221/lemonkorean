/**
 * Deploy Page
 *
 * APK 빌드 관리 페이지
 */

const DeployPage = (() => {
  // APK build state
  let currentBuildId = null;
  let apkStatusInterval = null;
  let apkLogsInterval = null;
  let lastApkLogId = 0;
  let apkBuildStartTime = null;

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('APK 빌드')}
          <div class="content-container">

            <!-- Build Button -->
            <div class="mb-4">
              <button id="apk-build-btn" class="btn btn-success btn-lg" onclick="DeployPage.startAPKBuild()">
                <i class="fas fa-hammer me-2"></i>
                APK 빌드
              </button>
              <p class="text-muted mt-2">
                Flutter APK를 빌드합니다. 약 15-20분 소요됩니다.
              </p>
            </div>

            <!-- Current Build Progress -->
            <div id="current-apk-build" style="display: none;">
              <div class="table-card mb-4">
                <div class="card-header">
                  <h5 class="card-title">APK 빌드 진행 중</h5>
                </div>
                <div class="card-body">
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-2">
                      <span>진행 상황: <strong id="apk-build-status-text">초기화 중...</strong></span>
                      <span id="apk-build-progress-percent">0%</span>
                    </div>
                    <div class="progress" style="height: 25px;">
                      <div id="apk-build-progress-bar" class="progress-bar progress-bar-striped progress-bar-animated bg-success"
                           role="progressbar" style="width: 0%;">
                      </div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <small class="text-muted">경과 시간: <span id="apk-build-elapsed">0s</span></small>
                  </div>
                  <div class="mb-3">
                    <button class="btn btn-sm btn-danger" onclick="DeployPage.cancelAPKBuild()">
                      <i class="fas fa-times me-1"></i>
                      빌드 취소
                    </button>
                  </div>

                  <!-- Live Logs -->
                  <h6>실시간 로그</h6>
                  <div id="apk-build-logs" class="log-viewer">
                    <div class="text-muted">로그를 불러오는 중...</div>
                  </div>
                </div>
              </div>
            </div>

            <!-- Build History -->
            <div class="table-card">
              <div class="card-header">
                <h5 class="card-title">APK 빌드 이력</h5>
              </div>
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>관리자</th>
                      <th>상태</th>
                      <th>진행률</th>
                      <th>APK 크기</th>
                      <th>소요 시간</th>
                      <th>시작 시간</th>
                      <th>작업</th>
                    </tr>
                  </thead>
                  <tbody id="apk-build-history-tbody">
                    <tr>
                      <td colspan="8" class="text-center">
                        <div class="spinner-border text-success"></div>
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

    // Check if there's an active build
    await checkActiveAPKBuild();

    // Load history
    await loadAPKBuildHistory();
  }

  // ============================================================================
  // APK Build Functions
  // ============================================================================

  async function startAPKBuild() {
    Modal.confirm(
      'APK를 빌드하시겠습니까?<br><small class="text-muted">약 15-20분이 소요됩니다.</small>',
      async () => {
        try {
          const buildBtn = document.getElementById('apk-build-btn');
          buildBtn.disabled = true;
          buildBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>시작 중...';

          const response = await API.deploy.startAPK();
          currentBuildId = response.data.buildId;
          apkBuildStartTime = Date.now();
          lastApkLogId = 0;

          Toast.info('APK 빌드가 시작되었습니다.');

          document.getElementById('current-apk-build').style.display = 'block';

          startAPKPolling();

        } catch (error) {
          Toast.error(error.message || 'APK 빌드 시작 실패');
          const buildBtn = document.getElementById('apk-build-btn');
          buildBtn.disabled = false;
          buildBtn.innerHTML = '<i class="fas fa-hammer me-2"></i>APK 빌드';
        }
      }
    );
  }

  async function cancelAPKBuild() {
    Modal.confirm(
      'APK 빌드를 취소하시겠습니까?',
      async () => {
        try {
          await API.deploy.cancelAPK(currentBuildId);
          Toast.warning('APK 빌드가 취소되었습니다.');
          stopAPKPolling();
          await loadAPKBuildHistory();
        } catch (error) {
          Toast.error('APK 빌드 취소 실패');
        }
      }
    );
  }

  async function checkActiveAPKBuild() {
    try {
      const history = await API.deploy.listAPKHistory({ limit: 1 });

      if (history.data.length > 0) {
        const latest = history.data[0];

        if (['pending', 'building', 'signing'].includes(latest.status)) {
          const startedAt = new Date(latest.started_at).getTime();
          const now = Date.now();
          const ageMinutes = (now - startedAt) / 1000 / 60;

          if (ageMinutes > 35) {
            console.warn(`APK build ${latest.id} is stale (${ageMinutes.toFixed(1)} minutes old)`);
            return;
          }

          currentBuildId = latest.id;
          apkBuildStartTime = new Date(latest.started_at).getTime();
          document.getElementById('current-apk-build').style.display = 'block';
          document.getElementById('apk-build-btn').disabled = true;
          startAPKPolling();
        }
      }
    } catch (error) {
      console.error('Failed to check active APK build:', error);
    }
  }

  function startAPKPolling() {
    const POLLING_TIMEOUT = 35 * 60 * 1000;
    const pollingStartTime = Date.now();

    apkStatusInterval = setInterval(async () => {
      if (Date.now() - pollingStartTime > POLLING_TIMEOUT) {
        stopAPKPolling();
        Toast.error('APK 빌드 타임아웃');
        const buildBtn = document.getElementById('apk-build-btn');
        buildBtn.disabled = false;
        buildBtn.innerHTML = '<i class="fas fa-hammer me-2"></i>APK 빌드';
        return;
      }

      try {
        const response = await API.deploy.getAPKStatus(currentBuildId);
        const status = response.data || response;  // API 응답 구조 처리
        updateAPKProgressUI(status);

        if (apkBuildStartTime) {
          const elapsed = Math.floor((Date.now() - apkBuildStartTime) / 1000);
          document.getElementById('apk-build-elapsed').textContent = formatDuration(elapsed);
        }

        if (['completed', 'failed', 'cancelled'].includes(status.status)) {
          stopAPKPolling();

          const buildBtn = document.getElementById('apk-build-btn');
          buildBtn.disabled = false;
          buildBtn.innerHTML = '<i class="fas fa-hammer me-2"></i>APK 빌드';

          if (status.status === 'completed') {
            Toast.success('✅ APK 빌드가 완료되었습니다!');
          } else if (status.status === 'failed') {
            Toast.error('❌ APK 빌드가 실패했습니다.');
          } else {
            Toast.warning('APK 빌드가 취소되었습니다.');
          }

          await loadAPKBuildHistory();
        }
      } catch (error) {
        console.error('Failed to fetch APK status:', error);
      }
    }, 2000);

    apkLogsInterval = setInterval(async () => {
      try {
        const logs = await API.deploy.getAPKLogs(currentBuildId, lastApkLogId);

        if (logs.data.length > 0) {
          appendAPKLogs(logs.data);
          lastApkLogId = logs.data[logs.data.length - 1].id;
        }
      } catch (error) {
        console.error('Failed to fetch APK logs:', error);
      }
    }, 2000);
  }

  function stopAPKPolling() {
    if (apkStatusInterval) {
      clearInterval(apkStatusInterval);
      apkStatusInterval = null;
    }
    if (apkLogsInterval) {
      clearInterval(apkLogsInterval);
      apkLogsInterval = null;
    }
  }

  function updateAPKProgressUI(status) {
    const statusText = {
      'pending': '대기 중',
      'building': '빌드 중',
      'signing': '서명 중',
      'completed': '완료',
      'failed': '실패',
      'cancelled': '취소됨'
    };

    document.getElementById('apk-build-status-text').textContent = statusText[status.status] || status.status;
    document.getElementById('apk-build-progress-percent').textContent = `${status.progress ?? 0}%`;

    const progressBar = document.getElementById('apk-build-progress-bar');
    progressBar.style.width = `${status.progress ?? 0}%`;

    if (status.status === 'completed') {
      progressBar.classList.remove('progress-bar-animated', 'progress-bar-striped');
      progressBar.classList.add('bg-success');
    } else if (status.status === 'failed') {
      progressBar.classList.remove('progress-bar-animated', 'progress-bar-striped');
      progressBar.classList.add('bg-danger');
    }
  }

  function appendAPKLogs(logs) {
    const logsContainer = document.getElementById('apk-build-logs');

    if (logsContainer.children.length === 1 &&
        logsContainer.children[0].textContent.includes('로그를 불러오는 중')) {
      logsContainer.innerHTML = '';
    }

    logs.forEach(log => {
      const logLine = document.createElement('div');
      logLine.style.marginBottom = '2px';

      let color = '#d4d4d4';
      if (log.log_type === 'error') color = '#f48771';
      if (log.log_type === 'warning') color = '#dcdcaa';

      const timestamp = new Date(log.created_at).toLocaleTimeString('ko-KR');
      logLine.innerHTML = `<span style="color: #808080;">[${timestamp}]</span> <span style="color: ${color};">${escapeHtml(log.message)}</span>`;

      logsContainer.appendChild(logLine);
    });

    logsContainer.scrollTop = logsContainer.scrollHeight;

    while (logsContainer.children.length > 500) {
      logsContainer.removeChild(logsContainer.firstChild);
    }
  }

  async function loadAPKBuildHistory() {
    try {
      const history = await API.deploy.listAPKHistory({ limit: 20 });

      const tbody = document.getElementById('apk-build-history-tbody');

      if (history.data.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" class="text-center text-muted">APK 빌드 이력이 없습니다.</td></tr>';
        return;
      }

      tbody.innerHTML = history.data.map(build => {
        const statusBadge = getAPKStatusBadge(build.status);
        const duration = build.duration_seconds ? formatDuration(build.duration_seconds) : '-';
        const startedAt = new Date(build.started_at).toLocaleString('ko-KR');
        const apkSize = build.apk_size_bytes ? formatBytes(build.apk_size_bytes) : '-';

        const downloadBtn = build.status === 'completed' && build.apk_path
          ? `<button class="btn btn-sm btn-outline-success me-1" onclick="DeployPage.downloadAPK(${build.id})">
               <i class="fas fa-download"></i>
             </button>`
          : '';

        return `
          <tr>
            <td>${build.id}</td>
            <td>${escapeHtml(build.admin_email)}</td>
            <td>${statusBadge}</td>
            <td>${build.progress ?? 0}%</td>
            <td>${apkSize}</td>
            <td>${duration}</td>
            <td>${startedAt}</td>
            <td>
              ${downloadBtn}
              <button class="btn btn-sm btn-outline-primary" onclick="DeployPage.viewAPKLogs(${build.id})">
                <i class="fas fa-file-alt"></i>
              </button>
            </td>
          </tr>
        `;
      }).join('');

    } catch (error) {
      console.error('Failed to load APK history:', error);
      Toast.error('APK 빌드 이력을 불러올 수 없습니다.');
    }
  }

  function getAPKStatusBadge(status) {
    const badges = {
      'completed': '<span class="badge bg-success">완료</span>',
      'failed': '<span class="badge bg-danger">실패</span>',
      'cancelled': '<span class="badge bg-warning">취소</span>',
      'building': '<span class="badge bg-primary">빌드 중</span>',
      'signing': '<span class="badge bg-info">서명 중</span>',
      'pending': '<span class="badge bg-secondary">대기</span>'
    };
    return badges[status] || `<span class="badge bg-secondary">${status}</span>`;
  }

  async function viewAPKLogs(buildId) {
    try {
      const logs = await API.deploy.getAPKLogs(buildId, 0);

      const logsHtml = logs.data.map(log => {
        const time = new Date(log.created_at).toLocaleTimeString('ko-KR');
        return `[${time}] ${escapeHtml(log.message)}`;
      }).join('\n');

      Modal.show({
        title: `APK 빌드 로그 #${buildId}`,
        body: `<pre class="log-viewer" style="max-height: 400px;">${logsHtml}</pre>`,
        size: 'lg'
      });
    } catch (error) {
      Toast.error('로그를 불러올 수 없습니다.');
    }
  }

  async function downloadAPK(buildId) {
    try {
      Toast.info('APK 다운로드를 시작합니다.');
      await API.deploy.downloadAPK(buildId);
      // Toast.success will be shown automatically when download completes
    } catch (error) {
      console.error('APK download failed:', error);
      Toast.error(error.message || 'APK 다운로드 실패');
    }
  }

  // ============================================================================
  // Utility Functions
  // ============================================================================

  function formatDuration(seconds) {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins}m ${secs}s`;
  }

  function formatBytes(bytes) {
    if (bytes === 0) return '0 B';
    const k = 1024;
    const sizes = ['B', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
  }

  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  function cleanup() {
    stopAPKPolling();
  }

  return {
    render,
    cleanup,
    startAPKBuild,
    cancelAPKBuild,
    viewAPKLogs,
    downloadAPK
  };
})();
