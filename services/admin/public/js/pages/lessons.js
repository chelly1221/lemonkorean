/**
 * Enhanced Lessons Management Page
 *
 * 완전한 레슨 관리 기능
 */

const LessonsPage = (() => {
  let currentPage = 1;

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('레슨 관리', [
            { label: '새 레슨', icon: 'fa-plus', class: 'btn-primary', onClick: () => Router.navigate('/lessons/new') }
          ])}
          <div class="content-container">
            <div class="table-card">
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>레벨</th>
                      <th>주차</th>
                      <th>순서</th>
                      <th>제목</th>
                      <th>난이도</th>
                      <th>상태</th>
                      <th>작업</th>
                    </tr>
                  </thead>
                  <tbody id="lessons-tbody">
                    <tr><td colspan="8" class="text-center"><div class="spinner-border"></div></td></tr>
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
    await loadLessons();
  }

  async function renderNew() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('새 레슨 만들기', [
            { label: '목록으로', icon: 'fa-list', class: 'btn-secondary', onClick: () => Router.navigate('/lessons') }
          ])}
          <div class="content-container">
            ${renderLessonForm()}
          </div>
        </div>
      </div>
    `;
    Router.render(layout);
    Sidebar.updateActive();
    attachFormListeners();
  }

  async function renderEdit(params) {
    try {
      const response = await API.lessons.getById(params.id);
      const lesson = response.data;

      const layout = `
        <div class="app-layout">
          ${Sidebar.render()}
          <div class="main-content">
            ${Header.render('레슨 수정', [
              { label: '목록으로', icon: 'fa-list', class: 'btn-secondary', onClick: () => Router.navigate('/lessons') }
            ])}
            <div class="content-container">
              ${renderLessonForm(lesson)}
            </div>
          </div>
        </div>
      `;
      Router.render(layout);
      Sidebar.updateActive();
      attachFormListeners(params.id);
    } catch (error) {
      Toast.error('레슨 정보를 불러올 수 없습니다.');
      Router.navigate('/lessons');
    }
  }

  function renderLessonForm(lesson = null) {
    const isEdit = lesson !== null;

    return `
      <div class="card">
        <div class="card-body">
          <form id="lesson-form">
            <!-- 기본 정보 섹션 -->
            <h5 class="mb-3"><i class="fas fa-info-circle me-2"></i>기본 정보</h5>
            <div class="row">
              <div class="col-md-2">
                <div class="mb-3">
                  <label class="form-label">레벨 *</label>
                  <select class="form-select" name="level" required>
                    <option value="">선택</option>
                    ${[1,2,3,4,5,6].map(l => `
                      <option value="${l}" ${lesson?.level == l ? 'selected' : ''}>레벨 ${l}</option>
                    `).join('')}
                  </select>
                  <small class="text-muted">TOPIK 레벨 (1-6)</small>
                </div>
              </div>
              <div class="col-md-2">
                <div class="mb-3">
                  <label class="form-label">주차 *</label>
                  <input type="number" class="form-control" name="week"
                         value="${lesson?.week || ''}" min="1" required>
                  <small class="text-muted">Week number</small>
                </div>
              </div>
              <div class="col-md-2">
                <div class="mb-3">
                  <label class="form-label">순서 *</label>
                  <input type="number" class="form-control" name="order_num"
                         value="${lesson?.order_num || ''}" min="1" required>
                  <small class="text-muted">레슨 순서</small>
                </div>
              </div>
              <div class="col-md-3">
                <div class="mb-3">
                  <label class="form-label">난이도 *</label>
                  <select class="form-select" name="difficulty" required>
                    <option value="">선택</option>
                    <option value="beginner" ${lesson?.difficulty === 'beginner' ? 'selected' : ''}>입문 (Beginner)</option>
                    <option value="elementary" ${lesson?.difficulty === 'elementary' ? 'selected' : ''}>초급 (Elementary)</option>
                    <option value="intermediate" ${lesson?.difficulty === 'intermediate' ? 'selected' : ''}>중급 (Intermediate)</option>
                    <option value="advanced" ${lesson?.difficulty === 'advanced' ? 'selected' : ''}>고급 (Advanced)</option>
                  </select>
                </div>
              </div>
              <div class="col-md-3">
                <div class="mb-3">
                  <label class="form-label">소요 시간 (분)</label>
                  <input type="number" class="form-control" name="duration_minutes"
                         value="${lesson?.duration_minutes || 30}" min="5">
                  <small class="text-muted">기본 30분</small>
                </div>
              </div>
            </div>

            <!-- 제목 및 설명 -->
            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">제목 (한국어) *</label>
                  <input type="text" class="form-control" name="title_ko"
                         value="${Formatters.escapeHTML(lesson?.title_ko || '')}" required>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">제목 (중국어) *</label>
                  <input type="text" class="form-control" name="title_zh"
                         value="${Formatters.escapeHTML(lesson?.title_zh || '')}" required>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">설명 (한국어)</label>
                  <textarea class="form-control" name="description_ko" rows="3">${Formatters.escapeHTML(lesson?.description_ko || '')}</textarea>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">설명 (중국어)</label>
                  <textarea class="form-control" name="description_zh" rows="3">${Formatters.escapeHTML(lesson?.description_zh || '')}</textarea>
                </div>
              </div>
            </div>

            <!-- 미디어 & 메타데이터 -->
            <hr class="my-4">
            <h5 class="mb-3"><i class="fas fa-image me-2"></i>미디어 & 메타데이터</h5>

            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">썸네일 URL</label>
                  <input type="url" class="form-control" name="thumbnail_url"
                         value="${lesson?.thumbnail_url || ''}"
                         placeholder="http://cdn.example.com/thumb.jpg">
                  <small class="text-muted">이미지 URL (선택사항)</small>
                </div>
              </div>
              <div class="col-md-3">
                <div class="mb-3">
                  <label class="form-label">버전</label>
                  <input type="text" class="form-control" name="version"
                         value="${lesson?.version || '1.0.0'}" placeholder="1.0.0">
                </div>
              </div>
              <div class="col-md-3">
                <div class="mb-3">
                  <label class="form-label">상태 *</label>
                  <select class="form-select" name="status" required>
                    <option value="draft" ${lesson?.status === 'draft' ? 'selected' : ''}>초안 (Draft)</option>
                    <option value="published" ${lesson?.status === 'published' ? 'selected' : ''}>발행됨 (Published)</option>
                    <option value="archived" ${lesson?.status === 'archived' ? 'selected' : ''}>보관됨 (Archived)</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- 선수 레슨 & 태그 -->
            <div class="row">
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">선수 레슨 ID</label>
                  <input type="text" class="form-control" name="prerequisites"
                         value="${lesson?.prerequisites?.join(', ') || ''}"
                         placeholder="1, 2, 3">
                  <small class="text-muted">쉼표로 구분 (예: 1, 2, 3)</small>
                </div>
              </div>
              <div class="col-md-6">
                <div class="mb-3">
                  <label class="form-label">태그</label>
                  <input type="text" class="form-control" name="tags"
                         value="${lesson?.tags?.join(', ') || ''}"
                         placeholder="인사, 일상회화">
                  <small class="text-muted">쉼표로 구분 (예: 인사, 일상회화)</small>
                </div>
              </div>
            </div>

            <!-- 레슨 콘텐츠 (MongoDB) 안내 -->
            ${isEdit ? `
              <hr class="my-4">
              <div class="alert alert-info">
                <div class="d-flex justify-content-between align-items-start">
                  <div class="flex-grow-1">
                    <h6><i class="fas fa-info-circle me-2"></i>레슨 콘텐츠 (7단계)</h6>
                    <p class="mb-2">레슨의 상세 콘텐츠(7단계 학습 내용, 단어, 문법 등)는 MongoDB에 저장됩니다.</p>
                    <p class="mb-0">
                      <strong>콘텐츠 편집:</strong> 웹 기반 에디터를 사용하거나 Mongo Express에서 직접 편집할 수 있습니다.
                    </p>
                  </div>
                  <button type="button" class="btn btn-primary ms-3"
                          onclick="Router.navigate('/lessons/${lesson.id}/content')">
                    <i class="fas fa-file-alt me-2"></i>콘텐츠 편집기 열기
                  </button>
                </div>
              </div>
            ` : ''}

            <!-- 버튼 -->
            <div class="d-flex gap-2 mt-4">
              <button type="submit" class="btn btn-primary">
                <i class="fas fa-save me-2"></i>${isEdit ? '수정' : '생성'}
              </button>
              <button type="button" class="btn btn-secondary" onclick="Router.navigate('/lessons')">
                <i class="fas fa-times me-2"></i>취소
              </button>
              ${isEdit ? `
                <button type="button" class="btn btn-success ms-auto" onclick="LessonsPage.publishLesson(${lesson.id})">
                  <i class="fas fa-check me-2"></i>발행
                </button>
                <button type="button" class="btn btn-danger" onclick="LessonsPage.deleteLesson(${lesson.id})">
                  <i class="fas fa-trash me-2"></i>삭제
                </button>
              ` : ''}
            </div>
          </form>
        </div>
      </div>
    `;
  }

  function attachFormListeners(lessonId = null) {
    document.getElementById('lesson-form').addEventListener('submit', async (e) => {
      e.preventDefault();
      const formData = new FormData(e.target);
      const data = Object.fromEntries(formData);

      // 배열 필드 처리
      if (data.prerequisites) {
        data.prerequisites = data.prerequisites.split(',').map(id => parseInt(id.trim())).filter(id => !isNaN(id));
      } else {
        data.prerequisites = [];
      }

      if (data.tags) {
        data.tags = data.tags.split(',').map(tag => tag.trim()).filter(tag => tag);
      } else {
        data.tags = [];
      }

      // 숫자 변환
      data.level = parseInt(data.level);
      data.week = parseInt(data.week);
      data.order_num = parseInt(data.order_num);
      data.duration_minutes = parseInt(data.duration_minutes);

      try {
        if (lessonId) {
          await API.lessons.update(lessonId, data);
          Toast.success('레슨이 수정되었습니다.');
        } else {
          await API.lessons.create(data);
          Toast.success('레슨이 생성되었습니다.');
        }
        Router.navigate('/lessons');
      } catch (error) {
        Toast.error(error.message || '레슨 저장에 실패했습니다.');
      }
    });
  }

  async function loadLessons() {
    try {
      const response = await API.lessons.list({ page: currentPage, limit: 20 });
      renderTable(response.data);
      renderPagination(response.pagination);
    } catch (error) {
      Toast.error('레슨 목록을 불러올 수 없습니다.');
    }
  }

  function renderTable(lessons) {
    const tbody = document.getElementById('lessons-tbody');
    if (lessons.length === 0) {
      tbody.innerHTML = '<tr><td colspan="8" class="text-center">레슨이 없습니다.</td></tr>';
      return;
    }
    tbody.innerHTML = lessons.map(lesson => `
      <tr>
        <td>${lesson.id}</td>
        <td>L${lesson.level}</td>
        <td>W${lesson.week}</td>
        <td>#${lesson.order_num}</td>
        <td>
          <strong>${lesson.title_ko}</strong><br>
          <small class="text-muted">${lesson.title_zh}</small>
        </td>
        <td>
          <span class="badge bg-${getDifficultyColor(lesson.difficulty)}">
            ${Formatters.formatDifficulty(lesson.difficulty)}
          </span>
        </td>
        <td>
          <span class="badge bg-${getStatusColor(lesson.status)}">
            ${Formatters.formatLessonStatus(lesson.status)}
          </span>
        </td>
        <td>
          <button class="btn btn-sm btn-link text-secondary p-0 me-2"
                  onclick="Router.navigate('/lessons/${lesson.id}')" title="메타데이터 편집">
            <i class="fas fa-edit fa-lg"></i>
          </button>
          <button class="btn btn-sm btn-link text-primary p-0 me-2"
                  onclick="Router.navigate('/lessons/${lesson.id}/content')" title="콘텐츠 편집">
            <i class="fas fa-file-alt fa-lg"></i>
          </button>
          ${lesson.status === 'draft' ? `
            <button class="btn btn-sm btn-link text-success p-0 me-2"
                    onclick="LessonsPage.publishLesson(${lesson.id})" title="발행">
              <i class="fas fa-check fa-lg"></i>
            </button>
          ` : ''}
          <button class="btn btn-sm btn-link text-danger p-0"
                  onclick="LessonsPage.deleteLesson(${lesson.id})" title="삭제">
            <i class="fas fa-trash fa-lg"></i>
          </button>
        </td>
      </tr>
    `).join('');
  }

  function getDifficultyColor(difficulty) {
    const colors = {
      beginner: 'success',
      elementary: 'info',
      intermediate: 'warning',
      advanced: 'danger'
    };
    return colors[difficulty] || 'secondary';
  }

  function getStatusColor(status) {
    const colors = {
      draft: 'secondary',
      published: 'success',
      archived: 'dark'
    };
    return colors[status] || 'secondary';
  }

  function renderPagination(pagination) {
    document.getElementById('pagination-container').innerHTML = Pagination.render({
      ...pagination,
      onPageChange: (page) => {
        currentPage = page;
        loadLessons();
      },
    });
  }

  async function publishLesson(id) {
    Modal.confirm('이 레슨을 발행하시겠습니까?', async () => {
      try {
        await API.lessons.publish(id);
        Toast.success('레슨이 발행되었습니다.');
        await loadLessons();
      } catch (error) {
        Toast.error(error.message || '레슨 발행에 실패했습니다.');
      }
    });
  }

  async function deleteLesson(id) {
    Modal.confirm('이 레슨을 삭제하시겠습니까?', async () => {
      try {
        await API.lessons.delete(id);
        Toast.success('레슨이 삭제되었습니다.');
        await loadLessons();
      } catch (error) {
        Toast.error(error.message || '레슨 삭제에 실패했습니다.');
      }
    });
  }

  return { render, renderNew, renderEdit, publishLesson, deleteLesson };
})();
