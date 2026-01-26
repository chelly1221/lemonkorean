const { verifyToken } = require('../config/jwt');
const User = require('../models/user.model');

// ==================== Main Authentication Middleware ====================

/**
 * requireAuth - JWT authentication middleware
 * Extracts and verifies JWT from Authorization header
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
        error: 'Unauthorized',
        message: 'No authorization header provided',
        code: 'NO_AUTH_HEADER'
      });
    }

    if (!authHeader.startsWith('Bearer ')) {
      console.log(`[AUTH] Invalid Authorization header format`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Invalid authorization header format. Expected: Bearer <token>',
        code: 'INVALID_AUTH_FORMAT'
      });
    }

    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    if (!token || token.trim() === '') {
      console.log(`[AUTH] Empty token provided`);
      return res.status(401).json({
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

    // 3. Check if user exists
    const user = await User.findById(decoded.userId);

    if (!user) {
      console.log(`[AUTH] User not found: ${decoded.userId}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'User not found. Token may be invalid.',
        code: 'USER_NOT_FOUND'
      });
    }

    // 4. Check account active status
    if (!user.is_active) {
      console.log(`[AUTH] User account is deactivated: ${decoded.userId}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Your account has been deactivated. Please contact support.',
        code: 'ACCOUNT_DEACTIVATED'
      });
    }

    // 5. Add user info to req.user
    req.user = {
      id: user.id,
      email: user.email,
      name: user.name,
      subscriptionType: user.subscription_type,
      languagePreference: user.language_preference,
      emailVerified: user.email_verified,
      role: user.role || 'user'
    };

    console.log(`[AUTH] Authentication successful for user: ${user.email}`);

    next();
  } catch (error) {
    console.error('[AUTH] Unexpected authentication error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Authentication failed due to server error',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Admin Authorization Middleware ====================

/**
 * requireAdmin - Admin privilege check middleware
 * Must run after requireAuth
 * Returns 403 if user is not admin
 *
 * @usage router.delete('/users/:id', requireAuth, requireAdmin, controller)
 */
const requireAdmin = async (req, res, next) => {
  try {
    console.log(`[ADMIN] Checking admin privileges for user: ${req.user?.id}`);

    // 1. Check if requireAuth was executed first
    if (!req.user) {
      console.log(`[ADMIN] No user found in request. requireAuth not executed?`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Authentication required',
        code: 'AUTH_REQUIRED'
      });
    }

    // 2. Fetch user info again (get latest data)
    const user = await User.findById(req.user.id);

    if (!user) {
      console.log(`[ADMIN] User not found: ${req.user.id}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'User not found',
        code: 'USER_NOT_FOUND'
      });
    }

    // 3. Check if user is admin
    // Hybrid approach for backward compatibility + future scalability

    // Method 1: Role-based (preferred for new implementation)
    const isAdminByRole = user.role && ['admin', 'content_editor', 'super_admin'].includes(user.role);

    // Method 2: Email-based (temporary method)
    const isAdminByEmail = user.email.toLowerCase().includes('admin@');

    // Method 3: Admin email list (environment variable)
    const adminEmails = (process.env.ADMIN_EMAILS || 'admin@lemon.com').split(',');
    const isAdminByList = adminEmails.includes(user.email.toLowerCase());

    // Method 4: User ID-based (first user is admin)
    const isAdminById = user.id === 1;

    const isAdmin = isAdminByRole || isAdminByEmail || isAdminByList || isAdminById;

    if (!isAdmin) {
      console.log(`[ADMIN] Access denied for user: ${user.email} (not admin)`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Admin access required. You do not have permission to access this resource.',
        code: 'ADMIN_REQUIRED'
      });
    }

    console.log(`[ADMIN] Admin access granted for user: ${user.email}`);

    // Add admin flag and role to req.user
    req.user.isAdmin = true;
    req.user.role = user.role || 'admin';

    next();
  } catch (error) {
    console.error('[ADMIN] Admin check error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Authorization check failed',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Exports ====================

module.exports = {
  requireAuth,
  requireAdmin
};
