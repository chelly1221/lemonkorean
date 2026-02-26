---
date: 2026-02-20
category: Mobile
title: Stage 0 한글 레슨 — 도입부 관점 전체 개선
author: Claude Opus 4.6
tags: [hangul, stage0, ux, tts, animation, haptic, simplification]
priority: high
---

## 변경 요약

Stage 0 인터랙티브 레슨의 학습 플로우 및 인터랙션 피드백을 2차에 걸쳐 개선.
"간단한 이해와 도입부"라는 관점에서 과도한 요소를 제거하고, 전체 21→19 스텝으로 간소화.

---

## Round 1: 학습 플로우 + UX 개선

### Part A: 학습 플로우

| 항목 | 내용 |
|------|------|
| A1 | 0-1: `syllableAnimation` 스텝 삭제 (인트로 애니메이션이 동일 역할) |
| A2 | 글자 조립 후 TTS 재생 (drag-drop, syllable-build, timed-mission) |
| A3 | 나/다 등장 시 힌트 표시 (`hint` 필드, 0.8초) |
| A4 | 0-2: 음절 소리 탐색 스텝 추가 (가/나/다) |
| A5 | 0-3: 가/나/다 개별 스텝 → 1개 멀티 타겟 스텝 |
| A6 | 퀴즈 선택지에서 안 배운 글자 "도" 제거 |

### Part B: 인터랙션 UX

| 항목 | 내용 |
|------|------|
| B1 | 오답 shake 애니메이션 + "다시 시도해보세요" 텍스트 |
| B2 | 퀴즈 오답 딜레이 확대 (→1800ms) |
| B3 | 소리 탐색 — 전체 듣기 완료 전 다음 버튼 비활성화 |
| B4 | 드래그 거부 빨간 테두리 피드백 |
| B5 | 타이머 ≤30초 펄스 애니메이션 |
| B6 | 전체 스텝 햅틱 피드백 (정답: light, 오답: medium) |

---

## Round 2: 도입부 관점 간소화

### C1. 소리 탐색(0-2) 간소화 (7→5 스텝)
- ㄱ 단독 스텝 삭제 → 자음(ㄱ,ㄴ,ㄷ) 하나의 탐색 스텝으로 통합
- SoundMatch 퀴즈 삭제 — 퀴즈는 0-3에 이미 존재
- 레슨 제목 "소리와 입모양 감각 켜기" → "소리 탐색"으로 간결화

### C2. 입모양(MouthAnimationWidget) 숨김
- `step_sound_explore.dart`에 `showMouth` 데이터 플래그 지원 추가
- 0-2 자음/모음 스텝에 `'showMouth': false` 설정
- 도입부에서 언어학 수준의 입모양 정보를 제거하여 부담 감소

### C3. 퀴즈(0-3) 축소 (5문제→3문제, 4지선다→3지선다)
- 배운 글자 중 3개만 확인: 가, 노, 다
- 선택지 3개로 축소하여 도입부에 맞는 난이도

### C4. 드래그 드롭 풀 데이터 기반화
- `step_drag_drop_assembly.dart`의 하드코딩된 자음/모음 풀을 step data에서 읽도록 변경
- `DragTarget.onWillAcceptWithDetails`도 동적 리스트 사용
- fallback으로 기존 값 유지

### C5. Dead code 정리
- `StepType.syllableAnimation` enum 값 삭제
- `step_syllable_animation.dart` 파일 삭제
- `syllable_combine_animation.dart` 파일 삭제
- `hangul_lesson_flow_screen.dart`에서 import 및 switch case 제거

---

## 수정 파일

| 파일 | 변경 |
|------|------|
| `stage0_lesson_content.dart` | A1, A3~A6, C1, C3 (enum, 레슨 재구성) |
| `step_drag_drop_assembly.dart` | A2, A3, B4, B6, C4 |
| `step_syllable_build.dart` | A2, B1, B6 |
| `step_timed_mission.dart` | A2, B1, B6 |
| `step_sound_match.dart` | B2, B6 |
| `step_quiz_mcq.dart` | B2, B6 |
| `step_sound_explore.dart` | B3, C2 |
| `countdown_timer_widget.dart` | B5 |
| `hangul_lesson_flow_screen.dart` | C5 (dead import/case 제거) |
| `step_syllable_animation.dart` | **삭제** |
| `syllable_combine_animation.dart` | **삭제** |

## 최종 레슨 구조 (19 스텝)

- **0-1**: 5 스텝 (Intro → DragDrop 가 → DragDrop 나(힌트) → DragDrop 다(힌트) → Summary)
- **0-2**: 5 스텝 (Intro → 자음 ㄱ/ㄴ/ㄷ → 모음 ㅏ/ㅗ → 음절 가/나/다 → Summary)
- **0-3**: 5 스텝 (Intro → Build 가/나/다 → Build 고/노 → MCQ 3문제 → Summary)
- **0-M**: 4 스텝 (Mission Intro → Timed 3분/5개 → Results → Stage Complete)
