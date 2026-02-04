# Lemon Korean API Documentation

## Overview

The Lemon Korean API provides endpoints for managing lessons, vocabulary, grammar, and user progress. All content endpoints support multi-language content via the `?language=` query parameter.

## Base URLs

| Service | Port | Base URL |
|---------|------|----------|
| Auth | 3001 | `/api/auth` |
| Content | 3002 | `/api/content` |
| Progress | 3003 | `/api/progress` |
| Media | 3004 | `/media` |
| Analytics | 3005 | `/api/analytics` |
| Admin | 3006 | `/api/admin` |

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

## Rate Limiting

- 100 requests per minute per IP
- Authenticated users: 1000 requests per minute
- Bulk endpoints (check-updates, batch): 10 requests per minute
