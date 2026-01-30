/**
 * Sidebar Component
 *
 * 네비게이션 사이드바 렌더링
 *
 * 사용 예시:
 * const html = Sidebar.render();
 * document.body.insertAdjacentHTML('afterbegin', html);
 */

const Sidebar = (() => {
  /**
   * 사이드바 메뉴 항목 정의
   */
  const menuItems = [
    {
      path: '/dashboard',
      icon: 'fa-th-large',
      label: '대시보드',
    },
    {
      path: '/users',
      icon: 'fa-users',
      label: '사용자 관리',
    },
    {
      path: '/lessons',
      icon: 'fa-pen-to-square',
      label: '레슨 관리',
    },
    {
      path: '/vocabulary',
      icon: 'fa-language',
      label: '단어 관리',
    },
    {
      path: '/media',
      icon: 'fa-images',
      label: '미디어 관리',
    },
    {
      path: '/services',
      icon: 'fa-cubes',
      label: '서비스 관리',
    },
    {
      path: '/system',
      icon: 'fa-cog',
      label: '시스템 모니터링',
    },
    {
      path: '/network-settings',
      icon: 'fa-network-wired',
      label: '네트워크 설정',
    },
    {
      path: '/docs',
      icon: 'fa-book',
      label: '개발 문서',
    },
  ];

  /**
   * 사이드바 HTML 렌더링
   *
   * @returns {string} HTML 문자열
   *
   * @example
   * const html = Sidebar.render();
   */
  function render() {
    // 현재 경로 가져오기
    const currentPath = Router.getCurrentPath();

    // 메뉴 항목 HTML 생성
    const menuHTML = menuItems
      .map((item) => {
        const isActive = currentPath === item.path || currentPath.startsWith(item.path + '/');
        const activeClass = isActive ? 'active' : '';

        return `
          <a href="#${item.path}" class="sidebar-menu-item ${activeClass}">
            <i class="fas ${item.icon}"></i>
            ${item.label}
          </a>
        `;
      })
      .join('');

    return `
      <aside class="sidebar">
        <div class="sidebar-header">
          <h2>柠檬韩语</h2>
          <p>관리자 페이지</p>
        </div>
        <nav class="sidebar-menu">
          ${menuHTML}
        </nav>
      </aside>
    `;
  }

  /**
   * 사이드바 활성 상태 업데이트
   * - 페이지 이동 시 호출하여 활성 메뉴 하이라이팅
   *
   * @example
   * // Router에서 페이지 이동 후 호출
   * Sidebar.updateActive();
   */
  function updateActive() {
    const currentPath = Router.getCurrentPath();

    // 모든 메뉴 항목에서 active 제거
    document.querySelectorAll('.sidebar-menu-item').forEach((item) => {
      item.classList.remove('active');
    });

    // 현재 경로와 일치하는 메뉴 항목에 active 추가
    menuItems.forEach((item) => {
      if (currentPath === item.path || currentPath.startsWith(item.path + '/')) {
        const link = document.querySelector(`.sidebar-menu-item[href="#${item.path}"]`);
        if (link) {
          link.classList.add('active');
        }
      }
    });
  }

  // Public API 반환
  return {
    render,
    updateActive,
  };
})();
