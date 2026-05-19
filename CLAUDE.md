# 柠檬韩语 (Lemon Korean) - 프로젝트 가이드

## 프로젝트 개요
다국어 한국어 학습 앱 (Android 모바일 앱). 오프라인 학습 지원, 마이크로서비스 아키텍처, 자체 호스팅. 전 세계 학습자를 위한 6개 언어 콘텐츠 제공.

**플랫폼**: Flutter 기반 Android 모바일 앱

**상태**: ✅ **프로덕션 준비 완료** (100%, 8/8 서비스)

**핵심 특징**: 오프라인 우선, SRS 복습, 7단계 레슨, 13단계 한글 커리큘럼(Stage 0~12), 다국어 콘텐츠 (ko, en, es, ja, zh, zh_TW), 간체/번체 자동 변환, 게임화(레몬 보상), SNS 커뮤니티, 실시간 DM, 음성 대화방(LiveKit, 6가지 방 유형), AI 콘텐츠 모더레이션 (AVX2/AVX-VNNI 최적화)

---

## 빠른 시작
```bash
# 서버
cp .env.example .env && docker-compose up -d

# Flutter 앱
cd mobile/lemon_korean && flutter pub get && flutter run
```

---

## 아키텍처
```
Flutter App (오프라인 우선, 콘텐츠 내장) ↔ Nginx Gateway ↔ 최소 서버(Auth/Progress/SNS) ↔ PostgreSQL/Redis/MinIO
```

### 2026-02 개발 방향 (중요)

- **최소 서버 구조를 기본값으로 유지**:
  - 서버 필수: `Auth`, `Progress`, `SNS(커뮤니티/DM/음성)`
  - 앱 내장: `한글/레슨/단어/문법`, `앱 테마 기본값`, `게임화 기본값`, `캐릭터 아이템 카탈로그`
- 정적 학습 콘텐츠는 서버 CRUD보다 **앱 번들 + 로컬 저장소**를 우선한다.
- 새로운 데이터 추가 시 판단 기준:
  - 사용자별 상태/동기화 필요 -> 서버
  - 정적 커리큘럼/사전/표시용 설정 -> 앱 내장

### 마이크로서비스 (운영 관점)
| 서비스 | 포트 | 기술 | 역할 |
|--------|------|------|------|
| Auth | 3001 | Node.js | JWT 인증 |
| Content | 3002 | Node.js | 레슨/단어/문법 콘텐츠 (개발/운영용) |
| Progress | 3003 | Go | 진도/SRS |
| Media | 3004 | Go | 미디어 서빙 |
| Analytics | 3005 | Python | 통계 |
| Admin | 3006 | Node.js | 운영/관리 도구(배포/운영 설정) |
| SNS | 3007 | Node.js | 커뮤니티 피드, 게시물, 댓글, 팔로우, DM, 음성대화방 |
| Moderation | 3008 | Python (FastAPI) | AI 콘텐츠 모더레이션 (ONNX Runtime) |

> Content/Admin 서비스는 개발/운영 도구로 유지 가능하지만, 모바일 런타임의 정적 학습 콘텐츠 필수 의존으로 두지 않는다.

---

## 주요 디렉토리
```
services/           # 백엔드 마이크로서비스
mobile/lemon_korean/lib/  # Flutter 앱 (323 Dart 파일)
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
- **AI/ML**: ONNX Runtime (콘텐츠 모더레이션, AVX2/AVX-VNNI 최적화), Transformers
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

### 폴백(Fallback) 금지 원칙
- ❌ **폴백 함수/로직을 만들지 않는다.** 서비스가 정상 동작하지 않으면 에러가 명확히 드러나야 한다.
- 각 서비스는 **단일 구현 경로**만 가진다. 서버 → 로컬 폴백, 고급 → 저급 폴백 등 이중 경로 금지.
- 예시:
  - ✅ `KoreanTtsHelper`: `flutter_tts`만 사용 (서버 오디오 폴백 없음)
  - ✅ `SpeechModelManager`: 번들 모델만 사용 (서버 다운로드 폴백 없음)
  - ❌ `try serverAudio() catch → try localTts()` 같은 폴백 체인
- **이유**: 폴백이 있으면 서비스 장애가 숨겨져 문제를 발견할 수 없다.

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

### 배포 자동화
- Deploy Agent는 systemd 서비스로 실행 (`deploy-agent.service`)
- APK 빌드는 Admin Dashboard에서 트리거
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

## APK 설치 (데이터 보존)

**중요**: `flutter install`은 기존 앱을 삭제 후 재설치하여 로그인/온보딩 데이터가 날아감.
반드시 `adb install -r` (replace)을 사용하여 데이터를 보존할 것.

```bash
# APK 빌드
cd mobile/lemon_korean && flutter build apk --release

# 데이터 보존 설치 (adb install -r)
ADB=/home/chell/android-sdk/platform-tools/adb
APK=build/app/outputs/flutter-apk/app-release.apk
$ADB -s <device-serial> install -r "$APK"

# 연결된 디바이스 확인
$ADB devices -l
```

- ❌ `flutter install` — 앱 삭제 후 재설치 (데이터 손실)
- ✅ `adb install -r` — 기존 데이터 유지하면서 업데이트

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

---

## 환경 변수
`.env.example` 참조. 주요 변수:
- `DB_*`: PostgreSQL 연결
- `MONGODB_URI`: MongoDB 연결
- `JWT_SECRET`: 인증 시크릿
- `MINIO_*`: 미디어 스토리지
- `REDIS_URL`: Redis 연결 (Socket.IO, 온라인 상태, 배포 락)
- `LIVEKIT_API_KEY`, `LIVEKIT_API_SECRET`, `LIVEKIT_URL`: LiveKit 음성 대화방
- `MODERATION_SERVICE_URL`, `MODERATION_TIMEOUT_MS`: AI 콘텐츠 모더레이션 서비스
- `TEXT_REJECT_THRESHOLD`, `TEXT_FLAG_THRESHOLD`: 모더레이션 독성 점수 임계값

---

**마지막 업데이트**: 2026-05-18
