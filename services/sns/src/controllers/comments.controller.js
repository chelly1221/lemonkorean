const Comment = require('../models/comment.model');
const Post = require('../models/post.model');
const Block = require('../models/block.model');
const { moderateText, logModeration } = require('../utils/moderation');

// ==================== Controller Functions ====================

/**
 * Get comments for a post
 * GET /api/sns/comments/post/:postId
 * @query { cursor?, limit? }
 */
const getByPost = async (req, res) => {
  try {
    const postId = parseInt(req.params.postId);
    const userId = req.user ? req.user.id : null;
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

    // Check block relationship with post author
    if (userId && userId !== post.user_id) {
      const blocked = await Block.isBlockedEitherWay(userId, post.user_id);
      if (blocked) {
        return res.status(404).json({
          error: 'Not Found',
          message: 'Post not found'
        });
      }
    }

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const comments = await Comment.getByPost(postId, { cursor, limit: parsedLimit, userId });

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

    // Check block relationship - blocked users cannot comment on each other's posts
    if (userId !== post.user_id) {
      const blocked = await Block.isBlockedEitherWay(userId, post.user_id);
      if (blocked) {
        return res.status(403).json({
          error: 'Forbidden',
          message: 'Cannot interact with this post'
        });
      }
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

    // Content moderation
    let moderationResult = null;
    let moderationStatus = 'unmoderated';
    try {
      moderationResult = await moderateText(content, 'comment');
      console.log(`[SNS] Comment moderation: ${moderationResult.action} (score: ${moderationResult.max_score})`);

      if (moderationResult.action === 'reject') {
        return res.status(422).json({
          error: 'Content Rejected',
          message: 'Your comment was flagged by our content moderation system',
          moderation: {
            action: moderationResult.action,
            categories: moderationResult.categories,
          }
        });
      }
      moderationStatus = moderationResult.action === 'flag' ? 'flagged' : 'allowed';
    } catch (moderationError) {
      console.warn('[SNS] Moderation service unavailable:', moderationError.message);
    }

    const comment = await Comment.create(postId, userId, {
      content,
      parentId: parentId ? parseInt(parentId) : null,
      moderationStatus,
      moderationCategories: moderationResult?.categories ?? null,
      moderationScore: moderationResult?.max_score ?? null,
    });

    // Log moderation result (non-blocking)
    if (moderationResult) {
      logModeration({
        contentType: 'comment', contentId: comment.id, userId,
        contentText: content, result: moderationResult,
      });
    }

    console.log(`[SNS] Comment created successfully: ${comment.id} (moderation: ${moderationStatus})`);

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
