---
date: 2026-02-19
category: Mobile
title: 앱 전체 테마를 온보딩 Toss 스타일로 통일
author: Claude Opus 4.6
tags: [theme, ui, onboarding, toss-style]
priority: high
---

## 변경 요약

온보딩 화면의 Toss 스타일 디자인(크림색 배경, 따뜻한 브라운 톤)을 앱 전체 테마로 통일.

## 색상 변경

| 속성 | 이전 | 이후 |
|------|------|------|
| `textPrimary` | `#212121` | `#191F28` |
| `textSecondary` | `#757575` | `#6B7684` |
| `textHint` | `#BDBDBD` | `#8B95A1` |
| `backgroundLight` | `#FAFAFA` | `#FEFFF4` |
| AppBar 배경 | primary (노란) | backgroundLight (크림) |
| AppBar 텍스트 | 흰색 | textPrimary (다크) |
| ElevatedButton 텍스트 | 흰색 | `#43240D` (브라운) |
| FAB 텍스트 | 흰색 | `#43240D` (브라운) |

## 수정 파일 (5개)

1. **`lib/data/models/app_theme_model.dart`** — `defaultTheme()` 색상 기본값 4개 변경
2. **`lib/core/constants/app_constants.dart`** — 컴파일 타임 색상 상수 4개 변경
3. **`lib/presentation/providers/theme_provider.dart`** — AppBar, ElevatedButton, FAB 스타일 변경
4. **`services/admin/src/controllers/app-theme.controller.js`** — `getSettings()` 및 `resetSettings()` 기본값 동기화
5. **`database/postgres/migrations/017_update_theme_to_toss_style.sql`** — 기존 DB 레코드 업데이트

## 변경하지 않은 것

- `primaryColor` (`#FFEF5F`) — 브랜드 색상 유지
- `OnboardingColors` — 이미 올바른 색상
- Lesson stage colors — 기능적 의미 유지
- 개별 화면 하드코딩 색상 — 후속 작업으로 분리

## 영향 범위

`Theme.of(context)`를 사용하는 모든 화면에 자동 적용됨:
- 홈, 설정, 레슨 목록, 프로필 등 주요 화면
- AppBar가 크림색 배경 + 어두운 텍스트로 변경
- 버튼이 노란 배경 + 브라운 텍스트로 변경
