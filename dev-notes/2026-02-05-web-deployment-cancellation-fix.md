---
date: 2026-02-05
category: Backend
title: 웹 배포 취소 및 중단 배포 복구 기능 구현
author: Claude Sonnet 4.5
tags: [deployment, bug-fix, admin, reliability]
priority: high
---

## 문제 상황

웹 배포 시스템에 두 가지 중요한 문제가 발견됨:

1. **배포 취소 버튼 작동 안 함**
   - "배포 취소" 버튼을 눌러도 배포가 계속 진행됨
   - DB 상태만 'cancelled'로 변경되고 실제 배포 프로세스는 계속 실행
   - 배포 완료 시 상태가 'completed'로 덮어씌워짐

2. **오래된 배포가 "진행 중" 상태로 고착**
   - 15분 타임아웃 시 DB 업데이트가 실패하면 상태가 영구적으로 'building'으로 남음
   - 프론트엔드가 이전 배포를 계속 폴링하려고 시도
   - 새 배포를 시작할 수 없음

## 근본 원인 분석

### 취소 버튼 문제
- `cancelDeployment()`가 DB 상태만 업데이트하고 Redis 락만 해제
- `executeDeployment()`의 비동기 루프는 취소 신호를 전혀 확인하지 않음
- 파일 기반 트리거 시스템에 취소 메커니즘이 없음

### 중단 배포 문제
- DB 업데이트 실패 시 재시도 로직 없음
- 에러 핸들러에서 `pool.query()` 실패 시 예외가 조용히 무시됨
- 프론트엔드가 배포 나이를 확인하지 않음

## 구현 내용

### 1. 취소 신호 메커니즘 추가

**파일**: `services/admin/src/services/web-deploy.service.js`

#### a) 취소 플래그 추가
```javascript
async function executeDeployment(deploymentId) {
  const startTime = Date.now();
  let isCancelled = false; // 취소 상태 추적
```

#### b) 모니터링 루프에서 취소 파일 확인
```javascript
while (attempts < maxAttempts && !isCancelled) {
  // 취소 신호 파일 체크
  const cancelFile = path.join(triggerDir, `deploy-${deploymentId}.cancel`);
  try {
    await fs.access(cancelFile);
    isCancelled = true;
    await fs.unlink(cancelFile).catch(() => {});
    throw new Error('Deployment cancelled by admin');
  } catch (err) {
    if (err.code !== 'ENOENT' && err.message.includes('cancelled')) {
      throw err;
    }
  }
  // ... 나머지 로직
}
```

#### c) cancelDeployment()에서 취소 파일 생성
```javascript
async function cancelDeployment(deploymentId) {
  // DB 상태 업데이트
  const result = await pool.query(/* ... */);

  // 취소 신호 파일 생성
  const cancelFile = path.join(triggerDir, `deploy-${deploymentId}.cancel`);
  await fs.writeFile(cancelFile, 'CANCEL', 'utf8');

  // 락 해제
  await redis.del(DEPLOY_LOCK_KEY);
  await appendLog(deploymentId, 'warning', 'Deployment cancelled by admin');
}
```

### 2. 견고한 DB 업데이트 재시도 로직

**새 함수**: `updateStatusWithRetry()`

```javascript
async function updateStatusWithRetry(deploymentId, status, options = {}) {
  const maxRetries = 3;
  const { completedAt, duration, errorMessage, progress } = options;

  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      // DB 업데이트 시도
      await pool.query(/* ... */);
      return; // 성공
    } catch (err) {
      console.error(`[DEPLOY] Status update attempt ${attempt} failed:`, err);

      if (attempt === maxRetries) {
        // 마지막 시도 실패 - 복구 로그 작성
        const recoveryLog = '/app/src/deploy-triggers/status-update-failures.log';
        const entry = JSON.stringify({
          deploymentId, status, options,
          timestamp: new Date().toISOString(),
          error: err.message
        }) + '\n';
        await fs.appendFile(recoveryLog, entry);
        throw err;
      }

      // 지수 백오프: 1s, 2s, 4s
      await new Promise(resolve =>
        setTimeout(resolve, Math.pow(2, attempt - 1) * 1000)
      );
    }
  }
}
```

**적용 위치**:
- 배포 완료 시 (line 185-192)
- 배포 실패 시 (line 196-209)

### 3. 프론트엔드 중단 배포 감지

**파일**: `services/admin/public/js/pages/deploy.js`

#### a) checkActiveDeployment()에 나이 확인 추가
```javascript
async function checkActiveDeployment() {
  const history = await API.deploy.listHistory({ limit: 1 });
  if (history.data.length > 0) {
    const latest = history.data[0];

    if (['pending', 'building', ...].includes(latest.status)) {
      // 배포 나이 확인 (20분 초과 시 중단된 것으로 간주)
      const startedAt = new Date(latest.started_at).getTime();
      const ageMinutes = (Date.now() - startedAt) / 1000 / 60;

      if (ageMinutes > 20) {
        console.warn(`Deployment ${latest.id} is stale`);
        Toast.warning('이전 배포가 응답하지 않습니다. 새로 배포를 시작하세요.');
        return; // 폴링 재개하지 않음
      }

      // 정상 배포면 폴링 시작
      startPolling();
    }
  }
}
```

#### b) 폴링 타임아웃 추가
```javascript
function startPolling() {
  const POLLING_TIMEOUT = 20 * 60 * 1000; // 20분
  const pollingStartTime = Date.now();

  statusInterval = setInterval(async () => {
    // 타임아웃 체크
    if (Date.now() - pollingStartTime > POLLING_TIMEOUT) {
      stopPolling();
      Toast.error('배포 타임아웃 - 배포가 20분 이상 응답하지 않습니다.');
      // 배포 버튼 활성화
      return;
    }

    // ... 정상 폴링 로직
  }, 2000);
}
```

## 기술적 세부사항

### 파일 기반 취소 시그널
- **위치**: `/app/src/deploy-triggers/deploy-{id}.cancel`
- **내용**: 단순 텍스트 "CANCEL"
- **라이프사이클**:
  1. `cancelDeployment()` 호출 시 생성
  2. `executeDeployment()` 루프에서 2초마다 확인
  3. 감지 즉시 삭제 후 에러 발생
  4. 에러가 catch 블록으로 전파되어 상태 업데이트

### 재시도 전략
- **최대 재시도**: 3회
- **백오프**: 지수 (1s → 2s → 4s)
- **실패 시**: `/app/src/deploy-triggers/status-update-failures.log`에 JSON 기록
- **복구 방법**: 로그 파일 확인 후 수동으로 DB 업데이트

### 타임아웃 정책
- **백엔드**: 15분 (450번 * 2초 = 900초)
- **프론트엔드**: 20분 (폴링 타임아웃 + 중단 배포 감지)
- **이유**: 프론트엔드가 백엔드보다 5분 더 여유를 두어 정상적인 타임아웃 메시지를 받을 수 있도록 함

## 테스트 시나리오

### ✅ 테스트 1: 취소 기능
1. 웹 배포 시작
2. 1-2분 후 "배포 취소" 클릭
3. **예상 결과**:
   - 2-4초 내 상태가 'cancelled'로 변경
   - 로그에 "Deployment cancelled by admin" 표시
   - 배포 버튼 재활성화
   - 배포가 완료되지 않음

### ✅ 테스트 2: 중단 배포 처리
1. Deploy agent 중지: `systemctl stop lemon-deploy-agent`
2. 배포 시작
3. 15분 이상 대기
4. **예상 결과**:
   - 타임아웃 후 상태가 'failed'로 변경
   - 에러 메시지에 타임아웃 표시
   - 새 배포 시작 가능

### ✅ 테스트 3: 중단 배포 감지
1. DB에서 임의 배포의 상태를 'building', 시작 시간을 25분 전으로 설정
2. 관리자 페이지 새로고침
3. **예상 결과**:
   - 중단된 배포 폴링하지 않음
   - 경고 토스트 표시
   - 배포 버튼 활성화

### ✅ 테스트 4: DB 실패 복구
1. 배포 중 임시로 DB 연결 끊기
2. 배포 완료/실패 대기
3. `/app/src/deploy-triggers/status-update-failures.log` 확인
4. 로그 내용 기반으로 수동 상태 업데이트

## 영향 받는 파일

### Backend
- `services/admin/src/services/web-deploy.service.js` (주요 변경)
  - `updateStatusWithRetry()` 함수 추가
  - `executeDeployment()` 취소 확인 로직 추가
  - `cancelDeployment()` 취소 파일 생성 로직 추가
  - DB 업데이트를 재시도 로직으로 교체

### Frontend
- `services/admin/public/js/pages/deploy.js`
  - `checkActiveDeployment()` 중단 배포 감지 추가
  - `startPolling()` 타임아웃 보호 추가

## 배포 방법

```bash
# 변경사항 적용
docker compose restart admin-service

# 로그 확인
docker compose logs -f admin-service
```

## 향후 개선 사항

1. **호스트 측 Deploy Agent 개선** (옵션)
   - Agent도 취소 파일을 확인하여 빌드 프로세스를 graceful하게 종료
   - 현재는 컨테이너 측 취소만 작동하지만, 호스트 측도 개선하면 더 깨끗한 정리 가능

2. **자동 복구 스크립트**
   - `status-update-failures.log`를 모니터링하여 자동으로 DB 업데이트
   - Cron job으로 실행

3. **Prometheus 메트릭 추가**
   - 취소된 배포 수
   - 타임아웃된 배포 수
   - DB 업데이트 재시도 횟수

## 롤백 계획

문제 발생 시:
1. Git에서 이전 버전으로 되돌리기
2. 서비스 재시작
3. 원래 동작 복원 (취소 없음, 재시도 없음, 중단 감지 없음)

## 참고사항

- 취소 신호는 파일 기반으로 작동 (Docker 볼륨 공유 필요)
- DB 연결 실패는 최대 3회까지만 재시도
- 20분 이상 경과한 배포는 프론트엔드에서 자동으로 무시됨
- 복구 로그는 수동 확인 및 처리 필요

## 커밋 정보

- **커밋 메시지**: Fix web deployment cancellation and handle stuck deployments
- **영향 범위**: Admin 서비스 (배포 시스템)
- **하위 호환성**: 완전 호환 (기존 배포 동작 변경 없음)
