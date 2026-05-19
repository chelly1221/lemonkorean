const { AccessToken, RoomServiceClient } = require('livekit-server-sdk');

const LIVEKIT_HOST = process.env.LIVEKIT_HOST || 'http://localhost:7880';
const LIVEKIT_API_KEY = process.env.LIVEKIT_API_KEY;
const LIVEKIT_SECRET = process.env.LIVEKIT_SECRET;

if (!LIVEKIT_API_KEY || !LIVEKIT_SECRET) {
  console.error('FATAL: LIVEKIT_API_KEY and LIVEKIT_SECRET environment variables are required');
  process.exit(1);
}

const roomService = new RoomServiceClient(LIVEKIT_HOST, LIVEKIT_API_KEY, LIVEKIT_SECRET);

/**
 * Generate a LiveKit access token for a user joining a room
 * @param {string} roomName - LiveKit room name
 * @param {number} userId - User ID
 * @param {string} userName - Display name
 * @param {string} role - 'speaker' or 'listener'
 */
const generateToken = async (roomName, userId, userName, role = 'speaker') => {
  const token = new AccessToken(LIVEKIT_API_KEY, LIVEKIT_SECRET, {
    identity: `user_${userId}`,
    name: userName,
    ttl: '1h',
  });

  const isSpeaker = role === 'speaker';

  token.addGrant({
    room: roomName,
    roomJoin: true,
    canPublish: isSpeaker,
    canSubscribe: true,
    canPublishData: isSpeaker,
  });

  return await token.toJwt();
};

/**
 * Get LiveKit connection URL for clients
 * In production, this goes through nginx proxy; for direct, use the actual URL
 */
const getLiveKitUrl = () => {
  // Client connects via WSS through nginx
  return process.env.LIVEKIT_PUBLIC_URL || LIVEKIT_HOST.replace('http', 'ws');
};

/**
 * Update a participant's publish permissions in-place via LiveKit Server API.
 * This avoids the need for clients to disconnect/reconnect when promoted or demoted.
 */
const updateParticipantPermissions = async (roomName, userId, canPublish) => {
  const identity = `user_${userId}`;
  try {
    await roomService.updateParticipant(roomName, identity, {
      permission: {
        canSubscribe: true,
        canPublish: canPublish,
        canPublishData: canPublish,
      },
    });
    console.log(`[LiveKit] Updated permissions for ${identity} in ${roomName}: canPublish=${canPublish}`);
  } catch (err) {
    // Participant may not be connected yet — log but don't throw
    console.warn(`[LiveKit] Failed to update permissions for ${identity}: ${err.message}`);
  }
};

module.exports = { generateToken, getLiveKitUrl, updateParticipantPermissions, roomService, LIVEKIT_HOST };
