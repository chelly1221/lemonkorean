# Character Customization API

## Overview

The Character Customization API enables users to personalize their avatars and decorate their virtual rooms using items purchased with lemon currency. The system includes a shop, inventory management, character equipment, and room furniture placement. Character avatars are SVG-based with layered rendering and support for 16 item categories.

**Service Information:**
- **Progress Service Base URL**: `https://lemon.3chan.kr/api/progress`
- **Admin Service Base URL**: `https://lemon.3chan.kr/api/admin`
- **Ports**: 3003 (Progress), 3006 (Admin)
- **Technology**: Go (Progress Service), Node.js (Admin Service)
- **Authentication**: JWT required for all endpoints
- **Database**: PostgreSQL (character_items, user_characters, user_inventory, user_room_furniture)

**Last Updated**: 2026-02-11

---

## Architecture

### Item Categories (16 Types)

**Character Appearance (13 categories):**
- `body`: Base character body
- `skin_color`: Skin tone (hex color code, not an item)
- `hair`: Hairstyles
- `eyes`: Eye styles
- `eyebrows`: Eyebrow styles
- `nose`: Nose shapes
- `mouth`: Mouth expressions
- `top`: Upper clothing
- `bottom`: Lower clothing
- `shoes`: Footwear
- `hat`: Headwear
- `accessory`: Accessories (glasses, earrings, etc.)
- `pet`: Pet companions

**Room Decoration (3 categories):**
- `wallpaper`: Wall backgrounds
- `floor`: Floor textures
- `furniture`: Furniture items (chairs, tables, plants, etc.)

---

### SVG Rendering System

**Canvas Size:** 300x400 pixels (3:4 aspect ratio)

**Layer Stacking Order:**
```
Bottom → Top (render_order values)
0:   Background (wallpaper, floor)
10:  Body parts (body → 0)
20:  Eyes (eyes → 20)
25:  Eyebrows (eyebrows → 25)
30:  Nose (nose → 30)
35:  Mouth (mouth → 35)
40:  Hair (hair → 40)
50:  Clothing (top, bottom, shoes → 50-55)
60:  Hat (hat → 60)
70:  Accessory (accessory → 70)
80:  Pet (pet → 80)
```

**Skin Color Filtering:**
- `skin_color` is applied as a CSS filter or SVG fill override to the `body` layer
- Default: `#FFDBB4` (light peach)

**Asset Storage:**
- Path pattern: `assets/character/{category}/{name}.svg`
- Example: `assets/character/hair/hair_short.svg`
- Served via Media Service (port 3004)

---

## Table of Contents

1. [Progress Service Endpoints](#progress-service-endpoints) (User-facing)
2. [Admin Service Endpoints](#admin-service-endpoints) (Content management)
3. [Database Schema](#database-schema)
4. [Purchase Transaction Flow](#purchase-transaction-flow)
5. [Error Handling](#error-handling)

---

## Progress Service Endpoints

These endpoints are used by the Flutter app for user interactions.

### Get Character
Retrieve a user's equipped character items.

**Endpoint:** `GET /api/progress/character/:userId`
**Authentication:** Required (can view any user's character)

**Path Parameters:**
- `userId` (required): User ID

**Response:**
```json
{
  "equipped": {
    "body": 1,
    "hair": 2,
    "eyes": 4,
    "eyebrows": 7,
    "nose": 9,
    "mouth": 11,
    "top": 14,
    "bottom": 16,
    "shoes": 18,
    "hat": 20,
    "accessory": 22,
    "pet": 24,
    "wallpaper": 26,
    "floor": 28
  },
  "skin_color": "#FFDBB4"
}
```

**Notes:**
- Returns item IDs for each category
- If a category is not equipped, it's omitted from the `equipped` object
- Default response for new users: `{ "equipped": {}, "skin_color": "#FFDBB4" }`

---

### Equip Item
Equip an item to a specific category.

**Endpoint:** `PUT /api/progress/character/equip`
**Authentication:** Required

**Request Body:**
```json
{
  "category": "hair",
  "item_id": 3
}
```

**Fields:**
- `category` (required): One of the 14 item categories (not `skin_color`)
- `item_id` (required): Item ID from `character_items` table

**Response:**
```json
{
  "success": true,
  "category": "hair",
  "item_id": 3
}
```

**Error Codes:**
- `400`: Invalid category or missing fields
- `403`: Item not owned (not in user_inventory)
- `404`: Item not found

**Notes:**
- User must own the item (must be in `user_inventory`)
- Overwrites previously equipped item in that category
- Upserts `user_characters` record (creates if doesn't exist)

---

### Update Skin Color
Change the character's skin color.

**Endpoint:** `PUT /api/progress/character/skin-color`
**Authentication:** Required

**Request Body:**
```json
{
  "skin_color": "#8D5524"
}
```

**Fields:**
- `skin_color` (required): Hex color code (e.g., `#FFDBB4`, `#8D5524`, `#F1C27D`)

**Response:**
```json
{
  "success": true,
  "skin_color": "#8D5524"
}
```

**Notes:**
- Skin color is free to change (no purchase required)
- Common values: `#FFDBB4` (light), `#F1C27D` (medium), `#8D5524` (dark)

---

### Get Inventory
Retrieve all items owned by a user.

**Endpoint:** `GET /api/progress/inventory/:userId`
**Authentication:** Required (can view any user's inventory)

**Path Parameters:**
- `userId` (required): User ID

**Response:**
```json
{
  "items": [
    {
      "id": 1,
      "category": "body",
      "name": "Default Body",
      "asset_key": "assets/character/body/body_default.svg",
      "asset_type": "svg",
      "is_bundled": true,
      "render_order": 0,
      "price": 0,
      "rarity": "common",
      "is_default": true,
      "acquired_at": "2026-01-15T10:00:00Z"
    },
    {
      "id": 2,
      "category": "hair",
      "name": "Short Hair",
      "asset_key": "assets/character/hair/hair_short.svg",
      "asset_type": "svg",
      "is_bundled": true,
      "render_order": 40,
      "price": 0,
      "rarity": "common",
      "is_default": true,
      "acquired_at": "2026-01-15T10:00:00Z"
    },
    {
      "id": 15,
      "category": "top",
      "name": "Hoodie",
      "asset_key": "assets/character/top/top_hoodie.svg",
      "asset_type": "svg",
      "is_bundled": true,
      "render_order": 50,
      "price": 10,
      "rarity": "common",
      "is_default": false,
      "acquired_at": "2026-02-10T14:30:00Z"
    }
  ]
}
```

**Notes:**
- Includes default/bundled items automatically added on first access
- Sorted by category and render_order

---

### Purchase Item
Buy an item from the shop using lemon currency.

**Endpoint:** `POST /api/progress/shop/purchase`
**Authentication:** Required

**Request Body:**
```json
{
  "item_id": 15
}
```

**Response:**
```json
{
  "success": true,
  "item_id": 15,
  "price": 10,
  "remaining_lemons": 1240
}
```

**Error Codes:**
- `400`: Invalid item_id, insufficient lemons, or item not available
- `404`: Item not found
- `409`: Item already owned

**Notes:**
- **Race condition safe**: Uses database transaction with row-level locks (`SELECT ... FOR UPDATE`)
- Checks ownership first to prevent duplicate purchases
- Deducts lemons and adds item to inventory atomically
- Records transaction in `lemon_transactions` table

**Race Condition Protection:**
```sql
BEGIN TRANSACTION;
-- Check ownership
SELECT COUNT(*) FROM user_inventory WHERE user_id = ? AND item_id = ?;
-- Lock lemon balance row
SELECT total_lemons FROM lemon_currency WHERE user_id = ? FOR UPDATE;
-- Deduct lemons
UPDATE lemon_currency SET total_lemons = total_lemons - ? WHERE user_id = ?;
-- Add to inventory
INSERT INTO user_inventory (user_id, item_id) VALUES (?, ?);
COMMIT;
```

---

### Get Shop Items
Browse available items for purchase.

**Endpoint:** `GET /api/progress/shop/items`
**Authentication:** Required

**Query Parameters:**
- `category` (optional): Filter by category (e.g., `hair`, `top`)

**Response:**
```json
{
  "items": [
    {
      "id": 15,
      "category": "top",
      "name": "Hoodie",
      "asset_key": "assets/character/top/top_hoodie.svg",
      "asset_type": "svg",
      "is_bundled": true,
      "render_order": 50,
      "price": 10,
      "rarity": "common",
      "is_default": false
    },
    {
      "id": 16,
      "category": "bottom",
      "name": "Shorts",
      "asset_key": "assets/character/bottom/bottom_shorts.svg",
      "asset_type": "svg",
      "is_bundled": true,
      "render_order": 55,
      "price": 10,
      "rarity": "common",
      "is_default": false
    }
  ]
}
```

**Notes:**
- Only returns active items (`is_active = true`)
- Sorted by category, price, and render_order
- Does not filter by ownership (client should check against inventory)

---

### Get Room
Retrieve a user's room furniture layout.

**Endpoint:** `GET /api/progress/room/:userId`
**Authentication:** Required (can view any user's room)

**Path Parameters:**
- `userId` (required): User ID

**Response:**
```json
{
  "furniture": [
    {
      "id": 1,
      "item_id": 30,
      "name": "Wooden Chair",
      "asset_key": "assets/character/furniture/chair_wood.svg",
      "asset_type": "svg",
      "position_x": 0.3,
      "position_y": 0.6
    },
    {
      "id": 2,
      "item_id": 31,
      "name": "Plant Pot",
      "asset_key": "assets/character/furniture/plant_pot.svg",
      "asset_type": "svg",
      "position_x": 0.8,
      "position_y": 0.2
    }
  ]
}
```

**Notes:**
- Positions are normalized (0.0 to 1.0) relative to room dimensions
- Empty array if no furniture placed

---

### Update Room Furniture
Replace all furniture in a user's room.

**Endpoint:** `PUT /api/progress/room/furniture`
**Authentication:** Required

**Request Body:**
```json
{
  "furniture": [
    {
      "item_id": 30,
      "position_x": 0.3,
      "position_y": 0.6
    },
    {
      "item_id": 31,
      "position_x": 0.8,
      "position_y": 0.2
    }
  ]
}
```

**Fields:**
- `furniture` (required): Array of furniture placements
  - `item_id` (required): Item ID from inventory
  - `position_x` (required): Horizontal position (0.0 to 1.0)
  - `position_y` (required): Vertical position (0.0 to 1.0)

**Response:**
```json
{
  "success": true,
  "count": 2
}
```

**Notes:**
- **Replaces all furniture** (deletes existing, inserts new)
- All items must be owned by the user
- Positions are ratio-based (works across different screen sizes)
- Use transaction for atomicity

---

## Admin Service Endpoints

These endpoints are used by the Admin Dashboard for content management.

### Get Character Items (Paginated)
Retrieve character items with filters.

**Endpoint:** `GET /api/admin/character-items`
**Authentication:** Required (admin only)

**Query Parameters:**
- `page` (optional): Page number (default: 1)
- `limit` (optional): Items per page (default: 50, max: 100)
- `category` (optional): Filter by category
- `rarity` (optional): Filter by rarity (`common`, `rare`, `epic`, `legendary`)
- `is_active` (optional): Filter by active status (`true` or `false`)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "category": "body",
      "name": "Default Body",
      "description": "Standard character body",
      "asset_key": "assets/character/body/body_default.svg",
      "asset_type": "svg",
      "is_bundled": true,
      "render_order": 0,
      "price": 0,
      "rarity": "common",
      "is_default": true,
      "is_active": true,
      "metadata": {},
      "created_at": "2026-02-11T00:00:00Z",
      "updated_at": "2026-02-11T00:00:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 50,
    "total": 22,
    "totalPages": 1
  }
}
```

---

### Get Single Item
Retrieve a specific character item by ID.

**Endpoint:** `GET /api/admin/character-items/:id`
**Authentication:** Required (admin only)

**Path Parameters:**
- `id` (required): Item ID

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 15,
    "category": "top",
    "name": "Hoodie",
    "description": "Cozy pullover hoodie",
    "asset_key": "assets/character/top/top_hoodie.svg",
    "asset_type": "svg",
    "is_bundled": true,
    "render_order": 50,
    "price": 10,
    "rarity": "common",
    "is_default": false,
    "is_active": true,
    "metadata": { "tags": ["winter", "casual"] },
    "created_at": "2026-02-11T00:00:00Z",
    "updated_at": "2026-02-11T00:00:00Z"
  }
}
```

---

### Create Item
Create a new character item.

**Endpoint:** `POST /api/admin/character-items`
**Authentication:** Required (admin only)

**Request Body:**
```json
{
  "category": "hair",
  "name": "Ponytail",
  "description": "Long ponytail hairstyle",
  "asset_key": "assets/character/hair/hair_ponytail.svg",
  "asset_type": "svg",
  "is_bundled": true,
  "render_order": 40,
  "price": 15,
  "rarity": "rare",
  "is_default": false,
  "metadata": { "tags": ["feminine", "long"] }
}
```

**Fields:**
- `category` (required): Item category
- `name` (required): Item display name
- `description` (optional): Item description
- `asset_key` (required): Path to SVG/PNG asset
- `asset_type` (optional): `svg` or `png` (default: `svg`)
- `is_bundled` (optional): Bundled with app (default: false)
- `render_order` (optional): Stacking order (default: 0)
- `price` (optional): Lemon price (default: 0)
- `rarity` (optional): Rarity tier (default: `common`)
- `is_default` (optional): Default item for category (default: false)
- `metadata` (optional): JSON metadata (default: `{}`)

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 32,
    "category": "hair",
    "name": "Ponytail",
    ...
  }
}
```

---

### Update Item
Update an existing character item.

**Endpoint:** `PUT /api/admin/character-items/:id`
**Authentication:** Required (admin only)

**Path Parameters:**
- `id` (required): Item ID

**Request Body:** (all fields optional)
```json
{
  "name": "Ponytail (Updated)",
  "price": 20,
  "is_active": true
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 32,
    "name": "Ponytail (Updated)",
    "price": 20,
    ...
  }
}
```

---

### Delete Item (Soft Delete)
Deactivate a character item.

**Endpoint:** `DELETE /api/admin/character-items/:id`
**Authentication:** Required (admin only)

**Path Parameters:**
- `id` (required): Item ID

**Response:**
```json
{
  "success": true,
  "message": "Item deactivated"
}
```

**Notes:**
- Soft delete: Sets `is_active = false`
- Item remains in database and user inventories
- Hidden from shop and new acquisitions

---

### Upload Asset
Get an asset key pattern for uploading files.

**Endpoint:** `POST /api/admin/character-items/upload-asset`
**Authentication:** Required (admin only)

**Request Body:**
```json
{
  "category": "hair",
  "filename": "hair_ponytail.svg"
}
```

**Response:**
```json
{
  "success": true,
  "asset_key": "character-items/hair/hair_ponytail.svg",
  "message": "Upload the file to the media service with this key"
}
```

**Notes:**
- Returns the asset key pattern for use in item creation
- Actual file upload is handled by Media Service (port 3004)
- Admin dashboard should upload the file first, then use the returned `asset_key` when creating the item

---

### Get Category Statistics
Get item count statistics by category.

**Endpoint:** `GET /api/admin/character-items/stats`
**Authentication:** Required (admin only)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "category": "body",
      "count": 1,
      "active_count": 1,
      "default_count": 1
    },
    {
      "category": "hair",
      "count": 3,
      "active_count": 3,
      "default_count": 1
    },
    {
      "category": "top",
      "count": 2,
      "active_count": 2,
      "default_count": 1
    }
  ]
}
```

---

## Database Schema

### character_items
Item catalog managed by admins.

**Columns:**
- `id`: Serial primary key
- `category`: VARCHAR(30), one of 16 categories
- `name`: VARCHAR(100), display name
- `description`: TEXT, optional description
- `asset_key`: VARCHAR(200), path to asset file
- `asset_type`: VARCHAR(10), `svg` or `png`
- `is_bundled`: BOOLEAN, bundled with app
- `render_order`: INTEGER, stacking order (0-100)
- `price`: INTEGER, lemon currency price
- `rarity`: VARCHAR(20), `common`, `rare`, `epic`, `legendary`
- `is_default`: BOOLEAN, default item for category
- `is_active`: BOOLEAN, available for purchase
- `metadata`: JSONB, arbitrary metadata
- `created_at`: TIMESTAMPTZ
- `updated_at`: TIMESTAMPTZ

**Indexes:**
- `idx_character_items_category` on `category`
- `idx_character_items_active` on `is_active` where `is_active = true`

---

### user_characters
Equipped items per user.

**Columns:**
- `user_id`: INTEGER PRIMARY KEY, references `users(id)`
- `body_item_id`: INTEGER, references `character_items(id)`
- `skin_color`: VARCHAR(7), hex color code (default: `#FFDBB4`)
- `hair_item_id`: INTEGER
- `eyes_item_id`: INTEGER
- `eyebrows_item_id`: INTEGER
- `nose_item_id`: INTEGER
- `mouth_item_id`: INTEGER
- `top_item_id`: INTEGER
- `bottom_item_id`: INTEGER
- `shoes_item_id`: INTEGER
- `hat_item_id`: INTEGER
- `accessory_item_id`: INTEGER
- `pet_item_id`: INTEGER
- `wallpaper_item_id`: INTEGER
- `floor_item_id`: INTEGER
- `updated_at`: TIMESTAMPTZ

**Notes:**
- One row per user
- All item columns are nullable (user may not have equipped items)

---

### user_inventory
Items owned by users.

**Columns:**
- `id`: Serial primary key
- `user_id`: INTEGER, references `users(id)`
- `item_id`: INTEGER, references `character_items(id)`
- `acquired_at`: TIMESTAMPTZ

**Constraints:**
- `UNIQUE(user_id, item_id)` - prevents duplicate ownership

**Indexes:**
- `idx_user_inventory_user` on `user_id`

---

### user_room_furniture
Furniture placements in user rooms.

**Columns:**
- `id`: Serial primary key
- `user_id`: INTEGER, references `users(id)`
- `item_id`: INTEGER, references `character_items(id)`
- `position_x`: REAL, horizontal position (0.0 to 1.0)
- `position_y`: REAL, vertical position (0.0 to 1.0)
- `created_at`: TIMESTAMPTZ

**Indexes:**
- `idx_user_room_furniture_user` on `user_id`

**Notes:**
- Multiple furniture items per user
- Positions are normalized ratios for responsive layouts

---

## Purchase Transaction Flow

### Step-by-Step Flow

1. **Client Request:**
   ```
   POST /api/progress/shop/purchase
   { "item_id": 15 }
   ```

2. **Server Validation:**
   - Verify JWT authentication
   - Start database transaction

3. **Ownership Check:**
   ```sql
   SELECT COUNT(*) FROM user_inventory
   WHERE user_id = 123 AND item_id = 15;
   ```
   - If count > 0, return `409 Conflict` (already owned)

4. **Item Validation:**
   ```sql
   SELECT price, is_active FROM character_items WHERE id = 15;
   ```
   - If not found, return `404 Not Found`
   - If `is_active = false`, return `400 Bad Request` (not available)

5. **Balance Check with Lock:**
   ```sql
   SELECT total_lemons FROM lemon_currency
   WHERE user_id = 123 FOR UPDATE;
   ```
   - Row-level lock prevents concurrent modifications
   - If balance < price, return `400 Bad Request` (insufficient lemons)

6. **Deduct Lemons:**
   ```sql
   UPDATE lemon_currency
   SET total_lemons = total_lemons - 10, updated_at = NOW()
   WHERE user_id = 123;
   ```

7. **Record Transaction:**
   ```sql
   INSERT INTO lemon_transactions
   (user_id, amount, type, source_id)
   VALUES (123, -10, 'purchase', 15);
   ```

8. **Add to Inventory:**
   ```sql
   INSERT INTO user_inventory (user_id, item_id)
   VALUES (123, 15);
   ```

9. **Commit Transaction:**
   - All steps succeed → COMMIT
   - Any step fails → ROLLBACK

10. **Response:**
    ```json
    {
      "success": true,
      "item_id": 15,
      "price": 10,
      "remaining_lemons": 1240
    }
    ```

---

### Race Condition Protection

**Scenario:** Two simultaneous purchase requests for the same item

**Without Lock (UNSAFE):**
```
Request A                        Request B
─────────────────────────────────────────────
Check ownership (not owned)
                                 Check ownership (not owned)
Check balance (1250 lemons)
                                 Check balance (1250 lemons)
Deduct 10 lemons (1240)
                                 Deduct 10 lemons (1230) ❌ WRONG!
Add to inventory
                                 Add to inventory ❌ DUPLICATE!
```

**With Lock (SAFE):**
```
Request A                        Request B
─────────────────────────────────────────────
Check ownership (not owned)
                                 Check ownership (not owned)
Lock balance row (FOR UPDATE)
Deduct 10 lemons (1240)
Add to inventory
Commit (releases lock)
                                 Lock balance row (waits...)
                                 Check ownership (now owned)
                                 Return 409 Conflict ✅
```

---

## Error Handling

### Common Error Codes

| Status Code | Error Message | Cause |
|-------------|---------------|-------|
| `400` | `Invalid category` | Category not in allowed list |
| `400` | `Invalid request` | Missing required fields |
| `400` | `Insufficient lemons` | Not enough lemon currency |
| `400` | `Item not available` | Item is deactivated (`is_active = false`) |
| `401` | `Unauthorized` | Missing or invalid JWT token |
| `403` | `Item not owned` | User doesn't own the item (for equip) |
| `404` | `Item not found` | Invalid item_id |
| `409` | `Item already owned` | Duplicate purchase attempt |
| `500` | `Internal server error` | Database or transaction failure |

---

### Example Error Responses

**Insufficient Lemons:**
```json
{
  "error": "insufficient lemons",
  "total_lemons": 5,
  "required": 10
}
```

**Item Not Owned:**
```json
{
  "error": "item not owned"
}
```

**Item Already Owned:**
```json
{
  "error": "item already owned"
}
```

---

## Best Practices

### 1. Frontend Item Display
- Fetch shop items and user inventory in parallel
- Mark owned items in shop UI (disable purchase button)
- Show lemon price and rarity badges

### 2. Character Rendering
- Load all equipped items' SVG assets
- Render in order of `render_order` (bottom to top)
- Apply `skin_color` filter to body layer
- Cache rendered character for performance

### 3. Purchase Flow
- Show confirmation dialog with item preview
- Display lemon balance before/after purchase
- Handle errors gracefully (show user-friendly messages)
- Refresh inventory after successful purchase

### 4. Room Editing
- Use drag-and-drop for furniture placement
- Save positions as normalized coordinates (0.0 to 1.0)
- Show grid or snap-to-grid for alignment
- Validate ownership before saving

### 5. Admin Content Management
- Upload asset file first (via Media Service)
- Use returned `asset_key` when creating item
- Preview rendered item before publishing
- Set appropriate `render_order` for layering

---

## Related Documentation

- [Progress API](./PROGRESS_API.md) - Gamification and progress tracking
- [Media API](./MEDIA_API.md) - Asset upload and serving
- [SNS API](./SNS_API.md) - Social features where characters are displayed
- [Voice Rooms API](./VOICE_ROOMS_API.md) - Live voice rooms with character avatars
