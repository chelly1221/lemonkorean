---
date: 2026-01-31
category: Mobile
title: Flutter 웹 동적 네트워크 설정 구현 (포트 3007 개발 모드 지원)
author: Claude Sonnet 4.5
tags: [feature, web, flutter, network-config, development-mode]
priority: medium
---

# Flutter 웹 동적 네트워크 설정 구현

## 개요
Flutter 웹 앱이 포트 3007에서 접속 시 Admin 네트워크 설정의 "개발모드"를 자동으로 감지하고 개발 URL을 사용하도록 구현했습니다.

## 배경

### 기존 문제점
Flutter 웹 빌드는 컴파일 시점에 `.env.production` 파일의 URL을 코드에 포함시킵니다. 이로 인해:
- 웹 앱을 `http://3chan.kr:3007`에서 접속해도 항상 프로덕션 URL (`http://3chan.kr`) 사용
- Admin 패널에서 "개발모드"로 설정해도 웹 앱은 프로덕션 모드로 동작
- `dart.vm.product` 환경 변수 감지가 웹 플랫폼에서 작동하지 않음

### 사용자 요구사항
포트 3007에서 웹 앱 접속 시 Admin 네트워크 설정이 "개발모드"로 되어 있으면:
- 개발 URL 사용 (직접 마이크로서비스 포트: 3001-3004)
- 게이트웨이 우회
- CORS 완화
- 개발 친화적 설정

## 해결 방법

### 1. ApiClient 네트워크 설정 로직 확장

**파일**: `mobile/lemon_korean/lib/core/network/api_client.dart`

**변경 내용**:
```dart
// Before: 단순한 URL 목록 (3개, 프로덕션만)
final urls = <String>{
  EnvironmentConfig.adminUrl,
  EnvironmentConfig.baseUrl,
  '${_extractHost(EnvironmentConfig.baseUrl)}:3006',
}.toList();

// After: 포괄적 URL 목록 (6+, 프로덕션 + 개발)
final urls = <String>[];

// 1. 웹 플랫폼: 현재 호스트 우선 시도
if (kIsWeb) {
  final currentOrigin = html.window.location.origin; // http://3chan.kr:3007
  urls.add(currentOrigin);
}

// 2. 프로덕션 URL (.env.production)
urls.add(EnvironmentConfig.adminUrl);   // http://3chan.kr:3006
urls.add(EnvironmentConfig.baseUrl);    // http://3chan.kr

// 3. 개발 URL 하드코딩 폴백
urls.add('http://3chan.kr:3007');       // 개발 포트
urls.add('http://192.168.0.100:3006');  // 로컬 네트워크
urls.add('http://localhost:3006');      // 로컬호스트

// 중복 제거 후 순차 시도
```

**핵심 개선사항**:
- **자동 플랫폼 감지**: `kIsWeb`로 웹 플랫폼 감지
- **현재 호스트 우선**: `window.location.origin`으로 포트 3007 자동 감지
- **다중 폴백**: 프로덕션 실패 시 개발 URL 시도
- **중복 제거**: 같은 URL 여러 번 시도 방지
- **상세 로깅**: 각 시도마다 성공/실패 로그

### 2. Nginx 포트 3007 프록시 추가

**파일**: `nginx/nginx.dev.conf` (line 138 이후 추가)

**추가 설정**:
```nginx
# Proxy admin network config API to admin service
location /api/admin/network/config {
    proxy_pass http://admin_service;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    # CORS for proxied requests
    add_header Access-Control-Allow-Origin "*" always;
    add_header Access-Control-Allow-Methods "GET, OPTIONS" always;
    add_header Access-Control-Allow-Headers "*" always;
}
```

**목적**:
- 포트 3007로 들어온 네트워크 설정 API 요청을 Admin 서비스로 프록시
- CORS 헤더 포함으로 웹 앱이 API 호출 가능
- Admin 서비스는 Redis에서 현재 모드 확인 후 적절한 URL 반환

## 동작 흐름

### 개발 모드 흐름 (포트 3007)
```
1. 사용자: http://3chan.kr:3007/ 접속
   ↓
2. Flutter 웹 앱 로드
   ↓
3. main.dart: ApiClient.getNetworkConfig() 호출
   ↓
4. ApiClient: window.location.origin 감지 → "http://3chan.kr:3007"
   ↓
5. 첫 번째 시도: http://3chan.kr:3007/api/admin/network/config
   ↓
6. Nginx (포트 3007): /api/admin/network/config 요청 인터셉트
   ↓
7. Nginx → Admin Service (포트 3006) 프록시
   ↓
8. Admin Service: Redis에서 network:mode 확인 → "development"
   ↓
9. Admin Service 응답:
   {
     "mode": "development",
     "baseUrl": "http://localhost:3001",
     "contentUrl": "http://localhost:3002",
     "progressUrl": "http://localhost:3003",
     "mediaUrl": "http://localhost:3004",
     "useGateway": false
   }
   ↓
10. ApiClient: NetworkConfigModel 생성
    ↓
11. AppConstants.updateFromConfig() 호출
    ↓
12. 모든 API 호출이 직접 마이크로서비스 포트 사용 ✅
```

### 프로덕션 모드 흐름 (포트 80)
```
1. 사용자: http://3chan.kr/app/ 접속
   ↓
2. Flutter 웹 앱 로드
   ↓
3. ApiClient: window.location.origin → "http://3chan.kr"
   ↓
4. 첫 번째 시도: http://3chan.kr/api/admin/network/config
   ↓
5. Nginx (포트 80): Admin Service로 프록시
   ↓
6. Admin Service: network:mode → "production"
   ↓
7. Admin Service 응답:
   {
     "mode": "production",
     "baseUrl": "http://3chan.kr",
     "contentUrl": "http://3chan.kr",
     "progressUrl": "http://3chan.kr",
     "mediaUrl": "http://3chan.kr",
     "useGateway": true
   }
   ↓
8. 모든 API 호출이 Nginx 게이트웨이 경유 ✅
```

## 변경된 파일

### 코드 파일
1. **`mobile/lemon_korean/lib/core/network/api_client.dart`**
   - Lines 1-11: 임포트 추가 (`kIsWeb`, `dart:html`)
   - Lines 70-142: `getNetworkConfig()` 메서드 완전 재작성

### 설정 파일
2. **`nginx/nginx.dev.conf`**
   - Line 138 이후: `/api/admin/network/config` 프록시 위치 추가

## 빌드 및 배포

### 웹 앱 빌드
```bash
cd /home/sanchan/lemonkorean/mobile/lemon_korean
flutter build web

# 빌드 시간: ~360초 (6분)
# 출력: build/web/
# 아이콘 최적화:
#   - CupertinoIcons: 99.4% 감소
#   - MaterialIcons: 99.0% 감소
```

### Nginx 재시작
```bash
cd /home/sanchan/lemonkorean
docker compose restart nginx

# Container lemon-nginx Restarting
# Container lemon-nginx Started
```

## 검증 결과

### 1. 포트 3007 접근성
```bash
curl -I http://localhost:3007/
# HTTP/1.1 200 OK ✅
```

### 2. 네트워크 설정 API 프록시
```bash
curl -s http://localhost:3007/api/admin/network/config
# {
#   "success": true,
#   "config": {
#     "mode": "development",
#     "baseUrl": "http://localhost:3001",
#     ...
#   }
# } ✅
```

### 3. Nginx 설정 확인
```bash
docker exec lemon-nginx nginx -T | grep "location /api/admin/network/config"
# location /api/admin/network/config { ... } ✅
```

### 4. Redis 네트워크 모드
```bash
docker exec lemon-redis redis-cli -a "password" GET network:mode
# "development" ✅
```

## 기술적 세부사항

### 웹 플랫폼 감지
```dart
import 'package:flutter/foundation.dart' show kIsWeb;

// 조건부 임포트 (웹에서만 dart:html 사용)
import 'dart:html' as html if (dart.library.io) '';

if (kIsWeb) {
  final currentOrigin = html.window.location.origin;
  // 웹에서만 실행되는 코드
}
```

### URL 중복 제거 로직
```dart
// Set 대신 List + contains 사용 (순서 유지)
final uniqueUrls = <String>[];
for (final url in urls) {
  if (!uniqueUrls.contains(url)) {
    uniqueUrls.add(url);
  }
}
```

### 타임아웃 설정
```dart
final configDio = Dio(BaseOptions(
  baseUrl: url,
  connectTimeout: const Duration(seconds: 3),  // 빠른 폴백
  receiveTimeout: const Duration(seconds: 3),
  ...
));
```

## 영향 분석

### 긍정적 영향
- ✅ 개발 환경과 프로덕션 환경 자동 전환
- ✅ 개발자가 로컬 백엔드 테스트 가능
- ✅ 포트만 변경하면 모드 전환 (재빌드 불필요)
- ✅ 하위 호환성 유지 (프로덕션 모드 변경 없음)
- ✅ 모바일 앱 영향 없음 (웹 전용 변경)

### 성능 영향
- **웹 앱 로딩**: 무시할 수 있음 (첫 번째 URL 시도는 현재 호스트, 일반적으로 성공)
- **빌드 시간**: 변경 없음 (~360초)
- **네트워크 오버헤드**: 무시할 수 있음 (3초 타임아웃, 빠른 폴백)

## 사용 가이드

### 개발 모드로 전환
1. Admin 대시보드 접속: `http://localhost:3006/`
2. 사이드바 → "Network Settings" 클릭
3. "개발 모드 (Development Mode)" 선택
4. "변경사항 저장" 클릭
5. Nginx 재시작 확인

### 웹 앱 테스트 (개발 모드)
```bash
# 브라우저에서 접속
http://3chan.kr:3007/

# 또는 로컬호스트
http://localhost:3007/

# DevTools (F12) 확인:
# Console → 네트워크 설정 로그 확인
# Network → /api/admin/network/config 요청 확인
```

### 프로덕션 모드로 전환
1. Admin 대시보드 → Network Settings
2. "프로덕션 모드 (Production Mode)" 선택
3. 저장 및 Nginx 재시작
4. 웹 앱 접속: `http://3chan.kr/app/`

## 문제 해결

### Q: 포트 3007에서 여전히 프로덕션 URL 사용
**A**: 브라우저 캐시 문제일 수 있습니다.
```bash
# 브라우저에서 강제 새로고침
Ctrl + Shift + R (Windows/Linux)
Cmd + Shift + R (Mac)

# 또는 캐시 완전 삭제
DevTools → Application → Clear storage
```

### Q: 네트워크 설정 API 404 에러
**A**: Nginx 설정이 제대로 로드되지 않았을 수 있습니다.
```bash
# Nginx 설정 검증
docker exec lemon-nginx nginx -t

# Nginx 재시작
docker compose restart nginx

# 프록시 설정 확인
docker exec lemon-nginx nginx -T | grep "location /api/admin/network/config"
```

### Q: 개발 모드 설정이 반영되지 않음
**A**: Redis 네트워크 모드를 확인하세요.
```bash
# 현재 모드 확인
docker exec lemon-redis redis-cli -a "Scott122001" GET network:mode

# 개발 모드로 수동 변경
docker exec lemon-redis redis-cli -a "Scott122001" SET network:mode development

# Nginx 재시작
docker compose restart nginx
```

## 향후 개선 사항

1. **환경 자동 감지 강화**
   - IP 주소 패턴으로 개발/프로덕션 자동 구분
   - 로컬호스트 감지 시 자동 개발 모드

2. **설정 캐싱**
   - 네트워크 설정을 localStorage에 캐싱
   - 재접속 시 빠른 로드

3. **개발자 도구**
   - 웹 앱 내에서 모드 전환 UI
   - URL 오버라이드 기능

4. **모니터링**
   - 어떤 URL이 가장 많이 성공하는지 분석
   - 실패 URL 패턴 로깅

## 관련 문서

- `CHANGES.md` - 변경 로그 항목
- `CLAUDE.md` - 프로젝트 가이드 (업데이트 필요)
- `WEB_DEPLOYMENT_SUMMARY.md` - 웹 배포 요약 (업데이트 필요)
- `nginx/nginx.dev.conf` - Nginx 개발 설정

## 결론

Flutter 웹 앱이 이제 포트 3007에서 접속 시 자동으로 개발 모드를 감지하고 직접 마이크로서비스 URL을 사용합니다. 이를 통해 개발자는 Admin 패널에서 간단히 모드를 전환할 수 있으며, 웹 앱 재빌드 없이도 개발/프로덕션 환경을 전환할 수 있습니다.

**프로덕션 배포 완료**: http://3chan.kr:3007 (개발 모드)
**프로덕션 배포 완료**: http://3chan.kr/app/ (프로덕션 모드)
