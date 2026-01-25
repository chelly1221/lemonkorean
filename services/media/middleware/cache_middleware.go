package middleware

import (
	"crypto/md5"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// ================================================================
// CACHE MIDDLEWARE
// ================================================================
// Adds HTTP caching headers to responses
// Supports ETag, Last-Modified, and Cache-Control headers
// ================================================================

// CacheMiddleware adds caching headers to the response
// maxAge is in seconds
func CacheMiddleware(maxAge int) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Only apply caching to GET requests
		if c.Request.Method != "GET" {
			c.Next()
			return
		}

		// Set Cache-Control header
		cacheControl := fmt.Sprintf("public, max-age=%d", maxAge)
		c.Header("Cache-Control", cacheControl)

		// Set Expires header
		expires := time.Now().Add(time.Duration(maxAge) * time.Second)
		c.Header("Expires", expires.UTC().Format(http.TimeFormat))

		// Add Vary header
		c.Header("Vary", "Accept-Encoding")

		c.Next()
	}
}

// NoCacheMiddleware disables caching
func NoCacheMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Header("Cache-Control", "no-cache, no-store, must-revalidate")
		c.Header("Pragma", "no-cache")
		c.Header("Expires", "0")
		c.Next()
	}
}

// ETagMiddleware generates and validates ETags
func ETagMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Store the original writer
		blw := &bodyLogWriter{body: []byte{}, ResponseWriter: c.Writer}
		c.Writer = blw

		c.Next()

		// Generate ETag from response body
		if blw.body != nil && len(blw.body) > 0 {
			etag := generateETag(blw.body)
			c.Header("ETag", etag)

			// Check if client has matching ETag
			clientETag := c.GetHeader("If-None-Match")
			if clientETag == etag {
				c.Status(http.StatusNotModified)
				return
			}
		}
	}
}

// ConditionalGetMiddleware handles If-Modified-Since requests
func ConditionalGetMiddleware(modTime time.Time) gin.HandlerFunc {
	return func(c *gin.Context) {
		// Set Last-Modified header
		c.Header("Last-Modified", modTime.UTC().Format(http.TimeFormat))

		// Check If-Modified-Since header
		ifModifiedSince := c.GetHeader("If-Modified-Since")
		if ifModifiedSince != "" {
			clientTime, err := time.Parse(http.TimeFormat, ifModifiedSince)
			if err == nil && !modTime.After(clientTime) {
				c.Status(http.StatusNotModified)
				c.Abort()
				return
			}
		}

		c.Next()
	}
}

// BrowserCacheMiddleware sets appropriate cache headers based on content type
func BrowserCacheMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		contentType := c.ContentType()

		// Set cache duration based on content type
		var maxAge int
		switch {
		case contentType == "image/jpeg" || contentType == "image/png" || contentType == "image/gif" || contentType == "image/webp":
			// Images: cache for 7 days
			maxAge = 604800
		case contentType == "audio/mpeg" || contentType == "audio/wav" || contentType == "audio/ogg":
			// Audio: cache for 7 days
			maxAge = 604800
		case contentType == "video/mp4" || contentType == "video/webm":
			// Video: cache for 1 day
			maxAge = 86400
		case contentType == "application/json":
			// JSON: cache for 5 minutes
			maxAge = 300
		default:
			// Default: cache for 1 hour
			maxAge = 3600
		}

		cacheControl := fmt.Sprintf("public, max-age=%d", maxAge)
		c.Header("Cache-Control", cacheControl)
		c.Header("Vary", "Accept-Encoding")

		c.Next()
	}
}

// CompressionMiddleware indicates compression support
func CompressionMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Check if client accepts compression
		acceptEncoding := c.GetHeader("Accept-Encoding")
		if acceptEncoding != "" {
			c.Header("Vary", "Accept-Encoding")
		}

		c.Next()
	}
}

// ================================================================
// HELPER TYPES
// ================================================================

// bodyLogWriter is a custom response writer that captures the response body
type bodyLogWriter struct {
	gin.ResponseWriter
	body []byte
}

func (w *bodyLogWriter) Write(b []byte) (int, error) {
	w.body = append(w.body, b...)
	return w.ResponseWriter.Write(b)
}

// ================================================================
// HELPER FUNCTIONS
// ================================================================

// generateETag generates an ETag from the response body
func generateETag(body []byte) string {
	hash := md5.Sum(body)
	return fmt.Sprintf(`"%x"`, hash)
}

// SetCacheHeaders is a helper function to set cache headers manually
func SetCacheHeaders(c *gin.Context, maxAge int) {
	cacheControl := fmt.Sprintf("public, max-age=%d", maxAge)
	c.Header("Cache-Control", cacheControl)

	expires := time.Now().Add(time.Duration(maxAge) * time.Second)
	c.Header("Expires", expires.UTC().Format(http.TimeFormat))
	c.Header("Vary", "Accept-Encoding")
}

// SetNoCacheHeaders is a helper function to disable caching
func SetNoCacheHeaders(c *gin.Context) {
	c.Header("Cache-Control", "no-cache, no-store, must-revalidate")
	c.Header("Pragma", "no-cache")
	c.Header("Expires", "0")
}
