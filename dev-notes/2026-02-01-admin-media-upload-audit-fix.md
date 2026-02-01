---
date: 2026-02-01
category: Backend
title: Admin 미디어 업로드 시 Audit 로그 상태값 수정
author: Claude Opus 4.5
tags: [bugfix, admin, audit, database]
priority: medium
---

# Admin 미디어 업로드 Audit 로그 수정

## 개요
Admin 웹에서 미디어 업로드 시 발생하던 500 Internal Server Error 원인 중 하나인 audit 로그 상태값 불일치 문제를 수정했습니다.

## 문제 / 배경
Admin 대시보드에서 PNG 파일 업로드 시 500 에러가 발생했습니다. 원인 분석 결과, audit middleware에서 실패 상태를 기록할 때 `'failure'`를 사용하고 있었으나, PostgreSQL의 `admin_audit_logs` 테이블 제약조건은 `'success'`, `'failed'`, `'pending'`만 허용하고 있었습니다.

이로 인해 업로드 실패 시 audit 로그 기록이 DB 제약조건 위반으로 실패하여 에러 추적이 불가능했습니다.

## 해결 / 구현
`audit.middleware.js`에서 상태값을 DB 제약조건에 맞게 수정했습니다.

## 변경 파일
- `/services/admin/src/middleware/audit.middleware.js` - 상태값 `'failure'` → `'failed'` 수정

## 코드 예시

```javascript
// Before (라인 23)
const status = res.statusCode >= 200 && res.statusCode < 300 ? 'success' : 'failure';

// After
// DB constraint allows: 'success', 'failed', 'pending'
const status = res.statusCode >= 200 && res.statusCode < 300 ? 'success' : 'failed';
```

## 테스트

### 서비스 재시작
```bash
docker compose restart admin-service
```

### 업로드 테스트
1. Admin 웹 (https://lemon.3chan.kr/admin/) → 미디어 관리
2. PNG 파일 드래그 앤 드롭 또는 클릭하여 업로드
3. "업로드 완료" 메시지 확인

### Audit 로그 확인
```bash
docker compose exec -T postgres psql -U 3chan -d lemon_korean \
  -c "SELECT action, status, created_at FROM admin_audit_logs ORDER BY id DESC LIMIT 5;"
```

## 관련 이슈 / 참고
- MinIO 리전 설정은 이미 `us-east-1`로 설정되어 있음 (`/services/admin/src/config/minio.js`)
- DB 제약조건: `admin_audit_logs_status_check CHECK (status IN ('success', 'failed', 'pending'))`
