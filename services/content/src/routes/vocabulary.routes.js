const express = require('express');
const router = express.Router();
const vocabularyController = require('../controllers/vocabulary.controller');
const { requireAuth } = require('../middleware/auth.middleware');
const { languageMiddleware } = require('../middleware/language.middleware');

// Apply language middleware to all vocabulary routes
router.use(languageMiddleware);

/**
 * ================================================================
 * VOCABULARY ENDPOINTS (Public)
 * ================================================================
 */

/**
 * @route   GET /api/content/vocabulary
 * @desc    Get all vocabulary
 * @access  Public
 * @query   level, part_of_speech, limit, offset, search
 */
router.get('/', vocabularyController.getVocabulary);

/**
 * @route   GET /api/content/vocabulary/search
 * @desc    Search vocabulary
 * @access  Public
 * @query   q (search query), limit
 */
router.get('/search', vocabularyController.searchVocabulary);

/**
 * @route   GET /api/content/vocabulary/stats
 * @desc    Get vocabulary statistics
 * @access  Public
 */
router.get('/stats', vocabularyController.getVocabularyStats);

/**
 * @route   GET /api/content/vocabulary/high-similarity
 * @desc    Get vocabulary with high Hanja similarity
 * @access  Public
 * @query   min_similarity, limit
 */
router.get('/high-similarity', vocabularyController.getHighSimilarityVocabulary);

/**
 * @route   GET /api/content/vocabulary/level/:level
 * @desc    Get vocabulary by TOPIK level
 * @access  Public
 */
router.get('/level/:level', vocabularyController.getVocabularyByLevel);

/**
 * ================================================================
 * BOOKMARK ENDPOINTS (Protected - Requires Authentication)
 * ================================================================
 */

/**
 * @route   POST /api/content/vocabulary/bookmarks/batch
 * @desc    Create multiple bookmarks at once
 * @access  Private (JWT required)
 * @body    bookmarks - Array of {vocabulary_id, notes}
 */
router.post('/bookmarks/batch', requireAuth, vocabularyController.createBookmarksBatch);

/**
 * @route   POST /api/content/vocabulary/bookmarks
 * @desc    Create a new vocabulary bookmark
 * @access  Private (JWT required)
 * @body    vocabulary_id, notes (optional)
 */
router.post('/bookmarks', requireAuth, vocabularyController.createBookmark);

/**
 * @route   GET /api/content/vocabulary/bookmarks
 * @desc    Get user's bookmarks with full vocabulary data
 * @access  Private (JWT required)
 * @query   page, limit
 */
router.get('/bookmarks', requireAuth, vocabularyController.getUserBookmarks);

/**
 * @route   GET /api/content/vocabulary/bookmarks/:id
 * @desc    Get single bookmark by ID
 * @access  Private (JWT required)
 */
router.get('/bookmarks/:id', requireAuth, vocabularyController.getBookmark);

/**
 * @route   PUT /api/content/vocabulary/bookmarks/:id
 * @desc    Update bookmark notes
 * @access  Private (JWT required)
 * @body    notes
 */
router.put('/bookmarks/:id', requireAuth, vocabularyController.updateBookmarkNotes);

/**
 * @route   DELETE /api/content/vocabulary/bookmarks/:id
 * @desc    Delete bookmark
 * @access  Private (JWT required)
 */
router.delete('/bookmarks/:id', requireAuth, vocabularyController.deleteBookmark);

/**
 * ================================================================
 * VOCABULARY BY ID (Must be last to avoid route conflicts)
 * ================================================================
 */

/**
 * @route   GET /api/content/vocabulary/:id
 * @desc    Get vocabulary by ID
 * @access  Public
 */
router.get('/:id', vocabularyController.getVocabularyById);

module.exports = router;
