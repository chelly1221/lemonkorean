/**
 * SNS Moderation Page
 * 커뮤니티 콘텐츠 관리 (신고 처리, 게시글 삭제, 유저 차단)
 */

const SnsModerationPage = (() => {
  let currentTab = 'stats';

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('SNS 관리')}
          <div class="content-container">
            <ul class="nav nav-tabs mb-4" role="tablist">
              <li class="nav-item">
                <a class="nav-link ${currentTab === 'stats' ? 'active' : ''}" href="#" data-tab="stats">
                  <i class="fas fa-chart-bar me-1"></i>통계
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link ${currentTab === 'reports' ? 'active' : ''}" href="#" data-tab="reports">
                  <i class="fas fa-flag me-1"></i>신고
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link ${currentTab === 'posts' ? 'active' : ''}" href="#" data-tab="posts">
                  <i class="fas fa-file-alt me-1"></i>게시글
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link ${currentTab === 'users' ? 'active' : ''}" href="#" data-tab="users">
                  <i class="fas fa-users me-1"></i>유저
                </a>
              </li>
            </ul>
            <div id="sns-tab-content"></div>
          </div>
        </div>
      </div>
    `;

    Router.render(layout);

    // Tab click handlers
    document.querySelectorAll('[data-tab]').forEach(tab => {
      tab.addEventListener('click', (e) => {
        e.preventDefault();
        currentTab = e.target.closest('[data-tab]').dataset.tab;
        render();
      });
    });

    // Load tab content
    switch (currentTab) {
      case 'stats': await renderStats(); break;
      case 'reports': await renderReports(); break;
      case 'posts': await renderPosts(); break;
      case 'users': await renderUsers(); break;
    }
  }

  async function renderStats() {
    const container = document.getElementById('sns-tab-content');
    try {
      const res = await API.snsModeration.getStats();
      const stats = res;

      container.innerHTML = `
        <div class="row g-4">
          <div class="col-md-3">
            <div class="card text-center">
              <div class="card-body">
                <h3 class="text-primary">${stats.posts.total}</h3>
                <p class="text-muted mb-0">총 게시글</p>
                <small class="text-danger">${stats.posts.deleted} 삭제됨</small>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="card text-center">
              <div class="card-body">
                <h3 class="text-success">${stats.users.active}</h3>
                <p class="text-muted mb-0">활성 유저</p>
                <small class="text-danger">${stats.users.banned} 차단됨</small>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="card text-center">
              <div class="card-body">
                <h3 class="text-warning">${stats.reports.pending}</h3>
                <p class="text-muted mb-0">대기 중 신고</p>
                <small class="text-muted">총 ${stats.reports.total}건</small>
              </div>
            </div>
          </div>
          <div class="col-md-3">
            <div class="card text-center">
              <div class="card-body">
                <h3 class="text-info">${stats.comments.total}</h3>
                <p class="text-muted mb-0">총 댓글</p>
              </div>
            </div>
          </div>
        </div>
      `;
    } catch (error) {
      container.innerHTML = `<div class="alert alert-danger">통계 로드 실패: ${error.message}</div>`;
    }
  }

  async function renderReports() {
    const container = document.getElementById('sns-tab-content');
    try {
      const res = await API.snsModeration.getReports({ status: 'all' });
      const reports = res.reports || [];

      if (reports.length === 0) {
        container.innerHTML = '<div class="alert alert-info">신고 내역이 없습니다.</div>';
        return;
      }

      const statusBadge = (status) => {
        const colors = { pending: 'warning', reviewed: 'info', resolved: 'success', dismissed: 'secondary' };
        return `<span class="badge bg-${colors[status] || 'secondary'}">${status}</span>`;
      };

      container.innerHTML = `
        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>ID</th>
                <th>신고자</th>
                <th>유형</th>
                <th>대상 내용</th>
                <th>사유</th>
                <th>상태</th>
                <th>날짜</th>
                <th>액션</th>
              </tr>
            </thead>
            <tbody>
              ${reports.map(r => `
                <tr>
                  <td>${r.id}</td>
                  <td>${r.reporter_name}</td>
                  <td><span class="badge bg-primary">${r.target_type}</span></td>
                  <td class="text-truncate" style="max-width:200px">${r.target_content || '-'}</td>
                  <td class="text-truncate" style="max-width:150px">${r.reason}</td>
                  <td>${statusBadge(r.status)}</td>
                  <td>${new Date(r.created_at).toLocaleDateString()}</td>
                  <td>
                    ${r.status === 'pending' ? `
                      <div class="btn-group btn-group-sm">
                        <button class="btn btn-success btn-sm" onclick="SnsModerationPage.resolveReport(${r.id})">처리</button>
                        <button class="btn btn-secondary btn-sm" onclick="SnsModerationPage.dismissReport(${r.id})">무시</button>
                      </div>
                    ` : '-'}
                  </td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      `;
    } catch (error) {
      container.innerHTML = `<div class="alert alert-danger">신고 목록 로드 실패: ${error.message}</div>`;
    }
  }

  async function renderPosts() {
    const container = document.getElementById('sns-tab-content');
    try {
      const res = await API.snsModeration.getPosts();
      const posts = res.posts || [];

      if (posts.length === 0) {
        container.innerHTML = '<div class="alert alert-info">게시글이 없습니다.</div>';
        return;
      }

      container.innerHTML = `
        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>ID</th>
                <th>작성자</th>
                <th>내용</th>
                <th>카테고리</th>
                <th>좋아요</th>
                <th>댓글</th>
                <th>신고</th>
                <th>상태</th>
                <th>날짜</th>
                <th>액션</th>
              </tr>
            </thead>
            <tbody>
              ${posts.map(p => `
                <tr class="${p.is_deleted ? 'table-danger' : ''}">
                  <td>${p.id}</td>
                  <td>${p.author_name}</td>
                  <td class="text-truncate" style="max-width:250px">${p.content}</td>
                  <td><span class="badge bg-${p.category === 'learning' ? 'info' : 'secondary'}">${p.category}</span></td>
                  <td>${p.like_count}</td>
                  <td>${p.comment_count}</td>
                  <td>${p.report_count > 0 ? `<span class="badge bg-danger">${p.report_count}</span>` : '0'}</td>
                  <td>${p.is_deleted ? '<span class="badge bg-danger">삭제됨</span>' : '<span class="badge bg-success">활성</span>'}</td>
                  <td>${new Date(p.created_at).toLocaleDateString()}</td>
                  <td>
                    ${!p.is_deleted ? `<button class="btn btn-danger btn-sm" onclick="SnsModerationPage.deletePost(${p.id})">삭제</button>` : '-'}
                  </td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      `;
    } catch (error) {
      container.innerHTML = `<div class="alert alert-danger">게시글 로드 실패: ${error.message}</div>`;
    }
  }

  async function renderUsers() {
    const container = document.getElementById('sns-tab-content');
    try {
      const res = await API.snsModeration.getUsers();
      const users = res.users || [];

      if (users.length === 0) {
        container.innerHTML = '<div class="alert alert-info">SNS 활동 유저가 없습니다.</div>';
        return;
      }

      container.innerHTML = `
        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>ID</th>
                <th>이름</th>
                <th>이메일</th>
                <th>게시글</th>
                <th>팔로워</th>
                <th>팔로잉</th>
                <th>상태</th>
                <th>액션</th>
              </tr>
            </thead>
            <tbody>
              ${users.map(u => `
                <tr class="${u.sns_banned ? 'table-warning' : ''}">
                  <td>${u.id}</td>
                  <td>${u.name}</td>
                  <td>${u.email}</td>
                  <td>${u.post_count}</td>
                  <td>${u.follower_count}</td>
                  <td>${u.following_count}</td>
                  <td>${u.sns_banned ? '<span class="badge bg-danger">차단</span>' : '<span class="badge bg-success">정상</span>'}</td>
                  <td>
                    ${u.sns_banned
                      ? `<button class="btn btn-success btn-sm" onclick="SnsModerationPage.unbanUser(${u.id})">차단 해제</button>`
                      : `<button class="btn btn-danger btn-sm" onclick="SnsModerationPage.banUser(${u.id})">차단</button>`
                    }
                  </td>
                </tr>
              `).join('')}
            </tbody>
          </table>
        </div>
      `;
    } catch (error) {
      container.innerHTML = `<div class="alert alert-danger">유저 로드 실패: ${error.message}</div>`;
    }
  }

  // Action handlers
  async function resolveReport(id) {
    if (!confirm('이 신고를 처리 완료하시겠습니까?')) return;
    try {
      await API.snsModeration.updateReport(id, { status: 'resolved', admin_notes: 'Resolved by admin' });
      await renderReports();
    } catch (error) {
      alert('처리 실패: ' + error.message);
    }
  }

  async function dismissReport(id) {
    if (!confirm('이 신고를 무시하시겠습니까?')) return;
    try {
      await API.snsModeration.updateReport(id, { status: 'dismissed', admin_notes: 'Dismissed by admin' });
      await renderReports();
    } catch (error) {
      alert('처리 실패: ' + error.message);
    }
  }

  async function deletePost(id) {
    if (!confirm('이 게시글을 삭제하시겠습니까?')) return;
    try {
      await API.snsModeration.deletePost(id);
      await renderPosts();
    } catch (error) {
      alert('삭제 실패: ' + error.message);
    }
  }

  async function banUser(id) {
    if (!confirm('이 유저를 SNS에서 차단하시겠습니까?')) return;
    try {
      await API.snsModeration.banUser(id);
      await renderUsers();
    } catch (error) {
      alert('차단 실패: ' + error.message);
    }
  }

  async function unbanUser(id) {
    if (!confirm('이 유저의 SNS 차단을 해제하시겠습니까?')) return;
    try {
      await API.snsModeration.unbanUser(id);
      await renderUsers();
    } catch (error) {
      alert('해제 실패: ' + error.message);
    }
  }

  return {
    render,
    resolveReport,
    dismissReport,
    deletePost,
    banUser,
    unbanUser,
  };
})();
