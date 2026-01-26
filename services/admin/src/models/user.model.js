const { query } = require('../config/database');

/**
 * User Model - Admin Service
 * Read-only operations for authentication/authorization
 */

/**
 * Find user by ID
 * @param {number} userId - User ID
 * @returns {Object|null} User object or null
 */
const findById = async (userId) => {
  try {
    const result = await query(
      `SELECT
        id,
        email,
        name,
        password_hash,
        subscription_type,
        language_preference,
        email_verified,
        is_active,
        role,
        created_at,
        last_login
      FROM users
      WHERE id = $1`,
      [userId]
    );

    if (result.rows.length === 0) {
      return null;
    }

    return result.rows[0];
  } catch (error) {
    console.error('[USER_MODEL] Error finding user by ID:', error);
    throw error;
  }
};

/**
 * Find user by email
 * @param {string} email - User email
 * @returns {Object|null} User object or null
 */
const findByEmail = async (email) => {
  try {
    const result = await query(
      `SELECT
        id,
        email,
        name,
        password_hash,
        subscription_type,
        language_preference,
        email_verified,
        is_active,
        role,
        created_at,
        last_login
      FROM users
      WHERE email = $1`,
      [email.toLowerCase()]
    );

    if (result.rows.length === 0) {
      return null;
    }

    return result.rows[0];
  } catch (error) {
    console.error('[USER_MODEL] Error finding user by email:', error);
    throw error;
  }
};

/**
 * Get all users with pagination and filtering
 * @param {Object} options - Query options
 * @returns {Object} { users, total, page, limit }
 */
const getAll = async (options = {}) => {
  try {
    const {
      page = 1,
      limit = 20,
      search = '',
      subscriptionType = null,
      isActive = null,
      role = null,
      sortBy = 'created_at',
      sortOrder = 'DESC'
    } = options;

    const offset = (page - 1) * limit;

    // Build WHERE clause
    const conditions = [];
    const params = [];
    let paramIndex = 1;

    if (search) {
      conditions.push(`(email ILIKE $${paramIndex} OR name ILIKE $${paramIndex})`);
      params.push(`%${search}%`);
      paramIndex++;
    }

    if (subscriptionType) {
      conditions.push(`subscription_type = $${paramIndex}`);
      params.push(subscriptionType);
      paramIndex++;
    }

    if (isActive !== null) {
      conditions.push(`is_active = $${paramIndex}`);
      params.push(isActive);
      paramIndex++;
    }

    if (role) {
      conditions.push(`role = $${paramIndex}`);
      params.push(role);
      paramIndex++;
    }

    const whereClause = conditions.length > 0 ? `WHERE ${conditions.join(' AND ')}` : '';

    // Validate sort column
    const allowedSortColumns = ['id', 'email', 'name', 'created_at', 'last_login', 'subscription_type'];
    const validSortBy = allowedSortColumns.includes(sortBy) ? sortBy : 'created_at';
    const validSortOrder = sortOrder.toUpperCase() === 'ASC' ? 'ASC' : 'DESC';

    // Get total count
    const countResult = await query(
      `SELECT COUNT(*) as total FROM users ${whereClause}`,
      params
    );
    const total = parseInt(countResult.rows[0].total);

    // Get users
    const usersResult = await query(
      `SELECT
        id,
        email,
        name,
        subscription_type,
        language_preference,
        email_verified,
        is_active,
        role,
        created_at,
        last_login
      FROM users
      ${whereClause}
      ORDER BY ${validSortBy} ${validSortOrder}
      LIMIT $${paramIndex} OFFSET $${paramIndex + 1}`,
      [...params, limit, offset]
    );

    return {
      users: usersResult.rows,
      total,
      page: parseInt(page),
      limit: parseInt(limit),
      totalPages: Math.ceil(total / limit)
    };
  } catch (error) {
    console.error('[USER_MODEL] Error getting users:', error);
    throw error;
  }
};

/**
 * Update user
 * @param {number} userId - User ID
 * @param {Object} updates - Fields to update
 * @returns {Object} Updated user
 */
const update = async (userId, updates) => {
  try {
    const allowedFields = [
      'name',
      'subscription_type',
      'language_preference',
      'email_verified',
      'is_active',
      'role'
    ];

    const updateFields = [];
    const params = [];
    let paramIndex = 1;

    Object.keys(updates).forEach((key) => {
      if (allowedFields.includes(key)) {
        updateFields.push(`${key} = $${paramIndex}`);
        params.push(updates[key]);
        paramIndex++;
      }
    });

    if (updateFields.length === 0) {
      throw new Error('No valid fields to update');
    }

    // Add userId as last parameter
    params.push(userId);

    const result = await query(
      `UPDATE users
       SET ${updateFields.join(', ')}
       WHERE id = $${paramIndex}
       RETURNING
        id, email, name, subscription_type, language_preference,
        email_verified, is_active, role, created_at, last_login`,
      params
    );

    if (result.rows.length === 0) {
      throw new Error('User not found');
    }

    return result.rows[0];
  } catch (error) {
    console.error('[USER_MODEL] Error updating user:', error);
    throw error;
  }
};

/**
 * Get user stats (for user detail page)
 * @param {number} userId - User ID
 * @returns {Object} User statistics
 */
const getUserStats = async (userId) => {
  try {
    const result = await query(
      `SELECT
        COUNT(DISTINCT lesson_id) as completed_lessons,
        COUNT(*) as total_progress_entries,
        AVG(quiz_score) as avg_quiz_score,
        MAX(completed_at) as last_activity
      FROM user_progress
      WHERE user_id = $1 AND status = 'completed'`,
      [userId]
    );

    return result.rows[0];
  } catch (error) {
    console.error('[USER_MODEL] Error getting user stats:', error);
    throw error;
  }
};

module.exports = {
  findById,
  findByEmail,
  getAll,
  update,
  getUserStats
};
