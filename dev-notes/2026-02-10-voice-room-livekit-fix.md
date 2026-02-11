---
date: 2026-02-10
category: Mobile
title: 음성 대화방 LiveKit 연결 실패 수정 및 재연결 기능 추가
author: Claude Opus 4.6
tags: [voice-room, livekit, socket-io, reconnect, bugfix]
priority: high
---

## 문제

폰(Galaxy S24)에서 음성 대화방 생성/참여 시 LiveKit 연결 실패:
```
ClientException with SocketException: Failed host lookup: 'livekit'
```

**근본 원인**: 백엔드 SNS 서비스가 클라이언트에 내부 Docker 호스트네임(`ws://livekit:7880`)을 반환. `docker-compose.yml`에 `LIVEKIT_PUBLIC_URL: wss://lemon.3chan.kr/livekit/`가 설정되어 있었으나 실행 중인 컨테이너에 반영되지 않은 상태.

## 수정 내용

### 1. SNS 컨테이너 재생성
- `docker compose up -d sns-service`로 환경변수 적용
- 검증: `docker compose exec sns-service printenv | grep LIVEKIT_PUBLIC`

### 2. LiveKit 연결 개선 (`voice_room_provider.dart`)
- 연결 타임아웃 15초 추가
- 연결 실패 시 `_error` 상태 설정 (이전에는 로그만 남김)
- `RoomDisconnectedEvent` 발생 시 자동 재연결 (최대 3회, exponential backoff: 2s, 4s, 8s)
- 재연결 실패 시 수동 `reconnect()` 메서드 제공
- `TimeoutException` 별도 처리

### 3. Socket.IO 음성방 이벤트 구독 (`voice_room_provider.dart`, `socket_service.dart`)
- **버그 수정**: `_socket.joinConversation()` (DM용) → `_socket.joinVoiceRoom()` (음성방용)으로 변경
- `voice:participant_joined` → 참가자 목록 갱신
- `voice:participant_left` → 참가자 목록 갱신
- `voice:participant_muted` → 로컬 음소거 상태 즉시 업데이트
- `voice:room_closed` → 방 종료 처리 (LiveKit 정리, 에러 메시지 표시)

### 4. UI 개선 (`voice_room_screen.dart`)
- 재연결 중 배너: "Reconnecting (1/3)..." + 스피너
- 연결 끊김 배너: 에러 메시지 + "Retry" 버튼 (탭하면 수동 재연결)
- 방이 호스트에 의해 닫힌 경우: 안내 메시지 + "Go Back" 버튼

## 변경 파일
- `mobile/lemon_korean/lib/core/services/socket_service.dart` - 음성방 이벤트 스트림/핸들러 추가
- `mobile/lemon_korean/lib/presentation/providers/voice_room_provider.dart` - 재연결 로직, 소켓 이벤트 구독
- `mobile/lemon_korean/lib/presentation/screens/voice_rooms/voice_room_screen.dart` - 연결 상태 UI 개선

## 검증 방법
1. `docker compose exec sns-service printenv | grep LIVEKIT_PUBLIC` → `wss://lemon.3chan.kr/livekit/`
2. 폰에서 음성 대화방 생성 → logcat에서 "LiveKit connected" 확인
3. 네트워크 끊었다 연결 → "Reconnecting (1/3)..." 배너 표시 후 자동 재연결
4. 두 폰에서 같은 방 → Socket.IO로 참가자 목록 실시간 업데이트
