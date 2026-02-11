const { AccessToken } = require('livekit-server-sdk');

const LIVEKIT_HOST = process.env.LIVEKIT_HOST || 'http://localhost:7880';
const LIVEKIT_API_KEY = process.env.LIVEKIT_API_KEY || 'lemon-korean-key';
const LIVEKIT_SECRET = process.env.LIVEKIT_SECRET || 'lemon-korean-secret-change-me';

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

module.exports = { generateToken, getLiveKitUrl, LIVEKIT_HOST };
