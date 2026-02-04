/**
 * Deploy Routes
 *
 * Web deployment API routes
 */

const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const { auditLog } = require('../middleware/audit.middleware');
const deployController = require('../controllers/deploy.controller');

/**
 * Web Deployment Routes
 * All routes require authentication and admin privileges
 */

// Start web deployment
router.post(
  '/web/start',
  requireAuth,
  requireAdmin,
  auditLog('deploy.web.start', 'deployment'),
  deployController.startWebDeploy
);

// Get deployment status
router.get(
  '/web/status/:id',
  requireAuth,
  requireAdmin,
  deployController.getDeploymentStatus
);

// Get deployment logs (polling endpoint)
router.get(
  '/web/logs/:id',
  requireAuth,
  requireAdmin,
  deployController.getDeploymentLogs
);

// List deployment history
router.get(
  '/web/history',
  requireAuth,
  requireAdmin,
  deployController.listDeploymentHistory
);

// Cancel deployment
router.delete(
  '/web/:id',
  requireAuth,
  requireAdmin,
  auditLog('deploy.web.cancel', 'deployment'),
  deployController.cancelDeployment
);

module.exports = router;
