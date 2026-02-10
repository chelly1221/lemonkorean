require('dotenv').config();
const express = require('express');
const cors = require('cors');
const postsRoutes = require('./routes/posts.routes');
const commentsRoutes = require('./routes/comments.routes');
const followsRoutes = require('./routes/follows.routes');
const profilesRoutes = require('./routes/profiles.routes');
const reportsRoutes = require('./routes/reports.routes');
const blocksRoutes = require('./routes/blocks.routes');
const { testConnection } = require('./config/database');

const app = express();
const PORT = process.env.PORT || 3007;

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

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
  console.log(`[SNS] [${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// ==================== Routes ====================
app.use('/api/sns/posts', postsRoutes);
app.use('/api/sns/comments', commentsRoutes);
app.use('/api/sns/follows', followsRoutes);
app.use('/api/sns/profiles', profilesRoutes);
app.use('/api/sns/reports', reportsRoutes);
app.use('/api/sns/blocks', blocksRoutes);

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'healthy',
    service: 'sns-service',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    service: 'Lemon Korean SNS Service',
    version: '1.0.0',
    endpoints: {
      health: '/health',
      posts: '/api/sns/posts',
      comments: '/api/sns/comments',
      follows: '/api/sns/follows',
      profiles: '/api/sns/profiles',
      reports: '/api/sns/reports',
      blocks: '/api/sns/blocks'
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
  console.error('[SNS] Error:', err);

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
    // Test database connection
    await testConnection();
    console.log('[SNS] Database connection successful');

    // Start server
    app.listen(PORT, '0.0.0.0', () => {
      console.log('========================================');
      console.log(`[SNS] SNS Service running on port ${PORT}`);
      console.log(`[SNS] Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`[SNS] Health check: http://localhost:${PORT}/health`);
      console.log('========================================');
    });
  } catch (error) {
    console.error('[SNS] Failed to start server:', error);
    process.exit(1);
  }
};

// Handle graceful shutdown
process.on('SIGTERM', () => {
  console.log('[SNS] SIGTERM signal received: closing HTTP server');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('[SNS] SIGINT signal received: closing HTTP server');
  process.exit(0);
});

startServer();

module.exports = app;
