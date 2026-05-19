# Moderation Service API

## Overview

The Moderation Service provides AI-powered content moderation using ONNX Runtime inference with a multilingual toxic content detection model (unitary/multilingual-toxic-xlm-roberta). It is called internally by the SNS Service when users create posts, comments, or update their bio.

**Service Information:**
- **Port**: 3008
- **Technology**: Python (FastAPI), ONNX Runtime
- **Model**: unitary/multilingual-toxic-xlm-roberta (INT8 quantized by default)
- **Access**: Internal only (called by SNS Service, not exposed via Nginx)

**Last Updated**: 2026-03-11

---

## Endpoints

### POST /api/moderation/text

Moderate text content for toxicity across 6 categories.

**Request Body:**
```json
{
  "text": "Text content to moderate",
  "context": "post"
}
```

**Fields:**
- `text` (required): Text to moderate (1-5000 characters)
- `context` (required): One of `post`, `comment`, `bio`, `dm`

**Response:**
```json
{
  "safe": true,
  "action": "allow",
  "max_score": 0.0312,
  "categories": {
    "toxic": 0.0312,
    "severe_toxic": 0.001,
    "obscene": 0.0089,
    "threat": 0.0005,
    "insult": 0.0201,
    "identity_hate": 0.0011
  },
  "context": "post",
  "processing_time_ms": 12.5
}
```

**Action thresholds:**
- `allow`: max_score < 0.3
- `flag`: max_score >= 0.3
- `reject`: max_score >= 0.7

**Error Codes:**
- `422`: Validation error (empty text, invalid context)
- `503`: Model not loaded

---

### GET /api/moderation/health

Health check with model loading status and optimization details.

**Response:**
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

### GET /health

Root-level health check (outside `/api/moderation` prefix).

**Response:**
```json
{
  "status": "ok",
  "service": "moderation"
}
```

---

## Toxicity Categories

The model detects 6 toxicity categories from the Jigsaw Multilingual dataset:

| Category | Description |
|----------|-------------|
| `toxic` | Generally toxic or rude content |
| `severe_toxic` | Extremely toxic content |
| `obscene` | Obscene or vulgar language |
| `threat` | Threatening content |
| `insult` | Insulting content |
| `identity_hate` | Hate speech targeting identity groups |

---

## Configuration

| Environment Variable | Default | Description |
|---------------------|---------|-------------|
| `MODERATION_PORT` | `3008` | Service port |
| `MODEL_PATH` | `/app/models/text-toxicity` | Path to ONNX model directory |
| `TEXT_REJECT_THRESHOLD` | `0.7` | Score threshold for rejection |
| `TEXT_FLAG_THRESHOLD` | `0.3` | Score threshold for flagging |
| `INTRA_OP_THREADS` | `0` (auto) | ONNX Runtime intra-op thread count |
| `USE_QUANTIZED` | `true` | Prefer INT8 quantized model |

---

## Related Documentation

- [SNS API](./SNS_API.md) - Posts, comments, profiles (calls moderation internally)
- [DM API](./DM_API.md) - Direct messaging
- [Database Schema](../../database/postgres/SCHEMA.md) - moderation_logs table, moderation columns on sns_posts/sns_comments
