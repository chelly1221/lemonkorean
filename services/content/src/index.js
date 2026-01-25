require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { connectPostgres, testPostgresConnection } = require('./config/database');
const { connectMongoDB, testMongoConnection } = require('./config/mongodb');
const { connectRedis, testRedisConnection } = require('./config/redis');

// Import routes
const lessonsRoutes = require('./routes/lessons.routes');
const vocabularyRoutes = require('./routes/vocabulary.routes');
const grammarRoutes = require('./routes/grammar.routes');

const app = express();
const PORT = process.env.PORT || 3002;

// ==================== Middleware ====================
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// ==================== Routes ====================
app.use('/api/content/lessons', lessonsRoutes);
app.use('/api/content/vocabulary', vocabularyRoutes);
app.use('/api/content/grammar', grammarRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    service: 'content-service',
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
    connections: {
      postgres: 'connected',
      mongodb: 'connected',
      redis: 'connected'
    }
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    service: 'Lemon Korean Content Service',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      lessons: '/api/content/lessons',
      vocabulary: '/api/content/vocabulary',
      grammar: '/api/content/grammar'
    }
  });
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
  console.error('Error:', err);

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
    // Test database connections
    console.log('Testing database connections...');

    await testPostgresConnection();
    console.log('✓ PostgreSQL connection successful');

    await testMongoConnection();
    console.log('✓ MongoDB connection successful');

    await testRedisConnection();
    console.log('✓ Redis connection successful');

    // Start server
    app.listen(PORT, '0.0.0.0', () => {
      console.log('========================================');
      console.log(`🚀 Content Service running on port ${PORT}`);
      console.log(`📝 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🏥 Health check: http://localhost:${PORT}/health`);
      console.log('========================================');
    });
  } catch (error) {
    console.error('❌ Failed to start server:', error);
    process.exit(1);
  }
};

// Handle graceful shutdown
process.on('SIGTERM', () => {
  console.log('SIGTERM signal received: closing HTTP server');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('SIGINT signal received: closing HTTP server');
  process.exit(0);
});

startServer();

module.exports = app;
