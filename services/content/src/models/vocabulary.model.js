const { query } = require('../config/database');
const { getFallbackChain } = require('../middleware/language.middleware');

class Vocabulary {
  /**
   * Get all vocabulary with translations
   * @param {Object} filters - Filter options including language
   * @returns {Array} Vocabulary array with localized content
   */
  static async findAll(filters = {}) {
    const { level, part_of_speech, limit = 100, offset = 0, search, language = 'zh' } = filters;

    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    let sql = `
      SELECT v.id, v.korean, v.hanja,
             COALESCE(vt.translation, v.chinese) as translation,
             COALESCE(vt.pronunciation, v.pinyin) as pronunciation,
             v.part_of_speech,
             v.level, v.similarity_score, v.image_url, v.audio_url_male, v.audio_url_female,
             COALESCE(vt.example_sentence, v.example_sentence_ko) as example_sentence,
             v.frequency_rank, v.created_at,
             COALESCE(vt.language_code, '${language}') as content_language
      FROM vocabulary v
      LEFT JOIN LATERAL (
        SELECT translation, pronunciation, example_sentence, language_code
        FROM vocabulary_translations
        WHERE vocabulary_id = v.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) vt ON true
      WHERE 1=1
    `;

    const params = [];
    let paramCount = 1;

    if (level) {
      sql += ` AND level = $${paramCount}`;
      params.push(level);
      paramCount++;
    }

    if (part_of_speech) {
      sql += ` AND part_of_speech = $${paramCount}`;
      params.push(part_of_speech);
      paramCount++;
    }

    if (search) {
      sql += ` AND (v.korean ILIKE $${paramCount} OR COALESCE(vt.translation, v.chinese) ILIKE $${paramCount})`;
      params.push(`%${search}%`);
      paramCount++;
    }

    sql += ` ORDER BY frequency_rank NULLS LAST, id`;
    sql += ` LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(limit, offset);

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Get vocabulary by ID with translations
   * @param {Number} id - Vocabulary ID
   * @param {String} language - Language code (default: 'zh')
   * @returns {Object|null} Vocabulary object with localized content
   */
  static async findById(id, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT v.id, v.korean, v.hanja,
             COALESCE(vt.translation, v.chinese) as translation,
             COALESCE(vt.pronunciation, v.pinyin) as pronunciation,
             v.part_of_speech,
             v.level, v.similarity_score, v.image_url, v.audio_url_male, v.audio_url_female,
             COALESCE(vt.example_sentence, v.example_sentence_ko) as example_sentence,
             COALESCE(vt.notes, v.notes) as notes,
             v.frequency_rank, v.created_at, v.updated_at,
             COALESCE(vt.language_code, '${language}') as content_language
      FROM vocabulary v
      LEFT JOIN LATERAL (
        SELECT translation, pronunciation, example_sentence, notes, language_code
        FROM vocabulary_translations
        WHERE vocabulary_id = v.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) vt ON true
      WHERE v.id = $1
    `;

    const result = await query(sql, [id]);
    return result.rows[0] || null;
  }

  /**
   * Search vocabulary with translations
   * @param {String} searchTerm - Search term
   * @param {Number} limit - Result limit
   * @param {String} language - Language code (default: 'zh')
   * @returns {Array} Vocabulary array with localized content
   */
  static async search(searchTerm, limit = 20, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT v.id, v.korean, v.hanja,
             COALESCE(vt.translation, v.chinese) as translation,
             COALESCE(vt.pronunciation, v.pinyin) as pronunciation,
             v.part_of_speech, v.level, v.similarity_score,
             COALESCE(vt.language_code, 'zh') as content_language
      FROM vocabulary v
      LEFT JOIN LATERAL (
        SELECT translation, pronunciation, language_code
        FROM vocabulary_translations
        WHERE vocabulary_id = v.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) vt ON true
      WHERE v.korean ILIKE $1 OR COALESCE(vt.translation, v.chinese) ILIKE $1 OR COALESCE(vt.pronunciation, v.pinyin) ILIKE $1
      ORDER BY
        CASE
          WHEN v.korean = $2 THEN 1
          WHEN COALESCE(vt.translation, v.chinese) = $2 THEN 2
          WHEN v.korean ILIKE $1 THEN 3
          WHEN COALESCE(vt.translation, v.chinese) ILIKE $1 THEN 4
          ELSE 5
        END,
        v.frequency_rank NULLS LAST
      LIMIT $3
    `;

    const result = await query(sql, [`%${searchTerm}%`, searchTerm, limit]);
    return result.rows;
  }

  /**
   * Get vocabulary by level with translations
   * @param {Number} level - TOPIK level (1-6)
   * @param {String} language - Language code (default: 'zh')
   * @returns {Array} Vocabulary array with localized content
   */
  static async findByLevel(level, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT v.id, v.korean, v.hanja,
             COALESCE(vt.translation, v.chinese) as translation,
             COALESCE(vt.pronunciation, v.pinyin) as pronunciation,
             v.part_of_speech, v.similarity_score, v.image_url,
             COALESCE(vt.language_code, 'zh') as content_language
      FROM vocabulary v
      LEFT JOIN LATERAL (
        SELECT translation, pronunciation, language_code
        FROM vocabulary_translations
        WHERE vocabulary_id = v.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) vt ON true
      WHERE v.level = $1
      ORDER BY v.frequency_rank NULLS LAST, v.korean
    `;

    const result = await query(sql, [level]);
    return result.rows;
  }

  /**
   * Get high-similarity Hanja words (한자어) with translations
   * @param {Number} minSimilarity - Minimum similarity score (0-1)
   * @param {Number} limit - Result limit
   * @param {String} language - Language code (default: 'zh')
   * @returns {Array} Vocabulary array with localized content
   */
  static async findHighSimilarity(minSimilarity = 0.8, limit = 100, language = 'zh') {
    // Get fallback chain for the requested language
    const fallbackChain = getFallbackChain(language);
    const fallbackList = fallbackChain.map(l => `'${l}'`).join(', ');

    const sql = `
      SELECT v.id, v.korean, v.hanja,
             COALESCE(vt.translation, v.chinese) as translation,
             COALESCE(vt.pronunciation, v.pinyin) as pronunciation,
             v.similarity_score, v.level,
             COALESCE(vt.language_code, 'zh') as content_language
      FROM vocabulary v
      LEFT JOIN LATERAL (
        SELECT translation, pronunciation, language_code
        FROM vocabulary_translations
        WHERE vocabulary_id = v.id
          AND language_code IN (${fallbackList})
        ORDER BY array_position(ARRAY[${fallbackList}]::varchar[], language_code)
        LIMIT 1
      ) vt ON true
      WHERE v.similarity_score >= $1
      ORDER BY v.similarity_score DESC, v.frequency_rank NULLS LAST
      LIMIT $2
    `;

    const result = await query(sql, [minSimilarity, limit]);
    return result.rows;
  }

  /**
   * Get vocabulary statistics
   * @returns {Object} Statistics
   */
  static async getStatistics() {
    const sql = `
      SELECT
        COUNT(*) as total_words,
        COUNT(DISTINCT level) as total_levels,
        COUNT(DISTINCT part_of_speech) as total_pos,
        ROUND(AVG(similarity_score), 2) as avg_similarity,
        COUNT(*) FILTER (WHERE similarity_score >= 0.8) as high_similarity_count
      FROM vocabulary
    `;

    const result = await query(sql);
    return result.rows[0];
  }

  /**
   * Get vocabulary count by level
   * @returns {Array} Count by level
   */
  static async getCountByLevel() {
    const sql = `
      SELECT level, COUNT(*) as count
      FROM vocabulary
      GROUP BY level
      ORDER BY level
    `;

    const result = await query(sql);
    return result.rows;
  }
}

module.exports = Vocabulary;
