const express = require('express');
const router = express.Router();
const { requireAuth } = require('../middleware/auth.middleware');
const {
  getConversations,
  createConversation,
  markRead,
  getUnreadCount
} = require('../controllers/conversations.controller');

// All routes require authentication
router.use(requireAuth);

router.get('/', getConversations);
router.post('/', createConversation);
router.get('/unread-count', getUnreadCount);
router.post('/:id/read', markRead);

module.exports = router;
