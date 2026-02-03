---
date: 2026-02-03
category: Backend|Mobile|Database
title: 다국어 콘텐츠 지원 구현 (Internationalization)
author: Claude Opus 4.5
tags: [i18n, multi-language, api, database, flutter]
priority: high
---

# 다국어 콘텐츠 지원 구현

## 개요

앱을 중국어 화자 전용에서 완전한 국제화 앱으로 전환. 6개 언어(한국어, 영어, 스페인어, 일본어, 중국어 간체, 중국어 번체)에 대한 콘텐츠 번역 지원 아키텍처 구현.

## 변경 사항

### 1. 데이터베이스 스키마

**새 테이블 생성:**
- `languages` - 지원 언어 참조 테이블
- `lesson_translations` - 레슨별 번역 (제목, 설명)
- `vocabulary_translations` - 단어별 번역 (번역, 발음, 예문)
- `grammar_translations` - 문법별 번역 (이름, 설명, 언어 비교)

**마이그레이션 파일:** `database/postgres/migrations/001_add_translations.sql`

```sql
-- 기존 중국어 데이터를 zh 번역으로 마이그레이션
INSERT INTO lesson_translations (lesson_id, language_code, title, description)
SELECT id, 'zh', title_zh, description_zh FROM lessons WHERE title_zh IS NOT NULL;
```

### 2. 백엔드 API

**언어 미들웨어:** `services/content/src/middleware/language.middleware.js`
- `?language=` 쿼리 파라미터 추출
- `Accept-Language` 헤더 폴백
- 기본값: `zh` (하위 호환성)

**폴백 체인:**
| 요청 언어 | 폴백 순서 |
|----------|----------|
| `en` | en → zh → ko |
| `es` | es → en → zh → ko |
| `ja` | ja → zh → ko |
| `zh` | zh → ko |
| `zh_TW` | zh_TW → zh → ko |
| `ko` | ko |

**모델 업데이트:**
- `lesson.model.js` - LATERAL JOIN으로 폴백 쿼리 구현
- `vocabulary.model.js` - 번역 테이블 JOIN
- 모든 컨트롤러에서 `req.language` 사용

**캐시 키 변경:**
```javascript
// 기존: lesson:full:${id}
// 변경: lesson:full:${id}:${language}
```

### 3. Flutter 앱

**설정 프로바이더:**
```dart
String get contentLanguageCode {
  switch (_appLanguage) {
    case AppLanguage.ko: return 'ko';
    case AppLanguage.en: return 'en';
    case AppLanguage.es: return 'es';
    case AppLanguage.ja: return 'ja';
    case AppLanguage.zhCN: return 'zh';
    case AppLanguage.zhTW: return 'zh_TW';
  }
}
```

**API 클라이언트:**
- 모든 콘텐츠 API 메서드에 `language` 파라미터 추가

**데이터 모델 필드명 변경:**
| 기존 | 변경 |
|------|------|
| `titleZh` | `title` |
| `chinese` | `translation` |
| `pinyin` | `pronunciation` |
| `nameZh` | `name` |

**로컬 스토리지:**
- 언어별 키 접미사 지원: `lesson_1_en`, `vocab_5_ja`
- 하위 호환성을 위한 기본 키 유지

## 하위 호환성

1. **API**: `?language=` 없으면 기본값 `zh` 사용
2. **모델**: `fromJson`에서 기존 필드명(`title_zh`, `chinese`)과 새 필드명(`title`, `translation`) 모두 지원
3. **DB**: 기존 컬럼 유지 (deprecation 주석 추가)

## 테스트 방법

```bash
# API 테스트
curl "https://api.lemonkorean.com/api/content/lessons?language=en"
curl "https://api.lemonkorean.com/api/content/vocabulary/1?language=ja"

# 폴백 테스트 (번역 없는 언어 요청)
curl "https://api.lemonkorean.com/api/content/lessons/1?language=es"
# → es 번역 없으면 en → zh → ko 순으로 폴백
```

## 영향받는 파일

### 데이터베이스
- `database/postgres/migrations/001_add_translations.sql` (신규)
- `database/postgres/init/01_schema.sql` (수정)

### 백엔드
- `services/content/src/middleware/language.middleware.js` (신규)
- `services/content/src/models/lesson.model.js`
- `services/content/src/models/vocabulary.model.js`
- `services/content/src/controllers/lessons.controller.js`
- `services/content/src/controllers/vocabulary.controller.js`
- `services/content/src/controllers/grammar.controller.js`
- `services/content/src/routes/lessons.routes.js`
- `services/content/src/routes/vocabulary.routes.js`
- `services/content/src/routes/grammar.routes.js`

### Flutter
- `lib/presentation/providers/settings_provider.dart`
- `lib/core/network/api_client.dart`
- `lib/data/models/lesson_model.dart`
- `lib/data/models/vocabulary_model.dart`
- `lib/data/repositories/content_repository.dart`
- `lib/core/storage/local_storage.dart`

### 문서
- `README.md`
- `CLAUDE.md`
- `docs/API.md` (신규)

## 다음 단계

1. 번역 데이터 입력 (Admin 대시보드 또는 직접 SQL)
2. Admin 대시보드에 번역 관리 UI 추가 (선택)
3. 번역 누락 알림 기능 (선택)
