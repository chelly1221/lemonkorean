/**
 * System Page
 *
 * 감사 로그 페이지 (페이지네이션 및 필터링 지원)
 */

const SystemPage = (() => {
  let currentPage = 1;
  let currentLimit = 50;
  let filters = {};

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('로그')}
          <div class="content-container">
            <!-- 필터바 -->
            <div class="filter-bar">
              <div class="row g-3 align-items-end">
                <div class="col-md-2">
                  <label for="filter-action" class="form-label">작업 유형</label>
                  <select class="form-select" id="filter-action">
                    <option value="">전체</option>
                    <option value="CREATE">생성 (CREATE)</option>
                    <option value="UPDATE">수정 (UPDATE)</option>
                    <option value="DELETE">삭제 (DELETE)</option>
                    <option value="LOGIN">로그인 (LOGIN)</option>
                    <option value="LOGOUT">로그아웃 (LOGOUT)</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <label for="filter-status" class="form-label">상태</label>
                  <select class="form-select" id="filter-status">
                    <option value="">전체</option>
                    <option value="success">성공</option>
                    <option value="error">오류</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <label for="filter-start-date" class="form-label">시작일</label>
                  <input type="date" class="form-control" id="filter-start-date">
                </div>
                <div class="col-md-2">
                  <label for="filter-end-date" class="form-label">종료일</label>
                  <input type="date" class="form-control" id="filter-end-date">
                </div>
                <div class="col-md-2">
                  <label for="filter-limit" class="form-label">페이지당 항목 수</label>
                  <select class="form-select" id="filter-limit">
                    <option value="10">10개</option>
                    <option value="25">25개</option>
                    <option value="50" selected>50개</option>
                    <option value="100">100개</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <button class="btn btn-primary w-100" id="btn-apply-filters">
                    <i class="fas fa-search"></i> 검색
                  </button>
                  <button class="btn btn-secondary w-100 mt-2" id="btn-reset-filters">
                    <i class="fas fa-redo"></i> 초기화
                  </button>
                </div>
              </div>
            </div>

            <!-- 감사 로그 테이블 -->
            <div class="table-card">
              <div class="card-header">
                <h5 class="card-title">감사 로그</h5>
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

              <!-- 페이지네이션 -->
              <div id="pagination-container"></div>
            </div>
          </div>
        </div>
      </div>
    `;
    Router.render(layout);
    Sidebar.updateActive();

    // 이벤트 리스너 등록
    attachEventListeners();

    // 초기 데이터 로드
    await loadData();
  }

  function attachEventListeners() {
    // 검색 버튼
    document.getElementById('btn-apply-filters').addEventListener('click', applyFilters);

    // 초기화 버튼
    document.getElementById('btn-reset-filters').addEventListener('click', resetFilters);

    // 페이지당 항목 수 변경 시 즉시 적용
    document.getElementById('filter-limit').addEventListener('change', (e) => {
      currentLimit = parseInt(e.target.value);
      currentPage = 1;
      loadData();
    });

    // Enter 키로 검색
    ['filter-action', 'filter-status', 'filter-start-date', 'filter-end-date'].forEach(id => {
      document.getElementById(id).addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
          applyFilters();
        }
      });
    });
  }

  async function loadData() {
    try {
      const params = {
        page: currentPage,
        limit: currentLimit,
        ...filters
      };

      const response = await API.system.getLogs(params);

      // Unwrap data from response
      const logs = response.data || response;
      const pagination = response.pagination;

      updateLogs(logs);
      updatePagination(pagination);
    } catch (error) {
      console.error('[SystemPage] 데이터 로드 에러:', error);
      Toast.error('로그를 불러올 수 없습니다.');
    }
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

  function updatePagination(pagination) {
    if (!pagination) return;

    const container = document.getElementById('pagination-container');
    const html = Pagination.render({
      currentPage: pagination.page || 1,
      totalPages: pagination.totalPages || 1,
      totalItems: pagination.total || 0,
      limit: pagination.limit || 50,
      onPageChange: (page) => {
        currentPage = page;
        loadData();
      }
    });
    container.innerHTML = html;
  }

  function applyFilters() {
    const action = document.getElementById('filter-action').value;
    const status = document.getElementById('filter-status').value;
    const startDate = document.getElementById('filter-start-date').value;
    const endDate = document.getElementById('filter-end-date').value;

    // 날짜 유효성 검사
    if (startDate && endDate && startDate > endDate) {
      Toast.error('시작일은 종료일보다 이전이어야 합니다.');
      return;
    }

    filters = {};
    if (action) filters.action = action;
    if (status) filters.status = status;
    if (startDate) filters.startDate = startDate;
    if (endDate) filters.endDate = endDate;

    currentPage = 1;
    loadData();
  }

  function resetFilters() {
    filters = {};
    currentPage = 1;
    currentLimit = 50;

    // 필터 입력 초기화
    document.getElementById('filter-action').value = '';
    document.getElementById('filter-status').value = '';
    document.getElementById('filter-start-date').value = '';
    document.getElementById('filter-end-date').value = '';
    document.getElementById('filter-limit').value = '50';

    loadData();
  }

  // Public API 반환
  return {
    render,
    cleanup: () => {
      // 페이지 떠날 때 정리 (자동 갱신 없음)
    }
  };
})();
