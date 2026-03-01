---
date: 2026-03-01
category: Mobile
title: 음성 대화방 전체 UI 종합 버그 감사 및 수정
author: Claude Opus 4.6
tags: [voice-room, bugfix, i18n, race-condition, memory-leak, accessibility]
priority: high
---

## 개요

음성 대화방 기능의 10개 UI 요소에 대해 10가지 감사 카테고리(null safety, 상태관리, 경쟁조건, 메모리 누수, 네비게이션/생명주기, i18n, 에러처리, UI 레이아웃, 접근성, 엣지케이스)를 기반으로 종합 버그 감사 및 수정을 수행했다.

## 감사 대상 요소 (10개)

1. VoiceRoomsListScreen (방 목록)
2. CreateVoiceRoomScreen (방 생성)
3. RoomCard (방 카드)
4. VoiceChatWidget (채팅)
5. StageControlsWidget (스테이지 컨트롤)
6. AudienceBarWidget (청중 바)
7. ReactionTrayWidget (리액션 트레이)
8. GestureTrayWidget (제스처 트레이)
9. VoiceRoomScreen 메인 (연결 배너, 나가기/닫기, 스테이지 관리)
10. VoiceRoomProvider (상태 관리, 소켓, LiveKit)

## 주요 수정 사항

### HIGH 심각도 수정

| 요소 | 버그 | 수정 |
|------|------|------|
| VoiceChatWidget | "New messages" 하드코딩 영문 | l10n 키 적용 (`voiceRoomNewMessages`) |
| VoiceChatWidget | `_localizedChatError` 함수가 l10n 파라미터 무시 | l10n 사용하도록 수정 |
| AudienceBarWidget | `NetworkImage` 실패 시 위젯 크래시 | `onBackgroundImageError` 콜백 추가 |
| ReactionTrayWidget | 타이머+버튼 동시 탭으로 `onClose` 이중 호출 | `_isClosing` 가드 플래그 추가 |
| VoiceRoomScreen | `_game` (FlameGame) 미해제, GPU 리소스 누수 | `dispose()`에서 `_game?.onRemove()` 호출 |
| VoiceRoomProvider | `leaveStage()`에 try-catch 없음 (오프라인 크래시) | try-catch 래핑 추가 |

### MEDIUM 심각도 수정

| 요소 | 버그 | 수정 |
|------|------|------|
| VoiceChatWidget | `_onNewMessage` mounted 미확인 | `if (!mounted) return` 추가 |
| VoiceChatWidget | `_scrollToBottom` 콜백 mounted 미확인 | `if (!mounted)` 가드 추가 |
| VoiceChatWidget | `_localizedChatError` default case가 raw key 반환 | 일반 오류 메시지 폴백 추가 |
| StageControlsWidget | 배지 시맨틱 "pending requests" 하드코딩 | 영문 제거, 숫자만 표시 |
| GestureTrayWidget | 동일한 double-close 경쟁조건 | `_isClosing` 가드 추가 |
| GestureTrayWidget | `build()` 내 상태 직접 변경 | `addPostFrameCallback`으로 이동 |
| GestureTrayWidget | 강등 후 제스처 탭 시 가짜 쿨다운 표시 | `isSpeaker` 체크 추가 |
| VoiceRoomScreen | Leave/Close 더블탭 시 `Navigator.pop` 이중 호출 | `_isLeaving` 가드 추가 |
| VoiceRoomScreen | room-closed 타이머가 Consumer context 사용 | `Navigator.of(context)` 미리 캡처 |
| VoiceRoomProvider | 변경 가능한 컬렉션 getter로 외부 상태 오염 가능 | `List.unmodifiable` / `Map.unmodifiable` 적용 |
| VoiceRoomProvider | 하드코딩 영문 에러 메시지 6건 | 에러 코드 키로 변환 |
| VoiceRoomProvider | 스피커 중복 추가 가능 (소켓 이벤트 재생) | `removeWhere` 중복 제거 추가 |

## i18n 변경

### 새로 추가된 l10n 키 (6개 언어 모두 적용)
- `roomClosedByHost`
- `removedFromRoomByHost`
- `connectionTimedOut`
- `missingLiveKitCredentials`
- `microphoneEnableFailed`
- `voiceRoomNewMessages`
- `voiceRoomChatRateLimited`
- `voiceRoomMessageSendFailed`
- `voiceRoomChatError`

### ErrorLocalizer 업데이트
- 5개 새 에러 코드 매핑 추가
- VoiceRoomScreen, VoiceRoomsListScreen, CreateVoiceRoomScreen에서 `ErrorLocalizer.localize()` 사용하도록 업데이트

## 변경 파일 목록

### Flutter 앱
- `lib/presentation/screens/voice_rooms/voice_rooms_list_screen.dart`
- `lib/presentation/screens/voice_rooms/create_voice_room_screen.dart`
- `lib/presentation/screens/voice_rooms/voice_room_screen.dart`
- `lib/presentation/screens/voice_rooms/widgets/room_card.dart`
- `lib/presentation/screens/voice_rooms/widgets/voice_chat_widget.dart`
- `lib/presentation/screens/voice_rooms/widgets/stage_controls_widget.dart`
- `lib/presentation/screens/voice_rooms/widgets/audience_bar_widget.dart`
- `lib/presentation/screens/voice_rooms/widgets/reaction_tray_widget.dart`
- `lib/presentation/screens/voice_rooms/widgets/gesture_tray_widget.dart`
- `lib/presentation/providers/voice_room_provider.dart`
- `lib/core/utils/error_localizer.dart`

### l10n (6개 언어)
- `lib/l10n/app_en.arb`
- `lib/l10n/app_ko.arb`
- `lib/l10n/app_ja.arb`
- `lib/l10n/app_es.arb`
- `lib/l10n/app_zh.arb`
- `lib/l10n/app_zh_TW.arb`
- `lib/l10n/generated/` (자동 생성)

---

## Phase 2: 심층 버그 수정 (2026-03-01 오후)

7개 디버깅 에이전트의 추가 분석으로 발견된 ~50건의 버그를 8개 그룹으로 나누어 수정.

### GROUP 1: DB 마이그레이션 (Critical)
- **신규**: `database/postgres/migrations/019_voice_room_enhancements.sql`
- `room_type VARCHAR(20)` 컬럼 (CHECK constraint, DEFAULT 'free_talk')
- `duration INTEGER` 컬럼 (NULL = 무제한)

### GROUP 2: 백엔드 모델
- `voice-room.model.js` - `create()`에 roomType/duration, `toggleMute()`에 desiredState
- `socket-manager.js` - disconnect 30초 grace period + 재연결 확인

### GROUP 3: 백엔드 컨트롤러 & 소켓 핸들러
- `voice-rooms.controller.js` - toggleMute desiredState, createRoom duration, closeRoom에 creator_id
- `voice-room-handler.js` - gesture DB 역할 검증, send_message 데드코드 제거

### GROUP 4: Flutter Mute 시스템
- 서버 응답과 로컬 상태 동기화, API 실패 시 롤백, speakers/stageCharacters/GameBridge 동시 업데이트
- `voice_room_repository.dart` - desiredState 파라미터 추가

### GROUP 5: Gesture & Stage Request
- Per-gesture 쿨다운 맵 (`_lastGestureSentMap`), 개별 제스처 쿨다운 시각화
- `_isTogglingStageRequest` 가드, `grantStage()` 반환값 확인

### GROUP 6: Room Lifecycle
- `leaveStage()` speakers→listeners 이동 + Flame 통지
- `onVoiceRoomClosed` creator_id 자체 이벤트 무시, `detachGameBridge()`, `leaveVoiceRoom()` 추가
- `onVoiceParticipantKicked` 동일 리소스 정리, 추방 시 즉시 이동 (3초→0초)

### GROUP 7: Chat
- `sendMessage()` null 반환 시 chatError 설정
- `_isSending` 가드 + 버튼 비활성화, `maxLength: 500`

### GROUP 8: UI Feedback & Error Localizer
- `inviteToStage()`/`removeFromStage()` 실패 에러 표시
- `onVoiceStageRequestRejected` 거절 에러 표시
- ErrorLocalizer에 6개 새 에러 키, 6개 언어 번역 추가

### 추가 변경 파일
- `database/postgres/migrations/019_voice_room_enhancements.sql` (신규)
- `services/sns/src/models/voice-room.model.js`
- `services/sns/src/socket/socket-manager.js`
- `services/sns/src/controllers/voice-rooms.controller.js`
- `services/sns/src/socket/voice-room-handler.js`
- `lib/data/repositories/voice_room_repository.dart`
