const { query } = require('../config/database');

/**
 * Hangul Characters Controller
 * Handles CRUD operations for Korean alphabet characters
 */

/**
 * List hangul characters with filtering
 * GET /api/admin/hangul
 */
const listCharacters = async (req, res) => {
  try {
    const { type, status, page = 1, limit = 50 } = req.query;

    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 50));
    const offset = (pageNum - 1) * limitNum;

    // Build query
    let sql = `
      SELECT id, character, character_type, romanization, pronunciation_zh,
             pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
             display_order, example_words, mnemonics_zh, status,
             created_at, updated_at
      FROM hangul_characters
      WHERE 1=1
    `;
    const params = [];
    let paramCount = 1;

    if (type) {
      sql += ` AND character_type = $${paramCount}`;
      params.push(type);
      paramCount++;
    }

    if (status) {
      sql += ` AND status = $${paramCount}`;
      params.push(status);
      paramCount++;
    }

    // Count total
    let countSql = sql.replace(/SELECT .* FROM/, 'SELECT COUNT(*) as total FROM');
    const countResult = await query(countSql, params);
    const total = parseInt(countResult.rows[0].total);

    // Add sorting and pagination
    sql += ` ORDER BY character_type, display_order`;
    sql += ` LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(limitNum, offset);

    const result = await query(sql, params);

    res.json({
      success: true,
      data: result.rows,
      pagination: {
        total,
        page: pageNum,
        limit: limitNum,
        total_pages: Math.ceil(total / limitNum),
        has_next: pageNum < Math.ceil(total / limitNum),
        has_prev: pageNum > 1
      }
    });
  } catch (error) {
    console.error('[HANGUL] Error listing characters:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to list hangul characters',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

/**
 * Get hangul character by ID
 * GET /api/admin/hangul/:id
 */
const getCharacterById = async (req, res) => {
  try {
    const { id } = req.params;

    const sql = `
      SELECT id, character, character_type, romanization, pronunciation_zh,
             pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
             display_order, example_words, mnemonics_zh, status,
             created_at, updated_at
      FROM hangul_characters
      WHERE id = $1
    `;

    const result = await query(sql, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Hangul character not found'
      });
    }

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('[HANGUL] Error getting character:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get hangul character',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

/**
 * Create hangul character
 * POST /api/admin/hangul
 */
const createCharacter = async (req, res) => {
  try {
    const {
      character, character_type, romanization, pronunciation_zh,
      pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
      display_order, example_words, mnemonics_zh, status
    } = req.body;

    // Validate required fields
    if (!character || !character_type || !romanization || !pronunciation_zh || display_order === undefined) {
      return res.status(400).json({
        success: false,
        error: 'Missing required fields: character, character_type, romanization, pronunciation_zh, display_order'
      });
    }

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
      mnemonics_zh || null, status || 'draft'
    ];

    const result = await query(sql, params);

    console.log(`[HANGUL] Created character: ${character}`);

    res.status(201).json({
      success: true,
      data: result.rows[0],
      message: 'Hangul character created successfully'
    });
  } catch (error) {
    console.error('[HANGUL] Error creating character:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create hangul character',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

/**
 * Update hangul character
 * PUT /api/admin/hangul/:id
 */
const updateCharacter = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      character, character_type, romanization, pronunciation_zh,
      pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
      display_order, example_words, mnemonics_zh, status
    } = req.body;

    // Build update query dynamically
    const fields = [];
    const params = [];
    let paramCount = 1;

    const allowedFields = {
      character, character_type, romanization, pronunciation_zh,
      pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
      display_order, example_words, mnemonics_zh, status
    };

    for (const [field, value] of Object.entries(allowedFields)) {
      if (value !== undefined) {
        fields.push(`${field} = $${paramCount}`);
        params.push(value);
        paramCount++;
      }
    }

    if (fields.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'No fields to update'
      });
    }

    params.push(id);

    const sql = `
      UPDATE hangul_characters
      SET ${fields.join(', ')}, updated_at = CURRENT_TIMESTAMP
      WHERE id = $${paramCount}
      RETURNING *
    `;

    const result = await query(sql, params);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Hangul character not found'
      });
    }

    console.log(`[HANGUL] Updated character ID ${id}`);

    res.json({
      success: true,
      data: result.rows[0],
      message: 'Hangul character updated successfully'
    });
  } catch (error) {
    console.error('[HANGUL] Error updating character:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update hangul character',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

/**
 * Delete hangul character
 * DELETE /api/admin/hangul/:id
 */
const deleteCharacter = async (req, res) => {
  try {
    const { id } = req.params;

    const sql = 'DELETE FROM hangul_characters WHERE id = $1 RETURNING id, character';
    const result = await query(sql, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Hangul character not found'
      });
    }

    console.log(`[HANGUL] Deleted character: ${result.rows[0].character}`);

    res.json({
      success: true,
      message: 'Hangul character deleted successfully'
    });
  } catch (error) {
    console.error('[HANGUL] Error deleting character:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete hangul character',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

/**
 * Get hangul statistics
 * GET /api/admin/hangul/stats
 */
const getStats = async (req, res) => {
  try {
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

    res.json({
      success: true,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('[HANGUL] Error getting stats:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to get hangul statistics',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

/**
 * Bulk seed initial hangul data
 * POST /api/admin/hangul/bulk
 */
const bulkSeed = async (req, res) => {
  try {
    const { characters } = req.body;

    if (!Array.isArray(characters) || characters.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'characters must be a non-empty array'
      });
    }

    let successCount = 0;
    let errorCount = 0;
    const errors = [];

    for (const char of characters) {
      try {
        const sql = `
          INSERT INTO hangul_characters (
            character, character_type, romanization, pronunciation_zh,
            pronunciation_tip_zh, stroke_count, stroke_order_url, audio_url,
            display_order, example_words, mnemonics_zh, status
          ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
          ON CONFLICT (character, character_type) DO UPDATE SET
            romanization = EXCLUDED.romanization,
            pronunciation_zh = EXCLUDED.pronunciation_zh,
            pronunciation_tip_zh = EXCLUDED.pronunciation_tip_zh,
            stroke_count = EXCLUDED.stroke_count,
            example_words = EXCLUDED.example_words,
            mnemonics_zh = EXCLUDED.mnemonics_zh,
            updated_at = CURRENT_TIMESTAMP
          RETURNING id
        `;

        const params = [
          char.character, char.character_type, char.romanization, char.pronunciation_zh,
          char.pronunciation_tip_zh || null, char.stroke_count || 1, char.stroke_order_url || null,
          char.audio_url || null, char.display_order, char.example_words || '[]',
          char.mnemonics_zh || null, char.status || 'published'
        ];

        await query(sql, params);
        successCount++;
      } catch (error) {
        errorCount++;
        errors.push({
          character: char.character,
          error: error.message
        });
      }
    }

    console.log(`[HANGUL] Bulk seed: ${successCount} success, ${errorCount} errors`);

    res.json({
      success: true,
      data: {
        total: characters.length,
        success: successCount,
        errors: errorCount
      },
      errors: errors.length > 0 ? errors : undefined
    });
  } catch (error) {
    console.error('[HANGUL] Error bulk seeding:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to bulk seed hangul characters',
      details: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
};

module.exports = {
  listCharacters,
  getCharacterById,
  createCharacter,
  updateCharacter,
  deleteCharacter,
  getStats,
  bulkSeed
};
