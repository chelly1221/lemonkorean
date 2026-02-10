const { Server } = require('socket.io');
const { verifyToken } = require('../config/jwt');
const { query } = require('../config/database');
const { getRedisClient } = require('../config/redis');
const dmHandler = require('./dm-handler');
const voiceRoomHandler = require('./voice-room-handler');

const ONLINE_TTL = 300; // 5 minutes

/**
 * Initialize Socket.IO server with JWT auth
 */
const initSocketIO = (httpServer) => {
  const io = new Server(httpServer, {
    path: '/api/sns/socket.io',
    cors: {
      origin: '*',
      methods: ['GET', 'POST']
    },
    pingTimeout: 60000,
    pingInterval: 25000
  });

  // ==================== Authentication Middleware ====================
  io.use(async (socket, next) => {
    try {
      const token = socket.handshake.auth?.token;
      if (!token) {
        return next(new Error('Authentication required'));
      }

      const decoded = verifyToken(token);

      // Verify user exists and is active
      const result = await query(
        'SELECT id, name, profile_image_url FROM users WHERE id = $1 AND is_active = true',
        [decoded.userId]
      );

      if (!result.rows[0]) {
        return next(new Error('User not found'));
      }

      socket.userId = result.rows[0].id;
      socket.userName = result.rows[0].name;
      socket.userAvatar = result.rows[0].profile_image_url;

      next();
    } catch (error) {
      console.error('[Socket] Auth error:', error.message);
      next(new Error('Invalid token'));
    }
  });

  // ==================== Connection Handler ====================
  io.on('connection', async (socket) => {
    const userId = socket.userId;
    console.log(`[Socket] User ${userId} connected (${socket.id})`);

    // Join personal room for direct notifications
    socket.join(`user:${userId}`);

    // Track online status in Redis
    const redis = getRedisClient();
    if (redis) {
      try {
        await redis.set(`dm:online:${userId}`, socket.id, { EX: ONLINE_TTL });
        // Broadcast online status
        socket.broadcast.emit('dm:user_online', { user_id: userId });
      } catch (e) {
        console.error('[Socket] Redis online set error:', e.message);
      }
    }

    // Register event handlers
    dmHandler(io, socket);
    voiceRoomHandler(io, socket);

    // ==================== Disconnect ====================
    socket.on('disconnect', async (reason) => {
      console.log(`[Socket] User ${userId} disconnected: ${reason}`);

      if (redis) {
        try {
          await redis.del(`dm:online:${userId}`);
          socket.broadcast.emit('dm:user_offline', { user_id: userId });
        } catch (e) {
          console.error('[Socket] Redis online del error:', e.message);
        }
      }
    });

    // Heartbeat to refresh online TTL
    socket.on('ping_alive', async () => {
      if (redis) {
        try {
          await redis.set(`dm:online:${userId}`, socket.id, { EX: ONLINE_TTL });
        } catch (e) { /* ignore */ }
      }
    });
  });

  console.log('[Socket] Socket.IO initialized');
  return io;
};

module.exports = { initSocketIO };
