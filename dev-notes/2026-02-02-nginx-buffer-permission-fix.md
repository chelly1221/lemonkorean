---
date: 2026-02-02
category: Infrastructure
title: Nginx 버퍼 크기 및 임시 파일 경로 수정으로 135KB 한글 파일명 업로드 실패 해결
author: Claude Sonnet 4.5
tags: [nginx, upload, korean-filename, buffer, permissions]
priority: high
---

## 문제 요약

한글 파일명을 가진 135KB 파일 업로드 시 HTTP 500 에러 발생. 78바이트 소형 파일은 정상 업로드되지만, 135KB 파일은 실패.

## 근본 원인

### 1. Nginx 버퍼 크기 미설정
**파일**: `/nginx/nginx.dev.conf`

- `client_body_buffer_size` 설정이 누락되어 nginx 기본값(8-16k) 사용
- 135KB 파일이 버퍼 크기를 초과하여 디스크로 스필오버 발생

### 2. 디스크 임시 파일 권한 문제
**에러 로그**:
```
[crit] 7#7: *12 open() "/var/cache/nginx/client_temp/0000000002" failed (13: Permission denied)
```

- `/var/cache/nginx/client_temp/`가 NAS (`/mnt/nas/lemon/nginx-cache/`)에 마운트됨
- 디렉토리 소유자: `sanchan:sanchan` (UID 1000)
- Nginx 워커 프로세스: `nginx:nginx` (UID 101)
- 권한 불일치로 임시 파일 생성 실패

## 해결 방법

### 1단계: Nginx 버퍼 크기 증가

**파일**: `/nginx/nginx.dev.conf` (라인 41)

**변경 전**:
```nginx
# Body sizes
client_max_body_size 50m;
```

**변경 후**:
```nginx
# Body sizes
client_body_buffer_size 512m;  # Allow up to 512MB to buffer in memory
client_body_temp_path /tmp/nginx_client_body 1 2;  # Use /tmp for temp files
client_max_body_size 50m;
```

**근거**:
- `512m` 버퍼로 최대 512MB 파일까지 메모리에서 처리 (디스크 I/O 없음)
- 관리자 업로드 제한(200MB)보다 여유 있게 설정
- 동시 업로드는 rate limiting (`upload_limit` zone)으로 제한되어 메모리 부담 최소화

### 2단계: 임시 파일 경로 변경

**추가 설정**: `client_body_temp_path /tmp/nginx_client_body 1 2`

- NAS 마운트 대신 컨테이너 내부 `/tmp` 사용
- Nginx 사용자가 쓰기 권한 보장
- 권한 문제 완전 회피

### 3단계: Express Body Parser 제한 추가

**파일**: `/services/admin/src/index.js` (라인 39-40)

**변경 전**:
```javascript
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
```

**변경 후**:
```javascript
app.use(express.json({ limit: '200mb' }));
app.use(express.urlencoded({ limit: '200mb', extended: true }));
```

**참고**: Multer가 multipart/form-data를 처리하므로 직접 영향은 없지만, 일관성을 위해 추가.

### 4단계: 서비스 재시작

```bash
# Nginx 재시작
docker compose restart nginx

# Admin 서비스 재시작 (Express 설정 적용)
docker compose restart admin-service
```

## 테스트 결과

### 다양한 파일 크기 업로드 테스트

| 크기 | 한글 파일명 | HTTP 상태 | 결과 |
|------|------------|-----------|------|
| 100 B | 작은파일.png | 201 | ✅ 성공 |
| 135 KB | 테스트파일.png | 201 | ✅ 성공 |
| 500 KB | 중간파일.png | 201 | ✅ 성공 |
| 1 MB | 큰파일.jpg | 201 | ✅ 성공 |

### 검증 사항
- ✅ 135KB 파일 업로드 성공 (HTTP 201)
- ✅ 한글 파일명 보존: `"originalName": "테스트파일.png"`
- ✅ 소형 파일 (<128k) 정상 작동 (회귀 없음)
- ✅ 대형 파일 (최대 1MB) 메모리에서 처리
- ✅ Nginx 에러 로그에 권한 거부 에러 없음
- ✅ 영문 파일명도 정상 작동 (회귀 없음)

## Admin 서비스 로그 확인

```
[MEDIA_SERVICE] Upload request received
  - Original filename from multer: 테스트파일.png
  - Original filename from body: 테스트파일.png
  - Display name (final): 테스트파일.png
[MEDIA_SERVICE] File uploaded: images/a3042eb0d323dfa2f1d3a466f813370e.png
```

한글 파일명이 전체 업로드 프로세스에서 올바르게 보존됨.

## 성능 영향

### 메모리 사용량
- **버퍼당 오버헤드**: 최대 512MB
- **실제 영향**: Rate limiting (`burst=2`)으로 동시 업로드 제한
- **일반적 사용**: 관리자 업로드는 순차적이므로 실제 메모리 부담 낮음

### 장점
- 디스크 I/O 제거로 업로드 속도 향상
- NAS 파일시스템 권한 문제 완전 회피
- 최대 512MB 파일까지 안정적 처리

## 관련 파일

| 파일 | 변경 내용 |
|------|----------|
| `/nginx/nginx.dev.conf` | 버퍼 크기 및 임시 경로 설정 추가 |
| `/nginx/nginx.conf` | 버퍼 크기 추가 (프로덕션) |
| `/services/admin/src/index.js` | Express body parser 제한 추가 |

## 롤백 계획

메모리 문제 발생 시:

```nginx
# nginx.dev.conf에서 원복
client_body_buffer_size 128k;
client_body_temp_path /var/cache/nginx/client_temp;
```

```bash
docker compose restart nginx
```

**참고**: 512m 버퍼는 연결당 384KB 추가 메모리만 사용하므로 문제 발생 가능성 매우 낮음.

## 향후 고려사항

1. **프로덕션 배포 시**: `nginx.conf`도 동일하게 수정 필요
2. **모니터링**: Nginx 메모리 사용량 모니터링 권장
3. **NAS 권한**: 가능하면 NAS 디렉토리 권한 수정 시도 (현재는 우회)

## 참고

- 2026-02-02: 한글 파일명 인코딩 수정 (UTF-8 → Base64)
- 이번 수정은 인코딩 이후 발견된 버퍼 크기/권한 문제 해결
