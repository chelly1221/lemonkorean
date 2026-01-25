# Nginx API Gateway - 빠른 시작 가이드

## 빠른 시작 (5분)

### 1. SSL 인증서 생성 (개발용)
```bash
cd nginx
./generate-ssl.sh
```

### 2. Docker로 실행
```bash
# 개발 모드 (HTTP only)
docker build -t lemon-nginx .
docker run -d \
  --name lemon-nginx \
  -p 80:80 \
  -v $(pwd)/nginx.dev.conf:/etc/nginx/nginx.conf:ro \
  lemon-nginx

# 프로덕션 모드 (HTTPS)
docker run -d \
  --name lemon-nginx \
  -p 80:80 -p 443:443 \
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf:ro \
  -v $(pwd)/ssl:/etc/nginx/ssl:ro \
  lemon-nginx
```

### 3. Health Check
```bash
curl http://localhost/health

# 예상 응답:
# {"status":"ok","service":"api-gateway","timestamp":"2026-01-25T10:00:00Z"}
```

### 4. 테스트 실행
```bash
./test-endpoints.sh http://localhost
```

---

## Docker Compose 통합

### docker-compose.yml에 추가
```yaml
nginx:
  build: ./nginx
  ports:
    - "80:80"
    - "443:443"
  volumes:
    - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    - ./nginx/ssl:/etc/nginx/ssl:ro
  depends_on:
    - auth-service
    - content-service
    - progress-service
    - media-service
  networks:
    - lemon-network
```

### 전체 스택 실행
```bash
# 모든 서비스 시작
docker-compose up -d

# Nginx만 재시작
docker-compose restart nginx

# 로그 확인
docker-compose logs -f nginx
```

---

## 일반적인 작업

### 설정 변경 후 재시작
```bash
# 설정 검증
docker exec lemon-nginx nginx -t

# Reload (무중단)
docker exec lemon-nginx nginx -s reload

# 재시작 (연결 끊김)
docker restart lemon-nginx
```

### 캐시 삭제
```bash
# 모든 캐시 삭제
docker exec lemon-nginx rm -rf /var/cache/nginx/*

# 미디어 캐시만 삭제
docker exec lemon-nginx rm -rf /var/cache/nginx/media/*

# Reload
docker exec lemon-nginx nginx -s reload
```

### 로그 확인
```bash
# Access log
docker exec lemon-nginx tail -f /var/log/nginx/access.log

# Error log
docker exec lemon-nginx tail -f /var/log/nginx/error.log

# 미디어 캐시 로그
docker exec lemon-nginx tail -f /var/log/nginx/media_access.log
```

---

## API 테스트 예제

### Auth Service
```bash
# 회원가입
curl -X POST http://localhost/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'

# 로그인
curl -X POST http://localhost/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

### Content Service
```bash
# 레슨 목록 (캐시됨)
curl http://localhost/api/content/lessons

# 캐시 상태 확인
curl -I http://localhost/api/content/lessons | grep X-Cache-Status
```

### Media Service
```bash
# 이미지 업로드
curl -X POST http://localhost/media/upload?type=images \
  -F "file=@test.jpg"

# 이미지 조회 (캐시됨)
curl http://localhost/media/images/1234567890_test.jpg -o image.jpg

# 리사이징
curl "http://localhost/media/images/1234567890_test.jpg?width=800" -o resized.jpg

# 썸네일
curl "http://localhost/media/thumbnails/1234567890_test.jpg?size=200" -o thumb.jpg
```

---

## 프로덕션 배포

### 1. 도메인 설정
```bash
# DNS A 레코드 추가
api.lemonkorean.com -> Your-Server-IP
```

### 2. Let's Encrypt 설정
```bash
cd nginx
./setup-letsencrypt.sh api.lemonkorean.com admin@lemonkorean.com
```

### 3. nginx.conf 업데이트
```nginx
# server_name 변경
server_name api.lemonkorean.com;
```

### 4. 프로덕션 시작
```bash
docker-compose -f docker-compose.prod.yml up -d
```

---

## 성능 모니터링

### 실시간 통계
```bash
# 초당 요청 수
docker exec lemon-nginx tail -f /var/log/nginx/access.log | \
  pv -l -i 1 -r > /dev/null

# 응답 시간 분석
docker exec lemon-nginx awk '{print $NF}' /var/log/nginx/access.log | \
  awk -F'=' '{print $2}' | sort -n | tail -20
```

### 캐시 히트율
```bash
# 캐시 상태 통계
docker exec lemon-nginx grep "X-Cache-Status" /var/log/nginx/media_access.log | \
  awk '{print $NF}' | sort | uniq -c

# 예상 출력:
#   8500 HIT
#   1200 MISS
#    300 EXPIRED
# 히트율: 85% (8500/10000)
```

---

## 문제 해결

### Q: 429 Too Many Requests 에러
**A:** Rate limit 증가 또는 burst 조정
```nginx
limit_req zone=api_limit burst=100 nodelay;
```

### Q: 502 Bad Gateway
**A:** Upstream 서비스 확인
```bash
docker-compose ps
docker-compose logs auth-service
```

### Q: SSL 인증서 에러
**A:** 인증서 확인 및 갱신
```bash
openssl x509 -in ssl/fullchain.pem -noout -dates
sudo certbot renew
```

### Q: 캐시가 작동하지 않음
**A:** 캐시 디렉토리 권한 확인
```bash
docker exec lemon-nginx ls -la /var/cache/nginx/
docker exec lemon-nginx chown -R nginx:nginx /var/cache/nginx/
```

---

## 다음 단계

1. **개발 환경 테스트**: `./test-endpoints.sh`
2. **프로덕션 배포**: Let's Encrypt 설정
3. **모니터링 설정**: Prometheus + Grafana
4. **CDN 통합**: CloudFlare 또는 AWS CloudFront
5. **WAF 추가**: ModSecurity 또는 Cloudflare WAF

---

## 지원

문제가 있으면 다음을 확인하세요:
1. `docker-compose logs nginx`
2. `docker exec nginx nginx -t`
3. `/var/log/nginx/error.log`
