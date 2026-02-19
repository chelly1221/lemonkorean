package handlers

import (
	"log"
	"net/http"

	"lemonkorean/progress/middleware"
	"lemonkorean/progress/repository"

	"github.com/gin-gonic/gin"
)

// ================================================================
// HANGUL LESSON PROGRESS HANDLER
// ================================================================
// Handles Stage 0+ interactive lesson progress
// ================================================================

// HangulLessonHandler handles hangul lesson progress requests
type HangulLessonHandler struct {
	repo *repository.ProgressRepository
}

// NewHangulLessonHandler creates a new hangul lesson handler
func NewHangulLessonHandler(repo *repository.ProgressRepository) *HangulLessonHandler {
	return &HangulLessonHandler{repo: repo}
}

// ================================================================
// POST /api/progress/hangul-lesson/complete
// ================================================================
// Records completion of an interactive hangul lesson

type HangulLessonCompleteRequest struct {
	LessonID       string `json:"lesson_id" binding:"required"`
	CompletedSteps int    `json:"completed_steps"`
	TotalSteps     int    `json:"total_steps"`
	BestScore      int    `json:"best_score"`
	LemonsEarned   int    `json:"lemons_earned"`
}

func (h *HangulLessonHandler) CompleteLesson(c *gin.Context) {
	var req HangulLessonCompleteRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		log.Printf("[HANGUL-LESSON] Invalid request: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"error":   "Bad Request",
			"message": err.Error(),
		})
		return
	}

	userID, err := middleware.GetUserID(c)
	if err != nil {
		log.Printf("[HANGUL-LESSON] Unauthorized: %v", err)
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "Unauthorized",
		})
		return
	}

	log.Printf("[HANGUL-LESSON] User %d completing lesson %s (score=%d, lemons=%d)",
		userID, req.LessonID, req.BestScore, req.LemonsEarned)

	err = h.repo.UpsertHangulLessonProgress(c.Request.Context(), userID, &repository.HangulLessonProgress{
		LessonID:       req.LessonID,
		CompletedSteps: req.CompletedSteps,
		TotalSteps:     req.TotalSteps,
		BestScore:      req.BestScore,
		LemonsEarned:   req.LemonsEarned,
	})
	if err != nil {
		log.Printf("[HANGUL-LESSON] Error saving progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
			"message": "Failed to save lesson progress",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success":   true,
		"message":   "Lesson progress saved",
		"lesson_id": req.LessonID,
	})
}

// ================================================================
// GET /api/progress/hangul-lesson/:userId
// ================================================================
// Gets all hangul lesson progress for a user

func (h *HangulLessonHandler) GetLessonProgress(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{
			"success": false,
			"error":   "Unauthorized",
		})
		return
	}

	progress, err := h.repo.GetHangulLessonProgress(c.Request.Context(), userID)
	if err != nil {
		log.Printf("[HANGUL-LESSON] Error fetching progress: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"success": false,
			"error":   "Internal Server Error",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success":  true,
		"progress": progress,
	})
}
