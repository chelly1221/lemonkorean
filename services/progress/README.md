# Lemon Korean - Progress Service

학습 진도 관리 및 SRS(Spaced Repetition System) 서비스 - Go로 구현

## 기능

- **진도 관리**: 레슨별 학습 진도 추적
- **SRS 알고리즘**: SM-2 기반 복습 스케줄링
- **오프라인 동기화**: 오프라인 학습 데이터 자동 동기화
- **학습 세션**: 학습 시간 및 통계 추적
- **단어 복습**: 단어별 숙달도 관리

## 기술 스택

- **런타임**: Go 1.20
- **프레임워크**: Gin (웹 프레임워크)
- **데이터베이스**: PostgreSQL (진도 데이터)
- **캐시**: Redis (캐싱)
- **인증**: JWT 인증

## 환경 변수

```env
NODE_ENV=production
PORT=3003

# PostgreSQL
DATABASE_URL=postgres://user:password@postgres:5432/lemon_korean

# Redis
REDIS_URL=redis://:password@redis:6379

# JWT
JWT_SECRET=your_jwt_secret
```

## 설치

```bash
# 의존성 설치
go mod download

# 개발 서버 실행
go run main.go

# 프로덕션 빌드
go build -o progress-service main.go
```

## API 엔드포인트

### 진도

- `GET /api/progress/user/:userId` - 사용자 전체 진도
- `GET /api/progress/lesson/:lessonId` - 레슨별 진도
- `POST /api/progress/complete` - 레슨 완료
- `POST /api/progress/update` - 진도 업데이트
- `DELETE /api/progress/reset/:lessonId` - 진도 초기화

### 단어

- `GET /api/progress/vocabulary/:userId` - 단어 학습 진도
- `POST /api/progress/vocabulary/practice` - 단어 연습 기록
- `GET /api/progress/review-schedule/:userId` - 복습 스케줄
- `POST /api/progress/review/complete` - 복습 완료

### 세션

- `POST /api/progress/session/start` - 학습 세션 시작
- `POST /api/progress/session/end` - 학습 세션 종료
- `GET /api/progress/session/stats/:userId` - 세션 통계

### 동기화

- `POST /api/progress/sync` - 오프라인 데이터 동기화
- `POST /api/progress/sync/batch` - 배치 동기화
- `GET /api/progress/sync/status/:userId` - 동기화 상태

### 통계

- `GET /api/progress/stats/:userId` - 사용자 통계
- `GET /api/progress/stats/weekly/:userId` - 주간 통계

## Docker

### 빌드

```bash
docker build -t lemon-progress-service:latest .
```

### 실행

```bash
docker run -d \
  --name lemon-progress \
  -p 3003:3003 \
  --env-file .env \
  lemon-progress-service:latest
```

## 프로젝트 구조

```
progress/
├── main.go                  # 진입점
├── config/
│   ├── database.go         # PostgreSQL 설정
│   └── redis.go            # Redis 설정
├── models/
│   ├── progress.go         # Progress 모델
│   └── session.go          # Session 모델
├── handlers/
│   ├── progress_handler.go # Progress API 핸들러
│   └── sync_handler.go     # 동기화 핸들러
├── repository/
│   └── progress_repository.go # 데이터 접근 계층
├── middleware/
│   └── auth_middleware.go  # JWT 인증 미들웨어
└── utils/
    └── srs.go              # SRS 알고리즘 (SM-2)
```

## SRS 알고리즘

SuperMemo 2 (SM-2) 알고리즘 기반:

- **Quality 0-5**: 응답 품질 (0=모름, 5=완벽)
- **Easiness Factor**: 2.5 초기값, 1.3-3.5 범위
- **Interval**: 1일 → 6일 → EF * 이전 간격
- **Mastery Levels**: New → Learning → Reviewing → Mastered

### 품질 점수

- 0: Complete blackout (전혀 모름)
- 1: Incorrect, but familiar (틀렸지만 익숙함)
- 2: Incorrect with difficulty (어렵게 기억했지만 틀림)
- 3: Correct with difficulty (어렵게 맞춤)
- 4: Correct with hesitation (약간 망설였지만 맞춤)
- 5: Perfect recall (완벽하게 기억)

## 라이선스

MIT
