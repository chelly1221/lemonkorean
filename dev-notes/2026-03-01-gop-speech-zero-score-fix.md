---
date: 2026-03-01
category: Mobile
title: 음성인식 0점 문제 수정 + 점수 정확도 개선
author: Claude Opus 4.6
tags: [gop, speech, pronunciation, bugfix, audio]
priority: high
---

## 문제

한국인 원어민이 발음해도 항상 0점이 나오는 문제. 여러 단계에서 조용히 실패하여 `SpeechResult.empty()` (score=0)를 반환.

## 원인 분석

1. **WAV 헤더 파싱 오류**: `bytes.sublist(44)` 고정 오프셋 → 확장 헤더가 있는 WAV에서 PCM 데이터 깨짐
2. **시그모이드 보정 미흡**: `k=0.8, center=-4.5` → 양자화 모델에서 원어민도 낮은 점수
3. **오디오 전처리 부재**: 무음 구간, 볼륨 차이가 그대로 모델 입력
4. **에러 UI 없음**: 모든 실패가 0점으로 표시되어 원인 파악 불가

## 수정 내용

### gop_service.dart (5개 태스크)
- **WAV 파싱**: RIFF/WAVE 헤더 검증, 청크 순회로 `fmt `/`data` 청크 정확한 위치 탐색
- **오디오 전처리**: VAD(에너지 기반 무음 제거) + 볼륨 정규화(목표 RMS 0.1, gain 0.5~10.0)
- **시그모이드 보정**: `k=0.8→0.6`, `center=-4.5→-6.0` (더 완만한 곡선)
- **디버그 로깅**: 모델 로딩, WAV 포맷, PCM 통계, ONNX 출력, 음소별 점수 상세 로깅
- **최소 녹음 시간**: 4800→8000 샘플 (0.3s→0.5s)

### speech_provider.dart (2개 태스크)
- `SpeechRecordingState.error` 상태 추가
- `_isInitializing`, `_initError` 필드로 모델 초기화 상태 추적
- `_classifyError()`: audioTooShort / modelError / analysisError 분류
- `retryInitialize()` 메서드 추가

### step_speech_practice.dart (3개 태스크)
- 모델 로딩 중 스피너 + "음성 모델 로딩 중..." 표시
- 모델 에러 시 "음성 모델을 불러올 수 없습니다" + 재시도 버튼
- 분석 에러 시 에러 코드별 한국어 메시지 + 다시 시도 버튼
- 0.5초 미만 녹음 시 정지 버튼 비활성 + 원형 프로그레스 표시

## 시그모이드 매핑 변경

| avgLogProb | 이전 점수 | 수정 후 점수 | 설명 |
|-----------|----------|------------|------|
| -1.0 | ~95 | ~97 | 탁월 |
| -3.0 | ~75 | ~86 | 우수 |
| -6.0 | ~23 | ~50 | 보통 |
| -9.0 | ~2 | ~14 | 미흡 |

## 검증 방법

콘솔 로그에서 `[GopService]` 태그로 각 단계별 정상 동작 확인:
- WAV fmt, PCM loaded, VAD trim, Normalization, ONNX output, Phoneme 점수
