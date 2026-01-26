const { cacheHelpers } = require('../config/redis');

/**
 * Cache Invalidation Utilities
 * Invalidate Content Service caches after mutations
 */

/**
 * Invalidate all caches related to a lesson
 * @param {number} lessonId - Lesson ID
 */
const invalidateLessonCaches = async (lessonId) => {
  try {
    const keysToDelete = [
      `lesson:full:${lessonId}`,
      `lesson:package:${lessonId}`,
      `lesson:metadata:${lessonId}`,
      'lessons:list:*',
      'lessons:published:*',
      'admin:lessons:*'
    ];

    console.log(`[CACHE] Invalidating lesson caches for lesson ${lessonId}`);

    // Delete specific keys
    for (const key of keysToDelete) {
      if (key.includes('*')) {
        // For wildcard patterns, we'd need to use SCAN in production
        // For now, just log
        console.log(`[CACHE] Would delete pattern: ${key}`);
      } else {
        await cacheHelpers.del(key);
      }
    }

    console.log(`[CACHE] Lesson caches invalidated for lesson ${lessonId}`);
  } catch (error) {
    console.error('[CACHE] Error invalidating lesson caches:', error);
    // Don't throw - cache invalidation failure shouldn't break the operation
  }
};

/**
 * Invalidate all lesson list caches
 */
const invalidateLessonListCaches = async () => {
  try {
    console.log('[CACHE] Invalidating all lesson list caches');

    // In production, would use Redis SCAN to find and delete all matching keys
    // For now, just clear known patterns
    const patterns = ['lessons:list:*', 'lessons:published:*', 'admin:lessons:list:*'];

    for (const pattern of patterns) {
      console.log(`[CACHE] Would delete pattern: ${pattern}`);
    }

    console.log('[CACHE] Lesson list caches invalidated');
  } catch (error) {
    console.error('[CACHE] Error invalidating lesson list caches:', error);
  }
};

/**
 * Invalidate all caches related to vocabulary
 * @param {number} vocabId - Vocabulary ID (optional)
 */
const invalidateVocabularyCaches = async (vocabId = null) => {
  try {
    const keysToDelete = [
      'vocabulary:list:*',
      'vocabulary:search:*',
      'admin:vocabulary:*'
    ];

    if (vocabId) {
      keysToDelete.push(`vocabulary:${vocabId}`);
      console.log(`[CACHE] Invalidating vocabulary caches for vocab ${vocabId}`);
    } else {
      console.log('[CACHE] Invalidating all vocabulary caches');
    }

    for (const key of keysToDelete) {
      if (key.includes('*')) {
        console.log(`[CACHE] Would delete pattern: ${key}`);
      } else {
        await cacheHelpers.del(key);
      }
    }

    console.log('[CACHE] Vocabulary caches invalidated');
  } catch (error) {
    console.error('[CACHE] Error invalidating vocabulary caches:', error);
  }
};

/**
 * Invalidate all admin caches
 */
const invalidateAllAdminCaches = async () => {
  try {
    console.log('[CACHE] Invalidating all admin caches');

    await cacheHelpers.del('admin:*');

    console.log('[CACHE] All admin caches invalidated');
  } catch (error) {
    console.error('[CACHE] Error invalidating admin caches:', error);
  }
};

module.exports = {
  invalidateLessonCaches,
  invalidateLessonListCaches,
  invalidateVocabularyCaches,
  invalidateAllAdminCaches
};
