const Comment = require('../models/comment.model');
const Post = require('../models/post.model');

// ==================== Controller Functions ====================

/**
 * Get comments for a post
 * GET /api/sns/comments/post/:postId
 * @query { cursor?, limit? }
 */
const getByPost = async (req, res) => {
  try {
    const postId = parseInt(req.params.postId);
    const { cursor, limit } = req.query;

    console.log(`[SNS] Getting comments for post: ${postId}`);

    if (!postId || isNaN(postId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid post ID'
      });
    }

    // Verify post exists
    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Post not found'
      });
    }

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const comments = await Comment.getByPost(postId, { cursor, limit: parsedLimit });

    const nextCursor = comments.length === parsedLimit ? comments[comments.length - 1].created_at : null;

    res.json({
      success: true,
      comments,
      pagination: {
        nextCursor,
        limit: parsedLimit,
        hasMore: comments.length === parsedLimit
      }
    });
  } catch (error) {
    console.error('[SNS] Get comments error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get comments',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Create a comment
 * POST /api/sns/comments/post/:postId
 * @body { content, parentId? }
 */
const create = async (req, res) => {
  try {
    const postId = parseInt(req.params.postId);
    const userId = req.user.id;
    const { content, parentId } = req.body;

    console.log(`[SNS] Creating comment on post: ${postId} by user: ${userId}`);

    if (!postId || isNaN(postId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid post ID'
      });
    }

    // Validate content
    if (!content || content.trim().length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Content is required'
      });
    }

    if (content.length > 1000) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Comment must be 1000 characters or less'
      });
    }

    // Verify post exists
    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Post not found'
      });
    }

    // If parentId provided, verify parent comment exists
    if (parentId) {
      const parentComment = await Comment.findById(parseInt(parentId));
      if (!parentComment) {
        return res.status(404).json({
          error: 'Not Found',
          message: 'Parent comment not found'
        });
      }
    }

    const comment = await Comment.create(postId, userId, { content, parentId: parentId ? parseInt(parentId) : null });

    console.log(`[SNS] Comment created successfully: ${comment.id}`);

    res.status(201).json({
      success: true,
      message: 'Comment created successfully',
      comment
    });
  } catch (error) {
    console.error('[SNS] Create comment error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to create comment',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Delete a comment (soft delete)
 * DELETE /api/sns/comments/:id
 */
const deleteComment = async (req, res) => {
  try {
    const commentId = parseInt(req.params.id);
    const userId = req.user.id;

    console.log(`[SNS] Deleting comment: ${commentId} by user: ${userId}`);

    if (!commentId || isNaN(commentId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid comment ID'
      });
    }

    const deletedComment = await Comment.delete(commentId, userId);

    if (!deletedComment) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Comment not found or you do not have permission to delete it'
      });
    }

    console.log(`[SNS] Comment deleted successfully: ${commentId}`);

    res.json({
      success: true,
      message: 'Comment deleted successfully'
    });
  } catch (error) {
    console.error('[SNS] Delete comment error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to delete comment',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Export Functions ====================

module.exports = {
  getByPost,
  create,
  delete: deleteComment
};
