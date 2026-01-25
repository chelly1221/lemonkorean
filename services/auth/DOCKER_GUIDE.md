# Docker 사용 가이드 - Auth Service

Node.js 20 Alpine 기반의 최적화된 Docker 이미지 빌드 및 실행 가이드입니다.

---

## 📋 목차

1. [Dockerfile 특징](#dockerfile-특징)
2. [빌드 방법](#빌드-방법)
3. [실행 방법](#실행-방법)
4. [헬스체크](#헬스체크)
5. [환경 변수](#환경-변수)
6. [최적화 팁](#최적화-팁)
7. [트러블슈팅](#트러블슈팅)

---

## 🐳 Dockerfile 특징

### ✅ Node.js 20 Alpine
- **경량화**: Alpine Linux 기반 (5MB)
- **최신 버전**: Node.js 20 LTS
- **보안**: 정기적인 보안 패치

### ✅ 멀티스테이지 빌드
- **Build Stage**: 의존성 설치
- **Production Stage**: 최종 런타임 이미지
- **결과**: 이미지 크기 최소화

### ✅ 보안 강화
- **Non-root user**: nodejs 유저로 실행 (UID: 1001)
- **최소 권한**: 필요한 파일만 접근
- **레이어 최적화**: 캐싱 활용

### ✅ 신뢰성
- **dumb-init**: PID 1 프로세스 시그널 처리
- **헬스체크**: 자동 상태 모니터링
- **그레이스풀 셧다운**: SIGTERM 처리

---

## 🔨 빌드 방법

### 기본 빌드

```bash
# Auth 서비스 디렉토리로 이동
cd services/auth

# 이미지 빌드
docker build -t lemon-auth-service:latest .

# 빌드 확인
docker images | grep lemon-auth-service
```

**예상 출력:**
```
REPOSITORY            TAG       IMAGE ID       CREATED          SIZE
lemon-auth-service   latest    abc123def456   10 seconds ago   150MB
```

### 버전 태그 빌드

```bash
# 특정 버전으로 태그
docker build -t lemon-auth-service:1.0.0 .

# 여러 태그 동시 지정
docker build \
  -t lemon-auth-service:1.0.0 \
  -t lemon-auth-service:latest \
  .
```

### 빌드 인수 사용

```bash
# NODE_ENV 지정
docker build \
  --build-arg NODE_ENV=production \
  -t lemon-auth-service:latest \
  .

# 프록시 사용
docker build \
  --build-arg HTTP_PROXY=http://proxy:8080 \
  --build-arg HTTPS_PROXY=http://proxy:8080 \
  -t lemon-auth-service:latest \
  .
```

### 캐시 없이 빌드

```bash
# 전체 재빌드 (clean build)
docker build --no-cache -t lemon-auth-service:latest .
```

### BuildKit 사용 (권장)

```bash
# BuildKit 활성화 (더 빠른 빌드)
DOCKER_BUILDKIT=1 docker build -t lemon-auth-service:latest .

# 빌드 로그 상세히 보기
DOCKER_BUILDKIT=1 docker build --progress=plain -t lemon-auth-service:latest .
```

---

## 🚀 실행 방법

### 기본 실행

```bash
# 컨테이너 실행
docker run -d \
  --name lemon-auth \
  -p 3001:3001 \
  lemon-auth-service:latest

# 로그 확인
docker logs lemon-auth

# 실시간 로그
docker logs -f lemon-auth
```

### 환경 변수와 함께 실행

```bash
docker run -d \
  --name lemon-auth \
  -p 3001:3001 \
  -e NODE_ENV=production \
  -e PORT=3001 \
  -e DATABASE_URL=postgres://user:pass@postgres:5432/lemon_korean \
  -e JWT_SECRET=your-secret-key \
  -e REDIS_URL=redis://:password@redis:6379 \
  lemon-auth-service:latest
```

### .env 파일 사용

```bash
# .env 파일 생성
cat > .env <<EOF
NODE_ENV=production
PORT=3001
DATABASE_URL=postgres://3chan:Scott122001&&@postgres:5432/lemon_korean
JWT_SECRET=change_this_jwt_secret_key
JWT_EXPIRES_IN=7d
REDIS_URL=redis://:change_this_redis_password@redis:6379
EOF

# .env 파일로 실행
docker run -d \
  --name lemon-auth \
  -p 3001:3001 \
  --env-file .env \
  lemon-auth-service:latest
```

### 네트워크 연결

```bash
# 네트워크 생성
docker network create lemon-network

# 네트워크에 연결하여 실행
docker run -d \
  --name lemon-auth \
  --network lemon-network \
  -p 3001:3001 \
  --env-file .env \
  lemon-auth-service:latest
```

### 볼륨 마운트 (개발 모드)

```bash
# 소스 코드 마운트 (hot reload)
docker run -d \
  --name lemon-auth-dev \
  -p 3001:3001 \
  -v $(pwd)/src:/app/src \
  -e NODE_ENV=development \
  --env-file .env \
  lemon-auth-service:latest
```

### 리소스 제한

```bash
# CPU 및 메모리 제한
docker run -d \
  --name lemon-auth \
  -p 3001:3001 \
  --cpus="0.5" \
  --memory="512m" \
  --memory-swap="512m" \
  --env-file .env \
  lemon-auth-service:latest
```

---

## 🏥 헬스체크

### 헬스체크 설정

Dockerfile에 이미 포함되어 있습니다:

```dockerfile
HEALTHCHECK --interval=30s \
            --timeout=10s \
            --start-period=40s \
            --retries=3 \
    CMD curl -f http://localhost:3001/health || exit 1
```

**파라미터 설명:**
- `--interval=30s`: 30초마다 체크
- `--timeout=10s`: 10초 이내 응답 없으면 실패
- `--start-period=40s`: 시작 후 40초는 유예 기간
- `--retries=3`: 3번 연속 실패 시 unhealthy

### 헬스체크 상태 확인

```bash
# 컨테이너 상태 확인
docker ps

# 상세 헬스체크 정보
docker inspect --format='{{json .State.Health}}' lemon-auth | jq

# 헬스체크 로그
docker inspect lemon-auth | jq '.[0].State.Health'
```

**예상 출력:**
```json
{
  "Status": "healthy",
  "FailingStreak": 0,
  "Log": [
    {
      "Start": "2026-01-25T10:30:00Z",
      "End": "2026-01-25T10:30:00Z",
      "ExitCode": 0,
      "Output": ""
    }
  ]
}
```

### 수동 헬스체크

```bash
# 컨테이너 내부에서 헬스체크
docker exec lemon-auth curl -f http://localhost:3001/health

# 호스트에서 헬스체크
curl -f http://localhost:3001/health

# 상세 정보
curl http://localhost:3001/health | jq
```

**정상 응답:**
```json
{
  "status": "healthy",
  "service": "auth-service",
  "timestamp": "2026-01-25T10:30:00.000Z",
  "uptime": 123.45
}
```

---

## 🔧 환경 변수

### 필수 환경 변수

| 변수 | 설명 | 예제 |
|------|------|------|
| `DATABASE_URL` | PostgreSQL 연결 URL | `postgres://user:pass@host:5432/db` |
| `JWT_SECRET` | JWT 서명 키 | `your-secret-key-change-in-production` |

### 선택 환경 변수

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `NODE_ENV` | `production` | 환경 (development/production) |
| `PORT` | `3001` | 서버 포트 |
| `JWT_EXPIRES_IN` | `7d` | Access token 유효 기간 |
| `REDIS_URL` | - | Redis 연결 URL |
| `ADMIN_EMAILS` | `admin@lemon.com` | 관리자 이메일 목록 (콤마 구분) |

### 환경 변수 파일 예제

```bash
# .env.example
NODE_ENV=production
PORT=3001

# Database
DATABASE_URL=postgres://3chan:Scott122001&&@postgres:5432/lemon_korean

# JWT
JWT_SECRET=change_this_jwt_secret_key
JWT_EXPIRES_IN=7d

# Redis (Optional)
REDIS_URL=redis://:password@redis:6379

# Admin
ADMIN_EMAILS=admin@lemon.com,superadmin@lemon.com
```

---

## ⚡ 최적화 팁

### 1. 이미지 크기 최적화

```bash
# 이미지 크기 확인
docker images lemon-auth-service

# 레이어별 크기 분석
docker history lemon-auth-service:latest

# 사용하지 않는 이미지 정리
docker image prune -a
```

**최적화 결과:**
- 멀티스테이지 빌드: ~150MB
- Alpine Linux: ~100MB 절약
- npm cache clean: ~20MB 절약

### 2. 빌드 캐시 활용

```bash
# package.json 변경 없으면 캐시 사용
# → 빌드 시간 단축 (60초 → 5초)

# 캐시 상태 확인
docker builder prune --dry-run
```

### 3. 레이어 최적화

```dockerfile
# ❌ 나쁜 예 - 레이어 많음
RUN apk add dumb-init
RUN apk add curl
RUN apk add tzdata

# ✅ 좋은 예 - 레이어 최소화
RUN apk add --no-cache dumb-init curl tzdata
```

### 4. .dockerignore 활용

```bash
# 불필요한 파일 제외
# → 빌드 컨텍스트 크기 감소
# → 빌드 속도 향상

# 빌드 컨텍스트 크기 확인
du -sh .
```

---

## 🛠️ 트러블슈팅

### 문제 1: bcrypt 빌드 실패

**증상:**
```
Error: Cannot find module 'bcrypt'
```

**해결:**
```bash
# Dockerfile에 빌드 도구 추가 (이미 포함됨)
RUN apk add --no-cache python3 make g++
```

### 문제 2: 헬스체크 실패

**증상:**
```
Status: unhealthy
```

**해결:**
```bash
# 1. 컨테이너 로그 확인
docker logs lemon-auth

# 2. 헬스체크 엔드포인트 확인
docker exec lemon-auth curl http://localhost:3001/health

# 3. 포트 바인딩 확인
docker port lemon-auth

# 4. 데이터베이스 연결 확인
docker exec lemon-auth env | grep DATABASE_URL
```

### 문제 3: 데이터베이스 연결 실패

**증상:**
```
Error: connect ECONNREFUSED
```

**해결:**
```bash
# 1. 네트워크 확인
docker network inspect lemon-network

# 2. PostgreSQL 컨테이너 실행 확인
docker ps | grep postgres

# 3. DATABASE_URL 확인
docker exec lemon-auth printenv DATABASE_URL

# 4. 호스트명 사용 (localhost → postgres)
DATABASE_URL=postgres://user:pass@postgres:5432/db
```

### 문제 4: 권한 에러

**증상:**
```
Error: EACCES: permission denied
```

**해결:**
```bash
# 1. 파일 소유권 확인
docker exec lemon-auth ls -la /app

# 2. Dockerfile에서 chown 확인 (이미 포함됨)
COPY --chown=nodejs:nodejs . .

# 3. USER 지시문 확인
USER nodejs
```

### 문제 5: 환경 변수 로드 안 됨

**증상:**
```
JWT_SECRET is undefined
```

**해결:**
```bash
# 1. 환경 변수 확인
docker exec lemon-auth printenv

# 2. .env 파일 경로 확인
docker run --env-file /full/path/to/.env ...

# 3. 직접 환경 변수 지정
docker run -e JWT_SECRET=mysecret ...
```

---

## 📊 유용한 명령어

### 컨테이너 관리

```bash
# 시작
docker start lemon-auth

# 중지
docker stop lemon-auth

# 재시작
docker restart lemon-auth

# 삭제
docker rm -f lemon-auth

# 로그 확인 (최근 100줄)
docker logs --tail 100 lemon-auth

# 실시간 로그
docker logs -f lemon-auth

# 컨테이너 접속
docker exec -it lemon-auth sh

# 리소스 사용량
docker stats lemon-auth
```

### 이미지 관리

```bash
# 이미지 목록
docker images

# 이미지 삭제
docker rmi lemon-auth-service:latest

# 사용하지 않는 이미지 정리
docker image prune

# 모든 것 정리
docker system prune -a --volumes
```

### 디버깅

```bash
# 컨테이너 정보
docker inspect lemon-auth

# 프로세스 확인
docker top lemon-auth

# 포트 매핑 확인
docker port lemon-auth

# 파일 시스템 확인
docker exec lemon-auth ls -la /app

# 네트워크 확인
docker exec lemon-auth ping postgres
```

---

## 🎯 빠른 시작

```bash
# 1. 프로젝트 루트에서
cd services/auth

# 2. 이미지 빌드
docker build -t lemon-auth-service:latest .

# 3. .env 파일 생성
cp .env.example .env
# .env 파일 수정

# 4. 실행
docker run -d \
  --name lemon-auth \
  -p 3001:3001 \
  --env-file .env \
  lemon-auth-service:latest

# 5. 상태 확인
docker logs lemon-auth
curl http://localhost:3001/health

# 6. API 테스트
curl http://localhost:3001/
```

---

## 📈 이미지 정보

**최종 이미지 특징:**
- **베이스 이미지**: node:20-alpine (~40MB)
- **의존성**: bcrypt, express, jsonwebtoken 등 (~80MB)
- **애플리케이션 코드**: ~5MB
- **총 이미지 크기**: ~150MB

**비교:**
- node:20 (Ubuntu 기반): ~900MB
- node:20-alpine (Alpine 기반): ~150MB
- **절약**: ~750MB (83% 감소)

---

## ✅ 체크리스트

- [x] Node.js 20 Alpine 사용
- [x] 멀티스테이지 빌드
- [x] 포트 3001 노출
- [x] 헬스체크 포함
- [x] Non-root 사용자
- [x] dumb-init 사용
- [x] 환경 변수 지원
- [x] .dockerignore 최적화
- [x] 레이어 캐싱 최적화
- [x] 메타데이터 라벨

완벽하게 최적화된 Docker 이미지입니다! 🎉
