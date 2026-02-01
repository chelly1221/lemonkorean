---
date: 2026-02-01
category: Mobile
title: 다국어 지원 (i18n) 구현 - 6개 언어
author: Claude Opus 4.5
tags: [i18n, localization, flutter, multi-language]
priority: high
---

# 다국어 지원 (i18n) 구현

## 개요
Flutter 앱에 6개 언어 지원을 구현했습니다. 기존의 중국어(간체/번체)에 한국어, 영어, 일본어, 스페인어 번역을 추가하고, main.dart의 locale 선택 로직을 수정했습니다.

## 문제 / 배경
- 기존에는 `app_zh.arb` (간체 중국어)와 `app_zh_TW.arb` (번체 중국어) 두 가지 언어만 지원
- `SettingsProvider`에 `AppLanguage` enum이 6개 언어를 정의하고 있었으나 실제 번역 파일이 없었음
- `main.dart`의 locale 선택 로직이 `ChineseVariant`만 참조하여 `AppLanguage` 설정이 무시되는 버그 존재

## 솔루션 / 구현

### 1. ARB 파일 생성 (4개 새 파일)
각 ARB 파일에 206개의 번역 키를 포함:

| 파일 | 언어 | 설명 |
|------|------|------|
| `app_ko.arb` | 한국어 | 자연스러운 한국어 UI 텍스트 |
| `app_en.arb` | 영어 | 표준 영어 UI 관례 따름 |
| `app_ja.arb` | 일본어 | 적절한 경어 사용 |
| `app_es.arb` | 스페인어 | 중립적 라틴 아메리카 스페인어 |

### 2. main.dart locale 로직 수정
`ChineseVariant` 기반에서 `AppLanguage` 기반으로 변경:

```dart
// Before: ChineseVariant만 참조
final locale = settings.chineseVariant == ChineseVariant.traditional
    ? const Locale('zh', 'TW')
    : const Locale('zh');

// After: AppLanguage 기반
Locale _getLocaleFromLanguage(AppLanguage language) {
  switch (language) {
    case AppLanguage.zhCN:
      return const Locale('zh');
    case AppLanguage.zhTW:
      return const Locale('zh', 'TW');
    case AppLanguage.ko:
      return const Locale('ko');
    case AppLanguage.en:
      return const Locale('en');
    case AppLanguage.ja:
      return const Locale('ja');
    case AppLanguage.es:
      return const Locale('es');
  }
}

// Consumer 내부
final locale = _getLocaleFromLanguage(settings.appLanguage);
```

## 변경된 파일

### 새 파일
- `/mobile/lemon_korean/lib/l10n/app_ko.arb` - 한국어 번역 (206개 키)
- `/mobile/lemon_korean/lib/l10n/app_en.arb` - 영어 번역 (206개 키)
- `/mobile/lemon_korean/lib/l10n/app_ja.arb` - 일본어 번역 (206개 키)
- `/mobile/lemon_korean/lib/l10n/app_es.arb` - 스페인어 번역 (206개 키)

### 수정된 파일
- `/mobile/lemon_korean/lib/main.dart` - locale 선택 로직 변경

### 자동 생성된 파일
- `/mobile/lemon_korean/lib/l10n/generated/app_localizations.dart` - 메인 localization 클래스
- `/mobile/lemon_korean/lib/l10n/generated/app_localizations_ko.dart` - 한국어
- `/mobile/lemon_korean/lib/l10n/generated/app_localizations_en.dart` - 영어
- `/mobile/lemon_korean/lib/l10n/generated/app_localizations_ja.dart` - 일본어
- `/mobile/lemon_korean/lib/l10n/generated/app_localizations_es.dart` - 스페인어

## 번역 키 카테고리

| 카테고리 | 키 수 | 예시 |
|---------|-------|------|
| 인증 | 16 | login, register, email, password |
| 오류 메시지 | 5 | networkError, invalidCredentials |
| 설정 | 30+ | languageSettings, notificationSettings |
| 도움말 | 24 | helpCenter, faq, howToDownload |
| 학습 콘텐츠 | 50+ | lessonContent, words, grammarPoints |
| 퀴즈 | 35+ | listenAndChoose, excellent, score |
| UI 네비게이션 | 20+ | home, lessons, review, profile |
| 공통 액션 | 15+ | cancel, confirm, delete, save |
| 문법 용어 | 10+ | noun, verb, adjective, particle |
| 상태 | 10+ | notStarted, inProgress, completed |

## 테스트

### 빌드 검증
```bash
cd mobile/lemon_korean
flutter gen-l10n
flutter build web --release
# ✓ Built build/web
```

### 생성된 supportedLocales 확인
```dart
static const List<Locale> supportedLocales = <Locale>[
  Locale('en'),
  Locale('es'),
  Locale('ja'),
  Locale('ko'),
  Locale('zh'),
  Locale('zh', 'TW')
];
```

### 앱에서 테스트 방법
1. 앱 실행
2. 설정 → 언어 설정으로 이동
3. 각 언어 선택 (중국어 간체, 중국어 번체, 한국어, 영어, 일본어, 스페인어)
4. UI 텍스트가 선택한 언어로 변경되는지 확인

## 관련 사항

### SettingsProvider의 AppLanguage enum
```dart
enum AppLanguage {
  zhCN('zh_CN', '中文(简体)', '중국어(간체자)'),
  zhTW('zh_TW', '中文(繁體)', '중국어(번체자)'),
  ko('ko', '한국어', '한국어'),
  en('en', 'English', '영어'),
  ja('ja', '日本語', '일본어'),
  es('es', 'Español', '스페인어');
  // ...
}
```

### ChineseVariant와의 연동
`SettingsProvider.setAppLanguage()` 메서드에서 `zhCN` 또는 `zhTW` 선택 시 `ChineseVariant`도 자동으로 설정됩니다. 이는 중국어 콘텐츠 표시에 영향을 미칩니다.

## 향후 개선 사항
- 언어별 폰트 최적화 (일본어, 한국어용 폰트 추가 고려)
- 우측에서 좌측(RTL) 언어 지원 시 레이아웃 조정 필요
- 번역 품질 검수 및 네이티브 스피커 리뷰 권장
