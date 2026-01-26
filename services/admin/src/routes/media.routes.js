const express = require('express');
const router = express.Router();
const multer = require('multer');
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const { auditLog } = require('../middleware/audit.middleware');
const mediaController = require('../controllers/media.controller');

/**
 * Media Management Routes
 * All routes require authentication and admin privileges
 */

// Configure multer for memory storage (files stored in buffer)
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 200 * 1024 * 1024, // 200 MB max (will be validated per category)
    files: 1 // Only one file at a time
  }
});

// Upload file
router.post(
  '/upload',
  requireAuth,
  requireAdmin,
  upload.single('file'), // Field name must be 'file'
  auditLog('media.upload', 'media'),
  mediaController.uploadFile
);

// List files
router.get(
  '/',
  requireAuth,
  requireAdmin,
  mediaController.listFiles
);

// Get file metadata
router.get(
  '/:key(*)', // Wildcard to capture path with slashes
  requireAuth,
  requireAdmin,
  mediaController.getFileMetadata
);

// Delete file
router.delete(
  '/:key(*)', // Wildcard to capture path with slashes
  requireAuth,
  requireAdmin,
  auditLog('media.delete', 'media'),
  mediaController.deleteFile
);

// Handle multer errors
router.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'File too large. Maximum size is 200 MB'
      });
    }
    if (error.code === 'LIMIT_FILE_COUNT') {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Too many files. Only one file can be uploaded at a time'
      });
    }
    if (error.code === 'LIMIT_UNEXPECTED_FILE') {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Unexpected field name. Use "file" as the field name'
      });
    }

    return res.status(400).json({
      error: 'Bad Request',
      message: error.message
    });
  }

  next(error);
});

module.exports = router;
