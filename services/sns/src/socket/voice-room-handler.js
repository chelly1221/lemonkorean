/**
 * Voice room socket event handlers
 * Handles joining/leaving voice room socket rooms, chat, character positions, reactions, gestures
 */
const VoiceRoom = require('../models/voice-room.model');

module.exports = (io, socket) => {
  const userId = socket.userId;

  // Track which voice rooms this socket has joined (for disconnect cleanup)
  socket._voiceRooms = socket._voiceRooms || new Set();

  // Helper: validate room_id is a positive integer
  const validateRoomId = (room_id) => {
    const id = typeof room_id === 'number' ? room_id : parseInt(room_id);
    return (!isNaN(id) && id > 0) ? id : null;
  };

  // Helper: check if socket is in a specific voice room
  const isInRoom = (room_id) => socket.rooms.has(`voice:${room_id}`);

  // Join voice room socket room (with participation check)
  socket.on('voice:join_room', async ({ room_id }) => {
    try {
      const roomId = validateRoomId(room_id);
      if (!roomId) return;

      // Verify user is actually a participant in the room
      const isParticipant = await VoiceRoom.isParticipant(roomId, userId);
      if (!isParticipant) {
        socket.emit('voice:error', { message: 'Not a participant of this room' });
        return;
      }

      socket.join(`voice:${roomId}`);
      socket._voiceRooms.add(roomId);
      console.log(`[Socket] User ${userId} joined voice room ${roomId}`);
    } catch (err) {
      console.error('[Socket] voice:join_room error:', err.message);
    }
  });

  // Leave voice room socket room
  socket.on('voice:leave_room', ({ room_id }) => {
    try {
      const roomId = validateRoomId(room_id);
      if (!roomId) return;
      socket.leave(`voice:${roomId}`);
      socket._voiceRooms.delete(roomId);
    } catch (err) {
      console.error('[Socket] voice:leave_room error:', err.message);
    }
  });

  // Character position update (stage walking)
  socket.on('voice:character_position', ({ room_id, x, y, direction }) => {
    try {
      const roomId = validateRoomId(room_id);
      if (!roomId) return;
      if (!isInRoom(roomId)) return;
      if (typeof x !== 'number' || typeof y !== 'number') return;
      // Clamp coordinates to valid range
      const cx = Math.max(0, Math.min(1, x));
      const cy = Math.max(0, Math.min(1, y));
      const validDirections = ['front', 'back', 'left', 'right'];
      const dir = validDirections.includes(direction) ? direction : 'front';

      socket.to(`voice:${roomId}`).emit('voice:character_position', {
        user_id: userId,
        x: cx,
        y: cy,
        direction: dir
      });
    } catch (err) {
      console.error('[Socket] voice:character_position error:', err.message);
    }
  });

  // Emoji reaction (all room members can send)
  socket.on('voice:reaction', ({ room_id, emoji }) => {
    try {
      const roomId = validateRoomId(room_id);
      if (!roomId) return;
      if (!isInRoom(roomId)) return;
      if (!emoji || typeof emoji !== 'string' || emoji.length > 10) return;

      io.to(`voice:${roomId}`).emit('voice:reaction', {
        user_id: userId,
        emoji,
        name: socket.userName
      });
    } catch (err) {
      console.error('[Socket] voice:reaction error:', err.message);
    }
  });

  // Character gesture (speakers only — verified via DB role check)
  socket.on('voice:gesture', async ({ room_id, gesture }) => {
    try {
      const roomId = validateRoomId(room_id);
      if (!roomId) return;
      if (!isInRoom(roomId)) return;
      const validGestures = ['wave', 'bow', 'dance', 'jump', 'clap'];
      if (!validGestures.includes(gesture)) return;

      // Verify user is a speaker (not just in the socket room)
      const role = await VoiceRoom.getParticipantRole(roomId, userId);
      if (role !== 'speaker') return;

      io.to(`voice:${roomId}`).emit('voice:gesture', {
        user_id: userId,
        gesture
      });
    } catch (err) {
      console.error('[Socket] voice:gesture error:', err.message);
    }
  });
};
