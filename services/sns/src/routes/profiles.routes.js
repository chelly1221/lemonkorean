const express = require('express');
const router = express.Router();
const profilesController = require('../controllers/profiles.controller');
const { requireAuth, optionalAuth } = require('../middleware/auth.middleware');

/**
 * @route   GET /api/sns/profiles/search
 * @desc    Search users by name
 * @access  Private
 * @query   { q, limit? }
 */
router.get('/search', requireAuth, profilesController.search);

/**
 * @route   GET /api/sns/profiles/suggested
 * @desc    Get suggested users to follow
 * @access  Private
 * @query   { limit? }
 */
router.get('/suggested', requireAuth, profilesController.getSuggested);

/**
 * @route   GET /api/sns/profiles/:userId
 * @desc    Get user profile
 * @access  Public (optional auth for is_following flag)
 */
router.get('/:userId', optionalAuth, profilesController.getProfile);

/**
 * @route   PUT /api/sns/profiles
 * @desc    Update own profile (bio)
 * @access  Private
 * @body    { bio? }
 */
router.put('/', requireAuth, profilesController.updateProfile);

module.exports = router;
