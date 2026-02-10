const { AccessToken } = require('livekit-server-sdk');

const LIVEKIT_HOST = process.env.LIVEKIT_HOST || 'http://localhost:7880';
const LIVEKIT_API_KEY = process.env.LIVEKIT_API_KEY || 'lemon-korean-key';
const LIVEKIT_SECRET = process.env.LIVEKIT_SECRET || 'lemon-korean-secret-change-me';

/**
 * Generate a LiveKit access token for a user joining a room
 */
const generateToken = async (roomName, userId, userName) => {
  const token = new AccessToken(LIVEKIT_API_KEY, LIVEKIT_SECRET, {
    identity: `user_${userId}`,
    name: userName,
    ttl: '1h',
  });

  token.addGrant({
    room: roomName,
    roomJoin: true,
    canPublish: true,
    canSubscribe: true,
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
