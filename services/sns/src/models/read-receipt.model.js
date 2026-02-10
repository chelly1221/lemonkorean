const { query } = require('../config/database');

class ReadReceipt {
  /**
   * Mark messages as read up to a specific message ID
   */
  static async markRead(conversationId, userId, messageId) {
    const sql = `
      INSERT INTO dm_read_receipts (conversation_id, user_id, last_read_message_id, last_read_at)
      VALUES ($1, $2, $3, NOW())
      ON CONFLICT (conversation_id, user_id)
      DO UPDATE SET
        last_read_message_id = GREATEST(dm_read_receipts.last_read_message_id, $3),
        last_read_at = NOW()
      RETURNING *
    `;

    const result = await query(sql, [conversationId, userId, messageId]);
    return result.rows[0];
  }

  /**
   * Get last read message ID for a user in a conversation
   */
  static async getLastRead(conversationId, userId) {
    const sql = `
      SELECT last_read_message_id, last_read_at
      FROM dm_read_receipts
      WHERE conversation_id = $1 AND user_id = $2
    `;

    const result = await query(sql, [conversationId, userId]);
    return result.rows[0] || { last_read_message_id: 0, last_read_at: null };
  }
}

module.exports = ReadReceipt;
