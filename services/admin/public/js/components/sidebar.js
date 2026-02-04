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
   * 사이드바 메뉴 섹션 정의
   */
  const menuSections = [
    {
      type: 'single',
      items: [
        { path: '/dashboard', icon: 'fa-th-large', label: '대시보드' },
        { path: '/users', icon: 'fa-users', label: '사용자 관리' }
      ]
    },
    {
      type: 'group',
      label: '자료관리',
      icon: 'fa-database',
      items: [
        { path: '/lessons', icon: 'fa-pen-to-square', label: '레슨 관리' },
        { path: '/vocabulary', icon: 'fa-language', label: '단어 관리' },
        { path: '/hangul', icon: 'fa-font', label: '한글 자모' },
        { path: '/media', icon: 'fa-images', label: '미디어 관리' }
      ]
    },
    {
      type: 'group',
      label: '개발',
      icon: 'fa-code',
      items: [
        { path: '/services', icon: 'fa-cubes', label: '서비스 현황' },
        { path: '/system', icon: 'fa-cog', label: '시스템 모니터링' },
        { path: '/deploy', icon: 'fa-rocket', label: '웹 배포' },
        { path: '/app-theme', icon: 'fa-mobile-alt', label: '앱 테마' },
        { path: '/docs', icon: 'fa-book', label: '개발 문서' },
        { path: '/dev-notes', icon: 'fa-sticky-note', label: '개발노트' }
      ]
    }
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
    const currentPath = Router.getCurrentPath();

    // 모든 섹션 HTML 생성
    const menuHTML = menuSections
      .map((section) => {
        if (section.type === 'single') {
          // 섹션 헤더 없이 항목 렌더링
          return section.items
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
        } else if (section.type === 'group') {
          // 섹션 헤더 + 항목 렌더링
          const sectionIcon = section.icon ? `<i class="fas ${section.icon}"></i>` : '';
          const itemsHTML = section.items
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
            <div class="sidebar-section">
              <div class="sidebar-section-header">
                ${sectionIcon}
                <span>${section.label}</span>
              </div>
              ${itemsHTML}
            </div>
          `;
        }
        return '';
      })
      .join('');

    // Static logo text
    const logoHTML = '<h2>Lemon Korean Admin</h2>';

    return `
      <aside class="sidebar">
        <div class="sidebar-header">
          ${logoHTML}
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

    // 모든 섹션에서 항목 추출 (flatten)
    const allItems = menuSections.flatMap(section => section.items);

    // 현재 경로와 일치하는 메뉴 항목에 active 추가
    allItems.forEach((item) => {
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
