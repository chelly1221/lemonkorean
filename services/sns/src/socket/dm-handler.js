const Message = require('../models/message.model');
const Conversation = require('../models/conversation.model');
const ReadReceipt = require('../models/read-receipt.model');
const Block = require('../models/block.model');

/**
 * Register DM socket event handlers for a connected socket
 */
module.exports = (io, socket) => {
  const userId = socket.userId;

  // ==================== Join/Leave Conversation Room ====================

  socket.on('dm:join_conversation', async ({ conversation_id }) => {
    try {
      const isParticipant = await Conversation.isParticipant(conversation_id, userId);
      if (!isParticipant) return;

      socket.join(`conversation:${conversation_id}`);
      console.log(`[Socket] User ${userId} joined conversation ${conversation_id}`);
    } catch (error) {
      console.error('[Socket] join_conversation error:', error.message);
    }
  });

  socket.on('dm:leave_conversation', ({ conversation_id }) => {
    socket.leave(`conversation:${conversation_id}`);
  });

  // ==================== Send Message ====================

  socket.on('dm:send_message', async (data, ack) => {
    try {
      const {
        conversation_id,
        message_type = 'text',
        content,
        media_url,
        media_metadata,
        client_message_id
      } = data;

      // Validate message_type
      const VALID_MESSAGE_TYPES = ['text', 'image', 'voice'];
      if (!VALID_MESSAGE_TYPES.includes(message_type)) {
        if (ack) ack({ error: 'Invalid message type' });
        return;
      }

      // Validate content length
      if (content && content.length > 5000) {
        if (ack) ack({ error: 'Message too long (max 5000 characters)' });
        return;
      }

      if (!content && !media_url) {
        if (ack) ack({ error: 'Message content or media is required' });
        return;
      }

      // Verify participation
      const isParticipant = await Conversation.isParticipant(conversation_id, userId);
      if (!isParticipant) {
        if (ack) ack({ error: 'Not a participant' });
        return;
      }

      // Check block status
      const otherUserId = await Conversation.getOtherUserId(conversation_id, userId);
      if (otherUserId) {
        const blocked = await Block.isBlockedEitherWay(userId, otherUserId);
        if (blocked) {
          if (ack) ack({ error: 'Cannot message this user' });
          return;
        }
      }

      // Create message
      const message = await Message.create({
        conversationId: conversation_id,
        senderId: userId,
        messageType: message_type,
        content,
        mediaUrl: media_url,
        mediaMetadata: media_metadata,
        clientMessageId: client_message_id
      });

      // Update conversation
      const preview = message_type === 'text'
        ? (content || '').substring(0, 100)
        : message_type === 'image' ? '[Image]' : '[Voice]';
      await Conversation.updateLastMessage(conversation_id, message.id, preview);

      // Get full message with sender info
      const fullMessage = await Message.getById(message.id);

      // Send to conversation room (all participants)
      io.to(`conversation:${conversation_id}`).emit('dm:new_message', fullMessage);

      // Also send to recipient's personal room (for badge updates even if not in conversation)
      if (otherUserId) {
        io.to(`user:${otherUserId}`).emit('dm:conversation_updated', {
          conversation_id,
          last_message: fullMessage
        });
      }

      // Acknowledge to sender with server-assigned ID
      if (ack) {
        ack({ message: fullMessage, client_message_id });
      } else {
        socket.emit('dm:message_sent', { message: fullMessage, client_message_id });
      }
    } catch (error) {
      console.error('[Socket] send_message error:', error.message);
      if (ack) ack({ error: 'Failed to send message' });
    }
  });

  // ==================== Typing Indicators ====================

  socket.on('dm:typing_start', async ({ conversation_id }) => {
    try {
      const isParticipant = await Conversation.isParticipant(conversation_id, userId);
      if (!isParticipant) return;

      socket.to(`conversation:${conversation_id}`).emit('dm:typing', {
        conversation_id,
        user_id: userId,
        is_typing: true
      });
    } catch (error) {
      console.error('[Socket] typing_start error:', error.message);
    }
  });

  socket.on('dm:typing_stop', async ({ conversation_id }) => {
    try {
      const isParticipant = await Conversation.isParticipant(conversation_id, userId);
      if (!isParticipant) return;

      socket.to(`conversation:${conversation_id}`).emit('dm:typing', {
        conversation_id,
        user_id: userId,
        is_typing: false
      });
    } catch (error) {
      console.error('[Socket] typing_stop error:', error.message);
    }
  });

  // ==================== Read Receipt ====================

  socket.on('dm:mark_read', async ({ conversation_id, message_id }) => {
    try {
      const isParticipant = await Conversation.isParticipant(conversation_id, userId);
      if (!isParticipant) return;

      await ReadReceipt.markRead(conversation_id, userId, message_id);

      // Notify the other user
      socket.to(`conversation:${conversation_id}`).emit('dm:read_receipt', {
        conversation_id,
        user_id: userId,
        last_read_message_id: message_id
      });
    } catch (error) {
      console.error('[Socket] mark_read error:', error.message);
    }
  });
};
