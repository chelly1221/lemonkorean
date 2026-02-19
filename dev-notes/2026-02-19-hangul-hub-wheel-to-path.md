---
date: 2026-02-19
category: Mobile
title: 한글 레벨0 허브 - 레몬 휠을 수직 경로로 교체
author: Claude Opus 4.6
tags: [hangul, hub, UI, path, gamification]
priority: high
---

## 변경 요약

레벨 0 한글 허브의 회전 레몬 휠(`GiantLemonWheel`)을 수직 지그재그 레몬 경로(`HangulStagePathView`)로 교체했습니다.

## 변경 이유

- 레몬 휠은 한 번에 1개 스테이지만 보여주고, 스와이프 필요
- 레벨 1-6에서 이미 사용 중인 `LessonPathView` 패턴과 일관성 유지
- 학습 여정 전체가 한눈에 보이는 UX 개선

## 파일 변경

### 새 파일
- `widgets/hangul_stage_path_node.dart` — 스테이지 레몬 노드 위젯 (`LessonPathNode` 패턴 적용)
- `widgets/hangul_stage_path_view.dart` — 9개 스테이지 + BOSS 노드 수직 경로 레이아웃

### 수정 파일
- `widgets/hangul_stats_bar.dart` — `kStageLessonCounts` 상수 이동 (삭제된 `stage_info_card.dart`에서)
- `hangul_level0_learning_screen.dart` — 휠 → 스크롤 가능한 수직 경로로 교체

### 삭제 파일
- `widgets/lemon_slice_wheel.dart` — 레몬 휠 위젯
- `widgets/lemon_slice_painter.dart` — 레몬 슬라이스 페인터
- `widgets/adaptive_cta_button.dart` — 적응형 CTA 버튼
- `widgets/stage_info_card.dart` — 스테이지 정보 카드

## 구현 세부사항

### 경로 노드 (HangulStagePathNode)
- 3가지 시각 상태: 완료(채워진 레몬+체크), 진행중(펄스 글로우), 미시작(회색)
- mastery 기반 레몬 보상 표시: `≥5.0→3🍋, ≥3.0→2🍋, ≥1.0→1🍋`
- 노드 아래 제목(11px) + 레슨 카운트 "X/Y 레슨"(10px)

### 경로 레이아웃 (HangulStagePathView)
- `_verticalSpacing = 130.0`, `_maxWidth = 420.0`
- 지그재그 정렬: `[-0.5, 0.0, 0.5, 0.0]`
- S-curve 연결선: 완료 구간은 실선(levelColor), 미완료는 점선(grey)
- 마지막에 BOSS 노드 (`BossQuizNode` 재사용)
- 스태거드 애니메이션: 각 노드 80ms 지연 fadeIn + slideY

### 화면 변경 (HangulLevel0LearningScreen)
- `_selectedStageIndex` 상태 제거 (단일 선택 불필요)
- `ScrollController` 추가 + init/dispose
- 자동 스크롤 기능 (첫 미완료 스테이지로)
- BOSS 노드 탭 시 "보스 퀴즈는 준비 중입니다" 스낵바

## 재사용 컴포넌트
- `LemonShapePainter` — `home/widgets/lemon_clipper.dart`
- `BossQuizNode` — `home/widgets/boss_quiz_node.dart`
- `HangulStatsBar` + `StageVisualState` — 기존 유지

## 빌드 검증
- `flutter build apk --debug` 성공
