# Lemon Korean Database Schema

PostgreSQL 15+ compatible schema documentation for the Lemon Korean learning platform.

## Overview

The database consists of 36+ tables organized into the following functional areas:

- **User Management**: Users, sessions, authentication
- **Lesson Content**: Lessons, vocabulary, grammar, dialogues
- **Hangul Learning**: Korean alphabet characters and practice data (6 tables)
- **Progress Tracking**: User progress, SRS (Spaced Repetition System)
- **Media Management**: Media metadata and storage references
- **Admin Tools**: Audit logs, web deployment tracking
- **Internationalization**: Multi-language content support (6 languages)
- **Gamification**: Lemon rewards, currency, boss quizzes, settings (5 tables)
- **SNS/Community**: Posts, comments, likes, follows, reports, blocks (6 tables)

---

## Core Tables

### users

User account information with subscription and language preferences.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | User ID |
| email | VARCHAR(255) | UNIQUE, NOT NULL | Email address |
| password_hash | VARCHAR(255) | NOT NULL | bcrypt hashed password |
| name | VARCHAR(100) | | Display name |
| language_preference | VARCHAR(10) | DEFAULT 'ko' | Content language (ko, en, es, ja, zh, zh_TW) |
| subscription_type | VARCHAR(20) | DEFAULT 'free' | Subscription tier (free, premium, lifetime) |
| subscription_expires_at | TIMESTAMP | | Premium expiration date |
| created_at | TIMESTAMP | DEFAULT NOW() | Account creation |
| last_login | TIMESTAMP | | Last login timestamp |
| is_active | BOOLEAN | DEFAULT true | Account status |
| email_verified | BOOLEAN | DEFAULT false | Email verification status |
| profile_image_url | TEXT | | Profile image URL |

**Indexes:**
- `idx_users_email` on email
- `idx_users_subscription` on (subscription_type, subscription_expires_at)
- `idx_users_created_at` on created_at DESC

---

### sessions

JWT session and refresh token management.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | UUID | PRIMARY KEY | Session ID |
| user_id | INTEGER | FK(users.id) | User reference |
| token | VARCHAR(500) | NOT NULL | JWT access token |
| refresh_token | VARCHAR(500) | | Refresh token |
| expires_at | TIMESTAMP | NOT NULL | Token expiration |
| device_info | JSONB | | Device metadata JSON |
| ip_address | INET | | Client IP address |
| user_agent | TEXT | | Browser user agent |
| created_at | TIMESTAMP | DEFAULT NOW() | Session start |
| last_activity | TIMESTAMP | DEFAULT NOW() | Last activity time |

**Indexes:**
- `idx_sessions_user_id` on user_id
- `idx_sessions_token` on token
- `idx_sessions_refresh_token` on refresh_token
- `idx_sessions_expires_at` on expires_at

---

## Lesson Content Tables

### lessons

Lesson metadata with multi-language support.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Lesson ID |
| level | INTEGER | NOT NULL, CHECK (1-6) | TOPIK level |
| week | INTEGER | NOT NULL, CHECK (>= 1) | Week number |
| order_num | INTEGER | NOT NULL | Display order |
| title_ko | VARCHAR(255) | NOT NULL | Korean title |
| title_zh | VARCHAR(255) | NOT NULL | Chinese title (deprecated) |
| description_ko | TEXT | | Korean description |
| description_zh | TEXT | | Chinese description (deprecated) |
| duration_minutes | INTEGER | DEFAULT 30 | Estimated duration |
| difficulty | VARCHAR(20) | | Difficulty level |
| thumbnail_url | TEXT | | Thumbnail image URL |
| version | VARCHAR(20) | DEFAULT '1.0.0' | Content version |
| status | VARCHAR(20) | DEFAULT 'draft' | Lesson status (draft, published, archived) |
| published_at | TIMESTAMP | | Publication date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| prerequisites | INTEGER[] | DEFAULT ARRAY[] | Prerequisite lesson IDs |
| tags | TEXT[] | DEFAULT ARRAY[] | Search tags |
| view_count | INTEGER | DEFAULT 0 | View counter |
| completion_count | INTEGER | DEFAULT 0 | Completion counter |

**Note:** `title_zh` and `description_zh` columns are deprecated. Use `lesson_translations` table for multi-language content.

**Indexes:**
- `idx_lessons_level` on level
- `idx_lessons_status` on status
- `idx_lessons_order` on (level, week, order_num)
- `idx_lessons_published` on published_at DESC
- Full-text search index on title_ko, title_zh

---

### lesson_translations

Multi-language lesson content (replaces deprecated _zh columns).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Translation ID |
| lesson_id | INTEGER | FK(lessons.id) | Lesson reference |
| language_code | VARCHAR(10) | NOT NULL | Language (ko, en, es, ja, zh, zh_TW) |
| title | VARCHAR(255) | NOT NULL | Localized title |
| description | TEXT | | Localized description |
| objectives | JSONB | DEFAULT '[]' | Learning objectives array |
| cultural_notes | TEXT | | Cultural context notes |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(lesson_id, language_code) | | | One translation per language |

**Indexes:**
- `idx_lesson_translations_lesson` on lesson_id
- `idx_lesson_translations_language` on language_code
- `idx_lesson_translations_lookup` on (lesson_id, language_code)

---

### vocabulary

Vocabulary words with multi-language translations.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Vocabulary ID |
| korean_word | VARCHAR(100) | NOT NULL | Korean word |
| hanja | VARCHAR(100) | | Chinese characters (if applicable) |
| romanization | VARCHAR(100) | NOT NULL | Romanization (usually Revised) |
| part_of_speech | VARCHAR(30) | NOT NULL | POS (noun, verb, etc.) |
| topik_level | INTEGER | CHECK (0-6) | TOPIK level (0 = beginner) |
| audio_url | TEXT | | Audio file URL |
| image_url | TEXT | | Illustrative image URL |
| difficulty_score | DECIMAL(3,2) | DEFAULT 0 | Difficulty (0-5) |
| frequency_rank | INTEGER | | Usage frequency rank |
| example_sentences | JSONB | DEFAULT '[]' | Example sentences |
| synonyms | JSONB | DEFAULT '[]' | Synonym IDs |
| antonyms | JSONB | DEFAULT '[]' | Antonym IDs |
| related_words | JSONB | DEFAULT '[]' | Related word IDs |
| word_family | VARCHAR(50) | | Word family/root |
| usage_notes_ko | TEXT | | Korean usage notes |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |

**Indexes:**
- `idx_vocabulary_korean` on korean_word
- `idx_vocabulary_level` on topik_level
- `idx_vocabulary_pos` on part_of_speech
- `idx_vocabulary_frequency` on frequency_rank
- Full-text search index on korean_word

---

### vocabulary_translations

Multi-language vocabulary translations.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Translation ID |
| vocabulary_id | INTEGER | FK(vocabulary.id) | Vocabulary reference |
| language_code | VARCHAR(10) | NOT NULL | Language code |
| translation | VARCHAR(255) | NOT NULL | Translated word |
| definition | TEXT | | Full definition |
| example_sentence | TEXT | | Example in target language |
| usage_notes | TEXT | | Usage notes in target language |
| mnemonic | TEXT | | Memory aid |
| similarity_explanation | TEXT | | Similarity to native language |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(vocabulary_id, language_code) | | | One translation per language |

**Indexes:**
- `idx_vocab_translations_vocab` on vocabulary_id
- `idx_vocab_translations_language` on language_code
- Full-text search on translation field

---

### grammar_points

Grammar rules and patterns.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Grammar ID |
| pattern_korean | VARCHAR(255) | NOT NULL | Korean pattern |
| pattern_romanized | VARCHAR(255) | NOT NULL | Romanized pattern |
| topik_level | INTEGER | CHECK (0-6) | TOPIK level |
| category | VARCHAR(50) | | Grammar category |
| difficulty_score | DECIMAL(3,2) | DEFAULT 0 | Difficulty (0-5) |
| formality_level | VARCHAR(20) | | Formality (formal, informal, casual) |
| audio_url | TEXT | | Audio example URL |
| related_grammar_ids | JSONB | DEFAULT '[]' | Related grammar IDs |
| prerequisites | JSONB | DEFAULT '[]' | Prerequisite grammar IDs |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |

**Indexes:**
- `idx_grammar_level` on topik_level
- `idx_grammar_category` on category

---

### grammar_translations

Multi-language grammar explanations.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Translation ID |
| grammar_id | INTEGER | FK(grammar_points.id) | Grammar reference |
| language_code | VARCHAR(10) | NOT NULL | Language code |
| explanation | TEXT | NOT NULL | Full explanation |
| usage_notes | TEXT | | Usage guidelines |
| examples | JSONB | DEFAULT '[]' | Example sentences |
| common_mistakes | TEXT | | Common errors to avoid |
| comparison_to_native | TEXT | | Comparison to learner's language |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(grammar_id, language_code) | | | One translation per language |

**Indexes:**
- `idx_grammar_translations_grammar` on grammar_id
- `idx_grammar_translations_language` on language_code

---

## Hangul Learning Tables

### hangul_characters

Korean alphabet characters (자모) with pronunciation data.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Character ID |
| character | VARCHAR(10) | NOT NULL | Hangul character (ㄱ, ㅏ, etc.) |
| character_type | VARCHAR(20) | NOT NULL | Type (see below) |
| romanization | VARCHAR(50) | NOT NULL | Romanization |
| pronunciation_zh | VARCHAR(100) | NOT NULL | Chinese pronunciation description |
| pronunciation_tip_zh | TEXT | | Chinese pronunciation tips |
| stroke_count | INTEGER | DEFAULT 1 | Number of strokes |
| stroke_order_url | TEXT | | Stroke order animation URL |
| audio_url | TEXT | | Audio pronunciation URL |
| display_order | INTEGER | NOT NULL | UI display order |
| example_words | JSONB | DEFAULT '[]' | Example words JSON |
| mnemonics_zh | TEXT | | Memory aids in Chinese |
| status | VARCHAR(20) | DEFAULT 'published' | Status (draft, published, archived) |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |

**Character Types:**
- `basic_consonant` - Basic consonants (ㄱ, ㄴ, ㄷ, etc.)
- `double_consonant` - Double/tense consonants (ㄲ, ㄸ, ㅃ, etc.)
- `basic_vowel` - Basic vowels (ㅏ, ㅓ, ㅗ, etc.)
- `compound_vowel` - Compound vowels (ㅐ, ㅔ, ㅘ, etc.)
- `final_consonant` - Final consonants (받침)

**Indexes:**
- `idx_hangul_characters_type` on character_type
- `idx_hangul_characters_order` on (character_type, display_order)
- `idx_hangul_characters_status` on status
- `idx_hangul_characters_unique` on (character, character_type) UNIQUE

---

### hangul_pronunciation_guides

Enhanced pronunciation visualizations (mouth shapes, tongue positions).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| character_id | INTEGER | PRIMARY KEY, FK(hangul_characters.id) | Character reference |
| mouth_shape_url | TEXT | | Mouth shape diagram URL |
| tongue_position_url | TEXT | | Tongue position diagram URL |
| air_flow_description | JSONB | DEFAULT '{}' | Airflow type/description JSON |
| native_comparisons | JSONB | DEFAULT '{}' | Native language comparisons JSON |
| similar_character_ids | INTEGER[] | | Similar-sounding character IDs |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |

**JSONB Structures:**
- `air_flow_description`: `{type, description_zh, description_ko, description_en}`
- `native_comparisons`: `{zh: {comparison, tip}, en: {...}, ja: {...}, es: {...}}`

---

### hangul_syllables

Syllable combinations (음절) for practice.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Syllable ID |
| syllable | VARCHAR(10) | NOT NULL, UNIQUE | Syllable (가, 나, 다, etc.) |
| initial_consonant_id | INTEGER | FK(hangul_characters.id) | Initial consonant (초성) |
| vowel_id | INTEGER | FK(hangul_characters.id) | Vowel (중성) |
| final_consonant_id | INTEGER | FK(hangul_characters.id), NULLABLE | Final consonant (종성/받침) |
| audio_url | TEXT | | Audio pronunciation URL |
| example_word | VARCHAR(50) | | Example Korean word |
| example_word_meanings | JSONB | DEFAULT '{}' | Translations JSON |
| frequency_rank | INTEGER | | Usage frequency rank |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |

**Indexes:**
- `idx_hangul_syllables_initial` on initial_consonant_id
- `idx_hangul_syllables_vowel` on vowel_id
- `idx_hangul_syllables_final` on final_consonant_id
- `idx_hangul_syllables_frequency` on frequency_rank

---

### hangul_similar_sound_groups

Groups of similar-sounding characters for discrimination training.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Group ID |
| group_name | VARCHAR(50) | NOT NULL | Group name (ㄱ/ㅋ/ㄲ) |
| group_name_ko | VARCHAR(50) | NOT NULL | Korean group name |
| description | TEXT | | English description |
| description_ko | TEXT | | Korean description |
| category | VARCHAR(20) | NOT NULL | consonant or vowel |
| character_ids | INTEGER[] | NOT NULL | Character IDs in group |
| difficulty_level | INTEGER | DEFAULT 1, CHECK (1-5) | Difficulty level |
| practice_count | INTEGER | DEFAULT 0 | Practice count |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |

**Examples:**
- ㄱ/ㅋ/ㄲ (plain/aspirated/tense velar stops)
- ㅓ/ㅗ (unrounded vs rounded mid vowels)
- ㅐ/ㅔ (similar front mid vowels)

---

### hangul_progress

User progress for hangul characters (SRS-based).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Progress ID |
| user_id | INTEGER | FK(users.id) | User reference |
| character_id | INTEGER | FK(hangul_characters.id) | Character reference |
| mastery_level | INTEGER | DEFAULT 0, CHECK (0-5) | Mastery level |
| correct_count | INTEGER | DEFAULT 0 | Correct answer count |
| wrong_count | INTEGER | DEFAULT 0 | Wrong answer count |
| streak_count | INTEGER | DEFAULT 0 | Current correct streak |
| last_practiced | TIMESTAMP | | Last practice time |
| next_review | TIMESTAMP | | Next SRS review time |
| ease_factor | DECIMAL(3,2) | DEFAULT 2.50 | SM-2 algorithm ease factor |
| interval_days | INTEGER | DEFAULT 1 | Days until next review |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(user_id, character_id) | | | One record per user-character |

**Indexes:**
- `idx_hangul_progress_user` on user_id
- `idx_hangul_progress_character` on character_id
- `idx_hangul_progress_mastery` on mastery_level
- `idx_hangul_progress_next_review` on next_review
- `idx_hangul_progress_user_review` on (user_id, next_review)

---

### hangul_writing_progress

Writing practice progress tracking.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Progress ID |
| user_id | INTEGER | FK(users.id) | User reference |
| character_id | INTEGER | FK(hangul_characters.id) | Character reference |
| total_attempts | INTEGER | DEFAULT 0 | Total writing attempts |
| successful_attempts | INTEGER | DEFAULT 0 | Successful attempts |
| average_accuracy | DECIMAL(5,2) | DEFAULT 0 | Average accuracy % |
| best_accuracy | DECIMAL(5,2) | DEFAULT 0 | Best accuracy % |
| last_practiced | TIMESTAMP | | Last practice time |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(user_id, character_id) | | | One record per user-character |

**Indexes:**
- `idx_hangul_writing_progress_user` on user_id
- `idx_hangul_writing_progress_character` on character_id

---

### hangul_discrimination_progress

Sound discrimination training progress.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Progress ID |
| user_id | INTEGER | FK(users.id) | User reference |
| group_id | INTEGER | FK(hangul_similar_sound_groups.id) | Sound group reference |
| total_attempts | INTEGER | DEFAULT 0 | Total attempts |
| correct_attempts | INTEGER | DEFAULT 0 | Correct attempts |
| accuracy_percent | DECIMAL(5,2) | DEFAULT 0 | Accuracy % |
| best_streak | INTEGER | DEFAULT 0 | Best correct streak |
| last_practiced | TIMESTAMP | | Last practice time |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(user_id, group_id) | | | One record per user-group |

**Indexes:**
- `idx_hangul_disc_progress_user` on user_id
- `idx_hangul_disc_progress_group` on group_id

---

### hangul_pronunciation_attempts

Pronunciation recording history (shadowing practice).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Attempt ID |
| user_id | INTEGER | FK(users.id) | User reference |
| character_id | INTEGER | FK(hangul_characters.id) | Character reference |
| recording_url | TEXT | | Recording file URL (optional) |
| self_rating | VARCHAR(20) | | Self-assessment (accurate, almost, needs_practice) |
| created_at | TIMESTAMP | DEFAULT NOW() | Recording timestamp |

**Indexes:**
- `idx_hangul_pronunciation_user` on user_id
- `idx_hangul_pronunciation_character` on character_id
- `idx_hangul_pronunciation_date` on created_at

---

## Progress Tracking Tables

### user_progress

Lesson completion and progress tracking.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Progress ID |
| user_id | INTEGER | FK(users.id) | User reference |
| lesson_id | INTEGER | FK(lessons.id) | Lesson reference |
| status | VARCHAR(20) | DEFAULT 'not_started' | Status (not_started, in_progress, completed) |
| current_stage | INTEGER | DEFAULT 1 | Current stage number (1-7) |
| completed_stages | INTEGER[] | DEFAULT ARRAY[] | Completed stage numbers |
| accuracy_percent | DECIMAL(5,2) | DEFAULT 0 | Overall accuracy % |
| time_spent_minutes | INTEGER | DEFAULT 0 | Time spent in minutes |
| last_accessed | TIMESTAMP | | Last access time |
| completed_at | TIMESTAMP | | Completion timestamp |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(user_id, lesson_id) | | | One progress per user-lesson |

**Indexes:**
- `idx_user_progress_user` on user_id
- `idx_user_progress_lesson` on lesson_id
- `idx_user_progress_status` on status
- `idx_user_progress_updated` on updated_at DESC

---

### vocabulary_progress

Vocabulary SRS (Spaced Repetition System) progress.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Progress ID |
| user_id | INTEGER | FK(users.id) | User reference |
| vocabulary_id | INTEGER | FK(vocabulary.id) | Vocabulary reference |
| mastery_level | INTEGER | DEFAULT 0, CHECK (0-5) | Mastery level (0-5) |
| correct_count | INTEGER | DEFAULT 0 | Correct answers |
| wrong_count | INTEGER | DEFAULT 0 | Wrong answers |
| streak_count | INTEGER | DEFAULT 0 | Current streak |
| last_practiced | TIMESTAMP | | Last practice time |
| next_review | TIMESTAMP | | Next SRS review time |
| ease_factor | DECIMAL(3,2) | DEFAULT 2.50 | SM-2 ease factor |
| interval_days | INTEGER | DEFAULT 1 | Review interval in days |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation date |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update |
| UNIQUE(user_id, vocabulary_id) | | | One record per user-vocabulary |

**Indexes:**
- `idx_vocab_progress_user` on user_id
- `idx_vocab_progress_vocab` on vocabulary_id
- `idx_vocab_progress_next_review` on next_review
- `idx_vocab_progress_user_review` on (user_id, next_review)

---

## Admin & Deployment Tables

### web_deployments

Web app deployment history and status tracking.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Deployment ID |
| admin_id | INTEGER | FK(users.id) | Admin who triggered |
| admin_email | VARCHAR(255) | NOT NULL | Admin email |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'pending' | Deployment status (see below) |
| progress | INTEGER | DEFAULT 0, CHECK (0-100) | Progress percentage |
| started_at | TIMESTAMP | DEFAULT NOW() | Start time |
| completed_at | TIMESTAMP | | Completion time |
| duration_seconds | INTEGER | | Total duration in seconds |
| error_message | TEXT | | Error message if failed |
| git_commit_hash | VARCHAR(40) | | Git commit SHA |
| git_branch | VARCHAR(100) | | Git branch name |
| deployment_url | TEXT | DEFAULT 'https://lemon.3chan.kr/app/' | Deployed app URL |
| created_at | TIMESTAMP | DEFAULT NOW() | Record creation |

**Status Values:**
- `pending` - Queued, not started
- `building` - Running flutter build web
- `syncing` - Copying files to nginx directory
- `restarting` - Restarting nginx
- `validating` - Health check validation
- `completed` - Successfully deployed
- `failed` - Deployment failed
- `cancelled` - Manually cancelled

**Indexes:**
- `idx_web_deployments_admin_id` on admin_id
- `idx_web_deployments_status` on status
- `idx_web_deployments_started_at` on started_at DESC

---

### web_deployment_logs

Real-time deployment logs with timestamps.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Log ID |
| deployment_id | INTEGER | FK(web_deployments.id) | Deployment reference |
| log_type | VARCHAR(20) | DEFAULT 'info' | Log level (info, error, warning) |
| message | TEXT | NOT NULL | Log message |
| created_at | TIMESTAMP | DEFAULT NOW() | Log timestamp |

**Indexes:**
- `idx_deployment_logs_deployment_id` on (deployment_id, created_at)

---

### audit_logs

Admin action audit trail.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Log ID |
| user_id | INTEGER | FK(users.id) | Admin user ID |
| action | VARCHAR(100) | NOT NULL | Action performed |
| resource_type | VARCHAR(50) | | Resource type (lesson, vocabulary, etc.) |
| resource_id | INTEGER | | Resource ID |
| changes | JSONB | | JSON of changes made |
| ip_address | INET | | Client IP |
| user_agent | TEXT | | Browser user agent |
| created_at | TIMESTAMP | DEFAULT NOW() | Action timestamp |

**Indexes:**
- `idx_audit_logs_user` on user_id
- `idx_audit_logs_resource` on (resource_type, resource_id)
- `idx_audit_logs_created` on created_at DESC

---

## Views

### user_hangul_stats

Aggregated hangul learning statistics per user.

```sql
SELECT
    u.id AS user_id,
    u.email,
    COUNT(DISTINCT hp.character_id) FILTER (WHERE hp.mastery_level >= 1) AS characters_learned,
    COUNT(DISTINCT hp.character_id) FILTER (WHERE hp.mastery_level >= 3) AS characters_mastered,
    COUNT(DISTINCT hp.character_id) FILTER (WHERE hp.mastery_level = 5) AS characters_perfected,
    SUM(hp.correct_count) AS total_correct,
    SUM(hp.wrong_count) AS total_wrong,
    ROUND(100.0 * SUM(hp.correct_count) / NULLIF(SUM(hp.correct_count) + SUM(hp.wrong_count), 0), 2) AS accuracy_percent,
    MAX(hp.last_practiced) AS last_practice_date
FROM users u
LEFT JOIN hangul_progress hp ON u.id = hp.user_id
GROUP BY u.id, u.email;
```

---

## Indexes Summary

### Performance Indexes
- All foreign keys have indexes
- Timestamp columns used for filtering have DESC indexes
- Multi-column composite indexes for common queries
- Full-text search indexes on searchable text fields (lessons, vocabulary)

### Unique Constraints
- User-specific progress tables: UNIQUE(user_id, resource_id)
- Translation tables: UNIQUE(resource_id, language_code)
- Hangul characters: UNIQUE(character, character_type)

---

## Triggers

All tables with `updated_at` columns have automatic update triggers:

```sql
CREATE TRIGGER update_<table>_updated_at
    BEFORE UPDATE ON <table>
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

Applies to: lessons, vocabulary, grammar, hangul_characters, hangul_progress, and all translation tables.

---

## JSONB Field Structures

### vocabulary.example_sentences
```json
[
  {
    "sentence_ko": "저는 학생입니다.",
    "sentence_translation": "I am a student.",
    "romanization": "Jeoneun haksaengimnida."
  }
]
```

### hangul_pronunciation_guides.native_comparisons
```json
{
  "zh": {
    "comparison": "类似汉语拼音的 g",
    "tip": "发音时比汉语的 g 更轻"
  },
  "en": {
    "comparison": "Like 'g' in 'go' but softer",
    "tip": "Less aspiration than English 'k'"
  },
  "ja": {
    "comparison": "日本語の「か」に近い",
    "tip": "もっと弱く発音する"
  },
  "es": {
    "comparison": "Como la 'g' en 'gato'",
    "tip": "Más suave que en español"
  }
}
```

### hangul_syllables.example_word_meanings
```json
{
  "ko": "나는 학생입니다",
  "zh": "我是学生",
  "en": "I am a student",
  "ja": "私は学生です",
  "es": "Soy estudiante"
}
```

---

### app_theme_settings

System-wide Flutter app theme configuration (single-row table, id=1).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Theme ID (always 1) |
| primary_color | VARCHAR(7) | DEFAULT '#FFEF5F' | Brand primary color (hex) |
| secondary_color | VARCHAR(7) | DEFAULT '#4CAF50' | Brand secondary color |
| accent_color | VARCHAR(7) | DEFAULT '#FF9800' | Brand accent color |
| error_color | VARCHAR(7) | DEFAULT '#F44336' | Error state color |
| success_color | VARCHAR(7) | DEFAULT '#4CAF50' | Success state color |
| warning_color | VARCHAR(7) | DEFAULT '#FF9800' | Warning state color |
| info_color | VARCHAR(7) | DEFAULT '#2196F3' | Info state color |
| text_primary | VARCHAR(7) | DEFAULT '#212121' | Primary text color |
| text_secondary | VARCHAR(7) | DEFAULT '#757575' | Secondary text color |
| text_hint | VARCHAR(7) | DEFAULT '#BDBDBD' | Hint text color |
| background_light | VARCHAR(7) | DEFAULT '#FAFAFA' | Light background |
| background_dark | VARCHAR(7) | DEFAULT '#303030' | Dark background |
| card_background | VARCHAR(7) | DEFAULT '#FFFFFF' | Card background |
| stage1_color | VARCHAR(7) | DEFAULT '#2196F3' | Lesson stage 1 color |
| stage2_color | VARCHAR(7) | DEFAULT '#4CAF50' | Lesson stage 2 color |
| stage3_color | VARCHAR(7) | DEFAULT '#FF9800' | Lesson stage 3 color |
| stage4_color | VARCHAR(7) | DEFAULT '#9C27B0' | Lesson stage 4 color |
| stage5_color | VARCHAR(7) | DEFAULT '#F44336' | Lesson stage 5 color |
| stage6_color | VARCHAR(7) | DEFAULT '#00BCD4' | Lesson stage 6 color |
| stage7_color | VARCHAR(7) | DEFAULT '#FFC107' | Lesson stage 7 color |
| splash_logo_key | TEXT | NULLABLE | MinIO key for splash logo |
| splash_logo_url | TEXT | NULLABLE | URL for splash logo |
| login_logo_key | TEXT | NULLABLE | MinIO key for login logo |
| login_logo_url | TEXT | NULLABLE | URL for login logo |
| favicon_key | TEXT | NULLABLE | MinIO key for favicon |
| favicon_url | TEXT | NULLABLE | URL for favicon |
| font_family | VARCHAR(100) | DEFAULT 'NotoSansKR' | Font family name |
| font_source | VARCHAR(20) | DEFAULT 'google' | Font source (google/custom/system) |
| custom_font_key | TEXT | NULLABLE | MinIO key for custom font |
| custom_font_url | TEXT | NULLABLE | URL for custom font |
| version | INTEGER | DEFAULT 1 | Version for cache invalidation |
| updated_by | INTEGER | FK(users.id) | Admin who last updated |
| updated_at | TIMESTAMP | DEFAULT NOW() | Last update time |
| created_at | TIMESTAMP | DEFAULT NOW() | Creation time |

**Indexes**: `idx_app_theme_settings_updated_at` on updated_at DESC

**Constraints**:
- `valid_hex_colors` - All color columns must be valid hex (#RRGGBB)
- `valid_font_source` - font_source must be one of (google, custom, system)

---

---

## Migration 007: APK Build Tracking (2026-02-05)

### apk_builds

Android APK build history and status tracking.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Build ID |
| admin_id | INTEGER | NOT NULL, FK to users(id) | Admin who triggered build |
| admin_email | VARCHAR(255) | NOT NULL | Admin email |
| status | VARCHAR(20) | NOT NULL, DEFAULT 'pending' | Build status (see below) |
| progress | INTEGER | DEFAULT 0, CHECK (0-100) | Build progress percentage |
| version_name | VARCHAR(20) | | App version name |
| version_code | INTEGER | | App version code |
| apk_size_bytes | BIGINT | | APK file size in bytes |
| apk_path | TEXT | | APK filename (relative to NAS storage) |
| started_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Build start time |
| completed_at | TIMESTAMP | | Build completion time |
| duration_seconds | INTEGER | | Build duration |
| error_message | TEXT | | Error message if failed |
| git_commit_hash | VARCHAR(40) | | Git commit hash |
| git_branch | VARCHAR(100) | | Git branch |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Record creation time |

**Status Values:**
- `pending` - Queued, not started
- `building` - Running flutter build apk
- `signing` - Signing APK
- `completed` - Successfully built
- `failed` - Build failed
- `cancelled` - Manually cancelled

**Indexes:**
- `idx_apk_builds_admin_id` on `admin_id`
- `idx_apk_builds_status` on `status`
- `idx_apk_builds_started_at` on `started_at DESC`

---

### apk_build_logs

Real-time APK build logs with timestamps.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Log entry ID |
| build_id | INTEGER | NOT NULL, FK to apk_builds(id) CASCADE | Build reference |
| log_type | VARCHAR(20) | DEFAULT 'info', CHECK (info/error/warning) | Log type |
| message | TEXT | NOT NULL | Log message |
| created_at | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Log timestamp |

**Indexes:**
- `idx_apk_build_logs_build_id` on `(build_id, created_at)`

---

## Gamification Tables (Migration 008-009)

### lesson_rewards

Per-user, per-lesson lemon reward tracking (1-3 lemons based on quiz score).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Reward ID |
| user_id | INTEGER | NOT NULL, FK(users.id) CASCADE | User reference |
| lesson_id | INTEGER | NOT NULL, FK(lessons.id) CASCADE | Lesson reference |
| lemons_earned | INTEGER | DEFAULT 0, CHECK (0-3) | Lemons earned (0-3) |
| best_quiz_score | INTEGER | CHECK (0-100) | Best quiz score |
| earned_at | TIMESTAMPTZ | DEFAULT NOW() | First earned time |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Last update |
| UNIQUE(user_id, lesson_id) | | | One reward per user-lesson |

---

### lemon_currency

Per-user lemon balance and tree state.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| user_id | INTEGER | PRIMARY KEY, FK(users.id) CASCADE | User reference |
| total_lemons | INTEGER | DEFAULT 0 | Total lemons earned |
| tree_lemons_available | INTEGER | DEFAULT 0 | Lemons available on tree |
| tree_lemons_harvested | INTEGER | DEFAULT 0 | Lemons harvested from tree |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Last update |

---

### lemon_transactions

Lemon earning history.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Transaction ID |
| user_id | INTEGER | NOT NULL, FK(users.id) CASCADE | User reference |
| amount | INTEGER | NOT NULL | Lemon amount |
| type | VARCHAR(20) | NOT NULL, CHECK (lesson/boss/harvest/bonus) | Transaction type |
| source_id | INTEGER | | Source lesson_id or boss quiz ID |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Transaction time |

---

### boss_quiz_completions

Boss quiz completion tracking (one per user per level-week).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Completion ID |
| user_id | INTEGER | NOT NULL, FK(users.id) CASCADE | User reference |
| level | INTEGER | NOT NULL | TOPIK level |
| week | INTEGER | NOT NULL | Week number |
| score | INTEGER | | Quiz score |
| bonus_lemons | INTEGER | DEFAULT 5 | Bonus lemons earned |
| completed_at | TIMESTAMPTZ | DEFAULT NOW() | Completion time |
| UNIQUE(user_id, level, week) | | | One per user-level-week |

---

### gamification_settings

Global gamification settings (single-row table, id=1).

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | INTEGER | PRIMARY KEY, CHECK (id=1) | Settings ID (always 1) |
| admob_app_id | VARCHAR(100) | DEFAULT test ID | AdMob app ID |
| admob_rewarded_ad_id | VARCHAR(100) | DEFAULT test ID | AdMob rewarded ad unit ID |
| adsense_publisher_id | VARCHAR(100) | DEFAULT '' | AdSense publisher ID |
| adsense_ad_slot | VARCHAR(100) | DEFAULT '' | AdSense ad slot |
| ads_enabled | BOOLEAN | DEFAULT true | Enable ads globally |
| web_ads_enabled | BOOLEAN | DEFAULT false | Enable web ads |
| lemon_3_threshold | INTEGER | DEFAULT 95 | Score for 3 lemons |
| lemon_2_threshold | INTEGER | DEFAULT 80 | Score for 2 lemons |
| boss_quiz_bonus | INTEGER | DEFAULT 5 | Boss quiz bonus lemons |
| boss_quiz_pass_percent | INTEGER | DEFAULT 70 | Boss quiz pass threshold % |
| max_tree_lemons | INTEGER | DEFAULT 10 | Max lemons on tree |
| version | INTEGER | DEFAULT 1 | Version for cache |
| updated_by | INTEGER | | Admin who last updated |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Last update |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Creation time |

---

## SNS/Community Tables (Migration 010)

### users (extended columns)

Additional columns added to existing users table:

| Column | Type | Default | Description |
|--------|------|---------|-------------|
| bio | TEXT | | User bio |
| follower_count | INTEGER | 0 | Follower count |
| following_count | INTEGER | 0 | Following count |
| post_count | INTEGER | 0 | Post count |
| is_public | BOOLEAN | true | Public profile |
| sns_banned | BOOLEAN | false | SNS ban status |

---

### user_follows

Instagram-style 1-directional follows.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Follow ID |
| follower_id | INTEGER | NOT NULL, FK(users.id) CASCADE | Follower |
| following_id | INTEGER | NOT NULL, FK(users.id) CASCADE | Following |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Follow time |
| UNIQUE(follower_id, following_id) | | | No duplicate follows |
| CHECK(follower_id != following_id) | | | No self-follow |

---

### sns_posts

Community posts with categories and image support.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Post ID |
| user_id | INTEGER | NOT NULL, FK(users.id) CASCADE | Author |
| content | TEXT | NOT NULL | Post content |
| category | VARCHAR(20) | DEFAULT 'general', CHECK (learning/general) | Category |
| tags | TEXT[] | DEFAULT '{}' | Tags array |
| visibility | VARCHAR(20) | DEFAULT 'public', CHECK (public/followers) | Visibility |
| image_urls | TEXT[] | DEFAULT '{}' | Image URLs |
| like_count | INTEGER | DEFAULT 0 | Like count |
| comment_count | INTEGER | DEFAULT 0 | Comment count |
| is_deleted | BOOLEAN | DEFAULT false | Soft delete flag |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Creation time |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Last update |

---

### post_likes

Post like tracking.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Like ID |
| post_id | INTEGER | NOT NULL, FK(sns_posts.id) CASCADE | Post reference |
| user_id | INTEGER | NOT NULL, FK(users.id) CASCADE | User who liked |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Like time |
| UNIQUE(post_id, user_id) | | | One like per user-post |

---

### sns_comments

Post comments with nested reply support.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Comment ID |
| post_id | INTEGER | NOT NULL, FK(sns_posts.id) CASCADE | Post reference |
| user_id | INTEGER | NOT NULL, FK(users.id) CASCADE | Author |
| parent_id | INTEGER | FK(sns_comments.id) CASCADE | Parent comment (for replies) |
| content | TEXT | NOT NULL | Comment content |
| is_deleted | BOOLEAN | DEFAULT false | Soft delete flag |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Creation time |

---

### sns_reports

Report system for posts, comments, and users.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Report ID |
| reporter_id | INTEGER | NOT NULL, FK(users.id) CASCADE | Reporter |
| target_type | VARCHAR(20) | NOT NULL, CHECK (post/comment/user) | Target type |
| target_id | INTEGER | NOT NULL | Target ID |
| reason | TEXT | NOT NULL | Report reason |
| status | VARCHAR(20) | DEFAULT 'pending', CHECK (pending/reviewed/resolved/dismissed) | Status |
| admin_notes | TEXT | | Admin notes |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Report time |
| updated_at | TIMESTAMPTZ | DEFAULT NOW() | Last update |

---

### user_blocks

User blocking.

| Column | Type | Constraints | Description |
|--------|------|-------------|-------------|
| id | SERIAL | PRIMARY KEY | Block ID |
| blocker_id | INTEGER | NOT NULL, FK(users.id) CASCADE | Blocker |
| blocked_id | INTEGER | NOT NULL, FK(users.id) CASCADE | Blocked user |
| created_at | TIMESTAMPTZ | DEFAULT NOW() | Block time |
| UNIQUE(blocker_id, blocked_id) | | | No duplicate blocks |
| CHECK(blocker_id != blocked_id) | | | No self-block |

---

## Migration History

| Version | Date | Description |
|---------|------|-------------|
| 001 | 2026-01-20 | Add translation tables for i18n |
| 002 | 2026-02-03 | Add pronunciation guides, syllables, and discrimination tables |
| 003 | 2026-02-04 | Add web deployment tracking tables |
| 004 | 2026-02-04 | Update language defaults from Chinese to Korean |
| 005 | 2026-02-04 | Add app_theme_settings table |
| 006 | 2026-02-05 | Remove design_settings table (admin dashboard only) |
| 007 | 2026-02-05 | Add APK build tracking tables |
| 008 | 2026-02-10 | Add gamification tables (lesson_rewards, lemon_currency, lemon_transactions, boss_quiz_completions) |
| 009 | 2026-02-10 | Add gamification_settings table |
| 010 | 2026-02-10 | Add SNS tables (user_follows, sns_posts, post_likes, sns_comments, sns_reports, user_blocks) |

---

## Backup and Maintenance

### Recommended Indexes Rebuild
```sql
REINDEX DATABASE lemonkorean;
```

### Vacuum for Performance
```sql
VACUUM ANALYZE;
```

### Check Table Sizes
```sql
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

---

## See Also

- `/docs/API.md` - API endpoint documentation
- `/database/postgres/init/` - Schema initialization SQL files
- `/database/postgres/migrations/` - Schema migration files
- `/scripts/backup/` - Database backup scripts

---

**Last Updated:** 2026-02-10
