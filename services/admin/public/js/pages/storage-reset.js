/**
 * Storage Reset Page
 * 관리자가 웹 앱의 localStorage를 원격으로 리셋할 수 있는 페이지
 */

const StorageResetPage = (() => {
  let currentPage = 1;
  let currentStatus = null;

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('스토리지 리셋')}
          <div class="content-container">
            <div class="page-header">
              <h1><i class="fas fa-trash-restore"></i> 스토리지 리셋</h1>
              <p>웹 앱의 localStorage를 원격으로 초기화합니다</p>
            </div>

            <!-- 경고 메시지 -->
            <div class="alert alert-warning">
              <i class="fas fa-exclamation-triangle"></i>
              <strong>주의:</strong> 이 기능은 사용자의 로컬 데이터를 삭제합니다.
              복구할 수 없으므로 신중하게 사용하세요.
            </div>

            <!-- 안내: 캐시 관리 페이지로 이동 -->
            <div class="alert alert-info">
              <i class="fas fa-info-circle"></i>
              <strong>관리자 브라우저 캐시 관리:</strong>
              <a href="#/cache-management" class="alert-link">캐시 관리 페이지</a>에서
              브라우저 캐싱을 비활성화하거나 캐시를 삭제할 수 있습니다.
            </div>

            <!-- 새 리셋 플래그 생성 -->
            <div class="card">
              <div class="card-header">
                <h2><i class="fas fa-plus-circle"></i> 새 리셋 플래그 생성</h2>
              </div>
              <div class="card-body">
                <form id="create-flag-form">
                  <div class="form-group">
                    <label for="reset-scope">범위</label>
                    <select id="reset-scope" class="form-control" required>
                      <option value="all">전체 사용자</option>
                      <option value="single">특정 사용자</option>
                    </select>
                  </div>

                  <div class="form-group" id="user-id-group" style="display: none;">
                    <label for="user-id">사용자 ID</label>
                    <input
                      type="number"
                      id="user-id"
                      class="form-control"
                      placeholder="사용자 ID 입력"
                      min="1"
                    />
                  </div>

                  <div class="form-group">
                    <label for="reason">사유 (선택)</label>
                    <textarea
                      id="reason"
                      class="form-control"
                      rows="3"
                      placeholder="예: 버그 테스트를 위한 초기화"
                    ></textarea>
                  </div>

                  <button type="submit" class="btn btn-danger">
                    <i class="fas fa-trash-restore"></i> 리셋 플래그 생성
                  </button>
                </form>
              </div>
            </div>

            <!-- 리셋 플래그 이력 -->
            <div class="card" style="margin-top: 2rem;">
              <div class="card-header">
                <h2><i class="fas fa-history"></i> 리셋 플래그 이력</h2>
                <div style="margin-top: 1rem;">
                  <label for="status-filter">상태 필터:</label>
                  <select id="status-filter" class="form-control" style="width: 200px; display: inline-block; margin-left: 1rem;">
                    <option value="">모든 상태</option>
                    <option value="pending">대기중</option>
                    <option value="completed">완료됨</option>
                    <option value="expired">만료됨</option>
                  </select>
                </div>
              </div>
              <div class="card-body">
                <div id="flags-list"></div>
                <div id="pagination"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;

    Router.render(layout);
    Sidebar.updateActive();

    // 이벤트 리스너 설정
    attachEventListeners();

    // 플래그 목록 로드
    await loadFlags();
  }

  function attachEventListeners() {
    // 범위 선택 변경
    document.getElementById('reset-scope').addEventListener('change', (e) => {
      const userIdGroup = document.getElementById('user-id-group');
      const userIdInput = document.getElementById('user-id');

      if (e.target.value === 'single') {
        userIdGroup.style.display = 'block';
        userIdInput.required = true;
      } else {
        userIdGroup.style.display = 'none';
        userIdInput.required = false;
        userIdInput.value = '';
      }
    });

    // 폼 제출
    document.getElementById('create-flag-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      await createFlag();
    });

    // 상태 필터 변경
    document.getElementById('status-filter').addEventListener('change', async (e) => {
      currentStatus = e.target.value || null;
      currentPage = 1;
      await loadFlags();
    });
  }

  async function createFlag() {
    const scope = document.getElementById('reset-scope').value;
    const userId = document.getElementById('user-id').value;
    const reason = document.getElementById('reason').value.trim();

    // 확인 대화상자
    const targetText = scope === 'all' ? '전체 사용자' : `사용자 ${userId}`;
    if (!confirm(`정말 ${targetText}의 localStorage를 리셋하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.`)) {
      return;
    }

    try {
      const data = {
        user_id: scope === 'single' ? parseInt(userId) : null,
        reason: reason || null
      };

      const response = await API.system.createStorageResetFlag(data);

      if (response.success) {
        Toast.success('리셋 플래그가 생성되었습니다');

        // 폼 초기화
        document.getElementById('create-flag-form').reset();
        document.getElementById('user-id-group').style.display = 'none';

        // 플래그 목록 새로고침
        await loadFlags();
      }
    } catch (error) {
      console.error('Error creating flag:', error);

      let errorMessage = '리셋 플래그 생성 실패';
      if (error.response) {
        const data = await error.response.json();
        errorMessage = data.message || errorMessage;
      }

      Toast.error(errorMessage);
    }
  }

  async function loadFlags() {
    try {
      const params = {
        page: currentPage,
        limit: 20
      };

      if (currentStatus) {
        params.status = currentStatus;
      }

      const response = await API.system.listStorageResetFlags(params);

      if (response.success) {
        renderFlagsList(response.data);
        renderPagination(response.pagination);
      }
    } catch (error) {
      console.error('Error loading flags:', error);
      document.getElementById('flags-list').innerHTML = `
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-circle"></i>
          플래그 목록을 불러올 수 없습니다.
        </div>
      `;
    }
  }

  function renderFlagsList(flags) {
    const container = document.getElementById('flags-list');

    if (flags.length === 0) {
      container.innerHTML = `
        <div class="alert alert-info">
          <i class="fas fa-info-circle"></i>
          리셋 플래그가 없습니다.
        </div>
      `;
      return;
    }

    const table = `
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>대상</th>
            <th>생성자</th>
            <th>사유</th>
            <th>상태</th>
            <th>생성일</th>
            <th>완료일</th>
            <th>실행 IP</th>
          </tr>
        </thead>
        <tbody>
          ${flags.map(flag => renderFlagRow(flag)).join('')}
        </tbody>
      </table>
    `;

    container.innerHTML = table;
  }

  function renderFlagRow(flag) {
    const target = flag.user_id
      ? `${flag.target_username || 'Unknown'} (${flag.user_id})`
      : '전체 사용자';

    const statusBadge = getStatusBadge(flag.status);

    const createdAt = new Date(flag.created_at).toLocaleString('ko-KR');
    const completedAt = flag.completed_at
      ? new Date(flag.completed_at).toLocaleString('ko-KR')
      : '-';

    const executedIp = flag.executed_from_ip || '-';
    const reason = flag.reason || '-';

    return `
      <tr>
        <td>${flag.id}</td>
        <td>${target}</td>
        <td>${flag.admin_username}</td>
        <td style="max-width: 300px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;"
            title="${reason}">
          ${reason}
        </td>
        <td>${statusBadge}</td>
        <td>${createdAt}</td>
        <td>${completedAt}</td>
        <td>${executedIp}</td>
      </tr>
    `;
  }

  function getStatusBadge(status) {
    const badges = {
      'pending': '<span class="badge badge-warning">대기중</span>',
      'completed': '<span class="badge badge-success">완료됨</span>',
      'expired': '<span class="badge badge-secondary">만료됨</span>'
    };

    return badges[status] || `<span class="badge badge-secondary">${status}</span>`;
  }

  function renderPagination(pagination) {
    const container = document.getElementById('pagination');

    if (pagination.totalPages <= 1) {
      container.innerHTML = '';
      return;
    }

    const pages = [];
    const maxButtons = 5;
    let startPage = Math.max(1, pagination.page - Math.floor(maxButtons / 2));
    let endPage = Math.min(pagination.totalPages, startPage + maxButtons - 1);

    if (endPage - startPage + 1 < maxButtons) {
      startPage = Math.max(1, endPage - maxButtons + 1);
    }

    // 이전 버튼
    if (pagination.page > 1) {
      pages.push(`
        <button class="btn btn-sm btn-secondary" onclick="StorageResetPage.goToPage(${pagination.page - 1})">
          <i class="fas fa-chevron-left"></i>
        </button>
      `);
    }

    // 페이지 번호
    for (let i = startPage; i <= endPage; i++) {
      const active = i === pagination.page ? 'btn-primary' : 'btn-secondary';
      pages.push(`
        <button class="btn btn-sm ${active}" onclick="StorageResetPage.goToPage(${i})">
          ${i}
        </button>
      `);
    }

    // 다음 버튼
    if (pagination.page < pagination.totalPages) {
      pages.push(`
        <button class="btn btn-sm btn-secondary" onclick="StorageResetPage.goToPage(${pagination.page + 1})">
          <i class="fas fa-chevron-right"></i>
        </button>
      `);
    }

    container.innerHTML = `
      <div style="display: flex; gap: 0.5rem; justify-content: center; margin-top: 1rem;">
        ${pages.join('')}
      </div>
      <p style="text-align: center; margin-top: 0.5rem; color: #666;">
        ${pagination.page} / ${pagination.totalPages} 페이지 (총 ${pagination.total}개)
      </p>
    `;
  }

  async function goToPage(page) {
    currentPage = page;
    await loadFlags();
  }

  // Public API
  return {
    render,
    goToPage
  };
})();

// 전역 함수로 노출 (페이지네이션에서 사용)
window.StorageResetPage = StorageResetPage;
