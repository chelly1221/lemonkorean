# Performance Optimization Scripts

시스템 성능 최적화를 위한 스크립트 모음입니다.

## 📁 스크립트 목록

### 1. Database Optimization (`optimize-database.sh`)
PostgreSQL 데이터베이스 최적화 도구

**기능:**
- ANALYZE: 테이블 통계 정보 업데이트
- VACUUM: 불필요한 데이터 정리
- VACUUM FULL: 완전한 데이터베이스 정리 (테이블 잠금)
- REINDEX: 인덱스 재구성
- Bloat 체크: 테이블/인덱스 팽창 확인
- Missing indexes: 누락된 인덱스 제안
- Slow queries: 느린 쿼리 분석
- Index usage: 인덱스 사용률 확인

**사용법:**
```bash
# 대화형 모드
./optimize-database.sh

# 자동 최적화 (ANALYZE + VACUUM + REINDEX + 통계 업데이트)
./optimize-database.sh --auto
```

**주의사항:**
- VACUUM FULL은 테이블을 잠그므로 트래픽이 적은 시간에 실행
- 프로덕션 환경에서는 백업 후 실행 권장

---

### 2. Image Optimization (`optimize-images.sh`)
이미지 파일 최적화 및 WebP 변환

**기능:**
- JPEG/PNG 압축 (jpegoptim, optipng)
- WebP 변환 (cwebp)
- 이미지 리사이징 (최대 1920x1920)
- 용량 절감 통계 출력

**사용법:**
```bash
# 현재 디렉토리의 이미지 최적화
./optimize-images.sh

# 특정 디렉토리 최적화
./optimize-images.sh ./uploads ./uploads-optimized

# 품질 및 크기 커스텀
QUALITY=90 MAX_WIDTH=2560 ./optimize-images.sh ./images ./cdn
```

**의존성:**
```bash
sudo apt install imagemagick webp jpegoptim optipng
```

**출력:**
- `{filename}.jpg` - 최적화된 JPEG
- `{filename}.png` - 최적화된 PNG
- `{filename}.webp` - WebP 변환 파일

---

### 3. Redis Optimization (`optimize-redis.sh`)
Redis 캐시 최적화 및 메모리 관리

**기능:**
- 메모리 통계 확인
- 키 패턴 분석
- 만료 키 정리
- Slow log 분석
- 네임스페이스 삭제
- AOF 재작성
- 메모리/eviction 정책 설정

**사용법:**
```bash
# 대화형 모드
./optimize-redis.sh

# 정보만 출력
./optimize-redis.sh --info
```

**유용한 작업:**
- 특정 네임스페이스 삭제 (예: `session:*`)
- 만료된 키 정리
- 메모리 정책 조정 (LRU, LFU 등)

---

### 4. Nginx Optimization (`optimize-nginx.sh`)
Nginx 캐시 및 로그 분석

**기능:**
- 캐시 통계 (크기, 파일 수)
- 캐시 히트율 분석
- 응답 시간 통계
- 캐시 정리 (전체/오래된 파일)
- 에러 로그 분석
- 접근 로그 요약

**사용법:**
```bash
# 대화형 모드
./optimize-nginx.sh

# 통계만 출력
./optimize-nginx.sh --stats
```

**캐시 정리:**
```bash
# 30일 이상 된 캐시 삭제
# 스크립트 실행 후 옵션 6 선택, 30 입력
```

---

### 5. System Resource Monitor (`monitor-resources.sh`)
시스템 리소스 실시간 모니터링

**기능:**
- Docker 컨테이너 리소스 사용량
- 컨테이너 헬스 체크
- 시스템 CPU/메모리/디스크 사용량
- 네트워크 통계
- 데이터베이스 통계
- 로그 에러 확인
- 자동 알림 (임계치 초과 시)

**사용법:**
```bash
# 대화형 모드
./monitor-resources.sh

# 실시간 모니터링 (5초 간격)
./monitor-resources.sh --watch

# 전체 리포트 생성
./monitor-resources.sh --report
```

**알림 임계치:**
- CPU > 80%
- 메모리 > 85%
- 디스크 > 85%
- Unhealthy 컨테이너 감지

---

## 🚀 빠른 시작

### 1. 스크립트 실행 권한 부여
```bash
cd scripts/optimization
chmod +x *.sh
```

### 2. 일일 최적화 루틴
```bash
# 데이터베이스 최적화 (자동 모드)
./optimize-database.sh --auto

# Redis 정보 확인
./optimize-redis.sh --info

# Nginx 캐시 통계
./optimize-nginx.sh --stats

# 시스템 리포트
./monitor-resources.sh --report
```

### 3. 주간 최적화 루틴
```bash
# 데이터베이스 완전 최적화
./optimize-database.sh
# 옵션 3 (VACUUM FULL) 선택

# Redis 네임스페이스 정리
./optimize-redis.sh
# 옵션 7 (Clear namespace) 선택

# 오래된 Nginx 캐시 삭제
./optimize-nginx.sh
# 옵션 6 선택, 30일 입력
```

---

## 📊 성능 벤치마크

### Database Optimization
**효과:**
- VACUUM으로 10-30% 디스크 공간 절약
- ANALYZE로 쿼리 플래너 최적화
- REINDEX로 인덱스 크기 10-20% 감소

**권장 주기:**
- ANALYZE: 매일
- VACUUM: 주 1회
- VACUUM FULL: 월 1회 (야간)
- REINDEX: 분기 1회

### Image Optimization
**효과:**
- JPEG: 30-50% 크기 감소
- PNG: 20-40% 크기 감소
- WebP: 원본 대비 25-35% 크기

**예시:**
```
Original: 500KB JPEG
Optimized: 350KB JPEG (30% 절감)
WebP: 325KB (35% 절감)
```

### Redis Optimization
**효과:**
- 만료 키 정리로 10-20% 메모리 절약
- AOF 재작성으로 50-70% 파일 크기 감소
- Slow log 분석으로 병목 쿼리 식별

### Nginx Cache
**효과:**
- 캐시 히트율 70% 이상 목표
- 응답 시간 80-90% 감소 (캐시 적중 시)
- 백엔드 서버 부하 50-70% 감소

---

## ⚙️ 자동화 (Cron)

### Crontab 설정 예시
```bash
# Crontab 편집
crontab -e

# 매일 새벽 2시 데이터베이스 최적화
0 2 * * * cd /home/sanchan/lemonkorean && ./scripts/optimization/optimize-database.sh --auto >> /var/log/lemon-db-optimize.log 2>&1

# 매일 새벽 3시 시스템 리포트
0 3 * * * cd /home/sanchan/lemonkorean && ./scripts/optimization/monitor-resources.sh --report >> /var/log/lemon-report.log 2>&1

# 매주 일요일 새벽 4시 오래된 캐시 삭제 (스크립트 자동 모드 필요)
0 4 * * 0 find /home/sanchan/lemonkorean/nginx/cache -type f -mtime +30 -delete

# 매시간 시스템 알림 체크
0 * * * * cd /home/sanchan/lemonkorean && ./scripts/optimization/monitor-resources.sh --report | grep "alerts:" | grep -v "No alerts" && echo "ALERT DETECTED" | mail -s "Lemon Korean System Alert" admin@example.com
```

---

## 🔧 트러블슈팅

### 스크립트 실행 권한 오류
```bash
chmod +x scripts/optimization/*.sh
```

### Docker 컨테이너 접근 오류
```bash
# 컨테이너가 실행 중인지 확인
docker ps | grep lemon-

# 컨테이너 이름이 다른 경우 환경 변수 설정
export POSTGRES_CONTAINER=custom-postgres
./optimize-database.sh
```

### 의존성 설치 오류
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y imagemagick webp jpegoptim optipng

# macOS
brew install imagemagick webp jpegoptim optipng
```

### .env 파일 없음
```bash
# .env.example 복사
cp .env.example .env

# 필요한 값 설정
nano .env
```

---

## 📈 모니터링 통합

### Prometheus + Grafana 연동
최적화 메트릭을 Prometheus로 내보내려면:

```bash
# Node Exporter로 시스템 메트릭 수집 (이미 실행 중)
# Grafana 대시보드에서 다음 쿼리 사용:

# CPU 사용률
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# 메모리 사용률
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# 디스크 사용률
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / node_filesystem_size_bytes * 100
```

---

## 📝 로깅

모든 스크립트는 다음 위치에 로그 저장 가능:

```bash
# 로그 디렉토리 생성
mkdir -p /var/log/lemon-korean

# 스크립트 실행 시 로그 저장
./optimize-database.sh --auto >> /var/log/lemon-korean/db-optimize.log 2>&1
./monitor-resources.sh --report >> /var/log/lemon-korean/monitor.log 2>&1
```

---

## 🔒 보안 고려사항

- 스크립트는 루트 권한 없이 실행
- 민감한 데이터 (비밀번호)는 `.env` 파일에서 로드
- 프로덕션 환경에서는 읽기 전용 사용자 권한 사용 권장
- 로그 파일은 정기적으로 로테이션 (`logrotate` 사용)

---

## 📚 참고 자료

- [PostgreSQL Performance Tuning](https://www.postgresql.org/docs/current/performance-tips.html)
- [Redis Memory Optimization](https://redis.io/docs/manual/optimization/)
- [Nginx Caching Guide](https://www.nginx.com/blog/nginx-caching-guide/)
- [Docker Resource Constraints](https://docs.docker.com/config/containers/resource_constraints/)

---

## 💡 팁

1. **정기적인 모니터링**: `monitor-resources.sh --watch`로 실시간 리소스 확인
2. **백업 후 최적화**: 큰 변경 전에는 항상 백업 (`./scripts/backup/backup-postgres.sh`)
3. **점진적 최적화**: 한 번에 모든 최적화를 하지 말고 단계적으로 진행
4. **메트릭 기록**: 최적화 전후 메트릭을 기록하여 효과 측정
5. **알림 설정**: Grafana 또는 메일로 임계치 초과 시 알림 받기

---

## Socket.IO / Redis / DM 최적화 (2026-02-10)

### Redis DM 키 관리
- `dm:online:{userId}` 키는 TTL 300초 → 자동 만료, 수동 정리 불필요
- `deployment:web:lock` 키는 TTL 15분 → 배포 실패 시 수동 삭제 가능

### Socket.IO 연결 설정
- `pingTimeout`: 60000ms (60초)
- `pingInterval`: 25000ms (25초)
- 장시간 미활동 시 자동 연결 해제

### dm_messages 테이블 최적화
```bash
# dm_messages 테이블은 고빈도 INSERT → VACUUM 주기 단축 권장
docker compose exec postgres psql -U 3chan -d lemon_korean -c \
  "VACUUM ANALYZE dm_messages;"

# 테이블 크기 확인
docker compose exec postgres psql -U 3chan -d lemon_korean -c \
  "SELECT pg_size_pretty(pg_total_relation_size('dm_messages'));"
```

### Voice Room 정리
```bash
# 오래된 closed 방 정리 (30일 이상)
docker compose exec postgres psql -U 3chan -d lemon_korean -c \
  "DELETE FROM voice_rooms WHERE status = 'closed' AND closed_at < NOW() - INTERVAL '30 days';"
```

---

**작성일**: 2026-01-28
**버전**: 1.1.0
**유지보수**: Lemon Korean DevOps Team
