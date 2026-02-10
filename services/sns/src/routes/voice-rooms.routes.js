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
  toggleMute
} = require('../controllers/voice-rooms.controller');

// All routes require authentication
router.use(requireAuth);

router.get('/', getRooms);
router.post('/', createRoom);
router.get('/:id', getRoom);
router.post('/:id/join', joinRoom);
router.post('/:id/leave', leaveRoom);
router.delete('/:id', closeRoom);
router.post('/:id/mute', toggleMute);

module.exports = router;
