const userService = require('../services/user-management.service');
const { getAuditLogs } = require('../middleware/audit.middleware');
const { query } = require('../config/database');

/**
 * Users Controller
 * Handles HTTP requests for user management
 */

/**
 * GET /api/admin/users
 * List all users with pagination and filtering
 */
const listUsers = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      search = '',
      subscriptionType = null,
      isActive = null,
      role = null,
      sortBy = 'created_at',
      sortOrder = 'DESC'
    } = req.query;

    // Convert string booleans to actual booleans
    let isActiveBool = null;
    if (isActive === 'true') isActiveBool = true;
    if (isActive === 'false') isActiveBool = false;

    const options = {
      page: parseInt(page),
      limit: Math.min(parseInt(limit), 100), // Max 100 per page
      search,
      subscriptionType,
      isActive: isActiveBool,
      role,
      sortBy,
      sortOrder: sortOrder.toUpperCase()
    };

    const result = await userService.listUsers(options);

    res.json({
      success: true,
      data: result.users,
      pagination: {
        page: result.page,
        limit: result.limit,
        total: result.total,
        totalPages: result.totalPages
      }
    });
  } catch (error) {
    console.error('[USERS_CONTROLLER] Error listing users:', error);
    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve users',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/users/:id
 * Get user details with statistics
 */
const getUserById = async (req, res) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const result = await userService.getUserDetails(userId);

    res.json({
      success: true,
      data: result
    });
  } catch (error) {
    console.error('[USERS_CONTROLLER] Error getting user:', error);

    if (error.message === 'User not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * PUT /api/admin/users/:id
 * Update user
 */
const updateUser = async (req, res) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const updates = req.body;

    if (!updates || Object.keys(updates).length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'No updates provided'
      });
    }

    const updatedUser = await userService.updateUser(userId, updates, req.user.id);

    res.json({
      success: true,
      message: 'User updated successfully',
      data: updatedUser
    });
  } catch (error) {
    console.error('[USERS_CONTROLLER] Error updating user:', error);

    if (error.message === 'User not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    if (error.message.includes('Invalid fields') || error.message.includes('Cannot modify')) {
      return res.status(400).json({
        error: 'Bad Request',
        message: error.message
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to update user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * PUT /api/admin/users/:id/ban
 * Ban or unban user
 */
const banUser = async (req, res) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const { banned, ban_reason } = req.body;

    if (typeof banned !== 'boolean') {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'banned field must be a boolean'
      });
    }

    if (banned && !ban_reason) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'ban_reason is required when banning a user'
      });
    }

    // Update user ban status
    const updates = {
      banned: banned,
      ban_reason: banned ? ban_reason : null,
      banned_at: banned ? new Date().toISOString() : null
    };

    const result = await query(
      `UPDATE users
       SET banned = $1, ban_reason = $2, banned_at = $3
       WHERE id = $4
       RETURNING id, email, name, subscription_type, language_preference,
                 email_verified, is_active, role, banned, ban_reason, banned_at,
                 created_at, last_login`,
      [updates.banned, updates.ban_reason, updates.banned_at, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    // Invalidate caches
    await userService.invalidateUserCaches(userId);

    res.json({
      success: true,
      message: `User ${banned ? 'banned' : 'unbanned'} successfully`,
      data: result.rows[0]
    });
  } catch (error) {
    console.error('[USERS_CONTROLLER] Error banning user:', error);

    if (error.message === 'User not found') {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    if (error.message.includes('Cannot ban')) {
      return res.status(400).json({
        error: 'Bad Request',
        message: error.message
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to ban/unban user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/users/:id/activity
 * Get user activity logs
 */
const getUserActivity = async (req, res) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const limit = Math.min(parseInt(req.query.limit) || 50, 200);

    const activities = await userService.getUserActivity(userId, limit);

    res.json({
      success: true,
      data: activities
    });
  } catch (error) {
    console.error('[USERS_CONTROLLER] Error getting user activity:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve user activity',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/users/:id/audit-logs
 * Get audit logs for a specific user (actions performed on this user)
 */
const getUserAuditLogs = async (req, res) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    const limit = Math.min(parseInt(req.query.limit) || 50, 200);

    const logs = await getAuditLogs('user', userId, limit);

    res.json({
      success: true,
      data: logs
    });
  } catch (error) {
    console.error('[USERS_CONTROLLER] Error getting audit logs:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve audit logs',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * DELETE /api/admin/users/:id
 * Delete a user
 */
const deleteUser = async (req, res) => {
  try {
    const userId = parseInt(req.params.id);

    if (isNaN(userId)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Invalid user ID'
      });
    }

    // Check if user exists
    const userCheck = await query(
      'SELECT id FROM users WHERE id = $1',
      [userId]
    );

    if (userCheck.rows.length === 0) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    // Delete user (cascade will handle related records)
    await query('DELETE FROM users WHERE id = $1', [userId]);

    // Invalidate caches
    await userService.invalidateUserCaches(userId);

    console.log(`[USERS_CONTROLLER] User deleted: ${userId}`);

    res.json({
      success: true,
      message: 'User deleted successfully'
    });
  } catch (error) {
    console.error('[USERS_CONTROLLER] Error deleting user:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to delete user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  listUsers,
  getUserById,
  updateUser,
  banUser,
  deleteUser,
  getUserActivity,
  getUserAuditLogs
};
