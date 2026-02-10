const express = require('express');
const router = express.Router();
const gamificationController = require('../controllers/gamification.controller');
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

/**
 * Gamification Settings Routes
 * Base path: /api/admin/gamification
 */

// Public route - get current settings (used by Flutter app)
router.get('/settings', gamificationController.getSettings);

// Admin routes - require authentication and admin role
router.put('/ad-settings', requireAuth, requireAdmin, gamificationController.updateAdSettings);
router.put('/lemon-settings', requireAuth, requireAdmin, gamificationController.updateLemonSettings);
router.post('/reset', requireAuth, requireAdmin, gamificationController.resetSettings);

module.exports = router;
