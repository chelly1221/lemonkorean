const UserProfile = require('../models/user-profile.model');

// ==================== Controller Functions ====================

/**
 * Get user profile
 * GET /api/sns/profiles/:userId
 */
const getProfile = async (req, res) => {
  try {
    const targetUserId = parseInt(req.params.userId);
    const requesterId = req.user ? req.user.id : null;

    console.log(`[SNS] Getting profile for user: ${targetUserId}, requester: ${requesterId || 'anonymous'}`);

    if (!targetUserId || isNaN(targetUserId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const profile = await UserProfile.getProfile(targetUserId, requesterId);

    if (!profile) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    console.log(`[SNS] Profile retrieved for user: ${targetUserId}`);

    res.json({
      success: true,
      profile
    });
  } catch (error) {
    console.error('[SNS] Get profile error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get profile',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Update own profile
 * PUT /api/sns/profiles
 * @body { bio? }
 */
const updateProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const { bio } = req.body;

    console.log(`[SNS] Updating profile for user: ${userId}`);

    // Validate bio
    if (bio !== undefined && bio !== null && bio.length > 500) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Bio must be 500 characters or less'
      });
    }

    const profile = await UserProfile.updateProfile(userId, { bio: bio || null });

    if (!profile) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    console.log(`[SNS] Profile updated for user: ${userId}`);

    res.json({
      success: true,
      message: 'Profile updated successfully',
      profile
    });
  } catch (error) {
    console.error('[SNS] Update profile error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to update profile',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Search users by name
 * GET /api/sns/profiles/search
 * @query { q, limit? }
 */
const search = async (req, res) => {
  try {
    const { q, limit } = req.query;

    console.log(`[SNS] Searching users with query: ${q}`);

    if (!q || q.trim().length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Search query is required'
      });
    }

    if (q.trim().length < 2) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Search query must be at least 2 characters'
      });
    }

    const parsedLimit = Math.min(parseInt(limit) || 20, 50);
    const users = await UserProfile.search(q.trim(), { limit: parsedLimit });

    res.json({
      success: true,
      users,
      count: users.length
    });
  } catch (error) {
    console.error('[SNS] Search users error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to search users',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get suggested users to follow
 * GET /api/sns/profiles/suggested
 * @query { limit? }
 */
const getSuggested = async (req, res) => {
  try {
    const userId = req.user.id;
    const { limit } = req.query;

    console.log(`[SNS] Getting suggested users for user: ${userId}`);

    const parsedLimit = Math.min(parseInt(limit) || 10, 30);
    const users = await UserProfile.getSuggested(userId, { limit: parsedLimit });

    res.json({
      success: true,
      users,
      count: users.length
    });
  } catch (error) {
    console.error('[SNS] Get suggested users error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get suggested users',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Export Functions ====================

module.exports = {
  getProfile,
  updateProfile,
  search,
  getSuggested
};
