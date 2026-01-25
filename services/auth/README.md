# Lemon Korean - Auth Service

Lemon Korean 플랫폼의 인증 및 권한 부여 서비스입니다.

## 기능

- 이메일/비밀번호 기반 회원가입
- JWT 토큰 생성을 통한 로그인
- 토큰 갱신 메커니즘
- 사용자 프로필 관리
- 세션 관리
- bcrypt 기반 비밀번호 해싱
- 입력 검증 및 새니타이제이션

## 기술 스택

- **런타임**: Node.js 18+
- **프레임워크**: Express.js
- **데이터베이스**: PostgreSQL
- **인증**: JWT (jsonwebtoken)
- **비밀번호 해싱**: bcrypt
- **검증**: 커스텀 검증기

## 환경 변수

루트 디렉토리에 `.env` 파일을 생성하세요:

```env
NODE_ENV=development
PORT=3001
DATABASE_URL=postgres://user:password@localhost:5432/lemon_korean
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=7d
REDIS_URL=redis://:password@localhost:6379
```

## 설치

```bash
# 의존성 설치
npm install

# 자동 리로드 개발 모드
npm run dev

# 프로덕션 모드
npm start
```

## API 엔드포인트

### 공개 엔드포인트

#### 사용자 등록
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "张伟",
  "language_preference": "zh"
}
```

**응답:**
```json
{
  "message": "User registered successfully",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "张伟",
    "subscription_type": "free"
  },
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

#### 로그인
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### 토큰 갱신
```http
POST /api/auth/refresh
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 보호된 엔드포인트

#### 프로필 조회
```http
GET /api/auth/profile
Authorization: Bearer <accessToken>
```

#### 프로필 수정
```http
PUT /api/auth/profile
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "name": "新名字",
  "language_preference": "ko"
}
```

#### 로그아웃
```http
POST /api/auth/logout
Authorization: Bearer <accessToken>
Content-Type: application/json

{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## 프로젝트 구조

```
auth/
├── src/
│   ├── config/
│   │   ├── database.js      # PostgreSQL 연결
│   │   └── jwt.js           # JWT 설정
│   ├── controllers/
│   │   └── auth.controller.js    # 비즈니스 로직
│   ├── middleware/
│   │   └── auth.middleware.js    # 인증 미들웨어
│   ├── models/
│   │   └── user.model.js         # User 모델
│   ├── routes/
│   │   └── auth.routes.js        # 라우트 정의
│   ├── utils/
│   │   └── validator.js          # 입력 검증
│   └── index.js             # 진입점
├── Dockerfile
├── package.json
└── README.md
```

## Docker

### 이미지 빌드
```bash
docker build -t lemon-auth-service .
```

### 컨테이너 실행
```bash
docker run -p 3001:3001 \
  -e DATABASE_URL=postgres://user:pass@host:5432/db \
  -e JWT_SECRET=secret \
  lemon-auth-service
```

### Docker Compose 사용
```bash
docker-compose up auth-service
```

## 에러 코드

| 코드 | 설명 |
|------|------|
| `TOKEN_EXPIRED` | JWT access token이 만료됨 |
| `INVALID_TOKEN` | JWT 토큰이 유효하지 않거나 형식이 잘못됨 |
| `REFRESH_TOKEN_EXPIRED` | Refresh token이 만료됨 |
| `PREMIUM_REQUIRED` | 프리미엄 구독이 필요한 기능 |

## 보안

- 비밀번호는 bcrypt로 해싱 (10 salt rounds)
- JWT 토큰은 HS256 알고리즘으로 서명
- 세션은 데이터베이스에 저장
- 이메일 검증 및 새니타이제이션
- 파라미터화된 쿼리를 통한 SQL 인젝션 방지

## 헬스체크

```http
GET /health
```

서비스 상태 및 가동 시간을 반환합니다.

## 개발

```bash
# 의존성 설치
npm install

# 개발 모드 실행
npm run dev

# 파일 변경 시 서버가 자동으로 리로드됩니다
```

## 테스트

```bash
# 테스트 실행 (아직 구현되지 않음)
npm test
```

## 라이선스

MIT
