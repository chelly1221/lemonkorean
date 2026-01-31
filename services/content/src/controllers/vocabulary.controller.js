const Vocabulary = require('../models/vocabulary.model');
const { cacheHelpers } = require('../config/redis');

/**
 * ================================================================
 * VOCABULARY CONTROLLER
 * ================================================================
 * Handles vocabulary endpoints for Korean-Chinese word mappings
 * Features: Search, filtering by level/POS, Hanja similarity
 * ================================================================
 */

/**
 * Helper: Build pagination metadata
 */
const buildPaginationMeta = (total, page, limit) => {
  const totalPages = Math.ceil(total / limit);
  return {
    total,
    page,
    limit,
    total_pages: totalPages,
    has_next: page < totalPages,
    has_prev: page > 1
  };
};

/**
 * ================================================================
 * GET /api/content/vocabulary
 * ================================================================
 * Get all vocabulary with filtering and pagination
 * @query level - Filter by TOPIK level (0-6)
 * @query part_of_speech - Filter by POS (noun, verb, adjective, etc.)
 * @query search - Search in Korean/Chinese/Pinyin
 * @query page - Page number (default: 1)
 * @query limit - Items per page (default: 50, max: 100)
 */
const getVocabulary = async (req, res) => {
  try {
    console.log('[VOCABULARY] GET /api/content/vocabulary', req.query);

    const { level, part_of_speech, search, page = 1, limit = 50 } = req.query;

    // Validate pagination
    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 50));
    const offset = (pageNum - 1) * limitNum;

    // Validate level
    if (level !== undefined) {
      const levelNum = parseInt(level);
      if (isNaN(levelNum) || levelNum < 0 || levelNum > 6) {
        return res.status(400).json({
          success: false,
          error: 'Level must be between 0 and 6'
        });
      }
    }

    // Build cache key
    const cacheKey = `vocabulary:list:${level||'all'}:${part_of_speech||'all'}:${search||'none'}:${pageNum}:${limitNum}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[VOCABULARY] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Get total count for pagination
    let countSql = 'SELECT COUNT(*) as total FROM vocabulary WHERE 1=1';
    const countParams = [];
    let paramCount = 1;

    if (level !== undefined) {
      countSql += ` AND level = $${paramCount}`;
      countParams.push(parseInt(level));
      paramCount++;
    }

    if (part_of_speech) {
      countSql += ` AND part_of_speech = $${paramCount}`;
      countParams.push(part_of_speech);
      paramCount++;
    }

    if (search) {
      countSql += ` AND (korean ILIKE $${paramCount} OR chinese ILIKE $${paramCount})`;
      countParams.push(`%${search}%`);
      paramCount++;
    }

    const { query } = require('../config/database');
    const countResult = await query(countSql, countParams);
    const total = parseInt(countResult.rows[0].total);

    // Fetch vocabulary
    const vocabulary = await Vocabulary.findAll({
      level: level ? parseInt(level) : undefined,
      part_of_speech,
      search,
      limit: limitNum,
      offset
    });

    const response = {
      vocabulary,
      pagination: buildPaginationMeta(total, pageNum, limitNum)
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[VOCABULARY] Returned ${vocabulary.length} items (page ${pageNum}/${response.pagination.total_pages})`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[VOCABULARY] Error in getVocabulary:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/vocabulary/:id
 * ================================================================
 * Get vocabulary by ID
 */
const getVocabularyById = async (req, res) => {
  try {
    const vocabId = parseInt(req.params.id);
    console.log('[VOCABULARY] GET /api/content/vocabulary/:id', vocabId);

    // Validate ID
    if (isNaN(vocabId) || vocabId < 1) {
      return res.status(400).json({
        success: false,
        error: 'Invalid vocabulary ID'
      });
    }

    // Check cache
    const cacheKey = `vocabulary:${vocabId}`;
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[VOCABULARY] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        vocabulary: cached
      });
    }

    // Fetch from database
    const vocabulary = await Vocabulary.findById(vocabId);

    if (!vocabulary) {
      return res.status(404).json({
        success: false,
        error: 'Vocabulary not found'
      });
    }

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, vocabulary, 3600);

    console.log('[VOCABULARY] Found:', vocabulary.korean, '-', vocabulary.chinese);

    res.json({
      success: true,
      vocabulary
    });

  } catch (error) {
    console.error('[VOCABULARY] Error in getVocabularyById:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/vocabulary/search
 * ================================================================
 * Search vocabulary by Korean/Chinese/Pinyin
 * @query q - Search term (required)
 * @query limit - Result limit (default: 20, max: 100)
 */
const searchVocabulary = async (req, res) => {
  try {
    const { q: searchTerm, limit = 20 } = req.query;
    console.log('[VOCABULARY] GET /api/content/vocabulary/search', { searchTerm, limit });

    // Validate search term
    if (!searchTerm || searchTerm.trim().length === 0) {
      return res.status(400).json({
        success: false,
        error: 'Search term is required (query parameter: q)'
      });
    }

    // Validate limit
    const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 20));

    // Build cache key
    const cacheKey = `vocabulary:search:${searchTerm.trim()}:${limitNum}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[VOCABULARY] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Search in database
    const results = await Vocabulary.search(searchTerm.trim(), limitNum);

    const response = {
      search_term: searchTerm.trim(),
      results,
      count: results.length
    };

    // Cache for 30 minutes (shorter than regular queries)
    await cacheHelpers.set(cacheKey, response, 1800);

    console.log(`[VOCABULARY] Search "${searchTerm}" returned ${results.length} results`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[VOCABULARY] Error in searchVocabulary:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to search vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/vocabulary/stats
 * ================================================================
 * Get vocabulary statistics
 */
const getVocabularyStats = async (req, res) => {
  try {
    console.log('[VOCABULARY] GET /api/content/vocabulary/stats');

    const cacheKey = 'vocabulary:stats';

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[VOCABULARY] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        stats: cached
      });
    }

    // Get statistics
    const generalStats = await Vocabulary.getStatistics();
    const countByLevel = await Vocabulary.getCountByLevel();

    const stats = {
      ...generalStats,
      by_level: countByLevel
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, stats, 3600);

    console.log('[VOCABULARY] Stats:', generalStats);

    res.json({
      success: true,
      stats
    });

  } catch (error) {
    console.error('[VOCABULARY] Error in getVocabularyStats:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch vocabulary statistics',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/vocabulary/level/:level
 * ================================================================
 * Get vocabulary by TOPIK level
 */
const getVocabularyByLevel = async (req, res) => {
  try {
    const level = parseInt(req.params.level);
    console.log('[VOCABULARY] GET /api/content/vocabulary/level/:level', level);

    // Validate level
    if (isNaN(level) || level < 0 || level > 6) {
      return res.status(400).json({
        success: false,
        error: 'Level must be between 0 and 6'
      });
    }

    const cacheKey = `vocabulary:level:${level}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[VOCABULARY] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch from database
    const vocabulary = await Vocabulary.findByLevel(level);

    const response = {
      level,
      count: vocabulary.length,
      vocabulary
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[VOCABULARY] Level ${level} has ${vocabulary.length} words`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[VOCABULARY] Error in getVocabularyByLevel:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch vocabulary by level',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/vocabulary/high-similarity
 * ================================================================
 * Get vocabulary with high Hanja similarity
 * @query min_similarity - Minimum similarity score (default: 0.8)
 * @query limit - Result limit (default: 100, max: 500)
 */
const getHighSimilarityVocabulary = async (req, res) => {
  try {
    const { min_similarity = 0.8, limit = 100 } = req.query;
    console.log('[VOCABULARY] GET /api/content/vocabulary/high-similarity', { min_similarity, limit });

    // Validate min_similarity
    const minSimilarity = parseFloat(min_similarity);
    if (isNaN(minSimilarity) || minSimilarity < 0 || minSimilarity > 1) {
      return res.status(400).json({
        success: false,
        error: 'min_similarity must be between 0 and 1'
      });
    }

    // Validate limit
    const limitNum = Math.min(500, Math.max(1, parseInt(limit) || 100));

    const cacheKey = `vocabulary:high-similarity:${minSimilarity}:${limitNum}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[VOCABULARY] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch from database
    const vocabulary = await Vocabulary.findHighSimilarity(minSimilarity, limitNum);

    const response = {
      min_similarity: minSimilarity,
      count: vocabulary.length,
      vocabulary
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[VOCABULARY] High similarity (>=${minSimilarity}) found ${vocabulary.length} words`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[VOCABULARY] Error in getHighSimilarityVocabulary:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch high similarity vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * BOOKMARK ENDPOINTS
 * ================================================================
 * User bookmark management for vocabulary items
 * ================================================================
 */

/**
 * ================================================================
 * POST /api/content/vocabulary/bookmarks
 * ================================================================
 * Create a new vocabulary bookmark
 * @body vocabulary_id - ID of vocabulary to bookmark (required)
 * @body notes - Personal notes (optional)
 */
const createBookmark = async (req, res) => {
  try {
    const userId = req.user.id; // From JWT middleware
    const { vocabulary_id, notes } = req.body;
    console.log('[BOOKMARK] POST /api/content/vocabulary/bookmarks', { userId, vocabulary_id, notes });

    // Validate vocabulary_id
    if (!vocabulary_id || isNaN(parseInt(vocabulary_id))) {
      return res.status(400).json({
        success: false,
        error: 'vocabulary_id is required and must be a number'
      });
    }

    const vocabId = parseInt(vocabulary_id);

    // Check if vocabulary exists
    const vocabulary = await Vocabulary.findById(vocabId);
    if (!vocabulary) {
      return res.status(404).json({
        success: false,
        error: 'Vocabulary not found'
      });
    }

    // Create bookmark
    const { query } = require('../config/database');
    const insertSql = `
      INSERT INTO user_bookmarks (user_id, resource_type, resource_id, notes)
      VALUES ($1, 'vocabulary', $2, $3)
      ON CONFLICT (user_id, resource_type, resource_id) DO UPDATE
      SET notes = EXCLUDED.notes, created_at = NOW()
      RETURNING *
    `;

    const result = await query(insertSql, [userId, vocabId, notes || null]);
    const bookmark = result.rows[0];

    // Invalidate cache
    const cacheKey = `bookmarks:user:${userId}`;
    await cacheHelpers.del(cacheKey);

    console.log('[BOOKMARK] Created bookmark:', bookmark.id);

    res.status(201).json({
      success: true,
      bookmark: {
        id: bookmark.id,
        vocabulary_id: bookmark.resource_id,
        notes: bookmark.notes,
        created_at: bookmark.created_at
      }
    });

  } catch (error) {
    console.error('[BOOKMARK] Error in createBookmark:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create bookmark',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/vocabulary/bookmarks
 * ================================================================
 * Get user's bookmarks with full vocabulary data
 * @query page - Page number (default: 1)
 * @query limit - Items per page (default: 20, max: 100)
 */
const getUserBookmarks = async (req, res) => {
  try {
    const userId = req.user.id;
    const { page = 1, limit = 20 } = req.query;
    console.log('[BOOKMARK] GET /api/content/vocabulary/bookmarks', { userId, page, limit });

    // Validate pagination
    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 20));
    const offset = (pageNum - 1) * limitNum;

    // Build cache key
    const cacheKey = `bookmarks:user:${userId}:${pageNum}:${limitNum}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[BOOKMARK] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Get total count
    const { query } = require('../config/database');
    const countSql = `
      SELECT COUNT(*) as total
      FROM user_bookmarks
      WHERE user_id = $1 AND resource_type = 'vocabulary'
    `;
    const countResult = await query(countSql, [userId]);
    const total = parseInt(countResult.rows[0].total);

    // Fetch bookmarks with JOIN to vocabulary and vocabulary_progress
    const bookmarksSql = `
      SELECT
        ub.id as bookmark_id,
        ub.notes,
        ub.created_at as bookmarked_at,
        v.*,
        vp.mastery_level,
        vp.next_review,
        vp.ease_factor,
        vp.interval_days
      FROM user_bookmarks ub
      JOIN vocabulary v ON ub.resource_id = v.id
      LEFT JOIN vocabulary_progress vp ON (vp.user_id = ub.user_id AND vp.vocab_id = v.id)
      WHERE ub.user_id = $1 AND ub.resource_type = 'vocabulary'
      ORDER BY ub.created_at DESC
      LIMIT $2 OFFSET $3
    `;

    const bookmarksResult = await query(bookmarksSql, [userId, limitNum, offset]);
    const bookmarks = bookmarksResult.rows.map(row => ({
      bookmark_id: row.bookmark_id,
      notes: row.notes,
      bookmarked_at: row.bookmarked_at,
      vocabulary: {
        id: row.id,
        korean: row.korean,
        hanja: row.hanja,
        chinese: row.chinese,
        pinyin: row.pinyin,
        part_of_speech: row.part_of_speech,
        level: row.level,
        similarity_score: row.similarity_score,
        image_url: row.image_url,
        audio_url_male: row.audio_url_male,
        audio_url_female: row.audio_url_female,
        example_sentence_ko: row.example_sentence_ko,
        example_sentence_zh: row.example_sentence_zh,
        frequency_rank: row.frequency_rank
      },
      progress: row.mastery_level !== null ? {
        mastery_level: row.mastery_level,
        next_review: row.next_review,
        ease_factor: row.ease_factor,
        interval_days: row.interval_days
      } : null
    }));

    const response = {
      bookmarks,
      pagination: buildPaginationMeta(total, pageNum, limitNum)
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[BOOKMARK] Returned ${bookmarks.length} bookmarks (page ${pageNum}/${response.pagination.total_pages})`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[BOOKMARK] Error in getUserBookmarks:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch bookmarks',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/vocabulary/bookmarks/:id
 * ================================================================
 * Get single bookmark by ID
 */
const getBookmark = async (req, res) => {
  try {
    const userId = req.user.id;
    const bookmarkId = parseInt(req.params.id);
    console.log('[BOOKMARK] GET /api/content/vocabulary/bookmarks/:id', { userId, bookmarkId });

    // Validate ID
    if (isNaN(bookmarkId) || bookmarkId < 1) {
      return res.status(400).json({
        success: false,
        error: 'Invalid bookmark ID'
      });
    }

    // Fetch bookmark with vocabulary data
    const { query } = require('../config/database');
    const bookmarkSql = `
      SELECT
        ub.id as bookmark_id,
        ub.notes,
        ub.created_at as bookmarked_at,
        v.*
      FROM user_bookmarks ub
      JOIN vocabulary v ON ub.resource_id = v.id
      WHERE ub.id = $1 AND ub.user_id = $2 AND ub.resource_type = 'vocabulary'
    `;

    const result = await query(bookmarkSql, [bookmarkId, userId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Bookmark not found'
      });
    }

    const row = result.rows[0];
    const bookmark = {
      bookmark_id: row.bookmark_id,
      notes: row.notes,
      bookmarked_at: row.bookmarked_at,
      vocabulary: {
        id: row.id,
        korean: row.korean,
        hanja: row.hanja,
        chinese: row.chinese,
        pinyin: row.pinyin,
        part_of_speech: row.part_of_speech,
        level: row.level,
        similarity_score: row.similarity_score,
        image_url: row.image_url,
        audio_url_male: row.audio_url_male,
        audio_url_female: row.audio_url_female,
        example_sentence_ko: row.example_sentence_ko,
        example_sentence_zh: row.example_sentence_zh
      }
    };

    console.log('[BOOKMARK] Found bookmark:', bookmark.bookmark_id);

    res.json({
      success: true,
      bookmark
    });

  } catch (error) {
    console.error('[BOOKMARK] Error in getBookmark:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch bookmark',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * PUT /api/content/vocabulary/bookmarks/:id
 * ================================================================
 * Update bookmark notes
 * @body notes - New notes text
 */
const updateBookmarkNotes = async (req, res) => {
  try {
    const userId = req.user.id;
    const bookmarkId = parseInt(req.params.id);
    const { notes } = req.body;
    console.log('[BOOKMARK] PUT /api/content/vocabulary/bookmarks/:id', { userId, bookmarkId, notes });

    // Validate ID
    if (isNaN(bookmarkId) || bookmarkId < 1) {
      return res.status(400).json({
        success: false,
        error: 'Invalid bookmark ID'
      });
    }

    // Update bookmark
    const { query } = require('../config/database');
    const updateSql = `
      UPDATE user_bookmarks
      SET notes = $1
      WHERE id = $2 AND user_id = $3 AND resource_type = 'vocabulary'
      RETURNING *
    `;

    const result = await query(updateSql, [notes || null, bookmarkId, userId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Bookmark not found or unauthorized'
      });
    }

    const bookmark = result.rows[0];

    // Invalidate cache
    const cacheKey = `bookmarks:user:${userId}`;
    await cacheHelpers.del(cacheKey);

    console.log('[BOOKMARK] Updated bookmark:', bookmark.id);

    res.json({
      success: true,
      bookmark: {
        id: bookmark.id,
        vocabulary_id: bookmark.resource_id,
        notes: bookmark.notes,
        created_at: bookmark.created_at
      }
    });

  } catch (error) {
    console.error('[BOOKMARK] Error in updateBookmarkNotes:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to update bookmark',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * DELETE /api/content/vocabulary/bookmarks/:id
 * ================================================================
 * Delete bookmark
 */
const deleteBookmark = async (req, res) => {
  try {
    const userId = req.user.id;
    const bookmarkId = parseInt(req.params.id);
    console.log('[BOOKMARK] DELETE /api/content/vocabulary/bookmarks/:id', { userId, bookmarkId });

    // Validate ID
    if (isNaN(bookmarkId) || bookmarkId < 1) {
      return res.status(400).json({
        success: false,
        error: 'Invalid bookmark ID'
      });
    }

    // Delete bookmark
    const { query } = require('../config/database');
    const deleteSql = `
      DELETE FROM user_bookmarks
      WHERE id = $1 AND user_id = $2 AND resource_type = 'vocabulary'
      RETURNING id
    `;

    const result = await query(deleteSql, [bookmarkId, userId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Bookmark not found or unauthorized'
      });
    }

    // Invalidate cache
    const cacheKey = `bookmarks:user:${userId}`;
    await cacheHelpers.del(cacheKey);

    console.log('[BOOKMARK] Deleted bookmark:', bookmarkId);

    res.json({
      success: true,
      message: 'Bookmark deleted successfully'
    });

  } catch (error) {
    console.error('[BOOKMARK] Error in deleteBookmark:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to delete bookmark',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * POST /api/content/vocabulary/bookmarks/batch
 * ================================================================
 * Create multiple bookmarks at once
 * @body bookmarks - Array of {vocabulary_id, notes}
 */
const createBookmarksBatch = async (req, res) => {
  try {
    const userId = req.user.id;
    const { bookmarks } = req.body;
    console.log('[BOOKMARK] POST /api/content/vocabulary/bookmarks/batch', { userId, count: bookmarks?.length });

    // Validate input
    if (!Array.isArray(bookmarks) || bookmarks.length === 0) {
      return res.status(400).json({
        success: false,
        error: 'bookmarks must be a non-empty array'
      });
    }

    // Validate each bookmark
    for (const b of bookmarks) {
      if (!b.vocabulary_id || isNaN(parseInt(b.vocabulary_id))) {
        return res.status(400).json({
          success: false,
          error: 'Each bookmark must have a valid vocabulary_id'
        });
      }
    }

    // Insert bookmarks
    const { query } = require('../config/database');
    const results = [];
    const errors = [];

    for (const b of bookmarks) {
      try {
        const insertSql = `
          INSERT INTO user_bookmarks (user_id, resource_type, resource_id, notes)
          VALUES ($1, 'vocabulary', $2, $3)
          ON CONFLICT (user_id, resource_type, resource_id) DO UPDATE
          SET notes = EXCLUDED.notes
          RETURNING *
        `;
        const result = await query(insertSql, [userId, parseInt(b.vocabulary_id), b.notes || null]);
        results.push(result.rows[0]);
      } catch (error) {
        errors.push({
          vocabulary_id: b.vocabulary_id,
          error: error.message
        });
      }
    }

    // Invalidate cache
    const cacheKey = `bookmarks:user:${userId}`;
    await cacheHelpers.del(cacheKey);

    console.log(`[BOOKMARK] Batch created ${results.length} bookmarks, ${errors.length} errors`);

    res.status(201).json({
      success: true,
      created: results.length,
      errors: errors.length,
      bookmarks: results.map(b => ({
        id: b.id,
        vocabulary_id: b.resource_id,
        notes: b.notes,
        created_at: b.created_at
      })),
      ...(errors.length > 0 && { errors })
    });

  } catch (error) {
    console.error('[BOOKMARK] Error in createBookmarksBatch:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to create bookmarks',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * EXPORTS
 * ================================================================
 */
module.exports = {
  getVocabulary,
  getVocabularyById,
  searchVocabulary,
  getVocabularyStats,
  getVocabularyByLevel,
  getHighSimilarityVocabulary,
  // Bookmark endpoints
  createBookmark,
  getUserBookmarks,
  getBookmark,
  updateBookmarkNotes,
  deleteBookmark,
  createBookmarksBatch
};
