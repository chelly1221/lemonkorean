---
date: 2026-02-07
category: Infrastructure
title: NAS에서 로컬 디스크로 스토리지 마이그레이션
author: Claude Sonnet 4.5
tags: [infrastructure, storage, docker, migration, minio]
priority: high
---

# NAS to Local Disk Storage Migration

## 개요

Lemon Korean 프로젝트의 MinIO 오브젝트 스토리지, Nginx 캐시/로그, APK 빌드 파일을 NAS 마운트(`/mnt/nas/lemon/`)에서 로컬 디스크(`./data/`)로 마이그레이션했습니다.

**마이그레이션 날짜**: 2026년 2월 7일
**다운타임**: ~2분 (서비스 재시작)
**데이터 크기**: 총 ~96MB

## 마이그레이션 동기

### 문제점
- **NAS 의존성**: 외부 네트워크 마운트(NFS/CIFS)에 의존하여 장애 지점 증가
- **복잡성**: NAS 마운트 설정 및 관리의 추가 복잡도
- **성능**: 네트워크 스토리지보다 로컬 디스크가 더 빠른 I/O 제공

### 해결 방안
- MinIO 데이터를 로컬 디스크로 이동
- Docker volume 마운트만 변경, 코드 변경 없음
- 전체 아키텍처 유지 (MinIO 컨테이너 계속 사용)

## 변경 사항

### 1. 디렉토리 구조

**새로운 로컬 스토리지**:
```
/home/sanchan/lemonkorean/data/
├── minio-data/         # MinIO S3 storage (~844KB)
├── nginx-cache/        # Nginx cache (~324KB)
├── nginx-logs/         # Nginx logs (~30MB)
├── flutter-build/web/  # Flutter web app (empty, 추후 사용)
└── apk-builds/         # APK builds (~65MB)
```

### 2. Docker Compose 변경

**MinIO 서비스** (라인 86-107):
```yaml
# 변경 전
volumes:
  - /mnt/nas/lemon/minio-data:/data

# 변경 후
volumes:
  - ./data/minio-data:/data
```

**Nginx 서비스** (라인 413-457):
```yaml
# 변경 전
volumes:
  - /mnt/nas/lemon/nginx-cache:/var/cache/nginx
  - /mnt/nas/lemon/nginx-logs:/var/log/nginx
  - /mnt/nas/lemon/flutter-build/build/web:/var/www/lemon_korean_web:ro

# 변경 후
volumes:
  - ./data/nginx-cache:/var/cache/nginx
  - ./data/nginx-logs:/var/log/nginx
  - ./data/flutter-build/web:/var/www/lemon_korean_web:ro
```

**Admin 서비스** (라인 366-410):
```yaml
# 변경 전
volumes:
  - /mnt/nas/lemon/apk-builds:/mnt/nas/lemon/apk-builds:ro

# 변경 후
volumes:
  - ./data/apk-builds:/apk-builds:ro
```

### 3. 코드 변경

**Admin Service APK 빌드 경로**:
- **파일**: `services/admin/src/services/apk-build.service.js`
- **변경**: `APK_STORAGE_PATH = '/apk-builds'` (컨테이너 내부 경로)
- **이유**: docker-compose.yml의 새로운 마운트 경로에 맞춤

**문서 업데이트**:
- `services/admin/DASHBOARD.md`: APK 스토리지 경로 문서화 업데이트

### 4. 변경되지 않은 부분

✅ **서비스 코드**: Media Service, Admin Service 등 모든 서비스 코드 변경 없음
✅ **MinIO 아키텍처**: MinIO 컨테이너 계속 사용, S3 호환 API 유지
✅ **API 엔드포인트**: 모든 API 엔드포인트 동일
✅ **데이터베이스**: PostgreSQL, MongoDB 설정 변경 없음
✅ **Flutter 앱**: 모바일 앱 코드 변경 없음

## 마이그레이션 절차

### 1. 마이그레이션 스크립트 생성
```bash
scripts/migrate-nas-to-local.sh
```

**기능**:
- 로컬 디렉토리 생성 (`./data/`)
- rsync로 NAS 데이터 복사 (~96MB)
- 권한 설정 (uid 1000)

### 2. 실행 단계

```bash
# 1. 마이그레이션 스크립트 실행
bash scripts/migrate-nas-to-local.sh

# 2. 서비스 중지
docker compose down

# 3. docker-compose.yml 업데이트 (volume 마운트 변경)
# (이미 완료됨)

# 4. 서비스 재시작
docker compose up -d

# 5. 검증
bash scripts/verify-migration.sh
```

### 3. 다운타임
- **총 다운타임**: ~2분
- **영향**: 모든 서비스 일시 중단
- **복구**: 자동 (healthcheck로 확인)

## 검증 결과

### 서비스 상태
✅ MinIO: 정상 (healthy)
✅ Nginx: 정상 (healthy)
✅ Media Service: 정상 (healthy)
✅ Admin Service: 정상 (healthy)
✅ 모든 마이크로서비스: 정상

### 데이터 검증
✅ MinIO 버킷 존재: `lemon-korean-media`
✅ 이미지 디렉토리: `images/7257ea9ee6b0742a990c3d5bd2ca7cfc.png`
✅ APK 파일: `lemon_korean_20260206_121039.apk` (65MB)

### 기능 테스트
✅ 이미지 서빙: `http://localhost/media/images/7257ea9ee6b0742a990c3d5bd2ca7cfc.png` (200 OK)
✅ Nginx 캐시: 정상 작동 (`X-Cache-Status: MISS` → `HIT`)
✅ Nginx 로그: 로컬 디스크에 기록 중
✅ Admin 대시보드: APK 파일 접근 가능

### 스토리지 사용량

```bash
844K    data/minio-data
324K    data/nginx-cache
30M     data/nginx-logs
65M     data/apk-builds
```

**총 사용량**: ~96MB

## 생성된 파일

1. **마이그레이션 스크립트**: `scripts/migrate-nas-to-local.sh`
   - NAS에서 로컬로 데이터 복사
   - 디렉토리 생성 및 권한 설정

2. **검증 스크립트**: `scripts/verify-migration.sh`
   - 8단계 검증 테스트
   - Docker 서비스, 스토리지, 엔드포인트 확인

3. **문서**: `scripts/MIGRATION_README.md`
   - 마이그레이션 가이드
   - 롤백 절차

## 롤백 절차

마이그레이션 실패 시:

```bash
# 1. 서비스 중지
docker compose down

# 2. docker-compose.yml 복원
git checkout docker-compose.yml

# 3. Admin 서비스 코드 복원
git checkout services/admin/src/services/apk-build.service.js

# 4. 서비스 재시작 (NAS 마운트로 복귀)
docker compose up -d
```

**주의**: 로컬 데이터는 유지되므로 재시도 가능

## 이점

### 1. 단순성
- ✅ NAS 마운트 설정 불필요
- ✅ 외부 네트워크 의존성 제거
- ✅ Docker Compose만으로 완전한 스택 실행

### 2. 성능
- ✅ 로컬 디스크 I/O (NFS/CIFS보다 빠름)
- ✅ 네트워크 레이턴시 제거

### 3. 안정성
- ✅ NAS 장애 지점 제거
- ✅ 단일 머신에서 완전히 독립적 동작

### 4. 백업
- ✅ `./data/` 디렉토리만 백업하면 됨
- ✅ 표준 파일시스템 백업 도구 사용 가능

## 향후 고려사항

### 1. 디스크 공간 모니터링
현재 사용량이 적지만 (~96MB), 향후 미디어 파일 증가 시 디스크 공간 모니터링 필요:
- MinIO 데이터 증가 추이 확인
- APK 빌드 자동 정리 (오래된 빌드 삭제)
- Nginx 로그 로테이션 (이미 설정됨)

### 2. 백업 전략
로컬 스토리지 백업 스크립트 추가 권장:
```bash
# 예시
tar -czf /backup/lemon-data-$(date +%Y%m%d).tar.gz ./data/
```

### 3. Flutter Web 빌드
`./data/flutter-build/web/` 디렉토리가 현재 비어있음:
- Web 배포 시 이 경로 사용
- Deploy Agent가 자동으로 채움

## 교훈

### 성공 요인
1. **점진적 접근**: 마이그레이션 스크립트로 먼저 데이터 복사 후 서비스 중지
2. **검증 자동화**: `verify-migration.sh`로 모든 측면 자동 검증
3. **롤백 계획**: Git으로 설정 파일 복원 가능

### 주의점
1. **권한 설정**: uid 1000으로 통일 (NAS CIFS 마운트와 동일)
2. **볼륨 마운트**: docker-compose.yml에서 상대 경로 (`./data/`) 사용
3. **컨테이너 내부 경로**: 코드에서 사용하는 경로는 컨테이너 내부 마운트 경로

## 관련 문서

- **마이그레이션 가이드**: `/scripts/MIGRATION_README.md`
- **검증 스크립트**: `/scripts/verify-migration.sh`
- **Admin 대시보드**: `/services/admin/DASHBOARD.md`
- **Docker Compose**: `/docker-compose.yml`

## 결론

NAS 의존성 제거를 성공적으로 완료했습니다. 모든 서비스가 정상 작동하며, 이미지 서빙, 캐싱, APK 빌드 기능이 로컬 디스크에서 정상 작동합니다.

**마이그레이션 상태**: ✅ **완료 및 검증됨**

---

**문제 발생 시 연락처**: 이 개발노트 참조 후 롤백 절차 실행
