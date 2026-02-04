---
date: 2026-02-04
category: Backend, Mobile, Database
title: 다국어 시스템 수정 - 중국어 기본값을 한국어로 변경
author: Claude Sonnet 4.5
tags: [language, i18n, multilingual, breaking-change, migration]
priority: high
---

# 다국어 시스템 수정 - 중국어 기본값을 한국어로 변경

## 문제 요약

레슨 데이터와 시스템 기본값이 중국어('zh')로 설정되어 있었으나, 한국어 학습 앱이므로 한국어('ko')가 기본값이어야 함. 문제는 여러 계층에 걸쳐 존재했음:

1. **백엔드가 중국어를 기본값으로 사용** - language 파라미터가 없을 때
2. **데이터베이스 스키마가 신규 사용자에게 중국어 기본값 설정**
3. **모바일 앱이 API 호출 시 language 파라미터를 일관되게 전달하지 않음**
4. **한글 모듈에 중국어 참조가 하드코딩됨**

## 구현된 변경사항

### Phase 1: 백엔드 변경 (Critical Priority)

#### 파일: `services/content/src/middleware/language.middleware.js`

1. **DEFAULT_LANGUAGE 변경**: `'zh'` → `'ko'` (17번 줄)
2. **주석 업데이트**: "Default: 'zh' (for backwards compatibility)" → "Default: 'ko' (Korean is the primary learning target)" (11번 줄)
3. **알 수 없는 언어에 대한 fallback chain 변경**: `['zh', 'ko']` → `['ko', 'zh']` (125번 줄)
4. **개별 fallback chain 업데이트** (117-122번 줄):
   ```javascript
   const fallbacks = {
     'en': ['en', 'ko', 'zh'],      // 이전: ['en', 'zh', 'ko']
     'es': ['es', 'en', 'ko', 'zh'], // 이전: ['es', 'en', 'zh', 'ko']
     'ja': ['ja', 'ko', 'zh'],       // 이전: ['ja', 'zh', 'ko']
     'zh': ['zh', 'ko'],             // 유지
     'zh_TW': ['zh_TW', 'zh', 'ko'], // 유지
     'ko': ['ko']                     // 유지
   };
   ```

**영향**: 명시적인 language 파라미터가 없는 모든 API 호출에 영향. 데이터베이스에 언어 설정이 저장된 기존 사용자는 영향 없음.

### Phase 2: 데이터베이스 변경 (Medium Priority)

#### 파일: `database/postgres/init/01_schema.sql`

- **15번 줄**: `DEFAULT 'zh'` → `DEFAULT 'ko'`

#### 새 마이그레이션 파일: `database/postgres/migrations/004_update_language_defaults_to_korean.sql`

모든 기존 사용자를 한국어 기본값으로 업데이트하는 마이그레이션:

```sql
-- 모든 기존 사용자를 한국어로 업데이트
UPDATE users SET language_preference = 'ko' WHERE language_preference = 'zh';
UPDATE users SET language_preference = 'ko' WHERE language_preference = 'zh_TW';

-- 향후 사용자를 위한 기본값 업데이트
ALTER TABLE users ALTER COLUMN language_preference SET DEFAULT 'ko';
```

**⚠️ 중요 - 호환성 문제**: 기존 중국어 사용자들을 위한 **BREAKING CHANGE**. 업데이트 후 중국어 설정을 수동으로 다시 변경해야 함.

#### 파일: `database/postgres/init/02_seed.sql`

- 테스트 사용자(li.na@example.com)를 `'zh'`에서 `'ko'`로 업데이트하여 한국어 기본값 테스트

### Phase 3: 모바일 앱 - Language 파라미터 전달 (High Priority)

모든 콘텐츠 가져오기 Provider가 사용자의 언어 설정에 접근하고 API 호출에 전달하도록 수정.

**수정된 파일**:

1. **`mobile/lemon_korean/lib/presentation/providers/lesson_provider.dart`**
   - `fetchLessons()`: `language` 파라미터 추가 (22번 줄)
   - `getLesson()`: `language` 파라미터 추가 (55번 줄)
   - `downloadLessonPackage()`: `language` 파라미터 추가 (91번 줄)

2. **`mobile/lemon_korean/lib/presentation/providers/download_provider.dart`**
   - `loadData()`: `language` 파라미터 추가 (63번 줄)

3. **`mobile/lemon_korean/lib/presentation/providers/vocabulary_browser_provider.dart`**
   - `loadVocabularyForLevel()`: `language` 파라미터 추가 (56번 줄)

**구현 패턴**:
- Provider의 fetch 메서드에서 선택적 `language` 파라미터 수용
- 호출하는 위젯/화면에서 `settingsProvider.contentLanguageCode` 전달
- Provider가 SettingsProvider로부터 독립적으로 유지됨

### Phase 4: 하드코딩된 중국어 참조 제거 (Low Priority)

#### 파일: `mobile/lemon_korean/lib/presentation/screens/hangul/widgets/native_comparison_card.dart`

**변경사항** (567-574번 줄):
```dart
// 이전:
String _selectedLanguage = 'zh';

@override
void initState() {
  super.initState();
  if (widget.userLanguage != null) {
    _selectedLanguage = widget.userLanguage!;
  }
}

// 이후:
late String _selectedLanguage;

@override
void initState() {
  super.initState();
  // Use user's preferred language or default to Korean
  _selectedLanguage = widget.userLanguage ?? 'ko';
}
```

## 주요 파일

1. `services/content/src/middleware/language.middleware.js` - 백엔드 기본값
2. `mobile/lemon_korean/lib/presentation/providers/lesson_provider.dart` - 레슨 가져오기
3. `mobile/lemon_korean/lib/presentation/providers/vocabulary_browser_provider.dart` - 단어 가져오기
4. `mobile/lemon_korean/lib/presentation/providers/download_provider.dart` - 다운로드 관리
5. `database/postgres/init/01_schema.sql` - 데이터베이스 기본값
6. `database/postgres/migrations/004_update_language_defaults_to_korean.sql` - 마이그레이션
7. `mobile/lemon_korean/lib/presentation/screens/hangul/widgets/native_comparison_card.dart` - 하드코딩된 참조

## 엣지 케이스 처리

1. **오프라인 모드**: LocalStorage는 이미 언어별 키를 지원 (예: `lesson:123:zh`, `lesson:123:ko`). 사용자가 오프라인에서 언어를 변경하면 온라인 상태가 되면 새 콘텐츠를 가져옴. 오프라인 fallback은 사용 가능한 언어의 캐시된 콘텐츠를 표시.

2. **누락된 번역**: 백엔드 fallback chain이 처리. 프론트엔드는 `content_language`가 사용자 설정과 일치하지 않을 때를 감지하고 표시기를 보여야 함.

3. **Breaking Change - 사용자 마이그레이션**: 모든 기존 사용자가 한국어('ko')로 마이그레이션됨. 중국어 사용자는 앱 설정에서 언어 설정을 수동으로 중국어(간체 또는 번체)로 다시 변경해야 함.

## 검증 단계

### 백엔드
```bash
# 기본값 테스트 (한국어 반환해야 함)
curl http://localhost:3002/api/content/lessons

# 명시적 중국어 테스트 (중국어 반환해야 함)
curl http://localhost:3002/api/content/lessons?language=zh

# Fallback 테스트 (한국어로 fallback해야 함)
curl http://localhost:3002/api/content/lessons?language=invalid
```

### 모바일 앱
1. 새 설치 → 기본 언어가 한국어인지 확인
2. 중국어로 변경 → 콘텐츠가 중국어로 전환되는지 확인
3. API 호출에 `language=zh` 파라미터가 포함되는지 확인
4. 언어 전환과 함께 오프라인 모드 테스트
5. 한글 모듈이 사용자의 언어로 원어 비교를 표시하는지 테스트

### 데이터베이스
```sql
-- 새 사용자가 한국어 기본값을 가져오는지 테스트
INSERT INTO users (email, password_hash, name) VALUES ('test@example.com', 'hash', 'Test User');
SELECT language_preference FROM users WHERE email = 'test@example.com';
-- 'ko' 반환해야 함

-- 기존 중국어 사용자가 변경되지 않았는지 확인
SELECT COUNT(*) FROM users WHERE language_preference = 'zh';
```

## 배포 전략

**모든 Phase를 함께 구현**:

1. **Phase 1**: 백엔드 미들웨어 변경
2. **Phase 2**: 데이터베이스 마이그레이션 (모든 기존 사용자를 한국어로 마이그레이션 포함)
3. **Phase 3**: 모바일 앱 Provider (모든 Provider 업데이트됨)
4. **Phase 4**: 한글 모듈 정리

**배포 순서**:
1. 백엔드 변경사항 먼저 배포
2. 데이터베이스 마이그레이션 실행
3. 모바일 앱 업데이트 배포
4. 언어 설정 문제에 대한 사용자 피드백 모니터링

## 성공 기준

- [x] 백엔드가 language 파라미터가 제공되지 않을 때 한국어를 기본값으로 사용
- [x] 모든 사용자(신규 및 기존)가 한국어를 기본 언어 설정으로 보유
- [x] 모바일 앱이 모든 콘텐츠 API 호출에 language 파라미터 전달
- [x] 사용자가 여전히 설정에서 중국어(또는 다른 언어)를 수동으로 선택 가능
- [x] 한글 모듈이 비교를 위해 사용자의 언어를 동적으로 사용
- [x] 6개 언어(ko, en, es, ja, zh, zh_TW) 모두 올바르게 작동 계속
- [ ] 앱 내 알림이 사용자에게 언어 변경과 변경 방법을 알림

## 후속 작업

1. **앱 내 알림 추가**: 마이그레이션 후 사용자에게 다음과 같은 알림 표시:
   - "기본 언어를 한국어로 업데이트했습니다. 설정에서 언제든지 언어 설정을 변경할 수 있습니다."

2. **언어 선택 눈에 띄게 표시**: 이 업데이트 후 앱이 언어 선택을 눈에 띄게 표시해야 함

3. **사용자 피드백 모니터링**: 언어 설정 문제에 대한 사용자 피드백 추적

## 영향 분석

### 기존 사용자
- **중국어 사용자**: 언어 설정을 수동으로 다시 변경해야 함
- **한국어 사용자**: 영향 없음 (이미 한국어 사용 중)
- **기타 언어 사용자**: 영향 없음 (명시적 언어 설정 유지)

### 신규 사용자
- 기본적으로 한국어로 시작
- 온보딩 중 언어 선택 가능

### 시스템 동작
- API 호출이 더 이상 중국어를 기본값으로 사용하지 않음
- Fallback chain이 누락된 번역에 대해 한국어를 우선시
- 오프라인 모드가 언어 전환을 올바르게 처리

## 관련 문서

- `/docs/API.md` - API 엔드포인트 문서
- `/database/postgres/SCHEMA.md` - 데이터베이스 스키마
- `/mobile/lemon_korean/README.md` - Flutter 앱 문서

## 마지막 업데이트

2026-02-04 - 초기 구현 완료
