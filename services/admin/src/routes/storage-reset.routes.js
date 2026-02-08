const express = require('express');
const router = express.Router();
const systemController = require('../controllers/system.controller');

/**
 * Storage Reset Routes (Public API)
 * No authentication required - these are called by the web app at startup
 */

// Check if there's a pending storage reset flag
router.get('/check', systemController.checkStorageResetFlag);

// Mark a storage reset flag as completed
router.post('/complete', systemController.completeStorageResetFlag);

module.exports = router;
