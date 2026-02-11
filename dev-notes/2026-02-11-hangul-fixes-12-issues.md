---
date: 2026-02-11
category: Mobile
title: 한글 학습 기능 - 12개 오류/TODO/개선점 전체 수정
author: Claude Opus 4.6
tags: [hangul, tts, l10n, audio, writing, bugfix]
priority: high
---

# 한글 학습 기능 - 12개 문제 전체 수정

## 개요
한글 학습 기능 코드 리뷰에서 발견된 12개 문제(HIGH 3, MEDIUM 5, LOW 4)를 전부 수정.

## 변경 사항

### Phase 1: flutter_tts + KoreanTtsHelper (신규)
- `pubspec.yaml`: `flutter_tts: ^4.2.0` 의존성 추가
- `lib/core/utils/korean_tts_helper.dart` 신규 생성
  - 서버 오디오 우선 시도 → flutter_tts fallback 방식
  - `playKoreanText(text, audioPlayer, speed)` static 메서드

### Phase 2: 하드코딩 문자열 수정 (M1, M2, M3)
- 6개 ARB 파일에 7개 새 l10n 키 추가:
  - `batchimDescriptionText`, `syllableInputLabel`, `syllableInputHint`
  - `totalPracticedCount` (int placeholder), `audioLoadError`
  - `writingPracticeCompleteMessage`, `sevenRepresentativeSounds`
- `hangul_batchim_screen.dart`: 받침 설명 텍스트 + "7가지 대표음" → l10n
- `hangul_syllable_screen.dart`: 음절 입력 label/hint → l10n
- `hangul_shadowing_screen.dart`: "Total: N characters practiced" → l10n

### Phase 3: 오디오 에러 피드백 (M4, M5)
- `hangul_discrimination_screen.dart`: catch 블록에 SnackBar 추가
- `hangul_shadowing_screen.dart`: catch 블록에 SnackBar 추가

### Phase 4: 음절/받침 오디오 구현 (H1, H2)
- `hangul_syllable_screen.dart`: placeholder SnackBar → KoreanTtsHelper
- `hangul_batchim_screen.dart`: 예시 단어 placeholder → KoreanTtsHelper

### Phase 5: 코드 품질 (L1, L2, L4)
- `recording_widget.dart`: `_trackRecordingDuration` while 루프에 `mounted` 체크 추가
- `writing_canvas.dart`: freehand 완료 시 AlertDialog 표시 후 Navigator.pop
- `hangul_practice_screen.dart`: `_generateOptions`에 bounds check 추가

### Phase 6: 쓰기 정확도 개선 (H3)
- `writing_canvas.dart`: `_calculateAccuracy` 알고리즘 개선
  - 기존: 포인트 수 기반 (아무 낙서 = 높은 점수)
  - 변경: 스트로크 수(40%) + 영역 커버리지 3x3(30%) + 포인트 밀도(30%)

## 수정된 파일 목록
- `pubspec.yaml`
- `lib/core/utils/korean_tts_helper.dart` (신규)
- `lib/l10n/app_ko.arb`, `app_en.arb`, `app_zh.arb`, `app_zh_TW.arb`, `app_ja.arb`, `app_es.arb`
- `lib/presentation/screens/hangul/hangul_syllable_screen.dart`
- `lib/presentation/screens/hangul/hangul_batchim_screen.dart`
- `lib/presentation/screens/hangul/hangul_shadowing_screen.dart`
- `lib/presentation/screens/hangul/hangul_discrimination_screen.dart`
- `lib/presentation/screens/hangul/hangul_practice_screen.dart`
- `lib/presentation/screens/hangul/widgets/writing_canvas.dart`
- `lib/presentation/screens/hangul/widgets/recording_widget.dart`

## 검증
- `flutter pub get` ✅
- `flutter gen-l10n` ✅ (pub get에서 자동 실행)
- `flutter analyze` ✅ (0 errors)
