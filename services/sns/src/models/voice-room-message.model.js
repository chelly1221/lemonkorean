const { query } = require('../config/database');

class VoiceRoomMessage {
  /**
   * Create a new message
   */
  static async create({ roomId, userId, content, messageType = 'text' }) {
    const sql = `
      INSERT INTO voice_room_messages (room_id, user_id, content, message_type, created_at)
      VALUES ($1, $2, $3, $4, NOW())
      RETURNING *
    `;

    const result = await query(sql, [roomId, userId, content, messageType]);
    return result.rows[0];
  }

  /**
   * Get messages for a room (cursor-based pagination)
   */
  static async getByRoom(roomId, { limit = 50, before } = {}) {
    let sql;
    let params;

    if (before) {
      sql = `
        SELECT m.*, u.name, u.profile_image_url AS avatar
        FROM voice_room_messages m
        JOIN users u ON u.id = m.user_id
        WHERE m.room_id = $1 AND m.id < $2
        ORDER BY m.created_at DESC
        LIMIT $3
      `;
      params = [roomId, before, limit];
    } else {
      sql = `
        SELECT m.*, u.name, u.profile_image_url AS avatar
        FROM voice_room_messages m
        JOIN users u ON u.id = m.user_id
        WHERE m.room_id = $1
        ORDER BY m.created_at DESC
        LIMIT $2
      `;
      params = [roomId, limit];
    }

    const result = await query(sql, params);
    return result.rows.reverse(); // Return in chronological order
  }

  /**
   * Delete all messages for a room (called when room closes)
   */
  static async deleteByRoom(roomId) {
    const sql = 'DELETE FROM voice_room_messages WHERE room_id = $1';
    await query(sql, [roomId]);
  }
}

module.exports = VoiceRoomMessage;
