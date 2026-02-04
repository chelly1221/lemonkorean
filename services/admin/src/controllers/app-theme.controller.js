const pool = require('../config/database');
const mediaUploadService = require('../services/media-upload.service');

/**
 * App Theme Controller
 * Handles Flutter app theme customization (colors, logos, fonts)
 * Note: This is separate from design.controller.js which handles admin dashboard theme
 */

/**
 * Get current app theme settings
 * @route GET /api/admin/app-theme/settings
 * @access Public (no auth required - used by Flutter app)
 */
const getSettings = async (req, res) => {
  try {
    const result = await pool.query(
      'SELECT * FROM app_theme_settings WHERE id = 1'
    );

    if (result.rows.length === 0) {
      // Return defaults if no record exists
      return res.json({
        id: 1,
        primary_color: '#FFEF5F',
        secondary_color: '#4CAF50',
        accent_color: '#FF9800',
        error_color: '#F44336',
        success_color: '#4CAF50',
        warning_color: '#FF9800',
        info_color: '#2196F3',
        text_primary: '#212121',
        text_secondary: '#757575',
        text_hint: '#BDBDBD',
        background_light: '#FAFAFA',
        background_dark: '#303030',
        card_background: '#FFFFFF',
        stage1_color: '#2196F3',
        stage2_color: '#4CAF50',
        stage3_color: '#FF9800',
        stage4_color: '#9C27B0',
        stage5_color: '#E91E63',
        stage6_color: '#F44336',
        stage7_color: '#607D8B',
        splash_logo_key: null,
        splash_logo_url: null,
        login_logo_key: null,
        login_logo_url: null,
        favicon_key: null,
        favicon_url: null,
        font_family: 'NotoSansKR',
        font_source: 'google',
        custom_font_key: null,
        custom_font_url: null,
        version: 1
      });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('[APP-THEME] Error fetching settings:', error);
    res.status(500).json({ error: 'Failed to fetch app theme settings' });
  }
};

/**
 * Update color settings
 * @route PUT /api/admin/app-theme/colors
 * @access Admin only
 */
const updateColors = async (req, res) => {
  try {
    const {
      primary_color,
      secondary_color,
      accent_color,
      error_color,
      success_color,
      warning_color,
      info_color,
      text_primary,
      text_secondary,
      text_hint,
      background_light,
      background_dark,
      card_background,
      stage1_color,
      stage2_color,
      stage3_color,
      stage4_color,
      stage5_color,
      stage6_color,
      stage7_color
    } = req.body;

    // Validate hex colors
    const hexColorRegex = /^#[0-9A-Fa-f]{6}$/;
    const colors = {
      primary_color,
      secondary_color,
      accent_color,
      error_color,
      success_color,
      warning_color,
      info_color,
      text_primary,
      text_secondary,
      text_hint,
      background_light,
      background_dark,
      card_background,
      stage1_color,
      stage2_color,
      stage3_color,
      stage4_color,
      stage5_color,
      stage6_color,
      stage7_color
    };

    for (const [key, value] of Object.entries(colors)) {
      if (value && !hexColorRegex.test(value)) {
        return res.status(400).json({
          error: `Invalid color format for ${key}. Expected #RRGGBB format.`
        });
      }
    }

    // Build update query dynamically
    const updates = [];
    const values = [];
    let paramIndex = 1;

    for (const [key, value] of Object.entries(colors)) {
      if (value !== undefined) {
        updates.push(`${key} = $${paramIndex}`);
        values.push(value);
        paramIndex++;
      }
    }

    if (updates.length === 0) {
      return res.status(400).json({ error: 'No color values provided' });
    }

    // Add updated_at and updated_by
    updates.push(`updated_at = CURRENT_TIMESTAMP`);
    if (req.user && req.user.id) {
      updates.push(`updated_by = $${paramIndex}`);
      values.push(req.user.id);
      paramIndex++;
    }

    const query = `
      UPDATE app_theme_settings
      SET ${updates.join(', ')}
      WHERE id = 1
      RETURNING *
    `;

    const result = await pool.query(query, values);

    // Log to audit trail
    if (req.user && req.user.id) {
      await pool.query(
        `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
         VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
        [
          req.user.id,
          req.user.email,
          'app_theme.update_colors',
          'app_theme_settings',
          1,
          JSON.stringify(colors),
          req.ip,
          req.get('user-agent')
        ]
      );
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('[APP-THEME] Error updating colors:', error);
    res.status(500).json({ error: 'Failed to update app theme colors' });
  }
};

/**
 * Upload splash screen logo
 * @route POST /api/admin/app-theme/splash-logo
 * @access Admin only
 */
const uploadSplashLogo = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Validate file type
    const allowedTypes = ['image/png', 'image/jpeg', 'image/jpg', 'image/svg+xml', 'image/webp'];
    if (!allowedTypes.includes(req.file.mimetype)) {
      return res.status(400).json({
        error: 'Invalid file type. Only PNG, JPEG, SVG, and WebP are allowed.'
      });
    }

    // Validate file size (5MB max)
    const maxSize = 5 * 1024 * 1024;
    if (req.file.size > maxSize) {
      return res.status(400).json({
        error: 'File too large. Maximum size is 5MB.'
      });
    }

    // Delete old logo from MinIO if exists
    const currentSettings = await pool.query(
      'SELECT splash_logo_key FROM app_theme_settings WHERE id = 1'
    );
    if (currentSettings.rows.length > 0 && currentSettings.rows[0].splash_logo_key) {
      try {
        await mediaUploadService.deleteFile(currentSettings.rows[0].splash_logo_key);
      } catch (err) {
        console.warn('[APP-THEME] Failed to delete old splash logo:', err.message);
      }
    }

    // Upload to MinIO
    const uploadResult = await mediaUploadService.uploadFile(
      req.file,
      'app-theme/logos',
      `splash-${Date.now()}-${req.file.originalname}`
    );

    // Update database
    const result = await pool.query(
      `UPDATE app_theme_settings
       SET splash_logo_key = $1, splash_logo_url = $2, updated_at = CURRENT_TIMESTAMP, updated_by = $3
       WHERE id = 1
       RETURNING *`,
      [uploadResult.key, uploadResult.url, req.user.id]
    );

    // Log to audit trail
    await pool.query(
      `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        req.user.id,
        req.user.email,
        'app_theme.upload_splash_logo',
        'app_theme_settings',
        1,
        JSON.stringify({ splash_logo_key: uploadResult.key, splash_logo_url: uploadResult.url }),
        req.ip,
        req.get('user-agent')
      ]
    );

    res.json({
      message: 'Splash logo uploaded successfully',
      settings: result.rows[0]
    });
  } catch (error) {
    console.error('[APP-THEME] Error uploading splash logo:', error);
    res.status(500).json({ error: 'Failed to upload splash logo' });
  }
};

/**
 * Upload login screen logo
 * @route POST /api/admin/app-theme/login-logo
 * @access Admin only
 */
const uploadLoginLogo = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Validate file type
    const allowedTypes = ['image/png', 'image/jpeg', 'image/jpg', 'image/svg+xml', 'image/webp'];
    if (!allowedTypes.includes(req.file.mimetype)) {
      return res.status(400).json({
        error: 'Invalid file type. Only PNG, JPEG, SVG, and WebP are allowed.'
      });
    }

    // Validate file size (5MB max)
    const maxSize = 5 * 1024 * 1024;
    if (req.file.size > maxSize) {
      return res.status(400).json({
        error: 'File too large. Maximum size is 5MB.'
      });
    }

    // Delete old logo from MinIO if exists
    const currentSettings = await pool.query(
      'SELECT login_logo_key FROM app_theme_settings WHERE id = 1'
    );
    if (currentSettings.rows.length > 0 && currentSettings.rows[0].login_logo_key) {
      try {
        await mediaUploadService.deleteFile(currentSettings.rows[0].login_logo_key);
      } catch (err) {
        console.warn('[APP-THEME] Failed to delete old login logo:', err.message);
      }
    }

    // Upload to MinIO
    const uploadResult = await mediaUploadService.uploadFile(
      req.file,
      'app-theme/logos',
      `login-${Date.now()}-${req.file.originalname}`
    );

    // Update database
    const result = await pool.query(
      `UPDATE app_theme_settings
       SET login_logo_key = $1, login_logo_url = $2, updated_at = CURRENT_TIMESTAMP, updated_by = $3
       WHERE id = 1
       RETURNING *`,
      [uploadResult.key, uploadResult.url, req.user.id]
    );

    // Log to audit trail
    await pool.query(
      `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        req.user.id,
        req.user.email,
        'app_theme.upload_login_logo',
        'app_theme_settings',
        1,
        JSON.stringify({ login_logo_key: uploadResult.key, login_logo_url: uploadResult.url }),
        req.ip,
        req.get('user-agent')
      ]
    );

    res.json({
      message: 'Login logo uploaded successfully',
      settings: result.rows[0]
    });
  } catch (error) {
    console.error('[APP-THEME] Error uploading login logo:', error);
    res.status(500).json({ error: 'Failed to upload login logo' });
  }
};

/**
 * Upload favicon
 * @route POST /api/admin/app-theme/favicon
 * @access Admin only
 */
const uploadFavicon = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Validate file type
    const allowedTypes = ['image/x-icon', 'image/vnd.microsoft.icon', 'image/png', 'image/jpeg'];
    if (!allowedTypes.includes(req.file.mimetype)) {
      return res.status(400).json({
        error: 'Invalid file type. Only ICO and PNG are allowed.'
      });
    }

    // Validate file size (1MB max)
    const maxSize = 1 * 1024 * 1024;
    if (req.file.size > maxSize) {
      return res.status(400).json({
        error: 'File too large. Maximum size is 1MB.'
      });
    }

    // Delete old favicon from MinIO if exists
    const currentSettings = await pool.query(
      'SELECT favicon_key FROM app_theme_settings WHERE id = 1'
    );
    if (currentSettings.rows.length > 0 && currentSettings.rows[0].favicon_key) {
      try {
        await mediaUploadService.deleteFile(currentSettings.rows[0].favicon_key);
      } catch (err) {
        console.warn('[APP-THEME] Failed to delete old favicon:', err.message);
      }
    }

    // Upload to MinIO
    const uploadResult = await mediaUploadService.uploadFile(
      req.file,
      'app-theme/favicons',
      `favicon-${Date.now()}-${req.file.originalname}`
    );

    // Update database
    const result = await pool.query(
      `UPDATE app_theme_settings
       SET favicon_key = $1, favicon_url = $2, updated_at = CURRENT_TIMESTAMP, updated_by = $3
       WHERE id = 1
       RETURNING *`,
      [uploadResult.key, uploadResult.url, req.user.id]
    );

    // Log to audit trail
    await pool.query(
      `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        req.user.id,
        req.user.email,
        'app_theme.upload_favicon',
        'app_theme_settings',
        1,
        JSON.stringify({ favicon_key: uploadResult.key, favicon_url: uploadResult.url }),
        req.ip,
        req.get('user-agent')
      ]
    );

    res.json({
      message: 'Favicon uploaded successfully',
      settings: result.rows[0]
    });
  } catch (error) {
    console.error('[APP-THEME] Error uploading favicon:', error);
    res.status(500).json({ error: 'Failed to upload favicon' });
  }
};

/**
 * Update font settings
 * @route PUT /api/admin/app-theme/font
 * @access Admin only
 */
const updateFont = async (req, res) => {
  try {
    const { font_family, font_source } = req.body;

    if (!font_family || !font_source) {
      return res.status(400).json({
        error: 'Both font_family and font_source are required'
      });
    }

    // Validate font_source
    const validSources = ['google', 'custom', 'system'];
    if (!validSources.includes(font_source)) {
      return res.status(400).json({
        error: 'font_source must be one of: google, custom, system'
      });
    }

    // Update database
    const result = await pool.query(
      `UPDATE app_theme_settings
       SET font_family = $1, font_source = $2, updated_at = CURRENT_TIMESTAMP, updated_by = $3
       WHERE id = 1
       RETURNING *`,
      [font_family, font_source, req.user.id]
    );

    // Log to audit trail
    await pool.query(
      `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        req.user.id,
        req.user.email,
        'app_theme.update_font',
        'app_theme_settings',
        1,
        JSON.stringify({ font_family, font_source }),
        req.ip,
        req.get('user-agent')
      ]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error('[APP-THEME] Error updating font:', error);
    res.status(500).json({ error: 'Failed to update font settings' });
  }
};

/**
 * Upload custom font
 * @route POST /api/admin/app-theme/font-upload
 * @access Admin only
 */
const uploadCustomFont = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ error: 'No file uploaded' });
    }

    // Validate file type
    const allowedTypes = ['font/ttf', 'font/otf', 'application/x-font-ttf', 'application/x-font-otf', 'application/octet-stream'];
    const allowedExtensions = ['.ttf', '.otf'];
    const fileExtension = req.file.originalname.toLowerCase().slice(req.file.originalname.lastIndexOf('.'));

    if (!allowedTypes.includes(req.file.mimetype) && !allowedExtensions.includes(fileExtension)) {
      return res.status(400).json({
        error: 'Invalid file type. Only TTF and OTF fonts are allowed.'
      });
    }

    // Validate file size (10MB max)
    const maxSize = 10 * 1024 * 1024;
    if (req.file.size > maxSize) {
      return res.status(400).json({
        error: 'File too large. Maximum size is 10MB.'
      });
    }

    // Delete old font from MinIO if exists
    const currentSettings = await pool.query(
      'SELECT custom_font_key FROM app_theme_settings WHERE id = 1'
    );
    if (currentSettings.rows.length > 0 && currentSettings.rows[0].custom_font_key) {
      try {
        await mediaUploadService.deleteFile(currentSettings.rows[0].custom_font_key);
      } catch (err) {
        console.warn('[APP-THEME] Failed to delete old custom font:', err.message);
      }
    }

    // Upload to MinIO
    const uploadResult = await mediaUploadService.uploadFile(
      req.file,
      'app-theme/fonts',
      `custom-${Date.now()}-${req.file.originalname}`
    );

    // Extract font family name from filename (remove extension and timestamp)
    const fontFamilyName = req.file.originalname.replace(/\.(ttf|otf)$/i, '');

    // Update database
    const result = await pool.query(
      `UPDATE app_theme_settings
       SET custom_font_key = $1, custom_font_url = $2, font_family = $3, font_source = 'custom',
           updated_at = CURRENT_TIMESTAMP, updated_by = $4
       WHERE id = 1
       RETURNING *`,
      [uploadResult.key, uploadResult.url, fontFamilyName, req.user.id]
    );

    // Log to audit trail
    await pool.query(
      `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        req.user.id,
        req.user.email,
        'app_theme.upload_custom_font',
        'app_theme_settings',
        1,
        JSON.stringify({ custom_font_key: uploadResult.key, custom_font_url: uploadResult.url, font_family: fontFamilyName }),
        req.ip,
        req.get('user-agent')
      ]
    );

    res.json({
      message: 'Custom font uploaded successfully',
      settings: result.rows[0]
    });
  } catch (error) {
    console.error('[APP-THEME] Error uploading custom font:', error);
    res.status(500).json({ error: 'Failed to upload custom font' });
  }
};

/**
 * Reset to default settings
 * @route POST /api/admin/app-theme/reset
 * @access Admin only
 */
const resetSettings = async (req, res) => {
  try {
    // Delete old media files from MinIO if they exist
    const currentSettings = await pool.query(
      'SELECT splash_logo_key, login_logo_key, favicon_key, custom_font_key FROM app_theme_settings WHERE id = 1'
    );

    if (currentSettings.rows.length > 0) {
      const { splash_logo_key, login_logo_key, favicon_key, custom_font_key } = currentSettings.rows[0];

      const filesToDelete = [splash_logo_key, login_logo_key, favicon_key, custom_font_key].filter(Boolean);

      for (const fileKey of filesToDelete) {
        try {
          await mediaUploadService.deleteFile(fileKey);
        } catch (err) {
          console.warn(`[APP-THEME] Failed to delete file ${fileKey}:`, err.message);
        }
      }
    }

    // Reset to defaults (matching AppConstants.dart values)
    const result = await pool.query(
      `UPDATE app_theme_settings
       SET primary_color = '#FFEF5F',
           secondary_color = '#4CAF50',
           accent_color = '#FF9800',
           error_color = '#F44336',
           success_color = '#4CAF50',
           warning_color = '#FF9800',
           info_color = '#2196F3',
           text_primary = '#212121',
           text_secondary = '#757575',
           text_hint = '#BDBDBD',
           background_light = '#FAFAFA',
           background_dark = '#303030',
           card_background = '#FFFFFF',
           stage1_color = '#2196F3',
           stage2_color = '#4CAF50',
           stage3_color = '#FF9800',
           stage4_color = '#9C27B0',
           stage5_color = '#E91E63',
           stage6_color = '#F44336',
           stage7_color = '#607D8B',
           splash_logo_key = NULL,
           splash_logo_url = NULL,
           login_logo_key = NULL,
           login_logo_url = NULL,
           favicon_key = NULL,
           favicon_url = NULL,
           font_family = 'NotoSansKR',
           font_source = 'google',
           custom_font_key = NULL,
           custom_font_url = NULL,
           updated_at = CURRENT_TIMESTAMP,
           updated_by = $1
       WHERE id = 1
       RETURNING *`,
      [req.user.id]
    );

    // Log to audit trail
    await pool.query(
      `INSERT INTO admin_audit_logs (admin_id, admin_email, action, resource_type, resource_id, changes, ip_address, user_agent)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        req.user.id,
        req.user.email,
        'app_theme.reset',
        'app_theme_settings',
        1,
        JSON.stringify({ reset: true }),
        req.ip,
        req.get('user-agent')
      ]
    );

    res.json({
      message: 'App theme settings reset to defaults',
      settings: result.rows[0]
    });
  } catch (error) {
    console.error('[APP-THEME] Error resetting settings:', error);
    res.status(500).json({ error: 'Failed to reset app theme settings' });
  }
};

module.exports = {
  getSettings,
  updateColors,
  uploadSplashLogo,
  uploadLoginLogo,
  uploadFavicon,
  updateFont,
  uploadCustomFont,
  resetSettings
};
