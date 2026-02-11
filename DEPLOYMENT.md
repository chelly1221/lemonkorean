# 프로덕션 배포 가이드

Lemon Korean 애플리케이션을 프로덕션 환경에 배포하는 종합 가이드.

## 목차

1. [시스템 요구사항](#시스템-요구사항)
2. [서버 준비](#서버-준비)
3. [도메인 및 DNS 설정](#도메인-및-dns-설정)
4. [SSL/TLS 인증서](#ssltls-인증서)
5. [환경 변수 설정](#환경-변수-설정)
6. [배포 실행](#배포-실행)
7. [배포 후 검증](#배포-후-검증)
8. [모니터링 설정](#모니터링-설정)
9. [백업 설정](#백업-설정)
10. [보안 강화](#보안-강화)

---

## 시스템 요구사항

### 최소 사양
- **CPU**: 4 cores
- **RAM**: 8 GB
- **Storage**: 100 GB SSD
- **Network**: 100 Mbps

### 권장 사양
- **CPU**: 8 cores
- **RAM**: 16 GB
- **Storage**: 200 GB NVMe SSD
- **Network**: 1 Gbps

### OS
- Ubuntu 22.04 LTS (권장)
- Debian 11+
- CentOS 8+

### 소프트웨어
```bash
Docker 24.0+
Docker Compose 2.20+
Git 2.34+
Nginx (선택, 추가 reverse proxy용)
```

---

## 서버 준비

### 1. 서버 초기 설정

```bash
# 시스템 업데이트
sudo apt update && sudo apt upgrade -y

# 필수 패키지 설치
sudo apt install -y \
  curl \
  wget \
  git \
  ufw \
  fail2ban \
  htop \
  net-tools

# 타임존 설정
sudo timedatectl set-timezone Asia/Seoul
```

### 2. Docker 설치

```bash
# Docker 공식 GPG 키 추가
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Docker 저장소 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker 설치
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Docker 사용자 그룹 추가
sudo usermod -aG docker $USER

# Docker 자동 시작 설정
sudo systemctl enable docker
sudo systemctl start docker

# 설치 확인
docker --version
docker compose version
```

### 3. 방화벽 설정

```bash
# UFW 기본 정책
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 필수 포트 허용
sudo ufw allow ssh
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS

# 방화벽 활성화
sudo ufw enable

# 상태 확인
sudo ufw status
```

### 4. 프로젝트 디렉토리 생성

```bash
# 프로젝트 디렉토리
sudo mkdir -p /opt/lemon-korean
sudo chown $USER:$USER /opt/lemon-korean
cd /opt/lemon-korean

# 저장소 클론
git clone https://github.com/username/lemonkorean.git .
```

---

## 도메인 및 DNS 설정

### 1. 도메인 구입

- Namecheap, GoDaddy, CloudFlare 등에서 도메인 구매
- 예: `lemonkorean.com`

### 2. DNS 레코드 설정

| Type | Name | Value | TTL |
|------|------|-------|-----|
| A | @ | `YOUR_SERVER_IP` | 3600 |
| A | www | `YOUR_SERVER_IP` | 3600 |
| A | api | `YOUR_SERVER_IP` | 3600 |
| CNAME | media | api.lemonkorean.com | 3600 |

### 3. DNS 전파 확인

```bash
# DNS 레코드 확인
dig lemonkorean.com
dig api.lemonkorean.com

# 또는 nslookup
nslookup api.lemonkorean.com
```

---

## SSL/TLS 인증서

### Let's Encrypt 사용 (권장)

#### 1. Certbot 설치

```bash
sudo apt install -y certbot python3-certbot-nginx
```

#### 2. 인증서 발급

```bash
# 도메인 인증서 발급
sudo certbot certonly --standalone \
  -d lemonkorean.com \
  -d www.lemonkorean.com \
  -d api.lemonkorean.com \
  --email admin@lemonkorean.com \
  --agree-tos \
  --no-eff-email

# 인증서 위치
# /etc/letsencrypt/live/lemonkorean.com/fullchain.pem
# /etc/letsencrypt/live/lemonkorean.com/privkey.pem
```

#### 3. Nginx SSL 설정 업데이트

```bash
# nginx.conf에서 SSL 인증서 경로 수정
sudo mkdir -p nginx/ssl
sudo ln -s /etc/letsencrypt/live/lemonkorean.com/fullchain.pem nginx/ssl/fullchain.pem
sudo ln -s /etc/letsencrypt/live/lemonkorean.com/privkey.pem nginx/ssl/privkey.pem
```

#### 4. 자동 갱신 설정

```bash
# Certbot 자동 갱신 테스트
sudo certbot renew --dry-run

# Cron job 확인 (자동 생성됨)
sudo systemctl status certbot.timer

# 수동으로 cron 추가 (필요시)
sudo crontab -e
# 매일 새벽 3시 갱신 시도
0 3 * * * certbot renew --quiet --post-hook "docker-compose -f /opt/lemon-korean/docker-compose.yml restart nginx"
```

---

## 환경 변수 설정

### 1. `.env` 파일 생성

```bash
cd /opt/lemon-korean
cp .env.example .env
nano .env
```

### 2. 프로덕션 환경 변수

```.env
# ================================================================
# PRODUCTION ENVIRONMENT VARIABLES
# ================================================================

# Database - PostgreSQL
# Note: Dev uses 3chan, prod uses lemon_admin
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=lemon_korean
POSTGRES_USER=lemon_admin
POSTGRES_PASSWORD=REPLACE_WITH_STRONG_PASSWORD_HERE

# Database - MongoDB
MONGODB_URI=mongodb://lemon_admin:REPLACE_WITH_STRONG_PASSWORD@mongo:27017/lemon_korean?authSource=admin

# Database - Redis
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_PASSWORD=REPLACE_WITH_STRONG_PASSWORD

# JWT Authentication
JWT_SECRET=REPLACE_WITH_RANDOM_64_CHAR_STRING
JWT_EXPIRES_IN=7d

# MinIO (S3 Storage)
MINIO_ACCESS_KEY=lemon_minio_admin
MINIO_SECRET_KEY=REPLACE_WITH_STRONG_PASSWORD
MINIO_BUCKET=lemon-korean-media
MINIO_USE_SSL=false

# RabbitMQ
RABBITMQ_PASSWORD=REPLACE_WITH_STRONG_PASSWORD

# LiveKit (Voice Rooms)
LIVEKIT_API_KEY=your_api_key
LIVEKIT_API_SECRET=your_api_secret
LIVEKIT_URL=wss://livekit.your-domain.com

# Redis (Socket.IO, DM online status, deployment locks)
REDIS_URL=redis://redis:6379

# Service Ports
AUTH_SERVICE_PORT=3001
CONTENT_SERVICE_PORT=3002
PROGRESS_SERVICE_PORT=3003
MEDIA_SERVICE_PORT=3004
ANALYTICS_SERVICE_PORT=3005
ADMIN_SERVICE_PORT=3006

# Application
NODE_ENV=production
API_BASE_URL=https://api.lemonkorean.com
CORS_ORIGIN=https://lemonkorean.com,https://www.lemonkorean.com

# Logging
LOG_LEVEL=info

# Backup
BACKUP_DIR=/opt/lemon-korean/backups
```

### 3. 보안 강화

```bash
# .env 파일 권한 제한
chmod 600 .env

# 소유자만 읽기/쓰기 가능
ls -l .env
# -rw------- 1 user user 1234 Jan 28 10:00 .env
```

### 4. 강력한 비밀번호 생성

```bash
# 랜덤 비밀번호 생성 (64자)
openssl rand -base64 48

# JWT Secret 생성
openssl rand -hex 32
```

---

## 배포 실행

### 1. 프로덕션 Docker Compose

```bash
cd /opt/lemon-korean

# Docker Compose 설정 확인
docker compose config

# 이미지 빌드 (처음 한 번만)
docker compose build

# 컨테이너 시작
docker compose up -d

# 상태 확인
docker compose ps
```

### 2. 데이터베이스 초기화

```bash
# PostgreSQL 스키마 적용 (자동으로 실행됨)
# 수동 확인
docker compose exec postgres psql -U lemon_admin -d lemon_korean -c "\dt"

# MongoDB 초기 데이터 (필요시)
# docker compose exec mongo mongosh ...
```

### 3. 헬스체크

```bash
# 각 서비스 헬스체크
curl http://localhost/health
curl http://localhost:3001/health  # Auth
curl http://localhost:3002/health  # Content
curl http://localhost:3003/health  # Progress
curl http://localhost:3004/health  # Media
curl http://localhost:3005/health  # Analytics
curl http://localhost:3007/health  # SNS
# Admin은 nginx를 통해 접근: https://lemon.3chan.kr/admin/
```

### 4. LiveKit 설정 (음성 대화방)

음성 대화방 기능은 LiveKit을 사용합니다.

**네트워크 모드**: LiveKit은 `network_mode: host`로 실행됩니다. 호스트 네트워크 모드에서는 Docker 포트 매핑이 불필요하며, LiveKit이 직접 호스트 네트워크 인터페이스를 사용합니다.

**TURN 서버**: 비활성화됨. 대부분의 클라이언트가 직접 UDP 연결을 사용하므로 TURN relay는 사용하지 않습니다.

```bash
# LiveKit 서버 (호스트 네트워크 모드)
# 설정 파일: config/livekit/livekit.yaml
# 포트: 7880 (HTTP), 7881 (RTC/TCP), 50000-50200/udp (RTC 미디어)

# 방화벽에 LiveKit 포트 추가
sudo ufw allow 7880/tcp        # LiveKit HTTP API
sudo ufw allow 7881/tcp        # LiveKit RTC (TCP)
sudo ufw allow 50000:50200/udp # LiveKit RTC 미디어 (UDP)

# 환경변수 확인
echo $LIVEKIT_API_KEY
echo $LIVEKIT_URL
```

### 5. Socket.IO WebSocket 설정

SNS 서비스의 Socket.IO는 WebSocket 연결을 사용합니다. Nginx에서 WebSocket upgrade 설정이 필요합니다.

```nginx
# nginx.conf - Socket.IO WebSocket proxy
location /api/sns/socket.io {
    proxy_pass http://sns_service;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_read_timeout 86400;
}
```

---

## 배포 후 검증

### 1. 서비스 연결 테스트

```bash
# API Gateway
curl -I https://api.lemonkorean.com/health

# 인증 테스트
curl -X POST https://api.lemonkorean.com/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Test123!@#"}'

# 레슨 목록 조회
curl https://api.lemonkorean.com/api/content/lessons
```

### 2. SSL 인증서 검증

```bash
# SSL 인증서 정보 확인
openssl s_client -connect api.lemonkorean.com:443 -servername api.lemonkorean.com

# SSL Labs 테스트
# https://www.ssllabs.com/ssltest/analyze.html?d=api.lemonkorean.com
```

### 3. 로그 확인

```bash
# 전체 로그
docker compose logs -f

# 특정 서비스 로그
docker compose logs -f auth-service
docker compose logs -f nginx

# 최근 100줄
docker compose logs --tail=100
```

### 4. 성능 테스트

```bash
# Apache Bench
ab -n 1000 -c 10 https://api.lemonkorean.com/health

# 또는 hey
hey -n 1000 -c 10 https://api.lemonkorean.com/health
```

---

## 모니터링 설정

### 1. Prometheus + Grafana (선택)

Task #3에서 구현 예정.

### 2. 로그 모니터링

```bash
# 실시간 에러 로그 모니터링
docker compose logs -f | grep -i error

# 에러 개수
docker compose logs --since 1h | grep -i error | wc -l
```

### 3. 리소스 모니터링

```bash
# Docker 컨테이너 리소스 사용량
docker stats

# 시스템 리소스
htop
df -h
free -h
```

### 4. Uptime 모니터링

무료 서비스 사용:
- [UptimeRobot](https://uptimerobot.com)
- [StatusCake](https://www.statuscake.com)
- [Pingdom](https://www.pingdom.com)

---

## 백업 설정

```bash
# 백업 스크립트 설정
cd /opt/lemon-korean
bash scripts/backup/setup-cron.sh

# 수동 백업 테스트
bash scripts/backup/backup-all.sh

# 백업 파일 확인
ls -lh backups/postgres/daily/
ls -lh backups/mongodb/daily/
```

자세한 내용은 `scripts/backup/README.md` 참조.

---

## 보안 강화

### 1. Fail2Ban 설정

```bash
# Fail2Ban 설치
sudo apt install -y fail2ban

# SSH 보호 설정
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local

# [sshd] 섹션
[sshd]
enabled = true
maxretry = 3
bantime = 3600

# 서비스 재시작
sudo systemctl restart fail2ban
sudo systemctl status fail2ban
```

### 2. SSH 강화

```bash
# SSH 설정 수정
sudo nano /etc/ssh/sshd_config

# 권장 설정
PermitRootLogin no
PasswordAuthentication no
PubkeyAuthentication yes
Port 2222  # 기본 포트 변경

# SSH 재시작
sudo systemctl restart sshd

# 방화벽 업데이트
sudo ufw allow 2222/tcp
sudo ufw delete allow 22/tcp
```

### 3. 자동 보안 업데이트

```bash
# Unattended upgrades 설치
sudo apt install -y unattended-upgrades

# 설정
sudo dpkg-reconfigure -plow unattended-upgrades
```

### 4. 관리자 API IP 화이트리스트

nginx.conf에서 Admin API 접근 제한:

```nginx
location /api/admin/ {
    # Office IP
    allow 203.0.113.5;

    # VPN
    allow 10.0.0.0/8;

    # Deny all others
    deny all;

    proxy_pass http://admin_service;
}
```

---

## 문제 해결

### 컨테이너 시작 실패

```bash
# 로그 확인
docker compose logs <service-name>

# 개별 컨테이너 디버깅
docker run -it --rm lemon-korean-auth-service sh

# 환경 변수 확인
docker compose config | grep -A 10 environment
```

### 데이터베이스 연결 실패

```bash
# PostgreSQL 연결 테스트
docker compose exec postgres psql -U lemon_admin -d lemon_korean

# 연결 문자열 테스트
docker compose exec auth-service sh -c 'echo $DATABASE_URL'
```

### SSL 인증서 문제

```bash
# 인증서 갱신
sudo certbot renew --force-renewal

# Nginx 재시작
docker compose restart nginx
```

### 디스크 공간 부족

```bash
# Docker 정리
docker system prune -a --volumes

# 로그 파일 정리
sudo find /var/log -type f -name "*.log" -mtime +30 -delete

# 백업 파일 정리 (30일 이상)
find backups/ -type f -mtime +30 -delete
```

---

## 업데이트 및 롤백

### 애플리케이션 업데이트

```bash
cd /opt/lemon-korean

# 백업 생성
bash scripts/backup/backup-all.sh

# 최신 코드 가져오기
git fetch origin
git pull origin main

# 이미지 다시 빌드
docker compose build

# 무중단 재시작
docker compose up -d --force-recreate --no-deps <service-name>

# 또는 전체 재시작
docker compose down && docker compose up -d
```

### 롤백

```bash
# 이전 커밋으로 롤백
git log --oneline -n 10
git checkout <previous-commit-hash>
docker compose up -d --force-recreate
```

---

## 성능 최적화

### 1. Docker 리소스 제한

docker-compose.yml에 추가:

```yaml
services:
  auth-service:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M
```

### 2. Nginx 캐싱

이미 nginx.conf에 설정되어 있음:
- 미디어: 7일 캐싱
- API: 1시간 캐싱

### 3. 데이터베이스 최적화

```bash
# PostgreSQL 자동 vacuum 설정 확인
docker compose exec postgres psql -U lemon_admin -d lemon_korean \
  -c "SHOW autovacuum;"

# 인덱스 확인
docker compose exec postgres psql -U lemon_admin -d lemon_korean \
  -c "SELECT * FROM pg_indexes WHERE schemaname = 'public';"
```

---

## 체크리스트

배포 전:
- [ ] 서버 사양 확인
- [ ] 도메인 구입 및 DNS 설정
- [ ] SSL 인증서 발급
- [ ] 환경 변수 설정 (`.env`)
- [ ] 방화벽 설정
- [ ] 백업 전략 수립

배포:
- [ ] Docker 이미지 빌드
- [ ] 컨테이너 시작
- [ ] 데이터베이스 마이그레이션
- [ ] 헬스체크 통과

배포 후:
- [ ] SSL 인증서 검증
- [ ] API 엔드포인트 테스트
- [ ] 백업 자동화 설정
- [ ] 모니터링 설정
- [ ] 보안 강화 (Fail2Ban, SSH)
- [ ] LiveKit 서버 상태 확인 (포트 7880/7881, UDP 50000-50200)
- [ ] Socket.IO WebSocket 연결 테스트 (`/api/sns/socket.io`)
- [ ] DM 메시지 전송/수신 테스트
- [ ] 문서화

---

## 웹 앱 배포 (Flutter Web)

### 방법 1: 자동 배포 (권장) (2026-02-04)

Admin Dashboard를 통한 원클릭 배포:

1. **Admin Dashboard 접속**: https://lemon.3chan.kr/admin/
2. **Web Deployment 메뉴** 클릭 (`#/deploy`)
3. **"Start Deployment" 버튼** 클릭
4. **실시간 진행률** 및 로그 확인 (9-10분 소요)
5. **완료 확인** - 배포 성공 알림

**자동화된 프로세스**:
- Git pull (최신 코드)
- Flutter pub get (의존성)
- Flutter build web (빌드)
- 파일 복사 (nginx 디렉토리)
- Nginx 재시작
- 배포 검증

**장점**:
- 웹 UI에서 원클릭 배포
- 실시간 로그 스트리밍
- 배포 이력 추적
- 오류 자동 감지
- Redis 락으로 동시 배포 방지

**API 엔드포인트**:
- POST `/api/admin/deploy/web/start`
- GET `/api/admin/deploy/web/status/:id`
- GET `/api/admin/deploy/web/logs/:id`

### 방법 2: 수동 배포

로컬 환경에서 직접 빌드:

```bash
cd mobile/lemon_korean

# 웹 앱 빌드 (약 9-10분 소요)
./build_web.sh

# 또는 수동 빌드
flutter build web --release --base-href=/app/ --web-renderer=canvaskit

# Nginx 재시작 (Docker 볼륨으로 자동 반영)
docker compose restart nginx
```

### 데이터베이스 마이그레이션

웹 배포 관련 마이그레이션 순서:

```bash
# 1. 언어 기본값 변경 (zh → ko)
psql -U 3chan -d lemon_korean -f database/postgres/migrations/004_update_language_defaults_to_korean.sql

# 2. 앱 테마 설정 테이블 추가
psql -U 3chan -d lemon_korean -f database/postgres/migrations/005_add_app_theme_settings.sql

# 3. 디자인 설정 제거 (선택)
psql -U 3chan -d lemon_korean -f database/postgres/migrations/006_remove_design_settings.sql

# 4. 게임화 테이블 추가
psql -U 3chan -d lemon_korean -f database/postgres/migrations/008_add_gamification_tables.sql
psql -U 3chan -d lemon_korean -f database/postgres/migrations/009_add_gamification_settings.sql

# 5. SNS 테이블 추가
psql -U 3chan -d lemon_korean -f database/postgres/migrations/010_add_sns_tables.sql

# 6. DM 테이블 추가
psql -U 3chan -d lemon_korean -f database/postgres/migrations/011_add_dm_tables.sql

# 7. 음성 대화방 테이블 추가
psql -U 3chan -d lemon_korean -f database/postgres/migrations/012_add_voice_rooms.sql

# 8. 캐릭터 커스터마이징 시스템 (2026-02-11)
psql -U 3chan -d lemon_korean -f database/postgres/migrations/013_add_character_system.sql

# 9. 음성 대화방 무대/청중 시스템 (2026-02-11)
psql -U 3chan -d lemon_korean -f database/postgres/migrations/014_voice_room_stage_system.sql

# 10. 한글 SRS 반복 횟수 추적 (2026-02-11)
psql -U 3chan -d lemon_korean -f database/postgres/migrations/015_add_hangul_repetition_count.sql
```

### 배포 URL
- **프로덕션**: https://lemon.3chan.kr/app/
- **로컬 테스트**: http://localhost/app/

### 웹 앱 제한사항
- 오프라인 다운로드 미지원 (항상 온라인)
- localStorage 5-10MB 제한
- 미디어 파일은 CDN에서 직접 로드

### 트러블슈팅

**자동 배포 실패**:
```bash
# Redis 락 확인
docker exec lemon-redis redis-cli GET deployment:web:lock

# 강제 언락 (긴급 시에만)
docker exec lemon-redis redis-cli DEL deployment:web:lock

# Admin 서비스 로그 확인
docker logs lemon-admin-service
```

**수동 빌드 실패**:
```bash
# Flutter 캐시 정리
cd mobile/lemon_korean
flutter clean
flutter pub get

# 재빌드
./build_web.sh
```

자세한 내용: `/mobile/lemon_korean/WEB_DEPLOYMENT_GUIDE.md`

---

## Nginx 캐시 설정

### 캐시 디렉토리 권한 (UID 1000)

Docker 컨테이너에서 Nginx 캐시 권한 문제 발생 시:

```bash
# 캐시 디렉토리 권한 설정
sudo chown -R 1000:1000 nginx/cache/

# 또는 docker-compose.yml에서 user 지정
nginx:
  user: "1000:1000"
```

---

## 데이터베이스 사용자

| 환경 | PostgreSQL 사용자 | 비고 |
|------|-------------------|------|
| 개발 | 3chan | 기본 개발 계정 |
| 프로덕션 | lemon_admin | 보안 강화된 계정 |

`.env` 파일에서 `POSTGRES_USER` 확인 필요.

---

## 추가 리소스

- [Docker 공식 문서](https://docs.docker.com/)
- [Let's Encrypt 문서](https://letsencrypt.org/docs/)
- [Nginx 최적화](https://www.nginx.com/blog/tuning-nginx/)
- [Ubuntu 서버 가이드](https://ubuntu.com/server/docs)

## 지원

배포 관련 문의:
- Email: devops@lemonkorean.com
- GitHub Issues: https://github.com/username/lemonkorean/issues
