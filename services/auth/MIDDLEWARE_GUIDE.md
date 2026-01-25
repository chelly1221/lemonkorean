# Auth Middleware 사용 가이드

완전히 구현된 인증/인가 미들웨어 사용 가이드입니다.

---

## 📋 목차

1. [requireAuth - 기본 인증](#requireauth)
2. [requireAdmin - 관리자 권한](#requireadmin)
3. [requirePremium - 프리미엄 구독](#requirepremium)
4. [requireSubscription - 특정 구독 타입](#requiresubscription)
5. [optionalAuth - 선택적 인증](#optionalauth)
6. [requireEmailVerified - 이메일 인증](#requireemailverified)
7. [에러 코드](#error-codes)
8. [사용 예제](#examples)

---

## 🔐 requireAuth

**기본 JWT 인증 미들웨어**

### 기능
- Authorization 헤더에서 JWT 추출
- 토큰 검증 (만료, 유효성)
- 사용자 존재 여부 확인
- 계정 활성화 상태 확인
- `req.user`에 사용자 정보 추가

### 사용법

```javascript
const { requireAuth } = require('../middleware/auth.middleware');

// 보호된 라우트
router.get('/profile', requireAuth, (req, res) => {
  res.json({
    user: req.user
  });
});

// req.user 객체 구조
{
  id: 2,
  email: 'user@example.com',
  name: '张伟',
  subscriptionType: 'premium',
  languagePreference: 'zh',
  emailVerified: true
}
```

### API 호출 예제

```bash
# 인증된 요청
curl -X GET http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# 성공 응답 (200)
{
  "user": {
    "id": 2,
    "email": "user@example.com",
    ...
  }
}
```

### 에러 응답

```bash
# Authorization 헤더 없음
{
  "error": "Unauthorized",
  "message": "No authorization header provided",
  "code": "NO_AUTH_HEADER"
}

# 잘못된 형식
{
  "error": "Unauthorized",
  "message": "Invalid authorization header format. Expected: Bearer <token>",
  "code": "INVALID_AUTH_FORMAT"
}

# 토큰 만료
{
  "error": "Unauthorized",
  "message": "Token has expired. Please login again.",
  "code": "TOKEN_EXPIRED"
}

# 사용자 없음
{
  "error": "Unauthorized",
  "message": "User not found. Token may be invalid.",
  "code": "USER_NOT_FOUND"
}

# 계정 비활성화
{
  "error": "Forbidden",
  "message": "Your account has been deactivated. Please contact support.",
  "code": "ACCOUNT_DEACTIVATED"
}
```

---

## 👑 requireAdmin

**관리자 권한 확인 미들웨어**

### 기능
- `requireAuth` 다음에 사용
- 관리자 여부 확인 (3가지 방법)
  1. 이메일에 'admin@' 포함
  2. 환경 변수 `ADMIN_EMAILS` 목록에 포함
  3. 사용자 ID가 1 (첫 번째 사용자)
- `req.user.isAdmin = true` 추가

### 사용법

```javascript
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

// 관리자 전용 라우트
router.delete('/users/:id', requireAuth, requireAdmin, (req, res) => {
  // req.user.isAdmin === true
  res.json({ message: 'User deleted' });
});
```

### 환경 변수 설정

```bash
# .env 파일
ADMIN_EMAILS=admin@lemon.com,superadmin@lemon.com
```

### API 호출 예제

```bash
# 관리자 요청
curl -X DELETE http://localhost:3001/api/users/5 \
  -H "Authorization: Bearer <admin-token>"

# 성공 (200)
{
  "message": "User deleted"
}

# 실패 - 관리자 아님 (403)
{
  "error": "Forbidden",
  "message": "Admin access required. You do not have permission to access this resource.",
  "code": "ADMIN_REQUIRED"
}
```

---

## 💎 requirePremium

**프리미엄 구독 확인 미들웨어**

### 기능
- 사용자가 `premium` 또는 `lifetime` 구독인지 확인
- `free` 사용자는 403 반환
- 구독 만료일 확인 (premium의 경우)

### 사용법

```javascript
const { requireAuth, requirePremium } = require('../middleware/auth.middleware');

// 프리미엄 전용 콘텐츠
router.get('/premium-lessons', requireAuth, requirePremium, (req, res) => {
  res.json({
    lessons: [...]
  });
});
```

### API 호출 예제

```bash
# 프리미엄 사용자
curl -X GET http://localhost:3001/api/content/premium-lessons \
  -H "Authorization: Bearer <premium-token>"

# 성공 (200)
{
  "lessons": [...]
}

# 실패 - 무료 사용자 (403)
{
  "error": "Forbidden",
  "message": "Premium subscription required to access this resource",
  "code": "PREMIUM_REQUIRED",
  "upgradeUrl": "/api/subscription/upgrade"
}

# 실패 - 구독 만료 (403)
{
  "error": "Forbidden",
  "message": "Your premium subscription has expired",
  "code": "SUBSCRIPTION_EXPIRED",
  "expiredAt": "2025-12-31T23:59:59.000Z",
  "renewUrl": "/api/subscription/renew"
}
```

---

## 🎯 requireSubscription

**특정 구독 타입 확인 미들웨어 (고급)**

### 기능
- 특정 구독 타입 배열을 받아서 확인
- 더 세밀한 권한 제어

### 사용법

```javascript
const { requireAuth, requireSubscription } = require('../middleware/auth.middleware');

// Lifetime 전용 콘텐츠
router.get('/lifetime-only',
  requireAuth,
  requireSubscription(['lifetime']),
  (req, res) => {
    res.json({ message: 'Lifetime exclusive content' });
  }
);

// Premium 또는 Lifetime
router.get('/paid-content',
  requireAuth,
  requireSubscription(['premium', 'lifetime']),
  (req, res) => {
    res.json({ message: 'Paid content' });
  }
);
```

### API 호출 예제

```bash
# 실패 - 권한 부족 (403)
{
  "error": "Forbidden",
  "message": "This resource requires one of: lifetime subscription",
  "code": "SUBSCRIPTION_REQUIRED",
  "currentSubscription": "premium"
}
```

---

## 🔓 optionalAuth

**선택적 인증 미들웨어**

### 기능
- 토큰이 있으면 검증하고 `req.user` 추가
- 토큰이 없거나 유효하지 않아도 계속 진행
- 공개 콘텐츠지만 로그인 사용자에게 개인화된 응답 제공 시 사용

### 사용법

```javascript
const { optionalAuth } = require('../middleware/auth.middleware');

// 공개 콘텐츠 (로그인 시 개인화)
router.get('/lessons', optionalAuth, (req, res) => {
  if (req.user) {
    // 로그인 사용자 - 진도 포함
    return res.json({
      lessons: [...],
      userProgress: [...]
    });
  } else {
    // 비로그인 사용자 - 기본 정보만
    return res.json({
      lessons: [...]
    });
  }
});
```

### API 호출 예제

```bash
# 토큰 있음
curl -X GET http://localhost:3001/api/content/lessons \
  -H "Authorization: Bearer <token>"
# → req.user 존재

# 토큰 없음
curl -X GET http://localhost:3001/api/content/lessons
# → req.user 없음, 계속 진행

# 잘못된 토큰
curl -X GET http://localhost:3001/api/content/lessons \
  -H "Authorization: Bearer invalid-token"
# → req.user 없음, 계속 진행 (에러 없음)
```

---

## ✉️ requireEmailVerified

**이메일 인증 확인 미들웨어**

### 기능
- 이메일 인증된 사용자만 허용
- 미인증 사용자는 403 반환

### 사용법

```javascript
const { requireAuth, requireEmailVerified } = require('../middleware/auth.middleware');

// 이메일 인증 필수 기능
router.post('/create-post', requireAuth, requireEmailVerified, (req, res) => {
  res.json({ message: 'Post created' });
});
```

### API 호출 예제

```bash
# 실패 - 이메일 미인증 (403)
{
  "error": "Forbidden",
  "message": "Email verification required. Please verify your email address.",
  "code": "EMAIL_VERIFICATION_REQUIRED",
  "resendUrl": "/api/auth/resend-verification"
}
```

---

## ⚠️ 에러 코드

| 코드 | HTTP | 설명 |
|------|------|------|
| `NO_AUTH_HEADER` | 401 | Authorization 헤더 없음 |
| `INVALID_AUTH_FORMAT` | 401 | Bearer 형식 아님 |
| `MISSING_TOKEN` | 401 | 토큰 비어있음 |
| `TOKEN_EXPIRED` | 401 | 토큰 만료 |
| `INVALID_TOKEN` | 401 | 유효하지 않은 토큰 |
| `TOKEN_VERIFICATION_FAILED` | 401 | 토큰 검증 실패 |
| `USER_NOT_FOUND` | 401 | 사용자 없음 |
| `ACCOUNT_DEACTIVATED` | 403 | 계정 비활성화 |
| `AUTH_REQUIRED` | 401 | 인증 필요 |
| `ADMIN_REQUIRED` | 403 | 관리자 권한 필요 |
| `PREMIUM_REQUIRED` | 403 | 프리미엄 구독 필요 |
| `SUBSCRIPTION_EXPIRED` | 403 | 구독 만료 |
| `SUBSCRIPTION_REQUIRED` | 403 | 특정 구독 필요 |
| `EMAIL_VERIFICATION_REQUIRED` | 403 | 이메일 인증 필요 |

---

## 💡 사용 예제

### 예제 1: 기본 보호 라우트

```javascript
const express = require('express');
const router = express.Router();
const { requireAuth } = require('../middleware/auth.middleware');

// 프로필 조회 - 인증 필요
router.get('/profile', requireAuth, async (req, res) => {
  res.json({
    user: req.user
  });
});

// 프로필 수정 - 인증 필요
router.put('/profile', requireAuth, async (req, res) => {
  const { name } = req.body;
  // req.user.id 사용
  await updateUser(req.user.id, { name });
  res.json({ message: 'Updated' });
});
```

### 예제 2: 관리자 전용 라우트

```javascript
const { requireAuth, requireAdmin } = require('../middleware/auth.middleware');

// 사용자 목록 - 관리자만
router.get('/admin/users', requireAuth, requireAdmin, async (req, res) => {
  const users = await getAllUsers();
  res.json({ users });
});

// 사용자 삭제 - 관리자만
router.delete('/admin/users/:id', requireAuth, requireAdmin, async (req, res) => {
  await deleteUser(req.params.id);
  res.json({ message: 'Deleted' });
});
```

### 예제 3: 프리미엄 콘텐츠

```javascript
const { requireAuth, requirePremium } = require('../middleware/auth.middleware');

// 일반 레슨 - 인증만 필요
router.get('/lessons', requireAuth, async (req, res) => {
  const lessons = await getLessons();
  res.json({ lessons });
});

// 프리미엄 레슨 - 프리미엄 구독 필요
router.get('/premium-lessons', requireAuth, requirePremium, async (req, res) => {
  const lessons = await getPremiumLessons();
  res.json({ lessons });
});
```

### 예제 4: 다중 미들웨어 조합

```javascript
const {
  requireAuth,
  requireAdmin,
  requireEmailVerified
} = require('../middleware/auth.middleware');

// 이메일 인증 + 관리자 권한 필요
router.post('/admin/announcements',
  requireAuth,           // 1. 인증 확인
  requireEmailVerified,  // 2. 이메일 인증 확인
  requireAdmin,          // 3. 관리자 권한 확인
  async (req, res) => {
    // 모든 조건 통과
    await createAnnouncement(req.body);
    res.json({ message: 'Created' });
  }
);
```

### 예제 5: 선택적 인증

```javascript
const { optionalAuth } = require('../middleware/auth.middleware');

router.get('/public/lessons', optionalAuth, async (req, res) => {
  const lessons = await getLessons();

  if (req.user) {
    // 로그인 사용자 - 진도 포함
    const progress = await getProgress(req.user.id);
    return res.json({ lessons, progress });
  }

  // 비로그인 사용자 - 레슨만
  res.json({ lessons });
});
```

### 예제 6: 구독 타입별 제한

```javascript
const { requireAuth, requireSubscription } = require('../middleware/auth.middleware');

// Lifetime 전용
router.get('/lifetime-benefits',
  requireAuth,
  requireSubscription(['lifetime']),
  (req, res) => {
    res.json({ benefits: ['benefit1', 'benefit2'] });
  }
);

// Premium 또는 Lifetime (Free 제외)
router.get('/paid-features',
  requireAuth,
  requireSubscription(['premium', 'lifetime']),
  (req, res) => {
    res.json({ features: [...] });
  }
);
```

---

## 🔍 로깅

모든 미들웨어는 상세한 로그를 출력합니다:

```
[AUTH] Authenticating request: GET /api/auth/profile
[AUTH] Token verified for user: 2
[AUTH] Authentication successful for user: zhang.wei@example.com

[ADMIN] Checking admin privileges for user: 2
[ADMIN] Admin access granted for user: admin@lemon.com

[PREMIUM] Checking premium subscription for user: 3
[PREMIUM] Access denied for free user: li.na@example.com

[OPTIONAL_AUTH] No token provided, continuing without auth

[EMAIL_VERIFIED] Checking email verification for user: 2
[EMAIL_VERIFIED] Email verified for user: zhang.wei@example.com
```

---

## ✅ 체크리스트

- [x] `requireAuth` - 기본 JWT 인증
- [x] `requireAdmin` - 관리자 권한 확인
- [x] `requirePremium` - 프리미엄 구독 확인
- [x] `requireSubscription` - 특정 구독 타입 확인
- [x] `optionalAuth` - 선택적 인증
- [x] `requireEmailVerified` - 이메일 인증 확인
- [x] `attachUserToRateLimit` - Rate limiting 헬퍼
- [x] 완전한 에러 처리
- [x] 상세한 로깅
- [x] 에러 코드 체계
- [x] 보안 검증 (토큰 만료, 계정 상태 등)

---

## 🚀 빠른 시작

```javascript
// routes/protected.routes.js
const express = require('express');
const router = express.Router();
const {
  requireAuth,
  requireAdmin,
  requirePremium,
  optionalAuth
} = require('../middleware/auth.middleware');

// 공개 라우트 (개인화 가능)
router.get('/public', optionalAuth, controller.getPublic);

// 보호된 라우트
router.get('/protected', requireAuth, controller.getProtected);

// 프리미엄 라우트
router.get('/premium', requireAuth, requirePremium, controller.getPremium);

// 관리자 라우트
router.post('/admin', requireAuth, requireAdmin, controller.adminAction);

module.exports = router;
```

완벽하게 작동합니다! 🎉
