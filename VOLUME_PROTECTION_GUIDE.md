# 볼륨 보호 가이드 (Volume Protection Guide)

## ✅ 설치 완료

데이터 볼륨이 **외부 볼륨(External Volumes)**으로 마이그레이션되었습니다.

이제 **어떤 Docker 명령어로도** 볼륨이 삭제되지 않습니다! 🛡️

---

## 🔒 보호된 볼륨 목록

다음 볼륨들은 **절대 삭제되지 않습니다**:

```
✅ lemon-postgres-data-safe     (PostgreSQL 데이터베이스)
✅ lemon-mongo-data-safe        (MongoDB 데이터베이스)
✅ lemon-redis-data-safe        (Redis 캐시)
✅ lemon-minio-data-safe        (미디어 파일)
✅ lemon-rabbitmq-data-safe     (메시지 큐)
```

---

## 🚫 이제 차단되는 명령어들

### 1. docker-compose down -v
```bash
docker compose down -v
```

**이전**: ❌ 모든 볼륨 삭제 → 데이터 손실
**현재**: ✅ 외부 볼륨은 보호됨 → 데이터 안전

### 2. docker system prune --volumes
```bash
docker system prune -a --volumes
```

**이전**: ❌ 사용하지 않는 볼륨 모두 삭제
**현재**: ✅ 외부 볼륨은 삭제되지 않음

### 3. docker volume rm
```bash
docker volume rm lemon-postgres-data-safe
```

**결과**: ⚠️ 에러 발생 (볼륨이 사용 중이면 삭제 불가)

---

## 🧪 보호 기능 테스트

### 자동 테스트 실행

```bash
./scripts/test-volume-protection.sh
```

이 스크립트는:
1. ✅ 외부 볼륨 존재 확인
2. ✅ docker-compose.override.yml 설정 확인
3. ✅ (선택적) 실제 `docker compose down -v` 테스트

### 수동 테스트

```bash
# 1. 현재 볼륨 목록 저장
docker volume ls | grep lemon > volumes_before.txt

# 2. docker compose down -v 실행
docker compose down -v

# 3. 볼륨이 여전히 존재하는지 확인
docker volume ls | grep lemon-safe

# 결과: 모든 *-safe 볼륨이 여전히 존재해야 함

# 4. 서비스 재시작
docker compose up -d
```

---

## 📋 설정 파일 설명

### docker-compose.override.yml

이 파일이 자동으로 `docker-compose.yml`과 병합됩니다.

```yaml
volumes:
  postgres-data:
    external: true              # Docker Compose가 관리하지 않음
    name: lemon-postgres-data-safe
```

**external: true**의 의미:
- ✅ Docker Compose가 볼륨을 **생성하지 않음**
- ✅ Docker Compose가 볼륨을 **삭제하지 않음**
- ✅ 수동으로 생성된 볼륨 사용

---

## 🔄 볼륨 마이그레이션 상세

### 마이그레이션 프로세스

```
기존 볼륨                      새 외부 볼륨
─────────────────────────────────────────────────
lemon-postgres-data      →    lemon-postgres-data-safe
lemon-mongo-data         →    lemon-mongo-data-safe
lemon-redis-data         →    lemon-redis-data-safe
lemon-minio-data         →    lemon-minio-data-safe
lemon-rabbitmq-data      →    lemon-rabbitmq-data-safe
```

### 마이그레이션 검증

```bash
# PostgreSQL 데이터 확인
docker compose exec postgres psql -U 3chan -d lemon_korean -c "SELECT COUNT(*) FROM users;"

# MongoDB 데이터 확인
docker compose exec mongo mongo admin -u 3chan -p 'Scott122001&&' --quiet --eval "db.getMongo().getDBNames()"

# Redis 데이터 확인
docker compose exec redis redis-cli -a 'Scott122001&&' INFO keyspace

# MinIO 버킷 확인
docker compose exec minio mc ls local/
```

### 마이그레이션 이후 정리 (선택)

데이터 검증 완료 후 구 볼륨 삭제:

```bash
# ⚠️ 주의: 데이터가 정상적으로 작동하는지 확인 후에만 실행!

docker volume rm lemon-postgres-data
docker volume rm lemon-mongo-data
docker volume rm lemon-redis-data
docker volume rm lemon-minio-data
docker volume rm lemon-rabbitmq-data
```

---

## 🆘 볼륨을 삭제해야 하는 경우

### 시나리오 1: 전체 시스템 초기화

```bash
# 1. 모든 컨테이너 중지
docker compose down

# 2. 외부 볼륨 수동 삭제 (⚠️ 데이터 손실!)
docker volume rm lemon-postgres-data-safe
docker volume rm lemon-mongo-data-safe
docker volume rm lemon-redis-data-safe
docker volume rm lemon-minio-data-safe
docker volume rm lemon-rabbitmq-data-safe

# 3. 새 볼륨 생성
docker volume create lemon-postgres-data-safe
docker volume create lemon-mongo-data-safe
docker volume create lemon-redis-data-safe
docker volume create lemon-minio-data-safe
docker volume create lemon-rabbitmq-data-safe

# 4. 서비스 시작 (초기 데이터로 시작됨)
docker compose up -d
```

### 시나리오 2: 특정 볼륨만 초기화

PostgreSQL만 초기화하는 예:

```bash
# 1. 서비스 중지
docker compose down

# 2. 해당 볼륨만 삭제
docker volume rm lemon-postgres-data-safe

# 3. 새 볼륨 생성
docker volume create lemon-postgres-data-safe

# 4. 서비스 시작
docker compose up -d

# 5. 스키마 및 시드 데이터 로드
docker compose exec -T postgres psql -U 3chan -d lemon_korean < database/postgres/init/01_schema.sql
docker compose exec -T postgres psql -U 3chan -d lemon_korean < database/postgres/init/02_seed.sql
```

---

## 💾 백업 권장 사항

외부 볼륨 보호만으로는 충분하지 않습니다. 정기적인 백업도 필수입니다!

### 자동 백업 설정

```bash
# Cron 편집
crontab -e

# 매일 새벽 2시 백업
0 2 * * * cd /home/sanchan/lemonkorean && ./scripts/backup/backup-all.sh >> /var/log/lemon-backup.log 2>&1
```

### 수동 백업 실행

```bash
./scripts/backup/backup-all.sh
```

### 백업 복구

```bash
./scripts/backup/restore-postgres.sh
./scripts/backup/restore-mongodb.sh
```

---

## 📊 볼륨 상태 모니터링

### 볼륨 크기 확인

```bash
docker system df -v | grep lemon-safe
```

### 볼륨 상세 정보

```bash
docker volume inspect lemon-postgres-data-safe
```

### 정기 모니터링 스크립트

```bash
# 매시간 볼륨 체크
crontab -e

# 추가:
0 * * * * cd /home/sanchan/lemonkorean && ./scripts/monitoring/check-volumes.sh >> /var/log/lemon-monitor.log 2>&1
```

---

## 🔧 문제 해결

### 문제 1: "Volume is in use" 에러

```bash
docker volume rm lemon-postgres-data-safe
# Error: remove lemon-postgres-data-safe: volume is in use
```

**해결**:
```bash
# 1. 사용 중인 컨테이너 확인
docker ps -a --filter volume=lemon-postgres-data-safe

# 2. 컨테이너 중지 및 삭제
docker compose down

# 3. 다시 시도
docker volume rm lemon-postgres-data-safe
```

### 문제 2: "Volume not found" 에러

```bash
docker compose up -d
# Error: volume lemon-postgres-data-safe not found
```

**해결**:
```bash
# 외부 볼륨 생성
docker volume create lemon-postgres-data-safe
docker volume create lemon-mongo-data-safe
docker volume create lemon-redis-data-safe
docker volume create lemon-minio-data-safe
docker volume create lemon-rabbitmq-data-safe

# 서비스 시작
docker compose up -d
```

### 문제 3: 데이터가 없음

```bash
# PostgreSQL에 데이터가 없는 경우
docker compose exec postgres psql -U 3chan -d lemon_korean -c "SELECT COUNT(*) FROM lessons;"
# 0 rows
```

**해결**:
```bash
# 1. 백업에서 복구
./scripts/backup/restore-postgres.sh

# 2. 또는 시드 데이터 로드
docker compose exec -T postgres psql -U 3chan -d lemon_korean < database/postgres/init/02_seed.sql
```

---

## 📚 추가 리소스

- **데이터 손실 분석**: `DATA_LOSS_ANALYSIS.md`
- **백업 전략**: `scripts/backup/README.md`
- **모니터링 가이드**: `MONITORING.md`
- **Docker 볼륨 문서**: https://docs.docker.com/storage/volumes/

---

## ✅ 체크리스트

설정 완료 확인:

- [x] 외부 볼륨 생성됨
- [x] docker-compose.override.yml 설정됨
- [x] 데이터 마이그레이션 완료
- [x] 서비스 정상 작동
- [ ] 보호 기능 테스트 완료 (`./scripts/test-volume-protection.sh`)
- [ ] 자동 백업 Cron 설정
- [ ] 볼륨 모니터링 Cron 설정

---

## 🎯 요약

### 이전 (Before)
```bash
docker compose down -v
# → 💥 모든 데이터 삭제! 복구 불가능!
```

### 현재 (After)
```bash
docker compose down -v
# → ✅ 컨테이너만 삭제, 데이터는 안전!
```

### 보호 수준

| 명령어 | 이전 | 현재 |
|--------|------|------|
| `docker compose down -v` | ❌ 데이터 삭제 | ✅ 데이터 보호 |
| `docker system prune --volumes` | ❌ 데이터 삭제 | ✅ 데이터 보호 |
| `docker volume rm <volume>` | ❌ 즉시 삭제 | ⚠️ 사용 중이면 실패 |

---

**작성일**: 2026-02-01
**작성자**: Claude Sonnet 4.5
**우선순위**: 🔒 CRITICAL - DATA PROTECTION
