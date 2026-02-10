const Follow = require('../models/follow.model');
const Block = require('../models/block.model');

// ==================== Controller Functions ====================

/**
 * Follow a user
 * POST /api/sns/follows/:userId
 */
const follow = async (req, res) => {
  try {
    const followerId = req.user.id;
    const followingId = parseInt(req.params.userId);

    console.log(`[SNS] User ${followerId} following user ${followingId}`);

    if (!followingId || isNaN(followingId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    // Cannot follow yourself
    if (followerId === followingId) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'You cannot follow yourself'
      });
    }

    // Check if blocked
    const isBlocked = await Block.isBlocked(followingId, followerId);
    if (isBlocked) {
      return res.status(403).json({
        error: 'Forbidden',
        message: 'You cannot follow this user'
      });
    }

    const followRecord = await Follow.follow(followerId, followingId);

    if (!followRecord) {
      return res.json({
        success: true,
        message: 'Already following this user'
      });
    }

    console.log(`[SNS] Follow successful: ${followerId} -> ${followingId}`);

    res.status(201).json({
      success: true,
      message: 'Followed successfully',
      follow: followRecord
    });
  } catch (error) {
    console.error('[SNS] Follow error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to follow user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Unfollow a user
 * DELETE /api/sns/follows/:userId
 */
const unfollow = async (req, res) => {
  try {
    const followerId = req.user.id;
    const followingId = parseInt(req.params.userId);

    console.log(`[SNS] User ${followerId} unfollowing user ${followingId}`);

    if (!followingId || isNaN(followingId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const unfollowRecord = await Follow.unfollow(followerId, followingId);

    if (!unfollowRecord) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'You are not following this user'
      });
    }

    console.log(`[SNS] Unfollow successful: ${followerId} -> ${followingId}`);

    res.json({
      success: true,
      message: 'Unfollowed successfully'
    });
  } catch (error) {
    console.error('[SNS] Unfollow error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to unfollow user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get followers of a user
 * GET /api/sns/follows/:userId/followers
 * @query { cursor?, limit? }
 */
const getFollowers = async (req, res) => {
  try {
    const userId = parseInt(req.params.userId);
    const { cursor, limit } = req.query;

    console.log(`[SNS] Getting followers for user: ${userId}`);

    if (!userId || isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const parsedCursor = cursor ? parseInt(cursor) : null;
    const followers = await Follow.getFollowers(userId, { cursor: parsedCursor, limit: parsedLimit });

    const nextCursor = followers.length === parsedLimit ? followers[followers.length - 1].follow_id : null;

    res.json({
      success: true,
      followers,
      pagination: {
        nextCursor,
        limit: parsedLimit,
        hasMore: followers.length === parsedLimit
      }
    });
  } catch (error) {
    console.error('[SNS] Get followers error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get followers',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get users that a user is following
 * GET /api/sns/follows/:userId/following
 * @query { cursor?, limit? }
 */
const getFollowing = async (req, res) => {
  try {
    const userId = parseInt(req.params.userId);
    const { cursor, limit } = req.query;

    console.log(`[SNS] Getting following for user: ${userId}`);

    if (!userId || isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const parsedCursor = cursor ? parseInt(cursor) : null;
    const following = await Follow.getFollowing(userId, { cursor: parsedCursor, limit: parsedLimit });

    const nextCursor = following.length === parsedLimit ? following[following.length - 1].follow_id : null;

    res.json({
      success: true,
      following,
      pagination: {
        nextCursor,
        limit: parsedLimit,
        hasMore: following.length === parsedLimit
      }
    });
  } catch (error) {
    console.error('[SNS] Get following error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get following',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Export Functions ====================

module.exports = {
  follow,
  unfollow,
  getFollowers,
  getFollowing
};
