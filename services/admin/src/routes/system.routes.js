const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const systemController = require('../controllers/system.controller');

/**
 * System Routes
 * All routes require authentication and admin privileges
 */

// Get system audit logs
router.get(
  '/logs',
  requireAuth,
  requireAdmin,
  systemController.getLogs
);

// Create storage reset flag
router.post(
  '/storage-reset',
  requireAuth,
  requireAdmin,
  systemController.createStorageResetFlag
);

// List storage reset flags
router.get(
  '/storage-reset',
  requireAuth,
  requireAdmin,
  systemController.listStorageResetFlags
);

module.exports = router;
