# Lemon Korean API Documentation

**柠檬韩语 API 文档 | 레몬 코리안 API 문서**

Welcome to the Lemon Korean API documentation. This directory contains comprehensive API documentation for all microservices in the Lemon Korean platform.

---

## 📚 API Services

| Service | Port | Documentation | Description |
|---------|------|---------------|-------------|
| **Auth Service** | 3001 | [AUTH_API.md](./AUTH_API.md) | User authentication and management |
| **Content Service** | 3002 | [CONTENT_API.md](./CONTENT_API.md) | Lessons, vocabulary, and grammar content |
| **Progress Service** | 3003 | [PROGRESS_API.md](./PROGRESS_API.md) | Learning progress and SRS reviews |
| **Media Service** | 3004 | [MEDIA_API.md](./MEDIA_API.md) | Image and audio file serving |

---

## 🚀 Quick Start

### Base URLs

**Development**:
```
Auth Service:     http://localhost:3001/api/auth
Content Service:  http://localhost:3002/api/content
Progress Service: http://localhost:3003/api/progress
Media Service:    http://localhost:3004
```

**Production**:
```
Auth Service:     https://api.lemonkorean.com/auth
Content Service:  https://api.lemonkorean.com/content
Progress Service: https://api.lemonkorean.com/progress
Media Service:    https://media.lemonkorean.com
```

### Authentication

Most endpoints require JWT authentication. Include the token in the `Authorization` header:

```bash
Authorization: Bearer <your_jwt_token>
```

### Getting Started

1. **Register a new user**:
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

2. **Login to get token**:
```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecureP@ss123"
  }'
```

3. **Use token for authenticated requests**:
```bash
curl -X GET http://localhost:3002/api/content/lessons \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## 📖 API Overview

### Auth Service

**Purpose**: User authentication, registration, and profile management

**Key Endpoints**:
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Authenticate user
- `POST /api/auth/refresh` - Refresh access token
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update profile
- `POST /api/auth/change-password` - Change password

**Documentation**: [AUTH_API.md](./AUTH_API.md)

---

### Content Service

**Purpose**: Lesson content, vocabulary, and grammar management

**Key Endpoints**:
- `GET /api/content/lessons` - Get lessons list
- `GET /api/content/lessons/:id` - Get lesson detail
- `GET /api/content/lessons/:id/download` - Download lesson package
- `POST /api/content/check-updates` - Check for updates
- `GET /api/content/vocabulary` - Get vocabulary list
- `GET /api/content/grammar` - Get grammar points
- `GET /api/content/search` - Search content

**Documentation**: [CONTENT_API.md](./CONTENT_API.md)

---

### Progress Service

**Purpose**: Learning progress tracking and spaced repetition system (SRS)

**Key Endpoints**:
- `GET /api/progress/user/:userId` - Get user progress
- `POST /api/progress/complete` - Complete lesson
- `PUT /api/progress/lesson/:lessonId` - Update lesson progress
- `POST /api/progress/sync` - Sync offline progress
- `GET /api/progress/review-schedule` - Get SRS review schedule
- `POST /api/progress/review` - Submit review result
- `GET /api/progress/statistics` - Get learning statistics
- `GET /api/progress/streak` - Get learning streak

**Documentation**: [PROGRESS_API.md](./PROGRESS_API.md)

---

### Media Service

**Purpose**: Image and audio file serving with on-the-fly processing

**Key Endpoints**:
- `GET /media/images/:key` - Get image (with resize/format options)
- `GET /media/audio/:key` - Get audio (with transcode options)
- `POST /media/upload` - Upload media file (admin)
- `DELETE /media/:type/:key` - Delete media file (admin)
- `GET /media/info/:type/:key` - Get media metadata
- `POST /media/batch-download` - Batch download URLs

**Documentation**: [MEDIA_API.md](./MEDIA_API.md)

---

## 🔒 Authentication & Authorization

### JWT Token Structure

```json
{
  "sub": "1",
  "email": "user@example.com",
  "role": "user",
  "iat": 1706268000,
  "exp": 1706872800
}
```

### Token Lifecycle

1. **Access Token**: Valid for 7 days
2. **Refresh Token**: Valid for 30 days
3. **Token Refresh**: Use `/api/auth/refresh` endpoint before access token expires

### Authorization Levels

| Level | Description | Required For |
|-------|-------------|--------------|
| **Public** | No authentication | Health checks, media retrieval |
| **User** | JWT required | Content access, progress tracking |
| **Admin** | JWT with admin role | Media upload/delete, content management |

---

## 📊 Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    // Response data
  }
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": [] // Optional, for validation errors
  }
}
```

### Pagination

```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "total_pages": 8
    }
  }
}
```

---

## ⚠️ Common Error Codes

### HTTP Status Codes

| Code | Name | Description |
|------|------|-------------|
| `200` | OK | Request succeeded |
| `201` | Created | Resource created successfully |
| `204` | No Content | Request succeeded, no content to return |
| `206` | Partial Content | Partial data (range requests) |
| `400` | Bad Request | Invalid request data |
| `401` | Unauthorized | Authentication required or failed |
| `403` | Forbidden | Insufficient permissions |
| `404` | Not Found | Resource not found |
| `409` | Conflict | Resource conflict (e.g., duplicate) |
| `413` | Payload Too Large | Request body too large |
| `416` | Range Not Satisfiable | Invalid byte range |
| `422` | Unprocessable Entity | Validation error |
| `423` | Locked | Resource locked (e.g., account) |
| `429` | Too Many Requests | Rate limit exceeded |
| `500` | Internal Server Error | Server error |
| `503` | Service Unavailable | Service temporarily unavailable |

### Application Error Codes

| Code | Service | Description |
|------|---------|-------------|
| `VALIDATION_ERROR` | All | Invalid input data |
| `UNAUTHORIZED` | All | Authentication required |
| `FORBIDDEN` | All | Insufficient permissions |
| `INTERNAL_SERVER_ERROR` | All | Server error |
| `SERVICE_UNAVAILABLE` | All | Service down |
| `INVALID_CREDENTIALS` | Auth | Wrong email/password |
| `EMAIL_ALREADY_EXISTS` | Auth | Email already registered |
| `ACCOUNT_LOCKED` | Auth | Account temporarily locked |
| `LESSON_NOT_FOUND` | Content | Lesson not found |
| `SUBSCRIPTION_REQUIRED` | Content | Premium subscription required |
| `PROGRESS_NOT_FOUND` | Progress | Progress record not found |
| `SYNC_CONFLICT` | Progress | Data conflict during sync |
| `IMAGE_NOT_FOUND` | Media | Image file not found |
| `AUDIO_NOT_FOUND` | Media | Audio file not found |
| `FILE_TOO_LARGE` | Media | File exceeds size limit |
| `RATE_LIMIT_EXCEEDED` | Media | Rate limit exceeded |

---

## 🔄 Rate Limiting

### Limits by Service

| Service | Endpoint Type | Limit | Window |
|---------|---------------|-------|--------|
| Auth | Login | 5 requests | 15 minutes |
| Auth | Register | 3 requests | 1 hour |
| Auth | Other | 100 requests | 1 minute |
| Content | All | 1000 requests | 1 minute |
| Progress | All | 500 requests | 1 minute |
| Media | GET | 1000 requests | 1 minute |
| Media | POST/DELETE | 100 requests | 1 hour |

### Rate Limit Headers

When rate limit is exceeded, the response includes:

```
HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1706268000
Retry-After: 60
```

---

## 🧪 Testing APIs

### Using cURL

**Basic GET request**:
```bash
curl -X GET http://localhost:3002/api/content/lessons \
  -H "Authorization: Bearer <token>"
```

**POST with JSON body**:
```bash
curl -X POST http://localhost:3003/api/progress/complete \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "lesson_id": 1,
    "quiz_score": 95
  }'
```

**File upload**:
```bash
curl -X POST http://localhost:3004/media/upload \
  -H "Authorization: Bearer <token>" \
  -F "file=@/path/to/image.jpg" \
  -F "type=image" \
  -F "category=lessons"
```

### Using Postman

1. Import the OpenAPI 3.0 specifications from each API documentation
2. Set environment variables:
   - `base_url`: `http://localhost`
   - `auth_token`: Your JWT token
3. Use `{{base_url}}` and `{{auth_token}}` in requests

### Using HTTPie

**GET request**:
```bash
http GET localhost:3002/api/content/lessons \
  Authorization:"Bearer <token>"
```

**POST request**:
```bash
http POST localhost:3003/api/progress/complete \
  Authorization:"Bearer <token>" \
  user_id:=1 \
  lesson_id:=1 \
  quiz_score:=95
```

---

## 📝 API Changelog

### Version 1.0.0 (2024-01-26)

**Initial Release**

- ✅ Auth Service: User registration, login, profile management
- ✅ Content Service: Lesson content, vocabulary, grammar
- ✅ Progress Service: Progress tracking, SRS reviews, statistics
- ✅ Media Service: Image/audio serving with processing

---

## 🔗 Related Documentation

- **[Project Guide](../../CLAUDE.md)** - Complete development guide
- **[README](../../README.md)** - Project overview and setup
- **[Deployment Scripts](../../scripts/README.md)** - Deployment and operations

---

## 💡 Best Practices

### 1. Error Handling

Always handle errors gracefully:

```javascript
try {
  const response = await fetch('http://localhost:3002/api/content/lessons', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });

  if (!response.ok) {
    const error = await response.json();
    console.error(`Error ${error.error.code}: ${error.error.message}`);
    return;
  }

  const data = await response.json();
  // Handle success
} catch (error) {
  console.error('Network error:', error);
}
```

### 2. Token Management

Store tokens securely and refresh before expiration:

```javascript
// Check if token is about to expire
function isTokenExpiring(token) {
  const decoded = jwt_decode(token);
  const expiresIn = decoded.exp - (Date.now() / 1000);
  return expiresIn < 300; // Less than 5 minutes
}

// Refresh token if needed
if (isTokenExpiring(accessToken)) {
  const newTokens = await refreshAccessToken(refreshToken);
  // Update stored tokens
}
```

### 3. Pagination

Always implement pagination for list endpoints:

```javascript
async function fetchAllLessons() {
  let allLessons = [];
  let page = 1;
  let hasMore = true;

  while (hasMore) {
    const response = await fetch(
      `http://localhost:3002/api/content/lessons?page=${page}&limit=50`,
      { headers: { 'Authorization': `Bearer ${token}` } }
    );

    const data = await response.json();
    allLessons = [...allLessons, ...data.data.lessons];

    hasMore = page < data.data.pagination.total_pages;
    page++;
  }

  return allLessons;
}
```

### 4. Caching

Implement client-side caching for media files:

```javascript
// Use ETags for conditional requests
async function fetchImage(url, cachedETag) {
  const headers = {
    'Authorization': `Bearer ${token}`
  };

  if (cachedETag) {
    headers['If-None-Match'] = cachedETag;
  }

  const response = await fetch(url, { headers });

  if (response.status === 304) {
    // Use cached version
    return getCachedImage(url);
  }

  // Cache new version with ETag
  const etag = response.headers.get('ETag');
  const blob = await response.blob();
  cacheImage(url, blob, etag);

  return blob;
}
```

### 5. Offline Sync

Implement robust offline sync with conflict resolution:

```javascript
async function syncProgress() {
  const syncQueue = await getLocalSyncQueue();

  if (syncQueue.length === 0) return;

  const response = await fetch('http://localhost:3003/api/progress/sync', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      user_id: userId,
      sync_items: syncQueue
    })
  });

  const result = await response.json();

  // Remove synced items from queue
  for (const item of result.data.synced_items) {
    await removeSyncItem(item.index);
  }

  // Handle failed items
  for (const item of result.data.failed_items) {
    console.error(`Sync failed for item ${item.index}:`, item.error);
    // Optionally retry or notify user
  }
}
```

---

## 🆘 Support

For API issues or questions:

1. Check the specific service documentation
2. Review common error codes above
3. Check service health: `GET /health` or `GET /api/<service>/health`
4. Review logs: `./scripts/logs.sh <service-name>`
5. Create an issue on GitHub

---

## 📜 License

This API documentation is part of the Lemon Korean project.

---

**Last Updated**: 2024-01-26
**API Version**: 1.0.0

**Made with ❤️ for Chinese-speaking Korean learners**
