/**
 * Formatting Utilities
 *
 * 데이터 포맷팅 헬퍼 함수
 */

const Formatters = {
  /**
   * 날짜 포맷팅
   *
   * @param {string|Date} date - 날짜
   * @param {string} format - 포맷 ('full'|'date'|'time'|'datetime'|'relative')
   * @returns {string} 포맷팅된 날짜
   *
   * @example
   * Formatters.formatDate('2024-01-28T10:30:00', 'full')
   * // '2024-01-28 10:30:00'
   *
   * Formatters.formatDate(new Date(), 'relative')
   * // '방금 전', '5분 전', '2시간 전'
   */
  formatDate(date, format = 'datetime') {
    if (!date) return '-';

    const d = new Date(date);
    if (isNaN(d.getTime())) return '-';

    // 상대 시간 (방금 전, 5분 전 등)
    if (format === 'relative') {
      return this.formatRelativeTime(d);
    }

    const year = d.getFullYear();
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const day = String(d.getDate()).padStart(2, '0');
    const hours = String(d.getHours()).padStart(2, '0');
    const minutes = String(d.getMinutes()).padStart(2, '0');
    const seconds = String(d.getSeconds()).padStart(2, '0');

    switch (format) {
      case 'full':
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
      case 'date':
        return `${year}-${month}-${day}`;
      case 'time':
        return `${hours}:${minutes}:${seconds}`;
      case 'datetime':
      default:
        return `${year}-${month}-${day} ${hours}:${minutes}`;
    }
  },

  /**
   * 상대 시간 포맷팅
   *
   * @param {Date} date - 날짜
   * @returns {string} 상대 시간 (예: '방금 전', '5분 전', '2시간 전')
   *
   * @example
   * Formatters.formatRelativeTime(new Date())
   * // '방금 전'
   */
  formatRelativeTime(date) {
    const now = new Date();
    const diff = Math.floor((now - date) / 1000); // 초 단위

    if (diff < 60) return '방금 전';
    if (diff < 3600) return `${Math.floor(diff / 60)}분 전`;
    if (diff < 86400) return `${Math.floor(diff / 3600)}시간 전`;
    if (diff < 2592000) return `${Math.floor(diff / 86400)}일 전`;
    if (diff < 31536000) return `${Math.floor(diff / 2592000)}개월 전`;
    return `${Math.floor(diff / 31536000)}년 전`;
  },

  /**
   * 파일 크기 포맷팅
   *
   * @param {number} bytes - 바이트 크기
   * @param {number} decimals - 소수점 자릿수 (기본값: 2)
   * @returns {string} 포맷팅된 크기 (예: '10.5 MB')
   *
   * @example
   * Formatters.formatFileSize(1024)           // '1.00 KB'
   * Formatters.formatFileSize(1048576)        // '1.00 MB'
   * Formatters.formatFileSize(10485760, 1)    // '10.0 MB'
   */
  formatFileSize(bytes, decimals = 2) {
    if (bytes === 0) return '0 Bytes';

    const k = 1024;
    const dm = decimals < 0 ? 0 : decimals;
    const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];

    const i = Math.floor(Math.log(bytes) / Math.log(k));

    return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i];
  },

  /**
   * 숫자 포맷팅 (천 단위 콤마)
   *
   * @param {number} num - 숫자
   * @returns {string} 포맷팅된 숫자
   *
   * @example
   * Formatters.formatNumber(1234567)  // '1,234,567'
   */
  formatNumber(num) {
    if (num === null || num === undefined) return '-';
    return num.toLocaleString('ko-KR');
  },

  /**
   * 퍼센트 포맷팅
   *
   * @param {number} value - 값 (0~1 또는 0~100)
   * @param {boolean} isDecimal - 소수 형태인지 (기본값: true)
   * @param {number} decimals - 소수점 자릿수 (기본값: 1)
   * @returns {string} 포맷팅된 퍼센트
   *
   * @example
   * Formatters.formatPercent(0.5, true)    // '50.0%'
   * Formatters.formatPercent(75, false)    // '75.0%'
   */
  formatPercent(value, isDecimal = true, decimals = 1) {
    if (value === null || value === undefined) return '-';

    const percent = isDecimal ? value * 100 : value;
    return `${percent.toFixed(decimals)}%`;
  },

  /**
   * 소요 시간 포맷팅 (분 → 시간:분)
   *
   * @param {number} minutes - 분
   * @returns {string} 포맷팅된 시간
   *
   * @example
   * Formatters.formatDuration(65)   // '1시간 5분'
   * Formatters.formatDuration(30)   // '30분'
   */
  formatDuration(minutes) {
    if (!minutes || minutes === 0) return '-';

    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;

    if (hours === 0) return `${mins}분`;
    if (mins === 0) return `${hours}시간`;
    return `${hours}시간 ${mins}분`;
  },

  /**
   * 레슨 상태 배지 HTML 생성
   *
   * @param {string} status - 상태 ('draft'|'published'|'archived')
   * @returns {string} HTML 문자열
   *
   * @example
   * Formatters.formatLessonStatus('published')
   * // '<span class="badge bg-success">발행됨</span>'
   */
  formatLessonStatus(status) {
    const label = Constants.LESSON_STATUS_LABELS[status] || status;
    const color = Constants.LESSON_STATUS_COLORS[status] || 'secondary';
    return `<span class="badge bg-${color}">${label}</span>`;
  },

  /**
   * 구독 타입 배지 HTML 생성
   *
   * @param {string} subscription - 구독 타입 ('free'|'premium')
   * @returns {string} HTML 문자열
   *
   * @example
   * Formatters.formatSubscription('premium')
   * // '<span class="badge bg-warning">프리미엄</span>'
   */
  formatSubscription(subscription) {
    const label = Constants.SUBSCRIPTION_LABELS[subscription] || subscription;
    const color = Constants.SUBSCRIPTION_COLORS[subscription] || 'secondary';
    return `<span class="badge bg-${color}">${label}</span>`;
  },

  /**
   * 사용자 상태 배지 HTML 생성
   *
   * @param {string|Object} statusOrUser - 상태 ('active'|'inactive'|'banned') 또는 사용자 객체
   * @returns {string} HTML 문자열
   *
   * @example
   * Formatters.formatUserStatus('active')
   * // '<span class="badge bg-success">활성</span>'
   */
  formatUserStatus(statusOrUser) {
    let label, color;

    // 객체가 전달된 경우 (is_active, banned 속성 확인)
    if (typeof statusOrUser === 'object' && statusOrUser !== null) {
      if (statusOrUser.banned === true) {
        label = '차단됨';
        color = 'danger';
      } else if (statusOrUser.is_active === false) {
        label = '비활성';
        color = 'secondary';
      } else {
        label = '활성';
        color = 'success';
      }
    } else {
      // 문자열이 전달된 경우 (기존 방식)
      label = Constants.USER_STATUS_LABELS[statusOrUser] || statusOrUser;
      color = Constants.USER_STATUS_COLORS[statusOrUser] || 'secondary';
    }

    return `<span class="badge bg-${color}">${label}</span>`;
  },

  /**
   * 난이도 표시 HTML 생성
   *
   * @param {string} difficulty - 난이도 ('beginner'|'elementary'|'intermediate'|'advanced')
   * @returns {string} HTML 문자열
   *
   * @example
   * Formatters.formatDifficulty('intermediate')
   * // '<span class="text-warning">중급</span>'
   */
  formatDifficulty(difficulty) {
    const label = Constants.LESSON_DIFFICULTY_LABELS[difficulty] || difficulty;
    const colors = {
      beginner: 'success',
      elementary: 'info',
      intermediate: 'warning',
      advanced: 'danger',
    };
    const color = colors[difficulty] || 'secondary';
    return `<span class="text-${color} fw-bold">${label}</span>`;
  },

  /**
   * 품사 표시 HTML 생성
   *
   * @param {string} partOfSpeech - 품사
   * @returns {string} HTML 문자열
   *
   * @example
   * Formatters.formatPartOfSpeech('noun')
   * // '<span class="badge bg-primary">명사</span>'
   */
  formatPartOfSpeech(partOfSpeech) {
    const label = Constants.PARTS_OF_SPEECH_LABELS[partOfSpeech] || partOfSpeech;
    return `<span class="badge bg-primary">${label}</span>`;
  },

  /**
   * 텍스트 잘라내기 (말줄임표)
   *
   * @param {string} text - 텍스트
   * @param {number} maxLength - 최대 길이
   * @returns {string} 잘린 텍스트
   *
   * @example
   * Formatters.truncate('This is a long text', 10)
   * // 'This is a...'
   */
  truncate(text, maxLength) {
    if (!text) return '-';
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength) + '...';
  },

  /**
   * 빈 값 처리
   *
   * @param {*} value - 값
   * @param {string} placeholder - 빈 값일 때 표시할 문자열 (기본값: '-')
   * @returns {string} 값 또는 placeholder
   *
   * @example
   * Formatters.emptyValue(null)      // '-'
   * Formatters.emptyValue('', 'N/A') // 'N/A'
   * Formatters.emptyValue('test')    // 'test'
   */
  emptyValue(value, placeholder = '-') {
    if (value === null || value === undefined || value === '') {
      return placeholder;
    }
    return value;
  },

  /**
   * Boolean 값을 아이콘으로 표시
   *
   * @param {boolean} value - Boolean 값
   * @returns {string} HTML 문자열 (아이콘)
   *
   * @example
   * Formatters.formatBoolean(true)
   * // '<i class="fas fa-check text-success"></i>'
   *
   * Formatters.formatBoolean(false)
   * // '<i class="fas fa-times text-danger"></i>'
   */
  formatBoolean(value) {
    if (value) {
      return '<i class="fas fa-check text-success"></i>';
    } else {
      return '<i class="fas fa-times text-danger"></i>';
    }
  },

  /**
   * HTML 이스케이프 (XSS 방지)
   *
   * @param {string} text - 텍스트
   * @returns {string} 이스케이프된 텍스트
   *
   * @example
   * Formatters.escapeHTML('<script>alert("xss")</script>')
   * // '&lt;script&gt;alert(&quot;xss&quot;)&lt;/script&gt;'
   */
  escapeHTML(text) {
    if (!text) return '';
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
  },

  /**
   * JSON 예쁘게 포맷팅
   *
   * @param {Object} obj - JSON 객체
   * @param {number} indent - 들여쓰기 크기 (기본값: 2)
   * @returns {string} 포맷팅된 JSON 문자열
   *
   * @example
   * Formatters.formatJSON({ name: 'test', value: 123 })
   * // '{
   * //   "name": "test",
   * //   "value": 123
   * // }'
   */
  formatJSON(obj, indent = 2) {
    if (!obj) return '';
    try {
      return JSON.stringify(obj, null, indent);
    } catch (error) {
      return String(obj);
    }
  },
};
