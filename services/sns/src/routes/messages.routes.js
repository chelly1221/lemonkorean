const express = require('express');
const router = express.Router();
const { requireAuth } = require('../middleware/auth.middleware');
const {
  getMessages,
  sendMessage,
  deleteMessage,
  uploadMedia,
  upload
} = require('../controllers/messages.controller');

// All routes require authentication
router.use(requireAuth);

// Message routes scoped to conversations
router.get('/conversations/:id/messages', getMessages);
router.post('/conversations/:id/messages', sendMessage);

// Media upload
router.post('/dm/upload', upload.single('file'), uploadMedia);

// Message actions
router.delete('/messages/:id', deleteMessage);

module.exports = router;
