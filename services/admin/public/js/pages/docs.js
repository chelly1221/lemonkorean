/**
 * Docs Page
 *
 * Development documentation viewer
 * - Left sidebar: Document tree navigation
 * - Right panel: Markdown content viewer
 */

const DocsPage = (() => {
  // Current state
  let docTree = [];
  let currentDoc = null;
  let expandedCategories = new Set(['project']); // Default expanded

  // EasyMDE instance
  let editorInstance = null;

  /**
   * Render the docs page
   */
  async function render() {
    console.log('[DocsPage] Rendering docs page');
    // Initial page structure
    Router.render(`
      ${Sidebar.render()}
      <main class="main-content">
        ${Header.render('개발 문서')}
        <div class="content-wrapper">
          <div class="docs-container">
            <div class="docs-content" id="docs-viewer">
              <div class="docs-placeholder">
                <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                <p class="text-muted">우측 목록에서 문서를 선택하세요</p>
              </div>
            </div>
            <div class="docs-sidebar" id="docs-tree">
              <div class="text-center py-4">
                <div class="spinner-border text-primary" role="status">
                  <span class="visually-hidden">로딩 중...</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
    `);

    // Add custom styles
    addStyles();

    // Load document tree
    await loadDocTree();
  }

  /**
   * Add custom styles for docs page
   */
  function addStyles() {
    // Check if styles already exist
    if (document.getElementById('docs-styles')) return;

    const styles = document.createElement('style');
    styles.id = 'docs-styles';
    styles.textContent = `
      .docs-container {
        display: flex;
        gap: 0;
        height: calc(100vh - 140px);
        background: #fff;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
      }

      .docs-sidebar {
        width: 280px;
        min-width: 280px;
        background: #f8f9fa;
        border-left: 1px solid #e9ecef;
        overflow-y: auto;
        padding: 16px 0;
      }

      .docs-content {
        flex: 1;
        overflow-y: auto;
        padding: 24px 32px;
      }

      .docs-placeholder {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        height: 100%;
        color: #6c757d;
      }

      /* Tree styles */
      .docs-category {
        margin-bottom: 4px;
      }

      .docs-category-header {
        display: flex;
        align-items: center;
        padding: 8px 16px;
        cursor: pointer;
        color: #495057;
        font-weight: 500;
        font-size: 14px;
        transition: background 0.15s;
      }

      .docs-category-header:hover {
        background: #e9ecef;
      }

      .docs-category-header i {
        width: 20px;
        margin-right: 8px;
        text-align: center;
      }

      .docs-category-header .expand-icon {
        margin-left: auto;
        transition: transform 0.2s;
      }

      .docs-category-header.expanded .expand-icon {
        transform: rotate(90deg);
      }

      .docs-category-items {
        display: none;
        padding-left: 20px;
      }

      .docs-category-items.show {
        display: block;
      }

      .docs-item {
        display: block;
        padding: 6px 16px 6px 28px;
        color: #6c757d;
        text-decoration: none;
        font-size: 13px;
        cursor: pointer;
        transition: all 0.15s;
        border-left: 2px solid transparent;
      }

      .docs-item:hover {
        background: #e9ecef;
        color: #495057;
      }

      .docs-item.active {
        background: #e7f1ff;
        color: #0d6efd;
        border-left-color: #0d6efd;
      }

      .docs-subcategory {
        margin: 4px 0;
      }

      .docs-subcategory-header {
        display: flex;
        align-items: center;
        padding: 6px 16px 6px 28px;
        color: #6c757d;
        font-size: 13px;
        font-weight: 500;
        cursor: pointer;
      }

      .docs-subcategory-header:hover {
        color: #495057;
      }

      .docs-subcategory-header .expand-icon {
        margin-left: auto;
        font-size: 10px;
        transition: transform 0.2s;
      }

      .docs-subcategory-header.expanded .expand-icon {
        transform: rotate(90deg);
      }

      .docs-subcategory-items {
        display: none;
        padding-left: 12px;
      }

      .docs-subcategory-items.show {
        display: block;
      }

      /* Markdown content styles */
      .docs-content h1 {
        font-size: 2rem;
        font-weight: 600;
        margin-bottom: 1rem;
        padding-bottom: 0.5rem;
        border-bottom: 2px solid #e9ecef;
      }

      .docs-content h2 {
        font-size: 1.5rem;
        font-weight: 600;
        margin-top: 2rem;
        margin-bottom: 1rem;
        color: #212529;
      }

      .docs-content h3 {
        font-size: 1.25rem;
        font-weight: 600;
        margin-top: 1.5rem;
        margin-bottom: 0.75rem;
        color: #343a40;
      }

      .docs-content h4, .docs-content h5, .docs-content h6 {
        font-weight: 600;
        margin-top: 1rem;
        margin-bottom: 0.5rem;
      }

      .docs-content p {
        margin-bottom: 1rem;
        line-height: 1.7;
      }

      .docs-content pre {
        background: #1e1e1e;
        color: #d4d4d4;
        padding: 16px;
        border-radius: 6px;
        overflow-x: auto;
        margin: 1rem 0;
        font-size: 13px;
      }

      .docs-content code {
        background: #f1f3f4;
        padding: 2px 6px;
        border-radius: 4px;
        font-size: 0.9em;
        color: #d63384;
      }

      .docs-content pre code {
        background: transparent;
        padding: 0;
        color: inherit;
      }

      .docs-content ul, .docs-content ol {
        margin-bottom: 1rem;
        padding-left: 2rem;
      }

      .docs-content li {
        margin-bottom: 0.5rem;
        line-height: 1.6;
      }

      .docs-content table {
        width: 100%;
        margin: 1rem 0;
        border-collapse: collapse;
      }

      .docs-content th, .docs-content td {
        padding: 12px;
        border: 1px solid #dee2e6;
        text-align: left;
      }

      .docs-content th {
        background: #f8f9fa;
        font-weight: 600;
      }

      .docs-content blockquote {
        border-left: 4px solid #0d6efd;
        padding-left: 1rem;
        margin: 1rem 0;
        color: #6c757d;
      }

      .docs-content a {
        color: #0d6efd;
        text-decoration: none;
      }

      .docs-content a:hover {
        text-decoration: underline;
      }

      .docs-content hr {
        margin: 2rem 0;
        border: none;
        border-top: 1px solid #dee2e6;
      }

      .docs-content img {
        max-width: 100%;
        border-radius: 4px;
      }

      /* Heading anchor highlight animation */
      .docs-content h1,
      .docs-content h2,
      .docs-content h3,
      .docs-content h4,
      .docs-content h5,
      .docs-content h6 {
        transition: background-color 0.3s ease;
        padding: 2px 4px;
        margin-left: -4px;
        border-radius: 4px;
      }

      /* Internal link style */
      .docs-internal-link {
        color: #0d6efd;
        text-decoration: none;
        border-bottom: 1px dotted #0d6efd;
      }

      .docs-internal-link:hover {
        border-bottom-style: solid;
      }

      /* Document header */
      .docs-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 1.5rem;
        padding-bottom: 1rem;
      }

      .docs-header-info {
        color: #6c757d;
        font-size: 13px;
        display: flex;
        align-items: center;
        gap: 0.5rem;
      }

      .docs-header-info i {
        margin-right: 4px;
      }

      .docs-header-info .btn-link {
        font-size: 16px;
        text-decoration: none;
      }

      .docs-header-info .btn-link:hover {
        opacity: 0.8;
      }

      /* Loading state */
      .docs-loading {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 200px;
      }
    `;
    document.head.appendChild(styles);
  }

  /**
   * Load document tree from API
   */
  async function loadDocTree() {
    console.log('[DocsPage] Loading doc tree...');
    try {
      const response = await API.docs.list();
      console.log('[DocsPage] API response:', response);

      if (response.success) {
        docTree = response.data;
        renderDocTree();
      }
    } catch (error) {
      console.error('[DOCS] Failed to load doc tree:', error);
      document.getElementById('docs-tree').innerHTML = `
        <div class="text-center py-4 text-danger">
          <i class="fas fa-exclamation-triangle mb-2"></i>
          <p>문서 목록을 불러오지 못했습니다</p>
        </div>
      `;
    }
  }

  /**
   * Render document tree
   */
  function renderDocTree() {
    const container = document.getElementById('docs-tree');

    const html = docTree.map(category => {
      const isExpanded = expandedCategories.has(category.id);

      let itemsHtml = '';

      // Render direct items
      if (category.items && category.items.length > 0) {
        itemsHtml += category.items.map(item => `
          <div class="docs-item" data-path="${item.path}">
            <i class="fas fa-file-alt me-2"></i>${item.label}
          </div>
        `).join('');
      }

      // Render subcategories
      if (category.subCategories && category.subCategories.length > 0) {
        itemsHtml += category.subCategories.map(sub => {
          const subExpanded = expandedCategories.has(`${category.id}-${sub.id}`);

          return `
            <div class="docs-subcategory">
              <div class="docs-subcategory-header ${subExpanded ? 'expanded' : ''}"
                   data-subcategory="${category.id}-${sub.id}">
                <i class="fas fa-folder me-2"></i>${sub.name}
                <i class="fas fa-chevron-right expand-icon"></i>
              </div>
              <div class="docs-subcategory-items ${subExpanded ? 'show' : ''}">
                ${sub.items.map(item => `
                  <div class="docs-item" data-path="${item.path}">
                    <i class="fas fa-file-alt me-2"></i>${item.label}
                  </div>
                `).join('')}
              </div>
            </div>
          `;
        }).join('');
      }

      return `
        <div class="docs-category">
          <div class="docs-category-header ${isExpanded ? 'expanded' : ''}"
               data-category="${category.id}">
            <i class="fas ${category.icon}"></i>
            ${category.name}
            <i class="fas fa-chevron-right expand-icon"></i>
          </div>
          <div class="docs-category-items ${isExpanded ? 'show' : ''}">
            ${itemsHtml}
          </div>
        </div>
      `;
    }).join('');

    container.innerHTML = html;

    // Add event listeners
    attachTreeEventListeners();
  }

  /**
   * Attach event listeners to tree elements
   */
  function attachTreeEventListeners() {
    // Category headers
    document.querySelectorAll('.docs-category-header').forEach(header => {
      header.addEventListener('click', () => {
        const categoryId = header.dataset.category;
        toggleCategory(categoryId);
      });
    });

    // Subcategory headers
    document.querySelectorAll('.docs-subcategory-header').forEach(header => {
      header.addEventListener('click', () => {
        const subcategoryId = header.dataset.subcategory;
        toggleSubcategory(subcategoryId);
      });
    });

    // Document items
    document.querySelectorAll('.docs-item').forEach(item => {
      item.addEventListener('click', () => {
        const docPath = item.dataset.path;
        loadDocument(docPath);

        // Update active state
        document.querySelectorAll('.docs-item').forEach(i => i.classList.remove('active'));
        item.classList.add('active');
      });
    });
  }

  /**
   * Toggle category expansion
   */
  function toggleCategory(categoryId) {
    const header = document.querySelector(`.docs-category-header[data-category="${categoryId}"]`);
    const items = header.nextElementSibling;

    if (expandedCategories.has(categoryId)) {
      expandedCategories.delete(categoryId);
      header.classList.remove('expanded');
      items.classList.remove('show');
    } else {
      expandedCategories.add(categoryId);
      header.classList.add('expanded');
      items.classList.add('show');
    }
  }

  /**
   * Toggle subcategory expansion
   */
  function toggleSubcategory(subcategoryId) {
    const header = document.querySelector(`.docs-subcategory-header[data-subcategory="${subcategoryId}"]`);
    const items = header.nextElementSibling;

    if (expandedCategories.has(subcategoryId)) {
      expandedCategories.delete(subcategoryId);
      header.classList.remove('expanded');
      items.classList.remove('show');
    } else {
      expandedCategories.add(subcategoryId);
      header.classList.add('expanded');
      items.classList.add('show');
    }
  }

  /**
   * Load and display a document
   */
  async function loadDocument(docPath) {
    const viewer = document.getElementById('docs-viewer');

    // Show loading
    viewer.innerHTML = `
      <div class="docs-loading">
        <div class="spinner-border text-primary" role="status">
          <span class="visually-hidden">로딩 중...</span>
        </div>
      </div>
    `;

    try {
      const response = await API.docs.content(docPath);

      if (response.success) {
        currentDoc = response.data;
        renderDocument();
      }
    } catch (error) {
      console.error('[DOCS] Failed to load document:', error);
      viewer.innerHTML = `
        <div class="alert alert-danger">
          <i class="fas fa-exclamation-triangle me-2"></i>
          문서를 불러오지 못했습니다: ${error.message}
        </div>
      `;
    }
  }

  /**
   * Render document content
   */
  function renderDocument() {
    const viewer = document.getElementById('docs-viewer');

    if (!currentDoc) {
      viewer.innerHTML = `
        <div class="docs-placeholder">
          <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
          <p class="text-muted">좌측 목록에서 문서를 선택하세요</p>
        </div>
      `;
      return;
    }

    // Format file size
    const formatSize = (bytes) => {
      if (bytes < 1024) return bytes + ' B';
      if (bytes < 1024 * 1024) return (bytes / 1024).toFixed(1) + ' KB';
      return (bytes / (1024 * 1024)).toFixed(1) + ' MB';
    };

    // Format date
    const formatDate = (dateStr) => {
      const date = new Date(dateStr);
      return date.toLocaleString('ko-KR');
    };

    // Parse markdown to HTML
    let htmlContent = '';
    if (typeof marked !== 'undefined') {
      // Generate slug from text (for heading IDs)
      const slugify = (text) => {
        return text
          .toLowerCase()
          .replace(/<[^>]*>/g, '') // Remove HTML tags
          .replace(/[^\w\s\uAC00-\uD7AF\u4E00-\u9FFF-]/g, '') // Keep Korean, Chinese, alphanumeric
          .replace(/\s+/g, '-')
          .replace(/-+/g, '-')
          .trim();
      };

      // Custom renderer to handle heading IDs and links
      const renderer = {
        heading(text, depth) {
          const slug = slugify(text);
          return `<h${depth} id="${slug}">${text}</h${depth}>\n`;
        },
        link(href, title, text) {
          // Check if it's an internal anchor link
          if (href && href.startsWith('#')) {
            const titleAttr = title ? ` title="${title}"` : '';
            return `<a href="${href}" class="docs-internal-link"${titleAttr}>${text}</a>`;
          }
          // External links open in new tab
          const titleAttr = title ? ` title="${title}"` : '';
          return `<a href="${href}" target="_blank" rel="noopener noreferrer"${titleAttr}>${text}</a>`;
        }
      };

      // Configure marked with custom renderer and options
      marked.use({
        renderer,
        breaks: true,
        gfm: true
      });

      htmlContent = marked.parse(currentDoc.content);
    } else {
      // Fallback: show raw content with basic formatting
      htmlContent = `<pre>${escapeHtml(currentDoc.content)}</pre>`;
    }

    viewer.innerHTML = `
      <div class="docs-header">
        <div>
          <span class="text-muted small">${currentDoc.path}</span>
        </div>
        <div class="docs-header-info">
          <span class="me-3"><i class="fas fa-file"></i> ${formatSize(currentDoc.size)}</span>
          <span class="me-3"><i class="fas fa-clock"></i> ${formatDate(currentDoc.modifiedAt)}</span>
          <button class="btn btn-sm btn-link text-primary p-0" onclick="DocsPage.openEditModal()" title="편집">
            <i class="fas fa-edit"></i>
          </button>
        </div>
      </div>
      <div class="markdown-body" id="markdown-content">
        ${htmlContent}
      </div>
    `;

    // Handle internal anchor links
    attachDocLinkHandlers();
  }

  /**
   * Attach click handlers for internal document links
   */
  function attachDocLinkHandlers() {
    const markdownBody = document.getElementById('markdown-content');
    if (!markdownBody) return;

    markdownBody.querySelectorAll('a.docs-internal-link').forEach(link => {
      link.addEventListener('click', (e) => {
        e.preventDefault();
        const href = link.getAttribute('href');
        if (href && href.startsWith('#')) {
          const targetId = href.substring(1);
          const targetElement = document.getElementById(targetId);
          if (targetElement) {
            targetElement.scrollIntoView({ behavior: 'smooth', block: 'start' });
            // Highlight briefly
            targetElement.style.backgroundColor = '#fff3cd';
            setTimeout(() => {
              targetElement.style.backgroundColor = '';
            }, 2000);
          }
        }
      });
    });
  }

  /**
   * Escape HTML special characters
   */
  function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  }

  /**
   * Open edit modal for current document
   */
  async function openEditModal() {
    if (!currentDoc) return;

    Modal.create({
      title: `문서 편집: ${currentDoc.path}`,
      size: 'xl',
      body: renderEditorModal(),
      confirmText: '저장',
      confirmClass: 'btn-primary',
      onConfirm: async () => await saveDocChanges(),
      onClose: () => cleanupEditor()
    });

    // Initialize EasyMDE after modal is rendered
    setTimeout(() => initializeEditor(), 100);
  }

  /**
   * Render editor modal HTML
   */
  function renderEditorModal() {
    const content = currentDoc.content || '';
    return `
      <div class="editor-container">
        <textarea id="doc-editor" style="display:none;">${escapeHtml(content)}</textarea>
        <small class="text-muted d-block mt-2">
          <i class="fas fa-info-circle me-1"></i>
          파일 경로: ${currentDoc.path}
        </small>
      </div>
    `;
  }

  /**
   * Initialize EasyMDE editor
   */
  function initializeEditor() {
    const textarea = document.getElementById('doc-editor');
    if (!textarea) return;

    editorInstance = new EasyMDE({
      element: textarea,
      autofocus: true,
      spellChecker: false,
      renderingConfig: {
        singleLineBreaks: false,
        codeSyntaxHighlighting: true
      },
      toolbar: [
        'bold', 'italic', 'heading', '|',
        'code', 'quote', 'unordered-list', 'ordered-list', '|',
        'link', 'image', 'table', '|',
        'preview', 'side-by-side', 'fullscreen', '|',
        'guide'
      ]
    });
  }

  /**
   * Save document changes
   */
  async function saveDocChanges() {
    if (!editorInstance) return false;

    const content = editorInstance.value();

    try {
      await API.docs.update(currentDoc.path, content);
      Toast.success('문서가 저장되었습니다.');

      // Reload document
      await loadDocument(currentDoc.path);
      return true; // Close modal
    } catch (error) {
      console.error('Error saving document:', error);
      Toast.error('저장 실패: ' + (error.message || '알 수 없는 오류'));
      return false; // Keep modal open
    }
  }

  /**
   * Cleanup editor instance
   */
  function cleanupEditor() {
    if (editorInstance) {
      editorInstance.toTextArea();
      editorInstance = null;
    }
  }

  // Public API
  return {
    render,
    loadDocument,
    openEditModal
  };
})();
