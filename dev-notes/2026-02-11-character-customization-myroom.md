---
date: 2026-02-11
category: Mobile|Backend|Frontend|Database
title: 캐릭터 커스터마이제이션 & 마이룸 시스템 구현
author: Claude Opus 4.6
tags: [character, myroom, shop, gamification, customization]
priority: high
---

# 캐릭터 커스터마이제이션 & 마이룸 시스템

## 개요
기존 게임화 시스템(레몬 획득)에 소비처를 추가하여 학습 동기를 강화하는 시스템.
파츠 조합형 캐릭터 + 의상 + 마이룸(벽지/바닥/가구) + 펫 + 상점 구현.

## 변경 사항

### 1. Database (Migration 013)
- **`character_items`**: 아이템 카탈로그 (16개 카테고리, 희귀도, 가격, 번들/MinIO 구분)
- **`user_characters`**: 유저별 장착 아이템 (카테고리별 FK + 피부색)
- **`user_inventory`**: 유저 소유 아이템 (user_id, item_id UNIQUE)
- **`user_room_furniture`**: 가구 배치 (position_x/y 비율 좌표)
- **`lemon_transactions`**: type CHECK에 'purchase' 추가
- 기본 아이템 22개 시드 (body 1, hair 3, eyes 3, eyebrows 2, nose 2, mouth 2, top 2, bottom 2, wallpaper 2, floor 2)

### 2. Progress Service (Go)
- **`handlers/character_handler.go`**: 8개 엔드포인트
  - `GET /character/:userId` - 장착 정보 조회
  - `PUT /character/equip` - 아이템 장착 (소유 검증)
  - `PUT /character/skin-color` - 피부색 변경
  - `GET /inventory/:userId` - 인벤토리 조회
  - `POST /shop/purchase` - 구매 (트랜잭션: 레몬 차감 + 인벤토리 추가 + 기록)
  - `GET /shop/items` - 상점 목록 (카테고리 필터)
  - `GET /room/:userId` - 방 가구 조회
  - `PUT /room/furniture` - 가구 배치 업데이트

### 3. Admin Service (Node.js)
- **`character-items.controller.js`**: CRUD + 통계 + 에셋 업로드
- **`character-items.routes.js`**: `/api/admin/character-items` 하위 라우트
- **`character-items.js`**: Admin 대시보드 UI (카테고리/희귀도 필터, 아이템 카드 그리드, 생성/편집 모달)
- 사이드바에 "캐릭터 아이템" 메뉴 추가

### 4. Flutter App
- **모델**: `CharacterItemModel`, `UserCharacterModel`
- **Provider**: `CharacterProvider` (Hive 로컬 저장, sync queue 연동)
- **GamificationProvider 확장**: `spendLemons()` 메서드 추가
- **위젯**: `CharacterAvatarWidget` (SVG 레이어 스택 렌더링)
- **화면 4개**:
  - `MyRoomScreen` - 마이룸 메인 (벽지+바닥+캐릭터+가구)
  - `CharacterEditorScreen` - 캐릭터 편집 (실시간 프리뷰, 카테고리 탭, 피부색 선택)
  - `ShopScreen` - 상점 (카테고리 탭, 구매 확인, 레몬 잔액)
  - `RoomEditorScreen` - 룸 편집 (벽지/바닥/펫 선택)
- **네비게이션**: 4탭 → 5탭 (Home, Community, **MyRoom**, Review, Profile)
- **SyncManager**: `character_equip`, `character_purchase`, `room_update`, `lemon_spend` 타입 추가

### 5. 에셋
- `assets/character/` 디렉토리에 SVG 파일 22개 (300x400 캔버스)
- 카테고리별: body(1), hair(3), eyes(3), eyebrows(2), nose(2), mouth(2), top(2), bottom(2), wallpaper(2), floor(2)
- `pubspec.yaml`에 에셋 디렉토리 등록

## 아키텍처 결정

### SVG 레이어 렌더링
- 모든 캐릭터 파츠는 동일한 300x400 캔버스에 맞춰 제작
- `Stack` + `Positioned.fill`로 레이어 겹치기 (render_order 기준 정렬)
- 피부색은 body SVG에 `ColorFilter.mode(srcIn)` 적용

### 오프라인 우선
- 모든 변경 사항은 로컬 Hive 저장 후 sync queue에 추가
- 온라인 복귀 시 `_syncCharacter()` 메서드로 서버 동기화
- 구매는 로컬에서 즉시 반영, 서버 확인은 sync에서 처리

### 구매 트랜잭션
- Progress Service에서 DB 트랜잭션으로 원자적 처리
- 레몬 차감 → 인벤토리 추가 → lemon_transactions 기록
- 이미 소유 시 409 Conflict 반환 (중복 구매 방지)

## 배포 순서
1. DB 마이그레이션 적용: `psql < 013_add_character_system.sql`
2. Progress Service 재빌드: `docker compose restart progress`
3. Admin Service 재시작: `docker compose restart admin`
4. Flutter 웹 빌드: `cd mobile/lemon_korean && ./build_web.sh`
5. APK 빌드 (필요 시): Admin 대시보드에서 트리거

## 추후 확장 가능
- 가구 드래그&드롭 배치 (현재는 벽지/바닥/펫만)
- 기간 한정 아이템 (seasonal events)
- 아이템 세트 보너스
- 다른 유저 마이룸 방문
- MinIO 에셋 업로드 UI (현재는 키만 등록)
