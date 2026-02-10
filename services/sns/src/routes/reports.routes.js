const express = require('express');
const router = express.Router();
const reportsController = require('../controllers/reports.controller');
const { requireAuth } = require('../middleware/auth.middleware');

/**
 * @route   POST /api/sns/reports
 * @desc    Submit a report
 * @access  Private
 * @body    { targetType, targetId, reason }
 */
router.post('/', requireAuth, reportsController.create);

module.exports = router;
