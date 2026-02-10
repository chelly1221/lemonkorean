package handlers

import (
	"database/sql"
	"net/http"
	"strconv"
	"time"

	"lemonkorean/progress/repository"

	"github.com/gin-gonic/gin"
)

// GamificationHandler handles gamification-related endpoints
type GamificationHandler struct {
	repo *repository.ProgressRepository
}

// NewGamificationHandler creates a new gamification handler
func NewGamificationHandler(repo *repository.ProgressRepository) *GamificationHandler {
	return &GamificationHandler{repo: repo}
}

// LessonRewardRequest is the request body for saving lesson rewards
type LessonRewardRequest struct {
	LessonID     int `json:"lesson_id" binding:"required"`
	LemonsEarned int `json:"lemons_earned" binding:"required,min=1,max=3"`
	QuizScore    int `json:"quiz_score" binding:"min=0,max=100"`
}

// LemonHarvestRequest is the request body for harvesting a lemon
type LemonHarvestRequest struct {
	// No fields needed - user is from JWT context
}

// BossQuizCompleteRequest is the request body for completing a boss quiz
type BossQuizCompleteRequest struct {
	Level       int `json:"level" binding:"required"`
	Week        int `json:"week" binding:"required"`
	Score       int `json:"score" binding:"min=0,max=100"`
	BonusLemons int `json:"bonus_lemons"`
}

// SaveLessonReward saves or updates a lesson's lemon reward
func (h *GamificationHandler) SaveLessonReward(c *gin.Context) {
	userID, exists := c.Get("userId")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req LessonRewardRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	uid := int64(userID.(float64))

	// Upsert lesson reward (only update if new score is better)
	query := `
		INSERT INTO lesson_rewards (user_id, lesson_id, lemons_earned, best_quiz_score, earned_at, updated_at)
		VALUES ($1, $2, $3, $4, NOW(), NOW())
		ON CONFLICT (user_id, lesson_id) DO UPDATE
		SET lemons_earned = GREATEST(lesson_rewards.lemons_earned, EXCLUDED.lemons_earned),
		    best_quiz_score = GREATEST(lesson_rewards.best_quiz_score, EXCLUDED.best_quiz_score),
		    updated_at = NOW()
		RETURNING lemons_earned
	`

	var actualLemons int
	err := h.repo.GetDB().QueryRowContext(c.Request.Context(), query,
		uid, req.LessonID, req.LemonsEarned, req.QuizScore,
	).Scan(&actualLemons)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save reward"})
		return
	}

	// Update lemon currency
	currencyQuery := `
		INSERT INTO lemon_currency (user_id, total_lemons, tree_lemons_available, updated_at)
		VALUES ($1, $2, $2, NOW())
		ON CONFLICT (user_id) DO UPDATE
		SET total_lemons = lemon_currency.total_lemons + $2,
		    tree_lemons_available = lemon_currency.tree_lemons_available + $2,
		    updated_at = NOW()
	`
	h.repo.GetDB().ExecContext(c.Request.Context(), currencyQuery, uid, req.LemonsEarned)

	// Record transaction
	txQuery := `INSERT INTO lemon_transactions (user_id, amount, type, source_id) VALUES ($1, $2, 'lesson', $3)`
	h.repo.GetDB().ExecContext(c.Request.Context(), txQuery, uid, req.LemonsEarned, req.LessonID)

	c.JSON(http.StatusOK, gin.H{
		"success":       true,
		"lemons_earned": actualLemons,
	})
}

// GetLemonCurrency retrieves a user's lemon balance
func (h *GamificationHandler) GetLemonCurrency(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user ID"})
		return
	}

	query := `
		SELECT total_lemons, tree_lemons_available, tree_lemons_harvested
		FROM lemon_currency
		WHERE user_id = $1
	`

	var total, available, harvested int
	err = h.repo.GetDB().QueryRowContext(c.Request.Context(), query, userID).
		Scan(&total, &available, &harvested)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusOK, gin.H{
			"total_lemons":           0,
			"tree_lemons_available":  0,
			"tree_lemons_harvested":  0,
		})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get currency"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"total_lemons":           total,
		"tree_lemons_available":  available,
		"tree_lemons_harvested":  harvested,
	})
}

// GetLessonRewards retrieves all lesson rewards for a user
func (h *GamificationHandler) GetLessonRewards(c *gin.Context) {
	userIDStr := c.Param("userId")
	userID, err := strconv.ParseInt(userIDStr, 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid user ID"})
		return
	}

	query := `
		SELECT lesson_id, lemons_earned, best_quiz_score, earned_at
		FROM lesson_rewards
		WHERE user_id = $1
	`

	rows, err := h.repo.GetDB().QueryContext(c.Request.Context(), query, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get rewards"})
		return
	}
	defer rows.Close()

	type reward struct {
		LessonID     int       `json:"lesson_id"`
		LemonsEarned int       `json:"lemons_earned"`
		BestQuizScore int      `json:"best_quiz_score"`
		EarnedAt     time.Time `json:"earned_at"`
	}

	rewards := []reward{}
	for rows.Next() {
		var r reward
		if err := rows.Scan(&r.LessonID, &r.LemonsEarned, &r.BestQuizScore, &r.EarnedAt); err != nil {
			continue
		}
		rewards = append(rewards, r)
	}

	c.JSON(http.StatusOK, gin.H{
		"rewards": rewards,
	})
}

// HarvestLemon handles tree lemon harvesting (after ad watched)
func (h *GamificationHandler) HarvestLemon(c *gin.Context) {
	userID, exists := c.Get("userId")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	uid := int64(userID.(float64))

	// Decrement available, increment harvested
	query := `
		UPDATE lemon_currency
		SET tree_lemons_available = tree_lemons_available - 1,
		    tree_lemons_harvested = tree_lemons_harvested + 1,
		    updated_at = NOW()
		WHERE user_id = $1 AND tree_lemons_available > 0
		RETURNING tree_lemons_available, tree_lemons_harvested
	`

	var available, harvested int
	err := h.repo.GetDB().QueryRowContext(c.Request.Context(), query, uid).
		Scan(&available, &harvested)

	if err == sql.ErrNoRows {
		c.JSON(http.StatusBadRequest, gin.H{"error": "no lemons available"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to harvest"})
		return
	}

	// Record transaction
	txQuery := `INSERT INTO lemon_transactions (user_id, amount, type) VALUES ($1, 1, 'harvest')`
	h.repo.GetDB().ExecContext(c.Request.Context(), txQuery, uid)

	c.JSON(http.StatusOK, gin.H{
		"success":                true,
		"tree_lemons_available":  available,
		"tree_lemons_harvested":  harvested,
	})
}

// CompleteBossQuiz records boss quiz completion
func (h *GamificationHandler) CompleteBossQuiz(c *gin.Context) {
	userID, exists := c.Get("userId")
	if !exists {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req BossQuizCompleteRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	uid := int64(userID.(float64))
	bonusLemons := req.BonusLemons
	if bonusLemons <= 0 {
		bonusLemons = 5
	}

	// Insert boss quiz completion (ignore if already done)
	query := `
		INSERT INTO boss_quiz_completions (user_id, level, week, score, bonus_lemons)
		VALUES ($1, $2, $3, $4, $5)
		ON CONFLICT (user_id, level, week) DO NOTHING
		RETURNING id
	`

	var id int
	err := h.repo.GetDB().QueryRowContext(c.Request.Context(), query,
		uid, req.Level, req.Week, req.Score, bonusLemons,
	).Scan(&id)

	if err == sql.ErrNoRows {
		// Already completed
		c.JSON(http.StatusOK, gin.H{
			"success":       true,
			"already_completed": true,
		})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to record boss quiz"})
		return
	}

	// Add bonus lemons
	currencyQuery := `
		INSERT INTO lemon_currency (user_id, total_lemons, tree_lemons_available, updated_at)
		VALUES ($1, $2, $2, NOW())
		ON CONFLICT (user_id) DO UPDATE
		SET total_lemons = lemon_currency.total_lemons + $2,
		    tree_lemons_available = lemon_currency.tree_lemons_available + $2,
		    updated_at = NOW()
	`
	h.repo.GetDB().ExecContext(c.Request.Context(), currencyQuery, uid, bonusLemons)

	// Record transaction
	txQuery := `INSERT INTO lemon_transactions (user_id, amount, type) VALUES ($1, $2, 'boss')`
	h.repo.GetDB().ExecContext(c.Request.Context(), txQuery, uid, bonusLemons)

	c.JSON(http.StatusOK, gin.H{
		"success":       true,
		"bonus_lemons":  bonusLemons,
	})
}
