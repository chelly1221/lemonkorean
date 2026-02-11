---
date: 2026-02-11
category: Backend|Mobile
title: 코드 리뷰 보안 수정 및 l10n 적용
author: Claude Opus 4.6
tags: [security, race-condition, l10n, authentication]
priority: high
---

# 코드 리뷰: 보안 취약점 수정 및 l10n 적용

## 변경 요약

커밋되지 않은 변경사항에서 발견된 보안 취약점과 버그를 수정하고, My Room 화면의 하드코딩 문자열을 다국어 지원으로 전환.

---

## 1. [CRITICAL] SNS 모더레이션 인증 누락 수정

**파일**: `services/admin/src/routes/sns-moderation.routes.js`

**문제**: 게시물 삭제, 유저 밴/언밴, 신고 조회 등 관리자 전용 엔드포인트에 인증 미들웨어가 적용되지 않아 누구나 접근 가능했음.

**수정**: `requireAuth, requireAdmin` 미들웨어를 라우터 레벨에서 적용.

---

## 2. [HIGH] Go 핸들러 안전성 수정

**파일**: `services/progress/handlers/character_handler.go`

### 2a. Type Assertion 패닉 방지

4곳의 `uid := int64(userID.(float64))` 안전하지 않은 type assertion을 `getUserID()` 헬퍼 함수로 교체. 실패 시 서버 패닉 대신 401 응답 반환.

**영향 위치**: `EquipItem`, `UpdateSkinColor`, `PurchaseItem`, `UpdateRoomFurniture`

### 2b. 캐릭터 구매 레이스 컨디션 수정

**문제**: 레몬 잔액 확인이 트랜잭션 외부에서 수행되어, 동시 요청 시 음수 잔액 발생 가능했음.

**수정**:
- 소유 확인, 가격 조회, 잔액 확인을 모두 트랜잭션 내부로 이동
- `SELECT ... FOR UPDATE`로 row lock 적용하여 동시 접근 방지

---

## 3. [MEDIUM] My Room 화면 l10n 적용

**파일 10개** (ARB 6개 + 화면 4개)

### 추가된 l10n 키 (~31개)

`myRoom`, `characterEditor`, `roomEditor`, `shop`, `character`, `room`, `hair`, `eyes`, `brows`, `nose`, `mouth`, `top`, `bottom`, `hatItem`, `accessory`, `wallpaper`, `floorItem`, `petItem`, `furnitureItem`, `none`, `noItemsYet`, `visitShopToGetItems`, `alreadyOwned`, `buy`, `purchasedItem`, `notEnoughLemons`, `owned`, `free`, `comingSoon`, `balanceLemons`

### 수정된 화면 파일

- `my_room_screen.dart`: 제목 및 버튼 라벨 l10n 적용
- `character_editor_screen.dart`: 카테고리 탭 및 빈 상태 메시지 l10n 적용
- `shop_screen.dart`: 탭, 구매 다이얼로그, 상태 메시지 l10n 적용
- `room_editor_screen.dart`: 탭 및 빈 상태 메시지 l10n 적용

---

## 검증

- `flutter analyze`: 에러 0건 확인
- 6개 언어 ARB 파일 모두 동일 키 세트 포함 확인
