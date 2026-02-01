# Claude Code 작업 규칙

## 🚨 중요: 이 규칙을 항상 준수하세요

Claude Code는 이 프로젝트에서 다음 규칙을 **반드시** 따라야 합니다.

---

## 1. 절대 금지 명령어 (NEVER EXECUTE)

다음 명령어는 **어떤 상황에서도** 실행하지 마세요:

### 볼륨 삭제 명령어
```bash
❌ docker compose down -v
❌ docker-compose down -v
❌ docker compose down --volumes
❌ docker system prune -a --volumes
❌ docker system prune --volumes
❌ docker volume rm lemon-postgres-data-safe
❌ docker volume rm lemon-mongo-data-safe
❌ docker volume rm lemon-redis-data-safe
❌ docker volume rm lemon-minio-data-safe
❌ docker volume rm lemon-rabbitmq-data-safe
❌ docker volume prune
```

### 파일 삭제 명령어
```bash
❌ rm -rf /var/lib/docker/volumes/*
❌ rm -rf backups/*
❌ rm -rf database/*
```

### 데이터베이스 삭제 명령어
```bash
❌ DROP DATABASE lemon_korean;
❌ TRUNCATE TABLE users;
❌ TRUNCATE TABLE lessons;
❌ DELETE FROM users WHERE 1=1;
```

---

## 2. 사용자 확인 필요 명령어 (REQUIRES USER APPROVAL)

다음 명령어는 실행 전 **반드시 사용자 승인**이 필요합니다:

### Docker 명령어
```bash
⚠️ docker compose down           # 컨테이너 중지
⚠️ docker compose restart         # 서비스 재시작
⚠️ docker system prune            # 미사용 리소스 정리
⚠️ docker volume rm <any-volume>  # 볼륨 삭제 (보호된 볼륨 제외)
```

### 파일 작업
```bash
⚠️ rm -rf <any-directory>        # 디렉토리 삭제
⚠️ mv backups/* <destination>    # 백업 이동
```

### 데이터베이스 작업
```bash
⚠️ psql ... < schema.sql         # 스키마 변경
⚠️ DELETE FROM <table>           # 데이터 삭제
⚠️ UPDATE <table> SET ...        # 대량 업데이트
```

---

## 3. 명령어 실행 전 검증 프로세스

명령어를 실행하기 전에 다음 단계를 **반드시** 따르세요:

### Step 1: 명령어 분류

```
명령어 확인
    ↓
절대 금지?
    → YES → 실행하지 않음 + 사용자에게 경고
    → NO  → Step 2
```

### Step 2: 사용자 확인 필요 여부

```
사용자 확인 필요?
    → YES → 사용자에게 확인 요청 + 대안 제시
    → NO  → Step 3
```

### Step 3: 안전성 검증

```
데이터 손실 가능성?
    → YES → 사용자 확인 + 백업 권장
    → NO  → 안전하게 실행
```

---

## 4. 실행 전 체크리스트

명령어를 실행하기 전에 다음 질문에 답하세요:

- [ ] 이 명령어가 볼륨을 삭제하나요?
- [ ] 이 명령어가 데이터를 삭제하나요?
- [ ] 이 명령어가 서비스를 중지하나요?
- [ ] 이 명령어가 파일을 삭제하나요?
- [ ] 이 명령어가 복구 불가능한 작업인가요?

**하나라도 YES면 → 사용자 확인 필요!**

---

## 5. 대안 제시 규칙

금지된 명령어 대신 안전한 대안을 제시하세요:

### 예시 1: 볼륨 삭제
```
❌ 사용자 요청: "docker compose down -v 해줘"

✅ Claude 응답:
"⚠️ 이 명령어는 모든 볼륨을 삭제하여 데이터 손실을 일으킵니다.
대신 다음 명령어를 사용하세요:

  docker compose down    # 볼륨 보존

볼륨을 정말 삭제해야 한다면, 먼저:
1. 백업 실행: ./scripts/backup/backup-all.sh
2. 수동으로 직접 실행해주세요."
```

### 예시 2: 데이터 삭제
```
❌ 사용자 요청: "lessons 테이블 비워줘"

✅ Claude 응답:
"⚠️ 이 작업은 모든 레슨 데이터를 삭제합니다.
정말 실행하시겠습니까?

백업을 먼저 실행하는 것을 권장합니다:
  ./scripts/backup/backup-postgres.sh

계속하려면 다음 명령어를 직접 실행해주세요:
  docker compose exec postgres psql -U 3chan -d lemon_korean -c 'TRUNCATE TABLE lessons CASCADE;'"
```

---

## 6. 안전한 작업 패턴

### 파일 읽기/검색 (안전)
```bash
✅ cat <file>
✅ grep <pattern> <file>
✅ find <path> -name <pattern>
✅ ls -la <directory>
```

### 서비스 상태 확인 (안전)
```bash
✅ docker compose ps
✅ docker compose logs
✅ docker volume ls
✅ docker system df
```

### 데이터 조회 (안전)
```bash
✅ psql -c "SELECT ..."
✅ mongo --eval "db.collection.find()"
```

### 백업 (안전)
```bash
✅ ./scripts/backup/backup-all.sh
✅ ./scripts/backup/backup-postgres.sh
```

---

## 7. 에러 처리

명령어 실행 중 에러가 발생하면:

1. **즉시 중단** - 추가 명령어 실행하지 않음
2. **에러 로그 확인** - docker logs, system logs 확인
3. **사용자에게 보고** - 에러 내용 및 원인 설명
4. **복구 방법 제시** - 안전한 복구 절차 제시

### 예시
```
❌ 에러 발생: "docker compose up -d" 실패

✅ Claude 응답:
"서비스 시작 중 에러가 발생했습니다.

에러 확인:
  docker compose logs postgres

일반적인 원인:
  1. 포트 충돌
  2. 볼륨 권한 문제
  3. 설정 오류

안전한 복구:
  1. 로그 확인
  2. 충돌 서비스 확인: sudo lsof -i :5432
  3. 필요시 docker compose down 후 재시작

데이터는 안전합니다 (외부 볼륨 사용 중)."
```

---

## 8. 백업 우선 원칙

데이터를 수정하는 모든 작업 전에 백업을 권장하세요:

```bash
# 항상 백업 먼저!
./scripts/backup/backup-all.sh

# 그 다음 작업 수행
<실제 작업>
```

---

## 9. 로깅 규칙

위험한 명령어 시도는 로그에 기록하세요:

```bash
echo "$(date) | BLOCKED | <command> | Reason: <reason>" >> .claude-safety.log
```

---

## 10. 응급 상황 대응

### 데이터 손실이 발생한 경우

1. **즉시 작업 중단**
2. **사용자에게 알림**
3. **백업 확인**
```bash
ls -lh backups/postgres/daily/
ls -lh backups/mongodb/daily/
```
4. **복구 절차 제시**
```bash
./scripts/backup/restore-postgres.sh
./scripts/backup/restore-mongodb.sh
```

### 서비스 중단이 발생한 경우

1. **원인 파악**
```bash
docker compose ps
docker compose logs --tail=50
```
2. **안전한 재시작**
```bash
docker compose restart <service>
# 또는
docker compose down && docker compose up -d
```
3. **데이터 무결성 확인**
```bash
./scripts/monitoring/check-data-integrity.sh
```

---

## 11. 금지된 자동화

다음은 **절대** 자동으로 실행하지 마세요:

❌ 자동 볼륨 정리
❌ 자동 데이터 삭제
❌ 자동 스키마 변경
❌ 자동 프로덕션 배포
❌ 자동 백업 삭제

---

## 12. 허용된 자동화

다음은 안전하게 자동 실행 가능:

✅ 로그 조회
✅ 상태 확인
✅ 백업 생성
✅ 코드 검색/분석
✅ 문서 생성
✅ 테스트 실행 (읽기 전용)

---

## 13. 의심스러운 경우

명령어가 안전한지 확실하지 않으면:

1. **실행하지 않음**
2. **사용자에게 질문**
3. **안전한 대안 제시**
4. **검증 스크립트 사용**
```bash
./scripts/safety/validate-command.sh "<command>" claude
```

---

## 14. 체크리스트 요약

명령어 실행 전:

- [ ] `.claude-safety.yml` 확인
- [ ] 절대 금지 목록에 없는지 확인
- [ ] 데이터 손실 가능성 확인
- [ ] 사용자 확인 필요 여부 판단
- [ ] 백업 필요 여부 확인
- [ ] 안전한 대안 있는지 확인
- [ ] 로그 기록 필요 여부 확인

---

## 15. 위반 시 조치

이 규칙을 위반하면:

1. **즉시 작업 중단**
2. **사용자에게 사과**
3. **로그에 기록**
4. **복구 절차 제시**
5. **재발 방지책 수립**

---

## 🎯 핵심 원칙

### "의심스러우면 실행하지 마라"

1. **데이터 안전 > 편의성**
2. **사용자 확인 > 자동 실행**
3. **백업 우선 > 작업 수행**
4. **대안 제시 > 거부만 하기**
5. **투명성 > 숨기기**

---

**이 규칙은 절대적입니다. 예외는 없습니다.**

---

## 16. Docker Compose 수정 규칙

### 절대 금지: docker-compose.yml에서 설정 변경

다음 항목은 docker-compose.yml에서 **절대** 수정하지 마세요:

```bash
❌ PostgreSQL 설정 (memory, connections, logging)
❌ Redis 설정 (maxmemory, persistence)
❌ MongoDB 설정 (cache, logging, profiling)
❌ RabbitMQ 설정 (memory limits, queues)
❌ 볼륨 경로 변경 (data volume paths)
❌ command 섹션의 설정 플래그
```

### 대신 외부 설정 파일 수정

설정 변경이 필요하면 다음 파일을 수정하세요:

| 서비스 | 설정 파일 |
|--------|----------|
| PostgreSQL | `config/postgres/postgresql.conf` |
| Redis | `config/redis/redis.conf` |
| MongoDB | `config/mongo/mongod.conf` |
| RabbitMQ | `config/rabbitmq/rabbitmq.conf` |
| RabbitMQ Queues | `config/rabbitmq/definitions.json` |
| Prometheus | `monitoring/prometheus/prometheus.yml` |
| Prometheus Alerts | `monitoring/prometheus/rules/alerts.yml` |
| Nginx | `nginx/nginx.dev.conf` or `nginx/nginx.conf` |

### docker-compose.yml 수정이 허용되는 경우

```bash
✅ 새 서비스 추가
✅ 포트 매핑 변경
✅ 환경 변수 추가/변경 (비설정 관련)
✅ depends_on 관계 변경
✅ 네트워크 설정 변경
✅ 새 볼륨 마운트 추가
```

### 워크플로우

1. 설정 변경 요청 받음
2. docker-compose.yml 수정 ❌ **금지**
3. 해당 `config/` 파일 수정 ✅
4. 컨테이너 재시작으로 적용:
```bash
docker compose restart <service>
```

### 예시

```
❌ 사용자 요청: "PostgreSQL 메모리를 512MB로 변경해줘"

❌ 잘못된 방법: docker-compose.yml의 command 섹션 수정

✅ 올바른 방법:
1. config/postgres/postgresql.conf 수정
   shared_buffers = 512MB
2. 컨테이너 재시작
   docker compose restart postgres
```

---

**작성일**: 2026-02-01
**버전**: 1.1
**우선순위**: 🚨 CRITICAL - MUST FOLLOW
