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
 * EXPORTS
 * ================================================================
 */
module.exports = {
  getVocabulary,
  getVocabularyById,
  searchVocabulary,
  getVocabularyStats,
  getVocabularyByLevel,
  getHighSimilarityVocabulary
};
