/**
 * Users Page
 *
 * 사용자 관리 페이지
 */

const UsersPage = (() => {
  let currentPage = 1;
  let currentFilters = {};
  let selectedUsers = new Set();

  /**
   * 사용자 목록 페이지 렌더링
   */
  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('사용자 관리')}
          <div class="content-container">
            <!-- 필터 바 -->
            <div class="filters-bar">
              <div class="row">
                <div class="col-md-4">
                  <input type="text" class="form-control" id="search-input" placeholder="이메일 또는 이름으로 검색">
                </div>
                <div class="col-md-3">
                  <select class="form-select" id="subscription-filter">
                    <option value="">전체 구독</option>
                    <option value="free">무료</option>
                    <option value="premium">프리미엄</option>
                  </select>
                </div>
                <div class="col-md-3">
                  <select class="form-select" id="status-filter">
                    <option value="">전체 상태</option>
                    <option value="active">활성</option>
                    <option value="inactive">비활성</option>
                    <option value="banned">차단됨</option>
                  </select>
                </div>
                <div class="col-md-2">
                  <button type="button" class="btn btn-primary w-100" id="filter-btn">
                    <i class="fas fa-search me-2"></i>검색
                  </button>
                </div>
              </div>
            </div>

            <!-- 일괄 작업 바 -->
            <div class="bulk-actions-bar mb-3" id="bulk-actions-bar" style="display: none;">
              <div class="d-flex align-items-center gap-2">
                <span class="text-muted" id="selected-count">0명 선택됨</span>
                <button type="button" class="btn btn-sm btn-success" id="bulk-activate-btn">
                  <i class="fas fa-check-circle me-1"></i>활성화
                </button>
                <button type="button" class="btn btn-sm btn-secondary" id="bulk-deactivate-btn">
                  <i class="fas fa-times-circle me-1"></i>비활성화
                </button>
                <button type="button" class="btn btn-sm btn-danger" id="bulk-delete-btn">
                  <i class="fas fa-trash me-1"></i>삭제
                </button>
                <button type="button" class="btn btn-sm btn-outline-secondary" id="bulk-clear-btn">
                  <i class="fas fa-times me-1"></i>선택 해제
                </button>
              </div>
            </div>

            <!-- 사용자 테이블 -->
            <div class="table-card">
              <div class="card-header">
                <h5 class="card-title">사용자 목록</h5>
              </div>
              <div class="table-responsive">
                <table class="table" id="users-table">
                  <thead>
                    <tr>
                      <th width="40">
                        <input type="checkbox" class="form-check-input" id="select-all-checkbox">
                      </th>
                      <th>ID</th>
                      <th>이메일</th>
                      <th>구독</th>
                      <th>상태</th>
                      <th>가입일</th>
                      <th>작업</th>
                    </tr>
                  </thead>
                  <tbody id="users-tbody">
                    <tr>
                      <td colspan="7" class="text-center">
                        <div class="spinner-border text-primary" role="status"></div>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
              <div id="pagination-container"></div>
            </div>
          </div>
        </div>
      </div>
    `;

    Router.render(layout);
    Sidebar.updateActive();

    attachEventListeners();
    await loadUsers();
  }

  /**
   * 사용자 상세 페이지 렌더링
   */
  async function renderDetail(params) {
    const userId = params.id;

    try {
      const user = await API.users.getById(userId);

      const layout = `
        <div class="app-layout">
          ${Sidebar.render()}
          <div class="main-content">
            ${Header.render('사용자 상세', [
              { label: '뒤로', icon: 'fa-arrow-left', class: 'btn-secondary', onClick: () => Router.navigate('/users') }
            ])}
            <div class="content-container">
              <div class="row">
                <div class="col-md-6">
                  <div class="table-card">
                    <div class="card-header">
                      <h5 class="card-title">기본 정보</h5>
                    </div>
                    <table class="table">
                      <tr><th width="40%">ID</th><td>${user.id}</td></tr>
                      <tr><th>이메일</th><td>${user.email}</td></tr>
                      <tr><th>구독</th><td>${Formatters.formatSubscription(user.subscription_type)}</td></tr>
                      <tr><th>상태</th><td>${Formatters.formatUserStatus(user.status || 'active')}</td></tr>
                      <tr><th>가입일</th><td>${Formatters.formatDate(user.created_at, 'datetime')}</td></tr>
                    </table>
                  </div>
                </div>
                <div class="col-md-6">
                  <div class="table-card">
                    <div class="card-header">
                      <h5 class="card-title">학습 통계</h5>
                    </div>
                    <table class="table">
                      <tr><th width="40%">완료한 레슨</th><td>${user.stats?.completedLessons || 0}개</td></tr>
                      <tr><th>총 학습 시간</th><td>${Formatters.formatDuration(user.stats?.totalStudyTime || 0)}</td></tr>
                      <tr><th>평균 퀴즈 점수</th><td>${user.stats?.avgQuizScore || 0}점</td></tr>
                    </table>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      `;

      Router.render(layout);
      Sidebar.updateActive();
    } catch (error) {
      Toast.error('사용자 정보를 불러올 수 없습니다.');
      Router.navigate('/users');
    }
  }

  function attachEventListeners() {
    // 검색 버튼
    document.getElementById('filter-btn').addEventListener('click', () => {
      currentPage = 1;
      loadUsers();
    });

    // 엔터키로 검색
    document.getElementById('search-input').addEventListener('keypress', (e) => {
      if (e.key === 'Enter') {
        currentPage = 1;
        loadUsers();
      }
    });

    // 전체 선택 체크박스
    document.getElementById('select-all-checkbox').addEventListener('change', handleSelectAllChange);

    // 일괄 작업 버튼들
    document.getElementById('bulk-activate-btn').addEventListener('click', handleBulkActivate);
    document.getElementById('bulk-deactivate-btn').addEventListener('click', handleBulkDeactivate);
    document.getElementById('bulk-delete-btn').addEventListener('click', handleBulkDelete);
    document.getElementById('bulk-clear-btn').addEventListener('click', handleBulkClear);
  }

  async function loadUsers() {
    const search = document.getElementById('search-input').value.trim();
    const subscription = document.getElementById('subscription-filter').value;
    const status = document.getElementById('status-filter').value;

    currentFilters = {
      page: currentPage,
      limit: 10,
      search,
      subscription,
      status,
    };

    try {
      const response = await API.users.list(currentFilters);
      renderUsersTable(response.data);
      renderPagination(response.pagination);
    } catch (error) {
      console.error('[UsersPage] 사용자 로드 에러:', error);
      Toast.error('사용자 목록을 불러올 수 없습니다.');
    }
  }

  function renderUsersTable(users) {
    const tbody = document.getElementById('users-tbody');

    if (users.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" class="text-center">사용자가 없습니다.</td></tr>';
      return;
    }

    tbody.innerHTML = users.map(user => `
      <tr>
        <td>
          <input type="checkbox" class="form-check-input user-checkbox" data-user-id="${user.id}">
        </td>
        <td>${user.id}</td>
        <td>${user.email}</td>
        <td>${Formatters.formatSubscription(user.subscription_type)}</td>
        <td>${Formatters.formatUserStatus(user)}</td>
        <td>${Formatters.formatDate(user.created_at, 'date')}</td>
        <td>
          <button class="btn btn-link text-secondary p-0" data-detail-id="${user.id}" title="사용자 상세">
            <i class="fas fa-cog fa-lg"></i>
          </button>
        </td>
      </tr>
    `).join('');

    // 상세 버튼 이벤트 리스너 추가
    tbody.querySelectorAll('[data-detail-id]').forEach(btn => {
      btn.addEventListener('click', () => showUserDetailModal(btn.dataset.detailId));
    });

    // 체크박스 이벤트 리스너 추가
    tbody.querySelectorAll('.user-checkbox').forEach(checkbox => {
      checkbox.addEventListener('change', handleUserCheckboxChange);
    });

    // 선택 상태 복원
    tbody.querySelectorAll('.user-checkbox').forEach(checkbox => {
      const userId = parseInt(checkbox.dataset.userId);
      checkbox.checked = selectedUsers.has(userId);
    });

    updateBulkActionsBar();
  }

  function renderPagination(pagination) {
    const container = document.getElementById('pagination-container');
    container.innerHTML = Pagination.render({
      ...pagination,
      onPageChange: (page) => {
        currentPage = page;
        loadUsers();
      },
    });
  }

  /**
   * 사용자 상세 모달 표시
   */
  async function showUserDetailModal(userId) {
    try {
      const response = await API.users.getById(userId);
      const user = response.data.user;
      const stats = response.data.stats;

      const isBanned = user.banned === true;
      const isActive = user.is_active !== false && !isBanned;

      const modalContent = `
        <div class="row mb-3">
          <div class="col-12">
            <div class="d-flex gap-2">
              <button type="button" class="btn btn-sm ${isActive ? 'btn-success' : 'btn-secondary'}" id="toggle-active-btn">
                <i class="fas fa-${isActive ? 'check-circle' : 'times-circle'} me-1"></i>
                ${isActive ? '활성' : '비활성'}
              </button>
              <button type="button" class="btn btn-sm ${isBanned ? 'btn-warning' : 'btn-danger'}" id="toggle-ban-btn">
                <i class="fas fa-${isBanned ? 'unlock' : 'ban'} me-1"></i>
                ${isBanned ? '차단 해제' : '차단'}
              </button>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-6">
            <h6 class="mb-3">기본 정보</h6>
            <table class="table table-sm">
              <tr><th width="40%">ID</th><td>${user.id}</td></tr>
              <tr><th>이메일</th><td>${user.email}</td></tr>
              <tr><th>구독</th><td>${Formatters.formatSubscription(user.subscription_type)}</td></tr>
              <tr><th>상태</th><td id="user-status-display">${Formatters.formatUserStatus(user)}</td></tr>
              ${isBanned ? `<tr><th>차단 사유</th><td class="text-danger">${Formatters.escapeHTML(user.ban_reason || '-')}</td></tr>` : ''}
              ${isBanned && user.banned_at ? `<tr><th>차단 일시</th><td>${Formatters.formatDate(user.banned_at, 'datetime')}</td></tr>` : ''}
              <tr><th>가입일</th><td>${Formatters.formatDate(user.created_at, 'datetime')}</td></tr>
            </table>
          </div>
          <div class="col-md-6">
            <h6 class="mb-3">학습 통계</h6>
            <table class="table table-sm">
              <tr><th width="40%">완료한 레슨</th><td>${stats?.completedLessons || 0}개</td></tr>
              <tr><th>진도 기록</th><td>${stats?.totalProgressEntries || 0}개</td></tr>
              <tr><th>평균 퀴즈 점수</th><td>${Math.round(stats?.averageQuizScore || 0)}점</td></tr>
            </table>
          </div>
        </div>
        <div class="row mt-3">
          <div class="col-12">
            <h6 class="mb-3">구독 정보</h6>
            <table class="table table-sm">
              <tr><th width="20%">구독 타입</th><td>${Formatters.formatSubscription(user.subscription_type)}</td></tr>
              ${user.subscription_started_at ? `<tr><th>구독 시작일</th><td>${Formatters.formatDate(user.subscription_started_at, 'date')}</td></tr>` : ''}
              ${user.subscription_expires_at ? `<tr><th>만료일</th><td>${Formatters.formatDate(user.subscription_expires_at, 'date')}</td></tr>` : ''}
            </table>
          </div>
        </div>
      `;

      // 모달 생성
      const modalId = 'user-detail-modal-' + userId;
      const modalHTML = `
        <div class="modal fade" id="${modalId}" tabindex="-1" aria-hidden="true">
          <div class="modal-dialog modal-lg">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">사용자 상세</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body">
                ${modalContent}
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-danger" id="delete-user-btn" title="삭제">
                  <i class="fas fa-trash"></i>
                </button>
                <button type="button" class="btn btn-primary" id="edit-user-btn" title="수정">
                  <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
              </div>
            </div>
          </div>
        </div>
      `;

      // 기존 모달 제거
      const existingModal = document.getElementById(modalId);
      if (existingModal) existingModal.remove();

      // 모달 추가 및 표시
      document.body.insertAdjacentHTML('beforeend', modalHTML);
      const modalElement = document.getElementById(modalId);
      const bsModal = new bootstrap.Modal(modalElement);
      bsModal.show();

      // 모달 닫힐 때 DOM에서 제거
      modalElement.addEventListener('hidden.bs.modal', () => {
        modalElement.remove();
      });

      // 활성/비활성 토글 버튼 이벤트
      document.getElementById('toggle-active-btn').addEventListener('click', async () => {
        const newActiveStatus = !isActive;

        // 비활성화할 때는 확인 필요
        if (isActive) {
          Modal.confirm('이 사용자를 비활성화하시겠습니까?', async () => {
            await toggleUserStatus(userId, newActiveStatus, bsModal);
          });
        } else {
          // 활성화는 바로 실행
          await toggleUserStatus(userId, newActiveStatus, bsModal);
        }
      });

      // 차단/해제 버튼 이벤트
      document.getElementById('toggle-ban-btn').addEventListener('click', async () => {
        if (isBanned) {
          await unbanUser(userId, bsModal);
        } else {
          await banUserWithReason(userId, bsModal);
        }
      });

      // 삭제 버튼 이벤트
      document.getElementById('delete-user-btn').addEventListener('click', () => {
        bsModal.hide();
        deleteUser(userId);
      });

      // 수정 버튼 이벤트
      document.getElementById('edit-user-btn').addEventListener('click', () => {
        bsModal.hide();
        showUserEditModal(userId, user);
      });
    } catch (error) {
      console.error('[UsersPage] 사용자 상세 로드 에러:', error);
      Toast.error('사용자 정보를 불러올 수 없습니다.');
    }
  }

  /**
   * 사용자 수정 모달 표시
   */
  async function showUserEditModal(userId, user) {
    const modalContent = `
      <form id="edit-user-form">
        <div class="mb-3">
          <label class="form-label">이메일</label>
          <input type="email" class="form-control" value="${user.email}" disabled>
          <small class="text-muted">이메일은 수정할 수 없습니다.</small>
        </div>
        <div class="mb-3">
          <label class="form-label">구독 타입</label>
          <select class="form-select" id="subscription-type" required>
            <option value="free" ${user.subscription_type === 'free' ? 'selected' : ''}>무료</option>
            <option value="premium" ${user.subscription_type === 'premium' ? 'selected' : ''}>프리미엄</option>
            <option value="lifetime" ${user.subscription_type === 'lifetime' ? 'selected' : ''}>평생</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">상태</label>
          <select class="form-select" id="user-status" required>
            <option value="active" ${(user.status || 'active') === 'active' ? 'selected' : ''}>활성</option>
            <option value="inactive" ${user.status === 'inactive' ? 'selected' : ''}>비활성</option>
            <option value="banned" ${user.status === 'banned' ? 'selected' : ''}>차단됨</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">언어 설정</label>
          <select class="form-select" id="language-preference">
            <option value="zh-CN" ${user.language_preference === 'zh-CN' ? 'selected' : ''}>중국어 (간체)</option>
            <option value="zh-TW" ${user.language_preference === 'zh-TW' ? 'selected' : ''}>중국어 (번체)</option>
          </select>
        </div>
      </form>
    `;

    Modal.custom({
      title: '사용자 수정',
      body: modalContent,
      size: 'md',
      confirmText: '저장',
      confirmClass: 'btn-primary',
      showCancel: true,
      cancelText: '취소',
      onConfirm: async () => {
        const subscriptionType = document.getElementById('subscription-type').value;
        const status = document.getElementById('user-status').value;
        const languagePreference = document.getElementById('language-preference').value;

        try {
          await API.users.update(userId, {
            subscription_type: subscriptionType,
            status: status,
            language_preference: languagePreference
          });

          Toast.success('사용자 정보가 수정되었습니다.');
          await loadUsers(); // 목록 새로고침
        } catch (error) {
          console.error('[UsersPage] 사용자 수정 에러:', error);
          Toast.error('사용자 정보 수정에 실패했습니다.');
        }
      }
    });
  }

  /**
   * 사용자 활성/비활성 상태 토글
   */
  async function toggleUserStatus(userId, isActive, currentModal) {
    try {
      await API.users.update(userId, { is_active: isActive });
      Toast.success(`사용자가 ${isActive ? '활성화' : '비활성화'}되었습니다.`);

      // 모달 닫고 목록 새로고침
      currentModal.hide();
      await loadUsers();
    } catch (error) {
      console.error('[UsersPage] 상태 변경 에러:', error);
      Toast.error('상태 변경에 실패했습니다.');
    }
  }

  /**
   * 사용자 차단 (사유 입력)
   */
  async function banUserWithReason(userId, currentModal) {
    const banReasonForm = `
      <form id="ban-reason-form">
        <div class="mb-3">
          <label class="form-label">차단 사유</label>
          <textarea class="form-control" id="ban-reason" rows="3" required placeholder="차단 사유를 입력하세요"></textarea>
        </div>
      </form>
    `;

    // 현재 모달 닫기
    currentModal.hide();

    Modal.custom({
      title: '사용자 차단',
      body: banReasonForm,
      size: 'md',
      confirmText: '차단',
      confirmClass: 'btn-danger',
      showCancel: true,
      cancelText: '취소',
      onConfirm: async () => {
        const reason = document.getElementById('ban-reason').value.trim();

        if (!reason) {
          Toast.error('차단 사유를 입력해주세요.');
          return;
        }

        try {
          await API.users.ban(userId, {
            banned: true,
            ban_reason: reason
          });
          Toast.success('사용자가 차단되었습니다.');
          await loadUsers();
        } catch (error) {
          console.error('[UsersPage] 차단 에러:', error);
          Toast.error('사용자 차단에 실패했습니다.');
        }
      }
    });
  }

  /**
   * 사용자 차단 해제
   */
  async function unbanUser(userId, currentModal) {
    Modal.confirm('이 사용자의 차단을 해제하시겠습니까?', async () => {
      try {
        await API.users.ban(userId, {
          banned: false,
          ban_reason: null
        });
        Toast.success('차단이 해제되었습니다.');

        // 모달 닫고 목록 새로고침
        currentModal.hide();
        await loadUsers();
      } catch (error) {
        console.error('[UsersPage] 차단 해제 에러:', error);
        Toast.error('차단 해제에 실패했습니다.');
      }
    });
  }

  /**
   * 사용자 삭제
   */
  async function deleteUser(userId) {
    Modal.confirm('정말 이 사용자를 삭제하시겠습니까?<br><small class="text-danger">이 작업은 되돌릴 수 없습니다.</small>', async () => {
      try {
        await API.users.delete(userId);
        Toast.success('사용자가 삭제되었습니다.');
        await loadUsers(); // 목록 새로고침
      } catch (error) {
        console.error('[UsersPage] 사용자 삭제 에러:', error);
        Toast.error('사용자 삭제에 실패했습니다.');
      }
    });
  }

  /**
   * 개별 체크박스 변경 핸들러
   */
  function handleUserCheckboxChange(e) {
    const userId = parseInt(e.target.dataset.userId);

    if (e.target.checked) {
      selectedUsers.add(userId);
    } else {
      selectedUsers.delete(userId);
    }

    updateBulkActionsBar();
    updateSelectAllCheckbox();
  }

  /**
   * 전체 선택 체크박스 핸들러
   */
  function handleSelectAllChange(e) {
    const checkboxes = document.querySelectorAll('.user-checkbox');

    checkboxes.forEach(checkbox => {
      const userId = parseInt(checkbox.dataset.userId);
      checkbox.checked = e.target.checked;

      if (e.target.checked) {
        selectedUsers.add(userId);
      } else {
        selectedUsers.delete(userId);
      }
    });

    updateBulkActionsBar();
  }

  /**
   * 일괄 작업 바 표시/숨김 및 카운트 업데이트
   */
  function updateBulkActionsBar() {
    const bulkActionsBar = document.getElementById('bulk-actions-bar');
    const selectedCount = document.getElementById('selected-count');
    const count = selectedUsers.size;

    if (count > 0) {
      bulkActionsBar.style.display = 'block';
      selectedCount.textContent = `${count}명 선택됨`;
    } else {
      bulkActionsBar.style.display = 'none';
    }
  }

  /**
   * 전체 선택 체크박스 상태 업데이트
   */
  function updateSelectAllCheckbox() {
    const selectAllCheckbox = document.getElementById('select-all-checkbox');
    const checkboxes = document.querySelectorAll('.user-checkbox');
    const checkedCount = document.querySelectorAll('.user-checkbox:checked').length;

    if (checkboxes.length === 0) {
      selectAllCheckbox.checked = false;
      selectAllCheckbox.indeterminate = false;
    } else if (checkedCount === 0) {
      selectAllCheckbox.checked = false;
      selectAllCheckbox.indeterminate = false;
    } else if (checkedCount === checkboxes.length) {
      selectAllCheckbox.checked = true;
      selectAllCheckbox.indeterminate = false;
    } else {
      selectAllCheckbox.checked = false;
      selectAllCheckbox.indeterminate = true;
    }
  }

  /**
   * 일괄 활성화
   */
  async function handleBulkActivate() {
    if (selectedUsers.size === 0) return;

    Modal.confirm(`선택한 ${selectedUsers.size}명의 사용자를 활성화하시겠습니까?`, async () => {
      const userIds = Array.from(selectedUsers);
      let successCount = 0;
      let failCount = 0;

      for (const userId of userIds) {
        try {
          await API.users.update(userId, { is_active: true });
          successCount++;
        } catch (error) {
          console.error(`[UsersPage] 사용자 ${userId} 활성화 에러:`, error);
          failCount++;
        }
      }

      if (successCount > 0) {
        Toast.success(`${successCount}명의 사용자가 활성화되었습니다.`);
      }
      if (failCount > 0) {
        Toast.error(`${failCount}명의 사용자 활성화에 실패했습니다.`);
      }

      selectedUsers.clear();
      await loadUsers();
    });
  }

  /**
   * 일괄 비활성화
   */
  async function handleBulkDeactivate() {
    if (selectedUsers.size === 0) return;

    Modal.confirm(`선택한 ${selectedUsers.size}명의 사용자를 비활성화하시겠습니까?`, async () => {
      const userIds = Array.from(selectedUsers);
      let successCount = 0;
      let failCount = 0;

      for (const userId of userIds) {
        try {
          await API.users.update(userId, { is_active: false });
          successCount++;
        } catch (error) {
          console.error(`[UsersPage] 사용자 ${userId} 비활성화 에러:`, error);
          failCount++;
        }
      }

      if (successCount > 0) {
        Toast.success(`${successCount}명의 사용자가 비활성화되었습니다.`);
      }
      if (failCount > 0) {
        Toast.error(`${failCount}명의 사용자 비활성화에 실패했습니다.`);
      }

      selectedUsers.clear();
      await loadUsers();
    });
  }

  /**
   * 일괄 삭제
   */
  async function handleBulkDelete() {
    if (selectedUsers.size === 0) return;

    Modal.confirm(
      `정말 선택한 ${selectedUsers.size}명의 사용자를 삭제하시겠습니까?<br><small class="text-danger">이 작업은 되돌릴 수 없습니다.</small>`,
      async () => {
        const userIds = Array.from(selectedUsers);
        let successCount = 0;
        let failCount = 0;

        for (const userId of userIds) {
          try {
            await API.users.delete(userId);
            successCount++;
          } catch (error) {
            console.error(`[UsersPage] 사용자 ${userId} 삭제 에러:`, error);
            failCount++;
          }
        }

        if (successCount > 0) {
          Toast.success(`${successCount}명의 사용자가 삭제되었습니다.`);
        }
        if (failCount > 0) {
          Toast.error(`${failCount}명의 사용자 삭제에 실패했습니다.`);
        }

        selectedUsers.clear();
        await loadUsers();
      }
    );
  }

  /**
   * 선택 해제
   */
  function handleBulkClear() {
    selectedUsers.clear();

    // 모든 체크박스 해제
    document.querySelectorAll('.user-checkbox').forEach(checkbox => {
      checkbox.checked = false;
    });

    updateBulkActionsBar();
    updateSelectAllCheckbox();
  }

  return { render, renderDetail };
})();
