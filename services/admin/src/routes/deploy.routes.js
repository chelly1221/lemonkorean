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
const apkBuildController = require('../controllers/apk-build.controller');

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

/**
 * APK Build Routes
 * All routes require authentication and admin privileges
 */

// Start APK build
router.post(
  '/apk/start',
  requireAuth,
  requireAdmin,
  auditLog('deploy.apk.start', 'deployment'),
  apkBuildController.startAPKBuild
);

// Get build status
router.get(
  '/apk/status/:id',
  requireAuth,
  requireAdmin,
  apkBuildController.getBuildStatus
);

// Get build logs (polling endpoint)
router.get(
  '/apk/logs/:id',
  requireAuth,
  requireAdmin,
  apkBuildController.getBuildLogs
);

// List build history
router.get(
  '/apk/history',
  requireAuth,
  requireAdmin,
  apkBuildController.listBuildHistory
);

// Download APK
router.get(
  '/apk/download/:id',
  requireAuth,
  requireAdmin,
  apkBuildController.downloadAPK
);

// Cancel build
router.delete(
  '/apk/:id',
  requireAuth,
  requireAdmin,
  auditLog('deploy.apk.cancel', 'deployment'),
  apkBuildController.cancelBuild
);

module.exports = router;
