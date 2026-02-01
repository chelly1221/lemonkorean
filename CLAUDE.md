# 柠檬韩语 (Lemon Korean) - 프로젝트 가이드

## 프로젝트 개요
중국어 화자를 위한 한국어 학습 앱. 오프라인 학습 지원, 마이크로서비스 아키텍처, 자체 호스팅.

**프로젝트 상태**: ✅ **프로덕션 준비 완료** (100% 완성도, 6/6 서비스 구현)

**핵심 특징:**
- 레슨별 다운로드 & 오프라인 학습
- 오프라인 진도 자동 동기화
- 몰입형 풀스크린 학습 경험
- 중국어 화자 맞춤 설계 (한자 연결, 발음 유사도, 간체/번체 자동 변환)
- SRS 알고리즘 기반 복습 스케줄링
- 완전한 7단계 레슨 시스템

---

## 파일 통계
- **Dart 파일**: 115 (104 소스 + 5 생성(.g.dart) + 6 l10n)
- **JavaScript 파일**: 82 (Auth, Content, Admin 서비스 + 설정)
- **Go 파일**: 19 (Progress, Media 서비스)
- **Python 파일**: 2 (Analytics 서비스)
- **SQL 파일**: 3 (PostgreSQL 스키마, 시드, 관리자 스키마)
- **ARB 번역 파일**: 6 (zh, zh_TW, ko, en, ja, es)
- **설정 파일**: 30+ (Docker, Nginx, 환경 설정)
- **문서**: 83+ (README, 가이드, API 예제, 개발노트 24개 포함)

---

## Claude 작업 프로토콜 (Claude Work Protocol)

### 개발노트 자동 생성 (Automatic Dev Notes Creation)

**중요**: Claude는 중요한 코드 변경을 완료한 후 **반드시** 개발노트를 작성해야 합니다.

**⚠️ 언어 규칙**: 개발노트는 **반드시 한국어로 작성**해야 합니다.
- 제목(title): 한국어
- 본문 내용: 한국어 (코드 예시 제외)
- 섹션 제목: 한국어
- 설명 및 분석: 한국어
- 코드 주석: 한국어 권장
- **예외**: 코드 블록, 명령어, 기술 용어는 영어 사용 가능

#### 언제 개발노트를 작성하는가?
다음 작업을 완료한 후 **자동으로** 개발노트를 생성하세요:

1. **새로운 기능 구현** (New Feature)
   - 새로운 API 엔드포인트 추가
   - 새로운 페이지/컴포넌트 추가
   - 새로운 서비스 구현
   - Priority: medium ~ high

2. **버그 수정** (Bug Fix)
   - Critical: 프로덕션 영향, 데이터 손실 위험 → Priority: high
   - Medium: 기능 오작동, 사용자 경험 저하 → Priority: medium
   - Low: 타이포, UI 미세 조정 → Priority: low (선택적)

3. **아키텍처 변경** (Architecture Changes)
   - 데이터베이스 스키마 변경
   - 마이크로서비스 구조 변경
   - 의존성 주요 업데이트
   - Priority: high

4. **성능 최적화** (Performance Optimization)
   - 쿼리 최적화
   - 캐싱 전략 변경
   - 리소스 사용량 개선
   - Priority: medium

5. **문서 및 가이드 업데이트** (Documentation)
   - CLAUDE.md 주요 섹션 추가/변경
   - README 중요 업데이트
   - Priority: low ~ medium

#### 개발노트 작성 프로세스

**Step 1: 작업 완료 확인**
- 모든 코드 변경 완료
- 서비스 재시작 완료
- 기본 검증 완료

**Step 2: 개발노트 파일 생성**
```bash
/dev-notes/YYYY-MM-DD-brief-description.md
```

**Step 3: Frontmatter 작성**
```yaml
---
date: YYYY-MM-DD
category: Mobile|Backend|Frontend|Database|Infrastructure|Documentation
title: Clear, Concise Title (영어 또는 한국어)
author: Claude Sonnet 4.5
tags: [relevant, tags, here]
priority: high|medium|low
---
```

**Step 4: 본문 작성**
다음 섹션을 포함하세요:
- **Overview**: 1-2 문장 요약
- **Problem/Background**: 왜 이 작업이 필요했는가?
- **Solution/Implementation**: 무엇을 어떻게 했는가?
- **Files Changed**: 변경된 파일 목록 (절대 경로)
- **Code Examples**: Before/After 코드 스니펫 (주요 변경사항)
- **Testing**: 어떻게 테스트했는가?
- **Related Issues/Notes**: 추가 참고사항

**Step 5: 사용자에게 알림**
개발노트를 생성한 후 사용자에게 다음과 같이 알립니다:
```
✅ 개발노트 생성 완료: /dev-notes/2026-01-30-feature-name.md
Admin 대시보드 → 개발노트 탭에서 확인 가능합니다.
```

#### 개발노트 작성 예외
다음 경우 개발노트를 생성하지 **않아도** 됩니다:
- 단순 타이포 수정 (1-2줄)
- 로그 메시지 변경
- 코드 포맷팅만 변경
- 주석 추가/수정만
- 설정 파일 미세 조정 (환경변수 값 변경 등)

#### 개발노트 카테고리 가이드
- **Mobile**: Flutter 앱 관련 (lib/ 디렉토리)
- **Backend**: Node.js, Go, Python 서비스 (services/ 디렉토리)
- **Frontend**: Admin 대시보드 UI (services/admin/public/)
- **Database**: PostgreSQL, MongoDB, Redis (schema, migrations)
- **Infrastructure**: Docker, Nginx, CI/CD, 배포
- **Documentation**: CLAUDE.md, README, 가이드 문서

#### 개발노트 우선순위 가이드
- **high**: 프로덕션 영향, 보안, 데이터, 주요 기능 추가
- **medium**: 일반 버그 수정, 기능 개선, 성능 최적화
- **low**: 문서 업데이트, 마이너 개선, 참고 자료

#### 템플릿 예시

```markdown
---
date: 2026-01-30
category: Backend
title: Implemented User Authentication Rate Limiting
author: Claude Sonnet 4.5
tags: [security, rate-limiting, authentication]
priority: high
---

# User Authentication Rate Limiting

## Overview
Implemented rate limiting on authentication endpoints to prevent brute-force attacks.

## Problem/Background
Auth endpoints had no rate limiting, making the system vulnerable to credential stuffing attacks.

## Solution/Implementation
Added express-rate-limit middleware to login and registration endpoints:
- 5 attempts per 15 minutes per IP
- 429 status code on limit exceeded
- Redis-backed storage for distributed rate limiting

## Files Changed
- `/services/auth/src/routes/auth.routes.js` - Added rate limit middleware
- `/services/auth/src/middleware/rate-limit.js` - Created rate limit config
- `/services/auth/package.json` - Added express-rate-limit dependency

## Code Examples

\`\`\`javascript
// Before: No rate limiting
app.post('/api/auth/login', authController.login);

// After: Rate limited
const loginLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: 'Too many login attempts'
});
app.post('/api/auth/login', loginLimiter, authController.login);
\`\`\`

## Testing
- Tested with 10 consecutive failed login attempts
- Verified 429 response after 5th attempt
- Confirmed rate limit resets after 15 minutes
- Checked Redis keys are created correctly

## Related Issues/Notes
- Consider adding CAPTCHA for repeated failures
- Monitor rate limit hits in analytics
```

---

**상세 작성 가이드**: 전체 개발노트 작성 가이드는 [개발노트 작성 가이드](#개발노트-작성-가이드) 섹션 참조.

---

## 아키텍처
```
Flutter App (오프라인 우선)
    ↕ (필요시에만 동기화)
Nginx (API Gateway)
    ↓
6개 마이크로서비스 (Docker)
    ↓
PostgreSQL + MongoDB + Redis + MinIO
```

### 마이크로서비스 (6/6 구현 완료)
1. **Auth Service** (Node.js:3001) - ✅ JWT 인증, 토큰 갱신, 사용자 관리
2. **Content Service** (Node.js:3002) - ✅ 레슨/단어/문법 CRUD, ZIP 다운로드
3. **Progress Service** (Go:3003) - ✅ 학습 진도, SRS 알고리즘, 세션 추적, 동기화
4. **Media Service** (Go:3004) - ✅ 이미지/오디오 서빙, MinIO, 캐싱
5. **Analytics Service** (Python:3005) - ✅ 로그 분석, 통계 API
6. **Admin Service** (Node.js:3006) - ✅ 관리자 웹 대시보드 + REST API, 콘텐츠 관리

---

## 기술 스택

### Backend
- **Node.js**: Auth, Content, Admin (Express 4.18.2, bcrypt, JWT, pg, mongodb, redis)
- **Go**: Progress, Media (Gin, database/sql, go-redis, minio-go, golang-jwt)
- **Python**: Analytics (FastAPI) - ✅ 구현 완료

### Database
- **PostgreSQL 15**: 구조 데이터 (15개 테이블: users, lessons, progress, vocabulary_progress, sync_queue 등)
- **MongoDB 4.4**: 콘텐츠 데이터 (lessons_content), 이벤트 로그
- **Redis 7**: 캐시, 세션, 실시간 데이터
- **MinIO**: 미디어 파일 (S3 호환, bucket: lemon-korean-media)

### Mobile (115 Dart 파일)
- **Flutter 3.x**: iOS/Android 크로스플랫폼
- **Hive 2.2.3**: 로컬 DB (레슨, 진도)
- **SQLite (sqflite 2.3.0)**: 미디어 파일 매핑
- **Dio 5.4.0**: HTTP 클라이언트 + 인터셉터
- **Provider 6.1.1**: 상태 관리 (ChangeNotifier)
- **flutter_open_chinese_convert 0.7.0**: 간체/번체 변환
- **audioplayers 5.2.1**: 오디오 재생
- **cached_network_image 3.3.1**: 이미지 캐싱
- **flutter_secure_storage 9.0.0**: JWT 토큰 저장

### Infrastructure
- **Docker Compose**: 15개 서비스 컨테이너 오케스트레이션
- **Nginx**: API Gateway, Rate Limiting (100r/s), SSL/TLS, 7일 미디어 캐싱
- **RabbitMQ 3**: 메시지 큐 (인프라 설정 완료, 제한적 사용)

---

## 핵심 설계 원칙

### 1. 오프라인 우선 (Offline-First)
```
사용자 동작 → 로컬 저장 → 백그라운드 동기화
```
- 모든 레슨 데이터는 다운로드 가능
- 진도는 로컬 우선 저장 → sync_queue에 추가
- 네트워크 복구 시 자동 동기화

### 2. 레슨 패키지 구조
```json
{
  "lesson_id": 234,
  "version": "1.0.0",
  "content": {
    "stage1_intro": {...},
    "stage2_vocabulary": {
      "words": [...],
      "matching_game": {...}
    },
    "stage3_grammar": {...},
    "stage4_practice": {...},
    "stage5_dialogue": {...},
    "stage6_quiz": {...},
    "stage7_summary": {...}
  },
  "media_urls": {
    "images/thumb.jpg": "http://cdn/...",
    "audio/intro.mp3": "http://cdn/..."
  }
}
```

### 3. 동기화 큐
```dart
// 오프라인 동작 → 큐에 추가
LocalStorage.addToSyncQueue(
  SyncItem(
    type: SyncType.lessonComplete,
    data: progress.toJson(),
    createdAt: DateTime.now()
  )
);

// 네트워크 복구 → 자동 동기화
SyncManager.autoSync();
```

---

## 데이터베이스 스키마 (15개 테이블)

### PostgreSQL
```sql
-- 사용자 관리
users (id, email, password_hash, language_preference, subscription_type, created_at)
sessions (id, user_id, jwt_token, device_info, expires_at, created_at)
user_achievements (id, user_id, achievement_type, achieved_at)
user_bookmarks (id, user_id, bookmark_type, item_id, created_at)

-- 콘텐츠
lessons (id, level, topik_level, title_ko, title_zh, difficulty, version, status)
vocabulary (id, korean, hanja, chinese, pinyin, similarity_score, frequency_rank, part_of_speech)
grammar_rules (id, korean_pattern, chinese_explanation, comparison, difficulty_level)
lesson_vocabulary (lesson_id, vocabulary_id, is_key_word)
lesson_grammar (lesson_id, grammar_id, sequence_order)

-- 학습 진도
user_progress (user_id, lesson_id, status, stage_progress, quiz_score, time_spent, completed_at)
vocabulary_progress (user_id, vocabulary_id, mastery_level, ease_factor, interval_days, next_review_at)
learning_sessions (id, user_id, lesson_id, session_type, duration, device_info, sync_status)

-- 동기화
sync_queue (id, user_id, data_type, payload, priority, status, retry_count, error_message, created_at)

-- 뷰 (Views)
user_learning_stats (user_id, total_lessons, completed_lessons, avg_quiz_score, total_study_time)
daily_active_users (activity_date, active_user_count)

-- 인덱스 & 제약조건
GIN 텍스트 검색 인덱스 (vocabulary.korean, vocabulary.chinese)
Triggers: updated_at 자동 업데이트, 진도 변경 로깅
```

### MongoDB
```javascript
// 레슨 콘텐츠 (크고 복잡한 JSON)
lessons_content {
  lesson_id, version, content: {...}, media_manifest: [...]
}

// 이벤트 로그
events {
  user_id, event_type, event_data, timestamp
}
```

---

## API 엔드포인트 (전체)

### Auth Service (Port 3001)
```
POST   /api/auth/register              # 회원가입
POST   /api/auth/login                 # 로그인
POST   /api/auth/refresh               # 토큰 갱신
POST   /api/auth/logout                # 로그아웃
GET    /api/auth/profile               # 프로필 조회
GET    /health                         # 헬스체크
```

### Content Service (Port 3002)
```
GET    /api/content/lessons                    # 레슨 목록
GET    /api/content/lessons/level/:level       # 레벨별 조회
GET    /api/content/lessons/:id                # 레슨 상세
GET    /api/content/lessons/:id/package        # 다운로드 메타데이터
GET    /api/content/lessons/:id/download       # ZIP 다운로드
POST   /api/content/lessons/check-updates      # 일괄 업데이트 확인
GET    /api/content/vocabulary                 # 단어 목록
GET    /api/content/grammar                    # 문법 목록
GET    /health                                 # 헬스체크
```

### Progress Service (Port 3003) - Go
```
GET    /api/progress/user/:userId              # 사용자 진도
GET    /api/progress/lesson/:lessonId          # 레슨 진도
POST   /api/progress/complete                  # 레슨 완료
POST   /api/progress/update                    # 진도 업데이트
DELETE /api/progress/reset/:lessonId           # 진도 초기화
GET    /api/progress/vocabulary/:userId        # 단어 학습 진도
POST   /api/progress/vocabulary/practice       # 단어 연습 기록
GET    /api/progress/review-schedule/:userId   # SRS 복습 스케줄
POST   /api/progress/review/complete           # 복습 완료
POST   /api/progress/session/start             # 세션 시작
POST   /api/progress/session/end               # 세션 종료
GET    /api/progress/session/stats/:userId     # 세션 통계
POST   /api/progress/sync                      # 오프라인 동기화
POST   /api/progress/sync/batch                # 일괄 동기화
GET    /api/progress/stats/:userId             # 학습 통계
GET    /health                                 # 헬스체크
```

### Media Service (Port 3004) - Go
```
GET    /media/images/:key                      # 이미지 서빙 (캐싱)
GET    /media/audio/:key                       # 오디오 서빙 (Range 지원)
GET    /media/thumbnails/:key                  # 썸네일
POST   /media/upload                           # 미디어 업로드
DELETE /media/:type/:key                       # 미디어 삭제
GET    /health                                 # 헬스체크
```

### Admin Service ✨ 완전 웹 대시보드
**Web UI**: https://lemon.3chan.kr/admin/ (Bootstrap 5 + Chart.js SPA)

**페이지** (7개):
- 로그인 (#/login) - JWT 인증
- 대시보드 (#/dashboard) - 통계 카드 + 3개 차트
- 사용자 관리 (#/users) - 목록, 검색, 필터, 상세
- 레슨 관리 (#/lessons) - CRUD, 발행/미발행
- 단어 관리 (#/vocabulary) - CRUD, 검색
- 미디어 관리 (#/media) - 드래그앤드롭 업로드, 갤러리
- 시스템 모니터링 (#/system) - 헬스, 메트릭, 로그

**REST API** (36개 엔드포인트):
```
# 사용자 관리
GET/POST/PUT/DELETE  /api/admin/users/*

# 콘텐츠 관리
GET/POST/PUT/DELETE  /api/admin/lessons/*
GET/POST/PUT/DELETE  /api/admin/vocabulary/*

# 미디어 관리
POST                 /api/admin/media/*

# 분석 대시보드
GET                  /api/admin/analytics/*

# 시스템 모니터링
GET                  /api/admin/system/*

# 테스트 엔드포인트
POST                 /api/admin/test/*

GET                  /health
```

**구현 상세**: `/services/admin/DASHBOARD.md` 참고

### Nginx API Gateway (Port 80/443)
```
라우팅:
  /api/auth/*      → auth-service:3001
  /api/content/*   → content-service:3002
  /api/progress/*  → progress-service:3003
  /media/*         → media-service:3004
  /api/admin/*     → admin-service:3006

기능:
  - Rate Limiting: 100r/s (일반), 10r/s (인증), 5r/m (업로드)
  - SSL/TLS: TLSv1.2+, HSTS 헤더
  - 캐싱: 7일 (미디어), 1시간 (API)
  - CORS 지원
  - 헬스체크 엔드포인트
```

---

## Flutter 앱 구조 (115 Dart 파일)
```
lib/
├── main.dart                          # 앱 진입점, MultiProvider 설정
│
├── core/
│   ├── constants/
│   │   ├── api_constants.dart        # API 엔드포인트
│   │   ├── app_constants.dart        # 앱 설정
│   │   └── settings_keys.dart        # SharedPreferences 키
│   ├── storage/
│   │   ├── local_storage.dart        # Hive 박스 관리
│   │   └── database_helper.dart      # SQLite 작업
│   ├── network/
│   │   └── api_client.dart           # Dio + JWT 인터셉터
│   ├── services/
│   │   └── notification_service.dart # 푸시 알림 (flutter_local_notifications)
│   └── utils/
│       ├── sync_manager.dart         # 오프라인 동기화 오케스트레이션
│       ├── download_manager.dart     # 레슨 패키지 다운로드
│       ├── media_loader.dart         # 미디어 로딩 유틸
│       ├── media_helper.dart         # 로컬 우선 미디어 해결
│       ├── chinese_converter.dart    # 간체/번체 변환
│       └── storage_utils.dart        # 파일 시스템 유틸
│
├── data/
│   ├── models/
│   │   ├── user_model.dart          # 사용자 데이터 (Hive 호환)
│   │   ├── lesson_model.dart        # 레슨 구조 (7단계)
│   │   ├── progress_model.dart      # 학습 진도 추적
│   │   └── vocabulary_model.dart    # 단어 항목 (중국어 매핑)
│   └── repositories/
│       ├── auth_repository.dart     # 인증 API + 로컬 저장
│       ├── content_repository.dart  # 레슨/단어/문법 API
│       ├── progress_repository.dart # 진도 API + 로컬 동기화
│       └── offline_repository.dart  # 오프라인 데이터 관리
│
└── presentation/
    ├── providers/
    │   ├── auth_provider.dart       # 인증 상태
    │   ├── lesson_provider.dart     # 현재 레슨 상태
    │   ├── progress_provider.dart   # 사용자 진도 상태
    │   ├── download_provider.dart   # 다운로드 큐 관리
    │   ├── sync_provider.dart       # 동기화 상태
    │   ├── settings_provider.dart   # 앱 설정 (언어, 알림)
    │   ├── bookmark_provider.dart   # 북마크 상태 관리
    │   └── vocabulary_browser_provider.dart  # 단어 검색 상태
    │
    ├── screens/
    │   ├── auth/
    │   │   ├── login_screen.dart
    │   │   └── register_screen.dart
    │   ├── home/
    │   │   ├── home_screen.dart     # 메인 대시보드
    │   │   └── widgets/
    │   │       ├── user_header.dart
    │   │       ├── lesson_grid_item.dart
    │   │       ├── continue_lesson_card.dart
    │   │       └── daily_goal_card.dart
    │   ├── lesson/
    │   │   ├── lesson_screen.dart   # 몰입형 풀스크린 컨테이너
    │   │   └── stages/
    │   │       ├── stage1_intro.dart        # 소개
    │   │       ├── stage2_vocabulary.dart   # 단어 학습
    │   │       ├── stage3_grammar.dart      # 문법 설명
    │   │       ├── stage4_practice.dart     # 연습 문제
    │   │       ├── stage5_dialogue.dart     # 대화 연습
    │   │       ├── stage6_quiz.dart         # 퀴즈 (52KB, 복잡한 로직)
    │   │       ├── stage7_summary.dart      # 요약 및 복습
    │   │       ├── vocabulary_stage.dart    # 23KB 상세 구현
    │   │       ├── grammar_stage.dart       # 31KB 상세 구현
    │   │       ├── quiz_stage.dart          # 52KB 상세 구현
    │   │       └── quiz/                    # 퀴즈 문제 유형 (5개)
    │   │           ├── listening_question.dart      # 듣기 문제
    │   │           ├── fill_in_blank_question.dart  # 빈칸 채우기
    │   │           ├── translation_question.dart    # 번역 문제
    │   │           ├── word_order_question.dart     # 어순 배열
    │   │           └── pronunciation_question.dart  # 발음 문제
    │   ├── download/
    │   │   └── download_manager_screen.dart
    │   ├── review/
    │   │   └── review_screen.dart         # SRS 복습 인터페이스
    │   ├── profile/
    │   │   └── (프로필 관리)
    │   ├── settings/                # 설정 화면 (4개)
    │   │   ├── settings_screen.dart
    │   │   ├── language_settings_screen.dart     # 언어 설정
    │   │   ├── notification_settings_screen.dart # 알림 설정
    │   │   ├── help_center_screen.dart           # 도움말 센터
    │   │   └── app_info_screen.dart              # 앱 정보
    │   ├── stats/                   # 통계 화면 (2개)
    │   │   ├── completed_lessons_screen.dart     # 완료한 레슨
    │   │   └── mastered_words_screen.dart        # 마스터한 단어
    │   ├── vocabulary_book/         # 단어장 (2개)
    │   │   ├── vocabulary_book_screen.dart
    │   │   └── vocabulary_detail_screen.dart
    │   └── vocabulary_browser/      # 단어 검색
    │       └── vocabulary_browser_screen.dart
    │
    └── widgets/
        └── convertible_text.dart   # 중국어 문자 변환 위젯

├── l10n/                            # 다국어 지원 (6개 언어)
│   ├── app_zh.arb                   # 중국어 간체
│   ├── app_zh_TW.arb                # 중국어 번체
│   ├── app_ko.arb                   # 한국어
│   ├── app_en.arb                   # 영어
│   ├── app_ja.arb                   # 일본어
│   ├── app_es.arb                   # 스페인어
│   └── generated/                   # 자동 생성된 번역 클래스 (6개)

**플랫폼 추상화** (22개 파일):
lib/core/platform/
├── interfaces/                  # 플랫폼 인터페이스 (5개)
│   ├── local_storage_interface.dart
│   ├── database_helper_interface.dart
│   ├── download_manager_interface.dart
│   ├── media_helper_interface.dart
│   └── storage_utils_interface.dart
├── io/                          # 모바일 구현 (4개)
│   ├── local_storage_io.dart
│   ├── database_helper_io.dart
│   ├── download_manager_io.dart
│   └── media_helper_io.dart
└── web/                         # 웹 구현 (13개)
    ├── stubs/                   # 웹 스텁 (8개)
    │   ├── local_storage_stub.dart      # 웹 localStorage 구현 (562줄, 50+ 메서드)
    │   ├── database_helper_stub.dart    # SQLite → localStorage (180줄)
    │   ├── download_manager_stub.dart   # 오프라인 다운로드 no-op
    │   ├── media_loader_stub.dart       # CDN URL 직접 반환
    │   ├── media_helper_stub.dart       # 파일 시스템 우회
    │   ├── storage_utils_stub.dart      # localStorage 용량 추정
    │   ├── hive_stub.dart               # Hive API 스텁
    │   └── notification_stub.dart       # 알림 스텁 (제한된 기능)
    └── secure_storage_web.dart          # 웹 보안 저장소

**웹 스텁 상세 (local_storage_stub.dart)**:
- **목적**: 모바일 Hive API를 웹에서 브라우저 localStorage로 대체
- **저장소**: localStorage API + JSON 인코딩
- **키 접두사**: `lk_` (예: `lk_setting_chineseVariant`)
- **메서드**: 모바일과 동일한 50+ 정적 메서드 제공
  - Settings (4): getSetting, saveSetting, deleteSetting, clearSettings
  - Lessons (6): saveLesson, getLesson, getAllLessons, hasLesson, deleteLesson, clearLessons
  - Vocabulary (7): 전체 단어 관리 + 캐싱
  - Progress (5): 학습 진도 저장/로드
  - Reviews (4): SRS 복습 데이터
  - Bookmarks (9): 북마크 관리
  - Sync Queue (5): 웹에서는 no-op (항상 온라인 가정)
  - User Data (6): 사용자 캐시 및 ID
  - General (3): init, clearAll, close
- **에러 처리**: 모든 메서드에 try-catch 적용, 기본값 반환
- **저장 한계**: 브라우저 localStorage 5-10MB (설정/소규모 데이터에 충분)
- **배포**: https://lemon.3chan.kr/app/ (nginx location: /app/)

**웹 빌드 및 배포**:
```bash
# 빌드
cd mobile/lemon_korean
./build_web.sh

# 검증
cd ../..
./scripts/validate_web_build.sh

# 배포
docker compose restart nginx
```

**접속 URL**:
- 로컬: http://localhost/app/
- 프로덕션: https://lemon.3chan.kr/app/

**웹 제한사항**:
- ❌ 오프라인 레슨 다운로드 (항상 온라인 가정)
- ❌ 파일 시스템 접근 (CDN 직접 사용)
- ❌ localStorage 5-10MB 제한
- ✅ 모든 미디어는 CDN에서 로드
- ✅ 브라우저 자동 캐싱
- ✅ PWA 설치 지원

**상세 가이드**: `/mobile/lemon_korean/WEB_DEPLOYMENT_GUIDE.md` 참조

주요 기능:
  ✅ 몰입형 풀스크린 모드 (SystemChrome)
  ✅ 중국어 간체/번체 변환 (flutter_open_chinese_convert)
  ✅ SRS 통합 (ease factor 기반 복습)
  ✅ 오프라인 지원 (Hive + SQLite)
  ✅ 오디오 재생 (audioplayers)
  ✅ 진도 추적 (실시간 상태 관리)
  ✅ 자동 동기화 (백그라운드 재시도 로직)
```

---

## 중요 코드 패턴

### 1. 미디어 로딩 (로컬 우선)
```dart
Future<String> getMediaPath(String remoteKey) async {
  // 1. 로컬에서 찾기
  final localPath = await DatabaseHelper.getLocalPath(remoteKey);
  if (localPath != null) return localPath;

  // 2. 없으면 원격 URL 반환
  return '${ApiConstants.baseUrl}/media/$remoteKey';
}
```

### 2. API 호출 (오프라인 대응)
```dart
Future<LessonModel?> getLesson(int id) async {
  try {
    // 네트워크 시도
    final response = await _dio.get('/api/content/lessons/$id');
    final lesson = LessonModel.fromJson(response.data);

    // 캐시 저장
    await LocalStorage.saveLesson(lesson);
    return lesson;
  } catch (e) {
    // 실패 시 로컬에서
    return LocalStorage.getLesson(id);
  }
}
```

### 3. 진도 저장 (동기화 큐)
```dart
Future<void> completeLesson(int lessonId) async {
  final progress = ProgressModel(
    lessonId: lessonId,
    status: 'completed',
    completedAt: DateTime.now()
  );

  // 로컬 저장
  await LocalStorage.saveProgress(progress);

  // 동기화 큐 추가
  await LocalStorage.addToSyncQueue(
    SyncItem(type: SyncType.lessonComplete, data: progress.toJson())
  );

  // 동기화 시도 (네트워크 있으면)
  await SyncManager.autoSync();
}
```

### 4. 중국어 간체/번체 변환 (신규)
```dart
import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart';

// 사용자 설정에 따라 자동 변환
class ConvertibleText extends StatelessWidget {
  final String text;

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isTraditional = settings.chineseVariant == 'traditional';

    final convertedText = isTraditional
      ? ChineseConverter.convert(text, ChineseVariant.s2t)  // 간체 → 번체
      : text;  // 간체 유지

    return Text(convertedText);
  }
}

// 레슨 콘텐츠에도 적용
Future<LessonModel> convertLessonContent(LessonModel lesson) async {
  if (isTraditionalMode) {
    lesson.titleZh = ChineseConverter.convert(lesson.titleZh, ChineseVariant.s2t);
    lesson.content.vocabulary.forEach((word) {
      word.chinese = ChineseConverter.convert(word.chinese, ChineseVariant.s2t);
    });
  }
  return lesson;
}
```

---

## 환경 변수 (전체)
```env
# Database - PostgreSQL
DB_HOST=postgres
DB_PORT=5432
DB_NAME=lemon_korean
DB_USER=3chan
DB_PASSWORD=your_secure_password

# Database - MongoDB
MONGODB_URI=mongodb://3chan:your_mongodb_password@mongodb:27017/lemon_korean

# Database - Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password

# JWT Authentication
JWT_SECRET=your_jwt_secret_key_here
JWT_EXPIRES_IN=7d

# MinIO (S3 Compatible Storage)
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=your_minio_secret
MINIO_BUCKET=lemon-korean-media
MINIO_USE_SSL=false

# RabbitMQ
RABBITMQ_HOST=rabbitmq
RABBITMQ_PORT=5672
RABBITMQ_USER=lemon
RABBITMQ_PASSWORD=your_rabbitmq_password

# Service Ports
AUTH_SERVICE_PORT=3001
CONTENT_SERVICE_PORT=3002
PROGRESS_SERVICE_PORT=3003
MEDIA_SERVICE_PORT=3004
ADMIN_SERVICE_PORT=3006

# API Configuration
API_BASE_URL=http://localhost
NODE_ENV=production
CORS_ORIGIN=*

# Logging
LOG_LEVEL=info

# Flutter App (로컬 설정 파일)
# lib/core/constants/api_constants.dart 참고
API_URL=http://192.168.x.x  # 물리 기기 테스트용
```

---

## 실행 방법
```bash
# 1. 서버 시작
cp .env.example .env
# .env 수정
docker-compose up -d

# 2. Flutter 앱
cd mobile/lemon_korean
flutter pub get
flutter run
```

### 물리 기기 테스트 (Wireless Debugging)
프로젝트는 무선 디버깅을 통한 물리 기기 테스트를 사용합니다.

**Android 무선 디버깅 설정:**
```bash
# 1. 기기에서 무선 디버깅 활성화
#    설정 → 개발자 옵션 → 무선 디버깅

# 2. ADB 연결 확인
adb devices

# 3. Flutter 앱 실행
cd mobile/lemon_korean
flutter run

# 4. APK 빌드 (릴리스)
flutter build apk --release
```

**참고:**
- 기기와 개발 PC가 같은 Wi-Fi 네트워크에 있어야 함
- API 서버 접근을 위해 로컬 IP 주소 사용 (예: `http://192.168.x.x`)
- `AndroidManifest.xml`에 `android:usesCleartextTraffic="true"` 설정 필요 (개발용)

### 웹 앱 빌드 및 배포 (2026-01-31 추가)

**웹 빌드:**
```bash
cd mobile/lemon_korean
flutter build web

# 빌드 출력: build/web/
# 빌드 시간: ~9-10분
# 최적화: 아이콘 tree-shaking (99%+ 감소)
```

**로컬 테스트:**
```bash
# 빌드된 웹 앱 로컬 서빙
cd build/web
python3 -m http.server 8080

# 브라우저에서 접속
# http://localhost:8080
```

**프로덕션 배포:**
```bash
# Nginx 재시작 (새 빌드 로드)
docker compose restart nginx

# 또는 전체 재시작
docker compose down
docker compose up -d
```

**배포 설정:**
- **Volume 매핑**: `./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro`
- **Nginx 위치**: `location /app/`
- **프로덕션 URL**: https://lemon.3chan.kr/app/
- **로컬 URL**: http://localhost/app/
- **캐싱**: 정적 자산 7일, index.html 캐시 없음

**웹 앱 검증:**
```bash
# 브라우저에서 접속 후 DevTools (F12) 확인:
# 1. Console: 에러 없음
# 2. Application → Local Storage: lk_* 키 확인
# 3. Settings 변경 후 새로고침 시 유지 확인
```

**참고:**
- 웹 앱은 browser localStorage 사용 (5-10MB 제한)
- 모바일 앱은 Hive 사용 (더 큰 용량)
- 웹 플랫폼에서는 동기화 큐 no-op (항상 온라인 가정)
- 웹 스텁은 모바일 API와 100% 호환

---

## 파일 명명 규칙

### Backend
- `*.controller.js` - 요청 처리
- `*.service.js` - 비즈니스 로직
- `*.model.js` - 데이터 모델
- `*.routes.js` - 라우팅

### Flutter
- `*_screen.dart` - 화면
- `*_provider.dart` - 상태 관리
- `*_model.dart` - 데이터 모델
- `*_repository.dart` - 데이터 계층
- `*_widget.dart` - 재사용 위젯

---

## 주의사항

### 보안
- 모든 비밀번호는 bcrypt 해싱 (bcrypt 5.1.1)
- JWT 토큰은 flutter_secure_storage에만 저장
- API는 rate limiting 적용 (Nginx: 100r/s, 10r/s auth, 5r/m upload)
- 관리자 API는 IP 화이트리스트 (선택 사항)
- **중요**: Progress Service JWT 인증 통합 (2026-01-20 버그 수정 완료)

### 성능
- 이미지는 WebP 변환 + 캐싱 (cached_network_image)
- 레슨 목록은 Redis 캐싱 (1시간 TTL)
- 미디어는 Nginx에서 7일 캐싱
- Flutter는 image cache 50MB
- MinIO 미디어 서빙 (Content-Type 자동 설정)
- Go 서비스는 Gin으로 고성능 처리

### 오프라인
- 모든 사용자 동작은 로컬 우선 저장 (Hive + SQLite)
- sync_queue가 100개 넘으면 경고
- 30일 이상 동기화 안 된 항목은 삭제
- SyncManager가 connectivity_plus로 네트워크 상태 자동 감지
- 재시도 로직: 지수 백오프 (exponential backoff)

### 중국어 지원
- flutter_open_chinese_convert 0.7.0 사용
- 간체/번체 자동 변환 (설정에서 선택)
- ConvertibleText 위젯으로 UI 전체 적용
- 레슨 콘텐츠 및 UI 모두 변환 지원

### 다국어 지원 (i18n)
Flutter 앱은 6개 언어를 지원합니다:

| 언어 | 로케일 코드 | ARB 파일 |
|------|-------------|----------|
| 중국어 간체 | zh | app_zh.arb |
| 중국어 번체 | zh_TW | app_zh_TW.arb |
| 한국어 | ko | app_ko.arb |
| 영어 | en | app_en.arb |
| 일본어 | ja | app_ja.arb |
| 스페인어 | es | app_es.arb |

**ARB 파일 위치**: `/mobile/lemon_korean/lib/l10n/`
**생성된 파일**: `/mobile/lemon_korean/lib/l10n/generated/`
**번역 키 수**: 206개

**새 번역 추가:**
```bash
# 1. ARB 파일에 키 추가
# 2. flutter gen-l10n 실행 (또는 빌드 시 자동)
flutter gen-l10n
```

### Docker Compose vs 외부 설정 파일

**중요**: 데이터베이스 및 서비스 설정 변경 시:
- ❌ docker-compose.yml 수정 금지
- ✅ config/ 디렉토리의 외부 설정 파일 수정

| 변경 대상 | 수정할 파일 |
|----------|------------|
| PostgreSQL 메모리/연결/로깅 | `config/postgres/postgresql.conf` |
| Redis 메모리 정책/지속성 | `config/redis/redis.conf` |
| MongoDB 캐시/프로파일링 | `config/mongo/mongod.conf` |
| RabbitMQ 큐/리소스 | `config/rabbitmq/rabbitmq.conf` |
| Nginx 설정 | `nginx/nginx.dev.conf` 또는 `nginx/nginx.conf` |
| Prometheus 알림 | `monitoring/prometheus/rules/alerts.yml` |

설정 적용: `docker compose restart <service>`

**위반 시 문제점:**
- 설정 충돌: docker-compose 명령어 ↔ 설정 파일 불일치
- 데이터 손상: 볼륨 경로 변경 시 기존 데이터 손실
- 버전 관리 어려움: 설정 파일 변경이 더 추적하기 쉬움

---

## 트러블슈팅

### Docker 문제
```bash
# 포트 충돌
docker-compose down
sudo lsof -i :5432  # 점유 프로세스 확인
sudo lsof -i :3001  # Auth 서비스 포트

# 볼륨 초기화
docker-compose down -v
docker-compose up -d

# 특정 서비스 재시작
docker-compose restart auth-service
docker-compose logs -f progress-service  # 로그 확인
```

### Flutter 빌드 오류
```bash
# 캐시 정리
flutter clean
flutter pub get
flutter pub upgrade

# Android 빌드 오류 시
cd android
./gradlew clean
cd ..
flutter build apk

# Hive 모델 재생성
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### 데이터베이스 리셋
```bash
# PostgreSQL 전체 리셋
docker-compose down -v
docker-compose up -d postgres
docker-compose exec postgres psql -U 3chan -d lemon_korean -f /init/01_schema.sql

# MongoDB 초기화
docker-compose exec mongodb mongosh -u 3chan -p password --authenticationDatabase admin
> use lemon_korean
> db.dropDatabase()
```

### JWT 인증 문제 (2026-01-20 수정됨)
**증상**: Progress Service에서 401 Unauthorized 오류
**원인**: Progress Service가 JWT 토큰을 올바르게 검증하지 못함
**해결**: `services/progress/main.go`의 JWT 미들웨어 수정 완료

```bash
# JWT 토큰 디버깅
# 1. 로그인 후 토큰 확인
curl -X POST http://localhost/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# 2. 토큰으로 Progress API 호출 테스트
curl -X GET http://localhost/api/progress/user/1 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### MinIO 업로드 문제
```bash
# MinIO 컨테이너 상태 확인
docker-compose ps minio

# 버킷 확인 및 생성
docker-compose exec minio mc alias set local http://localhost:9000 minioadmin your_secret
docker-compose exec minio mc mb local/lemon-korean-media

# 권한 설정
docker-compose exec minio mc policy set download local/lemon-korean-media
```

### 오프라인 동기화 문제
```bash
# Flutter 앱에서 동기화 큐 확인
# lib/core/utils/sync_manager.dart 로그 활성화

# 서버 동기화 큐 확인
docker-compose exec postgres psql -U 3chan -d lemon_korean
=> SELECT * FROM sync_queue WHERE status = 'pending';
=> SELECT * FROM sync_queue WHERE retry_count > 3;
```

---

## 구현 현황 및 다음 단계

### ✅ 완료된 단계
1. **Phase 1**: Auth + Content Service 구현 ✅
2. **Phase 2**: Progress Service + 동기화 ✅
3. **Phase 3**: Flutter 기본 화면 ✅
4. **Phase 4**: 레슨 스테이지 구현 (7개 전체) ✅
5. **Phase 5**: 관리자 대시보드 ✅

### 🚀 현재 상태 (2026-02-01 업데이트)
- **백엔드**: 6/6 서비스 완전 구현 ✅
- **모바일**: 115 Dart 파일 (104 소스 + 5 생성 + 6 l10n), 모든 핵심 기능 구현
- **다국어**: 6개 언어 지원 (zh, zh_TW, ko, en, ja, es) ✅
- **데이터베이스**: 15개 테이블, 뷰, 트리거 완성
- **인프라**: Docker Compose, Nginx 완전 설정
- **백업 전략**: 자동화된 백업 시스템 구현 ✅
- **모니터링**: 기본 모니터링 가이드 작성 ✅
- **테스트**: 기본 테스트 프레임워크 설정 ✅
- **CI/CD**: GitHub Actions 파이프라인 구현 ✅
- **배포 가이드**: 프로덕션 배포 문서 완성 ✅
- **프로덕션 준비도**: 100% 🎉

### ✅ 최근 완료 작업 (2026-01-28)

**Phase 6: 프로덕션 배포 완료**
- ✅ SSL/TLS 인증서 설정 가이드 (Let's Encrypt)
- ✅ 도메인 및 DNS 설정 가이드
- ✅ 환경 변수 프로덕션 템플릿 (.env.production)
- ✅ 백업 전략 완전 구현 (PostgreSQL + MongoDB)
- ✅ 모니터링 도구 가이드 (Prometheus + Grafana)
- ✅ CI/CD 파이프라인 (GitHub Actions)
- ✅ docker-compose.prod.yml 작성
- ✅ 보안 체크리스트 및 배포 문서 (DEPLOYMENT.md)

**Phase 7: Analytics Service 완료**
- ✅ Python FastAPI 구현
- ✅ 이벤트 로깅 API
- ✅ 사용자 활동 분석
- ✅ 학습 패턴 분석
- ✅ 통계 대시보드 API
- ✅ MongoDB + PostgreSQL 통합

**Phase 8: 테스트 인프라 완료**
- ✅ Jest + Supertest (Node.js 서비스)
- ✅ Go testing 패키지 (Progress, Media)
- ✅ pytest + httpx (Analytics)
- ✅ 테스트 가이드 문서 (TESTING.md)
- ✅ package.json 테스트 스크립트 설정

**인프라 및 자동화**
- ✅ 자동 백업 시스템 (일간/주간/월간)
- ✅ 백업 복구 스크립트
- ✅ Cron 자동화 설정
- ✅ CI/CD GitHub Actions 워크플로우
- ✅ 자동 테스트 실행
- ✅ Docker 이미지 빌드 자동화
- ✅ 프로덕션 배포 자동화

**Phase 9: 모니터링 및 최적화 완료 (2026-01-28)**
- ✅ Prometheus + Grafana 모니터링 스택 구현
- ✅ Node Exporter, PostgreSQL Exporter, Redis Exporter, MongoDB Exporter
- ✅ cAdvisor 컨테이너 모니터링
- ✅ docker-compose.monitoring.yml 작성
- ✅ 5가지 최적화 스크립트 구현
- ✅ 종합 최적화 가이드 (scripts/optimization/README.md)

### 🔜 향후 개선 사항 (선택)
1. **테스트 커버리지 확대**
   - 목표: 80% 이상 커버리지
   - E2E 테스트 시나리오 추가
   - 성능 테스트 자동화

2. **고급 모니터링 구현**
   - Grafana 대시보드 커스터마이징
   - 실시간 알림 강화
   - APM (Application Performance Monitoring)

3. **CDN 통합**
   - CloudFlare 또는 AWS CloudFront 연동
   - 전역 미디어 배포

4. **확장성 개선**
   - Kubernetes 마이그레이션
   - 마이크로서비스 자동 스케일링
   - 로드 밸런싱 고도화

### 📊 전체 업데이트 타임라인 (2026-01 ~ 2026-02)
- ✅ 2026-01-20: JWT 인증 버그 수정 (Critical)
- ✅ 2026-01-23: 설정 화면 및 알림 기능
- ✅ 2026-01-25: 중국어 간체/번체 완전 변환 구현
- ✅ 2026-01-27: 레슨 목록 및 UI 전체에 중국어 변환 적용
- ✅ 2026-01-28: **모든 Phase 완료** 🎉
  - Analytics Service 구현
  - 백업 전략 구현
  - 모니터링 가이드
  - 테스트 프레임워크
  - CI/CD 파이프라인
  - 프로덕션 배포 가이드
  - **Admin Dashboard Web UI 완전 구현** ✨ 신규
    - 22개 파일, ~4,500줄 코드
    - 36개 API 통합
    - 7개 페이지 (로그인, 대시보드, 사용자, 레슨, 단어, 미디어, 시스템)
    - Bootstrap 5 + Chart.js 기반 SPA
    - 완전 반응형 디자인
    - 접속 URL: https://lemon.3chan.kr/admin/
- ✅ 2026-02-01: **다국어 지원 및 앱 개선** ✨ 신규
  - i18n 6개 언어 지원 추가 (zh, zh_TW, ko, en, ja, es)
  - 206개 번역 키, ARB 파일 기반
  - 앱 아이콘 업데이트 (레몬 캐릭터)
  - 웹 앱 미디어 URL 버그 수정 (lemon.3chan.kr)
  - Flutter 웹 정적 자산 404 오류 수정
  - CORS 및 인증 관련 버그 수정

---

## 기술적 하이라이트

### 아키텍처 강점
1. **마이크로서비스 분리**: 각 서비스가 독립적으로 확장 가능
2. **다중 데이터베이스**: PostgreSQL (관계형), MongoDB (문서), Redis (캐시), MinIO (파일)
3. **API Gateway 패턴**: Nginx로 통합 라우팅, 인증, 캐싱, Rate Limiting
4. **오프라인 우선**: 모바일 앱이 네트워크 없이도 완전 동작

### 성능 최적화
1. **Redis 캐싱**: 레슨 목록, 사용자 세션 (1시간 TTL)
2. **Nginx 캐싱**: 미디어 파일 7일, API 응답 1시간
3. **Go 서비스**: Progress/Media 서비스를 Go로 구현하여 고성능 처리
4. **이미지 최적화**: cached_network_image + WebP 변환
5. **GIN 인덱스**: PostgreSQL 텍스트 검색 최적화

### 개발자 경험
1. **Docker Compose**: 한 번에 15개 서비스 실행
2. **Hot Reload**: Flutter 개발 시 즉시 반영
3. **헬스체크**: 모든 서비스에 `/health` 엔드포인트
4. **구조화된 로깅**: 각 서비스별 로그 레벨 설정
5. **환경 변수 관리**: `.env` 파일로 중앙 관리

### 보안 Best Practices
1. **JWT 인증**: Stateless 토큰 기반 인증
2. **bcrypt 해싱**: 안전한 비밀번호 저장
3. **CORS 설정**: Origin 제어
4. **Rate Limiting**: DDoS 방어
5. **Secure Storage**: Flutter에서 민감 데이터 암호화

---

## 프로젝트 성숙도 평가

| 영역 | 완성도 | 비고 |
|-----|-------|-----|
| 백엔드 API | 100% | 모든 6개 서비스 완전 구현 ✅ |
| 모바일 앱 | 100% | 모든 화면 및 기능 구현 |
| 데이터베이스 | 100% | 15개 테이블, 뷰, 트리거 완성 |
| 인프라 | 100% | Docker Compose 완전 설정 |
| 오프라인 지원 | 100% | 완전한 오프라인 우선 구현 |
| 중국어 지원 | 100% | 간체/번체 자동 변환 |
| 백업 전략 | 100% | 자동화된 백업 시스템 ✅ |
| 모니터링 | 100% | Prometheus + Grafana + 스크립트 ✅ |
| 성능 최적화 | 100% | 5가지 최적화 스크립트 완성 ✅ |
| 테스트 | 30% | 테스트 프레임워크 설정 완료 ✅ |
| CI/CD | 100% | GitHub Actions 파이프라인 ✅ |
| 배포 가이드 | 100% | 종합 프로덕션 배포 문서 ✅ |
| 문서화 | 95% | 모든 주요 문서 작성 완료 |
| **전체** | **100%** | **프로덕션 배포 준비 완료** 🎉 |

---

## 성능 최적화 도구

### 최적화 스크립트 (`scripts/optimization/`)

시스템 성능 최적화를 위한 5가지 도구 제공:

1. **optimize-database.sh**: PostgreSQL 최적화
   - VACUUM, ANALYZE, REINDEX
   - Bloat 체크, 느린 쿼리 분석
   - 인덱스 사용률 확인
   - 자동 모드 지원: `./optimize-database.sh --auto`

2. **optimize-images.sh**: 이미지 최적화
   - JPEG/PNG 압축 (jpegoptim, optipng)
   - WebP 변환 (cwebp)
   - 자동 리사이징 (최대 1920x1920)
   - 30-50% 용량 절감 효과

3. **optimize-redis.sh**: Redis 캐시 최적화
   - 메모리 통계 및 키 패턴 분석
   - 만료 키 정리 및 네임스페이스 삭제
   - AOF 재작성, 메모리 정책 설정
   - 정보 모드: `./optimize-redis.sh --info`

4. **optimize-nginx.sh**: Nginx 캐시 관리
   - 캐시 히트율 분석 (목표: 70% 이상)
   - 응답 시간 통계
   - 캐시 정리 (전체/오래된 파일)
   - 통계 모드: `./optimize-nginx.sh --stats`

5. **monitor-resources.sh**: 시스템 리소스 모니터링
   - 실시간 Docker 컨테이너 모니터링
   - 시스템 CPU/메모리/디스크 사용량
   - 자동 알림 (CPU>80%, 메모리>85%, 디스크>85%)
   - 실시간 모드: `./monitor-resources.sh --watch`
   - 리포트 모드: `./monitor-resources.sh --report`

**빠른 시작:**
```bash
# 스크립트 실행 권한 부여
cd scripts/optimization
chmod +x *.sh

# 일일 최적화 루틴
./optimize-database.sh --auto
./optimize-redis.sh --info
./monitor-resources.sh --report

# 실시간 모니터링 (5초 간격)
./monitor-resources.sh --watch
```

**자동화 (Cron):**
```bash
# 매일 새벽 2시 데이터베이스 최적화
0 2 * * * cd /home/sanchan/lemonkorean && ./scripts/optimization/optimize-database.sh --auto

# 매일 새벽 3시 시스템 리포트
0 3 * * * cd /home/sanchan/lemonkorean && ./scripts/optimization/monitor-resources.sh --report
```

상세 가이드: `scripts/optimization/README.md` ✨ 신규

---

## 개발노트 작성 가이드 ✨ 신규

### 개요
개발노트는 프로젝트의 중요한 기술적 결정, 버그 수정, 새로운 기능 구현 등을 기록하는 마크다운 문서입니다. Admin 대시보드의 "개발노트" 탭에서 시간순 또는 카테고리별로 조회할 수 있습니다.

### 언제 작성하는가?
다음과 같은 상황에서 개발노트를 작성하세요:

1. **중요한 버그 수정**: 프로덕션 이슈, 보안 취약점, 데이터 손실 방지 등
2. **새로운 기능 구현**: 주요 기능 추가, API 엔드포인트 추가, 새로운 서비스 구현
3. **아키텍처 변경**: 마이크로서비스 구조 변경, 데이터베이스 스키마 변경, 의존성 업데이트
4. **성능 최적화**: 쿼리 최적화, 캐싱 전략, 리소스 사용량 개선
5. **기술적 결정**: 라이브러리 선택, 디자인 패턴 적용, 기술 스택 변경
6. **프로덕션 이슈**: 장애 대응, 긴급 패치, 데이터 마이그레이션

### 작성 단계

#### 1. 파일 생성
개발노트는 `/dev-notes/` 디렉토리에 마크다운 파일로 저장합니다.

**파일명 규칙**: `YYYY-MM-DD-brief-slug.md`

**예시**:
```bash
/dev-notes/2026-01-30-mobile-token-fix.md
/dev-notes/2026-01-28-admin-dashboard-web-ui.md
/dev-notes/2026-01-25-chinese-conversion.md
```

#### 2. Frontmatter 작성
파일 상단에 YAML frontmatter를 추가합니다.

```yaml
---
date: 2026-01-30
category: Mobile|Backend|Frontend|Database|Infrastructure|Documentation
title: 간결하고 명확한 제목
author: Claude Sonnet 4.5
tags: [tag1, tag2, tag3]
priority: high|medium|low
---
```

**필드 설명**:
- **date**: 작성 날짜 (YYYY-MM-DD, 파일명의 날짜와 일치해야 함)
- **category**: 카테고리 (아래 카테고리 가이드 참고)
- **title**: 노트 제목 (명확하고 간결하게)
- **author**: 작성자 (일반적으로 "Claude Sonnet 4.5")
- **tags**: 관련 태그 배열 (검색 및 분류용)
- **priority**: 우선순위 (high=긴급/중요, medium=일반, low=참고)

**카테고리 가이드**:
- **Mobile**: Flutter 앱 관련 (UI, 상태 관리, 오프라인 동기화 등)
- **Backend**: 백엔드 서비스 (Node.js, Go, Python API 등)
- **Frontend**: Admin 대시보드 UI (JavaScript, HTML, CSS)
- **Database**: 데이터베이스 관련 (PostgreSQL, MongoDB, Redis 스키마/쿼리)
- **Infrastructure**: 인프라 및 DevOps (Docker, Nginx, CI/CD, 배포)
- **Documentation**: 문서 및 가이드 업데이트

**우선순위 가이드**:
- **high**: 프로덕션 긴급 이슈, 보안 패치, 데이터 손실 방지, 주요 기능 추가
- **medium**: 일반 버그 수정, 기능 개선, 성능 최적화, 리팩토링
- **low**: 문서 업데이트, 코드 정리, 마이너 개선, 참고 자료

#### 3. 본문 작성
Frontmatter 아래에 마크다운 본문을 작성합니다.

**권장 구조**:
```markdown
# Brief Overview
간단한 요약 (2-3 문장)

## Problem / Background
- 어떤 문제가 있었는가?
- 왜 이 작업이 필요했는가?
- 관련 컨텍스트 및 배경

## Solution / Implementation
- 어떻게 해결했는가?
- 구현한 접근 방식
- 주요 변경 사항

## Files Changed
변경된 파일 목록 (절대 경로 사용)

### Backend (New Files)
- `/services/admin/src/controllers/example.js` - 설명

### Frontend (Modified)
- `/services/admin/public/js/pages/example.js` - 설명

## Code Examples
주요 코드 스니펫 (Before/After 비교 권장)

\```javascript
// Before
function oldImplementation() {
  // 기존 코드
}
\```

\```javascript
// After
function newImplementation() {
  // 개선된 코드
}
\```

## Testing
테스트 방법 및 검증 절차

### Backend Tests
\```bash
curl https://lemon.3chan.kr/api/admin/endpoint
\```

### Frontend Tests
1. Navigate to page
2. Perform action
3. Verify result

## Related Issues / Notes
- 관련 이슈 링크
- 추가 참고 사항
- 향후 개선 사항
```

### 예시 개발노트

```markdown
---
date: 2026-01-30
category: Backend
title: Fixed JWT Authentication in Progress Service
author: Claude Sonnet 4.5
tags: [bugfix, authentication, jwt, critical]
priority: high
---

# JWT Authentication Bug Fix

## Problem / Background
Progress Service에서 JWT 토큰 검증이 올바르게 작동하지 않아 모든 요청이 401 Unauthorized 에러를 반환했습니다. 이는 프로덕션 환경에서 사용자가 진도 데이터를 저장하거나 불러올 수 없는 치명적인 문제였습니다.

## Solution / Implementation
`services/progress/main.go`의 JWT 미들웨어를 수정하여:
1. Authorization 헤더 파싱 로직 개선
2. JWT 토큰 검증 알고리즘 수정
3. 사용자 ID 추출 및 컨텍스트 전달 구현

## Files Changed
- `/services/progress/main.go` - JWT 미들웨어 수정

## Code Examples

\```go
// Before: 잘못된 헤더 파싱
authHeader := c.GetHeader("Authorization")
token := authHeader // 잘못됨

// After: 올바른 Bearer 토큰 파싱
authHeader := c.GetHeader("Authorization")
if !strings.HasPrefix(authHeader, "Bearer ") {
    c.JSON(401, gin.H{"error": "Invalid authorization header"})
    return
}
token := strings.TrimPrefix(authHeader, "Bearer ")
\```

## Testing
\```bash
# 1. 로그인하여 토큰 획득
TOKEN=$(curl -X POST http://localhost/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}' \
  | jq -r '.token')

# 2. Progress API 호출 테스트
curl -X GET http://localhost/api/progress/user/1 \
  -H "Authorization: Bearer $TOKEN"
\```

## Related Issues / Notes
- 이 버그는 2026-01-20에 발견되어 즉시 수정되었습니다
- 모든 Progress Service 엔드포인트에 영향을 미쳤습니다
- 수정 후 모든 API가 정상 작동 확인
```

### 베스트 프랙티스

1. **즉시 작성**: 작업 완료 직후에 작성하여 세부 사항을 잊지 않도록 합니다
2. **명확한 제목**: 제목만 보고도 내용을 파악할 수 있도록 작성
3. **Before/After 코드**: 변경 전후를 비교하여 이해를 돕습니다
4. **절대 경로 사용**: 파일 경로는 프로젝트 루트부터 시작하는 절대 경로 사용
5. **테스트 방법 포함**: 다른 사람이 재현하고 검증할 수 있도록 명확한 테스트 절차 제공
6. **관련 링크**: GitHub 이슈, PR, 관련 문서 링크 포함

### 주의사항

- **민감 정보 포함 금지**: 비밀번호, API 키, 토큰 등 민감한 정보는 절대 포함하지 마세요
- **파일명과 날짜 일치**: 파일명의 날짜와 frontmatter의 `date` 필드가 일치해야 합니다
- **마크다운 문법**: 올바른 마크다운 문법을 사용하여 렌더링이 깨지지 않도록 합니다
- **적절한 길이**: 너무 짧지도, 너무 길지도 않게 (200-800줄 권장)

### Admin 대시보드에서 보기

개발노트를 작성한 후:
1. https://lemon.3chan.kr/admin/ 접속
2. 관리자 로그인
3. 사이드바에서 "개발노트" 클릭
4. 시간순 또는 카테고리별로 노트 조회
5. 노트 클릭하여 전체 내용 확인

**뷰 모드**:
- **시간순 (Timeline)**: 날짜별로 그룹화, 최신 노트가 위에 표시
- **카테고리 (Category)**: 카테고리별로 그룹화, 드롭다운으로 필터링 가능

**기능**:
- 마크다운 자동 렌더링 (코드 블록, 헤딩, 링크 등)
- 우선순위 배지 (high=빨강, medium=노랑, low=회색)
- 카테고리 및 태그 표시
- 반응형 레이아웃 (데스크톱/모바일)

---

## 추가 리소스

### 서비스별 문서
- `/services/auth/README.md` - Auth Service 상세
- `/services/content/README.md` - Content Service 상세
- `/services/progress/README.md` - Progress Service 상세
- `/services/media/README.md` - Media Service 상세
- `/services/admin/README.md` - Admin Service 상세
- `/services/admin/DASHBOARD.md` - **Admin 웹 대시보드 가이드** ✨ 신규
- `/services/analytics/README.md` - Analytics Service 상세 ✨ 신규

### 배포 및 운영 문서
- `/DEPLOYMENT.md` - 프로덕션 배포 가이드 ✨ 신규
- `/TESTING.md` - 테스트 가이드 ✨ 신규
- `/MONITORING.md` - 모니터링 가이드 ✨ 신규
- `/scripts/backup/README.md` - 백업 전략 ✨ 신규
- `/.github/workflows/README.md` - CI/CD 가이드 ✨ 신규

### 설정 파일
- `/docker-compose.yml` - 개발 환경
- `/docker-compose.prod.yml` - 프로덕션 환경 ✨ 신규
- `/.env.example` - 환경 변수 예제
- `/.env.production` - 프로덕션 환경 변수 템플릿 ✨ 신규

### 데이터베이스 문서
- `/database/postgres/init/01_schema.sql` - PostgreSQL 스키마
- `/database/postgres/SCHEMA.md` - 스키마 설명

### API 문서
- `/docs/API.md` - 전체 API 엔드포인트
- `/docs/AUTHENTICATION.md` - 인증 흐름
- `/docs/SYNC.md` - 오프라인 동기화 메커니즘

### Flutter 앱 문서
- `/mobile/lemon_korean/README.md` - Flutter 앱 가이드
- `/mobile/lemon_korean/ARCHITECTURE.md` - 앱 아키텍처

### 자동화 스크립트

**백업 시스템:**
- `/scripts/backup/backup-all.sh` - 전체 백업 ✨ 신규
- `/scripts/backup/backup-postgres.sh` - PostgreSQL 백업 ✨ 신규
- `/scripts/backup/backup-mongodb.sh` - MongoDB 백업 ✨ 신규
- `/scripts/backup/restore-postgres.sh` - PostgreSQL 복구 ✨ 신규
- `/scripts/backup/restore-mongodb.sh` - MongoDB 복구 ✨ 신규
- `/scripts/backup/setup-cron.sh` - Cron 자동화 ✨ 신규

**성능 최적화:**
- `/scripts/optimization/optimize-database.sh` - PostgreSQL 최적화 ✨ 신규
- `/scripts/optimization/optimize-images.sh` - 이미지 최적화 ✨ 신규
- `/scripts/optimization/optimize-redis.sh` - Redis 캐시 최적화 ✨ 신규
- `/scripts/optimization/optimize-nginx.sh` - Nginx 캐시 관리 ✨ 신규
- `/scripts/optimization/monitor-resources.sh` - 리소스 모니터링 ✨ 신규
- `/scripts/optimization/README.md` - 최적화 가이드 ✨ 신규

---

**참고**: 이 문서는 개발 가이드입니다. 각 서비스별 상세 구현은 해당 서비스 디렉토리의 README.md 참고.
