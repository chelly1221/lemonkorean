package middleware

import (
	"fmt"
	"net/http"
	"os"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v4"
)

// AuthMiddleware handles authentication
type AuthMiddleware struct {
	jwtSecret []byte
}

// NewAuthMiddleware creates a new auth middleware
func NewAuthMiddleware() *AuthMiddleware {
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		secret = "default_secret_change_in_production"
	}

	return &AuthMiddleware{
		jwtSecret: []byte(secret),
	}
}

// Claims represents JWT claims
type Claims struct {
	UserID           int64  `json:"userId"`
	Email            string `json:"email"`
	SubscriptionType string `json:"subscriptionType"`
	jwt.RegisteredClaims
}

// RequireAuth is a middleware that validates JWT token
func (am *AuthMiddleware) RequireAuth() gin.HandlerFunc {
	return func(c *gin.Context) {
		// Get Authorization header
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.JSON(http.StatusUnauthorized, gin.H{
				"error": "Unauthorized",
				"message": "Authorization header required",
			})
			c.Abort()
			return
		}

		// Check Bearer prefix
		if !strings.HasPrefix(authHeader, "Bearer ") {
			c.JSON(http.StatusUnauthorized, gin.H{
				"error": "Unauthorized",
				"message": "Invalid authorization header format",
			})
			c.Abort()
			return
		}

		// Extract token
		tokenString := strings.TrimPrefix(authHeader, "Bearer ")

		// Parse and validate token with issuer and audience validation
		token, err := jwt.ParseWithClaims(tokenString, &Claims{}, func(token *jwt.Token) (interface{}, error) {
			// Validate signing method
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
			}
			return am.jwtSecret, nil
		}, jwt.WithValidMethods([]string{"HS256"}),
			jwt.WithIssuer("lemon-korean-auth"),
			jwt.WithAudience("lemon-korean-api"))

		if err != nil {
			c.JSON(http.StatusUnauthorized, gin.H{
				"error": "Unauthorized",
				"message": "Invalid or expired token",
			})
			c.Abort()
			return
		}

		// Extract claims
		claims, ok := token.Claims.(*Claims)
		if !ok || !token.Valid {
			c.JSON(http.StatusUnauthorized, gin.H{
				"error": "Unauthorized",
				"message": "Invalid token claims",
			})
			c.Abort()
			return
		}

		// Set user info in context
		c.Set("userId", claims.UserID)
		c.Set("email", claims.Email)
		c.Set("subscriptionType", claims.SubscriptionType)

		c.Next()
	}
}

// RequirePremium checks if user has premium subscription
func (am *AuthMiddleware) RequirePremium() gin.HandlerFunc {
	return func(c *gin.Context) {
		subscriptionType, exists := c.Get("subscriptionType")
		if !exists {
			c.JSON(http.StatusForbidden, gin.H{
				"error": "Forbidden",
				"message": "Subscription type not found",
			})
			c.Abort()
			return
		}

		subType, ok := subscriptionType.(string)
		if !ok || (subType != "premium" && subType != "premium_plus") {
			c.JSON(http.StatusForbidden, gin.H{
				"error": "Forbidden",
				"message": "Premium subscription required",
			})
			c.Abort()
			return
		}

		c.Next()
	}
}

// GetUserID extracts user ID from context
func GetUserID(c *gin.Context) (int64, error) {
	userID, exists := c.Get("userId")
	if !exists {
		return 0, fmt.Errorf("user ID not found in context")
	}

	id, ok := userID.(int64)
	if !ok {
		return 0, fmt.Errorf("invalid user ID type")
	}

	return id, nil
}

// GetEmail extracts email from context
func GetEmail(c *gin.Context) (string, error) {
	email, exists := c.Get("email")
	if !exists {
		return "", fmt.Errorf("email not found in context")
	}

	emailStr, ok := email.(string)
	if !ok {
		return "", fmt.Errorf("invalid email type")
	}

	return emailStr, nil
}
