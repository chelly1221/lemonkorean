const { query, getClient } = require('../config/database');
const { v4: uuidv4 } = require('uuid');

class VoiceRoom {
  /**
   * Create a new voice room
   */
  static async create({ creatorId, title, topic, languageLevel = 'all', maxParticipants = 4 }) {
    const livekitRoomName = `lemon-voice-${uuidv4().substring(0, 8)}`;

    const sql = `
      INSERT INTO voice_rooms (creator_id, title, topic, language_level, max_participants, livekit_room_name, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, NOW())
      RETURNING *
    `;

    const result = await query(sql, [creatorId, title, topic, languageLevel, maxParticipants, livekitRoomName]);
    return result.rows[0];
  }

  /**
   * Get a room by ID with participant details
   */
  static async getById(roomId) {
    const sql = `
      SELECT r.*,
        u.name AS creator_name,
        u.profile_image_url AS creator_avatar
      FROM voice_rooms r
      JOIN users u ON u.id = r.creator_id
      WHERE r.id = $1
    `;

    const result = await query(sql, [roomId]);
    return result.rows[0] || null;
  }

  /**
   * Get active rooms with current participants
   */
  static async getActiveRooms({ limit = 20, offset = 0 } = {}) {
    const sql = `
      SELECT r.*,
        u.name AS creator_name,
        u.profile_image_url AS creator_avatar,
        COALESCE(
          json_agg(
            json_build_object(
              'user_id', p.user_id,
              'name', pu.name,
              'avatar', pu.profile_image_url,
              'is_muted', p.is_muted
            )
          ) FILTER (WHERE p.user_id IS NOT NULL), '[]'
        ) AS participants
      FROM voice_rooms r
      JOIN users u ON u.id = r.creator_id
      LEFT JOIN voice_room_participants p ON p.room_id = r.id AND p.left_at IS NULL
      LEFT JOIN users pu ON pu.id = p.user_id
      WHERE r.status = 'active'
      GROUP BY r.id, u.name, u.profile_image_url
      ORDER BY r.created_at DESC
      LIMIT $1 OFFSET $2
    `;

    const result = await query(sql, [limit, offset]);
    return result.rows;
  }

  /**
   * Get active participants for a room
   */
  static async getParticipants(roomId) {
    const sql = `
      SELECT p.*, u.name, u.profile_image_url AS avatar
      FROM voice_room_participants p
      JOIN users u ON u.id = p.user_id
      WHERE p.room_id = $1 AND p.left_at IS NULL
      ORDER BY p.joined_at
    `;

    const result = await query(sql, [roomId]);
    return result.rows;
  }

  /**
   * Join a room (returns participant record)
   */
  static async join(roomId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      // Check room is active and not full
      const room = await client.query(
        'SELECT * FROM voice_rooms WHERE id = $1 AND status = $2 FOR UPDATE',
        [roomId, 'active']
      );

      if (!room.rows[0]) {
        throw new Error('Room not found or closed');
      }

      if (room.rows[0].participant_count >= room.rows[0].max_participants) {
        throw new Error('Room is full');
      }

      // Check if already in room
      const existing = await client.query(
        'SELECT * FROM voice_room_participants WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL',
        [roomId, userId]
      );

      if (existing.rows[0]) {
        await client.query('COMMIT');
        return existing.rows[0];
      }

      // Add participant
      const participant = await client.query(
        'INSERT INTO voice_room_participants (room_id, user_id, joined_at) VALUES ($1, $2, NOW()) RETURNING *',
        [roomId, userId]
      );

      // Update count
      await client.query(
        'UPDATE voice_rooms SET participant_count = participant_count + 1 WHERE id = $1',
        [roomId]
      );

      await client.query('COMMIT');
      return participant.rows[0];
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Leave a room
   */
  static async leave(roomId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const result = await client.query(
        'UPDATE voice_room_participants SET left_at = NOW() WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL RETURNING *',
        [roomId, userId]
      );

      if (result.rows[0]) {
        await client.query(
          'UPDATE voice_rooms SET participant_count = GREATEST(participant_count - 1, 0) WHERE id = $1',
          [roomId]
        );

        // Auto-close if empty
        const room = await client.query('SELECT participant_count FROM voice_rooms WHERE id = $1', [roomId]);
        if (room.rows[0] && room.rows[0].participant_count <= 0) {
          await client.query(
            "UPDATE voice_rooms SET status = 'closed', closed_at = NOW() WHERE id = $1",
            [roomId]
          );
        }
      }

      await client.query('COMMIT');
      return result.rows[0] || null;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Close a room (creator only)
   */
  static async close(roomId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      // Mark room as closed
      const result = await client.query(
        "UPDATE voice_rooms SET status = 'closed', closed_at = NOW() WHERE id = $1 AND creator_id = $2 AND status = 'active' RETURNING *",
        [roomId, userId]
      );

      if (result.rows[0]) {
        // Remove all participants
        await client.query(
          'UPDATE voice_room_participants SET left_at = NOW() WHERE room_id = $1 AND left_at IS NULL',
          [roomId]
        );
        await client.query('UPDATE voice_rooms SET participant_count = 0 WHERE id = $1', [roomId]);
      }

      await client.query('COMMIT');
      return result.rows[0] || null;
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Toggle mute status
   */
  static async toggleMute(roomId, userId) {
    const sql = `
      UPDATE voice_room_participants
      SET is_muted = NOT is_muted
      WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL
      RETURNING *
    `;

    const result = await query(sql, [roomId, userId]);
    return result.rows[0] || null;
  }

  /**
   * Check if user is participant
   */
  static async isParticipant(roomId, userId) {
    const sql = `
      SELECT EXISTS(
        SELECT 1 FROM voice_room_participants
        WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL
      ) AS is_participant
    `;

    const result = await query(sql, [roomId, userId]);
    return result.rows[0].is_participant;
  }
}

module.exports = VoiceRoom;
