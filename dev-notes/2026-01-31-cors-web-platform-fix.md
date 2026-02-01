---
date: 2026-01-31
category: Backend
title: 웹 플랫폼을 위한 CORS 설정 수정 (lemon.3chan.kr 도메인 지원)
author: Claude Sonnet 4.5
tags: [cors, web-platform, bugfix, critical, backend]
priority: high
---

# 웹 플랫폼 CORS 설정 수정

## 개요
웹 앱(`http://lemon.3chan.kr/app/`)에서 API 요청 시 CORS 에러가 발생하는 문제를 해결했습니다. Progress Service와 Media Service의 CORS 설정에 `lemon.3chan.kr` 도메인을 추가하여 개발 환경에서도 도메인을 통한 접근을 허용했습니다.

## 문제 배경

### 초기 CORS 설정
Progress Service와 Media Service는 이미 CORS 설정이 구현되어 있었으나, 개발 환경에서는 `localhost`와 `127.0.0.1`만 허용하고 있었습니다:

```go
// 기존 개발 환경 CORS 설정
config.AllowedOrigins = []string{
    "http://localhost",
    "http://localhost:3007",
    "http://localhost:80",
    "http://127.0.0.1",
    "http://127.0.0.1:3007",
}
```

### 문제 상황
Flutter 웹 앱은 다음 환경에서 실행될 수 있습니다:
- `http://localhost:3007` (Flutter 개발 서버)
- `http://localhost/app/` (Nginx를 통한 접근)
- `http://lemon.3chan.kr:3007` (도메인 기반 개발 서버) ❌ **CORS 에러**
- `http://lemon.3chan.kr/app/` (도메인 기반 Nginx) ❌ **CORS 에러**

웹 앱이 `lemon.3chan.kr` 도메인에서 실행될 때 Progress/Media API를 호출하면 CORS 에러가 발생했습니다.

## 해결 방법

### 1. CORS 설정 업데이트

**파일**: `/services/progress/config/cors.go`, `/services/media/config/cors.go`

**변경 전**:
```go
} else {
    // Development: Permissive for local testing
    config.AllowedOrigins = []string{
        "http://localhost",
        "http://localhost:3007",
        "http://localhost:80",
        "http://127.0.0.1",
        "http://127.0.0.1:3007",
    }
}
```

**변경 후**:
```go
} else {
    // Development: Permissive for local testing
    config.AllowedOrigins = []string{
        "http://localhost",
        "http://localhost:3007",
        "http://localhost:80",
        "http://127.0.0.1",
        "http://127.0.0.1:3007",
        "http://lemon.3chan.kr:3007", // Dev server port
        "http://lemon.3chan.kr",      // Dev domain (nginx)
    }
}
```

### 2. CORS 동작 방식

**환경 감지**:
- `NODE_ENV=production`: 프로덕션 도메인만 허용 (`https://lemon.3chan.kr`)
- `NODE_ENV=development` (또는 미설정): 개발 도메인 모두 허용

**CORS 헤더 설정**:
```go
// Origin 반영 (Spec-compliant)
c.Writer.Header().Set("Access-Control-Allow-Origin", origin)
c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
```

**Preflight 처리**:
```go
if c.Request.Method == "OPTIONS" {
    if corsConfig.IsOriginAllowed(origin) {
        c.AbortWithStatus(204)  // 허용된 Origin
    } else {
        c.AbortWithStatus(403)  // 거부된 Origin
    }
    return
}
```

### 3. 보안 고려사항

✅ **CORS Spec 준수**: Wildcard `*`를 사용하지 않고 특정 origin을 명시적으로 반영
✅ **Credentials 지원**: `Access-Control-Allow-Credentials: true` (JWT 토큰 전송 가능)
✅ **환경별 분리**: 프로덕션 환경에서는 HTTPS만 허용
✅ **거부 처리**: 허용되지 않은 origin은 403 Forbidden 응답

## 변경된 파일

### Go 설정 파일 (수정)
- `/services/progress/config/cors.go` - `lemon.3chan.kr` 도메인 추가
- `/services/media/config/cors.go` - `lemon.3chan.kr` 도메인 추가

### 테스트 스크립트 (신규)
- `/scripts/test_cors.sh` - CORS 설정 자동 테스트 스크립트

## 테스트 결과

### 자동 테스트
```bash
./scripts/test_cors.sh
```

**결과**: 모든 테스트 통과 ✅
- Progress Service: 5/5 origins 허용
- Media Service: 5/5 origins 허용
- 거부 테스트: 403 Forbidden 정상 동작

### 수동 테스트

**Progress Service CORS 테스트**:
```bash
# lemon.3chan.kr:3007 origin 테스트
curl -X OPTIONS http://localhost:3003/api/progress/user/1 \
  -H "Origin: http://lemon.3chan.kr:3007" \
  -H "Access-Control-Request-Method: GET" \
  -v

# 응답:
# HTTP/1.1 204 No Content
# Access-Control-Allow-Origin: http://lemon.3chan.kr:3007
# Access-Control-Allow-Credentials: true
```

**Media Service CORS 테스트**:
```bash
# lemon.3chan.kr origin 테스트
curl -X OPTIONS http://localhost:3004/media/images/test.jpg \
  -H "Origin: http://lemon.3chan.kr" \
  -H "Access-Control-Request-Method: GET" \
  -v

# 응답:
# HTTP/1.1 204 No Content
# Access-Control-Allow-Origin: http://lemon.3chan.kr
# Access-Control-Allow-Credentials: true
```

## 배포 절차

### 1. 서비스 빌드
```bash
docker compose build progress-service media-service
```

### 2. 서비스 재시작
```bash
docker compose up -d progress-service media-service
```

### 3. 로그 확인
```bash
docker compose logs --tail=20 progress-service media-service
```

### 4. CORS 테스트
```bash
./scripts/test_cors.sh
```

## 브라우저 검증

### 웹 앱 접속 방법
1. `http://lemon.3chan.kr:3007` 또는 `http://localhost:3007`
2. 브라우저 DevTools (F12) 열기
3. Console 탭 확인: CORS 에러 없어야 함
4. Network 탭 확인:
   - API 요청 확인
   - Response Headers 확인:
     - `Access-Control-Allow-Origin: http://lemon.3chan.kr:3007`
     - `Access-Control-Allow-Credentials: true`

### 예상 동작
- ✅ 로그인 성공
- ✅ 레슨 목록 로드
- ✅ 진도 데이터 저장
- ✅ 미디어 파일 로드

## 관련 이슈

### 이전 CORS 구현 (이미 완료됨)
- 2026-01-20: Progress/Media Service에 CORS 미들웨어 구현
- 문제: `localhost`만 지원, `lemon.3chan.kr` 도메인 미지원

### 이번 업데이트
- 2026-01-31: `lemon.3chan.kr` 도메인을 개발 환경 CORS에 추가
- 웹 플랫폼이 도메인에서도 정상 작동 가능

## 참고 자료

### CORS Specification
- [MDN CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS)
- Wildcard `*`와 `credentials: true` 조합은 CORS 스펙 위반
- 동적 origin 반영 방식이 정석 구현

### 프로젝트 문서
- `/CLAUDE.md` - 프로젝트 아키텍처
- `/services/progress/README.md` - Progress Service 상세
- `/services/media/README.md` - Media Service 상세

## 향후 개선 사항

1. **프로덕션 배포 시**: `NODE_ENV=production` 설정 확인
2. **추가 도메인**: 필요시 CORS 설정에 도메인 추가
3. **모니터링**: CORS 거부 로그 수집 및 분석
4. **Rate Limiting**: Origin별 요청 제한 추가 고려

---

**요약**: 웹 플랫폼이 `lemon.3chan.kr` 도메인에서 정상 동작하도록 CORS 설정을 확장했습니다. 모든 테스트 통과 및 배포 완료.
