const express = require('express');
const router = express.Router();
const hangulController = require('../controllers/hangul.controller');

/**
 * ================================================================
 * HANGUL (한글) CHARACTER ENDPOINTS (Public)
 * ================================================================
 * Korean alphabet learning endpoints
 * ================================================================
 */

/**
 * @route   GET /api/content/hangul/characters
 * @desc    Get all hangul characters
 * @access  Public
 * @query   character_type - Filter by type (basic_consonant, double_consonant, basic_vowel, compound_vowel)
 */
router.get('/characters', hangulController.getCharacters);

/**
 * @route   GET /api/content/hangul/table
 * @desc    Get full alphabet table organized by type
 * @access  Public
 */
router.get('/table', hangulController.getAlphabetTable);

/**
 * @route   GET /api/content/hangul/stats
 * @desc    Get hangul character statistics
 * @access  Public
 */
router.get('/stats', hangulController.getStats);

/**
 * @route   GET /api/content/hangul/characters/type/:type
 * @desc    Get hangul characters by type
 * @access  Public
 * @param   type - Character type (basic_consonant, double_consonant, basic_vowel, compound_vowel)
 */
router.get('/characters/type/:type', hangulController.getCharactersByType);

/**
 * @route   GET /api/content/hangul/characters/:id
 * @desc    Get hangul character by ID
 * @access  Public
 */
router.get('/characters/:id', hangulController.getCharacterById);

/**
 * @route   GET /api/content/hangul/pronunciation-guides
 * @desc    Get pronunciation guides for all characters
 * @access  Public
 */
router.get('/pronunciation-guides', hangulController.getPronunciationGuides);

/**
 * @route   GET /api/content/hangul/pronunciation-guides/:characterId
 * @desc    Get pronunciation guide for a specific character
 * @access  Public
 */
router.get('/pronunciation-guides/:characterId', hangulController.getPronunciationGuideByCharacterId);

/**
 * @route   GET /api/content/hangul/syllables
 * @desc    Get syllable combinations
 * @access  Public
 * @query   initial - Filter by initial consonant ID
 * @query   vowel - Filter by vowel ID
 * @query   final - Filter by final consonant ID
 */
router.get('/syllables', hangulController.getSyllables);

/**
 * @route   GET /api/content/hangul/similar-sounds
 * @desc    Get similar sound groups for discrimination training
 * @access  Public
 * @query   category - Filter by category (consonant/vowel)
 */
router.get('/similar-sounds', hangulController.getSimilarSoundGroups);

module.exports = router;
