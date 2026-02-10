const Conversation = require('../models/conversation.model');
const Block = require('../models/block.model');
const ReadReceipt = require('../models/read-receipt.model');

/**
 * Get conversation list for authenticated user
 */
const getConversations = async (req, res) => {
  try {
    const userId = req.user.id;
    const limit = Math.min(parseInt(req.query.limit) || 20, 50);
    const offset = parseInt(req.query.offset) || 0;

    const conversations = await Conversation.getListForUser(userId, { limit, offset });

    res.json({
      conversations,
      pagination: { limit, offset, count: conversations.length }
    });
  } catch (error) {
    console.error('[SNS] getConversations error:', error);
    res.status(500).json({ error: 'Failed to load conversations' });
  }
};

/**
 * Create or get existing conversation with another user
 */
const createConversation = async (req, res) => {
  try {
    const userId = req.user.id;
    const { user_id: otherUserId } = req.body;

    if (!otherUserId) {
      return res.status(400).json({ error: 'user_id is required' });
    }

    if (parseInt(otherUserId) === userId) {
      return res.status(400).json({ error: 'Cannot create conversation with yourself' });
    }

    // Check block status
    const blocked = await Block.isBlockedEitherWay(userId, otherUserId);
    if (blocked) {
      return res.status(403).json({ error: 'Cannot message this user' });
    }

    const conversation = await Conversation.findOrCreate(userId, otherUserId);
    const fullConversation = await Conversation.getById(conversation.id, userId);

    res.status(201).json({ conversation: fullConversation });
  } catch (error) {
    console.error('[SNS] createConversation error:', error);
    res.status(500).json({ error: 'Failed to create conversation' });
  }
};

/**
 * Mark conversation as read
 */
const markRead = async (req, res) => {
  try {
    const userId = req.user.id;
    const conversationId = parseInt(req.params.id);
    const { message_id: messageId } = req.body;

    // Verify participation
    const isParticipant = await Conversation.isParticipant(conversationId, userId);
    if (!isParticipant) {
      return res.status(403).json({ error: 'Not a participant' });
    }

    if (!messageId) {
      return res.status(400).json({ error: 'message_id is required' });
    }

    const receipt = await ReadReceipt.markRead(conversationId, userId, messageId);

    res.json({ read_receipt: receipt });
  } catch (error) {
    console.error('[SNS] markRead error:', error);
    res.status(500).json({ error: 'Failed to mark as read' });
  }
};

/**
 * Get total unread count across all conversations
 */
const getUnreadCount = async (req, res) => {
  try {
    const userId = req.user.id;
    const count = await Conversation.getTotalUnreadCount(userId);

    res.json({ unread_count: count });
  } catch (error) {
    console.error('[SNS] getUnreadCount error:', error);
    res.status(500).json({ error: 'Failed to get unread count' });
  }
};

module.exports = {
  getConversations,
  createConversation,
  markRead,
  getUnreadCount
};
