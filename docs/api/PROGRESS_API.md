# Progress Service API 문서

**Base URL**: `http://localhost:3003/api/progress`

**OpenAPI Version**: 3.0.3

---

## 목차

- [인증](#인증)
- [엔드포인트](#엔드포인트)
  - [사용자 진도 조회](#사용자-진도-조회)
  - [레슨 완료](#레슨-완료)
  - [레슨 진도 업데이트](#레슨-진도-업데이트)
  - [오프라인 진도 동기화](#오프라인-진도-동기화)
  - [복습 일정 조회](#복습-일정-조회)
  - [복습 결과 제출](#복습-결과-제출)
  - [통계 조회](#통계-조회)
  - [연속 기록 조회](#연속-기록-조회)
  - [헬스 체크](#헬스-체크)
- [오류 코드](#오류-코드)
- [데이터 모델](#데이터-모델)

---

## 인증

`/health`를 제외한 모든 엔드포인트는 JWT 인증이 필요합니다:

```
Authorization: Bearer <jwt_token>
```

---

## 엔드포인트

### 사용자 진도 조회

모든 레슨에 대한 사용자의 학습 진도를 조회합니다.

**엔드포인트**: `GET /api/progress/user/:userId`

**인증**: 필요 (JWT)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `userId` | integer | 예 | 사용자 ID (인증된 사용자와 일치해야 함) |

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `status` | string | 아니오 | - | 상태별 필터 (not_started, in_progress, completed) |
| `level` | string | 아니오 | - | 레슨 레벨별 필터 |

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X GET http://localhost:3003/api/progress/user/1 \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### 오류 응답

**상태**: `403 Forbidden`

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

### 레슨 완료

레슨을 완료로 표시합니다.

**엔드포인트**: `POST /api/progress/complete`

**인증**: 필요 (JWT)

#### 요청 본문

```json
{
  "user_id": 1,
  "lesson_id": 1,
  "quiz_score": 95,
  "time_spent_seconds": 1800,
  "completed_at": "2024-01-26T10:30:00Z"
}
```

#### 응답

**상태**: `200 OK`

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

#### 예시

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

#### 오류 응답

**상태**: `400 Bad Request`

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

### 레슨 진도 업데이트

레슨의 특정 스테이지에 대한 진도를 업데이트합니다.

**엔드포인트**: `POST /api/progress/update`

**인증**: 필요 (JWT)

#### 요청 본문

```json
{
  "user_id": 1,
  "lesson_id": 2,
  "current_stage": 3,
  "stage_data": {
    "vocabulary_learned": 8,
    "grammar_practiced": 2,
    "exercises_completed": 5
  },
  "time_spent_seconds": 600
}
```

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X POST http://localhost:3003/api/progress/update \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "lesson_id": 2,
    "current_stage": 3,
    "time_spent_seconds": 600
  }'
```

---

### 오프라인 진도 동기화

오프라인 상태에서 수집된 진도 데이터를 동기화합니다.

**엔드포인트**: `POST /api/progress/sync`

**인증**: 필요 (JWT)

#### 요청 본문

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

#### 응답

**상태**: `200 OK`

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

#### 예시

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

#### 오류 응답

**상태**: `207 Multi-Status`

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

### 복습 일정 조회

SRS (간격 반복 시스템) 복습 일정을 조회합니다.

**엔드포인트**: `GET /api/progress/review-schedule`

**인증**: 필요 (JWT)

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `user_id` | integer | 예 | - | 사용자 ID |
| `date` | string | 아니오 | today | 날짜 (YYYY-MM-DD) |
| `days` | integer | 아니오 | 7 | 조회할 일수 |

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X GET "http://localhost:3003/api/progress/review-schedule?user_id=1&days=7" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### 복습 결과 제출

SRS 복습 결과를 제출합니다.

**엔드포인트**: `POST /api/progress/review/complete`

**인증**: 필요 (JWT)

#### 요청 본문

```json
{
  "user_id": 1,
  "lesson_id": 1,
  "quality": 4,
  "reviewed_at": "2024-01-26T10:30:00Z"
}
```

**품질 척도**:
- `0`: 완전히 기억나지 않음
- `1`: 틀린 응답이지만 정답이 익숙함
- `2`: 틀린 응답이지만 정답을 기억함
- `3`: 맞는 응답이지만 어려움
- `4`: 맞는 응답이지만 망설임
- `5`: 완벽한 응답

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X POST http://localhost:3003/api/progress/review/complete \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "lesson_id": 1,
    "quality": 4,
    "reviewed_at": "2024-01-26T10:30:00Z"
  }'
```

#### 오류 응답

**상태**: `400 Bad Request`

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

### 통계 조회

사용자 학습 통계를 조회합니다.

**엔드포인트**: `GET /api/progress/stats/:userId`

**인증**: 필요 (JWT)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `userId` | integer | 예 | 사용자 ID |

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `period` | string | 아니오 | all | 기간 (all, week, month, year) |

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X GET "http://localhost:3003/api/progress/statistics?user_id=1&period=month" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### 연속 기록 조회

> **참고**: 이 엔드포인트는 현재 구현 예정입니다. 연속 기록 데이터는 `/api/progress/stats/:userId` 응답에 포함되어 있습니다.

사용자의 학습 연속 기록 정보를 조회합니다.

**엔드포인트**: `GET /api/progress/streak` *(계획됨)*

**인증**: 필요 (JWT)

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `user_id` | integer | 예 | - | 사용자 ID |

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X GET "http://localhost:3003/api/progress/streak?user_id=1" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### 헬스 체크

Progress Service가 정상인지 확인합니다.

**엔드포인트**: `GET /health`

> **참고**: 헬스 체크 엔드포인트는 `/api/progress/` 프리픽스를 사용하지 않습니다.

**인증**: 불필요

#### 응답

**상태**: `200 OK`

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

#### 예시

```bash
curl -X GET http://localhost:3003/health
```

---

## 오류 코드

| 코드 | HTTP 상태 | 설명 |
|------|-------------|-------------|
| `FORBIDDEN` | 403 | 사용자는 본인 데이터만 접근 가능 |
| `INVALID_QUIZ_SCORE` | 400 | 퀴즈 점수 범위 초과 |
| `INVALID_QUALITY` | 400 | 복습 품질 범위 초과 |
| `LESSON_NOT_FOUND` | 404 | 레슨을 찾을 수 없음 |
| `PROGRESS_NOT_FOUND` | 404 | 진도 레코드를 찾을 수 없음 |
| `SYNC_CONFLICT` | 409 | 동기화 중 데이터 충돌 |
| `UNAUTHORIZED` | 401 | 인증 필요 |
| `INTERNAL_SERVER_ERROR` | 500 | 서버 오류 발생 |
| `SERVICE_UNAVAILABLE` | 503 | 서비스가 일시적으로 사용 불가 |

---

## 데이터 모델

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

## OpenAPI 3.0 스펙

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
