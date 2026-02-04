const express = require('express');
const multer = require('multer');
const router = express.Router();
const appThemeController = require('../controllers/app-theme.controller');
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

// Configure multer for different file types
const uploadLogo = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024 // 5MB max for logos
  }
});

const uploadFavicon = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 1 * 1024 * 1024 // 1MB max for favicon
  }
});

const uploadFont = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024 // 10MB max for fonts
  }
});

/**
 * App Theme Routes
 * Base path: /api/admin/app-theme
 * Note: This is separate from /design routes (which control admin dashboard theme)
 */

// Public route - get current settings (no auth required - used by Flutter app)
router.get('/settings', appThemeController.getSettings);

// Admin routes - require authentication and admin role
router.put('/colors', requireAuth, requireAdmin, appThemeController.updateColors);
router.post('/splash-logo', requireAuth, requireAdmin, uploadLogo.single('logo'), appThemeController.uploadSplashLogo);
router.post('/login-logo', requireAuth, requireAdmin, uploadLogo.single('logo'), appThemeController.uploadLoginLogo);
router.post('/favicon', requireAuth, requireAdmin, uploadFavicon.single('favicon'), appThemeController.uploadFavicon);
router.put('/font', requireAuth, requireAdmin, appThemeController.updateFont);
router.post('/font-upload', requireAuth, requireAdmin, uploadFont.single('font'), appThemeController.uploadCustomFont);
router.post('/reset', requireAuth, requireAdmin, appThemeController.resetSettings);

module.exports = router;
