---
date: 2026-03-01
category: Mobile
title: 발음 채점 방식 전환 — GOP → 임베딩 코사인 유사도
author: Claude Opus 4.6
tags: [speech, pronunciation, wav2vec2, onnx, embedding]
priority: high
---

## 배경

wav2vec2-large-xlsr-korean ONNX 모델의 CTC head 출력이 1205 클래스인데, 코드에서는 46개 자모(ㄱ~ㅣ + 특수토큰) 라벨로 매핑하고 있어 항상 0점이 나오는 문제가 있었다.

모델 자체는 정상 작동하므로, CTC 로짓 대신 인코더의 hidden state(1024차원)를 임베딩으로 추출하여 TTS 레퍼런스와 비교하는 방식으로 전환.

## 변경 사항

### 1. ONNX 모델 트리밍 (Python 스크립트)
- `scripts/models/trim_wav2vec2.py` 생성
- CTC head(`lm_head`) 제거, 마지막 encoder layer_norm 출력을 모델 출력으로 설정
- 입력: `wav2vec2_korean_q8.onnx` (356MB, 출력 [1, T, 1205])
- 출력: `wav2vec2_korean_emb_q8.onnx` (335MB, 출력 [1, T, 1024])
- 14개 노드 제거, 4개 이니셜라이저 제거

### 2. 레퍼런스 임베딩 생성 (Python 스크립트)
- `scripts/models/generate_reference_embeddings.py` 생성
- edge-tts(`ko-KR-SunHiNeural`)로 각 글자/단어 TTS 오디오 생성
- 트리밍된 모델로 임베딩 추출 → mean pool → L2 정규화
- Stage 0~11 전체 152개 캐릭터/단어 대상
- 출력: `lib/core/data/reference_embeddings.dart` (Dart const Map, ~1.7MB)

### 3. GopService 리라이팅
- `gop_service_native.dart`:
  - `extractPhonemeLogits()` → `extractEmbedding()` 메서드로 교체
  - `_runOnnxInference()`: 출력 shape [1, T, 1024] 기대
  - `_meanPool()`: 시간축 평균 + L2 정규화 추가
  - `phonemeLabels`, `computeGopScores`, `_logSoftmax`, `_sigmoidNormalize`, `_computeFrameRanges`, `_FrameRange` 제거
  - `_parseWavToFloat32`, `_preprocessAudio`, `_computeRms` 유지
- `gop_service_stub.dart`: `extractEmbedding()` → null 반환
- `gop_models.dart`: `GopResult`, `PhonemeGopScore` 제거 (불필요)
- `gop_service.dart` 배럴: `gop_models.dart` export 제거

### 4. PronunciationScorer 리라이팅
- 기존: GOP per-phoneme 점수 → 위치 가중 평균
- 변경: 임베딩 코사인 유사도 → 선형 매핑 (0.30~0.85 → 0~100점)
- `ReferenceEmbeddings.get(expectedText)` → 레퍼런스 조회
- `GopService.instance.extractEmbedding(audioPath)` → 사용자 임베딩
- 자모별 점수는 전체 점수로 균일하게 채움 (UI 호환)
- `SpeechResult` 인터페이스 100% 유지 → UI 변경 없음

### 5. SpeechModelManager
- 모델 파일명: `wav2vec2_korean_q8.onnx` → `wav2vec2_korean_emb_q8.onnx`

### 6. SpeechProvider
- `_classifyError`에 `'embedding'`, `'reference'` 키워드 추가

## 점수 매핑

```
cosine_similarity → score
0.85+            → 100 (원어민 수준)
0.70             → 73  (양호)
0.60             → 55  (보통)
0.30             → 0   (미인식/잡음)
```

공식: `score = ((sim - 0.30) / (0.85 - 0.30) * 100).clamp(0, 100)`

## 파일 변경 요약

| 파일 | 변경 |
|------|------|
| `scripts/models/trim_wav2vec2.py` | 신규 |
| `scripts/models/generate_reference_embeddings.py` | 신규 |
| `lib/core/data/reference_embeddings.dart` | 신규 (생성됨) |
| `lib/core/services/gop_service.dart` | 수정 |
| `lib/core/services/gop_service_native.dart` | 리라이팅 |
| `lib/core/services/gop_service_stub.dart` | 수정 |
| `lib/core/services/gop_models.dart` | 비움 |
| `lib/core/services/pronunciation_scorer.dart` | 리라이팅 |
| `lib/core/services/speech_model_manager.dart` | 수정 |
| `lib/presentation/providers/speech_provider.dart` | 수정 |
| `assets/models/gop/wav2vec2_korean_q8.onnx` | 삭제 |
| `assets/models/gop/wav2vec2_korean_emb_q8.onnx` | 신규 |

## 검증 방법

1. `flutter analyze` — 컴파일 에러 없음 확인
2. APK 빌드 후 실기기 설치
3. 발음 레슨 진입 → 모델 로드 성공 확인
4. 녹음 → 점수 표시 확인 (0점이 아닌 정상 점수)
5. 정확한 발음 → 70+ 점, 침묵/잡음 → 낮은 점수 확인
