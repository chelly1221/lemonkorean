---
date: 2026-02-27
category: Mobile
title: 한글 레벨 전체 점검 및 버그 수정
author: Claude Opus 4.6
tags: [hangul, bugfix, ui, navigation, gamification]
priority: high
---

# 한글 레벨 전체 점검 및 버그 수정

## 개요
6개 에이전트 팀을 구성하여 한글 레벨 12개 스테이지(0-11), 95개 레슨을 전수 점검.
CRITICAL~LOW 수준 총 40+ 이슈 발견, 16건의 핵심 수정 적용.

## 수정 내역

### CRITICAL 수정

#### 1. `_combineSyllable` 자음/모음 맵 완성
- **파일**: `stage0/steps/step_timed_mission.dart`
- **문제**: consonantMap에 4개(ㄱ,ㄴ,ㄷ,ㅇ)만, vowelMap에 ㅐ/ㅔ/ㅒ/ㅖ 누락
- **영향**: 스테이지 3~11 미션 전부 잘못된 음절 생성
- **수정**: 전체 19개 자음, 21개 모음 유니코드 인덱스 완전 매핑

#### 2. `StepStageComplete` 데이터키 불일치
- **파일**: `stage0/steps/step_stage_complete.dart`
- **문제**: `step.data['stage']` 읽지만 콘텐츠는 `'stageNumber'` 제공
- **영향**: 모든 스테이지 완료 배지에 "0단계 마스터" 표시
- **수정**: `stageNumber` 우선 읽기 + `stage` 폴백, 동적 메시지 표시

#### 3. `stageComplete` 스텝 도달 불가
- **파일**: `stage0/hangul_lesson_flow_screen.dart`
- **문제**: summary의 onComplete가 항상 `Navigator.pop()` 호출
- **영향**: 모든 스테이지의 완료 축하 화면 미표시
- **수정**: summary 다음에 stageComplete 스텝이 있으면 `_goNext()` 호출

#### 4. `_hangulLessonKey` 미션 ID 처리 실패
- **파일**: `stage0/hangul_lesson_flow_screen.dart`
- **문제**: 정규식 `\d+-\d+`이 '6-M' 등 미션 ID 불일치 → 모두 키 90000 충돌
- **수정**: 정규식에 `M` 허용, 미션은 lesson=99로 매핑

#### 5. `writing_canvas.dart` shouldRepaint 참조 비교 문제
- **파일**: `widgets/writing_canvas.dart`
- **문제**: 같은 리스트 참조 비교로 캔버스가 다시 그려지지 않음
- **수정**: `shouldRepaint` 항상 true 반환

### HIGH 수정

#### 6. `_completeLesson()` 중복 호출 방지
- 미션 플로우에서 missionResults + summary 양쪽에서 호출되는 문제
- `_lessonCompleted` 가드 플래그 추가

#### 7. `isReviewComplete` / `nextReviewItem` 오프바이원
- **파일**: `hangul_provider.dart`
- 복습 마지막 항목 도달 전에 완료 처리되는 문제 수정

#### 8-11. Row 오버플로우 수정 (4개 파일)
- `step_sound_match.dart`: Row → Wrap
- `step_sound_explore.dart`: 탭 Row → SingleChildScrollView
- `step_timed_mission.dart`: 자음/모음 Row → Wrap
- `step_syllable_build.dart`: 자음/모음 Row → Wrap

#### 12. Stage 7 lesson 7-4 중복 soundMatch 문제
- 동일 문제 2개(정답:싸) → 하나를 정답:사로 변경

#### 13. 대시보드 completedLessonsMap + progress 매핑
- UI 스테이지 6-11이 잘못된 content stage를 참조하는 문제 수정
- Stage 4/5 분할 로직도 개별 스테이지 완료 카운트로 수정

### MEDIUM 수정

#### 14. `hangul_character_model.dart` - `.cast<int>()` 안전 처리
- JSON에 double 값이 올 때 TypeError 방지

#### 15. `hangul_stage_path_node.dart` - bounds check
- `kStageLessonCounts[stageIndex]` 범위 초과 방지

#### 16. `native_comparison_card.dart` - build()내 state mutation
- `_selectedLanguage` 직접 변경 → postFrameCallback으로 안전하게 처리

## 미수정 (낮은 우선순위)
- 하드코딩된 한국어 문자열 (i18n) - 별도 작업 필요
- countdown_timer pulse 속도 변경 미작동 - 시각적 미미
- lemon_cross_section_painter 불필요한 삼항 연산 - 기능 무관
- 레슨별 lessonId 데이터 불일치 - 현재 미사용 필드
