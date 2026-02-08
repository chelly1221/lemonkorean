---
date: 2026-02-07
category: Infrastructure
title: 웹 앱 배포 시 Dart 코드 변경사항 미반영 문제 수정
author: Claude Opus 4.6
tags: [nginx, caching, flutter-web, deployment, npm-proxy]
priority: high
---

## 문제 상황

웹 앱 배포 후 Dart 코드 변경사항(예: 홈 화면 UI 변경, 프로필 탭 레이아웃)이 브라우저에 반영되지 않음.
스플래시 화면의 타임스탬프는 업데이트되지만, 실제 앱 코드는 이전 버전이 계속 로드됨.

## 근본 원인 (3단계 문제)

### 1단계: Nginx `main.dart.js` 7일 캐시
```nginx
# 기존 설정 - 모든 Flutter JS 파일에 7일 캐시 적용
location ~ ^/app/(flutter_bootstrap\.js|main\.dart\.js|flutter\.js|...) {
    expires 7d;
    add_header Cache-Control "public, max-age=604800";
}
```
`main.dart.js`는 매 빌드마다 내용이 변경되므로 7일 캐시는 부적절.

### 2단계: Service Worker 제거 스크립트
`index.html`에 추가한 service worker 제거 스크립트가 오히려 문제를 악화시킴.
Flutter의 `flutter_service_worker.js`는 새 버전을 감지하고 파일을 재다운로드하는 메커니즘인데,
이를 제거하면 브라우저가 순수 HTTP 캐싱(7일)에만 의존하게 됨.

### 3단계: NPM (Nginx Proxy Manager) 자산 캐싱
NPM의 `assets.conf`가 모든 `.js` 파일을 30분간 캐싱하며 upstream의 `Cache-Control` 헤더를 무시:
```nginx
# NPM assets.conf
location ~* ^.*\.(css|js|...)$ {
    proxy_ignore_headers Set-Cookie Cache-Control Expires;
    proxy_hide_header Cache-Control;
    proxy_cache_valid any 30m;
}
```

## 수정 내용

### 1. Nginx 캐싱 규칙 변경 (`nginx/nginx.conf`)
빌드마다 변경되는 파일은 `no-cache`, 정적 자산만 7일 캐시:
```nginx
location = /app/main.dart.js {
    add_header Cache-Control "no-store, no-cache, must-revalidate";
}
location = /app/flutter_bootstrap.js {
    add_header Cache-Control "no-store, no-cache, must-revalidate";
}
location = /app/flutter.js {
    add_header Cache-Control "no-store, no-cache, must-revalidate";
}

# 정적 자산만 장기 캐시
location ~ ^/app/(canvaskit/|icons/|assets/|manifest\.json|favicon\.png) {
    expires 7d;
    add_header Cache-Control "public, max-age=604800";
}
```

### 2. Service Worker 제거 스크립트 삭제 (`web/index.html`)
- Service worker/cache 강제 삭제 스크립트 제거
- `flutter_bootstrap.js?v=20260207` 파라미터 제거
- 디버그용 빌드 타임스탬프 제거

### 3. NPM 커스텀 설정 추가
NPM 컨테이너 내 `/data/nginx/custom/server_proxy.conf`에 `location =` 블록 추가.
Nginx에서 `location =` (exact match)는 `location ~*` (regex)보다 우선하므로
NPM의 `assets.conf` 캐싱을 오버라이드함.

### 4. nginx.dev.conf를 nginx.conf로 통합
- `nginx.dev.conf` 삭제
- `docker-compose.yml`, `Dockerfile`, 문서 등 모든 참조를 `nginx.conf`로 변경

## 수정 파일

| 파일 | 변경 내용 |
|------|-----------|
| `nginx/nginx.conf` | 캐싱 규칙 수정 + dev.conf 내용 통합 |
| `nginx/nginx.dev.conf` | 삭제 |
| `nginx/Dockerfile` | COPY 참조를 `nginx.conf`로 변경 |
| `docker-compose.yml` | 볼륨 마운트를 `nginx.conf`로 변경 |
| `mobile/lemon_korean/web/index.html` | SW 제거 스크립트/타임스탬프 삭제 |
| NPM `server_proxy.conf` | Flutter JS 파일 캐시 오버라이드 |
| `CLAUDE_INSTRUCTIONS.md` | nginx 설정 참조 업데이트 |
| `.claude-safety.yml` | nginx 설정 참조 업데이트 |
| `nginx/README.md` | dev.conf 참조 제거 |
| `README.md` | 디렉토리 구조 업데이트 |
| `CHANGES.md` | 참조 업데이트 |
| `nginx/QUICKSTART.md` | 참조 업데이트 |

## 검증

```bash
# 캐싱 헤더 확인
curl -sI https://lemon.3chan.kr/app/main.dart.js | grep cache-control
# 결과: cache-control: no-store, no-cache, must-revalidate

curl -sI https://lemon.3chan.kr/app/flutter_bootstrap.js | grep cache-control
# 결과: cache-control: no-store, no-cache, must-revalidate
```

## 교훈

1. **Flutter 웹의 `main.dart.js`는 매 빌드마다 변경됨** - 절대 장기 캐시하면 안 됨
2. **Service Worker를 제거하면 역효과** - Flutter SW는 버전 감지/업데이트 메커니즘
3. **NPM 앞단 프록시의 `assets.conf`** - upstream Cache-Control 헤더를 무시하므로 별도 오버라이드 필요
4. **설정 파일 통합** - dev/prod 분리보다 단일 파일이 관리하기 쉬움
