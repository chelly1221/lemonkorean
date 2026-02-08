const systemService = require('../services/system-monitoring.service');
const db = require('../config/database');

/**
 * System Controller
 * Handles HTTP requests for system logs and storage reset flags
 */

/**
 * GET /api/admin/system/logs
 * Get system audit logs with pagination and filtering
 */
const getLogs = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 50,
      action = null,
      resourceType = null,
      adminId = null,
      status = null,
      startDate = null,
      endDate = null
    } = req.query;

    const options = {
      page: parseInt(page),
      limit: Math.min(parseInt(limit), 200),
      action,
      resourceType,
      adminId: adminId ? parseInt(adminId) : null,
      status,
      startDate,
      endDate
    };

    const logs = await systemService.getSystemLogs(options);

    res.json({
      success: true,
      data: logs.logs,
      pagination: {
        page: logs.page,
        limit: logs.limit,
        total: logs.total,
        totalPages: logs.totalPages
      }
    });
  } catch (error) {
    console.error('[SYSTEM_CONTROLLER] Error getting logs:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve system logs',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * POST /api/admin/system/storage-reset
 * Create a storage reset flag
 * Admin only
 */
const createStorageResetFlag = async (req, res) => {
  try {
    const { user_id = null, reason = null } = req.body;
    const adminId = req.user.id;

    // Validate user_id if provided
    if (user_id !== null) {
      const userCheck = await db.query(
        'SELECT id FROM users WHERE id = $1',
        [user_id]
      );
      if (userCheck.rows.length === 0) {
        return res.status(404).json({
          error: 'Not Found',
          message: `User with ID ${user_id} does not exist`
        });
      }
    }

    // Create the flag
    const result = await db.query(
      `INSERT INTO storage_reset_flags (user_id, admin_id, reason)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [user_id, adminId, reason]
    );

    const flag = result.rows[0];

    // Log the action to audit logs
    await db.query(
      `INSERT INTO admin_audit_logs
       (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        adminId,
        req.user.email,
        'CREATE_STORAGE_RESET_FLAG',
        'storage_reset_flag',
        flag.id,
        JSON.stringify({ user_id, reason, scope: user_id ? 'single_user' : 'all_users' }),
        req.ip || req.connection.remoteAddress,
        'success'
      ]
    );

    res.status(201).json({
      success: true,
      data: flag,
      message: user_id
        ? `Storage reset flag created for user ${user_id}`
        : 'Storage reset flag created for all users'
    });
  } catch (error) {
    console.error('[SYSTEM_CONTROLLER] Error creating storage reset flag:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to create storage reset flag',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/storage-reset/check
 * Check if there's a pending storage reset flag for the user
 * Public API (no authentication required)
 */
const checkStorageResetFlag = async (req, res) => {
  try {
    const { user_id = null } = req.query;
    const userId = user_id ? parseInt(user_id) : null;

    // Query for pending flags
    // Check both user-specific and global flags
    const result = await db.query(
      `SELECT id, reason
       FROM storage_reset_flags
       WHERE status = 'pending'
         AND expires_at > NOW()
         AND (user_id = $1 OR user_id IS NULL)
       ORDER BY created_at DESC
       LIMIT 1`,
      [userId]
    );

    if (result.rows.length > 0) {
      const flag = result.rows[0];
      res.json({
        reset_required: true,
        flag_id: flag.id,
        reason: flag.reason
      });
    } else {
      res.json({
        reset_required: false
      });
    }
  } catch (error) {
    console.error('[SYSTEM_CONTROLLER] Error checking storage reset flag:', error);

    // Fail gracefully - don't block app startup
    res.json({
      reset_required: false,
      error: 'Check failed'
    });
  }
};

/**
 * POST /api/storage-reset/complete
 * Mark a storage reset flag as completed
 * Public API (no authentication required)
 */
const completeStorageResetFlag = async (req, res) => {
  try {
    const { flag_id } = req.body;

    if (!flag_id) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'flag_id is required'
      });
    }

    const ipAddress = req.ip || req.connection.remoteAddress;

    // Update the flag
    const result = await db.query(
      `UPDATE storage_reset_flags
       SET status = 'completed',
           completed_at = NOW(),
           executed_at = NOW(),
           executed_from_ip = $1
       WHERE id = $2 AND status = 'pending'
       RETURNING *`,
      [ipAddress, flag_id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        error: 'Not Found',
        message: 'Storage reset flag not found or already completed'
      });
    }

    res.json({
      success: true,
      message: 'Storage reset flag marked as completed'
    });
  } catch (error) {
    console.error('[SYSTEM_CONTROLLER] Error completing storage reset flag:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to complete storage reset flag',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/system/storage-reset
 * List storage reset flags with pagination
 * Admin only
 */
const listStorageResetFlags = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      status = null
    } = req.query;

    const pageNum = parseInt(page);
    const limitNum = Math.min(parseInt(limit), 100);
    const offset = (pageNum - 1) * limitNum;

    // Build query
    let whereClause = '';
    const queryParams = [];

    if (status) {
      whereClause = 'WHERE status = $1';
      queryParams.push(status);
    }

    // Get total count
    const countResult = await db.query(
      `SELECT COUNT(*) FROM storage_reset_flags ${whereClause}`,
      queryParams
    );
    const total = parseInt(countResult.rows[0].count);

    // Get flags with admin and user info
    const flagsResult = await db.query(
      `SELECT
         f.*,
         a.name as admin_username,
         u.name as target_username
       FROM storage_reset_flags f
       JOIN users a ON f.admin_id = a.id
       LEFT JOIN users u ON f.user_id = u.id
       ${whereClause}
       ORDER BY f.created_at DESC
       LIMIT $${queryParams.length + 1} OFFSET $${queryParams.length + 2}`,
      [...queryParams, limitNum, offset]
    );

    res.json({
      success: true,
      data: flagsResult.rows,
      pagination: {
        page: pageNum,
        limit: limitNum,
        total,
        totalPages: Math.ceil(total / limitNum)
      }
    });
  } catch (error) {
    console.error('[SYSTEM_CONTROLLER] Error listing storage reset flags:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve storage reset flags',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  getLogs,
  createStorageResetFlag,
  checkStorageResetFlag,
  completeStorageResetFlag,
  listStorageResetFlags
};
