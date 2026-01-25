package utils

import (
	"bytes"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"io"
	"path/filepath"
	"strings"

	"github.com/disintegration/imaging"
)

// ================================================================
// IMAGE OPTIMIZATION
// ================================================================

// OptimizationConfig defines optimization parameters
type OptimizationConfig struct {
	MaxWidth      int
	MaxHeight     int
	Quality       int
	ConvertToWebP bool
}

// DefaultConfig returns default optimization settings
var DefaultConfig = OptimizationConfig{
	MaxWidth:      1920,
	MaxHeight:     1920,
	Quality:       85,
	ConvertToWebP: false, // Disabled by default, can be enabled per request
}

// ================================================================
// MAIN OPTIMIZATION FUNCTION
// ================================================================

// OptimizeImage optimizes an image for web delivery
// Returns optimized image reader, content type, and error
func OptimizeImage(src io.Reader, filename string) (io.Reader, string, error) {
	return OptimizeImageWithConfig(src, filename, DefaultConfig)
}

// OptimizeImageWithConfig optimizes with custom configuration
func OptimizeImageWithConfig(src io.Reader, filename string, config OptimizationConfig) (io.Reader, string, error) {
	// Read image data
	imgData, err := io.ReadAll(src)
	if err != nil {
		return nil, "", fmt.Errorf("failed to read image data: %w", err)
	}

	// Decode image
	img, format, err := image.Decode(bytes.NewReader(imgData))
	if err != nil {
		return nil, "", fmt.Errorf("failed to decode image: %w", err)
	}

	// Get original dimensions
	bounds := img.Bounds()
	width := bounds.Dx()
	height := bounds.Dy()

	// Resize if necessary
	if width > config.MaxWidth || height > config.MaxHeight {
		img = imaging.Fit(img, config.MaxWidth, config.MaxHeight, imaging.Lanczos)
	}

	// Determine output format
	outputFormat := format
	contentType := getContentTypeFromFormat(format)

	// Convert to WebP if requested (currently disabled by default)
	if config.ConvertToWebP && supportsWebPConversion(format) {
		outputFormat = "webp"
		contentType = "image/webp"
	}

	// Encode optimized image
	var buf bytes.Buffer
	switch outputFormat {
	case "jpeg", "jpg":
		err = jpeg.Encode(&buf, img, &jpeg.Options{Quality: config.Quality})
	case "png":
		encoder := png.Encoder{CompressionLevel: png.BestCompression}
		err = encoder.Encode(&buf, img)
	case "webp":
		// WebP encoding would go here if enabled
		// For now, fall back to JPEG
		err = jpeg.Encode(&buf, img, &jpeg.Options{Quality: config.Quality})
		contentType = "image/jpeg"
	default:
		// For unsupported formats, encode as JPEG
		err = jpeg.Encode(&buf, img, &jpeg.Options{Quality: config.Quality})
		contentType = "image/jpeg"
	}

	if err != nil {
		return nil, "", fmt.Errorf("failed to encode optimized image: %w", err)
	}

	return bytes.NewReader(buf.Bytes()), contentType, nil
}

// ================================================================
// RESIZE FUNCTIONS
// ================================================================

// ResizeImage resizes an image to specific dimensions
func ResizeImage(src io.Reader, width, height int) (io.Reader, error) {
	imgData, err := io.ReadAll(src)
	if err != nil {
		return nil, err
	}

	img, _, err := image.Decode(bytes.NewReader(imgData))
	if err != nil {
		return nil, err
	}

	resized := imaging.Resize(img, width, height, imaging.Lanczos)

	var buf bytes.Buffer
	err = jpeg.Encode(&buf, resized, &jpeg.Options{Quality: 85})
	if err != nil {
		return nil, err
	}

	return bytes.NewReader(buf.Bytes()), nil
}

// CreateThumbnail creates a thumbnail of specified size
func CreateThumbnail(src io.Reader, size int) (io.Reader, error) {
	imgData, err := io.ReadAll(src)
	if err != nil {
		return nil, err
	}

	img, _, err := image.Decode(bytes.NewReader(imgData))
	if err != nil {
		return nil, err
	}

	// Use Fit to maintain aspect ratio
	thumbnail := imaging.Fit(img, size, size, imaging.Lanczos)

	var buf bytes.Buffer
	err = jpeg.Encode(&buf, thumbnail, &jpeg.Options{Quality: 80})
	if err != nil {
		return nil, err
	}

	return bytes.NewReader(buf.Bytes()), nil
}

// ================================================================
// HELPER FUNCTIONS
// ================================================================

// getContentTypeFromFormat returns MIME type for image format
func getContentTypeFromFormat(format string) string {
	switch strings.ToLower(format) {
	case "jpeg", "jpg":
		return "image/jpeg"
	case "png":
		return "image/png"
	case "gif":
		return "image/gif"
	case "webp":
		return "image/webp"
	default:
		return "application/octet-stream"
	}
}

// supportsWebPConversion checks if format can be converted to WebP
func supportsWebPConversion(format string) bool {
	format = strings.ToLower(format)
	return format == "jpeg" || format == "jpg" || format == "png"
}

// GetImageDimensions returns width and height of an image
func GetImageDimensions(src io.Reader) (int, int, error) {
	imgData, err := io.ReadAll(src)
	if err != nil {
		return 0, 0, err
	}

	img, _, err := image.Decode(bytes.NewReader(imgData))
	if err != nil {
		return 0, 0, err
	}

	bounds := img.Bounds()
	return bounds.Dx(), bounds.Dy(), nil
}

// ValidateImage checks if the file is a valid image
func ValidateImage(src io.Reader) (bool, string, error) {
	imgData, err := io.ReadAll(src)
	if err != nil {
		return false, "", err
	}

	_, format, err := image.Decode(bytes.NewReader(imgData))
	if err != nil {
		return false, "", nil // Not a valid image
	}

	return true, format, nil
}

// GetImageInfo returns comprehensive information about an image
type ImageInfo struct {
	Width       int
	Height      int
	Format      string
	Size        int64
	AspectRatio float64
}

// GetImageInfoFromReader analyzes an image and returns info
func GetImageInfoFromReader(src io.Reader) (*ImageInfo, error) {
	imgData, err := io.ReadAll(src)
	if err != nil {
		return nil, err
	}

	img, format, err := image.Decode(bytes.NewReader(imgData))
	if err != nil {
		return nil, err
	}

	bounds := img.Bounds()
	width := bounds.Dx()
	height := bounds.Dy()

	info := &ImageInfo{
		Width:       width,
		Height:      height,
		Format:      format,
		Size:        int64(len(imgData)),
		AspectRatio: float64(width) / float64(height),
	}

	return info, nil
}

// ================================================================
// BATCH PROCESSING
// ================================================================

// GenerateMultipleSizes creates multiple versions of an image
func GenerateMultipleSizes(src io.Reader, sizes []int) (map[int]io.Reader, error) {
	imgData, err := io.ReadAll(src)
	if err != nil {
		return nil, err
	}

	img, _, err := image.Decode(bytes.NewReader(imgData))
	if err != nil {
		return nil, err
	}

	results := make(map[int]io.Reader)

	for _, size := range sizes {
		resized := imaging.Fit(img, size, size, imaging.Lanczos)

		var buf bytes.Buffer
		err = jpeg.Encode(&buf, resized, &jpeg.Options{Quality: 85})
		if err != nil {
			continue
		}

		results[size] = bytes.NewReader(buf.Bytes())
	}

	return results, nil
}

// ================================================================
// FILE TYPE VALIDATION
// ================================================================

// IsValidImageExtension checks if file extension is valid for images
func IsValidImageExtension(filename string) bool {
	ext := strings.ToLower(filepath.Ext(filename))
	validExts := []string{".jpg", ".jpeg", ".png", ".gif", ".webp"}

	for _, validExt := range validExts {
		if ext == validExt {
			return true
		}
	}

	return false
}

// GetOptimalQuality returns optimal quality based on image size
func GetOptimalQuality(width, height int) int {
	pixels := width * height

	switch {
	case pixels > 2000000: // > 2MP
		return 80
	case pixels > 1000000: // > 1MP
		return 85
	default:
		return 90
	}
}
