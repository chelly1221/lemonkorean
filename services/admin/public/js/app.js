/**
 * App Initialization
 *
 * SPA 초기화 및 전역 설정
 */

(function () {
  'use strict';

  /**
   * 앱 초기화
   */
  async function init() {
    console.log('[App] Lemon Korean Admin Dashboard 초기화');

    // 1. Clear legacy design settings from sessionStorage
    sessionStorage.removeItem('admin_logo_url');

    // 2. 라우터 초기화
    Router.init();

    // 3. 토큰 자동 갱신 (30분마다)
    setInterval(() => {
      if (Auth.isAuthenticated()) {
        Auth.refreshTokenIfNeeded();
      }
    }, 30 * 60 * 1000);

    // 4. 전역 에러 핸들러
    window.addEventListener('error', (event) => {
      console.error('[App] 전역 에러:', event.error);
    });

    // 5. 전역 Promise rejection 핸들러
    window.addEventListener('unhandledrejection', (event) => {
      console.error('[App] Unhandled Promise Rejection:', event.reason);
    });

    console.log('[App] 초기화 완료');
  }

  // DOM 로드 완료 후 초기화
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
