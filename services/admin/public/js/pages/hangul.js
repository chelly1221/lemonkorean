/**
 * Hangul Page
 *
 * 한글 자모 관리 페이지
 */

const HangulPage = (() => {
  let currentPage = 1;
  let currentType = '';

  const CHARACTER_TYPES = {
    basic_consonant: '기본 자음',
    double_consonant: '쌍자음',
    basic_vowel: '기본 모음',
    compound_vowel: '복합 모음'
  };

  const STATUS_LABELS = {
    published: '게시됨',
    draft: '초안',
    archived: '보관됨'
  };

  async function render() {
    const layout = `
      <div class="app-layout">
        ${Sidebar.render()}
        <div class="main-content">
          ${Header.render('한글 자모 관리', [
            { label: '새 자모', icon: 'fa-plus', class: 'btn-primary', onClick: showCreateModal }
          ])}
          <div class="content-container">
            <!-- Stats Cards -->
            <div class="row mb-4" id="stats-container">
              <div class="col-md-3">
                <div class="card bg-primary text-white">
                  <div class="card-body text-center">
                    <h3 id="stat-total">-</h3>
                    <small>전체 자모</small>
                  </div>
                </div>
              </div>
              <div class="col-md-2">
                <div class="card">
                  <div class="card-body text-center">
                    <h4 id="stat-consonants">-</h4>
                    <small>자음</small>
                  </div>
                </div>
              </div>
              <div class="col-md-2">
                <div class="card">
                  <div class="card-body text-center">
                    <h4 id="stat-vowels">-</h4>
                    <small>모음</small>
                  </div>
                </div>
              </div>
              <div class="col-md-2">
                <div class="card bg-success text-white">
                  <div class="card-body text-center">
                    <h4 id="stat-published">-</h4>
                    <small>게시됨</small>
                  </div>
                </div>
              </div>
              <div class="col-md-3">
                <div class="card bg-warning">
                  <div class="card-body text-center">
                    <h4 id="stat-draft">-</h4>
                    <small>초안</small>
                  </div>
                </div>
              </div>
            </div>

            <!-- Filters -->
            <div class="filters-bar">
              <div class="row">
                <div class="col-md-4">
                  <select class="form-select" id="type-filter">
                    <option value="">전체 유형</option>
                    ${Object.entries(CHARACTER_TYPES).map(([key, label]) =>
                      `<option value="${key}">${label}</option>`
                    ).join('')}
                  </select>
                </div>
                <div class="col-md-4">
                  <select class="form-select" id="status-filter">
                    <option value="">전체 상태</option>
                    ${Object.entries(STATUS_LABELS).map(([key, label]) =>
                      `<option value="${key}">${label}</option>`
                    ).join('')}
                  </select>
                </div>
                <div class="col-md-4">
                  <button class="btn btn-primary w-100" id="filter-btn">
                    <i class="fas fa-filter me-2"></i>필터 적용
                  </button>
                </div>
              </div>
            </div>

            <!-- Alphabet Preview -->
            <div class="card mb-4">
              <div class="card-header">
                <h5 class="mb-0">한글 자모표 미리보기</h5>
              </div>
              <div class="card-body" id="alphabet-preview">
                <div class="text-center"><div class="spinner-border"></div></div>
              </div>
            </div>

            <!-- Character List -->
            <div class="table-card">
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th style="width: 60px;">자모</th>
                      <th>로마자</th>
                      <th>유형</th>
                      <th>발음 설명</th>
                      <th>순서</th>
                      <th>상태</th>
                      <th style="width: 100px;">작업</th>
                    </tr>
                  </thead>
                  <tbody id="hangul-tbody">
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
    await Promise.all([loadStats(), loadCharacters(), loadAlphabetPreview()]);
  }

  function attachEventListeners() {
    document.getElementById('filter-btn').addEventListener('click', () => {
      currentPage = 1;
      loadCharacters();
    });

    document.getElementById('type-filter').addEventListener('change', () => {
      currentPage = 1;
      loadCharacters();
    });

    document.getElementById('status-filter').addEventListener('change', () => {
      currentPage = 1;
      loadCharacters();
    });
  }

  async function loadStats() {
    try {
      const response = await API.hangul.getStats();
      const stats = response.data;

      document.getElementById('stat-total').textContent = stats.total_characters;
      document.getElementById('stat-consonants').textContent =
        parseInt(stats.basic_consonants) + parseInt(stats.double_consonants);
      document.getElementById('stat-vowels').textContent =
        parseInt(stats.basic_vowels) + parseInt(stats.compound_vowels);
      document.getElementById('stat-published').textContent = stats.published;
      document.getElementById('stat-draft').textContent = stats.draft;
    } catch (error) {
      console.error('Failed to load stats:', error);
    }
  }

  async function loadAlphabetPreview() {
    try {
      const response = await API.hangul.list({ limit: 100, status: 'published' });
      const characters = response.data;

      // Group by type
      const grouped = {
        basic_consonant: [],
        double_consonant: [],
        basic_vowel: [],
        compound_vowel: []
      };

      characters.forEach(char => {
        if (grouped[char.character_type]) {
          grouped[char.character_type].push(char);
        }
      });

      // Sort by display_order
      Object.keys(grouped).forEach(type => {
        grouped[type].sort((a, b) => a.display_order - b.display_order);
      });

      const previewHTML = `
        <div class="row">
          <div class="col-md-6 mb-3">
            <h6>기본 자음 (${grouped.basic_consonant.length})</h6>
            <div class="hangul-grid">
              ${grouped.basic_consonant.map(c =>
                `<span class="hangul-char" title="${c.romanization}">${c.character}</span>`
              ).join('')}
            </div>
          </div>
          <div class="col-md-6 mb-3">
            <h6>쌍자음 (${grouped.double_consonant.length})</h6>
            <div class="hangul-grid">
              ${grouped.double_consonant.map(c =>
                `<span class="hangul-char" title="${c.romanization}">${c.character}</span>`
              ).join('')}
            </div>
          </div>
          <div class="col-md-6 mb-3">
            <h6>기본 모음 (${grouped.basic_vowel.length})</h6>
            <div class="hangul-grid">
              ${grouped.basic_vowel.map(c =>
                `<span class="hangul-char" title="${c.romanization}">${c.character}</span>`
              ).join('')}
            </div>
          </div>
          <div class="col-md-6 mb-3">
            <h6>복합 모음 (${grouped.compound_vowel.length})</h6>
            <div class="hangul-grid">
              ${grouped.compound_vowel.map(c =>
                `<span class="hangul-char" title="${c.romanization}">${c.character}</span>`
              ).join('')}
            </div>
          </div>
        </div>
        <style>
          .hangul-grid { display: flex; flex-wrap: wrap; gap: 8px; }
          .hangul-char {
            width: 40px; height: 40px;
            display: flex; align-items: center; justify-content: center;
            font-size: 24px; font-weight: bold;
            background: #f8f9fa; border-radius: 4px;
            cursor: pointer; transition: all 0.2s;
          }
          .hangul-char:hover { background: #e9ecef; transform: scale(1.1); }
        </style>
      `;

      document.getElementById('alphabet-preview').innerHTML = previewHTML;
    } catch (error) {
      console.error('Failed to load alphabet preview:', error);
      document.getElementById('alphabet-preview').innerHTML =
        '<p class="text-danger">자모표를 불러올 수 없습니다.</p>';
    }
  }

  async function loadCharacters() {
    const type = document.getElementById('type-filter')?.value || '';
    const status = document.getElementById('status-filter')?.value || '';

    try {
      const response = await API.hangul.list({
        page: currentPage,
        limit: 20,
        type,
        status
      });
      renderTable(response.data);
      renderPagination(response.pagination);
    } catch (error) {
      Toast.error('자모 목록을 불러올 수 없습니다.');
    }
  }

  function renderTable(characters) {
    const tbody = document.getElementById('hangul-tbody');
    if (characters.length === 0) {
      tbody.innerHTML = '<tr><td colspan="7" class="text-center">자모가 없습니다.</td></tr>';
      return;
    }

    tbody.innerHTML = characters.map(char => `
      <tr>
        <td style="font-size: 24px; font-weight: bold;">${char.character}</td>
        <td>${char.romanization}</td>
        <td><span class="badge bg-secondary">${CHARACTER_TYPES[char.character_type] || char.character_type}</span></td>
        <td>${Formatters.truncate(char.pronunciation_zh, 30)}</td>
        <td>${char.display_order}</td>
        <td>
          <span class="badge ${char.status === 'published' ? 'bg-success' : 'bg-warning'}">
            ${STATUS_LABELS[char.status] || char.status}
          </span>
        </td>
        <td>
          <button class="btn btn-sm btn-link text-secondary p-0 me-2" onclick="HangulPage.showEditModal(${char.id})" title="수정">
            <i class="fas fa-edit fa-lg"></i>
          </button>
          <button class="btn btn-sm btn-link text-danger p-0" onclick="HangulPage.deleteCharacter(${char.id})" title="삭제">
            <i class="fas fa-trash fa-lg"></i>
          </button>
        </td>
      </tr>
    `).join('');
  }

  function renderPagination(pagination) {
    document.getElementById('pagination-container').innerHTML = Pagination.render({
      ...pagination,
      onPageChange: (page) => {
        currentPage = page;
        loadCharacters();
      },
    });
  }

  function showCreateModal() {
    Modal.custom({
      title: '새 자모 추가',
      size: 'lg',
      body: getCharacterFormHTML(),
      confirmText: '추가',
      onConfirm: async () => {
        const form = document.getElementById('hangul-form');
        const formData = new FormData(form);
        const data = Object.fromEntries(formData);

        // Parse example_words as JSON
        try {
          data.example_words = data.example_words ? JSON.parse(data.example_words) : [];
        } catch (e) {
          Toast.error('예시 단어 JSON 형식이 올바르지 않습니다.');
          return false;
        }

        try {
          await API.hangul.create(data);
          Toast.success('자모가 추가되었습니다.');
          await Promise.all([loadStats(), loadCharacters(), loadAlphabetPreview()]);
        } catch (error) {
          Toast.error(error.message);
          return false;
        }
      },
    });
  }

  async function showEditModal(id) {
    try {
      const response = await API.hangul.getById(id);
      const char = response.data;

      Modal.custom({
        title: `자모 수정: ${char.character}`,
        size: 'lg',
        body: getCharacterFormHTML(char),
        confirmText: '저장',
        onConfirm: async () => {
          const form = document.getElementById('hangul-form');
          const formData = new FormData(form);
          const data = Object.fromEntries(formData);

          // Parse example_words as JSON
          try {
            data.example_words = data.example_words ? JSON.parse(data.example_words) : [];
          } catch (e) {
            Toast.error('예시 단어 JSON 형식이 올바르지 않습니다.');
            return false;
          }

          // Convert empty strings to null
          Object.keys(data).forEach(key => {
            if (data[key] === '') data[key] = null;
          });

          try {
            await API.hangul.update(id, data);
            Toast.success('자모가 수정되었습니다.');
            await Promise.all([loadStats(), loadCharacters(), loadAlphabetPreview()]);
          } catch (error) {
            Toast.error(error.message);
            return false;
          }
        },
      });
    } catch (error) {
      Toast.error('자모 정보를 불러올 수 없습니다.');
    }
  }

  function getCharacterFormHTML(char = null) {
    const exampleWordsStr = char && char.example_words
      ? (typeof char.example_words === 'string' ? char.example_words : JSON.stringify(char.example_words, null, 2))
      : '[]';

    return `
      <form id="hangul-form">
        <div class="row">
          <div class="col-md-4 mb-3">
            <label class="form-label">자모 *</label>
            <input type="text" class="form-control" name="character"
                   value="${Formatters.escapeHTML(char?.character || '')}"
                   required style="font-size: 24px; text-align: center;">
          </div>
          <div class="col-md-4 mb-3">
            <label class="form-label">유형 *</label>
            <select class="form-select" name="character_type" required>
              ${Object.entries(CHARACTER_TYPES).map(([key, label]) =>
                `<option value="${key}" ${char?.character_type === key ? 'selected' : ''}>${label}</option>`
              ).join('')}
            </select>
          </div>
          <div class="col-md-4 mb-3">
            <label class="form-label">표시 순서 *</label>
            <input type="number" class="form-control" name="display_order"
                   value="${char?.display_order || 1}" required min="1">
          </div>
        </div>
        <div class="row">
          <div class="col-md-6 mb-3">
            <label class="form-label">로마자 표기 *</label>
            <input type="text" class="form-control" name="romanization"
                   value="${Formatters.escapeHTML(char?.romanization || '')}" required>
          </div>
          <div class="col-md-3 mb-3">
            <label class="form-label">획수</label>
            <input type="number" class="form-control" name="stroke_count"
                   value="${char?.stroke_count || 1}" min="1">
          </div>
          <div class="col-md-3 mb-3">
            <label class="form-label">상태</label>
            <select class="form-select" name="status">
              ${Object.entries(STATUS_LABELS).map(([key, label]) =>
                `<option value="${key}" ${char?.status === key ? 'selected' : ''}>${label}</option>`
              ).join('')}
            </select>
          </div>
        </div>
        <div class="mb-3">
          <label class="form-label">발음 설명 (중국어) *</label>
          <input type="text" class="form-control" name="pronunciation_zh"
                 value="${Formatters.escapeHTML(char?.pronunciation_zh || '')}" required>
        </div>
        <div class="mb-3">
          <label class="form-label">발음 팁 (중국어)</label>
          <textarea class="form-control" name="pronunciation_tip_zh" rows="2">${Formatters.escapeHTML(char?.pronunciation_tip_zh || '')}</textarea>
        </div>
        <div class="mb-3">
          <label class="form-label">기억법 (중국어)</label>
          <textarea class="form-control" name="mnemonics_zh" rows="2">${Formatters.escapeHTML(char?.mnemonics_zh || '')}</textarea>
        </div>
        <div class="mb-3">
          <label class="form-label">예시 단어 (JSON)</label>
          <textarea class="form-control" name="example_words" rows="4" style="font-family: monospace;">${Formatters.escapeHTML(exampleWordsStr)}</textarea>
          <small class="text-muted">형식: [{"korean": "가", "chinese": "去", "pinyin": "qù"}]</small>
        </div>
        <div class="row">
          <div class="col-md-6 mb-3">
            <label class="form-label">획순 이미지 URL</label>
            <input type="text" class="form-control" name="stroke_order_url"
                   value="${Formatters.escapeHTML(char?.stroke_order_url || '')}">
          </div>
          <div class="col-md-6 mb-3">
            <label class="form-label">오디오 URL</label>
            <input type="text" class="form-control" name="audio_url"
                   value="${Formatters.escapeHTML(char?.audio_url || '')}">
          </div>
        </div>
      </form>
    `;
  }

  async function deleteCharacter(id) {
    Modal.confirm('이 자모를 삭제하시겠습니까?', async () => {
      try {
        await API.hangul.delete(id);
        Toast.success('자모가 삭제되었습니다.');
        await Promise.all([loadStats(), loadCharacters(), loadAlphabetPreview()]);
      } catch (error) {
        Toast.error(error.message);
      }
    });
  }

  return { render, showEditModal, deleteCharacter };
})();
