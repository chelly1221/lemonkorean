const User = require('../models/user.model');
const { cacheHelpers } = require('../config/redis');

/**
 * User Management Service
 * Business logic for user administration
 */

/**
 * Get all users with pagination and filtering
 * @param {Object} options - Query options
 * @returns {Object} Paginated users
 */
const listUsers = async (options = {}) => {
  try {
    console.log('[USER_SERVICE] Listing users with options:', options);

    // Try to get from cache
    const cacheKey = `admin:users:list:${JSON.stringify(options)}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log('[USER_SERVICE] Returning cached user list');
      return cached;
    }

    // Get from database
    const result = await User.getAll(options);

    // Cache for 5 minutes
    await cacheHelpers.set(cacheKey, result, 300);

    return result;
  } catch (error) {
    console.error('[USER_SERVICE] Error listing users:', error);
    throw error;
  }
};

/**
 * Get user details with statistics
 * @param {number} userId - User ID
 * @returns {Object} User details and stats
 */
const getUserDetails = async (userId) => {
  try {
    console.log(`[USER_SERVICE] Getting details for user: ${userId}`);

    // Try to get from cache
    const cacheKey = `admin:user:details:${userId}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log('[USER_SERVICE] Returning cached user details');
      return cached;
    }

    // Get user info
    const user = await User.findById(userId);

    if (!user) {
      throw new Error('User not found');
    }

    // Get user stats
    const stats = await User.getUserStats(userId);

    // Remove password hash from response
    delete user.password_hash;

    const result = {
      user,
      stats: {
        completedLessons: parseInt(stats.completed_lessons) || 0,
        totalProgressEntries: parseInt(stats.total_progress_entries) || 0,
        averageQuizScore: parseFloat(stats.avg_quiz_score) || 0,
        lastActivity: stats.last_activity
      }
    };

    // Cache for 2 minutes
    await cacheHelpers.set(cacheKey, result, 120);

    return result;
  } catch (error) {
    console.error('[USER_SERVICE] Error getting user details:', error);
    throw error;
  }
};

/**
 * Update user
 * @param {number} userId - User ID
 * @param {Object} updates - Fields to update
 * @param {number} adminId - Admin performing the update
 * @returns {Object} Updated user
 */
const updateUser = async (userId, updates, adminId) => {
  try {
    console.log(`[USER_SERVICE] Admin ${adminId} updating user ${userId}:`, updates);

    // Validate updates
    const allowedUpdates = ['name', 'subscription_type', 'language_preference', 'email_verified', 'is_active', 'role'];
    const invalidFields = Object.keys(updates).filter(key => !allowedUpdates.includes(key));

    if (invalidFields.length > 0) {
      throw new Error(`Invalid fields: ${invalidFields.join(', ')}`);
    }

    // Prevent admins from updating their own role/status
    if (userId === adminId && (updates.role || updates.is_active !== undefined)) {
      throw new Error('Cannot modify your own role or active status');
    }

    // Update user
    const updatedUser = await User.update(userId, updates);

    // Remove password hash from response
    delete updatedUser.password_hash;

    // Invalidate caches
    await invalidateUserCaches(userId);

    return updatedUser;
  } catch (error) {
    console.error('[USER_SERVICE] Error updating user:', error);
    throw error;
  }
};

/**
 * Ban or unban user
 * @param {number} userId - User ID
 * @param {boolean} ban - True to ban, false to unban
 * @param {number} adminId - Admin performing the action
 * @returns {Object} Updated user
 */
const banUser = async (userId, ban, adminId) => {
  try {
    console.log(`[USER_SERVICE] Admin ${adminId} ${ban ? 'banning' : 'unbanning'} user ${userId}`);

    // Prevent admins from banning themselves
    if (userId === adminId) {
      throw new Error('Cannot ban/unban yourself');
    }

    // Update is_active status
    const updatedUser = await User.update(userId, { is_active: !ban });

    // Remove password hash from response
    delete updatedUser.password_hash;

    // Invalidate caches
    await invalidateUserCaches(userId);

    return updatedUser;
  } catch (error) {
    console.error('[USER_SERVICE] Error banning/unbanning user:', error);
    throw error;
  }
};

/**
 * Get user activity (from audit logs and user_progress)
 * @param {number} userId - User ID
 * @param {number} limit - Number of activities to retrieve
 * @returns {Array} User activities
 */
const getUserActivity = async (userId, limit = 50) => {
  try {
    console.log(`[USER_SERVICE] Getting activity for user: ${userId}`);

    const { query } = require('../config/database');

    // Get recent progress updates
    const progressResult = await query(
      `SELECT
        'progress' as activity_type,
        lesson_id as resource_id,
        status,
        quiz_score,
        completed_at as created_at
      FROM user_progress
      WHERE user_id = $1
      ORDER BY completed_at DESC
      LIMIT $2`,
      [userId, limit]
    );

    return progressResult.rows;
  } catch (error) {
    console.error('[USER_SERVICE] Error getting user activity:', error);
    throw error;
  }
};

/**
 * Invalidate all caches related to a user
 * @param {number} userId - User ID
 */
const invalidateUserCaches = async (userId) => {
  try {
    // Invalidate user details cache
    await cacheHelpers.del(`admin:user:details:${userId}`);

    // Invalidate user list caches (all variants)
    // This is a brute force approach; in production, consider using Redis SCAN or key patterns
    await cacheHelpers.del('admin:users:list:*');

    console.log(`[USER_SERVICE] Invalidated caches for user ${userId}`);
  } catch (error) {
    console.error('[USER_SERVICE] Error invalidating caches:', error);
    // Don't throw - cache invalidation failure shouldn't break the operation
  }
};

module.exports = {
  listUsers,
  getUserDetails,
  updateUser,
  banUser,
  getUserActivity
};
