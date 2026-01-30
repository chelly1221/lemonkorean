const systemService = require('../services/system-monitoring.service');

/**
 * System Controller
 * Handles HTTP requests for system monitoring
 */

/**
 * GET /api/admin/system/health
 * Get health status of all services
 */
const getHealth = async (req, res) => {
  try {
    const health = await systemService.checkAllServices();

    // Always return 200 OK so frontend can display the data
    // Frontend will check health.status to determine if services are healthy or degraded
    res.status(200).json({
      success: true,
      data: health
    });
  } catch (error) {
    console.error('[SYSTEM_CONTROLLER] Error checking health:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to check system health',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/system/logs
 * Get system audit logs with pagination
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
 * GET /api/admin/system/metrics
 * Get system performance metrics
 */
const getMetrics = async (req, res) => {
  try {
    const metrics = await systemService.getSystemMetrics();

    res.json({
      success: true,
      data: metrics
    });
  } catch (error) {
    console.error('[SYSTEM_CONTROLLER] Error getting metrics:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve system metrics',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  getHealth,
  getLogs,
  getMetrics
};
