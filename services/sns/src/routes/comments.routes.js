const express = require('express');
const router = express.Router();
const commentsController = require('../controllers/comments.controller');
const { requireAuth, optionalAuth } = require('../middleware/auth.middleware');

/**
 * @route   GET /api/sns/comments/post/:postId
 * @desc    Get comments for a post
 * @access  Public (optional auth)
 * @query   { cursor?, limit? }
 */
router.get('/post/:postId', optionalAuth, commentsController.getByPost);

/**
 * @route   POST /api/sns/comments/post/:postId
 * @desc    Create a comment on a post
 * @access  Private
 * @body    { content, parentId? }
 */
router.post('/post/:postId', requireAuth, commentsController.create);

/**
 * @route   DELETE /api/sns/comments/:id
 * @desc    Delete a comment (soft delete)
 * @access  Private (must be author)
 */
router.delete('/:id', requireAuth, commentsController.delete);

module.exports = router;
