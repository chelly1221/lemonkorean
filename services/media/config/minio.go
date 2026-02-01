package config

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

// MinIO configuration
const (
	// Use unified bucket with folder structure (same as admin-service)
	UnifiedBucket = "lemon-korean-media"
	BucketImages  = "lemon-korean-media"
	BucketAudio   = "lemon-korean-media"
	BucketVideo   = "lemon-korean-media"
)

// InitMinIO initializes and returns a MinIO client
func InitMinIO() (*minio.Client, error) {
	endpoint := getEnv("MINIO_ENDPOINT", "minio:9000")
	accessKey := getEnv("MINIO_ACCESS_KEY", "admin")
	secretKey := getEnv("MINIO_SECRET_KEY", "")
	useSSL := getEnv("MINIO_USE_SSL", "false") == "true"

	if secretKey == "" {
		return nil, fmt.Errorf("MINIO_SECRET_KEY is required")
	}

	log.Printf("[MINIO] Connecting to %s (SSL: %v)", endpoint, useSSL)

	// Initialize MinIO client
	client, err := minio.New(endpoint, &minio.Options{
		Creds:  credentials.NewStaticV4(accessKey, secretKey, ""),
		Secure: useSSL,
	})

	if err != nil {
		return nil, fmt.Errorf("failed to create MinIO client: %w", err)
	}

	// Test connection
	ctx := context.Background()
	_, err = client.ListBuckets(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to connect to MinIO: %w", err)
	}

	log.Println("[MINIO] Connected successfully")

	// Ensure buckets exist
	if err := ensureBuckets(client); err != nil {
		return nil, fmt.Errorf("failed to create buckets: %w", err)
	}

	return client, nil
}

// ensureBuckets creates required buckets if they don't exist
func ensureBuckets(client *minio.Client) error {
	ctx := context.Background()
	buckets := []string{BucketImages, BucketAudio, BucketVideo}

	for _, bucket := range buckets {
		exists, err := client.BucketExists(ctx, bucket)
		if err != nil {
			return fmt.Errorf("failed to check bucket %s: %w", bucket, err)
		}

		if !exists {
			log.Printf("[MINIO] Creating bucket: %s", bucket)
			err = client.MakeBucket(ctx, bucket, minio.MakeBucketOptions{})
			if err != nil {
				return fmt.Errorf("failed to create bucket %s: %w", bucket, err)
			}

			// Set bucket policy to public-read for images
			if bucket == BucketImages {
				policy := fmt.Sprintf(`{
					"Version": "2012-10-17",
					"Statement": [
						{
							"Effect": "Allow",
							"Principal": {"AWS": ["*"]},
							"Action": ["s3:GetObject"],
							"Resource": ["arn:aws:s3:::%s/*"]
						}
					]
				}`, bucket)

				err = client.SetBucketPolicy(ctx, bucket, policy)
				if err != nil {
					log.Printf("[MINIO] Warning: Failed to set public policy for %s: %v", bucket, err)
				}
			}

			log.Printf("[MINIO] Bucket created: %s", bucket)
		} else {
			log.Printf("[MINIO] Bucket exists: %s", bucket)
		}
	}

	return nil
}

// GetBucketName returns the appropriate bucket name for the media type
func GetBucketName(mediaType string) string {
	switch mediaType {
	case "images", "image":
		return BucketImages
	case "audio":
		return BucketAudio
	case "video":
		return BucketVideo
	default:
		return BucketImages
	}
}

// getEnv gets environment variable with fallback
func getEnv(key, fallback string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return fallback
}
