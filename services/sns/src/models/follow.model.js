const { query, getClient } = require('../config/database');

class Follow {
  /**
   * Follow a user
   * @param {Number} followerId - Follower user ID
   * @param {Number} followingId - User being followed ID
   * @returns {Object} Follow record
   */
  static async follow(followerId, followingId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      // Insert follow relationship (ignore if already exists)
      const sql = `
        INSERT INTO user_follows (follower_id, following_id, created_at)
        VALUES ($1, $2, NOW())
        ON CONFLICT (follower_id, following_id) DO NOTHING
        RETURNING *
      `;

      const result = await client.query(sql, [followerId, followingId]);

      if (result.rows[0]) {
        // Increment follower count for the followed user
        await client.query(
          'UPDATE users SET follower_count = COALESCE(follower_count, 0) + 1 WHERE id = $1',
          [followingId]
        );

        // Increment following count for the follower
        await client.query(
          'UPDATE users SET following_count = COALESCE(following_count, 0) + 1 WHERE id = $1',
          [followerId]
        );
      }

      await client.query('COMMIT');

      console.log(`[SNS] User ${followerId} followed user ${followingId}`);
      return result.rows[0] || null;
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('[SNS] Follow error:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Unfollow a user
   * @param {Number} followerId - Follower user ID
   * @param {Number} followingId - User being unfollowed ID
   * @returns {Object|null} Deleted follow record or null
   */
  static async unfollow(followerId, followingId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const sql = `
        DELETE FROM user_follows
        WHERE follower_id = $1 AND following_id = $2
        RETURNING *
      `;

      const result = await client.query(sql, [followerId, followingId]);

      if (result.rows[0]) {
        // Decrement follower count for the unfollowed user
        await client.query(
          'UPDATE users SET follower_count = GREATEST(COALESCE(follower_count, 0) - 1, 0) WHERE id = $1',
          [followingId]
        );

        // Decrement following count for the unfollower
        await client.query(
          'UPDATE users SET following_count = GREATEST(COALESCE(following_count, 0) - 1, 0) WHERE id = $1',
          [followerId]
        );
      }

      await client.query('COMMIT');

      console.log(`[SNS] User ${followerId} unfollowed user ${followingId}`);
      return result.rows[0] || null;
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('[SNS] Unfollow error:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Check if a user is following another user
   * @param {Number} followerId - Follower user ID
   * @param {Number} followingId - User being checked ID
   * @returns {Boolean} True if following
   */
  static async isFollowing(followerId, followingId) {
    const sql = `
      SELECT EXISTS(
        SELECT 1 FROM user_follows
        WHERE follower_id = $1 AND following_id = $2
      ) AS is_following
    `;

    const result = await query(sql, [followerId, followingId]);
    return result.rows[0].is_following;
  }

  /**
   * Get followers of a user
   * Cursor-based pagination
   * @param {Number} userId - User ID
   * @param {Object} options - Pagination options
   * @returns {Array} Followers array with user info
   */
  static async getFollowers(userId, { cursor, limit = 20 }) {
    const params = [userId, limit];
    let cursorClause = '';

    if (cursor) {
      cursorClause = 'AND uf.id < $3';
      params.push(cursor);
    }

    const sql = `
      SELECT uf.id AS follow_id,
             uf.created_at AS followed_at,
             u.id,
             u.name,
             u.email,
             u.profile_image_url,
             u.follower_count,
             u.following_count
      FROM user_follows uf
      JOIN users u ON uf.follower_id = u.id
      WHERE uf.following_id = $1
        ${cursorClause}
      ORDER BY uf.id DESC
      LIMIT $2
    `;

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Get users that a user is following
   * Cursor-based pagination
   * @param {Number} userId - User ID
   * @param {Object} options - Pagination options
   * @returns {Array} Following array with user info
   */
  static async getFollowing(userId, { cursor, limit = 20 }) {
    const params = [userId, limit];
    let cursorClause = '';

    if (cursor) {
      cursorClause = 'AND uf.id < $3';
      params.push(cursor);
    }

    const sql = `
      SELECT uf.id AS follow_id,
             uf.created_at AS followed_at,
             u.id,
             u.name,
             u.email,
             u.profile_image_url,
             u.follower_count,
             u.following_count
      FROM user_follows uf
      JOIN users u ON uf.following_id = u.id
      WHERE uf.follower_id = $1
        ${cursorClause}
      ORDER BY uf.id DESC
      LIMIT $2
    `;

    const result = await query(sql, params);
    return result.rows;
  }
}

module.exports = Follow;
