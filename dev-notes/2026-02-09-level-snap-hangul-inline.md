---
date: 2026-02-09
category: Mobile
title: 레벨 셀렉터 스냅 자동선택 + 한글 페이지 인라인화
author: Claude Opus 4.6
tags: [level-selector, hangul, home-screen, carousel, path-view]
priority: medium
---

# 레벨 셀렉터 스냅 자동선택 + 한글 페이지 인라인화

## 변경 요약

캐러셀 스크롤 스냅 시 자동 레벨 전환 + 한글(레벨 0) 인라인 표시 구현.

## 변경 내용

### 1. 캐러셀 스냅 → 자동 레벨 선택

**파일**: `widgets/level_selector.dart`

- `PageView.builder`에 `onPageChanged` 콜백 추가
- `onPageChanged`에서 `widget.onLevelSelected(index)` 호출 → 스냅 시 자동 전환
- `onTap`에서 `onLevelSelected` 제거 (중복 방지) → `_animateToPage(index)`만 유지
- `_animateToPage` 완료 시 `onPageChanged`가 자동으로 트리거

### 2. 한글(레벨 0) 인라인 표시

**파일**: `widgets/hangul_path_view.dart` (신규)

- `LessonPathView`와 동일한 지그재그 S-curve 스타일
- 4개 섹션 노드: 자모표, 학습, 연습, 활동
- 레몬 모양 노드에 아이콘 표시 (LemonShapePainter 재사용)
- 레벨 0 색상 (#5BA3EC 파랑) 사용
- 각 노드 탭 → `HangulMainScreen(initialTabIndex: n)` 이동

**파일**: `home_screen.dart`

- `_onLevelSelected`에서 레벨 0 특별 처리(Navigator.push) 제거
- `_selectedLevel == 0`일 때 `HangulPathView` 인라인 표시
- 미사용 `HangulMainScreen` import 제거

## 수정 파일

| 파일 | 작업 |
|------|------|
| `widgets/level_selector.dart` | 수정 — onPageChanged 추가 |
| `widgets/hangul_path_view.dart` | 신규 — 한글 경로 뷰 |
| `home_screen.dart` | 수정 — 레벨 0 인라인 처리 |

## 검증

- `flutter build web --release --base-href /app/` 빌드 성공
- `./build_web.sh`로 프로덕션 배포 완료
