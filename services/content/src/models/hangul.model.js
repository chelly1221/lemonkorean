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
      SELECT hc.id, hc.character, hc.character_type, hc.romanization, hc.pronunciation_zh,
             hc.pronunciation_tip_zh, hc.stroke_count, hc.stroke_order_url, hc.audio_url,
             hc.display_order, hc.example_words, hc.mnemonics_zh, hc.status, hc.created_at,
             pg.mouth_shape_url, pg.tongue_position_url, pg.air_flow_description,
             pg.native_comparisons, pg.similar_character_ids
      FROM hangul_characters hc
      LEFT JOIN hangul_pronunciation_guides pg ON hc.id = pg.character_id
      WHERE hc.status = $1
    `;

    const params = [status];
    let paramCount = 2;

    if (character_type) {
      sql += ` AND hc.character_type = $${paramCount}`;
      params.push(character_type);
      paramCount++;
    }

    sql += ` ORDER BY hc.character_type, hc.display_order`;
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
      SELECT hc.id, hc.character, hc.character_type, hc.romanization, hc.pronunciation_zh,
             hc.pronunciation_tip_zh, hc.stroke_count, hc.stroke_order_url, hc.audio_url,
             hc.display_order, hc.example_words, hc.mnemonics_zh, hc.status,
             hc.created_at, hc.updated_at,
             pg.mouth_shape_url, pg.tongue_position_url, pg.air_flow_description,
             pg.native_comparisons, pg.similar_character_ids
      FROM hangul_characters hc
      LEFT JOIN hangul_pronunciation_guides pg ON hc.id = pg.character_id
      WHERE hc.id = $1
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
      SELECT hc.id, hc.character, hc.character_type, hc.romanization, hc.pronunciation_zh,
             hc.pronunciation_tip_zh, hc.stroke_count, hc.stroke_order_url, hc.audio_url,
             hc.display_order, hc.example_words, hc.mnemonics_zh,
             pg.mouth_shape_url, pg.tongue_position_url, pg.air_flow_description,
             pg.native_comparisons, pg.similar_character_ids
      FROM hangul_characters hc
      LEFT JOIN hangul_pronunciation_guides pg ON hc.id = pg.character_id
      WHERE hc.character_type = $1 AND hc.status = 'published'
      ORDER BY hc.display_order
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
      SELECT hc.id, hc.character, hc.character_type, hc.romanization, hc.pronunciation_zh,
             hc.stroke_count, hc.display_order, hc.audio_url,
             pg.mouth_shape_url, pg.tongue_position_url, pg.air_flow_description,
             pg.native_comparisons, pg.similar_character_ids
      FROM hangul_characters hc
      LEFT JOIN hangul_pronunciation_guides pg ON hc.id = pg.character_id
      WHERE hc.status = 'published'
      ORDER BY hc.character_type, hc.display_order
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

  /**
   * Get all pronunciation guides
   * @returns {Array} Pronunciation guides array
   */
  static async getPronunciationGuides() {
    const sql = `
      SELECT pg.*, hc.character, hc.character_type, hc.romanization
      FROM hangul_pronunciation_guides pg
      JOIN hangul_characters hc ON pg.character_id = hc.id
      WHERE hc.status = 'published'
      ORDER BY hc.character_type, hc.display_order
    `;

    const result = await query(sql);
    return result.rows;
  }

  /**
   * Get pronunciation guide by character ID
   * @param {Number} characterId - Character ID
   * @returns {Object|null} Pronunciation guide
   */
  static async getPronunciationGuideByCharacterId(characterId) {
    const sql = `
      SELECT pg.*, hc.character, hc.character_type, hc.romanization,
             hc.pronunciation_zh, hc.pronunciation_tip_zh
      FROM hangul_pronunciation_guides pg
      JOIN hangul_characters hc ON pg.character_id = hc.id
      WHERE pg.character_id = $1
    `;

    const result = await query(sql, [characterId]);
    return result.rows[0] || null;
  }

  /**
   * Get syllable combinations
   * @param {Object} filters - Filter options
   * @returns {Array} Syllables array
   */
  static async getSyllables(filters = {}) {
    const { initial, vowel, final, limit = 100, offset = 0 } = filters;

    let sql = `
      SELECT s.*,
             ic.character as initial_char, ic.romanization as initial_roman,
             vc.character as vowel_char, vc.romanization as vowel_roman,
             fc.character as final_char, fc.romanization as final_roman
      FROM hangul_syllables s
      LEFT JOIN hangul_characters ic ON s.initial_consonant_id = ic.id
      LEFT JOIN hangul_characters vc ON s.vowel_id = vc.id
      LEFT JOIN hangul_characters fc ON s.final_consonant_id = fc.id
      WHERE 1=1
    `;

    const params = [];
    let paramCount = 1;

    if (initial) {
      sql += ` AND s.initial_consonant_id = $${paramCount}`;
      params.push(parseInt(initial));
      paramCount++;
    }

    if (vowel) {
      sql += ` AND s.vowel_id = $${paramCount}`;
      params.push(parseInt(vowel));
      paramCount++;
    }

    if (final === 'none') {
      sql += ` AND s.final_consonant_id IS NULL`;
    } else if (final) {
      sql += ` AND s.final_consonant_id = $${paramCount}`;
      params.push(parseInt(final));
      paramCount++;
    }

    sql += ` ORDER BY s.frequency_rank NULLS LAST, s.id`;
    sql += ` LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(parseInt(limit), parseInt(offset));

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Get similar sound groups for discrimination training
   * @param {String} category - Filter by category (consonant/vowel)
   * @returns {Array} Similar sound groups array
   */
  static async getSimilarSoundGroups(category = null) {
    let sql = `
      SELECT id, group_name, group_name_ko, description, description_ko,
             category, character_ids, difficulty_level, practice_count
      FROM hangul_similar_sound_groups
    `;

    const params = [];

    if (category) {
      sql += ` WHERE category = $1`;
      params.push(category);
    }

    sql += ` ORDER BY difficulty_level, id`;

    const result = await query(sql, params);

    // Fetch character details for each group
    const groups = [];
    for (const group of result.rows) {
      if (group.character_ids && group.character_ids.length > 0) {
        const charSql = `
          SELECT id, character, romanization, pronunciation_zh
          FROM hangul_characters
          WHERE id = ANY($1)
          ORDER BY display_order
        `;
        const charResult = await query(charSql, [group.character_ids]);
        group.characters = charResult.rows;
      } else {
        group.characters = [];
      }
      groups.push(group);
    }

    return groups;
  }

  /**
   * Create or update pronunciation guide (admin)
   * @param {Number} characterId - Character ID
   * @param {Object} data - Guide data
   * @returns {Object} Created/Updated guide
   */
  static async upsertPronunciationGuide(characterId, data) {
    const {
      mouth_shape_url, tongue_position_url, air_flow_description,
      native_comparisons, similar_character_ids
    } = data;

    const sql = `
      INSERT INTO hangul_pronunciation_guides (
        character_id, mouth_shape_url, tongue_position_url,
        air_flow_description, native_comparisons, similar_character_ids
      ) VALUES ($1, $2, $3, $4, $5, $6)
      ON CONFLICT (character_id) DO UPDATE SET
        mouth_shape_url = EXCLUDED.mouth_shape_url,
        tongue_position_url = EXCLUDED.tongue_position_url,
        air_flow_description = EXCLUDED.air_flow_description,
        native_comparisons = EXCLUDED.native_comparisons,
        similar_character_ids = EXCLUDED.similar_character_ids,
        updated_at = CURRENT_TIMESTAMP
      RETURNING *
    `;

    const params = [
      characterId,
      mouth_shape_url || null,
      tongue_position_url || null,
      air_flow_description || '{}',
      native_comparisons || '{}',
      similar_character_ids || null
    ];

    const result = await query(sql, params);
    return result.rows[0];
  }
}

module.exports = Hangul;
