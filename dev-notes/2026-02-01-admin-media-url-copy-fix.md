---
date: 2026-02-01
category: Backend
title: 어드민 미디어 URL 복사 및 이미지 서빙 수정
author: Claude Opus 4.5
tags: [bugfix, admin, media, url, minio]
priority: medium
---

# 어드민 미디어 URL 복사 및 이미지 서빙 수정

## 개요
웹 어드민의 미디어 관리에서 두 가지 문제를 수정했습니다:
1. "URL 복사" 버튼 클릭 시 내부 Docker 네트워크 주소가 복사되는 문제
2. 복사된 URL로 접속 시 "image not found" 오류 발생

## 문제 / 배경

### 문제 1: 잘못된 URL 복사
- "URL 복사" 버튼 클릭 시 `http://localhost/media/images/abc123.jpg` 형태의 URL이 복사됨
- 환경변수 `API_BASE_URL`이 `http://localhost`로 설정되어 있었음

### 문제 2: 이미지 접근 불가
- 공개 URL로 접속 시 "image not found" 오류 발생
- **원인**: Admin Service와 Media Service가 서로 다른 MinIO 버킷 구조를 사용
  - Admin Service: `lemon-korean-media` 버킷의 `images/xxx.png` 경로
  - Media Service: `lemon-images` 버킷의 `xxx.png` 경로

## 해결 / 구현

### 1. 환경변수 수정
`.env` 파일의 `API_BASE_URL`을 프로덕션 도메인으로 변경:
```bash
# Before
API_BASE_URL=http://localhost

# After
API_BASE_URL=https://lemon.3chan.kr
```

### 2. Admin Service URL 생성 로직 수정
`services/admin/src/services/media-upload.service.js`에서 공개 URL 사용:
```javascript
const PUBLIC_URL = process.env.API_BASE_URL || 'https://lemon.3chan.kr';

// 3곳의 URL 생성을 PUBLIC_URL 사용으로 변경
const mediaUrl = `${PUBLIC_URL}/media/${type}/${fileName}`;
```

### 3. Media Service 버킷 구조 통일
`services/media/config/minio.go`에서 통합 버킷 사용:
```go
// Before: 개별 버킷 사용
const (
    BucketImages = "lemon-images"
    BucketAudio  = "lemon-audio"
    BucketVideo  = "lemon-video"
)

// After: 통합 버킷 사용 (Admin Service와 동일)
const (
    UnifiedBucket = "lemon-korean-media"
    BucketImages  = "lemon-korean-media"
    BucketAudio   = "lemon-korean-media"
    BucketVideo   = "lemon-korean-media"
)
```

### 4. Media Service 경로 구조 수정
`services/media/handlers/media_handler.go`에서 폴더 경로 추가:
```go
// Before: 파일명만 사용
object, err := h.minioClient.GetObject(ctx, config.BucketImages, key, ...)

// After: 폴더 경로 포함
objectKey := "images/" + key
object, err := h.minioClient.GetObject(ctx, config.BucketImages, objectKey, ...)
```

수정된 함수:
- `ServeImage`: `images/` 접두사 추가
- `ServeAudio`: `audio/` 접두사 추가
- `ServeThumbnail`: `images/` 접두사 추가
- `DeleteMedia`: `{mediaType}/` 접두사 추가

## 변경된 파일

| 파일 | 변경 내용 |
|------|----------|
| `.env` | `API_BASE_URL`을 `https://lemon.3chan.kr`로 변경 |
| `services/admin/src/services/media-upload.service.js` | PUBLIC_URL 상수 추가, 3곳 URL 수정 |
| `services/media/config/minio.go` | 버킷 상수를 `lemon-korean-media`로 통일 |
| `services/media/handlers/media_handler.go` | 4개 함수에서 폴더 경로 추가 |

## 테스트

### 검증 절차
```bash
# 1. 서비스 재시작
docker compose restart admin-service
docker compose up -d --build media-service

# 2. 이미지 접근 테스트
curl -I "https://lemon.3chan.kr/media/images/ccd3eb9df282a6d57a07b7d3bcddc9d4.png"
# 결과: HTTP/2 200
```

### 결과
- URL 복사: `https://lemon.3chan.kr/media/images/xxx.png` (정상)
- 이미지 접근: HTTP 200 (정상)

## 관련 참고사항
- Admin Service와 Media Service가 이제 동일한 MinIO 버킷 구조 사용
- 버킷: `lemon-korean-media`
- 폴더 구조: `images/`, `audio/`, `video/`
