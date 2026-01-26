const { query } = require('../config/database');

/**
 * Vocabulary Model - Admin Service
 * CRUD operations for vocabulary management
 */

/**
 * Get all vocabulary with filtering and pagination
 * @param {Object} options - Query options
 * @returns {Object} Paginated vocabulary
 */
const getAll = async (options = {}) => {
  try {
    const {
      page = 1,
      limit = 50,
      search = '',
      sortBy = 'id',
      sortOrder = 'ASC'
    } = options;

    const offset = (page - 1) * limit;

    // Build WHERE clause
    const conditions = [];
    const params = [];
    let paramIndex = 1;

    if (search) {
      conditions.push(`(korean ILIKE $${paramIndex} OR chinese ILIKE $${paramIndex} OR hanja ILIKE $${paramIndex})`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    // Validate sort column
    const allowedSortColumns = ['id', 'korean', 'chinese', 'similarity_score', 'created_at'];
    const validSortBy = allowedSortColumns.includes(sortBy) ? sortBy : 'id';
    const validSortOrder = sortOrder.toUpperCase() === 'DESC' ? 'DESC' : 'ASC';

    // Get total count
    const countResult = await query(
      `SELECT COUNT(*) as total FROM vocabulary ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].total);

    // Get vocabulary
    const vocabResult = await query(
      `SELECT
        id,
        korean,
        hanja,
        chinese,
        pinyin,
        part_of_speech,
        level,
        similarity_score,
        image_url,
        audio_url_male,
        audio_url_female,
        example_sentence_ko,
        example_sentence_zh,
        notes,
        frequency_rank,
        created_at,
        updated_at
      FROM vocabulary
      ${whereClause}
      ORDER BY ${validSortBy} ${validSortOrder}
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`,
      [...params, limit, offset]
    );

    return {
      vocabulary: vocabResult.rows,
      total,
      page: parseInt(page),
      limit: parseInt(limit),
      totalPages: Math.ceil(total / limit)
    };
  } catch (error) {
    console.error('[VOCABULARY_MODEL] Error getting vocabulary:', error);
    throw error;
  }
};

/**
 * Get vocabulary by ID
 * @param {number} vocabId - Vocabulary ID
 * @returns {Object|null} Vocabulary entry
 */
const findById = async (vocabId) => {
  try {
    const result = await query(
      `SELECT
        id,
        korean,
        hanja,
        chinese,
        pinyin,
        part_of_speech,
        level,
        similarity_score,
        image_url,
        audio_url_male,
        audio_url_female,
        example_sentence_ko,
        example_sentence_zh,
        notes,
        frequency_rank,
        created_at,
        updated_at
      FROM vocabulary
      WHERE id = $1`,
      [vocabId]
    );

    if (result.rows.length === 0) {
      return null;
    }

    return result.rows[0];
  } catch (error) {
    console.error('[VOCABULARY_MODEL] Error finding vocabulary by ID:', error);
    throw error;
  }
};

/**
 * Create new vocabulary entry
 * @param {Object} vocabData - Vocabulary data
 * @returns {Object} Created vocabulary
 */
const create = async (vocabData) => {
  try {
    const {
      korean,
      hanja = null,
      chinese,
      pinyin = null,
      part_of_speech = 'noun',
      level = null,
      similarity_score = 0,
      image_url = null,
      audio_url_male = null,
      audio_url_female = null,
      example_sentence_ko = null,
      example_sentence_zh = null,
      notes = null,
      frequency_rank = null
    } = vocabData;

    const result = await query(
      `INSERT INTO vocabulary
       (korean, hanja, chinese, pinyin, part_of_speech, level, similarity_score,
        image_url, audio_url_male, audio_url_female, example_sentence_ko, example_sentence_zh, notes, frequency_rank)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
       RETURNING *`,
      [korean, hanja, chinese, pinyin, part_of_speech, level, similarity_score,
       image_url, audio_url_male, audio_url_female, example_sentence_ko, example_sentence_zh, notes, frequency_rank]
    );

    return result.rows[0];
  } catch (error) {
    console.error('[VOCABULARY_MODEL] Error creating vocabulary:', error);
    throw error;
  }
};

/**
 * Update vocabulary
 * @param {number} vocabId - Vocabulary ID
 * @param {Object} updates - Fields to update
 * @returns {Object} Updated vocabulary
 */
const update = async (vocabId, updates) => {
  try {
    const allowedFields = [
      'korean',
      'hanja',
      'chinese',
      'pinyin',
      'part_of_speech',
      'level',
      'similarity_score',
      'image_url',
      'audio_url_male',
      'audio_url_female',
      'example_sentence_ko',
      'example_sentence_zh',
      'notes',
      'frequency_rank'
    ];

    const updateFields = [];
    const params = [];
    let paramIndex = 1;

    Object.keys(updates).forEach((key) => {
      if (allowedFields.includes(key)) {
        updateFields.push(`${key} = $${paramIndex}`);
        params.push(updates[key]);
        paramIndex++;
      }
    });

    if (updateFields.length === 0) {
      throw new Error('No valid fields to update');
    }

    updateFields.push(`updated_at = CURRENT_TIMESTAMP`);
    params.push(vocabId);

    const result = await query(
      `UPDATE vocabulary
       SET ${updateFields.join(', ')}
       WHERE id = $${paramIndex}
       RETURNING *`,
      params
    );

    if (result.rows.length === 0) {
      throw new Error('Vocabulary not found');
    }

    return result.rows[0];
  } catch (error) {
    console.error('[VOCABULARY_MODEL] Error updating vocabulary:', error);
    throw error;
  }
};

/**
 * Delete vocabulary
 * @param {number} vocabId - Vocabulary ID
 * @returns {boolean} Success
 */
const deleteVocabulary = async (vocabId) => {
  try {
    const result = await query(
      `DELETE FROM vocabulary WHERE id = $1 RETURNING id`,
      [vocabId]
    );

    if (result.rows.length === 0) {
      throw new Error('Vocabulary not found');
    }

    return true;
  } catch (error) {
    console.error('[VOCABULARY_MODEL] Error deleting vocabulary:', error);
    throw error;
  }
};

/**
 * Bulk delete vocabulary
 * @param {Array<number>} vocabIds - Vocabulary IDs to delete
 * @returns {number} Number of vocabulary entries deleted
 */
const bulkDelete = async (vocabIds) => {
  try {
    const result = await query(
      `DELETE FROM vocabulary
       WHERE id = ANY($1)
       RETURNING id`,
      [vocabIds]
    );

    return result.rows.length;
  } catch (error) {
    console.error('[VOCABULARY_MODEL] Error bulk deleting vocabulary:', error);
    throw error;
  }
};

module.exports = {
  getAll,
  findById,
  create,
  update,
  deleteVocabulary,
  bulkDelete
};
