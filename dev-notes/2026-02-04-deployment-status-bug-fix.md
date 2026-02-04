---
date: 2026-02-04
category: Backend
title: 웹 배포 상태 업데이트 버그 수정
author: Claude Sonnet 4.5
tags: [bugfix, deployment, admin, critical]
priority: critical
---

## 문제 설명

배포가 성공적으로 완료된 후에도 Admin UI에서 상태가 "빌드 중"에서 "완료"로 변경되지 않는 버그가 발생했습니다.

### 증상

- 배포 에이전트가 빌드를 성공적으로 완료함 (~9-10분)
- 상태 파일에 "SUCCESS" 기록됨
- 서비스가 SUCCESS를 감지하고 로그를 기록함
- **하지만 데이터베이스 상태가 "building"에 멈춰있음**
- UI에서 진행률이 95%에서 멈춤
- 완료 알림(toast) 표시되지 않음
- 배포 버튼이 비활성화 상태로 유지됨

### 사용자 영향

- 배포 완료 여부를 알 수 없음
- 새로운 배포를 시작할 수 없음 (Redis lock 때문에)
- 관리자가 수동으로 데이터베이스 확인 필요

## 원인 분석

**파일**: `services/admin/src/services/web-deploy.service.js`
**함수**: `executeDeployment()` (71-275행)
**문제**: 제어 흐름 로직 오류

### 버그가 있던 코드 (143-158행)

```javascript
if (status.includes('SUCCESS')) {
  await appendLog(deploymentId, 'info', '✅ Build completed successfully!');

  // Cleanup
  await fs.unlink(triggerFile).catch(() => {});
  await fs.unlink(statusFile).catch(() => {});
  await fs.unlink(logFile).catch(() => {});

  // ❌ 여기서 함수 종료 - 데이터베이스 업데이트 코드에 도달하지 못함!
  return {
    stdout: { on: () => {} },
    stderr: { on: () => {} },
    on: (event, cb) => {
      if (event === 'close') setTimeout(() => cb(0), 0);
    }
  };
}
```

### 실행되지 않던 코드 (234-252행)

```javascript
// Validate deployment (도달 불가)
await updateStatus(deploymentId, 'validating', 98);
await appendLog(deploymentId, 'info', 'Validating deployment...');

const isValid = await validateDeployment();
if (!isValid) {
  throw new Error('Deployment validation failed - app not accessible');
}

// Mark as completed (도달 불가)
const duration = Math.floor((Date.now() - startTime) / 1000);
await pool.query(
  `UPDATE web_deployments
   SET status = 'completed', progress = 100,
       completed_at = NOW(), duration_seconds = $1
   WHERE id = $2`,
  [duration, deploymentId]
);

await appendLog(deploymentId, 'info', `✅ Deployment completed successfully in ${duration}s`);
```

### 부가 문제

1. **죽은 코드** (181-232행): 이전 직접 실행 모델의 잔여 코드 (도달 불가)
2. **누락된 검증**: `validateDeployment()` 함수가 실행되지 않음
3. **아키텍처 불일치**: 파일 기반과 프로세스 기반 패턴 혼재

## 해결 방법

### 변경 사항 1: Early Return을 Break로 교체 (152행)

**수정 전:**
```javascript
// Create dummy process for compatibility
return {
  stdout: { on: () => {} },
  stderr: { on: () => {} },
  on: (event, cb) => {
    if (event === 'close') setTimeout(() => cb(0), 0);
  }
};
```

**수정 후:**
```javascript
// Break out of monitoring loop to continue to validation
break;
```

### 변경 사항 2: 죽은 코드 제거 (181-232행)

삭제된 섹션:
- `const buildProcess = null;` 선언
- stdout/stderr 이벤트 핸들러 (186-212행)
- 프로세스 완료 핸들러 (215-227행)
- 버퍼 플러시 코드 (229-232행)

### 변경 사항 3: 검증 및 완료 코드 유지 (174-194행)

이제 `break`로 루프를 빠져나온 후 이 코드가 실행됨:
1. 배포 검증 (https://lemon.3chan.kr/app/ 접근 가능 확인)
2. 데이터베이스 상태 업데이트 → `'completed'`, progress = 100
3. 지속 시간 기록
4. 완료 로그 작성

## 수정 후 실행 흐름

### 성공 시나리오

```
1. 배포 에이전트가 빌드 완료 → status 파일에 "SUCCESS" 기록
2. 서비스가 SUCCESS 감지 → 완료 로그 작성, 파일 정리
3. 루프 종료 (break) → 실행 계속
4. 배포 검증 → https://lemon.3chan.kr/app/ 접근 확인
5. ✅ 데이터베이스 업데이트:
   - status = 'completed'
   - progress = 100
   - completed_at = NOW()
   - duration_seconds = ~540 (9분)
6. 최종 로그 작성 → "✅ Deployment completed successfully in 540s"
7. Redis lock 해제 (finally 블록)
8. UI가 상태 폴링 → "completed" 수신
9. 토스트 알림 표시 → "✅ 배포가 완료되었습니다!"
```

### 실패 시나리오

```
1. 배포 에이전트 실패 → status 파일에 "FAILED" 기록
2. 서비스가 FAILED 감지 → Error throw
3. Catch 블록 실행:
   - status = 'failed' 설정
   - 오류 메시지 기록
4. Redis lock 해제
5. UI에 에러 표시 → "❌ 배포가 실패했습니다."
```

## 테스트

### 적용된 변경사항

```bash
# 파일 수정 확인
git diff services/admin/src/services/web-deploy.service.js

# 서비스 재시작
docker compose restart admin-service

# 로그 확인
docker logs lemon-admin-service --tail 20
```

### 서비스 재시작 결과

```
Container lemon-admin-service Restarting
Container lemon-admin-service Started
```

서비스가 오류 없이 정상 시작됨을 확인했습니다.

### 다음 배포에서 검증 필요

- [ ] 배포 시작 → 상태가 "building"으로 변경
- [ ] 빌드 완료 (9-10분 후) → 상태가 "validating"으로 변경
- [ ] 검증 완료 → 상태가 "completed"로 변경 ✅
- [ ] 진행률이 100%에 도달
- [ ] 지속 시간이 기록됨
- [ ] 토스트 알림이 표시됨
- [ ] 히스토리 테이블에 "완료" 배지 표시
- [ ] 배포 버튼이 다시 활성화됨
- [ ] 새로운 배포를 시작할 수 있음

## 영향 평가

**심각도**: Critical
**영향받는 사용자**: Admin UI의 웹 배포 기능을 사용하는 모든 관리자
**데이터 손실 위험**: 없음 (읽기 전용 버그)
**다운타임**: ~5초 (서비스 재시작)

**수정으로 얻는 이점**:
- ✅ 관리자가 배포 완료 시점을 정확히 알 수 있음
- ✅ 토스트 알림이 정상 작동
- ✅ 배포 버튼이 자동으로 재활성화됨
- ✅ 히스토리에 정확한 상태 표시
- ✅ 배포 검증이 실행됨
- ✅ 정확한 지속 시간 추적

## 교훈

### 왜 테스트에서 발견하지 못했나?

초기 테스트 중에는 배포를 30초만 모니터링했습니다 (3초 간격으로 10번 체크). 실제 빌드는 9-10분이 걸리므로 완료 시점을 볼 수 없었습니다. 버그는 완료 시에만 나타납니다.

### 개선 사항

향후 고려사항:
1. `executeDeployment` 함수에 대한 단위 테스트 추가
2. 전체 배포 사이클을 모의하는 통합 테스트 추가
3. 15분 이상 걸리는 배포에 대한 타임아웃 알림 추가
4. 배포 시스템 상태를 확인하는 헬스 체크 엔드포인트 추가

## 기술 정보

**변경된 파일**: `services/admin/src/services/web-deploy.service.js`
**변경된 줄 수**: ~10줄 수정, ~50줄 삭제 (죽은 코드)
**위험도**: 낮음 (단순 제어 흐름 수정)
**테스트 방법**: 전체 배포 사이클로 수동 검증

## 요약

배포 완료 시 데이터베이스 업데이트 코드가 실행되지 않는 제어 흐름 버그를 수정했습니다. SUCCESS 감지 후 early return을 break로 교체하여 검증 및 완료 코드가 실행되도록 했습니다. 이로써 배포 상태가 "completed"로 정상 전환되고, 관리자가 배포 완료를 정확히 파악할 수 있게 되었습니다.
