const { query, getClient } = require('../config/database');

class Post {
  /**
   * Create a new post
   * @param {Number} userId - Author user ID
   * @param {Object} postData - Post data
   * @returns {Object} Created post
   */
  static async create(userId, { content, category, tags, visibility, imageUrls }) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const sql = `
        INSERT INTO sns_posts (user_id, content, category, tags, visibility, image_urls, created_at)
        VALUES ($1, $2, $3, $4, $5, $6, NOW())
        RETURNING *
      `;

      const values = [
        userId,
        content,
        category || 'general',
        tags || [],
        visibility || 'public',
        imageUrls || []
      ];

      const result = await client.query(sql, values);

      // Increment user post_count
      await client.query(
        'UPDATE users SET post_count = COALESCE(post_count, 0) + 1 WHERE id = $1',
        [userId]
      );

      await client.query('COMMIT');

      console.log(`[SNS] Post created: ${result.rows[0].id} by user ${userId}`);
      return result.rows[0];
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('[SNS] Create post error:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Find post by ID with author info
   * @param {Number} id - Post ID
   * @returns {Object|null} Post object or null
   */
  static async findById(id) {
    const sql = `
      SELECT p.*,
             u.name AS author_name,
             u.profile_image_url AS author_image
      FROM sns_posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.id = $1 AND p.is_deleted = false
    `;

    const result = await query(sql, [id]);
    return result.rows[0] || null;
  }

  /**
   * Get feed - posts from followed users
   * Cursor-based pagination using created_at
   * @param {Number} userId - Current user ID
   * @param {Object} options - Pagination options
   * @returns {Array} Posts array
   */
  static async getFeed(userId, { cursor, limit = 20 }) {
    const params = [userId, userId, limit];
    let cursorClause = '';

    if (cursor) {
      cursorClause = 'AND p.created_at < $4';
      params.push(cursor);
    }

    const sql = `
      SELECT p.*,
             u.name AS author_name,
             u.profile_image_url AS author_image,
             EXISTS(SELECT 1 FROM post_likes WHERE post_id = p.id AND user_id = $1) AS is_liked
      FROM sns_posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.is_deleted = false
        AND (
          p.user_id IN (SELECT following_id FROM user_follows WHERE follower_id = $1)
          OR p.user_id = $1
        )
        AND p.user_id NOT IN (SELECT blocked_id FROM user_blocks WHERE blocker_id = $2)
        ${cursorClause}
      ORDER BY p.created_at DESC
      LIMIT $3
    `;

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Get discover - public posts for discovery
   * Excludes blocked users
   * @param {Object} options - Filter and pagination options
   * @returns {Array} Posts array
   */
  static async getDiscover({ cursor, limit = 20, category, userId }) {
    const params = [limit];
    let paramIndex = 2;
    let cursorClause = '';
    let categoryClause = '';
    let blockClause = '';
    let likedClause = 'false AS is_liked';

    if (userId) {
      blockClause = `AND p.user_id NOT IN (SELECT blocked_id FROM user_blocks WHERE blocker_id = $${paramIndex})`;
      params.push(userId);
      paramIndex++;

      likedClause = `EXISTS(SELECT 1 FROM post_likes WHERE post_id = p.id AND user_id = $${paramIndex}) AS is_liked`;
      params.push(userId);
      paramIndex++;
    }

    if (category) {
      categoryClause = `AND p.category = $${paramIndex}`;
      params.push(category);
      paramIndex++;
    }

    if (cursor) {
      cursorClause = `AND p.created_at < $${paramIndex}`;
      params.push(cursor);
      paramIndex++;
    }

    const sql = `
      SELECT p.*,
             u.name AS author_name,
             u.profile_image_url AS author_image,
             ${likedClause}
      FROM sns_posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.is_deleted = false
        AND p.visibility = 'public'
        ${blockClause}
        ${categoryClause}
        ${cursorClause}
      ORDER BY p.created_at DESC
      LIMIT $1
    `;

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Get posts by a specific user
   * Respects visibility if requester is not following
   * @param {Number} targetUserId - Target user ID
   * @param {Object} options - Pagination options
   * @returns {Array} Posts array
   */
  static async getByUser(targetUserId, { cursor, limit = 20, requesterId }) {
    const params = [targetUserId, limit];
    let paramIndex = 3;
    let cursorClause = '';
    let visibilityClause = "AND p.visibility = 'public'";
    let likedClause = 'false AS is_liked';

    if (requesterId) {
      // If requester is the owner, show all posts
      if (requesterId === targetUserId) {
        visibilityClause = '';
      } else {
        // Check if requester follows the target user - show followers_only posts too
        visibilityClause = `AND (
          p.visibility = 'public'
          OR (p.visibility = 'followers' AND EXISTS(
            SELECT 1 FROM user_follows WHERE follower_id = $${paramIndex} AND following_id = $1
          ))
        )`;
        params.push(requesterId);
        paramIndex++;
      }

      likedClause = `EXISTS(SELECT 1 FROM post_likes WHERE post_id = p.id AND user_id = $${paramIndex}) AS is_liked`;
      params.push(requesterId === targetUserId ? targetUserId : requesterId);
      paramIndex++;
    }

    if (cursor) {
      cursorClause = `AND p.created_at < $${paramIndex}`;
      params.push(cursor);
      paramIndex++;
    }

    const sql = `
      SELECT p.*,
             u.name AS author_name,
             u.profile_image_url AS author_image,
             ${likedClause}
      FROM sns_posts p
      JOIN users u ON p.user_id = u.id
      WHERE p.user_id = $1
        AND p.is_deleted = false
        ${visibilityClause}
        ${cursorClause}
      ORDER BY p.created_at DESC
      LIMIT $2
    `;

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Soft delete a post
   * @param {Number} postId - Post ID
   * @param {Number} userId - User ID (must be author)
   * @returns {Object|null} Deleted post or null
   */
  static async delete(postId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const sql = `
        UPDATE sns_posts
        SET is_deleted = true, updated_at = NOW()
        WHERE id = $1 AND user_id = $2 AND is_deleted = false
        RETURNING *
      `;

      const result = await client.query(sql, [postId, userId]);

      if (result.rows[0]) {
        // Decrement user post_count
        await client.query(
          'UPDATE users SET post_count = GREATEST(COALESCE(post_count, 0) - 1, 0) WHERE id = $1',
          [userId]
        );
      }

      await client.query('COMMIT');

      return result.rows[0] || null;
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('[SNS] Delete post error:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Increment like count
   * @param {Number} postId - Post ID
   */
  static async incrementLikeCount(postId) {
    const sql = `
      UPDATE sns_posts
      SET like_count = COALESCE(like_count, 0) + 1
      WHERE id = $1
    `;
    await query(sql, [postId]);
  }

  /**
   * Decrement like count
   * @param {Number} postId - Post ID
   */
  static async decrementLikeCount(postId) {
    const sql = `
      UPDATE sns_posts
      SET like_count = GREATEST(COALESCE(like_count, 0) - 1, 0)
      WHERE id = $1
    `;
    await query(sql, [postId]);
  }

  /**
   * Increment comment count
   * @param {Number} postId - Post ID
   */
  static async incrementCommentCount(postId) {
    const sql = `
      UPDATE sns_posts
      SET comment_count = COALESCE(comment_count, 0) + 1
      WHERE id = $1
    `;
    await query(sql, [postId]);
  }

  /**
   * Decrement comment count
   * @param {Number} postId - Post ID
   */
  static async decrementCommentCount(postId) {
    const sql = `
      UPDATE sns_posts
      SET comment_count = GREATEST(COALESCE(comment_count, 0) - 1, 0)
      WHERE id = $1
    `;
    await query(sql, [postId]);
  }
}

module.exports = Post;
