const Report = require('../models/report.model');

// ==================== Controller Functions ====================

/**
 * Create a report
 * POST /api/sns/reports
 * @body { targetType, targetId, reason }
 */
const create = async (req, res) => {
  try {
    const reporterId = req.user.id;
    const { targetType, targetId, reason } = req.body;

    console.log(`[SNS] Creating report by user: ${reporterId}`);

    // Validate target type
    const validTargetTypes = ['post', 'comment', 'user'];
    if (!targetType || !validTargetTypes.includes(targetType)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: `Invalid target type. Must be one of: ${validTargetTypes.join(', ')}`
      });
    }

    // Validate target ID
    if (!targetId || isNaN(parseInt(targetId))) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Valid target ID is required'
      });
    }

    // Validate reason
    if (!reason || reason.trim().length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Reason is required'
      });
    }

    if (reason.length > 1000) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Reason must be 1000 characters or less'
      });
    }

    const report = await Report.create(reporterId, {
      targetType,
      targetId: parseInt(targetId),
      reason: reason.trim()
    });

    console.log(`[SNS] Report created successfully: ${report.id}`);

    res.status(201).json({
      success: true,
      message: 'Report submitted successfully',
      report
    });
  } catch (error) {
    console.error('[SNS] Create report error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to submit report',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Export Functions ====================

module.exports = {
  create
};
