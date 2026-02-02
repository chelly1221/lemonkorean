---
date: 2026-02-02
category: Mobile
title: 온보딩 기능 구현 완료
author: Claude Sonnet 4.5
tags: [onboarding, ux, flutter, first-run-experience]
priority: high
---

# 온보딩 기능 구현 완료

## 개요
최초 설치/방문 시에만 나타나는 레몬 캐릭터 기반 온보딩 화면을 구현했습니다. 웹 버전은 localStorage로, 모바일은 Hive로 방문 여부를 기록하여 한 번만 표시됩니다.

## 구현된 기능

### 1. 2단계 온보딩 플로우

#### 1단계: 언어 선택 화면 (`LanguageSelectionScreen`)
- 6개 언어 중 선택 (중국어 간체/번체, 한국어, 영어, 일본어, 스페인어)
- 레몬 캐릭터 표시
- 건너뛰기 버튼 (우측 상단)
- 애니메이션: fade-in, scale, slide

#### 2단계: 환영 + 레벨 선택 화면 (`WelcomeLevelScreen`)
- 손 흔드는 레몬 캐릭터
- 환영 메시지 (한국어)
- 4개 레벨 선택 카드:
  - 🌱 입문: 한글부터 시작
  - 🍋 초급: 기초 회화
  - 🚀 중급: 자연스러운 표현
  - 🏆 고급: 디테일한 표현
- 건너뛰기 버튼
- 애니메이션: 순차적 fade-in + slide

### 2. 레몬 캐릭터 위젯 (`LemonCharacter`)

CustomPaint를 사용하여 다양한 표정의 레몬 캐릭터 구현:
- `welcome`: 기본 친근한 표정
- `waving`: 손 흔드는 모습
- `thinking`: 생각하는 표정
- `encouraging`: 응원하는 표정

**특징:**
- 완전히 코드로 그려진 벡터 그래픽 (SVG 파일 불필요)
- 크기 조절 가능 (`size` 파라미터)
- 애니메이션 친화적

### 3. 레벨 선택 카드 위젯 (`LevelSelectionCard`)

재사용 가능한 선택 카드 컴포넌트:
- 아이콘, 레벨명, 설명 표시
- 선택 상태 하이라이트 (노란 테두리 + 배경)
- 탭 애니메이션
- 체크 아이콘 표시

### 4. 설정 관리 확장

#### `SettingsKeys` 추가
```dart
static const String onboardingCompleted = 'onboarding_completed';
static const String userLevel = 'user_level';
static const bool defaultOnboardingCompleted = false;
```

#### `SettingsProvider` 확장
- `hasCompletedOnboarding` getter
- `userLevel` getter
- `completeOnboarding()` 메서드
- `setUserLevel(String level)` 메서드
- 백엔드 동기화에 `user_level` 포함

### 5. SplashScreen 통합

`main.dart`의 `_checkAuth()` 메서드 수정:
```dart
// 온보딩 완료 여부 체크
if (!settingsProvider.hasCompletedOnboarding) {
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
      builder: (context) => const LanguageSelectionScreen(),
    ),
  );
  return;
}
```

**플로우:**
```
SplashScreen (1.5초)
  ↓
설정 초기화
  ↓
온보딩 완료 여부 체크
  ├─ 미완료 → LanguageSelectionScreen → WelcomeLevelScreen → LoginScreen
  └─ 완료 → (기존 플로우) LoginScreen/HomeScreen
```

## 생성된 파일

1. `/lib/presentation/screens/onboarding/language_selection_screen.dart` (165줄)
   - 1단계 언어 선택 화면

2. `/lib/presentation/screens/onboarding/welcome_level_screen.dart` (168줄)
   - 2단계 환영 + 레벨 선택 화면

3. `/lib/presentation/screens/onboarding/widgets/lemon_character.dart` (265줄)
   - 레몬 캐릭터 CustomPaint 위젯

4. `/lib/presentation/screens/onboarding/widgets/level_selection_card.dart` (82줄)
   - 레벨 선택 카드 위젯

## 수정된 파일

1. `/lib/core/constants/settings_keys.dart`
   - 온보딩 관련 상수 추가

2. `/lib/presentation/providers/settings_provider.dart`
   - 온보딩 상태 관리 기능 추가
   - 백엔드 동기화에 user_level 포함

3. `/lib/main.dart`
   - SplashScreen에서 온보딩 체크 로직 추가
   - LanguageSelectionScreen import 추가

## 기술적 세부사항

### 저장소 전략
- **웹**: localStorage에 `lk_onboarding_completed` 저장
- **모바일**: Hive settingsBox에 저장
- **추상화**: `LocalStorage` 클래스로 플랫폼 차이 흡수

### 애니메이션
- 패키지: `flutter_animate` ^4.5.0 (이미 설치됨)
- 화면 전환: SlideTransition (우→좌, 300ms)
- 레몬 캐릭터: scale + fadeIn
- 텍스트/카드: 순차적 fadeIn + slideY/slideX (100ms 간격)

### 스타일링
- Primary Color: `#FFD700` (레몬 노란색)
- Accent Color: `#FF9800` (주황색)
- Secondary Color: `#4CAF50` (초록색, 잎사귀)
- 폰트: NotoSansKR
- 버튼: 12px border-radius

### 레벨 값
서버로 전송되는 `user_level` 값:
- `beginner`: 입문
- `elementary`: 초급
- `intermediate`: 중급
- `advanced`: 고급

## 플랫폼 호환성

### 웹
- ✅ localStorage 저장 확인
- ✅ 온보딩 표시/건너뛰기 정상 작동
- ✅ 브라우저 변경 시 재표시 (정상 동작)

### 모바일 (Android/iOS)
- ✅ Hive 저장 확인
- ✅ 온보딩 표시/건너뛰기 정상 작동
- ✅ 앱 재설치 시 재표시 (정상 동작)

## Edge Cases 처리

1. **스토리지 클리어 시**: 온보딩 재표시 (정상 동작)
2. **중간에 앱 종료**: 다음 실행 시 온보딩 재표시
3. **건너뛰기 클릭**: 즉시 LoginScreen으로 이동, onboarding_completed = true
4. **레벨 선택 안 하고 건너뛰기**: userLevel = null (나중에 프로필에서 설정 가능)
5. **로그아웃 시**: 온보딩 상태 유지 (다시 표시 안 함)

## 테스트 방법

### 첫 설치 시나리오
```bash
flutter clean
flutter pub get
flutter run
```

예상 동작:
1. SplashScreen 표시 (1.5초)
2. LanguageSelectionScreen으로 자동 이동
3. 언어 선택 → "다음" 클릭
4. WelcomeLevelScreen 표시
5. 레벨 선택 (선택적) → "시작하기" 클릭
6. LoginScreen으로 이동
7. 앱 재실행 시 온보딩 건너뜀

### 스토리지 초기화 테스트
```bash
# 웹
개발자 도구 → Application → Local Storage 삭제 → 새로고침

# 모바일
설정 → 앱 정보 → 저장공간 삭제 → 재실행
```

## 향후 개선 사항

1. ✨ 온보딩 내용 다국어 번역 (현재 한국어 하드코딩)
2. ✨ 더 다양한 레몬 표정/포즈 추가
3. ✨ 설정 화면에 "온보딩 다시 보기" 기능
4. ✨ 레벨별 맞춤 레슨 추천 로직
5. ✨ 온보딩 진행 상황 서버 동기화 (Analytics)

## 코드 품질

- ✅ Flutter analyze: 모든 이슈 해결
- ✅ 지원되지 않는 `withOpacity()` → 상수 색상 코드로 교체
- ✅ Required 파라미터 순서 수정
- ✅ 주석 추가로 코드 가독성 향상

## 성능 고려사항

- CustomPaint 사용으로 이미지 로딩 불필요 → 빠른 렌더링
- 애니메이션 Duration 최적화 (200-500ms)
- 화면 전환 시 불필요한 위젯 트리 재빌드 최소화
- LocalStorage 비동기 I/O 최소화

## 사용자 경험 개선

1. **친근한 캐릭터**: 레몬 캐릭터로 부담 없는 첫인상
2. **명확한 진행**: 2단계로 간결하게 구성
3. **자유로운 선택**: 언제든 건너뛰기 가능
4. **부드러운 전환**: 애니메이션으로 자연스러운 플로우
5. **선택적 레벨**: 레벨 선택 안 해도 진행 가능

## 백엔드 통합

### 서버로 전송되는 데이터
```json
{
  "user_id": 123,
  "app_language": "zh_CN",
  "user_level": "elementary",
  ...
}
```

### 동기화 시점
1. 온보딩에서 레벨 선택 시 (`setUserLevel()`)
2. 이후 모든 설정 변경 시 (`_syncPreferencesToBackend()`)
3. 로그인 후 자동 동기화

### 오프라인 지원
- 비로그인 상태에서도 로컬 저장
- 로그인 후 서버로 동기화
- 네트워크 오류 시 sync queue에 추가

## 결론

온보딩 기능이 성공적으로 구현되었습니다. 사용자는 앱을 처음 실행할 때 레몬 캐릭터의 안내를 받으며 언어와 레벨을 선택할 수 있고, 이후 실행 시에는 온보딩을 건너뛰고 바로 로그인/홈 화면으로 이동합니다.

**핵심 성과:**
- ✅ 사용자 친화적인 첫 실행 경험
- ✅ 웹/모바일 크로스 플랫폼 지원
- ✅ 오프라인 우선 저장 방식
- ✅ 레몬 캐릭터 브랜딩 강화
- ✅ 유연한 건너뛰기 옵션

**파일 통계:**
- 새로 생성: 4개 파일 (680줄)
- 수정: 3개 파일
- 분석 결과: 이슈 없음
