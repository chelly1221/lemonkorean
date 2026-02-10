const pool = require('../config/database');

/**
 * Gamification Settings Controller
 * Manages ad configuration and lemon reward parameters
 * Pattern: single-row (id=1) like app-theme.controller.js
 */

// Default values (must match migration 009)
const DEFAULTS = {
  admob_app_id: 'ca-app-pub-3940256099942544~3347511713',
  admob_rewarded_ad_id: 'ca-app-pub-3940256099942544/5224354917',
  adsense_publisher_id: '',
  adsense_ad_slot: '',
  ads_enabled: true,
  web_ads_enabled: false,
  lemon_3_threshold: 95,
  lemon_2_threshold: 80,
  boss_quiz_bonus: 5,
  boss_quiz_pass_percent: 70,
  max_tree_lemons: 10,
  version: 1,
};

/**
 * Get current gamification settings
 * @route GET /api/admin/gamification/settings
 * @access Public (used by Flutter app)
 */
const getSettings = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM gamification_settings WHERE id = 1'
    );

    if (result.rows.length === 0) {
      return res.json({ id: 1, ...DEFAULTS });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('[GAMIFICATION] Error fetching settings:', error);
    res.status(500).json({ error: 'Failed to fetch gamification settings' });
  }
};

/**
 * Update ad settings
 * @route PUT /api/admin/gamification/ad-settings
 * @access Admin only
 */
const updateAdSettings = async (req, res) => {
  try {
    const {
      admob_app_id,
      admob_rewarded_ad_id,
      adsense_publisher_id,
      adsense_ad_slot,
      ads_enabled,
      web_ads_enabled,
    } = req.body;

    const updates = [];
    const values = [];
    let paramIndex = 1;

    const fields = {
      admob_app_id,
      admob_rewarded_ad_id,
      adsense_publisher_id,
      adsense_ad_slot,
      ads_enabled,
      web_ads_enabled,
    };

    for (const [key, value] of Object.entries(fields)) {
      if (value !== undefined) {
        updates.push(`${key} = $${paramIndex}`);
        values.push(value);
        paramIndex++;
      }
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'No values provided' });
    }

    updates.push('updated_at = CURRENT_TIMESTAMP');
    updates.push('version = version + 1');
    if (req.user && req.user.id) {
      updates.push(`updated_by = $${paramIndex}`);
      values.push(req.user.id);
      paramIndex++;
    }

    const query = `
      UPDATE gamification_settings
      SET ${updates.join(', ')}
      WHERE id = 1
      RETURNING *
    `;

    const result = await pool.query(query, values);

    // Audit log
    if (req.user && req.user.id) {
      await pool.query(
        `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [
          req.user.id,
          req.user.email,
          'gamification.update_ad_settings',
          'gamification_settings',
          1,
          JSON.stringify(fields),
          req.ip,
          req.get('user-agent'),
        ]
      );
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('[GAMIFICATION] Error updating ad settings:', error);
    res.status(500).json({ error: 'Failed to update ad settings' });
  }
};

/**
 * Update lemon reward settings
 * @route PUT /api/admin/gamification/lemon-settings
 * @access Admin only
 */
const updateLemonSettings = async (req, res) => {
  try {
    const {
      lemon_3_threshold,
      lemon_2_threshold,
      boss_quiz_bonus,
      boss_quiz_pass_percent,
      max_tree_lemons,
    } = req.body;

    // Validate ranges
    const intFields = { lemon_3_threshold, lemon_2_threshold, boss_quiz_pass_percent };
    for (const [key, value] of Object.entries(intFields)) {
      if (value !== undefined && (value < 0 || value > 100)) {
        return res.status(400).json({ error: `${key} must be between 0 and 100` });
      }
    }
    if (boss_quiz_bonus !== undefined && (boss_quiz_bonus < 1 || boss_quiz_bonus > 50)) {
      return res.status(400).json({ error: 'boss_quiz_bonus must be between 1 and 50' });
    }
    if (max_tree_lemons !== undefined && (max_tree_lemons < 1 || max_tree_lemons > 20)) {
      return res.status(400).json({ error: 'max_tree_lemons must be between 1 and 20' });
    }

    const updates = [];
    const values = [];
    let paramIndex = 1;

    const fields = {
      lemon_3_threshold,
      lemon_2_threshold,
      boss_quiz_bonus,
      boss_quiz_pass_percent,
      max_tree_lemons,
    };

    for (const [key, value] of Object.entries(fields)) {
      if (value !== undefined) {
        updates.push(`${key} = $${paramIndex}`);
        values.push(value);
        paramIndex++;
      }
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'No values provided' });
    }

    updates.push('updated_at = CURRENT_TIMESTAMP');
    updates.push('version = version + 1');
    if (req.user && req.user.id) {
      updates.push(`updated_by = $${paramIndex}`);
      values.push(req.user.id);
      paramIndex++;
    }

    const query = `
      UPDATE gamification_settings
      SET ${updates.join(', ')}
      WHERE id = 1
      RETURNING *
    `;

    const result = await pool.query(query, values);

    // Audit log
    if (req.user && req.user.id) {
      await pool.query(
        `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [
          req.user.id,
          req.user.email,
          'gamification.update_lemon_settings',
          'gamification_settings',
          1,
          JSON.stringify(fields),
          req.ip,
          req.get('user-agent'),
        ]
      );
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('[GAMIFICATION] Error updating lemon settings:', error);
    res.status(500).json({ error: 'Failed to update lemon settings' });
  }
};

/**
 * Reset to default settings
 * @route POST /api/admin/gamification/reset
 * @access Admin only
 */
const resetSettings = async (req, res) => {
  try {
    const result = await pool.query(
      `UPDATE gamification_settings
       SET admob_app_id = $1,
           admob_rewarded_ad_id = $2,
           adsense_publisher_id = $3,
           adsense_ad_slot = $4,
           ads_enabled = $5,
           web_ads_enabled = $6,
           lemon_3_threshold = $7,
           lemon_2_threshold = $8,
           boss_quiz_bonus = $9,
           boss_quiz_pass_percent = $10,
           max_tree_lemons = $11,
           version = version + 1,
           updated_at = CURRENT_TIMESTAMP,
           updated_by = $12
       WHERE id = 1
       RETURNING *`,
      [
        DEFAULTS.admob_app_id,
        DEFAULTS.admob_rewarded_ad_id,
        DEFAULTS.adsense_publisher_id,
        DEFAULTS.adsense_ad_slot,
        DEFAULTS.ads_enabled,
        DEFAULTS.web_ads_enabled,
        DEFAULTS.lemon_3_threshold,
        DEFAULTS.lemon_2_threshold,
        DEFAULTS.boss_quiz_bonus,
        DEFAULTS.boss_quiz_pass_percent,
        DEFAULTS.max_tree_lemons,
        req.user.id,
      ]
    );

    // Audit log
    await pool.query(
      `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        req.user.id,
        req.user.email,
        'gamification.reset',
        'gamification_settings',
        1,
        JSON.stringify({ reset: true }),
        req.ip,
        req.get('user-agent'),
      ]
    );

    res.json({
      message: 'Gamification settings reset to defaults',
      settings: result.rows[0],
    });
  } catch (error) {
    console.error('[GAMIFICATION] Error resetting settings:', error);
    res.status(500).json({ error: 'Failed to reset gamification settings' });
  }
};

module.exports = {
  getSettings,
  updateAdSettings,
  updateLemonSettings,
  resetSettings,
};
