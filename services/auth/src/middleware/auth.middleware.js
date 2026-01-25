const { verifyToken } = require('../config/jwt');
const User = require('../models/user.model');

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
    console.log(`[AUTH] Authenticating request: ${req.method} ${req.path}`);

    // 1. Authorization 헤더에서 토큰 추출
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

    // 2. JWT 토큰 검증
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

    // 3. 사용자 존재 여부 확인
    const user = await User.findById(decoded.userId);

    if (!user) {
      console.log(`[AUTH] User not found: ${decoded.userId}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'User not found. Token may be invalid.',
        code: 'USER_NOT_FOUND'
      });
    }

    // 4. 계정 활성화 상태 확인
    if (!user.is_active) {
      console.log(`[AUTH] User account is deactivated: ${decoded.userId}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Your account has been deactivated. Please contact support.',
        code: 'ACCOUNT_DEACTIVATED'
      });
    }

    // 5. req.user에 사용자 정보 추가
    req.user = {
      id: user.id,
      email: user.email,
      name: user.name,
      subscriptionType: user.subscription_type,
      languagePreference: user.language_preference,
      emailVerified: user.email_verified
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
 * requireAdmin - 관리자 권한 확인 미들웨어
 * requireAuth 실행 후 사용자가 admin인지 확인
 * admin이 아니면 403 반환
 *
 * @usage router.delete('/users/:id', requireAuth, requireAdmin, controller)
 */
const requireAdmin = async (req, res, next) => {
  try {
    console.log(`[ADMIN] Checking admin privileges for user: ${req.user?.id}`);

    // 1. requireAuth가 먼저 실행되었는지 확인
    if (!req.user) {
      console.log(`[ADMIN] No user found in request. requireAuth not executed?`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Authentication required',
        code: 'AUTH_REQUIRED'
      });
    }

    // 2. 사용자 정보 다시 조회 (최신 정보 확인)
    const user = await User.findById(req.user.id);

    if (!user) {
      console.log(`[ADMIN] User not found: ${req.user.id}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'User not found',
        code: 'USER_NOT_FOUND'
      });
    }

    // 3. Admin 여부 확인
    // 방법 1: 이메일 기반 (임시 방법)
    const isAdminByEmail = user.email.toLowerCase().includes('admin@');

    // 방법 2: 특정 관리자 이메일 목록 (환경 변수)
    const adminEmails = (process.env.ADMIN_EMAILS || 'admin@lemon.com').split(',');
    const isAdminByList = adminEmails.includes(user.email.toLowerCase());

    // 방법 3: 사용자 ID 기반 (첫 번째 사용자는 admin)
    const isAdminById = user.id === 1;

    const isAdmin = isAdminByEmail || isAdminByList || isAdminById;

    if (!isAdmin) {
      console.log(`[ADMIN] Access denied for user: ${user.email} (not admin)`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Admin access required. You do not have permission to access this resource.',
        code: 'ADMIN_REQUIRED'
      });
    }

    console.log(`[ADMIN] Admin access granted for user: ${user.email}`);

    // req.user에 admin 플래그 추가
    req.user.isAdmin = true;

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

// ==================== Subscription-based Middleware ====================

/**
 * requirePremium - 프리미엄 구독 확인 미들웨어
 * 사용자가 premium 또는 lifetime 구독인지 확인
 *
 * @usage router.get('/premium-content', requireAuth, requirePremium, controller)
 */
const requirePremium = (req, res, next) => {
  console.log(`[PREMIUM] Checking premium subscription for user: ${req.user?.id}`);

  if (!req.user) {
    console.log(`[PREMIUM] No user found in request`);
    return res.status(401).json({
      error: 'Unauthorized',
      message: 'Authentication required',
      code: 'AUTH_REQUIRED'
    });
  }

  const { subscriptionType } = req.user;

  // free가 아니면 premium/lifetime
  if (subscriptionType === 'free') {
    console.log(`[PREMIUM] Access denied for free user: ${req.user.email}`);
    return res.status(403).json({
      error: 'Forbidden',
      message: 'Premium subscription required to access this resource',
      code: 'PREMIUM_REQUIRED',
      upgradeUrl: '/api/subscription/upgrade'
    });
  }

  // Premium 또는 lifetime 구독인 경우 구독 만료일 확인
  if (subscriptionType === 'premium' && req.user.subscription_expires_at) {
    const expiresAt = new Date(req.user.subscription_expires_at);
    const now = new Date();

    if (expiresAt < now) {
      console.log(`[PREMIUM] Subscription expired for user: ${req.user.email}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Your premium subscription has expired',
        code: 'SUBSCRIPTION_EXPIRED',
        expiredAt: expiresAt.toISOString(),
        renewUrl: '/api/subscription/renew'
      });
    }
  }

  console.log(`[PREMIUM] Premium access granted for user: ${req.user.email}`);

  next();
};

/**
 * requireSubscription - 특정 구독 타입 확인 미들웨어
 *
 * @param {Array<string>} allowedTypes - 허용된 구독 타입들
 * @returns {Function} Express middleware
 * @usage router.get('/lifetime-only', requireAuth, requireSubscription(['lifetime']), controller)
 */
const requireSubscription = (allowedTypes) => {
  return (req, res, next) => {
    console.log(`[SUBSCRIPTION] Checking subscription for user: ${req.user?.id}`);

    if (!req.user) {
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Authentication required',
        code: 'AUTH_REQUIRED'
      });
    }

    if (!allowedTypes.includes(req.user.subscriptionType)) {
      console.log(`[SUBSCRIPTION] Access denied. Required: ${allowedTypes.join(', ')}, User has: ${req.user.subscriptionType}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: `This resource requires one of: ${allowedTypes.join(', ')} subscription`,
        code: 'SUBSCRIPTION_REQUIRED',
        currentSubscription: req.user.subscriptionType
      });
    }

    console.log(`[SUBSCRIPTION] Access granted for user: ${req.user.email}`);
    next();
  };
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
      console.log(`[OPTIONAL_AUTH] No token provided, continuing without auth`);
      return next();
    }

    const token = authHeader.substring(7);

    try {
      const decoded = verifyToken(token);
      const user = await User.findById(decoded.userId);

      if (user && user.is_active) {
        req.user = {
          id: user.id,
          email: user.email,
          name: user.name,
          subscriptionType: user.subscription_type,
          languagePreference: user.language_preference,
          emailVerified: user.email_verified
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
    // 에러가 발생해도 계속 진행
    next();
  }
};

// ==================== Email Verification Middleware ====================

/**
 * requireEmailVerified - 이메일 인증 확인 미들웨어
 * 이메일이 인증된 사용자만 허용
 *
 * @usage router.post('/create-post', requireAuth, requireEmailVerified, controller)
 */
const requireEmailVerified = (req, res, next) => {
  console.log(`[EMAIL_VERIFIED] Checking email verification for user: ${req.user?.id}`);

  if (!req.user) {
    return res.status(401).json({
      error: 'Unauthorized',
      message: 'Authentication required',
      code: 'AUTH_REQUIRED'
    });
  }

  if (!req.user.emailVerified) {
    console.log(`[EMAIL_VERIFIED] Email not verified for user: ${req.user.email}`);
    return res.status(403).json({
      error: 'Forbidden',
      message: 'Email verification required. Please verify your email address.',
      code: 'EMAIL_VERIFICATION_REQUIRED',
      resendUrl: '/api/auth/resend-verification'
    });
  }

  console.log(`[EMAIL_VERIFIED] Email verified for user: ${req.user.email}`);
  next();
};

// ==================== Rate Limiting Helper ====================

/**
 * attachUserToRateLimit - Rate limiting을 위해 사용자 ID 추가
 * Rate limiter와 함께 사용하여 사용자별 제한 적용
 */
const attachUserToRateLimit = (req, res, next) => {
  if (req.user) {
    req.rateLimitKey = `user:${req.user.id}`;
  } else {
    req.rateLimitKey = `ip:${req.ip}`;
  }
  next();
};

// ==================== Exports ====================

module.exports = {
  // Main authentication
  requireAuth,
  authenticate: requireAuth, // Alias for backward compatibility

  // Authorization
  requireAdmin,
  requirePremium,
  requireSubscription,
  requireEmailVerified,

  // Optional
  optionalAuth,

  // Helpers
  attachUserToRateLimit
};
