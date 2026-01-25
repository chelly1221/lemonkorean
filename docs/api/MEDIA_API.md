# Media Service API Documentation

**Base URL**: `http://localhost:3004`

**OpenAPI Version**: 3.0.3

---

## Table of Contents

- [Authentication](#authentication)
- [Endpoints](#endpoints)
  - [Get Image](#get-image)
  - [Get Audio](#get-audio)
  - [Upload Media](#upload-media)
  - [Delete Media](#delete-media)
  - [Get Media Info](#get-media-info)
  - [Batch Download](#batch-download)
  - [Health Check](#health-check)
- [Error Codes](#error-codes)
- [Data Models](#data-models)

---

## Authentication

Media retrieval endpoints (`GET /media/images/:key`, `GET /media/audio/:key`) do NOT require authentication for public content.

Upload and delete operations require JWT authentication:

```
Authorization: Bearer <jwt_token>
```

---

## Endpoints

### Get Image

Retrieve an image file.

**Endpoint**: `GET /media/images/:key`

**Authentication**: Not required for public content

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `key` | string | Yes | Image key (URL-encoded path) |

#### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `w` | integer | No | - | Resize width (px) |
| `h` | integer | No | - | Resize height (px) |
| `q` | integer | No | 85 | Quality (1-100) |
| `format` | string | No | original | Output format (webp, jpg, png) |

#### Response

**Status**: `200 OK`

**Content-Type**: `image/jpeg`, `image/png`, `image/webp`, etc.

Binary image data

#### Headers

```
Cache-Control: public, max-age=604800
ETag: "a1b2c3d4e5f6"
Content-Length: 102400
Last-Modified: Wed, 25 Jan 2024 10:30:00 GMT
```

#### Example

```bash
# Get original image
curl -X GET http://localhost:3004/media/images/lessons/1/thumbnail.jpg

# Get resized image (300x200, WebP format, 90% quality)
curl -X GET "http://localhost:3004/media/images/lessons/1/thumbnail.jpg?w=300&h=200&format=webp&q=90"

# Get thumbnail (100x100)
curl -X GET "http://localhost:3004/media/images/vocab/1/image.jpg?w=100&h=100"
```

#### Error Responses

**Status**: `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "IMAGE_NOT_FOUND",
    "message": "Image not found: lessons/1/thumbnail.jpg"
  }
}
```

**Status**: `400 Bad Request`

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

### Get Audio

Retrieve an audio file.

**Endpoint**: `GET /media/audio/:key`

**Authentication**: Not required for public content

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `key` | string | Yes | Audio key (URL-encoded path) |

#### Query Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `format` | string | No | original | Output format (mp3, ogg, wav) |
| `bitrate` | integer | No | 128 | Bitrate (kbps) for transcoding |

#### Response

**Status**: `200 OK`

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

#### Example

```bash
# Get original audio
curl -X GET http://localhost:3004/media/audio/vocab/1/pronunciation.mp3

# Get audio with specific format and bitrate
curl -X GET "http://localhost:3004/media/audio/vocab/1/pronunciation.mp3?format=ogg&bitrate=64"

# Range request (for streaming)
curl -X GET http://localhost:3004/media/audio/lessons/1/dialogue.mp3 \
  -H "Range: bytes=0-1048575"
```

#### Error Responses

**Status**: `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "AUDIO_NOT_FOUND",
    "message": "Audio file not found: vocab/1/pronunciation.mp3"
  }
}
```

**Status**: `416 Range Not Satisfiable`

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

### Upload Media

Upload a media file (admin only).

**Endpoint**: `POST /media/upload`

**Authentication**: Required (JWT with admin role)

#### Request

**Content-Type**: `multipart/form-data`

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `file` | file | Yes | Media file |
| `type` | string | Yes | Media type (image, audio) |
| `category` | string | Yes | Category (lessons, vocab, grammar, etc.) |
| `lesson_id` | integer | No | Associated lesson ID |
| `metadata` | string | No | JSON metadata |

#### Response

**Status**: `201 Created`

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

#### Example

```bash
curl -X POST http://localhost:3004/media/upload \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -F "file=@/path/to/image.jpg" \
  -F "type=image" \
  -F "category=lessons" \
  -F "lesson_id=1" \
  -F 'metadata={"alt_text":"Lesson 1 thumbnail"}'
```

#### Error Responses

**Status**: `400 Bad Request`

```json
{
  "success": false,
  "error": {
    "code": "INVALID_FILE_TYPE",
    "message": "File type not allowed. Allowed types: jpg, png, webp, mp3, ogg, wav"
  }
}
```

**Status**: `413 Payload Too Large`

```json
{
  "success": false,
  "error": {
    "code": "FILE_TOO_LARGE",
    "message": "File size exceeds maximum allowed size of 50MB"
  }
}
```

**Status**: `403 Forbidden`

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

### Delete Media

Delete a media file (admin only).

**Endpoint**: `DELETE /media/:type/:key`

**Authentication**: Required (JWT with admin role)

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `type` | string | Yes | Media type (images, audio) |
| `key` | string | Yes | Media key (URL-encoded path) |

#### Response

**Status**: `200 OK`

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

#### Example

```bash
curl -X DELETE http://localhost:3004/media/images/lessons/1/old-thumbnail.jpg \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

#### Error Responses

**Status**: `404 Not Found`

```json
{
  "success": false,
  "error": {
    "code": "MEDIA_NOT_FOUND",
    "message": "Media file not found"
  }
}
```

**Status**: `409 Conflict`

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

### Get Media Info

Get metadata about a media file.

**Endpoint**: `GET /media/info/:type/:key`

**Authentication**: Not required

#### Path Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `type` | string | Yes | Media type (images, audio) |
| `key` | string | Yes | Media key (URL-encoded path) |

#### Response

**Status**: `200 OK`

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

#### Example

```bash
curl -X GET http://localhost:3004/media/info/images/lessons/1/thumbnail.jpg
```

---

### Batch Download

Get download URLs for multiple media files.

**Endpoint**: `POST /media/batch-download`

**Authentication**: Required (JWT)

#### Request Body

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

#### Response

**Status**: `200 OK`

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

#### Example

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

### Health Check

Check if Media Service is healthy.

**Endpoint**: `GET /health`

**Authentication**: Not required

#### Response

**Status**: `200 OK`

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

#### Example

```bash
curl -X GET http://localhost:3004/health
```

---

## Error Codes

| Code | HTTP Status | Description |
|------|-------------|-------------|
| `IMAGE_NOT_FOUND` | 404 | Image file not found |
| `AUDIO_NOT_FOUND` | 404 | Audio file not found |
| `MEDIA_NOT_FOUND` | 404 | Media file not found |
| `INVALID_DIMENSIONS` | 400 | Invalid width or height |
| `INVALID_RANGE` | 416 | Invalid byte range |
| `INVALID_FILE_TYPE` | 400 | File type not allowed |
| `FILE_TOO_LARGE` | 413 | File exceeds size limit |
| `ADMIN_ONLY` | 403 | Admin privileges required |
| `MEDIA_IN_USE` | 409 | Media file is still referenced |
| `UPLOAD_FAILED` | 500 | Failed to upload file |
| `UNAUTHORIZED` | 401 | Authentication required |
| `INTERNAL_SERVER_ERROR` | 500 | Server error occurred |
| `SERVICE_UNAVAILABLE` | 503 | Service temporarily unavailable |

---

## Data Models

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

## Rate Limiting

Media endpoints have rate limiting:

| Endpoint | Limit | Window |
|----------|-------|--------|
| `GET /media/images/:key` | 1000 requests | 1 minute |
| `GET /media/audio/:key` | 500 requests | 1 minute |
| `POST /media/upload` | 100 requests | 1 hour |
| `DELETE /media/:type/:key` | 50 requests | 1 hour |

When rate limit is exceeded:

**Status**: `429 Too Many Requests`

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

Headers:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1706268000
Retry-After: 60
```

---

## Caching

### Client-Side Caching

All media files include cache headers:

```
Cache-Control: public, max-age=604800
ETag: "a1b2c3d4e5f6"
Last-Modified: Wed, 25 Jan 2024 10:30:00 GMT
```

Use conditional requests to save bandwidth:

```bash
# First request
curl -X GET http://localhost:3004/media/images/lessons/1/thumbnail.jpg \
  -v

# Subsequent request with ETag
curl -X GET http://localhost:3004/media/images/lessons/1/thumbnail.jpg \
  -H "If-None-Match: \"a1b2c3d4e5f6\""

# Response: 304 Not Modified (if unchanged)
```

### Server-Side Caching

The media service implements:
- **Memory cache** (frequently accessed files)
- **CDN integration** (production)
- **Image processing cache** (resized/transcoded variants)

---

## Image Processing

### Supported Formats

**Input**: JPEG, PNG, WebP, GIF
**Output**: JPEG, PNG, WebP

### Resize Modes

**Query Parameter**: `mode`

- `fit` (default): Fit within dimensions, maintain aspect ratio
- `fill`: Fill dimensions, crop if needed
- `stretch`: Stretch to exact dimensions

Example:
```bash
# Fit mode (default)
curl "http://localhost:3004/media/images/lessons/1/banner.jpg?w=800&h=400&mode=fit"

# Fill mode (cropped)
curl "http://localhost:3004/media/images/lessons/1/banner.jpg?w=800&h=400&mode=fill"
```

### Quality

**Query Parameter**: `q` (1-100, default: 85)

```bash
# High quality (larger file)
curl "http://localhost:3004/media/images/lessons/1/photo.jpg?q=95"

# Low quality (smaller file)
curl "http://localhost:3004/media/images/lessons/1/photo.jpg?q=60"
```

---

## Audio Streaming

### Range Requests

Audio files support HTTP range requests for streaming:

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

### Transcoding

**Query Parameter**: `format` (mp3, ogg, wav)
**Query Parameter**: `bitrate` (kbps)

```bash
# Convert to OGG, 64kbps
curl "http://localhost:3004/media/audio/vocab/1/audio.mp3?format=ogg&bitrate=64"
```

---

## OpenAPI 3.0 Specification

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
