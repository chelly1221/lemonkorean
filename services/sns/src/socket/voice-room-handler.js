/**
 * Voice room socket event handlers
 * Handles joining/leaving voice room socket rooms for real-time updates
 */
module.exports = (io, socket) => {
  const userId = socket.userId;

  // Join voice room socket room (for receiving participant updates)
  socket.on('voice:join_room', ({ room_id }) => {
    socket.join(`voice:${room_id}`);
    console.log(`[Socket] User ${userId} joined voice room ${room_id}`);
  });

  // Leave voice room socket room
  socket.on('voice:leave_room', ({ room_id }) => {
    socket.leave(`voice:${room_id}`);
  });
};
