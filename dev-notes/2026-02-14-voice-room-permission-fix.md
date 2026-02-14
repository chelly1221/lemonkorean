---
date: 2026-02-14
category: Backend|Mobile
title: 음성대화방 권한 업데이트 인플레이스 전환 및 핸드레이즈 최적화
author: Claude Opus 4.6
tags: [voice-room, livekit, permissions, optimistic-ui]
priority: high
---

## 변경 요약

음성대화방에서 발생하던 3가지 문제를 수정:

1. **핸드레이즈 지연** → 옵티미스틱 UI로 즉시 반영
2. **승격/강등 시 끊김** → LiveKit Server API로 인플레이스 권한 업데이트 (disconnect/reconnect 제거)
3. **단방향 오디오** → 동일 identity 재접속으로 인한 충돌 제거

## 근본 원인

기존 플로우: 리스너 → 스피커 승격 시 클라이언트가 LiveKit 연결을 완전히 끊고(`_cleanupLiveKit()`) 새 토큰으로 재접속(`_connectToLiveKit()`). 이 과정에서:
- 다른 참가자들이 이전 트랙 구독을 잃음
- 같은 identity로 재접속 시 LiveKit 내부 충돌 가능
- 재접속 동안 오디오 갭 발생

## 해결 방법

`livekit-server-sdk`의 `RoomServiceClient.updateParticipant()`를 사용하여 서버 측에서 참가자 권한을 직접 변경. 클라이언트는 `ParticipantPermissionsUpdatedEvent`를 수신하여 마이크 활성화/비활성화만 처리.

## 변경 파일

### `services/sns/src/config/livekit.js`
- `RoomServiceClient` 인스턴스 생성
- `updateParticipantPermissions(roomName, userId, canPublish)` 함수 추가

### `services/sns/src/controllers/voice-rooms.controller.js`
- `grantStage()`: DB 승격 후 `updateParticipantPermissions(room, user, true)` 호출
- `removeFromStage()`: DB 강등 후 `updateParticipantPermissions(room, user, false)` 호출
- `leaveStage()`: 동일 패턴
- 기존 토큰 생성은 폴백으로 유지

### `mobile/lemon_korean/lib/presentation/providers/voice_room_provider.dart`
- `_connectToLiveKit()`: `ParticipantPermissionsUpdatedEvent` 리스너 추가
- `voice:stage_granted` 핸들러: `_cleanupLiveKit()` + `_connectToLiveKit()` 제거, 대신 `setMicrophoneEnabled(true)` 호출
- `voice:stage_removed` 핸들러: 동일하게 disconnect/reconnect 제거, `setMicrophoneEnabled(false)` 호출
- `leaveStage()`: disconnect/reconnect 제거
- `requestStage()`: 옵티미스틱 UI (API 호출 전에 `_hasRaisedHand = true`)
- `cancelStageRequest()`: 옵티미스틱 UI (API 호출 전에 `_hasRaisedHand = false`)

## 테스트 방법

1. 호스트가 음성대화방 생성
2. 리스너가 참여 → "손들기" 탭 → 즉시 UI 반영 확인
3. 호스트가 수락 → 리스너가 끊김 없이 스피커로 전환, 마이크 활성화
4. 양쪽 오디오 정상 수신 확인
5. 호스트가 스피커 강등 → 끊김 없이 리스너로 전환
6. SNS 서비스 로그에서 `[LiveKit] Updated permissions` 메시지 확인
