# Auth Service API Documentation

**Base URL**: `http://localhost:3001/api/auth`

**OpenAPI Version**: 3.0.3

---

## Table of Contents

- [Authentication](#authentication)
- [Endpoints](#endpoints)
  - [Register User](#register-user)
  - [Login](#login)
  - [Refresh Token](#refresh-token)
  - [Get Profile](#get-profile)
  - [Update Profile](#update-profile)
  - [Change Password](#change-password)
  - [Health Check](#health-check)
- [Error Codes](#error-codes)
- [Data Models](#data-models)

---

## Authentication

Most endpoints require JWT authentication. Include the token in the `Authorization` header:

```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### Register User

Create a new user account.

**Endpoint**: `POST /api/auth/register`

**Authentication**: Not required

#### Request Body

```json
{
  "email": "string (required, email format)",
  "password": "string (required, min: 8, max: 64)",
  "username": "string (required, min: 3, max: 30)",
  "language": "string (optional, default: 'zh', enum: ['zh', 'en'])"
}
```

#### Response

**Status**: `201 Created`

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "username": "johndoe",
      "language": "zh",
      "subscription_type": "free",
      "created_at": "2024-01-25T10:30:00Z"
    },
    "token": {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expires_in": 604800
    }
  }
}
```

#### Example

```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecureP@ss123",
    "username": "johndoe",
    "language": "zh"
  }'
```

#### Error Responses

**Status**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid input data",
    "details": [
      {
        "field": "email",
        "message": "Email is already registered"
      }
    ]
  }
}
```

**Status**: `422 Unprocessable Entity`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_EMAIL",
    "message": "Email format is invalid"
  }
}
```

---

### Login

Authenticate user and receive JWT tokens.

**Endpoint**: `POST /api/auth/login`

**Authentication**: Not required

#### Request Body

```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "username": "johndoe",
      "language": "zh",
      "subscription_type": "premium",
      "created_at": "2024-01-25T10:30:00Z",
      "last_login": "2024-01-26T08:15:00Z"
    },
    "token": {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expires_in": 604800
    }
  }
}
```

#### Example

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecureP@ss123"
  }'
```

#### Error Responses

**Status**: `401 Unauthorized`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email or password is incorrect"
  }
}
```

**Status**: `423 Locked`

```json
{
  "success": false,
  "error": {
    "code": "ACCOUNT_LOCKED",
    "message": "Account is temporarily locked due to multiple failed login attempts",
    "retry_after": 900
  }
}
```

---

### Refresh Token

Refresh access token using refresh token.

**Endpoint**: `POST /api/auth/refresh`

**Authentication**: Not required (uses refresh token)

#### Request Body

```json
{
  "refresh_token": "string (required)"
}
```

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "token": {
      "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "expires_in": 604800
    }
  }
}
```

#### Example

```bash
curl -X POST http://localhost:3001/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

#### Error Responses

**Status**: `401 Unauthorized`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_REFRESH_TOKEN",
    "message": "Refresh token is invalid or expired"
  }
}
```

---

### Get Profile

Get current user profile.

**Endpoint**: `GET /api/auth/profile`

**Authentication**: Required (JWT)

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "id": 1,
    "email": "user@example.com",
    "username": "johndoe",
    "language": "zh",
    "subscription_type": "premium",
    "subscription_expires_at": "2024-12-31T23:59:59Z",
    "total_lessons_completed": 45,
    "streak_days": 12,
    "created_at": "2024-01-25T10:30:00Z",
    "last_login": "2024-01-26T08:15:00Z"
  }
}
```

#### Example

```bash
curl -X GET http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### Error Responses

**Status**: `401 Unauthorized`

```json
{
  "success": false,
  "error": {
    "code": "UNAUTHORIZED",
    "message": "Authentication token is missing or invalid"
  }
}
```

---

### Update Profile

Update user profile information.

**Endpoint**: `PUT /api/auth/profile`

**Authentication**: Required (JWT)

#### Request Body

```json
{
  "username": "string (optional, min: 3, max: 30)",
  "language": "string (optional, enum: ['zh', 'en'])",
  "email": "string (optional, email format)"
}
```

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "id": 1,
    "email": "newemail@example.com",
    "username": "newusername",
    "language": "en",
    "subscription_type": "premium",
    "updated_at": "2024-01-26T10:30:00Z"
  }
}
```

#### Example

```bash
curl -X PUT http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newusername",
    "language": "en"
  }'
```

#### Error Responses

**Status**: `409 Conflict`

```json
{
  "success": false,
  "error": {
    "code": "EMAIL_ALREADY_EXISTS",
    "message": "Email is already registered by another user"
  }
}
```

---

### Change Password

Change user password.

**Endpoint**: `POST /api/auth/change-password`

**Authentication**: Required (JWT)

#### Request Body

```json
{
  "current_password": "string (required)",
  "new_password": "string (required, min: 8, max: 64)"
}
```

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

#### Example

```bash
curl -X POST http://localhost:3001/api/auth/change-password \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "current_password": "OldP@ss123",
    "new_password": "NewSecureP@ss456"
  }'
```

#### Error Responses

**Status**: `401 Unauthorized`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PASSWORD",
    "message": "Current password is incorrect"
  }
}
```

**Status**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "WEAK_PASSWORD",
    "message": "New password does not meet security requirements"
  }
}
```

---

### Health Check

Check if Auth Service is healthy.

**Endpoint**: `GET /api/auth/health`

**Authentication**: Not required

#### Response

**Status**: `200 OK`

```json
{
  "status": "healthy",
  "service": "auth-service",
  "timestamp": "2024-01-26T10:30:00Z",
  "uptime": 86400,
  "database": {
    "status": "connected",
    "latency_ms": 5
  }
}
```

#### Example

```bash
curl -X GET http://localhost:3001/api/auth/health
```

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid input data |
| `INVALID_EMAIL` | 422 | Email format is invalid |
| `INVALID_CREDENTIALS` | 401 | Email or password is incorrect |
| `ACCOUNT_LOCKED` | 423 | Account temporarily locked |
| `INVALID_REFRESH_TOKEN` | 401 | Refresh token is invalid or expired |
| `UNAUTHORIZED` | 401 | Authentication required |
| `EMAIL_ALREADY_EXISTS` | 409 | Email already registered |
| `USERNAME_ALREADY_EXISTS` | 409 | Username already taken |
| `INVALID_PASSWORD` | 401 | Current password is incorrect |
| `WEAK_PASSWORD` | 400 | Password doesn't meet requirements |
| `INTERNAL_SERVER_ERROR` | 500 | Server error occurred |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |

---

## Data Models

### User

```json
{
  "id": "integer",
  "email": "string (email format)",
  "username": "string (3-30 characters)",
  "language": "string (enum: 'zh', 'en')",
  "subscription_type": "string (enum: 'free', 'premium', 'vip')",
  "subscription_expires_at": "string (ISO 8601 datetime, nullable)",
  "total_lessons_completed": "integer",
  "streak_days": "integer",
  "created_at": "string (ISO 8601 datetime)",
  "updated_at": "string (ISO 8601 datetime)",
  "last_login": "string (ISO 8601 datetime, nullable)"
}
```

### Token

```json
{
  "access_token": "string (JWT)",
  "refresh_token": "string (JWT)",
  "expires_in": "integer (seconds)"
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "string",
    "message": "string",
    "details": "array (optional)"
  }
}
```

---

## OpenAPI 3.0 Specification

```yaml
openapi: 3.0.3
info:
  title: Lemon Korean - Auth Service API
  description: Authentication and user management API for Lemon Korean platform
  version: 1.0.0
  contact:
    name: API Support
    email: support@lemonkorean.com

servers:
  - url: http://localhost:3001/api/auth
    description: Development server
  - url: https://api.lemonkorean.com/auth
    description: Production server

security:
  - BearerAuth: []

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    User:
      type: object
      properties:
        id:
          type: integer
          example: 1
        email:
          type: string
          format: email
          example: user@example.com
        username:
          type: string
          minLength: 3
          maxLength: 30
          example: johndoe
        language:
          type: string
          enum: [zh, en]
          default: zh
        subscription_type:
          type: string
          enum: [free, premium, vip]
          default: free
        subscription_expires_at:
          type: string
          format: date-time
          nullable: true
        total_lessons_completed:
          type: integer
          example: 45
        streak_days:
          type: integer
          example: 12
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
        last_login:
          type: string
          format: date-time
          nullable: true

    Token:
      type: object
      properties:
        access_token:
          type: string
          example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
        refresh_token:
          type: string
          example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
        expires_in:
          type: integer
          description: Token expiration time in seconds
          example: 604800

    Error:
      type: object
      properties:
        success:
          type: boolean
          example: false
        error:
          type: object
          properties:
            code:
              type: string
              example: VALIDATION_ERROR
            message:
              type: string
              example: Invalid input data
            details:
              type: array
              items:
                type: object

paths:
  /register:
    post:
      summary: Register new user
      security: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
                - username
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
                  minLength: 8
                  maxLength: 64
                username:
                  type: string
                  minLength: 3
                  maxLength: 30
                language:
                  type: string
                  enum: [zh, en]
                  default: zh
      responses:
        '201':
          description: User registered successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    type: object
                    properties:
                      user:
                        $ref: '#/components/schemas/User'
                      token:
                        $ref: '#/components/schemas/Token'
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /login:
    post:
      summary: Login user
      security: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
              properties:
                email:
                  type: string
                  format: email
                password:
                  type: string
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    type: object
                    properties:
                      user:
                        $ref: '#/components/schemas/User'
                      token:
                        $ref: '#/components/schemas/Token'
        '401':
          description: Invalid credentials
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /refresh:
    post:
      summary: Refresh access token
      security: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - refresh_token
              properties:
                refresh_token:
                  type: string
      responses:
        '200':
          description: Token refreshed successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    type: object
                    properties:
                      token:
                        $ref: '#/components/schemas/Token'

  /profile:
    get:
      summary: Get user profile
      responses:
        '200':
          description: Profile retrieved successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  success:
                    type: boolean
                  data:
                    $ref: '#/components/schemas/User'
    put:
      summary: Update user profile
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              properties:
                username:
                  type: string
                  minLength: 3
                  maxLength: 30
                language:
                  type: string
                  enum: [zh, en]
                email:
                  type: string
                  format: email
      responses:
        '200':
          description: Profile updated successfully

  /change-password:
    post:
      summary: Change user password
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - current_password
                - new_password
              properties:
                current_password:
                  type: string
                new_password:
                  type: string
                  minLength: 8
                  maxLength: 64
      responses:
        '200':
          description: Password changed successfully

  /health:
    get:
      summary: Health check
      security: []
      responses:
        '200':
          description: Service is healthy
```

---

**Last Updated**: 2024-01-26
**Version**: 1.0.0
