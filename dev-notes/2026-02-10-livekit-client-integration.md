---
date: 2026-02-10
category: Mobile
title: LiveKit 클라이언트 통합 - 음성대화방 실제 음성 연결 구현
author: Claude Opus 4.6
tags: [livekit, voice-rooms, webrtc, audio]
priority: high
---

# LiveKit 클라이언트 통합

## 배경
음성대화방 UI/백엔드/인프라(LiveKit 서버)는 완성되어 있었으나, Flutter 앱에서 실제 LiveKit 서버에 연결하는 코드가 없어 소리가 전달되지 않았음. 백엔드가 `livekitToken`과 `livekitUrl`을 반환하지만 앱에서 사용하지 않고 있었음.

## 변경 사항

### 1. 패키지 추가 (`pubspec.yaml`)
- `livekit_client: ^2.1.0` 추가 (connectivity_plus ^5.0.2와의 호환성을 위해 2.1.0 사용)

### 2. Android 권한 (`AndroidManifest.xml`)
- `RECORD_AUDIO`, `MODIFY_AUDIO_SETTINGS`, `BLUETOOTH`, `BLUETOOTH_CONNECT` 권한 추가

### 3. 백엔드 환경변수 (`docker-compose.yml`)
- SNS service에 `LIVEKIT_PUBLIC_URL: wss://lemon.3chan.kr/livekit/` 추가
- 기존 `getLiveKitUrl()`이 Docker 내부 주소(`ws://livekit:7880`)를 반환하여 폰에서 접근 불가했음
- nginx가 이미 `/livekit/` → `livekit:7880` WebSocket 프록시 설정되어 있으므로 public URL만 추가

### 4. LiveKit 통합 (`voice_room_provider.dart`) - 핵심 변경
- `lk.Room` 생성 및 연결 (`_connectToLiveKit()`)
- 이벤트 리스너: 연결/해제/참가자 변경/뮤트 이벤트 처리
- `createRoom()`/`joinRoom()` 성공 후 자동 LiveKit 연결
- `leaveRoom()`/`closeRoom()` 시 LiveKit 정리
- `toggleMute()`: LiveKit 로컬 트랙 먼저 토글 → 서버 비동기 알림 (즉각 반응)
- `isConnecting`/`isConnected` 상태 getter 추가
- `dispose()` 시 LiveKit 리소스 정리

### 5. UI 개선 (`voice_room_screen.dart`)
- 5초 폴링 타이머 **제거** (LiveKit 이벤트가 실시간 업데이트 처리)
- 연결 상태 배너 추가: "Connecting..." (주황) / "Disconnected" (빨강)

### 6. 마이크 권한 (`voice_rooms_list_screen.dart`, `create_voice_room_screen.dart`)
- 방 입장/생성 전 `Permission.microphone.request()` 호출
- 권한 거부 시 SnackBar 안내
- 웹에서는 권한 요청 스킵 (`kIsWeb` 체크)

## 기술 참고
- `livekit_client 2.1.0` 사용 (2.3.3+는 connectivity_plus ^6 필요하여 호환성 문제)
- DTX(Discontinuous Transmission) 활성화로 무음 시 대역폭 절약
- 웹 플랫폼에서는 LiveKit 연결 스킵 (향후 필요 시 별도 처리)

## 테스트 방법
1. `docker compose restart sns-service` (환경변수 반영)
2. `flutter run -d <device>` 로 두 대의 폰에 설치
3. 계정A: 방 생성 → 마이크 권한 허용 → 연결 배너 확인
4. 계정B: 방 입장 → 마이크 권한 → 서로 소리 확인
5. Mute 토글, 나가기/닫기 정상 동작 확인
