const express = require('express');
const router = express.Router();
const multer = require('multer');
const characterItemsController = require('../controllers/character-items.controller');
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

/**
 * Character Items Routes
 * Base path: /api/admin/character-items
 */

// All routes require admin authentication
router.use(requireAuth, requireAdmin);

// Configure multer for sprite uploads (PNG only, 10MB limit)
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024, // 10 MB
    files: 1,
  },
  fileFilter: (req, file, cb) => {
    if (file.mimetype !== 'image/png') {
      return cb(new Error('Only PNG files are allowed for sprites'));
    }
    cb(null, true);
  },
});

// CRUD operations
router.get('/', characterItemsController.getItems);
router.get('/stats', characterItemsController.getStats);
router.get('/:id', characterItemsController.getItemById);
router.post('/', characterItemsController.createItem);
router.put('/:id', characterItemsController.updateItem);
router.delete('/:id', characterItemsController.deleteItem);

// Sprite upload
router.post('/upload-sprite', upload.single('sprite'), characterItemsController.uploadSprite);

// Handle multer errors
router.use((error, req, res, next) => {
  if (error instanceof multer.MulterError) {
    if (error.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({
        error: 'File too large. Maximum size is 10 MB',
      });
    }
    if (error.code === 'LIMIT_UNEXPECTED_FILE') {
      return res.status(400).json({
        error: 'Unexpected field name. Use "sprite" as the field name',
      });
    }
    return res.status(400).json({ error: error.message });
  }

  if (error.message === 'Only PNG files are allowed for sprites') {
    return res.status(400).json({ error: error.message });
  }

  next(error);
});

module.exports = router;
