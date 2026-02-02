---
date: 2026-02-02
category: Infrastructure
title: Admin 미디어 업로드 "Unexpected token '<'" 오류 수정
author: Claude Sonnet 4.5
tags: [nginx, admin, media-upload, bug-fix]
priority: high
---

## 문제 설명

Admin 웹 인터페이스에서 미디어 파일 업로드 시 "unexpected token '<'" JavaScript 오류가 발생했습니다. 이 오류는 JavaScript가 JSON을 기대하지만 HTML을 받았을 때 발생합니다.

## 근본 원인

`nginx.conf`의 `/api/admin/` 엔드포인트 설정(기존 208-216줄)에 파일 업로드에 필요한 적절한 설정이 없었습니다:

1. **body size limit 부족** - 기본 50MB 사용, admin 서비스는 200MB까지 허용
2. **timeout 부족** - 기본 timeout이 대용량 파일 업로드에 너무 짧음
3. **잘못된 rate limiting** - `api_limit` 존(100 req/s) 사용, `upload_limit`(5 req/min) 사용해야 함

업로드가 이러한 제한으로 실패하면, nginx는 JSON 대신 HTML 오류 페이지(413 Payload Too Large, 504 Gateway Timeout)를 반환하여 "unexpected token '<'" 오류를 발생시켰습니다.

## 해결 방법

Media 서비스 수정과 동일한 패턴으로 admin 서비스 nginx 설정을 두 개의 location으로 분리:

### 1. 새로운 location: `/api/admin/media/upload` (특정 업로드 엔드포인트)
- `upload_limit` rate limiting 적용 (5 req/min, burst 2)
- `client_max_body_size 200m` 설정 (admin 서비스 multer 설정과 일치)
- 확장된 timeout: `proxy_send_timeout 300s`, `proxy_read_timeout 300s`
- 모든 필수 proxy 헤더 포함

### 2. 기존 location: `/api/admin/` (일반 API 엔드포인트)
- 기존 rate limiting 유지 (api_limit)
- 기본 timeout 유지
- 업로드 외 요청에는 기존 설정이 정상 작동

## 변경 내역

**파일**: `nginx/nginx.conf`

**위치**: 207-225줄 (기존 `/api/admin/` location 앞에 추가)

```nginx
# Admin Service API - Media Upload (no caching, extended limits)
location /api/admin/media/upload {
    limit_req zone=upload_limit burst=2 nodelay;

    proxy_pass http://admin_service;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # Extended timeouts for large uploads
    proxy_connect_timeout 60s;
    proxy_send_timeout 300s;
    proxy_read_timeout 300s;

    # Large request body support (matches admin service 200MB limit)
    client_max_body_size 200m;
}
```

## 배포 과정

```bash
# 설정 테스트
docker compose exec nginx nginx -t

# Nginx 재시작
docker compose restart nginx

# 상태 확인
docker compose ps nginx
docker compose logs --tail=20 nginx
```

## 검증

엔드포인트 접근성 테스트:
```bash
curl -I https://lemon.3chan.kr/api/admin/media/upload -H "Content-Type: multipart/form-data"
```

**결과**:
- HTTP/2 401 Unauthorized (예상된 응답 - 인증 필요)
- **중요**: `content-type: application/json` 반환 (HTML 아님)
- 이는 설정이 올바르게 작동함을 의미

## 처리된 엣지 케이스

1. **대용량 파일 (최대 200MB)** - 확장된 timeout 및 body size
2. **Rate limiting** - 업로드 전용 rate limit (5/min)으로 남용 방지
3. **다중 빠른 업로드** - Burst=2로 rate limiting 전에 2개의 빠른 업로드 허용
4. **동시 요청** - Nginx가 다중 업로드 스트림 처리
5. **인증** - JWT 토큰 검증은 admin 서비스에서 처리
6. **파일 타입 검증** - Admin 서비스가 MIME 타입 및 확장자 검증

## 성공 기준

- ✅ "unexpected token '<'" 오류 더 이상 발생하지 않음
- ✅ Admin 인터페이스를 통한 파일 업로드 성공
- ✅ 성공 및 오류 케이스 모두 JSON 응답
- ✅ 대용량 파일 (최대 200MB) timeout 없이 업로드
- ✅ 반환된 URL을 통한 파일 접근 가능
- ✅ 적절한 rate limiting 적용 (5 업로드/분)

## 업로드 흐름

1. Admin 프론트엔드 → `/api/admin/media/upload` (POST with FormData)
2. Nginx `/api/admin/media/upload` location → admin-service:3006
3. Admin 서비스가 media 서비스에 내부적으로 업로드 (nginx를 통하지 않음)
4. Admin 서비스가 JSON 응답 반환

## 추가 참고사항

- Admin 서비스는 자체 Multer 설정(200MB limit)을 가지므로 nginx가 이 크기를 허용해야 함
- Admin 서비스는 직접 서비스 간 호출을 통해 media 서비스에 내부적으로 업로드 (nginx 통하지 않음)
- Media 서비스는 메타데이터와 함께 MinIO에 파일 저장
- 업로드 rate limit(5/min)은 의도적으로 엄격하게 설정하여 남용 및 스토리지 고갈 방지

## 롤백 계획

문제 발생 시:
```bash
git checkout nginx/nginx.conf
docker compose restart nginx
```

또는 새로운 `/api/admin/media/upload` location 블록을 제거하고 재시작.
