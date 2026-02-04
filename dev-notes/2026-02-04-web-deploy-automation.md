---
date: 2026-02-04
category: Backend + Frontend
title: 웹 배포 자동화 기능 구현
author: Claude Sonnet 4.5
tags: [admin-dashboard, deployment, automation, flutter-web]
priority: high
---

# 웹 배포 자동화 기능 구현

## 개요

관리자 대시보드에 Flutter 웹 앱 배포를 자동화하는 기능을 추가했습니다. 기존의 수동 SSH 배포 프로세스를 대체하여 관리자 UI에서 원클릭으로 배포할 수 있습니다.

## 구현 내용

### 1. 데이터베이스 스키마

**Migration File**: `database/postgres/migrations/003_add_web_deployments.sql`

#### `web_deployments` 테이블
- 배포 이력 및 상태 추적
- 필드: ID, 관리자 정보, 상태, 진행률, 시작/완료 시간, 소요 시간, 에러 메시지, Git 정보

#### `web_deployment_logs` 테이블
- 실시간 배포 로그 저장
- 필드: ID, 배포 ID, 로그 타입 (info/error/warning), 메시지, 타임스탬프

#### 인덱스
- `admin_id`, `status`, `started_at`에 인덱스 추가하여 빠른 조회 지원

### 2. 백엔드 서비스

#### 파일 구조
```
services/admin/src/
├── services/web-deploy.service.js    # 핵심 배포 로직
├── controllers/deploy.controller.js  # HTTP 핸들러
└── routes/deploy.routes.js           # API 라우트 정의
```

#### 주요 기능

**web-deploy.service.js**:
- `startDeployment()`: 배포 시작, Redis 락 획득, 비동기 실행
- `executeDeployment()`: build_web.sh 실행, 실시간 로그 캡처, 진행률 업데이트
- `getDeploymentStatus()`: 배포 상태 조회
- `getDeploymentLogs()`: 로그 조회 (폴링 지원)
- `listDeploymentHistory()`: 배포 이력 조회
- `cancelDeployment()`: 배포 취소

**동시성 제어**:
- Redis 락 (`deploy:web:lock`) 사용하여 동시 배포 방지
- TTL 15분 설정으로 자동 만료

**진행률 추적**:
- Flutter 빌드 출력을 파싱하여 진행률 자동 업데이트
- 단계: Building (20-60%) → Syncing (90%) → Restarting (95%) → Validating (98%) → Completed (100%)

**로그 캡처**:
- stdout/stderr 실시간 캡처 및 DB 저장
- 로그 타입별 분류 (info/error/warning)
- 메시지 길이 제한 (2000자)

**배포 검증**:
- 완료 후 `https://lemon.3chan.kr/app/` HTTP 체크
- 응답 실패 시 배포를 failed로 마킹

### 3. API 엔드포인트

모든 엔드포인트는 인증 및 관리자 권한 필요:

| 메서드 | 경로 | 설명 |
|--------|------|------|
| POST | `/api/admin/deploy/web/start` | 배포 시작 |
| GET | `/api/admin/deploy/web/status/:id` | 배포 상태 조회 |
| GET | `/api/admin/deploy/web/logs/:id?since=N` | 배포 로그 조회 (폴링) |
| GET | `/api/admin/deploy/web/history?page=N&limit=N` | 배포 이력 조회 |
| DELETE | `/api/admin/deploy/web/:id` | 배포 취소 |

### 4. 프론트엔드 UI

**파일**: `services/admin/public/js/pages/deploy.js`

#### 주요 기능
1. **배포 버튼**: 원클릭 배포 시작
2. **실시간 진행률**: 프로그레스 바 + 경과 시간 표시
3. **실시간 로그**: 터미널 스타일 로그 뷰어 (자동 스크롤, 색상 구분)
4. **배포 이력**: 테이블 형태로 이력 표시
5. **배포 취소**: 진행 중 배포 취소 기능
6. **토스트 알림**: 배포 완료/실패 시 알림

#### 폴링 메커니즘
- 2초마다 상태 및 로그 폴링
- `sinceId` 파라미터로 증분 로그만 가져오기
- 완료/실패/취소 시 자동 정지

#### 로그 뷰어
- VS Code 다크 테마 스타일 (`#1e1e1e` 배경)
- 타임스탬프 + 색상별 로그 타입
- 자동 스크롤, 최대 500줄 제한

### 5. 통합

#### 라우터 (`router.js`)
```javascript
register('/deploy', DeployPage.render, true);
```

#### 사이드바 (`sidebar.js`)
- 아이콘: `fa-rocket`
- 라벨: "웹 배포"
- 위치: 시스템 모니터링과 개발 문서 사이

#### API 클라이언트 (`api-client.js`)
```javascript
API.deploy.startWeb()
API.deploy.getStatus(deploymentId)
API.deploy.getLogs(deploymentId, sinceId)
API.deploy.listHistory(params)
API.deploy.cancel(deploymentId)
```

## 기술 스택

- **Backend**: Node.js, Express, PostgreSQL, Redis
- **Frontend**: Vanilla JavaScript, Bootstrap 5
- **Child Process**: `exec()` for shell command execution
- **Concurrency**: Redis-based distributed lock

## 보안

- ✅ 모든 API는 JWT 인증 + 관리자 권한 필요
- ✅ Audit logging (배포 시작/취소)
- ✅ Redis 락으로 동시 배포 방지
- ✅ 에러 메시지 민감정보 제거 (프로덕션)

## 제한사항 및 향후 개선 (v2)

### 현재 버전 (v1)
- ✅ 수동 배포만 지원 (스케줄링 없음)
- ✅ 롤백 기능 없음
- ✅ 토스트 알림만 지원 (브라우저/이메일 알림 없음)

### 향후 개선 사항
- 롤백 기능 (이전 배포로 복원)
- 배포 스케줄링 (Cron)
- 브라우저 Push 알림
- 이메일/Slack/Discord 알림
- 특정 Git 브랜치/커밋에서 배포
- 사전/사후 배포 헬스 체크
- 배포 백업 관리 (최근 5개 유지)

## 테스트 방법

### 1. 관리자 대시보드 접속
```
https://lemon.3chan.kr/admin/#/deploy
```

### 2. 배포 시작
- "웹 앱 배포" 버튼 클릭
- 확인 모달에서 확인
- 진행률 및 로그 실시간 모니터링

### 3. 검증
- 약 9-10분 후 완료
- `https://lemon.3chan.kr/app/` 접속하여 앱 확인
- 배포 이력에서 상태 확인

### 4. API 수동 테스트
```bash
# 로그인
curl -X POST http://localhost:3006/api/admin/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "admin@lemon.com", "password": "your_password"}'

# 배포 시작
curl -X POST http://localhost:3006/api/admin/deploy/web/start \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 상태 확인
curl http://localhost:3006/api/admin/deploy/web/status/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# 로그 확인
curl http://localhost:3006/api/admin/deploy/web/logs/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## 파일 변경 사항

### 신규 파일 (5개)
1. `database/postgres/migrations/003_add_web_deployments.sql`
2. `services/admin/src/services/web-deploy.service.js`
3. `services/admin/src/controllers/deploy.controller.js`
4. `services/admin/src/routes/deploy.routes.js`
5. `services/admin/public/js/pages/deploy.js`

### 수정 파일 (5개)
1. `services/admin/src/index.js` - 라우트 등록
2. `services/admin/public/js/api-client.js` - deploy API 추가
3. `services/admin/public/js/router.js` - /deploy 라우트 등록
4. `services/admin/public/js/components/sidebar.js` - 메뉴 아이템 추가
5. `services/admin/public/index.html` - deploy.js 스크립트 태그 추가

## 배포 워크플로우

```
1. 관리자가 "웹 앱 배포" 클릭
   ↓
2. Redis 락 획득 (동시 배포 방지)
   ↓
3. DB에 배포 레코드 생성 (pending)
   ↓
4. build_web.sh 비동기 실행
   ↓
5. 실시간 stdout/stderr 캡처
   - DB에 로그 저장
   - 진행률 업데이트
   ↓
6. 빌드 완료 후 배포 검증
   - HTTP HEAD 요청으로 앱 접근성 확인
   ↓
7. 배포 완료 또는 실패 마킹
   ↓
8. Redis 락 해제
   ↓
9. 관리자에게 토스트 알림
```

## 성능 고려사항

- **빌드 시간**: 9-10분 (Flutter 웹 빌드 특성)
- **폴링 주기**: 2초 (상태 + 로그)
- **로그 제한**:
  - UI: 최대 500줄
  - DB: 메시지당 2000자
- **동시 배포**: Redis 락으로 1개만 허용

## 에러 처리

1. **동시 배포 시도**: 409 Conflict 반환
2. **빌드 스크립트 실패**: 에러 로그 캡처 + failed 상태
3. **검증 실패**: 배포 완료되었으나 앱 접근 불가 → failed
4. **취소**: 배포 레코드를 cancelled로 마킹, 락 해제

## 모니터링

- 배포 이력은 `web_deployments` 테이블에 영구 저장
- 감사 로그에 배포 시작/취소 기록
- Admin 대시보드에서 이력 조회 가능

## 참고사항

- 기존 `build_web.sh` 스크립트를 재사용 (변경 없음)
- 컨테이너에서 호스트의 스크립트 실행 (`/project` 마운트)
- Redis는 admin 서비스의 기존 연결 재사용
- PostgreSQL 커넥션 풀 사용

## 결론

이 구현으로 인해 웹 앱 배포가 수동 SSH 작업에서 관리자 UI의 원클릭 프로세스로 전환되었습니다. 실시간 진행률 추적과 로그 모니터링을 통해 배포 프로세스의 투명성과 편의성이 크게 향상되었습니다.

---

**구현 완료일**: 2026-02-04
**테스트 상태**: ✅ 백엔드 서비스 정상 기동 확인
**다음 단계**: 실제 배포 테스트 및 사용자 피드백 수집
