# Lemon Korean API Documentation

## Overview

The Lemon Korean API provides endpoints for managing lessons, vocabulary, grammar, user progress, gamification, and social features. All content endpoints support multi-language content via the `?language=` query parameter.

## Base URLs

| Service | Port | Base URL |
|---------|------|----------|
| Auth | 3001 | `/api/auth` |
| Content | 3002 | `/api/content` |
| Progress | 3003 | `/api/progress` |
| Media | 3004 | `/media` |
| Analytics | 3005 | `/api/analytics` |
| Admin | 3006 | `/api/admin` |
| SNS | 3007 | `/api/sns` |

---

## Multi-Language Support

All content endpoints (lessons, vocabulary, grammar) support the `?language=` query parameter for internationalized content.

### Supported Languages

| Code | Language |
|------|----------|
| `ko` | Korean |
| `en` | English |
| `es` | Spanish |
| `ja` | Japanese |
| `zh` | Chinese Simplified |
| `zh_TW` | Chinese Traditional |

### Language Resolution Priority

1. `?language=` query parameter
2. `Accept-Language` HTTP header
3. Default: `ko` (Korean - changed from `zh` on 2026-02-04)

### Fallback Chain

When a translation is not available, the API falls back in this order:

| Primary Language | Fallback Chain |
|------------------|----------------|
| `en` | en → zh → ko |
| `es` | es → en → zh → ko |
| `ja` | ja → zh → ko |
| `zh` | zh → ko |
| `zh_TW` | zh_TW → zh → ko |
| `ko` | ko |

### Example

```bash
# Get lessons in English
curl "https://api.lemonkorean.com/api/content/lessons?language=en"

# Get lesson in Japanese
curl "https://api.lemonkorean.com/api/content/lessons/1?language=ja"
```

---

## Content Service Endpoints

### Lessons

#### GET /api/content/lessons

Get all lessons with pagination.

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `level` | int | - | Filter by TOPIK level (0-6) |
| `status` | string | `published` | Lesson status |
| `page` | int | 1 | Page number |
| `limit` | int | 20 | Items per page (max: 100) |
| `language` | string | `ko` | Content language code |

**Response:**
```json
{
  "success": true,
  "lessons": [
    {
      "id": 1,
      "level": 1,
      "title_ko": "한글 기초",
      "title": "Hangul Basics",
      "description": "Learn the Korean alphabet",
      "content_language": "en",
      "vocabulary_count": 10,
      "estimated_minutes": 30
    }
  ],
  "pagination": {
    "total": 100,
    "page": 1,
    "limit": 20,
    "totalPages": 5
  }
}
```

#### GET /api/content/lessons/:id

Get a single lesson with full content.

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `language` | string | `ko` | Content language code |

**Response includes:**
- Lesson metadata with localized title/description
- Vocabulary with localized translations/pronunciations
- Grammar rules with localized explanations
- MongoDB content (stages)

---

### Vocabulary

#### GET /api/content/vocabulary

Get all vocabulary with filtering.

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `level` | int | - | Filter by TOPIK level (0-6) |
| `part_of_speech` | string | - | Filter by POS |
| `search` | string | - | Search in Korean/translation |
| `page` | int | 1 | Page number |
| `limit` | int | 50 | Items per page (max: 100) |
| `language` | string | `ko` | Content language code |

**Response:**
```json
{
  "success": true,
  "vocabulary": [
    {
      "id": 1,
      "korean": "사람",
      "hanja": "人",
      "translation": "person",
      "pronunciation": "saram",
      "part_of_speech": "noun",
      "level": 1,
      "similarity_score": 0.8,
      "content_language": "en"
    }
  ],
  "pagination": { ... }
}
```

#### GET /api/content/vocabulary/search

Search vocabulary.

**Query Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `q` | string | Yes | Search term |
| `limit` | int | No | Result limit (default: 20, max: 100) |
| `language` | string | No | Content language code |

---

### Grammar

#### GET /api/content/grammar

Get all grammar rules with filtering.

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `level` | int | - | Filter by TOPIK level (0-6) |
| `category` | string | - | Filter by category |
| `page` | int | 1 | Page number |
| `limit` | int | 50 | Items per page (max: 200) |
| `language` | string | `ko` | Content language code |

**Response:**
```json
{
  "success": true,
  "grammar": [
    {
      "id": 1,
      "name_ko": "-은/는",
      "name": "Topic Marker",
      "category": "particles",
      "level": 1,
      "description": "Used to mark the topic of a sentence",
      "language_comparison": "Similar to 'as for' in English",
      "content_language": "en"
    }
  ],
  "pagination": { ... }
}
```

---

### Hangul (Korean Alphabet)

Korean alphabet learning endpoints for character details, pronunciation guides, and practice content.

#### GET /api/content/hangul/characters

Get all hangul characters with optional filtering.

**Query Parameters:**
- `character_type` (optional): Filter by type
  - `basic_consonant` - Basic consonants (ㄱ, ㄴ, ㄷ, etc.)
  - `double_consonant` - Double consonants (ㄲ, ㄸ, ㅃ, etc.)
  - `basic_vowel` - Basic vowels (ㅏ, ㅓ, ㅗ, etc.)
  - `compound_vowel` - Compound vowels (ㅐ, ㅔ, ㅘ, etc.)
  - `final_consonant` - Final consonants (받침)

**Response:**
```json
{
  "success": true,
  "count": 40,
  "characters": [
    {
      "id": 1,
      "character": "ㄱ",
      "romanization": "g/k",
      "character_type": "basic_consonant",
      "audio_url": "/media/hangul/audio/basic_consonant_giyeok.mp3",
      "pronunciation_guide": { ... }
    }
  ]
}
```

#### GET /api/content/hangul/characters/:id

Get detailed character information including pronunciation guide.

#### GET /api/content/hangul/table

Get organized alphabet table grouped by type (for UI display).

#### GET /api/content/hangul/stats

Get character statistics (counts by type).

#### GET /api/content/hangul/characters/type/:type

Get characters filtered by specific type (convenience endpoint).

#### GET /api/content/hangul/pronunciation-guides

Get pronunciation guides for all characters.

**Response includes:**
- Mouth shape diagrams
- Tongue position diagrams
- Airflow descriptions
- Native language comparisons (zh, en, ja, es)
- Similar character IDs for discrimination practice

#### GET /api/content/hangul/pronunciation-guides/:characterId

Get pronunciation guide for specific character.

#### GET /api/content/hangul/syllables

Get syllable combinations with audio.

**Query Parameters:**
- `initial`: Filter by initial consonant ID
- `vowel`: Filter by vowel ID
- `final`: Filter by final consonant ID

#### GET /api/content/hangul/similar-sounds

Get similar sound groups for discrimination training.

**Query Parameters:**
- `category`: Filter by `consonant` or `vowel`

---

### Web Deployment

Admin-only endpoints for automated web app deployment.

#### POST /api/admin/deploy/web/start

Start Flutter web app deployment (requires admin auth).

**Response:**
```json
{
  "success": true,
  "deployment": {
    "id": 123,
    "status": "running",
    "progress": 0,
    "started_at": "2026-02-04T10:30:00Z"
  }
}
```

#### GET /api/admin/deploy/web/status/:id

Get real-time deployment status and progress (0-100%).

#### GET /api/admin/deploy/web/logs/:id

Get deployment logs (stdout/stderr) with polling support.

**Query Parameters:**
- `offset`: Log offset for pagination (default: 0)
- `limit`: Number of logs to return (default: 100)

#### GET /api/admin/deploy/web/history

List deployment history with pagination.

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)

#### DELETE /api/admin/deploy/web/:id

Cancel running deployment (requires admin auth).

---

## App Theme Configuration

Admin endpoints for managing Flutter app theme settings.

### GET /api/admin/app-theme

Get current app theme configuration (public endpoint, no auth required).

**Response**:
```json
{
  "success": true,
  "theme": {
    "id": 1,
    "version": 5,
    "colors": {
      "primary": "#FFEF5F",
      "secondary": "#4CAF50",
      "accent": "#FF9800",
      "error": "#F44336",
      "success": "#4CAF50",
      "warning": "#FF9800",
      "info": "#2196F3",
      "textPrimary": "#212121",
      "textSecondary": "#757575",
      "textHint": "#BDBDBD",
      "backgroundLight": "#FAFAFA",
      "backgroundDark": "#303030",
      "cardBackground": "#FFFFFF",
      "stages": {
        "stage1": "#2196F3",
        "stage2": "#4CAF50",
        "stage3": "#FF9800",
        "stage4": "#9C27B0",
        "stage5": "#F44336",
        "stage6": "#00BCD4",
        "stage7": "#FFC107"
      }
    },
    "logos": {
      "splashLogoUrl": "/media/logos/splash.png",
      "loginLogoUrl": "/media/logos/login.png",
      "faviconUrl": "/media/logos/favicon.ico"
    },
    "font": {
      "family": "NotoSansKR",
      "source": "google"
    }
  }
}
```

### PUT /api/admin/app-theme/colors

Update theme colors (requires admin auth).

**Request Body**: JSON object with color fields (hex format)

**Example**:
```json
{
  "primary_color": "#FFEF5F",
  "secondary_color": "#4CAF50",
  "stage1_color": "#2196F3"
}
```

### POST /api/admin/app-theme/logo/upload

Upload logo file (multipart/form-data, requires admin auth).

**Form Fields**:
- `file`: Logo file (PNG, JPG, SVG)
- `logoType`: One of (splash, login, favicon)

### DELETE /api/admin/app-theme/logo/:logoType

Delete logo (requires admin auth).

**Parameters**:
- `logoType`: One of (splash, login, favicon)

### PUT /api/admin/app-theme/font

Update font settings (requires admin auth).

**Request Body**:
```json
{
  "font_family": "Roboto",
  "font_source": "google"
}
```

### POST /api/admin/app-theme/font/upload

Upload custom font file (TTF/OTF, requires admin auth).

**Form Fields**:
- `file`: Font file (TTF or OTF format)
- `font_family`: Font family name

### POST /api/admin/app-theme/reset

Reset theme to default values (requires admin auth).

**Response**: Returns default theme configuration

### GET /api/admin/app-theme/history

Get theme update history with pagination (requires admin auth).

**Query Parameters**:
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)

**Response**:
```json
{
  "success": true,
  "history": [
    {
      "id": 123,
      "updated_by": 1,
      "admin_email": "admin@example.com",
      "changes": {"primary_color": "#FFEF5F"},
      "updated_at": "2026-02-04T10:30:00Z"
    }
  ],
  "pagination": {
    "total": 45,
    "page": 1,
    "limit": 20
  }
}
```

---

## APK Build Endpoints

Admin-only endpoints for Android APK build automation.

### Start APK Build

```http
POST /api/admin/deploy/apk/start
Authorization: Bearer <admin-token>

Response:
{
  "success": true,
  "data": {
    "buildId": 1,
    "message": "APK build started successfully"
  }
}
```

### Get Build Status

```http
GET /api/admin/deploy/apk/status/:id

Response:
{
  "success": true,
  "id": 1,
  "status": "building",
  "progress": 45,
  "started_at": "2026-02-05T10:30:00Z",
  "version_name": "1.0.0",
  "version_code": 1,
  "apk_size_bytes": 25000000,
  "git_branch": "main",
  "git_commit_hash": "abc123def456...",
  "duration_seconds": 180
}
```

**Status values:** `pending`, `building`, `signing`, `completed`, `failed`, `cancelled`

### Get Build Logs

```http
GET /api/admin/deploy/apk/logs/:id?since=0

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "log_type": "info",
      "message": "Starting APK build...",
      "created_at": "2026-02-05T10:30:01Z"
    },
    {
      "id": 2,
      "log_type": "info",
      "message": "Running flutter clean...",
      "created_at": "2026-02-05T10:30:05Z"
    }
  ]
}
```

**Query Parameters:**
- `since`: Return logs with ID greater than this value (for incremental polling)

### List Build History

```http
GET /api/admin/deploy/apk/history?page=1&limit=20

Response:
{
  "success": true,
  "data": [
    {
      "id": 1,
      "admin_email": "admin@example.com",
      "status": "completed",
      "progress": 100,
      "version_name": "1.0.0",
      "version_code": 1,
      "apk_size_bytes": 25000000,
      "apk_path": "lemon_korean_20260205_103000.apk",
      "started_at": "2026-02-05T10:30:00Z",
      "completed_at": "2026-02-05T10:35:00Z",
      "duration_seconds": 300,
      "git_branch": "main",
      "git_commit_hash": "abc123def456..."
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 15,
    "totalPages": 1
  }
}
```

### Download APK

```http
GET /api/admin/deploy/apk/download/:id

Response: Binary APK file stream
Content-Type: application/vnd.android.package-archive
Content-Disposition: attachment; filename="lemon_korean_YYYYMMDD_HHMMSS.apk"
```

Downloads the compiled APK file from NAS storage.

### Cancel Build

```http
DELETE /api/admin/deploy/apk/:id

Response:
{
  "success": true,
  "message": "APK build cancelled successfully"
}
```

Cancels a running build by creating a cancel trigger file that the build script monitors.

---

## Response Format Changes

### New Localized Fields

The API now returns localized field names instead of language-specific suffixes:

| Old Field | New Field | Description |
|-----------|-----------|-------------|
| `title_zh` | `title` | Localized lesson title |
| `description_zh` | `description` | Localized description |
| `chinese` | `translation` | Localized vocabulary translation |
| `pinyin` | `pronunciation` | Localized pronunciation |
| `name_zh` | `name` | Localized grammar name |
| `chinese_comparison` | `language_comparison` | Localized comparison |

### Additional Metadata

All content responses now include:
- `content_language`: The actual language code of the returned content (useful for knowing if a fallback was used)

---

## Database Schema

### Translation Tables

New tables for multi-language content:

```sql
-- Languages reference table
CREATE TABLE languages (
  code VARCHAR(10) PRIMARY KEY,
  name_native VARCHAR(100),
  name_english VARCHAR(100),
  is_active BOOLEAN DEFAULT true
);

-- Lesson translations
CREATE TABLE lesson_translations (
  lesson_id INTEGER REFERENCES lessons(id),
  language_code VARCHAR(10) REFERENCES languages(code),
  title VARCHAR(255) NOT NULL,
  description TEXT,
  UNIQUE(lesson_id, language_code)
);

-- Vocabulary translations
CREATE TABLE vocabulary_translations (
  vocabulary_id INTEGER REFERENCES vocabulary(id),
  language_code VARCHAR(10) REFERENCES languages(code),
  translation VARCHAR(200) NOT NULL,
  pronunciation VARCHAR(200),
  example_sentence TEXT,
  UNIQUE(vocabulary_id, language_code)
);

-- Grammar translations
CREATE TABLE grammar_translations (
  grammar_id INTEGER REFERENCES grammar_rules(id),
  language_code VARCHAR(10) REFERENCES languages(code),
  name VARCHAR(255) NOT NULL,
  description TEXT,
  language_comparison TEXT,
  UNIQUE(grammar_id, language_code)
);
```

---

## Migration Guide

### For API Consumers

1. Update API calls to include `?language=` parameter
2. Update model parsing to use new field names:
   - `title` instead of `title_zh`
   - `translation` instead of `chinese`
   - `pronunciation` instead of `pinyin`
   - `name` instead of `name_zh`
3. Handle `content_language` field to detect fallbacks

### Backwards Compatibility

- Old endpoints without `?language=` still work (default: `ko` as of 2026-02-04, previously `zh`)
- Old field names in responses have been replaced with new generic names
- Legacy data in `*_zh` columns is preserved and used as fallback

---

## Error Responses

```json
{
  "success": false,
  "error": "Error message",
  "details": "Additional details (development only)"
}
```

| Status Code | Description |
|-------------|-------------|
| 400 | Bad Request - Invalid parameters |
| 401 | Unauthorized - Invalid/missing token |
| 404 | Not Found - Resource doesn't exist |
| 500 | Internal Server Error |

---

## Gamification Endpoints (2026-02-10)

Lemon reward system with lesson scoring, boss quizzes, and lemon tree.

### Progress Service Gamification (`/api/progress/`)

All endpoints require authentication.

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/progress/lesson-reward` | Save/update lesson lemon reward (1-3 lemons based on quiz score) |
| GET | `/api/progress/lemon-currency/:userId` | Get user's lemon currency balance |
| GET | `/api/progress/lesson-rewards/:userId` | Get all lesson rewards for user |
| POST | `/api/progress/lemon-harvest` | Harvest lemon from tree (after ad watched) |
| POST | `/api/progress/boss-quiz/complete` | Record boss quiz completion |

### Admin Gamification Settings (`/api/admin/gamification/`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/settings` | Public | Get current gamification settings (used by Flutter app) |
| PUT | `/ad-settings` | Admin | Update ad settings (AdMob/AdSense IDs) |
| PUT | `/lemon-settings` | Admin | Update lemon reward thresholds |
| POST | `/reset` | Admin | Reset gamification settings to defaults |

---

## SNS Service Endpoints (2026-02-10)

Community features: posts, comments, follows, profiles, reports, blocks.

### Posts (`/api/sns/posts/`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/feed` | Required | Get feed from followed users |
| GET | `/discover` | Optional | Get public posts (discover) |
| GET | `/user/:userId` | Optional | Get posts by specific user |
| GET | `/:id` | Optional | Get single post |
| POST | `/` | Required | Create new post |
| DELETE | `/:id` | Required | Delete post (soft delete) |
| POST | `/:id/like` | Required | Like a post |
| DELETE | `/:id/like` | Required | Unlike a post |

### Comments (`/api/sns/comments/`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/post/:postId` | Optional | Get comments for a post |
| POST | `/post/:postId` | Required | Create comment |
| DELETE | `/:id` | Required | Delete comment (soft delete) |

### Follows (`/api/sns/follows/`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/:userId` | Required | Follow a user |
| DELETE | `/:userId` | Required | Unfollow a user |
| GET | `/:userId/followers` | Optional | Get user's followers |
| GET | `/:userId/following` | Optional | Get user's following list |

### Profiles (`/api/sns/profiles/`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| GET | `/search` | Required | Search users by name |
| GET | `/suggested` | Required | Get suggested users |
| GET | `/:userId` | Optional | Get user profile |
| PUT | `/` | Required | Update own profile |

### Reports (`/api/sns/reports/`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/` | Required | Submit a report |

### Blocks (`/api/sns/blocks/`)

| Method | Endpoint | Auth | Description |
|--------|----------|------|-------------|
| POST | `/:userId` | Required | Block a user |
| DELETE | `/:userId` | Required | Unblock a user |

### Admin SNS Moderation (`/api/admin/sns-moderation/`)

All endpoints require admin authentication.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/reports` | Get all reports |
| PUT | `/reports/:id` | Update report status |
| GET | `/posts` | Get posts (moderation view) |
| DELETE | `/posts/:id` | Delete post |
| GET | `/users` | Get users (moderation view) |
| PUT | `/users/:id/ban` | Ban user from SNS |
| PUT | `/users/:id/unban` | Unban user |
| GET | `/stats` | Get moderation statistics |

---

## DM Conversations (`/api/sns/conversations/`) (2026-02-10)

1:1 Direct Messaging between users. All endpoints require authentication.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Get conversation list (sorted by last_message_at DESC) |
| POST | `/` | Create or retrieve conversation (body: `{ user_id }`) |
| GET | `/unread-count` | Get total unread message count |
| POST | `/:id/read` | Mark conversation as read |

### GET /api/sns/conversations/

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `limit` | int | 20 | Items per page |
| `offset` | int | 0 | Pagination offset |

**Response:**
```json
{
  "success": true,
  "conversations": [
    {
      "id": 1,
      "other_user": { "id": 5, "name": "김학생", "profile_image_url": "..." },
      "last_message_preview": "안녕하세요!",
      "last_message_at": "2026-02-10T10:30:00Z",
      "unread_count": 3
    }
  ]
}
```

### POST /api/sns/conversations/

Creates a new conversation or returns existing one between two users.

**Request Body:**
```json
{ "user_id": 5 }
```

**Response:** Conversation object with `id`, `user1_id`, `user2_id`, `created_at`.

---

## DM Messages (`/api/sns/`) (2026-02-10)

Message history and sending. All endpoints require authentication.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/conversations/:id/messages` | Get message history (cursor-based) |
| POST | `/conversations/:id/messages` | Send message (REST fallback) |
| POST | `/dm/upload` | Upload media (image/voice, max 10MB) |
| DELETE | `/messages/:id` | Delete message (sender only, soft delete) |

### GET /api/sns/conversations/:id/messages

**Query Parameters:**
| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `cursor` | int | - | Message ID cursor (returns older messages) |
| `limit` | int | 50 | Items per page (max 100) |

**Response:**
```json
{
  "success": true,
  "messages": [
    {
      "id": 42,
      "sender_id": 1,
      "sender_name": "User",
      "sender_avatar": "...",
      "message_type": "text",
      "content": "안녕하세요!",
      "media_url": null,
      "client_message_id": "uuid-...",
      "created_at": "2026-02-10T10:30:00Z"
    }
  ],
  "has_more": true
}
```

### POST /api/sns/dm/upload

Upload image or voice message media.

**Content-Type:** `multipart/form-data`

**Form Fields:**
- `file`: Media file (max 10MB, image/jpeg, image/png, audio/webm, audio/mp4)

**Response:**
```json
{
  "success": true,
  "url": "/media/dm-images/uuid-filename.jpg",
  "media_type": "image"
}
```

---

## Voice Rooms (`/api/sns/voice-rooms/`) (2026-02-10)

Voice chat rooms with LiveKit integration (max 4 participants). All endpoints require authentication.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | List active voice rooms |
| POST | `/` | Create a new voice room |
| GET | `/:id` | Get room details with participants |
| POST | `/:id/join` | Join room (returns `livekit_token`, `livekit_url`) |
| POST | `/:id/leave` | Leave room |
| DELETE | `/:id` | Close room (creator only) |
| POST | `/:id/mute` | Toggle mute status |

### POST /api/sns/voice-rooms/

**Request Body:**
```json
{
  "title": "한국어 프리토킹",
  "topic": "일상 대화 연습",
  "language_level": "beginner",
  "max_participants": 4
}
```

**`language_level` values:** `beginner`, `intermediate`, `advanced`, `all`

### POST /api/sns/voice-rooms/:id/join

**Response:**
```json
{
  "success": true,
  "livekit_token": "eyJ...",
  "livekit_url": "wss://livekit.example.com",
  "room": { "id": 1, "title": "...", "participants": [...] }
}
```

### DELETE /api/sns/voice-rooms/:id

Closes the room (creator only). Sets status to `closed` and disconnects all participants.

---

## Socket.IO Real-time Events (2026-02-10)

Real-time messaging and presence via Socket.IO.

### Connection

- **Path:** `/api/sns/socket.io`
- **Auth:** `{ token: "JWT_TOKEN" }` in handshake auth
- **Ping Timeout:** 60s
- **Ping Interval:** 25s

### Client → Server Events

| Event | Payload | Description |
|-------|---------|-------------|
| `dm:join_conversation` | `{ conversation_id }` | Join conversation room for messages |
| `dm:leave_conversation` | `{ conversation_id }` | Leave conversation room |
| `dm:send_message` | `{ conversation_id, message_type, content, media_url?, media_metadata?, client_message_id? }` | Send a message (supports ack callback) |
| `dm:typing_start` | `{ conversation_id }` | Notify typing started |
| `dm:typing_stop` | `{ conversation_id }` | Notify typing stopped |
| `dm:mark_read` | `{ conversation_id, message_id }` | Mark messages as read up to message_id |
| `voice:join_room` | `{ room_id }` | Join voice room socket for updates |
| `voice:leave_room` | `{ room_id }` | Leave voice room socket |
| `ping_alive` | _(none)_ | Heartbeat to refresh online TTL (300s) |

### Server → Client Events

| Event | Payload | Description |
|-------|---------|-------------|
| `dm:new_message` | Message object | New message in joined conversation |
| `dm:conversation_updated` | `{ conversation_id, last_message }` | Conversation update (for badge/list) |
| `dm:typing` | `{ conversation_id, user_id, is_typing }` | Typing indicator |
| `dm:read_receipt` | `{ conversation_id, user_id, last_read_message_id }` | Read receipt update |
| `dm:user_online` | `{ user_id }` | User came online |
| `dm:user_offline` | `{ user_id }` | User went offline |
| `dm:message_sent` | `{ message, client_message_id }` | Message sent confirmation (when no ack) |
| `voice:participant_joined` | `{ room_id, user }` | Participant joined voice room |
| `voice:participant_left` | `{ room_id, user_id }` | Participant left voice room |
| `voice:participant_muted` | `{ room_id, user_id, is_muted }` | Mute status changed |
| `voice:room_created` | Room object | New voice room created |
| `voice:room_closed` | `{ room_id }` | Voice room closed |

### Online Status

Online status tracked via Redis keys `dm:online:{userId}` with 300s TTL. Refreshed by `ping_alive` heartbeat.

---

## Rate Limiting

- 100 requests per minute per IP
- Authenticated users: 1000 requests per minute
- Bulk endpoints (check-updates, batch): 10 requests per minute
