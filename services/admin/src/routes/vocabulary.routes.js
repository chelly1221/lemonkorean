const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const { auditLog } = require('../middleware/audit.middleware');
const vocabularyController = require('../controllers/vocabulary.controller');

/**
 * Vocabulary Management Routes
 * All routes require authentication and admin privileges
 * Audit logging is applied to all mutation operations
 */

// List vocabulary
router.get(
  '/',
  requireAuth,
  requireAdmin,
  vocabularyController.listVocabulary
);

// Get vocabulary by ID
router.get(
  '/:id',
  requireAuth,
  requireAdmin,
  vocabularyController.getVocabularyById
);

// Create vocabulary
router.post(
  '/',
  requireAuth,
  requireAdmin,
  auditLog('vocabulary.create', 'vocabulary'),
  vocabularyController.createVocabulary
);

// Update vocabulary
router.put(
  '/:id',
  requireAuth,
  requireAdmin,
  auditLog('vocabulary.update', 'vocabulary'),
  vocabularyController.updateVocabulary
);

// Delete vocabulary
router.delete(
  '/:id',
  requireAuth,
  requireAdmin,
  auditLog('vocabulary.delete', 'vocabulary'),
  vocabularyController.deleteVocabulary
);

// Bulk delete vocabulary
router.post(
  '/bulk-delete',
  requireAuth,
  requireAdmin,
  auditLog('vocabulary.bulk_delete', 'vocabulary'),
  vocabularyController.bulkDelete
);

module.exports = router;
