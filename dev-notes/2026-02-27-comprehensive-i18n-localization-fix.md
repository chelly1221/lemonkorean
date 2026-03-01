---
date: 2026-02-27
category: Mobile
title: 전체 앱 다국어(i18n) 누락 문자열 포괄적 수정
author: Claude Opus 4.6
tags: [i18n, l10n, localization, arb, flutter, multi-language]
priority: high
---

## 개요

앱 전체에서 하드코딩된 한국어/영어 문자열을 발견하여, 6개 언어(ko, en, es, ja, zh, zh_TW) ARB 파일 기반 l10n 시스템으로 전환. 언어 설정 기능은 오프라인에서도 동작하도록 SettingsProvider + LocalStorage(Hive) 기반으로 유지.

## 변경 범위

### 1. ARB 파일 확장 (6개 언어 모두)
- **~80개 이상의 새 l10n 키** 추가
- 카테고리: 인증, 유효성 검사, 오류/성공 메시지, 한글 스테이지 제목, UI 라벨, 음성 대화방, DM 등
- 파라미터 지원 키: `validationPasswordMinLength({minLength})`, `retryAttempt({current},{max})`, `noVocabularyForLevel({level})` 등

### 2. 인증 화면 (login_screen, register_screen, account_choice_screen)
- 약 25개 하드코딩 한국어 문자열 → `AppLocalizations` 호출로 전환
- `AuthProvider.localizeError()` 정적 메서드로 에러 코드 → 로컬라이즈 문자열 변환

### 3. Validators (core/utils/validators.dart)
- 모든 유효성 검사 메서드에 `{AppLocalizations? l10n}` 옵셔널 파라미터 추가
- 19개 하드코딩 한국어 유효성 메시지 → l10n 호출 (null 시 한국어 폴백)
- 기존 호출자(login_screen, register_screen)에서 `l10n` 전달하도록 업데이트

### 4. 에러 코드 시스템 (BuildContext 없는 핵심 유틸리티)
- **app_constants.dart**: 오류/성공 메시지 상수를 에러 코드 키(영문 식별자)로 변경
- **app_exception.dart**: 예외 기본 메시지를 에러 코드 키로 변경 (14개)
- **api_client.dart (_ErrorInterceptor)**: 5개 하드코딩 한국어 → 에러 코드 키
- **ErrorLocalizer** 유틸리티 신규 생성 (`core/utils/error_localizer.dart`)
  - 에러/성공 코드 키 → `AppLocalizations` 로컬라이즈 문자열 변환
  - UI 레이어에서 호출하여 사용

### 5. Provider 에러 메시지
- **social_provider.dart**: 6개 하드코딩 영어 에러 → 에러 코드 키
- **feed_provider.dart**: 2개 하드코딩 영어 에러 → 에러 코드 키
- **vocabulary_browser_provider.dart**: 1개 에러 → 에러 코드 키
- **voice_room_provider.dart**: 12개 하드코딩 영어 에러 → 에러 코드 키
- **dm_provider.dart**: 4개 하드코딩 UI 문자열 → 에러 코드 키

### 6. 한글/레슨 UI 화면
- 12개 한글 스테이지 레슨 목록 화면: AppBar 제목 l10n 적용
- home_screen, vocabulary_browser_screen, hangul_table_screen 등: 툴팁/라벨 l10n
- hangul_lesson_flow_screen: 다이얼로그 문자열 l10n
- step_*.dart (6개 파일): 에러/라벨 문자열 l10n
- step_speech_practice: 버튼 텍스트 ('다시 시도', '다음', '완료') l10n

### 7. DM/커뮤니티
- message_bubble.dart: 삭제 다이얼로그 l10n
- community_screen.dart: 빈 상태 문자열 l10n
- create_post_screen.dart: 태그 힌트 l10n

## 아키텍처 패턴

### BuildContext 없는 코드의 로컬라이제이션
```
[Core Layer] 에러 코드 키 저장 (예: 'errorServer')
     ↓
[Provider Layer] _errorMessage = 에러 코드 키
     ↓
[UI Layer] ErrorLocalizer.localize(errorMessage, l10n) → 로컬라이즈 문자열
```

### Validators 로컬라이제이션
```dart
// 옵셔널 l10n 파라미터 → null이면 한국어 폴백
validator: (value) => Validators.emailValidator(value, l10n: l10n),
```

## 미완료 항목 (Low Priority)
- `hangul_level0_learning_screen.dart` 등 한글 커리큘럼 학습 콘텐츠 (3000+ 라인)
  - 데이터 주도 리팩터링 필요 (JSON/ARB 분리)
- `pronunciation_feedback.dart` - 언어별 피드백 맵 구조
- `bundled_learning_content.dart` - 번들 레슨 제목

## 빌드 검증
- `flutter gen-l10n` ✅
- `flutter analyze` → **No issues found!** ✅
