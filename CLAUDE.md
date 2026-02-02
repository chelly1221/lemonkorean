# 柠檬韩语 (Lemon Korean) - 프로젝트 가이드

## 프로젝트 개요
중국어 화자를 위한 한국어 학습 앱. 오프라인 학습 지원, 마이크로서비스 아키텍처, 자체 호스팅.

**상태**: ✅ **프로덕션 준비 완료** (100%, 6/6 서비스)

**핵심 특징**: 오프라인 우선, SRS 복습, 7단계 레슨, 간체/번체 자동 변환, 6개 언어 지원

---

## 빠른 시작
```bash
# 서버
cp .env.example .env && docker-compose up -d

# Flutter 앱
cd mobile/lemon_korean && flutter pub get && flutter run

# 웹 빌드
flutter build web && docker compose restart nginx
# 접속: https://lemon.3chan.kr/app/
```

---

## 아키텍처
```
Flutter App (오프라인 우선) ↔ Nginx Gateway ↔ 6 Microservices ↔ PostgreSQL/MongoDB/Redis/MinIO
```

### 마이크로서비스
| 서비스 | 포트 | 기술 | 역할 |
|--------|------|------|------|
| Auth | 3001 | Node.js | JWT 인증 |
| Content | 3002 | Node.js | 레슨/단어 CRUD |
| Progress | 3003 | Go | 진도/SRS |
| Media | 3004 | Go | 미디어 서빙 |
| Analytics | 3005 | Python | 통계 |
| Admin | 3006 | Node.js | 관리자 대시보드 |

---

## 주요 디렉토리
```
services/           # 백엔드 마이크로서비스
mobile/lemon_korean/lib/  # Flutter 앱 (115 Dart 파일)
database/postgres/  # PostgreSQL 스키마 (15개 테이블)
config/             # DB/서비스 설정 파일
nginx/              # Nginx 설정
scripts/            # 백업, 최적화 스크립트
dev-notes/          # 개발노트
```

---

## Claude 작업 프로토콜

### 개발노트 작성 (중요한 변경 후 필수)
**언어**: 한국어로 작성 (코드 블록 제외)

```bash
# 파일 생성
/dev-notes/YYYY-MM-DD-brief-description.md
```

```yaml
---
date: 2026-01-30
category: Mobile|Backend|Frontend|Database|Infrastructure|Documentation
title: 명확한 제목
author: Claude Opus 4.5
tags: [tag1, tag2]
priority: high|medium|low
---
```

**작성 대상**: 새 기능, 버그 수정, 아키텍처 변경, 성능 최적화
**예외**: 타이포 수정, 포맷팅, 주석 추가

---

## 파일 명명 규칙

**Backend**: `*.controller.js`, `*.service.js`, `*.routes.js`
**Flutter**: `*_screen.dart`, `*_provider.dart`, `*_model.dart`, `*_repository.dart`

---

## 주요 기술 스택

- **Backend**: Node.js (Express), Go (Gin), Python (FastAPI)
- **DB**: PostgreSQL 15, MongoDB 4.4, Redis 7, MinIO
- **Mobile**: Flutter 3.x, Hive, Provider, Dio
- **Infra**: Docker Compose, Nginx (Rate Limiting, SSL)

---

## 핵심 패턴

### 오프라인 우선
```dart
// 항상 로컬 저장 먼저 → 백그라운드 동기화
await LocalStorage.saveProgress(progress);
await LocalStorage.addToSyncQueue(SyncItem(...));
await SyncManager.autoSync();
```

### 미디어 로딩 (로컬 우선)
```dart
final localPath = await DatabaseHelper.getLocalPath(remoteKey);
return localPath ?? '${ApiConstants.baseUrl}/media/$remoteKey';
```

---

## 중요 주의사항

### 보안
- JWT는 flutter_secure_storage에만 저장
- bcrypt 해싱, Rate Limiting 적용

### 설정 변경
- ❌ docker-compose.yml 직접 수정 금지
- ✅ `config/` 디렉토리의 설정 파일 수정

### 웹 앱 제한
- 오프라인 다운로드 불가 (항상 온라인 가정)
- localStorage 5-10MB 제한

---

## 트러블슈팅

```bash
# 서비스 재시작
docker-compose restart <service-name>

# 로그 확인
docker-compose logs -f <service-name>

# Flutter 캐시 정리
flutter clean && flutter pub get

# 포트 충돌 확인
sudo lsof -i :5432
```

---

## 상세 문서 참조

| 주제 | 문서 |
|------|------|
| API 엔드포인트 | `/docs/API.md` |
| DB 스키마 | `/database/postgres/SCHEMA.md` |
| 배포 가이드 | `/DEPLOYMENT.md` |
| 테스트 | `/TESTING.md` |
| 모니터링 | `/MONITORING.md` |
| 백업 | `/scripts/backup/README.md` |
| 최적화 | `/scripts/optimization/README.md` |
| Admin 대시보드 | `/services/admin/DASHBOARD.md` |
| Flutter 앱 | `/mobile/lemon_korean/README.md` |
| 웹 배포 | `/mobile/lemon_korean/WEB_DEPLOYMENT_GUIDE.md` |

---

## 환경 변수
`.env.example` 참조. 주요 변수:
- `DB_*`: PostgreSQL 연결
- `MONGODB_URI`: MongoDB 연결
- `JWT_SECRET`: 인증 시크릿
- `MINIO_*`: 미디어 스토리지

---

**마지막 업데이트**: 2026-02-02
