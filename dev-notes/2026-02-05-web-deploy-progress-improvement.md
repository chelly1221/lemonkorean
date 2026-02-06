---
date: 2026-02-05
category: Backend
title: 웹/APK 배포 진행률 표시 개선 - 로그 파싱 기반 실시간 추적
author: Claude Sonnet 4.5
tags: [admin, deployment, progress-tracking, web-deploy, apk-build, ux-improvement]
priority: high
---

# 웹/APK 배포 진행률 표시 개선

## 개요

웹 배포 및 APK 빌드 시 진행률 바가 0%에 고정되거나 실제 진행 상황을 반영하지 못하는 문제를 해결했습니다. 시간 기반 추정 대신 **실제 빌드 로그를 파싱**하여 단계별 진행률을 추적하도록 개선했습니다.

## 문제점

### 기존 구현의 한계

**Web Deploy (web-deploy.service.js:244-246)**:
```javascript
// 시간 기반 진행률 계산 (문제)
const progress = Math.min(15 + Math.floor((attempts / maxAttempts) * 80), 95);
await updateStatus(deploymentId, 'building', progress);
```

- **시간 기반 추정**: 폴링 시도 횟수(attempts)로 진행률 계산
- **실제 진행과 무관**: 79초 배포 시 22%만 표시
- **미사용 함수 존재**: `updateProgressFromOutput()` 함수가 있었지만 호출되지 않음
- **사용자 경험 저하**: 빌드가 진행 중임에도 0-20%에 고정

### 실제 배포 로그 분석 (deploy-13.log)

```
[13:20:03] Executing build script...
[13:20:03] Building Flutter web app...
[13:20:03] Compiling lib/main.dart for the Web...
[13:23:05] Compiling lib/main.dart for the Web... 172.9s  ← 컴파일 완료
[13:23:05] ✓ Built build/web
[13:23:05] Syncing to NAS deployment directory...
[13:23:07] Restarting nginx...
[13:23:07] Done! Web app deployed to https://lemon.3chan.kr/app/
```

**총 소요 시간**: 184초 (약 3분)

## 해결 방안

### 1. 단계별 진행률 이정표 정의

**Web Deploy Phases (web-deploy.service.js:34-62)**:
```javascript
const WEB_DEPLOY_PHASES = [
  // 초기화 (0-15%)
  { pattern: /Creating deployment trigger/i, progress: 5, status: 'pending' },
  { pattern: /Starting (web )?deployment( \d+)?/i, progress: 10, status: 'building' },

  // 빌드 준비 (15-30%)
  { pattern: /Cleaning previous build/i, progress: 15, status: 'building' },
  { pattern: /Getting dependencies/i, progress: 20, status: 'building' },
  { pattern: /Got dependencies/i, progress: 30, status: 'building' },

  // 컴파일 (30-75%) - 가장 긴 단계
  { pattern: /Building Flutter web app/i, progress: 35, status: 'building' },
  { pattern: /Compiling lib\/main\.dart for the Web\.{3,}$/m, progress: 40, status: 'building' },
  { pattern: /Compiling lib\/main\.dart for the Web\.{3,}\d+\.\d+s$/m, progress: 75, status: 'building' },
  { pattern: /✓ Built build\/web/i, progress: 78, status: 'building' },

  // 배포 (75-95%)
  { pattern: /Syncing to NAS deployment directory/i, progress: 80, status: 'syncing' },
  { pattern: /sending incremental file list/i, progress: 82, status: 'syncing' },
  { pattern: /Restarting nginx/i, progress: 92, status: 'restarting' },

  // 완료 (95-100%)
  { pattern: /Done! Web app deployed/i, progress: 98, status: 'validating' },
  { pattern: /Deployment completed successfully/i, progress: 99, status: 'validating' }
];
```

**APK Build Phases (apk-build.service.js:34-61)**:
```javascript
const APK_BUILD_PHASES = [
  // 초기화 및 의존성 (0-30%)
  { pattern: /Creating build trigger/i, progress: 5, status: 'pending' },
  { pattern: /Getting dependencies/i, progress: 20, status: 'building' },
  { pattern: /Running Gradle task/i, progress: 30, status: 'building' },

  // Gradle 빌드 (30-75%) - 가장 긴 단계
  { pattern: /> Task :app:compileReleaseKotlin/i, progress: 50, status: 'building' },
  { pattern: /Running.*kernel_snapshot/i, progress: 60, status: 'building' },
  { pattern: /Running.*gen_snapshot/i, progress: 70, status: 'building' },
  { pattern: /BUILD SUCCESSFUL/i, progress: 75, status: 'building' },

  // APK 생성 (75-100%)
  { pattern: /✓ Built.*\.apk/i, progress: 85, status: 'building' },
  { pattern: /APK Path:/i, progress: 90, status: 'building' },
  { pattern: /APK build completed successfully/i, progress: 99, status: 'building' }
];
```

### 2. 로그 파싱 함수 구현

**updateProgressFromLog 함수 (web-deploy.service.js:366-397)**:
```javascript
async function updateProgressFromLog(deploymentId, logLine, currentProgress) {
  let newProgress = currentProgress;
  let newStatus = null;

  // 에러 감지 - 즉시 실패 처리
  for (const errorPattern of ERROR_PATTERNS) {
    if (errorPattern.test(logLine)) {
      throw new Error(`Build failed: ${logLine}`);
    }
  }

  // 단계 감지 (역순으로 검사하여 나중 단계 우선)
  for (let i = WEB_DEPLOY_PHASES.length - 1; i >= 0; i--) {
    const phase = WEB_DEPLOY_PHASES[i];
    if (phase.pattern.test(logLine)) {
      // 진행률이 증가하는 경우에만 업데이트
      if (phase.progress > currentProgress) {
        newProgress = phase.progress;
        newStatus = phase.status;
        console.log(`[DEPLOY] Phase detected: ${logLine.substring(0, 60)} → ${newProgress}%`);
        break;
      }
    }
  }

  // 진행률 업데이트 (증가한 경우에만)
  if (newProgress > currentProgress) {
    await pool.query(
      `UPDATE web_deployments SET progress = $1, status = $2
       WHERE id = $3 AND progress < $1`,
      [newProgress, newStatus || 'building', deploymentId]
    );
  }

  return newProgress;
}
```

### 3. executeDeployment 함수 수정

**주요 변경사항**:

1. **currentProgress 변수 추가** (line 158):
```javascript
let currentProgress = 0; // Track current progress for log-based updates
```

2. **로그 읽기 루프에서 파싱 호출** (lines 221-236):
```javascript
for (const line of lines) {
  await appendLog(deploymentId, 'info', line.trim());

  // Log-based progress update
  try {
    currentProgress = await updateProgressFromLog(
      deploymentId,
      line.trim(),
      currentProgress
    );
  } catch (err) {
    // Error detected in log - propagate to outer catch
    throw err;
  }
}
```

3. **시간 기반 진행률 계산 제거 및 폴백 로직 추가** (lines 282-287):
```javascript
// Fallback progress update (only if no log-based progress detected)
// This prevents UI from showing 0% if logs are delayed
if (attempts % 30 === 0 && currentProgress < 15) {
  const fallbackProgress = Math.min(currentProgress + 2, 14);
  await updateStatus(deploymentId, 'building', fallbackProgress);
  currentProgress = fallbackProgress;
  console.log(`[DEPLOY] Fallback progress update: ${fallbackProgress}%`);
}
```

4. **기존 updateProgressFromOutput 함수 삭제**: 미사용 함수 제거

### 4. 에러 감지 패턴 추가

**Web Deploy (web-deploy.service.js:56-62)**:
```javascript
const ERROR_PATTERNS = [
  /Error: Failed to compile/i,
  /Target dart2js failed/i,
  /ProcessException/i,
  /BUILD FAILED/i,
  /Exception:/i,
  /fatal:/i
];
```

**APK Build (apk-build.service.js:57-66)**:
```javascript
const APK_ERROR_PATTERNS = [
  /Error: Failed to compile/i,
  /ProcessException/i,
  /Gradle build failed/i,
  /FAILURE: Build failed/i,
  /Exception:/i,
  /fatal:/i,
  /Could not resolve/i,
  /Task failed/i
];
```

## 수정된 파일

### 필수 수정

1. **`/services/admin/src/services/web-deploy.service.js`**
   - Line 31-62: WEB_DEPLOY_PHASES, ERROR_PATTERNS 상수 추가
   - Line 158: currentProgress 변수 추가
   - Lines 221-236: 로그 파싱 호출 추가
   - Lines 282-287: 시간 기반 진행률 삭제, 폴백 로직 추가
   - Lines 366-397: updateProgressFromOutput → updateProgressFromLog 함수 교체

2. **`/services/admin/src/services/apk-build.service.js`**
   - Line 32-66: APK_BUILD_PHASES, APK_ERROR_PATTERNS 상수 추가
   - Line 157: currentProgress 변수 추가
   - Lines 236-251: 로그 파싱 호출 추가
   - Lines 297-302: 시간 기반 진행률 삭제, 폴백 로직 추가
   - Lines 388-437: updateProgressFromLog 함수 추가

## 기대 효과

### 사용자 경험 개선

- ✅ 배포 시작 30초 이내 진행률 >0% (기존: 79초 후 22%)
- ✅ 컴파일 단계에서 진행률 30-75% 표시 (기존: 0-22%)
- ✅ rsync 단계에서 진행률 80-90% 표시 (기존: 22%)
- ✅ 완료 시 100% 도달 (기존: 95% 고정 후 100%로 점프)

### 기술적 개선

- ✅ 실제 빌드 단계와 진행률 동기화
- ✅ 에러 즉시 감지 (기존: 타임아웃 대기)
- ✅ 진행률이 절대 역행하지 않음 (`progress < $1` 조건)
- ✅ 로그 지연 시 폴백 로직 (1분마다 2% 증가, 15% 한도)

### 문제 진단 용이성

- ✅ 콘솔 로그에 단계 감지 메시지 출력
- ✅ 어느 단계에서 멈췄는지 즉시 확인 가능
- ✅ 실패 시 원인이 되는 로그 라인 포함

## 테스트 계획

### 1. 단위 테스트 (예정)

```javascript
// tests/web-deploy.service.test.js
describe('updateProgressFromLog', () => {
  it('should detect compilation start', async () => {
    const progress = await updateProgressFromLog(
      1,
      'Compiling lib/main.dart for the Web...',
      0
    );
    expect(progress).toBe(40);
  });

  it('should detect compilation completion', async () => {
    const progress = await updateProgressFromLog(
      1,
      'Compiling lib/main.dart for the Web...                            172.9s',
      40
    );
    expect(progress).toBe(75);
  });

  it('should not regress progress', async () => {
    const progress = await updateProgressFromLog(
      1,
      'Getting dependencies...',
      50
    );
    expect(progress).toBe(50); // 20% 단계를 무시
  });
});
```

### 2. 통합 테스트 (예정)

- 실제 배포 로그 파일(deploy-13.log) 재생
- 각 단계별 진행률 증가 검증
- 최종 진행률 99% 이상 확인

### 3. 수동 테스트 (권장)

1. Admin Dashboard에서 "웹 앱 배포" 클릭
2. 진행률 바가 30초 이내 0%에서 벗어나는지 확인
3. 빌드 단계별로 진행률이 증가하는지 확인
4. 로그 출력과 진행률이 동기화되는지 확인
5. 최종 완료 시 100% 도달 확인

## 검증 기준

구현 성공 시:

- ✅ 배포 시작 30초 이내 진행률 >0%
- ✅ 컴파일 단계에서 진행률 30-75% 표시
- ✅ rsync 단계에서 진행률 80-90% 표시
- ✅ 완료 시 100% 도달
- ✅ 실패한 빌드는 10초 이내 감지
- ✅ 진행률이 절대 역행하지 않음
- ✅ 기존 배포 기록 손상 없음

## 위험도 평가

**낮은 위험도**:
- 데이터베이스 스키마 변경 없음
- API 엔드포인트 변경 없음
- 기존 배포 기록과 호환
- 롤백 용이 (파일 복원만으로 가능)

**잠재적 이슈**:
- Flutter 버전 업데이트 시 로그 포맷 변경 가능
  - **완화**: 넓은 정규식 패턴 사용, 폴백 로직 구현
- 예상치 못한 로그 출력
  - **완화**: 패턴 미매칭 시 로깅, 시간 기반 폴백

## 배포 방법

```bash
# Admin 서비스 재시작
docker compose restart admin-service

# 로그 확인
docker compose logs -f admin-service
```

## 후속 작업 (선택)

1. **프론트엔드 개선** (deploy.js:391-416):
   - 상태별 한글 메시지 세분화
   - 예: "빌드 중" → "빌드 중 - 컴파일", "빌드 중 - 의존성 다운로드"

2. **단위/통합 테스트 작성**:
   - `tests/web-deploy.service.test.js`
   - `tests/apk-build.service.test.js`

3. **로그 재생 도구 개발**:
   - 과거 배포 로그로 진행률 추적 검증
   - 새로운 패턴 발견 시 업데이트

## 관련 문서

- `/docs/API.md` - Admin API 엔드포인트
- `/services/admin/DASHBOARD.md` - Admin Dashboard 사용법
- `/scripts/deploy-trigger/README.md` - 배포 트리거 시스템
- `/mobile/lemon_korean/WEB_DEPLOYMENT_GUIDE.md` - 웹 배포 가이드

## 참고

- 실제 배포 로그: `deploy-13.log` (184초 소요, 3분)
- 기존 미사용 함수: `updateProgressFromOutput()` (삭제됨)
- 폴백 로직: 1분(30 attempts * 2초)마다 2% 증가, 15% 한도

---

**마지막 업데이트**: 2026-02-05
**상태**: ✅ 구현 완료, 테스트 대기
**영향 범위**: Admin 서비스 (web-deploy, apk-build)
