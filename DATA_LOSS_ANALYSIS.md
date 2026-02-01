# 데이터 손실 분석 및 예방 가이드

## 📊 사건 개요

**발생 일시**: 2026-01-26 13:34 (KST)
**영향 범위**: PostgreSQL 및 MongoDB 전체 데이터 손실
**복구 가능성**: 백업 없음 (백업 시스템 미실행)

---

## 🔍 원인 분석

### 1. 볼륨 재생성 확인
```bash
# 볼륨 생성 시각 확인
docker volume inspect lemon-postgres-data --format '{{.CreatedAt}}'
# 결과: 2026-01-26T13:34:28+09:00

docker volume inspect lemon-mongo-data --format '{{.CreatedAt}}'
# 결과: 2026-01-26T13:34:28+09:00
```

**결론**: 두 볼륨이 동시에 재생성됨 → 이전 데이터 완전 삭제

### 2. 가능한 원인

#### 원인 A: `docker-compose down -v` 실행 (가장 가능성 높음)
```bash
docker-compose down -v  # ⚠️ 위험: 모든 볼륨 삭제!
```
- `-v` 플래그는 **모든 named volumes를 삭제**
- 실수로 입력하기 쉬운 명령어
- 데이터 복구 불가능

#### 원인 B: 수동 볼륨 삭제
```bash
docker volume rm lemon-postgres-data lemon-mongo-data
```
- 의도적이거나 실수로 볼륨 삭제
- 시스템 정리 중 발생 가능

#### 원인 C: `docker system prune` 사용
```bash
docker system prune -a --volumes  # ⚠️ 위험: 사용하지 않는 볼륨 모두 삭제!
```
- 시스템 정리 시 사용
- `--volumes` 플래그가 있으면 미사용 볼륨 삭제

### 3. 1월 26일 활동 분석
Git 커밋 이력:
```
8b61603 Android 빌드 수정
cbf4fd1 모든 TODO 항목 구현 완료
c0fb6b4 JWT 인증 통합 수정
a6597f0 관리자 대시보드 서비스 구현 완료
```

→ 개발 작업 중 Docker 컨테이너 재시작 가능성

---

## 🚨 데이터 손실 증거

### PostgreSQL 현재 상태
```sql
SELECT 'users' as table, COUNT(*) FROM users;           -- 4 (새로 생성됨)
SELECT 'lessons' as table, COUNT(*) FROM lessons;       -- 0 (손실)
SELECT 'vocabulary' as table, COUNT(*) FROM vocabulary; -- 20 (시드 데이터)
SELECT 'user_progress' as table, COUNT(*) FROM user_progress; -- 0 (손실)
```

### MongoDB 현재 상태
```javascript
db.getMongo().getDBNames()
// 결과: ["admin", "config", "local"]
// lemon_korean 데이터베이스 존재하지 않음 → 완전 손실
```

### 백업 상태
```bash
ls -R backups/
# 결과: 모든 백업 디렉토리 비어있음
# → 백업 스크립트가 실행되지 않았거나 Cron 미설정
```

---

## 🛡️ 예방 조치 (Critical!)

### 1. 위험한 명령어 차단

#### A. Docker Alias 설정
`~/.bashrc` 또는 `~/.zshrc`에 추가:

```bash
# 위험한 Docker 명령어 안전장치
alias docker-compose-down='echo "⚠️  WARNING: Use docker-compose-down-safe instead"; false'
alias docker-compose-down-safe='docker compose down'  # 볼륨 보존
alias docker-compose-down-volumes='echo "⚠️  DANGER: This will DELETE ALL VOLUMES! Type YES to confirm: " && read confirm && [ "$confirm" = "YES" ] && docker compose down -v'

# 시스템 정리 안전장치
alias docker-system-prune='echo "⚠️  WARNING: Use docker-system-prune-safe instead"; false'
alias docker-system-prune-safe='docker system prune'  # 볼륨 보존
alias docker-system-prune-all='echo "⚠️  DANGER: This will DELETE UNUSED VOLUMES! Type YES to confirm: " && read confirm && [ "$confirm" = "YES" ] && docker system prune -a --volumes'
```

적용:
```bash
source ~/.bashrc  # 또는 source ~/.zshrc
```

#### B. Docker Compose Override 파일
`docker-compose.override.yml` 생성:

```yaml
version: '3.8'

# 프로덕션 환경에서는 볼륨 외부 참조 강제
# docker-compose down -v 해도 삭제되지 않음
volumes:
  postgres-data:
    external: true
    name: lemon-postgres-data-prod
  mongo-data:
    external: true
    name: lemon-mongo-data-prod
```

볼륨 수동 생성:
```bash
docker volume create lemon-postgres-data-prod
docker volume create lemon-mongo-data-prod
```

### 2. 자동 백업 시스템 활성화

#### A. Cron Job 설정
```bash
# 백업 스크립트에 실행 권한 부여
chmod +x scripts/backup/*.sh

# Cron 편집
crontab -e
```

다음 추가:
```cron
# 매일 새벽 2시 데이터베이스 백업
0 2 * * * cd /home/sanchan/lemonkorean && ./scripts/backup/backup-all.sh >> /var/log/lemon-backup.log 2>&1

# 매주 일요일 새벽 3시 전체 백업
0 3 * * 0 cd /home/sanchan/lemonkorean && ./scripts/backup/backup-all.sh --weekly >> /var/log/lemon-backup.log 2>&1

# 매월 1일 새벽 4시 월간 백업
0 4 1 * * cd /home/sanchan/lemonkorean && ./scripts/backup/backup-all.sh --monthly >> /var/log/lemon-backup.log 2>&1
```

#### B. 백업 검증 스크립트
`scripts/backup/verify-backup.sh` 생성:

```bash
#!/bin/bash
set -e

BACKUP_DIR="./backups"
CURRENT_DATE=$(date +%Y-%m-%d)

# 오늘 날짜 백업 존재 확인
if [ ! -f "$BACKUP_DIR/postgres/daily/lemon_korean_${CURRENT_DATE}.sql.gz" ]; then
    echo "❌ ERROR: PostgreSQL backup missing for today!"
    exit 1
fi

if [ ! -d "$BACKUP_DIR/mongodb/daily/lemon_korean_${CURRENT_DATE}" ]; then
    echo "❌ ERROR: MongoDB backup missing for today!"
    exit 1
fi

echo "✅ Backups verified for $CURRENT_DATE"
```

Cron에 추가 (매일 오후 3시 백업 확인):
```cron
0 15 * * * cd /home/sanchan/lemonkorean && ./scripts/backup/verify-backup.sh || echo "Backup verification failed!" | mail -s "Backup Alert" admin@example.com
```

### 3. 볼륨 스냅샷 (추가 안전망)

#### A. LVM 스냅샷 사용 (Linux)
```bash
# LVM 볼륨 경로 확인
docker volume inspect lemon-postgres-data --format '{{.Mountpoint}}'

# 매일 스냅샷 생성 (Cron)
0 1 * * * lvcreate -L 10G -s -n postgres-snapshot /dev/vg0/docker-volumes
```

#### B. rsync 백업 (외부 서버)
`scripts/backup/rsync-backup.sh`:

```bash
#!/bin/bash
set -e

REMOTE_USER="backup"
REMOTE_HOST="backup-server.example.com"
REMOTE_PATH="/backups/lemonkorean"

# 백업 디렉토리를 원격 서버로 동기화
rsync -avz --delete \
  ./backups/ \
  ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_PATH}/

echo "✅ Remote backup completed at $(date)"
```

Cron에 추가 (매일 새벽 5시):
```cron
0 5 * * * cd /home/sanchan/lemonkorean && ./scripts/backup/rsync-backup.sh >> /var/log/lemon-rsync.log 2>&1
```

### 4. Docker 볼륨 잠금 (Read-Only Mode)

프로덕션 환경에서 중요한 볼륨을 읽기 전용으로 마운트:

```yaml
services:
  postgres:
    volumes:
      - postgres-data:/var/lib/postgresql/data:rw  # 일반 운영
      # - postgres-data:/var/lib/postgresql/data:ro  # 읽기 전용 (점검 중)
```

### 5. 모니터링 및 알림

#### A. 볼륨 존재 확인 스크립트
`scripts/monitoring/check-volumes.sh`:

```bash
#!/bin/bash
set -e

REQUIRED_VOLUMES=(
  "lemon-postgres-data"
  "lemon-mongo-data"
  "lemon-redis-data"
  "lemon-minio-data"
)

for volume in "${REQUIRED_VOLUMES[@]}"; do
  if ! docker volume inspect "$volume" &>/dev/null; then
    echo "❌ CRITICAL: Volume $volume does not exist!"
    # 알림 발송 (예: Slack, Email)
    exit 1
  fi
done

echo "✅ All critical volumes exist"
```

Cron에 추가 (매 시간):
```cron
0 * * * * cd /home/sanchan/lemonkorean && ./scripts/monitoring/check-volumes.sh || echo "Volume missing!" | mail -s "CRITICAL: Volume Alert" admin@example.com
```

#### B. 데이터 변경 감지
`scripts/monitoring/detect-data-loss.sh`:

```bash
#!/bin/bash
set -e

# 레슨 개수 확인
LESSON_COUNT=$(docker compose exec -T postgres psql -U 3chan -d lemon_korean -t -c "SELECT COUNT(*) FROM lessons;")

# 예상 최소 레슨 개수 (예: 100개)
MIN_LESSONS=100

if [ "$LESSON_COUNT" -lt "$MIN_LESSONS" ]; then
  echo "❌ CRITICAL: Only $LESSON_COUNT lessons found (expected > $MIN_LESSONS)"
  echo "Possible data loss detected!"
  # 알림 발송
  exit 1
fi

echo "✅ Data integrity check passed: $LESSON_COUNT lessons"
```

Cron에 추가 (매 6시간):
```cron
0 */6 * * * cd /home/sanchan/lemonkorean && ./scripts/monitoring/detect-data-loss.sh || echo "Data loss detected!" | mail -s "CRITICAL: Data Loss Alert" admin@example.com
```

---

## 📋 체크리스트: 즉시 실행할 조치

### 긴급 (즉시)
- [ ] Docker alias 설정 (`~/.bashrc` 수정)
- [ ] Cron 백업 작업 설정
- [ ] 백업 스크립트 실행 테스트
- [ ] 볼륨 모니터링 스크립트 설정

### 중요 (이번 주)
- [ ] 외부 백업 서버 설정 (rsync)
- [ ] docker-compose.override.yml 생성 (external volumes)
- [ ] 데이터 변경 감지 스크립트 설정
- [ ] 백업 복구 테스트 수행

### 권장 (이번 달)
- [ ] LVM 스냅샷 설정 (가능한 경우)
- [ ] 백업 보관 정책 문서화
- [ ] 재해 복구 계획 (Disaster Recovery Plan) 작성
- [ ] 팀원 교육 (위험한 명령어, 백업 절차)

---

## 🔧 즉시 실행 스크립트

아래 스크립트를 실행하여 기본 안전장치를 설정하세요:

```bash
#!/bin/bash
# 파일명: scripts/setup-safety.sh

set -e

echo "🛡️ Setting up data loss prevention measures..."

# 1. Bash alias 추가
if ! grep -q "docker-compose-down-safe" ~/.bashrc; then
  cat >> ~/.bashrc << 'EOF'

# === Lemon Korean Docker Safety Aliases ===
alias docker-compose-down='echo "⚠️  WARNING: Use docker-compose-down-safe instead"; false'
alias docker-compose-down-safe='docker compose down'
alias docker-compose-down-volumes='echo "⚠️  DANGER: This will DELETE ALL VOLUMES! Type YES to confirm: " && read confirm && [ "$confirm" = "YES" ] && docker compose down -v'
alias docker-system-prune='echo "⚠️  WARNING: Use docker-system-prune-safe instead"; false'
alias docker-system-prune-safe='docker system prune'
EOF
  echo "✅ Bash aliases added to ~/.bashrc"
fi

# 2. 백업 스크립트 실행 권한
chmod +x scripts/backup/*.sh
echo "✅ Backup scripts made executable"

# 3. 첫 백업 실행
./scripts/backup/backup-all.sh
echo "✅ Initial backup completed"

# 4. Cron 작업 추가 (사용자 확인 필요)
echo ""
echo "📋 Next step: Add cron jobs manually"
echo "Run: crontab -e"
echo "Add:"
echo "0 2 * * * cd $(pwd) && ./scripts/backup/backup-all.sh >> /var/log/lemon-backup.log 2>&1"

echo ""
echo "✅ Safety measures setup completed!"
echo "⚠️  Please restart your shell or run: source ~/.bashrc"
```

실행:
```bash
chmod +x scripts/setup-safety.sh
./scripts/setup-safety.sh
```

---

## 📚 참고 문서

- [Docker 볼륨 관리](https://docs.docker.com/storage/volumes/)
- [PostgreSQL 백업 및 복구](https://www.postgresql.org/docs/current/backup.html)
- [MongoDB 백업 전략](https://www.mongodb.com/docs/manual/core/backups/)
- [Cron 사용법](https://man7.org/linux/man-pages/man5/crontab.5.html)

---

## 🎯 결론

**데이터 손실의 주요 원인**: `docker-compose down -v` 또는 유사한 명령어 실행으로 볼륨 삭제

**핵심 예방 조치**:
1. ✅ 위험한 명령어 차단 (alias)
2. ✅ 자동 백업 시스템 (cron)
3. ✅ 볼륨 모니터링 (스크립트)
4. ✅ 외부 백업 (rsync)

**다음 번 데이터 손실 시**:
- 백업에서 복구: `./scripts/backup/restore-postgres.sh`
- 복구 불가능한 경우에도 최소 24시간 이내 데이터 복구 가능

---

**작성일**: 2026-02-01
**작성자**: Claude Sonnet 4.5
**우선순위**: 🚨 CRITICAL
