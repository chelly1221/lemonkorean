const { testConnection } = require('../config/database');
const { testMongoConnection } = require('../config/mongodb');
const { testRedisConnection } = require('../config/redis');
const { testMinIOConnection } = require('../config/minio');
const { getAllAuditLogs } = require('../middleware/audit.middleware');

/**
 * System Monitoring Service
 * Health checks and system status monitoring
 */

/**
 * Check all service health
 * @returns {Object} Health status of all services
 */
const checkAllServices = async () => {
  try {
    console.log('[SYSTEM_SERVICE] Checking all services health');

    const services = {
      admin: {
        name: 'Admin Service',
        status: 'healthy',
        uptime: process.uptime(),
        timestamp: new Date().toISOString()
      },
      postgres: await checkPostgres(),
      mongodb: await checkMongoDB(),
      redis: await checkRedis(),
      minio: await checkMinIO(),
      externalServices: await checkExternalServices()
    };

    // Determine overall status (skip externalServices array)
    const allHealthy = Object.entries(services).every(([key, service]) => {
      if (key === 'externalServices') return true; // Skip external services check
      if (service.name === 'Admin Service') return service.status === 'healthy';
      return service.status === 'healthy' || service.status === 'connected';
    });

    return {
      status: allHealthy ? 'healthy' : 'degraded',
      services,
      timestamp: new Date().toISOString()
    };
  } catch (error) {
    console.error('[SYSTEM_SERVICE] Error checking services:', error);
    throw error;
  }
};

/**
 * Check PostgreSQL health
 * @returns {Object} PostgreSQL status
 */
const checkPostgres = async () => {
  try {
    await testConnection();
    return {
      name: 'PostgreSQL',
      status: 'connected',
      responseTime: 'fast'
    };
  } catch (error) {
    return {
      name: 'PostgreSQL',
      status: 'disconnected',
      error: error.message
    };
  }
};

/**
 * Check MongoDB health
 * @returns {Object} MongoDB status
 */
const checkMongoDB = async () => {
  try {
    await testMongoConnection();
    return {
      name: 'MongoDB',
      status: 'connected',
      responseTime: 'fast'
    };
  } catch (error) {
    return {
      name: 'MongoDB',
      status: 'disconnected',
      error: error.message
    };
  }
};

/**
 * Check Redis health
 * @returns {Object} Redis status
 */
const checkRedis = async () => {
  try {
    await testRedisConnection();
    return {
      name: 'Redis',
      status: 'connected',
      responseTime: 'fast'
    };
  } catch (error) {
    return {
      name: 'Redis',
      status: 'disconnected',
      error: error.message
    };
  }
};

/**
 * Check MinIO health
 * @returns {Object} MinIO status
 */
const checkMinIO = async () => {
  try {
    await testMinIOConnection();
    return {
      name: 'MinIO',
      status: 'connected',
      responseTime: 'fast'
    };
  } catch (error) {
    return {
      name: 'MinIO',
      status: 'disconnected',
      error: error.message
    };
  }
};

/**
 * Check external services (auth, content, progress, media)
 * @returns {Object} External services status
 */
const checkExternalServices = async () => {
  const services = [
    { name: 'Auth Service', url: 'http://auth-service:3001/health' },
    { name: 'Content Service', url: 'http://content-service:3002/health' },
    { name: 'Progress Service', url: 'http://progress-service:3003/health' },
    { name: 'Media Service', url: 'http://media-service:3004/health' }
  ];

  const statuses = await Promise.allSettled(
    services.map(async (service) => {
      try {
        // Simple HTTP check (would need http module or fetch)
        // For now, return placeholder
        return {
          name: service.name,
          status: 'unknown',
          url: service.url
        };
      } catch (error) {
        return {
          name: service.name,
          status: 'error',
          error: error.message
        };
      }
    })
  );

  return statuses.map((result, index) => {
    if (result.status === 'fulfilled') {
      return result.value;
    } else {
      return {
        name: services[index].name,
        status: 'error',
        error: result.reason.message
      };
    }
  });
};

/**
 * Get system logs (recent audit logs)
 * @param {Object} options - Query options
 * @returns {Object} Paginated logs
 */
const getSystemLogs = async (options = {}) => {
  try {
    console.log('[SYSTEM_SERVICE] Getting system logs');

    const logs = await getAllAuditLogs(options);

    return logs;
  } catch (error) {
    console.error('[SYSTEM_SERVICE] Error getting system logs:', error);
    throw error;
  }
};

/**
 * Get system metrics
 * @returns {Object} System metrics
 */
const getSystemMetrics = async () => {
  try {
    console.log('[SYSTEM_SERVICE] Getting system metrics');

    const memoryUsage = process.memoryUsage();

    return {
      uptime: process.uptime(),
      memory: {
        heapUsed: Math.round(memoryUsage.heapUsed / 1024 / 1024), // MB
        heapTotal: Math.round(memoryUsage.heapTotal / 1024 / 1024), // MB
        rss: Math.round(memoryUsage.rss / 1024 / 1024), // MB
        external: Math.round(memoryUsage.external / 1024 / 1024) // MB
      },
      process: {
        pid: process.pid,
        version: process.version,
        platform: process.platform,
        arch: process.arch
      },
      timestamp: new Date().toISOString()
    };
  } catch (error) {
    console.error('[SYSTEM_SERVICE] Error getting system metrics:', error);
    throw error;
  }
};

module.exports = {
  checkAllServices,
  getSystemLogs,
  getSystemMetrics
};
