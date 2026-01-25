const bcrypt = require('bcrypt');
const User = require('../models/user.model');
const { generateTokenPair, verifyToken: jwtVerifyToken } = require('../config/jwt');
const { validateRegistration, validateLogin, sanitizeString } = require('../utils/validator');
const { query } = require('../config/database');

const SALT_ROUNDS = 10;

// ==================== Helper Functions ====================

/**
 * Extract device info from request
 */
const getDeviceInfo = (req) => {
  const userAgent = req.headers['user-agent'] || 'unknown';
  const ip = req.ip || req.connection.remoteAddress || 'unknown';

  // Parse basic device info
  let deviceType = 'unknown';
  if (/mobile/i.test(userAgent)) deviceType = 'mobile';
  else if (/tablet/i.test(userAgent)) deviceType = 'tablet';
  else if (/windows|mac|linux/i.test(userAgent)) deviceType = 'desktop';

  return {
    user_agent: userAgent,
    ip_address: ip,
    device_type: deviceType,
    timestamp: new Date().toISOString()
  };
};

/**
 * Create a new session
 */
const createSession = async (userId, tokens, req) => {
  try {
    const deviceInfo = getDeviceInfo(req);

    const sql = `
      INSERT INTO sessions (
        user_id, token, refresh_token, expires_at,
        device_info, ip_address, user_agent
      )
      VALUES ($1, $2, $3, NOW() + INTERVAL '30 days', $4, $5, $6)
      RETURNING id
    `;

    const result = await query(sql, [
      userId,
      tokens.accessToken,
      tokens.refreshToken,
      JSON.stringify(deviceInfo),
      deviceInfo.ip_address,
      deviceInfo.user_agent
    ]);

    console.log(`Session created for user ${userId}, session ID: ${result.rows[0].id}`);
    return result.rows[0].id;
  } catch (error) {
    console.error('Create session error:', error);
    throw error;
  }
};

/**
 * Check if session exists and is valid
 */
const checkSessionExists = async (userId, refreshToken) => {
  try {
    const sql = `
      SELECT EXISTS(
        SELECT 1 FROM sessions
        WHERE user_id = $1
          AND refresh_token = $2
          AND expires_at > NOW()
      ) as exists
    `;

    const result = await query(sql, [userId, refreshToken]);
    return result.rows[0].exists;
  } catch (error) {
    console.error('Check session error:', error);
    return false;
  }
};

/**
 * Update session with new tokens
 */
const updateSession = async (userId, oldRefreshToken, tokens) => {
  try {
    const sql = `
      UPDATE sessions
      SET
        token = $1,
        refresh_token = $2,
        last_activity = NOW(),
        expires_at = NOW() + INTERVAL '30 days'
      WHERE user_id = $3 AND refresh_token = $4
      RETURNING id
    `;

    const result = await query(sql, [
      tokens.accessToken,
      tokens.refreshToken,
      userId,
      oldRefreshToken
    ]);

    if (result.rowCount === 0) {
      throw new Error('Session not found');
    }

    console.log(`Session updated for user ${userId}`);
    return result.rows[0].id;
  } catch (error) {
    console.error('Update session error:', error);
    throw error;
  }
};

/**
 * Delete session
 */
const deleteSession = async (userId, refreshToken) => {
  try {
    const sql = `
      DELETE FROM sessions
      WHERE user_id = $1 AND refresh_token = $2
      RETURNING id
    `;

    const result = await query(sql, [userId, refreshToken]);

    if (result.rowCount > 0) {
      console.log(`Session deleted for user ${userId}`);
    }

    return result.rowCount;
  } catch (error) {
    console.error('Delete session error:', error);
    throw error;
  }
};

/**
 * Delete all sessions for a user
 */
const deleteAllUserSessions = async (userId) => {
  try {
    const sql = `
      DELETE FROM sessions
      WHERE user_id = $1
      RETURNING id
    `;

    const result = await query(sql, [userId]);
    console.log(`Deleted ${result.rowCount} sessions for user ${userId}`);
    return result.rowCount;
  } catch (error) {
    console.error('Delete all sessions error:', error);
    throw error;
  }
};

/**
 * Clean expired sessions
 */
const cleanExpiredSessions = async () => {
  try {
    const sql = `
      DELETE FROM sessions
      WHERE expires_at < NOW()
      RETURNING id
    `;

    const result = await query(sql);
    if (result.rowCount > 0) {
      console.log(`Cleaned ${result.rowCount} expired sessions`);
    }
    return result.rowCount;
  } catch (error) {
    console.error('Clean expired sessions error:', error);
    return 0;
  }
};

// ==================== Controller Functions ====================

/**
 * Register a new user
 * POST /api/auth/register
 * @body { email, password, name?, language_preference? }
 */
const register = async (req, res) => {
  try {
    const { email, password, name, language_preference } = req.body;

    console.log(`[REGISTER] Attempting registration for email: ${email}`);

    // Validate input
    const validation = validateRegistration(req.body);
    if (!validation.valid) {
      console.log(`[REGISTER] Validation failed:`, validation.errors);
      return res.status(400).json({
        error: 'Validation Error',
        errors: validation.errors
      });
    }

    // Sanitize inputs
    const sanitizedEmail = sanitizeString(email).toLowerCase();
    const sanitizedName = name ? sanitizeString(name) : null;

    // Check if email already exists
    const emailExists = await User.emailExists(sanitizedEmail);
    if (emailExists) {
      console.log(`[REGISTER] Email already exists: ${sanitizedEmail}`);
      return res.status(409).json({
        error: 'Conflict',
        message: 'Email already registered',
        code: 'EMAIL_EXISTS'
      });
    }

    // Hash password
    console.log(`[REGISTER] Hashing password...`);
    const password_hash = await bcrypt.hash(password, SALT_ROUNDS);

    // Create user
    console.log(`[REGISTER] Creating user...`);
    const user = await User.create({
      email: sanitizedEmail,
      password_hash,
      name: sanitizedName,
      language_preference: language_preference || 'zh'
    });

    console.log(`[REGISTER] User created successfully, ID: ${user.id}`);

    // Generate tokens
    const tokens = generateTokenPair(user);

    // Store session with device info
    await createSession(user.id, tokens, req);

    // Remove sensitive data
    delete user.password_hash;

    console.log(`[REGISTER] Registration successful for user: ${user.email}`);

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        language_preference: user.language_preference,
        subscription_type: user.subscription_type,
        created_at: user.created_at
      },
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken
    });
  } catch (error) {
    console.error('[REGISTER] Error:', error);

    // Handle specific database errors
    if (error.code === '23505') { // Unique violation
      return res.status(409).json({
        error: 'Conflict',
        message: 'Email already registered',
        code: 'EMAIL_EXISTS'
      });
    }

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to register user',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Login user
 * POST /api/auth/login
 * @body { email, password }
 */
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log(`[LOGIN] Attempting login for email: ${email}`);

    // Validate input
    const validation = validateLogin(req.body);
    if (!validation.valid) {
      console.log(`[LOGIN] Validation failed:`, validation.errors);
      return res.status(400).json({
        error: 'Validation Error',
        errors: validation.errors
      });
    }

    // Find user
    const sanitizedEmail = sanitizeString(email).toLowerCase();
    const user = await User.findByEmail(sanitizedEmail);

    if (!user) {
      console.log(`[LOGIN] User not found: ${sanitizedEmail}`);
      // Use same message as wrong password for security
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS'
      });
    }

    // Check if account is active
    if (!user.is_active) {
      console.log(`[LOGIN] Account deactivated: ${sanitizedEmail}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Account is deactivated. Please contact support.',
        code: 'ACCOUNT_DEACTIVATED'
      });
    }

    // Verify password
    console.log(`[LOGIN] Verifying password for user: ${user.id}`);
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);

    if (!isPasswordValid) {
      console.log(`[LOGIN] Invalid password for user: ${user.id}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Invalid email or password',
        code: 'INVALID_CREDENTIALS'
      });
    }

    // Generate tokens
    console.log(`[LOGIN] Generating tokens for user: ${user.id}`);
    const tokens = generateTokenPair(user);

    // Store session with device info
    await createSession(user.id, tokens, req);

    // Update last login timestamp
    await User.updateLastLogin(user.id);

    // Clean up old expired sessions periodically
    if (Math.random() < 0.1) { // 10% chance
      cleanExpiredSessions().catch(err =>
        console.error('Failed to clean expired sessions:', err)
      );
    }

    // Remove sensitive data
    delete user.password_hash;

    console.log(`[LOGIN] Login successful for user: ${user.email}`);

    res.json({
      success: true,
      message: 'Login successful',
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        language_preference: user.language_preference,
        subscription_type: user.subscription_type,
        subscription_expires_at: user.subscription_expires_at,
        email_verified: user.email_verified,
        created_at: user.created_at,
        last_login: new Date().toISOString()
      },
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken
    });
  } catch (error) {
    console.error('[LOGIN] Error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to login',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Refresh access token
 * POST /api/auth/refresh
 * @body { refreshToken }
 */
const refresh = async (req, res) => {
  try {
    const { refreshToken } = req.body;

    console.log(`[REFRESH] Token refresh requested`);

    if (!refreshToken) {
      console.log(`[REFRESH] No refresh token provided`);
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Refresh token is required',
        code: 'MISSING_REFRESH_TOKEN'
      });
    }

    // Verify refresh token
    let decoded;
    try {
      decoded = jwtVerifyToken(refreshToken);
      console.log(`[REFRESH] Token verified for user: ${decoded.userId}`);
    } catch (verifyError) {
      console.log(`[REFRESH] Token verification failed:`, verifyError.message);

      if (verifyError.message === 'Token expired') {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'Refresh token expired',
          code: 'REFRESH_TOKEN_EXPIRED'
        });
      }

      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Invalid refresh token',
        code: 'INVALID_REFRESH_TOKEN'
      });
    }

    // Find user
    const user = await User.findById(decoded.userId);

    if (!user) {
      console.log(`[REFRESH] User not found: ${decoded.userId}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Invalid refresh token - user not found',
        code: 'USER_NOT_FOUND'
      });
    }

    if (!user.is_active) {
      console.log(`[REFRESH] User account deactivated: ${decoded.userId}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Account is deactivated',
        code: 'ACCOUNT_DEACTIVATED'
      });
    }

    // Verify session exists in database
    const sessionExists = await checkSessionExists(user.id, refreshToken);
    if (!sessionExists) {
      console.log(`[REFRESH] Session not found or expired for user: ${user.id}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Session expired or invalid. Please login again.',
        code: 'SESSION_EXPIRED'
      });
    }

    // Generate new tokens
    console.log(`[REFRESH] Generating new tokens for user: ${user.id}`);
    const tokens = generateTokenPair(user);

    // Update session with new tokens
    await updateSession(user.id, refreshToken, tokens);

    console.log(`[REFRESH] Token refresh successful for user: ${user.email}`);

    res.json({
      success: true,
      message: 'Token refreshed successfully',
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken
    });
  } catch (error) {
    console.error('[REFRESH] Error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to refresh token',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Logout user
 * POST /api/auth/logout
 * @body { refreshToken?, logoutAll? }
 */
const logout = async (req, res) => {
  try {
    const { refreshToken, logoutAll } = req.body;
    const userId = req.user.id;

    console.log(`[LOGOUT] Logout requested for user: ${userId}, logoutAll: ${logoutAll}`);

    if (logoutAll) {
      // Logout from all devices
      const deletedCount = await deleteAllUserSessions(userId);
      console.log(`[LOGOUT] Logged out from all devices for user: ${userId}`);

      return res.json({
        success: true,
        message: `Logged out from all devices successfully`,
        sessionsDeleted: deletedCount
      });
    }

    if (refreshToken) {
      // Delete specific session
      const deleted = await deleteSession(userId, refreshToken);

      if (deleted > 0) {
        console.log(`[LOGOUT] Session deleted for user: ${userId}`);
        return res.json({
          success: true,
          message: 'Logged out successfully'
        });
      } else {
        console.log(`[LOGOUT] Session not found for user: ${userId}`);
        return res.status(404).json({
          error: 'Not Found',
          message: 'Session not found',
          code: 'SESSION_NOT_FOUND'
        });
      }
    }

    // If no refresh token provided, still return success
    // (user might have already cleared local storage)
    console.log(`[LOGOUT] No refresh token provided, returning success`);
    res.json({
      success: true,
      message: 'Logged out successfully'
    });
  } catch (error) {
    console.error('[LOGOUT] Error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to logout',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Verify JWT token and return user info
 * POST /api/auth/verify
 * @body { token }
 */
const verifyToken = async (req, res) => {
  try {
    const { token } = req.body;

    console.log(`[VERIFY] Token verification requested`);

    if (!token) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'Token is required',
        code: 'MISSING_TOKEN'
      });
    }

    // Verify token
    let decoded;
    try {
      decoded = jwtVerifyToken(token);
      console.log(`[VERIFY] Token verified for user: ${decoded.userId}`);
    } catch (verifyError) {
      console.log(`[VERIFY] Token verification failed:`, verifyError.message);

      if (verifyError.message === 'Token expired') {
        return res.status(401).json({
          error: 'Unauthorized',
          message: 'Token expired',
          code: 'TOKEN_EXPIRED',
          valid: false
        });
      }

      return res.status(401).json({
        error: 'Unauthorized',
        message: 'Invalid token',
        code: 'INVALID_TOKEN',
        valid: false
      });
    }

    // Find user
    const user = await User.findById(decoded.userId);

    if (!user) {
      console.log(`[VERIFY] User not found: ${decoded.userId}`);
      return res.status(401).json({
        error: 'Unauthorized',
        message: 'User not found',
        code: 'USER_NOT_FOUND',
        valid: false
      });
    }

    if (!user.is_active) {
      console.log(`[VERIFY] User account deactivated: ${decoded.userId}`);
      return res.status(403).json({
        error: 'Forbidden',
        message: 'Account is deactivated',
        code: 'ACCOUNT_DEACTIVATED',
        valid: false
      });
    }

    console.log(`[VERIFY] Token valid for user: ${user.email}`);

    // Return user info
    res.json({
      success: true,
      valid: true,
      message: 'Token is valid',
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        language_preference: user.language_preference,
        subscription_type: user.subscription_type,
        subscription_expires_at: user.subscription_expires_at,
        email_verified: user.email_verified
      },
      tokenData: {
        userId: decoded.userId,
        email: decoded.email,
        subscriptionType: decoded.subscriptionType,
        iat: decoded.iat,
        exp: decoded.exp
      }
    });
  } catch (error) {
    console.error('[VERIFY] Error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to verify token',
      valid: false,
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Get user profile
 * GET /api/auth/profile
 */
const getProfile = async (req, res) => {
  try {
    const userId = req.user.id;

    console.log(`[PROFILE] Fetching profile for user: ${userId}`);

    const user = await User.findById(userId);

    if (!user) {
      console.log(`[PROFILE] User not found: ${userId}`);
      return res.status(404).json({
        error: 'Not Found',
        message: 'User not found'
      });
    }

    // Get user learning statistics
    const stats = await User.getStats(userId);

    console.log(`[PROFILE] Profile retrieved for user: ${user.email}`);

    res.json({
      success: true,
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        language_preference: user.language_preference,
        subscription_type: user.subscription_type,
        subscription_expires_at: user.subscription_expires_at,
        email_verified: user.email_verified,
        profile_image_url: user.profile_image_url,
        created_at: user.created_at,
        last_login: user.last_login
      },
      stats: stats || {
        lessons_completed: 0,
        words_mastered: 0,
        avg_quiz_score: null,
        total_study_time_seconds: 0,
        last_study_date: null,
        study_days_count: 0
      }
    });
  } catch (error) {
    console.error('[PROFILE] Error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to get profile',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

/**
 * Update user profile
 * PUT /api/auth/profile
 * @body { name?, language_preference?, profile_image_url? }
 */
const updateProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const { name, language_preference, profile_image_url } = req.body;

    console.log(`[UPDATE_PROFILE] Updating profile for user: ${userId}`);

    // Validate language preference if provided
    if (language_preference && !['zh', 'en', 'ko'].includes(language_preference)) {
      return res.status(400).json({
        error: 'Validation Error',
        message: 'Invalid language preference. Must be one of: zh, en, ko'
      });
    }

    // Build updates object
    const updates = {};
    if (name !== undefined) {
      const sanitizedName = sanitizeString(name);
      if (sanitizedName.length > 100) {
        return res.status(400).json({
          error: 'Validation Error',
          message: 'Name must be less than 100 characters'
        });
      }
      updates.name = sanitizedName;
    }

    if (language_preference !== undefined) {
      updates.language_preference = language_preference;
    }

    if (profile_image_url !== undefined) {
      updates.profile_image_url = sanitizeString(profile_image_url);
    }

    // Check if there are any updates
    if (Object.keys(updates).length === 0) {
      return res.status(400).json({
        error: 'Bad Request',
        message: 'No valid fields to update'
      });
    }

    // Update user
    const updatedUser = await User.update(userId, updates);

    console.log(`[UPDATE_PROFILE] Profile updated for user: ${userId}`);

    res.json({
      success: true,
      message: 'Profile updated successfully',
      user: updatedUser
    });
  } catch (error) {
    console.error('[UPDATE_PROFILE] Error:', error);

    res.status(500).json({
      error: 'Internal Server Error',
      message: 'Failed to update profile',
      ...(process.env.NODE_ENV === 'development' && { details: error.message })
    });
  }
};

// ==================== Export Functions ====================

module.exports = {
  register,
  login,
  refresh,
  logout,
  verifyToken,
  getProfile,
  updateProfile
};
