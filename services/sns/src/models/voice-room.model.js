const { query, getClient } = require('../config/database');
const { v4: uuidv4 } = require('uuid');

class VoiceRoom {
  /**
   * Create a new voice room
   */
  static async create({ creatorId, title, topic, languageLevel = 'all', maxSpeakers = 4 }) {
    const livekitRoomName = `lemon-voice-${uuidv4().substring(0, 8)}`;

    const sql = `
      INSERT INTO voice_rooms (creator_id, title, topic, language_level, max_speakers, livekit_room_name, created_at)
      VALUES ($1, $2, $3, $4, $5, $6, NOW())
      RETURNING *
    `;

    const result = await query(sql, [creatorId, title, topic, languageLevel, maxSpeakers, livekitRoomName]);
    return result.rows[0];
  }

  /**
   * Get a room by ID with creator details
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
   * Get active rooms with current participants (speakers + listeners)
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
              'is_muted', p.is_muted,
              'role', p.role
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
   * Get active participants for a room, separated by role
   */
  static async getParticipants(roomId) {
    const sql = `
      SELECT p.*, u.name, u.profile_image_url AS avatar
      FROM voice_room_participants p
      JOIN users u ON u.id = p.user_id
      WHERE p.room_id = $1 AND p.left_at IS NULL
      ORDER BY p.role ASC, p.joined_at
    `;

    const result = await query(sql, [roomId]);
    return result.rows;
  }

  /**
   * Get speakers for a room (with character data)
   */
  static async getSpeakers(roomId) {
    const sql = `
      SELECT p.user_id, p.is_muted, p.role, u.name, u.profile_image_url AS avatar,
        uc.equipped_items, uc.skin_color
      FROM voice_room_participants p
      JOIN users u ON u.id = p.user_id
      LEFT JOIN user_characters uc ON uc.user_id = p.user_id
      WHERE p.room_id = $1 AND p.left_at IS NULL AND p.role = 'speaker'
      ORDER BY p.joined_at
    `;

    const result = await query(sql, [roomId]);
    return result.rows;
  }

  /**
   * Get listeners for a room
   */
  static async getListeners(roomId) {
    const sql = `
      SELECT p.user_id, p.role, u.name, u.profile_image_url AS avatar
      FROM voice_room_participants p
      JOIN users u ON u.id = p.user_id
      WHERE p.room_id = $1 AND p.left_at IS NULL AND p.role = 'listener'
      ORDER BY p.joined_at
    `;

    const result = await query(sql, [roomId]);
    return result.rows;
  }

  /**
   * Join a room as listener (no capacity check - audience is unlimited)
   */
  static async join(roomId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      // Check room is active
      const room = await client.query(
        'SELECT * FROM voice_rooms WHERE id = $1 AND status = $2 FOR UPDATE',
        [roomId, 'active']
      );

      if (!room.rows[0]) {
        throw new Error('Room not found or closed');
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

      // Add as listener
      const participant = await client.query(
        "INSERT INTO voice_room_participants (room_id, user_id, role, joined_at) VALUES ($1, $2, 'listener', NOW()) RETURNING *",
        [roomId, userId]
      );

      // Update listener_count
      await client.query(
        'UPDATE voice_rooms SET listener_count = listener_count + 1 WHERE id = $1',
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
   * Join a room as speaker (creator auto-join, checks capacity)
   */
  static async joinAsSpeaker(roomId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const room = await client.query(
        'SELECT * FROM voice_rooms WHERE id = $1 AND status = $2 FOR UPDATE',
        [roomId, 'active']
      );

      if (!room.rows[0]) {
        throw new Error('Room not found or closed');
      }

      if (room.rows[0].speaker_count >= room.rows[0].max_speakers) {
        throw new Error('Stage is full');
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

      const participant = await client.query(
        "INSERT INTO voice_room_participants (room_id, user_id, role, joined_at) VALUES ($1, $2, 'speaker', NOW()) RETURNING *",
        [roomId, userId]
      );

      await client.query(
        'UPDATE voice_rooms SET speaker_count = speaker_count + 1 WHERE id = $1',
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
   * Leave a room (checks role to decrement correct counter)
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
        const role = result.rows[0].role;
        if (role === 'speaker') {
          await client.query(
            'UPDATE voice_rooms SET speaker_count = GREATEST(speaker_count - 1, 0) WHERE id = $1',
            [roomId]
          );
        } else {
          await client.query(
            'UPDATE voice_rooms SET listener_count = GREATEST(listener_count - 1, 0) WHERE id = $1',
            [roomId]
          );
        }

        // Auto-close if completely empty (no speakers and no listeners)
        const room = await client.query(
          'SELECT speaker_count, listener_count FROM voice_rooms WHERE id = $1',
          [roomId]
        );
        if (room.rows[0] && room.rows[0].speaker_count <= 0 && room.rows[0].listener_count <= 0) {
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
   * Promote listener to speaker
   */
  static async promoteToSpeaker(roomId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const room = await client.query(
        'SELECT * FROM voice_rooms WHERE id = $1 AND status = $2 FOR UPDATE',
        [roomId, 'active']
      );

      if (!room.rows[0]) {
        throw new Error('Room not found or closed');
      }

      if (room.rows[0].speaker_count >= room.rows[0].max_speakers) {
        throw new Error('Stage is full');
      }

      // Must be a current listener
      const participant = await client.query(
        "SELECT * FROM voice_room_participants WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL AND role = 'listener'",
        [roomId, userId]
      );

      if (!participant.rows[0]) {
        throw new Error('User is not a listener in this room');
      }

      await client.query(
        "UPDATE voice_room_participants SET role = 'speaker' WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL",
        [roomId, userId]
      );

      await client.query(
        'UPDATE voice_rooms SET speaker_count = speaker_count + 1, listener_count = GREATEST(listener_count - 1, 0) WHERE id = $1',
        [roomId]
      );

      await client.query('COMMIT');

      // Return character data for the promoted user
      const characterData = await query(
        'SELECT equipped_items, skin_color FROM user_characters WHERE user_id = $1',
        [userId]
      );

      return {
        user_id: userId,
        role: 'speaker',
        equipped_items: characterData.rows[0]?.equipped_items || null,
        skin_color: characterData.rows[0]?.skin_color || null
      };
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Demote speaker to listener (creator cannot be demoted)
   */
  static async demoteToListener(roomId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const room = await client.query(
        'SELECT * FROM voice_rooms WHERE id = $1 AND status = $2 FOR UPDATE',
        [roomId, 'active']
      );

      if (!room.rows[0]) {
        throw new Error('Room not found or closed');
      }

      // Creator cannot be demoted
      if (room.rows[0].creator_id === userId) {
        throw new Error('Cannot demote the room creator');
      }

      const participant = await client.query(
        "SELECT * FROM voice_room_participants WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL AND role = 'speaker'",
        [roomId, userId]
      );

      if (!participant.rows[0]) {
        throw new Error('User is not a speaker in this room');
      }

      await client.query(
        "UPDATE voice_room_participants SET role = 'listener' WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL",
        [roomId, userId]
      );

      await client.query(
        'UPDATE voice_rooms SET speaker_count = GREATEST(speaker_count - 1, 0), listener_count = listener_count + 1 WHERE id = $1',
        [roomId]
      );

      await client.query('COMMIT');
      return { user_id: userId, role: 'listener' };
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Request to join stage (raise hand)
   */
  static async requestStage(roomId, userId) {
    const sql = `
      INSERT INTO voice_room_stage_requests (room_id, user_id, status, created_at)
      VALUES ($1, $2, 'pending', NOW())
      ON CONFLICT (room_id, user_id) DO UPDATE SET status = 'pending', created_at = NOW(), resolved_at = NULL
      RETURNING *
    `;

    const result = await query(sql, [roomId, userId]);
    return result.rows[0];
  }

  /**
   * Cancel own stage request
   */
  static async cancelStageRequest(roomId, userId) {
    const sql = `
      UPDATE voice_room_stage_requests SET status = 'cancelled', resolved_at = NOW()
      WHERE room_id = $1 AND user_id = $2 AND status = 'pending'
      RETURNING *
    `;

    const result = await query(sql, [roomId, userId]);
    return result.rows[0] || null;
  }

  /**
   * Resolve a stage request (approve/deny)
   */
  static async resolveStageRequest(roomId, userId, status) {
    const sql = `
      UPDATE voice_room_stage_requests SET status = $3, resolved_at = NOW()
      WHERE room_id = $1 AND user_id = $2 AND status = 'pending'
      RETURNING *
    `;

    const result = await query(sql, [roomId, userId, status]);
    return result.rows[0] || null;
  }

  /**
   * Get pending stage requests for a room
   */
  static async getPendingRequests(roomId) {
    const sql = `
      SELECT sr.*, u.name, u.profile_image_url AS avatar
      FROM voice_room_stage_requests sr
      JOIN users u ON u.id = sr.user_id
      WHERE sr.room_id = $1 AND sr.status = 'pending'
      ORDER BY sr.created_at
    `;

    const result = await query(sql, [roomId]);
    return result.rows;
  }

  /**
   * Close a room (creator only) - also deletes ephemeral messages
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
        await client.query(
          'UPDATE voice_rooms SET speaker_count = 0, listener_count = 0 WHERE id = $1',
          [roomId]
        );

        // Delete ephemeral chat messages
        await client.query('DELETE FROM voice_room_messages WHERE room_id = $1', [roomId]);

        // Cancel pending stage requests
        await client.query(
          "UPDATE voice_room_stage_requests SET status = 'cancelled', resolved_at = NOW() WHERE room_id = $1 AND status = 'pending'",
          [roomId]
        );
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

  /**
   * Get participant role
   */
  static async getParticipantRole(roomId, userId) {
    const sql = `
      SELECT role FROM voice_room_participants
      WHERE room_id = $1 AND user_id = $2 AND left_at IS NULL
    `;

    const result = await query(sql, [roomId, userId]);
    return result.rows[0]?.role || null;
  }
}

module.exports = VoiceRoom;
