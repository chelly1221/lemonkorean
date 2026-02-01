# Admin Dashboard Service

Administration service for Lemon Korean platform providing comprehensive management, analytics, and monitoring capabilities.

## Overview

The Admin Service provides a complete dashboard for managing users, content, media, and monitoring system health. All endpoints require admin authentication and include full audit logging.

**Base URL:** `https://lemon.3chan.kr/api/admin`

## Features

### 1. User Management
- List users with pagination, search, and filtering
- View detailed user information with statistics
- Update user profiles and subscription types
- Ban/unban user accounts
- View user activity logs
- Access audit trail for all user modifications

### 2. Content Management (CRUD)
- **Lessons**: Create, update, delete, publish/unpublish lessons
- **Vocabulary**: Full CRUD operations for vocabulary entries
- Bulk operations (publish/delete multiple lessons)
- Automatic cache invalidation after updates
- Draft/Published/Archived workflow

### 3. Media Upload
- Upload files to MinIO object storage
- Support for images, audio, video, documents
- File type and size validation per category
- List uploaded media with pagination
- Get file metadata
- Delete media files

### 4. Analytics Dashboard
- Overview statistics (users, lessons, progress, vocabulary)
- User analytics with time series data
- Engagement metrics and completion trends
- Content statistics by level and type
- Popular lessons ranking

### 5. System Monitoring
- Health checks for all services (PostgreSQL, MongoDB, Redis, MinIO)
- System logs with pagination and filtering
- Performance metrics (memory, uptime, process info)
- External service status monitoring

### 6. Audit Logging
- Complete tracking of all admin actions
- Records: admin user, action, resource type, changes, IP, timestamp
- Queryable audit trail for compliance

## API Endpoints

### Authentication
All endpoints require:
- `Authorization: Bearer <JWT_TOKEN>` header
- Admin privileges (checked via role, email pattern, or whitelist)

### User Management (`/users`)

```bash
# List users
GET /api/admin/users?page=1&limit=10&search=john&subscription=premium&status=active

# Get user details
GET /api/admin/users/:id

# Update user
PUT /api/admin/users/:id
Body: { "subscription_type": "premium", "name": "New Name" }

# Ban/unban user
PUT /api/admin/users/:id/ban
Body: { "is_active": false }

# Delete user
DELETE /api/admin/users/:id

# Get user activity
GET /api/admin/users/:id/activity

# Get audit logs
GET /api/admin/users/audit-logs?page=1&limit=10
```

### Lesson Management (`/lessons`)

```bash
# List all lessons (including drafts)
GET /api/admin/lessons?page=1&limit=10&level=1&status=published

# Get lesson details
GET /api/admin/lessons/:id

# Create lesson
POST /api/admin/lessons
Body: {
  "level": 1,
  "week": 1,
  "order_num": 1,
  "title_ko": "레슨 제목",
  "title_zh": "课程标题",
  "description_ko": "설명",
  "description_zh": "说明",
  "duration_minutes": 30,
  "difficulty": "beginner",
  "content": { /* MongoDB content */ },
  "status": "draft"
}

# Update lesson
PUT /api/admin/lessons/:id
Body: { "title_ko": "새 제목", "status": "published" }

# Delete lesson
DELETE /api/admin/lessons/:id

# Publish lesson
PUT /api/admin/lessons/:id/publish

# Unpublish lesson
PUT /api/admin/lessons/:id/unpublish

# Get lesson content (MongoDB)
GET /api/admin/lessons/:id/content

# Save lesson content (MongoDB)
PUT /api/admin/lessons/:id/content
Body: { "stage1_intro": {...}, "stage2_vocabulary": {...}, ... }

# Bulk publish
POST /api/admin/lessons/bulk-publish
Body: { "lessonIds": [1, 2, 3] }

# Bulk delete
POST /api/admin/lessons/bulk-delete
Body: { "lessonIds": [4, 5, 6] }
```

### Vocabulary Management (`/vocabulary`)

```bash
# List vocabulary
GET /api/admin/vocabulary?page=1&limit=10&level=1

# Get vocabulary entry
GET /api/admin/vocabulary/:id

# Create vocabulary
POST /api/admin/vocabulary
Body: {
  "korean": "안녕하세요",
  "hanja": null,
  "chinese": "你好",
  "pinyin": "nǐ hǎo",
  "part_of_speech": "interjection",
  "level": 1,
  "similarity_score": 0.95,
  "audio_url_male": "http://...",
  "audio_url_female": "http://..."
}

# Update vocabulary
PUT /api/admin/vocabulary/:id
Body: { "level": 2, "notes": "Updated note" }

# Delete vocabulary
DELETE /api/admin/vocabulary/:id

# Download Excel template
GET /api/admin/vocabulary/template

# Bulk upload from Excel
POST /api/admin/vocabulary/bulk-upload
Content-Type: multipart/form-data
Form fields:
  - file: <Excel file>

# Bulk delete
POST /api/admin/vocabulary/bulk-delete
Body: { "vocabularyIds": [1, 2, 3] }
```

### Media Upload (`/media`)

```bash
# Upload file
POST /api/admin/media/upload
Content-Type: multipart/form-data
Form fields:
  - file: <file>
  - type: images|audio|video|documents

# List uploaded media
GET /api/admin/media?page=1&limit=10&type=images

# Get file metadata
GET /api/admin/media/:key/metadata

# Delete media file
DELETE /api/admin/media/:key
```

**File Validation Limits:**
- Images: 10 MB (jpeg, jpg, png, gif, webp)
- Audio: 50 MB (mp3, wav, ogg)
- Video: 200 MB (mp4, webm, ogg)
- Documents: 20 MB (pdf, doc, docx)

### Analytics (`/analytics`)

```bash
# Dashboard overview
GET /api/admin/analytics/overview

# User analytics (7d, 30d, 90d)
GET /api/admin/analytics/users?period=30d

# Engagement metrics
GET /api/admin/analytics/engagement?period=7d

# Content statistics
GET /api/admin/analytics/content
```

### System Monitoring (`/system`)

```bash
# Service health checks
GET /api/admin/system/health

# System logs (audit trail)
GET /api/admin/system/logs?page=1&limit=50&action=lesson.create&status=success

# System metrics
GET /api/admin/system/metrics
```

## Architecture

### 5-Layer Pattern
```
Config → Models → Services → Controllers → Routes
         ↓
    Middleware (Auth + Admin + Audit)
```

### Multi-Database Integration
- **PostgreSQL**: User and lesson metadata, audit logs
- **MongoDB**: Lesson content JSON, event logs
- **Redis**: Caching with TTL (2-5 minutes)
- **MinIO**: Media file storage (S3 compatible)

### Middleware Chain
```javascript
router.post('/lessons',
  requireAuth,      // JWT verification
  requireAdmin,     // Admin privilege check
  auditLog('lesson.create', 'lesson'),  // Action logging
  controller.createLesson
);
```

## Authentication & Authorization

### Admin Detection (Hybrid Approach)

The service uses multiple methods to determine admin status:

1. **Role-based** (preferred): `role IN ('admin', 'content_editor', 'super_admin')`
2. **Email pattern**: Email contains 'admin@'
3. **Email whitelist**: `ADMIN_EMAILS` environment variable
4. **User ID**: First user (ID=1) is admin

### Admin User Creation

```bash
# Method 1: Register with admin@ email
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@yourcompany.com",
    "password": "SecurePassword123",
    "name": "Admin User"
  }'

# Method 2: Update existing user role in database
UPDATE users SET role = 'super_admin' WHERE email = 'user@example.com';
```

## Environment Variables

```env
# Server
PORT=3006
NODE_ENV=production

# PostgreSQL
DATABASE_URL=postgres://user:password@postgres:5432/lemon_korean

# MongoDB
MONGO_URL=mongodb://user:password@mongo:27017/lemon_korean?authSource=admin

# Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password

# MinIO
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secret_key
MINIO_USE_SSL=false

# JWT (shared with Auth Service)
JWT_SECRET=your_jwt_secret

# Admin Authorization
ADMIN_EMAILS=admin@lemon.com,admin@yourcompany.com
```

## Database Schema

### PostgreSQL Tables

**admin_audit_logs**
```sql
CREATE TABLE admin_audit_logs (
    id SERIAL PRIMARY KEY,
    admin_id INTEGER NOT NULL REFERENCES users(id),
    admin_email VARCHAR(255) NOT NULL,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    resource_id INTEGER,
    changes JSONB,
    ip_address INET,
    user_agent TEXT,
    status VARCHAR(20) DEFAULT 'success',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

**admin_stats_cache**
```sql
CREATE TABLE admin_stats_cache (
    cache_key VARCHAR(255) PRIMARY KEY,
    cache_data JSONB NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Cache Strategy

### Redis Caching
- **Users**: `admin:users:*` (TTL: 2 min)
- **Lessons**: `admin:lessons:*` (TTL: 5 min)
- **Vocabulary**: `admin:vocabulary:*` (TTL: 5 min)
- **Analytics**: `admin:analytics:*` (TTL: 5 min)

### Cache Invalidation
After mutations, the service invalidates:
- Specific resource caches
- Related list caches
- Content Service caches (for lesson updates)

```javascript
// Example: After lesson update
redis.del(`admin:lessons:${id}`);
redis.del('admin:lessons:list:*');
redis.del(`lesson:full:${id}`);  // Content Service cache
redis.del(`lesson:package:${id}`);
```

## Error Handling

All endpoints return standardized error responses:

```json
{
  "error": "Error Type",
  "message": "Human-readable error message",
  "code": "ERROR_CODE",
  "details": "Additional details (development only)"
}
```

**Common Status Codes:**
- `200`: Success
- `400`: Bad Request (validation error)
- `401`: Unauthorized (missing/invalid token)
- `403`: Forbidden (admin access required)
- `404`: Not Found
- `500`: Internal Server Error

## Testing

### Get Admin Token
```bash
# Login as admin
TOKEN=$(curl -s -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lemon.com","password":"YourPassword"}' \
  | jq -r '.data.accessToken')
```

### Test Endpoints
```bash
# List users
curl -H "Authorization: Bearer $TOKEN" \
  "https://lemon.3chan.kr/api/admin/users?page=1&limit=10" | jq

# Create lesson
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"level":1,"title_ko":"테스트","title_zh":"测试","status":"draft"}' \
  https://lemon.3chan.kr/api/admin/lessons | jq

# Upload image
curl -X POST -H "Authorization: Bearer $TOKEN" \
  -F "file=@test.jpg" \
  -F "type=images" \
  https://lemon.3chan.kr/api/admin/media/upload | jq

# Get analytics
curl -H "Authorization: Bearer $TOKEN" \
  https://lemon.3chan.kr/api/admin/analytics/overview | jq

# Check system health
curl -H "Authorization: Bearer $TOKEN" \
  https://lemon.3chan.kr/api/admin/system/health | jq
```

## Docker

### Build & Run
```bash
# Build image
docker build -t lemon-admin-service .

# Run container
docker run -d \
  --name lemon-admin-service \
  -p 3006:3006 \
  --env-file .env \
  lemon-admin-service
```

### Docker Compose
```yaml
admin-service:
  build: ./services/admin
  container_name: lemon-admin-service
  environment:
    PORT: 3006
    DATABASE_URL: postgres://...
    MONGO_URL: mongodb://...
    # ... other env vars
  ports:
    - "3006:3006"
  depends_on:
    - postgres
    - mongo
    - redis
    - minio
  networks:
    - lemon-network
```

## Development

### Project Structure
```
services/admin/
├── src/
│   ├── index.js                    # Express app
│   ├── config/                     # Database connections
│   │   ├── database.js             # PostgreSQL
│   │   ├── mongodb.js              # MongoDB
│   │   ├── redis.js                # Redis
│   │   ├── minio.js                # MinIO
│   │   └── jwt.js                  # JWT config
│   ├── models/                     # Data access layer
│   │   ├── user.model.js
│   │   ├── lesson.model.js
│   │   ├── vocabulary.model.js
│   │   └── audit.model.js
│   ├── services/                   # Business logic
│   │   ├── user-management.service.js
│   │   ├── content-management.service.js
│   │   ├── media-upload.service.js
│   │   ├── analytics.service.js
│   │   └── system-monitoring.service.js
│   ├── controllers/                # HTTP handlers
│   │   ├── users.controller.js
│   │   ├── lessons.controller.js
│   │   ├── vocabulary.controller.js
│   │   ├── media.controller.js
│   │   ├── analytics.controller.js
│   │   └── system.controller.js
│   ├── routes/                     # Route definitions
│   │   ├── users.routes.js
│   │   ├── lessons.routes.js
│   │   ├── vocabulary.routes.js
│   │   ├── media.routes.js
│   │   ├── analytics.routes.js
│   │   └── system.routes.js
│   ├── middleware/
│   │   ├── auth.middleware.js      # Auth + Admin checks
│   │   ├── audit.middleware.js     # Action logging
│   │   └── validation.middleware.js
│   └── utils/
│       ├── cache-helpers.js        # Redis helpers
│       └── cache-invalidation.js   # Cache busting
├── package.json
├── Dockerfile
└── README.md
```

### Install Dependencies
```bash
npm install
```

### Run in Development
```bash
npm run dev
```

## Security

### Best Practices
- ✅ All passwords hashed with bcrypt
- ✅ JWT tokens with expiration
- ✅ Parameterized SQL queries (SQL injection prevention)
- ✅ Rate limiting (100 req/min per admin)
- ✅ File type validation for uploads
- ✅ File size limits per category
- ✅ IP address logging in audit trail
- ✅ Admin self-protection (can't ban themselves)
- ✅ Complete audit trail for compliance

### Audit Trail
Every mutation is logged with:
- Admin user ID and email
- Action performed
- Resource type and ID
- Changes made (JSON)
- IP address
- User agent
- Timestamp
- Success/failure status

## Performance

### Caching Strategy
- Redis caching with 2-5 minute TTL
- Pattern-based cache invalidation
- Automatic cache warming for analytics

### Database Optimization
- Indexed columns for common queries
- Pagination for all list endpoints
- Aggregation queries for statistics
- Connection pooling for PostgreSQL

## Monitoring

### Health Checks
- Service uptime
- Database connectivity (PostgreSQL, MongoDB, Redis, MinIO)
- External service status
- Memory usage
- Process information

### Logs
- Request logging with timestamps
- Authentication events
- Admin actions (audit trail)
- Error logging with stack traces (development)

## License

Part of Lemon Korean (柠檬韩语) platform.

## Support

For issues or questions, contact the development team.
