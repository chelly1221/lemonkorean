const VoiceRoom = require('../models/voice-room.model');
const VoiceRoomMessage = require('../models/voice-room-message.model');
const Block = require('../models/block.model');
const { generateToken, getLiveKitUrl } = require('../config/livekit');

/**
 * Get active voice rooms
 */
const getRooms = async (req, res) => {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 20, 50);
    const offset = parseInt(req.query.offset) || 0;

    const rooms = await VoiceRoom.getActiveRooms({ limit, offset });

    res.json({ rooms });
  } catch (error) {
    console.error('[SNS] getRooms error:', error.message);
    res.status(500).json({ error: 'Failed to load rooms' });
  }
};

/**
 * Create a voice room (creator joins as speaker)
 */
const createRoom = async (req, res) => {
  try {
    const userId = req.user.id;
    const { title, topic, language_level, max_speakers } = req.body;

    if (!title || title.trim().length === 0) {
      return res.status(400).json({ error: 'Title is required' });
    }

    const room = await VoiceRoom.create({
      creatorId: userId,
      title: title.trim(),
      topic: topic?.trim() || null,
      languageLevel: language_level || 'all',
      maxSpeakers: Math.min(Math.max(parseInt(max_speakers) || 4, 2), 4)
    });

    // Auto-join creator as speaker
    await VoiceRoom.joinAsSpeaker(room.id, userId);

    // Generate LiveKit token with canPublish for creator (speaker)
    const token = await generateToken(room.livekit_room_name, userId, req.user.name, 'speaker');
    const fullRoom = await VoiceRoom.getById(room.id);
    const speakers = await VoiceRoom.getSpeakers(room.id);

    // Broadcast new room via Socket.IO
    const io = req.app.get('io');
    if (io) {
      io.emit('voice:room_created', fullRoom);
    }

    res.status(201).json({
      room: fullRoom,
      speakers,
      listeners: [],
      livekit_token: token,
      livekit_url: getLiveKitUrl(),
      role: 'speaker'
    });
  } catch (error) {
    console.error('[SNS] createRoom error:', error);
    res.status(500).json({ error: 'Failed to create room' });
  }
};

/**
 * Get room details with separated speakers/listeners
 */
const getRoom = async (req, res) => {
  try {
    const roomId = parseInt(req.params.id);
    const room = await VoiceRoom.getById(roomId);

    if (!room) {
      return res.status(404).json({ error: 'Room not found' });
    }

    const speakers = await VoiceRoom.getSpeakers(roomId);
    const listeners = await VoiceRoom.getListeners(roomId);
    const pendingRequests = await VoiceRoom.getPendingRequests(roomId);

    res.json({ room, speakers, listeners, pending_requests: pendingRequests });
  } catch (error) {
    console.error('[SNS] getRoom error:', error);
    res.status(500).json({ error: 'Failed to load room' });
  }
};

/**
 * Join a voice room as listener
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

    // Check block with any current speaker
    const speakers = await VoiceRoom.getSpeakers(roomId);
    for (const p of speakers) {
      const pBlocked = await Block.isBlockedEitherWay(userId, p.user_id);
      if (pBlocked) {
        return res.status(403).json({ error: 'Cannot join this room' });
      }
    }

    // Join as listener (no capacity check)
    const participant = await VoiceRoom.join(roomId, userId);

    // Generate LiveKit token with canPublish: false for listener
    const token = await generateToken(room.livekit_room_name, userId, req.user.name, 'listener');

    // Broadcast join event
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:participant_joined', {
        room_id: roomId,
        user_id: userId,
        name: req.user.name,
        avatar: req.user.profileImageUrl,
        role: 'listener'
      });
    }

    res.json({
      participant,
      livekit_token: token,
      livekit_url: getLiveKitUrl(),
      role: 'listener'
    });
  } catch (error) {
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

/**
 * Get chat messages for a room
 */
const getMessages = async (req, res) => {
  try {
    const roomId = parseInt(req.params.id);
    const limit = Math.min(parseInt(req.query.limit) || 50, 100);
    const before = req.query.before ? parseInt(req.query.before) : undefined;

    const messages = await VoiceRoomMessage.getByRoom(roomId, { limit, before });
    res.json({ messages });
  } catch (error) {
    console.error('[SNS] getMessages error:', error);
    res.status(500).json({ error: 'Failed to load messages' });
  }
};

/**
 * Send a chat message
 */
const sendMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);
    const { content } = req.body;

    if (!content || content.trim().length === 0) {
      return res.status(400).json({ error: 'Message content is required' });
    }

    if (content.length > 500) {
      return res.status(400).json({ error: 'Message too long (max 500 chars)' });
    }

    // Must be a participant
    const isParticipant = await VoiceRoom.isParticipant(roomId, userId);
    if (!isParticipant) {
      return res.status(403).json({ error: 'You must be in the room to send messages' });
    }

    const message = await VoiceRoomMessage.create({
      roomId,
      userId,
      content: content.trim(),
      messageType: 'text'
    });

    // Broadcast via Socket.IO
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:new_message', {
        ...message,
        name: req.user.name,
        avatar: req.user.profileImageUrl
      });
    }

    res.status(201).json({ message });
  } catch (error) {
    console.error('[SNS] sendMessage error:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
};

/**
 * Request to join stage (raise hand)
 */
const requestStage = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);

    // Must be a listener
    const role = await VoiceRoom.getParticipantRole(roomId, userId);
    if (role !== 'listener') {
      return res.status(400).json({ error: 'Only listeners can request to join stage' });
    }

    const request = await VoiceRoom.requestStage(roomId, userId);

    // Notify room (especially creator)
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:stage_request', {
        room_id: roomId,
        user_id: userId,
        name: req.user.name,
        avatar: req.user.profileImageUrl
      });
    }

    res.json({ request });
  } catch (error) {
    console.error('[SNS] requestStage error:', error);
    res.status(500).json({ error: 'Failed to request stage' });
  }
};

/**
 * Cancel own stage request
 */
const cancelStageRequest = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);

    await VoiceRoom.cancelStageRequest(roomId, userId);

    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:stage_request_cancelled', {
        room_id: roomId,
        user_id: userId
      });
    }

    res.json({ success: true });
  } catch (error) {
    console.error('[SNS] cancelStageRequest error:', error);
    res.status(500).json({ error: 'Failed to cancel request' });
  }
};

/**
 * Grant stage access (creator only) - promotes listener to speaker
 */
const grantStage = async (req, res) => {
  try {
    const creatorId = req.user.id;
    const roomId = parseInt(req.params.id);
    const { user_id: targetUserId } = req.body;

    if (!targetUserId) {
      return res.status(400).json({ error: 'user_id is required' });
    }

    // Verify requester is creator
    const room = await VoiceRoom.getById(roomId);
    if (!room || room.creator_id !== creatorId) {
      return res.status(403).json({ error: 'Only the room creator can manage the stage' });
    }

    // Promote listener to speaker
    const result = await VoiceRoom.promoteToSpeaker(roomId, targetUserId);

    // Resolve stage request if exists
    await VoiceRoom.resolveStageRequest(roomId, targetUserId, 'approved');

    // Generate new LiveKit token with canPublish for the promoted user
    const token = await generateToken(room.livekit_room_name, targetUserId, '', 'speaker');

    // Broadcast role change
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:role_changed', {
        room_id: roomId,
        user_id: targetUserId,
        role: 'speaker',
        equipped_items: result.equipped_items,
        skin_color: result.skin_color
      });

      io.to(`voice:${roomId}`).emit('voice:stage_granted', {
        room_id: roomId,
        user_id: targetUserId,
        livekit_token: token
      });
    }

    res.json({ success: true, livekit_token: token });
  } catch (error) {
    if (error.message === 'Stage is full') {
      return res.status(400).json({ error: 'Stage is full' });
    }
    console.error('[SNS] grantStage error:', error);
    res.status(500).json({ error: 'Failed to grant stage access' });
  }
};

/**
 * Remove from stage (creator only) - demotes speaker to listener
 */
const removeFromStage = async (req, res) => {
  try {
    const creatorId = req.user.id;
    const roomId = parseInt(req.params.id);
    const { user_id: targetUserId } = req.body;

    if (!targetUserId) {
      return res.status(400).json({ error: 'user_id is required' });
    }

    // Verify requester is creator
    const room = await VoiceRoom.getById(roomId);
    if (!room || room.creator_id !== creatorId) {
      return res.status(403).json({ error: 'Only the room creator can manage the stage' });
    }

    await VoiceRoom.demoteToListener(roomId, targetUserId);

    // Generate new listener token
    const token = await generateToken(room.livekit_room_name, targetUserId, '', 'listener');

    // Broadcast role change
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:role_changed', {
        room_id: roomId,
        user_id: targetUserId,
        role: 'listener'
      });

      io.to(`voice:${roomId}`).emit('voice:stage_removed', {
        room_id: roomId,
        user_id: targetUserId,
        livekit_token: token
      });
    }

    res.json({ success: true, livekit_token: token });
  } catch (error) {
    if (error.message === 'Cannot demote the room creator') {
      return res.status(400).json({ error: 'Cannot demote the room creator' });
    }
    console.error('[SNS] removeFromStage error:', error);
    res.status(500).json({ error: 'Failed to remove from stage' });
  }
};

/**
 * Speaker voluntarily leaves stage (demote self to listener)
 */
const leaveStage = async (req, res) => {
  try {
    const userId = req.user.id;
    const roomId = parseInt(req.params.id);

    // Creator cannot leave stage (they must close the room)
    const room = await VoiceRoom.getById(roomId);
    if (room && room.creator_id === userId) {
      return res.status(400).json({ error: 'Creator cannot leave stage. Close the room instead.' });
    }

    await VoiceRoom.demoteToListener(roomId, userId);

    // Generate new listener token
    const token = await generateToken(room.livekit_room_name, userId, req.user.name, 'listener');

    // Broadcast role change
    const io = req.app.get('io');
    if (io) {
      io.to(`voice:${roomId}`).emit('voice:role_changed', {
        room_id: roomId,
        user_id: userId,
        role: 'listener'
      });
    }

    res.json({ success: true, livekit_token: token, livekit_url: getLiveKitUrl() });
  } catch (error) {
    console.error('[SNS] leaveStage error:', error);
    res.status(500).json({ error: 'Failed to leave stage' });
  }
};

module.exports = {
  getRooms,
  createRoom,
  getRoom,
  joinRoom,
  leaveRoom,
  closeRoom,
  toggleMute,
  getMessages,
  sendMessage,
  requestStage,
  cancelStageRequest,
  grantStage,
  removeFromStage,
  leaveStage
};
