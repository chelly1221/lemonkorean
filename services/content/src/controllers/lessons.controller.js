const crypto = require('crypto');
const Lesson = require('../models/lesson.model');
const LessonPackagerService = require('../services/lesson-packager.service');
const { cacheHelpers } = require('../config/redis');
const { query } = require('../config/database');

// ==================== Helper Functions ====================

/**
 * Calculate checksum for data
 * @param {Object} data - Data to hash
 * @returns {String} SHA256 checksum
 */
const calculateChecksum = (data) => {
  const jsonString = JSON.stringify(data);
  return crypto.createHash('sha256').update(jsonString).digest('hex');
};

/**
 * Build pagination metadata
 * @param {Number} total - Total count
 * @param {Number} page - Current page
 * @param {Number} limit - Items per page
 * @returns {Object} Pagination metadata
 */
const buildPaginationMeta = (total, page, limit) => {
  const totalPages = Math.ceil(total / limit);
  return {
    total,
    page,
    limit,
    totalPages,
    hasNextPage: page < totalPages,
    hasPreviousPage: page > 1
  };
};

// ==================== Controller Functions ====================

/**
 * Get all lessons with pagination
 * GET /api/content/lessons
 * @query {Number} level - TOPIK level (0-6)
 * @query {String} status - Lesson status (published/draft/archived)
 * @query {Number} page - Page number (default: 1)
 * @query {Number} limit - Items per page (default: 20, max: 100)
 */
const getLessons = async (req, res) => {
  try {
    const {
      level,
      status = 'published',
      page = 1,
      limit = 20
    } = req.query;

    // Validate parameters
    const pageNum = Math.max(1, parseInt(page) || 1);
    const limitNum = Math.min(100, Math.max(1, parseInt(limit) || 20));
    const offset = (pageNum - 1) * limitNum;

    console.log(`[LESSONS] Fetching lessons - level: ${level}, status: ${status}, page: ${pageNum}, limit: ${limitNum}`);

    // Build cache key
    const cacheKey = `lessons:list:${level || 'all'}:${status}:${pageNum}:${limitNum}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log(`[LESSONS] Returning cached results`);
      return res.json({
        success: true,
        cached: true,
        ...cached
      });
    }

    // Get total count for pagination
    let countSql = 'SELECT COUNT(*) as total FROM lessons WHERE 1=1';
    const countParams = [];
    let paramCount = 1;

    if (level !== undefined) {
      countSql += ` AND level = $${paramCount}`;
      countParams.push(level);
      paramCount++;
    }

    if (status) {
      countSql += ` AND status = $${paramCount}`;
      countParams.push(status);
    }

    const countResult = await query(countSql, countParams);
    const total = parseInt(countResult.rows[0].total);

    // Fetch lessons
    const lessons = await Lesson.findAll({
      level,
      status,
      limit: limitNum,
      offset
    });

    // Build response
    const response = {
      lessons,
      pagination: buildPaginationMeta(total, pageNum, limitNum)
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, response, 3600);

    console.log(`[LESSONS] Found ${lessons.length} lessons (total: ${total})`);

    res.json({
      success: true,
      ...response
    });
  } catch (error) {
    console.error('[LESSONS] Error fetching lessons:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to fetch lessons',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get lesson by ID (metadata from PostgreSQL + content from MongoDB)
 * GET /api/content/lessons/:id
 * @param {Number} id - Lesson ID
 */
const getLessonById = async (req, res) => {
  try {
    const { id } = req.params;

    console.log(`[LESSONS] Fetching lesson ${id}`);

    // Validate ID
    const lessonId = parseInt(id);
    if (isNaN(lessonId) || lessonId < 1) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    // Try cache
    const cacheKey = `lesson:full:${id}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log(`[LESSONS] Returning cached lesson ${id}`);
      return res.json({
        success: true,
        cached: true,
        lesson: cached
      });
    }

    // 1. Get metadata from PostgreSQL
    const metadata = await Lesson.findById(lessonId);

    if (!metadata) {
      return res.status(404).json({
        error: 'Not Found',
        message: `Lesson ${id} not found`
      });
    }

    // 2. Get content from MongoDB
    let content = null;
    try {
      const contentDoc = await Lesson.findContentById(lessonId);
      content = contentDoc?.content || null;
    } catch (mongoError) {
      console.error('[LESSONS] MongoDB error (non-critical):', mongoError);
      // Continue without content if MongoDB fails
    }

    // 3. Get vocabulary
    const vocabulary = await Lesson.getVocabulary(lessonId);

    // 4. Get grammar
    const grammar = await Lesson.getGrammar(lessonId);

    // 5. Build complete lesson object
    const lesson = {
      id: metadata.id,
      level: metadata.level,
      week: metadata.week,
      order_num: metadata.order_num,
      title_ko: metadata.title_ko,
      title_zh: metadata.title_zh,
      description_ko: metadata.description_ko,
      description_zh: metadata.description_zh,
      duration_minutes: metadata.duration_minutes,
      difficulty: metadata.difficulty,
      thumbnail_url: metadata.thumbnail_url,
      version: metadata.version,
      status: metadata.status,
      published_at: metadata.published_at,
      prerequisites: metadata.prerequisites,
      tags: metadata.tags,
      view_count: metadata.view_count,
      completion_count: metadata.completion_count,
      content: content,
      vocabulary: vocabulary.map(v => ({
        id: v.id,
        korean: v.korean,
        hanja: v.hanja,
        chinese: v.chinese,
        pinyin: v.pinyin,
        part_of_speech: v.part_of_speech,
        similarity_score: v.similarity_score,
        image_url: v.image_url,
        audio_url_male: v.audio_url_male,
        audio_url_female: v.audio_url_female,
        is_primary: v.is_primary
      })),
      grammar: grammar.map(g => ({
        id: g.id,
        name_ko: g.name_ko,
        name_zh: g.name_zh,
        category: g.category,
        difficulty: g.difficulty,
        description: g.description,
        chinese_comparison: g.chinese_comparison,
        examples: g.examples,
        is_primary: g.is_primary
      }))
    };

    // Increment view count (async, don't wait)
    Lesson.incrementViewCount(lessonId).catch(err =>
      console.error('[LESSONS] Failed to increment view count:', err)
    );

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, lesson, 3600);

    console.log(`[LESSONS] Lesson ${id} fetched successfully`);

    res.json({
      success: true,
      lesson
    });
  } catch (error) {
    console.error('[LESSONS] Error fetching lesson:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to fetch lesson',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get lesson download package (JSON with checksum)
 * GET /api/content/lessons/:id/package
 * @param {Number} id - Lesson ID
 */
const getLessonDownloadPackage = async (req, res) => {
  try {
    const { id } = req.params;

    console.log(`[LESSONS] Creating download package for lesson ${id}`);

    const lessonId = parseInt(id);
    if (isNaN(lessonId) || lessonId < 1) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    // Try cache
    const cacheKey = `lesson:package:${id}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log(`[LESSONS] Returning cached package for lesson ${id}`);
      return res.json({
        success: true,
        cached: true,
        package: cached
      });
    }

    // Create package using LessonPackagerService
    const packageData = await LessonPackagerService.createPackage(lessonId);

    // Calculate checksum
    const checksum = calculateChecksum(packageData);

    // Build download package
    const downloadPackage = {
      lesson_id: packageData.lesson_id,
      version: packageData.version,
      checksum: checksum,
      metadata: packageData.metadata,
      content: packageData.content,
      vocabulary: packageData.vocabulary,
      grammar: packageData.grammar,
      media_urls: packageData.media_urls,
      package_info: {
        created_at: new Date().toISOString(),
        format_version: '1.0.0',
        size_bytes: LessonPackagerService.estimatePackageSize(packageData),
        checksum_algorithm: 'sha256'
      }
    };

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, downloadPackage, 3600);

    console.log(`[LESSONS] Package created for lesson ${id}, checksum: ${checksum.substring(0, 16)}...`);

    res.json({
      success: true,
      package: downloadPackage
    });
  } catch (error) {
    console.error('[LESSONS] Error creating download package:', error);

    if (error.message.includes('not found')) {
      return res.status(404).json({
        error: 'Not Found',
        message: error.message
      });
    }

    if (error.message.includes('not published')) {
      return res.status(403).json({
        error: 'Forbidden',
        message: error.message
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to create download package',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Check lesson version (single lesson)
 * GET /api/content/lessons/:id/version
 * @param {Number} id - Lesson ID
 * @query {String} clientVersion - Client's current version
 */
const checkLessonVersion = async (req, res) => {
  try {
    const { id } = req.params;
    const { clientVersion } = req.query;

    console.log(`[LESSONS] Checking version for lesson ${id}, client version: ${clientVersion}`);

    const lessonId = parseInt(id);
    if (isNaN(lessonId) || lessonId < 1) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    if (!clientVersion) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'clientVersion query parameter is required'
      });
    }

    // Get current lesson version from database
    const lesson = await Lesson.findById(lessonId);

    if (!lesson) {
      return res.status(404).json({
        error: 'Not Found',
        message: `Lesson ${id} not found`
      });
    }

    const serverVersion = lesson.version;
    const updateAvailable = serverVersion !== clientVersion;

    console.log(`[LESSONS] Version check - server: ${serverVersion}, client: ${clientVersion}, update: ${updateAvailable}`);

    res.json({
      success: true,
      lesson_id: lessonId,
      client_version: clientVersion,
      server_version: serverVersion,
      update_available: updateAvailable,
      updated_at: lesson.updated_at,
      ...(updateAvailable && {
        download_url: `/api/content/lessons/${id}/package`
      })
    });
  } catch (error) {
    console.error('[LESSONS] Error checking version:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to check lesson version',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Bulk check lesson updates
 * POST /api/content/lessons/check-updates
 * @body {Array} lessons - Array of {id, version}
 */
const bulkCheckUpdates = async (req, res) => {
  try {
    const { lessons } = req.body;

    // Validate input
    if (!Array.isArray(lessons)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'lessons must be an array of {id, version}'
      });
    }

    if (lessons.length === 0) {
      return res.json({
        success: true,
        updates_available: 0,
        updates: []
      });
    }

    if (lessons.length > 100) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Maximum 100 lessons per request'
      });
    }

    // Validate each lesson object
    for (const lesson of lessons) {
      if (!lesson.id || !lesson.version) {
        return res.status(400).json({
          error: 'Bad Request',
          message: 'Each lesson must have id and version fields'
        });
      }
    }

    console.log(`[LESSONS] Bulk checking updates for ${lessons.length} lessons`);

    // Build cache key
    const lessonIds = lessons.map(l => l.id).sort().join(',');
    const cacheKey = `lessons:updates:${crypto.createHash('md5').update(lessonIds).digest('hex')}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log(`[LESSONS] Returning cached update check results`);
      // Still need to compare with client versions
      const filteredUpdates = cached.filter(serverLesson => {
        const clientLesson = lessons.find(l => l.id === serverLesson.id);
        return clientLesson && clientLesson.version !== serverLesson.version;
      });

      return res.json({
        success: true,
        cached: true,
        updates_available: filteredUpdates.length,
        updates: filteredUpdates.map(update => ({
          lesson_id: update.id,
          client_version: lessons.find(l => l.id === update.id).version,
          server_version: update.version,
          updated_at: update.updated_at,
          download_url: `/api/content/lessons/${update.id}/package`
        }))
      });
    }

    // Fetch server versions
    const ids = lessons.map(l => l.id);
    const sql = `
      SELECT id, version, updated_at
      FROM lessons
      WHERE id = ANY($1)
    `;

    const result = await query(sql, [ids]);
    const serverLessons = result.rows;

    // Cache server versions for 30 minutes
    await cacheHelpers.set(cacheKey, serverLessons, 1800);

    // Compare versions
    const updates = [];
    for (const serverLesson of serverLessons) {
      const clientLesson = lessons.find(l => l.id === serverLesson.id);

      if (clientLesson && clientLesson.version !== serverLesson.version) {
        updates.push({
          lesson_id: serverLesson.id,
          client_version: clientLesson.version,
          server_version: serverLesson.version,
          updated_at: serverLesson.updated_at,
          download_url: `/api/content/lessons/${serverLesson.id}/package`
        });
      }
    }

    console.log(`[LESSONS] Found ${updates.length} updates out of ${lessons.length} lessons`);

    res.json({
      success: true,
      updates_available: updates.length,
      total_checked: lessons.length,
      updates
    });
  } catch (error) {
    console.error('[LESSONS] Error checking updates:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to check for updates',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Download lesson as ZIP archive
 * GET /api/content/lessons/:id/download
 * @param {Number} id - Lesson ID
 */
const downloadLessonZip = async (req, res) => {
  try {
    const { id } = req.params;

    console.log(`[LESSONS] Creating ZIP download for lesson ${id}`);

    const lessonId = parseInt(id);
    if (isNaN(lessonId) || lessonId < 1) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    // Create package
    const packageData = await LessonPackagerService.createPackage(lessonId);

    // Create archive stream
    const archive = LessonPackagerService.createArchiveStream(packageData);

    // Set response headers
    res.setHeader('Content-Type', 'application/zip');
    res.setHeader('Content-Disposition', `attachment; filename="lesson_${id}_v${packageData.version}.zip"`);
    res.setHeader('X-Lesson-Version', packageData.version);

    // Handle archive events
    archive.on('error', (err) => {
      console.error('[LESSONS] Archive error:', err);
      if (!res.headersSent) {
        res.status(500).json({
          error: 'Internal Server Error',
          message: 'Failed to create archive'
        });
      }
    });

    // Pipe archive to response
    archive.pipe(res);

    console.log(`[LESSONS] ZIP download started for lesson ${id}`);
  } catch (error) {
    console.error('[LESSONS] Error creating ZIP download:', error);

    if (!res.headersSent) {
      res.status(500).json({
        error: 'Internal Server Error',
        message: error.message || 'Failed to create download package',
        ...(process.env.NODE_ENV === 'development' && { details: error.message })
      });
    }
  }
};

/**
 * Get lessons by level
 * GET /api/content/lessons/level/:level
 * @param {Number} level - TOPIK level (0-6)
 */
const getLessonsByLevel = async (req, res) => {
  try {
    const { level } = req.params;

    const levelNum = parseInt(level);
    if (isNaN(levelNum) || levelNum < 0 || levelNum > 6) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Level must be between 0 and 6'
      });
    }

    console.log(`[LESSONS] Fetching lessons for level ${level}`);

    // Try cache
    const cacheKey = `lessons:level:${level}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log(`[LESSONS] Returning cached lessons for level ${level}`);
      return res.json({
        success: true,
        cached: true,
        level: levelNum,
        count: cached.length,
        lessons: cached
      });
    }

    const lessons = await Lesson.findByLevel(levelNum);

    // Cache for 1 hour
    await cacheHelpers.set(cacheKey, lessons, 3600);

    res.json({
      success: true,
      level: levelNum,
      count: lessons.length,
      lessons
    });
  } catch (error) {
    console.error('[LESSONS] Error fetching lessons by level:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to fetch lessons',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Exports ====================

module.exports = {
  getLessons,
  getLessonById,
  getLessonDownloadPackage,
  checkLessonVersion,
  bulkCheckUpdates,
  downloadLessonZip,
  getLessonsByLevel
};
