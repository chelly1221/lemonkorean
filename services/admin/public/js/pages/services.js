/**
 * Services Page
 *
 * 3rd Party 서비스 관리 페이지
 */

const ServicesPage = (() => {
  /**
   * 서비스 정의
   */
  const services = [
    {
      id: 'proxmox',
      name: 'Proxmox VE',
      description: '가상화 관리 플랫폼 - VM 및 컨테이너 관리',
      icon: 'fa-server',
      color: 'primary',
      port: 8006,
      host: '192.168.1.77', // Fixed IP for Proxmox host
      path: '',
      category: 'infrastructure',
      features: ['가상 머신 관리', '컨테이너 관리', '스토리지 관리', '네트워크 설정'],
      docs: 'https://www.proxmox.com/en/proxmox-ve/documentation',
      credentials: { username: 'root', password: 'Scott122001&&', note: 'root@pam 으로 로그인' }
    },
    {
      id: 'portainer',
      name: 'Portainer',
      description: 'Docker 컨테이너 관리 웹 UI',
      icon: 'fa-docker',
      color: 'info',
      port: 9443,
      path: '',
      category: 'containers',
      features: ['컨테이너 관리', '이미지 관리', '볼륨 관리', '네트워크 관리'],
      docs: 'https://docs.portainer.io/',
      credentials: { username: '3chan', password: 'Scott122001&&' }
    },
    {
      id: 'grafana',
      name: 'Grafana',
      description: '모니터링 및 시각화 대시보드',
      icon: 'fa-chart-line',
      color: 'warning',
      port: 3000,
      path: '',
      category: 'monitoring',
      features: ['메트릭 시각화', '알림 설정', '대시보드 생성', 'Prometheus 연동'],
      docs: 'https://grafana.com/docs/',
      credentials: { username: 'admin', password: 'Scott122001&&' }
    },
    {
      id: 'prometheus',
      name: 'Prometheus',
      description: '메트릭 수집 및 저장 시스템',
      icon: 'fa-database',
      color: 'danger',
      port: 9090,
      path: '',
      category: 'monitoring',
      features: ['메트릭 수집', '시계열 데이터베이스', '쿼리 언어 (PromQL)', '알림 규칙'],
      docs: 'https://prometheus.io/docs/',
      credentials: { username: '-', password: '-', note: '인증 불필요 (오픈 액세스)' }
    },
    {
      id: 'minio',
      name: 'MinIO Console',
      description: 'S3 호환 객체 스토리지 관리',
      icon: 'fa-cloud',
      color: 'success',
      port: 9001,
      path: '',
      category: 'storage',
      features: ['버킷 관리', '파일 업로드/다운로드', '액세스 키 관리', 'S3 API'],
      docs: 'https://min.io/docs/minio/linux/index.html',
      credentials: { username: '3chan', password: 'Scott122001&&' }
    },
    {
      id: 'rabbitmq',
      name: 'RabbitMQ Management',
      description: '메시지 브로커 관리 콘솔',
      icon: 'fa-exchange-alt',
      color: 'secondary',
      port: 15672,
      path: '',
      category: 'messaging',
      features: ['큐 관리', '메시지 모니터링', '연결 관리', '플러그인 설정'],
      docs: 'https://www.rabbitmq.com/documentation.html',
      credentials: { username: '3chan', password: 'Scott122001&&' }
    },
    {
      id: 'pgadmin',
      name: 'pgAdmin',
      description: 'PostgreSQL 데이터베이스 관리 도구',
      icon: 'fa-database',
      color: 'primary',
      port: 5050,
      path: '',
      category: 'database',
      features: ['SQL 쿼리 실행', '테이블 관리', '백업/복원', '성능 모니터링'],
      docs: 'https://www.pgadmin.org/docs/',
      credentials: { username: '3chan@lemon.com', password: 'Scott122001&&' }
    },
    {
      id: 'mongo-express',
      name: 'Mongo Express',
      description: 'MongoDB 데이터베이스 관리 도구',
      icon: 'fa-leaf',
      color: 'success',
      port: 8081,
      path: '',
      category: 'database',
      features: ['컬렉션 관리', '도큐먼트 편집', '인덱스 관리', 'JSON 뷰어'],
      docs: 'https://github.com/mongo-express/mongo-express',
      credentials: { username: '3chan', password: 'Scott122001&&' }
    },
    {
      id: 'redis-commander',
      name: 'Redis Commander',
      description: 'Redis 데이터베이스 관리 웹 UI',
      icon: 'fa-bolt',
      color: 'danger',
      port: 8082,
      path: '',
      category: 'database',
      features: ['키 브라우저', '값 편집', 'TTL 관리', 'CLI 명령 실행'],
      docs: 'https://github.com/joeferner/redis-commander',
      credentials: { username: '3chan', password: 'Scott122001&&' }
    },
    {
      id: 'nginx-proxy-manager',
      name: 'Nginx Proxy Manager',
      description: '리버스 프록시 및 SSL 인증서 관리',
      icon: 'fa-network-wired',
      color: 'info',
      port: 81,
      path: '',
      category: 'infrastructure',
      features: ['리버스 프록시 설정', 'SSL/TLS 인증서 자동 발급', '도메인 기반 라우팅', '접근 제어 (Access List)'],
      docs: 'https://nginxproxymanager.com/guide/',
      credentials: { username: 'chelly1221.com@gmail.com', password: 'Scott122001&&' }
    }
  ];

  /**
   * 카테고리별 서비스 그룹화
   */
  const categories = {
    infrastructure: { label: '인프라 관리', icon: 'fa-server' },
    containers: { label: '컨테이너 관리', icon: 'fa-boxes' },
    database: { label: '데이터베이스 관리', icon: 'fa-database' },
    monitoring: { label: '모니터링', icon: 'fa-chart-bar' },
    storage: { label: '스토리지', icon: 'fa-hdd' },
    messaging: { label: '메시징', icon: 'fa-comments' }
  };

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('서비스 관리', [])}
          <div class="content-container">
            <div class="alert alert-info mb-4">
              <i class="fas fa-info-circle me-2"></i>
              <strong>프로젝트에서 사용 중인 3rd Party 서비스</strong>
              <p class="mb-0 mt-2">
                아래 서비스들은 Lemon Korean 프로젝트의 인프라, 모니터링, 관리를 위해 사용됩니다.
                각 서비스의 접속 버튼을 클릭하여 관리 콘솔로 이동할 수 있습니다.
              </p>
            </div>

            ${Object.entries(categories).map(([categoryId, category]) => {
              const categoryServices = services.filter(s => s.category === categoryId);
              if (categoryServices.length === 0) return '';

              return `
                <div class="mb-4">
                  <h6 class="mb-3 text-muted" style="font-size: 0.875rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px;">
                    <i class="fas ${category.icon} me-2"></i>${category.label}
                  </h6>
                  <div class="row">
                    ${categoryServices.map(service => renderServiceCard(service)).join('')}
                  </div>
                </div>
              `;
            }).join('')}
          </div>
        </div>
      </div>
    `;
    Router.render(layout);
    Sidebar.updateActive();
    attachEventListeners();
  }

  function renderServiceCard(service) {
    const cardId = `service-${service.id}`;
    return `
      <div class="col-lg-6 mb-3">
        <div class="card service-card">
          <div class="card-header bg-white service-card-header"
               style="cursor: pointer;"
               data-bs-toggle="collapse"
               data-bs-target="#${cardId}"
               aria-expanded="false"
               aria-controls="${cardId}">
            <div class="d-flex justify-content-between align-items-start">
              <div class="flex-grow-1">
                <h5 class="card-title mb-1">
                  <i class="fas ${service.icon} text-${service.color} me-2"></i>
                  ${service.name}
                </h5>
                <p class="text-muted small mb-0">
                  ${service.host ? `${service.host}:${service.port}` : `포트: ${service.port}`}
                </p>
              </div>
              <span class="badge bg-${service.color} ms-2">${categories[service.category].label}</span>
            </div>
          </div>

          <div id="${cardId}" class="collapse">
            <div class="card-body pt-2">
              <p class="card-text mb-3">${service.description}</p>

              <div class="mb-3">
                <strong class="small text-muted">주요 기능:</strong>
                <ul class="small mt-2 mb-0">
                  ${service.features.slice(0, 3).map(f => `<li>${f}</li>`).join('')}
                </ul>
              </div>

              ${service.credentials ? `
                <div class="alert alert-info py-2 px-3 mb-3" style="font-size: 0.85rem;">
                  <strong><i class="fas fa-key me-1"></i>로그인 정보:</strong><br>
                  <code class="text-dark">ID: ${service.credentials.username}</code><br>
                  <code class="text-dark">PW: ${service.credentials.password}</code>
                  ${service.credentials.note ? `<br><small class="text-muted mt-1 d-block"><i class="fas fa-info-circle me-1"></i>${service.credentials.note}</small>` : ''}
                </div>
              ` : ''}

              <div class="d-flex gap-2">
                <button class="btn btn-${service.color} btn-sm flex-grow-1"
                        onclick="ServicesPage.openService('${service.id}', ${service.port}, '${service.path}')">
                  <i class="fas fa-external-link-alt me-1"></i>
                  접속하기
                </button>
                <a href="${service.docs}" target="_blank" class="btn btn-outline-secondary btn-sm" title="문서">
                  <i class="fas fa-book"></i>
                </a>
                <button class="btn btn-outline-secondary btn-sm"
                        onclick="ServicesPage.checkServiceStatus('${service.id}', ${service.port})"
                        title="상태 확인">
                  <i class="fas fa-heartbeat"></i>
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function attachEventListeners() {
    // Event listeners are attached via onclick in the HTML and Bootstrap collapse
  }

  /**
   * 서비스 접속
   */
  function openService(serviceId, port, path = '') {
    const service = services.find(s => s.id === serviceId);
    if (!service) {
      Toast.error('서비스를 찾을 수 없습니다.');
      return;
    }

    // Use service-specific host or current hostname
    const hostname = service.host || window.location.hostname;

    // Services that use HTTPS
    const httpsServices = ['proxmox', 'portainer'];
    const protocol = httpsServices.includes(serviceId) ? 'https' : 'http';
    const url = `${protocol}://${hostname}:${port}${path}`;

    // Show confirmation modal
    Modal.custom({
      title: `${service.name} 접속`,
      body: `
        <div class="alert alert-warning">
          <i class="fas fa-exclamation-triangle me-2"></i>
          <strong>새 창으로 이동합니다</strong>
        </div>
        <p class="mb-2">다음 주소로 이동합니다:</p>
        <p class="mb-0">
          <code>${url}</code>
        </p>
        ${(serviceId === 'proxmox' || serviceId === 'portainer') ? `
          <div class="alert alert-info mt-3 mb-0">
            <i class="fas fa-info-circle me-2"></i>
            <small>
              ${serviceId === 'proxmox' ? 'Proxmox는' : 'Portainer는'} 자체 서명 인증서를 사용하므로 브라우저에서 보안 경고가 표시될 수 있습니다.
              "고급" → "계속 진행"을 선택하여 접속하세요.
            </small>
          </div>
        ` : ''}
      `,
      confirmText: '접속',
      cancelText: '취소',
      onConfirm: () => {
        window.open(url, '_blank');
      }
    });
  }

  /**
   * 서비스 상태 확인
   */
  async function checkServiceStatus(serviceId, port) {
    const service = services.find(s => s.id === serviceId);
    if (!service) {
      Toast.error('서비스를 찾을 수 없습니다.');
      return;
    }

    Toast.info(`${service.name} 상태를 확인하는 중...`);

    try {
      const hostname = service.host || window.location.hostname;
      const httpsServices = ['proxmox', 'portainer'];
      const protocol = httpsServices.includes(serviceId) ? 'https' : 'http';
      const url = `${protocol}://${hostname}:${port}`;

      // Note: Direct status check may fail due to CORS
      // This is a simplified check - in production, use a backend proxy
      const controller = new AbortController();
      const timeoutId = setTimeout(() => controller.abort(), 5000);

      try {
        const response = await fetch(url, {
          method: 'HEAD',
          mode: 'no-cors',
          signal: controller.signal
        });
        clearTimeout(timeoutId);

        // With no-cors, we can't read the response, but if it completes, the service is likely running
        Toast.success(`${service.name} 서비스가 실행 중입니다.`);
      } catch (error) {
        clearTimeout(timeoutId);
        if (error.name === 'AbortError') {
          Toast.warning(`${service.name} 응답 시간 초과 - 서비스가 실행 중이 아니거나 느릴 수 있습니다.`);
        } else {
          // In no-cors mode, network errors might still mean the service is running
          Toast.info(`${service.name} 상태를 확인할 수 없습니다. 직접 접속을 시도해보세요.`);
        }
      }
    } catch (error) {
      Toast.error(`상태 확인 실패: ${error.message}`);
    }
  }

  return {
    render,
    openService,
    checkServiceStatus
  };
})();
