const { query } = require('../config/database');

/**
 * Audit Logging Middleware
 * Logs all admin actions to admin_audit_logs table
 * Must be used after requireAuth and requireAdmin middleware
 */

/**
 * Create audit log middleware
 * @param {string} action - Action being performed (e.g., 'user.update', 'lesson.delete')
 * @param {string} resourceType - Type of resource (e.g., 'user', 'lesson', 'media')
 * @returns {Function} Express middleware
 */
const auditLog = (action, resourceType) => {
  return async (req, res, next) => {
    // Store original res.json to intercept response
    const originalJson = res.json.bind(res);

    res.json = async (body) => {
      try {
        // Determine status based on HTTP status code
        // DB constraint allows: 'success', 'failed', 'pending'
        const status = res.statusCode >= 200 && res.statusCode < 300 ? 'success' : 'failed';

        // Extract resource ID from params or body
        const resourceId = req.params.id || req.params.userId || req.params.lessonId || req.body.id || null;

        // Capture request body changes (exclude sensitive fields)
        const changes = {};
        if (req.body && Object.keys(req.body).length > 0) {
          Object.keys(req.body).forEach(key => {
            if (!['password', 'password_hash', 'token', 'secret'].includes(key.toLowerCase())) {
              changes[key] = req.body[key];
            }
          });
        }

        // Get client IP
        const ipAddress = req.ip || req.connection.remoteAddress || null;

        // Get user agent
        const userAgent = req.headers['user-agent'] || null;

        // Insert audit log
        await query(
          `INSERT INTO admin_audit_logs
           (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent, status)
           VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
          [
            req.user?.id || null,
            req.user?.email || 'unknown',
            action,
            resourceType,
            resourceId,
            Object.keys(changes).length > 0 ? JSON.stringify(changes) : null,
            ipAddress,
            userAgent,
            status
          ]
        );

        console.log(`[AUDIT] ${req.user?.email} - ${action} - ${resourceType}:${resourceId} - ${status}`);
      } catch (error) {
        console.error('[AUDIT] Failed to log audit entry:', error);
        // Don't fail the request if audit logging fails
      }

      // Call original res.json
      return originalJson(body);
    };

    next();
  };
};

/**
 * Get audit logs for a specific resource
 * @param {string} resourceType - Type of resource
 * @param {number} resourceId - Resource ID
 * @param {number} limit - Number of logs to retrieve
 * @returns {Array} Audit log entries
 */
const getAuditLogs = async (resourceType, resourceId, limit = 50) => {
  try {
    const result = await query(
      `SELECT
        id,
        admin_id,
        admin_email,
        action,
        resource_type,
        resource_id,
        changes,
        ip_address,
        user_agent,
        status,
        created_at
      FROM admin_audit_logs
      WHERE resource_type = $1 AND resource_id = $2
      ORDER BY created_at DESC
      LIMIT $3`,
      [resourceType, resourceId, limit]
    );

    return result.rows;
  } catch (error) {
    console.error('[AUDIT] Error getting audit logs:', error);
    throw error;
  }
};

/**
 * Get admin's recent actions
 * @param {number} adminId - Admin user ID
 * @param {number} limit - Number of logs to retrieve
 * @returns {Array} Audit log entries
 */
const getAdminActions = async (adminId, limit = 100) => {
  try {
    const result = await query(
      `SELECT
        id,
        admin_email,
        action,
        resource_type,
        resource_id,
        changes,
        status,
        created_at
      FROM admin_audit_logs
      WHERE admin_id = $1
      ORDER BY created_at DESC
      LIMIT $2`,
      [adminId, limit]
    );

    return result.rows;
  } catch (error) {
    console.error('[AUDIT] Error getting admin actions:', error);
    throw error;
  }
};

/**
 * Get all audit logs with pagination and filtering
 * @param {Object} options - Query options
 * @returns {Object} Paginated audit logs
 */
const getAllAuditLogs = async (options = {}) => {
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
    } = options;

    const offset = (page - 1) * limit;

    // Build WHERE clause
    const conditions = [];
    const params = [];
    let paramIndex = 1;

    if (action) {
      conditions.push(`action = $${paramIndex}`);
      params.push(action);
      paramIndex++;
    }

    if (resourceType) {
      conditions.push(`resource_type = $${paramIndex}`);
      params.push(resourceType);
      paramIndex++;
    }

    if (adminId) {
      conditions.push(`admin_id = $${paramIndex}`);
      params.push(adminId);
      paramIndex++;
    }

    if (status) {
      conditions.push(`status = $${paramIndex}`);
      params.push(status);
      paramIndex++;
    }

    if (startDate) {
      conditions.push(`created_at >= $${paramIndex}`);
      params.push(startDate);
      paramIndex++;
    }

    if (endDate) {
      conditions.push(`created_at <= $${paramIndex}`);
      params.push(endDate);
      paramIndex++;
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    // Get total count
    const countResult = await query(
      `SELECT COUNT(*) as total FROM admin_audit_logs ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].total);

    // Get logs
    const logsResult = await query(
      `SELECT
        id,
        admin_id,
        admin_email,
        action,
        resource_type,
        resource_id,
        changes,
        ip_address,
        status,
        created_at
      FROM admin_audit_logs
      ${whereClause}
      ORDER BY created_at DESC
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`,
      [...params, limit, offset]
    );

    return {
      logs: logsResult.rows,
      total,
      page: parseInt(page),
      limit: parseInt(limit),
      totalPages: Math.ceil(total / limit)
    };
  } catch (error) {
    console.error('[AUDIT] Error getting all audit logs:', error);
    throw error;
  }
};

module.exports = {
  auditLog,
  getAuditLogs,
  getAdminActions,
  getAllAuditLogs
};
