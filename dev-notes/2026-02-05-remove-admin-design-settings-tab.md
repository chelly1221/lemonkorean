---
date: 2026-02-05
category: Backend
title: Admin 디자인 설정 탭 제거
author: Claude Sonnet 4.5
tags: [admin, cleanup, database, removal]
priority: medium
---

# Admin 디자인 설정 탭 완전 제거

## 개요
Admin 대시보드의 디자인 커스터마이징 기능(색상, 로고, 파비콘)을 완전히 제거했습니다. Flutter 앱 테마 설정 기능(`App Theme`)은 그대로 유지됩니다.

## 제거 이유
- Admin 대시보드는 내부 관리 도구로 디자인 커스터마이징 필요성이 낮음
- Flutter 앱 테마 설정과 혼동 가능성
- 코드 단순화 및 유지보수 부담 감소

## 변경 사항

### 1. Frontend 제거
**삭제된 파일:**
- `services/admin/public/js/pages/design.js` (17KB, 440줄)
  - 색상 피커, 로고/파비콘 업로드, 미리보기 기능

**수정된 파일:**
- `services/admin/public/js/router.js`
  - `/design` 라우트 제거 (line 243)

- `services/admin/public/js/components/sidebar.js`
  - "디자인 설정" 메뉴 항목 제거 (line 42)
  - 커스텀 로고 표시 로직 제거 (lines 108-112)
  - 정적 텍스트 "Lemon Korean Admin"으로 대체

- `services/admin/public/js/app.js`
  - `loadDesignSettings()` 함수 제거 (lines 13-44)
  - 초기화 시 디자인 설정 로드 제거
  - 기본 CSS 변수 사용 (`admin.css`의 `:root` 값)

### 2. Backend 제거
**삭제된 파일:**
- `services/admin/src/controllers/design.controller.js` (9KB, 356줄)
  - 엔드포인트: GET/PUT `/settings`, POST `/upload-logo`, POST `/upload-favicon`, POST `/reset`

- `services/admin/src/routes/design.routes.js` (1KB, 36줄)
  - 모든 `/api/admin/design/*` 라우트

**수정된 파일:**
- `services/admin/src/index.js`
  - `designRoutes` import 제거 (line 23)
  - `/api/admin/design` 라우트 등록 제거 (line 68)

### 3. Database 제거
**새 마이그레이션:**
- `database/postgres/migrations/006_remove_design_settings.sql`
  - `design_settings` 테이블 DROP
  - 옵션: `audit_logs`에서 디자인 설정 관련 로그 삭제 (주석 처리)

**수정된 파일:**
- `database/postgres/init/03_admin_schema.sql`
  - `design_settings` 테이블 정의 제거 (lines 78-109)
  - 기본 데이터 INSERT 제거
  - 트리거 생성 제거

### 4. Documentation 정리
**삭제:**
- `dev-notes/2026-02-04-admin-design-settings-feature.md`

**유지:**
- `dev-notes/2026-02-04-app-theme-configuration-system.md` (Flutter 앱 테마 기능)

## 유지된 기능
- **App Theme 탭** (`/app-theme`): Flutter 앱의 색상 커스터마이징 기능은 그대로 작동
- **Admin 대시보드 기본 테마**: `admin.css`의 정적 CSS 변수 사용
  ```css
  :root {
    --primary-color: #FFD93D;
    --primary-dark: #F4C430;
    --sidebar-bg: #2c3e50;
    --sidebar-text: #ecf0f1;
    --sidebar-hover: #34495e;
    --sidebar-active: #FFE66D;
  }
  ```

## MinIO Storage (옵션)
- `design/` 폴더의 로고/파비콘 파일은 수동 삭제 가능
- 용량이 작아 삭제하지 않아도 무방

## 테스트 체크리스트
- [ ] 사이드바에 "디자인 설정" 메뉴 없음
- [ ] `#/design` 접근 시 404 페이지 표시
- [ ] `#/app-theme` 정상 작동
- [ ] 사이드바에 "Lemon Korean Admin" 텍스트 표시
- [ ] 브라우저 콘솔 에러 없음
- [ ] API `/api/admin/design/*` 404 반환
- [ ] API `/api/admin/app-theme/*` 정상 작동
- [ ] DB에서 `design_settings` 테이블 삭제 확인
- [ ] `app_theme_settings` 테이블은 정상 존재

## 배포 순서
```bash
# 1. Admin 서비스 재시작
docker-compose restart admin

# 2. 마이그레이션 실행
docker-compose exec postgres psql -U lemon_admin -d lemon_korean \
  -f /docker-entrypoint-initdb.d/migrations/006_remove_design_settings.sql

# 3. 브라우저 캐시 클리어 및 테스트
```

## 롤백 방법
1. Git에서 삭제된 파일 복원
2. `index.js`, `router.js`, `sidebar.js`의 변경사항 되돌리기
3. 백업에서 `design_settings` 테이블 복원 또는 초기화 스크립트 재실행
4. Admin 서비스 재시작

## 영향 분석
- **제거된 코드**: ~800줄 (프론트엔드 + 백엔드)
- **삭제 파일**: 4개
- **수정 파일**: 5개
- **DB 테이블**: 1개 삭제
- **Breaking Changes**: 없음 (격리된 기능)
- **사용자 영향**: Admin 대시보드 디자인 커스터마이징 불가 (Flutter 앱 테마는 정상)

## 참고
- App Theme 기능은 완전히 별개의 시스템으로 영향 없음
- Admin 대시보드는 이제 정적 기본 테마 사용
- 기존 audit logs는 히스토리 보존을 위해 유지 가능
