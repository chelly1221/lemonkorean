/**
 * Vocabulary Page
 *
 * 단어 관리 페이지
 */

const VocabularyPage = (() => {
  let currentPage = 1;
  let selectedIds = new Set();

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('단어 관리', [
            { label: '엑셀 업로드', icon: 'fa-file-excel', class: 'btn-success', onClick: showBulkUploadModal },
            { label: '새 단어', icon: 'fa-plus', class: 'btn-primary', onClick: showCreateModal }
          ])}
          <div class="content-container">
            <div class="filters-bar">
              <div class="row">
                <div class="col-md-6">
                  <input type="text" class="form-control" id="search-input" placeholder="한국어 또는 중국어로 검색">
                </div>
                <div class="col-md-3">
                  <select class="form-select" id="level-filter">
                    <option value="">전체 레벨</option>
                    ${Constants.LESSON_LEVELS.map(l => `<option value="${l}">레벨 ${l}</option>`).join('')}
                  </select>
                </div>
                <div class="col-md-3">
                  <button class="btn btn-primary w-100" id="search-btn">
                    <i class="fas fa-search me-2"></i>검색
                  </button>
                </div>
              </div>
            </div>
            <div id="bulk-actions-bar" class="alert alert-info mt-3" style="display: none;">
              <div class="d-flex justify-content-between align-items-center">
                <span><strong id="selected-count">0</strong>개 선택됨</span>
                <button class="btn btn-danger btn-sm" id="bulk-delete-btn">
                  <i class="fas fa-trash me-2"></i>선택 항목 삭제
                </button>
              </div>
            </div>
            <div class="table-card">
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th style="width: 50px;">
                        <input type="checkbox" id="select-all-checkbox" class="form-check-input">
                      </th>
                      <th>ID</th>
                      <th>한국어</th>
                      <th>중국어</th>
                      <th>품사</th>
                      <th>레벨</th>
                      <th>작업</th>
                    </tr>
                  </thead>
                  <tbody id="vocabulary-tbody">
                    <tr><td colspan="7" class="text-center"><div class="spinner-border"></div></td></tr>
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
    await loadVocabulary();
  }

  function attachEventListeners() {
    document.getElementById('search-btn').addEventListener('click', () => {
      currentPage = 1;
      loadVocabulary();
    });

    // Select all checkbox
    document.getElementById('select-all-checkbox').addEventListener('change', (e) => {
      const checkboxes = document.querySelectorAll('.vocab-checkbox');
      checkboxes.forEach(cb => {
        cb.checked = e.target.checked;
        if (e.target.checked) {
          selectedIds.add(parseInt(cb.dataset.id));
        } else {
          selectedIds.delete(parseInt(cb.dataset.id));
        }
      });
      updateBulkActionsBar();
    });

    // Bulk delete button
    document.getElementById('bulk-delete-btn').addEventListener('click', bulkDeleteSelected);
  }

  function updateBulkActionsBar() {
    const bulkActionsBar = document.getElementById('bulk-actions-bar');
    const selectedCount = document.getElementById('selected-count');

    if (selectedIds.size > 0) {
      bulkActionsBar.style.display = 'block';
      selectedCount.textContent = selectedIds.size;
    } else {
      bulkActionsBar.style.display = 'none';
    }
  }

  async function bulkDeleteSelected() {
    if (selectedIds.size === 0) {
      Toast.error('삭제할 단어를 선택해주세요.');
      return;
    }

    Modal.confirm(
      `선택한 ${selectedIds.size}개의 단어를 삭제하시겠습니까?`,
      async () => {
        try {
          const vocabIds = Array.from(selectedIds);
          await API.vocabulary.bulkDelete(vocabIds);
          Toast.success(`${selectedIds.size}개의 단어가 삭제되었습니다.`);
          selectedIds.clear();
          updateBulkActionsBar();
          await loadVocabulary();
        } catch (error) {
          Toast.error(error.message || '삭제에 실패했습니다.');
        }
      }
    );
  }

  function showCreateModal() {
    Modal.custom({
      title: '새 단어 추가',
      size: 'lg',
      body: `
        <form id="vocabulary-form">
          <div class="mb-3">
            <label class="form-label">한국어</label>
            <input type="text" class="form-control" name="korean" required>
          </div>
          <div class="mb-3">
            <label class="form-label">중국어</label>
            <input type="text" class="form-control" name="chinese" required>
          </div>
          <div class="mb-3">
            <label class="form-label">병음</label>
            <input type="text" class="form-control" name="pinyin">
          </div>
          <div class="mb-3">
            <label class="form-label">품사</label>
            <select class="form-select" name="part_of_speech" required>
              ${Object.entries(Constants.PARTS_OF_SPEECH_LABELS).map(([key, label]) =>
                `<option value="${key}">${label}</option>`
              ).join('')}
            </select>
          </div>
        </form>
      `,
      confirmText: '추가',
      onConfirm: async () => {
        const form = document.getElementById('vocabulary-form');
        const formData = new FormData(form);
        const data = Object.fromEntries(formData);

        try {
          await API.vocabulary.create(data);
          Toast.success('단어가 추가되었습니다.');
          await loadVocabulary();
        } catch (error) {
          Toast.error(error.message);
          return false;
        }
      },
    });
  }

  async function loadVocabulary() {
    const search = document.getElementById('search-input')?.value || '';
    const level = document.getElementById('level-filter')?.value || '';

    try {
      const response = await API.vocabulary.list({ page: currentPage, limit: 10, search, level });
      renderTable(response.data);
      renderPagination(response.pagination);
    } catch (error) {
      Toast.error('단어 목록을 불러올 수 없습니다.');
    }
  }

  function renderTable(vocabulary) {
    const tbody = document.getElementById('vocabulary-tbody');
    if (vocabulary.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" class="text-center">단어가 없습니다.</td></tr>';
      return;
    }
    tbody.innerHTML = vocabulary.map(word => `
      <tr>
        <td>
          <input type="checkbox"
                 class="form-check-input vocab-checkbox"
                 data-id="${word.id}"
                 ${selectedIds.has(word.id) ? 'checked' : ''}
                 onchange="VocabularyPage.toggleSelection(${word.id}, this.checked)">
        </td>
        <td>${word.id}</td>
        <td>${word.korean}</td>
        <td>${word.chinese}</td>
        <td>${Formatters.formatPartOfSpeech(word.part_of_speech)}</td>
        <td>${word.level || '-'}</td>
        <td>
          <button class="btn btn-sm btn-link text-secondary p-0 me-2" onclick="VocabularyPage.showEditModal(${word.id})" title="수정">
            <i class="fas fa-edit fa-lg"></i>
          </button>
          <button class="btn btn-sm btn-link text-danger p-0" onclick="VocabularyPage.deleteWord(${word.id})" title="삭제">
            <i class="fas fa-trash fa-lg"></i>
          </button>
        </td>
      </tr>
    `).join('');
  }

  function toggleSelection(id, checked) {
    if (checked) {
      selectedIds.add(id);
    } else {
      selectedIds.delete(id);
      document.getElementById('select-all-checkbox').checked = false;
    }
    updateBulkActionsBar();
  }

  function renderPagination(pagination) {
    document.getElementById('pagination-container').innerHTML = Pagination.render({
      ...pagination,
      onPageChange: (page) => {
        currentPage = page;
        loadVocabulary();
      },
    });
  }

  async function showEditModal(id) {
    try {
      // Fetch current vocabulary data
      const response = await API.vocabulary.getById(id);
      const word = response.data;

      Modal.custom({
        title: '단어 수정',
        size: 'lg',
        body: `
          <form id="vocabulary-edit-form">
            <div class="mb-3">
              <label class="form-label">한국어</label>
              <input type="text" class="form-control" name="korean" value="${Formatters.escapeHTML(word.korean)}" required>
            </div>
            <div class="mb-3">
              <label class="form-label">중국어</label>
              <input type="text" class="form-control" name="chinese" value="${Formatters.escapeHTML(word.chinese)}" required>
            </div>
            <div class="mb-3">
              <label class="form-label">한자</label>
              <input type="text" class="form-control" name="hanja" value="${Formatters.escapeHTML(word.hanja || '')}">
            </div>
            <div class="mb-3">
              <label class="form-label">병음</label>
              <input type="text" class="form-control" name="pinyin" value="${Formatters.escapeHTML(word.pinyin || '')}">
            </div>
            <div class="mb-3">
              <label class="form-label">품사</label>
              <select class="form-select" name="part_of_speech" required>
                ${Object.entries(Constants.PARTS_OF_SPEECH_LABELS).map(([key, label]) =>
                  `<option value="${key}" ${word.part_of_speech === key ? 'selected' : ''}>${label}</option>`
                ).join('')}
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">레벨</label>
              <select class="form-select" name="level">
                <option value="">선택 안 함</option>
                ${Constants.LESSON_LEVELS.map(l =>
                  `<option value="${l}" ${word.level == l ? 'selected' : ''}>레벨 ${l}</option>`
                ).join('')}
              </select>
            </div>
          </form>
        `,
        confirmText: '저장',
        onConfirm: async () => {
          const form = document.getElementById('vocabulary-edit-form');
          const formData = new FormData(form);
          const data = Object.fromEntries(formData);

          // Convert empty strings to null
          if (!data.hanja) data.hanja = null;
          if (!data.pinyin) data.pinyin = null;
          if (!data.level) data.level = null;

          try {
            await API.vocabulary.update(id, data);
            Toast.success('단어가 수정되었습니다.');
            await loadVocabulary();
          } catch (error) {
            Toast.error(error.message);
            return false;
          }
        },
      });
    } catch (error) {
      Toast.error('단어 정보를 불러올 수 없습니다.');
    }
  }

  function showBulkUploadModal() {
    Modal.custom({
      title: '엑셀 일괄 업로드',
      size: 'lg',
      body: `
        <div class="mb-3">
          <div class="alert alert-info">
            <div class="d-flex justify-content-between align-items-start">
              <div>
                <h6><i class="fas fa-info-circle me-2"></i>엑셀 파일 형식 안내</h6>
                <p class="mb-2">엑셀 파일의 첫 번째 행은 헤더여야 하며, 다음 열을 포함해야 합니다:</p>
                <ul class="mb-0">
                  <li><strong>korean</strong> 또는 <strong>한국어</strong> - 필수</li>
                  <li><strong>chinese</strong> 또는 <strong>中文</strong> - 필수</li>
                  <li><strong>hanja</strong> 또는 <strong>漢字</strong> - 선택</li>
                  <li><strong>pinyin</strong> 또는 <strong>拼音</strong> - 선택</li>
                  <li><strong>part_of_speech</strong> 또는 <strong>품사</strong> - 선택</li>
                  <li><strong>level</strong> 또는 <strong>레벨</strong> - 선택</li>
                </ul>
              </div>
              <button type="button" class="btn btn-sm btn-outline-primary" id="download-template-btn">
                <i class="fas fa-download me-1"></i>템플릿 다운로드
              </button>
            </div>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label">중복 처리 방법</label>
          <select class="form-select" id="upload-mode">
            <option value="skip">중복 단어 건너뛰기 (권장)</option>
            <option value="update">중복 단어 업데이트</option>
          </select>
          <small class="text-muted">
            * 한국어 단어가 같으면 중복으로 판단합니다.
          </small>
        </div>
        <div class="mb-3">
          <label class="form-label">엑셀 파일 선택 (.xlsx, .xls)</label>
          <input type="file" class="form-control" id="excel-file-input" accept=".xlsx,.xls" required>
        </div>
        <div id="upload-progress" class="mt-3" style="display: none;">
          <div class="progress">
            <div class="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style="width: 100%">
              업로드 중...
            </div>
          </div>
        </div>
      `,
      confirmText: '업로드',
      onConfirm: async () => {
        const fileInput = document.getElementById('excel-file-input');
        const uploadMode = document.getElementById('upload-mode').value;
        const file = fileInput.files[0];

        if (!file) {
          Toast.error('파일을 선택해주세요.');
          return false;
        }

        const progressDiv = document.getElementById('upload-progress');
        progressDiv.style.display = 'block';

        try {
          const formData = new FormData();
          formData.append('file', file);

          const response = await API.vocabulary.bulkUpload(formData, uploadMode);

          progressDiv.style.display = 'none';

          // Show results
          const { success, failed, skipped, updated, errors, skippedWords } = response.data;

          // Build result message
          let resultBody = '';
          if (success > 0) resultBody += `<p class="mb-2"><strong>추가됨:</strong> ${success}개</p>`;
          if (updated > 0) resultBody += `<p class="mb-2"><strong>업데이트됨:</strong> ${updated}개</p>`;
          if (skipped > 0) resultBody += `<p class="mb-2"><strong>중복 건너뜀:</strong> ${skipped}개</p>`;
          if (failed > 0) resultBody += `<p class="mb-2"><strong>실패:</strong> ${failed}개</p>`;

          if (failed > 0 || skipped > 0) {
            let errorList = '';

            if (errors && errors.length > 0) {
              errorList += '<div class="mt-3"><strong>오류 목록:</strong><ul class="mt-2">';
              errorList += errors.slice(0, 5).map(e =>
                `<li>행 ${e.row}: ${e.error}</li>`
              ).join('');
              if (errors.length > 5) errorList += `<li>... 그리고 ${errors.length - 5}개 더</li>`;
              errorList += '</ul></div>';
            }

            if (skippedWords && skippedWords.length > 0 && skipped <= 10) {
              errorList += '<div class="mt-3"><strong>건너뛴 단어:</strong><ul class="mt-2">';
              errorList += skippedWords.map(s =>
                `<li>행 ${s.row}: ${s.korean} (기존 ID: ${s.existingId})</li>`
              ).join('');
              errorList += '</ul></div>';
            }

            Modal.custom({
              title: '업로드 결과',
              body: resultBody + errorList,
              confirmText: '확인',
              showCancel: false,
            });
          } else {
            Toast.success(`${success}개의 단어가 업로드되었습니다.`);
          }

          await loadVocabulary();
        } catch (error) {
          progressDiv.style.display = 'none';
          Toast.error(error.message || '업로드에 실패했습니다.');
          return false;
        }
      },
    });

    // Add event listener for template download button after modal is shown
    setTimeout(() => {
      const downloadBtn = document.getElementById('download-template-btn');
      if (downloadBtn) {
        downloadBtn.addEventListener('click', async () => {
          try {
            await API.vocabulary.downloadTemplate();
            Toast.success('템플릿이 다운로드되었습니다.');
          } catch (error) {
            Toast.error('템플릿 다운로드에 실패했습니다.');
          }
        });
      }
    }, 100);
  }

  async function deleteWord(id) {
    Modal.confirm('이 단어를 삭제하시겠습니까?', async () => {
      try {
        await API.vocabulary.delete(id);
        Toast.success('단어가 삭제되었습니다.');
        await loadVocabulary();
      } catch (error) {
        Toast.error(error.message);
      }
    });
  }

  return { render, deleteWord, showEditModal, showBulkUploadModal, toggleSelection };
})();
