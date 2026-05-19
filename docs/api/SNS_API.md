# SNS Service API

## Overview

The SNS Service provides social networking features including posts, comments, follows, blocks, reports, and user profiles. This service enables community interaction and content discovery for the Lemon Korean learning platform.

**Service Information:**
- **Base URL**: `https://lemon.3chan.kr/api/sns`
- **Port**: 3007
- **Technology**: Node.js (Express)
- **Authentication**: JWT required for most endpoints (some support optional auth)
- **Database**: PostgreSQL (social graph, posts, comments)
- **Rate Limiting**: 100 requests per 15 minutes per IP

**Last Updated**: 2026-03-11

---

## Authentication

All authenticated endpoints require a JWT token in the Authorization header:

```http
Authorization: Bearer <jwt_token>
```

**Optional Authentication**: Some endpoints support `optionalAuth` middleware, providing enhanced features for authenticated users (e.g., like status, follow status) while remaining accessible to guests.

---

## Table of Contents

1. [Posts](#posts)
2. [Comments](#comments)
3. [Follows](#follows)
4. [Blocks](#blocks)
5. [Reports](#reports)
6. [Profiles](#profiles)
7. [Error Handling](#error-handling)
8. [Moderation Rejection](#moderation-rejection)

---

## Posts

### Get Feed
Retrieve posts from followed users (personalized feed).

**Endpoint:** `GET /api/sns/posts/feed`
**Authentication:** Required
**Query Parameters:**
- `cursor` (optional): Cursor for pagination (ISO 8601 timestamp)
- `limit` (optional): Number of posts to retrieve (default: 20, max: 50)

**Response:**
```json
{
  "success": true,
  "posts": [
    {
      "id": 123,
      "author": {
        "id": 456,
        "username": "learner123",
        "display_name": "Alice",
        "profile_image_url": "https://..."
      },
      "content": "Just completed level 3! 🎉",
      "category": "achievement",
      "tags": ["level3", "milestone"],
      "visibility": "public",
      "image_urls": ["https://..."],
      "like_count": 15,
      "comment_count": 3,
      "is_liked": true,
      "created_at": "2026-02-11T10:30:00Z"
    }
  ],
  "pagination": {
    "hasMore": true,
    "nextCursor": "2026-02-11T09:00:00Z",
    "limit": 20
  }
}
```

---

### Get Discover Feed
Retrieve public posts for discovery (global feed with optional personalization).

**Endpoint:** `GET /api/sns/posts/discover`
**Authentication:** Optional
**Query Parameters:**
- `cursor` (optional): Cursor for pagination
- `limit` (optional): Number of posts (default: 20, max: 50)
- `category` (optional): Filter by category (`achievement`, `question`, `study_tip`, `general`)

**Response:**
```json
{
  "success": true,
  "posts": [
    {
      "id": 789,
      "author": {
        "id": 101,
        "username": "korean_master",
        "display_name": "Bob"
      },
      "content": "Tip: Practice hangul writing 15 minutes daily!",
      "category": "study_tip",
      "like_count": 42,
      "comment_count": 8,
      "is_liked": false,
      "created_at": "2026-02-11T12:00:00Z"
    }
  ],
  "pagination": {
    "hasMore": true,
    "nextCursor": "2026-02-11T11:00:00Z",
    "limit": 20
  }
}
```

---

### Get User Posts
Retrieve all posts by a specific user.

**Endpoint:** `GET /api/sns/posts/user/:userId`
**Authentication:** Optional
**Path Parameters:**
- `userId` (required): User ID

**Query Parameters:**
- `cursor` (optional): Cursor for pagination
- `limit` (optional): Number of posts (default: 20, max: 50)

**Response:** Same format as Discover Feed

---

### Get Single Post
Retrieve a single post by ID.

**Endpoint:** `GET /api/sns/posts/:id`
**Authentication:** Optional
**Path Parameters:**
- `id` (required): Post ID

**Response:**
```json
{
  "success": true,
  "post": {
    "id": 123,
    "author": { ... },
    "content": "...",
    "like_count": 15,
    "comment_count": 3,
    "is_liked": false,
    "created_at": "2026-02-11T10:30:00Z"
  }
}
```

---

### Create Post
Create a new post.

**Endpoint:** `POST /api/sns/posts`
**Authentication:** Required
**Request Body:**
```json
{
  "content": "Just finished my first Korean conversation! 😊",
  "category": "achievement",
  "tags": ["speaking", "milestone"],
  "visibility": "public",
  "image_urls": ["https://media.lemon.3chan.kr/..."]
}
```

**Fields:**
- `content` (required): Post text content (max 2000 characters)
- `category` (optional): One of `achievement`, `question`, `study_tip`, `general` (default: `general`)
- `tags` (optional): Array of tag strings (max 5 tags)
- `visibility` (optional): `public`, `followers`, or `private` (default: `public`)
- `image_urls` (optional): Array of media URLs (max 4 images, must be pre-uploaded via Media Service)

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Post created successfully",
  "post": {
    "id": 124,
    "author": { ... },
    "content": "Just finished my first Korean conversation! 😊",
    "category": "achievement",
    "like_count": 0,
    "comment_count": 0,
    "moderation_status": "allowed",
    "created_at": "2026-02-11T13:00:00Z"
  }
}
```

**Moderation:** Post content is automatically checked by the AI moderation service. The `moderation_status` field will be one of: `unmoderated`, `allowed`, `flagged`, or `rejected`. Rejected posts are not created and return HTTP 422 (see below).

**Error Codes:**
- `400`: Invalid request body (missing content, invalid category, content too long)
- `401`: Unauthorized (missing/invalid JWT)
- `422`: Content rejected by moderation (see [Moderation Rejection](#moderation-rejection))

---

### Delete Post
Delete a post (soft delete). Only the author can delete their own posts.

**Endpoint:** `DELETE /api/sns/posts/:id`
**Authentication:** Required
**Path Parameters:**
- `id` (required): Post ID

**Response:**
```json
{
  "success": true,
  "message": "Post deleted successfully"
}
```

**Error Codes:**
- `401`: Unauthorized
- `403`: Forbidden (not the author)
- `404`: Post not found

---

### Like Post
Like a post.

**Endpoint:** `POST /api/sns/posts/:id/like`
**Authentication:** Required
**Path Parameters:**
- `id` (required): Post ID

**Response:**
```json
{
  "success": true,
  "message": "Post liked successfully"
}
```

**Notes:**
- Idempotent: Liking an already-liked post returns success (no duplicate insert)
- Increments `like_count` only on new likes

---

### Unlike Post
Remove a like from a post.

**Endpoint:** `DELETE /api/sns/posts/:id/like`
**Authentication:** Required
**Path Parameters:**
- `id` (required): Post ID

**Response:**
```json
{
  "success": true,
  "message": "Post unliked successfully"
}
```

---

## Comments

### Get Comments for Post
Retrieve all comments for a specific post.

**Endpoint:** `GET /api/sns/comments/post/:postId`
**Authentication:** Optional
**Path Parameters:**
- `postId` (required): Post ID

**Query Parameters:**
- `cursor` (optional): Cursor for pagination
- `limit` (optional): Number of comments (default: 20, max: 50)

**Response:**
```json
{
  "success": true,
  "comments": [
    {
      "id": 501,
      "post_id": 123,
      "author": {
        "id": 789,
        "username": "commenter1",
        "display_name": "Charlie"
      },
      "content": "Congratulations! 축하해요!",
      "parent_id": null,
      "created_at": "2026-02-11T10:35:00Z"
    },
    {
      "id": 502,
      "post_id": 123,
      "author": { ... },
      "content": "Thank you!",
      "parent_id": 501,
      "created_at": "2026-02-11T10:40:00Z"
    }
  ],
  "pagination": {
    "hasMore": false,
    "nextCursor": null,
    "limit": 20
  }
}
```

**Notes:**
- Supports nested comments via `parent_id`
- Comments are ordered by `created_at` (oldest first)

---

### Create Comment
Add a comment to a post.

**Endpoint:** `POST /api/sns/comments/post/:postId`
**Authentication:** Required
**Path Parameters:**
- `postId` (required): Post ID

**Request Body:**
```json
{
  "content": "Great job! Keep it up!",
  "parent_id": null
}
```

**Fields:**
- `content` (required): Comment text (max 1000 characters)
- `parent_id` (optional): ID of parent comment for nested replies

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Comment created successfully",
  "comment": {
    "id": 503,
    "post_id": 123,
    "author": { ... },
    "content": "Great job! Keep it up!",
    "parent_id": null,
    "moderation_status": "allowed",
    "created_at": "2026-02-11T13:05:00Z"
  }
}
```

**Moderation:** Comment content is automatically checked by the AI moderation service. Rejected comments are not created and return HTTP 422 (see [Moderation Rejection](#moderation-rejection)).

---

### Delete Comment
Delete a comment (soft delete). Only the author can delete their own comments.

**Endpoint:** `DELETE /api/sns/comments/:id`
**Authentication:** Required
**Path Parameters:**
- `id` (required): Comment ID

**Response:**
```json
{
  "success": true,
  "message": "Comment deleted successfully"
}
```

---

## Follows

### Follow User
Follow another user.

**Endpoint:** `POST /api/sns/follows/:userId`
**Authentication:** Required
**Path Parameters:**
- `userId` (required): User ID to follow

**Response:**
```json
{
  "success": true,
  "message": "Followed successfully"
}
```

**Notes:**
- Idempotent: Following an already-followed user returns success
- Cannot follow yourself (returns `400`)
- Cannot follow blocked users (returns `403`)

---

### Unfollow User
Unfollow a user.

**Endpoint:** `DELETE /api/sns/follows/:userId`
**Authentication:** Required
**Path Parameters:**
- `userId` (required): User ID to unfollow

**Response:**
```json
{
  "success": true,
  "message": "Unfollowed successfully"
}
```

---

### Get Followers
Retrieve a user's followers.

**Endpoint:** `GET /api/sns/follows/:userId/followers`
**Authentication:** Optional
**Path Parameters:**
- `userId` (required): User ID

**Query Parameters:**
- `cursor` (optional): Cursor for pagination
- `limit` (optional): Number of users (default: 20, max: 50)

**Response:**
```json
{
  "success": true,
  "followers": [
    {
      "id": 101,
      "username": "follower1",
      "display_name": "Dave",
      "bio": "Learning Korean for K-pop",
      "follower_count": 25,
      "following_count": 50,
      "is_following": true,
      "is_followed_by": false
    }
  ],
  "pagination": {
    "hasMore": true,
    "nextCursor": 42,
    "limit": 20
  }
}
```

---

### Get Following
Retrieve users that a user is following.

**Endpoint:** `GET /api/sns/follows/:userId/following`
**Authentication:** Optional
**Path Parameters:**
- `userId` (required): User ID

**Query Parameters:** Same as Get Followers
**Response:** Same format as Get Followers

---

## Blocks

### Block User
Block a user (prevents all interaction).

**Endpoint:** `POST /api/sns/blocks/:userId`
**Authentication:** Required
**Path Parameters:**
- `userId` (required): User ID to block

**Response:**
```json
{
  "success": true,
  "message": "User blocked successfully"
}
```

**Effects:**
- Automatically unfollows both ways
- Blocked user cannot see your posts/comments
- You cannot see blocked user's content
- Prevents DMs and voice room interaction

---

### Unblock User
Unblock a user.

**Endpoint:** `DELETE /api/sns/blocks/:userId`
**Authentication:** Required
**Path Parameters:**
- `userId` (required): User ID to unblock

**Response:**
```json
{
  "success": true,
  "message": "User unblocked successfully"
}
```

---

## Reports

### Submit Report
Report a post, comment, or user for moderation.

**Endpoint:** `POST /api/sns/reports`
**Authentication:** Required
**Request Body:**
```json
{
  "target_type": "post",
  "target_id": 123,
  "reason": "spam"
}
```

**Fields:**
- `target_type` (required): One of `post`, `comment`, `user`
- `target_id` (required): ID of the target entity
- `reason` (required): Free-form text reason (max 1000 characters)

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Report submitted successfully",
  "report": {
    "id": 789,
    "reporter_id": 456,
    "target_type": "post",
    "target_id": 123,
    "reason": "spam",
    "created_at": "2026-02-11T13:00:00Z"
  }
}
```

**Notes:**
- Reports are reviewed by moderators via Admin Dashboard
- Duplicate reports from the same user are prevented (idempotent within 24 hours)

---

## Profiles

### Search Users
Search users by username or display name.

**Endpoint:** `GET /api/sns/profiles/search`
**Authentication:** Required
**Query Parameters:**
- `q` (required): Search query (min 2 characters)
- `limit` (optional): Number of results (default: 20, max: 50)

**Response:**
```json
{
  "success": true,
  "users": [
    {
      "id": 456,
      "username": "learner123",
      "display_name": "Alice",
      "bio": "Korean language enthusiast",
      "profile_image_url": "https://...",
      "follower_count": 120,
      "is_following": false
    }
  ],
  "count": 1
}
```

---

### Get Suggested Users
Get personalized user recommendations (users with similar learning patterns or popular users).

**Endpoint:** `GET /api/sns/profiles/suggested`
**Authentication:** Required
**Query Parameters:**
- `limit` (optional): Number of suggestions (default: 10, max: 30)

**Response:** Same format as Search Users

---

### Get User Profile
Retrieve a user's public profile.

**Endpoint:** `GET /api/sns/profiles/:userId`
**Authentication:** Optional
**Path Parameters:**
- `userId` (required): User ID

**Response:**
```json
{
  "success": true,
  "profile": {
    "id": 456,
    "username": "learner123",
    "display_name": "Alice",
    "bio": "Korean learner | Level 5 | Seoul 🇰🇷",
    "profile_image_url": "https://...",
    "level": 5,
    "total_lemons": 1250,
    "follower_count": 120,
    "following_count": 85,
    "post_count": 42,
    "is_following": true,
    "is_followed_by": false,
    "is_blocked": false,
    "joined_at": "2025-11-15T08:00:00Z"
  }
}
```

---

### Update Own Profile
Update the authenticated user's profile.

**Endpoint:** `PUT /api/sns/profiles`
**Authentication:** Required
**Request Body:**
```json
{
  "bio": "Learning Korean for travel and K-drama!"
}
```

**Fields:**
- `bio` (optional): User bio (max 500 characters)

**Response:**
```json
{
  "success": true,
  "message": "Profile updated successfully",
  "profile": {
    "id": 456,
    "username": "learner123",
    "bio": "Learning Korean for travel and K-drama!",
    "updated_at": "2026-02-11T13:10:00Z"
  }
}
```

**Moderation:** Bio content is automatically checked by the AI moderation service. Rejected bios return HTTP 422 (see [Moderation Rejection](#moderation-rejection)).

**Notes:**
- `username` and `display_name` are set during registration and cannot be changed via SNS API
- Profile image updates are handled via Auth Service

---

## Error Handling

### Standard Error Response Format

```json
{
  "error": "Error Category",
  "message": "Detailed error description"
}
```

### Common HTTP Status Codes

| Status Code | Meaning | Common Causes |
|-------------|---------|---------------|
| `400` | Bad Request | Missing required fields, invalid input format, validation errors |
| `401` | Unauthorized | Missing JWT token, expired token, invalid token |
| `403` | Forbidden | Insufficient permissions (e.g., not the author, blocked user) |
| `404` | Not Found | Post/comment/user does not exist or was deleted |
| `409` | Conflict | Duplicate action (e.g., already following, already liked) |
| `422` | Unprocessable Entity | Content rejected by AI moderation |
| `429` | Too Many Requests | Rate limit exceeded |
| `500` | Internal Server Error | Database error, unexpected server issue |

### Example Error Responses

**Missing JWT Token:**
```json
{
  "error": "Unauthorized",
  "message": "No token provided"
}
```

**Post Not Found:**
```json
{
  "error": "Not Found",
  "message": "Post not found"
}
```

**Blocked User Interaction:**
```json
{
  "error": "Forbidden",
  "message": "Cannot interact with this post"
}
```

---

## Moderation Rejection

When content (post, comment, or bio) is rejected by the AI moderation service, the API returns HTTP 422 with the following response format:

```json
{
  "error": "Content Rejected",
  "message": "Your content was flagged by our content moderation system",
  "moderation": {
    "action": "reject",
    "categories": {
      "toxic": 0.85,
      "severe_toxic": 0.12,
      "obscene": 0.43,
      "threat": 0.02,
      "insult": 0.72,
      "identity_hate": 0.08
    }
  }
}
```

The `categories` object contains per-category toxicity scores (0.0 to 1.0). Content is rejected when the highest score exceeds the reject threshold (default: 0.7).

If the moderation service is unavailable, content is created with `moderation_status: "unmoderated"` and proceeds normally.

---

## Rate Limiting

**Global Rate Limit**: 100 requests per 15 minutes per IP address

**Response Headers:**
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 87
X-RateLimit-Reset: 1707656400
```

**Rate Limit Exceeded Response:**
```json
{
  "error": "Too many requests. Please try again later.",
  "retry_after": 300
}
```

---

## Best Practices

1. **Pagination**: Always use cursor-based pagination for large result sets. Store the `next_cursor` value for the next request.

2. **Optional Auth**: For public endpoints with optional auth, always send the JWT token if available to get enhanced data (like status, follow status).

3. **Content Validation**: Validate content length client-side before submission to avoid `400` errors.

4. **Image Uploads**: Upload images to the Media Service first (port 3004), then include the returned URLs in post creation requests.

5. **Error Handling**: Always check for `error` field in responses and display user-friendly messages.

6. **Idempotency**: Like, follow, and block operations are idempotent - repeated calls return success without side effects.

---

## Related Documentation

- [DM API](./DM_API.md) - Direct messaging endpoints and Socket.IO events
- [Voice Rooms API](./VOICE_ROOMS_API.md) - Voice room stage/audience system
- [Auth API](./AUTH_API.md) - User authentication and registration
- [Media API](./MEDIA_API.md) - Media upload and serving
