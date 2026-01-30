/**
 * Lesson Content Editor (v2)
 *
 * 유연한 레슨 콘텐츠 에디터 - 제한 없는 단계 구조
 * - 7가지 템플릿 타입 재사용 가능
 * - 단계 수 제한 없음
 * - 순서 자유롭게 재정렬
 */

const LessonContentEditor = (() => {
  let currentLesson = null;
  let currentContent = null;
  let selectedStageId = null;
  let sortableInstances = [];

  async function render(params) {
    try {
      const lessonId = params.id;

      // 레슨 메타데이터 가져오기
      const lessonResponse = await API.lessons.getById(lessonId);
      currentLesson = lessonResponse.data;

      // 레슨 콘텐츠 가져오기 (MongoDB)
      try {
        const contentResponse = await API.lessons.getContent(lessonId);
        currentContent = contentResponse.data || getEmptyContent();
      } catch (error) {
        console.log('[CONTENT_EDITOR] No content found, using empty structure');
        currentContent = getEmptyContent();
      }

      // v2 구조로 변환 (백엔드에서 이미 변환되었지만 이중 체크)
      ensureV2Structure();

      // 첫 번째 단계 선택
      if (currentContent.content.stages.length > 0 && !selectedStageId) {
        selectedStageId = currentContent.content.stages[0].id;
      }

      const layout = `
        <div class="app-layout">
          ${Sidebar.render()}
          <div class="main-content">
            ${Header.render(`레슨 콘텐츠 편집: ${currentLesson.title_ko}`, [
              { label: '목록으로', icon: 'fa-list', class: 'btn-secondary', onClick: () => Router.navigate('/lessons') },
              { label: '저장', icon: 'fa-save', class: 'btn-primary', onClick: () => LessonContentEditor.saveContent() }
            ])}
            <div class="content-container">
              ${renderContentEditor()}
            </div>
          </div>
        </div>
      `;
      Router.render(layout);
      Sidebar.updateActive();
      attachEventListeners();
    } catch (error) {
      console.error('[CONTENT_EDITOR] Error:', error);
      Toast.error('레슨 정보를 불러올 수 없습니다.');
      Router.navigate('/lessons');
    }
  }

  function getEmptyContent() {
    return {
      lesson_id: currentLesson?.id,
      version: '2.0.0',
      content: {
        stages: []
      }
    };
  }

  function ensureV2Structure() {
    // v2 구조 확인 (백엔드에서 이미 처리하지만 이중 체크)
    if (!currentContent.content.stages) {
      currentContent.content = { stages: [] };
    }
    if (!Array.isArray(currentContent.content.stages)) {
      currentContent.content.stages = [];
    }
    currentContent.version = '2.0.0';
  }

  function renderContentEditor() {
    return `
      <div class="row g-3">
        <!-- 좌측: 단계 목록 -->
        <div class="col-auto stage-sidebar" id="stage-sidebar">
          <div class="card sticky-top" style="top: 20px; width: 180px;">
            <div class="card-body">
              ${renderStageListManager()}
            </div>
          </div>
        </div>

        <!-- 우측: 단계 편집기 -->
        <div class="col stage-editor-col">
          <div class="card">
            <div class="card-body" id="stage-editor-container">
              ${renderStageEditor()}
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function renderStageListManager() {
    const stages = currentContent.content.stages || [];

    return `
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h6 class="mb-0"><i class="fas fa-layer-group me-1"></i>단계</h6>
        <button class="btn btn-sm btn-success" onclick="LessonContentEditor.showAddStageModal()" title="단계 추가">
          <i class="fas fa-plus"></i>
        </button>
      </div>

      ${stages.length === 0 ? `
        <div class="text-center text-muted py-4">
          <i class="fas fa-inbox fa-2x mb-2"></i>
          <p class="mb-0">단계를 추가해주세요</p>
        </div>
      ` : `
        <div class="stage-list" id="sortable-stage-list">
          ${stages.map((stage, idx) => renderStageListItem(stage, idx)).join('')}
        </div>

        <!-- Delete Zone (fixed at bottom) -->
        <div class="delete-zone" id="delete-zone" style="display: none;">
          <div class="delete-zone-content">
            <i class="fas fa-trash-alt"></i>
          </div>
        </div>
      `}
    `;
  }

  function renderStageListItem(stage, idx) {
    const isSelected = selectedStageId === stage.id;
    const stages = currentContent.content.stages;

    return `
      <div class="card mb-2 stage-item ${isSelected ? 'border-primary selected' : ''}"
           data-stage-id="${stage.id}"
           style="cursor: pointer;">
        <div class="card-body py-2 px-3">
          <div class="d-flex align-items-center">
            <i class="fas fa-grip-vertical me-2 text-muted drag-handle" style="cursor: grab;" title="드래그하여 이동"></i>
            <span class="badge bg-${isSelected ? 'primary' : 'secondary'} me-2">${idx + 1}</span>
            <i class="fas fa-${getStageIcon(stage.type)} me-2"></i>
            <strong class="flex-grow-1" onclick="LessonContentEditor.editStage('${stage.id}')">${getStageLabel(stage.type)}</strong>
          </div>
        </div>
      </div>
    `;
  }

  function renderStageEditor() {
    if (!selectedStageId) {
      return `
        <div class="text-center text-muted py-5">
          <i class="fas fa-hand-pointer fa-3x mb-3"></i>
          <p>좌측에서 편집할 단계를 선택하거나<br>새 단계를 추가해주세요</p>
        </div>
      `;
    }

    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage) {
      return '<p class="text-danger">단계를 찾을 수 없습니다.</p>';
    }

    return renderStageContentByType(stage);
  }

  function renderStageContentByType(stage) {
    switch (stage.type) {
      case 'intro':
        return renderIntroStage(stage);
      case 'vocabulary':
        return renderVocabularyStage(stage);
      case 'grammar':
        return renderGrammarStage(stage);
      case 'practice':
        return renderPracticeStage(stage);
      case 'dialogue':
        return renderDialogueStage(stage);
      case 'quiz':
        return renderQuizStage(stage);
      case 'summary':
        return renderSummaryStage(stage);
      default:
        return `<p class="text-warning">알 수 없는 단계 타입: ${stage.type}</p>`;
    }
  }

  // Stage Type Renderers
  function renderIntroStage(stage) {
    const data = stage.data || {};
    return `
      <h5 class="mb-3"><i class="fas fa-book-open me-2"></i>소개 (Introduction)</h5>
      <div class="row">
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label">제목</label>
            <input type="text" class="form-control" data-field="title"
                   value="${Formatters.escapeHTML(data.title || '')}">
          </div>
        </div>
        <div class="col-md-6">
          <div class="mb-3">
            <label class="form-label">이미지 URL</label>
            <input type="url" class="form-control" data-field="image_url"
                   value="${data.image_url || ''}" placeholder="http://...">
          </div>
        </div>
      </div>
      <div class="mb-3">
        <label class="form-label">설명</label>
        <textarea class="form-control" data-field="description" rows="4">${Formatters.escapeHTML(data.description || '')}</textarea>
      </div>
      <div class="mb-3">
        <label class="form-label">오디오 URL</label>
        <input type="url" class="form-control" data-field="audio_url"
               value="${data.audio_url || ''}" placeholder="http://...">
      </div>
    `;
  }

  function renderVocabularyStage(stage) {
    const data = stage.data || { words: [] };
    const words = data.words || [];

    return `
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0"><i class="fas fa-language me-2"></i>단어 학습 (Vocabulary)</h5>
        <button class="btn btn-sm btn-success" onclick="LessonContentEditor.addWord()">
          <i class="fas fa-plus me-1"></i>단어 추가
        </button>
      </div>
      <div id="words-container">
        ${words.map((word, idx) => renderWord(word, idx)).join('')}
      </div>
      ${words.length === 0 ? '<p class="text-muted text-center py-4">단어를 추가해주세요.</p>' : ''}
    `;
  }

  function renderWord(word, idx) {
    return `
      <div class="card mb-3 word-card" data-index="${idx}">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-start mb-2">
            <h6 class="mb-0">단어 #${idx + 1}</h6>
            <button class="btn btn-sm btn-danger" onclick="LessonContentEditor.removeWord(${idx})">
              <i class="fas fa-trash"></i>
            </button>
          </div>
          <div class="row">
            <div class="col-md-3">
              <div class="mb-2">
                <label class="form-label small">한국어</label>
                <input type="text" class="form-control form-control-sm" data-word-field="korean" data-word-idx="${idx}"
                       value="${Formatters.escapeHTML(word.korean || '')}">
              </div>
            </div>
            <div class="col-md-3">
              <div class="mb-2">
                <label class="form-label small">중국어</label>
                <input type="text" class="form-control form-control-sm" data-word-field="chinese" data-word-idx="${idx}"
                       value="${Formatters.escapeHTML(word.chinese || '')}">
              </div>
            </div>
            <div class="col-md-3">
              <div class="mb-2">
                <label class="form-label small">발음 (Pinyin)</label>
                <input type="text" class="form-control form-control-sm" data-word-field="pinyin" data-word-idx="${idx}"
                       value="${Formatters.escapeHTML(word.pinyin || '')}">
              </div>
            </div>
            <div class="col-md-3">
              <div class="mb-2">
                <label class="form-label small">한자</label>
                <input type="text" class="form-control form-control-sm" data-word-field="hanja" data-word-idx="${idx}"
                       value="${Formatters.escapeHTML(word.hanja || '')}">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-4">
              <div class="mb-2">
                <label class="form-label small">이미지 URL</label>
                <input type="url" class="form-control form-control-sm" data-word-field="image_url" data-word-idx="${idx}"
                       value="${word.image_url || ''}">
              </div>
            </div>
            <div class="col-md-4">
              <div class="mb-2">
                <label class="form-label small">오디오 URL</label>
                <input type="url" class="form-control form-control-sm" data-word-field="audio_url" data-word-idx="${idx}"
                       value="${word.audio_url || ''}">
              </div>
            </div>
            <div class="col-md-4">
              <div class="mb-2">
                <label class="form-label small">품사</label>
                <select class="form-select form-select-sm" data-word-field="part_of_speech" data-word-idx="${idx}">
                  <option value="">선택</option>
                  ${Object.entries(Constants.PARTS_OF_SPEECH_LABELS).map(([key, label]) => `
                    <option value="${key}" ${word.part_of_speech === key ? 'selected' : ''}>${label}</option>
                  `).join('')}
                </select>
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function renderGrammarStage(stage) {
    const data = stage.data || { rules: [] };
    const rules = data.rules || [];

    return `
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0"><i class="fas fa-spell-check me-2"></i>문법 (Grammar)</h5>
        <button class="btn btn-sm btn-success" onclick="LessonContentEditor.addRule()">
          <i class="fas fa-plus me-1"></i>규칙 추가
        </button>
      </div>
      <div id="rules-container">
        ${rules.map((rule, idx) => renderRule(rule, idx)).join('')}
      </div>
      ${rules.length === 0 ? '<p class="text-muted text-center py-4">문법 규칙을 추가해주세요.</p>' : ''}
    `;
  }

  function renderRule(rule, idx) {
    return `
      <div class="card mb-3 rule-card" data-index="${idx}">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-start mb-2">
            <h6 class="mb-0">문법 규칙 #${idx + 1}</h6>
            <button class="btn btn-sm btn-danger" onclick="LessonContentEditor.removeRule(${idx})">
              <i class="fas fa-trash"></i>
            </button>
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="mb-2">
                <label class="form-label small">제목 (한국어)</label>
                <input type="text" class="form-control form-control-sm" data-rule-field="title_ko" data-rule-idx="${idx}"
                       value="${Formatters.escapeHTML(rule.title_ko || '')}">
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-2">
                <label class="form-label small">제목 (중국어)</label>
                <input type="text" class="form-control form-control-sm" data-rule-field="title_zh" data-rule-idx="${idx}"
                       value="${Formatters.escapeHTML(rule.title_zh || '')}">
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-12">
              <div class="mb-2">
                <label class="form-label small">설명 (한국어)</label>
                <textarea class="form-control form-control-sm" rows="2" data-rule-field="description_ko" data-rule-idx="${idx}">${Formatters.escapeHTML(rule.description_ko || '')}</textarea>
              </div>
            </div>
            <div class="col-md-12">
              <div class="mb-2">
                <label class="form-label small">설명 (중국어)</label>
                <textarea class="form-control form-control-sm" rows="2" data-rule-field="description_zh" data-rule-idx="${idx}">${Formatters.escapeHTML(rule.description_zh || '')}</textarea>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-md-6">
              <div class="mb-2">
                <label class="form-label small">예문 (한국어)</label>
                <input type="text" class="form-control form-control-sm" data-rule-field="example_ko" data-rule-idx="${idx}"
                       value="${Formatters.escapeHTML(rule.example_ko || '')}">
              </div>
            </div>
            <div class="col-md-6">
              <div class="mb-2">
                <label class="form-label small">예문 (중국어)</label>
                <input type="text" class="form-control form-control-sm" data-rule-field="example_zh" data-rule-idx="${idx}"
                       value="${Formatters.escapeHTML(rule.example_zh || '')}">
              </div>
            </div>
          </div>
        </div>
      </div>
    `;
  }

  function renderPracticeStage(stage) {
    const data = stage.data || { exercises: [] };
    const exercises = data.exercises || [];

    return `
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0"><i class="fas fa-pen me-2"></i>연습 문제 (Practice)</h5>
        <button class="btn btn-sm btn-success" onclick="LessonContentEditor.addExercise()">
          <i class="fas fa-plus me-1"></i>문제 추가
        </button>
      </div>
      <div id="exercises-container">
        ${exercises.map((exercise, idx) => renderExercise(exercise, idx)).join('')}
      </div>
      ${exercises.length === 0 ? '<p class="text-muted text-center py-4">연습 문제를 추가해주세요.</p>' : ''}
    `;
  }

  function renderExercise(exercise, idx) {
    return `
      <div class="card mb-3 exercise-card" data-index="${idx}">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-start mb-2">
            <h6 class="mb-0">문제 #${idx + 1}</h6>
            <button class="btn btn-sm btn-danger" onclick="LessonContentEditor.removeExercise(${idx})">
              <i class="fas fa-trash"></i>
            </button>
          </div>
          <div class="mb-2">
            <label class="form-label small">질문</label>
            <input type="text" class="form-control form-control-sm" data-exercise-field="question" data-exercise-idx="${idx}"
                   value="${Formatters.escapeHTML(exercise.question || '')}">
          </div>
          <div class="mb-2">
            <label class="form-label small">선택지 (쉼표로 구분)</label>
            <input type="text" class="form-control form-control-sm" data-exercise-field="options" data-exercise-idx="${idx}"
                   value="${(exercise.options || []).join(', ')}"
                   placeholder="선택지1, 선택지2, 선택지3, 선택지4">
          </div>
          <div class="mb-2">
            <label class="form-label small">정답 (0부터 시작하는 인덱스)</label>
            <input type="number" class="form-control form-control-sm" data-exercise-field="correct_answer" data-exercise-idx="${idx}"
                   value="${exercise.correct_answer ?? ''}" min="0" max="3">
          </div>
        </div>
      </div>
    `;
  }

  function renderDialogueStage(stage) {
    const data = stage.data || { dialogues: [] };
    const dialogues = data.dialogues || [];

    return `
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0"><i class="fas fa-comments me-2"></i>대화 (Dialogue)</h5>
        <button class="btn btn-sm btn-success" onclick="LessonContentEditor.addDialogue()">
          <i class="fas fa-plus me-1"></i>대화 추가
        </button>
      </div>
      <div id="dialogues-container">
        ${dialogues.map((dialogue, idx) => renderDialogue(dialogue, idx)).join('')}
      </div>
      ${dialogues.length === 0 ? '<p class="text-muted text-center py-4">대화를 추가해주세요.</p>' : ''}
    `;
  }

  function renderDialogue(dialogue, idx) {
    return `
      <div class="card mb-2 dialogue-card" data-index="${idx}">
        <div class="card-body py-2">
          <div class="d-flex align-items-center gap-2">
            <span class="badge bg-secondary">#${idx + 1}</span>
            <input type="text" class="form-control form-control-sm" style="width: 100px;"
                   data-dialogue-field="speaker" data-dialogue-idx="${idx}"
                   value="${Formatters.escapeHTML(dialogue.speaker || '')}" placeholder="화자">
            <input type="text" class="form-control form-control-sm flex-grow-1"
                   data-dialogue-field="text_ko" data-dialogue-idx="${idx}"
                   value="${Formatters.escapeHTML(dialogue.text_ko || '')}" placeholder="한국어">
            <input type="text" class="form-control form-control-sm flex-grow-1"
                   data-dialogue-field="text_zh" data-dialogue-idx="${idx}"
                   value="${Formatters.escapeHTML(dialogue.text_zh || '')}" placeholder="중국어">
            <input type="url" class="form-control form-control-sm" style="width: 150px;"
                   data-dialogue-field="audio_url" data-dialogue-idx="${idx}"
                   value="${dialogue.audio_url || ''}" placeholder="오디오 URL">
            <button class="btn btn-sm btn-danger" onclick="LessonContentEditor.removeDialogue(${idx})">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      </div>
    `;
  }

  function renderQuizStage(stage) {
    const data = stage.data || { questions: [] };
    const questions = data.questions || [];

    return `
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0"><i class="fas fa-question-circle me-2"></i>퀴즈 (Quiz)</h5>
        <button class="btn btn-sm btn-success" onclick="LessonContentEditor.addQuestion()">
          <i class="fas fa-plus me-1"></i>문제 추가
        </button>
      </div>
      <div id="questions-container">
        ${questions.map((question, idx) => renderQuestion(question, idx)).join('')}
      </div>
      ${questions.length === 0 ? '<p class="text-muted text-center py-4">퀴즈 문제를 추가해주세요.</p>' : ''}
    `;
  }

  function renderQuestion(question, idx) {
    return `
      <div class="card mb-3 question-card" data-index="${idx}">
        <div class="card-body">
          <div class="d-flex justify-content-between align-items-start mb-2">
            <h6 class="mb-0">문제 #${idx + 1}</h6>
            <button class="btn btn-sm btn-danger" onclick="LessonContentEditor.removeQuestion(${idx})">
              <i class="fas fa-trash"></i>
            </button>
          </div>
          <div class="mb-2">
            <label class="form-label small">질문</label>
            <input type="text" class="form-control form-control-sm" data-question-field="question" data-question-idx="${idx}"
                   value="${Formatters.escapeHTML(question.question || '')}">
          </div>
          <div class="mb-2">
            <label class="form-label small">선택지 (쉼표로 구분)</label>
            <input type="text" class="form-control form-control-sm" data-question-field="options" data-question-idx="${idx}"
                   value="${(question.options || []).join(', ')}"
                   placeholder="선택지1, 선택지2, 선택지3, 선택지4">
          </div>
          <div class="mb-2">
            <label class="form-label small">정답 (0부터 시작하는 인덱스)</label>
            <input type="number" class="form-control form-control-sm" data-question-field="correct_answer" data-question-idx="${idx}"
                   value="${question.correct_answer ?? ''}" min="0" max="3">
          </div>
        </div>
      </div>
    `;
  }

  function renderSummaryStage(stage) {
    const data = stage.data || {};
    return `
      <h5 class="mb-3"><i class="fas fa-check-circle me-2"></i>요약 (Summary)</h5>
      <div class="mb-3">
        <label class="form-label">요약 텍스트</label>
        <textarea class="form-control" data-field="summary_text" rows="5">${Formatters.escapeHTML(data.summary_text || '')}</textarea>
      </div>
      <div class="mb-3">
        <label class="form-label">복습 포인트 (한 줄에 하나씩)</label>
        <textarea class="form-control" data-field="review_points" rows="5">${(data.review_points || []).join('\n')}</textarea>
        <small class="text-muted">각 줄이 하나의 복습 포인트가 됩니다.</small>
      </div>
    `;
  }

  // Utility Functions
  function getStageIcon(type) {
    const icons = {
      intro: 'book-open',
      vocabulary: 'language',
      grammar: 'spell-check',
      practice: 'pen',
      dialogue: 'comments',
      quiz: 'question-circle',
      summary: 'check-circle'
    };
    return icons[type] || 'circle';
  }

  function getStageLabel(type) {
    const labels = {
      intro: '소개',
      vocabulary: '단어',
      grammar: '문법',
      practice: '연습',
      dialogue: '대화',
      quiz: '퀴즈',
      summary: '요약'
    };
    return labels[type] || type;
  }

  function getEmptyStageData(type) {
    const templates = {
      intro: { title: '', description: '', image_url: '', audio_url: '' },
      vocabulary: { words: [] },
      grammar: { rules: [] },
      practice: { exercises: [] },
      dialogue: { dialogues: [] },
      quiz: { questions: [] },
      summary: { summary_text: '', review_points: [] }
    };
    return templates[type] || {};
  }

  // Event Handlers
  function attachEventListeners() {
    // Auto-save on input change
    document.addEventListener('input', (e) => {
      if (e.target.hasAttribute('data-field') ||
          e.target.hasAttribute('data-word-field') ||
          e.target.hasAttribute('data-rule-field') ||
          e.target.hasAttribute('data-exercise-field') ||
          e.target.hasAttribute('data-dialogue-field') ||
          e.target.hasAttribute('data-question-field')) {
        collectCurrentStageData();
      }
    });

    // Keyboard shortcuts
    document.addEventListener('keydown', (e) => {
      // Ctrl+S / Cmd+S to save
      if ((e.ctrlKey || e.metaKey) && e.key === 's') {
        e.preventDefault();
        saveContent();
      }
    });

    // Initialize SortableJS for drag and drop
    initializeSortable();

    // Card click event (delegate)
    document.addEventListener('click', (e) => {
      const stageCard = e.target.closest('.stage-item');
      if (stageCard && !e.target.closest('button') && !e.target.closest('.drag-handle')) {
        const stageId = stageCard.dataset.stageId;
        if (stageId) {
          editStage(stageId);
        }
      }
    });
  }

  // Initialize SortableJS
  function initializeSortable() {
    // Destroy existing instances first
    sortableInstances.forEach(instance => {
      if (instance && instance.destroy) {
        instance.destroy();
      }
    });
    sortableInstances = [];

    const sortableList = document.getElementById('sortable-stage-list');
    const deleteZone = document.getElementById('delete-zone');
    if (!sortableList || typeof Sortable === 'undefined') return;

    let draggedStageId = null;
    let draggedStageIndex = null;

    // Main sortable list
    const listSortable = Sortable.create(sortableList, {
      group: {
        name: 'stages',
        pull: true,
        put: true
      },
      animation: 150,
      handle: '.drag-handle',
      ghostClass: 'sortable-ghost',
      chosenClass: 'sortable-chosen',
      dragClass: 'sortable-drag',
      onStart: function(evt) {
        const draggedItem = evt.item;
        draggedStageId = draggedItem.dataset.stageId;
        draggedStageIndex = evt.oldIndex;

        console.log('[SORTABLE] onStart - ID:', draggedStageId, 'Index:', draggedStageIndex);
        console.log('[SORTABLE] Current stages:', currentContent.content.stages.map((s, i) => `${i}:${s.id}`));

        // Show delete zone
        if (deleteZone) {
          deleteZone.style.display = 'flex';
        }
      },
      onEnd: function(evt) {
        console.log('[SORTABLE] onEnd - from:', evt.from.id, 'to:', evt.to.id);
        console.log('[SORTABLE] oldIndex:', evt.oldIndex, 'newIndex:', evt.newIndex);

        // Hide delete zone
        if (deleteZone) {
          deleteZone.style.display = 'none';
          deleteZone.classList.remove('delete-zone-hover');
        }

        // Check if dropped into delete zone
        if (evt.to.id === 'delete-zone') {
          console.log('[SORTABLE] Dropped in delete zone');

          // Store the ID in a closure variable to avoid scope issues
          const stageIdToDelete = draggedStageId;
          const stageIndexToDelete = draggedStageIndex;

          console.log('[SORTABLE] Will delete - ID:', stageIdToDelete, 'Index:', stageIndexToDelete);

          // Item was dropped in delete zone - show confirm modal
          Modal.confirm('이 단계를 삭제하시겠습니까?', () => {
            console.log('[SORTABLE] User confirmed deletion');
            console.log('[SORTABLE] Stages before:', currentContent.content.stages.map(s => s.id));

            const stages = currentContent.content.stages;

            // Try finding by ID first
            let index = stages.findIndex(s => s.id === stageIdToDelete);
            console.log('[SORTABLE] Found by ID at index:', index);

            // If not found by ID, use the stored index
            if (index === -1 && stageIndexToDelete !== null && stageIndexToDelete < stages.length) {
              console.log('[SORTABLE] Using stored index:', stageIndexToDelete);
              index = stageIndexToDelete;
            }

            if (index !== -1 && index < stages.length) {
              const deletedStage = stages.splice(index, 1)[0];
              console.log('[SORTABLE] Deleted stage:', deletedStage);
              console.log('[SORTABLE] Stages after:', stages.map(s => s.id));
              console.log('[SORTABLE] New count:', stages.length);

              // Reorder
              stages.forEach((s, i) => s.order = i);

              // Clear selection if deleted stage was selected
              if (selectedStageId === stageIdToDelete) {
                selectedStageId = stages.length > 0 ? stages[0].id : null;
              }

              refreshEditor();
              Toast.success(`단계가 삭제되었습니다. (${stages.length}개 단계)`);
            } else {
              console.error('[SORTABLE] Cannot delete - invalid index:', index);
              refreshEditor();
              Toast.error('단계 삭제에 실패했습니다.');
            }
          }, {
            title: '단계 삭제',
            confirmText: '삭제',
            cancelText: '취소',
            confirmClass: 'btn-danger',
            onCancel: () => {
              console.log('[SORTABLE] User cancelled deletion');
              refreshEditor();
            }
          });
        } else {
          // Normal reorder within the list
          console.log('[SORTABLE] Normal reorder');
          const stages = currentContent.content.stages;

          // Only reorder if indices are different
          if (evt.oldIndex !== evt.newIndex) {
            const movedStage = stages.splice(evt.oldIndex, 1)[0];
            stages.splice(evt.newIndex, 0, movedStage);

            // Reorder
            stages.forEach((s, i) => s.order = i);

            console.log('[SORTABLE] Reordered:', stages.map(s => s.id));

            // Refresh UI
            refreshEditor();
            Toast.success('단계 순서가 변경되었습니다.');
          }
        }

        // Clean up
        draggedStageId = null;
        draggedStageIndex = null;
      }
    });

    // Store instance
    sortableInstances.push(listSortable);

    // Delete zone sortable
    if (deleteZone) {
      const deleteZoneSortable = Sortable.create(deleteZone, {
        group: {
          name: 'stages',
          pull: false,
          put: true
        },
        sort: false,
        animation: 0,
        onAdd: function(evt) {
          console.log('[SORTABLE] onAdd - item added to delete zone');

          // Remove the item from delete zone DOM immediately
          const item = evt.item;
          if (item && item.parentNode) {
            item.remove();
          }
        }
      });

      // Store instance
      sortableInstances.push(deleteZoneSortable);
    }
  }

  function collectCurrentStageData() {
    if (!selectedStageId) return;

    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage) return;

    switch (stage.type) {
      case 'intro':
        collectIntroData(stage);
        break;
      case 'vocabulary':
        collectVocabularyData(stage);
        break;
      case 'grammar':
        collectGrammarData(stage);
        break;
      case 'practice':
        collectPracticeData(stage);
        break;
      case 'dialogue':
        collectDialogueData(stage);
        break;
      case 'quiz':
        collectQuizData(stage);
        break;
      case 'summary':
        collectSummaryData(stage);
        break;
    }
  }

  function collectIntroData(stage) {
    stage.data = {
      title: document.querySelector('[data-field="title"]')?.value || '',
      description: document.querySelector('[data-field="description"]')?.value || '',
      image_url: document.querySelector('[data-field="image_url"]')?.value || '',
      audio_url: document.querySelector('[data-field="audio_url"]')?.value || ''
    };
  }

  function collectVocabularyData(stage) {
    const words = [];
    document.querySelectorAll('.word-card').forEach(card => {
      const word = {
        korean: card.querySelector('[data-word-field="korean"]')?.value || '',
        chinese: card.querySelector('[data-word-field="chinese"]')?.value || '',
        pinyin: card.querySelector('[data-word-field="pinyin"]')?.value || '',
        hanja: card.querySelector('[data-word-field="hanja"]')?.value || '',
        image_url: card.querySelector('[data-word-field="image_url"]')?.value || '',
        audio_url: card.querySelector('[data-word-field="audio_url"]')?.value || '',
        part_of_speech: card.querySelector('[data-word-field="part_of_speech"]')?.value || ''
      };
      words.push(word);
    });
    stage.data = { words };
  }

  function collectGrammarData(stage) {
    const rules = [];
    document.querySelectorAll('.rule-card').forEach(card => {
      const rule = {
        title_ko: card.querySelector('[data-rule-field="title_ko"]')?.value || '',
        title_zh: card.querySelector('[data-rule-field="title_zh"]')?.value || '',
        description_ko: card.querySelector('[data-rule-field="description_ko"]')?.value || '',
        description_zh: card.querySelector('[data-rule-field="description_zh"]')?.value || '',
        example_ko: card.querySelector('[data-rule-field="example_ko"]')?.value || '',
        example_zh: card.querySelector('[data-rule-field="example_zh"]')?.value || ''
      };
      rules.push(rule);
    });
    stage.data = { rules };
  }

  function collectPracticeData(stage) {
    const exercises = [];
    document.querySelectorAll('.exercise-card').forEach(card => {
      const exercise = {
        question: card.querySelector('[data-exercise-field="question"]')?.value || '',
        options: (card.querySelector('[data-exercise-field="options"]')?.value || '').split(',').map(o => o.trim()).filter(o => o),
        correct_answer: parseInt(card.querySelector('[data-exercise-field="correct_answer"]')?.value) || 0
      };
      exercises.push(exercise);
    });
    stage.data = { exercises };
  }

  function collectDialogueData(stage) {
    const dialogues = [];
    document.querySelectorAll('.dialogue-card').forEach(card => {
      const dialogue = {
        speaker: card.querySelector('[data-dialogue-field="speaker"]')?.value || '',
        text_ko: card.querySelector('[data-dialogue-field="text_ko"]')?.value || '',
        text_zh: card.querySelector('[data-dialogue-field="text_zh"]')?.value || '',
        audio_url: card.querySelector('[data-dialogue-field="audio_url"]')?.value || ''
      };
      dialogues.push(dialogue);
    });
    stage.data = { dialogues };
  }

  function collectQuizData(stage) {
    const questions = [];
    document.querySelectorAll('.question-card').forEach(card => {
      const question = {
        question: card.querySelector('[data-question-field="question"]')?.value || '',
        options: (card.querySelector('[data-question-field="options"]')?.value || '').split(',').map(o => o.trim()).filter(o => o),
        correct_answer: parseInt(card.querySelector('[data-question-field="correct_answer"]')?.value) || 0
      };
      questions.push(question);
    });
    stage.data = { questions };
  }

  function collectSummaryData(stage) {
    const reviewPointsText = document.querySelector('[data-field="review_points"]')?.value || '';
    stage.data = {
      summary_text: document.querySelector('[data-field="summary_text"]')?.value || '',
      review_points: reviewPointsText.split('\n').map(p => p.trim()).filter(p => p)
    };
  }

  // Stage Management Functions
  function showAddStageModal() {
    Modal.custom({
      title: '새 단계 추가',
      body: `
        <div class="mb-3">
          <label class="form-label">단계 타입</label>
          <select class="form-select" id="new-stage-type">
            <option value="intro">소개 (Introduction)</option>
            <option value="vocabulary">단어 (Vocabulary)</option>
            <option value="grammar">문법 (Grammar)</option>
            <option value="practice">연습 (Practice)</option>
            <option value="dialogue">대화 (Dialogue)</option>
            <option value="quiz">퀴즈 (Quiz)</option>
            <option value="summary">요약 (Summary)</option>
          </select>
        </div>
        <div class="mb-3">
          <label class="form-label">위치</label>
          <select class="form-select" id="new-stage-position">
            <option value="end">맨 끝에 추가</option>
            ${currentContent.content.stages.map((s, idx) => `
              <option value="${idx}">${idx + 1}번 앞에 추가</option>
            `).join('')}
          </select>
        </div>
      `,
      confirmText: '추가',
      confirmClass: 'btn-primary',
      cancelText: '취소',
      showCancel: true,
      onConfirm: () => {
        addStage();
        return true; // 모달 닫기
      }
    });
  }

  function addStage() {
    const type = document.getElementById('new-stage-type')?.value;
    const position = document.getElementById('new-stage-position')?.value;

    if (!type) {
      Toast.error('단계 타입을 선택해주세요.');
      return false;
    }

    const newStage = {
      id: `stage_${Date.now()}`,
      type,
      order: 0,
      data: getEmptyStageData(type)
    };

    const stages = currentContent.content.stages;
    if (position === 'end') {
      stages.push(newStage);
    } else {
      stages.splice(parseInt(position), 0, newStage);
    }

    // Reorder all stages
    stages.forEach((s, i) => s.order = i);

    // Select the new stage
    selectedStageId = newStage.id;

    // Re-render
    refreshEditor();
    Toast.success(`${getStageLabel(type)} 단계가 추가되었습니다.`);
  }

  function deleteStage(stageId) {
    const stage = currentContent.content.stages.find(s => s.id === stageId);
    if (!stage) return;

    const stageLabel = getStageLabel(stage.type);
    if (!confirm(`"${stageLabel}" 단계를 삭제하시겠습니까?\n\n이 작업은 저장 전까지 취소할 수 있습니다.`)) return;

    const stages = currentContent.content.stages;
    const index = stages.findIndex(s => s.id === stageId);
    if (index === -1) return;

    stages.splice(index, 1);
    stages.forEach((s, i) => s.order = i);

    // Select another stage if deleted was selected
    if (selectedStageId === stageId) {
      selectedStageId = stages.length > 0 ? stages[0].id : null;
    }

    refreshEditor();
    Toast.success(`${stageLabel} 단계가 삭제되었습니다.`);
  }

  function moveStage(stageId, direction) {
    const stages = currentContent.content.stages;
    const index = stages.findIndex(s => s.id === stageId);
    if (index === -1) return;

    if (direction === 'up' && index > 0) {
      [stages[index], stages[index - 1]] = [stages[index - 1], stages[index]];
    } else if (direction === 'down' && index < stages.length - 1) {
      [stages[index], stages[index + 1]] = [stages[index + 1], stages[index]];
    }

    stages.forEach((s, i) => s.order = i);
    refreshEditor();
  }

  function editStage(stageId) {
    // Collect current stage data before switching
    collectCurrentStageData();

    selectedStageId = stageId;

    // Update stage list visual selection
    updateStageListSelection();

    // Update editor
    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function updateStageListSelection() {
    // Remove selection from all items
    document.querySelectorAll('.stage-item').forEach(item => {
      item.classList.remove('border-primary', 'selected');
      const badge = item.querySelector('.badge');
      if (badge) {
        badge.classList.remove('bg-primary');
        badge.classList.add('bg-secondary');
      }
    });

    // Add selection to current item
    if (selectedStageId) {
      const selectedItem = document.querySelector(`.stage-item[data-stage-id="${selectedStageId}"]`);
      if (selectedItem) {
        selectedItem.classList.add('border-primary', 'selected');
        const badge = selectedItem.querySelector('.badge');
        if (badge) {
          badge.classList.remove('bg-secondary');
          badge.classList.add('bg-primary');
        }
      }
    }
  }

  function refreshEditor() {
    const container = document.querySelector('.content-container');
    if (container) {
      container.innerHTML = renderContentEditor();
      // Re-initialize SortableJS after refresh
      initializeSortable();
    }
  }

  // Item Management Functions (for each stage type)
  function addWord() {
    collectCurrentStageData();
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'vocabulary') return;

    if (!stage.data.words) stage.data.words = [];
    stage.data.words.push({ korean: '', chinese: '', pinyin: '', hanja: '', image_url: '', audio_url: '', part_of_speech: '' });

    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function removeWord(idx) {
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'vocabulary') return;

    collectCurrentStageData();
    stage.data.words.splice(idx, 1);
    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function addRule() {
    collectCurrentStageData();
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'grammar') return;

    if (!stage.data.rules) stage.data.rules = [];
    stage.data.rules.push({ title_ko: '', title_zh: '', description_ko: '', description_zh: '', example_ko: '', example_zh: '' });

    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function removeRule(idx) {
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'grammar') return;

    collectCurrentStageData();
    stage.data.rules.splice(idx, 1);
    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function addExercise() {
    collectCurrentStageData();
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'practice') return;

    if (!stage.data.exercises) stage.data.exercises = [];
    stage.data.exercises.push({ question: '', options: [], correct_answer: 0 });

    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function removeExercise(idx) {
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'practice') return;

    collectCurrentStageData();
    stage.data.exercises.splice(idx, 1);
    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function addDialogue() {
    collectCurrentStageData();
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'dialogue') return;

    if (!stage.data.dialogues) stage.data.dialogues = [];
    stage.data.dialogues.push({ speaker: '', text_ko: '', text_zh: '', audio_url: '' });

    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function removeDialogue(idx) {
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'dialogue') return;

    collectCurrentStageData();
    stage.data.dialogues.splice(idx, 1);
    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function addQuestion() {
    collectCurrentStageData();
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'quiz') return;

    if (!stage.data.questions) stage.data.questions = [];
    stage.data.questions.push({ question: '', options: [], correct_answer: 0 });

    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  function removeQuestion(idx) {
    const stage = currentContent.content.stages.find(s => s.id === selectedStageId);
    if (!stage || stage.type !== 'quiz') return;

    collectCurrentStageData();
    stage.data.questions.splice(idx, 1);
    document.getElementById('stage-editor-container').innerHTML = renderStageEditor();
  }

  // Save Function
  async function saveContent() {
    // Collect current stage data before saving
    collectCurrentStageData();

    // Validation
    if (currentContent.content.stages.length === 0) {
      Toast.error('최소 1개의 단계를 추가해주세요.');
      return;
    }

    // Debug log
    console.log('[CONTENT_EDITOR] Saving content:', {
      lesson_id: currentLesson.id,
      stages_count: currentContent.content.stages.length,
      stage_ids: currentContent.content.stages.map(s => s.id),
      content: currentContent
    });

    // Show loading state
    const saveButton = document.querySelector('.btn-primary');
    if (saveButton) {
      saveButton.disabled = true;
      saveButton.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>저장 중...';
    }

    try {
      const response = await API.lessons.saveContent(currentLesson.id, currentContent);
      console.log('[CONTENT_EDITOR] Save response:', response);
      Toast.success(`레슨 콘텐츠가 저장되었습니다 (${currentContent.content.stages.length}개 단계).`);
    } catch (error) {
      console.error('[CONTENT_EDITOR] Save error:', error);
      Toast.error(error.message || '저장에 실패했습니다.');
    } finally {
      // Restore button state
      if (saveButton) {
        saveButton.disabled = false;
        saveButton.innerHTML = '<i class="fas fa-save me-1"></i>저장';
      }
    }
  }

  // Toggle sidebar collapse

  return {
    render,
    saveContent,
    showAddStageModal,
    editStage,
    deleteStage,
    moveStage,
    addWord,
    removeWord,
    addRule,
    removeRule,
    addExercise,
    removeExercise,
    addDialogue,
    removeDialogue,
    addQuestion,
    removeQuestion
  };
})();
