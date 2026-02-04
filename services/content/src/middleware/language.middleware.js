/**
 * ================================================================
 * LANGUAGE MIDDLEWARE
 * ================================================================
 * Extracts and validates language preference from requests.
 * Used for multi-language content support.
 *
 * Priority order:
 * 1. ?language= query parameter
 * 2. Accept-Language header
 * 3. Default: 'ko' (Korean is the primary learning target)
 * ================================================================
 */

// Supported languages for content
const SUPPORTED_LANGUAGES = ['ko', 'en', 'es', 'ja', 'zh', 'zh_TW'];
const DEFAULT_LANGUAGE = 'ko';

/**
 * Parse Accept-Language header to extract preferred language
 * @param {String} acceptLanguage - Accept-Language header value
 * @returns {String|null} - First supported language found or null
 */
const parseAcceptLanguage = (acceptLanguage) => {
  if (!acceptLanguage) return null;

  // Split by comma and parse each language with quality
  const languages = acceptLanguage.split(',').map(lang => {
    const parts = lang.trim().split(';');
    const code = parts[0].trim();
    const quality = parts[1] ? parseFloat(parts[1].replace('q=', '')) : 1.0;
    return { code, quality };
  });

  // Sort by quality (highest first)
  languages.sort((a, b) => b.quality - a.quality);

  // Find first supported language
  for (const lang of languages) {
    // Normalize language codes (e.g., zh-CN -> zh, zh-TW -> zh_TW)
    let normalizedCode = lang.code.toLowerCase();

    // Handle Chinese variants
    if (normalizedCode === 'zh-cn' || normalizedCode === 'zh-hans') {
      normalizedCode = 'zh';
    } else if (normalizedCode === 'zh-tw' || normalizedCode === 'zh-hant') {
      normalizedCode = 'zh_TW';
    } else if (normalizedCode.startsWith('zh')) {
      // Default Chinese to simplified
      normalizedCode = 'zh';
    }

    // Check for exact match
    if (SUPPORTED_LANGUAGES.includes(normalizedCode)) {
      return normalizedCode;
    }

    // Check for language family match (e.g., 'en-US' -> 'en')
    const baseCode = normalizedCode.split('-')[0];
    if (SUPPORTED_LANGUAGES.includes(baseCode)) {
      return baseCode;
    }
  }

  return null;
};

/**
 * Language middleware - Extracts language preference and attaches to request
 *
 * Usage:
 *   router.use(languageMiddleware);
 *
 * Access in controller:
 *   req.language  // 'zh', 'en', 'ko', etc.
 */
const languageMiddleware = (req, res, next) => {
  let language = DEFAULT_LANGUAGE;

  // Priority 1: Query parameter
  if (req.query.language) {
    const queryLang = req.query.language.trim();
    if (SUPPORTED_LANGUAGES.includes(queryLang)) {
      language = queryLang;
    } else {
      console.log(`[LANGUAGE] Invalid language query param: ${queryLang}, using default: ${DEFAULT_LANGUAGE}`);
    }
  }
  // Priority 2: Accept-Language header
  else if (req.headers['accept-language']) {
    const headerLang = parseAcceptLanguage(req.headers['accept-language']);
    if (headerLang) {
      language = headerLang;
    }
  }

  // Attach to request
  req.language = language;

  // Log for debugging (can be removed in production)
  if (process.env.NODE_ENV === 'development') {
    console.log(`[LANGUAGE] Request language: ${language} (query: ${req.query.language || 'none'}, header: ${req.headers['accept-language'] || 'none'})`);
  }

  next();
};

/**
 * Get fallback chain for a language
 * When translation is missing, try languages in this order
 *
 * @param {String} language - Primary language code
 * @returns {Array} - Array of language codes to try in order
 */
const getFallbackChain = (language) => {
  const fallbacks = {
    'en': ['en', 'ko', 'zh'],
    'es': ['es', 'en', 'ko', 'zh'],
    'ja': ['ja', 'ko', 'zh'],
    'zh': ['zh', 'ko'],
    'zh_TW': ['zh_TW', 'zh', 'ko'],
    'ko': ['ko']
  };

  return fallbacks[language] || ['ko', 'zh'];
};

/**
 * Build cache key with language suffix
 * @param {String} baseKey - Base cache key
 * @param {String} language - Language code
 * @returns {String} - Cache key with language suffix
 */
const buildLanguageCacheKey = (baseKey, language) => {
  return `${baseKey}:${language}`;
};

module.exports = {
  languageMiddleware,
  parseAcceptLanguage,
  getFallbackChain,
  buildLanguageCacheKey,
  SUPPORTED_LANGUAGES,
  DEFAULT_LANGUAGE
};
