---
date: 2026-02-27
category: Mobile
title: 음성 대화방(Voice Room) UX 종합 개선 구현 - 16+ 에이전트 병렬 실행
author: Claude Opus 4.6
tags: [voice-room, ux, accessibility, l10n, game-engine, livekit, flame]
priority: high
---

# 음성 대화방(Voice Room) UX 종합 개선 구현

> 2026-02-26 UX 리포트 기반, 16+ 에이전트 병렬 실행으로 전체 Phase 구현

---

## 변경 파일 목록 (24+ 파일)

### Flutter 위젯/화면 (12 파일)
- `voice_room_screen.dart` - 레이아웃 역전, 연결 배너, 확인 대화상자, 시맨틱스, l10n
- `create_voice_room_screen.dart` - 방 유형 선택기, 퀵 생성 템플릿, 세션 타이머, l10n
- `voice_rooms_list_screen.dart` - 마이크 권한 분리, FAB 툴팁, l10n
- `stage_controls_widget.dart` - 2단 레이아웃, InkWell, 시맨틱스, 햅틱 피드백, l10n
- `voice_chat_widget.dart` - 색상 대비 수정, 시맨틱스, l10n
- `audience_bar_widget.dart` - 빈 상태 처리, 색상 수정, 시맨틱스, l10n
- `room_card.dart` - 방 유형 뱃지, 색상 틴트, 시맨틱스, l10n
- `reaction_tray_widget.dart` - StatefulWidget, 슬라이드/페이드 애니메이션, 자동 닫기, l10n
- `gesture_tray_widget.dart` - StatefulWidget, 쿨다운 인디케이터, 애니메이션, l10n
- `stage_area_widget.dart` - STAGE/You 라벨 l10n

### 상태 관리 & 데이터 (5 파일)
- `voice_room_provider.dart` - 마이크 장애 알림, 발화 인디케이터, 에러 메시지 개선, 채팅 레이트 리밋, 재연결 피드백, 스테이지 요청 거부
- `voice_room_model.dart` - RoomTypes 클래스(6종), roomType/duration 필드, localizedRoomType 메서드
- `voice_room_repository.dart` - roomType/duration 파라미터, rejectStageRequest API
- `socket_service.dart` - voice:stage_request_rejected 스트림
- `conversation_prompts.dart` (신규) - 59개 대화 주제 프롬프트 (6개 방 유형 × 3개 레벨)

### Flame 게임 엔진 (7 파일)
- `voice_stage_game.dart` - Ambient sparkles, 호스트 지원, 스팟 마커, 반응형 스케일링
- `equipment_layer.dart` - 아이들 숨쉬기 애니메이션, 픽셀 퍼펙트 Paint
- `remote_character.dart` - 프레임레이트 독립 보간(dt), 호스트 지원
- `game_bridge.dart` - isHost 이벤트 필드
- `name_label.dart` - 호스트 왕관 이모지, 골드 틴트
- `speaking_aura.dart` - 호스트 골드 아우라
- `pixel_character.dart` - 동적 displayScale

### 백엔드 (2 파일)
- `voice-rooms.controller.js` - rejectStageRequest 컨트롤러
- `voice-rooms.routes.js` - POST /:id/reject-stage 라우트

### l10n (6 ARB + generated)
- `app_en.arb` - 59개 신규 키 (메타데이터 포함)
- `app_ko.arb` - 한국어 번역
- `app_es.arb` - 스페인어 번역
- `app_ja.arb` - 일본어 번역
- `app_zh.arb` - 중국어 간체 번역
- `app_zh_TW.arb` - 중국어 번체 번역

---

## 주요 개선 카테고리

### 1. 접근성 (WCAG AA)
- 색상 대비 alpha 0.3 → 0.6+ (4.5:1 이상)
- 모든 인터랙티브 요소에 `Semantics(button: true, label: ...)` 추가
- liveRegion 연결 배너 (스크린리더 자동 알림)
- 최소 폰트 사이즈 11px 보장

### 2. 사용성
- 컨트롤 버튼 2단 분리 (Primary: Mute/Leave/React, Secondary: Gesture/Stage/More)
- 위험 동작(강등/추방) 확인 대화상자
- 뒤로가기 더블탭 보호
- 스피커 퇴장 시 확인 다이얼로그
- 스테이지 요청 거부 버튼 추가
- 마이크 장애 시 SnackBar 알림
- 채팅 메시지 1초 레이트 리밋
- 재연결 성공 "Connected!" 배너

### 3. 방 유형 시스템
- 6가지 유형: 자유대화/발음연습/역할극/Q&A/듣기/토론
- 59개 대화 주제 프롬프트 (한영 이중언어)
- 퀵 생성 템플릿 4종
- 세션 타이머 옵션 (15/30/45/60분)

### 4. 게임 스테이지
- Ambient sparkles 활성화
- 캐릭터 숨쉬기 아이들 애니메이션
- 호스트 왕관 + 골드 아우라
- 프레임레이트 독립 보간
- 픽셀 퍼펙트 렌더링
- 반응형 캐릭터 스케일링

### 5. 다국어 (l10n)
- 59개 신규 번역 키 (6개 언어)
- 모든 하드코딩 영어 문자열 l10n 적용
- Semantics 라벨까지 다국어 처리

---

## 구현 전략

### Phase 1: 분석 (5 에이전트)
UX/UI, Experience, Product, Game UI/UX, Usability 전문가 에이전트 → 종합 리포트 작성

### Phase 2: 구현 (12 에이전트, 병렬)
파일별 비충돌 분할:
1. 색상/대비 → 2. 시맨틱스 → 3. 컨트롤 레이아웃 → 4. Provider 로직
5. 게임 엔진 폴리싱 → 6. 호스트 비주얼 → 7. 방 화면 레이아웃 → 8. 관리 시트
9. 리액션/제스처 트레이 → 10. l10n ARB → 11. 마이크 권한 → 12. 방 유형

### Phase 3: 재구현 (4 에이전트, worktree 문제 후)
게임 / Provider+Model / Screen / Widgets 그룹으로 재분할

### Phase 4: l10n (5 에이전트)
1. ARB 키 추가 (59개 × 6 언어) + gen-l10n
2-5. Dart 소스 파일 l10n 적용 (4 에이전트 병렬)

---

## dart analyze 결과
- **0 errors** ✅
- 3 pre-existing warnings (unused imports/fields)
- ~30 info-level style hints (pre-existing)
