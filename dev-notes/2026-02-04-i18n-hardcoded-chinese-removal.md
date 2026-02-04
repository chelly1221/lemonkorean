---
date: 2026-02-04
category: Mobile
title: 하드코딩된 중국어 문자열 국제화 처리
author: Claude Opus 4.5
tags: [i18n, localization, flutter, refactoring]
priority: high
---

## 개요

앱 전체에서 하드코딩된 중국어 문자열을 찾아 국제화 처리했습니다.

## 변경 내용

### 1. 모델 파일 - Deprecated 처리

다음 모델들의 중국어 반환 getter에 `@deprecated` 주석 추가:

| 파일 | Getter | 대체 메서드 |
|------|--------|-------------|
| `progress_model.dart` | `timeSpentFormatted` | `getTimeSpentDisplay(l10n)` |
| `progress_model.dart` | `statusDisplay` | `getStatusDisplay(l10n)` |
| `progress_model.dart` (ReviewModel) | `dueStatus` | `getDueStatusDisplay(l10n)` |
| `hangul_character_model.dart` | `typeDisplayName` | `getTypeDisplay(l10n)` |
| `vocabulary_model.dart` | `partOfSpeechDisplay` | `getPartOfSpeechDisplay(l10n)` |
| `vocabulary_model.dart` | `similarityLevel` | `getSimilarityLevelDisplay(l10n)` |
| `hangul_progress_model.dart` | `masteryLevelName` | `getMasteryLevelDisplay(l10n)` |

**참고**: 국제화된 버전은 이미 `lib/presentation/utils/localized_display.dart`에 구현되어 있음.

### 2. Quiz/Practice 스테이지 - l10n 사용으로 변경

UI 프롬프트를 l10n 키로 변경:

| 파일 | 변경 내용 |
|------|-----------|
| `quiz_stage.dart` | 질문 프롬프트 l10n 사용 (`listenAndChoose`, `fillInBlank` 등) |
| `stage3_grammar.dart` | 문법 제목 l10n 사용 (`topicParticle`, `honorificEnding` 등) |
| `stage4_practice.dart` | 연습 문제 프롬프트 l10n 사용 |
| `stage6_quiz.dart` | 퀴즈 질문 프롬프트 l10n 사용 |

### 3. Hangul 관련

| 파일 | 변경 내용 |
|------|-----------|
| `hangul_character_detail.dart` | 공유 텍스트 `#柠檬韩语` → `#${l10n.appName}` |

### 4. Mock 데이터 - TODO 주석 추가

다음 파일들의 mock 데이터에 백엔드 API로 대체 필요하다는 TODO 주석 추가:

- `vocabulary_stage.dart` - 단어 콘텐츠
- `stage2_vocabulary.dart` - 단어 콘텐츠
- `grammar_stage.dart` - 문법 설명 콘텐츠
- `stage5_dialogue.dart` - 대화 콘텐츠
- `native_comparison_card.dart` - 발음 비교 데이터

**중요**: 이 콘텐츠들은 학습 데이터로, 중국어 사용자를 위한 fallback입니다.
실제 다국어 지원을 위해서는 백엔드 API에서 사용자 언어에 맞는 콘텐츠를 제공해야 합니다.

### 5. 문서 업데이트

- `data/README.md` - deprecated getter 대신 localized_display.dart 사용 안내

## 유지된 항목

다음은 의도적으로 하드코딩 유지:

1. **settings_provider.dart** - 언어 이름을 해당 언어로 표시 (예: `中文(简体)`, `日本語`)
2. **l10n/generated/*.dart** - 번역 파일 (정상)
3. **콘텐츠 데이터** - 한국어 학습을 위한 번역/예문 (백엔드에서 제공 예정)

## 사용 방법

### Before (deprecated)
```dart
Text(progress.statusDisplay) // 중국어 고정
Text(review.dueStatus)       // 중국어 고정
```

### After (recommended)
```dart
import '../../presentation/utils/localized_display.dart';

final l10n = AppLocalizations.of(context)!;
Text(progress.getStatusDisplay(l10n)) // 언어에 따라 자동 변환
Text(review.getDueStatusDisplay(l10n)) // 언어에 따라 자동 변환
```

## 후속 작업

1. 백엔드 API에서 사용자 언어에 맞는 콘텐츠 제공 기능 구현
2. Mock 데이터를 실제 API 응답으로 대체
3. deprecated getter 사용처 완전 제거 (현재 미사용 확인됨)
