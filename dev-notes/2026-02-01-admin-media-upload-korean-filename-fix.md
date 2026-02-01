---
date: 2026-02-01
category: Backend
title: Admin 미디어 업로드 한국어 파일명 및 목록 조회 수정
author: Claude Opus 4.5
tags: [bugfix, admin, media, minio, encoding, base64, unicode]
priority: high
---

# Admin 미디어 업로드 한국어 파일명 및 목록 조회 수정

## 개요
Admin 웹에서 한국어 파일명으로 미디어 업로드 시 발생하던 500 에러와 업로드된 파일이 목록에 표시되지 않는 문제, 그리고 한국어 파일명이 깨져서 표시되는 문제를 수정했습니다.

## 문제 / 배경

### 문제 1: 한국어 파일명 업로드 실패 (1차 수정)
- **증상**: 한국어 파일명(예: `테스트이미지.png`)으로 업로드 시 500 Internal Server Error
- **에러**: `SignatureDoesNotMatch` - MinIO 서명 불일치
- **원인**: MinIO 메타데이터의 `X-Original-Name` 헤더에 한국어(non-ASCII) 문자가 포함되면 HTTP 헤더 인코딩 문제로 서명 계산 실패

### 문제 2: 업로드된 파일 목록 미표시 (1차 수정)
- **증상**: 파일 업로드 성공 후에도 미디어 갤러리에 0개 파일 표시
- **원인**: `listObjects`의 recursive 파라미터가 `false`여서 디렉토리(prefix)만 반환하고 실제 파일을 반환하지 않음

### 문제 3: 한국어 파일명 깨짐 (2차 수정)
- **증상**: 한국어 파일명이 `????.png` 또는 `Ã¬ÂÂÃÂÂ¤Ã­ÂÂ.jpg` 형태로 표시
- **원인**:
  - MinIO 메타데이터 키 대소문자 불일치 (`X-Original-Name` vs `x-original-name`)
  - 프론트엔드의 복잡한 인코딩 체인 (`btoa(unescape(encodeURIComponent()))`)
  - `encodeURIComponent()`만으로는 HTTP 헤더에서 불완전한 해결

## 해결 / 구현

### 1차 수정: 한국어 파일명 인코딩
`X-Original-Name` 메타데이터를 URL 인코딩하여 non-ASCII 문자 문제 해결

### 1차 수정: 파일 목록 조회
`listObjects`의 recursive 파라미터를 `true`로 변경하여 모든 파일 조회

### 2차 수정: Base64 인코딩으로 메타데이터 저장
HTTP 헤더에서 가장 안정적인 방법인 Base64 인코딩 사용

```javascript
// Before: URL 인코딩 (일부 깨짐 발생)
'X-Original-Name': encodeURIComponent(displayName),

// After: Base64 인코딩 (ASCII 안전)
'X-Original-Name': Buffer.from(displayName, 'utf8').toString('base64'),
```

### 2차 수정: 대소문자 무관 키 조회 + 폴백 디코딩
MinIO가 키를 다양한 형식으로 반환할 수 있으므로 대소문자 무관하게 검색

```javascript
// Before: 소문자 키만 조회
if (stat.metaData && stat.metaData['x-original-name']) {
  originalName = decodeURIComponent(stat.metaData['x-original-name']);
}

// After: 대소문자 무관 + Base64/URL 디코딩 폴백
if (stat.metaData) {
  const metaKeys = Object.keys(stat.metaData);
  const nameKey = metaKeys.find(k => k.toLowerCase() === 'x-original-name');
  if (nameKey && stat.metaData[nameKey]) {
    const rawValue = stat.metaData[nameKey];
    try {
      originalName = Buffer.from(rawValue, 'base64').toString('utf8');
    } catch (decodeErr) {
      try {
        originalName = decodeURIComponent(rawValue);
      } catch (urlDecodeErr) {
        originalName = rawValue;
      }
    }
  }
}
```

### 2차 수정: 프론트엔드 인코딩 단순화

```javascript
// Before: 복잡한 Base64 인코딩 체인 (deprecated unescape 사용)
formData.append('originalNameBase64', btoa(unescape(encodeURIComponent(file.name))));

// After: 단순히 파일명 전송 (백엔드에서 처리)
formData.append('originalName', file.name);
```

### 2차 수정: 백엔드 컨트롤러 단순화

```javascript
// Before: 복잡한 디코딩 로직
const { type = 'images', originalName, originalNameBase64 } = req.body;
let decodedOriginalName = originalName;
if (originalNameBase64) {
  try {
    decodedOriginalName = Buffer.from(originalNameBase64, 'base64').toString('utf8');
  } catch (e) { ... }
}

// After: 단순화
const { type = 'images', originalName } = req.body;
const displayName = originalName || req.file.originalname;
```

## 변경 파일
- `/services/admin/src/services/media-upload.service.js` - 메타데이터 Base64 저장/조회
- `/services/admin/public/js/pages/media.js` - 프론트엔드 인코딩 단순화
- `/services/admin/src/controllers/media.controller.js` - 컨트롤러 단순화

## 테스트

### 한국어 파일명 업로드 테스트
```bash
# 토큰 획득
TOKEN=$(curl -s -X POST http://localhost/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@lemon.com","password":"admin123"}' | jq -r '.token')

# 한국어 파일명 업로드
curl -s -X POST "http://localhost/api/admin/media/upload" \
  -H "Authorization: Bearer $TOKEN" \
  -F "file=@/tmp/테스트이미지.png" \
  -F "type=images"
# 결과: {"success":true,...}
```

### 파일 목록 조회 테스트
```bash
curl -s "http://localhost/api/admin/media" \
  -H "Authorization: Bearer $TOKEN" | jq '.count'
# 결과: 10 (실제 파일 수)
```

### 웹 UI 테스트
1. https://lemon.3chan.kr/admin/ → 미디어 관리
2. 한국어/중국어 파일명 이미지 드래그 앤 드롭
   - `테스트이미지.png`
   - `测试图片.jpg`
   - `테스트_test_测试.png`
3. "업로드 완료" 메시지 확인
4. 갤러리에서 **원본 파일명 정상 표시** 확인

## 기존 파일 호환성
- 기존에 `encodeURIComponent()`로 저장된 파일도 폴백 로직으로 정상 표시
- 디코딩 순서: Base64 → URL decode → 원본 값

## 관련 이슈 / 참고
- MinIO JS 클라이언트 7.x에서 메타데이터에 non-ASCII 문자 사용 시 서명 문제 발생
- HTTP/1.1 헤더는 ISO-8859-1 인코딩 사용 (ASCII 확장)으로 UTF-8 직접 사용 불가
- Base64는 모든 바이트를 ASCII 안전 문자로 변환하여 가장 안정적
- 이전 수정: Audit 로그 상태값 수정 (`/dev-notes/2026-02-01-admin-media-upload-audit-fix.md`)
