/**
 * Voice room socket event handlers
 * Handles joining/leaving voice room socket rooms, chat, character positions, reactions, gestures
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

  // Send chat message via socket (alternative to REST)
  socket.on('voice:send_message', ({ room_id, content }) => {
    if (!content || !content.trim()) return;
    // Messages are persisted via REST endpoint; this is for relay only
    io.to(`voice:${room_id}`).emit('voice:new_message', {
      room_id,
      user_id: userId,
      content: content.trim(),
      name: socket.userName,
      message_type: 'text',
      created_at: new Date().toISOString()
    });
  });

  // Character position update (stage walking)
  socket.on('voice:character_position', ({ room_id, x, y, direction }) => {
    // Relay to all others in the room (not back to sender)
    socket.to(`voice:${room_id}`).emit('voice:character_position', {
      user_id: userId,
      x,
      y,
      direction
    });
  });

  // Emoji reaction (all room members can send)
  socket.on('voice:reaction', ({ room_id, emoji }) => {
    io.to(`voice:${room_id}`).emit('voice:reaction', {
      user_id: userId,
      emoji,
      name: socket.userName
    });
  });

  // Character gesture (speakers only - enforced client-side + trust)
  socket.on('voice:gesture', ({ room_id, gesture }) => {
    const validGestures = ['wave', 'bow', 'dance', 'jump', 'clap'];
    if (!validGestures.includes(gesture)) return;

    io.to(`voice:${room_id}`).emit('voice:gesture', {
      user_id: userId,
      gesture
    });
  });
};
