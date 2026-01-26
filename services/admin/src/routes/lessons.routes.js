const express = require('express');
const router = express.Router();
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');
const { auditLog } = require('../middleware/audit.middleware');
const lessonsController = require('../controllers/lessons.controller');

/**
 * Lesson Management Routes
 * All routes require authentication and admin privileges
 * Audit logging is applied to all mutation operations
 */

// List lessons
router.get(
  '/',
  requireAuth,
  requireAdmin,
  lessonsController.listLessons
);

// Get lesson by ID
router.get(
  '/:id',
  requireAuth,
  requireAdmin,
  lessonsController.getLessonById
);

// Create lesson
router.post(
  '/',
  requireAuth,
  requireAdmin,
  auditLog('lesson.create', 'lesson'),
  lessonsController.createLesson
);

// Update lesson
router.put(
  '/:id',
  requireAuth,
  requireAdmin,
  auditLog('lesson.update', 'lesson'),
  lessonsController.updateLesson
);

// Delete lesson
router.delete(
  '/:id',
  requireAuth,
  requireAdmin,
  auditLog('lesson.delete', 'lesson'),
  lessonsController.deleteLesson
);

// Publish lesson
router.put(
  '/:id/publish',
  requireAuth,
  requireAdmin,
  auditLog('lesson.publish', 'lesson'),
  lessonsController.publishLesson
);

// Unpublish lesson
router.put(
  '/:id/unpublish',
  requireAuth,
  requireAdmin,
  auditLog('lesson.unpublish', 'lesson'),
  lessonsController.unpublishLesson
);

// Bulk publish lessons
router.post(
  '/bulk-publish',
  requireAuth,
  requireAdmin,
  auditLog('lesson.bulk_publish', 'lesson'),
  lessonsController.bulkPublish
);

// Bulk delete lessons
router.post(
  '/bulk-delete',
  requireAuth,
  requireAdmin,
  auditLog('lesson.bulk_delete', 'lesson'),
  lessonsController.bulkDelete
);

module.exports = router;
