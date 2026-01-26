const contentService = require('../services/content-management.service');

/**
 * Lessons Controller
 * Handles HTTP requests for lesson management
 */

/**
 * GET /api/admin/lessons
 * List all lessons with pagination and filtering
 */
const listLessons = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      level = null,
      status = null,
      search = '',
      sortBy = 'id',
      sortOrder = 'ASC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: Math.min(parseInt(limit), 100),
      level: level ? parseInt(level) : null,
      status,
      search,
      sortBy,
      sortOrder: sortOrder.toUpperCase()
    };

    const result = await contentService.listLessons(options);

    res.json({
      success: true,
      data: result.lessons,
      pagination: {
        page: result.page,
        limit: result.limit,
        total: result.total,
        totalPages: result.totalPages
      }
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error listing lessons:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve lessons',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/lessons/:id
 * Get lesson by ID with full content
 */
const getLessonById = async (req, res) => {
  try {
    const lessonId = parseInt(req.params.id);

    if (isNaN(lessonId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    const lesson = await contentService.getLessonById(lessonId);

    res.json({
      success: true,
      data: lesson
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error getting lesson:', error);

    if (error.message === 'Lesson not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Lesson not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve lesson',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/lessons
 * Create new lesson
 */
const createLesson = async (req, res) => {
  try {
    const { level, title_ko, title_zh } = req.body;

    // Validate required fields
    if (!level || !title_ko || !title_zh) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Missing required fields: level, title_ko, title_zh'
      });
    }

    const lesson = await contentService.createLesson(req.body);

    res.status(201).json({
      success: true,
      message: 'Lesson created successfully',
      data: lesson
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error creating lesson:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to create lesson',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * PUT /api/admin/lessons/:id
 * Update lesson
 */
const updateLesson = async (req, res) => {
  try {
    const lessonId = parseInt(req.params.id);

    if (isNaN(lessonId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    const updates = req.body;

    if (!updates || Object.keys(updates).length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'No updates provided'
      });
    }

    const lesson = await contentService.updateLesson(lessonId, updates);

    res.json({
      success: true,
      message: 'Lesson updated successfully',
      data: lesson
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error updating lesson:', error);

    if (error.message === 'Lesson not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Lesson not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to update lesson',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * DELETE /api/admin/lessons/:id
 * Delete lesson
 */
const deleteLesson = async (req, res) => {
  try {
    const lessonId = parseInt(req.params.id);

    if (isNaN(lessonId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    await contentService.deleteLesson(lessonId);

    res.json({
      success: true,
      message: 'Lesson deleted successfully'
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error deleting lesson:', error);

    if (error.message === 'Lesson not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Lesson not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to delete lesson',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * PUT /api/admin/lessons/:id/publish
 * Publish lesson
 */
const publishLesson = async (req, res) => {
  try {
    const lessonId = parseInt(req.params.id);

    if (isNaN(lessonId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    const lesson = await contentService.publishLesson(lessonId);

    res.json({
      success: true,
      message: 'Lesson published successfully',
      data: lesson
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error publishing lesson:', error);

    if (error.message === 'Lesson not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Lesson not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to publish lesson',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * PUT /api/admin/lessons/:id/unpublish
 * Unpublish lesson
 */
const unpublishLesson = async (req, res) => {
  try {
    const lessonId = parseInt(req.params.id);

    if (isNaN(lessonId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid lesson ID'
      });
    }

    const lesson = await contentService.unpublishLesson(lessonId);

    res.json({
      success: true,
      message: 'Lesson unpublished successfully',
      data: lesson
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error unpublishing lesson:', error);

    if (error.message === 'Lesson not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Lesson not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to unpublish lesson',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/lessons/bulk-publish
 * Bulk publish lessons
 */
const bulkPublish = async (req, res) => {
  try {
    const { lessonIds } = req.body;

    if (!Array.isArray(lessonIds) || lessonIds.length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'lessonIds must be a non-empty array'
      });
    }

    const count = await contentService.bulkPublishLessons(lessonIds);

    res.json({
      success: true,
      message: `${count} lessons published successfully`,
      data: { count }
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error bulk publishing:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to bulk publish lessons',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/lessons/bulk-delete
 * Bulk delete lessons
 */
const bulkDelete = async (req, res) => {
  try {
    const { lessonIds } = req.body;

    if (!Array.isArray(lessonIds) || lessonIds.length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'lessonIds must be a non-empty array'
      });
    }

    const count = await contentService.bulkDeleteLessons(lessonIds);

    res.json({
      success: true,
      message: `${count} lessons deleted successfully`,
      data: { count }
    });
  } catch (error) {
    console.error('[LESSONS_CONTROLLER] Error bulk deleting:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to bulk delete lessons',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  listLessons,
  getLessonById,
  createLesson,
  updateLesson,
  deleteLesson,
  publishLesson,
  unpublishLesson,
  bulkPublish,
  bulkDelete
};
