# 모니터링 가이드

Lemon Korean 애플리케이션 모니터링 전략 및 도구 설정.

## 개요

프로덕션 환경에서 시스템 상태, 성능, 에러를 실시간으로 모니터링합니다.

## 모니터링 레벨

### 1. 기본 모니터링 (현재 구현됨)

**헬스체크 엔드포인트**
```bash
# 전체 시스템
curl http://localhost/health

# 개별 서비스
curl http://localhost:3001/health  # Auth
curl http://localhost:3002/health  # Content
curl http://localhost:3003/health  # Progress
curl http://localhost:3004/health  # Media
curl http://localhost:3005/health  # Analytics
curl http://localhost:3007/health  # SNS
# Admin은 nginx를 통해 접근: https://lemon.3chan.kr/admin/

# Moderation (내부 전용, 호스트 포트 미노출 - docker exec로 확인)
docker exec lemon-moderation-service python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:3008/health')"
```

**Docker 상태**
```bash
# 컨테이너 상태
docker compose ps

# 실시간 리소스 사용량
docker stats

# 로그 모니터링
docker compose logs -f --tail=100
```

**시스템 리소스**
```bash
# CPU, 메모리, 디스크
htop
free -h
df -h

# 네트워크
netstat -tuln
ss -tuln
```

### 2. 로그 집계 (권장)

**Docker 로그 관리**
```bash
# 로그 파일 확인
ls -lh nginx/logs/
docker compose logs --since 1h > logs/app_$(date +%Y%m%d_%H%M%S).log

# 에러 로그만 필터링
docker compose logs | grep -i error

# 특정 서비스 로그
docker compose logs -f auth-service
```

**로그 로테이션**
```bash
# /etc/logrotate.d/lemon-korean
/opt/lemon-korean/nginx/logs/*.log {
    daily
    missingok
    rotate 14
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
}
```

### 3. Uptime 모니터링

**외부 모니터링 서비스 (무료)**

1. **UptimeRobot** (https://uptimerobot.com)
   - 5분마다 헬스체크
   - 50개 모니터까지 무료
   - 이메일/SMS 알림

2. **StatusCake** (https://www.statuscake.com)
   - 1분마다 체크 (무료)
   - 성능 메트릭 제공

3. **Pingdom** (https://www.pingdom.com)
   - 1개 사이트 무료
   - 상세한 분석

**설정 예시 (UptimeRobot):**
```
Monitor Type: HTTPS
URL: https://api.lemonkorean.com/health
Interval: 5 minutes
Alert Contacts: admin@lemonkorean.com
```

### 4. Prometheus + Grafana (고급, 선택)

**빠른 시작**

docker-compose.monitoring.yml 추가:

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: lemon-prometheus
    volumes:
      - ./monitoring/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - lemon-network
    restart: always

  grafana:
    image: grafana/grafana:latest
    container_name: lemon-grafana
    environment:
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_PASSWORD:-admin}
    volumes:
      - grafana-data:/var/lib/grafana
    ports:
      - "3000:3000"
    networks:
      - lemon-network
    restart: always

volumes:
  prometheus-data:
  grafana-data:

networks:
  lemon-network:
    external: true
```

**실행:**
```bash
# 모니터링 스택 시작
docker compose -f docker-compose.monitoring.yml up -d

# Grafana 접속
open http://localhost:3000
# 기본 로그인: admin / admin

# Prometheus 접속
open http://localhost:9090
```

**Prometheus 설정 (monitoring/prometheus.yml):**
```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'nginx'
    static_configs:
      - targets: ['nginx:80']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

## 알림 설정

### 1. Slack 알림

**Slack Incoming Webhook 생성:**
1. Slack App 생성
2. Incoming Webhooks 활성화
3. Webhook URL 복사

**사용:**
```bash
# 에러 알림
curl -X POST ${SLACK_WEBHOOK_URL} \
  -H 'Content-Type: application/json' \
  -d '{"text":"🚨 Error detected in production!"}'

# 배포 알림
curl -X POST ${SLACK_WEBHOOK_URL} \
  -H 'Content-Type: application/json' \
  -d '{"text":"✅ Deployment successful!"}'
```

### 2. 이메일 알림

**스크립트 (scripts/monitoring/alert.sh):**
```bash
#!/bin/bash

SERVICE="lemon-korean"
EMAIL="admin@lemonkorean.com"

# 헬스체크 실패 시 이메일
if ! curl -f https://api.lemonkorean.com/health; then
    echo "Service is down!" | mail -s "[$SERVICE] Alert: Service Down" $EMAIL
fi
```

**Cron 설정:**
```bash
# 5분마다 헬스체크
*/5 * * * * /opt/lemon-korean/scripts/monitoring/alert.sh
```

## 성능 메트릭

### 응답 시간 모니터링

```bash
# API 응답 시간 측정
time curl https://api.lemonkorean.com/health

# Apache Bench 부하 테스트
ab -n 1000 -c 10 https://api.lemonkorean.com/health

# 상세 타이밍
curl -w "@curl-format.txt" -o /dev/null -s https://api.lemonkorean.com/health
```

**curl-format.txt:**
```
    time_namelookup:  %{time_namelookup}s\n
       time_connect:  %{time_connect}s\n
    time_appconnect:  %{time_appconnect}s\n
   time_pretransfer:  %{time_pretransfer}s\n
      time_redirect:  %{time_redirect}s\n
 time_starttransfer:  %{time_starttransfer}s\n
                    ----------\n
         time_total:  %{time_total}s\n
```

### 데이터베이스 모니터링

```bash
# PostgreSQL 연결 수
docker compose exec postgres psql -U lemon_admin -d lemon_korean -c \
  "SELECT count(*) FROM pg_stat_activity;"

# 느린 쿼리
docker compose exec postgres psql -U lemon_admin -d lemon_korean -c \
  "SELECT query, calls, total_time FROM pg_stat_statements ORDER BY total_time DESC LIMIT 10;"

# 데이터베이스 크기
docker compose exec postgres psql -U lemon_admin -d lemon_korean -c \
  "SELECT pg_size_pretty(pg_database_size('lemon_korean'));"
```

## 에러 추적

### Sentry 통합 (선택)

**설치:**
```bash
# Node.js
npm install @sentry/node

# Python
pip install sentry-sdk

# Go
go get github.com/getsentry/sentry-go
```

**설정:**
```javascript
// Node.js
const Sentry = require('@sentry/node');

Sentry.init({
  dsn: process.env.SENTRY_DSN,
  environment: process.env.NODE_ENV,
});
```

## 대시보드

### 간단한 모니터링 대시보드

**scripts/monitoring/dashboard.sh:**
```bash
#!/bin/bash

echo "=== Lemon Korean Monitoring Dashboard ==="
echo "Date: $(date)"
echo ""

echo "=== Services Status ==="
docker compose ps

echo ""
echo "=== Resource Usage ==="
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"

echo ""
echo "=== Disk Usage ==="
df -h /

echo ""
echo "=== Recent Errors (last hour) ==="
docker compose logs --since 1h | grep -i error | tail -10

echo ""
echo "=== Active Connections ==="
netstat -an | grep :80 | wc -l
echo "HTTP connections"

netstat -an | grep :443 | wc -l
echo "HTTPS connections"
```

**실행:**
```bash
bash scripts/monitoring/dashboard.sh
```

## 주요 메트릭

모니터링해야 할 핵심 지표:

### 인프라
- ✅ CPU 사용률 (< 70%)
- ✅ 메모리 사용률 (< 80%)
- ✅ 디스크 사용률 (< 85%)
- ✅ 네트워크 대역폭

### 애플리케이션
- ✅ API 응답 시간 (< 500ms)
- ✅ 에러율 (< 1%)
- ✅ 요청 처리량 (RPS)
- ✅ 활성 사용자 수

### 데이터베이스
- ✅ 연결 수
- ✅ 쿼리 응답 시간
- ✅ 데드락 발생
- ✅ 캐시 히트율

### 비즈니스
- ✅ 신규 가입자
- ✅ 일일 활성 사용자 (DAU)
- ✅ 레슨 완료율
- ✅ 평균 세션 시간
- ✅ 온보딩 완료율 (퍼널 분석)
- ✅ 주간 목표 달성률

### Nginx 캐시
- ✅ 캐시 히트율 (X-Cache-Status 헤더)
- ✅ 캐시 디스크 사용량 (10GB 제한)
- ✅ 캐시 권한 오류 모니터링 (UID 1000)

### Socket.IO / DM (실시간 서비스)
- ✅ 동시 Socket.IO 연결 수
- ✅ DM 메시지 전송 볼륨 (24시간 기준)
- ✅ 온라인 사용자 수 (Redis `dm:online:*` keys)
- ✅ Socket.IO 연결 에러율

### LiveKit (음성 대화방)
- ✅ LiveKit 서버 상태 (HTTP health check)
- ✅ 활성 음성 대화방 수 (status='active')
- ✅ 동시 참가자 수

### Moderation Service (AI 콘텐츠 모더레이션)
- ✅ 서비스 헬스 상태 (`docker exec`로 확인)
- ✅ 모더레이션 처리 시간 (p95 < 500ms 목표)
- ✅ 게시물/댓글 자동 거부 수 (TEXT_REJECT_THRESHOLD 이상)
- ✅ 플래그된 콘텐츠 수 (수동 검토 대기)
- ✅ ONNX 모델 메모리 사용량

## 문제 해결

### 높은 CPU 사용률

```bash
# 프로세스 확인
docker stats

# 특정 컨테이너 디버깅
docker exec -it lemon-auth-service top
```

### 메모리 부족

```bash
# 메모리 사용량 확인
docker stats --no-stream

# 메모리 제한 설정 (docker-compose.yml)
deploy:
  resources:
    limits:
      memory: 512M
```

### 디스크 공간 부족

```bash
# Docker 정리
docker system prune -a --volumes

# 로그 정리
sudo journalctl --vacuum-time=7d

# 오래된 백업 삭제
find backups/ -mtime +90 -delete
```

## 자동화 스크립트

### 헬스체크 스크립트

**scripts/monitoring/healthcheck.sh:**
```bash
#!/bin/bash

SERVICES=(
  "https://api.lemonkorean.com/health"
  "https://api.lemonkorean.com/api/auth/health"
  "https://api.lemonkorean.com/api/content/health"
)

for SERVICE in "${SERVICES[@]}"; do
  if curl -f -s "$SERVICE" > /dev/null; then
    echo "✅ $SERVICE OK"
  else
    echo "❌ $SERVICE FAILED"
    # Send alert
    curl -X POST $SLACK_WEBHOOK_URL \
      -H 'Content-Type: application/json' \
      -d "{\"text\":\"❌ Health check failed: $SERVICE\"}"
  fi
done
```

## 추가 도구

### 추천 모니터링 도구

1. **Datadog** - 통합 모니터링 (유료)
2. **New Relic** - APM (유료, 무료 티어 있음)
3. **Elastic Stack** - 로그 분석 (오픈소스)
4. **Netdata** - 실시간 시스템 모니터링 (무료)

### Netdata 빠른 설치

```bash
# 설치
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# 접속
open http://localhost:19999
```

## Socket.IO / DM 모니터링

### 온라인 사용자 수

```bash
# Redis에서 현재 온라인 사용자 수 확인
docker exec lemon-redis redis-cli KEYS "dm:online:*" | wc -l

# 또는 SCAN으로 안전하게 카운트
docker exec lemon-redis redis-cli --scan --pattern "dm:online:*" | wc -l
```

### DM 메시지 볼륨

```bash
# 최근 24시간 DM 메시지 수
docker compose exec postgres psql -U 3chan -d lemon_korean -c \
  "SELECT COUNT(*) AS messages_24h FROM dm_messages WHERE created_at > NOW() - INTERVAL '24 hours';"

# 시간대별 메시지 볼륨
docker compose exec postgres psql -U 3chan -d lemon_korean -c \
  "SELECT date_trunc('hour', created_at) AS hour, COUNT(*) FROM dm_messages
   WHERE created_at > NOW() - INTERVAL '24 hours' GROUP BY 1 ORDER BY 1;"
```

### LiveKit 상태 체크

```bash
# LiveKit HTTP health check
curl http://localhost:7880

# 활성 음성 대화방 수
docker compose exec postgres psql -U 3chan -d lemon_korean -c \
  "SELECT COUNT(*) AS active_rooms FROM voice_rooms WHERE status = 'active';"

# 현재 참가자 수
docker compose exec postgres psql -U 3chan -d lemon_korean -c \
  "SELECT COUNT(*) AS active_participants FROM voice_room_participants WHERE left_at IS NULL;"
```

---

## 체크리스트

- [ ] 헬스체크 엔드포인트 테스트
- [ ] Uptime 모니터링 설정
- [ ] 로그 로테이션 설정
- [ ] 알림 채널 구성 (Slack/Email)
- [ ] 백업 모니터링 자동화
- [ ] 성능 벤치마크 수행
- [ ] Prometheus + Grafana 설정 (선택)
- [ ] 대시보드 접근 권한 설정
- [ ] Socket.IO 연결 수 모니터링 설정
- [ ] LiveKit 서버 헬스체크 추가
- [ ] DM 메시지 볼륨 알림 설정
- [ ] Moderation 서비스 헬스체크 추가 (내부 전용, `docker exec`)

## 참고 자료

- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)
- [Docker Monitoring](https://docs.docker.com/config/containers/runmetrics/)
- [Nginx Monitoring](https://www.nginx.com/blog/monitoring-nginx/)

## 문의

모니터링 관련 문의:
- GitHub Issues
- DevOps 팀: devops@lemonkorean.com
