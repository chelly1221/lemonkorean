const Message = require('../models/message.model');
const Conversation = require('../models/conversation.model');
const Block = require('../models/block.model');
const { getMinioClient } = require('../config/minio');
const { v4: uuidv4 } = require('uuid');
const multer = require('multer');
const path = require('path');

const BUCKET_NAME = process.env.MINIO_BUCKET || 'lemon-korean-media';

// Multer config for file uploads (memory storage)
const upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 10 * 1024 * 1024 }, // 10MB
  fileFilter: (req, file, cb) => {
    const allowedMimes = [
      'image/jpeg', 'image/png', 'image/gif', 'image/webp',
      'audio/webm', 'audio/ogg', 'audio/mpeg', 'audio/mp4', 'audio/wav', 'audio/aac'
    ];
    if (allowedMimes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error('Invalid file type'));
    }
  }
});

/**
 * Get message history for a conversation
 */
const getMessages = async (req, res) => {
  try {
    const userId = req.user.id;
    const conversationId = parseInt(req.params.id);
    const cursor = req.query.cursor ? parseInt(req.query.cursor) : null;
    const limit = Math.min(parseInt(req.query.limit) || 30, 50);

    // Verify participation
    const isParticipant = await Conversation.isParticipant(conversationId, userId);
    if (!isParticipant) {
      return res.status(403).json({ error: 'Not a participant' });
    }

    const messages = await Message.getByConversation(conversationId, { cursor, limit });

    const nextCursor = messages.length === limit ? messages[messages.length - 1].id : null;

    res.json({
      messages,
      next_cursor: nextCursor
    });
  } catch (error) {
    console.error('[SNS] getMessages error:', error);
    res.status(500).json({ error: 'Failed to load messages' });
  }
};

/**
 * Send a message (REST fallback when Socket.IO unavailable)
 */
const sendMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const conversationId = parseInt(req.params.id);
    const { message_type = 'text', content, media_url, media_metadata, client_message_id } = req.body;

    // Verify participation
    const isParticipant = await Conversation.isParticipant(conversationId, userId);
    if (!isParticipant) {
      return res.status(403).json({ error: 'Not a participant' });
    }

    // Check block status
    const otherUserId = await Conversation.getOtherUserId(conversationId, userId);
    if (otherUserId) {
      const blocked = await Block.isBlockedEitherWay(userId, otherUserId);
      if (blocked) {
        return res.status(403).json({ error: 'Cannot message this user' });
      }
    }

    // Create message
    const message = await Message.create({
      conversationId,
      senderId: userId,
      messageType: message_type,
      content,
      mediaUrl: media_url,
      mediaMetadata: media_metadata,
      clientMessageId: client_message_id
    });

    // Update conversation last message
    const preview = message_type === 'text'
      ? (content || '').substring(0, 100)
      : message_type === 'image' ? '[Image]' : '[Voice]';
    await Conversation.updateLastMessage(conversationId, message.id, preview);

    // Emit via Socket.IO if available
    const io = req.app.get('io');
    if (io) {
      const fullMessage = await Message.getById(message.id);
      io.to(`conversation:${conversationId}`).emit('dm:new_message', fullMessage);
    }

    const fullMessage = await Message.getById(message.id);
    res.status(201).json({ message: fullMessage });
  } catch (error) {
    console.error('[SNS] sendMessage error:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
};

/**
 * Delete a message (soft delete, sender only)
 */
const deleteMessage = async (req, res) => {
  try {
    const userId = req.user.id;
    const messageId = parseInt(req.params.id);

    const deleted = await Message.softDelete(messageId, userId);
    if (!deleted) {
      return res.status(404).json({ error: 'Message not found or not yours' });
    }

    // Notify via Socket.IO
    const io = req.app.get('io');
    if (io && deleted.conversation_id) {
      io.to(`conversation:${deleted.conversation_id}`).emit('dm:message_deleted', {
        message_id: messageId,
        conversation_id: deleted.conversation_id
      });
    }

    res.json({ success: true });
  } catch (error) {
    console.error('[SNS] deleteMessage error:', error);
    res.status(500).json({ error: 'Failed to delete message' });
  }
};

/**
 * Upload media file (image or voice) for DM
 */
const uploadMedia = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file provided' });
    }

    const file = req.file;
    const isImage = file.mimetype.startsWith('image/');
    const folder = isImage ? 'dm-images' : 'dm-voice';
    const ext = path.extname(file.originalname) || (isImage ? '.jpg' : '.webm');
    const objectName = `${folder}/${uuidv4()}${ext}`;

    const minio = getMinioClient();
    await minio.putObject(BUCKET_NAME, objectName, file.buffer, file.size, {
      'Content-Type': file.mimetype
    });

    // Build URL via media service
    const mediaUrl = `/media/${BUCKET_NAME}/${objectName}`;

    res.json({
      media_url: mediaUrl,
      media_metadata: {
        file_size: file.size,
        mime_type: file.mimetype,
        original_name: file.originalname
      }
    });
  } catch (error) {
    console.error('[SNS] uploadMedia error:', error);
    res.status(500).json({ error: 'Failed to upload file' });
  }
};

module.exports = {
  getMessages,
  sendMessage,
  deleteMessage,
  uploadMedia,
  upload
};
