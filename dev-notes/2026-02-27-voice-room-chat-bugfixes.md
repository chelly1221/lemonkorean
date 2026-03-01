---
date: 2026-02-27
category: Mobile|Backend
title: 음성 대화방 채팅 메시지 및 다수 버그 수정
author: Claude Opus 4.6
tags: [voice-room, chat, socket, bugfix, memory-leak]
priority: high
---

# 음성 대화방 채팅 메시지 및 다수 버그 수정

## 문제

사용자가 음성 대화방에서 보낸 메시지가 본인에게 보이지 않는 버그.
에이전트 팀(5명)을 투입하여 전체 음성 대화방 시스템을 병렬 분석.

## 근본 원인

### 핵심 버그: `sendMessage()`가 로컬에 메시지를 추가하지 않음

`VoiceRoomProvider.sendMessage()`가 REST API로 메시지를 보낸 후 응답값을 버리고 있었음. Socket.IO 브로드캐스트(`voice:new_message`)를 통해서만 메시지를 표시하는 구조였는데, Socket 재연결 시 방 멤버십이 소실되어 브로드캐스트를 받지 못함.

**DM 시스템과의 차이**: DM은 optimistic UI 패턴으로 즉시 로컬에 메시지를 추가하지만, 음성 대화방은 그렇지 않았음.

### 부차 원인: Socket 재연결 시 방 재가입 누락

Socket.IO가 재연결되면 새로운 `socket.id`가 할당되어 서버 측 `voice:<roomId>` 방 멤버십이 소실됨. 재연결 후 `voice:join_room`을 다시 emit하는 로직이 없었음.

## 수정 내역

### 1. `sendMessage()` REST 응답 활용 + 중복 방지 (핵심 수정)
- **파일**: `voice_room_provider.dart`
- REST 응답에서 반환된 메시지를 `_messages`에 즉시 추가
- Socket 리스너에 `id` 기반 중복 체크 추가 (REST 응답 + Socket 브로드캐스트 중복 방지)

### 2. Socket 재연결 시 음성 대화방 자동 재가입
- **파일**: `voice_room_provider.dart`
- `_socket.onConnectionChanged` 스트림을 구독하여 재연결 시 `joinVoiceRoom()` 자동 호출
- `_cleanupSocketListeners()`에서 구독 정리

### 3. `onNewMessageReceived` 콜백 dispose 시 해제
- **파일**: `voice_chat_widget.dart`
- `dispose()`에서 `provider.onNewMessageReceived = null` 추가
- 위젯 dispose 후 use-after-dispose 크래시 방지

### 4. `closeRoom()`에 `_isMuted = false` 추가
- **파일**: `voice_room_provider.dart`
- `leaveRoom()`과 달리 `closeRoom()`에서 `_isMuted` 초기화가 누락되어 있었음

### 5. `VoiceStageGame` 스트림 구독 메모리 누수 수정
- **파일**: `voice_stage_game.dart`
- `bridge.gameEvents.listen()`의 구독을 `_bridgeSub` 필드에 저장
- `onRemove()`에서 구독 취소

### 6. Backend `voice:send_message` 핸들러에 `avatar` 필드 추가
- **파일**: `voice-room-handler.js`
- `socket.userAvatar`가 이미 설정되어 있었지만 emit에 포함되지 않았음

### 7. Backend REST `sendMessage` 응답에 `name`/`avatar` 추가
- **파일**: `voice-rooms.controller.js`
- 응답에 `req.user.name`, `req.user.profileImageUrl` 추가
- 클라이언트가 REST 응답으로 메시지를 표시할 때 사용자 이름/아바타 필요

### 8. Stage granted 핸들러 `notifyListeners()` 이중 호출 제거
- **파일**: `voice_room_provider.dart`
- `userId == _myUserId`일 때 `notifyListeners()`가 2번 연속 호출되는 문제 수정

### 9. 채팅 rate-limit 에러를 별도 `_chatError` 필드로 분리
- **파일**: `voice_room_provider.dart`
- 기존에 `_error` 공유 필드를 사용하여 연결 에러를 덮어쓰는 문제 수정

## 변경 파일 목록

| 파일 | 변경 유형 |
|------|-----------|
| `lib/presentation/providers/voice_room_provider.dart` | 핵심 버그 수정 (메시지/소켓/상태) |
| `lib/presentation/screens/voice_rooms/widgets/voice_chat_widget.dart` | 콜백 메모리 누수 수정 |
| `lib/game/voice_stage/voice_stage_game.dart` | 스트림 구독 메모리 누수 수정 |
| `services/sns/src/socket/voice-room-handler.js` | avatar 필드 추가 |
| `services/sns/src/controllers/voice-rooms.controller.js` | REST 응답 name/avatar 추가 |
