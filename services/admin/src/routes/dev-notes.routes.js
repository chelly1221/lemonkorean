const express = require('express');
const router = express.Router();
const devNotesController = require('../controllers/dev-notes.controller');
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

/**
 * All routes require authentication and admin privileges
 */
router.use(requireAuth);
router.use(requireAdmin);

/**
 * GET /api/admin/dev-notes
 * List all development notes with metadata
 */
router.get('/', devNotesController.getDevNotesList);

/**
 * GET /api/admin/dev-notes/content
 * Get specific note content
 * Query params: path (e.g., dev-notes/2026-01-30-example.md)
 */
router.get('/content', devNotesController.getDevNoteContent);

/**
 * GET /api/admin/dev-notes/categories
 * Get unique categories from all notes
 */
router.get('/categories', devNotesController.getCategories);

module.exports = router;
