# Nginx Configuration Details

## 설정 파라미터 상세

### Worker 설정
```nginx
worker_processes auto;          # CPU 코어 수만큼 자동 설정
worker_connections 2048;        # Worker당 최대 동시 연결 수
use epoll;                      # Linux 최적화 이벤트 모델
multi_accept on;                # 한 번에 여러 연결 수락
```

**계산:**
- 최대 동시 클라이언트 = `worker_processes × worker_connections`
- 예: 4 cores × 2048 = 8192 동시 연결

---

## Rate Limiting 상세

### Zone 정의
```nginx
# 메모리 10MB = 약 160,000 IP 주소 저장 가능
limit_req_zone $binary_remote_addr zone=api_limit:10m rate=100r/s;
```

### Burst와 Nodelay
```nginx
limit_req zone=api_limit burst=50 nodelay;
```

- **burst=50**: 순간적으로 50개까지 큐에 대기
- **nodelay**: 대기 없이 즉시 처리 또는 거부
- 예시:
  - 평상시: 100 req/s 처리
  - 급증 시: 150 req/s까지 허용 (100 + 50 burst)
  - 초과 시: 429 에러 반환

### 실제 동작
```
시간(s)  요청 수    처리    대기    거부
0.0      200       100     50      50 ✗
0.5      150       100     50      0
1.0      100       100     0       0
1.5      200       100     50      50 ✗
```

---

## 캐싱 메커니즘

### Cache Key 생성
```nginx
proxy_cache_key "$scheme$request_method$host$request_uri";
```

**예시:**
- URL: `https://api.example.com/media/images/photo.jpg?width=800`
- Key: `httpsGEThttps://api.example.com/media/images/photo.jpg?width=800`

### Cache Levels
```nginx
proxy_cache_path /var/cache/nginx/media levels=1:2 ...
```

**디렉토리 구조:**
```
/var/cache/nginx/media/
  ├── a/
  │   ├── 3c/
  │   │   └── 4d2f1b3c...  (cached file)
  │   └── 7e/
  └── b/
```

- `levels=1:2`: 1자리 + 2자리 서브디렉토리
- 파일 시스템 성능 최적화

### Cache 상태
- **HIT**: 캐시에서 직접 반환
- **MISS**: 캐시 없음, upstream에서 가져옴
- **BYPASS**: 캐시 우회 (POST/PUT/DELETE)
- **EXPIRED**: 만료됨, 재검증 필요
- **STALE**: 만료됐지만 upstream 장애 시 반환
- **UPDATING**: 백그라운드 갱신 중
- **REVALIDATED**: 304 Not Modified로 재검증됨

---

## Upstream 로드 밸런싱

### Least Connections
```nginx
upstream auth_service {
    least_conn;  # 연결이 적은 서버 우선
    server auth-service:3001 max_fails=3 fail_timeout=30s;
    keepalive 32;
}
```

**파라미터:**
- `max_fails=3`: 3번 실패 시 서버 제외
- `fail_timeout=30s`: 30초 후 재시도
- `keepalive 32`: 32개 연결 유지

### 다중 서버 예시
```nginx
upstream content_service {
    least_conn;
    server content-1:3002 weight=2;  # 가중치 2
    server content-2:3002 weight=1;  # 가중치 1
    server content-3:3002 backup;    # 백업 서버
    keepalive 32;
}
```

**분산 비율:**
- content-1: 66% (2/3)
- content-2: 33% (1/3)
- content-3: 다른 서버 모두 장애 시에만 사용

---

## Proxy 설정 상세

### Buffering
```nginx
proxy_buffering on;              # 버퍼링 활성화
proxy_buffer_size 4k;            # 첫 번째 버퍼 크기
proxy_buffers 8 4k;              # 8개 × 4KB = 32KB
proxy_busy_buffers_size 8k;      # 클라이언트 전송용 버퍼
```

**동작:**
1. Upstream 응답을 버퍼에 저장
2. 클라이언트에게 점진적으로 전송
3. Upstream 응답 속도 > 클라이언트 속도일 때 유용

### Timeouts
```nginx
proxy_connect_timeout 10s;   # Upstream 연결 시간
proxy_send_timeout 30s;      # Upstream 전송 시간
proxy_read_timeout 30s;      # Upstream 응답 대기 시간
```

### Headers
```nginx
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $scheme;
```

**전달 예시:**
```
클라이언트: 1.2.3.4
프록시: 10.0.0.100
헤더:
  Host: api.example.com
  X-Real-IP: 1.2.3.4
  X-Forwarded-For: 1.2.3.4, 10.0.0.100
  X-Forwarded-Proto: https
```

---

## SSL/TLS 설정

### 프로토콜
```nginx
ssl_protocols TLSv1.2 TLSv1.3;
```

- TLSv1.0, TLSv1.1: 취약점으로 비활성화
- TLSv1.2: 현재 표준
- TLSv1.3: 최신, 더 빠름

### Cipher Suite
```nginx
ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:...';
ssl_prefer_server_ciphers off;
```

**선택 암호:**
- ECDHE: Forward Secrecy (완전 순방향 비밀성)
- AES-GCM: 인증된 암호화
- SHA256: 해시 알고리즘

### Session Cache
```nginx
ssl_session_cache shared:SSL:10m;
ssl_session_timeout 10m;
```

**효과:**
- 10MB 캐시 = 약 40,000 세션
- SSL 핸드셰이크 비용 감소 (CPU 절약)

### OCSP Stapling
```nginx
ssl_stapling on;
ssl_stapling_verify on;
resolver 8.8.8.8 8.8.4.4 valid=300s;
```

**장점:**
- 인증서 상태를 서버가 미리 확인
- 클라이언트 연결 속도 향상

---

## Gzip 압축

### 설정
```nginx
gzip on;
gzip_comp_level 6;              # 압축 레벨 (1-9)
gzip_min_length 256;            # 최소 256바이트부터 압축
gzip_types text/plain text/css application/json ...;
```

### 압축 레벨별 성능
| Level | CPU | 압축률 | 권장 용도 |
|-------|-----|--------|-----------|
| 1     | 낮음 | ~60%   | 실시간 스트리밍 |
| 3     | 보통 | ~70%   | 일반 API |
| 6     | 중간 | ~80%   | **권장 (균형)** |
| 9     | 높음 | ~85%   | 정적 파일 사전 압축 |

### 압축 효과
```
원본: 100 KB JSON 응답
압축: 20 KB (80% 감소)
대역폭 절약: 80% (100 → 20)
전송 시간: 5배 단축 (10Mbps 연결 기준)
```

---

## 보안 헤더 상세

### HSTS
```nginx
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
```

- **max-age=31536000**: 1년간 HTTPS만 사용
- **includeSubDomains**: 모든 서브도메인 포함
- 중간자 공격(MITM) 방지

### X-Frame-Options
```nginx
add_header X-Frame-Options "SAMEORIGIN" always;
```

- **DENY**: iframe 사용 불가
- **SAMEORIGIN**: 같은 도메인만 허용
- Clickjacking 공격 방지

### X-Content-Type-Options
```nginx
add_header X-Content-Type-Options "nosniff" always;
```

- MIME 타입 스니핑 비활성화
- XSS 공격 방지

### X-XSS-Protection
```nginx
add_header X-XSS-Protection "1; mode=block" always;
```

- 구형 브라우저용 XSS 필터
- 최신 브라우저는 CSP 사용 권장

---

## 성능 최적화 체크리스트

### ✅ 필수 설정
- [x] Worker processes = CPU 코어 수
- [x] Keepalive connections 활성화
- [x] Gzip 압축 활성화
- [x] 미디어 캐싱 활성화
- [x] Proxy buffering 활성화

### ⚡ 고급 최적화
- [ ] HTTP/2 활성화
- [ ] Brotli 압축 추가
- [ ] FastCGI cache (PHP 사용 시)
- [ ] Microcaching (1초 캐시)
- [ ] CDN 통합

### 📊 모니터링
- [ ] Access log 분석
- [ ] Slow log 활성화
- [ ] Prometheus exporter 설정
- [ ] Grafana 대시보드

---

## 실제 프로덕션 사용 예시

### 트래픽 패턴
```
일일 요청: 10,000,000 (1천만)
초당 평균: 115 req/s
초당 피크: 1,000 req/s
```

### 권장 설정
```nginx
worker_processes 8;              # 8코어 서버
worker_connections 2048;         # 16,384 동시 연결
limit_req_zone ... rate=200r/s;  # 피크의 2배 여유

# 캐시
proxy_cache_path ... max_size=50g inactive=7d;

# Upstream
upstream content_service {
    least_conn;
    server content-1:3002;
    server content-2:3002;
    server content-3:3002;
    keepalive 64;
}
```

### 예상 성능
- Cache Hit Rate: 85%
- P95 응답 시간: < 100ms
- 대역폭 절약: 70% (Gzip + Cache)
- Upstream 부하: 85% 감소

---

## 문제 해결 가이드

### 503 Service Unavailable
```nginx
# upstream 서버 상태 확인
upstream backend {
    server app:3000 max_fails=1 fail_timeout=10s;
}
```

**해결:**
- `max_fails` 증가
- `fail_timeout` 감소
- 서버 추가

### 499 Client Closed Request
```nginx
proxy_read_timeout 60s;  # 증가
```

**원인:**
- 클라이언트가 응답 전에 연결 종료
- Timeout 너무 짧음

### 502 Bad Gateway
```nginx
proxy_connect_timeout 10s;  # 증가
```

**원인:**
- Upstream 서버 다운
- 방화벽 차단
- 네트워크 지연

---

## 참고 자료

- [Nginx 튜닝 가이드](https://www.nginx.com/blog/tuning-nginx/)
- [성능 테스트](https://www.nginx.com/blog/nginx-performance-testing/)
- [보안 베스트 프랙티스](https://www.nginx.com/blog/nginx-security-best-practices/)
