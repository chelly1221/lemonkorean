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
    const specificKeys = [
      `lesson:full:${lessonId}`,
      `lesson:package:${lessonId}`,
      `lesson:metadata:${lessonId}`
    ];

    const patterns = [
      'lessons:list:*',
      'lessons:published:*',
      'admin:lessons:*'
    ];

    console.log(`[CACHE] Invalidating lesson caches for lesson ${lessonId}`);

    // Delete specific keys
    if (specificKeys.length > 0) {
      await cacheHelpers.del(...specificKeys);
    }

    // Delete pattern-matched keys
    for (const pattern of patterns) {
      await cacheHelpers.delPattern(pattern);
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

    const patterns = ['lessons:list:*', 'lessons:published:*', 'admin:lessons:list:*'];

    for (const pattern of patterns) {
      await cacheHelpers.delPattern(pattern);
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
    const patterns = [
      'vocabulary:list:*',
      'vocabulary:search:*',
      'admin:vocabulary:*'
    ];

    if (vocabId) {
      await cacheHelpers.del(`vocabulary:${vocabId}`);
      console.log(`[CACHE] Invalidating vocabulary caches for vocab ${vocabId}`);
    } else {
      console.log('[CACHE] Invalidating all vocabulary caches');
    }

    // Delete pattern-matched keys
    for (const pattern of patterns) {
      await cacheHelpers.delPattern(pattern);
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

    await cacheHelpers.delPattern('admin:*');

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
