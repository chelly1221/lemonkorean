const express = require('express');
const router = express.Router();
const multer = require('multer');
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const { auditLog } = require('../middleware/audit.middleware');
const vocabularyController = require('../controllers/vocabulary.controller');

// Multer configuration for Excel file upload
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB limit
  },
  fileFilter: (req, file, cb) => {
    // Accept Excel files only
    if (
      file.mimetype === 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ||
      file.mimetype === 'application/vnd.ms-excel' ||
      file.originalname.endsWith('.xlsx') ||
      file.originalname.endsWith('.xls')
    ) {
      cb(null, true);
    } else {
      cb(new Error('Only Excel files (.xlsx, .xls) are allowed'));
    }
  }
});

/**
 * Vocabulary Management Routes
 * All routes require authentication and admin privileges
 * Audit logging is applied to all mutation operations
 */

// Download Excel template
router.get(
  '/template',
  requireAuth,
  requireAdmin,
  vocabularyController.downloadTemplate
);

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

// Bulk upload vocabulary from Excel
router.post(
  '/bulk-upload',
  requireAuth,
  requireAdmin,
  upload.single('file'),
  auditLog('vocabulary.bulk_upload', 'vocabulary'),
  vocabularyController.bulkUpload
);

module.exports = router;
