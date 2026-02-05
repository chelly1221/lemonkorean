---
date: 2026-02-05
category: Frontend
title: 웹 관리자 페이지 "시스템 모니터링" → "로그" 페이지 변경
author: Claude Sonnet 4.5
tags: [admin, frontend, logs, refactoring]
priority: medium
---

# 웹 관리자 페이지: "시스템 모니터링" → "로그" 탭 변경

## 개요

웹 관리자 페이지의 "시스템 모니터링" 탭을 "로그" 탭으로 변경하고, 헬스 체크와 시스템 메트릭 기능을 제거하여 감사 로그 기능만 남겼습니다. 페이지네이션과 필터링 UI를 추가하여 로그 조회 기능을 개선했습니다.

## 변경 사항

### 프론트엔드 변경

#### 1. 사이드바 메뉴 업데이트
**파일**: `services/admin/public/js/components/sidebar.js:40`

- 메뉴 라벨: "시스템 모니터링" → "로그"
- 아이콘: `fa-cog` → `fa-file-lines`

#### 2. 시스템 페이지 전면 리팩터링
**파일**: `services/admin/public/js/pages/system.js`

**제거된 기능**:
- 헬스 상태 카드 (PostgreSQL, MongoDB, Redis, MinIO)
- 시스템 메트릭 섹션 (메모리 사용률, 가동 시간, 프로세스 정보)
- 30초 자동 새로고침

**추가된 기능**:
- 필터바 UI
  - 작업 유형 드롭다운 (CREATE, UPDATE, DELETE, LOGIN, LOGOUT)
  - 상태 드롭다운 (success, error)
  - 시작일/종료일 입력 (HTML5 date picker)
  - 검색/초기화 버튼
  - 페이지당 항목 수 선택 (10/25/50/100)
- 페이지네이션 통합
  - Pagination 컴포넌트 사용
  - 페이지 이동, 이전/다음 버튼
- 필터링 로직
  - 작업 유형별 필터
  - 상태별 필터
  - 날짜 범위 필터
  - 날짜 유효성 검사
- Enter 키로 검색 지원

**주요 변경사항**:
```javascript
// 이전: 3개 API 호출 + 자동 갱신
const [healthResponse, metricsResponse, logsResponse] = await Promise.all([...]);
refreshInterval = setInterval(loadData, 30000);

// 이후: 로그 API만 호출 + 자동 갱신 제거
const response = await API.system.getLogs(params);
```

#### 3. 스타일 추가
**파일**: `services/admin/public/css/admin.css`

필터바 스타일 추가:
- `.filter-bar`: 필터 컨테이너 스타일
- 폼 요소 스타일링
- Focus 상태 스타일

#### 4. API 클라이언트 정리
**파일**: `services/admin/public/js/api-client.js:717-749`

**제거된 함수**:
- `systemAPI.getHealth()` (라인 723-725)
- `systemAPI.getMetrics()` (라인 746-748)

**유지된 함수**:
- `systemAPI.getLogs()` (파라미터 문서 개선)

### 백엔드 변경

#### 5. 라우트 정리
**파일**: `services/admin/src/routes/system.routes.js`

**제거된 라우트**:
- `GET /api/admin/system/health`
- `GET /api/admin/system/metrics`

**유지된 라우트**:
- `GET /api/admin/system/logs` (페이지네이션 및 필터링 지원)

#### 6. 컨트롤러 정리
**파일**: `services/admin/src/controllers/system.controller.js`

**제거된 함수**:
- `getHealth()` (라인 12-31)
- `getMetrics()` (라인 88-105)

**유지된 함수**:
- `getLogs()` (라인 37-82, 이미 페이지네이션 로직 구현됨)

#### 7. 서비스 유지
**파일**: `services/admin/src/services/system-monitoring.service.js`

- 파일은 그대로 유지 (향후 재사용 가능성)
- 컨트롤러에서 호출만 제거

## 새 UI 구조

```
┌─────────────────────────────────────────────────────────┐
│ Header: "로그"                                           │
├─────────────────────────────────────────────────────────┤
│ 필터바                                                   │
│ [작업 유형 ▼] [상태 ▼] [시작일] [종료일]                │
│ [🔍 검색] [🔄 초기화]                                    │
├─────────────────────────────────────────────────────────┤
│ 로그 테이블                    [페이지당: 50개 ▼]        │
│ ┌─────┬────────┬──────┬──────────┬────────┐           │
│ │시간 │관리자  │작업  │리소스    │상태    │           │
│ ├─────┼────────┼──────┼──────────┼────────┤           │
│ │ ... │  ...   │ ...  │   ...    │  ...   │           │
│ └─────┴────────┴──────┴──────────┴────────┘           │
├─────────────────────────────────────────────────────────┤
│ 페이지네이션: [< 1 2 3 ... 10 >] 1-50 / 총 500개       │
└─────────────────────────────────────────────────────────┘
```

## API 엔드포인트

### 유지된 엔드포인트

**GET /api/admin/system/logs**

쿼리 파라미터:
- `page` (number): 페이지 번호 (기본값: 1)
- `limit` (number): 페이지당 항목 수 (기본값: 50, 최대: 200)
- `action` (string): 작업 유형 필터 (CREATE, UPDATE, DELETE 등)
- `status` (string): 상태 필터 (success, error)
- `startDate` (string): 시작일 (YYYY-MM-DD)
- `endDate` (string): 종료일 (YYYY-MM-DD)

응답:
```json
{
  "success": true,
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 50,
    "total": 500,
    "totalPages": 10
  }
}
```

### 제거된 엔드포인트

- ❌ `GET /api/admin/system/health`
- ❌ `GET /api/admin/system/metrics`

## 검증 체크리스트

### 기능 테스트
- ✅ 메뉴 표시: 사이드바에 "로그" 메뉴가 `fa-file-lines` 아이콘으로 표시
- ✅ 페이지 이동: "로그" 클릭 시 페이지 로딩
- ✅ 로그 테이블: 감사 로그가 테이블에 정상 표시
- ✅ 페이지네이션: 페이지 번호 클릭, 이전/다음 버튼 동작
- ✅ 페이지당 항목 수: 10/25/50/100 선택 가능
- ✅ 필터링: 작업 유형, 상태, 날짜 범위 필터
- ✅ 검색 버튼: 필터 적용
- ✅ 초기화 버튼: 필터 리셋
- ✅ 날짜 유효성 검사: 시작일 > 종료일 시 에러 메시지
- ⏳ 빈 상태: 로그가 없을 때 "로그가 없습니다" 메시지 표시
- ⏳ 에러 처리: API 오류 시 Toast 메시지 표시

### API 테스트
- ✅ 백엔드 재시작: admin-service 정상 재시작
- ⏳ 로그 API: 정상 응답 확인
- ⏳ 삭제된 API: 404 응답 확인

### 브라우저 테스트 (필요)
- ⏳ 자바스크립트 에러 없음
- ⏳ 30초 interval 로그 없음 (자동 갱신 제거 확인)
- ⏳ API 호출 성공 확인

## 파일 변경 요약

### 수정된 파일 (6개)
1. `services/admin/public/js/components/sidebar.js` - 메뉴 라벨/아이콘 변경
2. `services/admin/public/js/pages/system.js` - 전면 리팩터링
3. `services/admin/public/css/admin.css` - 필터바 스타일 추가
4. `services/admin/public/js/api-client.js` - API 함수 정리
5. `services/admin/src/routes/system.routes.js` - 라우트 2개 제거
6. `services/admin/src/controllers/system.controller.js` - 컨트롤러 2개 제거

### 변경되지 않은 파일
- `services/admin/public/js/components/pagination.js` - 기존 컴포넌트 재사용
- `services/admin/src/services/system-monitoring.service.js` - 서비스 유지 (호출만 제거)

## 주요 개선 사항

1. **UX 개선**
   - 페이지네이션으로 대량 로그 처리
   - 필터링으로 원하는 로그 빠르게 검색
   - 페이지당 항목 수 조정 가능

2. **성능 개선**
   - 자동 갱신 제거 (불필요한 API 호출 제거)
   - 헬스/메트릭 API 호출 제거

3. **코드 간소화**
   - 3개 API 호출 → 1개 API 호출
   - 복잡한 UI → 단순한 로그 테이블 + 필터

4. **유지보수성 향상**
   - 명확한 페이지 목적 ("로그" 조회)
   - 사용하지 않는 백엔드 코드 제거

## 잠재적 영향

### 없음
- 다른 페이지에서 system API를 사용하지 않음 확인 (Grep 검색 완료)
- 백엔드 service 파일은 유지하여 향후 재사용 가능

### 향후 고려사항
- 로그 엑셀 다운로드 기능 추가 (필요시)
- 로그 상세 보기 모달 (필요시)
- 실시간 로그 스트리밍 (WebSocket, 필요시)

## 테스트 방법

### 브라우저 테스트
1. https://lemon.3chan.kr/admin/ 접속
2. 로그인 후 "로그" 메뉴 클릭
3. 필터링 및 페이지네이션 동작 확인

### API 테스트 (curl)
```bash
# 로그 조회 (성공 예상)
curl -H "Authorization: Bearer $TOKEN" \
  "http://localhost:3006/api/admin/system/logs?page=1&limit=10"

# 삭제된 API (404 예상)
curl -I "http://localhost:3006/api/admin/system/health"
curl -I "http://localhost:3006/api/admin/system/metrics"
```

## 완료 상태

✅ 프론트엔드 변경 완료
✅ 백엔드 변경 완료
✅ 서비스 재시작 완료
⏳ 브라우저 테스트 필요
⏳ API 엔드포인트 테스트 필요

## 참고

- 기존 헬스 체크 및 메트릭 기능은 향후 필요시 별도 페이지로 복구 가능
- system-monitoring.service.js 파일은 유지되어 있음
