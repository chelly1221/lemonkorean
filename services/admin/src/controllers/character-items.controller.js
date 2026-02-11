const pool = require('../config/database');
const { getMinIOClient } = require('../config/minio');

/**
 * Character Items Controller
 * Manages character customization item catalog (CRUD)
 */

/**
 * Get character items with filters
 * @route GET /api/admin/character-items
 */
const getItems = async (req, res) => {
  try {
    const { page = 1, limit = 50, category, rarity, is_active } = req.query;
    const offset = (page - 1) * limit;

    let query = 'SELECT * FROM character_items WHERE 1=1';
    const params = [];
    let paramIndex = 1;

    if (category) {
      query += ` AND category = $${paramIndex++}`;
      params.push(category);
    }
    if (rarity) {
      query += ` AND rarity = $${paramIndex++}`;
      params.push(rarity);
    }
    if (is_active !== undefined) {
      query += ` AND is_active = $${paramIndex++}`;
      params.push(is_active === 'true');
    }

    // Count total
    const countQuery = query.replace('SELECT *', 'SELECT COUNT(*)');
    const countResult = await pool.query(countQuery, params);
    const total = parseInt(countResult.rows[0].count);

    // Add pagination
    query += ` ORDER BY category, render_order, id`;
    query += ` LIMIT $${paramIndex++} OFFSET $${paramIndex++}`;
    params.push(parseInt(limit), parseInt(offset));

    const result = await pool.query(query, params);

    res.json({
      success: true,
      data: result.rows,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        totalPages: Math.ceil(total / limit),
      },
    });
  } catch (error) {
    console.error('[CHARACTER-ITEMS] Error fetching items:', error);
    res.status(500).json({ error: 'Failed to fetch character items' });
  }
};

/**
 * Get single character item
 * @route GET /api/admin/character-items/:id
 */
const getItemById = async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM character_items WHERE id = $1', [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }

    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('[CHARACTER-ITEMS] Error fetching item:', error);
    res.status(500).json({ error: 'Failed to fetch character item' });
  }
};

/**
 * Create new character item
 * @route POST /api/admin/character-items
 */
const createItem = async (req, res) => {
  try {
    const {
      category, name, description, asset_key, asset_type = 'svg',
      is_bundled = false, render_order = 0, price = 0,
      rarity = 'common', is_default = false, metadata = {},
    } = req.body;

    if (!category || !name || !asset_key) {
      return res.status(400).json({ error: 'category, name, and asset_key are required' });
    }

    const result = await pool.query(
      `INSERT INTO character_items
       (category, name, description, asset_key, asset_type, is_bundled, render_order, price, rarity, is_default, metadata)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [category, name, description, asset_key, asset_type, is_bundled,
       render_order, price, rarity, is_default, JSON.stringify(metadata)]
    );

    res.status(201).json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('[CHARACTER-ITEMS] Error creating item:', error);
    res.status(500).json({ error: 'Failed to create character item' });
  }
};

/**
 * Update character item
 * @route PUT /api/admin/character-items/:id
 */
const updateItem = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      category, name, description, asset_key, asset_type,
      is_bundled, render_order, price, rarity, is_default, is_active, metadata,
    } = req.body;

    // Build dynamic UPDATE query
    const fields = [];
    const values = [];
    let paramIndex = 1;

    if (category !== undefined) { fields.push(`category = $${paramIndex++}`); values.push(category); }
    if (name !== undefined) { fields.push(`name = $${paramIndex++}`); values.push(name); }
    if (description !== undefined) { fields.push(`description = $${paramIndex++}`); values.push(description); }
    if (asset_key !== undefined) { fields.push(`asset_key = $${paramIndex++}`); values.push(asset_key); }
    if (asset_type !== undefined) { fields.push(`asset_type = $${paramIndex++}`); values.push(asset_type); }
    if (is_bundled !== undefined) { fields.push(`is_bundled = $${paramIndex++}`); values.push(is_bundled); }
    if (render_order !== undefined) { fields.push(`render_order = $${paramIndex++}`); values.push(render_order); }
    if (price !== undefined) { fields.push(`price = $${paramIndex++}`); values.push(price); }
    if (rarity !== undefined) { fields.push(`rarity = $${paramIndex++}`); values.push(rarity); }
    if (is_default !== undefined) { fields.push(`is_default = $${paramIndex++}`); values.push(is_default); }
    if (is_active !== undefined) { fields.push(`is_active = $${paramIndex++}`); values.push(is_active); }
    if (metadata !== undefined) { fields.push(`metadata = $${paramIndex++}`); values.push(JSON.stringify(metadata)); }

    if (fields.length === 0) {
      return res.status(400).json({ error: 'No fields to update' });
    }

    fields.push(`updated_at = NOW()`);
    values.push(id);

    const result = await pool.query(
      `UPDATE character_items SET ${fields.join(', ')} WHERE id = $${paramIndex} RETURNING *`,
      values
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }

    res.json({ success: true, data: result.rows[0] });
  } catch (error) {
    console.error('[CHARACTER-ITEMS] Error updating item:', error);
    res.status(500).json({ error: 'Failed to update character item' });
  }
};

/**
 * Soft delete (deactivate) character item
 * @route DELETE /api/admin/character-items/:id
 */
const deleteItem = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      'UPDATE character_items SET is_active = false, updated_at = NOW() WHERE id = $1 RETURNING id',
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Item not found' });
    }

    res.json({ success: true, message: 'Item deactivated' });
  } catch (error) {
    console.error('[CHARACTER-ITEMS] Error deleting item:', error);
    res.status(500).json({ error: 'Failed to delete character item' });
  }
};

/**
 * Upload asset file to MinIO
 * @route POST /api/admin/character-items/upload-asset
 */
const uploadAsset = async (req, res) => {
  try {
    // This endpoint expects multipart form data with a file
    // For now, we return the expected MinIO key pattern
    // Actual file upload is handled by the media service

    const { category, filename } = req.body;

    if (!category || !filename) {
      return res.status(400).json({ error: 'category and filename are required' });
    }

    const assetKey = `character-items/${category}/${filename}`;

    res.json({
      success: true,
      asset_key: assetKey,
      message: 'Upload the file to the media service with this key',
    });
  } catch (error) {
    console.error('[CHARACTER-ITEMS] Error uploading asset:', error);
    res.status(500).json({ error: 'Failed to upload asset' });
  }
};

/**
 * Get category statistics
 * @route GET /api/admin/character-items/stats
 */
const getStats = async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT category, COUNT(*) as count,
             COUNT(*) FILTER (WHERE is_active) as active_count,
             COUNT(*) FILTER (WHERE is_default) as default_count
      FROM character_items
      GROUP BY category
      ORDER BY category
    `);

    res.json({ success: true, data: result.rows });
  } catch (error) {
    console.error('[CHARACTER-ITEMS] Error fetching stats:', error);
    res.status(500).json({ error: 'Failed to fetch stats' });
  }
};

module.exports = {
  getItems,
  getItemById,
  createItem,
  updateItem,
  deleteItem,
  uploadAsset,
  getStats,
};
