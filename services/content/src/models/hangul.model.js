const { query } = require('../config/database');

/**
 * ================================================================
 * HANGUL CHARACTER MODEL
 * ================================================================
 * Database operations for Korean alphabet (한글) characters
 * ================================================================
 */

class Hangul {
  /**
   * Get all hangul characters
   * @param {Object} filters - Filter options
   * @returns {Array} Hangul characters array
   */
  static async findAll(filters = {}) {
    const { character_type, status = 'published', limit = 100, offset = 0 } = filters;

    let sql = `
      SELECT id, character, character_type, romanization, pronunciation_zh,
             pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
             display_order, example_words, mnemonics_zh, status, created_at
      FROM hangul_characters
      WHERE status = $1
    `;

    const params = [status];
    let paramCount = 2;

    if (character_type) {
      sql += ` AND character_type = $${paramCount}`;
      params.push(character_type);
      paramCount++;
    }

    sql += ` ORDER BY character_type, display_order`;
    sql += ` LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(limit, offset);

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Get hangul character by ID
   * @param {Number} id - Character ID
   * @returns {Object|null} Hangul character object
   */
  static async findById(id) {
    const sql = `
      SELECT id, character, character_type, romanization, pronunciation_zh,
             pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
             display_order, example_words, mnemonics_zh, status,
             created_at, updated_at
      FROM hangul_characters
      WHERE id = $1
    `;

    const result = await query(sql, [id]);
    return result.rows[0] || null;
  }

  /**
   * Get hangul characters by type
   * @param {String} type - Character type (basic_consonant, double_consonant, basic_vowel, compound_vowel)
   * @returns {Array} Hangul characters array
   */
  static async findByType(type) {
    const sql = `
      SELECT id, character, character_type, romanization, pronunciation_zh,
             pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
             display_order, example_words, mnemonics_zh
      FROM hangul_characters
      WHERE character_type = $1 AND status = 'published'
      ORDER BY display_order
    `;

    const result = await query(sql, [type]);
    return result.rows;
  }

  /**
   * Get full alphabet table organized by type
   * @returns {Object} Alphabet table with types as keys
   */
  static async getAlphabetTable() {
    const sql = `
      SELECT id, character, character_type, romanization, pronunciation_zh,
             stroke_count, display_order, audio_url
      FROM hangul_characters
      WHERE status = 'published'
      ORDER BY character_type, display_order
    `;

    const result = await query(sql);

    // Organize by type
    const table = {
      basic_consonants: [],
      double_consonants: [],
      basic_vowels: [],
      compound_vowels: []
    };

    for (const row of result.rows) {
      switch (row.character_type) {
        case 'basic_consonant':
          table.basic_consonants.push(row);
          break;
        case 'double_consonant':
          table.double_consonants.push(row);
          break;
        case 'basic_vowel':
          table.basic_vowels.push(row);
          break;
        case 'compound_vowel':
          table.compound_vowels.push(row);
          break;
      }
    }

    return table;
  }

  /**
   * Get hangul statistics
   * @returns {Object} Statistics
   */
  static async getStatistics() {
    const sql = `
      SELECT
        COUNT(*) as total_characters,
        COUNT(*) FILTER (WHERE character_type = 'basic_consonant') as basic_consonants,
        COUNT(*) FILTER (WHERE character_type = 'double_consonant') as double_consonants,
        COUNT(*) FILTER (WHERE character_type = 'basic_vowel') as basic_vowels,
        COUNT(*) FILTER (WHERE character_type = 'compound_vowel') as compound_vowels,
        COUNT(*) FILTER (WHERE status = 'published') as published,
        COUNT(*) FILTER (WHERE status = 'draft') as draft
      FROM hangul_characters
    `;

    const result = await query(sql);
    return result.rows[0];
  }

  /**
   * Create a new hangul character (admin)
   * @param {Object} data - Character data
   * @returns {Object} Created character
   */
  static async create(data) {
    const {
      character, character_type, romanization, pronunciation_zh,
      pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
      display_order, example_words, mnemonics_zh, status = 'draft'
    } = data;

    const sql = `
      INSERT INTO hangul_characters (
        character, character_type, romanization, pronunciation_zh,
        pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
        display_order, example_words, mnemonics_zh, status
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      RETURNING *
    `;

    const params = [
      character, character_type, romanization, pronunciation_zh,
      pronunciation_tip_zh || null, stroke_count || 1, stroke_order_url || null,
      audio_url || null, display_order, example_words || '[]',
      mnemonics_zh || null, status
    ];

    const result = await query(sql, params);
    return result.rows[0];
  }

  /**
   * Update a hangul character (admin)
   * @param {Number} id - Character ID
   * @param {Object} data - Update data
   * @returns {Object|null} Updated character
   */
  static async update(id, data) {
    const fields = [];
    const params = [];
    let paramCount = 1;

    const allowedFields = [
      'character', 'character_type', 'romanization', 'pronunciation_zh',
      'pronunciation_tip_zh', 'stroke_count', 'stroke_order_url', 'audio_url',
      'display_order', 'example_words', 'mnemonics_zh', 'status'
    ];

    for (const field of allowedFields) {
      if (data[field] !== undefined) {
        fields.push(`${field} = $${paramCount}`);
        params.push(data[field]);
        paramCount++;
      }
    }

    if (fields.length === 0) {
      return null;
    }

    params.push(id);

    const sql = `
      UPDATE hangul_characters
      SET ${fields.join(', ')}, updated_at = CURRENT_TIMESTAMP
      WHERE id = $${paramCount}
      RETURNING *
    `;

    const result = await query(sql, params);
    return result.rows[0] || null;
  }

  /**
   * Delete a hangul character (admin)
   * @param {Number} id - Character ID
   * @returns {Boolean} Success
   */
  static async delete(id) {
    const sql = 'DELETE FROM hangul_characters WHERE id = $1 RETURNING id';
    const result = await query(sql, [id]);
    return result.rows.length > 0;
  }
}

module.exports = Hangul;
