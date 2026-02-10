# Flutter Web Deployment Guide

## 개요
Lemon Korean Flutter 앱을 웹 플랫폼에 배포하기 위한 전체 가이드입니다.

**배포 URL**: https://lemon.3chan.kr/app/

## 웹 플랫폼 아키텍처

### 핵심 전략
- **오프라인 다운로드**: 웹에서는 지원하지 않음 (항상 온라인 가정)
- **파일 시스템**: localStorage 기반 (Hive 대체)
- **미디어 로딩**: CDN 직접 사용 (로컬 파일 없음)
- **저장 용량**: localStorage 5-10MB 제한

### 웹 스텁 (9개)
1. **download_manager_stub.dart** - 다운로드 no-op
2. **media_loader_stub.dart** - CDN URL 반환
3. **media_helper_stub.dart** - CDN URL 반환
4. **storage_utils_stub.dart** - localStorage 용량 추정
5. **database_helper_stub.dart** - localStorage 기반
6. **local_storage_stub.dart** - Hive → localStorage (562줄)
7. **notification_stub.dart** - 브라우저 알림
8. **secure_storage_web.dart** - localStorage 보안
9. **hive_stub.dart** - Hive API 스텁

---

## 빌드 프로세스

### 1. 빌드 실행
```bash
cd /home/sanchan/lemonkorean/mobile/lemon_korean
./build_web.sh
```

**빌드 플래그**:
- `--release`: 프로덕션 최적화
- `--base-href=/app/`: Nginx /app/ 경로
- `--web-renderer=canvaskit`: 고품질 렌더링
- `--dart-define=API_URL=https://lemon.3chan.kr`: 런타임 환경 변수

**예상 소요 시간**: 9-10분

### 2. 빌드 검증
```bash
cd /home/sanchan/lemonkorean
./scripts/validate_web_build.sh
```

**검증 항목**:
- Base href가 `/app/`로 설정되었는지
- manifest.json start_url이 `/app/`인지
- main.dart.js 파일 존재 확인
- 빌드 크기 < 20MB

### 3. 배포
```bash
cd /home/sanchan/lemonkorean
docker compose restart nginx
```

**배포 메커니즘**:
- Docker 볼륨 매핑: `./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro`
- Nginx location: `/app/`
- 캐싱: 정적 자산 7일, index.html 캐시 없음

---

## 환경 설정

### index.html
```html
<base href="/app/">
<title>柠檬韩语 - Lemon Korean</title>
<meta name="theme-color" content="#FFC107">
```

### manifest.json
```json
{
  "name": "柠檬韩语 - Lemon Korean",
  "start_url": "/app/",
  "scope": "/app/",
  "theme_color": "#FFC107"
}
```

### .env.production
```env
BASE_URL=https://lemon.3chan.kr
```

**중요**: 모든 URL을 https://로 설정하여 Mixed Content 에러 방지

---

## 검증 및 테스트

### 로컬 테스트
```bash
# Python HTTP 서버로 테스트
cd mobile/lemon_korean/build/web
python3 -m http.server 8080

# 브라우저 접속
# http://localhost:8080
```

### 프로덕션 테스트
1. **접속 확인**
   ```bash
   curl -I https://lemon.3chan.kr/app/
   # HTTP/1.1 200 OK 기대
   ```

2. **브라우저 DevTools (F12)**
   - Console: 에러 없음
   - Network: API 호출 https://lemon.3chan.kr 사용
   - Application > Local Storage: lk_* 키 확인
   - Mixed Content 경고 없음

3. **기능 테스트** (WEB_TEST_CHECKLIST.md 참고)
   - 로그인
   - 레슨 목록 로드
   - 레슨 진입
   - 오디오 재생
   - 설정 저장/로드

---

## 트러블슈팅

### 빌드 실패: dart:io 에러
**원인**: 조건부 export가 제대로 설정되지 않음
**해결**:
```bash
# 스텁 파일 확인
ls lib/core/platform/web/stubs/
# download_manager_stub.dart 등 존재 확인

# 조건부 export 확인
cat lib/core/utils/download_manager.dart
# export ... if (dart.library.html) ...
```

### 404 에러: /app/ 경로
**원인**: base-href 설정 누락
**해결**:
```bash
# index.html 확인
grep '<base href=' mobile/lemon_korean/build/web/index.html
# <base href="/app/"> 기대

# 재빌드
cd mobile/lemon_korean
./build_web.sh
```

### Mixed Content 에러
**원인**: .env.production에 http:// 사용
**해결**:
```bash
# .env.production 수정
sed -i 's/http:/https:/g' .env.production

# 재빌드 필요
./build_web.sh
```

### CORS 에러
**원인**: OPTIONS preflight 처리 실패
**해결**:
```bash
# nginx.conf 확인
grep -A 5 "OPTIONS" /home/sanchan/lemonkorean/nginx/nginx.conf
# if ($request_method = 'OPTIONS') { ... }

# Nginx 재시작
docker compose restart nginx
```

### localStorage 가득 참
**원인**: 브라우저 5-10MB 제한
**해결**:
1. 브라우저 설정 → 사이트 데이터 → lemon.3chan.kr 삭제
2. DevTools → Application → Local Storage → Clear

---

## 성능 최적화

### 빌드 크기 줄이기
```bash
# Tree-shaking (자동)
flutter build web --release

# 불필요한 패키지 제거
flutter pub deps | grep unused
```

### 로딩 속도 개선
- index.html에 로딩 인디케이터 추가 ✅
- canvaskit 렌더러 사용 ✅
- Nginx 정적 자산 캐싱 7일 ✅

### 브라우저 캐싱
- 정적 자산: 7일 (Cache-Control)
- index.html: 캐시 없음 (항상 최신)
- Service Worker: PWA 오프라인 지원

---

## 웹 제한사항

### 지원하지 않는 기능
- ❌ 오프라인 레슨 다운로드
- ❌ 파일 시스템 접근
- ❌ 백그라운드 동기화
- ❌ 대용량 데이터 저장 (>10MB)
- ❌ 음성 대화방 오디오 (LiveKit 웹에서 비활성)
- ❌ DM 음성메시지 녹음 (`record` 패키지 웹 미지원)

### 대안
- ✅ 항상 온라인 모드로 동작
- ✅ CDN에서 미디어 직접 로드
- ✅ 브라우저 자동 캐싱
- ✅ localStorage 소규모 데이터 (설정, 진도)
- ✅ DM 텍스트/이미지 메시지 정상 동작 (Socket.IO 웹 지원)
- ✅ 음성 대화방 UI 표시 (방 목록, 참가자 확인)

### DM on Web (2026-02-10)
- **Socket.IO**: 웹에서 정상 동작 (텍스트/이미지 메시지, 읽음확인, 타이핑 표시)
- **음성 메시지**: 녹음 불가 (`record` 패키지가 웹 미지원), 수신은 가능
- **미디어 업로드**: 이미지 선택/전송 가능 (`image_picker` 웹 지원)

### Voice Rooms on Web (2026-02-10)
- **LiveKit**: `kIsWeb` 체크로 웹에서 스킵 - 오디오 없음
- **UI**: 방 목록 조회, 참가자 확인 가능
- **오디오**: 웹에서는 불가 (모바일 앱 사용 안내)

### 웹 vs 모바일 기능 비교 (DM/Voice)

| 기능 | 모바일 | 웹 |
|------|--------|-----|
| DM 텍스트 메시지 | ✅ | ✅ |
| DM 이미지 전송 | ✅ | ✅ |
| DM 음성 메시지 녹음 | ✅ | ❌ |
| DM 음성 메시지 재생 | ✅ | ✅ |
| 읽음 확인/타이핑 | ✅ | ✅ |
| 온라인 상태 | ✅ | ✅ |
| 음성 대화방 (오디오) | ✅ | ❌ |
| 음성 대화방 (UI) | ✅ | ✅ |

---

## CI/CD 통합 (향후)

### GitHub Actions 예시
```yaml
name: Deploy Flutter Web

on:
  push:
    branches: [main]
    paths:
      - 'mobile/lemon_korean/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: cd mobile/lemon_korean && ./build_web.sh
      - run: ./scripts/validate_web_build.sh
      - run: docker compose restart nginx
```

---

## Automated Web Deployment (2026-02-04)

Admin Dashboard includes one-click automated web deployment.

### Deployment UI

**Access**: Admin Dashboard → Web Deployment (`#/deploy`)

**Features**:
- **Start Deployment**: Single button to trigger full build process
- **Real-time Progress**: 0-100% progress bar with stage indicators
  - Stages: pending → building → syncing → restarting → validating → completed
- **Live Logs**: VS Code-style terminal with auto-scroll
- **Deployment History**: Past 20 deployments with pagination
- **Status Badges**: Visual indicators (running, completed, failed, cancelled)
- **Cancel**: Abort running deployment

### Deployment Process

1. **Git Pull**: Fetch latest changes from repository
2. **Install Dependencies**: Run `flutter pub get`
3. **Build**: Execute `flutter build web --release --base-href=/app/`
4. **Sync**: Copy `build/web/` to nginx directory
5. **Restart**: Restart nginx service
6. **Validate**: HTTP health check to verify deployment
7. **Record**: Log deployment to database with status

**Duration**: ~9-10 minutes

### API Endpoints

Admin Service provides 5 deployment endpoints:

- **POST** `/api/admin/deploy/web/start` - Start new deployment
- **GET** `/api/admin/deploy/web/status/:id` - Get deployment status
- **GET** `/api/admin/deploy/web/logs/:id` - Stream deployment logs
- **GET** `/api/admin/deploy/web/history` - List past deployments
- **DELETE** `/api/admin/deploy/web/:id` - Cancel running deployment

### Concurrency Control

- **Redis Lock**: Prevents simultaneous deployments
- **TTL**: 15-minute auto-expiration
- **User Feedback**: Friendly error message if deployment already running

### Database Tables

- `web_deployments`: Deployment records (id, status, progress, git_commit, etc.)
- `web_deployment_logs`: Real-time log messages (deployment_id, message, timestamp)

### Backend Implementation

- **Service**: `/services/admin/src/services/web-deploy.service.js` (542 lines)
- **Controller**: `/services/admin/src/controllers/deploy.controller.js` (389 lines)
- **Routes**: `/services/admin/src/routes/deploy.routes.js`
- **Frontend**: `/services/admin/public/js/pages/deploy.js`

### Security

- **Admin Auth Required**: All endpoints except status check
- **Audit Logging**: All deployment actions logged
- **Safe Cancellation**: Graceful cleanup on abort

### Troubleshooting

**Deployment Stuck**:
```bash
# Check Redis lock
docker exec lemon-redis redis-cli GET deployment:web:lock

# Force unlock (emergency only)
docker exec lemon-redis redis-cli DEL deployment:web:lock
```

**Build Failed**:
- Check deployment logs in Admin Dashboard
- Verify git repository is clean
- Check disk space: `df -h`

**Nginx Not Restarting**:
```bash
# Manual restart
docker compose restart nginx

# Check nginx logs
docker compose logs nginx
```

---

## 참고 자료

### 프로젝트 문서
- `/CLAUDE.md` - 전체 프로젝트 가이드
- `/mobile/lemon_korean/README.md` - Flutter 앱 가이드
- `/mobile/lemon_korean/WEB_TEST_CHECKLIST.md` - 테스트 체크리스트

### Flutter 웹 문서
- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Flutter Web Renderers](https://docs.flutter.dev/platform-integration/web/renderers)
- [PWA Configuration](https://web.dev/progressive-web-apps/)

---

**마지막 업데이트**: 2026-02-11
**담당**: Claude Opus 4.6

---

## 온보딩 화면 (2026-02-02 추가)

온보딩 플로우는 웹 플랫폼에서도 완전히 동작합니다:
- 6단계 온보딩 (언어→소개→레벨→목표→개인화 완료→계정 선택)
- localStorage에 설정 저장 (lk_setting_*)
- 반응형 디자인 (모바일/태블릿/데스크톱)

### 웹 테스트 체크리스트 (온보딩)
- [ ] 언어 선택 후 즉시 UI 반영
- [ ] 레벨 선택 저장 확인 (DevTools > Application > localStorage)
- [ ] 주간 목표 선택 동작
- [ ] 온보딩 완료 후 홈 화면 이동
- [ ] 새로고침 후에도 온보딩 건너뛰기 (hasCompletedOnboarding=true)
