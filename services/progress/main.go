package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"

	"lemonkorean/progress/config"
	"lemonkorean/progress/handlers"
	"lemonkorean/progress/middleware"
	"lemonkorean/progress/repository"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Load environment variables
	if err := godotenv.Load(); err != nil {
		log.Println("Warning: .env file not found, using system environment variables")
	}

	// Set Gin mode
	if os.Getenv("NODE_ENV") == "production" {
		gin.SetMode(gin.ReleaseMode)
	}

	// Initialize database connection
	db, err := config.InitDatabase()
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	log.Println("✓ PostgreSQL connected successfully")

	// Initialize Redis connection
	redisClient, err := config.InitRedis()
	if err != nil {
		log.Fatalf("Failed to connect to Redis: %v", err)
	}
	defer redisClient.Close()

	log.Println("✓ Redis connected successfully")

	// Test Redis connection
	ctx := context.Background()
	if err := redisClient.Ping(ctx).Err(); err != nil {
		log.Fatalf("Redis ping failed: %v", err)
	}

	// Initialize repository
	progressRepo := repository.NewProgressRepository(db, redisClient)

	// Initialize handlers
	progressHandler := handlers.NewProgressHandler(progressRepo)
	syncHandler := handlers.NewSyncHandler(progressRepo)

	// Initialize middleware
	authMiddleware := middleware.NewAuthMiddleware()

	// Create Gin router
	router := gin.Default()

	// Global middleware
	router.Use(gin.Recovery())
	router.Use(corsMiddleware())

	// Health check endpoint (public)
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "ok",
			"service": "progress-service",
			"time":    time.Now().Format(time.RFC3339),
		})
	})

	// API routes (protected)
	api := router.Group("/api/progress")
	api.Use(authMiddleware.RequireAuth())
	{
		// Progress endpoints
		api.GET("/user/:userId", progressHandler.GetUserProgress)
		api.GET("/lesson/:lessonId", progressHandler.GetLessonProgress)
		api.POST("/complete", progressHandler.CompleteLesson)
		api.POST("/update", progressHandler.UpdateProgress)
		api.DELETE("/reset/:lessonId", progressHandler.ResetLessonProgress)

		// Vocabulary progress
		api.GET("/vocabulary/:userId", progressHandler.GetVocabularyProgress)
		api.POST("/vocabulary/practice", progressHandler.RecordVocabularyPractice)
		api.POST("/vocabulary/batch", progressHandler.RecordVocabularyBatch)

		// SRS (Spaced Repetition System)
		api.GET("/review-schedule/:userId", progressHandler.GetReviewSchedule)
		api.POST("/review/complete", progressHandler.MarkReviewDone)

		// Learning sessions
		api.POST("/session/start", progressHandler.StartLearningSession)
		api.POST("/session/end", progressHandler.EndLearningSession)
		api.GET("/session/stats/:userId", progressHandler.GetSessionStats)

		// Sync endpoints
		api.POST("/sync", syncHandler.SyncProgress)
		api.POST("/sync/batch", syncHandler.BatchSync)
		api.GET("/sync/status/:userId", syncHandler.GetSyncStatus)

		// Statistics
		api.GET("/stats/:userId", progressHandler.GetUserStats)
		api.GET("/stats/weekly/:userId", progressHandler.GetWeeklyStats)
	}

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "3003"
	}

	srv := &http.Server{
		Addr:           ":" + port,
		Handler:        router,
		ReadTimeout:    10 * time.Second,
		WriteTimeout:   10 * time.Second,
		MaxHeaderBytes: 1 << 20, // 1 MB
	}

	// Graceful shutdown
	go func() {
		log.Printf("🚀 Progress Service starting on port %s", port)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("Failed to start server: %v", err)
		}
	}()

	// Wait for interrupt signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Println("Shutting down server...")

	// Graceful shutdown with timeout
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("Server forced to shutdown: %v", err)
	}

	log.Println("Server exited")
}

// CORS middleware with spec-compliant configuration
func corsMiddleware() gin.HandlerFunc {
	corsConfig := config.GetCORSConfig()

	return func(c *gin.Context) {
		origin := c.Request.Header.Get("Origin")

		// Only set CORS headers for allowed origins
		if corsConfig.IsOriginAllowed(origin) {
			// Reflect specific origin (spec-compliant)
			c.Writer.Header().Set("Access-Control-Allow-Origin", origin)
			c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
			c.Writer.Header().Set("Access-Control-Allow-Methods",
				strings.Join(corsConfig.AllowedMethods, ", "))
			c.Writer.Header().Set("Access-Control-Allow-Headers",
				strings.Join(corsConfig.AllowedHeaders, ", "))
			c.Writer.Header().Set("Access-Control-Max-Age", "3600")
		}

		// Handle preflight OPTIONS
		if c.Request.Method == "OPTIONS" {
			if corsConfig.IsOriginAllowed(origin) {
				c.AbortWithStatus(204)
			} else {
				c.AbortWithStatus(403)
			}
			return
		}

		c.Next()
	}
}
