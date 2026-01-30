const { exec } = require('child_process');
const util = require('util');
const execPromise = util.promisify(exec);
const { getRedisClient } = require('../config/redis');

// Redis key for network mode
const NETWORK_MODE_KEY = 'network:mode';
const DEFAULT_MODE = 'development';

/**
 * Get current network mode from Redis
 */
const getNetworkMode = async () => {
  try {
    const client = getRedisClient();
    if (!client) return DEFAULT_MODE;

    const mode = await client.get(NETWORK_MODE_KEY);
    return mode || DEFAULT_MODE;
  } catch (error) {
    console.error('Error getting network mode from Redis:', error);
    return DEFAULT_MODE;
  }
};

/**
 * Get current network settings
 */
const getSettings = async (req, res) => {
  try {
    const nginxMode = await getNetworkMode();

    // Check if nginx container is running
    let isRunning = false;
    try {
      const { stdout } = await execPromise('docker ps --filter "name=lemon-nginx" --format "{{.Status}}"');
      isRunning = stdout.trim() !== '';
    } catch (e) {
      // Docker command failed, assume not running
      console.warn('Could not check nginx status:', e.message);
    }

    res.json({
      success: true,
      data: {
        mode: nginxMode,
        isRunning,
        availableModes: ['development', 'production']
      }
    });
  } catch (error) {
    console.error('Error getting network settings:', error);
    res.status(500).json({ error: error.message });
  }
};

/**
 * Update network settings
 */
const updateSettings = async (req, res) => {
  try {
    const { mode } = req.body;

    if (!['development', 'production'].includes(mode)) {
      return res.status(400).json({ error: 'Invalid mode. Use development or production.' });
    }

    // Save to Redis (no expiration - persistent setting)
    const client = getRedisClient();
    if (!client) {
      throw new Error('Redis not connected');
    }
    await client.set(NETWORK_MODE_KEY, mode);

    console.log(`[NETWORK] Mode updated to: ${mode}`);

    res.json({
      success: true,
      message: `Network mode updated to ${mode}. Please restart Nginx to apply changes.`,
      data: { mode }
    });
  } catch (error) {
    console.error('Error updating network settings:', error);
    res.status(500).json({ error: error.message });
  }
};

/**
 * Restart nginx container
 */
const restartNginx = async (req, res) => {
  try {
    // Restart nginx container using docker command
    await execPromise('docker restart lemon-nginx');

    res.json({
      success: true,
      message: 'Nginx restarted successfully'
    });
  } catch (error) {
    console.error('Error restarting nginx:', error);
    res.status(500).json({ error: error.message });
  }
};

/**
 * Get the server's base hostname from request or environment
 */
const getBaseHost = (req) => {
  // Priority: 1. Environment variable, 2. X-Forwarded-Host, 3. Request host (without port)
  if (process.env.SERVER_HOST) {
    return process.env.SERVER_HOST;
  }

  const forwardedHost = req.get('X-Forwarded-Host');
  if (forwardedHost) {
    return forwardedHost.split(':')[0]; // Remove port if present
  }

  const host = req.get('host');
  if (host) {
    return host.split(':')[0]; // Remove port if present
  }

  return 'localhost';
};

/**
 * Get network configuration for mobile app
 * Returns URLs based on current NGINX_MODE
 */
const getConfig = async (req, res) => {
  try {
    const nginxMode = await getNetworkMode();
    const baseHost = getBaseHost(req);

    // Development mode: Direct port access (bypass Nginx)
    // Production mode: Nginx gateway
    const config = nginxMode === 'development' ? {
      mode: 'development',
      baseUrl: `http://${baseHost}:3001`,      // Auth service (direct port)
      contentUrl: `http://${baseHost}:3002`,   // Content service (direct port)
      progressUrl: `http://${baseHost}:3003`,  // Progress service (direct port)
      mediaUrl: `http://${baseHost}:3004`,     // Media service (direct port)
      useGateway: false
    } : {
      mode: 'production',
      baseUrl: `http://${baseHost}`,           // Nginx gateway
      contentUrl: `http://${baseHost}`,        // Through Nginx
      progressUrl: `http://${baseHost}`,       // Through Nginx
      mediaUrl: `http://${baseHost}`,          // Through Nginx
      useGateway: true
    };

    console.log(`[NETWORK_CONFIG] Returning config for ${nginxMode} mode, host: ${baseHost}`);

    res.json({
      success: true,
      config
    });
  } catch (error) {
    console.error('Error getting network config:', error);
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getSettings,
  updateSettings,
  restartNginx,
  getConfig
};
