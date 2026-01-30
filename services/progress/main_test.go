package main

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

func setupRouter() *gin.Engine {
	gin.SetMode(gin.TestMode)
	router := gin.Default()

	// Health check endpoint
	router.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status":  "healthy",
			"service": "progress",
		})
	})

	return router
}

func TestHealthCheck(t *testing.T) {
	router := setupRouter()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/health", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, "healthy", response["status"])
	assert.Equal(t, "progress", response["service"])
}

func TestProgressCompletion(t *testing.T) {
	router := setupRouter()

	// Mock progress completion endpoint
	router.POST("/api/progress/complete", func(c *gin.Context) {
		var data map[string]interface{}
		if err := c.BindJSON(&data); err != nil {
			c.JSON(400, gin.H{"error": "Invalid request"})
			return
		}

		c.JSON(200, gin.H{
			"success": true,
			"message": "Progress updated",
		})
	})

	// Test valid request
	body := map[string]interface{}{
		"user_id":   1,
		"lesson_id": 234,
		"status":    "completed",
	}
	jsonBody, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/progress/complete", bytes.NewBuffer(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"])
}

func TestProgressUpdate(t *testing.T) {
	router := setupRouter()

	router.POST("/api/progress/update", func(c *gin.Context) {
		var data map[string]interface{}
		if err := c.BindJSON(&data); err != nil {
			c.JSON(400, gin.H{"error": "Invalid request"})
			return
		}

		// Validate required fields
		if data["user_id"] == nil || data["lesson_id"] == nil {
			c.JSON(400, gin.H{"error": "Missing required fields"})
			return
		}

		c.JSON(200, gin.H{
			"success": true,
			"message": "Progress updated",
		})
	})

	// Test with valid data
	body := map[string]interface{}{
		"user_id":   1,
		"lesson_id": 234,
		"stage":     3,
	}
	jsonBody, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/progress/update", bytes.NewBuffer(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)
}

func TestProgressUpdateMissingFields(t *testing.T) {
	router := setupRouter()

	router.POST("/api/progress/update", func(c *gin.Context) {
		var data map[string]interface{}
		if err := c.BindJSON(&data); err != nil {
			c.JSON(400, gin.H{"error": "Invalid request"})
			return
		}

		if data["user_id"] == nil || data["lesson_id"] == nil {
			c.JSON(400, gin.H{"error": "Missing required fields"})
			return
		}

		c.JSON(200, gin.H{"success": true})
	})

	// Test with missing fields
	body := map[string]interface{}{
		"user_id": 1,
		// missing lesson_id
	}
	jsonBody, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/progress/update", bytes.NewBuffer(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w, req)

	assert.Equal(t, 400, w.Code)
}

func TestGetUserProgress(t *testing.T) {
	router := setupRouter()

	router.GET("/api/progress/user/:userId", func(c *gin.Context) {
		userId := c.Param("userId")
		if userId == "" {
			c.JSON(400, gin.H{"error": "Invalid user ID"})
			return
		}

		c.JSON(200, gin.H{
			"user_id":  userId,
			"progress": []interface{}{},
		})
	})

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/progress/user/1", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.NotNil(t, response["progress"])
}

func TestSyncEndpoint(t *testing.T) {
	router := setupRouter()

	router.POST("/api/progress/sync", func(c *gin.Context) {
		var data map[string]interface{}
		if err := c.BindJSON(&data); err != nil {
			c.JSON(400, gin.H{"error": "Invalid request"})
			return
		}

		c.JSON(200, gin.H{
			"success": true,
			"synced":  1,
		})
	})

	body := map[string]interface{}{
		"user_id": 1,
		"items": []interface{}{
			map[string]interface{}{
				"lesson_id": 234,
				"status":    "completed",
			},
		},
	}
	jsonBody, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("POST", "/api/progress/sync", bytes.NewBuffer(jsonBody))
	req.Header.Set("Content-Type", "application/json")
	router.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)

	var response map[string]interface{}
	err := json.Unmarshal(w.Body.Bytes(), &response)
	assert.NoError(t, err)
	assert.Equal(t, true, response["success"])
}

func TestReviewSchedule(t *testing.T) {
	router := setupRouter()

	router.GET("/api/progress/review-schedule/:userId", func(c *gin.Context) {
		userId := c.Param("userId")

		c.JSON(200, gin.H{
			"user_id": userId,
			"reviews": []interface{}{},
		})
	})

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/api/progress/review-schedule/1", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, 200, w.Code)
}
