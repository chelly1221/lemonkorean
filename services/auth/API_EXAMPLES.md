# Auth Service API Examples

완전히 구현된 Auth Service API 사용 예제입니다.

## 🔐 구현된 기능

### 1. **회원가입 (Register)**
- 이메일 중복 체크
- 비밀번호 bcrypt 해싱 (10 salt rounds)
- JWT 토큰 자동 발급
- 세션 생성 (디바이스 정보 포함)

### 2. **로그인 (Login)**
- 이메일/비밀번호 검증
- bcrypt 비밀번호 비교
- Access Token + Refresh Token 발급
- 세션 저장 (IP, User-Agent 포함)
- 마지막 로그인 시간 업데이트

### 3. **토큰 갱신 (Refresh)**
- Refresh Token 검증
- 세션 유효성 확인
- 새로운 Access Token 발급
- 세션 업데이트

### 4. **토큰 검증 (Verify)**
- JWT 토큰 검증
- 사용자 정보 반환
- 토큰 만료 확인

### 5. **로그아웃 (Logout)**
- 특정 세션 삭제
- 모든 디바이스에서 로그아웃 (옵션)

---

## 📝 API 사용 예제

### 1. 회원가입

```bash
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123",
    "name": "张伟",
    "language_preference": "zh"
  }'
```

**응답:**
```json
{
  "success": true,
  "message": "User registered successfully",
  "user": {
    "id": 4,
    "email": "test@example.com",
    "name": "张伟",
    "language_preference": "zh",
    "subscription_type": "free",
    "created_at": "2026-01-25T10:30:00.000Z"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**에러 예시:**
```json
// 이메일 중복
{
  "error": "Conflict",
  "message": "Email already registered",
  "code": "EMAIL_EXISTS"
}

// 유효성 검증 실패
{
  "error": "Validation Error",
  "errors": [
    "Invalid email format",
    "Password must be at least 6 characters long"
  ]
}
```

---

### 2. 로그인

```bash
curl -X POST http://localhost:3001/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "zhang.wei@example.com",
    "password": "user123"
  }'
```

**응답:**
```json
{
  "success": true,
  "message": "Login successful",
  "user": {
    "id": 2,
    "email": "zhang.wei@example.com",
    "name": "张伟",
    "language_preference": "zh",
    "subscription_type": "premium",
    "subscription_expires_at": "2027-01-25T10:30:00.000Z",
    "email_verified": true,
    "created_at": "2025-12-26T10:30:00.000Z",
    "last_login": "2026-01-25T10:30:00.000Z"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**에러 예시:**
```json
// 잘못된 비밀번호
{
  "error": "Unauthorized",
  "message": "Invalid email or password",
  "code": "INVALID_CREDENTIALS"
}

// 계정 비활성화
{
  "error": "Forbidden",
  "message": "Account is deactivated. Please contact support.",
  "code": "ACCOUNT_DEACTIVATED"
}
```

---

### 3. 토큰 갱신

```bash
curl -X POST http://localhost:3001/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

**응답:**
```json
{
  "success": true,
  "message": "Token refreshed successfully",
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**에러 예시:**
```json
// 토큰 만료
{
  "error": "Unauthorized",
  "message": "Refresh token expired",
  "code": "REFRESH_TOKEN_EXPIRED"
}

// 세션 만료
{
  "error": "Unauthorized",
  "message": "Session expired or invalid. Please login again.",
  "code": "SESSION_EXPIRED"
}
```

---

### 4. 토큰 검증

```bash
curl -X POST http://localhost:3001/api/auth/verify \
  -H "Content-Type: application/json" \
  -d '{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'
```

**응답:**
```json
{
  "success": true,
  "valid": true,
  "message": "Token is valid",
  "user": {
    "id": 2,
    "email": "zhang.wei@example.com",
    "name": "张伟",
    "language_preference": "zh",
    "subscription_type": "premium",
    "subscription_expires_at": "2027-01-25T10:30:00.000Z",
    "email_verified": true
  },
  "tokenData": {
    "userId": 2,
    "email": "zhang.wei@example.com",
    "subscriptionType": "premium",
    "iat": 1706176200,
    "exp": 1706780200
  }
}
```

**에러 예시:**
```json
// 토큰 만료
{
  "error": "Unauthorized",
  "message": "Token expired",
  "code": "TOKEN_EXPIRED",
  "valid": false
}

// 유효하지 않은 토큰
{
  "error": "Unauthorized",
  "message": "Invalid token",
  "code": "INVALID_TOKEN",
  "valid": false
}
```

---

### 5. 프로필 조회

```bash
curl -X GET http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**응답:**
```json
{
  "success": true,
  "user": {
    "id": 2,
    "email": "zhang.wei@example.com",
    "name": "张伟",
    "language_preference": "zh",
    "subscription_type": "premium",
    "subscription_expires_at": "2027-01-25T10:30:00.000Z",
    "email_verified": true,
    "profile_image_url": null,
    "created_at": "2025-12-26T10:30:00.000Z",
    "last_login": "2026-01-25T10:30:00.000Z"
  },
  "stats": {
    "user_id": 2,
    "email": "zhang.wei@example.com",
    "lessons_completed": 2,
    "words_mastered": 3,
    "avg_quiz_score": 91.5,
    "total_study_time_seconds": 3120,
    "last_study_date": "2026-01-24T10:30:00.000Z",
    "study_days_count": 3
  }
}
```

---

### 6. 프로필 수정

```bash
curl -X PUT http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "name": "王小明",
    "language_preference": "ko"
  }'
```

**응답:**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "user": {
    "id": 2,
    "email": "zhang.wei@example.com",
    "name": "王小明",
    "language_preference": "ko",
    "subscription_type": "premium",
    "profile_image_url": null,
    "created_at": "2025-12-26T10:30:00.000Z"
  }
}
```

---

### 7. 로그아웃

```bash
# 현재 디바이스에서 로그아웃
curl -X POST http://localhost:3001/api/auth/logout \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }'

# 모든 디바이스에서 로그아웃
curl -X POST http://localhost:3001/api/auth/logout \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "logoutAll": true
  }'
```

**응답:**
```json
// 단일 디바이스
{
  "success": true,
  "message": "Logged out successfully"
}

// 모든 디바이스
{
  "success": true,
  "message": "Logged out from all devices successfully",
  "sessionsDeleted": 3
}
```

---

## 🔍 에러 코드

| 코드 | 설명 |
|------|------|
| `EMAIL_EXISTS` | 이메일이 이미 등록됨 |
| `INVALID_CREDENTIALS` | 잘못된 이메일 또는 비밀번호 |
| `ACCOUNT_DEACTIVATED` | 계정 비활성화됨 |
| `TOKEN_EXPIRED` | Access Token 만료 |
| `REFRESH_TOKEN_EXPIRED` | Refresh Token 만료 |
| `SESSION_EXPIRED` | 세션 만료 또는 유효하지 않음 |
| `INVALID_TOKEN` | 유효하지 않은 토큰 |
| `MISSING_TOKEN` | 토큰 없음 |
| `USER_NOT_FOUND` | 사용자를 찾을 수 없음 |
| `SESSION_NOT_FOUND` | 세션을 찾을 수 없음 |

---

## 🛡️ 보안 기능

### 1. 비밀번호 보안
- bcrypt 해싱 (10 salt rounds)
- 최소 6자 이상 요구
- 평문 비밀번호 저장 안 함

### 2. JWT 토큰
- HS256 알고리즘
- Access Token: 7일 유효
- Refresh Token: 30일 유효
- 발급자(issuer) 및 대상(audience) 검증

### 3. 세션 관리
- 디바이스 정보 저장
- IP 주소 추적
- User-Agent 저장
- 세션 만료 시간 관리
- 자동 만료 세션 정리

### 4. 입력 검증
- 이메일 형식 검증
- SQL Injection 방지 (Parameterized queries)
- XSS 방지 (입력 새니타이제이션)

### 5. 에러 처리
- 민감한 정보 노출 방지
- 일관된 에러 메시지
- 개발 모드에서만 스택 트레이스 표시

---

## 🧪 테스트 시나리오

### 시나리오 1: 완전한 사용자 플로우
```bash
# 1. 회원가입
RESPONSE=$(curl -s -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123","name":"测试用户"}')

ACCESS_TOKEN=$(echo $RESPONSE | jq -r '.accessToken')
REFRESH_TOKEN=$(echo $RESPONSE | jq -r '.refreshToken')

# 2. 프로필 조회
curl -s -X GET http://localhost:3001/api/auth/profile \
  -H "Authorization: Bearer $ACCESS_TOKEN" | jq

# 3. 토큰 갱신
NEW_RESPONSE=$(curl -s -X POST http://localhost:3001/api/auth/refresh \
  -H "Content-Type: application/json" \
  -d "{\"refreshToken\":\"$REFRESH_TOKEN\"}")

NEW_ACCESS_TOKEN=$(echo $NEW_RESPONSE | jq -r '.accessToken')

# 4. 로그아웃
curl -s -X POST http://localhost:3001/api/auth/logout \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"refreshToken\":\"$REFRESH_TOKEN\"}" | jq
```

### 시나리오 2: 에러 처리
```bash
# 잘못된 이메일 형식
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"invalid-email","password":"test123"}'

# 짧은 비밀번호
curl -X POST http://localhost:3001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"123"}'

# 만료된 토큰
curl -X POST http://localhost:3001/api/auth/verify \
  -H "Content-Type: application/json" \
  -d '{"token":"expired.token.here"}'
```

---

## 📊 로깅

모든 주요 작업은 콘솔에 로깅됩니다:

```
[REGISTER] Attempting registration for email: test@example.com
[REGISTER] Hashing password...
[REGISTER] Creating user...
[REGISTER] User created successfully, ID: 4
Session created for user 4, session ID: a1b2c3d4-...
[REGISTER] Registration successful for user: test@example.com

[LOGIN] Attempting login for email: zhang.wei@example.com
[LOGIN] Verifying password for user: 2
Session created for user 2, session ID: e5f6g7h8-...
[LOGIN] Login successful for user: zhang.wei@example.com

[REFRESH] Token refresh requested
[REFRESH] Token verified for user: 2
[REFRESH] Generating new tokens for user: 2
Session updated for user 2
[REFRESH] Token refresh successful for user: zhang.wei@example.com
```

---

## ✅ 체크리스트

- [x] 회원가입 구현
- [x] 로그인 구현
- [x] 토큰 갱신 구현
- [x] 토큰 검증 구현
- [x] 로그아웃 구현
- [x] 프로필 조회/수정 구현
- [x] bcrypt 비밀번호 해싱
- [x] JWT 토큰 발급
- [x] 세션 관리
- [x] 에러 처리
- [x] 입력 검증
- [x] 로깅
- [x] 디바이스 정보 저장
- [x] 모든 디바이스 로그아웃

모든 기능이 완전히 작동합니다! 🎉
