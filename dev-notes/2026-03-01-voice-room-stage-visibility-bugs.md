---
date: 2026-03-01
category: Mobile
title: 보이스룸 버그 종합 수정 (8건)
author: Claude Opus 4.6
tags: [voice-room, flame, stage, bugfix, socket, livekit]
priority: high
---

## 문제

방장(방 생성자)은 스테이지 위의 스피커들을 정상적으로 볼 수 있지만, 다른 참가자들은 스테이지가 비어 보이는 버그가 있었음. 전체 보이스룸 코드를 에이전트 팀으로 조사하여 총 8건의 버그를 발견·수정함.

## 1차 수정 (핵심 스테이지 가시성)

### 1. [CRITICAL] 초기 스피커가 Flame 게임에 표시되지 않음

**원인**: `voice_room_screen.dart`의 `_initializeGame()`에서 기존 스피커들을 `RemoteCharacterAdded` 이벤트로 GameBridge에 전송하지만, GameBridge의 StreamController가 **broadcast** 타입이라 `VoiceStageGame.onLoad()`가 아직 실행되지 않은 시점에서 전송된 이벤트가 모두 유실됨.

**수정**:
- `VoiceStageGame`에 `initialRemoteSpeakers` 매개변수 추가
- `onLoad()` 내에서 bridge 구독 설정 후 초기 스피커를 직접 추가
- `_initializeGame()`에서 bridge 전송 대신 생성자로 데이터 전달

### 2. [HIGH] `refreshParticipants()`가 Flame에 동기화하지 않음

**원인**: `refreshParticipants()`에서 `_stageCharacters` 맵에 새 캐릭터를 추가/제거할 때 Flame GameBridge에 알리지 않음.

**수정**: 캐릭터 추가 시 `RemoteCharacterAdded`, 제거 시 `RemoteCharacterRemoved` 이벤트를 GameBridge에 전송.

### 3. [MEDIUM] `onVoiceStageRemoved`에서 캐릭터 정리 누락

**원인**: 스피커가 강등될 때 `voice:stage_removed` 핸들러에서 `_stageCharacters`에서 제거하지 않음.

**수정**: `_stageCharacters.remove()` + `RemoteCharacterRemoved` + speakers→listeners 이동 처리 추가.

### 4. [LOW] 리액션 정리 타이밍 불일치

**수정**: 제거 임계값 1800ms → 2000ms 통일, `VoiceRoomScreen`에 5초 주기 정리 타이머 추가.

## 2차 수정 (심층 조사)

### 5. [HIGH] 6개 소켓 이벤트 핸들러에 room_id 검증 누락

**원인**: `onVoiceRoleChanged`, `onVoiceStageGranted`, `onVoiceStageRemoved`, `onVoiceCharacterPosition`, `onVoiceReaction`, `onVoiceGesture` 핸들러가 room_id를 검증하지 않아, 이전 방의 이벤트가 현재 방 상태를 오염시킬 수 있음.

**수정**: 모든 핸들러에 `if (data['room_id'] != null && data['room_id'] != _activeRoom!.id) return;` 추가.

### 6. [HIGH] 화면 리사이즈 시 리모트 캐릭터 스케일 미반영

**원인**: `onGameResize()`에서 로컬 캐릭터만 스케일 업데이트, 리모트 캐릭터와 UI 배지(이름, 뮤트, 연결 품질)는 기존 크기 유지.

**수정**:
- `RemoteCharacter`에 `updateDisplayScale()` 메서드 추가
- `onGameResize()`에서 모든 리모트 캐릭터 + 로컬 UI 배지 위치 재계산

### 7. [MEDIUM] 강등 시 _micError 미정리 + speakingStates 미정리

**원인**:
- 스피커→리스너 전환 시 `_micError`가 남아서 이전 마이크 에러 UI가 표시됨
- `_speakingStates`에서 퇴장한 참가자 데이터가 제거되지 않음

**수정**:
- `onVoiceStageRemoved`, `onVoiceRoleChanged`에서 `_micError = null` 추가
- `onVoiceParticipantLeft`, `onVoiceStageRemoved`에서 `_speakingStates.remove(userId)` 추가

### 8. [N/A] _handleClose의 mounted 체크 - 이미 처리됨

조사 결과 line 1132에서 이미 `if (mounted)` 체크가 `Navigator.pop(context)`를 감싸고 있어 수정 불필요.

## 3차 수정 (향후 고려사항 해결)

### 9. [VERIFIED] promoteToSpeaker 동시 승격 경합 조건

**조사 결과**: `promoteToSpeaker`와 `joinAsSpeaker` 모두 `SELECT ... FOR UPDATE`를 트랜잭션 내에서 사용하고 있어 PostgreSQL 행 수준 잠금이 동시 요청을 올바르게 직렬화함. 실제 버그가 아님.

### 10. [HIGH] 킥된 사용자 즉시 재입장 방지

**원인**: `kickParticipant`에서 `leave()`만 호출하므로 킥된 사용자가 바로 `joinRoom`으로 재입장 가능.

**수정**:
- `VoiceRoom` 모델에 인메모리 `_kickedUsers` Map (roomId → Set<userId>) 추가
- `kickUser()`, `isKicked()`, `clearKicked()` 정적 메서드 추가
- 컨트롤러 `kickParticipant`에서 `kickUser()` 호출
- 컨트롤러 `joinRoom`에서 `isKicked()` 체크 추가 (403 반환)
- `close()` 메서드에서 `clearKicked()` 호출 (방 종료 시 정리)

### 11. [HIGH] LiveKit 토큰 1시간 TTL 갱신

**원인**: 토큰 TTL이 1시간이지만 갱신 메커니즘이 없어, 1시간 이상 방에 있으면 연결 끊김.

**수정**:
- 백엔드: `POST /:id/refresh-token` 엔드포인트 추가 (참가자 역할 확인 후 새 토큰 발급)
- Flutter: `VoiceRoomRepository.refreshToken()` 메서드 추가
- Flutter: `VoiceRoomProvider`에 50분 주기 `_tokenRefreshTimer` 추가 (연결 성공 시 시작, 정리 시 취소)

### 12. [MEDIUM] getRooms 응답에 equipped_items/skin_color 누락

**원인**: `getActiveRooms()` SQL에 `user_characters` 조인 없음.

**수정**:
- SQL에 `LEFT JOIN user_characters uc` 추가
- 참가자 JSON에 `skin_color`와 아이템 ID 컬럼 포함
- 후처리로 `_fetchItemDetails()` + `_buildEquippedItemsMap()`으로 전체 아이템 정보 해석

### 13. [LOW] GestureTrayWidget build 중 setState 마이크로 루프

**원인**: `build()` 내에서 `addPostFrameCallback` + `setState()` 사용하여 불필요한 추가 프레임 발생.

**수정**: `addPostFrameCallback`/`setState` 제거, 맵 값을 `build()` 내에서 직접 업데이트 (Consumer가 이미 리빌드 중이므로 현재 프레임에서 반영됨).

### 14. [LOW] EquipmentLayer update()의 불필요한 조기 반환

**원인**: `update()`에서 뒷면 얼굴 카테고리에 대한 조기 반환이 애니메이션 진행 코드(line 74-87) 이후에 위치하여 실질적 영향 없음. `render()`에서 이미 별도로 처리.

**수정**: `update()` 내의 중복 얼굴 숨김 체크 제거 (`render()`의 체크만 유지).

## 수정 파일

- `mobile/lemon_korean/lib/game/voice_stage/voice_stage_game.dart` - initialRemoteSpeakers, onGameResize 개선
- `mobile/lemon_korean/lib/game/voice_stage/remote_character.dart` - updateDisplayScale 메서드 추가
- `mobile/lemon_korean/lib/game/components/character/equipment_layer.dart` - 중복 얼굴 숨김 체크 제거
- `mobile/lemon_korean/lib/presentation/providers/voice_room_provider.dart` - room_id 검증, 상태 정리, Flame 동기화, 토큰 갱신 타이머
- `mobile/lemon_korean/lib/presentation/screens/voice_rooms/voice_room_screen.dart` - 초기 스피커 전달 방식, 리액션 타이머
- `mobile/lemon_korean/lib/presentation/screens/voice_rooms/widgets/gesture_tray_widget.dart` - build 중 setState 제거
- `mobile/lemon_korean/lib/data/repositories/voice_room_repository.dart` - refreshToken 메서드 추가
- `services/sns/src/models/voice-room.model.js` - 킥 추적, getActiveRooms 캐릭터 데이터 추가
- `services/sns/src/controllers/voice-rooms.controller.js` - 킥 체크, 토큰 갱신 엔드포인트
- `services/sns/src/routes/voice-rooms.routes.js` - refresh-token 라우트 추가

## 근본 원인

Dart의 `StreamController<T>.broadcast()`는 이벤트 발행 시점에 리스너가 없으면 이벤트가 유실됨. Flame의 `FlameGame.onLoad()`는 `GameWidget`이 위젯 트리에 마운트된 후 비동기로 실행되므로, 같은 프레임에서 이벤트를 보내면 수신 불가.
