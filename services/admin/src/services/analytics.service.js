const { query } = require('../config/database');
const { cacheHelpers } = require('../config/redis');

/**
 * Analytics Service
 * Aggregates statistics for admin dashboard
 */

/**
 * Get dashboard overview statistics
 * @returns {Object} Overview stats
 */
const getDashboardOverview = async () => {
  try {
    console.log('[ANALYTICS_SERVICE] Getting dashboard overview');

    // Try cache first
    const cacheKey = 'admin:analytics:overview';
    const cached = await cacheHelpers.get(cacheKey);
    if (cached) {
      console.log('[ANALYTICS_SERVICE] Returning cached overview');
      return cached;
    }

    // Get all stats in parallel
    const [
      usersStats,
      lessonsStats,
      progressStats,
      vocabularyStats
    ] = await Promise.all([
      getUsersStats(),
      getLessonsStats(),
      getProgressStats(),
      getVocabularyStats()
    ]);

    const overview = {
      users: usersStats,
      lessons: lessonsStats,
      progress: progressStats,
      vocabulary: vocabularyStats,
      generatedAt: new Date().toISOString()
    };

    // Cache for 5 minutes
    await cacheHelpers.set(cacheKey, overview, 300);

    return overview;
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting dashboard overview:', error);
    throw error;
  }
};

/**
 * Get users statistics
 * @returns {Object} User stats
 */
const getUsersStats = async () => {
  try {
    const result = await query(`
      SELECT
        COUNT(*) as total_users,
        COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '7 days') as new_users_7d,
        COUNT(*) FILTER (WHERE created_at >= NOW() - INTERVAL '30 days') as new_users_30d,
        COUNT(*) FILTER (WHERE subscription_type = 'free') as free_users,
        COUNT(*) FILTER (WHERE subscription_type = 'premium') as premium_users,
        COUNT(*) FILTER (WHERE subscription_type = 'lifetime') as lifetime_users,
        COUNT(*) FILTER (WHERE is_active = true) as active_users,
        COUNT(*) FILTER (WHERE is_active = false) as inactive_users
      FROM users
    `);

    return result.rows[0];
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting users stats:', error);
    throw error;
  }
};

/**
 * Get lessons statistics
 * @returns {Object} Lesson stats
 */
const getLessonsStats = async () => {
  try {
    const result = await query(`
      SELECT
        COUNT(*) as total_lessons,
        COUNT(*) FILTER (WHERE status = 'draft') as draft_lessons,
        COUNT(*) FILTER (WHERE status = 'published') as published_lessons,
        COUNT(*) FILTER (WHERE status = 'archived') as archived_lessons,
        COUNT(DISTINCT level) as total_levels,
        AVG(duration_minutes) as avg_duration_minutes,
        SUM(view_count) as total_views,
        SUM(completion_count) as total_completions
      FROM lessons
    `);

    const stats = result.rows[0];

    // Convert numeric values
    return {
      total_lessons: parseInt(stats.total_lessons) || 0,
      draft_lessons: parseInt(stats.draft_lessons) || 0,
      published_lessons: parseInt(stats.published_lessons) || 0,
      archived_lessons: parseInt(stats.archived_lessons) || 0,
      total_levels: parseInt(stats.total_levels) || 0,
      avg_duration_minutes: parseFloat(stats.avg_duration_minutes) || 0,
      total_views: parseInt(stats.total_views) || 0,
      total_completions: parseInt(stats.total_completions) || 0
    };
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting lessons stats:', error);
    throw error;
  }
};

/**
 * Get progress statistics
 * @returns {Object} Progress stats
 */
const getProgressStats = async () => {
  try {
    const result = await query(`
      SELECT
        COUNT(*) as total_progress_entries,
        COUNT(DISTINCT user_id) as users_with_progress,
        COUNT(*) FILTER (WHERE status = 'completed') as completed_entries,
        COUNT(*) FILTER (WHERE status = 'in_progress') as in_progress_entries,
        COUNT(*) FILTER (WHERE completed_at >= NOW() - INTERVAL '7 days') as completions_7d,
        COUNT(*) FILTER (WHERE completed_at >= NOW() - INTERVAL '30 days') as completions_30d,
        AVG(quiz_score) FILTER (WHERE quiz_score IS NOT NULL) as avg_quiz_score
      FROM user_progress
    `);

    const stats = result.rows[0];

    return {
      total_progress_entries: parseInt(stats.total_progress_entries) || 0,
      users_with_progress: parseInt(stats.users_with_progress) || 0,
      completed_entries: parseInt(stats.completed_entries) || 0,
      in_progress_entries: parseInt(stats.in_progress_entries) || 0,
      completions_7d: parseInt(stats.completions_7d) || 0,
      completions_30d: parseInt(stats.completions_30d) || 0,
      avg_quiz_score: parseFloat(stats.avg_quiz_score) || 0
    };
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting progress stats:', error);
    throw error;
  }
};

/**
 * Get vocabulary statistics
 * @returns {Object} Vocabulary stats
 */
const getVocabularyStats = async () => {
  try {
    const result = await query(`
      SELECT
        COUNT(*) as total_vocabulary,
        COUNT(DISTINCT part_of_speech) as total_parts_of_speech,
        COUNT(*) FILTER (WHERE level IS NOT NULL) as vocabulary_with_level,
        AVG(similarity_score) FILTER (WHERE similarity_score IS NOT NULL) as avg_similarity_score
      FROM vocabulary
    `);

    const stats = result.rows[0];

    return {
      total_vocabulary: parseInt(stats.total_vocabulary) || 0,
      total_parts_of_speech: parseInt(stats.total_parts_of_speech) || 0,
      vocabulary_with_level: parseInt(stats.vocabulary_with_level) || 0,
      avg_similarity_score: parseFloat(stats.avg_similarity_score) || 0
    };
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting vocabulary stats:', error);
    throw error;
  }
};

/**
 * Get user analytics with time series data
 * @param {string} period - Time period (7d, 30d, 90d)
 * @returns {Object} User analytics
 */
const getUserAnalytics = async (period = '30d') => {
  try {
    console.log(`[ANALYTICS_SERVICE] Getting user analytics for period: ${period}`);

    const days = period === '7d' ? 7 : period === '90d' ? 90 : 30;

    const result = await query(`
      SELECT
        DATE(created_at) as date,
        COUNT(*) as new_users,
        COUNT(*) FILTER (WHERE subscription_type = 'premium') as premium_signups,
        COUNT(*) FILTER (WHERE subscription_type = 'lifetime') as lifetime_signups
      FROM users
      WHERE created_at >= NOW() - INTERVAL '${days} days'
      GROUP BY DATE(created_at)
      ORDER BY date ASC
    `);

    return {
      period,
      data: result.rows
    };
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting user analytics:', error);
    throw error;
  }
};

/**
 * Get engagement metrics
 * @param {string} period - Time period (7d, 30d, 90d)
 * @returns {Object} Engagement metrics
 */
const getEngagementMetrics = async (period = '30d') => {
  try {
    console.log(`[ANALYTICS_SERVICE] Getting engagement metrics for period: ${period}`);

    const days = period === '7d' ? 7 : period === '90d' ? 90 : 30;

    // Lesson completion trends
    const completionResult = await query(`
      SELECT
        DATE(completed_at) as date,
        COUNT(*) as completions,
        COUNT(DISTINCT user_id) as unique_users,
        AVG(quiz_score) as avg_quiz_score
      FROM user_progress
      WHERE completed_at >= NOW() - INTERVAL '${days} days'
        AND status = 'completed'
      GROUP BY DATE(completed_at)
      ORDER BY date ASC
    `);

    // Most popular lessons
    const popularLessonsResult = await query(`
      SELECT
        l.id,
        l.title_ko,
        l.title_zh,
        l.level,
        COUNT(up.id) as completion_count,
        AVG(up.quiz_score) as avg_quiz_score
      FROM lessons l
      LEFT JOIN user_progress up ON l.id = up.lesson_id
      WHERE up.completed_at >= NOW() - INTERVAL '${days} days'
        AND up.status = 'completed'
      GROUP BY l.id, l.title_ko, l.title_zh, l.level
      ORDER BY completion_count DESC
      LIMIT 10
    `);

    // Lesson completion rate by level
    const completionRateResult = await query(`
      SELECT
        l.level,
        COUNT(DISTINCT l.id) as total_lessons,
        COUNT(DISTINCT up.lesson_id) as completed_lessons,
        ROUND(COUNT(DISTINCT up.lesson_id)::numeric / NULLIF(COUNT(DISTINCT l.id), 0) * 100, 2) as completion_rate
      FROM lessons l
      LEFT JOIN user_progress up ON l.id = up.lesson_id AND up.status = 'completed'
      WHERE l.status = 'published'
      GROUP BY l.level
      ORDER BY l.level ASC
    `);

    return {
      period,
      completionTrends: completionResult.rows,
      popularLessons: popularLessonsResult.rows.map(row => ({
        ...row,
        avg_quiz_score: parseFloat(row.avg_quiz_score) || 0
      })),
      completionRateByLevel: completionRateResult.rows.map(row => ({
        ...row,
        completion_rate: parseFloat(row.completion_rate) || 0
      }))
    };
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting engagement metrics:', error);
    throw error;
  }
};

/**
 * Get content statistics
 * @returns {Object} Content stats
 */
const getContentStats = async () => {
  try {
    console.log('[ANALYTICS_SERVICE] Getting content statistics');

    // Lessons by level
    const lessonsByLevel = await query(`
      SELECT
        level,
        COUNT(*) as lesson_count,
        COUNT(*) FILTER (WHERE status = 'published') as published_count
      FROM lessons
      GROUP BY level
      ORDER BY level ASC
    `);

    // Vocabulary by part of speech
    const vocabularyByPOS = await query(`
      SELECT
        part_of_speech,
        COUNT(*) as word_count
      FROM vocabulary
      WHERE part_of_speech IS NOT NULL
      GROUP BY part_of_speech
      ORDER BY word_count DESC
    `);

    return {
      lessonsByLevel: lessonsByLevel.rows,
      vocabularyByPartOfSpeech: vocabularyByPOS.rows
    };
  } catch (error) {
    console.error('[ANALYTICS_SERVICE] Error getting content stats:', error);
    throw error;
  }
};

module.exports = {
  getDashboardOverview,
  getUserAnalytics,
  getEngagementMetrics,
  getContentStats
};
