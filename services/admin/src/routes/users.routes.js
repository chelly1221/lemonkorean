const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const { auditLog } = require('../middleware/audit.middleware');
const usersController = require('../controllers/users.controller');

/**
 * User Management Routes
 * All routes require authentication and admin privileges
 * Audit logging is applied to all mutation operations
 */

// List users with pagination and filtering
router.get(
  '/',
  requireAuth,
  requireAdmin,
  usersController.listUsers
);

// Get user details
router.get(
  '/:id',
  requireAuth,
  requireAdmin,
  usersController.getUserById
);

// Update user
router.put(
  '/:id',
  requireAuth,
  requireAdmin,
  auditLog('user.update', 'user'),
  usersController.updateUser
);

// Ban/unban user
router.put(
  '/:id/ban',
  requireAuth,
  requireAdmin,
  auditLog('user.ban', 'user'),
  usersController.banUser
);

// Get user activity
router.get(
  '/:id/activity',
  requireAuth,
  requireAdmin,
  usersController.getUserActivity
);

// Get audit logs for user
router.get(
  '/:id/audit-logs',
  requireAuth,
  requireAdmin,
  usersController.getUserAuditLogs
);

module.exports = router;
