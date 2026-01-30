/**
 * Pagination Component
 *
 * 테이블 페이지네이션 UI 생성
 *
 * 사용 예시:
 * const html = Pagination.render({
 *   currentPage: 1,
 *   totalPages: 10,
 *   totalItems: 95,
 *   limit: 10,
 *   onPageChange: (page) => {
 *     console.log('Page:', page);
 *   }
 * });
 */

const Pagination = (() => {
  /**
   * 페이지네이션 HTML 렌더링
   *
   * @param {Object} options - 페이지네이션 옵션
   * @param {number} options.currentPage - 현재 페이지 (1부터 시작)
   * @param {number} options.totalPages - 전체 페이지 수
   * @param {number} options.totalItems - 전체 항목 수
   * @param {number} options.limit - 페이지당 항목 수
   * @param {Function} options.onPageChange - 페이지 변경 시 콜백
   * @param {number} options.maxVisible - 표시할 최대 페이지 번호 수 (기본값: 5)
   *
   * @returns {string} HTML 문자열
   *
   * @example
   * const html = Pagination.render({
   *   currentPage: 3,
   *   totalPages: 10,
   *   totalItems: 95,
   *   limit: 10,
   *   onPageChange: (page) => loadData(page)
   * });
   * document.getElementById('pagination').innerHTML = html;
   */
  function render(options = {}) {
    const {
      currentPage = 1,
      totalPages = 1,
      totalItems = 0,
      limit = 10,
      onPageChange = null,
      maxVisible = 5,
    } = options;

    // 페이지가 1페이지뿐이면 페이지네이션 숨김
    if (totalPages <= 1) {
      return `
        <div class="pagination-wrapper">
          <div class="pagination-info">
            총 ${Formatters.formatNumber(totalItems)}개
          </div>
        </div>
      `;
    }

    // 현재 페이지 범위 계산
    const startItem = (currentPage - 1) * limit + 1;
    const endItem = Math.min(currentPage * limit, totalItems);

    // 페이지 번호 배열 생성
    const pageNumbers = generatePageNumbers(currentPage, totalPages, maxVisible);

    // 페이지 번호 HTML 생성
    const pagesHTML = pageNumbers
      .map((page) => {
        if (page === '...') {
          return `<li class="page-item disabled"><span class="page-link">...</span></li>`;
        }

        const isActive = page === currentPage;
        const activeClass = isActive ? 'active' : '';

        return `
          <li class="page-item ${activeClass}">
            <a class="page-link" href="#" data-page="${page}" onclick="event.preventDefault();">
              ${page}
            </a>
          </li>
        `;
      })
      .join('');

    // 이전/다음 버튼
    const prevDisabled = currentPage === 1 ? 'disabled' : '';
    const nextDisabled = currentPage === totalPages ? 'disabled' : '';

    const html = `
      <div class="pagination-wrapper">
        <div class="pagination-info">
          ${startItem}-${endItem} / 총 ${Formatters.formatNumber(totalItems)}개
        </div>
        <nav aria-label="Page navigation">
          <ul class="pagination mb-0">
            <li class="page-item ${prevDisabled}">
              <a class="page-link" href="#" data-page="${currentPage - 1}" onclick="event.preventDefault();">
                <i class="fas fa-chevron-left"></i>
              </a>
            </li>
            ${pagesHTML}
            <li class="page-item ${nextDisabled}">
              <a class="page-link" href="#" data-page="${currentPage + 1}" onclick="event.preventDefault();">
                <i class="fas fa-chevron-right"></i>
              </a>
            </li>
          </ul>
        </nav>
      </div>
    `;

    // 이벤트 리스너 등록 (렌더링 후 호출)
    if (onPageChange) {
      setTimeout(() => {
        attachEventListeners(onPageChange);
      }, 0);
    }

    return html;
  }

  /**
   * 페이지 번호 배열 생성
   *
   * @param {number} current - 현재 페이지
   * @param {number} total - 전체 페이지
   * @param {number} maxVisible - 표시할 최대 개수
   * @returns {Array} 페이지 번호 배열 (예: [1, 2, 3, '...', 10])
   *
   * @example
   * generatePageNumbers(5, 10, 5)
   * // [1, '...', 4, 5, 6, '...', 10]
   */
  function generatePageNumbers(current, total, maxVisible) {
    if (total <= maxVisible) {
      // 전체 페이지가 maxVisible 이하면 모두 표시
      return Array.from({ length: total }, (_, i) => i + 1);
    }

    const pages = [];
    const half = Math.floor(maxVisible / 2);

    // 항상 첫 페이지 포함
    pages.push(1);

    let start = Math.max(2, current - half);
    let end = Math.min(total - 1, current + half);

    // 앞에 생략 기호 추가
    if (start > 2) {
      pages.push('...');
    }

    // 중간 페이지들
    for (let i = start; i <= end; i++) {
      pages.push(i);
    }

    // 뒤에 생략 기호 추가
    if (end < total - 1) {
      pages.push('...');
    }

    // 항상 마지막 페이지 포함
    if (total > 1) {
      pages.push(total);
    }

    return pages;
  }

  /**
   * 페이지 클릭 이벤트 리스너 등록
   *
   * @param {Function} callback - 페이지 변경 시 콜백
   */
  function attachEventListeners(callback) {
    const paginationLinks = document.querySelectorAll('.pagination .page-link');

    paginationLinks.forEach((link) => {
      link.addEventListener('click', (e) => {
        e.preventDefault();

        const page = parseInt(link.dataset.page, 10);
        if (!isNaN(page) && page > 0) {
          callback(page);
        }
      });
    });
  }

  /**
   * API 응답에서 페이지네이션 정보 추출
   *
   * @param {Object} response - API 응답 객체
   * @param {Object} response.pagination - 페이지네이션 정보
   * @returns {Object} 페이지네이션 옵션
   *
   * @example
   * const response = {
   *   data: [...],
   *   pagination: {
   *     currentPage: 1,
   *     totalPages: 10,
   *     totalItems: 95,
   *     limit: 10
   *   }
   * };
   * const options = Pagination.fromResponse(response);
   */
  function fromResponse(response) {
    const pagination = response.pagination || {};

    return {
      currentPage: pagination.currentPage || 1,
      totalPages: pagination.totalPages || 1,
      totalItems: pagination.totalItems || 0,
      limit: pagination.limit || 10,
    };
  }

  // Public API 반환
  return {
    render,
    fromResponse,
  };
})();
