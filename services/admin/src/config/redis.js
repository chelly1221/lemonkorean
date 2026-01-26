const { createClient } = require('redis');

// Redis client
let redisClient;

// Connect to Redis
const connectRedis = async () => {
  try {
    // Support both REDIS_URL and individual REDIS_HOST/PORT/PASSWORD
    let redisConfig;

    if (process.env.REDIS_URL) {
      redisConfig = { url: process.env.REDIS_URL };
    } else {
      const host = process.env.REDIS_HOST || 'localhost';
      const port = process.env.REDIS_PORT || 6379;
      const password = process.env.REDIS_PASSWORD;

      redisConfig = {
        socket: {
          host,
          port: parseInt(port)
        },
        ...(password && { password })
      };
    }

    redisClient = createClient({
      ...redisConfig,
      socket: {
        ...redisConfig.socket,
        reconnectStrategy: (retries) => {
          if (retries > 10) {
            console.error('[REDIS] Too many reconnection attempts, giving up');
            return new Error('Too many retries');
          }
          return Math.min(retries * 100, 3000);
        }
      }
    });

    // Error handling
    redisClient.on('error', (err) => {
      console.error('[REDIS] Client Error:', err);
    });

    redisClient.on('connect', () => {
      console.log('[REDIS] Client connecting...');
    });

    redisClient.on('ready', () => {
      console.log('[REDIS] Client ready');
    });

    redisClient.on('reconnecting', () => {
      console.log('[REDIS] Client reconnecting...');
    });

    await redisClient.connect();
    console.log('[REDIS] Connected successfully');

    return redisClient;
  } catch (error) {
    console.error('[REDIS] Connection error:', error);
    throw error;
  }
};

// Test Redis connection
const testRedisConnection = async () => {
  try {
    if (!redisClient || !redisClient.isOpen) {
      await connectRedis();
    }

    if (redisClient && redisClient.isOpen) {
      await redisClient.ping();
      console.log('[REDIS] Ping successful');
      return true;
    }

    return false;
  } catch (error) {
    console.error('[REDIS] Test connection error:', error);
    throw error;
  }
};

// Get Redis client
const getRedisClient = () => {
  if (!redisClient || !redisClient.isOpen) {
    console.warn('[REDIS] Client not connected');
    return null;
  }
  return redisClient;
};

// Cache helpers
const cacheHelpers = {
  // Get cached data
  get: async (key) => {
    try {
      const client = getRedisClient();
      if (!client) return null;

      const data = await client.get(key);
      return data ? JSON.parse(data) : null;
    } catch (error) {
      console.error('[REDIS] Get error:', error);
      return null;
    }
  },

  // Set cached data with TTL
  set: async (key, value, ttlSeconds = 3600) => {
    try {
      const client = getRedisClient();
      if (!client) return false;

      await client.setEx(key, ttlSeconds, JSON.stringify(value));
      return true;
    } catch (error) {
      console.error('[REDIS] Set error:', error);
      return false;
    }
  },

  // Delete cached data
  del: async (...keys) => {
    try {
      const client = getRedisClient();
      if (!client) return 0;

      return await client.del(keys);
    } catch (error) {
      console.error('[REDIS] Delete error:', error);
      return 0;
    }
  },

  // Check if key exists
  exists: async (key) => {
    try {
      const client = getRedisClient();
      if (!client) return false;

      return (await client.exists(key)) === 1;
    } catch (error) {
      console.error('[REDIS] Exists error:', error);
      return false;
    }
  },

  // Flush all cache
  flushAll: async () => {
    try {
      const client = getRedisClient();
      if (!client) return false;

      await client.flushAll();
      return true;
    } catch (error) {
      console.error('[REDIS] FlushAll error:', error);
      return false;
    }
  }
};

// Close Redis connection
const closeRedis = async () => {
  if (redisClient && redisClient.isOpen) {
    await redisClient.quit();
    console.log('[REDIS] Connection closed');
  }
};

module.exports = {
  connectRedis,
  testRedisConnection,
  getRedisClient,
  cacheHelpers,
  closeRedis
};
