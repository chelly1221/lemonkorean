---
date: 2026-02-16
category: Mobile
title: Level 0 한글 과수원 (Lemon Orchard) 적응형 대시보드
author: Claude Opus 4.6
tags: [hangul, level-0, ui, lemon-theme, adaptive-layout, l10n]
priority: high
---

## 변경 요약

레벨 0 (한글)의 레이아웃을 기존 지그재그 경로 방식에서 **레몬 과수원 테마 대시보드**로 전면 교체.

## 주요 변경 사항

### 1. 새 파일: `hangul_dashboard_view.dart`
**경로:** `lib/presentation/screens/home/widgets/hangul_dashboard_view.dart`

- **적응형 안내 카드**: 학습 상태에 따라 5단계로 변화
  - 초보 (learned == 0) → "학습 시작하기"
  - 학습 중 (0 < learned < total) → "다음 글자 배우기"
  - 복습 필요 (dueForReview > 0) → "지금 복습하기"
  - 실전 연습 (learned >= 85%) → "활동 시작"
  - 마스터 (mastered >= 85%) → "Level 1 시작"
  - **판정 우선순위:** 마스터 > 초보 > 복습 필요 > 실전 연습 > 학습 중

- **레몬 테마 자모 그리드**: 각 한글 자모가 레몬 모양으로 표시
  - 마스터리 레벨에 따라 색상 변화 (회색→연두→초록→노란초록→노랑→금색+발광)
  - 4개 섹션: 기본자음(🌿), 쌍자음(🌿), 기본모음(🌸), 복합모음(🌸)
  - 탭하면 `HangulCharacterDetailScreen`으로 이동

- **진도 레몬**: 안내 카드 좌측에 큰 레몬으로 진도율(%) 표시
  - 색상 보간: 0%=회색 → 50%=초록 → 100%=밝은 노랑

- `LemonShapePainter`, `HangulProvider`, `HangulStats` 재사용
- `ConstrainedBox(maxWidth: 600)` + `Center`로 웹 대응
- `flutter_animate`로 그룹별 페이드인 애니메이션

### 2. 수정: `home_screen.dart`
- `HangulPathView` → `HangulDashboardView` 교체
- `onLevelSelected` 콜백 전달 (마스터 단계에서 Level 1 이동용)

### 3. 다국어 문자열 추가 (6개 ARB 파일)
11개 새 키 추가: `hangulWelcome`, `hangulWelcomeDesc`, `hangulStartLearning`, `hangulLearnNext`, `hangulLearnedCount`, `hangulReviewNeeded`, `hangulReviewNow`, `hangulPracticeSuggestion`, `hangulStartActivities`, `hangulMastered`, `hangulGoToLevel1`

대상 파일: `app_en.arb`, `app_ko.arb`, `app_ja.arb`, `app_es.arb`, `app_zh.arb`, `app_zh_TW.arb`

## 기존 파일 영향
- `hangul_path_view.dart`: 더 이상 home_screen에서 사용하지 않음 (파일은 유지)
- 레벨 1-6의 `LessonPathView` 동작은 변경 없음
