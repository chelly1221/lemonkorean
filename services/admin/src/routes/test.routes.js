const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

/**
 * Test route to verify authentication and authorization
 * GET /api/admin/test/auth - Requires authentication only
 * GET /api/admin/test/admin - Requires authentication + admin privileges
 */

// Test authentication only
router.get('/auth', requireAuth, (req, res) => {
  res.json({
    message: 'Authentication successful',
    user: {
      id: req.user.id,
      email: req.user.email,
      name: req.user.name,
      role: req.user.role
    }
  });
});

// Test admin authorization
router.get('/admin', requireAuth, requireAdmin, (req, res) => {
  res.json({
    message: 'Admin authorization successful',
    user: {
      id: req.user.id,
      email: req.user.email,
      name: req.user.name,
      role: req.user.role,
      isAdmin: req.user.isAdmin
    }
  });
});

module.exports = router;
