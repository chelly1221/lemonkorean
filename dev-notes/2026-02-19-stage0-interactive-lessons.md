---
date: 2026-02-19
category: Mobile
title: Stage 0 한글 구조 이해 — 인터랙티브 레슨 구현
author: Claude Opus 4.6
tags: [hangul, stage0, interactive-lesson, gamification, drag-drop, quiz]
priority: high
---

## 변경 요약

기존 `HangulStage0TutorialScreen` (정적 레슨 계획 문서)을 실제 인터랙티브 학습 화면으로 교체.
4개 레슨을 체계적으로 학습할 수 있는 PageView 기반 레슨 러너 구현.

## 새 파일 (20개)

### 데이터 모델
- `lib/data/models/hangul_lesson_progress_model.dart` — 레슨 진도 모델 (Hive JSON 저장)

### Stage 0 메인 화면
- `lib/presentation/screens/hangul/stage0/stage0_lesson_content.dart` — 4개 레슨 데이터 (상수)
- `lib/presentation/screens/hangul/stage0/hangul_stage0_lesson_list_screen.dart` — 레슨 목록
- `lib/presentation/screens/hangul/stage0/hangul_lesson_flow_screen.dart` — PageView 레슨 러너

### 스텝 위젯 (12개)
- `steps/step_intro.dart` — 인트로 (이모지 + 설명)
- `steps/step_syllable_animation.dart` — 자음+모음 결합 애니메이션
- `steps/step_drag_drop_assembly.dart` — 드래그 앤 드롭 조립
- `steps/step_sound_explore.dart` — 소리 탐색 (MouthAnimationWidget 재사용)
- `steps/step_sound_match.dart` — 소리 듣고 맞추기 (2지선다)
- `steps/step_syllable_build.dart` — 자음/모음 탭 선택 → 음절 조합
- `steps/step_quiz_mcq.dart` — 객관식 퀴즈
- `steps/step_mission_intro.dart` — 미션 소개
- `steps/step_timed_mission.dart` — 타이머 미션
- `steps/step_mission_results.dart` — 미션 결과
- `steps/step_summary.dart` — 레슨 완료 + 레몬 보상
- `steps/step_stage_complete.dart` — 스테이지 완료 축하

### 재사용 위젯 (5개)
- `widgets/syllable_block_template.dart` — 자음+모음 슬롯 시각화
- `widgets/draggable_character_tile.dart` — 드래그 가능한 글자 타일
- `widgets/syllable_combine_animation.dart` — 분리/결합 애니메이션
- `widgets/countdown_timer_widget.dart` — 미션 타이머
- `widgets/lemon_reward_animation.dart` — 레몬 획득 애니메이션

### 서버 (2개)
- `services/progress/handlers/hangul_lesson_handler.go` — 레슨 진도 API
- `database/postgres/migrations/018_hangul_lesson_progress.sql` — DB 테이블

## 수정 파일

| 파일 | 변경 |
|------|------|
| `hangul_dashboard_view.dart` | `HangulStage0TutorialScreen` → `HangulStage0LessonListScreen`, 레슨 진도 로딩 |
| `hangul_provider.dart` | `_lessonProgress` 맵 + `getLessonProgress`, `completeLesson`, `loadLessonProgress` 메서드 |
| `hangul_repository.dart` | `saveLessonProgress`, `getAllLessonProgress`, `getLessonProgress` (Hive box: `hangul_lesson_progress`) |
| `hangul_stage_path_node.dart` | `completedLessonsOverride` 파라미터 (실제 레슨 완료 기반) |
| `hangul_stage_path_view.dart` | `completedLessonsMap` 파라미터 전달 |
| `services/progress/main.go` | `hangul-lesson/complete`, `hangul-lesson/:userId` 라우트 등록 |
| `services/progress/repository/progress_repository.go` | `UpsertHangulLessonProgress`, `GetHangulLessonProgress` |

## 레슨 구조

| 레슨 | 제목 | 스텝 수 | 스텝 유형 |
|------|------|---------|----------|
| 0-1 | 가 블록 조립하기 | 5 | intro → animation → drag-drop × 2 → summary |
| 0-2 | 소리와 입모양 감각 켜기 | 6 | intro → sound-explore × 3 → sound-match → summary |
| 0-3 | 내 첫 글자 만들기 | 7 | intro → syllable-build × 4 → quiz-mcq → summary |
| 0-M | 블록 미션 | 4 | mission-intro → timed-mission → mission-results → stage-complete |

## 게이미피케이션

- 각 레슨 완료 시 1~3 레몬 보상 (점수 기반)
- `GamificationProvider.recordLessonReward` 재사용 (90001~90004 키)
- `LemonCrossSectionPainter` 의 조각이 실제 레슨 완료에 따라 채워짐

## 진도 저장

- **오프라인 우선**: Hive box `hangul_lesson_progress` (JSON map)
- **서버 동기화**: `LocalStorage.addToSyncQueue` + `POST /api/progress/hangul-lesson/complete`
- 레슨 잠금: 이전 레슨 완료 시에만 다음 레슨 해제

## 참고

- 기존 `HangulStage0TutorialScreen` 코드는 삭제하지 않음 (다른 스테이지에서도 같은 파일에 정의)
- `KoreanTtsHelper`와 `MouthAnimationWidget`을 sound-explore 스텝에서 재사용
- 미션 타이머는 `CountdownTimerWidget`으로 구현 (GlobalKey로 elapsed 접근)
