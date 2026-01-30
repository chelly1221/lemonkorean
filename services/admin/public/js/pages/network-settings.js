/**
 * 네트워크 설정 페이지
 * HTTP/HTTPS 모드 전환
 */
const NetworkSettingsPage = (() => {
  let currentSettings = null;

  async function render() {
    const layout = `
      <style>
        .transition-all {
          transition: all 0.3s ease;
        }
        #mode-description {
          transition: opacity 0.15s ease;
        }
        label[for^="mode-"] .card {
          transition: all 0.2s ease;
        }
        label[for^="mode-"]:hover .card {
          transform: translateY(-2px);
          box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1) !important;
          opacity: 1 !important;
        }
        label[for="mode-dev"]:hover .card.bg-light {
          background-color: rgba(13, 202, 240, 0.05) !important;
          border-color: #0dcaf0 !important;
        }
        label[for="mode-dev"]:hover .card.bg-light .text-secondary {
          color: #0dcaf0 !important;
        }
        label[for="mode-dev"]:hover .card.bg-light .bg-secondary {
          background-color: rgba(13, 202, 240, 0.1) !important;
        }
        label[for="mode-dev"]:hover .card.bg-light .badge {
          background-color: rgba(13, 202, 240, 0.1) !important;
          color: #0dcaf0 !important;
          border-color: #0dcaf0 !important;
        }
        label[for="mode-dev"]:hover .card.bg-light .text-muted:not(small) {
          color: #212529 !important;
        }
        label[for="mode-prod"]:hover .card.bg-light {
          background-color: rgba(25, 135, 84, 0.05) !important;
          border-color: #198754 !important;
        }
        label[for="mode-prod"]:hover .card.bg-light .text-secondary {
          color: #198754 !important;
        }
        label[for="mode-prod"]:hover .card.bg-light .bg-secondary {
          background-color: rgba(25, 135, 84, 0.1) !important;
        }
        label[for="mode-prod"]:hover .card.bg-light .badge {
          background-color: rgba(25, 135, 84, 0.1) !important;
          color: #198754 !important;
          border-color: #198754 !important;
        }
        label[for="mode-prod"]:hover .card.bg-light .text-muted:not(small) {
          color: #212529 !important;
        }
        .badge-sm {
          font-size: 0.75rem;
          padding: 0.25rem 0.5rem;
        }
      </style>
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('네트워크 설정')}
          <div class="content-container">
            <div id="network-content">
              <div class="text-center py-5">
                <div class="spinner-border text-primary" role="status"></div>
                <p class="mt-2 text-muted">로딩 중...</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
    Router.render(layout);
    Sidebar.updateActive();
    await loadSettings();
  }

  async function loadSettings() {
    try {
      const response = await API.network.getSettings();
      currentSettings = response.data;
      updateUI();
    } catch (error) {
      console.error('Failed to load settings:', error);
      document.getElementById('network-content').innerHTML = `
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-triangle me-2"></i>
          <strong>오류:</strong> 네트워크 설정을 불러올 수 없습니다
        </div>
      `;
    }
  }

  function updateUI() {
    const { mode, isRunning } = currentSettings;
    const isDev = mode === 'development';

    const content = `
      <!-- 현재 상태 요약 -->
      <div class="row g-4 mb-4">
        <div class="col-md-6">
          <div class="card border-0 shadow-sm h-100">
            <div class="card-body p-4">
              <div class="d-flex align-items-center">
                <div class="rounded-3 bg-${isDev ? 'info' : 'success'} bg-opacity-10 p-3 me-3">
                  <i class="fas fa-${isDev ? 'laptop-code' : 'shield-alt'} fa-2x text-${isDev ? 'info' : 'success'}"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">현재 모드</div>
                  <h4 class="mb-0">
                    <span class="badge bg-${isDev ? 'info' : 'success'} px-3 py-2">${isDev ? '개발 모드' : '프로덕션 모드'}</span>
                  </h4>
                </div>
              </div>
              <div class="mt-3 pt-3 border-top">
                <div class="d-flex justify-content-between align-items-center">
                  <span class="text-muted small">프로토콜</span>
                  <strong class="text-dark">${isDev ? 'HTTP' : 'HTTPS'}</strong>
                </div>
                <div class="d-flex justify-content-between align-items-center mt-2">
                  <span class="text-muted small">포트</span>
                  <strong class="text-dark">${isDev ? '80' : '443'}</strong>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div class="col-md-6">
          <div class="card border-0 shadow-sm h-100">
            <div class="card-body p-4">
              <div class="d-flex align-items-center">
                <div class="rounded-3 bg-${isRunning ? 'success' : 'danger'} bg-opacity-10 p-3 me-3">
                  <i class="fas fa-server fa-2x text-${isRunning ? 'success' : 'danger'}"></i>
                </div>
                <div class="flex-grow-1">
                  <div class="text-muted small mb-1">Nginx 상태</div>
                  <h4 class="mb-0">
                    <span class="badge bg-${isRunning ? 'success' : 'danger'} px-3 py-2">${isRunning ? '실행 중' : '중지됨'}</span>
                  </h4>
                </div>
              </div>
              <div class="mt-3 pt-3 border-top">
                <div class="d-flex justify-content-between align-items-center">
                  <span class="text-muted small">컨테이너</span>
                  <strong class="text-dark">lemon-nginx</strong>
                </div>
                <div class="d-flex justify-content-between align-items-center mt-2">
                  <span class="text-muted small">상태</span>
                  <span class="badge bg-${isRunning ? 'success' : 'secondary'} badge-sm">${isRunning ? 'healthy' : 'stopped'}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- 모드 선택 -->
      <div class="card border-0 shadow-sm mb-4">
        <div class="card-body p-4">
          <h5 class="mb-4">
            <i class="fas fa-sliders-h me-2 text-primary"></i>
            네트워크 모드 선택
          </h5>

          <div class="row g-4">
            <!-- 개발 모드 옵션 -->
            <div class="col-md-6">
              <input type="radio" class="btn-check" name="mode" id="mode-dev" value="development" ${isDev ? 'checked' : ''}>
              <label class="w-100" for="mode-dev" style="cursor: pointer;">
                <div class="card border-2 ${isDev ? 'border-info' : 'border-light bg-light'} h-100 transition-all" style="${!isDev ? 'opacity: 0.6;' : ''}">
                  <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-3">
                      <div class="rounded-circle ${isDev ? 'bg-info bg-opacity-10' : 'bg-secondary bg-opacity-10'} p-2 me-3">
                        <i class="fas fa-laptop-code fa-lg ${isDev ? 'text-info' : 'text-secondary'}"></i>
                      </div>
                      <div>
                        <h5 class="mb-0 ${isDev ? 'text-dark' : 'text-muted'}">개발 모드</h5>
                        <small class="text-muted">Development</small>
                      </div>
                    </div>
                    <p class="text-muted small mb-3">로컬 개발 및 테스트 환경에 최적화</p>
                    <div class="d-flex flex-wrap gap-2">
                      <span class="badge ${isDev ? 'bg-info bg-opacity-10 text-info border border-info' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">HTTP</span>
                      <span class="badge ${isDev ? 'bg-info bg-opacity-10 text-info border border-info' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">포트 80</span>
                      <span class="badge ${isDev ? 'bg-info bg-opacity-10 text-info border border-info' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">SSL 불필요</span>
                      <span class="badge ${isDev ? 'bg-info bg-opacity-10 text-info border border-info' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">완화된 제한</span>
                    </div>
                  </div>
                </div>
              </label>
            </div>

            <!-- 프로덕션 모드 옵션 -->
            <div class="col-md-6">
              <input type="radio" class="btn-check" name="mode" id="mode-prod" value="production" ${!isDev ? 'checked' : ''}>
              <label class="w-100" for="mode-prod" style="cursor: pointer;">
                <div class="card border-2 ${!isDev ? 'border-success' : 'border-light bg-light'} h-100 transition-all" style="${isDev ? 'opacity: 0.6;' : ''}">
                  <div class="card-body p-4">
                    <div class="d-flex align-items-center mb-3">
                      <div class="rounded-circle ${!isDev ? 'bg-success bg-opacity-10' : 'bg-secondary bg-opacity-10'} p-2 me-3">
                        <i class="fas fa-shield-alt fa-lg ${!isDev ? 'text-success' : 'text-secondary'}"></i>
                      </div>
                      <div>
                        <h5 class="mb-0 ${!isDev ? 'text-dark' : 'text-muted'}">프로덕션 모드</h5>
                        <small class="text-muted">Production</small>
                      </div>
                    </div>
                    <p class="text-muted small mb-3">실제 운영 환경을 위한 보안 강화</p>
                    <div class="d-flex flex-wrap gap-2">
                      <span class="badge ${!isDev ? 'bg-success bg-opacity-10 text-success border border-success' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">HTTPS</span>
                      <span class="badge ${!isDev ? 'bg-success bg-opacity-10 text-success border border-success' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">포트 443</span>
                      <span class="badge ${!isDev ? 'bg-success bg-opacity-10 text-success border border-success' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">SSL 필수</span>
                      <span class="badge ${!isDev ? 'bg-success bg-opacity-10 text-success border border-success' : 'bg-secondary bg-opacity-10 text-secondary border border-secondary'}">엄격한 보안</span>
                    </div>
                  </div>
                </div>
              </label>
            </div>
          </div>

        </div>
      </div>

      <!-- 모드 전환 확인 모달 -->
      <div class="modal fade" id="switchModeModal" tabindex="-1" aria-labelledby="switchModeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-header border-0 pb-0">
              <h5 class="modal-title" id="switchModeModalLabel">
                <i class="fas fa-exchange-alt me-2 text-primary"></i>모드 전환 확인
              </h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
            </div>
            <div class="modal-body py-4">
              <p class="mb-2">
                <strong id="targetModeName" class="text-primary"></strong>로 전환하시겠습니까?
              </p>
              <p class="text-muted small mb-0">
                <i class="fas fa-info-circle me-1"></i>Nginx가 자동으로 재시작됩니다. 잠시 서비스가 중단될 수 있습니다.
              </p>
            </div>
            <div class="modal-footer border-0 pt-0">
              <button type="button" class="btn btn-outline-secondary px-4" data-bs-dismiss="modal">취소</button>
              <button type="button" class="btn btn-primary px-4" id="btn-confirm-switch">
                <i class="fas fa-check me-2"></i>전환
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- 모드별 상세 설정 -->
      <div class="card border-0 shadow-sm">
        <div class="card-body p-4">
          <h5 class="mb-4">
            <i class="fas fa-info-circle me-2 text-primary"></i>
            상세 설정
          </h5>
          <div id="mode-description">
            ${getModeDescription(mode)}
          </div>
        </div>
      </div>
    `;

    document.getElementById('network-content').innerHTML = content;
    attachEventListeners();
  }

  function getModeDescription(mode) {
    if (mode === 'development') {
      return `
        <div class="row g-4">
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-info bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-network-wired fa-lg text-info"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">네트워크</h6>
              <div class="small text-muted">
                <div class="mb-1">HTTP (포트 80)</div>
                <div>CORS 전체 허용</div>
              </div>
            </div>
          </div>
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-info bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-tachometer-alt fa-lg text-info"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">성능</h6>
              <div class="small text-muted">
                <div class="mb-1">제한: 1000 req/s</div>
                <div>캐시: 짧은 시간</div>
              </div>
            </div>
          </div>
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-info bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-lock-open fa-lg text-info"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">보안</h6>
              <div class="small text-muted">
                <div class="mb-1">SSL 불필요</div>
                <div>기본 설정</div>
              </div>
            </div>
          </div>
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-info bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-bug fa-lg text-info"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">디버깅</h6>
              <div class="small text-muted">
                <div class="mb-1">레벨: debug</div>
                <div>상세 로그</div>
              </div>
            </div>
          </div>
        </div>
      `;
    } else {
      return `
        <div class="row g-4">
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-success bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-shield-alt fa-lg text-success"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">네트워크</h6>
              <div class="small text-muted">
                <div class="mb-1">HTTPS (포트 443)</div>
                <div>HTTP 자동 리다이렉트</div>
              </div>
            </div>
          </div>
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-success bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-tachometer-alt fa-lg text-success"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">성능</h6>
              <div class="small text-muted">
                <div class="mb-1">제한: 100 req/s</div>
                <div>캐시: 장기 보관</div>
              </div>
            </div>
          </div>
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-success bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-lock fa-lg text-success"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">보안</h6>
              <div class="small text-muted">
                <div class="mb-1">SSL/TLS 필수</div>
                <div>HSTS, CSP 활성화</div>
              </div>
            </div>
          </div>
          <div class="col-md-3 col-sm-6">
            <div class="text-center p-3 rounded-3 bg-success bg-opacity-10">
              <div class="rounded-circle bg-white d-inline-flex align-items-center justify-content-center mb-3" style="width: 50px; height: 50px;">
                <i class="fas fa-chart-line fa-lg text-success"></i>
              </div>
              <h6 class="fw-bold text-dark mb-2">로깅</h6>
              <div class="small text-muted">
                <div class="mb-1">레벨: warn</div>
                <div>프로덕션 최적화</div>
              </div>
            </div>
          </div>
        </div>
      `;
    }
  }

  let pendingMode = null;
  let switchModal = null;

  function attachEventListeners() {
    // Bootstrap 모달 초기화
    const modalElement = document.getElementById('switchModeModal');
    if (modalElement) {
      switchModal = new bootstrap.Modal(modalElement);
    }

    // 모드 카드 클릭 이벤트
    document.querySelectorAll('label[for^="mode-"]').forEach(label => {
      label.addEventListener('click', (e) => {
        e.preventDefault();

        const targetMode = label.getAttribute('for') === 'mode-dev' ? 'development' : 'production';

        // 현재 모드와 같으면 무시
        if (targetMode === currentSettings.mode) {
          return;
        }

        // 모달에 전환할 모드 표시
        const modeName = targetMode === 'development' ? '개발 모드' : '프로덕션 모드';
        document.getElementById('targetModeName').textContent = modeName;

        // 전환할 모드 저장
        pendingMode = targetMode;

        // 모달 표시
        switchModal.show();
      });
    });

    // 모달 전환 버튼 클릭
    document.getElementById('btn-confirm-switch')?.addEventListener('click', async () => {
      if (pendingMode) {
        switchModal.hide();
        await switchMode(pendingMode);
        pendingMode = null;
      }
    });
  }

  async function switchMode(targetMode) {
    const modeName = targetMode === 'development' ? '개발 모드' : '프로덕션 모드';

    try {
      Toast.info(`${modeName}로 전환하는 중...`);

      // 설정 저장
      await API.network.updateSettings({ mode: targetMode });

      // Nginx 재시작
      await API.network.restartNginx();

      Toast.success(`${modeName}로 전환되었습니다!`);

      // 2초 후 설정 다시 로드
      setTimeout(async () => {
        await loadSettings();
      }, 2000);
    } catch (error) {
      console.error('Failed to switch mode:', error);
      Toast.error('모드 전환 실패');
    }
  }

  return {
    render,
    cleanup: () => {
      // Cleanup if needed
    }
  };
})();
