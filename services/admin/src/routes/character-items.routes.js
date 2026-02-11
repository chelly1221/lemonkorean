const express = require('express');
const router = express.Router();
const characterItemsController = require('../controllers/character-items.controller');
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

/**
 * Character Items Routes
 * Base path: /api/admin/character-items
 */

// All routes require admin authentication
router.use(requireAuth, requireAdmin);

// CRUD operations
router.get('/', characterItemsController.getItems);
router.get('/stats', characterItemsController.getStats);
router.get('/:id', characterItemsController.getItemById);
router.post('/', characterItemsController.createItem);
router.put('/:id', characterItemsController.updateItem);
router.delete('/:id', characterItemsController.deleteItem);

// Asset upload
router.post('/upload-asset', characterItemsController.uploadAsset);

module.exports = router;
