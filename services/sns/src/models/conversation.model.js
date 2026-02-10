const { query, getClient } = require('../config/database');

class Conversation {
  /**
   * Find or create a conversation between two users
   * Normalizes user IDs so user1_id < user2_id
   */
  static async findOrCreate(userA, userB) {
    const user1 = Math.min(userA, userB);
    const user2 = Math.max(userA, userB);

    const sql = `
      INSERT INTO dm_conversations (user1_id, user2_id, created_at)
      VALUES ($1, $2, NOW())
      ON CONFLICT (user1_id, user2_id) DO UPDATE SET user1_id = dm_conversations.user1_id
      RETURNING *
    `;

    const result = await query(sql, [user1, user2]);
    return result.rows[0];
  }

  /**
   * Get conversation by ID with participant info
   */
  static async getById(conversationId, userId) {
    const sql = `
      SELECT c.*,
        u_other.id AS other_user_id,
        u_other.name AS other_user_name,
        u_other.profile_image_url AS other_user_avatar
      FROM dm_conversations c
      JOIN users u_other ON u_other.id = CASE
        WHEN c.user1_id = $2 THEN c.user2_id
        ELSE c.user1_id
      END
      WHERE c.id = $1
        AND (c.user1_id = $2 OR c.user2_id = $2)
    `;

    const result = await query(sql, [conversationId, userId]);
    return result.rows[0] || null;
  }

  /**
   * Get all conversations for a user with unread counts
   * Excludes conversations with blocked users
   */
  static async getListForUser(userId, { limit = 20, offset = 0 } = {}) {
    const sql = `
      SELECT
        c.id,
        c.last_message_at,
        c.last_message_preview,
        c.created_at,
        u_other.id AS other_user_id,
        u_other.name AS other_user_name,
        u_other.profile_image_url AS other_user_avatar,
        COALESCE(
          (SELECT m.id FROM dm_messages m
           WHERE m.conversation_id = c.id
           ORDER BY m.created_at DESC LIMIT 1), 0
        ) AS latest_message_id,
        COALESCE(
          (SELECT m.message_type FROM dm_messages m
           WHERE m.conversation_id = c.id AND m.is_deleted = false
           ORDER BY m.created_at DESC LIMIT 1), 'text'
        ) AS last_message_type,
        COALESCE(
          (SELECT m.sender_id FROM dm_messages m
           WHERE m.conversation_id = c.id AND m.is_deleted = false
           ORDER BY m.created_at DESC LIMIT 1), 0
        ) AS last_message_sender_id,
        COALESCE(
          (SELECT COUNT(*)::int FROM dm_messages m
           WHERE m.conversation_id = c.id
             AND m.sender_id != $1
             AND m.is_deleted = false
             AND m.id > COALESCE(
               (SELECT rr.last_read_message_id FROM dm_read_receipts rr
                WHERE rr.conversation_id = c.id AND rr.user_id = $1), 0
             )
          ), 0
        ) AS unread_count
      FROM dm_conversations c
      JOIN users u_other ON u_other.id = CASE
        WHEN c.user1_id = $1 THEN c.user2_id
        ELSE c.user1_id
      END
      WHERE (c.user1_id = $1 OR c.user2_id = $1)
        AND c.last_message_at IS NOT NULL
        AND NOT EXISTS (
          SELECT 1 FROM user_blocks ub
          WHERE (ub.blocker_id = $1 AND ub.blocked_id = u_other.id)
             OR (ub.blocker_id = u_other.id AND ub.blocked_id = $1)
        )
      ORDER BY c.last_message_at DESC NULLS LAST
      LIMIT $2 OFFSET $3
    `;

    const result = await query(sql, [userId, limit, offset]);
    return result.rows;
  }

  /**
   * Get total unread message count across all conversations
   */
  static async getTotalUnreadCount(userId) {
    const sql = `
      SELECT COALESCE(SUM(unread), 0)::int AS total_unread
      FROM (
        SELECT
          (SELECT COUNT(*)::int FROM dm_messages m
           WHERE m.conversation_id = c.id
             AND m.sender_id != $1
             AND m.is_deleted = false
             AND m.id > COALESCE(
               (SELECT rr.last_read_message_id FROM dm_read_receipts rr
                WHERE rr.conversation_id = c.id AND rr.user_id = $1), 0
             )
          ) AS unread
        FROM dm_conversations c
        WHERE (c.user1_id = $1 OR c.user2_id = $1)
          AND c.last_message_at IS NOT NULL
      ) sub
    `;

    const result = await query(sql, [userId]);
    return result.rows[0].total_unread;
  }

  /**
   * Update last message info on conversation
   */
  static async updateLastMessage(conversationId, messageId, preview) {
    const sql = `
      UPDATE dm_conversations
      SET last_message_id = $2,
          last_message_at = NOW(),
          last_message_preview = $3
      WHERE id = $1
    `;

    await query(sql, [conversationId, messageId, preview]);
  }

  /**
   * Check if user is participant of conversation
   */
  static async isParticipant(conversationId, userId) {
    const sql = `
      SELECT EXISTS(
        SELECT 1 FROM dm_conversations
        WHERE id = $1 AND (user1_id = $2 OR user2_id = $2)
      ) AS is_participant
    `;

    const result = await query(sql, [conversationId, userId]);
    return result.rows[0].is_participant;
  }

  /**
   * Get the other user's ID from a conversation
   */
  static async getOtherUserId(conversationId, userId) {
    const sql = `
      SELECT CASE
        WHEN user1_id = $2 THEN user2_id
        ELSE user1_id
      END AS other_user_id
      FROM dm_conversations
      WHERE id = $1
    `;

    const result = await query(sql, [conversationId, userId]);
    return result.rows[0]?.other_user_id || null;
  }
}

module.exports = Conversation;
