---
date: 2026-02-28
category: Mobile|Backend
title: 보이스룸 Critical/High 버그 일괄 수정
author: Claude Opus 4.6
tags: [voice-room, bugfix, security, livekit, socket]
priority: high
---

# 보이스룸 Critical/High 버그 일괄 수정

5개 에이전트를 병렬 투입하여 보이스룸 전체 코드를 조사한 결과 100+개 이슈 발견.
Critical/High 이슈를 우선 수정.

## 수정된 파일 및 내용

### 1. `voice_room_provider.dart` (Flutter Provider)

**Critical 수정:**
- **use-after-dispose 방지**: `_disposed` 플래그 + `_safeNotifyListeners()` 메서드로 모든 `notifyListeners()` 호출을 래핑. Timer/Future.delayed 콜백에서 dispose 후 호출 시 크래시 방지
- **concurrent join/create 방지**: `_isJoiningOrCreating` 가드 추가. 더블탭으로 중복 LiveKit 연결 생성 방지
- **_connectToLiveKit re-entrancy 방지**: `if (_isConnecting) return;` 가드. 기존 room이 있으면 dispose 후 새로 생성
- **이중 reconnect 타이머 방지**: `_reconnectTimer != null` 체크 + roomId 비교로 안전한 재연결

**High 수정:**
- **중복 참가자 방지**: `onVoiceParticipantJoined`에서 userId로 중복 체크 후 추가
- **중복 stage request 방지**: `onVoiceStageRequest`에서 userId 중복 체크
- **안전한 캐스팅**: `data['user_id'] as int` → `data['user_id'] as int?` + null 체크
- **reconnect 시 listener 정리**: `reconnect()` 및 `_attemptReconnect()`에서 `removeListener(_onActiveSpeakersChanged)` 호출
- **refreshParticipants 디바운스**: 500ms 디바운스 타이머로 LiveKit 이벤트 폭주 시 서버 과부하 방지
- **메시지 리스트 상한**: 500개 초과 시 오래된 메시지 제거 (메모리 누수 방지)
- **sendMessage 에러 핸들링**: try-catch 추가 + 에러 표시
- **rejectStageRequest 롤백**: 실패 시 제거한 request를 복원
- **grantStage/removeFromStage 에러 핸들링**: try-catch 추가
- **rate limit 에러 문자열 비교** → 상수 키 비교로 변경

### 2. `voice-room-handler.js` (Socket.IO 핸들러)

**Critical 수정:**
- **voice:join_room 인증 추가**: `VoiceRoom.isParticipant()` 확인 후 소켓 룸 입장 허용. 비참여자 도청 방지
- **voice:send_message 검증 추가**: 500자 제한, 소켓 룸 멤버십 확인

**High 수정:**
- **_voiceRooms 트래킹**: 소켓별 참여 룸 추적 (disconnect cleanup용)
- **room_id 유효성 검증**: 모든 핸들러에 `validateRoomId()` 적용
- **try-catch 래핑**: 모든 핸들러에 에러 핸들링 추가
- **character_position 검증**: 좌표를 0~1 범위로 클램프, direction 화이트리스트 검증
- **reaction 검증**: emoji 타입/길이 검증
- **소켓 룸 멤버십 확인**: `isInRoom()` 체크로 비참여자 이벤트 전송 차단

### 3. `socket-manager.js` (Socket 연결 관리)

**Critical 수정:**
- **disconnect 시 보이스룸 정리**: 소켓 연결 해제 시 `VoiceRoom.leave()` 호출 + 참가자 떠남 브로드캐스트 + 빈 방 자동 닫기. 고스트 참가자 누적 방지

### 4. `voice-rooms.controller.js` (REST API)

**Critical 수정:**
- **LiveKit 토큰 유출 방지**: `voice:stage_granted`와 `voice:stage_removed` 이벤트에서 토큰을 전체 룸이 아닌 대상 유저(`user:${targetUserId}`)에게만 전송

**High 수정:**
- **leaveStage null 크래시 수정**: `room`이 null이거나 closed일 때 404 반환 (기존: null reference 에러)
- **kickParticipant 타입 비교 수정**: `parseInt(targetUserId)` 적용으로 strict equality 실패 방지
- **강퇴 유저 소켓 룸 제거**: `fetchSockets()` + `s.leave()` + `_voiceRooms.delete()` 추가
- **closeRoom 중복 이벤트 수정**: 글로벌 broadcast만 사용 (기존: 룸 + 글로벌 이중 전송)
- **createRoom에 room_type 지원**: `room_type` 파라미터 파싱 + 검증 추가
- **title 길이 검증**: 100자 제한 추가

### 5. `voice_chat_widget.dart` (채팅 UI)

**High 수정:**
- **스마트 오토스크롤**: 사용자가 위로 스크롤한 경우 자동 스크롤 비활성화 + "New messages" 인디케이터 표시
- **chatError 표시**: 레이트 리밋/전송 실패 에러를 UI에 표시 (기존: 조용히 무시)
- **dispose 안전성**: `context.read()` 대신 `initState`에서 provider 캐시 후 dispose에서 null 처리
- **키보드 dismiss**: `ScrollViewKeyboardDismissBehavior.onDrag` 적용

### 6. `voice_rooms_list_screen.dart` (방 목록)

**High 수정:**
- **에러 상태 UI 추가**: 네트워크 오류 시 에러 메시지 + Retry 버튼 표시
- **더블탭 방지**: `_isJoining` 가드로 중복 네비게이션 방지
- **복귀 시 새로고침**: 보이스룸에서 나온 후 방 목록 자동 새로고침

### 7. `reaction_tray_widget.dart` (이모지 반응)

**High 수정:**
- **좁은 화면 오버플로우 수정**: `SingleChildScrollView(scrollDirection: Axis.horizontal)` 래핑

### 8. `room_card.dart` (방 카드)

- `onTap` 타입을 `VoidCallback?`(nullable)로 변경하여 비활성화 가능

## 미수정 (Medium/Low) — 향후 개선 사항
- DB 마이그레이션: `room_type` 컬럼 추가 필요
- LiveKit 토큰 TTL 갱신 메커니즘
- TURN 서버 활성화
- 소켓 이벤트 서버측 rate limiting
- 스테일 룸 자동 정리 크론잡
