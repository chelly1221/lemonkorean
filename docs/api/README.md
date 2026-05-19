# Lemon Korean API 문서

**柠檬韩语 API 文档 | 레몬 코리안 API 문서**

Lemon Korean API 문서에 오신 것을 환영합니다. 이 디렉토리는 Lemon Korean 플랫폼의 모든 마이크로서비스에 대한 포괄적인 API 문서를 포함하고 있습니다.

---

## 📚 API 서비스

| 서비스 | 포트 | 문서 | 설명 |
|---------|------|---------------|-------------|
| **Auth Service** | 3001 | [AUTH_API.md](./AUTH_API.md) | 사용자 인증 및 관리 |
| **Content Service** | 3002 | [CONTENT_API.md](./CONTENT_API.md) | 레슨, 단어, 문법 콘텐츠 |
| **Progress Service** | 3003 | [PROGRESS_API.md](./PROGRESS_API.md) | 학습 진도 및 SRS 복습 |
| **Media Service** | 3004 | [MEDIA_API.md](./MEDIA_API.md) | 이미지 및 오디오 파일 서빙 |
| **Analytics Service** | 3005 | [ANALYTICS_API.md](./ANALYTICS_API.md) | 로그 분석, 통계 API |
| **Admin Service** | 3006 | [ADMIN_API.md](./ADMIN_API.md) | 관리자 대시보드 REST API |
| **SNS Service** | 3007 | [SNS_API.md](./SNS_API.md) | 커뮤니티 피드, 게시물, 댓글, 팔로우 |
| **Moderation Service** | 3008 | [MODERATION_API.md](./MODERATION_API.md) | AI 콘텐츠 모더레이션 (ONNX Runtime) |

**참고**:
- SNS Service는 DM 및 음성 대화방 기능도 포함합니다 ([DM_API.md](./DM_API.md), [VOICE_ROOMS_API.md](./VOICE_ROOMS_API.md))
- 캐릭터 커스터마이징은 Progress/Admin Service에서 제공됩니다 ([CHARACTER_SYSTEM_API.md](./CHARACTER_SYSTEM_API.md))

---

## 🚀 빠른 시작

### Base URL

**개발 환경**:
```
Auth Service:     http://localhost:3001/api/auth
Content Service:  http://localhost:3002/api/content
Progress Service: http://localhost:3003/api/progress
Media Service:    http://localhost:3004
```

**프로덕션 환경**:
```
API Gateway:       https://lemon.3chan.kr/api
Auth Service:      https://lemon.3chan.kr/api/auth
Content Service:   https://lemon.3chan.kr/api/content
Progress Service:  https://lemon.3chan.kr/api/progress
Media Service:     https://lemon.3chan.kr/media
Analytics Service: https://lemon.3chan.kr/api/analytics
Admin Service:     https://lemon.3chan.kr/api/admin
SNS Service:       https://lemon.3chan.kr/api/sns
Moderation Service: http://moderation-service:3008/api/moderation (internal only)
Socket.IO:         wss://lemon.3chan.kr/socket.io
LiveKit:           wss://lemon.3chan.kr:7880
Admin Dashboard:   https://lemon.3chan.kr/admin/
Web App:           https://lemon.3chan.kr/app/
```

### 인증

대부분의 엔드포인트는 JWT 인증이 필요합니다. `Authorization` 헤더에 토큰을 포함하세요:

```bash
Authorization: Bearer <your_jwt_token>
```

### 시작하기

1. **새 사용자 등록**:
```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecureP@ss123",
    "username": "johndoe",
    "language": "zh"
  }'
```

2. **로그인하여 토큰 받기**:
```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "SecureP@ss123"
  }'
```

3. **인증된 요청에 토큰 사용**:
```bash
curl -X GET http://localhost:3002/api/content/lessons \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

---

## 📖 API 개요

### Auth Service

**목적**: 사용자 인증, 등록 및 프로필 관리

**주요 엔드포인트**:
- `POST /api/auth/register` - 새 사용자 등록
- `POST /api/auth/login` - 사용자 인증
- `POST /api/auth/refresh` - 액세스 토큰 갱신
- `GET /api/auth/profile` - 사용자 프로필 조회
- `PUT /api/auth/profile` - 프로필 업데이트 (weekly_goal, user_level 포함)
- `POST /api/auth/change-password` - 비밀번호 변경

**문서**: [AUTH_API.md](./AUTH_API.md)

---

### Content Service

**목적**: 레슨 콘텐츠, 단어 및 문법 관리

**주요 엔드포인트**:
- `GET /api/content/lessons` - 레슨 목록 조회
- `GET /api/content/lessons/:id` - 레슨 상세 조회
- `GET /api/content/lessons/:id/download` - 레슨 패키지 다운로드
- `POST /api/content/check-updates` - 업데이트 확인
- `GET /api/content/vocabulary` - 단어 목록 조회
- `GET /api/content/grammar` - 문법 포인트 조회
- `GET /api/content/search` - 콘텐츠 검색

**문서**: [CONTENT_API.md](./CONTENT_API.md)

---

### Progress Service

**목적**: 학습 진도 추적 및 간격 반복 시스템 (SRS)

**주요 엔드포인트**:
- `GET /api/progress/user/:userId` - 사용자 진도 조회
- `POST /api/progress/complete` - 레슨 완료
- `PUT /api/progress/lesson/:lessonId` - 레슨 진도 업데이트
- `POST /api/progress/sync` - 오프라인 진도 동기화
- `GET /api/progress/review-schedule` - SRS 복습 일정 조회
- `POST /api/progress/review` - 복습 결과 제출
- `GET /api/progress/statistics` - 학습 통계 조회
- `GET /api/progress/streak` - 학습 연속 기록 조회

**문서**: [PROGRESS_API.md](./PROGRESS_API.md)

---

### Media Service

**목적**: 실시간 처리를 통한 이미지 및 오디오 파일 서빙

**주요 엔드포인트**:
- `GET /media/images/:key` - 이미지 조회 (리사이즈/포맷 옵션 포함)
- `GET /media/audio/:key` - 오디오 조회 (트랜스코드 옵션 포함)
- `POST /media/upload` - 미디어 파일 업로드 (관리자)
- `DELETE /media/:type/:key` - 미디어 파일 삭제 (관리자)
- `GET /media/info/:type/:key` - 미디어 메타데이터 조회
- `POST /media/batch-download` - 배치 다운로드 URL

**문서**: [MEDIA_API.md](./MEDIA_API.md)

---

### Analytics Service

**목적**: 사용자 활동 로깅, 학습 패턴 분석, 통계 대시보드

**주요 엔드포인트**:
- `POST /api/analytics/events` - 이벤트 로깅
- `GET /api/analytics/user/:userId/activity` - 사용자 활동 조회
- `GET /api/analytics/user/:userId/patterns` - 학습 패턴 분석
- `GET /api/analytics/dashboard` - 통계 대시보드 (관리자)
- `GET /api/analytics/reports/daily` - 일일 리포트
- `GET /api/analytics/reports/weekly` - 주간 리포트
- `GET /health` - 헬스체크

**문서**: [ANALYTICS_API.md](./ANALYTICS_API.md)

---

### Admin Service

**목적**: 관리자 대시보드, 콘텐츠 관리, 시스템 모니터링

**주요 엔드포인트**:
- `POST /api/admin/auth/login` - 관리자 로그인
- `GET /api/admin/users` - 사용자 목록 조회
- `GET /api/admin/users/:id` - 사용자 상세 조회
- `PUT /api/admin/users/:id` - 사용자 정보 수정
- `DELETE /api/admin/users/:id` - 사용자 삭제
- `GET /api/admin/lessons` - 레슨 목록 조회
- `POST /api/admin/lessons` - 레슨 생성
- `PUT /api/admin/lessons/:id` - 레슨 수정
- `DELETE /api/admin/lessons/:id` - 레슨 삭제
- `GET /api/admin/vocabulary` - 단어 목록 조회
- `POST /api/admin/vocabulary` - 단어 추가
- `PUT /api/admin/vocabulary/:id` - 단어 수정
- `DELETE /api/admin/vocabulary/:id` - 단어 삭제
- `POST /api/admin/media/upload` - 미디어 업로드
- `GET /api/admin/analytics/dashboard` - 분석 대시보드
- `GET /api/admin/system/health` - 시스템 헬스체크
- `GET /api/admin/system/metrics` - 시스템 메트릭
- `GET /api/admin/dev-notes` - 개발노트 목록
- `GET /api/admin/dev-notes/:filename` - 개발노트 상세
- `GET /health` - 헬스체크

**Hangul 관리** (2026-02-03):
- `GET /api/admin/hangul/characters` - 한글 자모 목록 (관리자)
- `POST /api/admin/hangul/characters` - 자모 생성 (관리자)
- `PUT /api/admin/hangul/characters/:id` - 자모 수정 (관리자)
- `DELETE /api/admin/hangul/characters/:id` - 자모 삭제 (관리자)

**웹 배포 자동화** (2026-02-04):
- `POST /api/admin/deploy/web/start` - 배포 시작 (관리자)
- `GET /api/admin/deploy/web/status/:id` - 배포 상태 조회
- `GET /api/admin/deploy/web/logs/:id` - 배포 로그 조회
- `GET /api/admin/deploy/web/history` - 배포 이력
- `DELETE /api/admin/deploy/web/:id` - 배포 취소 (관리자)

**웹 대시보드**: https://lemon.3chan.kr/admin/

**문서**: [ADMIN_API.md](./ADMIN_API.md)

---

### Moderation Service

**목적**: AI 기반 콘텐츠 모더레이션 (다국어 독성 감지, ONNX Runtime 추론)

**주요 엔드포인트**:
- `POST /api/moderation/text` - 텍스트 콘텐츠 독성 검사
- `GET /api/moderation/health` - 모델 로딩 상태 및 헬스체크
- `GET /health` - 서비스 헬스체크

**참고**: Moderation Service는 SNS Service에서 내부적으로 호출합니다 (게시물, 댓글, 바이오 작성 시). 외부 직접 접근은 불필요합니다.

**문서**: [MODERATION_API.md](./MODERATION_API.md)

---

## 🔒 인증 및 권한

### JWT 토큰 구조

```json
{
  "sub": "1",
  "email": "user@example.com",
  "role": "user",
  "iat": 1706268000,
  "exp": 1706872800
}
```

### 토큰 수명 주기

1. **액세스 토큰**: 7일 유효
2. **리프레시 토큰**: 30일 유효
3. **토큰 갱신**: 액세스 토큰 만료 전에 `/api/auth/refresh` 엔드포인트 사용

### 권한 레벨

| 레벨 | 설명 | 필요한 경우 |
|-------|-------------|--------------|
| **Public** | 인증 불필요 | 헬스 체크, 미디어 조회 |
| **User** | JWT 필요 | 콘텐츠 접근, 진도 추적 |
| **Admin** | 관리자 역할의 JWT | 미디어 업로드/삭제, 콘텐츠 관리 |

---

## 📊 응답 형식

### 성공 응답

```json
{
  "success": true,
  "data": {
    // Response data
  }
}
```

### 오류 응답

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": [] // Optional, for validation errors
  }
}
```

### 페이지네이션

```json
{
  "success": true,
  "data": {
    "items": [...],
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 150,
      "total_pages": 8
    }
  }
}
```

---

## ⚠️ 공통 오류 코드

### HTTP 상태 코드

| 코드 | 이름 | 설명 |
|------|------|-------------|
| `200` | OK | 요청 성공 |
| `201` | Created | 리소스 생성 성공 |
| `204` | No Content | 요청 성공, 반환할 콘텐츠 없음 |
| `206` | Partial Content | 부분 데이터 (범위 요청) |
| `400` | Bad Request | 잘못된 요청 데이터 |
| `401` | Unauthorized | 인증 필요 또는 실패 |
| `403` | Forbidden | 권한 부족 |
| `404` | Not Found | 리소스를 찾을 수 없음 |
| `409` | Conflict | 리소스 충돌 (예: 중복) |
| `413` | Payload Too Large | 요청 본문이 너무 큼 |
| `416` | Range Not Satisfiable | 잘못된 바이트 범위 |
| `422` | Unprocessable Entity | 유효성 검증 오류 |
| `423` | Locked | 리소스 잠김 (예: 계정) |
| `429` | Too Many Requests | 속도 제한 초과 |
| `500` | Internal Server Error | 서버 오류 |
| `503` | Service Unavailable | 서비스 일시적으로 사용 불가 |

### 애플리케이션 오류 코드

| 코드 | 서비스 | 설명 |
|------|---------|-------------|
| `VALIDATION_ERROR` | All | 잘못된 입력 데이터 |
| `UNAUTHORIZED` | All | 인증 필요 |
| `FORBIDDEN` | All | 권한 부족 |
| `INTERNAL_SERVER_ERROR` | All | 서버 오류 |
| `SERVICE_UNAVAILABLE` | All | 서비스 다운 |
| `INVALID_CREDENTIALS` | Auth | 잘못된 이메일/비밀번호 |
| `EMAIL_ALREADY_EXISTS` | Auth | 이메일이 이미 등록됨 |
| `ACCOUNT_LOCKED` | Auth | 계정이 일시적으로 잠김 |
| `LESSON_NOT_FOUND` | Content | 레슨을 찾을 수 없음 |
| `SUBSCRIPTION_REQUIRED` | Content | 프리미엄 구독 필요 |
| `PROGRESS_NOT_FOUND` | Progress | 진도 레코드를 찾을 수 없음 |
| `SYNC_CONFLICT` | Progress | 동기화 중 데이터 충돌 |
| `IMAGE_NOT_FOUND` | Media | 이미지 파일을 찾을 수 없음 |
| `AUDIO_NOT_FOUND` | Media | 오디오 파일을 찾을 수 없음 |
| `FILE_TOO_LARGE` | Media | 파일이 크기 제한 초과 |
| `RATE_LIMIT_EXCEEDED` | Media | 속도 제한 초과 |

---

## 🔄 속도 제한

### 서비스별 제한

| 서비스 | 엔드포인트 타입 | 제한 | 기간 |
|---------|---------------|-------|--------|
| Auth | Login | 5 요청 | 15분 |
| Auth | Register | 3 요청 | 1시간 |
| Auth | Other | 100 요청 | 1분 |
| Content | All | 1000 요청 | 1분 |
| Progress | All | 500 요청 | 1분 |
| Media | GET | 1000 요청 | 1분 |
| Media | POST/DELETE | 100 요청 | 1시간 |

### 속도 제한 헤더

속도 제한을 초과하면 응답에 다음이 포함됩니다:

```
HTTP/1.1 429 Too Many Requests
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 0
X-RateLimit-Reset: 1706268000
Retry-After: 60
```

---

## 🧪 API 테스트

### cURL 사용

**기본 GET 요청**:
```bash
curl -X GET http://localhost:3002/api/content/lessons \
  -H "Authorization: Bearer <token>"
```

**JSON 본문을 포함한 POST**:
```bash
curl -X POST http://localhost:3003/api/progress/complete \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "lesson_id": 1,
    "quiz_score": 95
  }'
```

**파일 업로드**:
```bash
curl -X POST http://localhost:3004/media/upload \
  -H "Authorization: Bearer <token>" \
  -F "file=@/path/to/image.jpg" \
  -F "type=image" \
  -F "category=lessons"
```

### Postman 사용

1. 각 API 문서에서 OpenAPI 3.0 스펙 가져오기
2. 환경 변수 설정:
   - `base_url`: `http://localhost`
   - `auth_token`: 사용자의 JWT 토큰
3. 요청에서 `{{base_url}}` 및 `{{auth_token}}` 사용

### HTTPie 사용

**GET 요청**:
```bash
http GET localhost:3002/api/content/lessons \
  Authorization:"Bearer <token>"
```

**POST 요청**:
```bash
http POST localhost:3003/api/progress/complete \
  Authorization:"Bearer <token>" \
  user_id:=1 \
  lesson_id:=1 \
  quiz_score:=95
```

---

## 📝 API 변경 이력

### Version 1.0.0 (2024-01-26)

**초기 릴리스**

- ✅ Auth Service: 사용자 등록, 로그인, 프로필 관리
- ✅ Content Service: 레슨 콘텐츠, 단어, 문법
- ✅ Progress Service: 진도 추적, SRS 복습, 통계
- ✅ Media Service: 이미지/오디오 서빙 및 처리

---

## 🔗 관련 문서

- **[프로젝트 가이드](../../CLAUDE.md)** - 완전한 개발 가이드
- **[README](../../README.md)** - 프로젝트 개요 및 설정
- **[배포 스크립트](../../scripts/README.md)** - 배포 및 운영

---

## 💡 모범 사례

### 1. 오류 처리

항상 오류를 우아하게 처리하세요:

```javascript
try {
  const response = await fetch('http://localhost:3002/api/content/lessons', {
    headers: {
      'Authorization': `Bearer ${token}`
    }
  });

  if (!response.ok) {
    const error = await response.json();
    console.error(`Error ${error.error.code}: ${error.error.message}`);
    return;
  }

  const data = await response.json();
  // Handle success
} catch (error) {
  console.error('Network error:', error);
}
```

### 2. 토큰 관리

토큰을 안전하게 저장하고 만료 전에 갱신하세요:

```javascript
// Check if token is about to expire
function isTokenExpiring(token) {
  const decoded = jwt_decode(token);
  const expiresIn = decoded.exp - (Date.now() / 1000);
  return expiresIn < 300; // Less than 5 minutes
}

// Refresh token if needed
if (isTokenExpiring(accessToken)) {
  const newTokens = await refreshAccessToken(refreshToken);
  // Update stored tokens
}
```

### 3. 페이지네이션

리스트 엔드포인트에는 항상 페이지네이션을 구현하세요:

```javascript
async function fetchAllLessons() {
  let allLessons = [];
  let page = 1;
  let hasMore = true;

  while (hasMore) {
    const response = await fetch(
      `http://localhost:3002/api/content/lessons?page=${page}&limit=50`,
      { headers: { 'Authorization': `Bearer ${token}` } }
    );

    const data = await response.json();
    allLessons = [...allLessons, ...data.data.lessons];

    hasMore = page < data.data.pagination.total_pages;
    page++;
  }

  return allLessons;
}
```

### 4. 캐싱

미디어 파일에 대한 클라이언트 측 캐싱을 구현하세요:

```javascript
// Use ETags for conditional requests
async function fetchImage(url, cachedETag) {
  const headers = {
    'Authorization': `Bearer ${token}`
  };

  if (cachedETag) {
    headers['If-None-Match'] = cachedETag;
  }

  const response = await fetch(url, { headers });

  if (response.status === 304) {
    // Use cached version
    return getCachedImage(url);
  }

  // Cache new version with ETag
  const etag = response.headers.get('ETag');
  const blob = await response.blob();
  cacheImage(url, blob, etag);

  return blob;
}
```

### 5. 오프라인 동기화

충돌 해결 기능을 포함한 강력한 오프라인 동기화를 구현하세요:

```javascript
async function syncProgress() {
  const syncQueue = await getLocalSyncQueue();

  if (syncQueue.length === 0) return;

  const response = await fetch('http://localhost:3003/api/progress/sync', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      user_id: userId,
      sync_items: syncQueue
    })
  });

  const result = await response.json();

  // Remove synced items from queue
  for (const item of result.data.synced_items) {
    await removeSyncItem(item.index);
  }

  // Handle failed items
  for (const item of result.data.failed_items) {
    console.error(`Sync failed for item ${item.index}:`, item.error);
    // Optionally retry or notify user
  }
}
```

---

## 🆘 지원

API 문제나 질문이 있는 경우:

1. 특정 서비스 문서 확인
2. 위의 공통 오류 코드 검토
3. 서비스 헬스 체크: `GET /health` 또는 `GET /api/<service>/health`
4. 로그 검토: `./scripts/logs.sh <service-name>`
5. GitHub에 이슈 생성

---

## 📜 라이선스

이 API 문서는 Lemon Korean 프로젝트의 일부입니다.

---

**마지막 업데이트**: 2026-03-11
**API 버전**: 1.0.0

**중국어권 한국어 학습자를 위해 만들어졌습니다**
