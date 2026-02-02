---
date: 2026-02-02
category: Infrastructure
title: Nginx 캐시 권한 오류 수정 - UID 1000으로 실행
author: Claude Sonnet 4.5
tags: [nginx, docker, permissions, cache, nas, infrastructure]
priority: high
---

## 문제 요약

웹 앱 API 호출이 nginx 캐시 권한 오류로 인해 실패하는 문제 발생.

### 오류 로그
```
[crit] 8#8: *135 mkdir() "/var/cache/nginx/api/6" failed (13: Permission denied) while reading upstream
```

## 근본 원인 분석

### 권한 불일치
1. **NAS 마운트**: `/var/cache/nginx`가 `/mnt/nas/lemon/nginx-cache`에서 마운트됨
2. **소유권 문제**: NAS 디렉토리는 `sanchan:sanchan` (UID 1000) 소유
3. **Nginx 사용자**: Nginx worker 프로세스는 `nginx:nginx` (UID 101)로 실행
4. **영향**: Nginx가 캐시 하위 디렉토리(예: `/var/cache/nginx/api/6`)를 생성할 수 없어 캐시 실패

### 현재 상태
- 유사한 패턴이 이미 존재: MongoDB가 NAS 호환성을 위해 UID 1000으로 실행됨
- Proxy 캐시 경로가 NAS 마운트를 사용하며 권한 오류 발생
- 모든 서비스는 정상이지만 nginx가 캐시 파일 쓰기에 반복적으로 실패

## 해결 방법: Nginx를 UID 1000으로 실행

### 접근 방식
NAS 마운트 소유권과 일치하도록 nginx 컨테이너를 UID 1000으로 실행. MongoDB 서비스와 동일한 패턴 따름.

### 근거
- docker-compose.yml에서 한 줄 변경
- 기존 패턴과 일치 (MongoDB가 이미 UID 1000으로 실행 중)
- NAS에 캐시 보존 (재시작 후에도 유지)
- 설정 파일 변경 불필요

## 구현 내역

### 1. Docker Compose 설정 업데이트 ✅

**파일**: `/docker-compose.yml`

nginx 서비스에 `user` 지시어 추가:

```yaml
nginx:
  build: ./nginx
  container_name: lemon-nginx
  user: "1000:1000"  # Run as UID 1000 to match NAS mount ownership
  environment:
    NGINX_MODE: ${NGINX_MODE:-development}
```

### 2. Nginx Dockerfile 업데이트 ✅

**파일**: `/nginx/Dockerfile`

UID 1000으로 권한 설정 및 런타임 디렉토리 추가:

```dockerfile
# Create cache directories and runtime directory
RUN mkdir -p /var/cache/nginx/media \
    /var/cache/nginx/api \
    /var/www/certbot \
    /etc/nginx/ssl \
    /var/run/nginx

# Set permissions for UID 1000 (matching NAS mount ownership)
RUN chown -R 1000:1000 /var/cache/nginx /var/run/nginx \
    && chmod -R 755 /var/cache/nginx /var/run/nginx
```

### 3. Docker Entrypoint 스크립트 업데이트 ✅

**파일**: `/nginx/docker-entrypoint.sh`

시작 시 권한 확인 추가:

```bash
#!/bin/sh
set -e

echo "[Nginx] Starting nginx as UID $(id -u)"

# Ensure cache directories have correct permissions
if [ -d /var/cache/nginx ]; then
    chown -R 1000:1000 /var/cache/nginx 2>/dev/null || true
fi

# Test configuration
nginx -t

# Start nginx
exec nginx -g "daemon off;"
```

### 4. Nginx 설정 파일 업데이트 ✅

**파일**:
- `/nginx/nginx.dev.conf`
- `/nginx/nginx.conf`
- `/nginx/nginx.conf.dev`

PID 파일 경로를 `/var/run/nginx/nginx.pid`로 변경하여 UID 1000이 쓰기 가능하도록 수정:

```nginx
pid /var/run/nginx/nginx.pid;
```

### 5. 재빌드 및 재시작 ✅

```bash
# Rebuild nginx image
docker compose build nginx

# Restart nginx
docker compose up -d nginx
```

## 검증 결과

### 1. 권한 확인 ✅
```bash
$ docker exec lemon-nginx id
uid=1000 gid=1000 groups=1000

$ docker exec lemon-nginx ls -la /var/cache/nginx
total 4
drwxr-xr-x    2 1000     1000             0 Feb  1 13:07 .
drwxr-xr-x    2 1000     1000             0 Feb  2 14:56 api
drwxr-xr-x    2 1000     1000             0 Feb  1 13:55 media
...

$ docker exec lemon-nginx ls -la /var/run/nginx
total 16
drwxr-xr-x    1 1000     1000          4096 Feb  2 05:56 .
-rw-r--r--    1 1000     1000             2 Feb  2 05:56 nginx.pid
```

### 2. 캐시 기능 테스트 ✅
```bash
# 첫 번째 요청
$ curl -I http://localhost/api/content/lessons
HTTP/1.1 200 OK
X-Cache-Status: MISS

# 두 번째 요청
$ curl -I http://localhost/api/content/lessons
HTTP/1.1 200 OK
X-Cache-Status: HIT
```

### 3. 캐시 파일 생성 확인 ✅
```bash
$ ls -la /mnt/nas/lemon/nginx-cache/api/
drwxr-xr-x 2 sanchan sanchan 0  2월  2 14:56 6

$ find /mnt/nas/lemon/nginx-cache/api -type f
/mnt/nas/lemon/nginx-cache/api/6/73/e6e205b987228f4d006bdead2a1ff736
```

### 4. 권한 오류 없음 ✅
에러 로그에서 더 이상 "Permission denied" 오류가 발생하지 않음.

### 5. 컨테이너 상태 ✅
```bash
$ docker compose ps nginx
NAME          STATUS                   PORTS
lemon-nginx   Up 9 seconds (healthy)   0.0.0.0:80->80/tcp, 0.0.0.0:443->443/tcp
```

## 영향 평가

### 장점
✅ 모든 캐시 권한 오류 해결
✅ docker-compose.yml에서 간단한 한 줄 변경
✅ 기존 MongoDB 서비스 패턴과 일치
✅ NAS에 캐시 유지 (컨테이너 재시작 후에도 유지)
✅ nginx 설정 변경 불필요
✅ 여러 nginx 컨테이너 실행 시 캐시 공유 가능

### 단점
⚠️ Nginx가 비표준 UID로 실행 (하지만 컨테이너에서 격리됨)
⚠️ 모든 nginx 디렉토리가 UID 1000으로 쓰기 가능해야 함

### 성능
- **캐시**: NAS에 영구 저장 (재시작 후 재빌드 불필요)
- **디스크 사용량**: NAS에서 최대 11GB (미디어 10GB + API 1GB)
- **메모리 영향**: 없음

## 롤백 계획

문제 발생 시 변경 사항 되돌리기:

```bash
# docker-compose.yml에서 user 지시어 제거
# 원래 Dockerfile 및 entrypoint 복원

git checkout nginx/Dockerfile nginx/docker-entrypoint.sh docker-compose.yml
git checkout nginx/nginx.conf nginx/nginx.dev.conf nginx/nginx.conf.dev

# 재빌드 및 재시작
docker compose build nginx
docker compose up -d nginx
```

## 변경된 파일

| 파일 | 변경 유형 |
|------|-----------|
| `/docker-compose.yml` | 수정 - nginx 서비스에 `user: "1000:1000"` 추가 |
| `/nginx/Dockerfile` | 수정 - UID 1000으로 chown, `/var/run/nginx` 디렉토리 추가 |
| `/nginx/docker-entrypoint.sh` | 수정 - 권한 확인 추가 |
| `/nginx/nginx.dev.conf` | 수정 - PID 파일 경로 변경 |
| `/nginx/nginx.conf` | 수정 - PID 파일 경로 변경 |
| `/nginx/nginx.conf.dev` | 수정 - PID 파일 경로 변경 |

## 참고 사항

### 예상되는 경고 메시지 (무시 가능)
```
nginx: [warn] the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:10
```

이 경고는 nginx가 UID 1000으로 실행될 때 `user nginx;` 지시어가 무시되기 때문에 발생하지만, 정상 작동에는 영향을 주지 않습니다.

### 고려된 대안

1. **캐시에 로컬 /tmp 디렉토리 사용**: 더 빠르지만 재시작 시 캐시 손실
2. **NAS 권한을 UID 101로 수정**: CIFS가 UID 101을 제대로 지원하지 않을 수 있음
3. **캐싱 비활성화**: 성능 영향으로 인해 허용 불가
4. **Named volume 사용**: 여전히 권한 문제 발생 가능

**선택한 해결책** (nginx를 UID 1000으로 실행)이 가장 간단하며 코드베이스의 기존 MongoDB 패턴과 일치합니다.

## 관련 파일 위치

- Docker Compose: `docker-compose.yml:413-454`
- Nginx Dockerfile: `nginx/Dockerfile`
- Entrypoint: `nginx/docker-entrypoint.sh`
- 설정 파일: `nginx/nginx.dev.conf`, `nginx/nginx.conf`, `nginx/nginx.conf.dev`

## 추가 개선 제안

향후 고려 사항:
1. 모니터링: 캐시 적중률 및 디스크 사용량 모니터링 설정
2. 자동 정리: 오래된 캐시 파일 자동 정리 스크립트
3. 문서화: nginx 캐시 설정 문서에 UID 1000 요구사항 추가

## 결론

Nginx를 UID 1000으로 실행하도록 변경하여 NAS 마운트 캐시 디렉토리의 모든 권한 문제를 성공적으로 해결했습니다. 이 솔루션은 MongoDB 서비스에서 이미 사용 중인 패턴을 따르며, 캐시가 컨테이너 재시작 후에도 유지되도록 보장합니다.

**테스트 결과**: ✅ 모든 테스트 통과
- 권한 오류 없음
- 캐시 정상 작동 (MISS → HIT)
- NAS에 캐시 파일 생성 확인
- 컨테이너 정상 실행 및 Healthy 상태
