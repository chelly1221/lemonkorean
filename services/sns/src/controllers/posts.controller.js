const Post = require('../models/post.model');
const { query } = require('../config/database');

// ==================== Controller Functions ====================

/**
 * Get feed - posts from followed users
 * GET /api/sns/posts/feed
 * @query { cursor?, limit? }
 */
const getFeed = async (req, res) => {
  try {
    const userId = req.user.id;
    const { cursor, limit } = req.query;

    console.log(`[SNS] Getting feed for user: ${userId}`);

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const posts = await Post.getFeed(userId, { cursor, limit: parsedLimit });

    const nextCursor = posts.length === parsedLimit ? posts[posts.length - 1].created_at : null;

    res.json({
      success: true,
      posts,
      pagination: {
        nextCursor,
        limit: parsedLimit,
        hasMore: posts.length === parsedLimit
      }
    });
  } catch (error) {
    console.error('[SNS] Get feed error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get feed',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get discover - public posts for discovery
 * GET /api/sns/posts/discover
 * @query { cursor?, limit?, category? }
 */
const getDiscover = async (req, res) => {
  try {
    const userId = req.user ? req.user.id : null;
    const { cursor, limit, category } = req.query;

    console.log(`[SNS] Getting discover feed, user: ${userId || 'anonymous'}`);

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const posts = await Post.getDiscover({ cursor, limit: parsedLimit, category, userId });

    const nextCursor = posts.length === parsedLimit ? posts[posts.length - 1].created_at : null;

    res.json({
      success: true,
      posts,
      pagination: {
        nextCursor,
        limit: parsedLimit,
        hasMore: posts.length === parsedLimit
      }
    });
  } catch (error) {
    console.error('[SNS] Get discover error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get discover feed',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get post by ID
 * GET /api/sns/posts/:id
 */
const getById = async (req, res) => {
  try {
    const postId = parseInt(req.params.id);
    const userId = req.user ? req.user.id : null;

    console.log(`[SNS] Getting post: ${postId}`);

    if (!postId || isNaN(postId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid post ID'
      });
    }

    const post = await Post.findById(postId);

    if (!post) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Post not found'
      });
    }

    // Check if the current user has liked this post
    let isLiked = false;
    if (userId) {
      const likeResult = await query(
        'SELECT EXISTS(SELECT 1 FROM post_likes WHERE post_id = $1 AND user_id = $2) AS is_liked',
        [postId, userId]
      );
      isLiked = likeResult.rows[0].is_liked;
    }

    res.json({
      success: true,
      post: {
        ...post,
        is_liked: isLiked
      }
    });
  } catch (error) {
    console.error('[SNS] Get post error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get post',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get posts by user
 * GET /api/sns/posts/user/:userId
 * @query { cursor?, limit? }
 */
const getByUser = async (req, res) => {
  try {
    const targetUserId = parseInt(req.params.userId);
    const requesterId = req.user ? req.user.id : null;
    const { cursor, limit } = req.query;

    console.log(`[SNS] Getting posts for user: ${targetUserId}, requester: ${requesterId || 'anonymous'}`);

    if (!targetUserId || isNaN(targetUserId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const posts = await Post.getByUser(targetUserId, { cursor, limit: parsedLimit, requesterId });

    const nextCursor = posts.length === parsedLimit ? posts[posts.length - 1].created_at : null;

    res.json({
      success: true,
      posts,
      pagination: {
        nextCursor,
        limit: parsedLimit,
        hasMore: posts.length === parsedLimit
      }
    });
  } catch (error) {
    console.error('[SNS] Get user posts error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get user posts',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Create a new post
 * POST /api/sns/posts
 * @body { content, category?, tags?, visibility?, imageUrls? }
 */
const create = async (req, res) => {
  try {
    const userId = req.user.id;
    const { content, category, tags, visibility, imageUrls } = req.body;

    console.log(`[SNS] Creating post for user: ${userId}`);

    // Validate content
    if (!content || content.trim().length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Content is required'
      });
    }

    if (content.length > 2000) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Content must be 2000 characters or less'
      });
    }

    // Validate visibility
    const validVisibilities = ['public', 'followers', 'private'];
    if (visibility && !validVisibilities.includes(visibility)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: `Invalid visibility. Must be one of: ${validVisibilities.join(', ')}`
      });
    }

    const post = await Post.create(userId, { content, category, tags, visibility, imageUrls });

    console.log(`[SNS] Post created successfully: ${post.id}`);

    res.status(201).json({
      success: true,
      message: 'Post created successfully',
      post
    });
  } catch (error) {
    console.error('[SNS] Create post error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to create post',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Delete a post (soft delete)
 * DELETE /api/sns/posts/:id
 */
const deletePost = async (req, res) => {
  try {
    const postId = parseInt(req.params.id);
    const userId = req.user.id;

    console.log(`[SNS] Deleting post: ${postId} by user: ${userId}`);

    if (!postId || isNaN(postId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid post ID'
      });
    }

    const deletedPost = await Post.delete(postId, userId);

    if (!deletedPost) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Post not found or you do not have permission to delete it'
      });
    }

    console.log(`[SNS] Post deleted successfully: ${postId}`);

    res.json({
      success: true,
      message: 'Post deleted successfully'
    });
  } catch (error) {
    console.error('[SNS] Delete post error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to delete post',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Like a post
 * POST /api/sns/posts/:id/like
 */
const like = async (req, res) => {
  try {
    const postId = parseInt(req.params.id);
    const userId = req.user.id;

    console.log(`[SNS] User ${userId} liking post: ${postId}`);

    if (!postId || isNaN(postId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid post ID'
      });
    }

    // Check post exists
    const post = await Post.findById(postId);
    if (!post) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Post not found'
      });
    }

    // Insert like (ignore if already exists)
    const sql = `
      INSERT INTO post_likes (post_id, user_id, created_at)
      VALUES ($1, $2, NOW())
      ON CONFLICT (post_id, user_id) DO NOTHING
      RETURNING *
    `;

    const result = await query(sql, [postId, userId]);

    if (result.rows[0]) {
      // Only increment if it was a new like
      await Post.incrementLikeCount(postId);
      console.log(`[SNS] Post ${postId} liked by user ${userId}`);
    }

    res.json({
      success: true,
      message: 'Post liked successfully'
    });
  } catch (error) {
    console.error('[SNS] Like post error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to like post',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Unlike a post
 * DELETE /api/sns/posts/:id/like
 */
const unlike = async (req, res) => {
  try {
    const postId = parseInt(req.params.id);
    const userId = req.user.id;

    console.log(`[SNS] User ${userId} unliking post: ${postId}`);

    if (!postId || isNaN(postId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid post ID'
      });
    }

    // Delete like
    const sql = `
      DELETE FROM post_likes
      WHERE post_id = $1 AND user_id = $2
      RETURNING *
    `;

    const result = await query(sql, [postId, userId]);

    if (result.rows[0]) {
      await Post.decrementLikeCount(postId);
      console.log(`[SNS] Post ${postId} unliked by user ${userId}`);
    }

    res.json({
      success: true,
      message: 'Post unliked successfully'
    });
  } catch (error) {
    console.error('[SNS] Unlike post error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to unlike post',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Export Functions ====================

module.exports = {
  getFeed,
  getDiscover,
  getById,
  getByUser,
  create,
  delete: deletePost,
  like,
  unlike
};
