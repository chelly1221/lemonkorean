# Moderation Service

AI 기반 콘텐츠 모더레이션 서비스. ONNX Runtime을 사용한 CPU 최적화 텍스트 독성 분류.

## 기능

- **텍스트 독성 분류**: 다국어 독성 탐지 (6개 카테고리: toxic, severe_toxic, obscene, threat, insult, identity_hate)
- **ONNX Runtime 추론**: INT8 동적 양자화로 CPU 최적화
- **멀티 스레드 안전**: 동시 요청 처리 지원
- **유니코드 정규화**: 제로 폭 문자 제거, NFC 정규화

## 기술 스택

- **런타임**: Python 3.11
- **프레임워크**: FastAPI
- **추론 엔진**: ONNX Runtime (CPUExecutionProvider)
- **모델**: `unitary/multilingual-toxic-xlm-roberta` (Jigsaw Multilingual Toxic Comment)
- **토크나이저**: HuggingFace Transformers (AutoTokenizer)

## API 엔드포인트

### 텍스트 모더레이션

```
POST /api/moderation/text
```

**요청 본문:**
```json
{
  "text": "분석할 텍스트",
  "context": "post"
}
```

**필드:**
- `text` (필수): 분석할 텍스트 (1~5000자)
- `context` (선택): 컨텍스트 유형 (`post`, `comment`, `bio`, `dm`; 기본값: `post`)

**응답:**
```json
{
  "safe": true,
  "action": "allow",
  "max_score": 0.0234,
  "categories": {
    "toxic": 0.0234,
    "severe_toxic": 0.0012,
    "obscene": 0.0089,
    "threat": 0.0005,
    "insult": 0.0156,
    "identity_hate": 0.0023
  },
  "context": "post",
  "processing_time_ms": 15.2
}
```

**판정 기준:**
- `action: "allow"` - max_score < FLAG_THRESHOLD (0.3)
- `action: "flag"` - FLAG_THRESHOLD <= max_score < REJECT_THRESHOLD (0.7)
- `action: "reject"` - max_score >= REJECT_THRESHOLD (0.7)

---

### 모더레이션 헬스체크

```
GET /api/moderation/health
```

**응답:**
```json
{
  "status": "ok",
  "models_loaded": true,
  "optimization": {
    "model_file": "model_quantized.onnx",
    "quantized": true,
    "graph_optimization": "ORT_ENABLE_ALL",
    "intra_threads": 0
  }
}
```

---

### 서비스 헬스체크

```
GET /health
```

**응답:**
```json
{
  "status": "ok",
  "service": "moderation"
}
```

## 환경 변수

```env
# 서버
MODERATION_PORT=3008

# 모델
MODEL_NAME=unitary/multilingual-toxic-xlm-roberta
MODEL_PATH=/app/models/text-toxicity

# 임계값
TEXT_REJECT_THRESHOLD=0.7    # 이 점수 이상이면 reject
TEXT_FLAG_THRESHOLD=0.3      # 이 점수 이상이면 flag

# CPU 최적화
USE_QUANTIZED=true           # INT8 양자화 모델 사용 (AVX-VNNI 가속)
INTRA_OP_THREADS=0           # 0 = 자동 (모든 코어 사용)
```

## Docker 빌드

### 멀티 스테이지 빌드

Dockerfile은 2단계 빌드를 사용합니다:

**Stage 1: 모델 내보내기 + 양자화**
- HuggingFace 모델을 ONNX 형식으로 변환
- INT8 동적 양자화 적용
- PyTorch (CPU-only) 포함

**Stage 2: 경량 런타임**
- ONNX Runtime + FastAPI만 포함 (PyTorch 없음)
- 내보낸 ONNX 모델 복사
- 최종 이미지 크기 대폭 감소

```bash
# 빌드 (모델 다운로드 + ONNX 변환 + 양자화 포함)
docker build -t lemon-moderation .

# 실행
docker run -p 3008:3008 lemon-moderation
```

## CPU 최적화

### AVX2/AVX-VNNI 가속

- **FP32 모델**: AVX2 SIMD 명령어로 행렬 연산 가속
- **INT8 양자화 모델**: AVX-VNNI (VNNI 지원 CPU) 또는 AVX2로 정수 GEMM 가속
- **그래프 최적화**: `ORT_ENABLE_ALL` (연산자 퓨전, 상수 폴딩 등)
- **워밍업**: 서비스 시작 시 3회 추론으로 JIT 컴파일 트리거

### 양자화 효과

- INT8 동적 양자화로 모델 크기 ~4배 감소
- 추론 속도 ~2배 향상 (AVX2 지원 CPU 기준)
- 정확도 손실 최소화 (동적 양자화)

## 프로젝트 구조

```
moderation/
├── src/
│   ├── main.py              # FastAPI 앱 진입점
│   ├── routes.py            # API 라우트
│   ├── text_moderator.py    # ONNX 추론 엔진
│   └── config.py            # 환경 변수 설정
├── scripts/
│   └── export_model.py      # HuggingFace → ONNX 변환 스크립트
├── requirements.txt          # 런타임 의존성
├── requirements-export.txt   # 모델 내보내기 의존성
├── Dockerfile                # 멀티 스테이지 빌드
└── README.md
```

## 독성 카테고리

| 카테고리 | 설명 |
|----------|------|
| `toxic` | 일반 독성 |
| `severe_toxic` | 심각한 독성 |
| `obscene` | 음란/외설 |
| `threat` | 위협 |
| `insult` | 모욕 |
| `identity_hate` | 정체성 기반 혐오 |

## 라이선스

MIT
