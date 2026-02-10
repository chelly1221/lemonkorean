const express = require('express');
const router = express.Router();
const blocksController = require('../controllers/blocks.controller');
const { requireAuth } = require('../middleware/auth.middleware');

/**
 * @route   POST /api/sns/blocks/:userId
 * @desc    Block a user
 * @access  Private
 */
router.post('/:userId', requireAuth, blocksController.block);

/**
 * @route   DELETE /api/sns/blocks/:userId
 * @desc    Unblock a user
 * @access  Private
 */
router.delete('/:userId', requireAuth, blocksController.unblock);

module.exports = router;
