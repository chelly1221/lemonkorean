const express = require('express');
const router = express.Router();
const { requireAuth } = require('../middleware/auth.middleware');
const {
  getRooms,
  createRoom,
  getRoom,
  joinRoom,
  leaveRoom,
  closeRoom,
  toggleMute,
  getMessages,
  sendMessage,
  requestStage,
  cancelStageRequest,
  grantStage,
  removeFromStage,
  leaveStage
} = require('../controllers/voice-rooms.controller');

// All routes require authentication
router.use(requireAuth);

// Existing routes
router.get('/', getRooms);
router.post('/', createRoom);
router.get('/:id', getRoom);
router.post('/:id/join', joinRoom);
router.post('/:id/leave', leaveRoom);
router.delete('/:id', closeRoom);
router.post('/:id/mute', toggleMute);

// Chat messages
router.get('/:id/messages', getMessages);
router.post('/:id/messages', sendMessage);

// Stage management
router.post('/:id/request-stage', requestStage);
router.delete('/:id/request-stage', cancelStageRequest);
router.post('/:id/grant-stage', grantStage);
router.post('/:id/remove-from-stage', removeFromStage);
router.post('/:id/leave-stage', leaveStage);

module.exports = router;
