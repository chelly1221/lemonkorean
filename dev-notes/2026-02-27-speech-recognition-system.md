---
date: 2026-02-27
category: Mobile
title: GOP + Whisper 하이브리드 온디바이스 음성인식 시스템 구현
author: Claude Opus 4.6
tags: [speech-recognition, whisper, gop, wav2vec2, pronunciation, hangul, offline]
priority: high
---

# GOP + Whisper 하이브리드 음성인식 시스템

## 개요

한글 레슨(Stage 1-11)에 학습자가 직접 발음하고 AI 피드백을 받는 `speechPractice` 레슨 스텝을 구현했다. 완전 오프라인 온디바이스로 동작하며, Whisper(텍스트 인식) + wav2vec2 GOP(발음 품질 점수)를 결합한 하이브리드 채점 방식이다.

## 아키텍처

```
[사용자 발음] → [AudioRecorderService (WAV 16kHz mono)]
                    ↓
        ┌───────────┴───────────┐
        ↓                       ↓
  [WhisperService]        [GopService]
  (whisper_flutter_new)   (onnxruntime)
        ↓                       ↓
  transcription           phoneme logits
        ↓                       ↓
        └───────────┬───────────┘
                    ↓
        [PronunciationScorer]
        3단계 채점: 텍스트 비교(30%) + GOP(50%) + 상세분석(20%)
                    ↓
        [SpeechResult → UI 피드백]
```

## 새로 생성된 파일 (11개)

### Phase 1: 서비스 인프라
| 파일 | 역할 |
|------|------|
| `lib/core/services/whisper_service.dart` | Whisper 온디바이스 음성→텍스트 |
| `lib/core/services/gop_service.dart` | wav2vec2 ONNX 기반 GOP 발음 점수 |
| `lib/core/services/audio_recorder_service.dart` | WAV 16kHz mono 녹음 |
| `lib/core/services/speech_model_manager.dart` | AI 모델 다운로드/관리 (~232MB) |

### Phase 2: 채점 알고리즘
| 파일 | 역할 |
|------|------|
| `lib/core/services/pronunciation_scorer.dart` | 하이브리드 3단계 채점 + SpeechResult/PhonemeScoreDetail 모델 |
| `lib/core/utils/korean_phoneme_utils.dart` | 자모 분해, 유사 음소 매트릭스, Needleman-Wunsch 정렬 |
| `lib/core/utils/pronunciation_feedback.dart` | 6개 언어 피드백 생성 (ko/en/zh/zh_TW/ja/es) |

### Phase 3-4: UI 및 상태 관리
| 파일 | 역할 |
|------|------|
| `lib/data/models/speech_result_model.dart` | SpeechResult 타입 re-export |
| `lib/presentation/providers/speech_provider.dart` | 음성인식 상태 관리 (ChangeNotifier) |
| `lib/presentation/screens/hangul/stage0/steps/step_speech_practice.dart` | 발음 연습 스텝 위젯 |
| `lib/presentation/screens/settings/widgets/speech_model_manager_widget.dart` | 설정 화면 모델 관리 UI |

## 수정된 파일

| 파일 | 변경 내용 |
|------|-----------|
| `pubspec.yaml` | `whisper_flutter_new`, `onnxruntime` 패키지 추가 |
| `stage0_lesson_content.dart` | `StepType.speechPractice` enum 추가 |
| `hangul_lesson_flow_screen.dart` | `_buildStep()` switch에 speechPractice case 추가 |
| `main.dart` | `SpeechProvider` MultiProvider 등록 (모바일 전용) |
| `local_storage.dart` | `_pronunciationBox` Hive box, 발음 마스터리(0-5) 저장 |
| `stage1~11_lesson_content.dart` (11개) | 62개 speechPractice 스텝 삽입 |
| `app_*.arb` (6개) | 21개 로컬라이제이션 키 추가 |

## 채점 알고리즘 상세

### 3단계 가중 채점
1. **텍스트 비교 (30%)**: Whisper 인식 결과 ↔ 기대 텍스트 음소 정렬 (Needleman-Wunsch)
2. **GOP 품질 (50%)**: wav2vec2 프레임별 사후확률 → 음소별 GOP 점수
3. **위치별 상세분석 (20%)**: 초성(40%)/중성(40%)/종성(20%) 위치 가중치

### 동적 가중치 재분배
- Whisper만 가용: 텍스트 60%, 상세 40%
- GOP만 가용: GOP 71.4%, 상세 28.6%
- 둘 다 없음: 점수 0 반환

### 유사 음소 매트릭스
- 자음: 평음-격음(70), 평음-경음(60), 비음/유음 쌍(50)
- 모음: ㅐ/ㅔ(80, 현대 한국어 합류), ㅏ/ㅓ(50), ㅗ/ㅜ(50)

## 스테이지별 난이도

| Stage | 내용 | passScore | maxAttempts |
|-------|------|-----------|-------------|
| 1-2 | 기본 모음/자음 | 60 | 3 |
| 3-4 | 추가 모음/자음 | 65 | 3 |
| 5-6 | 쌍자음/복합모음 | 55 | 4 |
| 7-11 | 받침/복합음절 | 60 | 3 |

## AI 모델 — 완전 오프라인 (앱 내장)

- **Whisper base**: 141MB (`ggml-base.bin`)
- **wav2vec2-korean (ONNX int8)**: 304MB (`wav2vec2_korean_q8.onnx`)
- 총 ~445MB, Flutter assets로 앱에 번들
- **네트워크 불필요** — 모델이 앱에 내장되어 첫 실행부터 오프라인 동작
- `SpeechModelManager.ensureModelsReady()`가 assets → documents 디렉토리 복사 (첫 실행 시 1회)
- WhisperService에 빈 `downloadHost` 설정으로 HuggingFace 접근 차단

### 모델 파일 위치
```
# Flutter assets (앱 번들, .gitignore됨)
assets/models/whisper/ggml-base.bin           # 141MB
assets/models/gop/wav2vec2_korean_q8.onnx     # 304MB

# 런타임 복사 위치 (documents directory)
<documents>/models/whisper/ggml-base.bin
<documents>/models/gop/wav2vec2_korean_q8.onnx
```

### 모델 변환 과정
```bash
# scripts/speech-models/prepare_models.sh 실행으로 자동화
# 1. Whisper: HuggingFace에서 ggml-base.bin 직접 다운로드
# 2. wav2vec2: kresnik/wav2vec2-large-xlsr-korean → torch.onnx.export(opset 17) → quantize_dynamic(QInt8)
# 원본 1.2GB → int8 quantized 304MB
```

### 백업 — 미디어 서버에도 배치됨
```bash
# MinIO 버킷: lemon-korean-media (서버 백업용)
GET /media/models/whisper/ggml-base.bin
GET /media/models/gop/wav2vec2_korean_q8.onnx
```

## 완료된 작업 ✅

1. ✅ wav2vec2 ONNX 모델 변환 + int8 양자화
2. ✅ 모델 Flutter assets로 앱 내장 (완전 오프라인)
3. ✅ `SpeechModelManager`를 asset 복사 방식으로 전환 (다운로드 제거)
4. ✅ `SpeechProvider`에서 다운로드 상태 제거 (항상 서비스 초기화)
5. ✅ `StepSpeechPractice`에서 다운로드 프롬프트 제거 (항상 연습 화면 표시)
6. ✅ `GopService`에 실제 ONNX Runtime 추론 통합
7. ✅ 설정 화면에 모델 상태 표시 위젯
8. ✅ 미디어 서비스에 `/media/models/*filepath` 라우트 (백업)

## TODO / 후속 작업

1. 실기기 E2E 테스트: 녹음 → 채점 전체 흐름
2. wav2vec2 모델 크기 최적화 검토 (304MB → 더 작은 base 모델 검토)
