const contentService = require('../services/content-management.service');

/**
 * Vocabulary Controller
 * Handles HTTP requests for vocabulary management
 */

/**
 * GET /api/admin/vocabulary
 * List all vocabulary with pagination and filtering
 */
const listVocabulary = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 50,
      search = '',
      sortBy = 'id',
      sortOrder = 'ASC'
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: Math.min(parseInt(limit), 200),
      search,
      sortBy,
      sortOrder: sortOrder.toUpperCase()
    };

    const result = await contentService.listVocabulary(options);

    res.json({
      success: true,
      data: result.vocabulary,
      pagination: {
        page: result.page,
        limit: result.limit,
        total: result.total,
        totalPages: result.totalPages
      }
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error listing vocabulary:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/vocabulary/:id
 * Get vocabulary by ID
 */
const getVocabularyById = async (req, res) => {
  try {
    const vocabId = parseInt(req.params.id);

    if (isNaN(vocabId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid vocabulary ID'
      });
    }

    const vocab = await contentService.getVocabularyById(vocabId);

    res.json({
      success: true,
      data: vocab
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error getting vocabulary:', error);

    if (error.message === 'Vocabulary not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Vocabulary not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/vocabulary
 * Create new vocabulary entry
 */
const createVocabulary = async (req, res) => {
  try {
    const { korean, chinese } = req.body;

    // Validate required fields
    if (!korean || !chinese) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Missing required fields: korean, chinese'
      });
    }

    const vocab = await contentService.createVocabulary(req.body);

    res.status(201).json({
      success: true,
      message: 'Vocabulary created successfully',
      data: vocab
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error creating vocabulary:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to create vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * PUT /api/admin/vocabulary/:id
 * Update vocabulary
 */
const updateVocabulary = async (req, res) => {
  try {
    const vocabId = parseInt(req.params.id);

    if (isNaN(vocabId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid vocabulary ID'
      });
    }

    const updates = req.body;

    if (!updates || Object.keys(updates).length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'No updates provided'
      });
    }

    const vocab = await contentService.updateVocabulary(vocabId, updates);

    res.json({
      success: true,
      message: 'Vocabulary updated successfully',
      data: vocab
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error updating vocabulary:', error);

    if (error.message === 'Vocabulary not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Vocabulary not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to update vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * DELETE /api/admin/vocabulary/:id
 * Delete vocabulary
 */
const deleteVocabulary = async (req, res) => {
  try {
    const vocabId = parseInt(req.params.id);

    if (isNaN(vocabId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid vocabulary ID'
      });
    }

    await contentService.deleteVocabulary(vocabId);

    res.json({
      success: true,
      message: 'Vocabulary deleted successfully'
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error deleting vocabulary:', error);

    if (error.message === 'Vocabulary not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Vocabulary not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to delete vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/vocabulary/bulk-delete
 * Bulk delete vocabulary
 */
const bulkDelete = async (req, res) => {
  try {
    const { vocabIds } = req.body;

    if (!Array.isArray(vocabIds) || vocabIds.length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'vocabIds must be a non-empty array'
      });
    }

    const count = await contentService.bulkDeleteVocabulary(vocabIds);

    res.json({
      success: true,
      message: `${count} vocabulary entries deleted successfully`,
      data: { count }
    });
  } catch (error) {
    console.error('[VOCABULARY_CONTROLLER] Error bulk deleting vocabulary:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to bulk delete vocabulary',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  listVocabulary,
  getVocabularyById,
  createVocabulary,
  updateVocabulary,
  deleteVocabulary,
  bulkDelete
};
