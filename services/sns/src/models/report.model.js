const { query } = require('../config/database');

class Report {
  /**
   * Create a new report
   * @param {Number} reporterId - Reporter user ID
   * @param {Object} reportData - Report data
   * @returns {Object} Created report
   */
  static async create(reporterId, { targetType, targetId, reason }) {
    const sql = `
      INSERT INTO sns_reports (reporter_id, target_type, target_id, reason, status, created_at)
      VALUES ($1, $2, $3, $4, 'pending', NOW())
      RETURNING *
    `;

    const values = [reporterId, targetType, targetId, reason];
    const result = await query(sql, values);

    console.log(`[SNS] Report created: ${result.rows[0].id} by user ${reporterId} for ${targetType} ${targetId}`);
    return result.rows[0];
  }

  /**
   * Get all reports (for admin)
   * Cursor-based pagination
   * @param {Object} options - Filter and pagination options
   * @returns {Array} Reports array
   */
  static async getAll({ status, cursor, limit = 20 }) {
    const params = [limit];
    let paramIndex = 2;
    let statusClause = '';
    let cursorClause = '';

    if (status) {
      statusClause = `AND r.status = $${paramIndex}`;
      params.push(status);
      paramIndex++;
    }

    if (cursor) {
      cursorClause = `AND r.id < $${paramIndex}`;
      params.push(cursor);
      paramIndex++;
    }

    const sql = `
      SELECT r.*,
             u.name AS reporter_name,
             u.email AS reporter_email
      FROM sns_reports r
      JOIN users u ON r.reporter_id = u.id
      WHERE 1=1
        ${statusClause}
        ${cursorClause}
      ORDER BY r.id DESC
      LIMIT $1
    `;

    const result = await query(sql, params);
    return result.rows;
  }

  /**
   * Update report status
   * @param {Number} reportId - Report ID
   * @param {Object} updateData - Status and admin notes
   * @returns {Object|null} Updated report or null
   */
  static async updateStatus(reportId, { status, adminNotes }) {
    const sql = `
      UPDATE sns_reports
      SET status = $2, admin_notes = $3, updated_at = NOW()
      WHERE id = $1
      RETURNING *
    `;

    const result = await query(sql, [reportId, status, adminNotes || null]);
    return result.rows[0] || null;
  }
}

module.exports = Report;
