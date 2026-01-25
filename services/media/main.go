package main

import (
	"context"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"lemonkorean/media/config"
	"lemonkorean/media/handlers"
	"lemonkorean/media/middleware"

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

	// Initialize MinIO client
	minioClient, err := config.InitMinIO()
	if err != nil {
		log.Fatalf("Failed to initialize MinIO: %v", err)
	}

	log.Println("✓ MinIO client initialized successfully")

	// Initialize handler
	mediaHandler := handlers.NewMediaHandler(minioClient)

	// Create Gin router
	router := gin.Default()

	// Global middleware
	router.Use(gin.Recovery())
	router.Use(corsMiddleware())

	// Health check endpoint (public)
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "ok",
			"service": "media-service",
			"time":    time.Now().Format(time.RFC3339),
		})
	})

	// Media routes
	media := router.Group("/media")
	{
		// Public endpoints - Serve media files with caching
		media.GET("/images/:key", mediaHandler.ServeImage)    // Supports ?width=X&height=Y&format=webp
		media.GET("/audio/:key", mediaHandler.ServeAudio)     // Supports range requests for streaming
		media.GET("/thumbnails/:key", mediaHandler.ServeThumbnail) // Supports ?size=X

		// Admin endpoints - Upload and delete (add auth middleware in production)
		// TODO: Add authentication middleware for these routes
		media.POST("/upload", mediaHandler.UploadMedia)       // ?type=images|audio|video
		media.DELETE("/:type/:key", mediaHandler.DeleteMedia) // DELETE /media/images/abc.jpg
	}

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "3004"
	}

	srv := &http.Server{
		Addr:           ":" + port,
		Handler:        router,
		ReadTimeout:    30 * time.Second,
		WriteTimeout:   30 * time.Second,
		MaxHeaderBytes: 10 << 20, // 10 MB
	}

	// Graceful shutdown
	go func() {
		log.Printf("🚀 Media Service starting on port %s", port)
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

// CORS middleware
func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}
