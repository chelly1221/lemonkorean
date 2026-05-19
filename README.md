# 柠檬韩语 (Lemon Korean)

> 다국어 한국어 학습 플랫폼 | Multi-language Korean Learning Platform

---

## 📖 프로젝트 소개

**柠檬韩语 (Lemon Korean)** 는 전 세계 학습자를 위해 설계된 한국어 학습 애플리케이션으로, 오프라인 우선 아키텍처를 채택하여 레슨 다운로드 후 네트워크 없이 학습하고, 네트워크 복구 시 자동으로 진도를 동기화합니다. 6개 언어로 콘텐츠를 제공하여 국제적인 사용자층을 지원합니다.

### ✨ 핵심 특징

- **🔌 오프라인 우선 학습**: 레슨 다운로드 후 인터넷 없이 학습 가능
- **🔄 자동 동기화**: 네트워크 복구 시 학습 진도 자동 백업
- **🌍 완전한 다국어 지원**: 6개 언어 콘텐츠 (한국어, 영어, 스페인어, 일본어, 중국어 간체/번체)
- **🇨🇳 한자 문화권 최적화**: 한자 연결, 발음 유사도 비교, 간체/번체 자동 변환
- **📱 몰입형 경험**: 풀스크린 학습 모드, 집중 학습
- **🏗️ 마이크로서비스 아키텍처**: 확장 가능한 백엔드 시스템 (8개 서비스)
- **🎯 7단계 레슨**: 어휘→문법→연습→대화→퀴즈→복습→요약
- **🎨 현대적 UI 디자인**: Material Design 3, 부드러운 애니메이션
- **📊 SRS 복습 시스템**: 지능형 복습 알림
- **👋 개인화 온보딩**: 6단계 온보딩 플로우 (언어 선택→소개→레벨→주간 목표→개인화 완료→계정 선택)
- **🎨 앱 테마 커스터마이징**: 관리자가 색상, 로고, 폰트 설정 (20+ 옵션)
- **🔤 한글 학습 모듈**: 발음 가이드, 필기 연습, 소리 구분 (9개 모드)
- **🍋 게임화 시스템**: 레몬 보상, 보스 퀴즈, 레몬 나무, 리더보드
- **🎭 캐릭터 커스터마이징 & 마이룸**: 16종 아이템 카테고리, 레몬 상점, 방 꾸미기
- **👥 SNS 커뮤니티**: 게시물 피드, 댓글, 좋아요, 친구 검색, 팔로우
- **💬 실시간 DM**: Socket.IO 기반 1:1 메시징 (텍스트, 이미지, 음성)
- **🎤 음성 대화방**: LiveKit 기반 무대/청중 시스템 (스피커 제한, 청취자 무제한, 최대 200명)

---

## 🏗️ 아키텍처 설계

### 시스템 아키텍처

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter App                           │
│                (오프라인 우선 + 자동 동기화)              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐              │
│  │  Hive    │  │ SQLite   │  │   Dio    │              │
│  │ (Lessons)│  │ (Media)  │  │  (HTTP)  │              │
│  └──────────┘  └──────────┘  └──────────┘              │
└─────────────────────────────────────────────────────────┘
                          ↕
                  (필요시에만 동기화)
                          ↕
┌─────────────────────────────────────────────────────────┐
│                  Nginx API Gateway                       │
│              (포트 80, 로드 밸런싱 + 캐싱)               │
└─────────────────────────────────────────────────────────┘
                          ↓
        ┌─────────────────┼─────────────────┐
        ↓                 ↓                 ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Auth Service │  │Content Service│ │Progress Service│
│  (Node.js)   │  │  (Node.js)    │ │     (Go)      │
│   :3001      │  │    :3002      │ │    :3003      │
└──────────────┘  └──────────────┘  └──────────────┘
        ↓                 ↓                 ↓
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│ Media Service│  │Analytics Svc │  │ Admin Service│
│     (Go)     │  │   (Python)   │  │  (Node.js)   │
│   :3004      │  │    :3005     │  │    :3006     │
└──────────────┘  └──────────────┘  └──────────────┘
                          ↓
                  ┌──────────────┐
                  │ SNS Service  │
                  │  (Node.js)   │
                  │    :3007     │
                  └──────────────┘
                    ↕     ↕     ↕
            ┌──────────┐ ┌──────────┐ ┌──────────────┐
            │Socket.IO │ │ LiveKit  │ │  Moderation  │
            │  (DM)    │ │ (Voice)  │ │(Python/ONNX) │
            └──────────┘ └──────────┘ │  :3008 내부  │
                                      └──────────────┘
        ↓                 ↓                 ↓
┌─────────────────────────────────────────────────────────┐
│                   데이터 레이어                           │
│  ┌──────────┐  ┌──────────┐  ┌────────┐  ┌──────────┐ │
│  │PostgreSQL│  │ MongoDB  │  │ Redis  │  │  MinIO   │ │
│  │  :5432   │  │  :27017  │  │ :6379  │  │:9000/9001│ │
│  └──────────┘  └──────────┘  └────────┘  └──────────┘ │
│  ┌──────────┐                                          │
│  │ RabbitMQ │  (메시지 큐)                              │
│  │  :5672   │                                          │
│  └──────────┘                                          │
└─────────────────────────────────────────────────────────┘
```

### 데이터 흐름

```
사용자 동작 → 로컬 저장 (Hive/SQLite)
                ↓
        동기화 큐에 추가 (sync_queue)
                ↓
        네트워크 가능? ──No→ 큐 유지
                │
               Yes
                ↓
        백그라운드 자동 동기화 → API Gateway (Nginx)
                ↓
        마이크로서비스 처리 → 데이터베이스 영속화
                ↓
        확인 응답 → 큐 항목 제거
```

---

## 🔧 기술 스택

### 백엔드 서비스

| 서비스 | 기술 스택 | 포트 | 기능 |
|------|--------|------|------|
| **Auth Service** | Node.js + Express | 3001 | JWT 인증, 사용자 관리 |
| **Content Service** | Node.js + Express | 3002 | 레슨 콘텐츠, 어휘, 문법 |
| **Progress Service** | Go + Gin | 3003 | 학습 진도, SRS 알고리즘 |
| **Media Service** | Go + Gin | 3004 | 이미지/오디오 서빙 |
| **Analytics Service** | Python + FastAPI | 3005 | 로그 분석, 통계 |
| **Admin Service** | Node.js + Express | 3006 | 관리자 대시보드 |
| **SNS Service** | Node.js + Express | 3007 | 커뮤니티 피드, 게시물, 댓글, 팔로우, DM, 음성대화방 |
| **Moderation Service** | Python + FastAPI + ONNX | 3008 (내부) | AI 텍스트 모더레이션 (내부 전용, SNS에서 호출) |

### 데이터베이스 및 스토리지

| 구성 요소 | 포트 | 용도 |
|------|------|------|
| **PostgreSQL** | 5432 | 구조화된 데이터 (users, lessons, progress) |
| **MongoDB** | 27017 | 문서 저장소 (lesson content, logs) |
| **Redis** | 6379 | 캐시, 세션, 실시간 데이터 |
| **MinIO** | 9000/9001 | 미디어 파일 (S3 호환) |
| **RabbitMQ** | 5672/15672 | 메시지 큐, 비동기 작업 |

### 모바일

- **Flutter 3.x** - Android 모바일 앱
- **Hive** - 로컬 NoSQL 데이터베이스 (레슨, 진도)
- **SQLite** - 미디어 파일 매핑
- **Dio** - HTTP 클라이언트
- **Provider** - 상태 관리
- **flutter_animate** - 애니메이션 라이브러리
- **audioplayers** - 오디오 재생
- **flutter_localizations** - 다국어 지원 (6개 언어)
- **flutter_open_chinese_convert** - 간체/번체 변환
- **socket_io_client** - Socket.IO 실시간 메시징 (DM)
- **livekit_client** - LiveKit 음성 대화방

### 인프라

- **Docker & Docker Compose** - 컨테이너화 배포
- **Nginx** - API 게이트웨이, 로드 밸런싱, 캐싱
- **RabbitMQ** - 메시지 큐

---

## 🚀 빠른 시작

### 사전 요구사항

- **Docker** 20.x+ & **Docker Compose** 2.x+
- **Node.js** 18+ (개발용)
- **Go** 1.21+ (개발용)
- **Python** 3.11+ (개발용)
- **Flutter** 3.x (모바일 앱 개발)

### 설치 단계

#### 1️⃣ 저장소 클론

```bash
git clone https://github.com/chelly1221/lemonkorean.git
cd lemonkorean
```

#### 2️⃣ 환경 변수 설정

```bash
cp .env.example .env
```

`.env` 파일을 편집하여 필요한 환경 변수 설정:

```env
# 데이터베이스
DB_PASSWORD=your_secure_password
POSTGRES_DB=lemon_korean
POSTGRES_USER=3chan

# JWT
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d

# MinIO
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secure_key
```

#### 3️⃣ 서비스 시작

**방법 1: 배포 스크립트 사용 (권장)**

```bash
./scripts/deploy.sh
```

이 스크립트는 다음을 자동으로 수행합니다:
- ✅ 환경 변수 검증
- ✅ Docker 이미지 빌드
- ✅ 데이터베이스 마이그레이션
- ✅ 서비스 시작
- ✅ 헬스 체크

**방법 2: 수동 시작**

```bash
# 모든 서비스 빌드 및 시작
docker-compose up -d

# 서비스 상태 확인
docker-compose ps

# 로그 확인
./scripts/logs.sh
# 또는
docker-compose logs -f
```

#### 4️⃣ 서비스 확인

다음 주소로 접속하여 서비스 정상 작동 확인:

- **API 게이트웨이**: http://localhost
- **MinIO 콘솔**: http://localhost:9001
- **RabbitMQ 관리 UI**: http://localhost:15672 (계정: guest, 비밀번호: guest)

헬스 체크 엔드포인트:
```bash
# Auth Service
curl http://localhost:3001/health

# Content Service
curl http://localhost:3002/health

# Progress Service
curl http://localhost:3003/health
```

#### 5️⃣ Flutter 앱 실행

```bash
cd mobile/lemon_korean
flutter pub get
flutter run
```

---

## 📁 프로젝트 구조

```
lemonkorean/
├── services/                    # 마이크로서비스
│   ├── auth/                   # 인증 서비스 (Node.js)
│   │   ├── src/
│   │   │   ├── controllers/   # 요청 처리
│   │   │   ├── services/      # 비즈니스 로직
│   │   │   ├── models/        # 데이터 모델
│   │   │   └── routes/        # 라우팅 정의
│   │   ├── package.json
│   │   └── Dockerfile
│   ├── content/               # 콘텐츠 서비스 (Node.js)
│   ├── progress/              # 진도 관리 (Go)
│   ├── media/                 # 미디어 서비스 (Go)
│   ├── analytics/             # 분석 서비스 (Python)
│   ├── admin/                 # 관리 대시보드 (Node.js)
│   ├── sns/                   # SNS 커뮤니티 서비스 (Node.js)
│   └── moderation/            # AI 텍스트 모더레이션 (Python/ONNX, 내부 전용)
│
├── mobile/                     # Flutter 애플리케이션
│   └── lemon_korean/
│       ├── lib/
│       │   ├── core/          # 핵심 기능
│       │   │   ├── storage/   # Hive + SQLite
│       │   │   ├── network/   # Dio + API
│       │   │   └── utils/     # 유틸리티 함수
│       │   ├── data/          # 데이터 레이어
│       │   │   ├── models/    # 데이터 모델
│       │   │   └── repositories/
│       │   └── presentation/  # 프레젠테이션 레이어
│       │       ├── screens/   # 화면
│       │       ├── widgets/   # 위젯
│       │       └── providers/ # 상태 관리
│       ├── pubspec.yaml
│       └── README.md
│
├── database/                   # 데이터베이스 초기화
│   ├── postgres/              # PostgreSQL 스키마
│   │   └── init/
│   │       ├── 01_schema.sql
│   │       └── 02_seed.sql
│   └── mongo/                 # MongoDB 초기 데이터
│       └── init/
│
├── nginx/                      # Nginx 설정
│   └── nginx.conf
│
├── scripts/                    # 운영 스크립트
│   ├── deploy.sh              # 배포 스크립트
│   ├── backup.sh              # 백업 스크립트
│   ├── restore.sh             # 복구 스크립트
│   ├── logs.sh                # 로그 조회
│   └── README.md
│
├── docs/                       # 문서
│   └── api/                   # API 문서
│
├── docker-compose.yml          # Docker 오케스트레이션
├── .env.example               # 환경 변수 예제
├── CLAUDE.md                  # 개발 가이드
└── README.md                  # 본 문서
```

---

## 📚 개발 가이드

### 로컬 개발

#### 백엔드 서비스 개발

각 서비스는 독립적으로 실행 가능:

```bash
# Auth Service (Node.js)
cd services/auth
npm install
npm run dev

# Progress Service (Go)
cd services/progress
go mod download
go run main.go

# Analytics Service (Python)
cd services/analytics
pip install -r requirements.txt
uvicorn main:app --reload --port 3005
```

#### Flutter 애플리케이션 개발

```bash
cd mobile/lemon_korean
flutter pub get

# iOS 시뮬레이터
flutter run

# Android 에뮬레이터
flutter run

# 프로덕션 빌드
flutter build apk --release
flutter build ios --release
```

### 데이터베이스 작업

```bash
# PostgreSQL 접속
docker-compose exec postgres psql -U 3chan -d lemon_korean

# MongoDB 접속
docker-compose exec mongo mongosh

# Redis 접속
docker-compose exec redis redis-cli

# 데이터베이스 마이그레이션 실행
docker-compose exec postgres psql -U 3chan -d lemon_korean -f /init/01_schema.sql
```

### 코드 규칙

#### Flutter
- `*_screen.dart` - 화면
- `*_provider.dart` - 상태 관리
- `*_model.dart` - 데이터 모델
- `*_repository.dart` - 데이터 접근
- `*_widget.dart` - 재사용 가능한 위젯

#### Backend
- `*.controller.js/go` - 요청 처리
- `*.service.js/go` - 비즈니스 로직
- `*.model.js/go` - 데이터 모델
- `*.routes.js/go` - 라우팅 정의

---

## 🔍 API 문서

### 주요 엔드포인트

#### Auth Service (`:3001`)

| 메서드 | 엔드포인트 | 설명 |
|------|------|------|
| POST | `/api/auth/register` | 사용자 등록 |
| POST | `/api/auth/login` | 사용자 로그인 |
| POST | `/api/auth/refresh` | 토큰 갱신 |
| GET | `/api/auth/profile` | 사용자 정보 조회 |

#### Content Service (`:3002`)

| 메서드 | 엔드포인트 | 설명 |
|------|------|------|
| GET | `/api/content/lessons` | 레슨 목록 조회 |
| GET | `/api/content/lessons/:id` | 레슨 상세 조회 |
| GET | `/api/content/lessons/:id/download` | 레슨 패키지 다운로드 |
| POST | `/api/content/check-updates` | 레슨 업데이트 확인 |

#### Progress Service (`:3003`)

| 메서드 | 엔드포인트 | 설명 |
|------|------|------|
| GET | `/api/progress/user/:userId` | 사용자 진도 조회 |
| POST | `/api/progress/complete` | 레슨 완료 |
| POST | `/api/progress/sync` | 오프라인 진도 동기화 |
| GET | `/api/progress/review-schedule` | SRS 복습 일정 |

#### Media Service (`:3004`)

| 메서드 | 엔드포인트 | 설명 |
|------|------|------|
| GET | `/media/images/:key` | 이미지 조회 |
| GET | `/media/audio/:key` | 오디오 조회 |

상세 API 문서: [API 문서](./docs/API.md)

---

## 🧪 테스트

### 백엔드 테스트

```bash
# Auth Service
docker-compose exec auth npm test

# Progress Service
cd services/progress
go test ./...

# Analytics Service
cd services/analytics
pytest
```

### Flutter 테스트

```bash
cd mobile/lemon_korean

# 단위 테스트
flutter test

# 통합 테스트
flutter test integration_test/

# 테스트 커버리지
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

---

## 🛠️ 운영 도구

### 백업 및 복구

```bash
# 백업 생성
./scripts/backup.sh

# 사용 가능한 백업 조회
./scripts/restore.sh

# 백업에서 복구
./scripts/restore.sh 20240125_020000
```

백업 내용:
- ✅ PostgreSQL 데이터베이스
- ✅ MongoDB 데이터베이스
- ✅ MinIO 객체 스토리지
- ✅ 30일 이상 오래된 백업 자동 삭제

### 로그 조회

```bash
# 모든 서비스 로그 조회
./scripts/logs.sh

# 실시간 로그 추적
./scripts/logs.sh -f

# 특정 서비스
./scripts/logs.sh auth

# 지난 1시간 로그
./scripts/logs.sh --since 1h content
```

### 서비스 관리

```bash
# 특정 서비스 재시작
docker-compose restart auth

# 모든 서비스 중지
docker-compose down

# 완전 정리 (데이터 볼륨 포함)
docker-compose down -v

# 서비스 상태 확인
docker-compose ps
```

---

## ⚠️ 트러블슈팅

### 일반적인 문제

#### 1. 포트 충돌

**증상**: `Error: bind: address already in use`

**해결 방법**:
```bash
# 포트 사용 확인
sudo lsof -i :5432  # PostgreSQL
sudo lsof -i :3001  # Auth Service

# 충돌하는 프로세스 중지 또는 docker-compose.yml에서 포트 매핑 수정
docker-compose down
# 포트 수정 후 재시작
docker-compose up -d
```

#### 2. Docker 빌드 실패

**증상**: `ERROR [internal] load metadata for docker.io/library/...`

**해결 방법**:
```bash
# Docker 캐시 정리
docker system prune -a

# 재빌드
docker-compose build --no-cache
docker-compose up -d
```

#### 3. 데이터베이스 연결 실패

**증상**: `Error: connect ECONNREFUSED`

**해결 방법**:
```bash
# 데이터베이스 컨테이너 상태 확인
docker-compose ps postgres

# 데이터베이스 로그 확인
docker-compose logs postgres

# 데이터베이스 재시작
docker-compose restart postgres

# PostgreSQL 준비 대기
docker-compose exec postgres pg_isready -U 3chan
```

#### 4. Flutter 빌드 오류

**증상**: `Could not resolve all dependencies`

**해결 방법**:
```bash
cd mobile/lemon_korean

# 캐시 정리
flutter clean

# 의존성 재설치
flutter pub get

# 의존성 업그레이드
flutter pub upgrade

# 재실행
flutter run
```

#### 5. 헬스 체크 실패

**증상**: 일부 서비스의 헬스 체크 실패

**해결 방법**:
```bash
# 실패한 서비스 로그 확인
./scripts/logs.sh <service-name>

# 환경 변수 확인
cat .env

# 재배포
./scripts/deploy.sh
```

#### 6. MinIO 접근 문제

**증상**: MinIO 콘솔 접근 불가 또는 파일 업로드 실패

**해결 방법**:
```bash
# MinIO 상태 확인
curl http://localhost:9000/minio/health/live

# MinIO 로그 확인
docker-compose logs minio

# 인증 정보 재설정 (.env에서)
MINIO_ACCESS_KEY=admin
MINIO_SECRET_KEY=your_secure_key

# MinIO 재시작
docker-compose restart minio
```

#### 7. 백업 실패

**증상**: `backup.sh` 실행 실패

**해결 방법**:
```bash
# 디스크 공간 확인
df -h

# 컨테이너 실행 상태 확인
docker-compose ps

# 백업 디렉토리 권한 확인
ls -la backups/

# 백업 디렉토리 수동 생성
mkdir -p backups/{postgres,mongo,minio}
```

### 로그 위치

```bash
# 애플리케이션 로그
docker-compose logs <service-name>

# 백업 로그
/var/log/lemon_korean_backup.log

# Nginx 로그
docker-compose logs nginx

# 시스템 로그
journalctl -u docker
```

### 성능 최적화

#### 데이터베이스 최적화

```sql
-- PostgreSQL 인덱스 최적화
CREATE INDEX idx_user_progress_user_id ON user_progress(user_id);
CREATE INDEX idx_lessons_level ON lessons(level);

-- 느린 쿼리 확인
SELECT * FROM pg_stat_statements ORDER BY mean_exec_time DESC LIMIT 10;
```

#### Redis 캐시

```bash
# 캐시 적중률 확인
docker-compose exec redis redis-cli INFO stats | grep hit

# 캐시 비우기
docker-compose exec redis redis-cli FLUSHALL
```

#### Nginx 캐시

```bash
# Nginx 캐시 비우기
docker-compose exec nginx rm -rf /var/cache/nginx/*

# 설정 다시 로드
docker-compose exec nginx nginx -s reload
```

---

## 🔐 보안 권장사항

1. **프로덕션 환경 설정**:
   - 강력한 비밀번호 사용 (최소 16자)
   - JWT_SECRET 정기적으로 변경
   - HTTPS 활성화 (Let's Encrypt 사용)
   - 방화벽 규칙 설정

2. **데이터 백업**:
   - 정기 백업 설정 (cron)
   - 클라우드 스토리지로 원격 백업
   - 복구 절차 정기적으로 테스트

3. **모니터링 및 알림**:
   - 서비스 헬스 모니터링 설정
   - 디스크 공간 알림
   - CPU/메모리 사용률 모니터링

---

## 📖 상세 문서

- **[CLAUDE.md](./CLAUDE.md)** - 상세 개발 가이드
- **[scripts/README.md](./scripts/README.md)** - 운영 스크립트 문서
- **[mobile/lemon_korean/README.md](./mobile/lemon_korean/README.md)** - Flutter 앱 문서
- **[docs/API.md](./docs/API.md)** - API 문서

---

## 🗺️ 개발 로드맵

- [x] **Phase 1**: 인증 서비스 + 콘텐츠 서비스
- [x] **Phase 2**: 진도 서비스 + 동기화 메커니즘
- [x] **Phase 3**: Flutter 기본 화면 (로그인, 회원가입, 홈)
- [x] **Phase 4**: 레슨 7단계 구현
- [x] **Phase 5**: 관리자 대시보드
- [x] **Phase 6**: 데이터 분석 서비스
- [x] **Phase 7**: 프로덕션 배포 + CI/CD
- [x] **Phase 8**: 게임화 시스템 (레몬 보상, 보스 퀴즈, 광고)
- [x] **Phase 9**: SNS 커뮤니티 (피드, 게시물, 댓글, 팔로우, 모더레이션)
- [x] **Phase 10**: 실시간 DM, 음성 대화방 (Socket.IO, LiveKit)

---

## 📄 라이선스

이 프로젝트는 개인 프로젝트입니다.

---

## 🤝 기여

이슈 및 풀 리퀘스트 환영합니다.

---

## 📞 문의

질문이나 제안사항이 있으시면 이슈를 등록해주세요.

---

**Made with ❤️ for Korean learners worldwide**
