---
date: 2026-03-01
category: Mobile
title: 음성인식 즉시 시작, 노이즈 제거, per-phoneme 채점 개선
author: Claude Opus 4.6
tags: [speech, pronunciation, noise-reduction, scoring]
priority: high
---

## 변경 사항 요약

### 1. 녹음 시작 시 대기 시간 제거
- **파일**: `step_speech_practice.dart`
- `_minRecordDuration` (500ms) 게이트를 완전히 제거
- 녹음 시작 즉시 정지 버튼 활성화 (이전: 500ms 대기 후 활성화)
- CircularProgressIndicator (최소 녹음 시간 표시) 제거
- `_canStop` 상태 변수 제거로 코드 간소화

### 2. 노이즈 제거 전처리 파이프라인 (`gop_service_native.dart`)
기존 전처리 (VAD + 볼륨 정규화)에 4단계 노이즈 제거 추가:

1. **DC 오프셋 제거**: 신호의 평균값을 빼서 DC 바이어스 제거
2. **고역 통과 필터 (80Hz)**: 1차 IIR 고역 통과 필터로 저주파 노이즈 (험, 진동, 핸들링 노이즈) 제거
   - `α = RC / (RC + dt)`, RC = 1/(2π × 80Hz)
3. **노이즈 게이트**:
   - 첫 50ms (무음 구간)에서 노이즈 플로어 추정
   - 임계값 = max(노이즈 플로어 × 2, 0.005)
   - 소프트 게이트: 노이즈 프레임을 10%로 감쇄 (완전 제거 시 아티팩트 발생 방지)
4. **프리엠퍼시스 필터**: `y[n] = x[n] - 0.97 × x[n-1]` — 고주파 부스트로 자음 감지 정확도 향상

전체 파이프라인: DC 제거 → 고역 통과 → 노이즈 게이트 → VAD 트림 → 볼륨 정규화 → 프리엠퍼시스

### 3. Per-phoneme 채점 구현 (`pronunciation_scorer.dart`)
기존: 모든 음소에 동일한 전체 점수 부여 (uniform score)
변경: frame-level 분석을 통한 실제 음소별 점수 계산

**방식**:
- `GopService.extractEmbeddingWithFrames()` 추가 — 임베딩 + [T, 1024] 프레임 데이터 반환
- wav2vec2 모델의 T개 출력 프레임을 음소 수에 비례하여 분할
  - 모음(중성): 가중치 2.0 (자연 음소 길이 반영)
  - 자음(초성/종성): 가중치 1.0
- 각 세그먼트를 mean-pool + L2-normalize하여 참조 임베딩과 비교
- 세그먼트별 코사인 유사도 → 0-100 점수로 매핑
- per-phoneme 임계값: `_phonemeSimLow=0.55`, `_phonemeSimHigh=0.88` (세그먼트 단위가 더 노이즈가 많으므로 범위 확대)

**결과**: UI 음소 분석에서 각 음소마다 실제 다른 점수가 표시되어, 사용자가 어떤 음소를 개선해야 하는지 정확하게 파악 가능.

### 파일 변경 목록
- `lib/presentation/screens/hangul/stage0/steps/step_speech_practice.dart` — 대기 시간 제거
- `lib/core/services/gop_service_native.dart` — 노이즈 전처리 + EmbeddingResult + extractEmbeddingWithFrames
- `lib/core/services/gop_service_stub.dart` — 스텁 API 동기화
- `lib/core/services/pronunciation_scorer.dart` — per-phoneme 채점 로직
