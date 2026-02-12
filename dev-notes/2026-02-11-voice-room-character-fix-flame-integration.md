---
date: 2026-02-11
category: Mobile|Backend
title: 음성대화방 캐릭터 표시 버그 수정 + Flame 게임 엔진 통합
author: Claude Opus 4.6
tags: [voice-room, character, flame, spritesheet, bug-fix]
priority: high
---

# 음성대화방 캐릭터 표시 버그 수정 + Flame 통합

## 문제

음성대화방 진입 시 모든 캐릭터(내 캐릭터 + 상대 캐릭터)가 표시되지 않는 버그.

**근본 원인 (다수):**
1. 백엔드 `voice-room.model.js`의 `getSpeakers()`/`promoteToSpeaker()`가 존재하지 않는 `uc.equipped_items` 컬럼을 쿼리 → 항상 NULL
2. `voice_room_participants` 테이블에 `role` 컬럼 누락 (코드에서 참조하지만 미생성)
3. `voice_room_stage_requests`, `voice_room_messages` 테이블 미생성

`user_characters` 테이블에는 `equipped_items` 컬럼이 없고, 대신 개별 `*_item_id` 컬럼(`body_item_id`, `hair_item_id` 등)이 존재.

## 변경 사항

### Part 1: 백엔드 수정 (Critical Bug)
**파일**: `services/sns/src/models/voice-room.model.js`
- 헬퍼 함수 추가: `_collectItemIds()`, `_fetchItemDetails()`, `_buildEquippedItemsMap()`
- `getSpeakers()`: 개별 `*_item_id` 컬럼 쿼리 → `character_items` 배치 조회 → 카테고리별 맵 구성
- `promoteToSpeaker()`: 동일한 방식으로 수정

### Part 2: Placeholder 스프라이트시트 생성
**파일**: `scripts/generate-sprites/generate_placeholders.py`
- Pillow로 7개 placeholder 스프라이트시트 생성 (body, hair, eyes, eyebrows, nose, mouth, top)
- 레이아웃: 32x48 프레임, 4행 (front/back/right/gestures)
- 출력: `mobile/lemon_korean/assets/sprites/character/*/`

### Part 3: DB 마이그레이션 + 모델 수정
- `016_add_spritesheet_support.sql`:
  - `voice_room_participants`에 `role` 컬럼 추가 (default: 'listener')
  - `voice_room_stage_requests`, `voice_room_messages` 테이블 생성
  - `character_items` asset_type에 'spritesheet' 추가
  - default 아이템에 spritesheet 메타데이터 추가
- `CharacterItemModel`: `hasSpritesheet` getter가 `metadata['spritesheet_key']`도 체크하도록 수정, `spritesheetKey` getter 추가

### Part 4: Flame 코드 수정
- `SpriteLoader.loadSpritesheetImage()`: `spritesheetKey` 우선 사용
- `SpriteLoader.preloadItems()`: `hasSpritesheet` 사용 (기존 `assetType == 'spritesheet'`)
- `PixelCharacter._buildLayers()`: `hasSpritesheet` 필터 사용

### Part 5: VoiceRoomScreen Flame 통합
- `VoiceRoomProvider`: `GameBridge` 필드 추가, `attachGameBridge()`/`detachGameBridge()` 메서드
  - 소켓 리스너에서 Flame 이벤트 발송 (position, gesture, reaction, mute, add/remove character)
  - Flame → Flutter 이벤트 수신 (`LocalCharacterMoved` → `updateMyStagePosition()`)
- `VoiceRoomScreen`: `StageAreaWidget` → `GameWidget` 교체
  - `VoiceStageGame` 인스턴스 생성 및 관리
  - 기존 speakers를 `RemoteCharacterAdded` 이벤트로 초기 전달

## 적용 방법

모든 DB 변경 및 서비스 재시작은 이미 적용 완료.

```bash
# 이미 적용된 항목:
# - 스프라이트 7개 생성됨 (assets/sprites/character/*/*)
# - DB: role 컬럼, stage_requests/messages 테이블, spritesheet metadata 추가
# - SNS 서비스 재시작 완료

# Flutter 앱 빌드 시:
cd mobile/lemon_korean && flutter pub get
```

## 테스트 항목
- [ ] 음성대화방 생성 → 내 캐릭터가 Flame 스테이지에 표시
- [ ] 탭 → 캐릭터 이동 애니메이션
- [ ] 다른 사용자 참여 → 상대 캐릭터 표시
- [ ] 제스처/리액션 동작
- [ ] 리스너→스피커 승격 시 캐릭터 나타남
