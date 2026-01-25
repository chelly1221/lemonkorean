package models

import (
	"time"
)

// LearningSession represents a study session
type LearningSession struct {
	ID            int64      `json:"id" db:"id"`
	UserID        int64      `json:"user_id" db:"user_id"`
	LessonID      *int64     `json:"lesson_id,omitempty" db:"lesson_id"`
	SessionType   string     `json:"session_type" db:"session_type"` // lesson, vocabulary, review, practice
	StartedAt     time.Time  `json:"started_at" db:"started_at"`
	EndedAt       *time.Time `json:"ended_at,omitempty" db:"ended_at"`
	DurationMinutes int      `json:"duration_minutes" db:"duration_minutes"`
	ItemsCompleted  int      `json:"items_completed" db:"items_completed"`
	CorrectAnswers  int      `json:"correct_answers" db:"correct_answers"`
	TotalAnswers    int      `json:"total_answers" db:"total_answers"`
	DeviceType      string   `json:"device_type" db:"device_type"` // mobile, tablet, desktop
	CreatedAt       time.Time `json:"created_at" db:"created_at"`
	UpdatedAt       time.Time `json:"updated_at" db:"updated_at"`
}

// StartSessionRequest represents a request to start a session
type StartSessionRequest struct {
	UserID      int64  `json:"user_id" binding:"required"`
	LessonID    *int64 `json:"lesson_id,omitempty"`
	SessionType string `json:"session_type" binding:"required"`
	DeviceType  string `json:"device_type"`
}

// EndSessionRequest represents a request to end a session
type EndSessionRequest struct {
	SessionID       int64 `json:"session_id" binding:"required"`
	ItemsCompleted  int   `json:"items_completed"`
	CorrectAnswers  int   `json:"correct_answers"`
	TotalAnswers    int   `json:"total_answers"`
}

// SessionStats represents session statistics for a user
type SessionStats struct {
	UserID              int64     `json:"user_id"`
	TotalSessions       int       `json:"total_sessions"`
	TotalMinutes        int       `json:"total_minutes"`
	AverageDuration     float64   `json:"average_duration"`
	TotalItemsCompleted int       `json:"total_items_completed"`
	AccuracyRate        float64   `json:"accuracy_rate"`
	LastSessionAt       *time.Time `json:"last_session_at,omitempty"`
	SessionsThisWeek    int       `json:"sessions_this_week"`
	MinutesThisWeek     int       `json:"minutes_this_week"`
}
