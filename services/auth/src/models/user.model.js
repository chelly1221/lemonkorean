const { query, getClient } = require('../config/database');

class User {
  /**
   * Create a new user
   * @param {Object} userData - User data
   * @returns {Object} Created user
   */
  static async create(userData) {
    const { email, password_hash, name, language_preference } = userData;

    const sql = `
      INSERT INTO users (email, password_hash, name, language_preference, created_at)
      VALUES ($1, $2, $3, $4, NOW())
      RETURNING id, email, name, language_preference, subscription_type, created_at, is_active
    `;

    const values = [email, password_hash, name, language_preference || 'zh'];
    const result = await query(sql, values);

    return result.rows[0];
  }

  /**
   * Find user by email
   * @param {String} email - User email
   * @returns {Object|null} User object or null
   */
  static async findByEmail(email) {
    const sql = `
      SELECT id, email, password_hash, name, language_preference,
             subscription_type, subscription_expires_at, is_active,
             email_verified, created_at, last_login
      FROM users
      WHERE email = $1
    `;

    const result = await query(sql, [email]);
    return result.rows[0] || null;
  }

  /**
   * Find user by ID
   * @param {Number} id - User ID
   * @returns {Object|null} User object or null
   */
  static async findById(id) {
    const sql = `
      SELECT id, email, name, language_preference,
             subscription_type, subscription_expires_at, is_active,
             email_verified, profile_image_url, created_at, last_login
      FROM users
      WHERE id = $1
    `;

    const result = await query(sql, [id]);
    return result.rows[0] || null;
  }

  /**
   * Update user's last login timestamp
   * @param {Number} userId - User ID
   */
  static async updateLastLogin(userId) {
    const sql = `
      UPDATE users
      SET last_login = NOW()
      WHERE id = $1
    `;

    await query(sql, [userId]);
  }

  /**
   * Update user profile
   * @param {Number} userId - User ID
   * @param {Object} updates - Fields to update
   * @returns {Object} Updated user
   */
  static async update(userId, updates) {
    const allowedFields = ['name', 'language_preference', 'profile_image_url'];
    const fields = [];
    const values = [];
    let paramCount = 1;

    Object.keys(updates).forEach(key => {
      if (allowedFields.includes(key)) {
        fields.push(`${key} = $${paramCount}`);
        values.push(updates[key]);
        paramCount++;
      }
    });

    if (fields.length === 0) {
      throw new Error('No valid fields to update');
    }

    values.push(userId);
    const sql = `
      UPDATE users
      SET ${fields.join(', ')}
      WHERE id = $${paramCount}
      RETURNING id, email, name, language_preference, subscription_type,
                profile_image_url, created_at
    `;

    const result = await query(sql, values);
    return result.rows[0];
  }

  /**
   * Check if email exists
   * @param {String} email - Email to check
   * @returns {Boolean} True if exists
   */
  static async emailExists(email) {
    const sql = `
      SELECT EXISTS(SELECT 1 FROM users WHERE email = $1) as exists
    `;

    const result = await query(sql, [email]);
    return result.rows[0].exists;
  }

  /**
   * Verify user email
   * @param {Number} userId - User ID
   */
  static async verifyEmail(userId) {
    const sql = `
      UPDATE users
      SET email_verified = true
      WHERE id = $1
    `;

    await query(sql, [userId]);
  }

  /**
   * Deactivate user account
   * @param {Number} userId - User ID
   */
  static async deactivate(userId) {
    const sql = `
      UPDATE users
      SET is_active = false
      WHERE id = $1
    `;

    await query(sql, [userId]);
  }

  /**
   * Get user statistics
   * @param {Number} userId - User ID
   * @returns {Object} User stats
   */
  static async getStats(userId) {
    const sql = `
      SELECT * FROM user_learning_stats
      WHERE user_id = $1
    `;

    const result = await query(sql, [userId]);
    return result.rows[0] || null;
  }
}

module.exports = User;
