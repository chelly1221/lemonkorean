const Lesson = require('../models/lesson.model');
const Vocabulary = require('../models/vocabulary.model');
const { cacheHelpers } = require('../config/redis');
const { invalidateLessonCaches, invalidateLessonListCaches, invalidateVocabularyCaches } = require('../utils/cache-invalidation');

/**
 * Content Management Service
 * Business logic for lesson and vocabulary management
 */

// ==================== Lesson Management ====================

/**
 * List lessons with pagination and filtering
 * @param {Object} options - Query options
 * @returns {Object} Paginated lessons
 */
const listLessons = async (options = {}) => {
  try {
    console.log('[CONTENT_SERVICE] Listing lessons with options:', options);

    // Try to get from cache
    const cacheKey = `admin:lessons:list:${JSON.stringify(options)}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log('[CONTENT_SERVICE] Returning cached lesson list');
      return cached;
    }

    // Get from database
    const result = await Lesson.getAll(options);

    // Cache for 2 minutes
    await cacheHelpers.set(cacheKey, result, 120);

    return result;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error listing lessons:', error);
    throw error;
  }
};

/**
 * Get lesson by ID with full content
 * @param {number} lessonId - Lesson ID
 * @returns {Object} Lesson with content
 */
const getLessonById = async (lessonId) => {
  try {
    console.log(`[CONTENT_SERVICE] Getting lesson: ${lessonId}`);

    const lesson = await Lesson.findById(lessonId);

    if (!lesson) {
      throw new Error('Lesson not found');
    }

    return lesson;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error getting lesson:', error);
    throw error;
  }
};

/**
 * Create new lesson
 * @param {Object} lessonData - Lesson data
 * @returns {Object} Created lesson
 */
const createLesson = async (lessonData) => {
  try {
    console.log('[CONTENT_SERVICE] Creating lesson:', lessonData.title_ko);

    const lesson = await Lesson.create(lessonData);

    // Invalidate list caches
    await invalidateLessonListCaches();

    return lesson;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error creating lesson:', error);
    throw error;
  }
};

/**
 * Update lesson
 * @param {number} lessonId - Lesson ID
 * @param {Object} updates - Fields to update
 * @returns {Object} Updated lesson
 */
const updateLesson = async (lessonId, updates) => {
  try {
    console.log(`[CONTENT_SERVICE] Updating lesson ${lessonId}:`, Object.keys(updates));

    const lesson = await Lesson.update(lessonId, updates);

    // Invalidate caches
    await invalidateLessonCaches(lessonId);
    await invalidateLessonListCaches();

    return lesson;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error updating lesson:', error);
    throw error;
  }
};

/**
 * Delete lesson
 * @param {number} lessonId - Lesson ID
 * @returns {boolean} Success
 */
const deleteLesson = async (lessonId) => {
  try {
    console.log(`[CONTENT_SERVICE] Deleting lesson: ${lessonId}`);

    const success = await Lesson.deleteLesson(lessonId);

    // Invalidate caches
    await invalidateLessonCaches(lessonId);
    await invalidateLessonListCaches();

    return success;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error deleting lesson:', error);
    throw error;
  }
};

/**
 * Publish lesson (change status from draft to published)
 * @param {number} lessonId - Lesson ID
 * @returns {Object} Updated lesson
 */
const publishLesson = async (lessonId) => {
  try {
    console.log(`[CONTENT_SERVICE] Publishing lesson: ${lessonId}`);

    const lesson = await Lesson.update(lessonId, { status: 'published' });

    // Invalidate caches
    await invalidateLessonCaches(lessonId);
    await invalidateLessonListCaches();

    return lesson;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error publishing lesson:', error);
    throw error;
  }
};

/**
 * Unpublish lesson (change status from published to draft)
 * @param {number} lessonId - Lesson ID
 * @returns {Object} Updated lesson
 */
const unpublishLesson = async (lessonId) => {
  try {
    console.log(`[CONTENT_SERVICE] Unpublishing lesson: ${lessonId}`);

    const lesson = await Lesson.update(lessonId, { status: 'draft' });

    // Invalidate caches
    await invalidateLessonCaches(lessonId);
    await invalidateLessonListCaches();

    return lesson;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error unpublishing lesson:', error);
    throw error;
  }
};

/**
 * Bulk publish lessons
 * @param {Array<number>} lessonIds - Lesson IDs to publish
 * @returns {number} Number of lessons published
 */
const bulkPublishLessons = async (lessonIds) => {
  try {
    console.log(`[CONTENT_SERVICE] Bulk publishing ${lessonIds.length} lessons`);

    const count = await Lesson.bulkPublish(lessonIds);

    // Invalidate all lesson caches
    await invalidateLessonListCaches();
    for (const lessonId of lessonIds) {
      await invalidateLessonCaches(lessonId);
    }

    return count;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error bulk publishing lessons:', error);
    throw error;
  }
};

/**
 * Bulk delete lessons
 * @param {Array<number>} lessonIds - Lesson IDs to delete
 * @returns {number} Number of lessons deleted
 */
const bulkDeleteLessons = async (lessonIds) => {
  try {
    console.log(`[CONTENT_SERVICE] Bulk deleting ${lessonIds.length} lessons`);

    const count = await Lesson.bulkDelete(lessonIds);

    // Invalidate all lesson caches
    await invalidateLessonListCaches();
    for (const lessonId of lessonIds) {
      await invalidateLessonCaches(lessonId);
    }

    return count;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error bulk deleting lessons:', error);
    throw error;
  }
};

// ==================== Vocabulary Management ====================

/**
 * List vocabulary with pagination and filtering
 * @param {Object} options - Query options
 * @returns {Object} Paginated vocabulary
 */
const listVocabulary = async (options = {}) => {
  try {
    console.log('[CONTENT_SERVICE] Listing vocabulary with options:', options);

    // Try to get from cache
    const cacheKey = `admin:vocabulary:list:${JSON.stringify(options)}`;
    const cached = await cacheHelpers.get(cacheKey);

    if (cached) {
      console.log('[CONTENT_SERVICE] Returning cached vocabulary list');
      return cached;
    }

    // Get from database
    const result = await Vocabulary.getAll(options);

    // Cache for 5 minutes
    await cacheHelpers.set(cacheKey, result, 300);

    return result;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error listing vocabulary:', error);
    throw error;
  }
};

/**
 * Get vocabulary by ID
 * @param {number} vocabId - Vocabulary ID
 * @returns {Object} Vocabulary entry
 */
const getVocabularyById = async (vocabId) => {
  try {
    console.log(`[CONTENT_SERVICE] Getting vocabulary: ${vocabId}`);

    const vocab = await Vocabulary.findById(vocabId);

    if (!vocab) {
      throw new Error('Vocabulary not found');
    }

    return vocab;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error getting vocabulary:', error);
    throw error;
  }
};

/**
 * Create new vocabulary entry
 * @param {Object} vocabData - Vocabulary data
 * @returns {Object} Created vocabulary
 */
const createVocabulary = async (vocabData) => {
  try {
    console.log('[CONTENT_SERVICE] Creating vocabulary:', vocabData.korean);

    const vocab = await Vocabulary.create(vocabData);

    // Invalidate list caches
    await invalidateVocabularyCaches();

    return vocab;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error creating vocabulary:', error);
    throw error;
  }
};

/**
 * Update vocabulary
 * @param {number} vocabId - Vocabulary ID
 * @param {Object} updates - Fields to update
 * @returns {Object} Updated vocabulary
 */
const updateVocabulary = async (vocabId, updates) => {
  try {
    console.log(`[CONTENT_SERVICE] Updating vocabulary ${vocabId}:`, Object.keys(updates));

    const vocab = await Vocabulary.update(vocabId, updates);

    // Invalidate caches
    await invalidateVocabularyCaches(vocabId);

    return vocab;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error updating vocabulary:', error);
    throw error;
  }
};

/**
 * Delete vocabulary
 * @param {number} vocabId - Vocabulary ID
 * @returns {boolean} Success
 */
const deleteVocabulary = async (vocabId) => {
  try {
    console.log(`[CONTENT_SERVICE] Deleting vocabulary: ${vocabId}`);

    const success = await Vocabulary.deleteVocabulary(vocabId);

    // Invalidate caches
    await invalidateVocabularyCaches(vocabId);

    return success;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error deleting vocabulary:', error);
    throw error;
  }
};

/**
 * Bulk delete vocabulary
 * @param {Array<number>} vocabIds - Vocabulary IDs to delete
 * @returns {number} Number of vocabulary entries deleted
 */
const bulkDeleteVocabulary = async (vocabIds) => {
  try {
    console.log(`[CONTENT_SERVICE] Bulk deleting ${vocabIds.length} vocabulary entries`);

    const count = await Vocabulary.bulkDelete(vocabIds);

    // Invalidate all vocabulary caches
    await invalidateVocabularyCaches();

    return count;
  } catch (error) {
    console.error('[CONTENT_SERVICE] Error bulk deleting vocabulary:', error);
    throw error;
  }
};

module.exports = {
  // Lessons
  listLessons,
  getLessonById,
  createLesson,
  updateLesson,
  deleteLesson,
  publishLesson,
  unpublishLesson,
  bulkPublishLessons,
  bulkDeleteLessons,

  // Vocabulary
  listVocabulary,
  getVocabularyById,
  createVocabulary,
  updateVocabulary,
  deleteVocabulary,
  bulkDeleteVocabulary
};
