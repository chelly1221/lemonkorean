# Content Service API 문서

**Base URL**: `http://localhost:3002/api/content`

**OpenAPI Version**: 3.0.3

---

## 목차

- [인증](#인증)
- [엔드포인트](#엔드포인트)
  - [레슨 목록 조회](#레슨-목록-조회)
  - [레슨 상세 조회](#레슨-상세-조회)
  - [레슨 패키지 다운로드](#레슨-패키지-다운로드)
  - [업데이트 확인](#업데이트-확인)
  - [단어 조회](#단어-조회)
  - [문법 포인트 조회](#문법-포인트-조회)
  - [콘텐츠 검색](#콘텐츠-검색)
  - [헬스 체크](#헬스-체크)
- [오류 코드](#오류-코드)
- [데이터 모델](#데이터-모델)

---

## 인증

> **참고**: 현재 Content Service의 모든 엔드포인트는 **공개(Public)** 상태입니다.
> JWT 인증은 향후 구현 예정입니다.

```
Authorization: Bearer <jwt_token>  # 향후 구현 예정
```

---

## 엔드포인트

### 레슨 목록 조회

필터링과 함께 페이지네이션된 레슨 목록을 조회합니다.

**엔드포인트**: `GET /api/content/lessons`

**인증**: 공개 (향후 JWT 인증 예정)

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `page` | integer | 아니오 | 1 | 페이지 번호 |
| `limit` | integer | 아니오 | 20 | 페이지당 항목 수 (최대: 100) |
| `level` | string | 아니오 | - | 레벨별 필터 (beginner, intermediate, advanced) |
| `status` | string | 아니오 | published | 상태별 필터 (published, draft) |
| `search` | string | 아니오 | - | 제목 검색 (한국어/중국어) |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "lessons": [
    {
      "id": 1,
      "level": "beginner",
      "title_ko": "안녕하세요",
      "title_zh": "你好",
      "description_zh": "学习韩语的基本问候语",
      "thumbnail": "http://localhost:9000/lemon-korean/lessons/1/thumbnail.jpg",
      "duration_minutes": 30,
      "version": "1.2.0",
      "status": "published",
      "vocabulary_count": 10,
      "grammar_count": 2,
      "is_downloaded": false,
      "created_at": "2024-01-20T10:00:00Z",
      "updated_at": "2024-01-25T15:30:00Z"
    }
  ],
  "total": 150,
  "page": 1,
  "limit": 20,
  "totalPages": 8,
  "hasNextPage": true,
  "hasPreviousPage": false
}
```

#### 예시

```bash
curl -X GET "http://localhost:3002/api/content/lessons?page=1&limit=10&level=beginner" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### 오류 응답

**상태**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_QUERY_PARAMS",
    "message": "Invalid query parameters",
    "details": [
      {
        "field": "level",
        "message": "Must be one of: beginner, intermediate, advanced"
      }
    ]
  }
}
```

---

### 레슨 상세 조회

모든 스테이지를 포함한 상세한 레슨 콘텐츠를 조회합니다.

**엔드포인트**: `GET /api/content/lessons/:id`

**인증**: 공개 (향후 JWT 인증 예정)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `id` | integer | 예 | 레슨 ID |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "lesson": {
    "id": 1,
    "level": "beginner",
    "title_ko": "안녕하세요",
    "title_zh": "你好",
    "description_ko": "기본 인사말 배우기",
    "description_zh": "学习韩语的基本问候语",
    "thumbnail": "http://localhost:9000/lemon-korean/lessons/1/thumbnail.jpg",
    "duration_minutes": 30,
    "version": "1.2.0",
    "status": "published",
    "content": {
      "stage1_intro": {
        "type": "intro",
        "title_ko": "소개",
        "title_zh": "介绍",
        "video_url": "http://localhost:9000/lemon-korean/lessons/1/intro.mp4",
        "transcript_zh": "欢迎来到第一课..."
      },
      "stage2_vocabulary": {
        "type": "vocabulary",
        "words": [
          {
            "id": 1,
            "korean": "안녕하세요",
            "chinese": "你好",
            "pinyin": "nǐ hǎo",
            "romanization": "annyeonghaseyo",
            "hanja": null,
            "similarity_score": 95,
            "image_url": "http://localhost:9000/lemon-korean/vocab/1/image.jpg",
            "audio_url": "http://localhost:9000/lemon-korean/vocab/1/audio.mp3",
            "example_sentence_ko": "안녕하세요, 저는 이민수입니다.",
            "example_sentence_zh": "你好，我是李民秀。"
          }
        ]
      },
      "stage3_grammar": {
        "type": "grammar",
        "points": [
          {
            "id": 1,
            "title_ko": "은/는 (주제 조사)",
            "title_zh": "은/는 (主题助词)",
            "rule_ko": "받침이 있으면 '은', 없으면 '는'을 사용합니다.",
            "rule_zh": "有收音时使用'은'，无收音时使用'는'。",
            "comparison_zh": "类似于中文的'呢'或者用来强调主语。",
            "examples": [
              {
                "korean": "저는 학생입니다.",
                "chinese": "我是学生。",
                "highlight": "는"
              }
            ],
            "exercise": {
              "type": "fill_blank",
              "question_ko": "나___ 한국 사람입니다.",
              "question_zh": "我___韩国人。",
              "options": ["은", "는"],
              "correct_answer": "는"
            }
          }
        ]
      },
      "stage4_practice": {
        "type": "practice",
        "exercises": [
          {
            "type": "matching",
            "instructions_zh": "将韩语单词与中文意思连线",
            "pairs": [
              {
                "korean": "안녕하세요",
                "chinese": "你好"
              }
            ]
          }
        ]
      },
      "stage5_dialogue": {
        "type": "dialogue",
        "conversations": [
          {
            "id": 1,
            "participants": ["민수", "리나"],
            "lines": [
              {
                "speaker": "민수",
                "korean": "안녕하세요!",
                "chinese": "你好！",
                "audio_url": "http://localhost:9000/lemon-korean/lessons/1/dialogue/1.mp3"
              }
            ],
            "audio_full_url": "http://localhost:9000/lemon-korean/lessons/1/dialogue_full.mp3"
          }
        ]
      },
      "stage6_quiz": {
        "type": "quiz",
        "passing_score": 80,
        "questions": [
          {
            "id": 1,
            "type": "listening",
            "question_zh": "听音频，选择正确的韩语表达",
            "audio_url": "http://localhost:9000/lemon-korean/quiz/1/audio.mp3",
            "options": [
              "안녕하세요",
              "감사합니다",
              "죄송합니다",
              "안녕히 가세요"
            ],
            "correct_answer": 0
          }
        ]
      },
      "stage7_summary": {
        "type": "summary",
        "title_zh": "课程总结",
        "key_points_zh": [
          "学会了基本问候语：안녕하세요",
          "了解了主题助词 은/는 的用法"
        ],
        "next_lesson_id": 2
      }
    },
    "media_manifest": [
      {
        "key": "lessons/1/thumbnail.jpg",
        "type": "image",
        "size": 102400,
        "url": "http://localhost:9000/lemon-korean/lessons/1/thumbnail.jpg"
      }
    ],
    "created_at": "2024-01-20T10:00:00Z",
    "updated_at": "2024-01-25T15:30:00Z"
  }
}
```

> **참고**: 실제 응답에는 추가 필드가 포함됩니다: `week`, `order_num`, `estimated_minutes`, `difficulty`, `published_at`, `prerequisites`, `tags`, `view_count`, `completion_count`

#### 예시

```bash
curl -X GET http://localhost:3002/api/content/lessons/1
```

#### 오류 응답

**상태**: `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "LESSON_NOT_FOUND",
    "message": "Lesson with ID 999 not found"
  }
}
```

---

### 레슨 패키지 다운로드

오프라인 사용을 위한 완전한 레슨 패키지를 ZIP 파일로 다운로드합니다.

**엔드포인트**: `GET /api/content/lessons/:id/download`

**인증**: 공개 (향후 JWT 인증 예정)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `id` | integer | 예 | 레슨 ID |

#### 응답

**상태**: `200 OK`

**Content-Type**: `application/zip`

**Content-Disposition**: `attachment; filename="lesson_{id}_v{version}.zip"`

ZIP 파일 구조:
```
lesson_{id}_v{version}.zip
├── lesson.json          # 레슨 메타데이터 및 콘텐츠
├── media/               # 미디어 파일 디렉토리
│   ├── thumbnail.jpg
│   ├── audio/
│   └── images/
└── manifest.json        # 파일 매니페스트
```

#### 예시

```bash
curl -X GET "http://localhost:3002/api/content/lessons/1/download" \
  -o lesson_1.zip
```

> **참고**: 메타데이터만 필요한 경우 `/api/content/lessons/:id/package` 엔드포인트를 사용하세요.

#### 오류 응답

**상태**: `403 Forbidden`

```json
{
  "success": false,
  "error": {
    "code": "SUBSCRIPTION_REQUIRED",
    "message": "This lesson requires a premium subscription",
    "subscription_type_required": "premium"
  }
}
```

---

### 업데이트 확인

레슨 콘텐츠 업데이트를 확인합니다.

**엔드포인트**: `POST /api/content/lessons/check-updates`

**인증**: 공개 (향후 JWT 인증 예정)

> **제한**: 요청당 최대 100개 레슨

#### 요청 본문

```json
{
  "lessons": [
    {
      "id": 1,
      "version": "1.1.0"
    },
    {
      "id": 2,
      "version": "1.0.0"
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
    "updates_available": [
      {
        "lesson_id": 1,
        "current_version": "1.1.0",
        "latest_version": "1.2.0",
        "update_size": 5242880,
        "changelog": [
          "新增3个词汇",
          "修正语法练习错误"
        ],
        "is_major_update": false
      }
    ],
    "up_to_date": [2]
  }
}
```

#### 예시

```bash
curl -X POST http://localhost:3002/api/content/check-updates \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "lessons": [
      {"id": 1, "version": "1.1.0"},
      {"id": 2, "version": "1.0.0"}
    ]
  }'
```

---

### 단어 조회

필터링과 함께 단어 목록을 조회합니다.

**엔드포인트**: `GET /api/content/vocabulary`

**인증**: 공개 (향후 JWT 인증 예정)

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `page` | integer | 아니오 | 1 | 페이지 번호 |
| `limit` | integer | 아니오 | 50 | 페이지당 항목 수 (최대: 200) |
| `lesson_id` | integer | 아니오 | - | 레슨별 필터 |
| `level` | string | 아니오 | - | 레벨별 필터 |
| `search` | string | 아니오 | - | 한국어/중국어 검색 |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "vocabulary": [
    {
      "id": 1,
      "korean": "안녕하세요",
      "chinese": "你好",
      "pinyin": "nǐ hǎo",
      "romanization": "annyeonghaseyo",
      "hanja": null,
      "similarity_score": 95,
      "part_of_speech": "phrase",
      "image_url": "http://localhost:9000/lemon-korean/vocab/1/image.jpg",
      "audio_url_male": "http://localhost:9000/lemon-korean/vocab/1/audio_m.mp3",
      "audio_url_female": "http://localhost:9000/lemon-korean/vocab/1/audio_f.mp3",
      "is_primary": true
    }
  ],
  "total": 500,
  "page": 1,
  "limit": 50,
  "total_pages": 10,
  "has_next": true,
  "has_prev": false
}
```

#### 예시

```bash
curl -X GET "http://localhost:3002/api/content/vocabulary?lesson_id=1&limit=10" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### 문법 포인트 조회

필터링과 함께 문법 포인트 목록을 조회합니다.

**엔드포인트**: `GET /api/content/grammar`

**인증**: 공개 (향후 JWT 인증 예정)

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `page` | integer | 아니오 | 1 | 페이지 번호 |
| `limit` | integer | 아니오 | 20 | 페이지당 항목 수 |
| `lesson_id` | integer | 아니오 | - | 레슨별 필터 |
| `level` | string | 아니오 | - | 레벨별 필터 |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "grammar": [
    {
      "id": 1,
      "name_ko": "은/는 (주제 조사)",
      "name_zh": "은/는 (主题助词)",
      "category": "particle",
      "level": "beginner",
      "difficulty": 1,
      "description": "받침이 있으면 '은', 없으면 '는'을 사용합니다.",
      "chinese_comparison": "类似于中文的'呢'或者用来强调主语。",
      "examples": [
        {
          "korean": "저는 학생입니다.",
          "chinese": "我是学生。"
        }
      ],
      "usage_notes": "주어나 주제를 강조할 때 사용",
      "common_mistakes": "받침 유무에 따른 선택 오류",
      "related_grammar": [1, 2]
    }
  ],
  "total": 80,
  "page": 1,
  "limit": 20,
  "total_pages": 4,
  "has_next": true,
  "has_prev": false
}
```

#### 예시

```bash
curl -X GET "http://localhost:3002/api/content/grammar?level=beginner" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

### 단어 검색

단어를 검색합니다.

**엔드포인트**: `GET /api/content/vocabulary/search`

**인증**: 공개 (향후 JWT 인증 예정)

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `q` | string | 예 | - | 검색 쿼리 |
| `limit` | integer | 아니오 | 20 | 결과 수 제한 |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "vocabulary": [
    {
      "id": 1,
      "korean": "안녕하세요",
      "chinese": "你好",
      "pinyin": "nǐ hǎo",
      "romanization": "annyeonghaseyo",
      "similarity_score": 95
    }
  ],
  "total": 5
}
```

#### 예시

```bash
curl -X GET "http://localhost:3002/api/content/vocabulary/search?q=안녕&limit=10"
```

> **참고**: 통합 검색 (`/api/content/search`)은 향후 구현 예정입니다.

---

### 레슨 버전 확인

특정 레슨의 현재 버전을 확인합니다.

**엔드포인트**: `GET /api/content/lessons/:id/version`

**인증**: 공개

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `id` | integer | 예 | 레슨 ID |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "lesson_id": 1,
  "version": "1.2.0",
  "updated_at": "2024-01-25T15:30:00Z"
}
```

---

### 레슨 패키지 메타데이터

다운로드 전 레슨 패키지 정보를 조회합니다 (실제 다운로드 없이).

**엔드포인트**: `GET /api/content/lessons/:id/package`

**인증**: 공개 (향후 JWT 인증 예정)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `id` | integer | 예 | 레슨 ID |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "lesson_id": 1,
  "version": "1.2.0",
  "package_size": 52428800,
  "media_files": [
    {
      "key": "lessons/1/thumbnail.jpg",
      "type": "image",
      "size": 102400
    }
  ],
  "total_files": 25
}
```

---

### 레벨별 단어 조회

특정 레벨의 단어 목록을 조회합니다.

**엔드포인트**: `GET /api/content/vocabulary/level/:level`

**인증**: 공개 (향후 JWT 인증 예정)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `level` | string | 예 | 레벨 (beginner, intermediate, advanced) |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "vocabulary": [ /* 단어 목록 */ ],
  "total": 150,
  "level": "beginner"
}
```

---

### 고유사도 단어 조회

중국어와 유사도가 높은 한국어 단어 목록을 조회합니다.

**엔드포인트**: `GET /api/content/vocabulary/high-similarity`

**인증**: 공개 (향후 JWT 인증 예정)

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `min_similarity` | number | 아니오 | 0.8 | 최소 유사도 (0-1) |
| `limit` | integer | 아니오 | 100 | 결과 수 (최대: 500) |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "vocabulary": [
    {
      "id": 1,
      "korean": "도서관",
      "chinese": "图书馆",
      "similarity_score": 98
    }
  ],
  "total": 45
}
```

---

### 문법 카테고리 조회

문법 카테고리 목록을 조회합니다.

**엔드포인트**: `GET /api/content/grammar/categories`

**인증**: 공개 (향후 JWT 인증 예정)

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "categories": [
    {
      "id": "particle",
      "name_ko": "조사",
      "name_zh": "助词",
      "count": 25
    },
    {
      "id": "ending",
      "name_ko": "어미",
      "name_zh": "词尾",
      "count": 40
    }
  ]
}
```

---

### 레벨별 문법 조회

특정 레벨의 문법 목록을 조회합니다.

**엔드포인트**: `GET /api/content/grammar/level/:level`

**인증**: 공개 (향후 JWT 인증 예정)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `level` | string | 예 | 레벨 (beginner, intermediate, advanced) |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "grammar": [ /* 문법 목록 */ ],
  "total": 30,
  "level": "beginner"
}
```

---

### 헬스 체크

Content Service가 정상인지 확인합니다.

**엔드포인트**: `GET /health`

> **참고**: 헬스 체크 엔드포인트는 `/api/content/` 프리픽스를 사용하지 않습니다.

**인증**: 불필요

#### 응답

**상태**: `200 OK`

```json
{
  "status": "healthy",
  "service": "content-service",
  "timestamp": "2024-01-26T10:30:00Z",
  "database": {
    "postgres": {
      "status": "connected",
      "latency_ms": 3
    },
    "mongodb": {
      "status": "connected",
      "latency_ms": 5
    }
  },
  "cache": {
    "redis": {
      "status": "connected",
      "hit_rate": 0.85
    }
  }
}
```

#### 예시

```bash
curl -X GET http://localhost:3002/health
```

---

## 오류 코드

| 코드 | HTTP 상태 | 설명 |
|------|-------------|-------------|
| `INVALID_QUERY_PARAMS` | 400 | 잘못된 쿼리 파라미터 |
| `LESSON_NOT_FOUND` | 404 | 레슨을 찾을 수 없음 |
| `VOCABULARY_NOT_FOUND` | 404 | 단어를 찾을 수 없음 |
| `GRAMMAR_NOT_FOUND` | 404 | 문법 포인트를 찾을 수 없음 |
| `SUBSCRIPTION_REQUIRED` | 403 | 프리미엄 구독 필요 |
| `INVALID_VERSION` | 400 | 잘못된 버전 형식 |
| `UNAUTHORIZED` | 401 | 인증 필요 |
| `INTERNAL_SERVER_ERROR` | 500 | 서버 오류 발생 |
| `SERVICE_UNAVAILABLE` | 503 | 서비스가 일시적으로 사용 불가 |

---

## 데이터 모델

### Lesson (Summary)

```json
{
  "id": "integer",
  "level": "string (enum: beginner, intermediate, advanced)",
  "title_ko": "string",
  "title_zh": "string",
  "description_zh": "string",
  "thumbnail": "string (URL)",
  "duration_minutes": "integer",
  "version": "string (semver)",
  "status": "string (enum: published, draft)",
  "vocabulary_count": "integer",
  "grammar_count": "integer",
  "is_downloaded": "boolean",
  "created_at": "string (ISO 8601 datetime)",
  "updated_at": "string (ISO 8601 datetime)"
}
```

### Vocabulary

```json
{
  "id": "integer",
  "korean": "string",
  "chinese": "string",
  "pinyin": "string",
  "romanization": "string",
  "hanja": "string (nullable)",
  "similarity_score": "integer (0-100)",
  "part_of_speech": "string",
  "image_url": "string (URL)",
  "audio_url_male": "string (URL)",
  "audio_url_female": "string (URL)",
  "is_primary": "boolean",
  "example_sentence_ko": "string",
  "example_sentence_zh": "string"
}
```

### Grammar Point

```json
{
  "id": "integer",
  "name_ko": "string",
  "name_zh": "string",
  "category": "string",
  "level": "string (enum: beginner, intermediate, advanced)",
  "difficulty": "integer (1-5)",
  "description": "string",
  "chinese_comparison": "string",
  "examples": [
    {
      "korean": "string",
      "chinese": "string",
      "highlight": "string (optional)"
    }
  ],
  "usage_notes": "string",
  "common_mistakes": "string",
  "related_grammar": "array of integers",
  "version": "string"
}
```

### Pagination

```json
{
  "page": "integer",
  "limit": "integer",
  "total": "integer",
  "total_pages": "integer"
}
```

---

## OpenAPI 3.0 스펙

```yaml
openapi: 3.0.3
info:
  title: Lemon Korean - Content Service API
  description: Lesson content, vocabulary, and grammar management API
  version: 1.0.0

servers:
  - url: http://localhost:3002/api/content
    description: Development server
  - url: https://api.lemonkorean.com/content
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
    LessonSummary:
      type: object
      properties:
        id:
          type: integer
        level:
          type: string
          enum: [beginner, intermediate, advanced]
        title_ko:
          type: string
        title_zh:
          type: string
        description_zh:
          type: string
        thumbnail:
          type: string
          format: uri
        duration_minutes:
          type: integer
        version:
          type: string
          pattern: '^\d+\.\d+\.\d+$'
        status:
          type: string
          enum: [published, draft]
        vocabulary_count:
          type: integer
        grammar_count:
          type: integer
        is_downloaded:
          type: boolean
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time

    Vocabulary:
      type: object
      properties:
        id:
          type: integer
        korean:
          type: string
        chinese:
          type: string
        pinyin:
          type: string
        romanization:
          type: string
        hanja:
          type: string
          nullable: true
        similarity_score:
          type: integer
          minimum: 0
          maximum: 100
        image_url:
          type: string
          format: uri
        audio_url:
          type: string
          format: uri

    Pagination:
      type: object
      properties:
        page:
          type: integer
        limit:
          type: integer
        total:
          type: integer
        total_pages:
          type: integer

paths:
  /lessons:
    get:
      summary: Get lessons list
      parameters:
        - name: page
          in: query
          schema:
            type: integer
            default: 1
        - name: limit
          in: query
          schema:
            type: integer
            default: 20
            maximum: 100
        - name: level
          in: query
          schema:
            type: string
            enum: [beginner, intermediate, advanced]
      responses:
        '200':
          description: Lessons retrieved successfully
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
                      lessons:
                        type: array
                        items:
                          $ref: '#/components/schemas/LessonSummary'
                      pagination:
                        $ref: '#/components/schemas/Pagination'

  /lessons/{id}:
    get:
      summary: Get lesson detail
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: integer
      responses:
        '200':
          description: Lesson detail retrieved successfully
        '404':
          description: Lesson not found

  /health:
    get:
      summary: Health check
      security: []
      responses:
        '200':
          description: Service is healthy
```

---

**Last Updated**: 2026-01-30
**Version**: 1.1.0
