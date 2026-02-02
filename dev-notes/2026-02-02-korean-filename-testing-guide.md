---
date: 2026-02-02
category: Documentation
title: 한국어 파일명 업로드 테스트 가이드
author: Claude Sonnet 4.5
tags: [testing, media-upload, korean, admin]
priority: high
---

## 개요

이 문서는 관리자 인터페이스에서 한국어 파일명 업로드 수정을 테스트하는 방법을 설명합니다.

## 수정 내용 요약

1. **Multer 인코딩 수정**: Latin1으로 받은 UTF-8 파일명을 올바르게 재인코딩
2. **상세 디버깅 로그**: 업로드 플로우 전체를 추적할 수 있는 로그 추가
3. **Extension 추출 개선**: Fallback 로직 추가로 안정성 향상

## 테스트 준비

### 1. 테스트 이미지 준비

다음과 같은 한국어 파일명으로 테스트 이미지를 준비:

```bash
# 테스트 이미지 생성 (임시 디렉토리)
mkdir -p /tmp/korean-filename-test
cd /tmp/korean-filename-test

# 간단한 PNG 이미지 생성
convert -size 100x100 xc:red 테스트.png 2>/dev/null || \
  echo "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAFUlEQVR42mNk+M9Qz0AEYBxVSF+FAP0wDgXVfUEFAAAAAElFTkSuQmCC" | base64 -d > 테스트.png

# 다양한 테스트 케이스
cp 테스트.png "테스트 이미지.png"
cp 테스트.png "test테스트.png"
cp 테스트.png "이미지123.png"
cp 테스트.png "아주긴한국어파일이름테스트예시파일입니다.png"
```

또는 기존 이미지 파일을 한국어 이름으로 복사하여 사용.

### 2. Admin Dashboard 접속

```
URL: https://lemon.3chan.kr/admin/
```

관리자 계정으로 로그인 필요.

## 테스트 시나리오

### Scenario 1: 기본 한국어 파일명

1. Media Management 메뉴로 이동
2. `테스트.png` 파일 선택
3. "Upload" 버튼 클릭
4. **예상 결과**:
   - ✅ 업로드 성공 (201 Created)
   - ✅ 파일 갤러리에 표시됨
   - ✅ 파일명 "테스트.png"로 올바르게 표시

### Scenario 2: 공백 포함 한국어 파일명

1. `테스트 이미지.png` 파일 업로드
2. **예상 결과**:
   - ✅ 업로드 성공
   - ✅ 공백 포함된 파일명 올바르게 표시

### Scenario 3: 한영 혼합 파일명

1. `test테스트.png` 파일 업로드
2. **예상 결과**:
   - ✅ 업로드 성공
   - ✅ 한영 혼합 파일명 올바르게 표시

### Scenario 4: 숫자 포함 한국어 파일명

1. `이미지123.png` 파일 업로드
2. **예상 결과**:
   - ✅ 업로드 성공
   - ✅ 숫자 포함된 파일명 올바르게 표시

### Scenario 5: 매우 긴 한국어 파일명

1. `아주긴한국어파일이름테스트예시파일입니다.png` 파일 업로드
2. **예상 결과**:
   - ✅ 업로드 성공
   - ✅ 긴 파일명 올바르게 표시 (UI에서 말줄임 가능)

## 브라우저 DevTools로 확인

### Network 탭

1. DevTools 열기 (F12)
2. Network 탭 선택
3. 파일 업로드 수행
4. `/api/admin/media/upload` 요청 클릭

**Request 확인**:
```
Method: POST
Content-Type: multipart/form-data
Payload:
  - file: (binary)
  - type: images
  - originalName: 테스트.png  ← 한국어가 올바르게 전송되는지 확인
```

**Response 확인**:
```json
{
  "success": true,
  "message": "File uploaded successfully",
  "data": {
    "key": "images/abc123def456.png",
    "url": "https://lemon.3chan.kr/media/images/abc123def456.png",
    "originalName": "테스트.png",  ← 한국어가 올바르게 반환되는지 확인
    "mimeType": "image/png",
    "size": 12345,
    "type": "images"
  }
}
```

**Status Code**:
- ✅ 성공: `201 Created`
- ❌ 실패: `500 Internal Server Error` (수정 전)

## 서버 로그 확인

### Admin Service 로그

```bash
# 실시간 로그 모니터링
docker compose logs -f admin-service

# 또는 최근 100줄 확인
docker compose logs --tail=100 admin-service
```

### 예상 로그 출력 (한국어 파일명 업로드 시)

```
[MULTER] Filename already in UTF-8: 테스트.png
[MEDIA_SERVICE] Upload request received
  - Type: images
  - Original filename from multer: 테스트.png
  - Original filename from body: 테스트.png
  - Display name (final): 테스트.png
  - File size: 12345 bytes
  - MIME type: image/png
  - Extracted extension: .png
  - Generated filename: abc123def456.png
  - Object key: images/abc123def456.png
  - Base64 encoded name: 7YWM7Iqk7Yq4LnBuZw==
[MINIO] Bucket exists: lemon-korean-media
[MEDIA_SERVICE] File uploaded: images/abc123def456.png
```

**중요 포인트**:
- `Original filename from multer`에 한국어가 깨지지 않고 표시되어야 함
- `Base64 encoded name`에 Base64로 인코딩된 문자열이 표시되어야 함

### 로그에서 에러 찾기

```bash
# 에러 로그만 필터링
docker compose logs admin-service | grep -i error

# 업로드 관련 로그 필터링
docker compose logs admin-service | grep -i "upload\|media_service"
```

## MinIO 메타데이터 확인

업로드된 파일의 메타데이터를 직접 확인:

```bash
# MinIO client 사용
docker compose exec minio mc stat local/lemon-korean-media/images/<generated-filename>.png
```

**예상 출력**:
```
Name      : images/abc123def456.png
Date      : 2026-02-02 05:15:00 UTC
Size      : 12 KiB
ETag      : ...
Type      : image/png
Metadata  :
  Content-Type: image/png
  X-Original-Name: 7YWM7Iqk7Yq4LnBuZw==  ← Base64로 인코딩된 한국어 파일명
  X-Uploaded-By: admin-service
```

**Base64 디코딩 검증**:
```bash
# Base64 문자열 디코딩
echo "7YWM7Iqk7Yq4LnBuZw==" | base64 -d
# 출력: 테스트.png
```

## 에러 발생 시 디버깅

### Case 1: 여전히 500 에러 발생

```bash
# 1. Admin service 로그 전체 확인
docker compose logs --tail=200 admin-service

# 2. 에러 스택 트레이스 찾기
docker compose logs admin-service | grep -A 20 "Error uploading file"

# 3. MinIO 연결 확인
docker compose logs minio --tail=50

# 4. Nginx 로그 확인
docker compose logs nginx --tail=50 | grep "admin"
```

### Case 2: 파일명이 여전히 깨짐

```bash
# 1. Multer 로그 확인
docker compose logs admin-service | grep MULTER

# 2. 재인코딩이 작동하는지 확인
# "Re-encoded filename from latin1 to utf8" 메시지가 보여야 함

# 3. 그래도 깨진다면 브라우저 콘솔 확인
# FormData의 originalName이 올바르게 전송되는지 확인
```

### Case 3: Base64 인코딩 실패

```bash
# Base64 인코딩 로그 확인
docker compose logs admin-service | grep "Base64 encoded name"

# 출력이 없다면 서비스 재시작
docker compose restart admin-service
```

## 회귀(Regression) 테스트

한국어 파일명 수정이 기존 영문 파일명 업로드에 영향을 주지 않는지 확인:

### Test 1: 영문 파일명
- 파일: `test.png`
- **예상 결과**: ✅ 정상 업로드

### Test 2: 숫자 파일명
- 파일: `12345.png`
- **예상 결과**: ✅ 정상 업로드

### Test 3: 특수문자 포함
- 파일: `test_file-01.png`
- **예상 결과**: ✅ 정상 업로드

## 성공 체크리스트

업로드 테스트 후 다음 항목을 확인:

- [ ] 한국어 파일명 업로드 시 500 에러 없음
- [ ] 브라우저 Network 탭에서 201 Created 응답
- [ ] Response JSON에 한국어 originalName 포함
- [ ] 파일 갤러리에서 한국어 이름 올바르게 표시
- [ ] Admin service 로그에서 한국어 문자 깨짐 없이 표시
- [ ] MinIO 메타데이터에 Base64 인코딩된 X-Original-Name 저장
- [ ] 영문 파일명 여전히 정상 작동 (regression 없음)

## 문제 발생 시 연락

테스트 중 문제가 발생하면:

1. 위의 디버깅 단계 수행
2. 에러 로그 캡처
3. 브라우저 DevTools Network 탭 스크린샷
4. 관련 정보를 개발 팀에 전달

## 관련 문서

- `/dev-notes/2026-02-02-korean-filename-upload-fix.md` - 상세 수정 내용
- `/dev-notes/2026-02-02-admin-media-upload-fix.md` - 기존 관련 이슈

---

**마지막 업데이트**: 2026-02-02
**테스트 상태**: 대기 중
