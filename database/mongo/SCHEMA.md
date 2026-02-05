# MongoDB 스키마 문서 (MongoDB Schema Documentation)

> **마지막 업데이트**: 2026-02-05
> **MongoDB 버전**: 4.4
> **데이터베이스 이름**: `lemonkorean`

---

## 📑 목차 (Table of Contents)

1. [개요 (Overview)](#개요-overview)
2. [컬렉션 목록 (Collections List)](#컬렉션-목록-collections-list)
3. [컬렉션 상세 (Collection Details)](#컬렉션-상세-collection-details)
4. [인덱스 (Indexes)](#인덱스-indexes)
5. [데이터 관계 (Data Relationships)](#데이터-관계-data-relationships)
6. [백업 및 복구 (Backup & Restore)](#백업-및-복구-backup--restore)
7. [성능 최적화 (Performance Optimization)](#성능-최적화-performance-optimization)

---

## 개요 (Overview)

### 아키텍처 설계 원칙

**하이브리드 데이터베이스 전략**:
- **PostgreSQL**: 구조화된 메타데이터, 관계형 데이터, 사용자 정보
- **MongoDB**: 유연한 레슨 콘텐츠, 이벤트 로그, 분석 데이터

### MongoDB 사용 목적

1. **유연한 콘텐츠 구조**: 레슨 콘텐츠의 7단계 구조를 JSON으로 유연하게 저장
2. **대용량 비정형 데이터**: 이벤트 로그 및 분석 데이터 저장
3. **빠른 읽기 성능**: 중첩된 문서 구조로 Join 없이 빠른 조회
4. **스키마 진화 용이**: 콘텐츠 구조 변경 시 마이그레이션 없이 확장 가능

### 연결 정보

```javascript
// Connection String Format
mongodb://username:password@lemon-mongo:27017/lemonkorean

// Environment Variables
MONGO_URL=mongodb://lemon:password@lemon-mongo:27017/lemonkorean
```

---

## 컬렉션 목록 (Collections List)

| 컬렉션 이름 | 용도 | 문서 수 (예상) | 크기 |
|------------|------|--------------|------|
| **lessons_content** | 레슨 콘텐츠 (7단계 구조) | ~500 | Large |
| **events** | 이벤트 로그 (사용자 행동) | ~1M+ | Very Large |
| **analytics** | 분석 데이터 (집계) | ~10K | Medium |

---

## 컬렉션 상세 (Collection Details)

### 1. lessons_content

**목적**: 레슨의 실제 학습 콘텐츠를 7단계 구조로 저장

**스키마 구조**:

```javascript
{
  _id: ObjectId("507f1f77bcf86cd799439011"),
  lesson_id: 1,                    // PostgreSQL lessons 테이블의 ID (Foreign Key)
  version: "1.0.0",                // 콘텐츠 버전
  content: {
    stages: [                       // 7단계 레슨 구조
      {
        type: "intro",              // 단계 타입
        order: 1,                   // 순서
        data: {
          title: "레슨 소개",
          description: "이 레슨에서는...",
          duration_seconds: 120,
          video_url: null,
          image_url: "https://..."
        }
      },
      {
        type: "vocabulary",         // 어휘 학습 단계
        order: 2,
        data: {
          words: [
            {
              id: 101,              // PostgreSQL vocabulary 테이블의 ID
              korean: "안녕하세요",
              translation: "你好",
              pronunciation: "ān níng hā sèi yō",
              audio_url_male: "media/audio/101_m.mp3",
              audio_url_female: "media/audio/101_f.mp3",
              image_url: "media/images/101.jpg",
              part_of_speech: "greeting",
              example_sentence: "안녕하세요, 만나서 반가워요.",
              mnemonic: "안녕 = 平安, 하세요 = 敬语",
              is_primary: true
            }
          ],
          practice_exercises: [
            {
              type: "flashcard",
              word_ids: [101, 102, 103]
            },
            {
              type: "listening",
              audio_url: "media/audio/practice_001.mp3",
              correct_answer: 101
            }
          ]
        }
      },
      {
        type: "grammar",            // 문법 학습 단계
        order: 3,
        data: {
          rules: [
            {
              id: 50,               // PostgreSQL grammar_rules 테이블의 ID
              name: "-이에요/예요",
              description: "名词谓语形式",
              examples: [
            {
                  korean: "저는 학생이에요",
                  translation: "我是学生",
                  explanation: "-이에요用于有尾音的名词"
                }
              ],
              pattern: "명사 + 이에요/예요",
              usage_notes: "받침이 있으면 -이에요, 없으면 -예요"
            }
          ],
          practice_exercises: [
            {
              type: "fill_blank",
              sentence: "저는 _____ 이에요.",
              options: ["학생", "선생님", "의사"],
              correct_answer: 0
            }
          ]
        }
      },
      {
        type: "dialog",             // 대화 학습 단계
        order: 4,
        data: {
          scenario: "첫 만남",
          participants: ["지수", "명호"],
          lines: [
            {
              speaker: "지수",
              korean: "안녕하세요? 저는 지수예요.",
              translation: "你好？我是智秀。",
              audio_url: "media/audio/dialog_001_01.mp3",
              timestamp: 0
            },
            {
              speaker: "명호",
              korean: "안녕하세요! 저는 명호예요. 만나서 반가워요.",
              translation: "你好！我是明浩。很高兴见到你。",
              audio_url: "media/audio/dialog_001_02.mp3",
              timestamp: 3.5
            }
          ],
          full_audio_url: "media/audio/dialog_001_full.mp3",
          video_url: "media/video/dialog_001.mp4"
        }
      },
      {
        type: "practice",           // 연습 단계
        order: 5,
        data: {
          exercises: [
            {
              type: "multiple_choice",
              question: "다음 중 올바른 문장은?",
              options: [
                "저는 학생이에요.",
                "저는 학생예요.",
                "저는 학생있어요."
              ],
              correct_answer: 0,
              explanation: "받침이 있는 '학생' 뒤에는 -이에요를 사용합니다."
            },
            {
              type: "listening_comprehension",
              audio_url: "media/audio/practice_lc_001.mp3",
              question: "화자가 무엇이라고 말했나요?",
              options: ["안녕하세요", "감사합니다", "미안합니다"],
              correct_answer: 0
            },
            {
              type: "speaking_practice",
              prompt: "다음 상황에서 뭐라고 말할까요?",
              situation: "처음 만난 사람에게 인사하기",
              sample_answer: "안녕하세요? 저는 [이름]이에요. 만나서 반가워요.",
              recording_enabled: true
            }
          ]
        }
      },
      {
        type: "culture",            // 문화 학습 단계
        order: 6,
        data: {
          title: "한국의 인사 예절",
          content: "한국에서는 처음 만날 때 가벼운 고개 숙임과 함께 인사합니다...",
          images: [
            {
              url: "media/images/culture_bow_001.jpg",
              caption: "한국식 인사"
            }
          ],
          video_url: "media/video/culture_greeting_001.mp4",
          key_points: [
            "존댓말 사용",
            "나이가 많은 사람에게 더 깊이 인사",
            "악수보다 고개 숙임이 일반적"
          ],
          quiz: {
            question: "한국에서 처음 만날 때 가장 적절한 인사는?",
            options: [
              "손을 흔들며 '하이'",
              "고개 숙이며 '안녕하세요'",
              "포옹하기"
            ],
            correct_answer: 1
          }
        }
      },
      {
        type: "summary",            // 요약 단계
        order: 7,
        data: {
          title: "레슨 요약",
          key_vocabulary: [101, 102, 103, 104, 105],
          key_grammar: [50, 51],
          achievements: [
            "기본 인사 표현 학습",
            "명사 + 이에요/예요 문법 마스터",
            "첫 만남 대화 연습 완료"
          ],
          next_lesson_preview: {
            lesson_id: 2,
            title: "자기소개하기",
            description: "직업, 국적, 취미 등을 소개하는 방법을 배웁니다."
          },
          review_exercises: [
            {
              type: "comprehensive_quiz",
              question_count: 10,
              time_limit_seconds: 300
            }
          ]
        }
      }
    ],

    // 레슨 전체 설정
    settings: {
      allow_skip: false,            // 단계 건너뛰기 허용 여부
      min_score_to_pass: 80,        // 통과 점수
      retry_allowed: true,          // 재시도 허용
      estimated_time_minutes: 45    // 예상 소요 시간
    }
  },

  media_manifest: [                 // 미디어 파일 목록
    {
      type: "audio",
      url: "media/audio/101_m.mp3",
      size_bytes: 45678,
      duration_seconds: 2.5,
      checksum: "abc123...",
      cdn_url: "https://cdn.lemon.kr/media/audio/101_m.mp3"
    },
    {
      type: "image",
      url: "media/images/101.jpg",
      size_bytes: 123456,
      width: 800,
      height: 600,
      checksum: "def456...",
      cdn_url: "https://cdn.lemon.kr/media/images/101.jpg"
    },
    {
      type: "video",
      url: "media/video/dialog_001.mp4",
      size_bytes: 5234567,
      duration_seconds: 120,
      resolution: "1280x720",
      checksum: "ghi789...",
      cdn_url: "https://cdn.lemon.kr/media/video/dialog_001.mp4"
    }
  ],

  created_at: ISODate("2025-01-15T00:00:00Z"),
  updated_at: ISODate("2025-01-20T10:30:00Z")
}
```

**필드 설명**:

| 필드 | 타입 | 설명 | 필수 | 인덱스 |
|------|------|------|------|--------|
| `_id` | ObjectId | MongoDB 고유 ID | ✅ | Primary |
| `lesson_id` | Number | PostgreSQL lessons.id 참조 | ✅ | Unique |
| `version` | String | 콘텐츠 버전 (Semantic Versioning) | ✅ | - |
| `content` | Object | 레슨 콘텐츠 (7단계 구조) | ✅ | - |
| `content.stages` | Array | 7단계 배열 | ✅ | - |
| `content.settings` | Object | 레슨 설정 | ❌ | - |
| `media_manifest` | Array | 미디어 파일 목록 | ❌ | - |
| `created_at` | Date | 생성 시간 | ✅ | - |
| `updated_at` | Date | 수정 시간 | ✅ | - |

**레슨 단계 (Stage Types)**:

1. **intro**: 레슨 소개 및 목표
2. **vocabulary**: 어휘 학습 (단어, 이미지, 발음, 음성)
3. **grammar**: 문법 규칙 및 예문
4. **dialog**: 실전 대화 연습 (음성/영상)
5. **practice**: 종합 연습 문제
6. **culture**: 문화 학습 (한국 문화, 관습)
7. **summary**: 레슨 요약 및 복습

---

### 2. events

**목적**: 사용자 행동 및 시스템 이벤트 로그 저장 (분석 및 추적용)

**스키마 구조**:

```javascript
{
  _id: ObjectId("507f1f77bcf86cd799439012"),
  event_type: "lesson_started",      // 이벤트 타입
  user_id: 42,                        // PostgreSQL users.id
  session_id: "sess_abc123xyz",      // 세션 ID
  timestamp: ISODate("2025-01-25T14:30:00Z"),

  // 이벤트별 상세 데이터
  data: {
    lesson_id: 1,
    level: 1,
    device: "mobile",
    platform: "android",
    app_version: "1.2.0",
    language: "zh",
    referrer: "lesson_list"
  },

  // 컨텍스트 정보
  context: {
    ip_address: "203.0.113.42",
    user_agent: "Mozilla/5.0...",
    country: "CN",
    city: "Beijing",
    timezone: "Asia/Shanghai"
  },

  // 메타데이터
  metadata: {
    processed: false,                 // 분석 처리 여부
    anomaly_score: 0.05,             // 이상 탐지 점수
    retention_days: 90               // 보관 일수
  }
}
```

**주요 이벤트 타입**:

| 이벤트 타입 | 설명 | 데이터 필드 |
|------------|------|------------|
| `user_registered` | 사용자 가입 | `email`, `language`, `referrer` |
| `user_login` | 로그인 | `method` (email/social) |
| `lesson_started` | 레슨 시작 | `lesson_id`, `level` |
| `lesson_completed` | 레슨 완료 | `lesson_id`, `score`, `duration_seconds` |
| `stage_completed` | 단계 완료 | `lesson_id`, `stage_type`, `score` |
| `vocabulary_practiced` | 단어 학습 | `vocab_id`, `result` (correct/incorrect) |
| `quiz_submitted` | 퀴즈 제출 | `quiz_id`, `answers`, `score` |
| `media_played` | 미디어 재생 | `media_url`, `media_type`, `duration` |
| `download_started` | 오프라인 다운로드 시작 | `lesson_id`, `file_size` |
| `download_completed` | 오프라인 다운로드 완료 | `lesson_id`, `success` |
| `sync_triggered` | 동기화 트리거 | `sync_type`, `items_count` |
| `error_occurred` | 에러 발생 | `error_type`, `error_message`, `stack_trace` |

**인덱스 추천**:

```javascript
// 사용자별 이벤트 조회
db.events.createIndex({ user_id: 1, timestamp: -1 });

// 이벤트 타입별 조회
db.events.createIndex({ event_type: 1, timestamp: -1 });

// 세션별 조회
db.events.createIndex({ session_id: 1, timestamp: 1 });

// 미처리 이벤트 조회
db.events.createIndex({ "metadata.processed": 1, timestamp: 1 });

// TTL 인덱스 (90일 후 자동 삭제)
db.events.createIndex(
  { timestamp: 1 },
  { expireAfterSeconds: 7776000 }  // 90 days
);
```

---

### 3. analytics

**목적**: 집계된 분석 데이터 저장 (대시보드, 리포트용)

**스키마 구조**:

```javascript
{
  _id: ObjectId("507f1f77bcf86cd799439013"),
  metric_type: "daily_active_users",  // 지표 타입
  date: ISODate("2025-01-25T00:00:00Z"),
  granularity: "day",                 // 집계 단위 (hour/day/week/month)

  // 집계 데이터
  data: {
    count: 1250,
    breakdown: {
      by_platform: {
        android: 680,
        ios: 420,
        web: 150
      },
      by_country: {
        CN: 800,
        KR: 250,
        US: 100,
        others: 100
      },
      by_language: {
        zh: 850,
        en: 200,
        ko: 150,
        ja: 50
      }
    }
  },

  // 비교 데이터
  comparison: {
    previous_period: 1180,
    growth_rate: 5.93,                // 성장률 (%)
    trend: "up"                       // up/down/stable
  },

  // 메타데이터
  metadata: {
    computed_at: ISODate("2025-01-26T02:00:00Z"),
    data_quality: "complete",         // complete/partial/estimated
    source_event_count: 45678,
    computation_time_ms: 1234
  }
}
```

**주요 지표 타입**:

| 지표 타입 | 설명 | 업데이트 주기 |
|----------|------|--------------|
| `daily_active_users` | 일간 활성 사용자 | Daily |
| `weekly_active_users` | 주간 활성 사용자 | Weekly |
| `monthly_active_users` | 월간 활성 사용자 | Monthly |
| `lesson_completion_rate` | 레슨 완료율 | Daily |
| `average_study_time` | 평균 학습 시간 | Daily |
| `vocabulary_mastery` | 단어 숙련도 | Daily |
| `user_retention` | 사용자 유지율 | Daily |
| `popular_lessons` | 인기 레슨 | Daily |
| `error_rate` | 에러 발생률 | Hourly |
| `download_stats` | 다운로드 통계 | Daily |
| `sync_success_rate` | 동기화 성공률 | Hourly |

**인덱스 추천**:

```javascript
// 지표 타입 + 날짜 조회
db.analytics.createIndex({ metric_type: 1, date: -1 });

// 집계 단위별 조회
db.analytics.createIndex({ granularity: 1, date: -1 });

// 복합 조회
db.analytics.createIndex({ metric_type: 1, granularity: 1, date: -1 });
```

---

## 인덱스 (Indexes)

### 필수 인덱스 (Required Indexes)

```javascript
// 1. lessons_content - lesson_id 고유 인덱스
db.lessons_content.createIndex(
  { lesson_id: 1 },
  { unique: true, name: "idx_lesson_id_unique" }
);

// 2. lessons_content - 업데이트 시간 조회
db.lessons_content.createIndex(
  { updated_at: -1 },
  { name: "idx_updated_at" }
);

// 3. events - 사용자별 시간순 조회
db.events.createIndex(
  { user_id: 1, timestamp: -1 },
  { name: "idx_user_events" }
);

// 4. events - 이벤트 타입별 조회
db.events.createIndex(
  { event_type: 1, timestamp: -1 },
  { name: "idx_event_type" }
);

// 5. events - TTL 인덱스 (90일 자동 삭제)
db.events.createIndex(
  { timestamp: 1 },
  {
    expireAfterSeconds: 7776000,  // 90 days
    name: "idx_events_ttl"
  }
);

// 6. analytics - 지표 + 날짜 조회
db.analytics.createIndex(
  { metric_type: 1, date: -1 },
  { name: "idx_metrics" }
);
```

### 성능 모니터링

```javascript
// 인덱스 사용 통계 확인
db.lessons_content.aggregate([
  { $indexStats: {} }
]);

// 느린 쿼리 프로파일링
db.setProfilingLevel(1, { slowms: 100 });
db.system.profile.find().sort({ ts: -1 }).limit(10);
```

---

## 데이터 관계 (Data Relationships)

### PostgreSQL ↔ MongoDB 관계

```
PostgreSQL                          MongoDB
─────────────────────────────────────────────────────────────

┌──────────────┐                   ┌───────────────────┐
│   lessons    │ 1              1  │ lessons_content   │
│  (메타데이터)  │ ─────────────────▶│   (콘텐츠)        │
│              │    lesson_id      │                   │
│ - id         │                   │ - lesson_id       │
│ - title_ko   │                   │ - content         │
│ - level      │                   │ - media_manifest  │
│ - status     │                   │                   │
└──────────────┘                   └───────────────────┘
                                            │
                                            │ references
                                            ▼
┌──────────────┐                   ┌───────────────────┐
│ vocabulary   │                   │   content.stages  │
│              │                   │   [vocabulary]    │
│ - id         │ ◀─────────────────│ - words[].id      │
│ - korean     │                   │                   │
└──────────────┘                   └───────────────────┘

┌──────────────┐                   ┌───────────────────┐
│ grammar_rules│                   │   content.stages  │
│              │                   │   [grammar]       │
│ - id         │ ◀─────────────────│ - rules[].id      │
│ - name_ko    │                   │                   │
└──────────────┘                   └───────────────────┘

┌──────────────┐                   ┌───────────────────┐
│    users     │ 1              N  │      events       │
│              │ ─────────────────▶│                   │
│ - id         │    user_id        │ - user_id         │
│ - email      │                   │ - event_type      │
│ - name       │                   │ - data            │
└──────────────┘                   └───────────────────┘
                                            │
                                            │ aggregates
                                            ▼
                                   ┌───────────────────┐
                                   │    analytics      │
                                   │                   │
                                   │ - metric_type     │
                                   │ - data            │
                                   └───────────────────┘
```

### 데이터 정합성 유지

**규칙**:
1. **lesson_id는 반드시 PostgreSQL에 존재해야 함**
2. **vocabulary.id, grammar_rules.id는 참조 전 검증**
3. **MongoDB는 읽기 전용 참조** (업데이트는 PostgreSQL에서)
4. **삭제 시 양쪽 동기화 필요** (트랜잭션 없음)

**동기화 프로세스**:

```javascript
// 레슨 생성 시
async function createLesson(lessonData) {
  // 1. PostgreSQL에 메타데이터 생성
  const lesson = await pg.query(
    'INSERT INTO lessons (...) VALUES (...) RETURNING *'
  );

  // 2. MongoDB에 콘텐츠 생성
  await mongo.lessons_content.insertOne({
    lesson_id: lesson.id,
    content: lessonData.content,
    media_manifest: lessonData.media_manifest
  });
}

// 레슨 삭제 시
async function deleteLesson(lessonId) {
  // 1. MongoDB에서 삭제
  await mongo.lessons_content.deleteOne({ lesson_id: lessonId });

  // 2. PostgreSQL에서 삭제 (CASCADE로 관련 데이터 자동 삭제)
  await pg.query('DELETE FROM lessons WHERE id = $1', [lessonId]);
}
```

---

## 백업 및 복구 (Backup & Restore)

### 자동 백업 (Automated Backup)

**스크립트 위치**: `/home/sanchan/lemonkorean/scripts/backup/`

```bash
# 전체 백업 (mongodump)
mongodump --uri="mongodb://lemon:password@localhost:27017/lemonkorean" \
  --out=/backups/mongodb/$(date +%Y%m%d_%H%M%S) \
  --gzip

# 특정 컬렉션 백업
mongodump --uri="mongodb://lemon:password@localhost:27017/lemonkorean" \
  --collection=lessons_content \
  --out=/backups/mongodb/lessons_$(date +%Y%m%d_%H%M%S) \
  --gzip

# JSON 형식 백업 (mongoexport)
mongoexport --uri="mongodb://lemon:password@localhost:27017/lemonkorean" \
  --collection=lessons_content \
  --out=/backups/mongodb/lessons_content_$(date +%Y%m%d).json \
  --pretty
```

### 복구 (Restore)

```bash
# 전체 복구 (mongorestore)
mongorestore --uri="mongodb://lemon:password@localhost:27017/lemonkorean" \
  --gzip \
  /backups/mongodb/20250125_140000

# 특정 컬렉션 복구
mongorestore --uri="mongodb://lemon:password@localhost:27017/lemonkorean" \
  --collection=lessons_content \
  --gzip \
  /backups/mongodb/lessons_20250125_140000/lemonkorean/lessons_content.bson.gz

# JSON 복구 (mongoimport)
mongoimport --uri="mongodb://lemon:password@localhost:27017/lemonkorean" \
  --collection=lessons_content \
  --file=/backups/mongodb/lessons_content_20250125.json \
  --jsonArray
```

### 백업 전략

| 백업 타입 | 주기 | 보관 기간 | 방법 |
|----------|------|----------|------|
| **전체 백업** | 매일 02:00 | 30일 | mongodump --gzip |
| **증분 백업** | 매시간 | 7일 | oplog 기반 |
| **스냅샷** | 매주 일요일 | 90일 | Volume snapshot |
| **아카이브** | 매월 1일 | 1년 | S3/MinIO 업로드 |

---

## 성능 최적화 (Performance Optimization)

### 쿼리 최적화

```javascript
// ❌ 나쁜 예: 모든 문서 스캔
db.lessons_content.find({ "content.stages.type": "vocabulary" });

// ✅ 좋은 예: 인덱스 활용
db.lessons_content.createIndex({ "content.stages.type": 1 });
db.lessons_content.find({ "content.stages.type": "vocabulary" });

// ❌ 나쁜 예: 불필요한 필드 조회
db.lessons_content.find({ lesson_id: 1 });

// ✅ 좋은 예: 필요한 필드만 프로젝션
db.lessons_content.find(
  { lesson_id: 1 },
  { content: 1, version: 1, _id: 0 }
);
```

### Connection Pool 설정

```javascript
// Node.js MongoDB Driver 설정
const client = new MongoClient(MONGO_URL, {
  maxPoolSize: 10,           // 최대 연결 수
  minPoolSize: 5,            // 최소 연결 수
  maxIdleTimeMS: 30000,      // 유휴 연결 타임아웃
  serverSelectionTimeoutMS: 5000,
  socketTimeoutMS: 30000,
  connectTimeoutMS: 10000
});
```

### 집계 파이프라인 최적화

```javascript
// 효율적인 집계 (인덱스 활용 + 조기 필터링)
db.events.aggregate([
  // 1. 먼저 필터링 (인덱스 활용)
  { $match: {
      event_type: "lesson_completed",
      timestamp: { $gte: ISODate("2025-01-01") }
  }},

  // 2. 필요한 필드만 선택
  { $project: {
      user_id: 1,
      "data.lesson_id": 1,
      "data.score": 1,
      timestamp: 1
  }},

  // 3. 그룹화 및 집계
  { $group: {
      _id: "$data.lesson_id",
      avg_score: { $avg: "$data.score" },
      completion_count: { $sum: 1 }
  }},

  // 4. 정렬
  { $sort: { completion_count: -1 }},

  // 5. 제한
  { $limit: 10 }
]);
```

### 모니터링

```javascript
// 현재 작업 확인
db.currentOp();

// 데이터베이스 통계
db.stats();

// 컬렉션 통계
db.lessons_content.stats();
db.events.stats();
db.analytics.stats();

// 인덱스 크기 확인
db.lessons_content.totalIndexSize();
db.events.totalIndexSize();
```

---

## 유지보수 (Maintenance)

### 일상 작업

```javascript
// 1. 인덱스 재구축 (매월)
db.lessons_content.reIndex();
db.events.reIndex();

// 2. 컬렉션 통계 업데이트
db.runCommand({ collStats: "lessons_content" });

// 3. 오래된 이벤트 수동 정리 (TTL 보완)
db.events.deleteMany({
  timestamp: { $lt: ISODate("2024-10-01") }
});

// 4. 고아 문서 찾기 (PostgreSQL에 없는 lesson_id)
const lessonIds = await pg.query('SELECT id FROM lessons');
const validIds = lessonIds.rows.map(r => r.id);

db.lessons_content.find({
  lesson_id: { $nin: validIds }
}).forEach(doc => {
  print(`Orphan document: ${doc._id} (lesson_id: ${doc.lesson_id})`);
});
```

### 용량 모니터링

```javascript
// 데이터베이스 크기
db.stats(1024 * 1024);  // MB 단위

// 컬렉션별 크기
db.lessons_content.stats(1024 * 1024);
db.events.stats(1024 * 1024);
db.analytics.stats(1024 * 1024);

// 인덱스 크기
db.lessons_content.stats().indexSizes;
```

---

## 보안 (Security)

### 사용자 및 권한

```javascript
// 애플리케이션 사용자 (읽기/쓰기)
db.createUser({
  user: "lemon_app",
  pwd: "secure_password_here",
  roles: [
    { role: "readWrite", db: "lemonkorean" }
  ]
});

// 읽기 전용 사용자 (분석/리포트)
db.createUser({
  user: "lemon_readonly",
  pwd: "secure_password_here",
  roles: [
    { role: "read", db: "lemonkorean" }
  ]
});

// 백업 전용 사용자
db.createUser({
  user: "lemon_backup",
  pwd: "secure_password_here",
  roles: [
    { role: "backup", db: "admin" }
  ]
});
```

### 연결 보안

```javascript
// TLS/SSL 활성화 (production)
mongod --tlsMode requireTLS \
  --tlsCertificateKeyFile /path/to/mongodb.pem \
  --tlsCAFile /path/to/ca.pem

// 인증 활성화
mongod --auth
```

---

## 참고 자료 (References)

### 내부 문서
- [PostgreSQL Schema](../postgres/SCHEMA.md)
- [API Documentation](/docs/API.md)
- [Deployment Guide](/DEPLOYMENT.md)

### 외부 자료
- [MongoDB Manual](https://www.mongodb.com/docs/manual/)
- [MongoDB Best Practices](https://www.mongodb.com/docs/manual/administration/production-notes/)
- [Indexing Strategies](https://www.mongodb.com/docs/manual/applications/indexes/)

---

## 변경 이력 (Change Log)

| 날짜 | 버전 | 변경 내용 | 작성자 |
|------|------|-----------|--------|
| 2026-02-05 | 1.0.0 | 초기 MongoDB 스키마 문서 작성 | Claude Sonnet 4.5 |

---

**문서 작성자**: Claude Sonnet 4.5
**최종 검토**: 2026-02-05
**다음 검토 예정**: 2026-03-05
