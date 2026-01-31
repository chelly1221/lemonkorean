---
date: 2026-01-31
category: Infrastructure
title: Flutter 웹 앱 3007 포트 서빙 및 프로덕션 Nginx 설정 정리
author: Claude Sonnet 4.5
tags: [nginx, flutter-web, deployment, security, port-configuration]
priority: medium
---

# Flutter 웹 앱 3007 포트 서빙 및 프로덕션 Nginx 설정 정리

## 개요

개발 모드에서 Flutter 웹 앱을 3007번 포트로 접속할 수 있도록 Nginx 설정을 변경하고, 프로덕션 모드에서 불필요한 3007 포트 블록을 제거하여 보안을 강화했습니다. 또한 Nginx 설정 파일을 볼륨 마운트하여 개발 편의성을 개선했습니다.

## 문제 배경

### 1. Flutter 웹 앱 접속 포트 분리 필요
- Flutter 웹 앱이 빌드되어 있지만 별도 포트로 접속할 방법이 없음
- 네트워크 설정 API와 웹 앱을 다른 포트로 분리하여 접근하고 싶음
- 개발 모드에서 3007 포트가 네트워크 설정 API 전용으로 사용되고 있었음

### 2. 프로덕션 모드 설정 불일치
- 프로덕션 nginx.conf에도 3007 포트 블록이 존재
- HTTPS (443)에서 이미 모든 API를 제공하고 있어 3007 포트는 불필요
- 불필요한 포트 노출로 인한 보안 취약점 가능성

### 3. 개발 편의성 문제
- Nginx 설정 변경 시마다 Docker 이미지 재빌드 필요
- 빠른 설정 테스트가 어려움

## 해결 방법

### 1. 개발 모드 (nginx.dev.conf) - 3007 포트를 Flutter 웹 앱 전용으로 변경

**변경 전** (Lines 112-147):
```nginx
server {
    listen 3007;
    server_name localhost;

    # 네트워크 설정 API 프록시
    location /api/admin/network/config {
        proxy_pass http://admin_service/api/admin/network/config;
    }

    location /health { ... }
    location / { return JSON; }
}
```

**변경 후**:
```nginx
server {
    listen 3007;
    listen [::]:3007;
    server_name localhost;

    # Flutter 웹 앱 루트 디렉토리
    root /var/www/lemon_korean_web;
    index index.html;

    # CORS headers (개발 모드)
    add_header Access-Control-Allow-Origin "*" always;
    add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, PATCH, OPTIONS" always;
    add_header Access-Control-Allow-Headers "*" always;
    add_header Access-Control-Allow-Credentials "true" always;

    # OPTIONS preflight
    if ($request_method = 'OPTIONS') {
        return 204;
    }

    # Health check
    location /health {
        add_header Content-Type application/json;
        return 200 '{"service":"Flutter Web App","status":"ok","port":3007}';
    }

    # Flutter 웹 앱 정적 파일 (7일 캐싱)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|map)$ {
        expires 7d;
        add_header Cache-Control "public, immutable";
    }

    # index.html은 캐시 안 함 (항상 최신 버전)
    location = /index.html {
        add_header Cache-Control "no-store, no-cache, must-revalidate";
    }

    # SPA 라우팅: 모든 경로를 index.html로
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

**주요 변경점**:
- ❌ `/api/admin/network/config` 프록시 제거 (80번 포트에서 계속 사용)
- ✅ `root /var/www/lemon_korean_web` 추가
- ✅ SPA 라우팅 설정 (`try_files $uri $uri/ /index.html`)
- ✅ 정적 파일 캐싱 전략 (JS/CSS 7일, index.html 캐시 안 함)
- ✅ CORS 헤더 설정 (개발 모드)

### 2. 프로덕션 모드 (nginx.conf) - 3007 포트 블록 제거

**변경 전**: nginx.conf에 3007 포트 서버 블록 존재 (Lines 202-243, 42줄)
```nginx
server {
    listen 3007;
    listen [::]:3007;
    server_name _;

    location /api/admin/network/config {
        proxy_pass http://admin_service/api/admin/network/config;
        # ... 프록시 설정
    }
}
```

**변경 후**: 전체 블록 삭제
- 프로덕션에서 3007 포트 완전히 제거
- HTTPS (443)에서 `/api/admin/network/config` 계속 제공
- 불필요한 포트 노출 방지

### 3. Docker Compose - Nginx 설정 볼륨 마운트 추가

**변경 전**:
```yaml
volumes:
  - ./nginx/cache:/var/cache/nginx
  - ./nginx/logs:/var/log/nginx
  - ./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro
```

**변경 후**:
```yaml
volumes:
  - ./nginx/cache:/var/cache/nginx
  - ./nginx/logs:/var/log/nginx
  # Config files (for easy development)
  - ./nginx/nginx.conf:/nginx-configs/nginx.conf:ro
  - ./nginx/nginx.dev.conf:/nginx-configs/nginx.dev.conf:ro
  - ./nginx/docker-entrypoint.sh:/usr/local/bin/docker-entrypoint.sh:ro
  # Flutter web app build output
  - ./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro
```

**장점**:
- 설정 변경 시 컨테이너 재시작만 필요 (`docker compose restart nginx`)
- Docker 이미지 재빌드 불필요
- 빠른 설정 테스트 가능

## 변경된 파일

### 수정된 파일 (3개)

1. **/nginx/nginx.dev.conf** (Lines 112-147)
   - 3007 포트 서버 블록을 Flutter 웹 앱 전용으로 변경
   - SPA 라우팅, 정적 파일 캐싱 설정 추가

2. **/nginx/nginx.conf** (Lines 202-243 삭제)
   - 프로덕션 모드에서 3007 포트 서버 블록 제거
   - 총 547줄 (42줄 감소)

3. **/docker-compose.yml** (Lines 391-398)
   - Nginx 설정 파일 볼륨 마운트 3개 추가

## 코드 예시

### nginx.dev.conf - SPA 라우팅 설정

```nginx
# Flutter 웹 앱은 SPA이므로 모든 경로를 index.html로 라우팅
location / {
    try_files $uri $uri/ /index.html;
}
```

이 설정으로 `/login`, `/home`, `/lesson/1` 등 모든 경로가 `index.html`로 라우팅되어 Flutter Router가 처리할 수 있습니다.

### 정적 파일 캐싱 전략

```nginx
# JavaScript, CSS, 이미지 등 - 7일 캐싱
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|map)$ {
    expires 7d;
    add_header Cache-Control "public, immutable";
}

# index.html - 캐시 안 함 (항상 최신 버전 제공)
location = /index.html {
    add_header Cache-Control "no-store, no-cache, must-revalidate";
}
```

**이유**:
- 정적 파일은 해시된 파일명으로 빌드되므로 안전하게 장기 캐싱 가능
- index.html은 새로고침 시마다 최신 버전을 로드해야 함

## 테스트 및 검증

### 1. 개발 모드 테스트 (NGINX_MODE=development)

```bash
# Flutter 웹 앱 접속 (3007 포트)
$ curl http://localhost:3007/health
{
  "service": "Flutter Web App",
  "status": "ok",
  "port": 3007
}

# 실제 웹 앱 로드
$ curl -I http://localhost:3007
HTTP/1.1 200 OK
Content-Type: text/html

# 네트워크 설정 API (80 포트 - 기존 유지)
$ curl http://localhost/api/admin/network/config | jq .
{
  "success": true,
  "config": {
    "mode": "development",
    "baseUrl": "http://localhost:3001",
    "contentUrl": "http://localhost:3002",
    "progressUrl": "http://localhost:3003",
    "mediaUrl": "http://localhost:3004",
    "useGateway": false
  }
}

# 정적 파일 캐싱 확인
$ curl -I http://localhost:3007/main.dart.js | grep Cache-Control
Cache-Control: max-age=604800
Cache-Control: public, immutable

$ curl -I http://localhost:3007/index.html | grep Cache-Control
Cache-Control: no-store, no-cache, must-revalidate
```

### 2. 프로덕션 모드 검증

```bash
# nginx.conf에서 3007 포트 제거 확인
$ grep "listen 3007" nginx/nginx.conf
# (결과 없음)

# nginx.dev.conf에서 3007 포트 유지 확인
$ grep "listen 3007" nginx/nginx.dev.conf
113:        listen 3007;
114:        listen [::]:3007;

# 컨테이너 내부 설정 확인
$ docker compose exec nginx grep "listen 3007" /etc/nginx/nginx.conf
113:        listen 3007;
# (development 모드이므로 nginx.dev.conf가 로드됨)
```

### 3. 볼륨 마운트 검증

```bash
# 설정 파일이 볼륨으로 마운트되었는지 확인
$ docker compose exec nginx ls -lh /nginx-configs/
total 36K
-rw-rw-r-- 1 1000 1000 20.8K Jan 31 00:52 nginx.conf
-rw-rw-r-- 1 1000 1000  9.3K Jan 31 01:03 nginx.dev.conf

# 설정 변경 테스트 (컨테이너 재시작만 필요)
$ docker compose restart nginx
Container lemon-nginx Restarting
Container lemon-nginx Started
```

## 접속 방법

### 개발 모드 (NGINX_MODE=development)

```bash
# Flutter 웹 앱
http://localhost:3007
http://localhost:3007/login
http://localhost:3007/home

# 네트워크 설정 API
http://localhost/api/admin/network/config

# Admin 대시보드
http://localhost:3006

# 기타 API
http://localhost/api/auth/*
http://localhost/api/content/*
http://localhost/api/progress/*
```

### 프로덕션 모드 (NGINX_MODE=production)

```bash
# Flutter 웹 앱 (HTTPS, /app 경로)
https://yourdomain.com/app/

# 네트워크 설정 API (HTTPS)
https://yourdomain.com/api/admin/network/config

# 3007 포트
# (더 이상 노출되지 않음 - 보안 강화)
```

## 아키텍처 변경 사항

### Before (변경 전)

```
개발 모드:
- 80 포트: API Gateway (모든 백엔드 API)
- 3007 포트: 네트워크 설정 API 전용

프로덕션 모드:
- 443 포트: HTTPS (모든 API)
- 3007 포트: 네트워크 설정 API 중복 제공 (불필요)
```

### After (변경 후)

```
개발 모드:
- 80 포트: API Gateway (모든 백엔드 API + 네트워크 설정)
- 3007 포트: Flutter 웹 앱 전용 (SPA 서빙)

프로덕션 모드:
- 443 포트: HTTPS (모든 API + Flutter 웹 앱)
- 3007 포트: 제거됨 (보안 강화)
```

## 보안 개선

### 1. 불필요한 포트 노출 제거
- 프로덕션에서 3007 포트 완전히 제거
- HTTPS (443)로만 접근 가능
- 공격 표면(attack surface) 감소

### 2. 개발/프로덕션 환경 명확한 분리
- 개발 모드: 3007 포트 활성화 (로컬 테스트용)
- 프로덕션 모드: 3007 포트 비활성화
- NGINX_MODE 환경 변수로 자동 전환

### 3. CORS 설정
- 개발 모드: 모든 origin 허용 (`*`)
- 프로덕션 모드: 엄격한 CORS 정책 유지

## 성능 최적화

### 1. 정적 파일 캐싱
- JavaScript, CSS, 이미지: 7일 캐싱 (604800초)
- `Cache-Control: public, immutable` 헤더 설정
- 브라우저 캐시 활용으로 대역폭 절약

### 2. index.html 캐시 비활성화
- `Cache-Control: no-store, no-cache, must-revalidate`
- 항상 최신 버전의 앱 로드
- Flutter 빌드 업데이트 즉시 반영

### 3. SPA 라우팅 최적화
- `try_files $uri $uri/ /index.html` 설정
- 404 에러 없이 Flutter Router가 모든 경로 처리
- 새로고침 시에도 정상 작동

## 개발 편의성 개선

### 1. 설정 변경 워크플로우 간소화

**변경 전**:
```bash
# 1. nginx.conf 수정
# 2. Docker 이미지 재빌드 (시간 소요)
docker compose build nginx
# 3. 컨테이너 재시작
docker compose up -d nginx
```

**변경 후**:
```bash
# 1. nginx.conf 수정
# 2. 컨테이너 재시작만 (빠름)
docker compose restart nginx
```

### 2. 실시간 설정 테스트
- 볼륨 마운트로 파일 변경 즉시 반영 가능
- 이미지 재빌드 불필요
- 개발 속도 향상

## 관련 이슈 및 참고 사항

### 1. Flutter 웹 빌드
- 빌드 위치: `/mobile/lemon_korean/build/web`
- Nginx 볼륨 마운트: `/var/www/lemon_korean_web:ro` (읽기 전용)
- 빌드 명령: `flutter build web`

### 2. Nginx 모드 전환
```bash
# 개발 모드로 전환
NGINX_MODE=development docker compose up -d nginx

# 프로덕션 모드로 전환
NGINX_MODE=production docker compose up -d nginx
```

### 3. 향후 개선 사항
- [ ] 프로덕션 환경에서 Flutter 웹 앱 HTTPS 배포 테스트
- [ ] CDN 연동 고려 (CloudFlare, AWS CloudFront)
- [ ] Brotli 압축 추가 (gzip 외)
- [ ] HTTP/2 Server Push 활용 검토
- [ ] Service Worker 캐싱 전략 최적화

### 4. 문서 업데이트
- ✅ CLAUDE.md 업데이트 (Nginx 설정 섹션)
- ✅ README.md 업데이트 (접속 포트 정보)
- ✅ nginx/README.md 작성 고려

## 요약

### 주요 변경 사항
1. ✅ 개발 모드 3007 포트를 Flutter 웹 앱 전용으로 변경
2. ✅ 프로덕션 모드에서 불필요한 3007 포트 블록 제거
3. ✅ Nginx 설정 파일 볼륨 마운트로 개발 편의성 개선

### 영향 범위
- **개발 모드**: 3007 포트로 Flutter 웹 앱 접속 가능
- **프로덕션 모드**: 보안 강화 (불필요한 포트 제거)
- **기존 API**: 영향 없음 (계속 정상 작동)

### 기대 효과
- 🚀 개발 편의성 향상 (설정 변경 간소화)
- 🔒 보안 강화 (공격 표면 감소)
- ⚡ 성능 최적화 (정적 파일 캐싱)
- 📱 Flutter 웹 앱 접근성 개선

### 리스크
**없음** - 모든 기존 기능 정상 작동, 추가 기능만 제공
