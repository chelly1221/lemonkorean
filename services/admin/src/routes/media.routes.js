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
  },
  // Explicitly handle filename encoding for Korean/Unicode characters
  fileFilter: (req, file, cb) => {
    try {
      // Multer may receive filename in latin1 encoding from multipart form
      // Convert to proper UTF-8
      const originalName = file.originalname;

      // Try to detect if the filename is garbled (contains mojibake patterns)
      // If it contains only ASCII, no conversion needed
      if (/^[\x00-\x7F]*$/.test(originalName)) {
        // Pure ASCII, safe
        console.log('[MULTER] Filename is ASCII:', originalName);
        cb(null, true);
        return;
      }

      // Check if it looks like latin1-encoded UTF-8 (common multer issue)
      // Try to re-decode from latin1 to utf8
      try {
        const reencoded = Buffer.from(originalName, 'latin1').toString('utf8');
        // Check if re-encoding produces valid UTF-8
        if (reencoded !== originalName && !/�/.test(reencoded)) {
          console.log('[MULTER] Re-encoded filename from latin1 to utf8');
          console.log('  Before:', originalName);
          console.log('  After:', reencoded);
          file.originalname = reencoded;
        } else {
          console.log('[MULTER] Filename already in UTF-8:', originalName);
        }
      } catch (err) {
        console.warn('[MULTER] Failed to re-encode filename:', err.message);
      }

      cb(null, true);
    } catch (error) {
      console.error('[MULTER] Error in fileFilter:', error);
      cb(null, true); // Don't block upload due to encoding issues
    }
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
