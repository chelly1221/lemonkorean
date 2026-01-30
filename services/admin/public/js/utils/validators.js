/**
 * Validation Utilities
 *
 * 폼 입력 유효성 검사 헬퍼 함수
 */

const Validators = {
  /**
   * 이메일 유효성 검사
   *
   * @param {string} email - 이메일 주소
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isEmail('test@example.com')  // true
   * Validators.isEmail('invalid')           // false
   */
  isEmail(email) {
    if (!email) return false;
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
  },

  /**
   * 비밀번호 유효성 검사
   * - 최소 8자 이상
   * - 영문, 숫자 포함
   *
   * @param {string} password - 비밀번호
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isPassword('password123')  // true
   * Validators.isPassword('short')        // false
   */
  isPassword(password) {
    if (!password || password.length < 8) return false;
    // 영문과 숫자 포함
    const hasLetter = /[a-zA-Z]/.test(password);
    const hasNumber = /[0-9]/.test(password);
    return hasLetter && hasNumber;
  },

  /**
   * 필수 입력 확인
   *
   * @param {*} value - 값
   * @returns {boolean} 값이 있는지 여부
   *
   * @example
   * Validators.isRequired('test')  // true
   * Validators.isRequired('')      // false
   * Validators.isRequired(null)    // false
   */
  isRequired(value) {
    if (value === null || value === undefined) return false;
    if (typeof value === 'string') return value.trim().length > 0;
    if (typeof value === 'number') return true;
    if (Array.isArray(value)) return value.length > 0;
    return !!value;
  },

  /**
   * 최소 길이 확인
   *
   * @param {string} value - 문자열
   * @param {number} minLength - 최소 길이
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.minLength('hello', 3)  // true
   * Validators.minLength('hi', 3)     // false
   */
  minLength(value, minLength) {
    if (!value) return false;
    return value.length >= minLength;
  },

  /**
   * 최대 길이 확인
   *
   * @param {string} value - 문자열
   * @param {number} maxLength - 최대 길이
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.maxLength('hello', 10)  // true
   * Validators.maxLength('hello world!', 5)  // false
   */
  maxLength(value, maxLength) {
    if (!value) return true;
    return value.length <= maxLength;
  },

  /**
   * 숫자 범위 확인
   *
   * @param {number} value - 값
   * @param {number} min - 최소값
   * @param {number} max - 최대값
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isInRange(5, 1, 10)   // true
   * Validators.isInRange(15, 1, 10)  // false
   */
  isInRange(value, min, max) {
    if (value === null || value === undefined) return false;
    const num = Number(value);
    if (isNaN(num)) return false;
    return num >= min && num <= max;
  },

  /**
   * 정수 확인
   *
   * @param {*} value - 값
   * @returns {boolean} 정수 여부
   *
   * @example
   * Validators.isInteger(123)    // true
   * Validators.isInteger('123')  // true
   * Validators.isInteger(12.3)   // false
   */
  isInteger(value) {
    if (value === null || value === undefined) return false;
    const num = Number(value);
    return !isNaN(num) && Number.isInteger(num);
  },

  /**
   * 양수 확인
   *
   * @param {*} value - 값
   * @returns {boolean} 양수 여부
   *
   * @example
   * Validators.isPositive(10)   // true
   * Validators.isPositive(-5)   // false
   * Validators.isPositive(0)    // false
   */
  isPositive(value) {
    if (value === null || value === undefined) return false;
    const num = Number(value);
    return !isNaN(num) && num > 0;
  },

  /**
   * URL 유효성 검사
   *
   * @param {string} url - URL
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isURL('https://example.com')  // true
   * Validators.isURL('not a url')            // false
   */
  isURL(url) {
    if (!url) return false;
    try {
      new URL(url);
      return true;
    } catch {
      return false;
    }
  },

  /**
   * 파일 크기 확인
   *
   * @param {File} file - 파일 객체
   * @param {number} maxSize - 최대 크기 (바이트)
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isFileSizeValid(file, 10 * 1024 * 1024)  // 10MB 이하
   */
  isFileSizeValid(file, maxSize) {
    if (!file) return false;
    return file.size <= maxSize;
  },

  /**
   * 파일 확장자 확인
   *
   * @param {File} file - 파일 객체
   * @param {Array<string>} allowedExtensions - 허용된 확장자 배열 (예: ['.jpg', '.png'])
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isFileExtensionValid(file, ['.jpg', '.png'])
   */
  isFileExtensionValid(file, allowedExtensions) {
    if (!file) return false;
    const fileName = file.name.toLowerCase();
    return allowedExtensions.some((ext) => fileName.endsWith(ext.toLowerCase()));
  },

  /**
   * JSON 유효성 검사
   *
   * @param {string} jsonString - JSON 문자열
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isJSON('{"name":"test"}')  // true
   * Validators.isJSON('invalid')          // false
   */
  isJSON(jsonString) {
    if (!jsonString) return false;
    try {
      JSON.parse(jsonString);
      return true;
    } catch {
      return false;
    }
  },

  /**
   * 날짜 유효성 검사
   *
   * @param {string} dateString - 날짜 문자열 (YYYY-MM-DD)
   * @returns {boolean} 유효 여부
   *
   * @example
   * Validators.isDate('2024-01-28')  // true
   * Validators.isDate('invalid')     // false
   */
  isDate(dateString) {
    if (!dateString) return false;
    const date = new Date(dateString);
    return date instanceof Date && !isNaN(date);
  },

  /**
   * 폼 유효성 검사
   * - 여러 필드의 유효성을 한 번에 검사
   *
   * @param {Object} data - 폼 데이터
   * @param {Object} rules - 검증 규칙
   * @returns {Object} 검증 결과 { isValid: boolean, errors: Object }
   *
   * @example
   * const result = Validators.validateForm(
   *   { email: 'test@example.com', password: 'short' },
   *   {
   *     email: { required: true, email: true },
   *     password: { required: true, minLength: 8 }
   *   }
   * );
   * console.log(result.isValid);  // false
   * console.log(result.errors.password);  // '최소 8자 이상 입력해주세요.'
   */
  validateForm(data, rules) {
    const errors = {};
    let isValid = true;

    for (const [field, fieldRules] of Object.entries(rules)) {
      const value = data[field];

      // Required 검사
      if (fieldRules.required && !this.isRequired(value)) {
        errors[field] = '필수 입력 항목입니다.';
        isValid = false;
        continue;
      }

      // 값이 없으면 다른 검증은 스킵
      if (!this.isRequired(value)) continue;

      // Email 검사
      if (fieldRules.email && !this.isEmail(value)) {
        errors[field] = '올바른 이메일 주소를 입력해주세요.';
        isValid = false;
        continue;
      }

      // Password 검사
      if (fieldRules.password && !this.isPassword(value)) {
        errors[field] = '비밀번호는 8자 이상, 영문과 숫자를 포함해야 합니다.';
        isValid = false;
        continue;
      }

      // Min Length 검사
      if (fieldRules.minLength && !this.minLength(value, fieldRules.minLength)) {
        errors[field] = `최소 ${fieldRules.minLength}자 이상 입력해주세요.`;
        isValid = false;
        continue;
      }

      // Max Length 검사
      if (fieldRules.maxLength && !this.maxLength(value, fieldRules.maxLength)) {
        errors[field] = `최대 ${fieldRules.maxLength}자까지 입력 가능합니다.`;
        isValid = false;
        continue;
      }

      // Integer 검사
      if (fieldRules.integer && !this.isInteger(value)) {
        errors[field] = '정수를 입력해주세요.';
        isValid = false;
        continue;
      }

      // Positive 검사
      if (fieldRules.positive && !this.isPositive(value)) {
        errors[field] = '양수를 입력해주세요.';
        isValid = false;
        continue;
      }

      // Range 검사
      if (fieldRules.min !== undefined || fieldRules.max !== undefined) {
        const min = fieldRules.min ?? -Infinity;
        const max = fieldRules.max ?? Infinity;
        if (!this.isInRange(value, min, max)) {
          errors[field] = `${min}에서 ${max} 사이의 값을 입력해주세요.`;
          isValid = false;
          continue;
        }
      }

      // URL 검사
      if (fieldRules.url && !this.isURL(value)) {
        errors[field] = '올바른 URL을 입력해주세요.';
        isValid = false;
        continue;
      }

      // JSON 검사
      if (fieldRules.json && !this.isJSON(value)) {
        errors[field] = '올바른 JSON 형식이 아닙니다.';
        isValid = false;
        continue;
      }
    }

    return { isValid, errors };
  },
};
