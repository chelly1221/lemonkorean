const { query } = require('../config/database');
const { getDB, getCollection } = require('../config/mongodb');

/**
 * Lesson Model - Admin Service
 * CRUD operations for lesson management (includes drafts)
 */

/**
 * Get all lessons with filtering and pagination
 * @param {Object} options - Query options
 * @returns {Object} Paginated lessons
 */
const getAll = async (options = {}) => {
  try {
    const {
      page = 1,
      limit = 20,
      level = null,
      status = null,
      search = '',
      sortBy = 'id',
      sortOrder = 'ASC'
    } = options;

    const offset = (page - 1) * limit;

    // Build WHERE clause
    const conditions = [];
    const params = [];
    let paramIndex = 1;

    if (level !== null) {
      conditions.push(`level = $${paramIndex}`);
      params.push(level);
      paramIndex++;
    }

    if (status) {
      conditions.push(`status = $${paramIndex}`);
      params.push(status);
      paramIndex++;
    }

    if (search) {
      conditions.push(`(title_ko ILIKE $${paramIndex} OR title_zh ILIKE $${paramIndex})`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    // Validate sort column
    const allowedSortColumns = ['id', 'level', 'title_ko', 'status', 'created_at', 'updated_at'];
    const validSortBy = allowedSortColumns.includes(sortBy) ? sortBy : 'id';
    const validSortOrder = sortOrder.toUpperCase() === 'DESC' ? 'DESC' : 'ASC';

    // Get total count
    const countResult = await query(
      `SELECT COUNT(*) as total FROM lessons ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].total);

    // Get lessons
    const lessonsResult = await query(
      `SELECT
        id,
        level,
        week,
        order_num,
        title_ko,
        title_zh,
        description_ko,
        description_zh,
        difficulty,
        duration_minutes,
        status,
        version,
        thumbnail_url,
        published_at,
        created_at,
        updated_at
      FROM lessons
      ${whereClause}
      ORDER BY ${validSortBy} ${validSortOrder}
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`,
      [...params, limit, offset]
    );

    return {
      lessons: lessonsResult.rows,
      total,
      page: parseInt(page),
      limit: parseInt(limit),
      totalPages: Math.ceil(total / limit)
    };
  } catch (error) {
    console.error('[LESSON_MODEL] Error getting lessons:', error);
    throw error;
  }
};

/**
 * Get lesson by ID (includes full content from MongoDB)
 * @param {number} lessonId - Lesson ID
 * @returns {Object} Lesson with full content
 */
const findById = async (lessonId) => {
  try {
    // Get metadata from PostgreSQL
    const result = await query(
      `SELECT
        id,
        level,
        week,
        order_num,
        title_ko,
        title_zh,
        description_ko,
        description_zh,
        difficulty,
        duration_minutes,
        status,
        version,
        thumbnail_url,
        published_at,
        tags,
        prerequisites,
        view_count,
        completion_count,
        created_at,
        updated_at
      FROM lessons
      WHERE id = $1`,
      [lessonId]
    );

    if (result.rows.length === 0) {
      return null;
    }

    const lesson = result.rows[0];

    // Get content from MongoDB
    try {
      const db = getDB();
      const lessonsContent = db.collection('lessons_content');
      const content = await lessonsContent.findOne({ lesson_id: lessonId });

      if (content) {
        lesson.content = content.content || {};
        lesson.media_manifest = content.media_manifest || [];
      } else {
        lesson.content = {};
        lesson.media_manifest = [];
      }
    } catch (mongoError) {
      console.error('[LESSON_MODEL] Error fetching content from MongoDB:', mongoError);
      lesson.content = {};
      lesson.media_manifest = [];
    }

    return lesson;
  } catch (error) {
    console.error('[LESSON_MODEL] Error finding lesson by ID:', error);
    throw error;
  }
};

/**
 * Create new lesson
 * @param {Object} lessonData - Lesson data
 * @returns {Object} Created lesson
 */
const create = async (lessonData) => {
  try {
    const {
      level,
      week = 1,
      order_num = 1,
      title_ko,
      title_zh,
      description_ko = null,
      description_zh = null,
      difficulty = 'beginner',
      duration_minutes = 30,
      status = 'draft',
      version = '1.0.0',
      content = {},
      media_manifest = []
    } = lessonData;

    // Insert into PostgreSQL
    const result = await query(
      `INSERT INTO lessons
       (level, week, order_num, title_ko, title_zh, description_ko, description_zh, difficulty, duration_minutes, status, version)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [level, week, order_num, title_ko, title_zh, description_ko, description_zh, difficulty, duration_minutes, status, version]
    );

    const lesson = result.rows[0];

    // Insert content into MongoDB
    if (Object.keys(content).length > 0 || media_manifest.length > 0) {
      try {
        const db = getDB();
        const lessonsContent = db.collection('lessons_content');
        await lessonsContent.insertOne({
          lesson_id: lesson.id,
          version: version,
          content: content,
          media_manifest: media_manifest,
          created_at: new Date(),
          updated_at: new Date()
        });
      } catch (mongoError) {
        console.error('[LESSON_MODEL] Error inserting content to MongoDB:', mongoError);
        // Don't fail the operation, content can be added later
      }
    }

    lesson.content = content;
    lesson.media_manifest = media_manifest;

    return lesson;
  } catch (error) {
    console.error('[LESSON_MODEL] Error creating lesson:', error);
    throw error;
  }
};

/**
 * Update lesson
 * @param {number} lessonId - Lesson ID
 * @param {Object} updates - Fields to update
 * @returns {Object} Updated lesson
 */
const update = async (lessonId, updates) => {
  try {
    const allowedFields = [
      'level',
      'week',
      'order_num',
      'title_ko',
      'title_zh',
      'description_ko',
      'description_zh',
      'difficulty',
      'duration_minutes',
      'thumbnail_url',
      'status',
      'version',
      'tags',
      'prerequisites'
    ];

    const updateFields = [];
    const params = [];
    let paramIndex = 1;

    // Handle PostgreSQL fields
    Object.keys(updates).forEach((key) => {
      if (allowedFields.includes(key)) {
        updateFields.push(`${key} = $${paramIndex}`);
        params.push(updates[key]);
        paramIndex++;
      }
    });

    if (updateFields.length === 0 && !updates.content && !updates.media_manifest) {
      throw new Error('No valid fields to update');
    }

    // Update PostgreSQL if there are fields
    let lesson;
    if (updateFields.length > 0) {
      updateFields.push(`updated_at = CURRENT_TIMESTAMP`);
      params.push(lessonId);

      const result = await query(
        `UPDATE lessons
         SET ${updateFields.join(', ')}
         WHERE id = $${paramIndex}
         RETURNING *`,
        params
      );

      if (result.rows.length === 0) {
        throw new Error('Lesson not found');
      }

      lesson = result.rows[0];
    } else {
      // Just fetch the lesson
      lesson = await findById(lessonId);
      if (!lesson) {
        throw new Error('Lesson not found');
      }
    }

    // Update MongoDB content if provided
    if (updates.content || updates.media_manifest) {
      try {
        const db = getDB();
        const lessonsContent = db.collection('lessons_content');

        const mongoUpdates = { updated_at: new Date() };
        if (updates.content) mongoUpdates.content = updates.content;
        if (updates.media_manifest) mongoUpdates.media_manifest = updates.media_manifest;

        await lessonsContent.updateOne(
          { lesson_id: lessonId },
          { $set: mongoUpdates },
          { upsert: true }
        );

        lesson.content = updates.content || lesson.content || {};
        lesson.media_manifest = updates.media_manifest || lesson.media_manifest || [];
      } catch (mongoError) {
        console.error('[LESSON_MODEL] Error updating MongoDB content:', mongoError);
      }
    }

    return lesson;
  } catch (error) {
    console.error('[LESSON_MODEL] Error updating lesson:', error);
    throw error;
  }
};

/**
 * Delete lesson
 * @param {number} lessonId - Lesson ID
 * @returns {boolean} Success
 */
const deleteLesson = async (lessonId) => {
  try {
    // Delete from PostgreSQL (cascades to related tables)
    const result = await query(
      `DELETE FROM lessons WHERE id = $1 RETURNING id`,
      [lessonId]
    );

    if (result.rows.length === 0) {
      throw new Error('Lesson not found');
    }

    // Delete from MongoDB
    try {
      const db = getDB();
      const lessonsContent = db.collection('lessons_content');
      await lessonsContent.deleteOne({ lesson_id: lessonId });
    } catch (mongoError) {
      console.error('[LESSON_MODEL] Error deleting MongoDB content:', mongoError);
      // Don't fail the operation
    }

    return true;
  } catch (error) {
    console.error('[LESSON_MODEL] Error deleting lesson:', error);
    throw error;
  }
};

/**
 * Bulk publish lessons
 * @param {Array<number>} lessonIds - Lesson IDs to publish
 * @returns {number} Number of lessons published
 */
const bulkPublish = async (lessonIds) => {
  try {
    const result = await query(
      `UPDATE lessons
       SET status = 'published', updated_at = CURRENT_TIMESTAMP
       WHERE id = ANY($1) AND status = 'draft'
       RETURNING id`,
      [lessonIds]
    );

    return result.rows.length;
  } catch (error) {
    console.error('[LESSON_MODEL] Error bulk publishing:', error);
    throw error;
  }
};

/**
 * Bulk delete lessons
 * @param {Array<number>} lessonIds - Lesson IDs to delete
 * @returns {number} Number of lessons deleted
 */
const bulkDelete = async (lessonIds) => {
  try {
    const result = await query(
      `DELETE FROM lessons
       WHERE id = ANY($1)
       RETURNING id`,
      [lessonIds]
    );

    // Delete from MongoDB
    if (result.rows.length > 0) {
      try {
        const db = getDB();
        const lessonsContent = db.collection('lessons_content');
        await lessonsContent.deleteMany({ lesson_id: { $in: lessonIds } });
      } catch (mongoError) {
        console.error('[LESSON_MODEL] Error bulk deleting MongoDB content:', mongoError);
      }
    }

    return result.rows.length;
  } catch (error) {
    console.error('[LESSON_MODEL] Error bulk deleting:', error);
    throw error;
  }
};

module.exports = {
  getAll,
  findById,
  create,
  update,
  deleteLesson,
  bulkPublish,
  bulkDelete
};
