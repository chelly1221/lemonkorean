const express = require('express');
const router = express.Router();
const followsController = require('../controllers/follows.controller');
const { requireAuth, optionalAuth } = require('../middleware/auth.middleware');

/**
 * @route   POST /api/sns/follows/:userId
 * @desc    Follow a user
 * @access  Private
 */
router.post('/:userId', requireAuth, followsController.follow);

/**
 * @route   DELETE /api/sns/follows/:userId
 * @desc    Unfollow a user
 * @access  Private
 */
router.delete('/:userId', requireAuth, followsController.unfollow);

/**
 * @route   GET /api/sns/follows/:userId/followers
 * @desc    Get followers of a user
 * @access  Public (optional auth)
 * @query   { cursor?, limit? }
 */
router.get('/:userId/followers', optionalAuth, followsController.getFollowers);

/**
 * @route   GET /api/sns/follows/:userId/following
 * @desc    Get users that a user is following
 * @access  Public (optional auth)
 * @query   { cursor?, limit? }
 */
router.get('/:userId/following', optionalAuth, followsController.getFollowing);

module.exports = router;
