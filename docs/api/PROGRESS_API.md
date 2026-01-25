# Progress Service API Documentation

**Base URL**: `http://localhost:3003/api/progress`

**OpenAPI Version**: 3.0.3

---

## Table of Contents

- [Authentication](#authentication)
- [Endpoints](#endpoints)
  - [Get User Progress](#get-user-progress)
  - [Complete Lesson](#complete-lesson)
  - [Update Lesson Progress](#update-lesson-progress)
  - [Sync Offline Progress](#sync-offline-progress)
  - [Get Review Schedule](#get-review-schedule)
  - [Submit Review Result](#submit-review-result)
  - [Get Statistics](#get-statistics)
  - [Get Streak](#get-streak)
  - [Health Check](#health-check)
- [Error Codes](#error-codes)
- [Data Models](#data-models)

---

## Authentication

All endpoints except `/health` require JWT authentication:

```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### Get User Progress

Get user's learning progress for all lessons.

**Endpoint**: `GET /api/progress/user/:userId`

**Authentication**: Required (JWT)

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | integer | Yes | User ID (must match authenticated user) |

#### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `status` | string | No | - | Filter by status (not_started, in_progress, completed) |
| `level` | string | No | - | Filter by lesson level |

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "progress": [
      {
        "lesson_id": 1,
        "lesson_title_ko": "안녕하세요",
        "lesson_title_zh": "你好",
        "lesson_level": "beginner",
        "status": "completed",
        "current_stage": 7,
        "total_stages": 7,
        "progress_percentage": 100,
        "quiz_score": 95,
        "quiz_attempts": 1,
        "time_spent_seconds": 1800,
        "started_at": "2024-01-25T10:00:00Z",
        "completed_at": "2024-01-25T10:30:00Z",
        "last_accessed": "2024-01-25T10:30:00Z"
      },
      {
        "lesson_id": 2,
        "lesson_title_ko": "자기소개",
        "lesson_title_zh": "自我介绍",
        "lesson_level": "beginner",
        "status": "in_progress",
        "current_stage": 3,
        "total_stages": 7,
        "progress_percentage": 43,
        "quiz_score": null,
        "quiz_attempts": 0,
        "time_spent_seconds": 600,
        "started_at": "2024-01-26T09:00:00Z",
        "completed_at": null,
        "last_accessed": "2024-01-26T09:10:00Z"
      }
    ],
    "summary": {
      "total_lessons": 150,
      "completed_lessons": 45,
      "in_progress_lessons": 8,
      "not_started_lessons": 97,
      "completion_rate": 30.0,
      "average_quiz_score": 87.5,
      "total_time_spent_hours": 67.5
    }
  }
}
```

#### Example

```bash
curl -X GET http://localhost:3003/api/progress/user/1 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### Error Responses

**Status**: `403 Forbidden`

```json
{
  "success": false,
  "error": {
    "code": "FORBIDDEN",
    "message": "You can only access your own progress"
  }
}
```

---

### Complete Lesson

Mark a lesson as completed.

**Endpoint**: `POST /api/progress/complete`

**Authentication**: Required (JWT)

#### Request Body

```json
{
  "user_id": 1,
  "lesson_id": 1,
  "quiz_score": 95,
  "time_spent_seconds": 1800,
  "completed_at": "2024-01-26T10:30:00Z"
}
```

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "lesson_id": 1,
    "status": "completed",
    "quiz_score": 95,
    "passed": true,
    "time_spent_seconds": 1800,
    "completed_at": "2024-01-26T10:30:00Z",
    "achievements": [
      {
        "type": "lesson_completed",
        "title": "完成第一课",
        "description": "完成了你的第一堂韩语课程",
        "icon": "🎉"
      },
      {
        "type": "perfect_score",
        "title": "完美得分",
        "description": "测验获得90分以上",
        "icon": "⭐"
      }
    ],
    "next_review_date": "2024-01-27T10:30:00Z",
    "srs_level": 1
  }
}
```

#### Example

```bash
curl -X POST http://localhost:3003/api/progress/complete \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "lesson_id": 1,
    "quiz_score": 95,
    "time_spent_seconds": 1800,
    "completed_at": "2024-01-26T10:30:00Z"
  }'
```

#### Error Responses

**Status**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_QUIZ_SCORE",
    "message": "Quiz score must be between 0 and 100"
  }
}
```

---

### Update Lesson Progress

Update progress for a specific stage of a lesson.

**Endpoint**: `PUT /api/progress/lesson/:lessonId`

**Authentication**: Required (JWT)

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `lessonId` | integer | Yes | Lesson ID |

#### Request Body

```json
{
  "user_id": 1,
  "current_stage": 3,
  "stage_data": {
    "vocabulary_learned": 8,
    "grammar_practiced": 2,
    "exercises_completed": 5
  },
  "time_spent_seconds": 600
}
```

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "lesson_id": 2,
    "status": "in_progress",
    "current_stage": 3,
    "total_stages": 7,
    "progress_percentage": 43,
    "time_spent_seconds": 1200,
    "last_accessed": "2024-01-26T10:30:00Z"
  }
}
```

#### Example

```bash
curl -X PUT http://localhost:3003/api/progress/lesson/2 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "current_stage": 3,
    "time_spent_seconds": 600
  }'
```

---

### Sync Offline Progress

Sync progress data collected while offline.

**Endpoint**: `POST /api/progress/sync`

**Authentication**: Required (JWT)

#### Request Body

```json
{
  "user_id": 1,
  "sync_items": [
    {
      "type": "lesson_complete",
      "lesson_id": 1,
      "quiz_score": 95,
      "time_spent_seconds": 1800,
      "completed_at": "2024-01-25T10:30:00Z",
      "client_timestamp": "2024-01-25T10:30:00Z"
    },
    {
      "type": "lesson_progress",
      "lesson_id": 2,
      "current_stage": 3,
      "time_spent_seconds": 600,
      "client_timestamp": "2024-01-26T09:10:00Z"
    },
    {
      "type": "review_complete",
      "lesson_id": 1,
      "quality": 4,
      "reviewed_at": "2024-01-26T08:00:00Z",
      "client_timestamp": "2024-01-26T08:00:00Z"
    }
  ]
}
```

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "synced_count": 3,
    "failed_count": 0,
    "synced_items": [
      {
        "index": 0,
        "type": "lesson_complete",
        "lesson_id": 1,
        "status": "synced",
        "server_timestamp": "2024-01-26T10:35:00Z"
      },
      {
        "index": 1,
        "type": "lesson_progress",
        "lesson_id": 2,
        "status": "synced",
        "server_timestamp": "2024-01-26T10:35:01Z"
      },
      {
        "index": 2,
        "type": "review_complete",
        "lesson_id": 1,
        "status": "synced",
        "server_timestamp": "2024-01-26T10:35:02Z"
      }
    ],
    "failed_items": [],
    "conflicts": []
  }
}
```

#### Example

```bash
curl -X POST http://localhost:3003/api/progress/sync \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "sync_items": [
      {
        "type": "lesson_complete",
        "lesson_id": 1,
        "quiz_score": 95,
        "time_spent_seconds": 1800,
        "completed_at": "2024-01-25T10:30:00Z"
      }
    ]
  }'
```

#### Error Responses

**Status**: `207 Multi-Status`

```json
{
  "success": true,
  "data": {
    "synced_count": 2,
    "failed_count": 1,
    "synced_items": [
      {
        "index": 0,
        "type": "lesson_complete",
        "lesson_id": 1,
        "status": "synced"
      },
      {
        "index": 1,
        "type": "lesson_progress",
        "lesson_id": 2,
        "status": "synced"
      }
    ],
    "failed_items": [
      {
        "index": 2,
        "type": "review_complete",
        "lesson_id": 999,
        "status": "failed",
        "error": {
          "code": "LESSON_NOT_FOUND",
          "message": "Lesson 999 not found"
        }
      }
    ]
  }
}
```

---

### Get Review Schedule

Get SRS (Spaced Repetition System) review schedule.

**Endpoint**: `GET /api/progress/review-schedule`

**Authentication**: Required (JWT)

#### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `user_id` | integer | Yes | - | User ID |
| `date` | string | No | today | Date (YYYY-MM-DD) |
| `days` | integer | No | 7 | Number of days to fetch |

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "schedule": [
      {
        "date": "2024-01-26",
        "reviews": [
          {
            "lesson_id": 1,
            "lesson_title_ko": "안녕하세요",
            "lesson_title_zh": "你好",
            "srs_level": 2,
            "last_reviewed": "2024-01-24T10:00:00Z",
            "next_review": "2024-01-26T10:00:00Z",
            "interval_days": 2,
            "ease_factor": 2.5,
            "is_due": true
          },
          {
            "lesson_id": 3,
            "lesson_title_ko": "숫자",
            "lesson_title_zh": "数字",
            "srs_level": 1,
            "last_reviewed": "2024-01-25T14:00:00Z",
            "next_review": "2024-01-26T14:00:00Z",
            "interval_days": 1,
            "ease_factor": 2.5,
            "is_due": true
          }
        ],
        "total_reviews": 2
      },
      {
        "date": "2024-01-27",
        "reviews": [
          {
            "lesson_id": 5,
            "lesson_title_ko": "가족",
            "lesson_title_zh": "家人",
            "srs_level": 3,
            "last_reviewed": "2024-01-23T10:00:00Z",
            "next_review": "2024-01-27T10:00:00Z",
            "interval_days": 4,
            "ease_factor": 2.6,
            "is_due": false
          }
        ],
        "total_reviews": 1
      }
    ],
    "summary": {
      "total_due_today": 2,
      "total_upcoming": 1,
      "total_reviews_7_days": 3,
      "average_reviews_per_day": 0.43
    }
  }
}
```

#### Example

```bash
curl -X GET "http://localhost:3003/api/progress/review-schedule?user_id=1&days=7" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### Submit Review Result

Submit SRS review result.

**Endpoint**: `POST /api/progress/review`

**Authentication**: Required (JWT)

#### Request Body

```json
{
  "user_id": 1,
  "lesson_id": 1,
  "quality": 4,
  "reviewed_at": "2024-01-26T10:30:00Z"
}
```

**Quality Scale**:
- `0`: Complete blackout
- `1`: Incorrect response, but correct answer seemed familiar
- `2`: Incorrect response, but correct answer remembered
- `3`: Correct response, but with difficulty
- `4`: Correct response, with hesitation
- `5`: Perfect response

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "lesson_id": 1,
    "srs_level": 3,
    "interval_days": 4,
    "ease_factor": 2.6,
    "next_review_date": "2024-01-30T10:30:00Z",
    "total_reviews": 3,
    "retention_rate": 0.88
  }
}
```

#### Example

```bash
curl -X POST http://localhost:3003/api/progress/review \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "lesson_id": 1,
    "quality": 4,
    "reviewed_at": "2024-01-26T10:30:00Z"
  }'
```

#### Error Responses

**Status**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_QUALITY",
    "message": "Quality must be between 0 and 5"
  }
}
```

---

### Get Statistics

Get user learning statistics.

**Endpoint**: `GET /api/progress/statistics`

**Authentication**: Required (JWT)

#### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `user_id` | integer | Yes | - | User ID |
| `period` | string | No | all | Period (all, week, month, year) |

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "period": "all",
    "overall": {
      "total_lessons_completed": 45,
      "total_time_spent_hours": 67.5,
      "average_quiz_score": 87.5,
      "completion_rate": 30.0,
      "streak_days": 12,
      "longest_streak_days": 25
    },
    "by_level": {
      "beginner": {
        "completed": 30,
        "total": 50,
        "completion_rate": 60.0,
        "average_score": 89.2
      },
      "intermediate": {
        "completed": 15,
        "total": 60,
        "completion_rate": 25.0,
        "average_score": 85.7
      },
      "advanced": {
        "completed": 0,
        "total": 40,
        "completion_rate": 0.0,
        "average_score": 0.0
      }
    },
    "recent_activity": [
      {
        "date": "2024-01-26",
        "lessons_completed": 2,
        "time_spent_minutes": 60,
        "average_score": 92.5
      },
      {
        "date": "2024-01-25",
        "lessons_completed": 3,
        "time_spent_minutes": 90,
        "average_score": 88.0
      }
    ],
    "achievements": [
      {
        "type": "streak_7_days",
        "title": "7天连续学习",
        "earned_at": "2024-01-22T10:00:00Z"
      },
      {
        "type": "lessons_completed_50",
        "title": "完成50节课",
        "progress": 45,
        "total": 50,
        "percentage": 90.0
      }
    ]
  }
}
```

#### Example

```bash
curl -X GET "http://localhost:3003/api/progress/statistics?user_id=1&period=month" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### Get Streak

Get user's learning streak information.

**Endpoint**: `GET /api/progress/streak`

**Authentication**: Required (JWT)

#### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `user_id` | integer | Yes | - | User ID |

#### Response

**Status**: `200 OK`

```json
{
  "success": true,
  "data": {
    "user_id": 1,
    "current_streak": {
      "days": 12,
      "start_date": "2024-01-15",
      "last_activity_date": "2024-01-26",
      "is_active": true
    },
    "longest_streak": {
      "days": 25,
      "start_date": "2023-12-01",
      "end_date": "2023-12-25"
    },
    "today_completed": true,
    "streak_milestones": [
      {
        "days": 7,
        "achieved": true,
        "achieved_at": "2024-01-22T10:00:00Z"
      },
      {
        "days": 14,
        "achieved": false,
        "progress": 12,
        "percentage": 85.7
      },
      {
        "days": 30,
        "achieved": false,
        "progress": 12,
        "percentage": 40.0
      }
    ]
  }
}
```

#### Example

```bash
curl -X GET "http://localhost:3003/api/progress/streak?user_id=1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### Health Check

Check if Progress Service is healthy.

**Endpoint**: `GET /api/progress/health`

**Authentication**: Not required

#### Response

**Status**: `200 OK`

```json
{
  "status": "healthy",
  "service": "progress-service",
  "timestamp": "2024-01-26T10:30:00Z",
  "uptime": 86400,
  "database": {
    "postgres": {
      "status": "connected",
      "latency_ms": 4
    }
  },
  "cache": {
    "redis": {
      "status": "connected",
      "hit_rate": 0.78
    }
  }
}
```

#### Example

```bash
curl -X GET http://localhost:3003/api/progress/health
```

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `FORBIDDEN` | 403 | User can only access own data |
| `INVALID_QUIZ_SCORE` | 400 | Quiz score out of range |
| `INVALID_QUALITY` | 400 | Review quality out of range |
| `LESSON_NOT_FOUND` | 404 | Lesson not found |
| `PROGRESS_NOT_FOUND` | 404 | Progress record not found |
| `SYNC_CONFLICT` | 409 | Data conflict during sync |
| `UNAUTHORIZED` | 401 | Authentication required |
| `INTERNAL_SERVER_ERROR` | 500 | Server error occurred |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |

---

## Data Models

### Progress

```json
{
  "lesson_id": "integer",
  "lesson_title_ko": "string",
  "lesson_title_zh": "string",
  "lesson_level": "string",
  "status": "string (enum: not_started, in_progress, completed)",
  "current_stage": "integer (1-7)",
  "total_stages": "integer",
  "progress_percentage": "number (0-100)",
  "quiz_score": "integer (0-100, nullable)",
  "quiz_attempts": "integer",
  "time_spent_seconds": "integer",
  "started_at": "string (ISO 8601 datetime)",
  "completed_at": "string (ISO 8601 datetime, nullable)",
  "last_accessed": "string (ISO 8601 datetime)"
}
```

### SRS Review

```json
{
  "lesson_id": "integer",
  "srs_level": "integer",
  "interval_days": "integer",
  "ease_factor": "number",
  "next_review_date": "string (ISO 8601 datetime)",
  "last_reviewed": "string (ISO 8601 datetime)",
  "total_reviews": "integer",
  "retention_rate": "number (0-1)"
}
```

### Sync Item

```json
{
  "type": "string (enum: lesson_complete, lesson_progress, review_complete)",
  "lesson_id": "integer",
  "quiz_score": "integer (optional)",
  "current_stage": "integer (optional)",
  "time_spent_seconds": "integer",
  "quality": "integer (0-5, optional for reviews)",
  "completed_at": "string (ISO 8601 datetime, optional)",
  "reviewed_at": "string (ISO 8601 datetime, optional)",
  "client_timestamp": "string (ISO 8601 datetime)"
}
```

---

## OpenAPI 3.0 Specification

```yaml
openapi: 3.0.3
info:
  title: Lemon Korean - Progress Service API
  description: Learning progress tracking and SRS management API
  version: 1.0.0

servers:
  - url: http://localhost:3003/api/progress
    description: Development server
  - url: https://api.lemonkorean.com/progress
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
    Progress:
      type: object
      properties:
        lesson_id:
          type: integer
        status:
          type: string
          enum: [not_started, in_progress, completed]
        current_stage:
          type: integer
          minimum: 1
          maximum: 7
        quiz_score:
          type: integer
          minimum: 0
          maximum: 100
          nullable: true
        time_spent_seconds:
          type: integer
        started_at:
          type: string
          format: date-time
        completed_at:
          type: string
          format: date-time
          nullable: true

    SRSReview:
      type: object
      properties:
        lesson_id:
          type: integer
        srs_level:
          type: integer
        interval_days:
          type: integer
        ease_factor:
          type: number
        next_review_date:
          type: string
          format: date-time

paths:
  /user/{userId}:
    get:
      summary: Get user progress
      parameters:
        - name: userId
          in: path
          required: true
          schema:
            type: integer
      responses:
        '200':
          description: Progress retrieved successfully
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
                      progress:
                        type: array
                        items:
                          $ref: '#/components/schemas/Progress'

  /complete:
    post:
      summary: Complete lesson
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - user_id
                - lesson_id
                - quiz_score
              properties:
                user_id:
                  type: integer
                lesson_id:
                  type: integer
                quiz_score:
                  type: integer
                  minimum: 0
                  maximum: 100
                time_spent_seconds:
                  type: integer
      responses:
        '200':
          description: Lesson completed successfully

  /sync:
    post:
      summary: Sync offline progress
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - user_id
                - sync_items
              properties:
                user_id:
                  type: integer
                sync_items:
                  type: array
                  items:
                    type: object
      responses:
        '200':
          description: Sync completed successfully
        '207':
          description: Partial sync success

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
