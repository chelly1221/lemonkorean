---
date: 2026-02-10
category: Backend|Frontend|Mobile|Database
title: 게임화 설정 Admin 페이지 및 서버 연동 구현
author: Claude Opus 4.6
tags: [gamification, admin, settings, ads, lemons]
priority: high
---

# 게임화 설정 Admin 페이지 및 서버 연동 구현

## 개요
하드코딩된 광고 ID와 레몬 보상 파라미터를 서버에서 관리할 수 있도록 Admin 대시보드에 설정 페이지를 추가하고, Flutter 앱이 시작 시 서버 설정을 로드하도록 변경.

## 변경 사항

### 1. DB 마이그레이션
- `database/postgres/migrations/009_add_gamification_settings.sql`
- 단일 행(id=1) 설계로 `gamification_settings` 테이블 생성
- 광고 설정: `admob_app_id`, `admob_rewarded_ad_id`, `adsense_*`, `ads_enabled`, `web_ads_enabled`
- 레몬 보상: `lemon_3_threshold`(95), `lemon_2_threshold`(80), `boss_quiz_bonus`(5), `boss_quiz_pass_percent`(70), `max_tree_lemons`(10)

### 2. Admin 백엔드
- `services/admin/src/controllers/gamification.controller.js` — CRUD 컨트롤러
- `services/admin/src/routes/gamification.routes.js` — 라우트 정의
- `services/admin/src/index.js` — 라우트 등록 추가
- 엔드포인트:
  - `GET /api/admin/gamification/settings` (public, 앱 사용)
  - `PUT /api/admin/gamification/ad-settings` (admin)
  - `PUT /api/admin/gamification/lemon-settings` (admin)
  - `POST /api/admin/gamification/reset` (admin)

### 3. Admin 프론트엔드
- `services/admin/public/js/pages/gamification-settings.js` — 2탭 UI (광고/레몬)
- `index.html` — 스크립트 태그 추가
- `router.js` — `/gamification` 라우트 등록
- `sidebar.js` — '게임화 설정' 메뉴 항목 추가 (fa-lemon 아이콘)

### 4. Flutter 앱
- `lemon_reward_model.dart` — `calculateLemons()` 임계값 파라미터화 (`t3`, `t2`)
- `admob_service.dart` — `setAdUnitId()` 메서드 추가, 외부 주입 지원
- `gamification_provider.dart` — 서버 설정 fetch (`_fetchServerSettings`), Dio 사용, 5초 타임아웃
- `boss_quiz_screen.dart` — 하드코딩 70%/+5 제거, provider에서 값 읽기
- `lemon_tree_widget.dart` — `maxTreeLemons` 적용, AdMob ID 서버 주입

## 설계 결정
- **오프라인 우선**: 서버 설정 fetch 실패 시 기본값 유지 (앱 정상 작동)
- **디버그 모드**: `kDebugMode`에서는 항상 테스트 광고 ID 사용
- **app-theme.controller.js 패턴**: 동일한 단일 행 CRUD, audit log 패턴 적용

## 검증
- DB: `SELECT * FROM gamification_settings` 확인 완료
- API: 컨테이너 내부에서 settings 엔드포인트 응답 확인 완료
- Flutter: `flutter analyze` 통과 (기존 info 1건만)
