const { query } = require('../config/database');

class UserProfile {
  /**
   * Get user profile with is_following flag
   * @param {Number} userId - Target user ID
   * @param {Number} requesterId - Requesting user ID (optional)
   * @returns {Object|null} User profile or null
   */
  static async getProfile(userId, requesterId) {
    let isFollowingClause = 'false AS is_following';

    const params = [userId];

    if (requesterId) {
      isFollowingClause = `EXISTS(
        SELECT 1 FROM user_follows
        WHERE follower_id = $2 AND following_id = $1
      ) AS is_following`;
      params.push(requesterId);
    }

    const sql = `
      SELECT u.id,
             u.name,
             u.email,
             u.profile_image_url,
             u.bio,
             u.language_preference,
             u.follower_count,
             u.following_count,
             u.post_count,
             u.created_at,
             ${isFollowingClause}
      FROM users u
      WHERE u.id = $1 AND u.is_active = true
    `;

    const result = await query(sql, params);
    return result.rows[0] || null;
  }

  /**
   * Update user profile bio
   * @param {Number} userId - User ID
   * @param {Object} updates - Fields to update
   * @returns {Object} Updated profile
   */
  static async updateProfile(userId, { bio }) {
    const sql = `
      UPDATE users
      SET bio = $2, updated_at = NOW()
      WHERE id = $1
      RETURNING id, name, email, profile_image_url, bio, language_preference,
                follower_count, following_count, post_count, created_at
    `;

    const result = await query(sql, [userId, bio]);
    return result.rows[0] || null;
  }

  /**
   * Search users by name
   * @param {String} searchQuery - Search query string
   * @param {Object} options - Search options
   * @returns {Array} Users array
   */
  static async search(searchQuery, { limit = 20 }) {
    const sql = `
      SELECT id, name, email, profile_image_url, bio,
             follower_count, following_count, post_count
      FROM users
      WHERE name ILIKE $1
        AND is_active = true
      ORDER BY follower_count DESC
      LIMIT $2
    `;

    const result = await query(sql, [`%${searchQuery}%`, limit]);
    return result.rows;
  }

  /**
   * Get suggested users to follow
   * Users not yet followed, ordered by popularity
   * @param {Number} userId - Current user ID
   * @param {Object} options - Options
   * @returns {Array} Suggested users array
   */
  static async getSuggested(userId, { limit = 10 }) {
    const sql = `
      SELECT u.id, u.name, u.email, u.profile_image_url, u.bio,
             u.follower_count, u.following_count, u.post_count
      FROM users u
      WHERE u.id != $1
        AND u.is_active = true
        AND u.id NOT IN (SELECT following_id FROM user_follows WHERE follower_id = $1)
        AND u.id NOT IN (SELECT blocked_id FROM user_blocks WHERE blocker_id = $1)
      ORDER BY u.follower_count DESC
      LIMIT $2
    `;

    const result = await query(sql, [userId, limit]);
    return result.rows;
  }
}

module.exports = UserProfile;
