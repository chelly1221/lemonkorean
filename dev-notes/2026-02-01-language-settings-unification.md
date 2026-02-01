---
date: 2026-02-01
category: Mobile
title: 언어 설정 통합 - 중국어 간체/번체를 앱 언어에 통합
author: Claude Opus 4.5
tags: [language, settings, chinese, ui-improvement]
priority: medium
---

# 언어 설정 통합 - 중국어 간체/번체를 앱 언어에 통합

## 개요
중국어 표시 설정 섹션을 제거하고, 앱 언어 목록에서 중국어(간체자)와 중국어(번체자)를 별도 옵션으로 표시하도록 통합했습니다. 사용자가 중국어 언어를 선택하면 자동으로 해당 간체/번체 변환이 적용됩니다.

## 문제/배경
기존에는 언어 설정 화면에 두 개의 섹션이 있었습니다:
1. **앱 언어 섹션**: 중국어, 한국어, 영어, 일본어, 스페인어
2. **중국어 표시 섹션**: 간체중국어, 번체중국어

이 구조는 사용자에게 혼란을 줄 수 있었습니다. 중국어를 선택한 후 별도로 간체/번체를 선택해야 했기 때문입니다.

## 해결책/구현
앱 언어 목록에서 중국어를 두 개의 옵션으로 분리하여 통합:
- 🇨🇳 中文(简体) - 중국어(간체자)
- 🇹🇼 中文(繁體) - 중국어(번체자)

### 주요 변경 사항

1. **AppLanguage enum 수정**: `zh` → `zhCN`, `zhTW` 두 개로 분리
2. **setAppLanguage 메서드**: 중국어 언어 선택 시 자동으로 ChineseVariant 설정
3. **중국어 표시 섹션 제거**: 별도 섹션 삭제로 UI 간소화
4. **깃발 이모지 업데이트**: 대만 깃발(🇹🇼) 추가

## 변경된 파일

### 1. settings_provider.dart
`/home/sanchan/lemonkorean/mobile/lemon_korean/lib/presentation/providers/settings_provider.dart`

```dart
// Before
enum AppLanguage {
  zh('zh', '中文', '중국어'),
  ko('ko', '한국어', '한국어'),
  ...
}

// After
enum AppLanguage {
  zhCN('zh_CN', '中文(简体)', '중국어(간체자)'),
  zhTW('zh_TW', '中文(繁體)', '중국어(번체자)'),
  ko('ko', '한국어', '한국어'),
  ...
}
```

**setAppLanguage 메서드 자동 변환 추가:**
```dart
Future<void> setAppLanguage(AppLanguage language) async {
  // ... 기존 코드 ...

  // 언어 선택에 따라 자동으로 ChineseVariant 설정
  if (language == AppLanguage.zhCN) {
    _chineseVariant = ChineseVariant.simplified;
    await LocalStorage.saveSetting(
      SettingsKeys.chineseVariant,
      ChineseVariant.simplified.name,
    );
  } else if (language == AppLanguage.zhTW) {
    _chineseVariant = ChineseVariant.traditional;
    await LocalStorage.saveSetting(
      SettingsKeys.chineseVariant,
      ChineseVariant.traditional.name,
    );
  }
  // ...
}
```

### 2. language_settings_screen.dart
`/home/sanchan/lemonkorean/mobile/lemon_korean/lib/presentation/screens/settings/language_settings_screen.dart`

- 중국어 표시 섹션 전체 삭제 (약 130줄)
- Info Box 삭제
- `_getFlagEmoji` 메서드 수정: `zhCN` → 🇨🇳, `zhTW` → 🇹🇼

### 3. settings_keys.dart
`/home/sanchan/lemonkorean/mobile/lemon_korean/lib/core/constants/settings_keys.dart`

- `defaultAppLanguage` 값을 `'zh'` → `'zh_CN'`으로 변경
- 주석 업데이트

## 테스트

### 웹 빌드 확인
```bash
cd mobile/lemon_korean
flutter build web
# ✓ Built build/web
```

### UI 검증 방법
1. 웹앱 `/app/` 접속
2. 설정 → 언어 설정 진입
3. 6개 언어 옵션 확인:
   - 🇨🇳 中文(简体) - 중국어(간체자)
   - 🇹🇼 中文(繁體) - 중국어(번체자)
   - 🇰🇷 한국어 - 한국어
   - 🇺🇸 English - 영어
   - 🇯🇵 日本語 - 일본어
   - 🇪🇸 Español - 스페인어
4. 중국어(간체자) 선택 시 앱 전체 간체자 표시 확인
5. 중국어(번체자) 선택 시 앱 전체 번체자 표시 확인

## 관련 참고사항

- 기존 `'zh'` 언어 코드를 저장한 사용자는 `fromCode` 메서드의 `orElse`에 의해 `zhCN`으로 자동 매핑됨
- ChineseVariant enum은 그대로 유지 (내부 변환 로직에 계속 사용)
- 백엔드 동기화 시 `language_preference`와 `app_language` 둘 다 전송됨
