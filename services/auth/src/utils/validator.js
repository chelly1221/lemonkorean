/**
 * Email validation
 * @param {String} email - Email to validate
 * @returns {Boolean} True if valid
 */
const isValidEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

/**
 * Password validation
 * Rules: At least 6 characters
 * @param {String} password - Password to validate
 * @returns {Object} { valid: Boolean, message: String }
 */
const isValidPassword = (password) => {
  if (!password || password.length < 6) {
    return {
      valid: false,
      message: 'Password must be at least 6 characters long'
    };
  }

  // Optional: Add more complexity requirements
  // if (!/[A-Z]/.test(password)) {
  //   return { valid: false, message: 'Password must contain at least one uppercase letter' };
  // }
  // if (!/[a-z]/.test(password)) {
  //   return { valid: false, message: 'Password must contain at least one lowercase letter' };
  // }
  // if (!/[0-9]/.test(password)) {
  //   return { valid: false, message: 'Password must contain at least one number' };
  // }

  return { valid: true };
};

/**
 * Validate language preference
 * @param {String} lang - Language code
 * @returns {Boolean} True if valid
 */
const isValidLanguage = (lang) => {
  const validLanguages = ['zh', 'en', 'ko'];
  return validLanguages.includes(lang);
};

/**
 * Sanitize string input
 * @param {String} input - Input string
 * @returns {String} Sanitized string
 */
const sanitizeString = (input) => {
  if (typeof input !== 'string') return '';
  return input.trim();
};

/**
 * Validate registration data
 * @param {Object} data - Registration data
 * @returns {Object} { valid: Boolean, errors: Array }
 */
const validateRegistration = (data) => {
  const errors = [];

  // Email validation
  if (!data.email) {
    errors.push('Email is required');
  } else if (!isValidEmail(data.email)) {
    errors.push('Invalid email format');
  }

  // Password validation
  if (!data.password) {
    errors.push('Password is required');
  } else {
    const passwordCheck = isValidPassword(data.password);
    if (!passwordCheck.valid) {
      errors.push(passwordCheck.message);
    }
  }

  // Name validation (optional)
  if (data.name && data.name.length > 100) {
    errors.push('Name must be less than 100 characters');
  }

  // Language validation (optional)
  if (data.language_preference && !isValidLanguage(data.language_preference)) {
    errors.push('Invalid language preference. Must be one of: zh, en, ko');
  }

  return {
    valid: errors.length === 0,
    errors
  };
};

/**
 * Validate login data
 * @param {Object} data - Login data
 * @returns {Object} { valid: Boolean, errors: Array }
 */
const validateLogin = (data) => {
  const errors = [];

  if (!data.email) {
    errors.push('Email is required');
  } else if (!isValidEmail(data.email)) {
    errors.push('Invalid email format');
  }

  if (!data.password) {
    errors.push('Password is required');
  }

  return {
    valid: errors.length === 0,
    errors
  };
};

/**
 * Validate profile update data
 * @param {Object} data - Profile update data
 * @returns {Object} { valid: Boolean, errors: Array }
 */
const validateProfileUpdate = (data) => {
  const errors = [];

  if (data.name !== undefined) {
    if (typeof data.name !== 'string') {
      errors.push('Name must be a string');
    } else if (data.name.length > 100) {
      errors.push('Name must be less than 100 characters');
    }
  }

  if (data.language_preference !== undefined && !isValidLanguage(data.language_preference)) {
    errors.push('Invalid language preference. Must be one of: zh, en, ko');
  }

  return {
    valid: errors.length === 0,
    errors
  };
};

module.exports = {
  isValidEmail,
  isValidPassword,
  isValidLanguage,
  sanitizeString,
  validateRegistration,
  validateLogin,
  validateProfileUpdate
};
