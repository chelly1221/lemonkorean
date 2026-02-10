const { createClient } = require('redis');

let redisClient;

const initRedis = async () => {
  try {
    redisClient = createClient({
      url: process.env.REDIS_URL || 'redis://localhost:6379'
    });

    redisClient.on('error', (err) => {
      console.error('[SNS] Redis error:', err.message);
    });

    redisClient.on('connect', () => {
      console.log('[SNS] Redis connected');
    });

    await redisClient.connect();
    return redisClient;
  } catch (error) {
    console.error('[SNS] Redis connection failed:', error.message);
    // Non-fatal: DM can work without Redis (no online status)
    return null;
  }
};

const getRedisClient = () => redisClient;

module.exports = { initRedis, getRedisClient };
