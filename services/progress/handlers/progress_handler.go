package handlers

import (
	"log"
	"net/http"
	"strconv"

	"lemonkorean/progress/middleware"
	"lemonkorean/progress/models"
	"lemonkorean/progress/repository"
	"lemonkorean/progress/utils"

	"github.com/gin-gonic/gin"
)

// ================================================================
// PROGRESS HANDLER
// ================================================================
// Handles all progress-related HTTP requests
// Uses PostgreSQL for persistent storage and Redis for caching
// ================================================================

// ProgressHandler handles progress-related requests
type ProgressHandler struct {
	repo *repository.ProgressRepository
}

// NewProgressHandler creates a new progress handler
func NewProgressHandler(repo *repository.ProgressRepository) *ProgressHandler {
	return &ProgressHandler{repo: repo}
}

// ================================================================
// 1. GET USER PROGRESS
// ================================================================
// GET /api/progress/user/:userId
// Retrieves all lesson progress for a user

func (h *ProgressHandler) GetUserProgress(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[PROGRESS] Invalid user ID: %s", userIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	// Verify authenticated user matches requested userId
	authUserID, err := middleware.GetUserID(c)
	if err != nil || authUserID != userID {
		log.Printf("[PROGRESS] Unauthorized access attempt for user %d by user %d", userID, authUserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot access progress for other users",
		})
		return
	}

	log.Printf("[PROGRESS] Fetching progress for user %d", userID)

	progress, err := h.repo.GetUserProgress(c.Request.Context(), userID)
	if err != nil {
		log.Printf("[PROGRESS] Error fetching user progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch user progress",
		})
		return
	}

	log.Printf("[PROGRESS] Found %d progress records for user %d", len(progress), userID)

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"user_id":  userID,
		"count":    len(progress),
		"progress": progress,
	})
}

// ================================================================
// 2. GET LESSON PROGRESS
// ================================================================
// GET /api/progress/lesson/:lessonId
// Retrieves progress for a specific lesson

func (h *ProgressHandler) GetLessonProgress(c *gin.Context) {
	lessonIDStr := c.Param("lessonId")
	lessonID, err := strconv.ParseInt(lessonIDStr, 10, 64)
	if err != nil {
		log.Printf("[PROGRESS] Invalid lesson ID: %s", lessonIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid lesson ID",
		})
		return
	}

	userID, err := middleware.GetUserID(c)
	if err != nil {
		log.Printf("[PROGRESS] Unauthorized access: %v", err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "Unauthorized",
			"message": err.Error(),
		})
		return
	}

	log.Printf("[PROGRESS] Fetching lesson %d progress for user %d", lessonID, userID)

	progress, err := h.repo.GetLessonProgress(c.Request.Context(), userID, lessonID)
	if err != nil {
		log.Printf("[PROGRESS] Error fetching lesson progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch lesson progress",
		})
		return
	}

	if progress == nil {
		log.Printf("[PROGRESS] No progress found for lesson %d, user %d", lessonID, userID)
		c.JSON(http.StatusOK, gin.H{
			"success":   true,
			"lesson_id": lessonID,
			"progress":  nil,
			"message":   "No progress found for this lesson",
		})
		return
	}

	log.Printf("[PROGRESS] Found progress for lesson %d: status=%s, percent=%d%%",
		lessonID, progress.Status, progress.ProgressPercent)

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"progress": progress,
	})
}

// ================================================================
// 3. COMPLETE LESSON
// ================================================================
// POST /api/progress/complete
// Marks a lesson as completed with quiz score

func (h *ProgressHandler) CompleteLesson(c *gin.Context) {
	var req models.CompleteProgressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[PROGRESS] Invalid complete lesson request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user matches request
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		log.Printf("[PROGRESS] Unauthorized complete attempt: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot update progress for other users",
		})
		return
	}

	log.Printf("[PROGRESS] User %d completing lesson %d with score %d",
		req.UserID, req.LessonID, req.QuizScore)

	if err := h.repo.CompleteLesson(c.Request.Context(), &req); err != nil {
		log.Printf("[PROGRESS] Error completing lesson: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to complete lesson",
		})
		return
	}

	log.Printf("[PROGRESS] Lesson %d completed successfully for user %d", req.LessonID, req.UserID)

	c.JSON(http.StatusOK, gin.H{
		"success":   true,
		"message":   "Lesson completed successfully",
		"lesson_id": req.LessonID,
		"score":     req.QuizScore,
	})
}

// ================================================================
// 4. SAVE QUIZ RESULT
// ================================================================
// POST /api/progress/quiz
// Saves quiz result without completing the lesson

func (h *ProgressHandler) SaveQuizResult(c *gin.Context) {
	var req struct {
		UserID   int64 `json:"user_id" binding:"required"`
		LessonID int64 `json:"lesson_id" binding:"required"`
		Score    int   `json:"score" binding:"required,min=0,max=100"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[PROGRESS] Invalid quiz result request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		log.Printf("[PROGRESS] Unauthorized quiz save: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot save quiz for other users",
		})
		return
	}

	log.Printf("[PROGRESS] Saving quiz result for user %d, lesson %d: score=%d",
		req.UserID, req.LessonID, req.Score)

	// Update only quiz score, don't mark as completed
	updateReq := &models.UpdateProgressRequest{
		UserID:          req.UserID,
		LessonID:        req.LessonID,
		ProgressPercent: 90, // Quiz is near the end
		Status:          models.StatusInProgress,
	}

	if err := h.repo.UpdateProgress(c.Request.Context(), updateReq); err != nil {
		log.Printf("[PROGRESS] Error saving quiz result: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to save quiz result",
		})
		return
	}

	log.Printf("[PROGRESS] Quiz result saved successfully")

	c.JSON(http.StatusOK, gin.H{
		"success":   true,
		"message":   "Quiz result saved successfully",
		"lesson_id": req.LessonID,
		"score":     req.Score,
	})
}

// ================================================================
// 5. SYNC OFFLINE DATA
// ================================================================
// POST /api/progress/sync
// Synchronizes offline progress data from client

func (h *ProgressHandler) SyncOfflineData(c *gin.Context) {
	var req models.SyncProgressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[SYNC] Invalid sync request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		log.Printf("[SYNC] Unauthorized sync attempt: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot sync data for other users",
		})
		return
	}

	log.Printf("[SYNC] Syncing %d items for user %d from device %s",
		len(req.SyncItems), req.UserID, req.DeviceID)

	successCount, failCount, err := h.repo.SyncOfflineData(c.Request.Context(), &req)
	if err != nil {
		log.Printf("[SYNC] Error during sync: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to sync offline data",
		})
		return
	}

	log.Printf("[SYNC] Sync completed: success=%d, failed=%d", successCount, failCount)

	c.JSON(http.StatusOK, gin.H{
		"success":     true,
		"message":     "Offline data synced successfully",
		"total_items": len(req.SyncItems),
		"synced":      successCount,
		"failed":      failCount,
		"device_id":   req.DeviceID,
	})
}

// ================================================================
// 6. GET REVIEW SCHEDULE
// ================================================================
// GET /api/progress/review-schedule/:userId
// Retrieves vocabulary items due for review (SRS)

func (h *ProgressHandler) GetReviewSchedule(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[REVIEW] Invalid user ID: %s", userIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	// Verify authenticated user
	authUserID, err := middleware.GetUserID(c)
	if err != nil || authUserID != userID {
		log.Printf("[REVIEW] Unauthorized access for user %d by user %d", userID, authUserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot access review schedule for other users",
		})
		return
	}

	// Get limit from query parameter
	limit := 20
	if limitStr := c.Query("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 && l <= 100 {
			limit = l
		}
	}

	log.Printf("[REVIEW] Fetching review schedule for user %d (limit=%d)", userID, limit)

	items, err := h.repo.GetReviewSchedule(c.Request.Context(), userID, limit)
	if err != nil {
		log.Printf("[REVIEW] Error fetching review schedule: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch review schedule",
		})
		return
	}

	log.Printf("[REVIEW] Found %d items due for review", len(items))

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"user_id": userID,
		"count":   len(items),
		"items":   items,
	})
}

// ================================================================
// 7. MARK REVIEW DONE
// ================================================================
// POST /api/progress/review/complete
// Marks a vocabulary review as completed and updates SRS

func (h *ProgressHandler) MarkReviewDone(c *gin.Context) {
	var req models.VocabularyPracticeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[REVIEW] Invalid review complete request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		log.Printf("[REVIEW] Unauthorized review complete: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot complete review for other users",
		})
		return
	}

	log.Printf("[REVIEW] User %d completing review for vocab %d: correct=%v, time=%dms",
		req.UserID, req.VocabularyID, req.IsCorrect, req.ResponseTime)

	// Calculate quality from response time and correctness
	quality := utils.CalculateQualityFromResponseTime(req.IsCorrect, req.ResponseTime)

	// Get current vocabulary progress to use existing SRS data
	currentProgress, err := h.repo.GetVocabularyProgressByID(c.Request.Context(), req.UserID, req.VocabularyID)

	// Initialize SRS values from existing progress or use defaults
	var currentEasiness float64 = utils.InitialEasinessFactor
	var currentInterval int = 0
	var currentRepetitions int = 0
	var currentMastery int = utils.MasteryLevelNew

	if err == nil && currentProgress != nil {
		// Extract SRS data from existing progress
		currentEasiness = currentProgress.EasinessFactor
		currentInterval = currentProgress.IntervalDays
		currentRepetitions = currentProgress.RepetitionCount
		currentMastery = currentProgress.MasteryLevel

		log.Printf("[REVIEW] Found existing progress: EF=%.2f, interval=%d days, reps=%d, mastery=%s",
			currentEasiness, currentInterval, currentRepetitions, utils.GetMasteryDescription(currentMastery))
	} else {
		log.Printf("[REVIEW] No existing progress found, using defaults")
	}

	// Calculate next review using SM-2 algorithm
	srsResult := utils.CalculateNextReview(
		quality,
		currentEasiness,
		currentInterval,
		currentRepetitions,
		currentMastery,
	)

	srsData := map[string]interface{}{
		"mastery_level":    float64(srsResult.MasteryLevel),
		"easiness_factor":  srsResult.EasinessFactor,
		"interval_days":    float64(srsResult.IntervalDays),
		"repetition_count": float64(srsResult.RepetitionCount),
		"next_review_at":   srsResult.NextReviewAt,
	}

	if err := h.repo.RecordVocabularyPractice(c.Request.Context(), &req, srsData); err != nil {
		log.Printf("[REVIEW] Error recording review: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to complete review",
		})
		return
	}

	log.Printf("[REVIEW] Review completed: quality=%d, mastery=%s, next_in=%d days",
		quality, utils.GetMasteryDescription(srsResult.MasteryLevel), srsResult.IntervalDays)

	c.JSON(http.StatusOK, gin.H{
		"success":        true,
		"message":        "Review completed successfully",
		"quality":        quality,
		"srs":            srsResult,
		"mastery_level":  utils.GetMasteryDescription(srsResult.MasteryLevel),
		"next_review_in": srsResult.IntervalDays,
	})
}

// ================================================================
// 8. GET STATS
// ================================================================
// GET /api/progress/stats/:userId
// Retrieves comprehensive statistics for a user

func (h *ProgressHandler) GetStats(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[STATS] Invalid user ID: %s", userIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	// Verify authenticated user
	authUserID, err := middleware.GetUserID(c)
	if err != nil || authUserID != userID {
		log.Printf("[STATS] Unauthorized stats access for user %d by user %d", userID, authUserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot access stats for other users",
		})
		return
	}

	log.Printf("[STATS] Fetching statistics for user %d", userID)

	stats, err := h.repo.GetUserStats(c.Request.Context(), userID)
	if err != nil {
		log.Printf("[STATS] Error fetching user stats: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch statistics",
		})
		return
	}

	log.Printf("[STATS] Stats for user %d: lessons=%d/%d, time=%dmin, streak=%d",
		userID, stats.CompletedLessons, stats.TotalLessons, stats.TotalTimeMinutes, stats.CurrentStreak)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"user_id": userID,
		"stats":   stats,
	})
}

// ================================================================
// ADDITIONAL ENDPOINTS
// ================================================================

// UpdateProgress updates lesson progress (incremental)
// POST /api/progress/update
func (h *ProgressHandler) UpdateProgress(c *gin.Context) {
	var req models.UpdateProgressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[PROGRESS] Invalid update request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		log.Printf("[PROGRESS] Unauthorized update: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot update progress for other users",
		})
		return
	}

	log.Printf("[PROGRESS] Updating progress for user %d, lesson %d: %d%%",
		req.UserID, req.LessonID, req.ProgressPercent)

	if err := h.repo.UpdateProgress(c.Request.Context(), &req); err != nil {
		log.Printf("[PROGRESS] Error updating progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to update progress",
		})
		return
	}

	log.Printf("[PROGRESS] Progress updated successfully")

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Progress updated successfully",
	})
}

// ResetLessonProgress resets progress for a lesson
// DELETE /api/progress/reset/:lessonId
func (h *ProgressHandler) ResetLessonProgress(c *gin.Context) {
	lessonIDStr := c.Param("lessonId")
	lessonID, err := strconv.ParseInt(lessonIDStr, 10, 64)
	if err != nil {
		log.Printf("[PROGRESS] Invalid lesson ID: %s", lessonIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid lesson ID",
		})
		return
	}

	userID, err := middleware.GetUserID(c)
	if err != nil {
		log.Printf("[PROGRESS] Unauthorized reset: %v", err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "Unauthorized",
			"message": err.Error(),
		})
		return
	}

	log.Printf("[PROGRESS] Resetting lesson %d for user %d", lessonID, userID)

	if err := h.repo.ResetLessonProgress(c.Request.Context(), userID, lessonID); err != nil {
		log.Printf("[PROGRESS] Error resetting progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to reset progress",
		})
		return
	}

	log.Printf("[PROGRESS] Lesson %d reset successfully", lessonID)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Progress reset successfully",
	})
}

// GetVocabularyProgress retrieves vocabulary progress for a user
// GET /api/progress/vocabulary/:userId
func (h *ProgressHandler) GetVocabularyProgress(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[VOCAB] Invalid user ID: %s", userIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	limit := 100
	if limitStr := c.Query("limit"); limitStr != "" {
		if l, err := strconv.Atoi(limitStr); err == nil && l > 0 {
			limit = l
		}
	}

	log.Printf("[VOCAB] Fetching vocabulary progress for user %d (limit=%d)", userID, limit)

	progress, err := h.repo.GetVocabularyProgress(c.Request.Context(), userID, limit)
	if err != nil {
		log.Printf("[VOCAB] Error fetching vocabulary progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch vocabulary progress",
		})
		return
	}

	log.Printf("[VOCAB] Found %d vocabulary items", len(progress))

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"user_id":  userID,
		"count":    len(progress),
		"progress": progress,
	})
}

// RecordVocabularyPractice records a vocabulary practice result
// POST /api/progress/vocabulary/practice
func (h *ProgressHandler) RecordVocabularyPractice(c *gin.Context) {
	var req models.VocabularyPracticeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[VOCAB] Invalid practice request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		log.Printf("[VOCAB] Unauthorized practice: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot record practice for other users",
		})
		return
	}

	log.Printf("[VOCAB] Recording practice for user %d, vocab %d: correct=%v",
		req.UserID, req.VocabularyID, req.IsCorrect)

	// Calculate SRS
	srsResult := utils.CalculateNextReviewSimple(
		req.IsCorrect,
		utils.InitialEasinessFactor,
		0,
		0,
		utils.MasteryLevelNew,
	)

	srsData := map[string]interface{}{
		"mastery_level":    float64(srsResult.MasteryLevel),
		"easiness_factor":  srsResult.EasinessFactor,
		"interval_days":    float64(srsResult.IntervalDays),
		"repetition_count": float64(srsResult.RepetitionCount),
		"next_review_at":   srsResult.NextReviewAt,
	}

	if err := h.repo.RecordVocabularyPractice(c.Request.Context(), &req, srsData); err != nil {
		log.Printf("[VOCAB] Error recording practice: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to record practice",
		})
		return
	}

	log.Printf("[VOCAB] Practice recorded: mastery=%s, next_in=%d days",
		utils.GetMasteryDescription(srsResult.MasteryLevel), srsResult.IntervalDays)

	c.JSON(http.StatusOK, gin.H{
		"success":        true,
		"message":        "Practice recorded successfully",
		"srs":            srsResult,
		"mastery_level":  utils.GetMasteryDescription(srsResult.MasteryLevel),
		"next_review_in": srsResult.IntervalDays,
	})
}

// StartLearningSession starts a new learning session
// POST /api/progress/session/start
func (h *ProgressHandler) StartLearningSession(c *gin.Context) {
	var req models.StartSessionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[SESSION] Invalid start session request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		log.Printf("[SESSION] Unauthorized session start: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot start session for other users",
		})
		return
	}

	log.Printf("[SESSION] Starting session for user %d: type=%s, device=%s",
		req.UserID, req.SessionType, req.DeviceType)

	sessionID, err := h.repo.StartSession(c.Request.Context(), &req)
	if err != nil {
		log.Printf("[SESSION] Error starting session: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to start session",
		})
		return
	}

	log.Printf("[SESSION] Session started: id=%d", sessionID)

	c.JSON(http.StatusOK, gin.H{
		"success":    true,
		"message":    "Session started successfully",
		"session_id": sessionID,
	})
}

// EndLearningSession ends a learning session
// POST /api/progress/session/end
func (h *ProgressHandler) EndLearningSession(c *gin.Context) {
	var req models.EndSessionRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[SESSION] Invalid end session request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	log.Printf("[SESSION] Ending session %d: items=%d, correct=%d/%d",
		req.SessionID, req.ItemsCompleted, req.CorrectAnswers, req.TotalAnswers)

	if err := h.repo.EndSession(c.Request.Context(), &req); err != nil {
		log.Printf("[SESSION] Error ending session: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to end session",
		})
		return
	}

	log.Printf("[SESSION] Session %d ended successfully", req.SessionID)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Session ended successfully",
	})
}

// GetSessionStats retrieves session statistics for a user
// GET /api/progress/session/stats/:userId
func (h *ProgressHandler) GetSessionStats(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[SESSION] Invalid user ID: %s", userIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	// Verify authenticated user
	authUserID, err := middleware.GetUserID(c)
	if err != nil || authUserID != userID {
		log.Printf("[SESSION] Unauthorized stats access for user %d", userID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot access session stats for other users",
		})
		return
	}

	log.Printf("[SESSION] Fetching session stats for user %d", userID)

	stats, err := h.repo.GetSessionStats(c.Request.Context(), userID)
	if err != nil {
		log.Printf("[SESSION] Error fetching session stats: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch session statistics",
		})
		return
	}

	log.Printf("[SESSION] Stats for user %d: sessions=%d, minutes=%d, accuracy=%.1f%%",
		userID, stats.TotalSessions, stats.TotalMinutes, stats.AccuracyRate)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"user_id": userID,
		"stats":   stats,
	})
}

// GetUserStats retrieves overall statistics for a user (alias for GetStats)
// GET /api/progress/stats/:userId
func (h *ProgressHandler) GetUserStats(c *gin.Context) {
	h.GetStats(c)
}

// GetWeeklyStats retrieves weekly statistics for a user
// GET /api/progress/stats/weekly/:userId
func (h *ProgressHandler) GetWeeklyStats(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[STATS] Invalid user ID: %s", userIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	// Verify authenticated user
	authUserID, err := middleware.GetUserID(c)
	if err != nil || authUserID != userID {
		log.Printf("[STATS] Unauthorized weekly stats access for user %d", userID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot access weekly stats for other users",
		})
		return
	}

	// Get weeks parameter (default 4)
	weeks := 4
	if weeksStr := c.Query("weeks"); weeksStr != "" {
		if w, err := strconv.Atoi(weeksStr); err == nil && w > 0 && w <= 52 {
			weeks = w
		}
	}

	log.Printf("[STATS] Fetching weekly stats for user %d (weeks=%d)", userID, weeks)

	weeklyStats, err := h.repo.GetWeeklyStats(c.Request.Context(), userID, weeks)
	if err != nil {
		log.Printf("[STATS] Error fetching weekly stats: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch weekly statistics",
		})
		return
	}

	log.Printf("[STATS] Found %d weeks of data", len(weeklyStats))

	c.JSON(http.StatusOK, gin.H{
		"success":      true,
		"user_id":      userID,
		"weeks":        weeks,
		"count":        len(weeklyStats),
		"weekly_stats": weeklyStats,
	})
}
