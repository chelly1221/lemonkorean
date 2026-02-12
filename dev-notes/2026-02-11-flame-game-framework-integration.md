---
date: 2026-02-11
category: Mobile
title: FLAME 게임 엔진 통합 - Phase 1 기반 구축
author: Claude Opus 4.6
tags: [flame, game-engine, pixel-art, spritesheet, myroom, voice-room]
priority: high
---

## 개요

FLAME 게임 엔진을 프로젝트에 통합하여 MyRoom과 Voice Room Stage를 게임 기반 렌더링으로 전환하기 위한 기반 코드를 구축했습니다.

## 변경사항

### 1. 의존성 추가
- `pubspec.yaml`에 `flame: ^1.22.0`, `flame_audio: ^2.10.0` 추가
- `assets/sprites/` 디렉토리 트리 생성 및 flutter assets 섹션에 등록

### 2. 새로 생성된 파일 구조 (`lib/game/`)

```
lib/game/
  core/
    game_bridge.dart            # Provider ↔ FLAME 양방향 이벤트 스트림
    sprite_loader.dart          # 스프라이트시트 로딩, 캐싱, 합성
    palette_swap.dart           # 피부색 팔레트 스왑 (6종 스킨톤)
    game_constants.dart         # 프레임 크기, 속도, 렌더 순서 상수
  components/
    character/
      pixel_character.dart      # 합성 캐릭터 (레이어 정렬)
      character_animation.dart  # 상태 머신: idle/walk/gesture
      equipment_layer.dart      # 개별 스프라이트시트 레이어
      character_shadow.dart     # 캐릭터 그림자
    room/
      room_background.dart      # 배경 스프라이트
      floor_component.dart      # 이동 가능 바닥 영역
      furniture_component.dart  # 탭 가능 가구
      day_night_overlay.dart    # 시간 기반 색상 오버레이
    effects/
      particle_manager.dart     # 파티클 이펙트 팩토리
      speaking_aura.dart        # 음소거 해제 시 녹색 아우라
      floating_emoji.dart       # 떠오르는 이모지 리액션
      gesture_effects.dart      # 제스처별 파티클 효과
    pet/
      pixel_pet.dart            # 펫 스프라이트 + 배회/추적 AI
    ui/
      name_label.dart           # 캐릭터 이름 라벨
      mute_badge.dart           # 음소거 표시 배지
  my_room/
    my_room_game.dart           # MyRoom FlameGame
  voice_stage/
    voice_stage_game.dart       # Voice Stage FlameGame
    remote_character.dart       # 원격 플레이어 보간
  mini_games/
    mini_game_base.dart         # 미니게임 기본 클래스
    korean_quiz/korean_quiz_game.dart   # 한국어 퀴즈
    word_puzzle/word_puzzle_game.dart   # 한글 조합 퍼즐
```

### 3. 기존 파일 수정

- **`character_item_model.dart`**: `'spritesheet'` assetType 추가, 스프라이트시트 메타데이터 접근자 추가
  - `hasSpritesheet`, `spritesheetFrameWidth`, `spritesheetFrameHeight`, `spritesheetColumns`, `spritesheetRows`

### 4. 에셋 디렉토리

```
assets/sprites/character/{body,hair,eyes,eyebrows,nose,mouth,top,bottom,shoes,accessory}/
assets/sprites/room/{backgrounds,furniture}/
assets/sprites/pets/
assets/sprites/effects/
assets/audio/sfx/
```

## 핵심 설계 결정

### 스프라이트시트 포맷
- 프레임 크기: 32x48px (3x 스케일로 96x144px 표시)
- 행 구조: Front(0), Back(1), Right(2), Gestures(3)
- 왼쪽 방향: 오른쪽 스프라이트를 수평 반전 (기존 SVG Mirror 방식 유지)
- 보행 애니메이션: 4프레임 @ 8FPS

### 팔레트 스왑
- 바디 스프라이트시트에 4색 참조 팔레트 사용
- 런타임에 사용자 스킨 컬러에 맞게 픽셀 단위 리맵핑
- 결과 이미지 캐싱으로 성능 보장

### 이벤트 브릿지
- `GameBridge`: Provider ↔ FLAME 간 양방향 스트림 통신
- Flutter → FLAME: 장비 변경, 원격 캐릭터 이동, 리액션 등
- FLAME → Flutter: 로컬 이동 (Socket.IO 전송용), 가구 탭, 미니게임 요청

### 하위 호환성
- SVG 시스템 (`CharacterAvatarWidget`) 유지 - 에디터, 상점 등에서 계속 사용
- `assetType` 필드로 렌더러 라우팅 (`svg`/`png` → SVG, `spritesheet` → FLAME)
- 기존 아이템은 SVG로 유지, 새 아이템부터 스프라이트시트 적용

## 다음 단계 (Phase 2)

1. 플레이스홀더 스프라이트시트 에셋 제작 (body + hair + top)
2. `MyRoomScreen`에 `GameWidget` 통합
3. 탭-투-워크 및 스프라이트 애니메이션 테스트
4. `VoiceRoomScreen` 스테이지 영역 FLAME 전환

## 주의사항

- FLAME `HasGameRef`는 deprecated → `HasGameReference` 사용
- `backgroundColor()` 오버라이드 시 `dart:ui show Color` import 필요
- 미니게임의 `DragCallbacks` 메서드는 `super` 호출 필수
