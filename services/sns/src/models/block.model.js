const { query, getClient } = require('../config/database');

class Block {
  /**
   * Block a user
   * Also auto-unfollows in both directions
   * @param {Number} blockerId - Blocker user ID
   * @param {Number} blockedId - User being blocked ID
   * @returns {Object} Block record
   */
  static async block(blockerId, blockedId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      // Insert block relationship (ignore if already exists)
      const sql = `
        INSERT INTO user_blocks (blocker_id, blocked_id, created_at)
        VALUES ($1, $2, NOW())
        ON CONFLICT (blocker_id, blocked_id) DO NOTHING
        RETURNING *
      `;

      const result = await client.query(sql, [blockerId, blockedId]);

      if (result.rows[0]) {
        // Auto-unfollow: blocker unfollows blocked
        const unfollow1 = await client.query(
          'DELETE FROM user_follows WHERE follower_id = $1 AND following_id = $2 RETURNING *',
          [blockerId, blockedId]
        );
        if (unfollow1.rows[0]) {
          await client.query(
            'UPDATE users SET following_count = GREATEST(COALESCE(following_count, 0) - 1, 0) WHERE id = $1',
            [blockerId]
          );
          await client.query(
            'UPDATE users SET follower_count = GREATEST(COALESCE(follower_count, 0) - 1, 0) WHERE id = $1',
            [blockedId]
          );
        }

        // Auto-unfollow: blocked unfollows blocker
        const unfollow2 = await client.query(
          'DELETE FROM user_follows WHERE follower_id = $1 AND following_id = $2 RETURNING *',
          [blockedId, blockerId]
        );
        if (unfollow2.rows[0]) {
          await client.query(
            'UPDATE users SET following_count = GREATEST(COALESCE(following_count, 0) - 1, 0) WHERE id = $1',
            [blockedId]
          );
          await client.query(
            'UPDATE users SET follower_count = GREATEST(COALESCE(follower_count, 0) - 1, 0) WHERE id = $1',
            [blockerId]
          );
        }
      }

      await client.query('COMMIT');

      console.log(`[SNS] User ${blockerId} blocked user ${blockedId}`);
      return result.rows[0] || null;
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('[SNS] Block error:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Unblock a user
   * @param {Number} blockerId - Blocker user ID
   * @param {Number} blockedId - User being unblocked ID
   * @returns {Object|null} Deleted block record or null
   */
  static async unblock(blockerId, blockedId) {
    const sql = `
      DELETE FROM user_blocks
      WHERE blocker_id = $1 AND blocked_id = $2
      RETURNING *
    `;

    const result = await query(sql, [blockerId, blockedId]);

    if (result.rows[0]) {
      console.log(`[SNS] User ${blockerId} unblocked user ${blockedId}`);
    }

    return result.rows[0] || null;
  }

  /**
   * Check if a user is blocked
   * @param {Number} blockerId - Blocker user ID
   * @param {Number} blockedId - User being checked ID
   * @returns {Boolean} True if blocked
   */
  static async isBlocked(blockerId, blockedId) {
    const sql = `
      SELECT EXISTS(
        SELECT 1 FROM user_blocks
        WHERE blocker_id = $1 AND blocked_id = $2
      ) AS is_blocked
    `;

    const result = await query(sql, [blockerId, blockedId]);
    return result.rows[0].is_blocked;
  }

  /**
   * Check if either user has blocked the other (bidirectional)
   * @param {Number} userA - First user ID
   * @param {Number} userB - Second user ID
   * @returns {Boolean} True if either direction is blocked
   */
  static async isBlockedEitherWay(userA, userB) {
    const sql = `
      SELECT EXISTS(
        SELECT 1 FROM user_blocks
        WHERE (blocker_id = $1 AND blocked_id = $2)
           OR (blocker_id = $2 AND blocked_id = $1)
      ) AS is_blocked
    `;

    const result = await query(sql, [userA, userB]);
    return result.rows[0].is_blocked;
  }

  /**
   * Get all blocked user IDs for a user
   * @param {Number} userId - User ID
   * @returns {Array<Number>} Array of blocked user IDs
   */
  static async getBlockedIds(userId) {
    const sql = `
      SELECT blocked_id FROM user_blocks
      WHERE blocker_id = $1
    `;

    const result = await query(sql, [userId]);
    return result.rows.map(row => row.blocked_id);
  }
}

module.exports = Block;
