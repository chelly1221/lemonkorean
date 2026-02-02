---
date: 2026-02-02
category: Backend
title: 한국어 파일명 업로드 500 에러 수정
author: Claude Sonnet 4.5
tags: [admin, media-upload, korean, encoding, multer, debugging]
priority: high
---

## 문제 상황

관리자 웹 인터페이스(`/admin/`)에서 한국어 파일명을 가진 파일 업로드 시 500 Internal Server Error 발생.
영문 파일명은 정상 작동.

## 조사 결과

### 기존 수정 사항 확인
- **Base64 인코딩 수정 이미 존재**: `/services/admin/src/services/media-upload.service.js:43`에 Base64 인코딩 구현됨
- **커밋 기록**: `3612f29` (2026-02-01)에서 한국어 파일명 수정 문서화됨
- **추정 원인**: Admin 서비스 컨테이너가 구 코드를 실행 중이거나, 다른 에러 발생

### 근본 원인 분석

**Multer 인코딩 문제**: Multer가 multipart form data를 파싱할 때 한국어 문자가 포함된 `req.file.originalname`이 깨질 수 있음.

Multer는 기본적으로 filename을 latin1 인코딩으로 받아들이는데, 브라우저가 UTF-8로 전송하면 mojibake(문자 깨짐) 발생.

## 구현된 수정 사항

### 1. Enhanced Logging 추가 (`media-upload.service.js`)

**위치**: `/services/admin/src/services/media-upload.service.js:19-46`

```javascript
console.log(`[MEDIA_SERVICE] Upload request received`);
console.log(`  - Type: ${type}`);
console.log(`  - Original filename from multer: ${file.originalname}`);
console.log(`  - Original filename from body: ${originalName}`);
console.log(`  - Display name (final): ${displayName}`);
console.log(`  - File size: ${file.size} bytes`);
console.log(`  - MIME type: ${file.mimetype}`);
// ... extension extraction with fallback ...
console.log(`  - Extracted extension: ${fileExt}`);
console.log(`  - Generated filename: ${fileName}`);
console.log(`  - Object key: ${objectKey}`);
console.log(`  - Base64 encoded name: ${base64Name}`);
```

**목적**:
- 업로드 요청의 전체 플로우 추적
- 한국어 파일명이 어느 단계에서 깨지는지 확인
- Extension 추출 실패 시 fallback 제공

### 2. Multer fileFilter 인코딩 수정 (`media.routes.js`)

**위치**: `/services/admin/src/routes/media.routes.js:14-51`

**핵심 로직**:

```javascript
fileFilter: (req, file, cb) => {
  try {
    const originalName = file.originalname;

    // ASCII 파일명은 변환 불필요
    if (/^[\x00-\x7F]*$/.test(originalName)) {
      cb(null, true);
      return;
    }

    // latin1으로 인코딩된 UTF-8을 재변환
    try {
      const reencoded = Buffer.from(originalName, 'latin1').toString('utf8');
      if (reencoded !== originalName && !/�/.test(reencoded)) {
        console.log('[MULTER] Re-encoded filename from latin1 to utf8');
        file.originalname = reencoded;
      }
    } catch (err) {
      console.warn('[MULTER] Failed to re-encode filename:', err.message);
    }

    cb(null, true);
  } catch (error) {
    console.error('[MULTER] Error in fileFilter:', error);
    cb(null, true); // 인코딩 이슈로 업로드 차단하지 않음
  }
}
```

**작동 원리**:
1. **ASCII 검사**: 순수 ASCII 파일명은 변환 건너뜀
2. **Latin1→UTF-8 재인코딩**: Multer가 latin1으로 받은 UTF-8 문자를 올바르게 재변환
3. **Fallback 안전장치**: 인코딩 실패 시에도 업로드 차단하지 않음

### 3. Extension 추출 개선

**위치**: `/services/admin/src/services/media-upload.service.js:29-40`

```javascript
let fileExt = '';
try {
  fileExt = path.extname(file.originalname);
  if (!fileExt && displayName) {
    // Fallback: displayName에서 추출
    const dotIndex = displayName.lastIndexOf('.');
    fileExt = dotIndex >= 0 ? displayName.substring(dotIndex) : '';
  }
} catch (err) {
  console.warn('[MEDIA_SERVICE] Failed to extract extension:', err.message);
  fileExt = '';
}
```

**개선 사항**:
- `path.extname()` 실패 시 fallback 로직
- `displayName`(프론트엔드에서 직접 전송)에서 확장자 추출
- 에러 발생 시에도 업로드 계속 진행

## 업로드 플로우

```
Frontend (media.js:113)
  ↓ FormData.append('originalName', file.name) [한국어]
  ↓ POST /api/admin/media/upload
Nginx
  ↓
Multer Middleware (media.routes.js:14-51)
  ↓ fileFilter: latin1 → UTF-8 재인코딩
  ↓ req.file.originalname [한국어 복원]
  ↓ req.body.originalName [한국어 원본]
Controller (media.controller.js:24)
  ↓ displayName = originalName || req.file.originalname
Service (media-upload.service.js:19-65)
  ↓ Extension 추출 (fallback 포함)
  ↓ Base64 인코딩: Buffer.from(displayName, 'utf8').toString('base64')
  ↓ MinIO metadata: 'X-Original-Name': base64Name
MinIO
  ✓ 업로드 완료
```

## 테스트 시나리오

### 기본 테스트 케이스

1. **단순 한국어**: `테스트.png`
2. **공백 포함**: `테스트 이미지.jpg`
3. **한영 혼합**: `test테스트.png`
4. **숫자 포함**: `이미지123.png`
5. **긴 파일명**: `아주긴한국어파일이름테스트.jpg`

### 엣지 케이스

1. **매우 긴 파일명** (50+ 글자)
2. **특수 한국어 문자** (ㄱㄴㄷ, ㅏㅑㅓ 자모)
3. **혼합 스크립트**: `test테스트123.png`
4. **특수문자 포함**: `이미지(1).png`, `테스트_파일.jpg`
5. **여러 점**: `file.name.테스트.png`
6. **공백과 탭**: `테 스 트.png`

### 검증 방법

```bash
# 1. Admin service 로그 확인
docker compose logs --tail=100 admin-service | grep -A 10 "Upload request"

# 2. MinIO 메타데이터 확인
docker compose exec minio mc stat local/lemon-korean-media/images/<filename>.png

# 3. 브라우저 DevTools Network 탭
# Request:
#   - Form Data: originalName: 테스트.png
# Response:
#   - Status: 201 Created
#   - Body: { "success": true, "data": { "originalName": "테스트.png", ... } }
```

## 관련 파일

- `/services/admin/src/services/media-upload.service.js` (19-65행) - 업로드 서비스 + 로깅
- `/services/admin/src/routes/media.routes.js` (14-51행) - Multer 인코딩 수정
- `/services/admin/src/controllers/media.controller.js` (12-67행) - 업로드 컨트롤러
- `/services/admin/public/js/pages/media.js` (110-113행) - 프론트엔드 업로드

## 적용 방법

```bash
# Admin service 재시작
docker compose restart admin-service

# 로그 확인
docker compose logs -f admin-service
```

## 성공 기준

- ✅ 한국어 파일명 업로드 시 500 에러 없음
- ✅ 원본 한국어 파일명 보존 및 올바르게 표시됨
- ✅ MinIO 메타데이터에 Base64 인코딩 작동
- ✅ 파일 갤러리에서 한국어 이름 깨짐 없이 표시
- ✅ 다운로드 시 한국어 파일명 보존
- ✅ 영문 파일명 여전히 정상 작동 (regression 없음)
- ✅ 한영 혼합 파일명 정상 작동

## 주의사항

### 디버깅 로그 정리

현재 구현에서는 상세한 디버깅 로그가 활성화되어 있습니다. 프로덕션에서 로그 스팸을 방지하려면 다음과 같이 필수 로그만 유지:

```javascript
// Before (현재 - 디버깅용)
console.log(`[MEDIA_SERVICE] Upload request received`);
console.log(`  - Type: ${type}`);
console.log(`  - Original filename from multer: ${file.originalname}`);
// ... 8줄의 로그 ...

// After (프로덕션 권장)
console.log(`[MEDIA_SERVICE] Uploading file: ${displayName} (${type})`);
// ... (상세 디버그 로그 제거) ...
console.log(`[MEDIA_SERVICE] File uploaded: ${objectKey}`);
```

### 백워드 호환성

- 기존 URL 인코딩된 파일명도 `listFiles`에서 fallback 디코딩 지원
- Base64 디코딩 실패 시 URL 디코딩 시도 (`media-upload.service.js:118-127`)

## 롤백 계획

문제 발생 시:

```bash
# 1. 코드 롤백
git checkout services/admin/src/services/media-upload.service.js
git checkout services/admin/src/routes/media.routes.js

# 2. 서비스 재시작
docker compose restart admin-service
```

## 참고

- Multer 인코딩 이슈: https://github.com/expressjs/multer/issues/1104
- HTTP 헤더는 ASCII 필수 → Base64 인코딩 필요
- 최신 브라우저(Chrome, Firefox, Safari)는 FormData UTF-8 지원

---

**상태**: ✅ 구현 완료 (테스트 대기)
**다음 단계**: 실제 한국어 파일명으로 업로드 테스트 수행
