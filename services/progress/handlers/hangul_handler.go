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
// HANGUL PROGRESS HANDLER
// ================================================================
// Handles Korean alphabet (한글) learning progress
// Uses SRS (Spaced Repetition System) for character mastery
// ================================================================

// HangulHandler handles hangul progress-related requests
type HangulHandler struct {
	repo *repository.ProgressRepository
}

// NewHangulHandler creates a new hangul handler
func NewHangulHandler(repo *repository.ProgressRepository) *HangulHandler {
	return &HangulHandler{repo: repo}
}

// ================================================================
// GET /api/progress/hangul/:userId
// ================================================================
// Retrieves hangul learning progress for a user

func (h *HangulHandler) GetHangulProgress(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[HANGUL] Invalid user ID: %s", userIDStr)
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
		log.Printf("[HANGUL] Unauthorized access attempt for user %d by user %d", userID, authUserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot access progress for other users",
		})
		return
	}

	log.Printf("[HANGUL] Fetching hangul progress for user %d", userID)

	progress, stats, err := h.repo.GetHangulProgress(c.Request.Context(), userID)
	if err != nil {
		log.Printf("[HANGUL] Error fetching hangul progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch hangul progress",
		})
		return
	}

	log.Printf("[HANGUL] Found %d progress records for user %d", len(progress), userID)

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"user_id":  userID,
		"count":    len(progress),
		"progress": progress,
		"stats":    stats,
	})
}

// ================================================================
// POST /api/progress/hangul/:userId/:characterId
// ================================================================
// Updates hangul character practice result with SRS

func (h *HangulHandler) UpdateHangulProgress(c *gin.Context) {
	userIDStr := c.Param("userId")
	characterIDStr := c.Param("characterId")

	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[HANGUL] Invalid user ID: %s", userIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid user ID",
		})
		return
	}

	characterID, err := strconv.ParseInt(characterIDStr, 10, 64)
	if err != nil {
		log.Printf("[HANGUL] Invalid character ID: %s", characterIDStr)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": "Invalid character ID",
		})
		return
	}

	// Verify authenticated user
	authUserID, err := middleware.GetUserID(c)
	if err != nil || authUserID != userID {
		log.Printf("[HANGUL] Unauthorized update attempt: auth=%d, req=%d", authUserID, userID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot update progress for other users",
		})
		return
	}

	// Parse request body
	var req models.HangulPracticeRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[HANGUL] Invalid request body: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	log.Printf("[HANGUL] User %d practicing character %d: correct=%v, response_time=%dms",
		userID, characterID, req.IsCorrect, req.ResponseTime)

	// Get current progress to calculate SRS
	currentProgress, err := h.repo.GetHangulCharacterProgress(c.Request.Context(), userID, characterID)

	// Initialize SRS values from existing progress or use defaults
	var currentEasiness float64 = utils.InitialEasinessFactor
	var currentInterval int = 0
	var currentRepetitions int = 0
	var currentMastery int = utils.MasteryLevelNew

	if err == nil && currentProgress != nil {
		currentEasiness = currentProgress.EasinessFactor
		currentInterval = currentProgress.IntervalDays
		currentRepetitions = currentProgress.RepetitionCount
		currentMastery = currentProgress.MasteryLevel

		log.Printf("[HANGUL] Found existing progress: EF=%.2f, interval=%d, reps=%d, mastery=%d",
			currentEasiness, currentInterval, currentRepetitions, currentMastery)
	} else {
		log.Printf("[HANGUL] No existing progress found, using defaults")
	}

	// Calculate quality from response time and correctness
	quality := utils.CalculateQualityFromResponseTime(req.IsCorrect, req.ResponseTime)

	// Calculate next review using SM-2 algorithm
	srsResult := utils.CalculateNextReview(
		quality,
		currentEasiness,
		currentInterval,
		currentRepetitions,
		currentMastery,
	)

	// Save to database
	if err := h.repo.UpdateHangulProgress(c.Request.Context(), userID, characterID, req.IsCorrect, srsResult); err != nil {
		log.Printf("[HANGUL] Error updating progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to update hangul progress",
		})
		return
	}

	log.Printf("[HANGUL] Progress updated: quality=%d, mastery=%s, next_in=%d days",
		quality, utils.GetMasteryDescription(srsResult.MasteryLevel), srsResult.IntervalDays)

	c.JSON(http.StatusOK, gin.H{
		"success":        true,
		"message":        "Hangul progress updated successfully",
		"character_id":   characterID,
		"is_correct":     req.IsCorrect,
		"quality":        quality,
		"srs":            srsResult,
		"mastery_level":  utils.GetMasteryDescription(srsResult.MasteryLevel),
		"next_review_in": srsResult.IntervalDays,
	})
}

// ================================================================
// GET /api/progress/hangul/review/:userId
// ================================================================
// Get hangul characters due for review

func (h *HangulHandler) GetHangulReviewSchedule(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		log.Printf("[HANGUL] Invalid user ID: %s", userIDStr)
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
		log.Printf("[HANGUL] Unauthorized review access for user %d", userID)
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

	log.Printf("[HANGUL] Fetching review schedule for user %d (limit=%d)", userID, limit)

	items, err := h.repo.GetHangulReviewSchedule(c.Request.Context(), userID, limit)
	if err != nil {
		log.Printf("[HANGUL] Error fetching review schedule: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to fetch hangul review schedule",
		})
		return
	}

	log.Printf("[HANGUL] Found %d characters due for review", len(items))

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"user_id": userID,
		"count":   len(items),
		"items":   items,
	})
}

// ================================================================
// POST /api/progress/hangul/batch
// ================================================================
// Record batch hangul practice results (from quiz)

func (h *HangulHandler) RecordHangulBatch(c *gin.Context) {
	var req models.HangulBatchRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[HANGUL] Invalid batch request: %v", err)
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
		log.Printf("[HANGUL] Unauthorized batch: auth=%d, req=%d", userID, req.UserID)
		c.JSON(http.StatusForbidden, gin.H{
			"success": false,
			"error":   "Forbidden",
			"message": "Cannot record progress for other users",
		})
		return
	}

	log.Printf("[HANGUL] Recording batch for user %d: %d items", req.UserID, len(req.Results))

	successCount, failCount, err := h.repo.RecordHangulBatch(c.Request.Context(), &req)
	if err != nil {
		log.Printf("[HANGUL] Error recording batch: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to record hangul batch",
		})
		return
	}

	log.Printf("[HANGUL] Batch recorded: success=%d, failed=%d", successCount, failCount)

	c.JSON(http.StatusOK, gin.H{
		"success":       true,
		"message":       "Hangul batch recorded successfully",
		"total_items":   len(req.Results),
		"success_count": successCount,
		"fail_count":    failCount,
	})
}
