---
date: 2026-02-07
category: Mobile|Frontend
title: 캐시 및 스토리지 관리 기능 종합 구현
author: Claude Sonnet 4.5
tags: [web, admin, cache, storage, indexeddb, service-worker]
priority: high
---

# 캐시 및 스토리지 관리 기능 종합 구현

## 개요

웹 앱과 Admin 대시보드에 걸쳐 캐시/스토리지 관리 기능을 종합적으로 구현. 세 가지 영역:

1. **웹 앱 스토리지 리셋 강화** - IndexedDB, Service Worker 캐시 삭제 추가
2. **Admin 브라우저 캐시 삭제 버튼** - 관리자 원클릭 캐시 클리어
3. **Admin 캐시 관리 전용 페이지** - 캐시 비활성화 모드, 상태 확인

---

## 1. 웹 앱 스토리지 리셋 강화

### 문제
스토리지 리셋이 `localStorage`만 지우고 IndexedDB/Service Worker 캐시는 남아서, 리셋 후에도 이전 테마/설정이 유지됨 (시크릿 모드에서만 정상 동작).

### 해결
`main.dart`의 `_clearAppStorage()` 함수를 개선하여 세 가지 스토리지 타입 모두 삭제:

```dart
// 1. localStorage - lk_* 접두사 키들
// 2. IndexedDB - lemon_korean 데이터베이스 전체
idbFactory.deleteDatabase('lemon_korean');
// 3. Service Worker Caches - 모든 캐시 삭제 + 등록 해제
await cacheStorage.delete(cacheName);
await registration.unregister();
```

각 삭제 작업을 독립적 try-catch로 감싸서 하나 실패해도 계속 진행.

### 변경 파일
- `mobile/lemon_korean/lib/main.dart` (1개 함수 수정)

---

## 2. Admin 브라우저 캐시 삭제 버튼

### 문제
웹 앱 배포 후 관리자가 변경 확인하려면 수동으로 Ctrl+Shift+R, DevTools에서 Service Worker/IndexedDB 삭제 등 번거로운 과정 필요.

### 해결
Admin 대시보드 스토리지 리셋 페이지에 **"내 브라우저 캐시 완전 삭제"** 버튼 추가.

버튼 클릭 시 자동 수행:
1. localStorage `lk_*` 키 삭제
2. IndexedDB `lemon_korean` 삭제
3. Service Worker 캐시 모두 삭제
4. Service Worker 등록 해제
5. 3초 후 페이지 자동 새로고침

### 변경 파일
- `services/admin/public/js/pages/storage-reset.js`

---

## 3. Admin 캐시 관리 전용 페이지

### 기능

#### 3-1. 캐시 비활성화 모드 토글
- 원클릭으로 브라우저 캐싱 활성화/비활성화
- fetch() 및 XMLHttpRequest 오버라이드로 모든 요청에 `_nocache` 타임스탬프 + no-cache 헤더 추가
- localStorage에 상태 저장 (세션 간 유지)

```javascript
// 활성화 시 fetch() 오버라이드
url = `${url}?_nocache=${Date.now()}`;
headers['Cache-Control'] = 'no-cache, no-store, must-revalidate';
```

#### 3-2. 캐시 완전 삭제
스토리지 리셋 페이지의 캐시 삭제 기능을 이 페이지로 통합.

#### 3-3. 캐시 상태 확인
현재 브라우저의 localStorage 키 수, Service Worker 캐시 수, 등록 수 표시.

### 변경 파일
- `services/admin/public/js/pages/cache-management.js` (신규)
- `services/admin/public/js/components/sidebar.js` (메뉴 추가)
- `services/admin/public/js/router.js` (라우트 추가)
- `services/admin/public/index.html` (스크립트 태그 추가)
- `services/admin/public/js/pages/storage-reset.js` (캐시 섹션 제거, 안내 추가)

---

## 사용 시나리오

### 웹 앱 배포 후 테스트
```
1. ./build_web.sh 실행
2. Admin → 캐시 관리 → "캐시 비활성화" 또는 "모든 캐시 삭제"
3. 웹 앱 접속하여 최신 버전 확인
```

### 사용자 캐시 문제 디버깅
```
1. Admin → 스토리지 리셋 → 해당 사용자 리셋 플래그 생성
2. 사용자가 웹 앱 새로고침 → localStorage + IndexedDB + SW 캐시 모두 삭제됨
3. 깨끗한 상태로 재초기화
```

---

## 삭제 대상 정리

| 스토리지 타입 | 삭제 내용 | API |
|-------------|----------|-----|
| localStorage | `lk_*` 접두사 키 | `removeItem()` |
| IndexedDB | `lemon_korean` DB 전체 | `deleteDatabase()` |
| SW Cache | 모든 캐시 스토리지 | `caches.delete()` |
| SW Registration | 모든 활성 등록 | `registration.unregister()` |

---

## 주의사항

- 캐시 비활성화 모드는 성능이 저하되므로 테스트/개발 목적으로만 사용
- 브라우저 캐시 삭제는 현재 브라우저에만 적용 (다른 사용자 영향 없음)
- Admin 세션이 localStorage에 저장되어 있으면 삭제 시 로그아웃될 수 있음

---

## 검증

- ✅ localStorage `lk_*` 키 삭제 확인
- ✅ IndexedDB `lemon_korean` 삭제 확인
- ✅ Service Worker 캐시/등록 삭제 확인
- ✅ 일반 브라우저와 시크릿 모드 동작 일치
- ✅ 테마/설정이 리셋 후 유지되지 않음
- ✅ Admin 대시보드 캐시 관리 페이지 정상 동작

**배포**: `docker compose restart admin-service` + `./build_web.sh`
