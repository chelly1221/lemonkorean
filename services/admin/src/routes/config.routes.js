const express = require('express');
const router = express.Router();

/**
 * Public Configuration Endpoint
 *
 * Returns API configuration for mobile app.
 * Always returns production mode settings (Nginx gateway).
 *
 * No authentication required - public endpoint.
 */
router.get('/config', (req, res) => {
  try {
    const host = process.env.API_HOST || 'localhost';

    res.json({
      success: true,
      data: {
        mode: 'production',
        apiConfig: {
          baseUrl: `http://${host}/`,
          contentUrl: `http://${host}/`,
          progressUrl: `http://${host}/`,
          mediaUrl: `http://${host}/`,
          useGateway: true
        }
      }
    });
  } catch (error) {
    console.error('[Config] Error:', error);
    res.status(500).json({
      success: false,
      error: 'Failed to retrieve configuration'
    });
  }
});

module.exports = router;
