const VoiceRoom = require('../models/voice-room.model');
const Block = require('../models/block.model');
const { generateToken, getLiveKitUrl } = require('../config/livekit');

/**
 * Get active voice rooms
 */
const getRooms = async (req, res) => {
  try {
    const userId = req.user?.id || 'anonymous';
    const limit = Math.min(parseInt(req.query.limit) || 20, 50);
    const offset = parseInt(req.query.offset) || 0;

    console.log(`[SNS] getRooms called by user=${userId}, limit=${limit}, offset=${offset}`);

    const rooms = await VoiceRoom.getActiveRooms({ limit, offset });

    console.log(`[SNS] getRooms returning ${rooms.length} rooms for user=${userId}`,
      rooms.map(r => ({ id: r.id, status: r.status, participants: r.participant_count, creator: r.creator_id })));

    res.json({ rooms });
  } catch (error) {
    console.error('[SNS] getRooms error:', error.message, error.stack);
    res.status(500).json({ error: 'Failed to load rooms' });
  }
};

/**
 * Create a voice room
 */
const createRoom = async (req, res) => {
  try {
    const userId = req.user.id;
    const { title, topic, language_level, max_participants } = req.body;

    if (!title || title.trim().length === 0) {
      return res.status(400).json({ error: 'Title is required' });
    }

    const room = await VoiceRoom.create({
      creatorId: userId,
      title: title.trim(),
      topic: topic?.trim() || null,
      languageLevel: language_level || 'all',
      maxParticipants: Math.min(Math.max(parseInt(max_participants) || 4, 2), 4)
    });

    // Auto-join creator
    await VoiceRoom.join(room.id, userId);

    // Generate LiveKit token for creator
    const token = await generateToken(room.livekit_room_name, userId, req.user.name);
    const fullRoom = await VoiceRoom.getById(room.id);

    // Broadcast new room via Socket.IO
    const io = req.app.get('io');
    if (io) {
      io.emit('voice:room_created', fullRoom);
    }

    res.status(201).json({
      room: fullRoom,
      livekit_token: token,
      livekit_url: getLiveKitUrl()
    });
  } catch (error) {
    console.error('[SNS] createRoom error:', error);
    res.status(500).json({ error: 'Failed to create room' });
  }
};

/**
 * Get room details
 */
const getRoom = async (req, res) => {
  try {
    const roomId = parseInt(req.params.id);
    const room = await VoiceRoom.getById(roomId);

    if (!room) {
      return res.status(404).json({ error: 'Room not found' });
    }

    const participants = await VoiceRoom.getParticipants(roomId);

    res.json({ room, participants });
  } catch (error) {
    console.error('[SNS] getRoom error:', error);
    res.status(500).json({ error: 'Failed to load room' });
  }
};

/**
 * Join a voice room
 */
const joinRoom = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);

    const room = await VoiceRoom.getById(roomId);
    if (!room || room.status !== 'active') {
      return res.status(404).json({ error: 'Room not found or closed' });
    }

    // Check block status with creator
    const blocked = await Block.isBlockedEitherWay(userId, room.creator_id);
    if (blocked) {
      return res.status(403).json({ error: 'Cannot join this room' });
    }

    // Check block with any current participant
    const participants = await VoiceRoom.getParticipants(roomId);
    for (const p of participants) {
      const pBlocked = await Block.isBlockedEitherWay(userId, p.user_id);
      if (pBlocked) {
        return res.status(403).json({ error: 'Cannot join this room' });
      }
    }

    const participant = await VoiceRoom.join(roomId, userId);
    const token = await generateToken(room.livekit_room_name, userId, req.user.name);

    // Broadcast join event
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:participant_joined', {
        room_id: roomId,
        user_id: userId,
        name: req.user.name,
        avatar: req.user.profileImageUrl
      });
    }

    res.json({
      participant,
      livekit_token: token,
      livekit_url: getLiveKitUrl()
    });
  } catch (error) {
    if (error.message === 'Room is full') {
      return res.status(400).json({ error: 'Room is full' });
    }
    console.error('[SNS] joinRoom error:', error);
    res.status(500).json({ error: 'Failed to join room' });
  }
};

/**
 * Leave a voice room
 */
const leaveRoom = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);

    const result = await VoiceRoom.leave(roomId, userId);

    // Broadcast leave event
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:participant_left', {
        room_id: roomId,
        user_id: userId
      });

      // Check if room is now closed
      const room = await VoiceRoom.getById(roomId);
      if (room && room.status === 'closed') {
        io.emit('voice:room_closed', { room_id: roomId });
      }
    }

    res.json({ success: true });
  } catch (error) {
    console.error('[SNS] leaveRoom error:', error);
    res.status(500).json({ error: 'Failed to leave room' });
  }
};

/**
 * Close a room (creator only)
 */
const closeRoom = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);

    const result = await VoiceRoom.close(roomId, userId);
    if (!result) {
      return res.status(403).json({ error: 'Only the room creator can close the room' });
    }

    // Broadcast close event
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:room_closed', { room_id: roomId });
      io.emit('voice:room_closed', { room_id: roomId });
    }

    res.json({ success: true });
  } catch (error) {
    console.error('[SNS] closeRoom error:', error);
    res.status(500).json({ error: 'Failed to close room' });
  }
};

/**
 * Toggle mute status
 */
const toggleMute = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);

    const result = await VoiceRoom.toggleMute(roomId, userId);
    if (!result) {
      return res.status(404).json({ error: 'Not in this room' });
    }

    // Broadcast mute change
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:participant_muted', {
        room_id: roomId,
        user_id: userId,
        is_muted: result.is_muted
      });
    }

    res.json({ is_muted: result.is_muted });
  } catch (error) {
    console.error('[SNS] toggleMute error:', error);
    res.status(500).json({ error: 'Failed to toggle mute' });
  }
};

module.exports = {
  getRooms,
  createRoom,
  getRoom,
  joinRoom,
  leaveRoom,
  closeRoom,
  toggleMute
};
