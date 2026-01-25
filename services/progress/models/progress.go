package models

import (
	"database/sql/driver"
	"encoding/json"
	"time"
)

// ProgressStatus represents the status of a lesson
type ProgressStatus string

const (
	StatusNotStarted ProgressStatus = "not_started"
	StatusInProgress ProgressStatus = "in_progress"
	StatusCompleted  ProgressStatus = "completed"
	StatusReviewing  ProgressStatus = "reviewing"
)

// UserProgress represents a user's progress on a lesson
type UserProgress struct {
	ID              int64          `json:"id" db:"id"`
	UserID          int64          `json:"user_id" db:"user_id"`
	LessonID        int64          `json:"lesson_id" db:"lesson_id"`
	Status          ProgressStatus `json:"status" db:"status"`
	ProgressPercent int            `json:"progress_percent" db:"progress_percent"`
	QuizScore       *int           `json:"quiz_score,omitempty" db:"quiz_score"`
	TimeSpentMinutes int            `json:"time_spent_minutes" db:"time_spent_minutes"`
	LastAccessedAt  *time.Time     `json:"last_accessed_at,omitempty" db:"last_accessed_at"`
	CompletedAt     *time.Time     `json:"completed_at,omitempty" db:"completed_at"`
	CreatedAt       time.Time      `json:"created_at" db:"created_at"`
	UpdatedAt       time.Time      `json:"updated_at" db:"updated_at"`
}

// VocabularyProgress represents progress on vocabulary items
type VocabularyProgress struct {
	ID                int64      `json:"id" db:"id"`
	UserID            int64      `json:"user_id" db:"user_id"`
	VocabularyID      int64      `json:"vocabulary_id" db:"vocabulary_id"`
	MasteryLevel      int        `json:"mastery_level" db:"mastery_level"`
	CorrectCount      int        `json:"correct_count" db:"correct_count"`
	IncorrectCount    int        `json:"incorrect_count" db:"incorrect_count"`
	LastReviewedAt    *time.Time `json:"last_reviewed_at,omitempty" db:"last_reviewed_at"`
	NextReviewAt      *time.Time `json:"next_review_at,omitempty" db:"next_review_at"`
	EasinessFactor    float64    `json:"easiness_factor" db:"easiness_factor"`
	RepetitionCount   int        `json:"repetition_count" db:"repetition_count"`
	IntervalDays      int        `json:"interval_days" db:"interval_days"`
	CreatedAt         time.Time  `json:"created_at" db:"created_at"`
	UpdatedAt         time.Time  `json:"updated_at" db:"updated_at"`
}

// ReviewItem represents an item to be reviewed
type ReviewItem struct {
	VocabularyID   int64      `json:"vocabulary_id"`
	Korean         string     `json:"korean"`
	Chinese        string     `json:"chinese"`
	Hanja          *string    `json:"hanja,omitempty"`
	MasteryLevel   int        `json:"mastery_level"`
	NextReviewAt   *time.Time `json:"next_review_at,omitempty"`
	IntervalDays   int        `json:"interval_days"`
	CorrectCount   int        `json:"correct_count"`
	IncorrectCount int        `json:"incorrect_count"`
}

// CompleteProgressRequest represents a request to complete a lesson
type CompleteProgressRequest struct {
	UserID      int64                  `json:"user_id" binding:"required"`
	LessonID    int64                  `json:"lesson_id" binding:"required"`
	QuizScore   int                    `json:"quiz_score" binding:"min=0,max=100"`
	TimeSpent   int                    `json:"time_spent" binding:"min=0"`
	StageScores map[string]interface{} `json:"stage_scores,omitempty"`
}

// UpdateProgressRequest represents a request to update progress
type UpdateProgressRequest struct {
	UserID          int64          `json:"user_id" binding:"required"`
	LessonID        int64          `json:"lesson_id" binding:"required"`
	Status          ProgressStatus `json:"status,omitempty"`
	ProgressPercent int            `json:"progress_percent" binding:"min=0,max=100"`
	TimeSpent       int            `json:"time_spent,omitempty"`
}

// VocabularyPracticeRequest represents a vocabulary practice result
type VocabularyPracticeRequest struct {
	UserID       int64 `json:"user_id" binding:"required"`
	VocabularyID int64 `json:"vocabulary_id" binding:"required"`
	IsCorrect    bool  `json:"is_correct"`
	ResponseTime int   `json:"response_time"` // milliseconds
}

// SyncProgressRequest represents a sync request from offline client
type SyncProgressRequest struct {
	UserID       int64        `json:"user_id" binding:"required"`
	DeviceID     string       `json:"device_id" binding:"required"`
	SyncItems    []SyncItem   `json:"sync_items" binding:"required"`
	LastSyncedAt *time.Time   `json:"last_synced_at,omitempty"`
}

// SyncItem represents a single item to sync
type SyncItem struct {
	Type      string                 `json:"type"` // lesson_complete, progress_update, vocabulary_practice
	Timestamp time.Time              `json:"timestamp"`
	Data      map[string]interface{} `json:"data"`
}

// JSONMap is a custom type for JSONB columns
type JSONMap map[string]interface{}

// Value implements the driver.Valuer interface
func (j JSONMap) Value() (driver.Value, error) {
	if j == nil {
		return nil, nil
	}
	return json.Marshal(j)
}

// Scan implements the sql.Scanner interface
func (j *JSONMap) Scan(value interface{}) error {
	if value == nil {
		*j = nil
		return nil
	}

	bytes, ok := value.([]byte)
	if !ok {
		return nil
	}

	return json.Unmarshal(bytes, j)
}

// UserStats represents user learning statistics
type UserStats struct {
	UserID              int64     `json:"user_id"`
	TotalLessons        int       `json:"total_lessons"`
	CompletedLessons    int       `json:"completed_lessons"`
	InProgressLessons   int       `json:"in_progress_lessons"`
	TotalTimeMinutes    int       `json:"total_time_minutes"`
	AverageQuizScore    float64   `json:"average_quiz_score"`
	CurrentStreak       int       `json:"current_streak"`
	LongestStreak       int       `json:"longest_streak"`
	VocabularyMastered  int       `json:"vocabulary_mastered"`
	VocabularyLearning  int       `json:"vocabulary_learning"`
	LastStudiedAt       *time.Time `json:"last_studied_at,omitempty"`
}

// WeeklyStats represents weekly learning statistics
type WeeklyStats struct {
	Week             string  `json:"week"` // YYYY-WW format
	LessonsCompleted int     `json:"lessons_completed"`
	TimeSpentMinutes int     `json:"time_spent_minutes"`
	AverageScore     float64 `json:"average_score"`
	DaysActive       int     `json:"days_active"`
}
