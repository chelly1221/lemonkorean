# Nginx API Gateway

Lemon Korean 프로젝트의 API Gateway 설정

## 개요

Nginx가 다음 역할을 수행합니다:
- **API Gateway**: 6개 마이크로서비스로 요청 라우팅
- **Load Balancing**: Least connections 알고리즘
- **Rate Limiting**: IP 기반 요청 제한
- **Caching**: 미디어 파일 및 API 응답 캐싱
- **SSL Termination**: HTTPS 지원
- **Gzip Compression**: 응답 압축
- **Security Headers**: HSTS, XSS 보호 등

---

## 파일 구조

```
nginx/
├── nginx.conf              # 프로덕션 설정 (SSL, 엄격한 rate limiting)
├── nginx.dev.conf          # 개발 설정 (HTTP only, 완화된 제한)
├── Dockerfile              # Nginx 컨테이너 빌드
├── generate-ssl.sh         # 자체 서명 인증서 생성 (개발용)
├── setup-letsencrypt.sh    # Let's Encrypt 설정 (프로덕션용)
├── ssl/                    # SSL 인증서 디렉토리
├── cache/                  # Nginx 캐시 디렉토리
└── logs/                   # 로그 파일
```

---

## 라우팅 맵

| 엔드포인트 | 서비스 | 포트 | 설명 |
|-----------|--------|------|------|
| `/api/auth/*` | auth-service | 3001 | 인증/인가 |
| `/api/content/*` | content-service | 3002 | 레슨/단어/문법 |
| `/api/progress/*` | progress-service | 3003 | 진도/SRS |
| `/media/*` | media-service | 3004 | 이미지/오디오/비디오 |
| `/api/analytics/*` | analytics-service | 3005 | 로그 분석 |
| `/api/admin/*` | admin-service | 3006 | 관리자 대시보드 |

---

## Rate Limiting

### 프로덕션 (nginx.conf)
```nginx
# 일반 API: 100 req/s per IP
limit_req zone=api_limit burst=50

# 인증 API: 10 req/s per IP
limit_req zone=auth_limit burst=20

# 업로드: 5 req/min per IP
limit_req zone=upload_limit burst=3

# 동시 연결: 20 connections per IP
limit_conn conn_limit 20
```

### 개발 (nginx.dev.conf)
- 일반 API: 1000 req/s
- 인증 API: 100 req/s
- 업로드: 50 req/min

---

## 캐싱 전략

### 미디어 파일 캐싱
```nginx
# 위치: /var/cache/nginx/media
# 최대 크기: 10GB
# 유효 기간: 7일
# 캐시 키: $scheme$request_method$host$request_uri

proxy_cache_valid 200 7d;
proxy_cache_valid 404 1m;
```

### API 응답 캐싱
```nginx
# 위치: /var/cache/nginx/api
# 최대 크기: 1GB
# 유효 기간: 1시간

proxy_cache_valid 200 1h;
# GET 요청만 캐싱
proxy_cache_methods GET HEAD;
```

### 캐시 상태 확인
```bash
curl -I https://api.lemonkorean.com/media/images/test.jpg
# 응답 헤더:
# X-Cache-Status: HIT | MISS | BYPASS | EXPIRED
```

---

## SSL 설정

### 개발 환경 (자체 서명 인증서)

```bash
# 인증서 생성
cd nginx
./generate-ssl.sh

# 인증서 위치
# ssl/fullchain.pem
# ssl/privkey.pem
```

### 프로덕션 (Let's Encrypt)

```bash
# 1. DNS 설정
# A 레코드: api.lemonkorean.com -> Your-Server-IP

# 2. Let's Encrypt 설정
cd nginx
./setup-letsencrypt.sh api.lemonkorean.com admin@lemonkorean.com

# 3. Nginx 재시작
docker-compose restart nginx
```

### SSL 설정 상세
```nginx
# 프로토콜: TLSv1.2, TLSv1.3
# 암호화 스위트: ECDHE + GCM
# HSTS: 1년 (includeSubDomains)
# OCSP Stapling: 활성화
```

---

## 보안 헤더

### 프로덕션
```
Strict-Transport-Security: max-age=31536000; includeSubDomains
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Referrer-Policy: strict-origin-when-cross-origin
```

### CORS 설정
```nginx
# 허용 Origin: 요청의 Origin 헤더
# 허용 메서드: GET, POST, PUT, DELETE, PATCH, OPTIONS
# 자격 증명: true
# Preflight 캐시: 1시간
```

---

## Health Check 엔드포인트

### 기본 Health Check
```bash
curl http://localhost/health

{
  "status": "ok",
  "service": "api-gateway",
  "timestamp": "2026-01-25T10:00:00Z"
}
```

### 상세 Health Check
```bash
curl http://localhost/health/detailed

{
  "status": "ok",
  "gateway": "nginx",
  "upstreams": {
    "auth": "auth-service:3001",
    "content": "content-service:3002",
    "progress": "progress-service:3003",
    "media": "media-service:3004",
    "analytics": "analytics-service:3005",
    "admin": "admin-service:3006"
  }
}
```

---

## 실행 방법

### Docker Compose로 실행 (권장)

```yaml
# docker-compose.yml에 추가
nginx:
  build: ./nginx
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - ./nginx/ssl:/etc/nginx/ssl:ro
    - nginx_cache:/var/cache/nginx
    - nginx_logs:/var/log/nginx
  depends_on:
    - auth-service
    - content-service
    - progress-service
    - media-service
    - analytics-service
    - admin-service
  networks:
    - lemon-network
  restart: unless-stopped

volumes:
  nginx_cache:
  nginx_logs:
```

```bash
# 시작
docker-compose up -d nginx

# 로그 확인
docker-compose logs -f nginx

# 재시작
docker-compose restart nginx
```

### 직접 Docker 실행

```bash
# 빌드
cd nginx
docker build -t lemon-nginx .

# 실행
docker run -d \
  --name lemon-nginx \
  -p 80:80 -p 443:443 \
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
  -v $(pwd)/ssl:/etc/nginx/ssl:ro \
  lemon-nginx
```

---

## 개발 vs 프로덕션

### 개발 환경
```bash
# nginx.dev.conf 사용
docker run -d \
  -v $(pwd)/nginx.dev.conf:/etc/nginx/nginx.conf:ro \
  lemon-nginx

# 특징:
# - HTTP only (포트 80)
# - 완화된 rate limiting
# - 짧은 캐시 시간
# - 상세한 로깅 (debug level)
# - 허용적인 CORS (*)
```

### 프로덕션 환경
```bash
# nginx.conf 사용 (기본)
docker run -d \
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
  -v /etc/letsencrypt:/etc/nginx/ssl:ro \
  lemon-nginx

# 특징:
# - HTTPS (포트 443)
# - 엄격한 rate limiting
# - 긴 캐시 시간 (7일)
# - warn level 로깅
# - 제한적 CORS
```

---

## 설정 테스트

### Nginx 설정 검증
```bash
# 컨테이너 내부에서
docker exec lemon-nginx nginx -t

# 로컬에서
nginx -t -c nginx/nginx.conf
```

### Rate Limiting 테스트
```bash
# 100번 요청 (rate limit 초과)
for i in {1..100}; do
  curl -s -o /dev/null -w "%{http_code}\n" http://localhost/api/content/lessons
done

# 예상: 처음 50개는 200, 나머지는 429 (Too Many Requests)
```

### 캐싱 테스트
```bash
# 첫 요청 (MISS)
curl -I http://localhost/media/images/test.jpg | grep X-Cache-Status

# 두 번째 요청 (HIT)
curl -I http://localhost/media/images/test.jpg | grep X-Cache-Status
```

---

## 로그 분석

### Access Log
```bash
# 실시간 로그
docker exec lemon-nginx tail -f /var/log/nginx/access.log

# 응답 시간이 1초 이상인 요청
docker exec lemon-nginx grep "rt=[1-9][0-9]\+\." /var/log/nginx/access.log

# 5xx 에러
docker exec lemon-nginx grep " 5[0-9][0-9] " /var/log/nginx/access.log
```

### Error Log
```bash
# 에러 로그
docker exec lemon-nginx tail -f /var/log/nginx/error.log

# Upstream 연결 실패
docker exec lemon-nginx grep "upstream" /var/log/nginx/error.log
```

### 미디어 캐시 로그
```bash
# 캐시 상태별 분류
docker exec lemon-nginx grep "Cache:" /var/log/nginx/media_access.log | \
  awk '{print $NF}' | sort | uniq -c
```

---

## 성능 튜닝

### Worker Processes
```nginx
# 자동 (CPU 코어 수)
worker_processes auto;

# 또는 명시적으로
worker_processes 4;
```

### Worker Connections
```nginx
# 기본: 2048
# 최대 동시 클라이언트 = worker_processes * worker_connections
events {
    worker_connections 2048;
}
```

### Keepalive Connections
```nginx
# Upstream keepalive
upstream media_service {
    server media-service:3004;
    keepalive 64;  # 미디어는 더 많은 연결 유지
}
```

### Buffer 크기
```nginx
# 큰 파일 업로드
client_body_buffer_size 128k;
client_max_body_size 50m;

# 응답 버퍼
proxy_buffer_size 4k;
proxy_buffers 8 4k;
```

---

## 문제 해결

### Upstream 연결 실패
```bash
# 서비스 상태 확인
docker-compose ps

# 네트워크 확인
docker network inspect lemon-network

# Upstream 테스트
docker exec lemon-nginx curl http://auth-service:3001/health
```

### Rate Limit 429 에러
```bash
# Rate limit 상태 확인
docker exec lemon-nginx cat /etc/nginx/nginx.conf | grep limit_req_zone

# 임시로 제한 완화 (개발 시)
# nginx.dev.conf 사용
```

### SSL 인증서 문제
```bash
# 인증서 확인
openssl x509 -in nginx/ssl/fullchain.pem -noout -dates -subject

# 인증서 갱신 (Let's Encrypt)
sudo certbot renew --dry-run
sudo certbot renew
docker-compose restart nginx
```

### 캐시 삭제
```bash
# 모든 캐시 삭제
docker exec lemon-nginx rm -rf /var/cache/nginx/*

# 특정 캐시만 삭제
docker exec lemon-nginx rm -rf /var/cache/nginx/media/*
```

---

## 모니터링

### Nginx Status Module (선택)
```nginx
# nginx.conf에 추가
location /nginx_status {
    stub_status on;
    access_log off;
    allow 127.0.0.1;
    deny all;
}
```

```bash
# 상태 확인
curl http://localhost/nginx_status

# 출력:
# Active connections: 42
# server accepts handled requests
#  1000 1000 5000
# Reading: 0 Writing: 2 Waiting: 40
```

### Prometheus 통합
```bash
# nginx-prometheus-exporter 사용
docker run -d \
  --name nginx-exporter \
  -p 9113:9113 \
  nginx/nginx-prometheus-exporter:latest \
  -nginx.scrape-uri=http://nginx:80/nginx_status
```

---

## 참고 자료

- [Nginx 공식 문서](https://nginx.org/en/docs/)
- [Rate Limiting](https://www.nginx.com/blog/rate-limiting-nginx/)
- [Caching Guide](https://www.nginx.com/blog/nginx-caching-guide/)
- [SSL Best Practices](https://mozilla.github.io/server-side-tls/ssl-config-generator/)
- [Let's Encrypt](https://letsencrypt.org/getting-started/)

---

## 라이센스
MIT License
