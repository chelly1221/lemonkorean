const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const { auditLog } = require('../middleware/audit.middleware');
const hangulController = require('../controllers/hangul.controller');

/**
 * Hangul Characters Management Routes
 * All routes require authentication and admin privileges
 * Audit logging is applied to all mutation operations
 */

// List hangul characters
router.get(
  '/',
  requireAuth,
  requireAdmin,
  hangulController.listCharacters
);

// Get hangul statistics
router.get(
  '/stats',
  requireAuth,
  requireAdmin,
  hangulController.getStats
);

// Get hangul character by ID
router.get(
  '/:id',
  requireAuth,
  requireAdmin,
  hangulController.getCharacterById
);

// Create hangul character
router.post(
  '/',
  requireAuth,
  requireAdmin,
  auditLog('hangul.create', 'hangul'),
  hangulController.createCharacter
);

// Update hangul character
router.put(
  '/:id',
  requireAuth,
  requireAdmin,
  auditLog('hangul.update', 'hangul'),
  hangulController.updateCharacter
);

// Delete hangul character
router.delete(
  '/:id',
  requireAuth,
  requireAdmin,
  auditLog('hangul.delete', 'hangul'),
  hangulController.deleteCharacter
);

// Bulk seed initial data
router.post(
  '/bulk',
  requireAuth,
  requireAdmin,
  auditLog('hangul.bulk_seed', 'hangul'),
  hangulController.bulkSeed
);

module.exports = router;
