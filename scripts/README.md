# Lemon Korean - Deployment Scripts
# 柠檬韩语 - 배포 스크립트

이 디렉토리에는 Lemon Korean 플랫폼의 배포, 백업, 복구, 로그 관리를 위한 스크립트가 포함되어 있습니다.

## 📋 스크립트 목록

### 1. deploy.sh - 배포 스크립트

전체 배포 프로세스를 자동화합니다.

**기능:**
- ✅ 환경 변수 검증
- 🐳 Docker Compose 이미지 빌드
- 🗄️ 데이터베이스 마이그레이션 실행
- 🚀 모든 서비스 시작
- 💚 헬스 체크 (모든 서비스)

**사용법:**
```bash
./scripts/deploy.sh
```

**체크하는 서비스:**
- PostgreSQL (포트 5432)
- MongoDB (포트 27017)
- Redis (포트 6379)
- MinIO (포트 9000, 9001)
- Auth Service (포트 3001)
- Content Service (포트 3002)
- Progress Service (포트 3003)
- Media Service (포트 3004)
- Analytics Service (포트 3005)
- Admin Service (포트 3006)

**필수 환경 변수 (.env):**
- `DB_PASSWORD`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `JWT_SECRET`
- `MINIO_ACCESS_KEY`
- `MINIO_SECRET_KEY`

---

### 2. 백업 스크립트

**두 가지 백업 시스템이 있습니다:**

#### 2a. backup.sh - 통합 백업 (레거시)

모든 데이터베이스와 스토리지를 한 번에 백업합니다.

**사용법:**
```bash
./scripts/backup.sh
```

#### 2b. scripts/backup/ - 모듈화 백업 (권장)

개별 백업 스크립트로 세분화된 백업/복구 지원:

```
scripts/backup/
├── backup-all.sh        # 전체 백업 (PostgreSQL + MongoDB)
├── backup-postgres.sh   # PostgreSQL만 백업
├── backup-mongodb.sh    # MongoDB만 백업
├── restore-postgres.sh  # PostgreSQL 복구
├── restore-mongodb.sh   # MongoDB 복구
└── setup-cron.sh        # Cron 자동화 설정
```

**사용법:**
```bash
# 전체 백업
./scripts/backup/backup-all.sh

# 개별 백업
./scripts/backup/backup-postgres.sh
./scripts/backup/backup-mongodb.sh

# Cron 자동화 설정
./scripts/backup/setup-cron.sh
```

상세 문서: [scripts/backup/README.md](/scripts/backup/README.md)

**백업 위치:**
```
backups/
├── postgres/
│   └── lemon_korean_YYYYMMDD_HHMMSS.sql.gz
├── mongodb/
│   └── lemon_korean_YYYYMMDD_HHMMSS.tar.gz
└── minio/
    └── lemon_korean_YYYYMMDD_HHMMSS.tar.gz
```

**보존 기간:** 30일 (RETENTION_DAYS 변수로 조정 가능)

**cron 설정 (매일 새벽 2시):**
```bash
0 2 * * * /home/sanchan/lemonkorean/scripts/backup/backup-all.sh >> /var/log/lemon_korean_backup.log 2>&1
```

---

### 3. restore.sh - 복구 스크립트

백업에서 데이터를 복구합니다.

**기능:**
- ♻️ PostgreSQL 복구
- ♻️ MongoDB 복구
- ♻️ MinIO 복구
- ⚠️ 복구 전 확인 프롬프트

**사용법:**

1. 사용 가능한 백업 확인:
```bash
./scripts/restore.sh
```

2. 특정 타임스탬프로 복구:
```bash
./scripts/restore.sh 20240115_143022
```

**주의사항:**
- ⚠️ **모든 현재 데이터가 백업 데이터로 교체됩니다!**
- 복구 전 확인 프롬프트에서 `yes`를 입력해야 합니다
- 복구 후 서비스 재시작 권장: `docker-compose restart`

---

### 4. logs.sh - 로그 확인 스크립트

서비스 로그를 쉽게 확인할 수 있습니다.

**기능:**
- 📊 모든 서비스 로그 확인
- 🔍 특정 서비스 로그 필터링
- 📡 실시간 로그 팔로우
- ⏱️ 시간별 필터링

**사용법:**

모든 서비스 로그 (마지막 100줄):
```bash
./scripts/logs.sh
```

실시간 로그 팔로우:
```bash
./scripts/logs.sh -f
```

특정 서비스 로그:
```bash
./scripts/logs.sh auth
./scripts/logs.sh postgres
./scripts/logs.sh minio
```

실시간 + 특정 서비스:
```bash
./scripts/logs.sh -f auth
```

마지막 500줄:
```bash
./scripts/logs.sh -n 500
```

특정 시간 이후:
```bash
./scripts/logs.sh --since 1h        # 지난 1시간
./scripts/logs.sh --since 30m       # 지난 30분
./scripts/logs.sh --since 2024-01-15  # 특정 날짜 이후
```

**사용 가능한 서비스:**
- `all` - 모든 서비스 (기본값)
- `postgres` - PostgreSQL
- `mongo` - MongoDB
- `redis` - Redis
- `minio` - MinIO
- `nginx` - Nginx
- `auth` - Auth Service
- `content` - Content Service
- `progress` - Progress Service
- `media` - Media Service
- `analytics` - Analytics Service
- `admin` - Admin Service
- `rabbitmq` - RabbitMQ

**옵션:**
- `-f, --follow` - 실시간 로그 팔로우 (Ctrl+C로 종료)
- `-n, --lines NUM` - 표시할 줄 수 (기본값: 100)
- `-s, --since TIME` - 특정 시간 이후 로그
- `-h, --help` - 도움말

---

## 🔄 일반적인 워크플로우

### 초기 배포
```bash
# 1. 환경 변수 설정
cp .env.example .env
vim .env  # 필요한 값 수정

# 2. 배포 실행
./scripts/deploy.sh

# 3. 로그 확인
./scripts/logs.sh -f
```

### 정기 백업 설정
```bash
# crontab 편집
crontab -e

# 매일 새벽 2시 백업
0 2 * * * cd /home/sanchan/lemonkorean && ./scripts/backup.sh >> /var/log/lemon_korean_backup.log 2>&1
```

### 문제 발생 시 복구
```bash
# 1. 사용 가능한 백업 확인
./scripts/restore.sh

# 2. 선택한 백업으로 복구
./scripts/restore.sh 20240115_020000

# 3. 서비스 재시작
docker-compose restart

# 4. 헬스 체크
./scripts/deploy.sh  # 헬스 체크만 실행됨 (이미 실행 중인 경우)
```

### 디버깅
```bash
# 특정 서비스 로그 실시간 확인
./scripts/logs.sh -f auth

# 에러 로그 필터링 (grep 사용)
./scripts/logs.sh auth | grep ERROR

# 최근 1시간 로그
./scripts/logs.sh --since 1h content
```

---

## 📝 추가 명령어

### Docker Compose 관련
```bash
# 서비스 상태 확인
docker-compose ps

# 특정 서비스 재시작
docker-compose restart auth

# 모든 서비스 중지
docker-compose down

# 볼륨 포함 완전 삭제
docker-compose down -v

# 특정 서비스만 시작
docker-compose up -d postgres mongo redis
```

### 직접 데이터베이스 접근
```bash
# PostgreSQL
docker-compose exec postgres psql -U 3chan -d lemon_korean

# MongoDB
docker-compose exec mongo mongosh

# Redis
docker-compose exec redis redis-cli
```

### MinIO 관리
```bash
# MinIO 콘솔 접속
# http://localhost:9001
# 사용자명: MINIO_ACCESS_KEY
# 비밀번호: MINIO_SECRET_KEY
```

---

## ⚠️ 주의사항

1. **환경 변수**
   - `.env` 파일은 절대 Git에 커밋하지 마세요
   - 프로덕션 환경에서는 강력한 비밀번호 사용

2. **백업**
   - 백업은 로컬 디스크에 저장됩니다
   - 중요한 데이터는 원격 스토리지에도 백업하세요
   - 정기적으로 복구 테스트 수행

3. **복구**
   - 복구는 **모든 현재 데이터를 삭제**합니다
   - 프로덕션 환경에서는 반드시 현재 데이터 백업 후 복구 실행

4. **로그**
   - 로그 파일이 너무 커지지 않도록 Docker 로그 로테이션 설정
   - `/etc/docker/daemon.json`:
   ```json
   {
     "log-driver": "json-file",
     "log-opts": {
       "max-size": "10m",
       "max-file": "3"
     }
   }
   ```

---

## 🔧 트러블슈팅

### deploy.sh 실패
```bash
# 환경 변수 확인
cat .env

# Docker 상태 확인
docker-compose ps

# 포트 충돌 확인
sudo lsof -i :5432  # PostgreSQL
sudo lsof -i :3001  # Auth Service

# 로그 확인
./scripts/logs.sh
```

### backup.sh 실패
```bash
# 컨테이너 실행 확인
docker-compose ps

# 디스크 공간 확인
df -h

# 백업 디렉토리 권한 확인
ls -la backups/
```

### restore.sh 실패
```bash
# 백업 파일 확인
ls -lh backups/postgres/
ls -lh backups/mongo/

# 서비스 재시작 후 재시도
docker-compose restart postgres mongo
./scripts/restore.sh <timestamp>
```

---

## 📚 관련 문서

- [프로젝트 가이드](/CLAUDE.md)
- [Docker Compose 설정](/docker-compose.yml)
- [환경 변수 예제](/.env.example)
- [데이터베이스 스키마](/init/postgres/)

---

**Created:** 2024-01-25
**Last Updated:** 2024-01-25
