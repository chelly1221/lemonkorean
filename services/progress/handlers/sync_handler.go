package handlers

import (
	"net/http"
	"strconv"

	"lemonkorean/progress/middleware"
	"lemonkorean/progress/models"
	"lemonkorean/progress/repository"

	"github.com/gin-gonic/gin"
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

	// TODO: Implement batch sync logic
	c.JSON(http.StatusNotImplemented, gin.H{
		"error":   "Not Implemented",
		"message": "Batch sync not yet implemented",
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

	// TODO: Implement sync status retrieval from database/cache
	c.JSON(http.StatusOK, gin.H{
		"success":         true,
		"user_id":         userID,
		"last_synced_at":  nil,
		"pending_items":   0,
		"sync_queue_size": 0,
		"message":         "Sync status retrieved (placeholder)",
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

	// TODO: Get current progress and calculate SRS
	srsData := map[string]interface{}{
		"mastery_level":    float64(0),
		"easiness_factor":  2.5,
		"interval_days":    float64(1),
		"repetition_count": float64(0),
	}

	return h.repo.RecordVocabularyPractice(c.Request.Context(), req, srsData)
}
