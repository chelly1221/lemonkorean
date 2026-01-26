const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const analyticsController = require('../controllers/analytics.controller');

/**
 * Analytics Routes
 * All routes require authentication and admin privileges
 * No audit logging needed for read-only analytics
 */

// Get dashboard overview
router.get(
  '/overview',
  requireAuth,
  requireAdmin,
  analyticsController.getOverview
);

// Get user analytics
router.get(
  '/users',
  requireAuth,
  requireAdmin,
  analyticsController.getUserAnalytics
);

// Get engagement metrics
router.get(
  '/engagement',
  requireAuth,
  requireAdmin,
  analyticsController.getEngagement
);

// Get content statistics
router.get(
  '/content',
  requireAuth,
  requireAdmin,
  analyticsController.getContentStats
);

module.exports = router;
