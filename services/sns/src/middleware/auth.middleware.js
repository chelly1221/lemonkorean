const { verifyToken } = require('../config/jwt');
const { query } = require('../config/database');

// ==================== Main Authentication Middleware ====================

/**
 * requireAuth - JWT 인증 미들웨어
 * Authorization 헤더에서 JWT 추출 및 검증
 * req.user에 사용자 정보 추가
 *
 * @usage router.get('/protected', requireAuth, controller)
 */
const requireAuth = async (req, res, next) => {
  try {
    console.log(`[SNS] Authenticating request: ${req.method} ${req.path}`);

    // 1. Authorization 헤더에서 토큰 추출
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      console.log(`[SNS] No Authorization header provided`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'No authorization header provided',
        code: 'NO_AUTH_HEADER'
      });
    }

    if (!authHeader.startsWith('Bearer ')) {
      console.log(`[SNS] Invalid Authorization header format`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Invalid authorization header format. Expected: Bearer <token>',
        code: 'INVALID_AUTH_FORMAT'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    if (!token || token.trim() === '') {
      console.log(`[SNS] Empty token provided`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'No token provided',
        code: 'MISSING_TOKEN'
      });
    }

    // 2. JWT 토큰 검증
    let decoded;
    try {
      decoded = verifyToken(token);
      console.log(`[SNS] Token verified for user: ${decoded.userId}`);
    } catch (verifyError) {
      console.log(`[SNS] Token verification failed:`, verifyError.message);

      if (verifyError.message === 'Token expired') {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'Token has expired. Please login again.',
          code: 'TOKEN_EXPIRED'
        });
      }

      if (verifyError.message === 'Invalid token') {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'Invalid token',
          code: 'INVALID_TOKEN'
        });
      }

      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Token verification failed',
        code: 'TOKEN_VERIFICATION_FAILED'
      });
    }

    // 3. 사용자 존재 여부 확인
    const sql = `
      SELECT id, email, name, language_preference, profile_image_url, sns_banned
      FROM users
      WHERE id = $1 AND is_active = true
    `;
    const result = await query(sql, [decoded.userId]);
    const user = result.rows[0];

    if (!user) {
      console.log(`[SNS] User not found or inactive: ${decoded.userId}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'User not found. Token may be invalid.',
        code: 'USER_NOT_FOUND'
      });
    }

    // 4. SNS 차단 상태 확인
    if (user.sns_banned) {
      console.log(`[SNS] User is SNS banned: ${decoded.userId}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Your SNS access has been suspended. Please contact support.',
        code: 'SNS_BANNED'
      });
    }

    // 5. req.user에 사용자 정보 추가
    req.user = {
      id: user.id,
      email: user.email,
      name: user.name,
      languagePreference: user.language_preference,
      profileImageUrl: user.profile_image_url
    };

    console.log(`[SNS] Authentication successful for user: ${user.email}`);

    next();
  } catch (error) {
    console.error('[SNS] Unexpected authentication error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Authentication failed due to server error',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Optional Authentication ====================

/**
 * optionalAuth - 선택적 인증 미들웨어
 * 토큰이 있으면 검증하고, 없어도 계속 진행
 *
 * @usage router.get('/public-but-personalized', optionalAuth, controller)
 */
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log(`[SNS] [OPTIONAL_AUTH] No token provided, continuing without auth`);
      return next();
    }

    const token = authHeader.substring(7);

    try {
      const decoded = verifyToken(token);

      const sql = `
        SELECT id, email, name, language_preference, profile_image_url, sns_banned
        FROM users
        WHERE id = $1 AND is_active = true
      `;
      const result = await query(sql, [decoded.userId]);
      const user = result.rows[0];

      if (user && !user.sns_banned) {
        req.user = {
          id: user.id,
          email: user.email,
          name: user.name,
          languagePreference: user.language_preference,
          profileImageUrl: user.profile_image_url
        };
        console.log(`[SNS] [OPTIONAL_AUTH] User authenticated: ${user.email}`);
      } else {
        console.log(`[SNS] [OPTIONAL_AUTH] User not found, inactive, or SNS banned, continuing without auth`);
      }
    } catch (error) {
      console.log(`[SNS] [OPTIONAL_AUTH] Token verification failed, continuing without auth:`, error.message);
    }

    next();
  } catch (error) {
    console.error('[SNS] [OPTIONAL_AUTH] Unexpected error:', error);
    // 에러가 발생해도 계속 진행
    next();
  }
};

// ==================== Exports ====================

module.exports = {
  requireAuth,
  optionalAuth
};
