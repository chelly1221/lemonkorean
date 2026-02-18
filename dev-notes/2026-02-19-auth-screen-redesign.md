---
date: 2026-02-19
category: Mobile
title: 로그인/회원가입 화면 전면 리디자인 및 온보딩 UX 개선
author: Claude Sonnet 4.6
tags: [auth, onboarding, ui, design-system, pretendard, svg]
priority: medium
---

## 개요

로그인(`login_screen.dart`)과 회원가입(`register_screen.dart`) 화면을 목업 디자인에 맞게 전면 리디자인했습니다. 온보딩 흐름도 단순화하여 불필요한 화면 2개를 제거했으며, 모든 화면의 백버튼을 통일했습니다.

---

## 변경 내용

### 1. 회원가입 화면 (`register_screen.dart`) 리디자인

**레이아웃 구조**:
- AppBar 없이 `SafeArea + Column` 구조로 변환
- 상단 백버튼 고정 + `Expanded(SingleChildScrollView)` 스크롤 영역 + 하단 버튼 고정

**타이포그래피**:
- 제목: "상큼한 한국어 여행, 지금 출발!" — Pretendard w500, `screenWidth * 0.046`, `#43240D`
- 부제목: "가볍게 출발해도 괜찮아! 내가 꽉 잡아줄게" — Pretendard w400, `screenWidth * 0.036`, `#7B7B7B`
- 필드 레이블 (별명/이메일/비밀번호): Pretendard w500, `screenWidth * 0.036`, `#43240D`
- 플레이스홀더: Pretendard w500, `screenWidth * 0.036`, `#B0A9A4`

**입력 필드**:
- 외곽선: `#E9E9E9` / 포커스: `#FFD600` (1.5px) / 에러: `AppConstants.errorColor`
- 배경색: `#FEFFF4`
- `border-radius: 5px`
- `_inputDecoration()` 헬퍼 메서드로 일관성 유지

**버튼**:
- 배경: `#FFEC6D` / 글씨: `#43240D`
- `border-radius: 10px`, 높이: `screenHeight * 0.05`
- `padding: EdgeInsets.zero` (텍스트 잘림 방지)

**링크 행**: "이미 계정이 있으신가요? `#888888` / 로그인하기 `#FFA323`"

### 2. 로그인 화면 (`login_screen.dart`) 리디자인

**레이아웃 구조**:
- 회원가입과 동일한 `SafeArea + Column` 구조
- 필드 레이블 없음 (플레이스홀더만 사용, 중앙 정렬)

**상단 아이콘 섹션**:
- `assets/images/login_icon.svg` (레몬 캐릭터 마스코트)
- 아이콘 위치: `screenHeight * 0.169` 상단 패딩
- 아이콘 크기: 높이 `screenHeight * 0.115`
- 제목: "레몬 한국어" — Pretendard w500, `screenWidth * 0.046`
- 부제목: "레몬처럼 상큼하게, 실력은 탄탄하게!"

**추가 요소**:
- 아이디찾기 / 비밀번호 재설정 링크 (구분선: `#E4E3E3`)
- 하단 링크 행: "계정이 없으신가요? / 회원가입하기"

### 3. 커스텀 눈 아이콘 SVG 생성

**파일**: `assets/images/icon_eye_open.svg`, `assets/images/icon_eye_off.svg`

- 기본 Material 아이콘보다 눈동자가 작은 커스텀 디자인 (원 반경 `r=1.9`)
- 눈 높이를 약간 좁힌 형태 (`M1 12s4-7 11-7 11 7 11 7-4 7-11 7-11-7-11-7z`)
- `currentColor` 사용으로 `ColorFilter.mode(#43240D, BlendMode.srcIn)` 적용 가능
- 아이콘 표시 크기: `screenWidth * 0.040`

### 4. 온보딩 흐름 단순화

**삭제된 화면**:
- `welcome_introduction_screen.dart` — 앱 소개 화면 제거
- `personalization_complete_screen.dart` — 개인화 완료 요약 화면 제거

**현재 온보딩 흐름 (4단계)**:
1. 언어 선택 (`language_selection_screen.dart`)
2. 레벨 선택 (`level_selection_screen.dart`)
3. 주간 목표 (`weekly_goal_screen.dart`)
4. 계정 선택 (`account_choice_screen.dart`) → 로그인 또는 회원가입

### 5. 백버튼 통일

모든 온보딩 및 인증 화면의 백버튼을 `Icons.arrow_back_ios_new`로 통일:
- `level_selection_screen.dart` — SVG 아이콘에서 Material 아이콘으로 교체
- `weekly_goal_screen.dart` — 동일하게 교체
- 크기: `screenWidth * 0.051`, 색상: `Colors.black87`

---

## 디자인 토큰 (공통 적용)

| 토큰 | 값 | 용도 |
|------|-----|------|
| 기본 배경 | `#FEFFF4` | 전체 배경, 입력 필드 채우기 |
| 주요 텍스트 | `#43240D` | 제목, 레이블, 버튼 텍스트 |
| 보조 텍스트 | `#7B7B7B` | 부제목 |
| 비활성 텍스트 | `#888888` | 링크 접두 문구 |
| 플레이스홀더 | `#B0A9A4` | 입력 힌트 |
| 강조 버튼 | `#FFEC6D` | 주 CTA 버튼 배경 |
| 포커스 테두리 | `#FFD600` | 입력 필드 포커스 상태 |
| 입력 테두리 | `#E9E9E9` | 기본 입력 필드 외곽선 |
| 링크 강조 | `#FFA323` | 주요 텍스트 링크 (회원가입/로그인) |
| 구분선 | `#E4E3E3` | 아이디찾기/비밀번호찾기 사이 세로선 |

**폰트**: Pretendard (w400/w500/w600)

---

## 상대 사이즈 패턴

모든 수치는 `MediaQuery.of(context).size`를 기반으로 한 상대값 사용:

```dart
final screenHeight = MediaQuery.of(context).size.height;
final screenWidth = MediaQuery.of(context).size.width;
final hMargin = screenWidth * 0.061;  // 좌우 여백
```

단, `border-radius`(5px, 10px)처럼 명시적으로 지정된 절대값은 그대로 유지.

---

## 관련 파일

- `lib/presentation/screens/auth/login_screen.dart`
- `lib/presentation/screens/auth/register_screen.dart`
- `lib/presentation/screens/onboarding/level_selection_screen.dart`
- `lib/presentation/screens/onboarding/weekly_goal_screen.dart`
- `assets/images/icon_eye_open.svg` (신규)
- `assets/images/icon_eye_off.svg` (신규)
- `assets/images/login_icon.svg` (신규, 레몬 마스코트)
