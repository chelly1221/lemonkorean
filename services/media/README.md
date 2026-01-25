# Media Service

MinIO 기반 미디어 파일 관리 서비스 (이미지, 오디오, 비디오)

## 주요 기능

- 이미지 서빙 (자동 리사이징, WebP 변환)
- 오디오 스트리밍 (Range 요청 지원)
- 썸네일 자동 생성
- 미디어 업로드 (이미지 자동 최적화)
- 미디어 삭제
- HTTP 캐싱 (ETag, Cache-Control, Last-Modified)
- MinIO 객체 스토리지 통합

## API 엔드포인트

### 1. 이미지 서빙
```http
GET /media/images/:key?width=800&height=600&format=webp&quality=85
```

**Query Parameters:**
- `width` - 최대 너비 (픽셀)
- `height` - 최대 높이 (픽셀)
- `format` - 변환 포맷 (`webp`, `jpeg`, `png`)
- `quality` - JPEG 품질 (1-100, 기본값: 85)

**예제:**
```bash
# 원본 이미지
curl http://localhost:3004/media/images/1234567890_photo.jpg

# 800x600으로 리사이징
curl http://localhost:3004/media/images/1234567890_photo.jpg?width=800&height=600

# WebP로 변환 + 리사이징
curl http://localhost:3004/media/images/1234567890_photo.jpg?width=1200&format=webp&quality=80
```

**캐싱:**
- Cache-Control: public, max-age=604800 (7일)
- ETag 지원
- If-None-Match 헤더 처리

---

### 2. 오디오 스트리밍
```http
GET /media/audio/:key
```

**특징:**
- HTTP Range 요청 지원 (스트리밍)
- Accept-Ranges: bytes
- 브라우저 플레이어 호환

**예제:**
```bash
# 오디오 파일 스트리밍
curl http://localhost:3004/media/audio/1234567890_lesson1.mp3

# Range 요청 (특정 구간 재생)
curl -H "Range: bytes=0-1023" http://localhost:3004/media/audio/1234567890_lesson1.mp3
```

**캐싱:**
- Cache-Control: public, max-age=604800 (7일)
- ETag, Last-Modified 지원

---

### 3. 썸네일 생성/서빙
```http
GET /media/thumbnails/:key?size=200
```

**Query Parameters:**
- `size` - 썸네일 크기 (픽셀, 정사각형, 기본값: 200, 최대: 1000)

**예제:**
```bash
# 200x200 썸네일
curl http://localhost:3004/media/thumbnails/1234567890_photo.jpg

# 400x400 썸네일
curl http://localhost:3004/media/thumbnails/1234567890_photo.jpg?size=400
```

**특징:**
- 원본 비율 유지 (Fit)
- JPEG 포맷으로 출력
- X-Thumbnail-Size 헤더 포함

---

### 4. 미디어 업로드 (관리자용)
```http
POST /media/upload?type=images|audio|video
Content-Type: multipart/form-data
```

**Query Parameters:**
- `type` - 미디어 타입 (`images`, `audio`, `video`)

**Form Data:**
- `file` - 업로드할 파일

**예제:**
```bash
# 이미지 업로드 (자동 최적화)
curl -X POST http://localhost:3004/media/upload?type=images \
  -F "file=@photo.jpg"

# 오디오 업로드
curl -X POST http://localhost:3004/media/upload?type=audio \
  -F "file=@lesson1.mp3"

# 비디오 업로드
curl -X POST http://localhost:3004/media/upload?type=video \
  -F "file=@intro.mp4"
```

**응답:**
```json
{
  "success": true,
  "message": "File uploaded successfully",
  "type": "images",
  "key": "1234567890_photo.jpg",
  "url": "/media/images/1234567890_photo.jpg",
  "size": 102400,
  "content_type": "image/jpeg"
}
```

**이미지 최적화:**
- 자동 리사이징 (최대 1920x1920)
- JPEG 압축 (품질: 85)
- 메타데이터 제거

**지원 포맷:**
- 이미지: jpg, jpeg, png, gif, webp, bmp
- 오디오: mp3, wav, ogg, m4a, aac, flac
- 비디오: mp4, webm, mov, avi

---

### 5. 미디어 삭제 (관리자용)
```http
DELETE /media/:type/:key
```

**Path Parameters:**
- `type` - 미디어 타입 (`images`, `audio`, `video`)
- `key` - 파일 키 (파일명)

**예제:**
```bash
# 이미지 삭제
curl -X DELETE http://localhost:3004/media/images/1234567890_photo.jpg

# 오디오 삭제
curl -X DELETE http://localhost:3004/media/audio/1234567890_lesson1.mp3
```

**응답:**
```json
{
  "success": true,
  "message": "Media deleted successfully",
  "type": "images",
  "key": "1234567890_photo.jpg"
}
```

---

## 환경 변수

```env
# MinIO Configuration
MINIO_ENDPOINT=minio:9000
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secret_key
MINIO_USE_SSL=false

# Server
PORT=3004
NODE_ENV=production
```

---

## 실행 방법

### 로컬 개발
```bash
cd services/media

# 의존성 다운로드
go mod download

# 실행
go run main.go
```

### Docker
```bash
# 빌드
docker build -t lemon-media .

# 실행
docker run -p 3004:3004 \
  -e MINIO_ENDPOINT=minio:9000 \
  -e MINIO_ACCESS_KEY=admin \
  -e MINIO_SECRET_KEY=your_secret \
  lemon-media
```

### Docker Compose
```yaml
media-service:
  build: ./services/media
  ports:
    - "3004:3004"
  environment:
    - MINIO_ENDPOINT=minio:9000
    - MINIO_ACCESS_KEY=admin
    - MINIO_SECRET_KEY=${MINIO_SECRET_KEY}
  depends_on:
    - minio
```

---

## MinIO 버킷 구조

서비스 시작 시 자동 생성됩니다:

- `lemon-images` - 이미지 파일 (public-read 정책)
- `lemon-audio` - 오디오 파일
- `lemon-video` - 비디오 파일

---

## 캐싱 전략

### 브라우저 캐싱
- 이미지/오디오: 7일 (604800초)
- 비디오: 1일 (86400초)

### HTTP 헤더
```
Cache-Control: public, max-age=604800
ETag: "abc123..."
Last-Modified: Wed, 25 Jan 2026 10:00:00 GMT
Expires: Wed, 01 Feb 2026 10:00:00 GMT
Vary: Accept-Encoding
```

### CDN 통합
Nginx 앞단에 배치하여 추가 캐싱:
```nginx
location /media/ {
    proxy_pass http://media-service:3004;
    proxy_cache media_cache;
    proxy_cache_valid 200 7d;
    add_header X-Cache-Status $upstream_cache_status;
}
```

---

## 이미지 최적화 상세

### 이미지 최적화 설정
```go
config := utils.OptimizationConfig{
    MaxWidth:      1920,
    MaxHeight:     1920,
    Quality:       85,
    ConvertToWebP: false, // 요청 시 활성화
}
```

### 리샘플링 알고리즘
- Lanczos 필터 (고품질)
- 원본 비율 유지

### 압축
- JPEG: 품질 기반 압축
- PNG: BestCompression 레벨
- WebP: JPEG 품질과 동일 (활성화 시)

---

## 보안 고려사항

### 인증 미들웨어 추가 (TODO)
관리자 전용 엔드포인트에 인증 추가:
```go
// main.go
import "lemonkorean/media/middleware"

// Admin endpoints with auth
adminGroup := media.Group("/")
adminGroup.Use(middleware.AdminAuth())
{
    adminGroup.POST("/upload", mediaHandler.UploadMedia)
    adminGroup.DELETE("/:type/:key", mediaHandler.DeleteMedia)
}
```

### 파일 크기 제한
```go
// main.go
router.MaxMultipartMemory = 50 << 20 // 50 MB
```

### CORS 설정
현재 설정: `Access-Control-Allow-Origin: *`
프로덕션: 특정 도메인으로 제한

---

## 테스트

### 헬스체크
```bash
curl http://localhost:3004/health
```

**응답:**
```json
{
  "status": "ok",
  "service": "media-service",
  "time": "2026-01-25T10:00:00Z"
}
```

### 이미지 업로드 & 조회 테스트
```bash
# 1. 업로드
curl -X POST http://localhost:3004/media/upload?type=images \
  -F "file=@test.jpg" \
  | jq -r '.key'

# 2. 조회
curl http://localhost:3004/media/images/1234567890_test.jpg -o downloaded.jpg

# 3. 리사이징
curl "http://localhost:3004/media/images/1234567890_test.jpg?width=400" -o resized.jpg

# 4. 썸네일
curl "http://localhost:3004/media/thumbnails/1234567890_test.jpg?size=200" -o thumb.jpg

# 5. 삭제
curl -X DELETE http://localhost:3004/media/images/1234567890_test.jpg
```

---

## 성능

- **동시 요청**: Gin 프레임워크 (비동기 처리)
- **메모리**: 이미지 최적화 시 일시적 메모리 사용
- **스트리밍**: Range 요청으로 메모리 효율적
- **캐싱**: 7일 브라우저 캐싱으로 서버 부하 감소

---

## 문제 해결

### MinIO 연결 실패
```bash
# MinIO 상태 확인
docker logs minio

# 환경 변수 확인
echo $MINIO_ENDPOINT
echo $MINIO_ACCESS_KEY
```

### 이미지 최적화 실패
- ImageMagick 설치 확인: `which convert`
- libwebp 설치 확인: `which cwebp`
- Dockerfile에 포함됨: `apk add imagemagick libwebp-tools`

### 포트 충돌
```bash
# 포트 3004 사용 확인
sudo lsof -i :3004

# 다른 포트로 실행
PORT=3005 go run main.go
```

---

## 라이센스
MIT License
