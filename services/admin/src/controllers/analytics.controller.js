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
    console.error('[ANALYTICS_CONTROLLER] Error getting overview:', {
      error: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      endpoint: '/api/admin/analytics/overview'
    });

    // Try to return cached data as fallback
    try {
      const { cacheHelpers } = require('../config/redis');
      const cached = await cacheHelpers.get('admin:analytics:overview');
      if (cached) {
        console.log('[ANALYTICS_CONTROLLER] Returning stale cached data');
        return res.json({
          success: true,
          data: cached,
          warning: 'Using cached data due to database error'
        });
      }
    } catch (cacheError) {
      console.error('[ANALYTICS_CONTROLLER] Cache fallback failed:', cacheError);
    }

    // No cache available, return error with helpful message
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
    console.error('[ANALYTICS_CONTROLLER] Error getting user analytics:', {
      error: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      endpoint: '/api/admin/analytics/users',
      period: req.query.period
    });

    // Try to return cached data as fallback
    try {
      const { cacheHelpers } = require('../config/redis');
      const cacheKey = `admin:analytics:users:${req.query.period || '1d'}`;
      const cached = await cacheHelpers.get(cacheKey);
      if (cached) {
        console.log('[ANALYTICS_CONTROLLER] Returning stale cached data');
        return res.json({
          success: true,
          data: cached,
          warning: 'Using cached data due to database error'
        });
      }
    } catch (cacheError) {
      console.error('[ANALYTICS_CONTROLLER] Cache fallback failed:', cacheError);
    }

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
    console.error('[ANALYTICS_CONTROLLER] Error getting engagement:', {
      error: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      endpoint: '/api/admin/analytics/engagement',
      period: req.query.period
    });

    // Try to return cached data as fallback
    try {
      const { cacheHelpers } = require('../config/redis');
      const cacheKey = `admin:analytics:engagement:${req.query.period || '1d'}`;
      const cached = await cacheHelpers.get(cacheKey);
      if (cached) {
        console.log('[ANALYTICS_CONTROLLER] Returning stale cached data');
        return res.json({
          success: true,
          data: cached,
          warning: 'Using cached data due to database error'
        });
      }
    } catch (cacheError) {
      console.error('[ANALYTICS_CONTROLLER] Cache fallback failed:', cacheError);
    }

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
    console.error('[ANALYTICS_CONTROLLER] Error getting content stats:', {
      error: error.message,
      stack: error.stack,
      timestamp: new Date().toISOString(),
      endpoint: '/api/admin/analytics/content'
    });

    // Try to return cached data as fallback
    try {
      const { cacheHelpers } = require('../config/redis');
      const cached = await cacheHelpers.get('admin:analytics:content');
      if (cached) {
        console.log('[ANALYTICS_CONTROLLER] Returning stale cached data');
        return res.json({
          success: true,
          data: cached,
          warning: 'Using cached data due to database error'
        });
      }
    } catch (cacheError) {
      console.error('[ANALYTICS_CONTROLLER] Cache fallback failed:', cacheError);
    }

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
