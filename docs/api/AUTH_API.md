# Auth Service API 문서

**Base URL**: `http://localhost:3001/api/auth`

**OpenAPI Version**: 3.0.3

---

## 목차

- [인증](#인증)
- [엔드포인트](#엔드포인트)
  - [사용자 등록](#사용자-등록)
  - [로그인](#로그인)
  - [토큰 갱신](#토큰-갱신)
  - [프로필 조회](#프로필-조회)
  - [프로필 업데이트](#프로필-업데이트)
  - [비밀번호 변경](#비밀번호-변경)
  - [헬스 체크](#헬스-체크)
- [오류 코드](#오류-코드)
- [데이터 모델](#데이터-모델)

---

## 인증

대부분의 엔드포인트는 JWT 인증이 필요합니다. `Authorization` 헤더에 토큰을 포함하세요:

```
Authorization: Bearer <jwt_token>
```

---

## 엔드포인트

### 사용자 등록

새 사용자 계정을 생성합니다.

**엔드포인트**: `POST /api/auth/register`

**인증**: 불필요

#### 요청 본문

```json
{
  "email": "string (required, email format)",
  "password": "string (required, min: 8, max: 64)",
  "username": "string (required, min: 3, max: 30)",
  "language": "string (optional, default: 'zh', enum: ['zh', 'en'])"
}
```

#### 응답

**상태**: `201 Created`

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

#### 예시

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

#### 오류 응답

**상태**: `400 Bad Request`

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

### 로그인

사용자를 인증하고 JWT 토큰을 받습니다.

**엔드포인트**: `POST /api/auth/login`

**인증**: 불필요

#### 요청 본문

```json
{
  "email": "string (required)",
  "password": "string (required)"
}
```

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecureP@ss123"
  }'
```

#### 오류 응답

**상태**: `401 Unauthorized`

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

### 토큰 갱신

리프레시 토큰을 사용하여 액세스 토큰을 갱신합니다.

**엔드포인트**: `POST /api/auth/refresh`

**인증**: 불필요 (리프레시 토큰 사용)

#### 요청 본문

```json
{
  "refresh_token": "string (required)"
}
```

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X POST http://localhost:3001/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

#### 오류 응답

**상태**: `401 Unauthorized`

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

### 프로필 조회

현재 사용자 프로필을 조회합니다.

**엔드포인트**: `GET /api/auth/profile`

**인증**: 필요 (JWT)

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X GET http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### 오류 응답

**상태**: `401 Unauthorized`

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

### 프로필 업데이트

사용자 프로필 정보를 업데이트합니다.

**엔드포인트**: `PUT /api/auth/profile`

**인증**: 필요 (JWT)

#### 요청 본문

```json
{
  "username": "string (optional, min: 3, max: 30)",
  "language": "string (optional, enum: ['zh', 'en'])",
  "email": "string (optional, email format)"
}
```

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X PUT http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "username": "newusername",
    "language": "en"
  }'
```

#### 오류 응답

**상태**: `409 Conflict`

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

### 비밀번호 변경

사용자 비밀번호를 변경합니다.

**엔드포인트**: `POST /api/auth/change-password`

**인증**: 필요 (JWT)

#### 요청 본문

```json
{
  "current_password": "string (required)",
  "new_password": "string (required, min: 8, max: 64)"
}
```

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "message": "Password changed successfully"
}
```

#### 예시

```bash
curl -X POST http://localhost:3001/api/auth/change-password \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "current_password": "OldP@ss123",
    "new_password": "NewSecureP@ss456"
  }'
```

#### 오류 응답

**상태**: `401 Unauthorized`

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

### 헬스 체크

Auth Service가 정상인지 확인합니다.

**엔드포인트**: `GET /api/auth/health`

**인증**: 불필요

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X GET http://localhost:3001/api/auth/health
```

---

## 오류 코드

| 코드 | HTTP 상태 | 설명 |
|------|-------------|-------------|
| `VALIDATION_ERROR` | 400 | 잘못된 입력 데이터 |
| `INVALID_EMAIL` | 422 | 이메일 형식이 잘못됨 |
| `INVALID_CREDENTIALS` | 401 | 이메일 또는 비밀번호가 올바르지 않음 |
| `ACCOUNT_LOCKED` | 423 | 계정이 일시적으로 잠김 |
| `INVALID_REFRESH_TOKEN` | 401 | 리프레시 토큰이 유효하지 않거나 만료됨 |
| `UNAUTHORIZED` | 401 | 인증 필요 |
| `EMAIL_ALREADY_EXISTS` | 409 | 이메일이 이미 등록됨 |
| `USERNAME_ALREADY_EXISTS` | 409 | 사용자 이름이 이미 사용 중 |
| `INVALID_PASSWORD` | 401 | 현재 비밀번호가 올바르지 않음 |
| `WEAK_PASSWORD` | 400 | 비밀번호가 요구 사항을 충족하지 않음 |
| `INTERNAL_SERVER_ERROR` | 500 | 서버 오류 발생 |
| `SERVICE_UNAVAILABLE` | 503 | 서비스가 일시적으로 사용 불가 |

---

## 데이터 모델

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

## OpenAPI 3.0 스펙

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
