package config

import (
	"os"
	"strings"
)

// CORSConfig holds CORS configuration
type CORSConfig struct {
	AllowedOrigins []string
	AllowedMethods []string
	AllowedHeaders []string
}

// GetCORSConfig returns CORS configuration based on environment
func GetCORSConfig() *CORSConfig {
	env := os.Getenv("NODE_ENV")

	config := &CORSConfig{
		AllowedMethods: []string{"GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"},
		AllowedHeaders: []string{
			"Content-Type",
			"Content-Length",
			"Accept-Encoding",
			"X-CSRF-Token",
			"Authorization",
			"accept",
			"origin",
			"Cache-Control",
			"X-Requested-With",
		},
	}

	if env == "production" {
		// Production: Strict origin validation - Single domain architecture
		config.AllowedOrigins = []string{
			"https://lemon.3chan.kr",
			"https://www.lemon.3chan.kr",
		}
	} else {
		// Development: Permissive for local testing
		config.AllowedOrigins = []string{
			"http://localhost",
			"http://localhost:3007",
			"http://localhost:80",
			"http://127.0.0.1",
			"http://127.0.0.1:3007",
			"http://lemon.3chan.kr:3007", // Dev server port
			"http://lemon.3chan.kr",      // Dev domain (nginx)
		}
	}

	return config
}

// IsOriginAllowed checks if an origin is in the allowed list
func (c *CORSConfig) IsOriginAllowed(origin string) bool {
	if origin == "" {
		return false
	}

	for _, allowed := range c.AllowedOrigins {
		if origin == allowed {
			return true
		}
		// Also allow with trailing slash
		if strings.TrimSuffix(origin, "/") == allowed {
			return true
		}
	}

	return false
}
