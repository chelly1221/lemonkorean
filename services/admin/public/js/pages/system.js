/**
 * System Page
 *
 * 시스템 모니터링 페이지 (헬스 체크, 메트릭, 로그)
 */

const SystemPage = (() => {
  let refreshInterval = null;

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('시스템 모니터링')}
          <div class="content-container">
            <!-- 헬스 상태 -->
            <div class="row mb-4">
              <div class="col-md-3">
                <div class="health-card">
                  <div class="health-item">
                    <span>PostgreSQL</span>
                    <div class="health-status" id="health-postgres">
                      <div class="spinner-border spinner-border-sm"></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-3">
                <div class="health-card">
                  <div class="health-item">
                    <span>MongoDB</span>
                    <div class="health-status" id="health-mongodb">
                      <div class="spinner-border spinner-border-sm"></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-3">
                <div class="health-card">
                  <div class="health-item">
                    <span>Redis</span>
                    <div class="health-status" id="health-redis">
                      <div class="spinner-border spinner-border-sm"></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-3">
                <div class="health-card">
                  <div class="health-item">
                    <span>MinIO</span>
                    <div class="health-status" id="health-minio">
                      <div class="spinner-border spinner-border-sm"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 시스템 메트릭 -->
            <div class="row mb-4">
              <div class="col-md-6">
                <div class="table-card">
                  <div class="card-header">
                    <h5 class="card-title">시스템 메트릭</h5>
                  </div>
                  <div id="metrics-container">
                    <div class="text-center py-4">
                      <div class="spinner-border text-primary"></div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="table-card">
                  <div class="card-header">
                    <h5 class="card-title">프로세스 정보</h5>
                  </div>
                  <div id="process-info">
                    <div class="text-center py-4">
                      <div class="spinner-border text-primary"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <!-- 감사 로그 -->
            <div class="table-card">
              <div class="card-header">
                <h5 class="card-title">감사 로그 (최근 50개)</h5>
              </div>
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th>시간</th>
                      <th>관리자</th>
                      <th>작업</th>
                      <th>리소스</th>
                      <th>상태</th>
                    </tr>
                  </thead>
                  <tbody id="audit-logs-tbody">
                    <tr><td colspan="5" class="text-center"><div class="spinner-border"></div></td></tr>
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
    await loadData();

    // 30초마다 자동 새로고침
    refreshInterval = setInterval(loadData, 30000);
  }

  async function loadData() {
    try {
      const [healthResponse, metricsResponse, logsResponse] = await Promise.all([
        API.system.getHealth(),
        API.system.getMetrics(),
        API.system.getLogs({ limit: 50 }),
      ]);

      // Unwrap data from response
      const health = healthResponse.data || healthResponse;
      const metrics = metricsResponse.data || metricsResponse;
      const logs = logsResponse.data || logsResponse;

      updateHealthStatus(health);
      updateMetrics(metrics);
      updateLogs(logs);
    } catch (error) {
      console.error('[SystemPage] 데이터 로드 에러:', error);
      Toast.error('시스템 정보를 불러올 수 없습니다.');
    }
  }

  function updateHealthStatus(health) {
    const services = ['postgres', 'mongodb', 'redis', 'minio'];

    services.forEach((service) => {
      const element = document.getElementById(`health-${service}`);
      const serviceData = health.services?.[service];
      const status = serviceData?.status || 'unknown';

      if (status === 'connected' || status === 'healthy') {
        element.innerHTML = '<i class="fas fa-check-circle"></i> 정상';
        element.className = 'health-status healthy';
      } else {
        element.innerHTML = '<i class="fas fa-times-circle"></i> 오류';
        element.className = 'health-status unhealthy';
      }
    });
  }

  function updateMetrics(metrics) {
    const container = document.getElementById('metrics-container');
    const memory = metrics.memory || {};
    const memoryUsage = memory.heapTotal > 0
      ? ((memory.heapUsed / memory.heapTotal) * 100).toFixed(1)
      : 0;

    // 메모리 사용률에 따른 색상 결정
    let memoryColor = 'bg-success'; // 녹색 (안전)
    if (memoryUsage >= 80) {
      memoryColor = 'bg-danger'; // 빨간색 (위험)
    } else if (memoryUsage >= 60) {
      memoryColor = 'bg-warning'; // 노란색 (주의)
    }

    container.innerHTML = `
      <div class="p-3">
        <div class="mb-3">
          <label class="form-label">메모리 사용률</label>
          <div class="progress">
            <div class="progress-bar ${memoryColor}" style="width: ${memoryUsage}%">${memoryUsage}%</div>
          </div>
          <small class="text-muted">
            ${memory.heapUsed || 0} MB / ${memory.heapTotal || 0} MB
          </small>
        </div>
        <div class="mb-3">
          <label class="form-label">가동 시간</label>
          <p>${Formatters.formatDuration(Math.floor((metrics.uptime || 0) / 60))}</p>
        </div>
      </div>
    `;

    const processInfo = document.getElementById('process-info');
    const proc = metrics.process || {};
    processInfo.innerHTML = `
      <div class="p-3">
        <div class="mb-2"><strong>Node.js 버전:</strong> ${proc.version || '-'}</div>
        <div class="mb-2"><strong>Platform:</strong> ${proc.platform || '-'}</div>
        <div class="mb-2"><strong>PID:</strong> ${proc.pid || '-'}</div>
      </div>
    `;
  }

  function updateLogs(logs) {
    const tbody = document.getElementById('audit-logs-tbody');

    if (!logs || logs.length === 0) {
      tbody.innerHTML = '<tr><td colspan="5" class="text-center">로그가 없습니다.</td></tr>';
      return;
    }

    tbody.innerHTML = logs.map(log => `
      <tr>
        <td>${Formatters.formatDate(log.created_at, 'datetime')}</td>
        <td>${log.admin_email || '-'}</td>
        <td>${log.action || '-'}</td>
        <td>${log.resource_type || '-'} #${log.resource_id || '-'}</td>
        <td>
          <span class="badge bg-${log.status === 'success' ? 'success' : 'danger'}">
            ${log.status || '-'}
          </span>
        </td>
      </tr>
    `).join('');
  }

  // Public API 반환
  return {
    render,
    // 페이지 떠날 때 interval 정리
    cleanup: () => {
      if (refreshInterval) {
        clearInterval(refreshInterval);
        refreshInterval = null;
      }
    },
  };
})();
