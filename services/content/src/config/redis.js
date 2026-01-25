const { createClient } = require('redis');

// Redis client
let redisClient;

// Connect to Redis
const connectRedis = async () => {
  try {
    const REDIS_URL = process.env.REDIS_URL;

    if (!REDIS_URL) {
      console.warn('Warning: REDIS_URL not set, Redis features will be disabled');
      return null;
    }

    redisClient = createClient({
      url: REDIS_URL,
      socket: {
        reconnectStrategy: (retries) => {
          if (retries > 10) {
            console.error('Redis: Too many reconnection attempts, giving up');
            return new Error('Too many retries');
          }
          return Math.min(retries * 100, 3000);
        }
      }
    });

    // Error handling
    redisClient.on('error', (err) => {
      console.error('Redis Client Error:', err);
    });

    redisClient.on('connect', () => {
      console.log('Redis client connecting...');
    });

    redisClient.on('ready', () => {
      console.log('Redis client ready');
    });

    redisClient.on('reconnecting', () => {
      console.log('Redis client reconnecting...');
    });

    await redisClient.connect();
    console.log('Redis connected successfully');

    return redisClient;
  } catch (error) {
    console.error('Redis connection error:', error);
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
      console.log('Redis ping successful');
      return true;
    }

    return false;
  } catch (error) {
    console.error('Redis test connection error:', error);
    throw error;
  }
};

// Get Redis client
const getRedisClient = () => {
  if (!redisClient || !redisClient.isOpen) {
    console.warn('Redis client not connected');
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
      console.error('Redis get error:', error);
      return null;
    }
  },

  // Set cached data
  set: async (key, value, expirationInSeconds = 3600) => {
    try {
      const client = getRedisClient();
      if (!client) return false;

      await client.setEx(key, expirationInSeconds, JSON.stringify(value));
      return true;
    } catch (error) {
      console.error('Redis set error:', error);
      return false;
    }
  },

  // Delete cached data
  del: async (key) => {
    try {
      const client = getRedisClient();
      if (!client) return false;

      await client.del(key);
      return true;
    } catch (error) {
      console.error('Redis del error:', error);
      return false;
    }
  },

  // Check if key exists
  exists: async (key) => {
    try {
      const client = getRedisClient();
      if (!client) return false;

      const result = await client.exists(key);
      return result === 1;
    } catch (error) {
      console.error('Redis exists error:', error);
      return false;
    }
  },

  // Clear all cache (use with caution)
  flushAll: async () => {
    try {
      const client = getRedisClient();
      if (!client) return false;

      await client.flushAll();
      console.log('Redis cache cleared');
      return true;
    } catch (error) {
      console.error('Redis flushAll error:', error);
      return false;
    }
  }
};

// Close Redis connection
const closeRedis = async () => {
  if (redisClient && redisClient.isOpen) {
    await redisClient.quit();
    console.log('Redis connection closed');
  }
};

module.exports = {
  connectRedis,
  testRedisConnection,
  getRedisClient,
  cacheHelpers,
  closeRedis
};
