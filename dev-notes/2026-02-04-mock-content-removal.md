---
date: 2026-02-04
category: Mobile
title: Mock 콘텐츠 제거 및 실제 DB 콘텐츠 구현
author: Claude Opus 4.5
tags: [flutter, mock-data, database, api, i18n]
priority: high
---

# Mock 콘텐츠 제거 및 실제 DB 콘텐츠 구현

## 개요

Flutter 앱에서 하드코딩된 mock 데이터를 제거하고, 실제 데이터베이스 콘텐츠를 사용하도록 변경했습니다. 이를 통해 다국어 콘텐츠를 DB에서 관리할 수 있게 되었습니다.

## 변경 사항

### 1. 데이터베이스 시드 파일 생성

#### `/database/postgres/init/06_vocabulary_seed.sql`
- 기본 어휘 8개에 대한 4개 언어 번역 (en, ja, es, ko)
- `ON CONFLICT DO UPDATE` 패턴으로 idempotent 실행 보장

#### `/database/postgres/init/07_grammar_seed.sql`
- 기본 문법 5개에 대한 4개 언어 번역
- `language_comparison` 필드로 각 언어별 비교 설명 포함

#### `/database/postgres/init/08_dialogue_seed.js`
- MongoDB `lesson_contents` 컬렉션용 대화 콘텐츠 스크립트
- 레슨 1의 stage5 대화 데이터 포함

#### `/database/postgres/init/09_pronunciation_comparison_seed.sql`
- `hangul_pronunciation_guides` 테이블에 발음 비교 데이터 삽입
- JSONB 형식: `{"zh": [{"comparison": "...", "tip": "..."}], "en": [...]}`

### 2. Flutter Stage 파일 Mock 데이터 제거

| 파일 | 제거된 Mock | 대체 처리 |
|------|------------|----------|
| `stage2_vocabulary.dart` | `_getMockWords()` | stageData/lesson.content에서 로드, 빈 배열 시 `noVocabulary` 메시지 |
| `stage3_grammar.dart` | `_getGrammarPoints()` | stageData/lesson.content에서 로드, 빈 배열 시 `noGrammar` 메시지 |
| `stage4_practice.dart` | `_getMockQuestions()` | stageData에서 로드, 빈 배열 시 `noPractice` 메시지 |
| `stage5_dialogue.dart` | `_mockDialogues` | stageData/lesson.content에서 로드, 빈 배열 시 `noDialogue` 메시지 |
| `stage6_quiz.dart` | `_getMockQuestions()` | stageData/lesson.content에서 로드, 빈 배열 시 `noQuiz` 메시지 |
| `vocabulary_stage.dart` | `_mockWords` | lesson.content에서 로드, 빈 배열 시 빈 상태 표시 |
| `grammar_stage.dart` | `_mockGrammarPoints` | lesson.content에서 로드, 빈 배열 시 빈 상태 표시 |

### 3. native_comparison_card.dart 업데이트

- `NativeComparisonParser.fromJson()` 클래스 추가: API JSONB 데이터 파싱
- `customComparisons` prop 추가: API 데이터 전달용
- `KoreanCharacterComparisons` 유지: 오프라인 fallback용 하드코딩 데이터

### 4. HangulCharacterModel 확장

새로운 HiveField 추가:
```dart
@HiveField(15)
final Map<String, dynamic>? nativeComparisons;

@HiveField(16)
final String? mouthShapeUrl;

@HiveField(17)
final String? tonguePositionUrl;

@HiveField(18)
final Map<String, dynamic>? airFlowDescription;

@HiveField(19)
final List<int>? similarCharacterIds;
```

### 5. hangul_character_detail.dart 업데이트

`NativeComparisonCard` 위젯 추가하여 발음 비교 표시:
```dart
NativeComparisonCard(
  character: character.character,
  customComparisons: character.nativeComparisons != null
      ? NativeComparisonParser.fromJson(character.nativeComparisons)
      : null,
),
```

### 6. Backend Hangul Model 업데이트

`hangul.model.js`의 `findAll`, `findById`, `findByType`, `getAlphabetTable` 메서드에 pronunciation guide JOIN 추가:
```sql
LEFT JOIN hangul_pronunciation_guides pg ON hc.id = pg.character_id
```

반환 필드 추가:
- `mouth_shape_url`
- `tongue_position_url`
- `air_flow_description`
- `native_comparisons`
- `similar_character_ids`

## 빈 상태 처리 패턴

데이터가 없을 때 통일된 UI 표시:
```dart
Widget _buildEmptyState(AppLocalizations l10n) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(l10n.noContent, style: TextStyle(color: Colors.grey.shade600)),
        const SizedBox(height: 24),
        ElevatedButton(onPressed: _goToNext, child: Text(l10n.continueButton)),
      ],
    ),
  );
}
```

## 데이터 로딩 우선순위

1. `stageData` (레슨 스테이지별 데이터)
2. `lesson.content` (레슨 전체 콘텐츠)
3. 빈 배열 반환 (데이터 없음 상태)

## 테스트 방법

### DB 시드 적용
```bash
docker-compose exec postgres psql -U lemon -d lemonkorean -f /docker-entrypoint-initdb.d/06_vocabulary_seed.sql
docker-compose exec postgres psql -U lemon -d lemonkorean -f /docker-entrypoint-initdb.d/07_grammar_seed.sql
docker-compose exec postgres psql -U lemon -d lemonkorean -f /docker-entrypoint-initdb.d/09_pronunciation_comparison_seed.sql
```

### API 테스트
```bash
curl http://localhost:3002/api/content/hangul/characters/1
curl http://localhost:3002/api/content/hangul/table
```

### 앱 테스트
1. 레슨 화면에서 각 스테이지 정상 로드 확인
2. 설정에서 언어 변경 후 콘텐츠 번역 확인
3. 한글 문자 상세 화면에서 발음 비교 카드 표시 확인

## 관련 파일

- `/database/postgres/init/06_vocabulary_seed.sql`
- `/database/postgres/init/07_grammar_seed.sql`
- `/database/postgres/init/08_dialogue_seed.js`
- `/database/postgres/init/09_pronunciation_comparison_seed.sql`
- `/mobile/lemon_korean/lib/presentation/screens/lesson/stages/*.dart`
- `/mobile/lemon_korean/lib/presentation/screens/hangul/widgets/native_comparison_card.dart`
- `/mobile/lemon_korean/lib/presentation/screens/hangul/hangul_character_detail.dart`
- `/mobile/lemon_korean/lib/data/models/hangul_character_model.dart`
- `/services/content/src/models/hangul.model.js`
