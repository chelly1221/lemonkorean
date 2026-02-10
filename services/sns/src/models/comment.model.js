const { query, getClient } = require('../config/database');

class Comment {
  /**
   * Create a new comment
   * @param {Number} postId - Post ID
   * @param {Number} userId - Author user ID
   * @param {Object} commentData - Comment data
   * @returns {Object} Created comment
   */
  static async create(postId, userId, { content, parentId }) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const sql = `
        INSERT INTO sns_comments (post_id, user_id, content, parent_id, created_at)
        VALUES ($1, $2, $3, $4, NOW())
        RETURNING *
      `;

      const values = [postId, userId, content, parentId || null];
      const result = await client.query(sql, values);

      // Increment post comment_count
      await client.query(
        'UPDATE sns_posts SET comment_count = COALESCE(comment_count, 0) + 1 WHERE id = $1',
        [postId]
      );

      await client.query('COMMIT');

      console.log(`[SNS] Comment created: ${result.rows[0].id} on post ${postId} by user ${userId}`);
      return result.rows[0];
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('[SNS] Create comment error:', error);
      throw error;
    } finally {
      client.release();
    }
  }

  /**
   * Get comments for a post with author info
   * Cursor-based pagination using created_at ASC
   * @param {Number} postId - Post ID
   * @param {Object} options - Pagination options
   * @returns {Array} Comments array
   */
  static async getByPost(postId, { cursor, limit = 20 }) {
    const params = [postId, limit];
    let cursorClause = '';

    if (cursor) {
      cursorClause = 'AND c.created_at > $3';
      params.push(cursor);
    }

    const sql = `
      SELECT c.*,
             u.name AS author_name,
             u.profile_image_url AS author_image
      FROM sns_comments c
      JOIN users u ON c.user_id = u.id
      WHERE c.post_id = $1
        AND c.is_deleted = false
        ${cursorClause}
      ORDER BY c.created_at ASC
      LIMIT $2
    `;

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Find comment by ID
   * @param {Number} id - Comment ID
   * @returns {Object|null} Comment object or null
   */
  static async findById(id) {
    const sql = `
      SELECT c.*,
             u.name AS author_name,
             u.profile_image_url AS author_image
      FROM sns_comments c
      JOIN users u ON c.user_id = u.id
      WHERE c.id = $1 AND c.is_deleted = false
    `;

    const result = await query(sql, [id]);
    return result.rows[0] || null;
  }

  /**
   * Soft delete a comment
   * @param {Number} commentId - Comment ID
   * @param {Number} userId - User ID (must be author)
   * @returns {Object|null} Deleted comment or null
   */
  static async delete(commentId, userId) {
    const client = await getClient();
    try {
      await client.query('BEGIN');

      const sql = `
        UPDATE sns_comments
        SET is_deleted = true, updated_at = NOW()
        WHERE id = $1 AND user_id = $2 AND is_deleted = false
        RETURNING *
      `;

      const result = await client.query(sql, [commentId, userId]);

      if (result.rows[0]) {
        // Decrement post comment_count
        await client.query(
          'UPDATE sns_posts SET comment_count = GREATEST(COALESCE(comment_count, 0) - 1, 0) WHERE id = $1',
          [result.rows[0].post_id]
        );
      }

      await client.query('COMMIT');

      return result.rows[0] || null;
    } catch (error) {
      await client.query('ROLLBACK');
      console.error('[SNS] Delete comment error:', error);
      throw error;
    } finally {
      client.release();
    }
  }
}

module.exports = Comment;
