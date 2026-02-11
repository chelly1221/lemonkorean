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


module.exports = router;
