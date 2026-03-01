---
date: 2026-02-28
category: Mobile
title: 한글 스테이지 1-11 다국어 로컬라이제이션 완료
author: Claude Opus 4.6
tags: [i18n, l10n, hangul, ARB, localization, stages]
priority: high
---

# 한글 스테이지 1-11 다국어 로컬라이제이션

## 개요
한글 레슨 Stage 1~11의 모든 학습 콘텐츠를 6개 언어(ko, en, es, ja, zh, zh_TW)로 로컬라이제이션 완료.

## 변경 사항

### 1. 콘텐츠 파일 변환 (11개 파일)
각 스테이지의 `stageN_lesson_content.dart`를:
- `const stageNLessons = <LessonData>[...]` (하드코딩)
- → `List<LessonData> getStageNLessons(AppLocalizations l10n) => <LessonData>[...]` (l10n 참조)

변환된 파일:
- `stage1/stage1_lesson_content.dart` (~187키, 기본 모음)
- `stage2/stage2_lesson_content.dart` (110키, Y-모음)
- `stage3/stage3_lesson_content.dart` (87키, ㅐ/ㅔ 계열)
- `stage4/stage4_lesson_content.dart` (130키, 기본 자음 1)
- `stage5/stage5_lesson_content.dart` (123키, 기본 자음 2)
- `stage6/stage6_lesson_content.dart` (114키, 음절 조합)
- `stage7/stage7_lesson_content.dart` (81키, 된소리/격음)
- `stage8/stage8_lesson_content.dart` (115키, 기본 받침)
- `stage9/stage9_lesson_content.dart` (90키, 확장 받침)
- `stage10/stage10_lesson_content.dart` (82키, 겹받침)
- `stage11/stage11_lesson_content.dart` (107키, 단어 읽기)

### 2. ARB 파일 업데이트
6개 로케일 파일에 각 1,227개 새 키 추가:
- `app_ko.arb`: 1626 → 2853키
- `app_en.arb`: 1630 → 2857키
- `app_es.arb`: 1595 → 2822키
- `app_ja.arb`: 1595 → 2822키
- `app_zh.arb`: 1886 → 3113키
- `app_zh_TW.arb`: 1200 → 2427키

### 3. 레슨 목록 화면 업데이트 (11개 파일)
`hangul_stageN_lesson_list_screen.dart`:
- `stageNLessons` (const 참조) → `getStageNLessons(l10n!)` (함수 호출)
- `_isPreviousCompleted()` 메서드에 `lessons` 파라미터 추가

### 4. 네이티브 스피커 검토
각 언어별 에이전트가 번역 품질 검토 후 수정 적용:
- EN: 영어 자연스러움, 학습자 친화적 표현
- ES: 스페인어 문법, 악센트, 용어 통일
- JA: 일본어 자연스러움, ですます체 통일
- ZH: 간체 용어 통일 (辅音/元音)
- ZH_TW: 번체 용어 통일 (子音/母音), 간체 잔류 확인

## ARB 키 명명 규칙
```
hangulS{N}L{M}Title          - 레슨 제목
hangulS{N}L{M}Subtitle       - 레슨 부제
hangulS{N}L{M}Step{I}Title   - 스텝 제목
hangulS{N}L{M}Step{I}Desc    - 스텝 설명
hangulS{N}L{M}Step{I}Highlights - 하이라이트 (쉼표 구분)
hangulS{N}L{M}Step{I}Msg     - 요약 메시지
hangulS{N}L{M}Step{I}Q{J}    - 퀴즈 문제
hangulS{N}L{M}Step{I}Descs   - 단어 설명 (쉼표 구분)
hangulS{N}CompleteTitle       - 스테이지 완료 제목
hangulS{N}CompleteMsg         - 스테이지 완료 메시지
```

## 주의사항
- 한글 문자(ㄱ, ㅏ, 가 등)는 모든 언어에서 원본 그대로 유지
- `split(',')` 처리되는 값(Highlights, Descs)은 쉼표 구분 문자열
- zh는 辅音/元音, zh_TW는 子音/母音 용어 사용
- Stage 0은 이전 세션에서 별도 완료됨

## 검증
- `flutter gen-l10n`: 성공
- `flutter analyze`: No issues found!
