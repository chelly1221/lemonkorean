---
date: 2026-02-01
category: Mobile
title: 웹 앱 프로필 API 404 오류 수정
author: Claude Opus 4.5
tags: [bugfix, web, api, profile, authentication]
priority: medium
---

# 웹 앱 프로필 API 404 오류 수정

## Overview
Flutter 웹 앱에서 프로필 API 호출 시 404 오류가 발생하는 문제를 수정했습니다.

## Problem / Background
웹 앱 로그인 후 DevTools Network 탭에서 다음과 같은 404 오류가 발생:
- 요청 URL: `GET /api/auth/profile/2` (사용자 ID가 URL에 포함)
- Auth Service는 `GET /api/auth/profile` 만 지원 (ID 파라미터 없음)
- 백엔드는 JWT 토큰에서 사용자 ID를 추출하여 프로필 반환

## Solution / Implementation
API 클라이언트의 `getUserProfile` 메서드에서 사용자 ID 파라미터를 제거하고,
`/auth/profile` 엔드포인트를 직접 호출하도록 수정했습니다.

백엔드 Auth Service는 Authorization 헤더의 JWT 토큰에서 사용자 ID를 추출합니다.

## Files Changed

### Modified
- `/mobile/lemon_korean/lib/core/network/api_client.dart` - `getUserProfile()` 메서드에서 userId 파라미터 제거
- `/mobile/lemon_korean/lib/presentation/providers/auth_provider.dart` - `getUserProfile()` 호출 시 userId 인자 제거 (2곳)

## Code Examples

### api_client.dart

```dart
// Before
Future<Response> getUserProfile(int userId) async {
  return await _dio.get('/auth/profile/$userId');
}

// After
Future<Response> getUserProfile() async {
  return await _dio.get('/auth/profile');
}
```

### auth_provider.dart

```dart
// Before (line 118)
final response = await _apiClient.getUserProfile(userId);

// After
final response = await _apiClient.getUserProfile();

// Before (line 147)
final response = await _apiClient.getUserProfile(userId);

// After
final response = await _apiClient.getUserProfile();
```

## Testing

### 검증 단계
1. 웹 앱 빌드: `cd mobile/lemon_korean && ./build_web.sh`
2. Nginx 재시작: `docker compose restart nginx`
3. 브라우저에서 https://lemon.3chan.kr/app/ 접속
4. 로그인 후 DevTools (F12) Network 탭 확인
5. 기대 결과: `GET /api/auth/profile` (ID 없이)
6. 프로필 데이터가 정상적으로 로드되어야 함

### API 테스트
```bash
# 로그인하여 토큰 획득
TOKEN=$(curl -s -X POST https://lemon.3chan.kr/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}' \
  | jq -r '.token')

# 프로필 API 호출 (ID 없이)
curl -X GET https://lemon.3chan.kr/api/auth/profile \
  -H "Authorization: Bearer $TOKEN"
```

## Related Issues / Notes
- Auth Service의 `/api/auth/profile` 엔드포인트는 JWT 토큰 기반 인증을 사용
- `userId` 변수는 로깅 및 폴백 로직에서 여전히 사용됨 (API 호출에만 제거)
- 이 수정은 웹 앱과 모바일 앱 모두에 적용됨
