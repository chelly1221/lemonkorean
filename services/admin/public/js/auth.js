/**
 * Authentication Manager
 *
 * JWT 토큰 관리 및 인증 상태 관리
 *
 * 주요 기능:
 * - JWT 토큰 localStorage 저장/조회
 * - 로그인/로그아웃 상태 관리
 * - 토큰 만료 확인
 * - Admin 권한 확인
 *
 * 사용 예시:
 * Auth.login(token, user);
 * const isLoggedIn = Auth.isAuthenticated();
 * Auth.logout();
 */

const Auth = (() => {
  // localStorage 키
  const TOKEN_KEY = 'admin_token';
  const USER_KEY = 'admin_user';

  /**
   * 로그인 처리
   *
   * @param {string} token - JWT 토큰
   * @param {Object} user - 사용자 정보
   * @param {number} user.id - 사용자 ID
   * @param {string} user.email - 이메일
   * @param {string} user.role - 역할 (admin)
   *
   * @example
   * Auth.login('eyJhbGciOiJIUzI1NiIs...', { id: 1, email: 'admin@lemon.com', role: 'admin' });
   */
  function login(token, user) {
    // 토큰 저장
    localStorage.setItem(TOKEN_KEY, token);

    // 사용자 정보 저장
    localStorage.setItem(USER_KEY, JSON.stringify(user));

    console.log('[Auth] 로그인 성공:', user.email);
  }

  /**
   * 로그아웃 처리
   *
   * localStorage에서 토큰 및 사용자 정보를 삭제합니다.
   *
   * @example
   * Auth.logout();
   * window.location.hash = '#/login';
   */
  function logout() {
    // 토큰 삭제
    localStorage.removeItem(TOKEN_KEY);

    // 사용자 정보 삭제
    localStorage.removeItem(USER_KEY);

    console.log('[Auth] 로그아웃 완료');
  }

  /**
   * JWT 토큰 조회
   *
   * @returns {string|null} JWT 토큰 (없으면 null)
   *
   * @example
   * const token = Auth.getToken();
   * fetch('/api/admin/users', {
   *   headers: { 'Authorization': `Bearer ${token}` }
   * });
   */
  function getToken() {
    return localStorage.getItem(TOKEN_KEY);
  }

  /**
   * 사용자 정보 조회
   *
   * @returns {Object|null} 사용자 정보 (없으면 null)
   *
   * @example
   * const user = Auth.getUser();
   * if (user) {
   *   console.log(user.email);
   * }
   */
  function getUser() {
    const userJson = localStorage.getItem(USER_KEY);
    if (!userJson) return null;

    try {
      return JSON.parse(userJson);
    } catch (error) {
      console.error('[Auth] 사용자 정보 파싱 에러:', error);
      return null;
    }
  }

  /**
   * 인증 상태 확인
   *
   * @returns {boolean} 인증 여부 (토큰이 있고 만료되지 않았으면 true)
   *
   * @example
   * if (!Auth.isAuthenticated()) {
   *   window.location.hash = '#/login';
   * }
   */
  function isAuthenticated() {
    const token = getToken();
    if (!token) return false;

    // JWT 만료 확인
    try {
      const payload = parseJWT(token);
      const now = Math.floor(Date.now() / 1000);

      // 만료 시간이 있으면 확인
      if (payload.exp && payload.exp < now) {
        console.warn('[Auth] 토큰이 만료되었습니다.');
        logout();
        return false;
      }

      return true;
    } catch (error) {
      console.error('[Auth] 토큰 파싱 에러:', error);
      logout();
      return false;
    }
  }

  /**
   * Admin 권한 확인
   *
   * @returns {boolean} Admin 권한 여부
   *
   * @example
   * if (Auth.isAdmin()) {
   *   // Admin 전용 기능 실행
   * }
   */
  function isAdmin() {
    const user = getUser();
    return user && user.role === 'admin';
  }

  /**
   * JWT 토큰 파싱
   *
   * @param {string} token - JWT 토큰
   * @returns {Object} JWT 페이로드
   *
   * @example
   * const payload = parseJWT(token);
   * console.log(payload.userId);
   * console.log(payload.exp);  // 만료 시간
   */
  function parseJWT(token) {
    try {
      // JWT는 header.payload.signature 형태
      const parts = token.split('.');
      if (parts.length !== 3) {
        throw new Error('Invalid JWT format');
      }

      // Payload 부분 디코딩 (Base64URL)
      const payload = parts[1];
      const decodedPayload = atob(payload.replace(/-/g, '+').replace(/_/g, '/'));

      return JSON.parse(decodedPayload);
    } catch (error) {
      throw new Error('JWT 파싱 실패: ' + error.message);
    }
  }

  /**
   * 토큰 갱신
   *
   * 만료 시간이 임박한 경우 자동으로 토큰을 갱신합니다.
   * (백그라운드에서 주기적으로 호출 가능)
   *
   * @returns {Promise<void>}
   *
   * @example
   * // 30분마다 토큰 갱신 확인
   * setInterval(async () => {
   *   await Auth.refreshTokenIfNeeded();
   * }, 30 * 60 * 1000);
   */
  async function refreshTokenIfNeeded() {
    const token = getToken();
    if (!token) return;

    try {
      const payload = parseJWT(token);
      const now = Math.floor(Date.now() / 1000);

      // 만료 시간이 5분 이내면 갱신
      if (payload.exp && payload.exp - now < 5 * 60) {
        console.log('[Auth] 토큰 갱신 시도...');

        const response = await API.auth.refresh();
        if (response.token) {
          // 새 토큰으로 교체 (사용자 정보는 유지)
          localStorage.setItem(TOKEN_KEY, response.token);
          console.log('[Auth] 토큰 갱신 완료');
        }
      }
    } catch (error) {
      console.error('[Auth] 토큰 갱신 실패:', error);
      // 갱신 실패 시 로그아웃
      logout();
      window.location.hash = '#/login';
    }
  }

  // Public API 반환
  return {
    login,
    logout,
    getToken,
    getUser,
    isAuthenticated,
    isAdmin,
    refreshTokenIfNeeded,
  };
})();
