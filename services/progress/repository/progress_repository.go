package repository

import (
	"context"
	"database/sql"
	"encoding/json"
	"fmt"
	"time"

	"lemonkorean/progress/models"

	"github.com/go-redis/redis/v8"
)

// ProgressRepository handles database operations for progress
type ProgressRepository struct {
	db    *sql.DB
	redis *redis.Client
}

// NewProgressRepository creates a new progress repository
func NewProgressRepository(db *sql.DB, redisClient *redis.Client) *ProgressRepository {
	return &ProgressRepository{
		db:    db,
		redis: redisClient,
	}
}

// GetRedis returns the Redis client
func (r *ProgressRepository) GetRedis() *redis.Client {
	return r.redis
}

// ================================================================
// USER PROGRESS
// ================================================================

// GetUserProgress retrieves all progress for a user
func (r *ProgressRepository) GetUserProgress(ctx context.Context, userID int64) ([]models.UserProgress, error) {
	query := `
		SELECT id, user_id, lesson_id, status, progress_percent, quiz_score,
		       time_spent_minutes, last_accessed_at, completed_at, created_at, updated_at
		FROM user_progress
		WHERE user_id = $1
		ORDER BY last_accessed_at DESC NULLS LAST, created_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query, userID)
	if err != nil {
		return nil, fmt.Errorf("failed to query user progress: %w", err)
	}
	defer rows.Close()

	var progressList []models.UserProgress
	for rows.Next() {
		var p models.UserProgress
		err := rows.Scan(
			&p.ID, &p.UserID, &p.LessonID, &p.Status, &p.ProgressPercent,
			&p.QuizScore, &p.TimeSpentMinutes, &p.LastAccessedAt, &p.CompletedAt,
			&p.CreatedAt, &p.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan progress: %w", err)
		}
		progressList = append(progressList, p)
	}

	return progressList, nil
}

// GetLessonProgress retrieves progress for a specific lesson
func (r *ProgressRepository) GetLessonProgress(ctx context.Context, userID, lessonID int64) (*models.UserProgress, error) {
	query := `
		SELECT id, user_id, lesson_id, status, progress_percent, quiz_score,
		       time_spent_minutes, last_accessed_at, completed_at, created_at, updated_at
		FROM user_progress
		WHERE user_id = $1 AND lesson_id = $2
	`

	var p models.UserProgress
	err := r.db.QueryRowContext(ctx, query, userID, lessonID).Scan(
		&p.ID, &p.UserID, &p.LessonID, &p.Status, &p.ProgressPercent,
		&p.QuizScore, &p.TimeSpentMinutes, &p.LastAccessedAt, &p.CompletedAt,
		&p.CreatedAt, &p.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get lesson progress: %w", err)
	}

	return &p, nil
}

// CompleteLesson marks a lesson as completed
func (r *ProgressRepository) CompleteLesson(ctx context.Context, req *models.CompleteProgressRequest) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("failed to begin transaction: %w", err)
	}
	defer tx.Rollback()

	now := time.Now()

	// Upsert user_progress
	query := `
		INSERT INTO user_progress (
			user_id, lesson_id, status, progress_percent, quiz_score,
			time_spent_minutes, last_accessed_at, completed_at, created_at, updated_at
		) VALUES ($1, $2, $3, 100, $4, $5, $6, $6, $6, $6)
		ON CONFLICT (user_id, lesson_id)
		DO UPDATE SET
			status = $3,
			progress_percent = 100,
			quiz_score = $4,
			time_spent_minutes = user_progress.time_spent_minutes + $5,
			last_accessed_at = $6,
			completed_at = $6,
			updated_at = $6
	`

	_, err = tx.ExecContext(ctx, query,
		req.UserID, req.LessonID, models.StatusCompleted,
		req.QuizScore, req.TimeSpent, now,
	)
	if err != nil {
		return fmt.Errorf("failed to insert/update progress: %w", err)
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("failed to commit transaction: %w", err)
	}

	// Invalidate cache
	r.invalidateProgressCache(ctx, req.UserID)
	r.invalidateStatsCache(ctx, req.UserID)

	return nil
}

// UpdateProgress updates lesson progress
func (r *ProgressRepository) UpdateProgress(ctx context.Context, req *models.UpdateProgressRequest) error {
	now := time.Now()

	query := `
		INSERT INTO user_progress (
			user_id, lesson_id, status, progress_percent,
			time_spent_minutes, last_accessed_at, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $6, $6)
		ON CONFLICT (user_id, lesson_id)
		DO UPDATE SET
			status = COALESCE($3, user_progress.status),
			progress_percent = $4,
			time_spent_minutes = user_progress.time_spent_minutes + $5,
			last_accessed_at = $6,
			updated_at = $6
	`

	status := req.Status
	if status == "" {
		status = models.StatusInProgress
	}

	_, err := r.db.ExecContext(ctx, query,
		req.UserID, req.LessonID, status, req.ProgressPercent,
		req.TimeSpent, now,
	)

	if err != nil {
		return fmt.Errorf("failed to update progress: %w", err)
	}

	// Invalidate cache
	r.invalidateProgressCache(ctx, req.UserID)
	r.invalidateStatsCache(ctx, req.UserID)

	return nil
}

// ResetLessonProgress resets progress for a lesson
func (r *ProgressRepository) ResetLessonProgress(ctx context.Context, userID, lessonID int64) error {
	query := `
		DELETE FROM user_progress
		WHERE user_id = $1 AND lesson_id = $2
	`

	_, err := r.db.ExecContext(ctx, query, userID, lessonID)
	if err != nil {
		return fmt.Errorf("failed to reset progress: %w", err)
	}

	// Invalidate cache
	r.invalidateProgressCache(ctx, userID)
	r.invalidateStatsCache(ctx, userID)

	return nil
}

// ================================================================
// VOCABULARY PROGRESS
// ================================================================

// GetVocabularyProgress retrieves vocabulary progress for a user
func (r *ProgressRepository) GetVocabularyProgress(ctx context.Context, userID int64, limit int) ([]models.VocabularyProgress, error) {
	query := `
		SELECT id, user_id, vocabulary_id, mastery_level, correct_count,
		       incorrect_count, last_reviewed_at, next_review_at,
		       easiness_factor, repetition_count, interval_days,
		       created_at, updated_at
		FROM vocabulary_progress
		WHERE user_id = $1
		ORDER BY last_reviewed_at DESC NULLS LAST
		LIMIT $2
	`

	rows, err := r.db.QueryContext(ctx, query, userID, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to query vocabulary progress: %w", err)
	}
	defer rows.Close()

	var progressList []models.VocabularyProgress
	for rows.Next() {
		var vp models.VocabularyProgress
		err := rows.Scan(
			&vp.ID, &vp.UserID, &vp.VocabularyID, &vp.MasteryLevel,
			&vp.CorrectCount, &vp.IncorrectCount, &vp.LastReviewedAt,
			&vp.NextReviewAt, &vp.EasinessFactor, &vp.RepetitionCount,
			&vp.IntervalDays, &vp.CreatedAt, &vp.UpdatedAt,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan vocabulary progress: %w", err)
		}
		progressList = append(progressList, vp)
	}

	return progressList, nil
}

// GetVocabularyProgressByID retrieves vocabulary progress for a specific word
func (r *ProgressRepository) GetVocabularyProgressByID(ctx context.Context, userID, vocabularyID int64) (*models.VocabularyProgress, error) {
	query := `
		SELECT id, user_id, vocabulary_id, mastery_level, correct_count,
		       incorrect_count, last_reviewed_at, next_review_at,
		       easiness_factor, repetition_count, interval_days,
		       created_at, updated_at
		FROM vocabulary_progress
		WHERE user_id = $1 AND vocabulary_id = $2
	`

	var vp models.VocabularyProgress
	err := r.db.QueryRowContext(ctx, query, userID, vocabularyID).Scan(
		&vp.ID, &vp.UserID, &vp.VocabularyID, &vp.MasteryLevel,
		&vp.CorrectCount, &vp.IncorrectCount, &vp.LastReviewedAt,
		&vp.NextReviewAt, &vp.EasinessFactor, &vp.RepetitionCount,
		&vp.IntervalDays, &vp.CreatedAt, &vp.UpdatedAt,
	)

	if err == sql.ErrNoRows {
		return nil, nil
	}
	if err != nil {
		return nil, fmt.Errorf("failed to get vocabulary progress by ID: %w", err)
	}

	return &vp, nil
}

// RecordVocabularyPractice records a vocabulary practice result
func (r *ProgressRepository) RecordVocabularyPractice(ctx context.Context, req *models.VocabularyPracticeRequest, srsData map[string]interface{}) error {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return fmt.Errorf("failed to begin transaction: %w", err)
	}
	defer tx.Rollback()

	now := time.Now()

	// Extract SRS data
	masteryLevel := int(srsData["mastery_level"].(float64))
	easinessFactor := srsData["easiness_factor"].(float64)
	intervalDays := int(srsData["interval_days"].(float64))
	repetitionCount := int(srsData["repetition_count"].(float64))
	nextReviewAt := srsData["next_review_at"].(time.Time)

	var correctIncrement, incorrectIncrement int
	if req.IsCorrect {
		correctIncrement = 1
	} else {
		incorrectIncrement = 1
	}

	query := `
		INSERT INTO vocabulary_progress (
			user_id, vocabulary_id, mastery_level, correct_count, incorrect_count,
			last_reviewed_at, next_review_at, easiness_factor, repetition_count,
			interval_days, created_at, updated_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $6, $6)
		ON CONFLICT (user_id, vocabulary_id)
		DO UPDATE SET
			mastery_level = $3,
			correct_count = vocabulary_progress.correct_count + $4,
			incorrect_count = vocabulary_progress.incorrect_count + $5,
			last_reviewed_at = $6,
			next_review_at = $7,
			easiness_factor = $8,
			repetition_count = $9,
			interval_days = $10,
			updated_at = $6
	`

	_, err = tx.ExecContext(ctx, query,
		req.UserID, req.VocabularyID, masteryLevel, correctIncrement, incorrectIncrement,
		now, nextReviewAt, easinessFactor, repetitionCount, intervalDays,
	)

	if err != nil {
		return fmt.Errorf("failed to record vocabulary practice: %w", err)
	}

	if err := tx.Commit(); err != nil {
		return fmt.Errorf("failed to commit transaction: %w", err)
	}

	return nil
}

// RecordVocabularyBatch records multiple vocabulary results from lesson quiz
func (r *ProgressRepository) RecordVocabularyBatch(ctx context.Context, req *models.VocabularyBatchRequest) (int, int, error) {
	tx, err := r.db.BeginTx(ctx, nil)
	if err != nil {
		return 0, 0, fmt.Errorf("failed to begin transaction: %w", err)
	}
	defer tx.Rollback()

	now := time.Now()
	successCount := 0
	failCount := 0

	for _, result := range req.VocabularyResults {
		// Determine mastery level and SRS values based on correctness
		var masteryLevel int
		var correctIncrement, incorrectIncrement int

		if result.IsCorrect {
			masteryLevel = 2 // learning
			correctIncrement = 1
		} else {
			masteryLevel = 1 // seen
			incorrectIncrement = 1
		}

		// SRS initial values
		easinessFactor := 2.5
		intervalDays := 1
		repetitionCount := 1
		nextReviewAt := now.Add(24 * time.Hour)

		query := `
			INSERT INTO vocabulary_progress (
				user_id, vocabulary_id, mastery_level, correct_count, incorrect_count,
				last_reviewed_at, next_review_at, easiness_factor, repetition_count,
				interval_days, created_at, updated_at
			) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $6, $6)
			ON CONFLICT (user_id, vocabulary_id)
			DO UPDATE SET
				mastery_level = GREATEST(vocabulary_progress.mastery_level, $3),
				correct_count = vocabulary_progress.correct_count + $4,
				incorrect_count = vocabulary_progress.incorrect_count + $5,
				last_reviewed_at = $6,
				next_review_at = CASE WHEN $3 > vocabulary_progress.mastery_level THEN $7 ELSE vocabulary_progress.next_review_at END,
				easiness_factor = CASE WHEN $3 > vocabulary_progress.mastery_level THEN $8 ELSE vocabulary_progress.easiness_factor END,
				repetition_count = vocabulary_progress.repetition_count + 1,
				interval_days = CASE WHEN $3 > vocabulary_progress.mastery_level THEN $10 ELSE vocabulary_progress.interval_days END,
				updated_at = $6
		`

		_, err := tx.ExecContext(ctx, query,
			req.UserID, result.VocabularyID, masteryLevel, correctIncrement, incorrectIncrement,
			now, nextReviewAt, easinessFactor, repetitionCount, intervalDays,
		)

		if err != nil {
			failCount++
		} else {
			successCount++
		}
	}

	if err := tx.Commit(); err != nil {
		return 0, 0, fmt.Errorf("failed to commit transaction: %w", err)
	}

	return successCount, failCount, nil
}

// GetReviewSchedule retrieves vocabulary items due for review
func (r *ProgressRepository) GetReviewSchedule(ctx context.Context, userID int64, limit int) ([]models.ReviewItem, error) {
	query := `
		SELECT vp.vocabulary_id, v.korean, v.chinese, v.hanja,
		       vp.mastery_level, vp.next_review_at, vp.interval_days,
		       vp.correct_count, vp.incorrect_count
		FROM vocabulary_progress vp
		JOIN vocabulary v ON v.id = vp.vocabulary_id
		WHERE vp.user_id = $1
		  AND (vp.next_review_at IS NULL OR vp.next_review_at <= NOW())
		ORDER BY vp.next_review_at NULLS FIRST, vp.mastery_level ASC
		LIMIT $2
	`

	rows, err := r.db.QueryContext(ctx, query, userID, limit)
	if err != nil {
		return nil, fmt.Errorf("failed to query review schedule: %w", err)
	}
	defer rows.Close()

	var items []models.ReviewItem
	for rows.Next() {
		var item models.ReviewItem
		err := rows.Scan(
			&item.VocabularyID, &item.Korean, &item.Chinese, &item.Hanja,
			&item.MasteryLevel, &item.NextReviewAt, &item.IntervalDays,
			&item.CorrectCount, &item.IncorrectCount,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan review item: %w", err)
		}
		items = append(items, item)
	}

	return items, nil
}

// ================================================================
// CACHE HELPERS
// ================================================================

func (r *ProgressRepository) invalidateProgressCache(ctx context.Context, userID int64) {
	cacheKey := fmt.Sprintf("progress:user:%d", userID)
	r.redis.Del(ctx, cacheKey)
}

func (r *ProgressRepository) getCachedProgress(ctx context.Context, userID int64) ([]models.UserProgress, error) {
	cacheKey := fmt.Sprintf("progress:user:%d", userID)
	data, err := r.redis.Get(ctx, cacheKey).Result()
	if err == redis.Nil {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	var progress []models.UserProgress
	if err := json.Unmarshal([]byte(data), &progress); err != nil {
		return nil, err
	}

	return progress, nil
}

func (r *ProgressRepository) cacheProgress(ctx context.Context, userID int64, progress []models.UserProgress) error {
	cacheKey := fmt.Sprintf("progress:user:%d", userID)
	data, err := json.Marshal(progress)
	if err != nil {
		return err
	}

	return r.redis.Set(ctx, cacheKey, data, 1*time.Hour).Err()
}

// Stats cache helpers
func (r *ProgressRepository) invalidateStatsCache(ctx context.Context, userID int64) {
	cacheKey := fmt.Sprintf("stats:user:%d", userID)
	r.redis.Del(ctx, cacheKey)
}

func (r *ProgressRepository) getCachedStats(ctx context.Context, userID int64) (*models.UserStats, error) {
	cacheKey := fmt.Sprintf("stats:user:%d", userID)
	data, err := r.redis.Get(ctx, cacheKey).Result()
	if err == redis.Nil {
		return nil, nil
	}
	if err != nil {
		return nil, err
	}

	var stats models.UserStats
	if err := json.Unmarshal([]byte(data), &stats); err != nil {
		return nil, err
	}

	return &stats, nil
}

func (r *ProgressRepository) cacheStats(ctx context.Context, userID int64, stats *models.UserStats) error {
	cacheKey := fmt.Sprintf("stats:user:%d", userID)
	data, err := json.Marshal(stats)
	if err != nil {
		return err
	}

	return r.redis.Set(ctx, cacheKey, data, 5*time.Minute).Err()
}

// ================================================================
// LEARNING SESSIONS
// ================================================================

// StartSession creates a new learning session
func (r *ProgressRepository) StartSession(ctx context.Context, req *models.StartSessionRequest) (int64, error) {
	query := `
		INSERT INTO learning_sessions (
			user_id, lesson_id, session_type, device_type, started_at, created_at, updated_at
		) VALUES ($1, $2, $3, $4, NOW(), NOW(), NOW())
		RETURNING id
	`

	var sessionID int64
	err := r.db.QueryRowContext(ctx, query,
		req.UserID, req.LessonID, req.SessionType, req.DeviceType,
	).Scan(&sessionID)

	if err != nil {
		return 0, fmt.Errorf("failed to start session: %w", err)
	}

	return sessionID, nil
}

// EndSession ends a learning session
func (r *ProgressRepository) EndSession(ctx context.Context, req *models.EndSessionRequest) error {
	now := time.Now()

	query := `
		UPDATE learning_sessions
		SET ended_at = $1,
		    duration_minutes = EXTRACT(EPOCH FROM ($1 - started_at)) / 60,
		    items_completed = $2,
		    correct_answers = $3,
		    total_answers = $4,
		    updated_at = $1
		WHERE id = $5 AND ended_at IS NULL
	`

	result, err := r.db.ExecContext(ctx, query,
		now, req.ItemsCompleted, req.CorrectAnswers, req.TotalAnswers, req.SessionID,
	)

	if err != nil {
		return fmt.Errorf("failed to end session: %w", err)
	}

	rowsAffected, _ := result.RowsAffected()
	if rowsAffected == 0 {
		return fmt.Errorf("session not found or already ended")
	}

	return nil
}

// GetSessionStats retrieves session statistics for a user
func (r *ProgressRepository) GetSessionStats(ctx context.Context, userID int64) (*models.SessionStats, error) {
	query := `
		SELECT
			COUNT(*) as total_sessions,
			COALESCE(SUM(duration_minutes), 0) as total_minutes,
			COALESCE(AVG(duration_minutes), 0) as average_duration,
			COALESCE(SUM(items_completed), 0) as total_items,
			CASE
				WHEN SUM(total_answers) > 0
				THEN (SUM(correct_answers)::float / SUM(total_answers)::float * 100)
				ELSE 0
			END as accuracy_rate,
			MAX(started_at) as last_session_at,
			COUNT(*) FILTER (WHERE started_at >= NOW() - INTERVAL '7 days') as sessions_this_week,
			COALESCE(SUM(duration_minutes) FILTER (WHERE started_at >= NOW() - INTERVAL '7 days'), 0) as minutes_this_week
		FROM learning_sessions
		WHERE user_id = $1 AND ended_at IS NOT NULL
	`

	var stats models.SessionStats
	stats.UserID = userID

	err := r.db.QueryRowContext(ctx, query, userID).Scan(
		&stats.TotalSessions,
		&stats.TotalMinutes,
		&stats.AverageDuration,
		&stats.TotalItemsCompleted,
		&stats.AccuracyRate,
		&stats.LastSessionAt,
		&stats.SessionsThisWeek,
		&stats.MinutesThisWeek,
	)

	if err != nil {
		return nil, fmt.Errorf("failed to get session stats: %w", err)
	}

	return &stats, nil
}

// ================================================================
// USER STATISTICS
// ================================================================

// GetUserStats retrieves overall statistics for a user
func (r *ProgressRepository) GetUserStats(ctx context.Context, userID int64) (*models.UserStats, error) {
	// Check cache first
	cachedStats, err := r.getCachedStats(ctx, userID)
	if err == nil && cachedStats != nil {
		return cachedStats, nil
	}

	query := `
		SELECT
			COUNT(DISTINCT lesson_id) as total_lessons,
			COUNT(*) FILTER (WHERE status = 'completed') as completed_lessons,
			COUNT(*) FILTER (WHERE status = 'in_progress') as in_progress_lessons,
			COALESCE(SUM(time_spent_minutes), 0) as total_time,
			COALESCE(AVG(quiz_score), 0) as average_score,
			MAX(last_accessed_at) as last_studied_at,
			COUNT(DISTINCT DATE(completed_at)) FILTER (WHERE status = 'completed') as study_days
		FROM user_progress
		WHERE user_id = $1
	`

	var stats models.UserStats
	stats.UserID = userID

	err = r.db.QueryRowContext(ctx, query, userID).Scan(
		&stats.TotalLessons,
		&stats.CompletedLessons,
		&stats.InProgressLessons,
		&stats.TotalTimeMinutes,
		&stats.AverageQuizScore,
		&stats.LastStudiedAt,
		&stats.StudyDays,
	)

	if err != nil {
		return nil, fmt.Errorf("failed to get user stats: %w", err)
	}

	// Get vocabulary stats
	vocabQuery := `
		SELECT
			COUNT(*) FILTER (WHERE mastery_level >= 3) as mastered,
			COUNT(*) FILTER (WHERE mastery_level < 3) as learning
		FROM vocabulary_progress
		WHERE user_id = $1
	`

	err = r.db.QueryRowContext(ctx, vocabQuery, userID).Scan(
		&stats.VocabularyMastered,
		&stats.VocabularyLearning,
	)

	if err != nil {
		return nil, fmt.Errorf("failed to get vocabulary stats: %w", err)
	}

	// Calculate streaks (simplified)
	stats.CurrentStreak = r.calculateCurrentStreak(ctx, userID)
	stats.LongestStreak = r.calculateLongestStreak(ctx, userID)

	// Cache the stats
	_ = r.cacheStats(ctx, userID, &stats)

	return &stats, nil
}

// GetWeeklyStats retrieves weekly statistics
func (r *ProgressRepository) GetWeeklyStats(ctx context.Context, userID int64, weeks int) ([]models.WeeklyStats, error) {
	if weeks <= 0 {
		weeks = 4 // Default to 4 weeks
	}

	query := `
		SELECT
			TO_CHAR(completed_at, 'IYYY-IW') as week,
			COUNT(*) as lessons_completed,
			COALESCE(SUM(time_spent_minutes), 0) as time_spent,
			COALESCE(AVG(quiz_score), 0) as average_score,
			COUNT(DISTINCT DATE(completed_at)) as days_active
		FROM user_progress
		WHERE user_id = $1
		  AND status = 'completed'
		  AND completed_at >= NOW() - INTERVAL '1 week' * $2
		GROUP BY TO_CHAR(completed_at, 'IYYY-IW')
		ORDER BY week DESC
	`

	rows, err := r.db.QueryContext(ctx, query, userID, weeks)
	if err != nil {
		return nil, fmt.Errorf("failed to query weekly stats: %w", err)
	}
	defer rows.Close()

	var weeklyStats []models.WeeklyStats
	for rows.Next() {
		var ws models.WeeklyStats
		err := rows.Scan(
			&ws.Week,
			&ws.LessonsCompleted,
			&ws.TimeSpentMinutes,
			&ws.AverageScore,
			&ws.DaysActive,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan weekly stats: %w", err)
		}
		weeklyStats = append(weeklyStats, ws)
	}

	return weeklyStats, nil
}

// calculateCurrentStreak calculates the current daily study streak
func (r *ProgressRepository) calculateCurrentStreak(ctx context.Context, userID int64) int {
	query := `
		WITH daily_activity AS (
			SELECT DISTINCT DATE(last_accessed_at) as study_date
			FROM user_progress
			WHERE user_id = $1 AND last_accessed_at IS NOT NULL
			ORDER BY study_date DESC
		),
		streak_calc AS (
			SELECT
				study_date,
				study_date - ROW_NUMBER() OVER (ORDER BY study_date DESC)::int as streak_group
			FROM daily_activity
		)
		SELECT COUNT(*) as streak
		FROM streak_calc
		WHERE streak_group = (
			SELECT streak_group
			FROM streak_calc
			WHERE study_date = CURRENT_DATE
			LIMIT 1
		)
	`

	var streak int
	err := r.db.QueryRowContext(ctx, query, userID).Scan(&streak)
	if err != nil {
		return 0
	}

	return streak
}

// calculateLongestStreak calculates the longest study streak
func (r *ProgressRepository) calculateLongestStreak(ctx context.Context, userID int64) int {
	query := `
		WITH daily_activity AS (
			SELECT DISTINCT DATE(last_accessed_at) as study_date
			FROM user_progress
			WHERE user_id = $1 AND last_accessed_at IS NOT NULL
			ORDER BY study_date DESC
		),
		streak_calc AS (
			SELECT
				study_date,
				study_date - ROW_NUMBER() OVER (ORDER BY study_date DESC)::int as streak_group
			FROM daily_activity
		)
		SELECT COALESCE(MAX(streak_count), 0) as longest_streak
		FROM (
			SELECT COUNT(*) as streak_count
			FROM streak_calc
			GROUP BY streak_group
		) streaks
	`

	var longestStreak int
	err := r.db.QueryRowContext(ctx, query, userID).Scan(&longestStreak)
	if err != nil {
		return 0
	}

	return longestStreak
}

// ================================================================
// SYNC OPERATIONS
// ================================================================

// GetLastSyncTime retrieves the last sync time for a user
func (r *ProgressRepository) GetLastSyncTime(ctx context.Context, userID int64) (time.Time, error) {
	query := `
		SELECT MAX(updated_at) as last_sync
		FROM user_progress
		WHERE user_id = $1
	`

	var lastSync sql.NullTime
	err := r.db.QueryRowContext(ctx, query, userID).Scan(&lastSync)

	if err != nil {
		return time.Time{}, fmt.Errorf("failed to get last sync time: %w", err)
	}

	if lastSync.Valid {
		return lastSync.Time, nil
	}

	return time.Time{}, nil
}

// SyncOfflineData processes offline sync data
func (r *ProgressRepository) SyncOfflineData(ctx context.Context, req *models.SyncProgressRequest) (int, int, error) {
	successCount := 0
	failCount := 0

	for _, item := range req.SyncItems {
		var err error

		switch item.Type {
		case "lesson_complete":
			err = r.syncLessonComplete(ctx, &item, req.UserID)
		case "progress_update":
			err = r.syncProgressUpdate(ctx, &item, req.UserID)
		case "vocabulary_practice":
			err = r.syncVocabularyPractice(ctx, &item, req.UserID)
		default:
			continue // Skip unknown types
		}

		if err != nil {
			failCount++
		} else {
			successCount++
		}
	}

	// Invalidate caches
	r.invalidateProgressCache(ctx, req.UserID)

	return successCount, failCount, nil
}

// Helper functions for sync operations
func (r *ProgressRepository) syncLessonComplete(ctx context.Context, item *models.SyncItem, userID int64) error {
	lessonID, ok := item.Data["lesson_id"].(float64)
	if !ok {
		return fmt.Errorf("invalid lesson_id")
	}

	quizScore, _ := item.Data["quiz_score"].(float64)
	timeSpent, _ := item.Data["time_spent"].(float64)

	req := &models.CompleteProgressRequest{
		UserID:    userID,
		LessonID:  int64(lessonID),
		QuizScore: int(quizScore),
		TimeSpent: int(timeSpent),
	}

	return r.CompleteLesson(ctx, req)
}

func (r *ProgressRepository) syncProgressUpdate(ctx context.Context, item *models.SyncItem, userID int64) error {
	lessonID, ok := item.Data["lesson_id"].(float64)
	if !ok {
		return fmt.Errorf("invalid lesson_id")
	}

	progressPercent, _ := item.Data["progress_percent"].(float64)
	timeSpent, _ := item.Data["time_spent"].(float64)
	status, _ := item.Data["status"].(string)

	req := &models.UpdateProgressRequest{
		UserID:          userID,
		LessonID:        int64(lessonID),
		Status:          models.ProgressStatus(status),
		ProgressPercent: int(progressPercent),
		TimeSpent:       int(timeSpent),
	}

	return r.UpdateProgress(ctx, req)
}

func (r *ProgressRepository) syncVocabularyPractice(ctx context.Context, item *models.SyncItem, userID int64) error {
	vocabID, ok := item.Data["vocabulary_id"].(float64)
	if !ok {
		return fmt.Errorf("invalid vocabulary_id")
	}

	isCorrect, _ := item.Data["is_correct"].(bool)

	req := &models.VocabularyPracticeRequest{
		UserID:       userID,
		VocabularyID: int64(vocabID),
		IsCorrect:    isCorrect,
	}

	// Simple SRS calculation for sync
	srsData := map[string]interface{}{
		"mastery_level":    float64(1),
		"easiness_factor":  2.5,
		"interval_days":    float64(1),
		"repetition_count": float64(1),
		"next_review_at":   time.Now().Add(24 * time.Hour),
	}

	return r.RecordVocabularyPractice(ctx, req, srsData)
}
