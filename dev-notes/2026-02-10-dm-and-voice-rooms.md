---
date: 2026-02-10
category: Backend|Mobile|Infrastructure
title: 1:1 DM 시스템 + 음성 대화방 구현
author: Claude Opus 4.6
tags: [dm, voice-rooms, socket.io, livekit, real-time]
priority: high
---

## 개요

사용자 간 직접 소통을 위한 두 가지 핵심 기능 구현:
1. **1:1 DM (Direct Messaging)** - 텍스트, 이미지, 음성 메시지 지원
2. **음성 대화방** - LiveKit 기반, 최대 4명 동시 참가

## Phase 1: 1:1 DM

### 데이터베이스
- `011_add_dm_tables.sql`: `dm_conversations`, `dm_messages`, `dm_read_receipts` 3개 테이블 추가
- 대화 쌍 정규화: `user1_id < user2_id` 제약으로 중복 방지
- `client_message_id` UUID로 메시지 중복 전송 방지 (idempotency)

### 백엔드 (SNS Service)
- **새 의존성**: `socket.io`, `minio`, `multer`, `uuid`
- **Config**: `redis.js` (온라인 상태 추적), `minio.js` (이미지/음성 업로드)
- **Models**: `conversation.model.js`, `message.model.js`, `read-receipt.model.js`
- **Controllers/Routes**: 대화 목록, 메시지 히스토리, 미디어 업로드
- **Socket.IO**: `socket-manager.js` (JWT 인증 미들웨어), `dm-handler.js` (실시간 이벤트)
- **차단 연동**: `block.model.js`에 `isBlockedEitherWay()` 양방향 체크 추가

### Socket.IO 이벤트
| Client → Server | Server → Client |
|---|---|
| `dm:send_message` | `dm:new_message` |
| `dm:typing_start/stop` | `dm:typing` |
| `dm:mark_read` | `dm:read_receipt` |
| `dm:join/leave_conversation` | `dm:user_online/offline` |

### index.js 변경사항
- `app.listen()` → `http.createServer(app)` + Socket.IO 부착
- Socket.IO path: `/api/sns/socket.io`
- MinIO, Redis 초기화 추가 (비치명적 실패 허용)

### Flutter
- **새 의존성**: `socket_io_client`, `image_picker`
- **Models**: `ConversationModel`, `DmMessageModel`
- **Services**: `SocketService` (싱글턴, 자동 재연결, 스트림 기반)
- **Repository**: `DmRepository` (REST API fallback)
- **Provider**: `DmProvider` (낙관적 업데이트, 소켓 이벤트 처리)
- **UI**: 대화 목록, 채팅 화면, 메시지 버블, 입력 바

### 네비게이션 연동
- `CommunityScreen` AppBar에 메시지 아이콘 + 안읽은 수 배지
- `ProfileHeader`에 "Message" 버튼 추가 (Follow 옆)
- `main.dart`에 DmProvider + SocketService 초기화

## Phase 2: 음성 대화방

### Docker
- LiveKit 컨테이너: `livekit/livekit-server:latest`
- 포트: 7880 (HTTP), 7881 (TCP), 7882/udp (RTC)
- 설정: `config/livekit/livekit.yaml`

### 데이터베이스
- `012_add_voice_rooms.sql`: `voice_rooms`, `voice_room_participants` 테이블
- 방 상태: `active`/`closed`, 참가자 수 자동 관리
- 빈 방 자동 닫기

### 백엔드
- **새 의존성**: `livekit-server-sdk`
- **Config**: `livekit.js` (토큰 생성)
- **Model**: `voice-room.model.js` (트랜잭션 기반 참가/퇴장)
- **Controller**: 방 목록, 생성, 참가(토큰 반환), 퇴장, 닫기, 음소거
- **Socket 핸들러**: 실시간 참가자 변경 알림

### Flutter
- **Models**: `VoiceRoomModel`, `VoiceParticipantModel`
- **Repository**: `VoiceRoomRepository`
- **Provider**: `VoiceRoomProvider`
- **UI**: 방 목록, 활성 방 (다크 테마), 생성 폼

### 참가 플로우
1. 방 활성 확인 → 2. 정원 체크 → 3. 차단 유저 체크 → 4. DB 참가자 등록 → 5. LiveKit 토큰 생성 → 6. 클라이언트 반환

## Nginx 설정 변경

```nginx
# Socket.IO WebSocket 프록시
location /api/sns/socket.io/ { ... proxy_read_timeout 86400s; }

# LiveKit WebSocket 프록시
upstream livekit_service { server livekit:7880; }
location /livekit/ { ... }
```

## Docker 설정 변경

- SNS 서비스에 MinIO, LiveKit 환경변수 추가
- `depends_on`에 minio 추가
- LiveKit 컨테이너 추가 (`lemon-livekit`)

## 주요 결정사항

1. **Socket.IO vs 순수 WebSocket**: Socket.IO 선택 - 자동 재연결, 폴링 fallback, room 개념 내장
2. **Redis 온라인 상태**: TTL 300초, 비치명적 (Redis 없어도 DM 작동)
3. **미디어 업로드**: MinIO 직접 업로드 → media service 경로로 제공
4. **LiveKit 직접 포트 노출**: UDP 7882는 nginx 프록시 불가 → docker-compose에서 직접 노출
5. **낙관적 업데이트**: Flutter에서 메시지 즉시 표시, 서버 확인 후 ID 교체

## 배포 순서

1. DB 마이그레이션 실행 (011, 012)
2. `docker-compose build sns-service` (새 npm 패키지 설치)
3. `.env`에 `LIVEKIT_SECRET` 추가
4. `docker-compose up -d livekit sns-service nginx`
5. Flutter: `flutter pub get` → `./build_web.sh`

## 파일 목록

### 새 파일 (Backend)
```
services/sns/src/config/redis.js
services/sns/src/config/minio.js
services/sns/src/config/livekit.js
services/sns/src/models/conversation.model.js
services/sns/src/models/message.model.js
services/sns/src/models/read-receipt.model.js
services/sns/src/models/voice-room.model.js
services/sns/src/controllers/conversations.controller.js
services/sns/src/controllers/messages.controller.js
services/sns/src/controllers/voice-rooms.controller.js
services/sns/src/routes/conversations.routes.js
services/sns/src/routes/messages.routes.js
services/sns/src/routes/voice-rooms.routes.js
services/sns/src/socket/socket-manager.js
services/sns/src/socket/dm-handler.js
services/sns/src/socket/voice-room-handler.js
config/livekit/livekit.yaml
database/postgres/migrations/011_add_dm_tables.sql
database/postgres/migrations/012_add_voice_rooms.sql
```

### 새 파일 (Flutter)
```
lib/core/services/socket_service.dart
lib/data/models/conversation_model.dart
lib/data/models/dm_message_model.dart
lib/data/models/voice_room_model.dart
lib/data/repositories/dm_repository.dart
lib/data/repositories/voice_room_repository.dart
lib/presentation/providers/dm_provider.dart
lib/presentation/providers/voice_room_provider.dart
lib/presentation/screens/dm/conversations_screen.dart
lib/presentation/screens/dm/chat_screen.dart
lib/presentation/screens/dm/widgets/conversation_tile.dart
lib/presentation/screens/dm/widgets/message_bubble.dart
lib/presentation/screens/dm/widgets/chat_input_bar.dart
lib/presentation/screens/voice_rooms/voice_rooms_list_screen.dart
lib/presentation/screens/voice_rooms/voice_room_screen.dart
lib/presentation/screens/voice_rooms/create_voice_room_screen.dart
lib/presentation/screens/voice_rooms/widgets/participant_avatar.dart
lib/presentation/screens/voice_rooms/widgets/room_card.dart
```

### 수정된 파일
```
services/sns/src/index.js (Socket.IO 통합, 새 라우트)
services/sns/src/models/block.model.js (isBlockedEitherWay 추가)
services/sns/package.json (새 의존성)
nginx/nginx.conf (WebSocket + LiveKit 프록시)
docker-compose.yml (환경변수 + LiveKit 컨테이너)
mobile/lemon_korean/pubspec.yaml (socket_io_client, image_picker)
mobile/lemon_korean/lib/main.dart (DmProvider, VoiceRoomProvider, SocketService)
mobile/lemon_korean/lib/core/constants/api_constants.dart (DM 엔드포인트)
mobile/lemon_korean/lib/presentation/screens/community/community_screen.dart (DM + Voice 아이콘)
mobile/lemon_korean/lib/presentation/screens/user_profile/widgets/profile_header.dart (Message 버튼)
```
