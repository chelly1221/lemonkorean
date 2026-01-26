const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const systemController = require('../controllers/system.controller');

/**
 * System Monitoring Routes
 * All routes require authentication and admin privileges
 * No audit logging needed for read-only monitoring
 */

// Get service health status
router.get(
  '/health',
  requireAuth,
  requireAdmin,
  systemController.getHealth
);

// Get system logs
router.get(
  '/logs',
  requireAuth,
  requireAdmin,
  systemController.getLogs
);

// Get system metrics
router.get(
  '/metrics',
  requireAuth,
  requireAdmin,
  systemController.getMetrics
);

module.exports = router;
