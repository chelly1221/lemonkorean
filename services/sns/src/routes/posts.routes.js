const express = require('express');
const router = express.Router();
const postsController = require('../controllers/posts.controller');
const { requireAuth, optionalAuth } = require('../middleware/auth.middleware');

/**
 * @route   GET /api/sns/posts/feed
 * @desc    Get feed - posts from followed users
 * @access  Private
 * @query   { cursor?, limit? }
 */
router.get('/feed', requireAuth, postsController.getFeed);

/**
 * @route   GET /api/sns/posts/discover
 * @desc    Get discover - public posts for discovery
 * @access  Public (optional auth for personalization)
 * @query   { cursor?, limit?, category? }
 */
router.get('/discover', optionalAuth, postsController.getDiscover);

/**
 * @route   GET /api/sns/posts/user/:userId
 * @desc    Get posts by a specific user
 * @access  Public (optional auth for visibility)
 * @query   { cursor?, limit? }
 */
router.get('/user/:userId', optionalAuth, postsController.getByUser);

/**
 * @route   GET /api/sns/posts/:id
 * @desc    Get a single post by ID
 * @access  Public (optional auth for like status)
 */
router.get('/:id', optionalAuth, postsController.getById);

/**
 * @route   POST /api/sns/posts
 * @desc    Create a new post
 * @access  Private
 * @body    { content, category?, tags?, visibility?, imageUrls? }
 */
router.post('/', requireAuth, postsController.create);

/**
 * @route   DELETE /api/sns/posts/:id
 * @desc    Delete a post (soft delete)
 * @access  Private (must be author)
 */
router.delete('/:id', requireAuth, postsController.delete);

/**
 * @route   POST /api/sns/posts/:id/like
 * @desc    Like a post
 * @access  Private
 */
router.post('/:id/like', requireAuth, postsController.like);

/**
 * @route   DELETE /api/sns/posts/:id/like
 * @desc    Unlike a post
 * @access  Private
 */
router.delete('/:id/like', requireAuth, postsController.unlike);

module.exports = router;
