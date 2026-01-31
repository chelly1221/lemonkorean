/**
 * Development Notes Page
 *
 * 개발노트 뷰어 페이지 - 마크다운 개발노트 탐색 및 열람
 *
 * 주요 기능:
 * - 두 가지 뷰 모드: 시간순 (Timeline) / 카테고리별 (Category)
 * - 카테고리 필터링
 * - 마크다운 렌더링 (Marked.js)
 * - 우선순위 배지 표시
 */

const DevNotesPage = (() => {
  // ==================== State ====================
  let state = {
    notes: [],
    categories: [],
    currentView: 'timeline', // 'timeline' | 'category'
    selectedCategory: null, // null = all categories
    currentNote: null,
    loading: false,
    error: null,
    expandedGroups: new Set(), // 펼쳐진 그룹 추적
  };

  // ==================== Main Render ====================

  /**
   * 페이지 렌더링
   */
  async function render() {
    console.log('[DevNotesPage] Rendering');

    // 초기 페이지 구조 렌더링 (Sidebar + Header 포함)
    Router.render(`
      ${Sidebar.render()}
      <main class="main-content">
        ${Header.render('개발노트')}
        <div class="content-wrapper">
          <div class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
              <span class="visually-hidden">로딩 중...</span>
            </div>
            <p class="mt-3 text-muted">개발노트를 불러오는 중...</p>
          </div>
        </div>
      </main>
    `);

    // 스타일 추가
    addStyles();

    try {
      // 데이터 로드
      await loadNotes();
      await loadCategories();

      // 초기 로드 시 첫 번째 그룹 펼치기
      if (state.notes.length > 0 && state.expandedGroups.size === 0) {
        const groupedNotes = state.currentView === 'timeline'
          ? groupByDate(state.notes)
          : groupByCategory(state.notes);
        const firstGroup = Object.keys(groupedNotes)[0];
        if (firstGroup) {
          state.expandedGroups.add(firstGroup);
        }
      }

      // 컨텐츠 영역에 dev notes 렌더링
      const contentWrapper = document.querySelector('.content-wrapper');
      if (contentWrapper) {
        contentWrapper.innerHTML = renderLayout();
      }

      // 이벤트 리스너 연결
      attachEventListeners();

      // 첫 번째 노트 자동 선택 (있으면)
      if (state.notes.length > 0) {
        await loadNote(state.notes[0].path);
      } else {
        renderEmptyState();
      }
    } catch (error) {
      console.error('[DevNotesPage] Render error:', error);
      const contentWrapper = document.querySelector('.content-wrapper');
      if (contentWrapper) {
        contentWrapper.innerHTML = renderError(error.message);
      }
    }
  }

  // ==================== Data Loading ====================

  /**
   * 노트 목록 로드
   */
  async function loadNotes() {
    console.log('[DevNotesPage] Loading notes...');
    state.loading = true;

    try {
      const response = await API.devNotes.list();

      if (response.success) {
        state.notes = response.notes || [];
        console.log(`[DevNotesPage] Loaded ${state.notes.length} notes`);
      } else {
        throw new Error('Failed to load notes');
      }
    } catch (error) {
      console.error('[DevNotesPage] Error loading notes:', error);
      state.error = error.message;
      throw error;
    } finally {
      state.loading = false;
    }
  }

  /**
   * 카테고리 목록 로드
   */
  async function loadCategories() {
    console.log('[DevNotesPage] Loading categories...');

    try {
      const response = await API.devNotes.categories();

      if (response.success) {
        state.categories = response.categories || [];
        console.log(`[DevNotesPage] Loaded ${state.categories.length} categories`);
      }
    } catch (error) {
      console.error('[DevNotesPage] Error loading categories:', error);
      // Non-critical, continue
    }
  }

  /**
   * 특정 노트 로드
   */
  async function loadNote(notePath) {
    console.log('[DevNotesPage] Loading note:', notePath);

    try {
      // 로딩 상태 표시
      const contentArea = document.getElementById('dev-note-content');
      if (contentArea) {
        contentArea.innerHTML = `
          <div class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
              <span class="visually-hidden">로딩 중...</span>
            </div>
          </div>
        `;
      }

      const response = await API.devNotes.content(notePath);

      if (response.success && response.note) {
        state.currentNote = response.note;
        renderNoteContent();
        highlightActiveNote(notePath);
      } else {
        throw new Error('Failed to load note content');
      }
    } catch (error) {
      console.error('[DevNotesPage] Error loading note:', error);

      const contentArea = document.getElementById('dev-note-content');
      if (contentArea) {
        contentArea.innerHTML = `
          <div class="alert alert-danger">
            <i class="fas fa-exclamation-triangle"></i>
            노트를 불러오는 중 오류가 발생했습니다: ${error.message}
          </div>
        `;
      }
    }
  }

  // ==================== Rendering ====================

  /**
   * 스타일 추가
   */
  function addStyles() {
    // 이미 스타일이 존재하면 추가하지 않음
    if (document.getElementById('dev-notes-styles')) return;

    const styles = document.createElement('style');
    styles.id = 'dev-notes-styles';
    styles.textContent = `
      .dev-notes-layout {
        display: flex;
        gap: 20px;
        height: calc(100vh - 180px);
        background: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      }

      .dev-notes-sidebar {
        flex: 0 0 350px;
        display: flex;
        flex-direction: column;
        border-left: 1px solid #dee2e6;
        padding: 20px;
        overflow: hidden;
        background: #f8f9fa;
      }

      .dev-notes-content {
        flex: 1;
        overflow-y: auto;
        padding: 24px 32px;
      }

        .dev-note-item {
          cursor: pointer;
          padding: 12px;
          margin-bottom: 8px;
          border: 1px solid #e0e0e0;
          border-radius: 6px;
          transition: all 0.2s;
        }

        .dev-note-item:hover {
          background-color: #f8f9fa;
          border-color: #0d6efd;
        }

        .dev-note-item.active {
          background-color: #e7f1ff;
          border-color: #0d6efd;
          font-weight: 500;
        }

        .dev-note-item-title {
          font-size: 14px;
          font-weight: 500;
          margin-bottom: 6px;
          color: #212529;
        }

        .dev-note-item-meta {
          font-size: 12px;
          color: #6c757d;
          display: flex;
          gap: 8px;
          flex-wrap: wrap;
          align-items: center;
        }

        .notes-list-container {
          flex: 1;
          overflow-y: auto;
          margin-top: 15px;
        }

        .notes-group-header {
          position: sticky;
          top: 0;
          background-color: #f8f9fa;
          padding: 8px 12px;
          margin: 4px 0;
          font-weight: 600;
          font-size: 13px;
          color: #495057;
          border-radius: 4px;
          z-index: 10;
          cursor: pointer;
          user-select: none;
          transition: background-color 0.2s;
          display: flex;
          align-items: center;
          gap: 8px;
        }

        .notes-group-header:hover {
          background-color: #e9ecef;
        }

        .group-toggle-icon {
          font-size: 10px;
          transition: transform 0.2s;
          color: #6c757d;
        }

        .group-count {
          margin-left: auto;
          font-size: 11px;
          color: #6c757d;
          font-weight: 400;
        }

        .notes-group-content {
          max-height: 5000px;
          overflow: hidden;
          transition: max-height 0.3s ease-out, opacity 0.3s;
          opacity: 1;
        }

        .notes-group-content.collapsed {
          max-height: 0;
          opacity: 0;
        }

        .priority-badge {
          padding: 2px 8px;
          border-radius: 12px;
          font-size: 11px;
          font-weight: 500;
        }

        .priority-high {
          background-color: #dc3545;
          color: white;
        }

        .priority-medium {
          background-color: #ffc107;
          color: #212529;
        }

        .priority-low {
          background-color: #6c757d;
          color: white;
        }

        .category-badge {
          background-color: #0d6efd;
          color: white;
          padding: 2px 8px;
          border-radius: 12px;
          font-size: 11px;
        }

        .markdown-content {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
          line-height: 1.6;
          color: #24292e;
        }

        .markdown-content h1 {
          font-size: 2em;
          font-weight: 600;
          margin-top: 24px;
          margin-bottom: 16px;
          border-bottom: 1px solid #eaecef;
          padding-bottom: 0.3em;
        }

        .markdown-content h2 {
          font-size: 1.5em;
          font-weight: 600;
          margin-top: 24px;
          margin-bottom: 16px;
          border-bottom: 1px solid #eaecef;
          padding-bottom: 0.3em;
        }

        .markdown-content h3 {
          font-size: 1.25em;
          font-weight: 600;
          margin-top: 24px;
          margin-bottom: 16px;
        }

        .markdown-content h4 {
          font-size: 1em;
          font-weight: 600;
          margin-top: 16px;
          margin-bottom: 16px;
        }

        .markdown-content code {
          background-color: #f6f8fa;
          border-radius: 3px;
          font-size: 85%;
          margin: 0;
          padding: 0.2em 0.4em;
          font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
        }

        .markdown-content pre {
          background-color: #1e1e1e;
          border-radius: 6px;
          color: #d4d4d4;
          padding: 16px;
          overflow: auto;
          font-size: 14px;
          line-height: 1.45;
        }

        .markdown-content pre code {
          background-color: transparent;
          padding: 0;
          color: inherit;
        }

        .markdown-content ul,
        .markdown-content ol {
          margin-bottom: 16px;
          padding-left: 2em;
        }

        .markdown-content li {
          margin-bottom: 4px;
        }

        .markdown-content blockquote {
          border-left: 4px solid #dfe2e5;
          color: #6a737d;
          padding: 0 15px;
          margin: 16px 0;
        }

        .markdown-content table {
          border-collapse: collapse;
          width: 100%;
          margin-bottom: 16px;
        }

        .markdown-content table th,
        .markdown-content table td {
          border: 1px solid #dfe2e5;
          padding: 6px 13px;
        }

        .markdown-content table th {
          background-color: #f6f8fa;
          font-weight: 600;
        }

        .markdown-content a {
          color: #0366d6;
          text-decoration: none;
        }

        .markdown-content a:hover {
          text-decoration: underline;
        }

        @media (max-width: 992px) {
          .dev-notes-layout {
            flex-direction: column;
            height: auto;
          }

          .dev-notes-sidebar {
            flex: 0 0 auto;
            border-right: none;
            border-bottom: 1px solid #dee2e6;
            padding-bottom: 20px;
            margin-bottom: 20px;
          }
        }
    `;
    document.head.appendChild(styles);
  }

  /**
   * 메인 레이아웃 렌더링
   */
  function renderLayout() {
    return `
      <div class="dev-notes-layout">
          <!-- Content Area -->
          <div class="dev-notes-content">
            <div id="dev-note-content">
              <div class="text-center text-muted py-5">
                <i class="fas fa-arrow-right fa-3x mb-3"></i>
                <p>오른쪽에서 노트를 선택하세요</p>
              </div>
            </div>
          </div>

          <!-- Sidebar -->
          <div class="dev-notes-sidebar">
            ${renderViewToggle()}
            ${renderCategoryFilter()}
            ${renderNotesList()}
          </div>
        </div>
      </div>
    `;
  }

  /**
   * 뷰 토글 버튼 렌더링
   */
  function renderViewToggle() {
    return `
      <div class="btn-group w-100 mb-3" role="group">
        <button type="button"
                class="btn ${state.currentView === 'timeline' ? 'btn-primary' : 'btn-outline-primary'}"
                data-view="timeline">
          <i class="fas fa-clock"></i> 시간순
        </button>
        <button type="button"
                class="btn ${state.currentView === 'category' ? 'btn-primary' : 'btn-outline-primary'}"
                data-view="category">
          <i class="fas fa-folder"></i> 카테고리
        </button>
      </div>
    `;
  }

  /**
   * 카테고리 필터 렌더링 (카테고리 뷰에서만 표시)
   */
  function renderCategoryFilter() {
    if (state.currentView !== 'category') {
      return '';
    }

    return `
      <div class="mb-3">
        <label class="form-label small text-muted">카테고리 필터</label>
        <select class="form-select form-select-sm" id="category-filter">
          <option value="">전체 카테고리</option>
          ${state.categories
            .map(
              (cat) =>
                `<option value="${cat}" ${state.selectedCategory === cat ? 'selected' : ''}>${cat}</option>`
            )
            .join('')}
        </select>
      </div>
    `;
  }

  /**
   * 노트 목록 렌더링
   */
  function renderNotesList() {
    if (state.notes.length === 0) {
      return `
        <div class="text-center text-muted py-4">
          <i class="fas fa-inbox fa-2x mb-2"></i>
          <p>개발노트가 없습니다</p>
        </div>
      `;
    }

    const filteredNotes =
      state.currentView === 'category' && state.selectedCategory
        ? state.notes.filter((note) => note.category === state.selectedCategory)
        : state.notes;

    if (filteredNotes.length === 0) {
      return `
        <div class="text-center text-muted py-4">
          <i class="fas fa-filter fa-2x mb-2"></i>
          <p>해당 카테고리에 노트가 없습니다</p>
        </div>
      `;
    }

    let groupedNotes;
    if (state.currentView === 'timeline') {
      groupedNotes = groupByDate(filteredNotes);
    } else {
      groupedNotes = groupByCategory(filteredNotes);
    }

    const groupedEntries = Object.entries(groupedNotes);

    return `
      <div class="notes-list-container">
        ${groupedEntries
          .map(
            ([groupKey, notes]) => {
              const isExpanded = state.expandedGroups.has(groupKey);
              return `
                <div class="notes-group-wrapper">
                  <div class="notes-group-header collapsible" data-group="${groupKey}">
                    <i class="fas fa-chevron-${isExpanded ? 'down' : 'right'} group-toggle-icon"></i>
                    ${groupKey}
                    <span class="group-count">(${notes.length})</span>
                  </div>
                  <div class="notes-group-content ${isExpanded ? '' : 'collapsed'}" data-group="${groupKey}">
                    ${notes.map((note) => renderNoteItem(note)).join('')}
                  </div>
                </div>
              `;
            }
          )
          .join('')}
      </div>
    `;
  }

  /**
   * 단일 노트 아이템 렌더링
   */
  function renderNoteItem(note) {
    return `
      <div class="dev-note-item" data-path="${note.path}">
        <div class="dev-note-item-title">${escapeHtml(note.title)}</div>
        <div class="dev-note-item-meta">
          <span class="category-badge">${escapeHtml(note.category)}</span>
          <span class="priority-badge priority-${note.priority}">${note.priority}</span>
          <span><i class="fas fa-calendar-alt"></i> ${note.date || 'N/A'}</span>
        </div>
      </div>
    `;
  }

  /**
   * 노트 내용 렌더링
   */
  function renderNoteContent() {
    if (!state.currentNote) {
      return;
    }

    const note = state.currentNote;
    const contentArea = document.getElementById('dev-note-content');

    if (!contentArea) return;

    // Markdown을 HTML로 변환
    const htmlContent = marked.parse(note.content);

    contentArea.innerHTML = `
      <div class="card">
        <div class="card-body">
          <!-- Header -->
          <div class="d-flex justify-content-between align-items-start mb-4">
            <div>
              <h3 class="mb-2">${escapeHtml(note.title)}</h3>
              <div class="d-flex gap-2 align-items-center flex-wrap">
                <span class="category-badge">${escapeHtml(note.category)}</span>
                <span class="priority-badge priority-${note.priority}">${note.priority}</span>
                ${note.tags && note.tags.length > 0 ? note.tags.map((tag) => `<span class="badge bg-light text-dark">#${escapeHtml(tag)}</span>`).join('') : ''}
              </div>
            </div>
          </div>

          <!-- Metadata -->
          <div class="border-bottom pb-3 mb-4 text-muted small">
            <div class="row">
              <div class="col-md-6">
                <i class="fas fa-user"></i> ${escapeHtml(note.author || 'Unknown')}
              </div>
              <div class="col-md-6 text-md-end">
                <i class="fas fa-calendar-alt"></i> ${note.date || 'N/A'}
              </div>
            </div>
          </div>

          <!-- Content -->
          <div class="markdown-content">
            ${htmlContent}
          </div>
        </div>
      </div>
    `;
  }

  /**
   * 빈 상태 렌더링
   */
  function renderEmptyState() {
    const contentArea = document.getElementById('dev-note-content');
    if (!contentArea) return;

    contentArea.innerHTML = `
      <div class="text-center text-muted py-5">
        <i class="fas fa-sticky-note fa-4x mb-3" style="opacity: 0.3;"></i>
        <h4>개발노트가 없습니다</h4>
        <p class="mb-2">개발노트를 추가하려면 <code>/dev-notes/</code> 디렉토리에 마크다운 파일을 생성하세요.</p>
        <p class="small text-muted">파일 형식: <code>YYYY-MM-DD-title.md</code></p>
      </div>
    `;
  }

  /**
   * 에러 상태 렌더링
   */
  function renderError(message) {
    return `
      <div class="alert alert-danger">
        <h4 class="alert-heading"><i class="fas fa-exclamation-triangle"></i> 오류</h4>
        <p>${escapeHtml(message)}</p>
        <hr>
        <button class="btn btn-danger" onclick="location.reload()">
          <i class="fas fa-redo"></i> 다시 시도
        </button>
      </div>
    `;
  }

  // ==================== Event Handlers ====================

  /**
   * 이벤트 리스너 연결
   */
  function attachEventListeners() {
    // 뷰 토글 버튼
    document.querySelectorAll('[data-view]').forEach((btn) => {
      btn.addEventListener('click', (e) => {
        const view = e.currentTarget.dataset.view;
        if (state.currentView !== view) {
          state.currentView = view;
          state.selectedCategory = null;
          state.expandedGroups.clear(); // 뷰 전환 시 펼친 그룹 초기화
          updateSidebar();
        }
      });
    });

    // 카테고리 필터
    const categoryFilter = document.getElementById('category-filter');
    if (categoryFilter) {
      categoryFilter.addEventListener('change', (e) => {
        state.selectedCategory = e.target.value || null;
        updateSidebar();
      });
    }

    // 노트 아이템 클릭
    document.querySelectorAll('.dev-note-item').forEach((item) => {
      item.addEventListener('click', (e) => {
        const path = e.currentTarget.dataset.path;
        loadNote(path);
      });
    });

    // 그룹 헤더 클릭 (접기/펼치기)
    document.querySelectorAll('.notes-group-header').forEach((header) => {
      header.addEventListener('click', (e) => {
        const groupKey = e.currentTarget.dataset.group;
        toggleGroup(groupKey);
      });
    });
  }

  /**
   * 사이드바 업데이트 (뷰 변경 시)
   */
  function updateSidebar() {
    const sidebar = document.querySelector('.dev-notes-sidebar');
    if (!sidebar) return;

    sidebar.innerHTML =
      renderViewToggle() + renderCategoryFilter() + renderNotesList();

    attachEventListeners();
  }

  /**
   * 활성 노트 하이라이트
   */
  function highlightActiveNote(notePath) {
    document.querySelectorAll('.dev-note-item').forEach((item) => {
      item.classList.remove('active');
      if (item.dataset.path === notePath) {
        item.classList.add('active');
        item.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
      }
    });
  }

  /**
   * 그룹 접기/펼치기 토글 (아코디언 스타일)
   */
  function toggleGroup(groupKey) {
    // 아코디언 스타일: 클릭한 그룹이 이미 펼쳐져 있으면 접고, 아니면 다른 모든 그룹 닫고 이 그룹만 펼침
    if (state.expandedGroups.has(groupKey)) {
      // 이미 펼쳐져 있으면 접기
      state.expandedGroups.delete(groupKey);
    } else {
      // 다른 그룹 모두 닫고 클릭한 그룹만 펼치기
      state.expandedGroups.clear();
      state.expandedGroups.add(groupKey);
    }

    updateSidebar();
  }

  // ==================== Grouping Helpers ====================

  /**
   * 날짜별 그룹화 (Timeline 뷰)
   */
  function groupByDate(notes) {
    const groups = {};

    notes.forEach((note) => {
      const dateKey = note.date ? note.date : 'No Date';
      if (!groups[dateKey]) {
        groups[dateKey] = [];
      }
      groups[dateKey].push(note);
    });

    // Sort by date descending
    const sortedKeys = Object.keys(groups).sort((a, b) => {
      if (a === 'No Date') return 1;
      if (b === 'No Date') return -1;
      return b.localeCompare(a);
    });

    const sortedGroups = {};
    sortedKeys.forEach((key) => {
      sortedGroups[key] = groups[key];
    });

    return sortedGroups;
  }

  /**
   * 카테고리별 그룹화 (Category 뷰)
   */
  function groupByCategory(notes) {
    const groups = {};

    notes.forEach((note) => {
      const category = note.category || 'Uncategorized';
      if (!groups[category]) {
        groups[category] = [];
      }
      groups[category].push(note);
    });

    // Sort categories alphabetically
    const sortedKeys = Object.keys(groups).sort();

    const sortedGroups = {};
    sortedKeys.forEach((key) => {
      sortedGroups[key] = groups[key];
    });

    return sortedGroups;
  }

  // ==================== Utilities ====================

  /**
   * HTML 이스케이프
   */
  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  // Public API
  return {
    render,
  };
})();
