const express = require('express');
const router = express.Router();
const lessonsController = require('../controllers/lessons.controller');

/**
 * @route   GET /api/content/lessons
 * @desc    Get all lessons
 * @access  Public
 * @query   level, status, limit, offset
 */
router.get('/', lessonsController.getLessons);

/**
 * @route   GET /api/content/lessons/level/:level
 * @desc    Get lessons by level
 * @access  Public
 */
router.get('/level/:level', lessonsController.getLessonsByLevel);

/**
 * @route   POST /api/content/lessons/check-updates
 * @desc    Check for lesson updates (bulk)
 * @access  Public
 * @body    { lessons: [{id, version}] }
 */
router.post('/check-updates', lessonsController.bulkCheckUpdates);

/**
 * @route   GET /api/content/lessons/:id/version
 * @desc    Check lesson version
 * @access  Public
 * @query   clientVersion
 */
router.get('/:id/version', lessonsController.checkLessonVersion);

/**
 * @route   GET /api/content/lessons/:id/package
 * @desc    Get lesson download package (JSON with metadata)
 * @access  Public
 */
router.get('/:id/package', lessonsController.getLessonDownloadPackage);

/**
 * @route   GET /api/content/lessons/:id/download
 * @desc    Download lesson as ZIP archive
 * @access  Public
 */
router.get('/:id/download', lessonsController.downloadLessonZip);

/**
 * @route   GET /api/content/lessons/:id
 * @desc    Get lesson by ID (full data: metadata + content)
 * @access  Public
 */
router.get('/:id', lessonsController.getLessonById);

module.exports = router;
