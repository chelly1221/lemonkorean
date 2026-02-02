---
date: 2026-02-02
category: Infrastructure
title: NAS 스토리지 마이그레이션
author: Claude Opus 4.5
tags: [nas, storage, docker, migration]
priority: high
---

# NAS 스토리지 마이그레이션

## 개요
로컬 디스크 공간 확보를 위해 프로젝트 데이터를 Asustor NAS (`/mnt/nas/lemon/`)로 이전.

## 완료된 작업

### 1. MinIO 데이터 이전
- **이전 위치**: Docker volume `lemon-minio-data`
- **현재 위치**: `/mnt/nas/lemon/minio-data/`
- **변경사항**: `docker-compose.yml`에서 바인드 마운트로 변경

### 2. MongoDB 데이터 이전
- **이전 위치**: Docker volume `lemon-mongo-data`
- **현재 위치**: `/mnt/nas/lemon/mongo-data/`
- **주의**: CIFS 마운트의 uid=1000 제한으로 인해 MongoDB가 `user: "1000:1000"`으로 실행됨

### 3. Nginx 로그/캐시 이전
- **이전 위치**: `./nginx/logs/`, `./nginx/cache/`
- **현재 위치**: `/mnt/nas/lemon/nginx-logs/`, `/mnt/nas/lemon/nginx-cache/`

### 4. Flutter 빌드 이전
- **이전 위치**: `./mobile/lemon_korean/build/` (2.3GB)
- **현재 위치**: `/mnt/nas/lemon/flutter-build/build/`
- **방법**: 심볼릭 링크 생성

## docker-compose.yml 변경사항

```yaml
# MongoDB - NAS 바인드 마운트 + uid 1000으로 실행
mongo:
  user: "1000:1000"
  volumes:
    - /mnt/nas/lemon/mongo-data:/data/db
    - mongo-log:/var/log/mongodb

# MinIO - NAS 바인드 마운트
minio:
  volumes:
    - /mnt/nas/lemon/minio-data:/data

# Nginx - NAS 바인드 마운트
nginx:
  volumes:
    - /mnt/nas/lemon/nginx-cache:/var/cache/nginx
    - /mnt/nas/lemon/nginx-logs:/var/log/nginx
    - /mnt/nas/lemon/flutter-build/build/web:/var/www/lemon_korean_web:ro
```

## 완료된 추가 작업

### fstab 설정
- `/root/.nascreds` 자격 증명 파일 생성됨
- `/etc/fstab`에 NAS 마운트 엔트리 추가됨
- 재부팅 후 자동 마운트 설정 완료

### Docker data-root 이전 시도
- CIFS 마운트의 forceuid/forcegid 제한으로 인해 PostgreSQL/Redis가 NAS에서 실행 불가
- Docker data-root는 로컬에 유지
- 대신 `docker system prune -af --volumes`로 5.4GB 확보

## 디스크 공간 변화
- **이전**: 88% (42GB/50GB)
- **이후**: 71% (34GB/50GB)
- **총 확보**: ~8GB (Flutter 빌드 2.3GB + Docker prune 5.4GB + 기타)

## 확인 체크리스트
- [x] MinIO 서비스 정상 (`curl localhost:3004/health`)
- [x] MongoDB 서비스 정상 (`curl localhost:3002/health`)
- [x] Nginx 서비스 정상 (`curl localhost/health`)
- [x] 웹 앱 접근 가능 (`https://lemon.3chan.kr/app/`)
- [x] fstab 설정 완료
- [ ] 재부팅 후 자동 마운트 확인 (권장)

## CIFS 마운트 제한사항
NAS CIFS 마운트는 `forceuid,forcegid` 옵션으로 모든 파일을 uid=1000으로 매핑함.
MongoDB처럼 다른 uid로 실행되는 서비스는 Docker의 `user:` 옵션으로 uid=1000으로 실행해야 함.
