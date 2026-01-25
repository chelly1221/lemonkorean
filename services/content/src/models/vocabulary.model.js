const { query } = require('../config/database');

class Vocabulary {
  /**
   * Get all vocabulary
   * @param {Object} filters - Filter options
   * @returns {Array} Vocabulary array
   */
  static async findAll(filters = {}) {
    const { level, part_of_speech, limit = 100, offset = 0, search } = filters;

    let sql = `
      SELECT id, korean, hanja, chinese, pinyin, part_of_speech,
             level, similarity_score, image_url, audio_url_male, audio_url_female,
             example_sentence_ko, example_sentence_zh, frequency_rank, created_at
      FROM vocabulary
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
      sql += ` AND (korean ILIKE $${paramCount} OR chinese ILIKE $${paramCount})`;
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
   * Get vocabulary by ID
   * @param {Number} id - Vocabulary ID
   * @returns {Object|null} Vocabulary object
   */
  static async findById(id) {
    const sql = `
      SELECT id, korean, hanja, chinese, pinyin, part_of_speech,
             level, similarity_score, image_url, audio_url_male, audio_url_female,
             example_sentence_ko, example_sentence_zh, notes, frequency_rank,
             created_at, updated_at
      FROM vocabulary
      WHERE id = $1
    `;

    const result = await query(sql, [id]);
    return result.rows[0] || null;
  }

  /**
   * Search vocabulary
   * @param {String} searchTerm - Search term
   * @param {Number} limit - Result limit
   * @returns {Array} Vocabulary array
   */
  static async search(searchTerm, limit = 20) {
    const sql = `
      SELECT id, korean, hanja, chinese, pinyin, part_of_speech,
             level, similarity_score
      FROM vocabulary
      WHERE korean ILIKE $1 OR chinese ILIKE $1 OR pinyin ILIKE $1
      ORDER BY
        CASE
          WHEN korean = $2 THEN 1
          WHEN chinese = $2 THEN 2
          WHEN korean ILIKE $1 THEN 3
          WHEN chinese ILIKE $1 THEN 4
          ELSE 5
        END,
        frequency_rank NULLS LAST
      LIMIT $3
    `;

    const result = await query(sql, [`%${searchTerm}%`, searchTerm, limit]);
    return result.rows;
  }

  /**
   * Get vocabulary by level
   * @param {Number} level - TOPIK level (1-6)
   * @returns {Array} Vocabulary array
   */
  static async findByLevel(level) {
    const sql = `
      SELECT id, korean, hanja, chinese, pinyin, part_of_speech,
             similarity_score, image_url
      FROM vocabulary
      WHERE level = $1
      ORDER BY frequency_rank NULLS LAST, korean
    `;

    const result = await query(sql, [level]);
    return result.rows;
  }

  /**
   * Get high-similarity Hanja words (한자어)
   * @param {Number} minSimilarity - Minimum similarity score (0-1)
   * @param {Number} limit - Result limit
   * @returns {Array} Vocabulary array
   */
  static async findHighSimilarity(minSimilarity = 0.8, limit = 100) {
    const sql = `
      SELECT id, korean, hanja, chinese, pinyin, similarity_score, level
      FROM vocabulary
      WHERE similarity_score >= $1
      ORDER BY similarity_score DESC, frequency_rank NULLS LAST
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
