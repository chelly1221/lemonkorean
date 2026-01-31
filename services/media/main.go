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
		// Public endpoints - Serve media files with caching (no auth needed)
		media.GET("/images/:key", mediaHandler.ServeImage)    // Supports ?width=X&height=Y&format=webp
		media.GET("/audio/:key", mediaHandler.ServeAudio)     // Supports range requests for streaming
		media.GET("/thumbnails/:key", mediaHandler.ServeThumbnail) // Supports ?size=X

		// Admin endpoints - Upload and delete (require authentication)
		media.POST("/upload", middleware.AuthMiddleware(), mediaHandler.UploadMedia)       // ?type=images|audio|video
		media.DELETE("/:type/:key", middleware.AuthMiddleware(), mediaHandler.DeleteMedia) // DELETE /media/images/abc.jpg
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
