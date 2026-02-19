---
date: 2026-02-19
category: Mobile
title: 한글 레벨 0 허브 페이지 게이미피케이션 및 UX 개선
author: Claude Opus 4.6
tags: [hangul, gamification, ux, lemon-wheel, hub-page]
priority: high
---

## 변경 개요

한글 레벨 0 학습 허브 페이지에 게이미피케이션 요소와 사용성 개선을 동시에 적용. 9개 스테이지 서브 화면은 변경 없음.

## 새로 생성된 파일

### 1. `widgets/hangul_stats_bar.dart`
- `StageVisualState` enum 정의 (notStarted, inProgress, completed)
- `HangulStatsBar` 위젯: 레몬 개수, 학습 글자 수, 복습 대기 알림 표시
- `TweenAnimationBuilder<int>`로 숫자 카운트 애니메이션
- 복습 대기 3자 초과 시 10초 간격 shimmer 효과

### 2. `widgets/stage_info_card.dart`
- `kStageLessonCounts` 상수 (페인터와 공유)
- `StageInfoCard` 위젯: 스테이지 번호, 제목, 진행률 바, 정확도/숙달 칩
- 상태별 색상 변화 (미시작: 회색, 진행중: 레몬 옐로, 완료: 녹색)

### 3. `widgets/adaptive_cta_button.dart`
- `AdaptiveCTAButton` 위젯: 상태별 텍스트/아이콘/스타일 변경
  - 미시작: "학습 시작" + play_arrow (레몬 옐로 배경)
  - 진행중: "이어서 학습" + play_arrow (녹색 테두리)
  - 완료: "다시 복습" + replay (아웃라인 스타일)
- 완료 시 "다음 단계 (N단계) >" 링크 표시

## 수정된 파일

### 4. `widgets/lemon_slice_painter.dart`
- `stageStates` 파라미터 추가 (9개 StageVisualState)
- `recommendedStage` + `pulseValue` 파라미터 추가
- 상태별 렌더링:
  - 미시작: 저투명도 옅은 노란색, 스테이지 번호만 표시
  - 진행중: 기존 방사형 채우기 유지, X/Y 분수 표시
  - 완료: 골든 채우기, 체크마크, 3개 레몬 점 장식
- `kStageLessonCounts` 공유 상수 사용 (기존 `_lessonCounts` 제거)

### 5. `widgets/lemon_slice_wheel.dart`
- `stageStates` 파라미터 추가 및 페인터에 전달
- `TickerProviderStateMixin`으로 변경 (복수 애니메이션)
- 펄스 `AnimationController` 추가 (2초 주기, 반복)
- 추천 스테이지 (첫 번째 미완료) 자동 감지

### 6. `hangul_level0_learning_screen.dart` (1-317 라인, 허브 부분만)
- `GamificationProvider` 연동 (totalLemons)
- AppBar: 원형 진행률 아크 + 제목 + 퍼센트
- `HangulStatsBar` 삽입 (레몬, 글자 수, 복습 알림)
- `StageInfoCard`로 교체 + `AnimatedSwitcher` 전환 효과
- `AdaptiveCTAButton`으로 교체
- `_getStageStates()` 메서드 추가
- `_getNextIncompleteStage()` 메서드 추가
- `_ProgressArcPainter` 내부 클래스 추가

## 데이터 흐름

```
HangulLevel0LearningScreen
  ├── HangulProvider → stats, overallProgress
  ├── GamificationProvider → totalLemons
  ├── _getStageProgress() → List<double> (9값, 0-5)
  ├── _getStageStates() → List<StageVisualState> (9값)
  ├── AppBar: _ProgressArcPainter + 제목 + 퍼센트
  ├── HangulStatsBar: 레몬, 학습 글자, 복습 알림
  ├── StageInfoCard: 선택된 스테이지 정보
  ├── GiantLemonWheel: stageProgress + stageStates
  └── AdaptiveCTAButton: 상태별 적응형 버튼
```

## 주의사항
- 모든 스테이지는 자유 접근 가능 (잠금 없음), 시각적 상태 표시만
- 새로운 의존성 없음 (기존 flutter_animate, provider 활용)
- 빌드 검증 완료: `flutter build apk --debug` 성공
