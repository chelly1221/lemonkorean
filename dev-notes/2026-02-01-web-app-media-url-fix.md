---
date: 2026-02-01
category: Mobile
title: 웹 앱 미디어 URL 도메인 수정
author: Claude Opus 4.5
tags: [bugfix, web, media, cors]
priority: high
---

# 웹 앱 미디어 URL 도메인 수정

## 개요
Flutter 웹 앱의 미디어 로더 스텁에서 잘못된 도메인(`3chan.kr`)을 사용하고 있어 CORS 오류와 혼합 콘텐츠 차단이 발생하던 문제를 수정했습니다.

## 문제 / 배경
`https://lemon.3chan.kr/app/`에 배포된 웹 앱에서 다음과 같은 콘솔 오류가 발생:

1. **혼합 콘텐츠 차단**: HTTPS 페이지에서 HTTP 요청 차단
2. **CORS 오류**: 잘못된 도메인으로 인한 교차 출처 요청 차단
3. **404 오류**: `/api/admin/network/config` 엔드포인트 미존재 (구버전 코드)

**근본 원인**: `media_loader_stub.dart`가 `https://3chan.kr`을 하드코딩하고 있었으나,
실제 프로덕션 도메인은 `https://lemon.3chan.kr`임.

## 해결 / 구현
`media_loader_stub.dart`의 기본 URL을 올바른 도메인으로 수정:

```dart
// Before (잘못됨)
const baseUrl = 'https://3chan.kr';

// After (올바름)
const baseUrl = 'https://lemon.3chan.kr';
```

## 변경된 파일
- `/mobile/lemon_korean/lib/core/platform/web/stubs/media_loader_stub.dart` - 미디어 URL 도메인 수정

## 코드 예시

```dart
// Before
static String _getRemoteImageUrl(String remoteKey) {
  const baseUrl = 'https://3chan.kr';  // 잘못된 도메인
  return '$baseUrl/media/images/$remoteKey';
}

static String _getRemoteAudioUrl(String remoteKey) {
  const baseUrl = 'https://3chan.kr';  // 잘못된 도메인
  return '$baseUrl/media/audio/$remoteKey';
}
```

```dart
// After
static String _getRemoteImageUrl(String remoteKey) {
  const baseUrl = 'https://lemon.3chan.kr';  // 올바른 도메인
  return '$baseUrl/media/images/$remoteKey';
}

static String _getRemoteAudioUrl(String remoteKey) {
  const baseUrl = 'https://lemon.3chan.kr';  // 올바른 도메인
  return '$baseUrl/media/audio/$remoteKey';
}
```

## 테스트

### 빌드 검증
```bash
# 웹 앱 재빌드
cd mobile/lemon_korean
flutter clean
flutter pub get
flutter build web

# 빌드 결과에 올바른 도메인 포함 확인
grep -o "lemon.3chan.kr" build/web/main.dart.js | head -5
# 출력: lemon.3chan.kr (5회 이상)

# nginx 재시작
docker compose restart nginx
```

### 브라우저 테스트
1. https://lemon.3chan.kr/app/ 접속
2. DevTools 콘솔 (F12) 열기
3. 다음 오류가 없어야 함:
   - "Cross-Origin Request Blocked" 오류 없음
   - "Blocked loading mixed active content" 오류 없음
   - 네트워크 탭에서 `https://lemon.3chan.kr/api/*`로 요청 확인

## 관련 이슈 / 참고
- 웹 앱은 항상 `https://lemon.3chan.kr` 도메인 사용
- 모바일 앱은 개발 환경에 따라 다른 URL 사용 가능
- CORS 중복 헤더 문제는 nginx와 백엔드 서비스 모두에서 CORS 헤더를 설정하는 경우 발생 가능 (별도 조사 필요)
