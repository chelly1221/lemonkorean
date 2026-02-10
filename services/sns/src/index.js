require('dotenv').config();
const express = require('express');
const http = require('http');
const cors = require('cors');
const postsRoutes = require('./routes/posts.routes');
const commentsRoutes = require('./routes/comments.routes');
const followsRoutes = require('./routes/follows.routes');
const profilesRoutes = require('./routes/profiles.routes');
const reportsRoutes = require('./routes/reports.routes');
const blocksRoutes = require('./routes/blocks.routes');
const conversationsRoutes = require('./routes/conversations.routes');
const messagesRoutes = require('./routes/messages.routes');
const voiceRoomsRoutes = require('./routes/voice-rooms.routes');
const { testConnection } = require('./config/database');
const { initRedis } = require('./config/redis');
const { initMinIO, ensureBucket } = require('./config/minio');
const { initSocketIO } = require('./socket/socket-manager');

const app = express();
const server = http.createServer(app);
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
  // Skip Socket.IO polling noise
  if (req.path.includes('/socket.io')) return next();
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
app.use('/api/sns/conversations', conversationsRoutes);
app.use('/api/sns', messagesRoutes);
app.use('/api/sns/voice-rooms', voiceRoomsRoutes);

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
    version: '2.0.0',
    endpoints: {
      health: '/health',
      posts: '/api/sns/posts',
      comments: '/api/sns/comments',
      follows: '/api/sns/follows',
      profiles: '/api/sns/profiles',
      reports: '/api/sns/reports',
      blocks: '/api/sns/blocks',
      conversations: '/api/sns/conversations',
      messages: '/api/sns/conversations/:id/messages',
      dmUpload: '/api/sns/dm/upload',
      voiceRooms: '/api/sns/voice-rooms',
      socketio: '/api/sns/socket.io'
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

    // Initialize Redis (non-fatal if fails)
    await initRedis();

    // Initialize MinIO
    try {
      initMinIO();
      const bucket = process.env.MINIO_BUCKET || 'lemon-korean-media';
      await ensureBucket(bucket);
      console.log('[SNS] MinIO ready');
    } catch (e) {
      console.warn('[SNS] MinIO init failed (DM media upload will be unavailable):', e.message);
    }

    // Initialize Socket.IO
    const io = initSocketIO(server);
    app.set('io', io);

    // Start HTTP server (Socket.IO attached)
    server.listen(PORT, '0.0.0.0', () => {
      console.log('========================================');
      console.log(`[SNS] SNS Service running on port ${PORT}`);
      console.log(`[SNS] Socket.IO path: /api/sns/socket.io`);
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
  server.close(() => process.exit(0));
});

process.on('SIGINT', () => {
  console.log('[SNS] SIGINT signal received: closing HTTP server');
  server.close(() => process.exit(0));
});

startServer();

module.exports = app;
