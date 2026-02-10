const { query } = require('../config/database');

/**
 * SNS Moderation Controller
 * Admin-only endpoints for moderating community content
 */

// Get all reports with pagination
const getReports = async (req, res) => {
  try {
    const { status = 'all', page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    let sql = `
      SELECT r.*,
             reporter.name as reporter_name, reporter.email as reporter_email,
             CASE
               WHEN r.target_type = 'post' THEN (SELECT content FROM posts WHERE id = r.target_id)
               WHEN r.target_type = 'comment' THEN (SELECT content FROM post_comments WHERE id = r.target_id)
               WHEN r.target_type = 'user' THEN (SELECT name FROM users WHERE id = r.target_id)
             END as target_content
      FROM sns_reports r
      JOIN users reporter ON r.reporter_id = reporter.id
    `;
    const params = [];

    if (status !== 'all') {
      params.push(status);
      sql += ` WHERE r.status = $${params.length}`;
    }

    sql += ` ORDER BY r.created_at DESC`;
    params.push(parseInt(limit));
    sql += ` LIMIT $${params.length}`;
    params.push(parseInt(offset));
    sql += ` OFFSET $${params.length}`;

    const result = await query(sql, params);

    // Get total count
    let countSql = 'SELECT COUNT(*) as total FROM sns_reports';
    const countParams = [];
    if (status !== 'all') {
      countParams.push(status);
      countSql += ` WHERE status = $1`;
    }
    const countResult = await query(countSql, countParams);

    res.json({
      reports: result.rows,
      total: parseInt(countResult.rows[0].total),
      page: parseInt(page),
      limit: parseInt(limit),
    });
  } catch (error) {
    console.error('[SNS-MOD] Get reports error:', error);
    res.status(500).json({ error: 'Failed to get reports' });
  }
};

// Update report status
const updateReport = async (req, res) => {
  try {
    const { id } = req.params;
    const { status, admin_notes } = req.body;

    const result = await query(
      `UPDATE sns_reports SET status = $1, admin_notes = $2, updated_at = NOW()
       WHERE id = $3 RETURNING *`,
      [status, admin_notes || null, id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Report not found' });
    }

    res.json({ report: result.rows[0] });
  } catch (error) {
    console.error('[SNS-MOD] Update report error:', error);
    res.status(500).json({ error: 'Failed to update report' });
  }
};

// Get posts with moderation info
const getPosts = async (req, res) => {
  try {
    const { page = 1, limit = 20, search = '' } = req.query;
    const offset = (page - 1) * limit;
    const params = [];

    let sql = `
      SELECT p.*, u.name as author_name, u.email as author_email,
             (SELECT COUNT(*) FROM sns_reports WHERE target_type = 'post' AND target_id = p.id) as report_count
      FROM posts p
      JOIN users u ON p.user_id = u.id
    `;

    if (search) {
      params.push(`%${search}%`);
      sql += ` WHERE p.content ILIKE $${params.length}`;
    }

    sql += ` ORDER BY p.created_at DESC`;
    params.push(parseInt(limit));
    sql += ` LIMIT $${params.length}`;
    params.push(parseInt(offset));
    sql += ` OFFSET $${params.length}`;

    const result = await query(sql, params);

    // Total count
    let countSql = 'SELECT COUNT(*) as total FROM posts';
    const countParams = [];
    if (search) {
      countParams.push(`%${search}%`);
      countSql += ` WHERE content ILIKE $1`;
    }
    const countResult = await query(countSql, countParams);

    res.json({
      posts: result.rows,
      total: parseInt(countResult.rows[0].total),
      page: parseInt(page),
      limit: parseInt(limit),
    });
  } catch (error) {
    console.error('[SNS-MOD] Get posts error:', error);
    res.status(500).json({ error: 'Failed to get posts' });
  }
};

// Admin delete post (hard delete flag)
const deletePost = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await query(
      `UPDATE posts SET is_deleted = true, updated_at = NOW() WHERE id = $1 RETURNING id`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Post not found' });
    }

    // Decrement user post count
    await query(
      `UPDATE users SET post_count = GREATEST(0, post_count - 1)
       WHERE id = (SELECT user_id FROM posts WHERE id = $1)`,
      [id]
    );

    res.json({ message: 'Post deleted', id: parseInt(id) });
  } catch (error) {
    console.error('[SNS-MOD] Delete post error:', error);
    res.status(500).json({ error: 'Failed to delete post' });
  }
};

// Get SNS users with stats
const getUsers = async (req, res) => {
  try {
    const { page = 1, limit = 20, search = '' } = req.query;
    const offset = (page - 1) * limit;
    const params = [];

    let sql = `
      SELECT id, email, name, bio, follower_count, following_count, post_count,
             is_public, sns_banned, created_at
      FROM users
      WHERE (post_count > 0 OR follower_count > 0 OR following_count > 0)
    `;

    if (search) {
      params.push(`%${search}%`);
      sql += ` AND (name ILIKE $${params.length} OR email ILIKE $${params.length})`;
    }

    sql += ` ORDER BY post_count DESC`;
    params.push(parseInt(limit));
    sql += ` LIMIT $${params.length}`;
    params.push(parseInt(offset));
    sql += ` OFFSET $${params.length}`;

    const result = await query(sql, params);

    res.json({ users: result.rows });
  } catch (error) {
    console.error('[SNS-MOD] Get users error:', error);
    res.status(500).json({ error: 'Failed to get users' });
  }
};

// Ban user from SNS
const banUser = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await query(
      `UPDATE users SET sns_banned = true WHERE id = $1 RETURNING id, name, email, sns_banned`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ user: result.rows[0], message: 'User banned from SNS' });
  } catch (error) {
    console.error('[SNS-MOD] Ban user error:', error);
    res.status(500).json({ error: 'Failed to ban user' });
  }
};

// Unban user
const unbanUser = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await query(
      `UPDATE users SET sns_banned = false WHERE id = $1 RETURNING id, name, email, sns_banned`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.json({ user: result.rows[0], message: 'User unbanned from SNS' });
  } catch (error) {
    console.error('[SNS-MOD] Unban user error:', error);
    res.status(500).json({ error: 'Failed to unban user' });
  }
};

// Get SNS stats overview
const getStats = async (req, res) => {
  try {
    const [postsResult, usersResult, reportsResult, commentsResult] = await Promise.all([
      query('SELECT COUNT(*) as total, COUNT(*) FILTER (WHERE is_deleted = true) as deleted FROM posts'),
      query('SELECT COUNT(*) FILTER (WHERE post_count > 0) as active_users, COUNT(*) FILTER (WHERE sns_banned = true) as banned_users FROM users'),
      query('SELECT COUNT(*) as total, COUNT(*) FILTER (WHERE status = \'pending\') as pending FROM sns_reports'),
      query('SELECT COUNT(*) as total FROM post_comments WHERE is_deleted = false'),
    ]);

    res.json({
      posts: {
        total: parseInt(postsResult.rows[0].total),
        deleted: parseInt(postsResult.rows[0].deleted),
      },
      users: {
        active: parseInt(usersResult.rows[0].active_users),
        banned: parseInt(usersResult.rows[0].banned_users),
      },
      reports: {
        total: parseInt(reportsResult.rows[0].total),
        pending: parseInt(reportsResult.rows[0].pending),
      },
      comments: {
        total: parseInt(commentsResult.rows[0].total),
      },
    });
  } catch (error) {
    console.error('[SNS-MOD] Get stats error:', error);
    res.status(500).json({ error: 'Failed to get stats' });
  }
};

module.exports = {
  getReports,
  updateReport,
  getPosts,
  deletePost,
  getUsers,
  banUser,
  unbanUser,
  getStats,
};
