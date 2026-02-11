---
date: 2026-02-11
category: Mobile
title: MyRoom 기본 캐릭터가 표시되지 않는 문제 수정
author: Claude Opus 4.6
tags: [character, myroom, offline-first, bugfix]
priority: high
---

## 문제

MyRoom 화면에서 기본 캐릭터가 표시되지 않음. 3가지 원인:

1. **DB 마이그레이션 미적용** - `013_add_character_system.sql`이 실행되지 않아 `character_items` 테이블 부재. 추가로 전제 조건인 `008_add_gamification_tables.sql`도 미적용 (`lemon_transactions` 테이블 부재로 013 롤백).
2. **인증 토큰 누락** - `CharacterProvider.fetchShopItems()`에서 `Dio()`를 직접 생성하여 인증 헤더 없이 요청. `/shop/items` 엔드포인트는 `authMiddleware.RequireAuth()` 필요.
3. **오프라인 폴백 없음** - 서버 접근 불가 시 캐릭터 초기화 불가. 오프라인 우선 앱에 맞지 않음.

추가로 `_fetchCharacterFromServer`와 `_fetchInventoryFromServer`가 빈 스텁이었음.

## 수정 내용

### 1. DB 마이그레이션 적용
```bash
# 전제 조건: 게이미피케이션 테이블
psql < migrations/008_add_gamification_tables.sql
# 캐릭터 시스템 (21개 아이템 시드)
psql < migrations/013_add_character_system.sql
```

### 2. CharacterProvider 수정 (`character_provider.dart`)
- `Dio()` → `ApiClient.instance.dio` (인증 인터셉터 포함)
- `_fetchCharacterFromServer()` 구현: `GET /api/progress/character/:userId`
- `_fetchInventoryFromServer()` 구현: `GET /api/progress/inventory/:userId`
- **번들 기본값 추가** (`bundledDefaults`): DB 시드 데이터와 동일한 21개 아이템 하드코딩
- `fetchShopItems()` 폴백 순서: 서버 → 로컬 캐시 → 번들 기본값

### 3. MyRoomScreen 수정 (`my_room_screen.dart`)
- `_loadData()`에서 `fetchShopItems`가 기본 아이템을 반환하지 못한 경우 `CharacterProvider.bundledDefaults`에서 직접 기본값 사용

## 변경 파일
- `mobile/lemon_korean/lib/presentation/providers/character_provider.dart`
- `mobile/lemon_korean/lib/presentation/screens/my_room/my_room_screen.dart`
