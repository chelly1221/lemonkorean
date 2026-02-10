const { query } = require('../config/database');

class Message {
  /**
   * Create a new message
   */
  static async create({ conversationId, senderId, messageType = 'text', content, mediaUrl, mediaMetadata, clientMessageId }) {
    // Check for duplicate via client_message_id
    if (clientMessageId) {
      const existing = await query(
        'SELECT * FROM dm_messages WHERE client_message_id = $1',
        [clientMessageId]
      );
      if (existing.rows[0]) return existing.rows[0];
    }

    const sql = `
      INSERT INTO dm_messages (conversation_id, sender_id, message_type, content, media_url, media_metadata, client_message_id, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, $7, NOW())
      RETURNING *
    `;

    const result = await query(sql, [
      conversationId,
      senderId,
      messageType,
      content || null,
      mediaUrl || null,
      mediaMetadata ? JSON.stringify(mediaMetadata) : '{}',
      clientMessageId || null
    ]);

    return result.rows[0];
  }

  /**
   * Get messages for a conversation with cursor-based pagination
   * Returns messages in reverse chronological order (newest first)
   */
  static async getByConversation(conversationId, { cursor, limit = 30 } = {}) {
    let sql;
    let params;

    if (cursor) {
      sql = `
        SELECT m.*,
          u.name AS sender_name,
          u.profile_image_url AS sender_avatar
        FROM dm_messages m
        JOIN users u ON u.id = m.sender_id
        WHERE m.conversation_id = $1
          AND m.id < $2
        ORDER BY m.created_at DESC
        LIMIT $3
      `;
      params = [conversationId, cursor, limit];
    } else {
      sql = `
        SELECT m.*,
          u.name AS sender_name,
          u.profile_image_url AS sender_avatar
        FROM dm_messages m
        JOIN users u ON u.id = m.sender_id
        WHERE m.conversation_id = $1
        ORDER BY m.created_at DESC
        LIMIT $2
      `;
      params = [conversationId, limit];
    }

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Get a single message by ID
   */
  static async getById(messageId) {
    const sql = `
      SELECT m.*,
        u.name AS sender_name,
        u.profile_image_url AS sender_avatar
      FROM dm_messages m
      JOIN users u ON u.id = m.sender_id
      WHERE m.id = $1
    `;

    const result = await query(sql, [messageId]);
    return result.rows[0] || null;
  }

  /**
   * Soft-delete a message (only by sender)
   */
  static async softDelete(messageId, userId) {
    const sql = `
      UPDATE dm_messages
      SET is_deleted = true, content = NULL, media_url = NULL
      WHERE id = $1 AND sender_id = $2
      RETURNING *
    `;

    const result = await query(sql, [messageId, userId]);
    return result.rows[0] || null;
  }
}

module.exports = Message;
