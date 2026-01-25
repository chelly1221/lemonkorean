package handlers

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"path/filepath"
	"strconv"
	"strings"
	"time"

	"lemonkorean/media/config"
	"lemonkorean/media/utils"

	"github.com/gin-gonic/gin"
	"github.com/minio/minio-go/v7"
)

// MediaHandler handles media-related requests
type MediaHandler struct {
	minioClient *minio.Client
}

// NewMediaHandler creates a new media handler
func NewMediaHandler(minioClient *minio.Client) *MediaHandler {
	return &MediaHandler{
		minioClient: minioClient,
	}
}

// ================================================================
// CONSTANTS
// ================================================================

const (
	DefaultThumbnailSize = 200
	MaxImageWidth        = 1920
	MaxImageHeight       = 1920
	DefaultImageQuality  = 85
	CacheMaxAge          = 604800 // 7 days
)

// ================================================================
// HANDLER 1: SERVE IMAGE (WITH RESIZING OPTIONS)
// ================================================================

// ServeImage serves an image with optional resizing and WebP conversion
// GET /media/images/:key?width=800&height=600&format=webp
func (h *MediaHandler) ServeImage(c *gin.Context) {
	key := c.Param("key")
	if key == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "Image key is required",
		})
		return
	}

	// Parse query parameters
	widthStr := c.Query("width")
	heightStr := c.Query("height")
	format := c.Query("format") // webp, jpeg, png
	quality := c.DefaultQuery("quality", "85")

	log.Printf("[MEDIA] Serving image: %s (width=%s, height=%s, format=%s)",
		key, widthStr, heightStr, format)

	ctx := context.Background()

	// Fetch from MinIO
	object, err := h.minioClient.GetObject(ctx, config.BucketImages, key, minio.GetObjectOptions{})
	if err != nil {
		log.Printf("[MEDIA] Error fetching image: %v", err)
		c.JSON(http.StatusNotFound, gin.H{
			"error":   "Not Found",
			"message": "Image not found",
		})
		return
	}
	defer object.Close()

	// Get object info
	stat, err := object.Stat()
	if err != nil {
		log.Printf("[MEDIA] Error getting image stat: %v", err)
		c.JSON(http.StatusNotFound, gin.H{
			"error":   "Not Found",
			"message": "Image not found",
		})
		return
	}

	// Check if client has cached version (ETag)
	clientETag := c.GetHeader("If-None-Match")
	if clientETag == stat.ETag {
		c.Status(http.StatusNotModified)
		return
	}

	// Read image data
	imageData, err := io.ReadAll(object)
	if err != nil {
		log.Printf("[MEDIA] Error reading image: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Internal Server Error",
			"message": "Failed to read image",
		})
		return
	}

	// Check if resizing or format conversion is needed
	needsProcessing := widthStr != "" || heightStr != "" || format != ""

	var finalData io.Reader
	var contentType string

	if needsProcessing {
		// Parse dimensions
		width, _ := strconv.Atoi(widthStr)
		height, _ := strconv.Atoi(heightStr)
		qualityInt, _ := strconv.Atoi(quality)

		// Build optimization config
		config := utils.OptimizationConfig{
			MaxWidth:      MaxImageWidth,
			MaxHeight:     MaxImageHeight,
			Quality:       qualityInt,
			ConvertToWebP: format == "webp",
		}

		// Apply specific dimensions if provided
		if width > 0 {
			config.MaxWidth = width
		}
		if height > 0 {
			config.MaxHeight = height
		}

		// Optimize/resize image
		optimized, ct, err := utils.OptimizeImageWithConfig(
			bytes.NewReader(imageData),
			key,
			config,
		)
		if err != nil {
			log.Printf("[MEDIA] Error optimizing image: %v", err)
			// Fall back to original
			finalData = bytes.NewReader(imageData)
			contentType = stat.ContentType
		} else {
			finalData = optimized
			contentType = ct
		}
	} else {
		// Serve original
		finalData = bytes.NewReader(imageData)
		contentType = stat.ContentType
	}

	// Set default content type if empty
	if contentType == "" {
		contentType = getContentType(key)
	}

	// Set cache headers
	h.setCacheHeaders(c, stat.ETag, stat.LastModified)
	c.Header("Content-Type", contentType)

	// Stream to client
	io.Copy(c.Writer, finalData)
}

// ================================================================
// HANDLER 2: SERVE AUDIO (STREAMING)
// ================================================================

// ServeAudio serves audio files with range support for streaming
// GET /media/audio/:key
func (h *MediaHandler) ServeAudio(c *gin.Context) {
	key := c.Param("key")
	if key == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "Audio key is required",
		})
		return
	}

	log.Printf("[MEDIA] Streaming audio: %s", key)

	ctx := context.Background()

	// Fetch from MinIO
	object, err := h.minioClient.GetObject(ctx, config.BucketAudio, key, minio.GetObjectOptions{})
	if err != nil {
		log.Printf("[MEDIA] Error fetching audio: %v", err)
		c.JSON(http.StatusNotFound, gin.H{
			"error":   "Not Found",
			"message": "Audio not found",
		})
		return
	}
	defer object.Close()

	// Get object info
	stat, err := object.Stat()
	if err != nil {
		log.Printf("[MEDIA] Error getting audio stat: %v", err)
		c.JSON(http.StatusNotFound, gin.H{
			"error":   "Not Found",
			"message": "Audio not found",
		})
		return
	}

	// Check ETag for caching
	clientETag := c.GetHeader("If-None-Match")
	if clientETag == stat.ETag {
		c.Status(http.StatusNotModified)
		return
	}

	// Set content type
	contentType := stat.ContentType
	if contentType == "" {
		contentType = getContentType(key)
	}

	// Set headers for streaming
	c.Header("Content-Type", contentType)
	c.Header("Content-Length", fmt.Sprintf("%d", stat.Size))
	c.Header("Accept-Ranges", "bytes")
	c.Header("Cache-Control", fmt.Sprintf("public, max-age=%d", CacheMaxAge))
	c.Header("ETag", stat.ETag)
	c.Header("Last-Modified", stat.LastModified.UTC().Format(http.TimeFormat))

	// Check for range request
	rangeHeader := c.GetHeader("Range")
	if rangeHeader != "" {
		h.serveRangeRequest(c, object, stat.Size, contentType, rangeHeader)
		return
	}

	// Stream entire file
	c.Status(http.StatusOK)
	io.Copy(c.Writer, object)
}

// ================================================================
// HANDLER 3: SERVE THUMBNAIL
// ================================================================

// ServeThumbnail generates and serves a thumbnail
// GET /media/thumbnails/:key?size=200
func (h *MediaHandler) ServeThumbnail(c *gin.Context) {
	key := c.Param("key")
	if key == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "Image key is required",
		})
		return
	}

	// Parse size parameter
	sizeStr := c.DefaultQuery("size", fmt.Sprintf("%d", DefaultThumbnailSize))
	size, err := strconv.Atoi(sizeStr)
	if err != nil || size <= 0 || size > 1000 {
		size = DefaultThumbnailSize
	}

	log.Printf("[MEDIA] Generating thumbnail: %s (size=%d)", key, size)

	ctx := context.Background()

	// Fetch original image from MinIO
	object, err := h.minioClient.GetObject(ctx, config.BucketImages, key, minio.GetObjectOptions{})
	if err != nil {
		log.Printf("[MEDIA] Error fetching image for thumbnail: %v", err)
		c.JSON(http.StatusNotFound, gin.H{
			"error":   "Not Found",
			"message": "Image not found",
		})
		return
	}
	defer object.Close()

	// Get object info
	stat, err := object.Stat()
	if err != nil {
		log.Printf("[MEDIA] Error getting image stat: %v", err)
		c.JSON(http.StatusNotFound, gin.H{
			"error":   "Not Found",
			"message": "Image not found",
		})
		return
	}

	// Read image data
	imageData, err := io.ReadAll(object)
	if err != nil {
		log.Printf("[MEDIA] Error reading image: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Internal Server Error",
			"message": "Failed to read image",
		})
		return
	}

	// Generate thumbnail
	thumbnail, err := utils.CreateThumbnail(bytes.NewReader(imageData), size)
	if err != nil {
		log.Printf("[MEDIA] Error creating thumbnail: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Internal Server Error",
			"message": "Failed to create thumbnail",
		})
		return
	}

	// Set cache headers
	h.setCacheHeaders(c, stat.ETag, stat.LastModified)
	c.Header("Content-Type", "image/jpeg")
	c.Header("X-Thumbnail-Size", fmt.Sprintf("%d", size))

	// Stream thumbnail
	c.Status(http.StatusOK)
	io.Copy(c.Writer, thumbnail)
}

// ================================================================
// HANDLER 4: UPLOAD MEDIA (ADMIN ONLY)
// ================================================================

// UploadMedia handles media file upload with automatic optimization
// POST /media/upload?type=images|audio|video
// Requires admin authentication (add middleware in routes)
func (h *MediaHandler) UploadMedia(c *gin.Context) {
	// Get media type from query
	mediaType := c.DefaultQuery("type", "images")

	// Validate media type
	if !isValidMediaType(mediaType) {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "Invalid media type. Supported: images, audio, video",
		})
		return
	}

	// Get file from form
	file, err := c.FormFile("file")
	if err != nil {
		log.Printf("[MEDIA] Error getting file: %v", err)
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "File is required",
		})
		return
	}

	log.Printf("[MEDIA] Uploading %s: %s (size: %d bytes)", mediaType, file.Filename, file.Size)

	// Validate file type based on media type
	if !isValidFileForType(file.Filename, mediaType) {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": fmt.Sprintf("Invalid file format for %s", mediaType),
		})
		return
	}

	// Open file
	src, err := file.Open()
	if err != nil {
		log.Printf("[MEDIA] Error opening file: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Internal Server Error",
			"message": "Failed to process file",
		})
		return
	}
	defer src.Close()

	// Get bucket name
	bucket := config.GetBucketName(mediaType)

	// Generate unique key
	key := generateKey(file.Filename)

	var finalData io.Reader
	var contentType string
	var uploadSize int64 = file.Size

	// Optimize images automatically
	if mediaType == "images" {
		optimized, ct, err := utils.OptimizeImage(src, file.Filename)
		if err != nil {
			log.Printf("[MEDIA] Error optimizing image: %v, using original", err)
			// Seek back to beginning if optimization fails
			if seeker, ok := src.(io.Seeker); ok {
				seeker.Seek(0, 0)
			}
			finalData = src
			contentType = getContentType(file.Filename)
		} else {
			finalData = optimized
			contentType = ct
			uploadSize = -1 // Unknown size after optimization
		}
	} else {
		// Audio and video: upload as-is
		finalData = src
		contentType = getContentType(file.Filename)
	}

	// Upload to MinIO
	ctx := context.Background()
	info, err := h.minioClient.PutObject(ctx, bucket, key, finalData, uploadSize, minio.PutObjectOptions{
		ContentType: contentType,
	})

	if err != nil {
		log.Printf("[MEDIA] Error uploading to MinIO: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Internal Server Error",
			"message": "Failed to upload file",
		})
		return
	}

	log.Printf("[MEDIA] File uploaded successfully: %s/%s (size: %d bytes)", bucket, key, info.Size)

	c.JSON(http.StatusOK, gin.H{
		"success":      true,
		"message":      "File uploaded successfully",
		"type":         mediaType,
		"key":          key,
		"url":          fmt.Sprintf("/media/%s/%s", mediaType, key),
		"size":         info.Size,
		"content_type": contentType,
	})
}

// ================================================================
// HANDLER 5: DELETE MEDIA (ADMIN ONLY)
// ================================================================

// DeleteMedia deletes a media file from MinIO
// DELETE /media/:type/:key
// Requires admin authentication (add middleware in routes)
func (h *MediaHandler) DeleteMedia(c *gin.Context) {
	mediaType := c.Param("type")
	key := c.Param("key")

	if mediaType == "" || key == "" {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "Media type and key are required",
		})
		return
	}

	// Validate media type
	if !isValidMediaType(mediaType) {
		c.JSON(http.StatusBadRequest, gin.H{
			"error":   "Bad Request",
			"message": "Invalid media type",
		})
		return
	}

	log.Printf("[MEDIA] Deleting %s: %s", mediaType, key)

	bucket := config.GetBucketName(mediaType)
	ctx := context.Background()

	// Check if object exists
	_, err := h.minioClient.StatObject(ctx, bucket, key, minio.StatObjectOptions{})
	if err != nil {
		log.Printf("[MEDIA] Object not found: %v", err)
		c.JSON(http.StatusNotFound, gin.H{
			"error":   "Not Found",
			"message": "Media file not found",
		})
		return
	}

	// Delete object
	err = h.minioClient.RemoveObject(ctx, bucket, key, minio.RemoveObjectOptions{})
	if err != nil {
		log.Printf("[MEDIA] Error deleting media: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"error":   "Internal Server Error",
			"message": "Failed to delete media",
		})
		return
	}

	log.Printf("[MEDIA] Media deleted successfully: %s/%s", mediaType, key)

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "Media deleted successfully",
		"type":    mediaType,
		"key":     key,
	})
}

// ================================================================
// HELPER FUNCTIONS
// ================================================================

// setCacheHeaders sets comprehensive cache headers
func (h *MediaHandler) setCacheHeaders(c *gin.Context, etag string, lastModified time.Time) {
	c.Header("Cache-Control", fmt.Sprintf("public, max-age=%d", CacheMaxAge))
	c.Header("ETag", etag)
	c.Header("Last-Modified", lastModified.UTC().Format(http.TimeFormat))

	expires := time.Now().Add(time.Duration(CacheMaxAge) * time.Second)
	c.Header("Expires", expires.UTC().Format(http.TimeFormat))

	c.Header("Vary", "Accept-Encoding")
}

// serveRangeRequest handles HTTP range requests for audio/video streaming
func (h *MediaHandler) serveRangeRequest(c *gin.Context, object io.ReadSeeker, size int64, contentType, rangeHeader string) {
	// Parse range header: "bytes=start-end"
	ranges := strings.TrimPrefix(rangeHeader, "bytes=")
	parts := strings.Split(ranges, "-")

	var start, end int64
	var err error

	// Parse start
	if parts[0] != "" {
		start, err = strconv.ParseInt(parts[0], 10, 64)
		if err != nil {
			c.Status(http.StatusRequestedRangeNotSatisfiable)
			return
		}
	}

	// Parse end
	if len(parts) > 1 && parts[1] != "" {
		end, err = strconv.ParseInt(parts[1], 10, 64)
		if err != nil {
			end = size - 1
		}
	} else {
		end = size - 1
	}

	// Validate range
	if start < 0 || start >= size || end >= size || start > end {
		c.Status(http.StatusRequestedRangeNotSatisfiable)
		return
	}

	// Seek to start position
	_, err = object.Seek(start, io.SeekStart)
	if err != nil {
		log.Printf("[MEDIA] Error seeking to position: %v", err)
		c.Status(http.StatusInternalServerError)
		return
	}

	// Calculate content length
	contentLength := end - start + 1

	// Set headers for partial content
	c.Header("Content-Type", contentType)
	c.Header("Content-Length", fmt.Sprintf("%d", contentLength))
	c.Header("Content-Range", fmt.Sprintf("bytes %d-%d/%d", start, end, size))
	c.Header("Accept-Ranges", "bytes")
	c.Status(http.StatusPartialContent)

	// Stream the requested range
	io.CopyN(c.Writer, object, contentLength)
}

// generateKey generates a unique key for the file
func generateKey(filename string) string {
	ext := filepath.Ext(filename)
	timestamp := time.Now().Unix()
	baseFilename := filename[:len(filename)-len(ext)]
	// Clean filename: remove spaces, special characters
	baseFilename = strings.ReplaceAll(baseFilename, " ", "_")
	baseFilename = strings.ReplaceAll(baseFilename, "(", "")
	baseFilename = strings.ReplaceAll(baseFilename, ")", "")

	return fmt.Sprintf("%d_%s%s", timestamp, baseFilename, ext)
}

// getContentType returns the content type based on file extension
func getContentType(filename string) string {
	ext := strings.ToLower(filepath.Ext(filename))
	switch ext {
	// Images
	case ".jpg", ".jpeg":
		return "image/jpeg"
	case ".png":
		return "image/png"
	case ".gif":
		return "image/gif"
	case ".webp":
		return "image/webp"
	case ".svg":
		return "image/svg+xml"
	case ".bmp":
		return "image/bmp"
	// Audio
	case ".mp3":
		return "audio/mpeg"
	case ".wav":
		return "audio/wav"
	case ".ogg":
		return "audio/ogg"
	case ".m4a":
		return "audio/mp4"
	case ".aac":
		return "audio/aac"
	case ".flac":
		return "audio/flac"
	// Video
	case ".mp4":
		return "video/mp4"
	case ".webm":
		return "video/webm"
	case ".mov":
		return "video/quicktime"
	case ".avi":
		return "video/x-msvideo"
	default:
		return "application/octet-stream"
	}
}

// isValidMediaType checks if media type is valid
func isValidMediaType(mediaType string) bool {
	validTypes := []string{"images", "image", "audio", "video"}
	for _, validType := range validTypes {
		if mediaType == validType {
			return true
		}
	}
	return false
}

// isValidFileForType checks if file extension is valid for the media type
func isValidFileForType(filename, mediaType string) bool {
	switch mediaType {
	case "images", "image":
		return isValidImageType(filename)
	case "audio":
		return isValidAudioType(filename)
	case "video":
		return isValidVideoType(filename)
	default:
		return false
	}
}

// isValidImageType checks if the file is a valid image type
func isValidImageType(filename string) bool {
	ext := strings.ToLower(filepath.Ext(filename))
	validExts := []string{".jpg", ".jpeg", ".png", ".gif", ".webp", ".bmp"}
	for _, validExt := range validExts {
		if ext == validExt {
			return true
		}
	}
	return false
}

// isValidAudioType checks if the file is a valid audio type
func isValidAudioType(filename string) bool {
	ext := strings.ToLower(filepath.Ext(filename))
	validExts := []string{".mp3", ".wav", ".ogg", ".m4a", ".aac", ".flac"}
	for _, validExt := range validExts {
		if ext == validExt {
			return true
		}
	}
	return false
}

// isValidVideoType checks if the file is a valid video type
func isValidVideoType(filename string) bool {
	ext := strings.ToLower(filepath.Ext(filename))
	validExts := []string{".mp4", ".webm", ".mov", ".avi"}
	for _, validExt := range validExts {
		if ext == validExt {
			return true
		}
	}
	return false
}
