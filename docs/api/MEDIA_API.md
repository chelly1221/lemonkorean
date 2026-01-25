# Media Service API 문서

**Base URL**: `http://localhost:3004`

**OpenAPI Version**: 3.0.3

---

## 목차

- [인증](#인증)
- [엔드포인트](#엔드포인트)
  - [이미지 조회](#이미지-조회)
  - [오디오 조회](#오디오-조회)
  - [미디어 업로드](#미디어-업로드)
  - [미디어 삭제](#미디어-삭제)
  - [미디어 정보 조회](#미디어-정보-조회)
  - [배치 다운로드](#배치-다운로드)
  - [헬스 체크](#헬스-체크)
- [오류 코드](#오류-코드)
- [데이터 모델](#데이터-모델)

---

## 인증

미디어 조회 엔드포인트 (`GET /media/images/:key`, `GET /media/audio/:key`)는 공개 콘텐츠에 대해 인증이 필요하지 않습니다.

업로드 및 삭제 작업은 JWT 인증이 필요합니다:

```
Authorization: Bearer <jwt_token>
```

---

## 엔드포인트

### 이미지 조회

이미지 파일을 조회합니다.

**엔드포인트**: `GET /media/images/:key`

**인증**: 공개 콘텐츠의 경우 불필요

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `key` | string | 예 | 이미지 키 (URL 인코딩된 경로) |

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `w` | integer | 아니오 | - | 리사이즈 너비 (px) |
| `h` | integer | 아니오 | - | 리사이즈 높이 (px) |
| `q` | integer | 아니오 | 85 | 품질 (1-100) |
| `format` | string | 아니오 | original | 출력 형식 (webp, jpg, png) |

#### 응답

**상태**: `200 OK`

**Content-Type**: `image/jpeg`, `image/png`, `image/webp`, etc.

Binary image data

#### 헤더

```
Cache-Control: public, max-age=604800
ETag: "a1b2c3d4e5f6"
Content-Length: 102400
Last-Modified: Wed, 25 Jan 2024 10:30:00 GMT
```

#### 예시

```bash
# Get original image
curl -X GET http://localhost:3004/media/images/lessons/1/thumbnail.jpg

# Get resized image (300x200, WebP format, 90% quality)
curl -X GET "http://localhost:3004/media/images/lessons/1/thumbnail.jpg?w=300&h=200&format=webp&q=90"

# Get thumbnail (100x100)
curl -X GET "http://localhost:3004/media/images/vocab/1/image.jpg?w=100&h=100"
```

#### 오류 응답

**상태**: `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "IMAGE_NOT_FOUND",
    "message": "Image not found: lessons/1/thumbnail.jpg"
  }
}
```

**상태**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_DIMENSIONS",
    "message": "Width and height must be positive integers"
  }
}
```

---

### 오디오 조회

오디오 파일을 조회합니다.

**엔드포인트**: `GET /media/audio/:key`

**인증**: 공개 콘텐츠의 경우 불필요

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `key` | string | 예 | 오디오 키 (URL 인코딩된 경로) |

#### 쿼리 파라미터

| 파라미터 | 타입 | 필수 | 기본값 | 설명 |
|-----------|------|----------|---------|-------------|
| `format` | string | 아니오 | original | 출력 형식 (mp3, ogg, wav) |
| `bitrate` | integer | 아니오 | 128 | 트랜스코딩 비트레이트 (kbps) |

#### 응답

**상태**: `200 OK`

**Content-Type**: `audio/mpeg`, `audio/ogg`, `audio/wav`, etc.

Binary audio data

#### Headers

```
Cache-Control: public, max-age=604800
Accept-Ranges: bytes
Content-Length: 524288
Content-Range: bytes 0-524287/524288
ETag: "x1y2z3w4v5u6"
Last-Modified: Wed, 25 Jan 2024 10:30:00 GMT
```

#### 예시

```bash
# Get original audio
curl -X GET http://localhost:3004/media/audio/vocab/1/pronunciation.mp3

# Get audio with specific format and bitrate
curl -X GET "http://localhost:3004/media/audio/vocab/1/pronunciation.mp3?format=ogg&bitrate=64"

# Range request (for streaming)
curl -X GET http://localhost:3004/media/audio/lessons/1/dialogue.mp3 \
  -H "Range: bytes=0-1048575"
```

#### 오류 응답

**상태**: `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "AUDIO_NOT_FOUND",
    "message": "Audio file not found: vocab/1/pronunciation.mp3"
  }
}
```

**상태**: `416 Range Not Satisfiable`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_RANGE",
    "message": "Requested range not satisfiable"
  }
}
```

---

### 미디어 업로드

미디어 파일을 업로드합니다 (관리자 전용).

**엔드포인트**: `POST /media/upload`

**인증**: 필요 (관리자 역할의 JWT)

#### 요청

**Content-Type**: `multipart/form-data`

| 필드 | 타입 | 필수 | 설명 |
|-------|------|----------|-------------|
| `file` | file | 예 | 미디어 파일 |
| `type` | string | 예 | 미디어 타입 (image, audio) |
| `category` | string | 예 | 카테고리 (lessons, vocab, grammar 등) |
| `lesson_id` | integer | 아니오 | 연결된 레슨 ID |
| `metadata` | string | 아니오 | JSON 메타데이터 |

#### 응답

**상태**: `201 Created`

```json
{
  "success": true,
  "data": {
    "key": "lessons/1/thumbnail.jpg",
    "url": "http://localhost:3004/media/images/lessons/1/thumbnail.jpg",
    "type": "image",
    "size": 102400,
    "mime_type": "image/jpeg",
    "dimensions": {
      "width": 1920,
      "height": 1080
    },
    "checksum": "a1b2c3d4e5f6",
    "uploaded_at": "2024-01-26T10:30:00Z"
  }
}
```

#### 예시

```bash
curl -X POST http://localhost:3004/media/upload \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -F "file=@/path/to/image.jpg" \
  -F "type=image" \
  -F "category=lessons" \
  -F "lesson_id=1" \
  -F 'metadata={"alt_text":"Lesson 1 thumbnail"}'
```

#### 오류 응답

**상태**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_FILE_TYPE",
    "message": "File type not allowed. Allowed types: jpg, png, webp, mp3, ogg, wav"
  }
}
```

**상태**: `413 Payload Too Large`

```json
{
  "success": false,
  "error": {
    "code": "FILE_TOO_LARGE",
    "message": "File size exceeds maximum allowed size of 50MB"
  }
}
```

**상태**: `403 Forbidden`

```json
{
  "success": false,
  "error": {
    "code": "ADMIN_ONLY",
    "message": "This operation requires admin privileges"
  }
}
```

---

### 미디어 삭제

미디어 파일을 삭제합니다 (관리자 전용).

**엔드포인트**: `DELETE /media/:type/:key`

**인증**: 필요 (관리자 역할의 JWT)

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `type` | string | 예 | 미디어 타입 (images, audio) |
| `key` | string | 예 | 미디어 키 (URL 인코딩된 경로) |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "message": "Media file deleted successfully",
  "data": {
    "key": "lessons/1/thumbnail.jpg",
    "deleted_at": "2024-01-26T10:35:00Z"
  }
}
```

#### 예시

```bash
curl -X DELETE http://localhost:3004/media/images/lessons/1/old-thumbnail.jpg \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### 오류 응답

**상태**: `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "MEDIA_NOT_FOUND",
    "message": "Media file not found"
  }
}
```

**상태**: `409 Conflict`

```json
{
  "success": false,
  "error": {
    "code": "MEDIA_IN_USE",
    "message": "Cannot delete media file: still referenced by 3 lessons"
  }
}
```

---

### 미디어 정보 조회

미디어 파일에 대한 메타데이터를 조회합니다.

**엔드포인트**: `GET /media/info/:type/:key`

**인증**: 불필요

#### 경로 파라미터

| 파라미터 | 타입 | 필수 | 설명 |
|-----------|------|----------|-------------|
| `type` | string | 예 | 미디어 타입 (images, audio) |
| `key` | string | 예 | 미디어 키 (URL 인코딩된 경로) |

#### 응답

**상태**: `200 OK`

```json
{
  "success": true,
  "data": {
    "key": "lessons/1/thumbnail.jpg",
    "type": "image",
    "mime_type": "image/jpeg",
    "size": 102400,
    "url": "http://localhost:3004/media/images/lessons/1/thumbnail.jpg",
    "dimensions": {
      "width": 1920,
      "height": 1080
    },
    "checksum": "a1b2c3d4e5f6",
    "created_at": "2024-01-20T10:00:00Z",
    "last_modified": "2024-01-25T15:30:00Z",
    "metadata": {
      "alt_text": "Lesson 1 thumbnail",
      "lesson_id": 1
    },
    "variants": [
      {
        "size": "thumbnail",
        "dimensions": "300x200",
        "url": "http://localhost:3004/media/images/lessons/1/thumbnail.jpg?w=300&h=200"
      },
      {
        "size": "medium",
        "dimensions": "800x600",
        "url": "http://localhost:3004/media/images/lessons/1/thumbnail.jpg?w=800&h=600"
      }
    ]
  }
}
```

#### 예시

```bash
curl -X GET http://localhost:3004/media/info/images/lessons/1/thumbnail.jpg
```

---

### 배치 다운로드

여러 미디어 파일에 대한 다운로드 URL을 조회합니다.

**엔드포인트**: `POST /media/batch-download`

**인증**: 필요 (JWT)

#### 요청 본문

```json
{
  "files": [
    {
      "type": "image",
      "key": "lessons/1/thumbnail.jpg"
    },
    {
      "type": "audio",
      "key": "vocab/1/pronunciation.mp3"
    },
    {
      "type": "audio",
      "key": "lessons/1/dialogue.mp3"
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
    "files": [
      {
        "type": "image",
        "key": "lessons/1/thumbnail.jpg",
        "url": "http://localhost:3004/media/images/lessons/1/thumbnail.jpg",
        "size": 102400,
        "checksum": "a1b2c3d4e5f6",
        "available": true
      },
      {
        "type": "audio",
        "key": "vocab/1/pronunciation.mp3",
        "url": "http://localhost:3004/media/audio/vocab/1/pronunciation.mp3",
        "size": 524288,
        "checksum": "x1y2z3w4v5u6",
        "available": true
      },
      {
        "type": "audio",
        "key": "lessons/1/dialogue.mp3",
        "url": null,
        "available": false,
        "error": "File not found"
      }
    ],
    "total_files": 3,
    "available_files": 2,
    "total_size": 626688
  }
}
```

#### 예시

```bash
curl -X POST http://localhost:3004/media/batch-download \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "files": [
      {"type": "image", "key": "lessons/1/thumbnail.jpg"},
      {"type": "audio", "key": "vocab/1/pronunciation.mp3"}
    ]
  }'
```

---

### 헬스 체크

Media Service가 정상인지 확인합니다.

**엔드포인트**: `GET /health`

**인증**: 불필요

#### 응답

**상태**: `200 OK`

```json
{
  "status": "healthy",
  "service": "media-service",
  "timestamp": "2024-01-26T10:30:00Z",
  "uptime": 86400,
  "storage": {
    "minio": {
      "status": "connected",
      "bucket": "lemon-korean",
      "total_objects": 1250,
      "total_size_mb": 2450.5
    }
  },
  "cache": {
    "enabled": true,
    "hit_rate": 0.82,
    "cached_items": 450
  }
}
```

#### 예시

```bash
curl -X GET http://localhost:3004/health
```

---

## 오류 코드

| 코드 | HTTP 상태 | 설명 |
|------|-------------|-------------|
| `IMAGE_NOT_FOUND` | 404 | 이미지 파일을 찾을 수 없음 |
| `AUDIO_NOT_FOUND` | 404 | 오디오 파일을 찾을 수 없음 |
| `MEDIA_NOT_FOUND` | 404 | 미디어 파일을 찾을 수 없음 |
| `INVALID_DIMENSIONS` | 400 | 잘못된 너비 또는 높이 |
| `INVALID_RANGE` | 416 | 잘못된 바이트 범위 |
| `INVALID_FILE_TYPE` | 400 | 허용되지 않는 파일 타입 |
| `FILE_TOO_LARGE` | 413 | 파일이 크기 제한 초과 |
| `ADMIN_ONLY` | 403 | 관리자 권한 필요 |
| `MEDIA_IN_USE` | 409 | 미디어 파일이 여전히 참조됨 |
| `UPLOAD_FAILED` | 500 | 파일 업로드 실패 |
| `UNAUTHORIZED` | 401 | 인증 필요 |
| `INTERNAL_SERVER_ERROR` | 500 | 서버 오류 발생 |
| `SERVICE_UNAVAILABLE` | 503 | 서비스가 일시적으로 사용 불가 |

---

## 데이터 모델

### Media File Info

```json
{
  "key": "string",
  "type": "string (enum: image, audio)",
  "mime_type": "string",
  "size": "integer (bytes)",
  "url": "string (URL)",
  "dimensions": {
    "width": "integer (images only)",
    "height": "integer (images only)"
  },
  "duration": "number (seconds, audio only)",
  "checksum": "string (MD5 hash)",
  "created_at": "string (ISO 8601 datetime)",
  "last_modified": "string (ISO 8601 datetime)",
  "metadata": "object (optional)"
}
```

### Upload Response

```json
{
  "key": "string",
  "url": "string (URL)",
  "type": "string (enum: image, audio)",
  "size": "integer (bytes)",
  "mime_type": "string",
  "dimensions": {
    "width": "integer (optional)",
    "height": "integer (optional)"
  },
  "checksum": "string (MD5 hash)",
  "uploaded_at": "string (ISO 8601 datetime)"
}
```

### Batch Download Item

```json
{
  "type": "string (enum: image, audio)",
  "key": "string",
  "url": "string (URL, nullable)",
  "size": "integer (bytes, optional)",
  "checksum": "string (optional)",
  "available": "boolean",
  "error": "string (optional)"
}
```

---

## 속도 제한

미디어 엔드포인트에는 속도 제한이 있습니다:

| 엔드포인트 | 제한 | 기간 |
|----------|-------|--------|
| `GET /media/images/:key` | 1000 요청 | 1분 |
| `GET /media/audio/:key` | 500 요청 | 1분 |
| `POST /media/upload` | 100 요청 | 1시간 |
| `DELETE /media/:type/:key` | 50 요청 | 1시간 |

속도 제한을 초과하면:

**상태**: `429 Too Many Requests`

```json
{
  "success": false,
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please try again later.",
    "retry_after": 60
  }
}
```

헤더:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1706268000
Retry-After: 60
```

---

## 캐싱

### 클라이언트 측 캐싱

모든 미디어 파일에는 캐시 헤더가 포함됩니다:

```
Cache-Control: public, max-age=604800
ETag: "a1b2c3d4e5f6"
Last-Modified: Wed, 25 Jan 2024 10:30:00 GMT
```

대역폭을 절약하기 위해 조건부 요청을 사용하세요:

```bash
# First request
curl -X GET http://localhost:3004/media/images/lessons/1/thumbnail.jpg \
  -v

# Subsequent request with ETag
curl -X GET http://localhost:3004/media/images/lessons/1/thumbnail.jpg \
  -H "If-None-Match: \"a1b2c3d4e5f6\""

# Response: 304 Not Modified (if unchanged)
```

### 서버 측 캐싱

미디어 서비스는 다음을 구현합니다:
- **메모리 캐시** (자주 접근하는 파일)
- **CDN 통합** (프로덕션)
- **이미지 처리 캐시** (리사이즈/트랜스코드된 변형)

---

## 이미지 처리

### 지원되는 형식

**입력**: JPEG, PNG, WebP, GIF
**출력**: JPEG, PNG, WebP

### 리사이즈 모드

**쿼리 파라미터**: `mode`

- `fit` (기본값): 크기 내에 맞추고 종횡비 유지
- `fill`: 크기 채우기, 필요시 자르기
- `stretch`: 정확한 크기로 늘리기

예시:
```bash
# Fit mode (default)
curl "http://localhost:3004/media/images/lessons/1/banner.jpg?w=800&h=400&mode=fit"

# Fill mode (cropped)
curl "http://localhost:3004/media/images/lessons/1/banner.jpg?w=800&h=400&mode=fill"
```

### 품질

**쿼리 파라미터**: `q` (1-100, 기본값: 85)

```bash
# High quality (larger file)
curl "http://localhost:3004/media/images/lessons/1/photo.jpg?q=95"

# Low quality (smaller file)
curl "http://localhost:3004/media/images/lessons/1/photo.jpg?q=60"
```

---

## 오디오 스트리밍

### 범위 요청

오디오 파일은 스트리밍을 위한 HTTP 범위 요청을 지원합니다:

```bash
# Request first 1MB
curl -X GET http://localhost:3004/media/audio/lessons/1/dialogue.mp3 \
  -H "Range: bytes=0-1048575" \
  -v

# Response headers:
# HTTP/1.1 206 Partial Content
# Content-Range: bytes 0-1048575/5242880
# Content-Length: 1048576
# Accept-Ranges: bytes
```

### 트랜스코딩

**쿼리 파라미터**: `format` (mp3, ogg, wav)
**쿼리 파라미터**: `bitrate` (kbps)

```bash
# Convert to OGG, 64kbps
curl "http://localhost:3004/media/audio/vocab/1/audio.mp3?format=ogg&bitrate=64"
```

---

## OpenAPI 3.0 스펙

```yaml
openapi: 3.0.3
info:
  title: Lemon Korean - Media Service API
  description: Media file serving and management API
  version: 1.0.0

servers:
  - url: http://localhost:3004
    description: Development server
  - url: https://media.lemonkorean.com
    description: Production server (CDN)

components:
  securitySchemes:
    BearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT

  schemas:
    MediaFileInfo:
      type: object
      properties:
        key:
          type: string
          example: lessons/1/thumbnail.jpg
        type:
          type: string
          enum: [image, audio]
        mime_type:
          type: string
          example: image/jpeg
        size:
          type: integer
          description: File size in bytes
          example: 102400
        url:
          type: string
          format: uri
        dimensions:
          type: object
          properties:
            width:
              type: integer
            height:
              type: integer
        checksum:
          type: string
          description: MD5 hash
        created_at:
          type: string
          format: date-time
        last_modified:
          type: string
          format: date-time

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
            message:
              type: string

paths:
  /media/images/{key}:
    get:
      summary: Get image file
      security: []
      parameters:
        - name: key
          in: path
          required: true
          schema:
            type: string
          description: Image key (URL-encoded path)
        - name: w
          in: query
          schema:
            type: integer
          description: Resize width
        - name: h
          in: query
          schema:
            type: integer
          description: Resize height
        - name: q
          in: query
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 85
          description: Quality (1-100)
        - name: format
          in: query
          schema:
            type: string
            enum: [webp, jpg, png]
          description: Output format
      responses:
        '200':
          description: Image file
          content:
            image/jpeg:
              schema:
                type: string
                format: binary
            image/png:
              schema:
                type: string
                format: binary
            image/webp:
              schema:
                type: string
                format: binary
        '404':
          description: Image not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /media/audio/{key}:
    get:
      summary: Get audio file
      security: []
      parameters:
        - name: key
          in: path
          required: true
          schema:
            type: string
        - name: format
          in: query
          schema:
            type: string
            enum: [mp3, ogg, wav]
        - name: bitrate
          in: query
          schema:
            type: integer
          description: Bitrate in kbps
      responses:
        '200':
          description: Audio file
          content:
            audio/mpeg:
              schema:
                type: string
                format: binary
        '206':
          description: Partial content (range request)

  /media/upload:
    post:
      summary: Upload media file
      security:
        - BearerAuth: []
      requestBody:
        required: true
        content:
          multipart/form-data:
            schema:
              type: object
              required:
                - file
                - type
                - category
              properties:
                file:
                  type: string
                  format: binary
                type:
                  type: string
                  enum: [image, audio]
                category:
                  type: string
                lesson_id:
                  type: integer
                metadata:
                  type: string
                  description: JSON metadata
      responses:
        '201':
          description: File uploaded successfully

  /media/{type}/{key}:
    delete:
      summary: Delete media file
      security:
        - BearerAuth: []
      parameters:
        - name: type
          in: path
          required: true
          schema:
            type: string
            enum: [images, audio]
        - name: key
          in: path
          required: true
          schema:
            type: string
      responses:
        '200':
          description: File deleted successfully

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
