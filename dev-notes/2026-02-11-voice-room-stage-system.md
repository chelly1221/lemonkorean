---
date: 2026-02-11
category: Mobile|Backend|Database
title: 음성 대화방 스테이지/청취자 시스템 구현
author: Claude Opus 4.6
tags: [voice-room, stage, livekit, socket-io, character, localization]
priority: high
---

# 음성 대화방 스테이지/청취자 시스템

## 개요

기존 2-4인 단순 그룹 통화를 **스테이지 기반 경험**으로 변환:
- **스테이지 (상단)**: 제한된 발언자, 걸어다니는 캐릭터, 이모지 리액션, 제스처 애니메이션
- **청취석 (무제한)**: 리스너 프로필 사진 + 이름 가로 스크롤
- **텍스트 채팅**: 실시간 메시지 (방 종료 시 삭제 - 임시 채팅)
- `maxParticipants` → `maxSpeakers` (스테이지 슬롯만 제한)
- 방장만 승격/강등 권한 보유

## 변경 사항

### Phase 1: 데이터베이스 마이그레이션
- `database/postgres/migrations/014_voice_room_stage_system.sql`
  - `voice_rooms`: `max_participants` → `max_speakers`, `participant_count` → `speaker_count`, `listener_count` 추가
  - `voice_room_participants`: `role` 컬럼 추가 (speaker/listener)
  - 신규 테이블: `voice_room_messages` (임시 채팅), `voice_room_stage_requests` (손들기)

### Phase 2: 백엔드 (SNS 서비스)
- `services/sns/src/models/voice-room.model.js` - 전면 재작성 (~536줄)
  - `join()`: 항상 listener로 입장 (용량 제한 없음)
  - `joinAsSpeaker()`: 방장 전용 (용량 체크)
  - `promoteToSpeaker()`, `demoteToListener()`: 트랜잭션, 캐릭터 데이터 반환
  - `requestStage()`, `resolveStageRequest()`: 손들기 시스템
  - `close()`: 임시 메시지 삭제 + 대기 요청 취소
- `services/sns/src/models/voice-room-message.model.js` - 신규
- `services/sns/src/controllers/voice-rooms.controller.js` - 7개 신규 엔드포인트
  - GET/POST `/:id/messages`, POST/DELETE `/:id/request-stage`
  - POST `/:id/grant-stage`, `/:id/remove-from-stage`, `/:id/leave-stage`
- `services/sns/src/config/livekit.js` - role 기반 토큰 (speaker: canPublish, listener: subscribe-only)
- `config/livekit/livekit.yaml` - max_participants: 200 (리스너 무제한)
- `services/sns/src/socket/voice-room-handler.js` - 신규 이벤트: voice:send_message, voice:character_position, voice:reaction, voice:gesture

### Phase 3: Flutter 데이터 레이어
- `voice_room_model.dart` - `VoiceRoomModel` 재작성: maxSpeakers, speakerCount, listenerCount, isStageFull
- `VoiceParticipantModel`: role, equippedItems, skinColor 추가
- 신규: `VoiceChatMessageModel`, `StageRequestModel`
- `voice_room_repository.dart` - 7개 신규 API 메서드
- `socket_service.dart` - 9개 신규 스트림 + 이미터

### Phase 4: Flutter Provider
- `voice_room_provider.dart` 전면 재작성 (~1072줄)
  - `StageCharacterState`: 위치, 방향, 장착 아이템, 제스처 상태
  - 포지션 스로틀링 (100ms, 최소 0.005 이동)
  - 제스처 쿨다운 3초
  - LiveKit speaker만 마이크 활성화
  - 리액션 2초 자동 정리

### Phase 5: Flutter UI
- 신규 위젯: `stage_area_widget.dart` (60fps 캐릭터 보간, 탭 이동, 제스처 애니메이션)
- 신규 위젯: `audience_bar_widget.dart`, `voice_chat_widget.dart`, `stage_controls_widget.dart`
- 신규 위젯: `reaction_tray_widget.dart`, `gesture_tray_widget.dart`
- `voice_room_screen.dart` 전면 재작성: 스테이지(40%) → 청취석 → 채팅(30%) → 컨트롤
- `room_card.dart` 업데이트: 🎤 2/4 👁 12 표시, isFull → isStageFull
- `create_voice_room_screen.dart` 업데이트: "Max Participants" → "Stage Slots" + 부제

### Phase 6: 다국어 (6개 언어)
- `maxParticipants` → `stageSlots` 변경
- 11개 신규 키 추가: `anyoneCanListen`, `emojiReaction`, `gesture`, `raiseHand`, `cancelRequest`, `leaveStage`, `pendingRequests`, `typeAMessage`, `stageRequests`, `noPendingRequests`, `onStage`
- en, ko, ja, es, zh, zh_TW 모두 적용

## 아키텍처 결정
- **임시 채팅**: 방 종료 시 메시지 삭제 (저장 부담 제거)
- **리스너 무제한**: LiveKit subscribe-only 효율적 처리
- **방장만 승격/강등**: 명확한 권한 관리
- **캐릭터 위치 10Hz + 60fps 보간**: 네트워크 부담 최소화, 부드러운 시각 효과
