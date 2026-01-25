const { query } = require('../config/database');
const { cacheHelpers } = require('../config/redis');

/**
 * ================================================================
 * GRAMMAR CONTROLLER
 * ================================================================
 * Handles grammar rules endpoints for Korean grammar patterns
 * Features: Chinese comparisons, filtering by level/category
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
 * GET /api/content/grammar
 * ================================================================
 * Get all grammar rules with filtering and pagination
 * @query level - Filter by TOPIK level (0-6)
 * @query category - Filter by category
 * @query page - Page number (default: 1)
 * @query limit - Items per page (default: 50, max: 200)
 */
const getGrammarRules = async (req, res) => {
  try {
    console.log('[GRAMMAR] GET /api/content/grammar', req.query);

    const { level, category, page = 1, limit = 50 } = req.query;

    // Validate pagination
    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(200, Math.max(1, parseInt(limit) || 50));
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
    const cacheKey = `grammar:list:${level||'all'}:${category||'all'}:${pageNum}:${limitNum}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[GRAMMAR] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Get total count for pagination
    let countSql = 'SELECT COUNT(*) as total FROM grammar_rules WHERE 1=1';
    const countParams = [];
    let paramCount = 1;

    if (level !== undefined) {
      countSql += ` AND level = $${paramCount}`;
      countParams.push(parseInt(level));
      paramCount++;
    }

    if (category) {
      countSql += ` AND category = $${paramCount}`;
      countParams.push(category);
      paramCount++;
    }

    const countResult = await query(countSql, countParams);
    const total = parseInt(countResult.rows[0].total);

    // Fetch grammar rules
    let sql = `
      SELECT id, name_ko, name_zh, category, level, difficulty,
             description, chinese_comparison, examples, usage_notes,
             created_at
      FROM grammar_rules
      WHERE 1=1
    `;

    const params = [];
    paramCount = 1;

    if (level !== undefined) {
      sql += ` AND level = $${paramCount}`;
      params.push(parseInt(level));
      paramCount++;
    }

    if (category) {
      sql += ` AND category = $${paramCount}`;
      params.push(category);
      paramCount++;
    }

    sql += ` ORDER BY level, id`;
    sql += ` LIMIT $${paramCount} OFFSET $${paramCount + 1}`;
    params.push(limitNum, offset);

    const result = await query(sql, params);

    const response = {
      grammar: result.rows,
      pagination: buildPaginationMeta(total, pageNum, limitNum)
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[GRAMMAR] Returned ${result.rows.length} items (page ${pageNum}/${response.pagination.total_pages})`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[GRAMMAR] Error in getGrammarRules:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch grammar rules',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/grammar/:id
 * ================================================================
 * Get grammar rule by ID
 */
const getGrammarById = async (req, res) => {
  try {
    const grammarId = parseInt(req.params.id);
    console.log('[GRAMMAR] GET /api/content/grammar/:id', grammarId);

    // Validate ID
    if (isNaN(grammarId) || grammarId < 1) {
      return res.status(400).json({
        success: false,
        error: 'Invalid grammar rule ID'
      });
    }

    // Check cache
    const cacheKey = `grammar:${grammarId}`;
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[GRAMMAR] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        grammar: cached
      });
    }

    // Fetch from database
    const sql = `
      SELECT id, name_ko, name_zh, category, level, difficulty,
             description, chinese_comparison, examples, usage_notes,
             common_mistakes, related_grammar, version,
             created_at, updated_at
      FROM grammar_rules
      WHERE id = $1
    `;

    const result = await query(sql, [grammarId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        error: 'Grammar rule not found'
      });
    }

    const grammar = result.rows[0];

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, grammar, 3600);

    console.log('[GRAMMAR] Found:', grammar.name_ko, '-', grammar.name_zh);

    res.json({
      success: true,
      grammar
    });

  } catch (error) {
    console.error('[GRAMMAR] Error in getGrammarById:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch grammar rule',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/grammar/categories
 * ================================================================
 * Get all grammar categories with counts
 */
const getGrammarCategories = async (req, res) => {
  try {
    console.log('[GRAMMAR] GET /api/content/grammar/categories');

    const cacheKey = 'grammar:categories';

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[GRAMMAR] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        categories: cached
      });
    }

    // Fetch from database
    const sql = `
      SELECT category, COUNT(*) as count
      FROM grammar_rules
      GROUP BY category
      ORDER BY category
    `;

    const result = await query(sql);

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, result.rows, 3600);

    console.log(`[GRAMMAR] Found ${result.rows.length} categories`);

    res.json({
      success: true,
      categories: result.rows
    });

  } catch (error) {
    console.error('[GRAMMAR] Error in getGrammarCategories:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch grammar categories',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * ================================================================
 * GET /api/content/grammar/level/:level
 * ================================================================
 * Get grammar rules by TOPIK level
 */
const getGrammarByLevel = async (req, res) => {
  try {
    const level = parseInt(req.params.level);
    console.log('[GRAMMAR] GET /api/content/grammar/level/:level', level);

    // Validate level
    if (isNaN(level) || level < 0 || level > 6) {
      return res.status(400).json({
        success: false,
        error: 'Level must be between 0 and 6'
      });
    }

    const cacheKey = `grammar:level:${level}`;

    // Check cache
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[GRAMMAR] Cache hit:', cacheKey);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Fetch from database
    const sql = `
      SELECT id, name_ko, name_zh, category, level, difficulty,
             description, chinese_comparison
      FROM grammar_rules
      WHERE level = $1
      ORDER BY category, id
    `;

    const result = await query(sql, [level]);

    const response = {
      level,
      count: result.rows.length,
      grammar: result.rows
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[GRAMMAR] Level ${level} has ${result.rows.length} rules`);

    res.json({
      success: true,
      ...response
    });

  } catch (error) {
    console.error('[GRAMMAR] Error in getGrammarByLevel:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to fetch grammar by level',
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
  getGrammarRules,
  getGrammarById,
  getGrammarCategories,
  getGrammarByLevel
};
