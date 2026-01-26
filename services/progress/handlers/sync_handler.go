package handlers

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"time"

	"lemonkorean/progress/middleware"
	"lemonkorean/progress/models"
	"lemonkorean/progress/repository"
	"lemonkorean/progress/utils"

	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
)

// SyncHandler handles synchronization-related requests
type SyncHandler struct {
	repo *repository.ProgressRepository
}

// NewSyncHandler creates a new sync handler
func NewSyncHandler(repo *repository.ProgressRepository) *SyncHandler {
	return &SyncHandler{repo: repo}
}

// ================================================================
// SYNC ENDPOINTS
// ================================================================

// SyncProgress synchronizes progress from offline client
// POST /api/progress/sync
func (h *SyncHandler) SyncProgress(c *gin.Context) {
	var req models.SyncProgressRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil || userID != req.UserID {
		c.JSON(http.StatusForbidden, gin.H{
			"error":   "Forbidden",
			"message": "Cannot sync progress for other users",
		})
		return
	}

	// Process each sync item
	successCount := 0
	failedCount := 0
	errors := []string{}

	for _, item := range req.SyncItems {
		err := h.processSyncItem(c, &item, req.UserID)
		if err != nil {
			failedCount++
			errors = append(errors, err.Error())
		} else {
			successCount++
		}
	}

	response := gin.H{
		"success":       true,
		"total_items":   len(req.SyncItems),
		"synced":        successCount,
		"failed":        failedCount,
		"device_id":     req.DeviceID,
		"synced_at":     req.LastSyncedAt,
	}

	if len(errors) > 0 {
		response["errors"] = errors
	}

	c.JSON(http.StatusOK, response)
}

// BatchSync processes multiple sync requests in batch
// POST /api/progress/sync/batch
func (h *SyncHandler) BatchSync(c *gin.Context) {
	var requests []models.SyncProgressRequest
	if err := c.ShouldBindJSON(&requests); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	// Verify authenticated user
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"error":   "Unauthorized",
			"message": err.Error(),
		})
		return
	}

	// Verify all requests are for the authenticated user
	for _, req := range requests {
		if req.UserID != userID {
			c.JSON(http.StatusForbidden, gin.H{
				"error":   "Forbidden",
				"message": "Cannot sync progress for other users",
			})
			return
		}
	}

	// Process all requests
	results := make([]gin.H, len(requests))
	totalSynced := 0
	totalFailed := 0

	for i, req := range requests {
		successCount := 0
		failedCount := 0
		errors := []string{}

		// Process each sync item in this request
		for _, item := range req.SyncItems {
			err := h.processSyncItem(c, &item, req.UserID)
			if err != nil {
				failedCount++
				errors = append(errors, err.Error())
			} else {
				successCount++
			}
		}

		// Build result for this request
		results[i] = gin.H{
			"device_id":  req.DeviceID,
			"synced":     successCount,
			"failed":     failedCount,
			"total":      len(req.SyncItems),
			"synced_at":  req.LastSyncedAt,
		}

		if len(errors) > 0 {
			results[i]["errors"] = errors
		}

		totalSynced += successCount
		totalFailed += failedCount
	}

	c.JSON(http.StatusOK, gin.H{
		"success":      true,
		"total_synced": totalSynced,
		"total_failed": totalFailed,
		"total_items":  totalSynced + totalFailed,
		"batch_count":  len(requests),
		"results":      results,
	})
}

// GetSyncStatus retrieves synchronization status for a user
// GET /api/progress/sync/status/:userId
func (h *SyncHandler) GetSyncStatus(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	// Verify authenticated user
	authUserID, err := middleware.GetUserID(c)
	if err != nil || authUserID != userID {
		c.JSON(http.StatusForbidden, gin.H{
			"error":   "Forbidden",
			"message": "Cannot view sync status for other users",
		})
		return
	}

	// Get sync status from Redis cache
	ctx := c.Request.Context()

	// Key pattern: sync:status:{user_id}
	cacheKey := fmt.Sprintf("sync:status:%d", userID)

	type SyncStatus struct {
		LastSyncedAt  *time.Time `json:"last_synced_at"`
		PendingItems  int        `json:"pending_items"`
		SyncQueueSize int        `json:"sync_queue_size"`
		LastDeviceID  string     `json:"last_device_id"`
	}

	var syncStatus SyncStatus

	// Try to get from Redis
	val, err := h.repo.GetRedis().Get(ctx, cacheKey).Result()
	if err == nil {
		// Parse cached status
		if jsonErr := json.Unmarshal([]byte(val), &syncStatus); jsonErr == nil {
			// Return cached data
			c.JSON(http.StatusOK, gin.H{
				"success":         true,
				"user_id":         userID,
				"last_synced_at":  syncStatus.LastSyncedAt,
				"pending_items":   syncStatus.PendingItems,
				"sync_queue_size": syncStatus.SyncQueueSize,
				"last_device_id":  syncStatus.LastDeviceID,
				"cached":          true,
			})
			return
		}
	} else if err != redis.Nil {
		// Redis error (not just missing key) - log it but continue
		fmt.Printf("[SYNC] Redis error getting sync status: %v\n", err)
	}

	// Get from database if not in cache
	lastSync, err := h.repo.GetLastSyncTime(ctx, userID)
	if err == nil && !lastSync.IsZero() {
		syncStatus.LastSyncedAt = &lastSync
	}

	// Note: pending_items and sync_queue_size would require additional queries
	// For now, we'll set them to 0 as placeholders
	syncStatus.PendingItems = 0
	syncStatus.SyncQueueSize = 0
	syncStatus.LastDeviceID = ""

	// Cache for 5 minutes
	statusJSON, _ := json.Marshal(syncStatus)
	h.repo.GetRedis().Set(ctx, cacheKey, statusJSON, 5*time.Minute)

	c.JSON(http.StatusOK, gin.H{
		"success":         true,
		"user_id":         userID,
		"last_synced_at":  syncStatus.LastSyncedAt,
		"pending_items":   syncStatus.PendingItems,
		"sync_queue_size": syncStatus.SyncQueueSize,
		"last_device_id":  syncStatus.LastDeviceID,
		"cached":          false,
	})
}

// ================================================================
// HELPER FUNCTIONS
// ================================================================

// processSyncItem processes a single sync item based on its type
func (h *SyncHandler) processSyncItem(c *gin.Context, item *models.SyncItem, userID int64) error {
	switch item.Type {
	case "lesson_complete":
		return h.syncLessonComplete(c, item, userID)

	case "progress_update":
		return h.syncProgressUpdate(c, item, userID)

	case "vocabulary_practice":
		return h.syncVocabularyPractice(c, item, userID)

	default:
		return nil // Ignore unknown types
	}
}

// syncLessonComplete syncs lesson completion
func (h *SyncHandler) syncLessonComplete(c *gin.Context, item *models.SyncItem, userID int64) error {
	lessonID, ok := item.Data["lesson_id"].(float64)
	if !ok {
		return nil
	}

	quizScore, _ := item.Data["quiz_score"].(float64)
	timeSpent, _ := item.Data["time_spent"].(float64)

	req := &models.CompleteProgressRequest{
		UserID:    userID,
		LessonID:  int64(lessonID),
		QuizScore: int(quizScore),
		TimeSpent: int(timeSpent),
	}

	return h.repo.CompleteLesson(c.Request.Context(), req)
}

// syncProgressUpdate syncs progress update
func (h *SyncHandler) syncProgressUpdate(c *gin.Context, item *models.SyncItem, userID int64) error {
	lessonID, ok := item.Data["lesson_id"].(float64)
	if !ok {
		return nil
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

	return h.repo.UpdateProgress(c.Request.Context(), req)
}

// syncVocabularyPractice syncs vocabulary practice
func (h *SyncHandler) syncVocabularyPractice(c *gin.Context, item *models.SyncItem, userID int64) error {
	vocabID, ok := item.Data["vocabulary_id"].(float64)
	if !ok {
		return nil
	}

	isCorrect, _ := item.Data["is_correct"].(bool)
	responseTime, _ := item.Data["response_time"].(float64)

	req := &models.VocabularyPracticeRequest{
		UserID:       userID,
		VocabularyID: int64(vocabID),
		IsCorrect:    isCorrect,
		ResponseTime: int(responseTime),
	}

	// Get current vocabulary progress from repository
	currentProgress, err := h.repo.GetVocabularyProgressByID(c.Request.Context(), userID, int64(vocabID))

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
	}

	// Calculate quality from response time and correctness
	quality := utils.CalculateQualityFromResponseTime(isCorrect, int(responseTime))

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

	return h.repo.RecordVocabularyPractice(c.Request.Context(), req, srsData)
}
