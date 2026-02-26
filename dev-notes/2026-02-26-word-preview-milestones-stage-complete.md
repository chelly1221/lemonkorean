---
date: 2026-02-26
category: Mobile
title: 단어 미리보기 마일스톤 + 스테이지 완료 스텝 추가
author: Claude Opus 4.6
tags: [hangul, curriculum, pedagogy, milestones, stageComplete]
priority: high
---

## 변경 요약

학습자가 첫 단어를 읽는 시점을 대폭 앞당기기 위해 "단어 미리보기 마일스톤" 레슨 3개를 추가하고, 모든 12개 스테이지에 `stageComplete` 스텝을 적용했습니다.

## 변경 내용

### 1. 단어 미리보기 마일스톤 레슨 (3개 추가)

| 스테이지 | 레슨 ID | 제목 | 내용 |
|----------|---------|------|------|
| Stage 1 | `1-10` | 첫 한국어 단어! | 아이, 우유, 오이 등 모음만으로 읽는 단어 |
| Stage 4 | `4-8` | 단어 읽기 도전! | 나무, 바다, 나비, 모자, 가구, 두부 |
| Stage 11 | `11-7` | 실생활 한국어 읽기 | 카페 메뉴, 지하철역, 인사 표현 |

**교육학적 근거**: 기존에는 Lesson 75 (Stage 11)에서야 첫 단어를 읽었으나, 이제 Stage 1 완료 시점(~Lesson 14)에서 첫 단어를 접할 수 있어 학습 동기가 크게 향상됩니다.

### 2. stageComplete 스텝 (12개 스테이지 전체)

모든 스테이지의 마지막 레슨에 `StepType.stageComplete` 스텝을 추가했습니다. 각 스테이지별 축하 메시지:

- Stage 0: 한글의 구조를 이해했어요!
- Stage 1: 기본 모음 6개를 마스터했어요!
- Stage 2: Y-모음까지 정복했어요!
- Stage 3: 모든 모음을 배웠어요!
- Stage 4: 기본 자음 7개를 익혔어요!
- Stage 5: 모든 기본 자음을 마스터했어요!
- Stage 6: 자유롭게 음절을 조합할 수 있어요!
- Stage 7: 된소리와 거센소리를 구분할 수 있어요!
- Stage 8: 받침의 기초를 다졌어요!
- Stage 9: 확장 받침까지 정복했어요!
- Stage 10: 겹받침까지 마스터했어요!
- Stage 11: 한글을 완전히 읽을 수 있어요!

### 3. kStageLessonCounts 업데이트

Stage 1: 9 → 10 (1-10 추가 반영)

## 수정된 파일

- `lib/presentation/screens/hangul/stage0/stage0_lesson_content.dart`
- `lib/presentation/screens/hangul/stage1/stage1_lesson_content.dart`
- `lib/presentation/screens/hangul/stage2/stage2_lesson_content.dart`
- `lib/presentation/screens/hangul/stage3/stage3_lesson_content.dart`
- `lib/presentation/screens/hangul/stage4/stage4_lesson_content.dart`
- `lib/presentation/screens/hangul/stage5/stage5_lesson_content.dart`
- `lib/presentation/screens/hangul/stage6/stage6_lesson_content.dart`
- `lib/presentation/screens/hangul/stage7/stage7_lesson_content.dart`
- `lib/presentation/screens/hangul/stage8/stage8_lesson_content.dart`
- `lib/presentation/screens/hangul/stage9/stage9_lesson_content.dart`
- `lib/presentation/screens/hangul/stage10/stage10_lesson_content.dart`
- `lib/presentation/screens/hangul/stage11/stage11_lesson_content.dart`
- `lib/presentation/screens/hangul/widgets/hangul_stats_bar.dart`
