---
date: 2026-02-14
category: Mobile|Backend
title: 음성 대화방 LiveKit 고급 기능 구현
author: Claude Opus 4.6
tags: [voice-room, livekit, audio, connection-quality, kick, invite-to-stage]
priority: high
---

## 개요
음성 대화방에 4가지 기능을 추가:
1. 오디오 품질 설정 (echo cancellation, noise suppression, auto gain control, high pass filter)
2. 연결 품질 UI (참가자별 신호 강도 배지)
3. 서버 측 Room/Participant 제어 (방 삭제, 참가자 강제퇴장)
4. Pull to Stage (호스트가 리스너를 직접 스테이지로 초대)

## 변경 사항

### Feature 1: 오디오 품질 설정
- `voice_room_provider.dart`: `RoomOptions`에 `defaultAudioCaptureOptions` 추가
- `echoCancellation`, `noiseSuppression`, `autoGainControl`은 기본값이 true이나 명시적으로 설정
- `highPassFilter: true` 추가 (기본값 false)

### Feature 2: 연결 품질 UI
- `StageCharacterState`에 `connectionQuality` 필드 추가
- LiveKit `ParticipantConnectionQualityUpdatedEvent` 리스너 추가
- `ConnectionQualityChanged` GameBridge 이벤트 추가
- **새 파일**: `connection_quality_badge.dart` - 신호 바 Flame 컴포넌트
  - excellent/unknown: 숨김
  - good: 노란색 2칸
  - poor: 빨간색 1칸
  - lost: 빨간 X
- `RemoteCharacter`와 `VoiceStageGame`에 배지 통합

### Feature 3: 서버 측 제어
- `livekit.js`: `roomService` export 추가
- `closeRoom`: 방 닫기 시 `roomService.deleteRoom()` 호출 (best-effort)
- **새 엔드포인트**: `POST /:id/kick` - 참가자 강제퇴장
  - DB에서 제거 + LiveKit에서 `removeParticipant()` 호출
  - `voice:participant_kicked` + `voice:participant_left` 소켓 이벤트 발송
- 프론트엔드: `voice:participant_kicked` 소켓 이벤트 핸들러 추가
  - 내가 강퇴당하면 전체 정리 + "You were removed from the room by the host" 에러
- Stage Management 바텀시트에 킥 버튼 추가 (스피커 + 리스너 섹션)

### Feature 4: Pull to Stage
- **새 엔드포인트**: `POST /:id/invite-to-stage` - 리스너를 스피커로 직접 초대
  - `grantStage`와 동일 패턴이나 stage request 없이 동작
  - 기존 `voice:role_changed` + `voice:stage_granted` 소켓 이벤트 재활용
- `AudienceBarWidget`에 `onListenerTap` 콜백 추가
- 호스트가 리스너 아바타 탭 시 초대 확인 다이얼로그 표시

## 수정된 파일

### 백엔드
- `services/sns/src/config/livekit.js` - roomService export
- `services/sns/src/controllers/voice-rooms.controller.js` - closeRoom 수정, kickParticipant/inviteToStage 추가
- `services/sns/src/routes/voice-rooms.routes.js` - kick/invite-to-stage 라우트

### Flutter
- `voice_room_provider.dart` - 오디오 옵션, 연결 품질, kick/invite 메서드
- `voice_room_repository.dart` - kickParticipant/inviteToStage API
- `socket_service.dart` - voice:participant_kicked 이벤트
- `game_bridge.dart` - ConnectionQualityChanged 이벤트
- `voice_stage_game.dart` - 연결 품질 배지
- `remote_character.dart` - 연결 품질 배지
- `connection_quality_badge.dart` - 새 파일
- `audience_bar_widget.dart` - onListenerTap 콜백
- `voice_room_screen.dart` - kick UI, invite 다이얼로그

## 검증 방법
1. SNS 서비스 재빌드: `docker compose up -d --build sns`
2. Flutter 웹: `cd mobile/lemon_korean && ./build_web.sh`
3. 테스트 시나리오:
   - 방 생성 후 음성 통화 - 에코/노이즈 억제 확인
   - 네트워크 저하 시 신호 강도 배지 표시 확인
   - 호스트가 참가자 강퇴 시 "removed by host" 메시지 확인
   - 호스트가 리스너 아바타 탭 → 초대 → 스피커 승격 확인
   - 방 닫기 시 SNS 로그에 `[LiveKit] Deleted room` 확인
