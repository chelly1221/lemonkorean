/**
 * SPA Router
 *
 * Hash-based 라우팅 시스템
 * - 페이지 리로드 없이 부드러운 화면 전환
 * - 인증이 필요한 페이지 자동 보호
 * - 브라우저 뒤로가기/앞으로가기 지원
 *
 * 라우트 정의:
 * - #/login           → 로그인
 * - #/dashboard       → 대시보드
 * - #/users           → 사용자 목록
 * - #/users/:id       → 사용자 상세
 * - #/lessons         → 레슨 목록
 * - #/lessons/new     → 레슨 생성
 * - #/lessons/:id     → 레슨 수정
 * - #/vocabulary      → 단어 목록
 * - #/media           → 미디어 관리
 * - #/services        → 서비스 관리
 * - #/system          → 시스템 모니터링
 *
 * 사용 예시:
 * Router.navigate('/dashboard');
 * Router.navigate('/lessons/123');
 */

const Router = (() => {
  // 라우트 정의
  const routes = [];

  // 현재 페이지 컨테이너
  const appContainer = document.getElementById('app');

  /**
   * 라우트 등록
   *
   * @param {string} path - 라우트 경로 (예: '/dashboard', '/users/:id')
   * @param {Function} handler - 페이지 렌더링 함수
   * @param {boolean} requireAuth - 인증 필요 여부 (기본값: true)
   *
   * @example
   * Router.register('/dashboard', DashboardPage.render, true);
   * Router.register('/users/:id', UsersPage.renderDetail, true);
   */
  function register(path, handler, requireAuth = true) {
    routes.push({
      path,
      handler,
      requireAuth,
      // 정규식 패턴으로 변환 (동적 파라미터 지원)
      // 예: '/users/:id' → /^\/users\/([^/]+)$/
      regex: pathToRegex(path),
    });
  }

  /**
   * 경로를 정규식으로 변환
   *
   * @param {string} path - 라우트 경로
   * @returns {RegExp} 정규식 패턴
   *
   * @example
   * pathToRegex('/users/:id')  // /^\/users\/([^/]+)$/
   * pathToRegex('/lessons')    // /^\/lessons$/
   */
  function pathToRegex(path) {
    // :param을 ([^/]+)로 변환
    const pattern = path
      .replace(/\//g, '\\/')       // / → \/
      .replace(/:\w+/g, '([^/]+)'); // :id → ([^/]+)

    return new RegExp(`^${pattern}$`);
  }

  /**
   * 현재 경로에 맞는 라우트 찾기
   *
   * @param {string} path - 경로
   * @returns {Object|null} 매칭된 라우트 및 파라미터
   *
   * @example
   * matchRoute('/users/123')
   * // 반환값: { route: {...}, params: { id: '123' } }
   */
  function matchRoute(path) {
    for (const route of routes) {
      const match = path.match(route.regex);
      if (match) {
        // 동적 파라미터 추출
        const paramNames = route.path.match(/:\w+/g) || [];
        const params = {};

        paramNames.forEach((paramName, index) => {
          const key = paramName.substring(1); // ':id' → 'id'
          params[key] = match[index + 1];
        });

        return { route, params };
      }
    }

    return null;
  }

  /**
   * 페이지 네비게이션
   *
   * @param {string} path - 이동할 경로
   *
   * @example
   * Router.navigate('/dashboard');
   * Router.navigate('/lessons/123');
   */
  function navigate(path) {
    // Hash 변경 (hashchange 이벤트 발생)
    window.location.hash = `#${path}`;
  }

  /**
   * 라우트 처리
   * - Hash 변경 시 자동 호출됨
   */
  async function handleRoute() {
    // 현재 경로 추출 (# 제거)
    let path = window.location.hash.slice(1) || '/';

    // 기본 경로 처리
    if (path === '' || path === '/') {
      path = Auth.isAuthenticated() ? '/dashboard' : '/login';
      window.location.hash = `#${path}`;
      return;
    }

    console.log('[Router] 경로 처리:', path);

    // 매칭된 라우트 찾기
    const match = matchRoute(path);

    if (!match) {
      // 404 페이지
      render404();
      return;
    }

    const { route, params } = match;

    // 인증 확인
    if (route.requireAuth && !Auth.isAuthenticated()) {
      console.warn('[Router] 인증 필요, 로그인 페이지로 이동');
      window.location.hash = '#/login';
      return;
    }

    // 로그인 페이지인데 이미 인증됨 → 대시보드로
    if (path === '/login' && Auth.isAuthenticated()) {
      console.log('[Router] 이미 로그인됨, 대시보드로 이동');
      window.location.hash = '#/dashboard';
      return;
    }

    try {
      // 페이지 렌더링
      await route.handler(params);

      // 페이지 이동 후 스크롤 최상단
      window.scrollTo(0, 0);
    } catch (error) {
      console.error('[Router] 페이지 렌더링 에러:', error);
      renderError(error.message);
    }
  }

  /**
   * 404 페이지 렌더링
   */
  function render404() {
    appContainer.innerHTML = `
      <div class="container mt-5">
        <div class="row justify-content-center">
          <div class="col-md-6 text-center">
            <h1 class="display-1">404</h1>
            <p class="lead">페이지를 찾을 수 없습니다.</p>
            <a href="#/dashboard" class="btn btn-primary">
              <i class="fas fa-home me-2"></i>대시보드로 돌아가기
            </a>
          </div>
        </div>
      </div>
    `;
  }

  /**
   * 에러 페이지 렌더링
   *
   * @param {string} message - 에러 메시지
   */
  function renderError(message) {
    appContainer.innerHTML = `
      <div class="container mt-5">
        <div class="row justify-content-center">
          <div class="col-md-6">
            <div class="alert alert-danger" role="alert">
              <h4 class="alert-heading">
                <i class="fas fa-exclamation-triangle me-2"></i>오류 발생
              </h4>
              <p>${message}</p>
              <hr>
              <button class="btn btn-danger" onclick="history.back()">
                <i class="fas fa-arrow-left me-2"></i>뒤로 가기
              </button>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  /**
   * 라우터 초기화
   * - 모든 페이지 라우트 등록
   * - hashchange 이벤트 리스너 등록
   */
  function init() {
    console.log('[Router] 라우터 초기화');

    // 라우트 등록
    register('/login', LoginPage.render, false);
    register('/dashboard', DashboardPage.render, true);
    register('/users', UsersPage.render, true);
    register('/users/:id', UsersPage.renderDetail, true);
    register('/lessons', LessonsPage.render, true);
    register('/lessons/new', LessonsPage.renderNew, true);
    register('/lessons/:id/content', LessonContentEditor.render, true);
    register('/lessons/:id', LessonsPage.renderEdit, true);
    register('/vocabulary', VocabularyPage.render, true);
    register('/media', MediaPage.render, true);
    register('/services', ServicesPage.render, true);
    register('/system', SystemPage.render, true);
    register('/network-settings', NetworkSettingsPage.render, true);
    register('/docs', DocsPage.render, true);

    // Hash 변경 이벤트 리스너
    window.addEventListener('hashchange', handleRoute);

    // 초기 라우트 처리
    handleRoute();
  }

  /**
   * 앱 컨테이너에 HTML 렌더링
   *
   * @param {string} html - 렌더링할 HTML
   *
   * @example
   * Router.render('<div>Hello World</div>');
   */
  function render(html) {
    appContainer.innerHTML = html;
  }

  /**
   * 현재 경로 가져오기
   *
   * @returns {string} 현재 경로
   *
   * @example
   * const currentPath = Router.getCurrentPath();
   * console.log(currentPath); // '/dashboard'
   */
  function getCurrentPath() {
    return window.location.hash.slice(1) || '/';
  }

  /**
   * 쿼리 파라미터 파싱
   *
   * @returns {Object} 쿼리 파라미터 객체
   *
   * @example
   * // URL: #/users?page=2&search=john
   * const query = Router.getQueryParams();
   * console.log(query.page);    // '2'
   * console.log(query.search);  // 'john'
   */
  function getQueryParams() {
    const hash = window.location.hash;
    const queryString = hash.includes('?') ? hash.split('?')[1] : '';

    if (!queryString) return {};

    const params = {};
    queryString.split('&').forEach((param) => {
      const [key, value] = param.split('=');
      params[decodeURIComponent(key)] = decodeURIComponent(value || '');
    });

    return params;
  }

  // Public API 반환
  return {
    init,
    register,
    navigate,
    render,
    getCurrentPath,
    getQueryParams,
  };
})();
