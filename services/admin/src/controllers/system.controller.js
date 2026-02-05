const systemService = require('../services/system-monitoring.service');

/**
 * System Controller
 * Handles HTTP requests for system logs
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

module.exports = {
  getLogs
};
