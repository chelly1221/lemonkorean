const express = require('express');
const router = express.Router();
const grammarController = require('../controllers/grammar.controller');
const { languageMiddleware } = require('../middleware/language.middleware');

// Apply language middleware to all grammar routes
router.use(languageMiddleware);

/**
 * @route   GET /api/content/grammar
 * @desc    Get all grammar rules
 * @access  Public
 * @query   level, category, limit, offset
 */
router.get('/', grammarController.getGrammarRules);

/**
 * @route   GET /api/content/grammar/categories
 * @desc    Get all grammar categories
 * @access  Public
 */
router.get('/categories', grammarController.getGrammarCategories);

/**
 * @route   GET /api/content/grammar/level/:level
 * @desc    Get grammar rules by TOPIK level
 * @access  Public
 */
router.get('/level/:level', grammarController.getGrammarByLevel);

/**
 * @route   GET /api/content/grammar/:id
 * @desc    Get grammar rule by ID
 * @access  Public
 */
router.get('/:id', grammarController.getGrammarById);

module.exports = router;
