# 백업 및 복구 가이드

Lemon Korean 데이터베이스 백업 및 복구 전략.

## 개요

자동화된 백업 시스템:
- PostgreSQL (사용자, 레슨, 진도 데이터)
- MongoDB (레슨 콘텐츠, 이벤트 로그)

## 백업 전략

### 보존 정책

| 백업 유형 | 빈도 | 보존 기간 |
|----------|------|----------|
| Daily | 매일 | 7일 |
| Weekly | 매주 일요일 | 30일 |
| Monthly | 매월 1일 | 90일 |

### 자동 백업 설정

```bash
# 실행 권한 부여
chmod +x scripts/backup/*.sh

# Cron 작업 설정 (매일 오전 2시 자동 백업)
cd /path/to/lemonkorean
bash scripts/backup/setup-cron.sh
```

### 수동 백업

```bash
# 모든 데이터베이스 백업
bash scripts/backup/backup-all.sh

# PostgreSQL만 백업
bash scripts/backup/backup-postgres.sh

# MongoDB만 백업
bash scripts/backup/backup-mongodb.sh
```

## 백업 위치

```
backups/
├── postgres/
│   ├── daily/
│   │   └── backup_20260128_120000.sql.gz
│   ├── weekly/
│   │   └── backup_20260121_120000.sql.gz
│   └── monthly/
│       └── backup_20260101_120000.sql.gz
├── mongodb/
│   ├── daily/
│   │   └── backup_20260128_120000.archive
│   ├── weekly/
│   │   └── backup_20260121_120000.archive
│   └── monthly/
│       └── backup_20260101_120000.archive
└── backup.log
```

## 복구

### PostgreSQL 복구

```bash
# 백업 파일 목록 확인
ls -lh backups/postgres/daily/

# 데이터베이스 복구 (주의: 기존 데이터 삭제됨!)
bash scripts/backup/restore-postgres.sh backups/postgres/daily/backup_20260128_120000.sql.gz
```

**경고**: 복구는 기존 데이터베이스를 완전히 대체합니다!

### MongoDB 복구

```bash
# 백업 파일 목록 확인
ls -lh backups/mongodb/daily/

# 데이터베이스 복구
bash scripts/backup/restore-mongodb.sh backups/mongodb/daily/backup_20260128_120000.archive
```

## 백업 검증

### 백업 무결성 확인

```bash
# PostgreSQL 백업 검증 (gzip 압축 테스트)
gzip -t backups/postgres/daily/backup_20260128_120000.sql.gz

# MongoDB 백업 검증 (파일 존재 및 크기 확인)
ls -lh backups/mongodb/daily/backup_20260128_120000.archive
```

### 테스트 복구

프로덕션 환경이 아닌 별도 환경에서 정기적으로 복구 테스트 수행 권장.

```bash
# 1. 테스트 컨테이너 시작
docker run -d --name test-postgres -e POSTGRES_PASSWORD=test postgres:15-alpine

# 2. 백업 복구
docker cp backups/postgres/daily/backup_20260128_120000.sql.gz test-postgres:/tmp/
docker exec test-postgres sh -c "gunzip -c /tmp/backup_20260128_120000.sql.gz | psql -U postgres"

# 3. 데이터 확인
docker exec test-postgres psql -U postgres -c "\dt"

# 4. 정리
docker rm -f test-postgres
```

## 프로덕션 권장사항

### 1. 오프사이트 백업

로컬 백업만으로는 불충분. 원격 스토리지로 백업 복사 필요:

```bash
# AWS S3로 백업 복사 (예시)
aws s3 sync backups/ s3://your-bucket/lemon-korean-backups/ \
  --storage-class STANDARD_IA \
  --exclude "*" \
  --include "*/daily/*" \
  --include "*/weekly/*" \
  --include "*/monthly/*"
```

```bash
# rsync로 원격 서버 백업 (예시)
rsync -avz --delete \
  backups/ \
  backup-server:/backups/lemon-korean/
```

### 2. 백업 모니터링

```bash
# 최근 백업 확인
find backups/ -name "backup_*.sql.gz" -o -name "backup_*.archive" -type f -mtime -1

# 백업 실패 알림 (cron에서 실행)
if ! bash scripts/backup/backup-all.sh; then
    echo "Backup failed!" | mail -s "Backup Alert" admin@example.com
fi
```

### 3. 디스크 공간 모니터링

```bash
# 백업 디렉토리 크기 확인
du -sh backups/

# 디스크 여유 공간 확인
df -h .
```

## 재해 복구 절차

완전한 시스템 재구축 시:

### 1. 인프라 재구축

```bash
# Docker 컨테이너 시작
docker-compose up -d postgres mongo
```

### 2. 데이터 복구

```bash
# 가장 최근 백업 찾기
latest_postgres=$(ls -t backups/postgres/*/backup_*.sql.gz | head -1)
latest_mongo=$(ls -t backups/mongodb/*/backup_*.archive | head -1)

# 복구 실행
bash scripts/backup/restore-postgres.sh "$latest_postgres"
bash scripts/backup/restore-mongodb.sh "$latest_mongo"
```

### 3. 서비스 시작

```bash
# 모든 서비스 시작
docker-compose up -d

# 헬스체크
curl http://localhost/health
```

## 보안

### 백업 파일 보호

```bash
# 백업 디렉토리 권한 제한
chmod 700 backups/
chmod 600 backups/**/*.sql.gz
chmod 600 backups/**/*.archive

# 암호화 (옵션)
# GPG로 백업 암호화
gpg --symmetric --cipher-algo AES256 backups/postgres/daily/backup_20260128_120000.sql.gz

# 복호화
gpg backups/postgres/daily/backup_20260128_120000.sql.gz.gpg
```

## 문제 해결

### 백업 실패

```bash
# Docker 컨테이너 상태 확인
docker ps -a

# 로그 확인
docker logs lemon-postgres
docker logs lemon-mongo

# 디스크 공간 확인
df -h
```

### 복구 실패

```bash
# 백업 파일 무결성 확인
gzip -t backups/postgres/daily/backup_20260128_120000.sql.gz

# 수동 복구 시도
gunzip -c backups/postgres/daily/backup_20260128_120000.sql.gz | \
  docker exec -i lemon-postgres psql -U 3chan -d lemon_korean
```

## 환경 변수

백업 스크립트를 환경 변수로 커스터마이징할 수 있습니다:

| 변수 | 기본값 | 설명 |
|------|--------|------|
| `POSTGRES_CONTAINER` | `lemon-postgres` | PostgreSQL 컨테이너 이름 |
| `MONGO_CONTAINER` | `lemon-mongo` | MongoDB 컨테이너 이름 |
| `BACKUP_DIR` | `./backups/postgres` 또는 `./backups/mongodb` | 백업 저장 디렉토리 |
| `DB_NAME` | `lemon_korean` | 백업할 데이터베이스 이름 |
| `DB_USER` | `3chan` | PostgreSQL 사용자 이름 |

**예시:**
```bash
# 커스텀 컨테이너 이름 사용
POSTGRES_CONTAINER=my-postgres bash scripts/backup/backup-postgres.sh

# 커스텀 백업 디렉토리 지정
BACKUP_DIR=/mnt/external/backups bash scripts/backup/backup-all.sh
```

## 자동화 스크립트

모든 백업 스크립트는 다음 기능 포함:
- ✅ 에러 처리 (set -e)
- ✅ 로깅 (타임스탬프 포함)
- ✅ 무결성 검증
- ✅ 자동 정리 (보존 정책)
- ✅ 컨테이너 상태 확인

## 연락처

백업/복구 관련 문의:
- 기술 문서: `/docs/backup-strategy.md`
- 이슈 보고: GitHub Issues

## DM 데이터 백업 참고사항 (2026-02-10)

### DM 메시지
- DM 메시지 (`dm_conversations`, `dm_messages`, `dm_read_receipts`)는 PostgreSQL에 저장되므로 **기존 PostgreSQL 백업에 자동 포함**
- 추가 설정 불필요

### DM 미디어 파일
- DM 이미지: MinIO `dm-images/` 경로에 저장
- DM 음성메시지: MinIO `dm-voice/` 경로에 저장
- MinIO 백업이 설정되어 있다면 자동 포함

### Redis 온라인 상태
- `dm:online:{userId}` 키는 TTL 300초로 자동 만료
- 세션 상태이므로 **백업 불필요** (재접속 시 자동 복구)

---

## 변경 이력

- 2026-02-10: DM 데이터 백업 참고사항 추가
- 2026-01-28: 초기 백업 시스템 구현
  - PostgreSQL 자동 백업
  - MongoDB 자동 백업
  - 복구 스크립트
  - Cron 자동화
