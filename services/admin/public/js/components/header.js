/**
 * Header Component
 *
 * 앱 헤더 (상단 바) 렌더링
 *
 * 사용 예시:
 * const html = Header.render('대시보드');
 * document.querySelector('.main-content').insertAdjacentHTML('afterbegin', html);
 */

const Header = (() => {
  /**
   * 헤더 HTML 렌더링
   *
   * @param {string} title - 페이지 제목
   * @param {Array} actions - 추가 액션 버튼 (선택)
   *
   * @returns {string} HTML 문자열
   *
   * @example
   * const html = Header.render('사용자 관리', [
   *   { label: '추가', icon: 'fa-plus', class: 'btn-primary', onClick: () => {} }
   * ]);
   */
  function render(title = '대시보드', actions = []) {
    // 현재 사용자 정보
    const user = Auth.getUser();
    const userEmail = user ? user.email : '';
    const userInitial = userEmail ? userEmail.charAt(0).toUpperCase() : 'A';

    // 액션 버튼 HTML
    const actionsHTML = actions
      .map((action, index) => {
        const icon = action.icon ? `<i class="fas ${action.icon} me-2"></i>` : '';
        return `
          <button type="button" class="btn ${action.class || 'btn-primary'}" data-action-index="${index}">
            ${icon}${action.label}
          </button>
        `;
      })
      .join('');

    const html = `
      <header class="app-header">
        <div class="header-title">
          <h1>${title}</h1>
        </div>
        <div class="header-actions">
          ${actionsHTML}
          <div class="header-user">
            <button class="btn btn-link" type="button" id="logout-btn" title="로그아웃">
              <div class="user-avatar">${userInitial}</div>
            </button>
          </div>
        </div>
      </header>
    `;

    // 이벤트 리스너 등록 (렌더링 후 호출)
    setTimeout(() => {
      attachEventListeners(actions);
    }, 0);

    return html;
  }

  /**
   * 이벤트 리스너 등록
   *
   * @param {Array} actions - 액션 버튼 배열
   */
  function attachEventListeners(actions) {
    // 로그아웃 버튼
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
      logoutBtn.addEventListener('click', (e) => {
        e.preventDefault();
        handleLogout();
      });
    }

    // 액션 버튼들
    actions.forEach((action, index) => {
      const btn = document.querySelector(`[data-action-index="${index}"]`);
      if (btn && action.onClick) {
        btn.addEventListener('click', action.onClick);
      }
    });
  }

  /**
   * 로그아웃 처리
   */
  async function handleLogout() {
    Modal.confirm('로그아웃 하시겠습니까?', async () => {
      try {
        // API 로그아웃 호출
        await API.auth.logout();
      } catch (error) {
        console.error('[Header] 로그아웃 에러:', error);
      } finally {
        // 로컬 인증 정보 삭제
        Auth.logout();

        // 로그인 페이지로 이동
        Router.navigate('/login');

        Toast.success('로그아웃 되었습니다.');
      }
    });
  }

  // Public API 반환
  return {
    render,
  };
})();
