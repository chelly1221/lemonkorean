const { query } = require('../config/database');

const MODERATION_URL = process.env.MODERATION_SERVICE_URL || 'http://moderation-service:3008';
const MODERATION_TIMEOUT_MS = parseInt(process.env.MODERATION_TIMEOUT_MS || '5000');

/**
 * Call moderation service to classify text content.
 *
 * @param {string} text - Text to moderate
 * @param {string} context - One of: post, comment, bio, dm
 * @returns {Object} { safe, action, max_score, categories, processing_time_ms }
 * @throws {Error} If moderation service is unreachable, returns error, or response is malformed
 */
async function moderateText(text, context = 'post') {
  const response = await fetch(`${MODERATION_URL}/api/moderation/text`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ text, context }),
    signal: AbortSignal.timeout(MODERATION_TIMEOUT_MS),
  });

  if (!response.ok) {
    throw new Error(`Moderation service returned ${response.status}`);
  }

  const result = await response.json();

  // Validate response shape
  if (!result.action || typeof result.action !== 'string' ||
      !['allow', 'flag', 'reject'].includes(result.action)) {
    throw new Error(`Moderation service returned invalid action: ${result.action}`);
  }
  if (typeof result.max_score !== 'number') {
    throw new Error(`Moderation service returned invalid max_score: ${result.max_score}`);
  }

  return result;
}

/**
 * Log moderation result to database.
 */
async function logModeration({ contentType, contentId, userId, contentText, result }) {
  try {
    const safeText = (contentText ?? '').substring(0, 500);
    await query(
      `INSERT INTO moderation_logs
       (content_type, content_id, user_id, content_text, action, max_score, categories, processing_time_ms)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        contentType,
        contentId,
        userId,
        safeText,
        result.action,
        result.max_score,
        JSON.stringify(result.categories),
        result.processing_time_ms,
      ]
    );
  } catch (error) {
    console.error('[Moderation] Failed to log moderation result:', error.message);
  }
}

module.exports = { moderateText, logModeration };
