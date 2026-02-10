const Block = require('../models/block.model');

// ==================== Controller Functions ====================

/**
 * Block a user
 * POST /api/sns/blocks/:userId
 */
const block = async (req, res) => {
  try {
    const blockerId = req.user.id;
    const blockedId = parseInt(req.params.userId);

    console.log(`[SNS] User ${blockerId} blocking user ${blockedId}`);

    if (!blockedId || isNaN(blockedId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    // Cannot block yourself
    if (blockerId === blockedId) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'You cannot block yourself'
      });
    }

    const blockRecord = await Block.block(blockerId, blockedId);

    if (!blockRecord) {
      return res.json({
        success: true,
        message: 'User is already blocked'
      });
    }

    console.log(`[SNS] Block successful: ${blockerId} -> ${blockedId}`);

    res.status(201).json({
      success: true,
      message: 'User blocked successfully'
    });
  } catch (error) {
    console.error('[SNS] Block error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to block user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Unblock a user
 * DELETE /api/sns/blocks/:userId
 */
const unblock = async (req, res) => {
  try {
    const blockerId = req.user.id;
    const blockedId = parseInt(req.params.userId);

    console.log(`[SNS] User ${blockerId} unblocking user ${blockedId}`);

    if (!blockedId || isNaN(blockedId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const unblockRecord = await Block.unblock(blockerId, blockedId);

    if (!unblockRecord) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User is not blocked'
      });
    }

    console.log(`[SNS] Unblock successful: ${blockerId} -> ${blockedId}`);

    res.json({
      success: true,
      message: 'User unblocked successfully'
    });
  } catch (error) {
    console.error('[SNS] Unblock error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to unblock user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Export Functions ====================

module.exports = {
  block,
  unblock
};
