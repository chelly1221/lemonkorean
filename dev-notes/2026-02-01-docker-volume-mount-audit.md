---
date: 2026-02-01
category: Infrastructure
title: Docker 볼륨 마운트 감사 및 설정 파일 외부화
author: Claude Opus 4.5
tags: [docker, volumes, configuration, postgresql, redis, mongodb, rabbitmq, prometheus]
priority: high
---

# Docker 볼륨 마운트 감사 및 설정 파일 외부화

## Overview
모든 Docker 컨테이너의 데이터 볼륨 및 설정 파일 마운트를 감사하고, 누락된 설정 파일을 외부화하여 관리 용이성과 영속성을 개선했습니다.

## Problem / Background
기존 Docker 설정에서 다음 문제가 발견되었습니다:

1. **PostgreSQL**: 커스텀 설정 파일 없이 기본 설정 사용
2. **Redis**: 명령줄 인자로만 설정, 설정 파일 없음
3. **MongoDB**: 커스텀 설정 파일 없이 기본 설정 사용
4. **RabbitMQ**: 환경 변수만 사용, 고급 설정 불가
5. **Prometheus**: 알림 규칙 파일 누락
6. **Nginx (dev)**: SSL 디렉토리 마운트 누락
7. **Admin Service (prod)**: docker.sock 마운트 누락

## Solution / Implementation

### 1. 설정 디렉토리 구조 생성
```
config/
├── postgres/
│   └── postgresql.conf       # 메모리, 연결, 로깅 최적화
├── redis/
│   └── redis.conf            # 메모리 정책, 지속성, 보안
├── mongo/
│   └── mongod.conf           # 캐시, 로깅, 프로파일링
└── rabbitmq/
    ├── rabbitmq.conf         # 리소스 제한, 큐 설정
    └── definitions.json      # 큐, 익스체인지, 바인딩 사전 정의
```

### 2. PostgreSQL 설정 (postgresql.conf)
- 메모리 최적화: `shared_buffers=512MB`, `effective_cache_size=1536MB`
- 병렬 쿼리: `max_parallel_workers=4`
- 로깅: 느린 쿼리(1초+), 체크포인트, 연결 로깅
- Autovacuum 튜닝: 2% scale factor

### 3. Redis 설정 (redis.conf)
- 메모리 관리: `maxmemory=512mb`, `allkeys-lru` 정책
- 지속성: RDB + AOF 활성화
- Lazy freeing 활성화
- Slow log 설정

### 4. MongoDB 설정 (mongod.conf)
- WiredTiger 캐시: 1GB
- 저널링 활성화
- 느린 쿼리 프로파일링: 100ms 이상
- Snappy 압축

### 5. RabbitMQ 설정 (rabbitmq.conf + definitions.json)
- 메모리 제한: 60% watermark
- 디스크 제한: 1GB minimum
- 사전 정의된 큐:
  - `progress.sync` - 진도 동기화
  - `analytics.events` - 분석 이벤트
  - `notifications.push` - 푸시 알림
- Dead letter 익스체인지 설정

### 6. Prometheus 알림 규칙 (alerts.yml)
- 서비스 헬스 알림
- 데이터베이스 알림 (PostgreSQL, MongoDB, Redis)
- 컨테이너 리소스 알림
- 시스템 리소스 알림 (CPU, 메모리, 디스크)

## Files Changed

### 새로 생성된 파일
- `/config/postgres/postgresql.conf` - PostgreSQL 설정
- `/config/redis/redis.conf` - Redis 설정
- `/config/mongo/mongod.conf` - MongoDB 설정
- `/config/rabbitmq/rabbitmq.conf` - RabbitMQ 설정
- `/config/rabbitmq/definitions.json` - RabbitMQ 정의
- `/monitoring/prometheus/rules/alerts.yml` - Prometheus 알림 규칙
- `/scripts/verify-volume-mounts.sh` - 볼륨 검증 스크립트

### 수정된 파일
- `/docker-compose.yml` - 설정 파일 마운트 추가
- `/docker-compose.prod.yml` - 설정 파일 마운트 및 admin-service 볼륨 추가
- `/docker-compose.monitoring.yml` - Prometheus 알림 규칙 마운트 추가
- `/monitoring/prometheus/prometheus.yml` - 알림 규칙 로드 설정

## Code Examples

### docker-compose.yml 변경 (PostgreSQL)

```yaml
# Before
postgres:
  image: postgres:15-alpine
  volumes:
    - postgres-data:/var/lib/postgresql/data
    - ./database/postgres/init:/docker-entrypoint-initdb.d

# After
postgres:
  image: postgres:15-alpine
  command: postgres -c config_file=/etc/postgresql/postgresql.conf
  volumes:
    - postgres-data:/var/lib/postgresql/data
    - ./database/postgres/init:/docker-entrypoint-initdb.d
    - ./config/postgres/postgresql.conf:/etc/postgresql/postgresql.conf:ro
```

### docker-compose.yml 변경 (Redis)

```yaml
# Before
redis:
  command: redis-server --requirepass ${REDIS_PASSWORD}
  volumes:
    - redis-data:/data

# After
redis:
  command: redis-server /etc/redis/redis.conf --requirepass ${REDIS_PASSWORD}
  volumes:
    - redis-data:/data
    - ./config/redis/redis.conf:/etc/redis/redis.conf:ro
```

### docker-compose.prod.yml 변경 (Admin Service)

```yaml
# Before
admin-service:
  # No volumes section

# After
admin-service:
  volumes:
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - ./:/project:ro
```

## Testing

### 설정 파일 확인
```bash
./scripts/verify-volume-mounts.sh
```

### 컨테이너 재시작 및 검증
```bash
# 컨테이너 재시작
docker compose down
docker compose up -d

# PostgreSQL 설정 확인
docker exec lemon-postgres psql -U 3chan -c "SHOW config_file;"
# 예상 출력: /etc/postgresql/postgresql.conf

# Redis 설정 확인
docker exec lemon-redis redis-cli CONFIG GET maxmemory
# 예상 출력: 536870912 (512MB)

# MongoDB 상태 확인
docker exec lemon-mongo mongosh --eval "db.adminCommand({getCmdLineOpts:1})"
```

### Docker Compose 문법 검증
```bash
docker compose config --quiet
docker compose -f docker-compose.prod.yml config --quiet
docker compose -f docker-compose.monitoring.yml config --quiet
```

## Related Issues / Notes

### 볼륨 상태 요약

| 카테고리 | 이전 | 이후 |
|---------|------|------|
| 데이터 볼륨 | 10/10 ✅ | 10/10 ✅ |
| 설정 마운트 | 5/10 ⚠️ | 10/10 ✅ |
| 전체 점수 | 75% | 100% |

### 주의사항
1. 컨테이너 재시작 필요: 새 설정을 적용하려면 `docker compose down && docker compose up -d` 실행
2. MongoDB 로그 볼륨: `lemon-mongo-log` 볼륨이 새로 추가됨
3. SSL 디렉토리: 개발 환경에서도 SSL 디렉토리가 마운트됨 (비어있어도 됨)

### 향후 개선 사항
- Alertmanager 통합으로 알림 전송 구현
- MinIO 익스포터 추가로 스토리지 메트릭 수집
- 설정 파일 버전 관리 및 변경 이력 추적
