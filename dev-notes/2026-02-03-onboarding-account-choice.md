---
date: 2026-02-03
category: Mobile
title: 온보딩 6단계 계정 선택 화면 추가
author: Claude Opus 4.5
tags: [onboarding, UX, authentication]
priority: medium
---

## 개요

온보딩 플로우를 5단계에서 6단계로 확장하여 별도의 계정 선택 화면을 추가했습니다.

## 변경 전 (5단계)

1. 언어 선택
2. 소개 화면
3. 레벨 선택
4. 주간 목표
5. **개인화 완료** (설정 요약 + 학습 시작 버튼 → 로그인 화면)

## 변경 후 (6단계)

1. 언어 선택
2. 소개 화면
3. 레벨 선택
4. 주간 목표
5. **개인화 완료** (설정 요약 + 다음 버튼)
6. **계정 선택** (로그인/회원가입 선택)

## 신규 파일

### `lib/presentation/screens/onboarding/account_choice_screen.dart`
- 새로운 6단계 화면
- 뒤로가기 버튼 포함
- 레몬 캐릭터 (waving 표현)
- 두 개의 버튼:
  - **"Log In"** (primary 스타일) → LoginScreen
  - **"Create Account"** (secondary 스타일) → RegisterScreen
- 온보딩 완료 처리 (`settingsProvider.completeOnboarding()`)

## 수정된 파일

### 1. `lib/presentation/screens/onboarding/widgets/onboarding_button.dart`
- `OnboardingButtonVariant` enum 추가 (primary, secondary)
- secondary 스타일: 투명 배경 + 테두리

### 2. `lib/presentation/screens/onboarding/personalization_complete_screen.dart`
- 로그인/회원가입 버튼 제거
- 단일 "다음" 버튼으로 변경 → AccountChoiceScreen으로 이동

### 3. 로컬라이제이션 파일 (6개 언어)
신규 문자열 추가:
- `onboardingAccountTitle`: "Ready to start?" / "准备好了吗？" / ...
- `onboardingAccountSubtitle`: "Log in or create an account to save your progress" / ...

### 4. `README.md`
- 온보딩 플로우 설명 업데이트 (5단계 → 6단계)
- 파일 목록에 account_choice_screen.dart 추가
- 파일 수 업데이트 (15개 → 16개)

## 빌드 및 배포

```bash
# 웹 빌드 및 배포 (NAS로 자동 동기화 + nginx 재시작)
cd /home/sanchan/lemonkorean/mobile/lemon_korean
./build_web.sh
```

## 테스트 방법

1. 앱 실행 후 온보딩 플로우 진행
2. 5단계(개인화 완료)에서 "다음" 버튼 탭
3. 6단계(계정 선택) 화면 확인
4. 뒤로가기 버튼으로 5단계로 복귀 가능
5. "Log In" → LoginScreen으로 이동
6. "Create Account" → RegisterScreen으로 이동
7. 여러 언어로 테스트

## UI 레이아웃

### 5단계: 개인화 완료
```
┌─────────────────────────────┐
│   [Lemon Character]         │
│                             │
│   "You're all set!"         │
│   "Let's start..."          │
│                             │
│   [Summary Card]            │
│   - Language: English       │
│   - Level: Beginner         │
│   - Goal: Casual            │
│                             │
│ ┌─────────────────────────┐ │
│ │        Next             │ │
│ └─────────────────────────┘ │
└─────────────────────────────┘
```

### 6단계: 계정 선택
```
┌─────────────────────────────┐
│ ← (back)                    │
│                             │
│   [Lemon Character]         │
│                             │
│   "Ready to start?"         │
│   "Log in or create..."     │
│                             │
│ ┌─────────────────────────┐ │
│ │      Log In             │ │ ← Primary
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │   Create Account        │ │ ← Secondary
│ └─────────────────────────┘ │
└─────────────────────────────┘
```
