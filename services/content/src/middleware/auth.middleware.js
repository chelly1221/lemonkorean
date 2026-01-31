const { verifyToken } = require('../config/jwt');
const { query } = require('../config/database');

/**
 * requireAuth - JWT authentication middleware
 * Extracts JWT from Authorization header and verifies it
 * Adds user info to req.user
 *
 * @usage router.get('/protected', requireAuth, controller)
 */
const requireAuth = async (req, res, next) => {
  try {
    console.log(`[AUTH] Authenticating request: ${req.method} ${req.path}`);

    // 1. Extract token from Authorization header
    const authHeader = req.headers.authorization;

    if (!authHeader) {
      console.log(`[AUTH] No Authorization header provided`);
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'No authorization header provided',
        code: 'NO_AUTH_HEADER'
      });
    }

    if (!authHeader.startsWith('Bearer ')) {
      console.log(`[AUTH] Invalid Authorization header format`);
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Invalid authorization header format. Expected: Bearer <token>',
        code: 'INVALID_AUTH_FORMAT'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    if (!token || token.trim() === '') {
      console.log(`[AUTH] Empty token provided`);
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'No token provided',
        code: 'MISSING_TOKEN'
      });
    }

    // 2. Verify JWT token
    let decoded;
    try {
      decoded = verifyToken(token);
      console.log(`[AUTH] Token verified for user: ${decoded.userId}`);
    } catch (verifyError) {
      console.log(`[AUTH] Token verification failed:`, verifyError.message);

      if (verifyError.message === 'Token expired') {
        return res.status(401).json({
          success: false,
          error: 'Unauthorized',
          message: 'Token has expired. Please login again.',
          code: 'TOKEN_EXPIRED'
        });
      }

      if (verifyError.message === 'Invalid token') {
        return res.status(401).json({
          success: false,
          error: 'Unauthorized',
          message: 'Invalid token',
          code: 'INVALID_TOKEN'
        });
      }

      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'Token verification failed',
        code: 'TOKEN_VERIFICATION_FAILED'
      });
    }

    // 3. Check if user exists in database
    const userSql = 'SELECT id, email, subscription_type, is_active FROM users WHERE id = $1';
    const userResult = await query(userSql, [decoded.userId]);

    if (userResult.rows.length === 0) {
      console.log(`[AUTH] User not found: ${decoded.userId}`);
      return res.status(401).json({
        success: false,
        error: 'Unauthorized',
        message: 'User not found. Token may be invalid.',
        code: 'USER_NOT_FOUND'
      });
    }

    const user = userResult.rows[0];

    // 4. Check account activation status
    if (!user.is_active) {
      console.log(`[AUTH] User account is deactivated: ${decoded.userId}`);
      return res.status(403).json({
        success: false,
        error: 'Forbidden',
        message: 'Your account has been deactivated. Please contact support.',
        code: 'ACCOUNT_DEACTIVATED'
      });
    }

    // 5. Add user info to req.user
    req.user = {
      id: user.id,
      email: user.email,
      subscriptionType: user.subscription_type
    };

    console.log(`[AUTH] Authentication successful for user: ${user.email}`);

    next();
  } catch (error) {
    console.error('[AUTH] Unexpected authentication error:', error);

    res.status(500).json({
      success: false,
      error: 'Internal Server Error',
      message: 'Authentication failed due to server error',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * optionalAuth - Optional authentication middleware
 * Verifies token if present, continues without auth if not
 *
 * @usage router.get('/public-but-personalized', optionalAuth, controller)
 */
const optionalAuth = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      console.log(`[OPTIONAL_AUTH] No token provided, continuing without auth`);
      return next();
    }

    const token = authHeader.substring(7);

    try {
      const decoded = verifyToken(token);
      const userSql = 'SELECT id, email, subscription_type, is_active FROM users WHERE id = $1';
      const userResult = await query(userSql, [decoded.userId]);

      if (userResult.rows.length > 0 && userResult.rows[0].is_active) {
        const user = userResult.rows[0];
        req.user = {
          id: user.id,
          email: user.email,
          subscriptionType: user.subscription_type
        };
        console.log(`[OPTIONAL_AUTH] User authenticated: ${user.email}`);
      } else {
        console.log(`[OPTIONAL_AUTH] User not found or inactive, continuing without auth`);
      }
    } catch (error) {
      console.log(`[OPTIONAL_AUTH] Token verification failed, continuing without auth:`, error.message);
    }

    next();
  } catch (error) {
    console.error('[OPTIONAL_AUTH] Unexpected error:', error);
    // Continue even if error occurs
    next();
  }
};

module.exports = {
  requireAuth,
  optionalAuth
};
