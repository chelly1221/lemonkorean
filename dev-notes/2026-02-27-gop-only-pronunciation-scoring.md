---
date: 2026-02-27
category: Mobile
title: 발음 채점을 GOP 전용으로 전환 — Whisper 제거 및 GOP 정확도 개선
author: Claude Opus 4.6
tags: [speech, pronunciation, gop, whisper, scoring]
priority: high
---

## 배경

한국인 사용자가 발음 연습에서 0점, 50점, 100점이 불규칙하게 나오는 문제 발생.

### 근본 원인 분석

1. **Whisper base 모델이 단음절에 부적합**: "가", "나" 같은 1-2음절에서 빈 텍스트 반환 또는 오인식 빈번
2. **GOP 강제 정렬이 균등 분배**: 자음/모음 구분 없이 프레임을 균등 배분 → 부정확
3. **복합 종성(ㄳ, ㄵ 등)이 GOP 라벨에 없음**: 0점 처리되어 전체 점수 하락
4. **점수 정규화가 지나치게 가혹**: 선형 매핑 [-10, 0] → [0, 100]은 원어민도 50점대

## 변경 사항

### 1. Whisper 완전 제거 — GOP 전용 채점

**`pronunciation_scorer.dart`** 전면 재작성:
- Whisper 텍스트 비교(30% 가중치) 제거
- GOP 점수(40%) + 음절 위치 가중 상세 점수(60%) 조합
- `SpeechResult`에서 `textScore`, `actualText`, `transcription` 필드 제거

### 2. GOP 강제 정렬 개선

**`gop_service.dart`**:
- **음소 유형별 프레임 배분**: 자음 30% / 모음 70% (기존: 균등 분배)
- **최소 녹음 길이 검증**: 0.3초 미만 녹음 거부 (4800 samples at 16kHz)
- **시그모이드 정규화**: 선형 → 시그모이드 곡선으로 자연스러운 점수 분포
  - -1.0 → ~95점 (원어민 수준)
  - -3.0 → ~75점 (양호)
  - -5.0 → ~50점 (보통)
  - -7.0 → ~25점 (미흡)
- **개발용 합성 logits 폴백 제거**

### 3. 복합 종성 처리

**`korean_phoneme_utils.dart`**:
- `complexFinalToSimple` 맵 추가: ㄳ→ㄱ, ㄵ→ㄴ, ㄶ→ㄴ, ㄺ→ㄹ, ㄻ→ㅁ 등
- `simplifyForGop()`: GOP 라벨 조회 전 복합 종성을 대표음으로 변환
- `classifyPhoneme()`: 음소를 자음/모음으로 분류 (프레임 배분용)

### 4. UI/Provider 업데이트

**`speech_provider.dart`**: WhisperService 초기화 제거
**`step_speech_practice.dart`**: "인식: ..." 표시 제거, GOP/상세 점수만 표시
**`pronunciation_feedback.dart`**: PhonemeScoreDetail의 `actual` 필드 참조 제거

## 점수 공식 (변경 후)

```
최종 점수 = GOP 평균 × 0.40 + 음절 위치 가중 점수 × 0.60

음절 위치 가중치:
- 초성 (ㄱ,ㄴ,ㄷ...): 40%
- 중성 (ㅏ,ㅓ,ㅗ...): 40%
- 종성 (ㄱ,ㄴ,ㅁ...): 20%
```

## 수정 파일

- `lib/core/services/gop_service.dart`
- `lib/core/services/pronunciation_scorer.dart`
- `lib/core/utils/korean_phoneme_utils.dart`
- `lib/core/utils/pronunciation_feedback.dart`
- `lib/presentation/providers/speech_provider.dart`
- `lib/presentation/screens/hangul/stage0/steps/step_speech_practice.dart`
