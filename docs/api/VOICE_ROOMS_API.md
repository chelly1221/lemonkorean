# Voice Rooms API

## Overview

The Voice Rooms API provides stage-based live voice chat experiences with character positioning, reactions, and gestures. Built on LiveKit for scalable real-time audio, the system supports unlimited listeners with limited speaker slots, enabling live language practice rooms, study sessions, and community events.

**Service Information:**
- **Base URL**: `https://lemon.3chan.kr/api/sns`
- **Socket.IO URL**: `wss://lemon.3chan.kr/socket.io`
- **LiveKit URL**: `wss://lemon.3chan.kr:7880` (internal: 7881, UDP: 50000-50200)
- **Port**: 3007 (SNS Service)
- **Technology**: Node.js (Express + Socket.IO) + LiveKit (media server)
- **Authentication**: JWT required for all endpoints and connections
- **Database**: PostgreSQL (rooms, participants, messages, stage requests)

**Last Updated**: 2026-02-11

---

## Architecture

### Stage/Audience System

Voice rooms use a **two-tier participant model**:

1. **Speakers (Stage):**
   - Limited slots (default: 4, configurable up to 10)
   - Can publish audio (talk)
   - Can move character around the stage
   - Can send reactions and gestures
   - Full interaction capabilities

2. **Listeners (Audience):**
   - Unlimited capacity (200+ listeners supported)
   - Can only subscribe to audio (listen)
   - Can send text messages and reactions
   - Can raise hand to request stage access
   - Low-bandwidth, scalable

### LiveKit Integration

- **Network Mode**: `host` (ports 7880, 7881, 50000-50200/udp exposed)
- **TURN**: Disabled for performance (relies on UDP hole punching)
- **Roles**: Two LiveKit roles with different permissions:
  - `speaker`: Can publish audio tracks
  - `listener`: Can only subscribe to audio tracks
- **Token Generation**: Server-side, role-based, with room name and participant identity
- **Configuration**: `/config/livekit/livekit.yaml`

### Character Positioning

- **Update Rate**: 10Hz from client (10 updates per second)
- **Render Rate**: 60fps client-side interpolation
- **Position Format**: `{ x: float, y: float, direction: 'left'|'right' }`
- **Broadcast**: Server relays position updates to all room participants via Socket.IO

### Ephemeral Chat

- Messages are stored in `voice_room_messages` table
- Automatically deleted when the room closes
- Supports text and system messages (e.g., "Alice joined the stage")

---

## Table of Contents

1. [REST Endpoints](#rest-endpoints)
2. [Socket.IO Events](#socketio-events)
3. [LiveKit Connection](#livekit-connection)
4. [Stage Management](#stage-management)
5. [Character Positioning](#character-positioning)
6. [Error Handling](#error-handling)

---

## REST Endpoints

### Get Rooms
Retrieve all active voice rooms.

**Endpoint:** `GET /api/sns/voice-rooms`
**Authentication:** Required

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Rooms per page (default: 20, max: 50)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Korean Study Room 🇰🇷",
      "description": "Practice speaking Korean with fellow learners",
      "host": {
        "id": 123,
        "username": "host1",
        "display_name": "Alice",
        "profile_image_url": "https://..."
      },
      "max_speakers": 4,
      "speaker_count": 3,
      "listener_count": 12,
      "is_public": true,
      "language": "ko",
      "tags": ["korean", "practice", "beginner"],
      "created_at": "2026-02-11T10:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 5,
    "totalPages": 1
  }
}
```

**Notes:**
- Rooms are sorted by creation time (newest first)
- `speaker_count` + `listener_count` = total participants

---

### Create Room
Create a new voice room.

**Endpoint:** `POST /api/sns/voice-rooms`
**Authentication:** Required

**Request Body:**
```json
{
  "name": "Beginner Korean Speaking Practice",
  "description": "Let's practice basic Korean conversations!",
  "max_speakers": 4,
  "is_public": true,
  "language": "ko",
  "tags": ["korean", "speaking", "beginner"]
}
```

**Fields:**
- `name` (required): Room name (max 100 characters)
- `description` (optional): Room description (max 500 characters)
- `max_speakers` (optional): Maximum speakers on stage (default: 4, min: 2, max: 10)
- `is_public` (optional): Public visibility (default: true)
- `language` (optional): Primary language code (`ko`, `en`, `ja`, etc.)
- `tags` (optional): Array of tags (max 5 tags)

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 2,
    "name": "Beginner Korean Speaking Practice",
    "host": {
      "id": 123,
      "username": "host1",
      "display_name": "Alice"
    },
    "max_speakers": 4,
    "speaker_count": 1,
    "listener_count": 0,
    "livekit_token": "eyJhbGc...",
    "livekit_url": "wss://lemon.3chan.kr:7880",
    "created_at": "2026-02-11T15:00:00Z"
  }
}
```

**Notes:**
- Creator automatically joins as a speaker (speaker_count starts at 1)
- `livekit_token` is a time-limited JWT for LiveKit connection (valid for 1 hour)
- Creator is automatically the host with special permissions

---

### Get Room Details
Retrieve detailed information about a specific room.

**Endpoint:** `GET /api/sns/voice-rooms/:id`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Korean Study Room 🇰🇷",
    "description": "Practice speaking Korean with fellow learners",
    "host": {
      "id": 123,
      "username": "host1",
      "display_name": "Alice"
    },
    "max_speakers": 4,
    "speaker_count": 3,
    "listener_count": 12,
    "is_public": true,
    "language": "ko",
    "tags": ["korean", "practice", "beginner"],
    "speakers": [
      {
        "id": 123,
        "username": "host1",
        "display_name": "Alice",
        "character": { ... },
        "is_muted": false
      },
      {
        "id": 456,
        "username": "speaker2",
        "display_name": "Bob",
        "character": { ... },
        "is_muted": false
      }
    ],
    "stage_requests": [
      {
        "user_id": 789,
        "username": "listener1",
        "display_name": "Charlie",
        "requested_at": "2026-02-11T15:10:00Z"
      }
    ],
    "created_at": "2026-02-11T10:00:00Z"
  }
}
```

**Notes:**
- `speakers` array includes character customization data
- `stage_requests` shows pending raise-hand requests (host only)

---

### Join Room
Join a voice room as a listener or speaker (if slots available).

**Endpoint:** `POST /api/sns/voice-rooms/:id/join`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Request Body:**
```json
{
  "join_as_speaker": false
}
```

**Fields:**
- `join_as_speaker` (optional): Request to join as speaker (default: false)
  - If `true` and speaker slots are available, joins as speaker
  - If `true` and speaker slots are full, returns error
  - If `false`, joins as listener

**Response:**
```json
{
  "success": true,
  "data": {
    "role": "listener",
    "livekit_token": "eyJhbGc...",
    "livekit_url": "wss://lemon.3chan.kr:7880"
  }
}
```

**Notes:**
- `livekit_token` is role-specific (speaker vs listener)
- Listener tokens have subscribe-only permissions
- Speaker tokens have publish permissions

---

### Leave Room
Leave a voice room.

**Endpoint:** `POST /api/sns/voice-rooms/:id/leave`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Response:**
```json
{
  "success": true,
  "message": "Left room"
}
```

**Notes:**
- If the host leaves, the room is automatically closed
- Automatically decrements `speaker_count` or `listener_count`

---

### Close Room (Host Only)
Close a voice room permanently.

**Endpoint:** `DELETE /api/sns/voice-rooms/:id`
**Authentication:** Required (must be host)

**Path Parameters:**
- `id` (required): Room ID

**Response:**
```json
{
  "success": true,
  "message": "Room closed"
}
```

**Effects:**
- All participants are disconnected
- All ephemeral messages are deleted
- Room status set to "closed"
- Cannot be reopened

---

### Toggle Mute
Toggle your own mute status.

**Endpoint:** `POST /api/sns/voice-rooms/:id/mute`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Request Body:**
```json
{
  "is_muted": true
}
```

**Response:**
```json
{
  "success": true,
  "is_muted": true
}
```

**Notes:**
- Mute status is tracked server-side for UI display
- Actual audio muting is handled by LiveKit client SDK

---

### Get Messages
Retrieve ephemeral chat messages for a room.

**Endpoint:** `GET /api/sns/voice-rooms/:id/messages`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Query Parameters:**
- `limit` (optional): Number of messages (default: 50, max: 100)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 123,
      "room_id": 1,
      "user": {
        "id": 456,
        "username": "user1",
        "display_name": "Bob"
      },
      "content": "Great room! Thanks for hosting!",
      "message_type": "text",
      "created_at": "2026-02-11T15:30:00Z"
    },
    {
      "id": 124,
      "room_id": 1,
      "content": "Alice joined the stage",
      "message_type": "system",
      "created_at": "2026-02-11T15:31:00Z"
    }
  ]
}
```

**Notes:**
- Messages are deleted when the room closes
- System messages (joins, leaves, stage changes) are auto-generated

---

### Send Message
Send a text message in the room chat.

**Endpoint:** `POST /api/sns/voice-rooms/:id/messages`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Request Body:**
```json
{
  "content": "Can someone explain the difference between 이/가 and 은/는?"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 125,
    "room_id": 1,
    "user": {
      "id": 789,
      "username": "user2",
      "display_name": "Charlie"
    },
    "content": "Can someone explain the difference between 이/가 and 은/는?",
    "message_type": "text",
    "created_at": "2026-02-11T15:35:00Z"
  }
}
```

---

## Stage Management

### Request Stage Access
Raise hand to request speaker access (listener only).

**Endpoint:** `POST /api/sns/voice-rooms/:id/request-stage`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Response:**
```json
{
  "success": true,
  "message": "Stage request sent"
}
```

**Notes:**
- Only listeners can request stage access
- Host sees request in the stage requests list
- Request is automatically cancelled if user leaves

---

### Cancel Stage Request
Cancel your own stage request.

**Endpoint:** `DELETE /api/sns/voice-rooms/:id/request-stage`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Response:**
```json
{
  "success": true,
  "message": "Stage request cancelled"
}
```

---

### Grant Stage Access (Host Only)
Approve a listener's request to join the stage.

**Endpoint:** `POST /api/sns/voice-rooms/:id/grant-stage`
**Authentication:** Required (must be host)

**Path Parameters:**
- `id` (required): Room ID

**Request Body:**
```json
{
  "user_id": 789
}
```

**Response:**
```json
{
  "success": true,
  "message": "User granted stage access",
  "new_livekit_token": "eyJhbGc..."
}
```

**Notes:**
- User's role changes from listener to speaker
- New LiveKit token with publish permissions is generated
- Client must reconnect to LiveKit with the new token
- Decrements `listener_count`, increments `speaker_count`

---

### Remove from Stage (Host Only)
Remove a speaker from the stage (demote to listener).

**Endpoint:** `POST /api/sns/voice-rooms/:id/remove-from-stage`
**Authentication:** Required (must be host)

**Path Parameters:**
- `id` (required): Room ID

**Request Body:**
```json
{
  "user_id": 456
}
```

**Response:**
```json
{
  "success": true,
  "message": "User removed from stage",
  "new_livekit_token": "eyJhbGc..."
}
```

**Notes:**
- Cannot remove the host
- User must reconnect to LiveKit with the new listener token
- Increments `listener_count`, decrements `speaker_count`

---

### Leave Stage
Voluntarily leave the stage (become a listener).

**Endpoint:** `POST /api/sns/voice-rooms/:id/leave-stage`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Room ID

**Response:**
```json
{
  "success": true,
  "message": "Left stage",
  "new_livekit_token": "eyJhbGc..."
}
```

**Notes:**
- Host cannot leave stage (must close room instead)
- Automatically disconnects from LiveKit and reconnects as listener

---

## Socket.IO Events

### Connection

Connect to Socket.IO with JWT authentication:

```javascript
const socket = io('wss://lemon.3chan.kr', {
  auth: {
    token: '<jwt_token>'
  }
});
```

---

### Client → Server Events

#### voice:join_room
Join a voice room's Socket.IO room (for receiving updates).

**Emit:**
```javascript
socket.emit('voice:join_room', {
  room_id: 1
});
```

**Notes:**
- Must be called after joining via REST API
- Enables receiving character positions, reactions, and gestures

---

#### voice:leave_room
Leave a voice room's Socket.IO room.

**Emit:**
```javascript
socket.emit('voice:leave_room', {
  room_id: 1
});
```

---

#### voice:send_message
Send a chat message via Socket.IO (alternative to REST).

**Emit:**
```javascript
socket.emit('voice:send_message', {
  room_id: 1,
  content: 'Hello everyone!'
});
```

**Notes:**
- Messages are persisted to database via REST endpoint
- This is for real-time relay only
- Prefer REST endpoint for reliable delivery

---

#### voice:character_position
Update your character's position on the stage (speakers only).

**Emit:**
```javascript
socket.emit('voice:character_position', {
  room_id: 1,
  x: 0.5,
  y: 0.7,
  direction: 'right'
});
```

**Fields:**
- `room_id` (required): Room ID
- `x` (required): Horizontal position (0.0 to 1.0, normalized)
- `y` (required): Vertical position (0.0 to 1.0, normalized)
- `direction` (required): Facing direction (`'left'` or `'right'`)

**Notes:**
- Send at 10Hz (every 100ms) when character is moving
- Server relays to all room participants
- Only speakers can update positions

---

#### voice:reaction
Send an emoji reaction (all participants can send).

**Emit:**
```javascript
socket.emit('voice:reaction', {
  room_id: 1,
  emoji: '👍'
});
```

**Notes:**
- Supports any Unicode emoji
- Reactions are ephemeral (not persisted)
- Displayed as floating animation over the sender's character

---

#### voice:gesture
Trigger a character gesture animation (speakers only).

**Emit:**
```javascript
socket.emit('voice:gesture', {
  room_id: 1,
  gesture: 'wave'
});
```

**Valid Gestures:**
- `wave`: Wave hand
- `bow`: Polite bow
- `dance`: Dance animation
- `jump`: Jump excitedly
- `clap`: Clapping hands

**Notes:**
- Only speakers can send gestures
- Animations are 1-2 seconds long
- Server validates gesture names

---

### Server → Client Events

#### voice:new_message
Receive a new chat message.

**Listen:**
```javascript
socket.on('voice:new_message', (message) => {
  console.log('New message:', message);
});
```

**Payload:**
```javascript
{
  room_id: 1,
  user_id: 456,
  name: 'Bob',
  content: 'Hello everyone!',
  message_type: 'text',
  created_at: '2026-02-11T16:00:00Z'
}
```

---

#### voice:character_position
Receive character position updates from other participants.

**Listen:**
```javascript
socket.on('voice:character_position', (position) => {
  updateCharacterPosition(position.user_id, position.x, position.y, position.direction);
});
```

**Payload:**
```javascript
{
  user_id: 456,
  x: 0.5,
  y: 0.7,
  direction: 'right'
}
```

**Notes:**
- Received at 10Hz from each moving speaker
- Client should interpolate smoothly to 60fps for animation

---

#### voice:reaction
Receive emoji reactions from participants.

**Listen:**
```javascript
socket.on('voice:reaction', (reaction) => {
  showReactionAnimation(reaction.user_id, reaction.emoji);
});
```

**Payload:**
```javascript
{
  user_id: 456,
  name: 'Bob',
  emoji: '❤️'
}
```

---

#### voice:gesture
Receive gesture animations from speakers.

**Listen:**
```javascript
socket.on('voice:gesture', (gesture) => {
  playGestureAnimation(gesture.user_id, gesture.gesture);
});
```

**Payload:**
```javascript
{
  user_id: 456,
  gesture: 'wave'
}
```

---

## LiveKit Connection

### Token Generation

LiveKit tokens are generated server-side and include:
- **Room name**: Unique identifier for the voice room
- **Participant identity**: User ID
- **Role**: `speaker` or `listener`
- **Permissions**: Based on role
- **Expiration**: 1 hour (3600 seconds)

**Example Token Payload:**
```json
{
  "sub": "123",
  "name": "Alice",
  "video": {
    "room": "voice_room_1",
    "roomJoin": true,
    "canPublish": true,
    "canSubscribe": true
  }
}
```

**Listener Token:**
- `canPublish`: false
- `canSubscribe`: true

**Speaker Token:**
- `canPublish`: true
- `canSubscribe`: true

---

### Client Connection (Flutter Example)

```dart
import 'package:livekit_client/livekit_client.dart';

// Connect to LiveKit room
final room = Room();

await room.connect(
  'wss://lemon.3chan.kr:7880',
  token, // From REST API response
);

// Enable microphone for speakers
if (role == 'speaker') {
  await room.localParticipant?.setMicrophoneEnabled(true);
}

// Listen to remote participants' audio
room.addListener(() {
  for (var participant in room.participants.values) {
    // Subscribe to audio tracks
    for (var track in participant.tracks.values) {
      if (track.source == TrackSource.microphone) {
        // Play audio from this participant
      }
    }
  }
});
```

---

### LiveKit Configuration

Configuration file: `/config/livekit/livekit.yaml`

**Key Settings:**
```yaml
port: 7880
bind_addresses:
  - "0.0.0.0"

rtc:
  port_range_start: 50000
  port_range_end: 50200
  use_external_ip: true
  udp_port: 7881

turn:
  enabled: false  # Disabled for performance

keys:
  <api_key>: <api_secret>
```

**Network Mode:** `host` (in docker-compose.yml)
- Exposes ports directly to the host network
- Required for UDP hole punching without TURN

---

## Character Positioning

### Coordinate System

- **Origin (0, 0)**: Top-left corner of the stage
- **Max (1, 1)**: Bottom-right corner of the stage
- **Normalized**: All positions are 0.0 to 1.0 (percentage of stage dimensions)

**Example Stage (800x600px canvas):**
- Position (0.5, 0.5) → rendered at (400px, 300px)
- Position (0.0, 0.0) → top-left corner
- Position (1.0, 1.0) → bottom-right corner

---

### Update Flow

1. **Client (Speaker):**
   - Detects character movement (touch/mouse drag)
   - Sends position update at 10Hz via Socket.IO
   - Immediately updates local character position (no lag)

2. **Server:**
   - Receives position update
   - Broadcasts to all room participants (excluding sender)
   - No server-side validation (trust client)

3. **Other Clients:**
   - Receive position update at ~10Hz
   - Interpolate smoothly to 60fps for animation
   - Update character sprite position on stage

---

### Interpolation Example (JavaScript)

```javascript
let targetPosition = { x: 0.5, y: 0.5 };
let currentPosition = { x: 0.5, y: 0.5 };

// Receive position update (10Hz)
socket.on('voice:character_position', (update) => {
  targetPosition = { x: update.x, y: update.y };
});

// Render loop (60fps)
function animationLoop() {
  // Smooth interpolation
  currentPosition.x += (targetPosition.x - currentPosition.x) * 0.3;
  currentPosition.y += (targetPosition.y - currentPosition.y) * 0.3;

  // Render character at currentPosition
  renderCharacter(currentPosition.x, currentPosition.y);

  requestAnimationFrame(animationLoop);
}
```

---

## Error Handling

### Common REST Errors

| Status Code | Error Message | Cause |
|-------------|---------------|-------|
| `400` | `Invalid request` | Missing required fields, invalid values |
| `401` | `Unauthorized` | Missing or invalid JWT token |
| `403` | `Forbidden` | Not the host (for host-only actions) |
| `404` | `Room not found` | Invalid room ID or closed room |
| `409` | `Room full` | Max speakers reached |
| `500` | `Internal server error` | Database or LiveKit token generation failure |

---

### LiveKit Connection Errors

**Token Expired:**
- Fetch a new token via REST API (rejoin endpoint)

**Connection Failed:**
- Check network connectivity
- Verify LiveKit server is running
- Ensure ports 7880, 7881, 50000-50200 are accessible

**Audio Not Working:**
- Check microphone permissions
- Verify speaker role (listeners cannot publish audio)
- Ensure LiveKit track is enabled

---

## Best Practices

### 1. Room Lifecycle
- Close rooms when the host leaves
- Auto-kick inactive participants after 10 minutes
- Clean up ephemeral messages on room closure

### 2. Stage Management
- Enforce speaker limits server-side
- Show "Raise Hand" button only for listeners
- Allow host to manage stage requests via UI

### 3. Character Positioning
- Send position updates only when moving (not idle)
- Implement client-side boundary checks (keep character on stage)
- Use smooth interpolation for 60fps animation

### 4. LiveKit Audio
- Request microphone permission before joining as speaker
- Mute by default when joining
- Show visual indicators for active speakers (waveform animation)

### 5. Error Handling
- Handle LiveKit disconnects gracefully (show reconnecting UI)
- Refresh tokens before expiration (e.g., at 50 minutes)
- Fall back to listener role if speaker promotion fails

---

## Related Documentation

- [SNS API](./SNS_API.md) - Social networking features
- [DM API](./DM_API.md) - Direct messaging
- [Character System API](./CHARACTER_SYSTEM_API.md) - Character customization for avatars
- [LiveKit Documentation](https://docs.livekit.io/) - Official LiveKit docs
