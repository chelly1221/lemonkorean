---
date: 2026-02-03
category: Mobile
title: 국제화 - 데이터 모델 디스플레이 문자열
author: Claude Opus 4.5
tags: [i18n, l10n, flutter, localization]
priority: medium
---

# 국제화 - 데이터 모델 디스플레이 문자열

## 개요
데이터 모델의 하드코딩된 중국어 디스플레이 문자열을 국제화하기 위해 UI 레이어 헬퍼 확장 메서드를 구현했습니다.

## 문제점
다음 모델 파일들의 getter가 하드코딩된 중국어를 반환하고 있었음:
- `vocabulary_model.dart`: `partOfSpeechDisplay`, `similarityLevel`
- `progress_model.dart`: `timeSpentFormatted`, `statusDisplay`
- `progress_model.dart` (ReviewModel): `dueStatus`
- `hangul_progress_model.dart`: `masteryLevelName`
- `hangul_character_model.dart`: `typeDisplayName`

## 해결방안
모델 파일을 직접 수정하는 대신 UI 레이어에 확장 메서드를 생성하여 `AppLocalizations`를 받아 지역화된 문자열을 반환하도록 함.

### 새로 생성된 파일
**`lib/presentation/utils/localized_display.dart`**
- `VocabularyModelL10n` 확장: `getPartOfSpeechDisplay()`, `getSimilarityLevelDisplay()`
- `ProgressModelL10n` 확장: `getTimeSpentDisplay()`, `getStatusDisplay()`
- `ReviewModelL10n` 확장: `getDueStatusDisplay()`
- `HangulProgressModelL10n` 확장: `getMasteryLevelDisplay()`
- `HangulCharacterModelL10n` 확장: `getTypeDisplay()`
- `LocalizedDisplay` 정적 클래스: 모델 인스턴스 없이 raw 값만 있을 때 사용

### 추가된 l10n 키
모든 6개 ARB 파일에 시간 형식 키 추가:
- `timeFormatHMS`: 시, 분, 초 형식 (예: "1h 30m 45s")
- `timeFormatMS`: 분, 초 형식 (예: "30m 45s")
- `timeFormatS`: 초만 형식 (예: "45s")

### 수정된 파일
1. **`continue_lesson_card.dart`**
   - `progress.timeSpentFormatted` → `progress.getTimeSpentDisplay(l10n)` 변경
   - `localized_display.dart` import 추가

2. **`hangul_character_detail.dart`**
   - `_getLocalizedTypeName()` 메서드의 기본 fallback 수정
   - `character.typeDisplayName` → `character.characterType`

3. **`vocabulary_book_review_screen.dart`**
   - 사용하지 않는 `bilingual_text.dart` import 제거

## 사용 방법

### 확장 메서드 사용
```dart
import 'presentation/utils/localized_display.dart';

// VocabularyModel 확장
final posDisplay = vocabulary.getPartOfSpeechDisplay(l10n);
final similarityDisplay = vocabulary.getSimilarityLevelDisplay(l10n);

// ProgressModel 확장
final timeDisplay = progress.getTimeSpentDisplay(l10n);
final statusDisplay = progress.getStatusDisplay(l10n);

// ReviewModel 확장
final dueDisplay = review.getDueStatusDisplay(l10n);

// HangulProgressModel 확장
final masteryDisplay = hangulProgress.getMasteryLevelDisplay(l10n);

// HangulCharacterModel 확장
final typeDisplay = hangulChar.getTypeDisplay(l10n);
```

### 정적 헬퍼 사용 (raw 값만 있을 때)
```dart
// 품사
final pos = LocalizedDisplay.partOfSpeech('noun', l10n);

// 진도 상태
final status = LocalizedDisplay.progressStatus('in_progress', l10n);

// 숙달도
final mastery = LocalizedDisplay.masteryLevel(3, l10n);

// 한글 문자 유형
final type = LocalizedDisplay.hangulType('basic_consonant', l10n);

// 시간 형식
final time = LocalizedDisplay.timeSpent(3665, l10n); // "1h 1m 5s"
```

## 기존 모델 getter 유지
기존 모델의 getter(`partOfSpeechDisplay`, `timeSpentFormatted` 등)는 삭제하지 않고 유지함.
이유:
1. 하위 호환성 유지
2. 기존 코드에서 사용 중일 수 있음
3. 테스트/디버깅 용도로 유용

## 테스트
- `flutter gen-l10n` 성공
- `flutter analyze lib/` - 관련 에러 없음
- 6개 언어 모두 ARB 파일 업데이트 완료 (ko, en, zh, zh_TW, ja, es)
