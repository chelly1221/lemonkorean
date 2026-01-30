const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const networkController = require('../controllers/network.controller');

/**
 * GET /api/admin/network/settings
 * Get current network settings (HTTP/HTTPS mode)
 */
router.get(
  '/settings',
  requireAuth,
  requireAdmin,
  networkController.getSettings
);

/**
 * PUT /api/admin/network/settings
 * Update network settings
 */
router.put(
  '/settings',
  requireAuth,
  requireAdmin,
  networkController.updateSettings
);

/**
 * POST /api/admin/network/restart
 * Restart nginx container
 */
router.post(
  '/restart',
  requireAuth,
  requireAdmin,
  networkController.restartNginx
);

/**
 * GET /api/admin/network/config
 * Get network configuration for mobile app (no auth required)
 * This endpoint is used by the mobile app on startup to determine URLs
 */
router.get('/config', networkController.getConfig);

/**
 * GET /api/admin/network/test
 * Test endpoint (no auth required)
 */
router.get('/test', async (req, res) => {
  try {
    const fs = require('fs').promises;
    const envContent = await fs.readFile('/app/.env', 'utf8');
    const nginxMode = envContent.match(/NGINX_MODE=(\w+)/)?.[1] || 'production';
    res.json({
      success: true,
      mode: nginxMode,
      envPath: '/app/.env',
      message: 'Network API is working'
    });
  } catch (error) {
    res.status(500).json({ error: error.message, stack: error.stack });
  }
});

module.exports = router;
