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
  - [토큰 검증](#토큰-검증)
  - [로그아웃](#로그아웃)
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
  "password": "string (required, min: 6, max: 64)",
  "name": "string (required, min: 2, max: 50)",
  "language_preference": "string (optional, default: 'zh', enum: ['zh', 'en', 'ko'])"
}
```

#### 응답

**상태**: `201 Created`

```json
{
  "success": true,
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "johndoe",
    "language_preference": "zh",
    "subscription_type": "free",
    "created_at": "2024-01-25T10:30:00Z"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 예시

```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecureP@ss123",
    "name": "johndoe",
    "language_preference": "zh"
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
  "message": "Login successful",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "johndoe",
    "language_preference": "zh",
    "subscription_type": "premium",
    "created_at": "2024-01-25T10:30:00Z",
    "last_login_at": "2024-01-26T08:15:00Z"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
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
  "refreshToken": "string (required)"
}
```

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 예시

```bash
curl -X POST http://localhost:3001/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
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
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "johndoe",
    "language_preference": "zh",
    "subscription_type": "premium",
    "subscription_expires_at": "2024-12-31T23:59:59Z",
    "created_at": "2024-01-25T10:30:00Z"
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
  "name": "string (optional, min: 2, max: 50)",
  "language_preference": "string (optional, enum: ['zh', 'en', 'ko'])",
  "email": "string (optional, email format)"
}
```

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "user": {
    "id": 1,
    "email": "newemail@example.com",
    "name": "newusername",
    "language_preference": "en",
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

### 토큰 검증

JWT 토큰의 유효성을 검증하고 사용자 정보를 반환합니다.

**엔드포인트**: `POST /api/auth/verify`

**인증**: 불필요

#### 요청 본문

```json
{
  "token": "string (required)"
}
```

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "valid": true,
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "johndoe"
  }
}
```

#### 예시

```bash
curl -X POST http://localhost:3001/api/auth/verify \
  -H "Content-Type: application/json" \
  -d '{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

#### 오류 응답

**상태**: `401 Unauthorized`

```json
{
  "success": false,
  "valid": false,
  "error": {
    "code": "INVALID_TOKEN",
    "message": "Token is invalid or expired"
  }
}
```

---

### 로그아웃

사용자를 로그아웃하고 리프레시 토큰을 무효화합니다.

**엔드포인트**: `POST /api/auth/logout`

**인증**: 필요 (JWT)

#### 요청 본문

```json
{
  "refreshToken": "string (optional)",
  "logoutAll": "boolean (optional, default: false)"
}
```

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

#### 예시

```bash
curl -X POST http://localhost:3001/api/auth/logout \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "logoutAll": false
  }'
```

---

### 헬스 체크

Auth Service가 정상인지 확인합니다.

**엔드포인트**: `GET /health`

> **참고**: 헬스 체크 엔드포인트는 `/api/auth/` 프리픽스를 사용하지 않습니다.

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
curl -X GET http://localhost:3001/health
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
  "name": "string (2-50 characters)",
  "language_preference": "string (enum: 'zh', 'en', 'ko')",
  "subscription_type": "string (enum: 'free', 'premium', 'vip')",
  "subscription_expires_at": "string (ISO 8601 datetime, nullable)",
  "created_at": "string (ISO 8601 datetime)",
  "updated_at": "string (ISO 8601 datetime)"
}
```

### Token

```json
{
  "accessToken": "string (JWT)",
  "refreshToken": "string (JWT)"
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
