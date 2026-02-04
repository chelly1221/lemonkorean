---
date: 2026-02-04
category: Mobile
title: 앱 시작 화면 색상 통일 - 레몬 옐로우 일관성 개선
author: Claude Sonnet 4.5
tags: [ui, ux, branding, splash, onboarding, android]
priority: medium
---

# 앱 시작 화면 색상 통일 - 레몬 옐로우 일관성 개선

## 문제 상황

앱 시작 시 3단계의 화면 색상이 불일치하여 사용자 경험을 저해:

1. **안드로이드 네이티브 런치 스크린**: 흰색 (`#FFFFFF`)
2. **Flutter 스플래시 화면**: 레몬 크림 (`#FFF8E1`)
3. **온보딩 화면들**: 레몬 크림 (`#FFF8E1`)

앱을 시작하면 흰색 → 레몬 크림 → 온보딩 순서로 색상이 바뀌어 브랜드 일관성이 부족했습니다.

## 해결 방법

**원래 스플래시의 선명한 레몬 옐로우**(`#FFEF5F`)를 기준으로 전체 통일:

- 안드로이드 런치 스크린 → 레몬 옐로우
- Flutter 스플래시 → 레몬 옐로우 그라디언트 (원래대로 복원)
- 온보딩 화면들 → 레몬 옐로우

## 구현 내용

### 1. Flutter 스플래시 화면 복원

**파일**: `mobile/lemon_korean/lib/main.dart`

**변경 전** (레몬 크림 단색):
```dart
import 'presentation/screens/onboarding/utils/onboarding_colors.dart';

// ...

decoration: const BoxDecoration(
  color: OnboardingColors.backgroundYellow,
),
```

**변경 후** (레몬 옐로우 그라디언트):
```dart
// import 제거

decoration: BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppConstants.primaryColor,  // Color(0xFFFFEF5F)
      AppConstants.primaryColor.withOpacity(0.8),
    ],
  ),
),
```

### 2. 온보딩 배경색 변경

**파일**: `mobile/lemon_korean/lib/presentation/screens/onboarding/utils/onboarding_colors.dart`

```dart
// 변경 전
static const backgroundYellow = Color(0xFFFFF8E1);     // Lemon yellow background

// 변경 후
static const backgroundYellow = Color(0xFFFFEF5F);     // Bright lemon yellow background
```

**영향받는 화면** (자동 반영):
- `welcome_introduction_screen.dart`
- `language_selection_screen.dart`
- `level_selection_screen.dart`
- `weekly_goal_screen.dart`
- `welcome_level_screen.dart`
- `personalization_complete_screen.dart`
- `account_choice_screen.dart`

모두 `Scaffold(backgroundColor: OnboardingColors.backgroundYellow)`를 사용하므로 자동 적용됩니다.

### 3. 안드로이드 네이티브 런치 스크린

#### 색상 리소스 정의

**파일**: `mobile/lemon_korean/android/app/src/main/res/values/colors.xml` (신규 생성)

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <!-- Lemon Korean primary color - Bright lemon yellow -->
    <color name="lemon_yellow">#FFEF5F</color>
</resources>
```

#### Light Mode 런치 배경

**파일**: `mobile/lemon_korean/android/app/src/main/res/drawable/launch_background.xml`

```xml
<!-- 변경 전 -->
<item android:drawable="@android:color/white" />

<!-- 변경 후 -->
<item android:drawable="@color/lemon_yellow" />
```

#### Dark Mode 런치 배경

**파일**: `mobile/lemon_korean/android/app/src/main/res/drawable-v21/launch_background.xml`

```xml
<!-- 변경 전 -->
<item android:drawable="?android:colorBackground" />

<!-- 변경 후 -->
<item android:drawable="@color/lemon_yellow" />
```

## 수정된 파일

**Flutter (2개)**:
1. `mobile/lemon_korean/lib/main.dart`
2. `mobile/lemon_korean/lib/presentation/screens/onboarding/utils/onboarding_colors.dart`

**Android (3개)**:
3. `mobile/lemon_korean/android/app/src/main/res/values/colors.xml` (신규)
4. `mobile/lemon_korean/android/app/src/main/res/drawable/launch_background.xml`
5. `mobile/lemon_korean/android/app/src/main/res/drawable-v21/launch_background.xml`

**총 5개 파일** (1개 신규, 4개 수정)

## 검증 방법

### Flutter 검증

```bash
cd mobile/lemon_korean
flutter clean
flutter pub get
flutter run
```

확인 사항:
1. 스플래시 화면이 레몬 옐로우 그라디언트로 표시되는지
2. 온보딩 7개 화면이 모두 레몬 옐로우 배경인지
3. 스플래시 → 온보딩 전환 시 색상이 일관되는지

### Android 네이티브 런치 스크린 검증

```bash
cd mobile/lemon_korean
flutter build apk --debug
flutter install
```

확인 사항:
1. 앱 완전 종료 후 재시작
2. 앱 아이콘 클릭 시 가장 먼저 나타나는 네이티브 화면이 레몬 옐로우인지
3. 흰색 플래시가 없는지
4. 전체 플로우: 안드로이드 런치 (레몬 옐로우) → Flutter 스플래시 (레몬 옐로우) → 온보딩 (레몬 옐로우)

### 다크 모드 검증

1. Android 시스템 설정에서 다크 모드 활성화
2. 앱 재시작하여 런치 스크린이 여전히 레몬 옐로우인지 확인

## 기대 효과

✅ **완전한 색상 일관성**: 안드로이드 런치 → Flutter 스플래시 → 온보딩 전환이 자연스러워짐
✅ **흰색 플래시 제거**: 앱 시작 시 흰색 화면이 깜박이는 현상 제거
✅ **브랜드 강화**: 선명하고 활기찬 레몬 브랜드 이미지 일관성 확보
✅ **첫인상 개선**: 처음 사용자가 앱을 시작할 때 더 나은 경험 제공

## 잠재적 이슈 및 해결 방안

### 버튼 가시성 문제

배경색과 버튼 색상이 모두 `#FFEF5F`가 되어 버튼이 배경과 구분되지 않을 수 있습니다.

**현재 상태**:
- `OnboardingColors.backgroundYellow` = `#FFEF5F` (배경)
- `OnboardingColors.primaryYellow` = `#FFEF5F` (버튼)

**해결 방안** (필요시 적용):

1. **버튼을 흰색 배경 + 테두리로 변경**:
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    side: BorderSide(color: OnboardingColors.primaryYellow, width: 2),
    foregroundColor: OnboardingColors.textPrimary,
  ),
  // ...
)
```

2. **버튼을 더 진한 색상으로 변경**:
```dart
static const primaryYellow = Color(0xFFFFD600);  // Darker yellow
```

3. **버튼에 그림자 추가**:
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.2),
  ),
  // ...
)
```

실제 앱에서 테스트 후 필요한 경우 위 방안 중 하나를 선택하여 적용할 예정입니다.

## 색상 코드 참조

| 용도 | 색상명 | Hex | RGB |
|------|--------|-----|-----|
| 목표 색상 (레몬 옐로우) | Bright Lemon Yellow | `#FFEF5F` | 255, 239, 95 |
| 이전 온보딩 색상 | Lemon Cream | `#FFF8E1` | 255, 248, 225 |
| 이전 런치 색상 | White | `#FFFFFF` | 255, 255, 255 |

## 기술 노트

### Flutter 스플래시 vs 온보딩 색상 차이

- **스플래시**: `LinearGradient` 사용 - 위쪽이 밝고 아래로 갈수록 약간 어두워짐 (0.8 opacity)
- **온보딩**: 단색 (`Color(0xFFFFEF5F)`) 사용

이 차이는 의도적인 것으로, 스플래시는 짧은 전환 화면이므로 그라디언트로 시각적 흥미를 주고, 온보딩은 내용에 집중할 수 있도록 단색을 사용합니다.

### 안드로이드 런치 스크린 작동 방식

1. **네이티브 런치 스크린**: 앱 프로세스 시작 전 안드로이드 시스템이 표시 (XML 기반)
2. **Flutter 스플래시**: Flutter 엔진 초기화 중 표시 (Dart 기반)
3. **온보딩/홈**: 앱 로직에 따라 표시

런치 스크린은 Flutter보다 먼저 표시되므로 색상 일치가 중요합니다.

## 영향 범위

- **수정 파일**: 5개
- **영향받는 화면**: 10개 (런치 1 + 스플래시 1 + 온보딩 7 + 로그인/홈 간접 영향)
- **수정 라인 수**: ~20줄
- **리스크**: 낮음 (순수 시각적 변경, 동작 로직 변경 없음)
- **복원 가능성**: 쉬움 (Git revert 가능)

## 참고 문서

- `/mobile/lemon_korean/README.md` - Flutter 앱 구조
- `/CLAUDE.md` - 프로젝트 가이드
