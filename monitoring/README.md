# Lemon Korean 모니터링 스택

Prometheus + Grafana 기반 종합 모니터링 시스템.

## 구성 요소

### 핵심 모니터링
- **Prometheus** - 메트릭 수집 및 저장
- **Grafana** - 시각화 대시보드
- **Node Exporter** - 시스템 메트릭
- **cAdvisor** - 컨테이너 메트릭

### 데이터베이스 모니터링
- **PostgreSQL Exporter** - PostgreSQL 메트릭
- **Redis Exporter** - Redis 메트릭
- **MongoDB Exporter** - MongoDB 메트릭

## 빠른 시작

### 1. 네트워크 준비

모니터링 스택은 메인 앱과 동일한 Docker 네트워크를 사용합니다. 메인 앱이 실행 중이 아닌 경우 네트워크를 먼저 생성하세요:

```bash
# 네트워크 생성 (이미 존재하면 무시됨)
docker network create lemon-network 2>/dev/null || true
```

### 2. 모니터링 스택 시작

```bash
# 환경 변수 설정 (.env 파일에 GRAFANA_ADMIN_PASSWORD 추가 권장)
# export GRAFANA_ADMIN_PASSWORD=your_secure_password

# 모니터링 스택 시작
docker compose -f docker-compose.monitoring.yml up -d

# 상태 확인
docker compose -f docker-compose.monitoring.yml ps
```

### 3. 접속

**Grafana**
- URL: http://localhost:3000
- 로그인: `admin` / `.env`에서 설정한 `GRAFANA_ADMIN_PASSWORD`
- 비밀번호 미설정 시 기본값 사용 (보안상 변경 권장)

**Prometheus**
- URL: http://localhost:9090
- 타겟 상태: http://localhost:9090/targets
- 쿼리 브라우저: http://localhost:9090/graph

**cAdvisor** (컨테이너 메트릭)
- URL: http://localhost:8080

**Node Exporter** (시스템 메트릭)
- URL: http://localhost:9101/metrics (포트 9101로 매핑됨)

## Grafana 대시보드 설정

### 1. 데이터소스 확인

Grafana → Configuration → Data Sources → Prometheus (자동 설정됨)

### 2. 대시보드 가져오기

**추천 대시보드:**

1. **Node Exporter Full** (ID: 1860)
   - Grafana → Dashboards → Import
   - Dashboard ID: `1860`
   - Prometheus 데이터소스 선택

2. **Docker Container & Host Metrics** (ID: 179)
   - ID: `179`
   - cAdvisor 메트릭 사용

3. **PostgreSQL Database** (ID: 9628)
   - ID: `9628`
   - PostgreSQL Exporter 메트릭

4. **Redis Dashboard** (ID: 763)
   - ID: `763`
   - Redis Exporter 메트릭

5. **MongoDB Overview** (ID: 2583)
   - ID: `2583`
   - MongoDB Exporter 메트릭

## 주요 메트릭

### 시스템 메트릭 (Node Exporter)
```promql
# CPU 사용률
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# 메모리 사용률
(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100

# 디스크 사용률
(1 - (node_filesystem_avail_bytes / node_filesystem_size_bytes)) * 100

# 네트워크 트래픽
rate(node_network_receive_bytes_total[5m])
rate(node_network_transmit_bytes_total[5m])
```

### 컨테이너 메트릭 (cAdvisor)
```promql
# 컨테이너 CPU 사용률
rate(container_cpu_usage_seconds_total{name!=""}[5m]) * 100

# 컨테이너 메모리 사용량
container_memory_usage_bytes{name!=""}

# 컨테이너 네트워크 I/O
rate(container_network_receive_bytes_total{name!=""}[5m])
rate(container_network_transmit_bytes_total{name!=""}[5m])
```

### PostgreSQL 메트릭
```promql
# 활성 연결 수
pg_stat_activity_count

# 트랜잭션 커밋/롤백
rate(pg_stat_database_xact_commit[5m])
rate(pg_stat_database_xact_rollback[5m])

# 데이터베이스 크기
pg_database_size_bytes

# 느린 쿼리
pg_stat_activity_max_tx_duration
```

### Redis 메트릭
```promql
# 연결된 클라이언트 수
redis_connected_clients

# 메모리 사용량
redis_memory_used_bytes

# 명령 처리 속도
rate(redis_commands_processed_total[5m])

# 히트율
rate(redis_keyspace_hits_total[5m]) /
(rate(redis_keyspace_hits_total[5m]) + rate(redis_keyspace_misses_total[5m]))
```

### MongoDB 메트릭
```promql
# 활성 연결
mongodb_connections{state="current"}

# 작업 대기 시간
mongodb_op_latencies_latency

# 문서 작업
rate(mongodb_mongod_op_counters_total[5m])

# 메모리 사용
mongodb_memory{type="resident"}
```

## 알림 설정

### Alertmanager 추가 (선택)

```yaml
# monitoring/prometheus/alerts.yml
groups:
  - name: lemon_korean_alerts
    rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage detected"
          description: "CPU usage is above 80% for 5 minutes"

      - alert: HighMemoryUsage
        expr: (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "High memory usage detected"
          description: "Memory usage is above 90%"

      - alert: ServiceDown
        expr: up{job=~".*-service"} == 0
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Service is down"
          description: "{{ $labels.job }} has been down for 2 minutes"
```

### Slack 알림 통합

```yaml
# monitoring/alertmanager/config.yml
route:
  receiver: 'slack-notifications'

receivers:
  - name: 'slack-notifications'
    slack_configs:
      - api_url: 'YOUR_SLACK_WEBHOOK_URL'
        channel: '#alerts'
        text: '{{ range .Alerts }}{{ .Annotations.summary }}\n{{ .Annotations.description }}\n{{ end }}'
```

## 커스텀 대시보드 예제

### Lemon Korean 서비스 대시보드

```json
{
  "dashboard": {
    "title": "Lemon Korean Services",
    "panels": [
      {
        "title": "Service Health",
        "targets": [
          {
            "expr": "up{job=~\".*-service\"}"
          }
        ]
      },
      {
        "title": "Request Rate",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])"
          }
        ]
      },
      {
        "title": "Response Time",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))"
          }
        ]
      }
    ]
  }
}
```

## 데이터 보존

### Prometheus 보존 기간

기본 30일 설정:
```
--storage.tsdb.retention.time=30d
```

### 데이터 백업

```bash
# Prometheus 데이터 백업
docker run --rm -v lemon-prometheus-data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/prometheus-data-$(date +%Y%m%d).tar.gz -C /data .

# Grafana 데이터 백업
docker run --rm -v lemon-grafana-data:/data -v $(pwd)/backups:/backup \
  alpine tar czf /backup/grafana-data-$(date +%Y%m%d).tar.gz -C /data .
```

## 성능 최적화

### Prometheus

```yaml
# prometheus.yml
global:
  scrape_interval: 30s     # 더 긴 간격 (리소스 절약)
  evaluation_interval: 30s

storage:
  tsdb:
    retention:
      time: 15d              # 더 짧은 보존 기간
      size: 50GB             # 최대 크기 제한
```

### Grafana

```bash
# 환경 변수로 성능 튜닝
GF_DATABASE_WAL=true
GF_LOG_LEVEL=info
GF_METRICS_ENABLED=false
```

## 문제 해결

### Prometheus 타겟 연결 실패

```bash
# 네트워크 확인
docker network inspect lemon-network

# 타겟 서비스 확인
docker compose ps

# Prometheus 로그
docker compose -f docker-compose.monitoring.yml logs prometheus
```

### Grafana 데이터소스 오류

```bash
# Prometheus 연결 테스트
curl http://localhost:9090/-/healthy

# Grafana 로그
docker compose -f docker-compose.monitoring.yml logs grafana
```

### 높은 리소스 사용

```bash
# Prometheus 메트릭 수 확인
curl http://localhost:9090/api/v1/status/tsdb

# 불필요한 메트릭 제거
# prometheus.yml에서 metric_relabel_configs 사용
```

## 유지보수

### 로그 로테이션

```bash
# Prometheus 로그 정리
docker exec lemon-prometheus \
  find /prometheus -name "*.log" -mtime +7 -delete
```

### 정기 점검

```bash
# 매주 모니터링
- Prometheus 타겟 상태
- Grafana 대시보드 업데이트
- 디스크 사용량 확인
- 알림 규칙 테스트
```

## 리소스

- [Prometheus 문서](https://prometheus.io/docs/)
- [Grafana 문서](https://grafana.com/docs/)
- [PromQL 치트시트](https://promlabs.com/promql-cheat-sheet/)
- [Grafana 대시보드 라이브러리](https://grafana.com/grafana/dashboards/)

## 다음 단계

- [ ] Alertmanager 설정
- [ ] Loki 로그 집계 추가
- [ ] Jaeger 분산 추적 추가
- [ ] 커스텀 메트릭 엔드포인트 구현
- [ ] SLA/SLO 모니터링
