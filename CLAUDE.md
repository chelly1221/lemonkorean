# 柠檬韩语 (Lemon Korean) - 프로젝트 가이드

## 프로젝트 개요
다국어 한국어 학습 앱 (모바일 앱 + 웹 앱 동시 지원). 오프라인 학습 지원, 마이크로서비스 아키텍처, 자체 호스팅. 전 세계 학습자를 위한 6개 언어 콘텐츠 제공.

**플랫폼**: Flutter 기반 모바일(Android) + 웹 앱 호환 프로젝트 (단일 코드베이스)

**상태**: ✅ **프로덕션 준비 완료** (100%, 7/7 서비스)

**핵심 특징**: 오프라인 우선, SRS 복습, 7단계 레슨, 다국어 콘텐츠 (ko, en, es, ja, zh, zh_TW), 간체/번체 자동 변환, 게임화(레몬 보상), SNS 커뮤니티, 실시간 DM, 음성 대화방(LiveKit)

---

## 빠른 시작
```bash
# 서버
cp .env.example .env && docker-compose up -d

# Flutter 앱
cd mobile/lemon_korean && flutter pub get && flutter run

# 웹 빌드 (build_web.sh 사용 필수)
cd mobile/lemon_korean && ./build_web.sh
# 접속: https://lemon.3chan.kr/app/
```

---

## 아키텍처
```
Flutter App (오프라인 우선) ↔ Nginx Gateway ↔ 7 Microservices ↔ PostgreSQL/MongoDB/Redis/MinIO
```

### 마이크로서비스
| 서비스 | 포트 | 기술 | 역할 |
|--------|------|------|------|
| Auth | 3001 | Node.js | JWT 인증 |
| Content | 3002 | Node.js | 레슨/단어 CRUD |
| Progress | 3003 | Go | 진도/SRS |
| Media | 3004 | Go | 미디어 서빙 |
| Analytics | 3005 | Python | 통계 |
| Admin | 3006 | Node.js | 관리자 대시보드, 앱 테마 설정, APK 빌드 |
| SNS | 3007 | Node.js | 커뮤니티 피드, 게시물, 댓글, 팔로우, DM, 음성대화방 |

---

## 주요 디렉토리
```
services/           # 백엔드 마이크로서비스
mobile/lemon_korean/lib/  # Flutter 앱 (210+ Dart 파일)
database/postgres/  # PostgreSQL 스키마 (41+ 테이블)
config/             # DB/서비스 설정 파일 (livekit/ 포함)
nginx/              # Nginx 설정
scripts/            # 백업, 최적화, 배포 트리거 스크립트
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
author: Claude Opus 4.6
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
- **Realtime**: Socket.IO (DM/채팅), LiveKit (음성 대화방)
- **Mobile**: Flutter 3.x, Hive, Provider, Dio, socket_io_client, livekit_client
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
- **인증 문제 해결 시**: 백엔드 미들웨어보다 **프론트엔드 수정을 우선**
  - ✅ 프론트엔드: fetch() + Authorization 헤더 사용 (보안 권장)
  - ❌ 미들웨어: 쿼리 파라미터 토큰 허용 (로그 노출 위험)

### 설정 변경
- ❌ docker-compose.yml 직접 수정 금지
- ✅ `config/` 디렉토리의 설정 파일 수정

### 웹 앱 제한
- 오프라인 다운로드 불가 (항상 온라인 가정)
- localStorage 5-10MB 제한

### 웹 앱 캐시 관리 (중요!)
**문제**: Nginx는 `main.dart.js` 등 정적 자산을 7일간 캐시. 웹 앱 배포 후 변경사항이 보이지 않을 수 있음

**해결**: `build_web.sh` 스크립트가 자동으로 처리
```bash
cd mobile/lemon_korean && ./build_web.sh
```

**스크립트 자동 수행 작업**:
1. ✅ `version.json`에 빌드 타임스탬프 추가 (캐시 무효화)
2. ✅ Nginx 캐시 디렉토리 정리 (`/var/cache/nginx/`)
3. ✅ Nginx 컨테이너 재시작

**사용자 측 캐시 클리어** (배포 후 안내 필수):
- Chrome/Edge/Firefox: `Ctrl+Shift+R` (Mac: `Cmd+Shift+R`)
- Safari: `Cmd+Option+R`
- 또는 시크릿/비공개 모드로 확인

**수동 캐시 클리어** (필요 시):
```bash
# Nginx 캐시만 클리어
docker compose exec nginx sh -c "rm -rf /var/cache/nginx/*"
docker compose restart nginx

# 브라우저 서비스 워커 클리어 (F12 → Application → Service Workers → Unregister)
```

### 배포 자동화
- Deploy Agent는 systemd 서비스로 실행 (`deploy-agent.service`)
- 웹/APK 빌드는 Admin Dashboard에서 트리거
- 트리거 파일 기반 통신 (`/services/admin/src/deploy-triggers/`)

---

## Flutter 핫 리로드 / 핫 리스타트

`flutter run`이 백그라운드에서 실행 중이고 stdin이 닫혀 있을 때 (터미널 키 입력 불가), 시그널로 리로드:

```bash
# flutter run PID 확인
pgrep -a flutter | grep "run -d"

# 핫 리로드 (코드 변경 반영, 상태 유지) 🔥
kill -SIGUSR1 <PID>

# 핫 리스타트 (전체 재시작, 상태 초기화)
kill -SIGUSR2 <PID>

# 로그 확인 (flutter run 출력이 /tmp에 기록된 경우)
tail -f /tmp/flutter_run.log
```

> **참고**: `flutter run`이 포그라운드 터미널에서 실행 중이면 `r` (핫 리로드) / `R` (핫 리스타트) 키 사용.

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
| 배포 트리거 시스템 | `/scripts/deploy-trigger/README.md` |
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
- `REDIS_URL`: Redis 연결 (Socket.IO, 온라인 상태, 배포 락)
- `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET`, `LIVEKIT_URL`: LiveKit 음성 대화방

---

**마지막 업데이트**: 2026-02-19
