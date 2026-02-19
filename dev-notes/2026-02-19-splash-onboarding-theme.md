---
date: 2026-02-19
category: Mobile
title: 스플래시 화면 온보딩 테마 적용
author: Claude Opus 4.6
tags: [splash, onboarding, theme, ui, animation]
priority: medium
---

## 변경 요약

스플래시 화면을 온보딩 테마(Toss 스타일)와 시각적으로 일치시키기 위해 전면 재설계.

## 변경 내용

### 1. `lib/main.dart` — Flutter 스플래시 위젯

- **임포트 추가**: `flutter_animate`, `flutter_svg`
- **배경**: `#FFEF5F` (단색 노란) → `#FEFFF4` (크림색) + 방사형 그라데이션 오버레이 (`#FFEF7E` 50% opacity)
- **로고**: 🍋 이모지 (120x120 흰 박스) → `moni_mascot.svg` (screenHeight * 0.22)
- **제목 색상**: `#001F3F` (남색) → `#43240D` (따뜻한 브라운)
- **부제목 색상**: `#003366` (남색) → `#907866` (연한 브라운)
- **폰트**: 기본 → Pretendard, letterSpacing -0.8 (제목) / -0.2 (부제)
- **스피너**: 흰색 기본 크기 → `#DEB887` (버얼우드), 28x28, strokeWidth 3
- **크기**: 고정 px → 반응형 (screenWidth/screenHeight 비율)
- **애니메이션**: flutter_animate — scale+fadeIn (마스코트), fadeIn+slideY (텍스트), fadeIn (스피너)
- **그라데이션 패턴**: `account_choice_screen.dart` 재사용 (scaleY 0.65, screenWidth * 1.2)

### 2. `web/index.html` — 웹 스플래시 동기화

- `theme-color` meta: `#FFEF5F` → `#FEFFF4`
- CSS body background: `#FFEF5F` → `#FEFFF4`
- Pretendard CDN import 추가
- 그라데이션 배경 `div.gradient-bg` 추가
- 🍋 이모지 → `<img src="assets/assets/images/moni_mascot.svg">` (22vh)
- 텍스트 색상/폰트 동기화
- CSS 애니메이션: mascotIn, textIn, fadeIn
- Desktop 미디어 쿼리로 폰트 크기 클램핑

### 3. `web/manifest.json` — PWA 색상

- `background_color`, `theme_color`: `#FFEF5F` → `#FEFFF4`

### 4. `android/.../values/colors.xml` — Android 네이티브 스플래시

- `lemon_yellow`: `#FFEF5F` → `#FFFEFFF4` (AARRGGBB 형식)

## 영향 범위

- `launch_background.xml`은 `@color/lemon_yellow` 참조이므로 자동 반영
- `app_constants.dart`의 `primaryColor`는 변경하지 않음 (앱 전체 테마에서 사용)
- `pubspec.yaml` 변경 불필요 (flutter_animate, flutter_svg 이미 의존성에 포함)
