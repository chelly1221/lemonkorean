require('dotenv').config();
const express = require('express');
const path = require('path');
const cors = require('cors');
const { testConnection } = require('./config/database');
const { testMongoConnection } = require('./config/mongodb');
const { testRedisConnection } = require('./config/redis');
const { testMinIOConnection } = require('./config/minio');

// Import routes
const authRoutes = require('./routes/auth.routes');
const usersRoutes = require('./routes/users.routes');
const lessonsRoutes = require('./routes/lessons.routes');
const vocabularyRoutes = require('./routes/vocabulary.routes');
const mediaRoutes = require('./routes/media.routes');
const analyticsRoutes = require('./routes/analytics.routes');
const systemRoutes = require('./routes/system.routes');
const testRoutes = require('./routes/test.routes');
const docsRoutes = require('./routes/docs.routes');
const devNotesRoutes = require('./routes/dev-notes.routes');
const hangulRoutes = require('./routes/hangul.routes');
const deployRoutes = require('./routes/deploy.routes');

const app = express();
const PORT = process.env.PORT || 3006;

// ==================== Middleware ====================
// CORS configuration - allow web app and mobile clients
app.use(cors({
  origin: '*', // Allow all origins in development
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'X-Requested-With'],
  exposedHeaders: ['Content-Length', 'X-Request-Id'],
  maxAge: 86400 // 24 hours
}));

// Handle OPTIONS preflight requests explicitly
app.options('*', cors());

app.use(express.json({ limit: '200mb' }));
app.use(express.urlencoded({ limit: '200mb', extended: true }));

// Static files (Admin Dashboard UI)
app.use(express.static(path.join(__dirname, '../public')));

// Request logging
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// ==================== Routes ====================
app.use('/api/admin/auth', authRoutes);
app.use('/api/admin/users', usersRoutes);
app.use('/api/admin/lessons', lessonsRoutes);
app.use('/api/admin/vocabulary', vocabularyRoutes);
app.use('/api/admin/media', mediaRoutes);
app.use('/api/admin/analytics', analyticsRoutes);
app.use('/api/admin/system', systemRoutes);
app.use('/api/admin/test', testRoutes);
app.use('/api/admin/docs', docsRoutes);
app.use('/api/admin/dev-notes', devNotesRoutes);
app.use('/api/admin/hangul', hangulRoutes);
app.use('/api/admin/deploy', deployRoutes);

// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    // Check all connections
    const health = {
      status: 'healthy',
      service: 'admin-service',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      connections: {}
    };

    // PostgreSQL
    try {
      await testConnection();
      health.connections.postgres = 'connected';
    } catch (err) {
      health.connections.postgres = 'disconnected';
      health.status = 'degraded';
    }

    // MongoDB
    try {
      await testMongoConnection();
      health.connections.mongodb = 'connected';
    } catch (err) {
      health.connections.mongodb = 'disconnected';
      health.status = 'degraded';
    }

    // Redis
    try {
      await testRedisConnection();
      health.connections.redis = 'connected';
    } catch (err) {
      health.connections.redis = 'disconnected';
      health.status = 'degraded';
    }

    // MinIO
    try {
      await testMinIOConnection();
      health.connections.minio = 'connected';
    } catch (err) {
      health.connections.minio = 'disconnected';
      health.status = 'degraded';
    }

    const statusCode = health.status === 'healthy' ? 200 : 503;
    res.status(statusCode).json(health);
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      service: 'admin-service',
      timestamp: new Date().toISOString(),
      error: error.message
    });
  }
});

// Root endpoint - Serve Admin Dashboard
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/index.html'));
});

// ==================== Error Handling ====================
// 404 handler
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.method} ${req.path} not found`,
    timestamp: new Date().toISOString()
  });
});

// Global error handler
app.use((err, req, res, next) => {
  console.error('[ERROR]', err);

  const status = err.status || 500;
  const message = err.message || 'Internal Server Error';

  res.status(status).json({
    error: message,
    timestamp: new Date().toISOString(),
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// ==================== Server Startup ====================
const startServer = async () => {
  try {
    console.log('========================================');
    console.log('🔧 Admin Service Starting...');
    console.log('========================================');
    console.log('Testing database connections...');

    // Test all connections
    await testConnection();
    console.log('✓ PostgreSQL connection successful');

    await testMongoConnection();
    console.log('✓ MongoDB connection successful');

    // Initialize Redis connection BEFORE testing
    const { connectRedis, getRedisClient } = require('./config/redis');
    await connectRedis();
    console.log('✓ Redis connected');

    await testRedisConnection();
    console.log('✓ Redis connection successful');

    await testMinIOConnection();
    console.log('✓ MinIO connection successful');

    // Start server
    app.listen(PORT, '0.0.0.0', () => {
      console.log('========================================');
      console.log(`🚀 Admin Service running on port ${PORT}`);
      console.log(`📝 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🏥 Health check: http://localhost:${PORT}/health`);
      console.log('========================================');
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    console.error('   Make sure all required services are running:');
    console.error('   - PostgreSQL (DATABASE_URL)');
    console.error('   - MongoDB (MONGO_URL)');
    console.error('   - Redis (REDIS_HOST/REDIS_PORT/REDIS_PASSWORD)');
    console.error('   - MinIO (MINIO_ENDPOINT/MINIO_ACCESS_KEY/MINIO_SECRET_KEY)');
    process.exit(1);
  }
};

// Handle graceful shutdown
const shutdown = async () => {
  console.log('\n🛑 Shutting down gracefully...');

  try {
    const { closeRedis } = require('./config/redis');
    const { closeMongoDB } = require('./config/mongodb');

    await closeRedis();
    console.log('✓ Redis connection closed');

    await closeMongoDB();
    console.log('✓ MongoDB connection closed');

    console.log('✓ Shutdown complete');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error during shutdown:', error);
    process.exit(1);
  }
};

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

startServer();

module.exports = app;
