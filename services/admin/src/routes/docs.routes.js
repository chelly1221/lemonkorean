const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const docsController = require('../controllers/docs.controller');

/**
 * Documentation Routes
 * All routes require authentication and admin privileges
 */

// Get list of all documentation files
router.get(
  '/',
  requireAuth,
  requireAdmin,
  docsController.getDocsList
);

// Get content of a specific document
router.get(
  '/content',
  requireAuth,
  requireAdmin,
  docsController.getDocContent
);

// Update documentation file content
router.put(
  '/content',
  requireAuth,
  requireAdmin,
  docsController.updateDocContent
);

module.exports = router;
