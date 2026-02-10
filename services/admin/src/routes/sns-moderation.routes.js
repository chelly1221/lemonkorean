const express = require('express');
const router = express.Router();
const snsModerationController = require('../controllers/sns-moderation.controller');

// All routes require admin auth (handled by middleware in index.js)

// Reports
router.get('/reports', snsModerationController.getReports);
router.put('/reports/:id', snsModerationController.updateReport);

// Posts
router.get('/posts', snsModerationController.getPosts);
router.delete('/posts/:id', snsModerationController.deletePost);

// Users
router.get('/users', snsModerationController.getUsers);
router.put('/users/:id/ban', snsModerationController.banUser);
router.put('/users/:id/unban', snsModerationController.unbanUser);

// Stats
router.get('/stats', snsModerationController.getStats);

module.exports = router;
