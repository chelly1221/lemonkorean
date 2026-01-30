const analyticsService = require('../services/analytics.service');

/**
 * Analytics Controller
 * Handles HTTP requests for analytics and statistics
 */

/**
 * GET /api/admin/analytics/overview
 * Get dashboard overview statistics
 */
const getOverview = async (req, res) => {
  try {
    const overview = await analyticsService.getDashboardOverview();

    res.json({
      success: true,
      data: overview
    });
  } catch (error) {
    console.error('[ANALYTICS_CONTROLLER] Error getting overview:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve analytics overview',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/analytics/users
 * Get user analytics with time series
 */
const getUserAnalytics = async (req, res) => {
  try {
    const { period = '1d' } = req.query;

    // Validate period
    const validPeriods = ['1d', '7d', '30d', '365d'];
    if (!validPeriods.includes(period)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: `Invalid period. Must be one of: ${validPeriods.join(', ')}`
      });
    }

    const analytics = await analyticsService.getUserAnalytics(period);

    res.json({
      success: true,
      data: analytics
    });
  } catch (error) {
    console.error('[ANALYTICS_CONTROLLER] Error getting user analytics:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve user analytics',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/analytics/engagement
 * Get engagement metrics
 */
const getEngagement = async (req, res) => {
  try {
    const { period = '1d' } = req.query;

    // Validate period
    const validPeriods = ['1d', '7d', '30d', '365d'];
    if (!validPeriods.includes(period)) {
      return res.status(400).json({
        error: 'Bad Request',
        message: `Invalid period. Must be one of: ${validPeriods.join(', ')}`
      });
    }

    const engagement = await analyticsService.getEngagementMetrics(period);

    res.json({
      success: true,
      data: engagement
    });
  } catch (error) {
    console.error('[ANALYTICS_CONTROLLER] Error getting engagement:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve engagement metrics',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * GET /api/admin/analytics/content
 * Get content statistics
 */
const getContentStats = async (req, res) => {
  try {
    const stats = await analyticsService.getContentStats();

    res.json({
      success: true,
      data: stats
    });
  } catch (error) {
    console.error('[ANALYTICS_CONTROLLER] Error getting content stats:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to retrieve content statistics',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

module.exports = {
  getOverview,
  getUserAnalytics,
  getEngagement,
  getContentStats
};
