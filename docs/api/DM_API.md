# Direct Messaging (DM) API

## Overview

The DM (Direct Messaging) API provides private one-on-one messaging between users with real-time delivery via Socket.IO. It supports text messages, image sharing, voice messages, typing indicators, read receipts, and online status tracking.

**Service Information:**
- **Base URL**: `https://lemon.3chan.kr/api/sns`
- **Socket.IO URL**: `wss://lemon.3chan.kr/socket.io`
- **Port**: 3007 (SNS Service)
- **Technology**: Node.js (Express + Socket.IO)
- **Authentication**: JWT required for all endpoints and Socket.IO connections
- **Database**: PostgreSQL (conversations, messages, read receipts)
- **Redis**: Online status tracking

**Last Updated**: 2026-03-11

---

## Architecture

The DM system uses a **hybrid REST + Socket.IO architecture**:

- **REST API**: Used for conversation management (list, create, mark read) and retrieving message history
- **Socket.IO**: Used for real-time message delivery, typing indicators, and online status
- **Redis**: Tracks online/offline user status for presence indicators
- **PostgreSQL**: Stores conversations, messages, and read receipts

**Message Flow:**
1. Client sends message via Socket.IO (`dm:send_message` event) or REST (`POST /api/sns/conversations/:id/messages`)
2. Server validates sender participation and checks block status
3. Message is saved to PostgreSQL
4. Server emits `dm:new_message` event to both participants via Socket.IO
5. Recipient's device shows real-time notification/message
6. Read receipts are tracked when recipient views the message

---

## Table of Contents

1. [REST Endpoints](#rest-endpoints)
2. [Socket.IO Events](#socketio-events)
3. [Connection Flow](#connection-flow)
4. [Message Types](#message-types)
5. [Error Handling](#error-handling)

---

## REST Endpoints

### Get Conversations
Retrieve all conversations for the authenticated user.

**Endpoint:** `GET /api/sns/conversations`
**Authentication:** Required

**Query Parameters:**
- `offset` (optional): Offset for pagination (default: 0)
- `limit` (optional): Conversations per page (default: 20, max: 50)

**Response:**
```json
{
  "conversations": [
    {
      "id": 123,
      "participant": {
        "id": 456,
        "username": "friend1",
        "display_name": "Alice",
        "profile_image_url": "https://...",
        "is_online": true
      },
      "last_message": {
        "id": 789,
        "sender_id": 456,
        "content": "See you tomorrow!",
        "message_type": "text",
        "created_at": "2026-02-11T14:30:00Z"
      },
      "unread_count": 2,
      "created_at": "2026-02-10T08:00:00Z",
      "updated_at": "2026-02-11T14:30:00Z"
    }
  ],
  "pagination": {
    "limit": 20,
    "offset": 0,
    "count": 1
  }
}
```

**Notes:**
- Conversations are sorted by `updated_at` (most recent first)
- `is_online` reflects real-time online status from Redis
- `unread_count` shows messages the user hasn't read

---

### Create Conversation
Start a new conversation with another user.

**Endpoint:** `POST /api/sns/conversations`
**Authentication:** Required

**Request Body:**
```json
{
  "user_id": 456
}
```

**Fields:**
- `user_id` (required): User ID of the other participant

**Response (201 Created):**
```json
{
  "conversation": {
    "id": 456,
    "participant": {
      "id": 456,
      "username": "friend1",
      "display_name": "Alice"
    },
    "created_at": "2026-02-11T15:00:00Z"
  }
}
```

**Error Codes:**
- `400`: Invalid user_id (missing or self)
- `403`: Cannot create conversation (blocked by or blocking the user)

**Notes:**
- Idempotent: If a conversation already exists, the existing one is returned (201)
- Blocked users cannot create conversations with each other

---

### Get Unread Count
Get the total number of unread messages across all conversations.

**Endpoint:** `GET /api/sns/conversations/unread-count`
**Authentication:** Required

**Response:**
```json
{
  "unread_count": 5
}
```

**Notes:**
- Used for displaying badge count on the DM icon in the app

---

### Mark Conversation as Read
Mark all messages in a conversation as read.

**Endpoint:** `POST /api/sns/conversations/:id/read`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Conversation ID

**Request Body:**
```json
{
  "message_id": 789
}
```

**Fields:**
- `message_id` (required): ID of the latest message to mark as read

**Response:**
```json
{
  "read_receipt": { ... }
}
```

**Notes:**
- Updates the `read_receipts` table for the conversation
- Emits `dm:read_receipt` Socket.IO event to the other participant

---

### Get Messages
Retrieve message history for a conversation.

**Endpoint:** `GET /api/sns/conversations/:id/messages`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Conversation ID

**Query Parameters:**
- `cursor` (optional): Get messages before this message ID (for pagination)
- `limit` (optional): Number of messages (default: 30, max: 50)

**Response:**
```json
{
  "messages": [
    {
      "id": 123,
      "conversation_id": 456,
      "sender": {
        "id": 789,
        "username": "me",
        "display_name": "Bob"
      },
      "message_type": "text",
      "content": "Hello! How's your Korean study going?",
      "created_at": "2026-02-11T14:00:00Z"
    },
    {
      "id": 124,
      "conversation_id": 456,
      "sender": {
        "id": 456,
        "username": "friend1",
        "display_name": "Alice"
      },
      "message_type": "text",
      "content": "Great! Just finished level 4!",
      "created_at": "2026-02-11T14:05:00Z"
    },
    {
      "id": 125,
      "conversation_id": 456,
      "sender": {
        "id": 456,
        "username": "friend1",
        "display_name": "Alice"
      },
      "message_type": "image",
      "media_url": "https://media.lemon.3chan.kr/dm/images/...",
      "media_metadata": {
        "width": 1920,
        "height": 1080,
        "size": 245678
      },
      "created_at": "2026-02-11T14:10:00Z"
    }
  ],
  "next_cursor": 120
}
```

**Notes:**
- Messages are ordered by `created_at` (newest first)
- Use `cursor` parameter (integer message ID) for infinite scroll pagination
- `next_cursor` is `null` when no more messages
- Message types: `text`, `image`, `voice` (voice messages)

---

### Send Message (REST)
Send a message via REST API (alternative to Socket.IO for offline scenarios).

**Endpoint:** `POST /api/sns/conversations/:id/messages`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Conversation ID

**Request Body:**
```json
{
  "message_type": "text",
  "content": "Hello!"
}
```

**Fields:**
- `message_type` (required): One of `text`, `image`, `voice`
- `content` (required for text): Message text (max 5000 characters)
- `media_url` (required for image/audio): URL of uploaded media file
- `media_metadata` (optional): Metadata object (dimensions, size, duration)

**Response (201 Created):**
```json
{
  "message": {
    "id": 789,
    "conversation_id": 456,
    "sender": { ... },
    "message_type": "text",
    "content": "Hello!",
    "created_at": "2026-02-11T15:30:00Z"
  }
}
```

**Notes:**
- For real-time messaging, prefer Socket.IO (`dm:send_message` event)
- REST endpoint is useful for background message sending or retry logic

---

### Upload Media for DM
Upload an image or audio file for use in DM messages.

**Endpoint:** `POST /api/sns/dm/upload`
**Authentication:** Required
**Content-Type:** `multipart/form-data`

**Form Data:**
- `file` (required): Image or audio file
  - Images: jpg, png, gif, webp (max 5MB)
  - Audio: m4a, mp3, wav, ogg (max 10MB, max 60 seconds)

**Response:**
```json
{
  "media_url": "/media/lemon-korean-media/dm-images/abc123.jpg",
  "media_metadata": {
    "file_size": 245678,
    "mime_type": "image/jpeg",
    "original_name": "photo.jpg"
  }
}
```

**Notes:**
- Upload media first, then use `media_url` in message send request
- Files are stored in MinIO with automatic cleanup for deleted messages
- Allowed image mimes: jpeg, png, gif, webp
- Allowed audio mimes: webm, ogg, mpeg, mp4, wav, aac

---

### Delete Message
Delete a message (soft delete, only sender can delete their own messages).

**Endpoint:** `DELETE /api/sns/messages/:id`
**Authentication:** Required

**Path Parameters:**
- `id` (required): Message ID

**Response:**
```json
{
  "success": true
}
```

**Notes:**
- Soft delete: Message is marked as deleted but not removed from database
- Deleted messages show as "[Message deleted]" to both participants
- Emits `dm:message_deleted` Socket.IO event to the other participant

---

## Socket.IO Events

### Connection

All Socket.IO connections require JWT authentication:

```javascript
const socket = io('wss://lemon.3chan.kr', {
  auth: {
    token: '<jwt_token>'
  }
});
```

The server automatically:
1. Validates the JWT token
2. Extracts `userId` and `userName` from the token
3. Joins the user to their personal room (`user:{userId}`)
4. Updates online status in Redis
5. Broadcasts `dm:user_online` to all connected clients

---

### Client → Server Events

#### dm:join_conversation
Join a conversation room to receive real-time messages.

**Emit:**
```javascript
socket.emit('dm:join_conversation', {
  conversation_id: 'conv_abc123'
});
```

**Notes:**
- Must join a conversation room before receiving messages for that conversation
- Server verifies that the user is a participant before allowing join

---

#### dm:leave_conversation
Leave a conversation room.

**Emit:**
```javascript
socket.emit('dm:leave_conversation', {
  conversation_id: 'conv_abc123'
});
```

---

#### dm:send_message
Send a message in real-time.

**Emit:**
```javascript
socket.emit('dm:send_message', {
  conversation_id: 'conv_abc123',
  message_type: 'text',
  content: 'Hey! What are you up to?',
  client_message_id: 'local_msg_123' // Optional: for optimistic UI updates
}, (response) => {
  if (response.error) {
    console.error('Send failed:', response.error);
  } else {
    console.log('Message sent:', response.message);
  }
});
```

**Fields:**
- `conversation_id` (required): Conversation ID
- `message_type` (required): `text`, `image`, or `voice`
- `content` (required for text): Message text
- `media_url` (required for image/audio): Pre-uploaded media URL
- `media_metadata` (optional): Metadata object
- `client_message_id` (optional): Client-generated ID for matching optimistic UI updates

**Acknowledgment Response:**
```javascript
{
  message: {
    id: 'msg_server_456',
    conversation_id: 'conv_abc123',
    sender: { ... },
    content: 'Hey! What are you up to?',
    created_at: '2026-02-11T16:00:00Z'
  },
  client_message_id: 'local_msg_123'
}
```

**Error Response:**
```javascript
{
  error: 'Not a participant'
}
```

**Notes:**
- Includes acknowledgment callback for delivery confirmation
- Server broadcasts `dm:new_message` to both participants

---

#### dm:typing_start
Notify the other participant that you're typing.

**Emit:**
```javascript
socket.emit('dm:typing_start', {
  conversation_id: 'conv_abc123'
});
```

**Notes:**
- Server relays as `dm:typing` event to the other participant
- Typically sent on first keystroke in the message input field

---

#### dm:typing_stop
Notify the other participant that you've stopped typing.

**Emit:**
```javascript
socket.emit('dm:typing_stop', {
  conversation_id: 'conv_abc123'
});
```

**Notes:**
- Sent when user clears the input field or sends the message
- Client should also auto-send after 3-5 seconds of inactivity

---

#### dm:mark_read
Mark a message as read (read receipt).

**Emit:**
```javascript
socket.emit('dm:mark_read', {
  conversation_id: 'conv_abc123',
  message_id: 'msg_latest_789'
});
```

**Notes:**
- `message_id` should be the latest message in the conversation
- Server updates `read_receipts` table
- Server emits `dm:read_receipt` to the other participant

---

### Server → Client Events

#### dm:new_message
Receive a new message in real-time.

**Listen:**
```javascript
socket.on('dm:new_message', (message) => {
  console.log('New message:', message);
  // Update UI, show notification, play sound
});
```

**Payload:**
```javascript
{
  id: 'msg_xyz123',
  conversation_id: 'conv_abc123',
  sender: {
    id: 456,
    username: 'friend1',
    display_name: 'Alice',
    profile_image_url: 'https://...'
  },
  message_type: 'text',
  content: 'Hi there!',
  created_at: '2026-02-11T16:05:00Z'
}
```

**Notes:**
- Emitted to all participants in the conversation room
- Also emitted to recipient's personal room (`user:{userId}`) for badge updates

---

#### dm:message_deleted
Notified when a message is deleted.

**Listen:**
```javascript
socket.on('dm:message_deleted', (data) => {
  console.log('Message deleted:', data.message_id);
  // Update UI to show "[Message deleted]"
});
```

**Payload:**
```javascript
{
  message_id: 'msg_deleted_456',
  conversation_id: 'conv_abc123'
}
```

---

#### dm:typing
Receive typing indicator from the other participant.

**Listen:**
```javascript
socket.on('dm:typing', (data) => {
  if (data.is_typing) {
    showTypingIndicator(data.user_id);
  } else {
    hideTypingIndicator(data.user_id);
  }
});
```

**Payload:**
```javascript
{
  conversation_id: 'conv_abc123',
  user_id: 456,
  is_typing: true
}
```

---

#### dm:read_receipt
Receive read receipt from the other participant.

**Listen:**
```javascript
socket.on('dm:read_receipt', (data) => {
  console.log(`User ${data.user_id} read up to message ${data.last_read_message_id}`);
  // Update UI to show "Read" status
});
```

**Payload:**
```javascript
{
  conversation_id: 'conv_abc123',
  user_id: 456,
  last_read_message_id: 'msg_latest_789'
}
```

---

#### dm:user_online / dm:user_offline
Receive online/offline status updates for other users.

**Listen:**
```javascript
socket.on('dm:user_online', (data) => {
  updateUserStatus(data.user_id, true);
});

socket.on('dm:user_offline', (data) => {
  updateUserStatus(data.user_id, false);
});
```

**Payload:**
```javascript
{
  user_id: 456
}
```

**Notes:**
- `dm:user_online` is broadcast when a user connects via Socket.IO
- `dm:user_offline` is broadcast when a user disconnects
- These are two separate events (not a single event with a boolean flag)

---

#### dm:conversation_updated
Receive conversation metadata updates (for badge counts).

**Listen:**
```javascript
socket.on('dm:conversation_updated', (data) => {
  updateConversationBadge(data.conversation_id);
});
```

**Payload:**
```javascript
{
  conversation_id: 'conv_abc123',
  last_message: {
    id: 'msg_latest',
    content: 'New message preview...',
    created_at: '2026-02-11T16:20:00Z'
  }
}
```

**Notes:**
- Emitted to recipient's personal room when a new message arrives
- Used for updating conversation list and badge count even when not viewing the conversation

---

## Connection Flow

### Full Connection Flow Diagram

```
1. Client connects with JWT token
   ↓
2. Server validates JWT
   ↓
3. Server joins user to personal room: user:{userId}
   ↓
4. Server sets online status in Redis
   ↓
5. Server broadcasts dm:user_online to all connected clients
   ↓
6. Client joins specific conversation rooms: dm:join_conversation
   ↓
7. Client sends/receives messages in real-time
   ↓
8. On disconnect: Server clears online status, broadcasts dm:user_offline
```

### Example Client Code (JavaScript)

```javascript
import io from 'socket.io-client';

// Connect with JWT
const socket = io('wss://lemon.3chan.kr', {
  auth: {
    token: localStorage.getItem('jwt_token')
  }
});

// Handle connection
socket.on('connect', () => {
  console.log('Connected to DM server');

  // Join active conversations
  activeConversations.forEach(convId => {
    socket.emit('dm:join_conversation', { conversation_id: convId });
  });
});

// Listen for new messages
socket.on('dm:new_message', (message) => {
  addMessageToUI(message);
  playNotificationSound();
});

// Listen for typing indicators
socket.on('dm:typing', (data) => {
  showTypingIndicator(data.conversation_id, data.user_id, data.is_typing);
});

// Listen for online status
socket.on('dm:user_online', (data) => {
  updateOnlineStatus(data.user_id, true);
});
socket.on('dm:user_offline', (data) => {
  updateOnlineStatus(data.user_id, false);
});

// Send a message
function sendMessage(conversationId, content) {
  socket.emit('dm:send_message', {
    conversation_id: conversationId,
    message_type: 'text',
    content: content
  }, (response) => {
    if (response.error) {
      showError(response.error);
    } else {
      console.log('Message sent:', response.message);
    }
  });
}

// Mark as read when viewing a conversation
function markAsRead(conversationId, lastMessageId) {
  socket.emit('dm:mark_read', {
    conversation_id: conversationId,
    message_id: lastMessageId
  });
}
```

---

## Message Types

### Text Message
Standard text-based message.

**Example:**
```json
{
  "message_type": "text",
  "content": "안녕하세요! How are you?"
}
```

**Constraints:**
- Max length: 5000 characters
- Supports Unicode (emoji, Korean, etc.)

---

### Image Message
Image attachment with metadata.

**Example:**
```json
{
  "message_type": "image",
  "media_url": "https://media.lemon.3chan.kr/dm/images/abc123.jpg",
  "media_metadata": {
    "width": 1920,
    "height": 1080,
    "size": 245678,
    "mime_type": "image/jpeg"
  }
}
```

**Supported Formats:** JPEG, PNG, GIF, WebP
**Max Size:** 5MB

---

### Voice Message
Voice recording attachment.

**Example:**
```json
{
  "message_type": "voice",
  "media_url": "https://media.lemon.3chan.kr/dm/audio/def456.m4a",
  "media_metadata": {
    "duration": 15.5,
    "size": 125000,
    "mime_type": "audio/m4a"
  }
}
```

**Supported Formats:** M4A, MP3, WAV, OGG
**Max Size:** 10MB
**Max Duration:** 60 seconds

---

## Error Handling

### Common Socket.IO Errors

**Not a participant:**
```javascript
{
  error: 'Not a participant'
}
```
- User tried to send a message to a conversation they're not part of

**Blocked user:**
```javascript
{
  error: 'Cannot message this user'
}
```
- User tried to message someone who has blocked them or whom they've blocked

**Failed to send message:**
```javascript
{
  error: 'Failed to send message'
}
```
- Generic error (database failure, network issue)

---

### Common REST Errors

| Status Code | Error Message | Cause |
|-------------|---------------|-------|
| `400` | `user_id is required` | Missing or invalid user ID |
| `401` | `unauthorized` | Missing or invalid JWT token |
| `403` | `Cannot message this user` | Blocked user or block exists |
| `404` | `Conversation not found` | Invalid conversation ID |
| `400` | `Message too long` | Message exceeds 5000 characters |
| `500` | `Internal server error` | Database or server issue |

---

## Best Practices

### 1. Connection Management
- Establish Socket.IO connection on app startup
- Reconnect automatically on disconnect
- Join conversation rooms when viewing a conversation
- Leave conversation rooms when navigating away

### 2. Optimistic UI Updates
- Use `client_message_id` to match sent messages with server acknowledgments
- Show messages immediately in the UI (with "sending" indicator)
- Update to "sent" status when acknowledgment is received
- Handle failures gracefully (show "failed to send" and retry button)

### 3. Typing Indicators
- Send `dm:typing_start` on first keystroke
- Send `dm:typing_stop` after 3-5 seconds of inactivity or on message send
- Clear typing indicator after 5 seconds client-side (in case stop event is lost)

### 4. Read Receipts
- Send `dm:mark_read` when user views a conversation
- Update `last_read_message_id` to the latest message
- Show "Read" status only for messages sent by the current user

### 5. Offline Handling
- Cache undelivered messages locally
- Retry sending via REST API when connection is restored
- Fetch missed messages on reconnect using REST endpoint with timestamp

### 6. Media Uploads
- Show upload progress UI
- Compress images client-side before upload
- Validate file size and duration before upload

---

## Related Documentation

- [SNS API](./SNS_API.md) - Social networking features (posts, follows, profiles)
- [Voice Rooms API](./VOICE_ROOMS_API.md) - Voice room stage/audience system
- [Auth API](./AUTH_API.md) - User authentication
- [Media API](./MEDIA_API.md) - Media upload and serving
