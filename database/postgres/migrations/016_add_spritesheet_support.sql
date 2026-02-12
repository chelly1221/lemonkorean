-- Migration 016: Fix voice room schema + add spritesheet support
-- Fixes multiple missing columns/tables that were referenced in code but never created in DB.

BEGIN;

-- 0. Fix voice_rooms table: rename columns to match code expectations
ALTER TABLE voice_rooms RENAME COLUMN max_participants TO max_speakers;
ALTER TABLE voice_rooms RENAME COLUMN participant_count TO speaker_count;
ALTER TABLE voice_rooms ADD COLUMN IF NOT EXISTS listener_count INTEGER NOT NULL DEFAULT 0;
ALTER TABLE voice_rooms DROP CONSTRAINT IF EXISTS voice_rooms_max_participants_check;
ALTER TABLE voice_rooms ADD CONSTRAINT voice_rooms_max_speakers_check
  CHECK (max_speakers >= 2 AND max_speakers <= 8);

-- 0a. Add missing 'role' column to voice_room_participants
ALTER TABLE voice_room_participants
  ADD COLUMN IF NOT EXISTS role VARCHAR(20) NOT NULL DEFAULT 'listener';

-- 0b. Create missing voice_room_stage_requests table
CREATE TABLE IF NOT EXISTS voice_room_stage_requests (
  id SERIAL PRIMARY KEY,
  room_id INTEGER NOT NULL REFERENCES voice_rooms(id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) NOT NULL DEFAULT 'pending',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  UNIQUE (room_id, user_id)
);

-- 0c. Create missing voice_room_messages table
CREATE TABLE IF NOT EXISTS voice_room_messages (
  id SERIAL PRIMARY KEY,
  room_id INTEGER NOT NULL REFERENCES voice_rooms(id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  message_type VARCHAR(20) NOT NULL DEFAULT 'text',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX IF NOT EXISTS idx_voice_room_messages_room ON voice_room_messages(room_id, created_at);

-- 1. Update asset_type CHECK constraint to allow 'spritesheet'
ALTER TABLE character_items DROP CONSTRAINT IF EXISTS character_items_asset_type_check;
ALTER TABLE character_items ADD CONSTRAINT character_items_asset_type_check
  CHECK (asset_type IN ('svg', 'png', 'spritesheet'));

-- 2. Update default items with spritesheet metadata (spritesheet_key + frame dimensions)

-- Body
UPDATE character_items SET
  metadata = COALESCE(metadata, '{}'::jsonb) ||
    '{"spritesheet_key": "assets/sprites/character/body/body_default.png", "frameWidth": 32, "frameHeight": 48, "frameColumns": 5, "frameRows": 4}'::jsonb
WHERE is_default = true AND category = 'body';

-- Hair
UPDATE character_items SET
  metadata = COALESCE(metadata, '{}'::jsonb) ||
    '{"spritesheet_key": "assets/sprites/character/hair/hair_short.png", "frameWidth": 32, "frameHeight": 48, "frameColumns": 5, "frameRows": 4}'::jsonb
WHERE is_default = true AND category = 'hair';

-- Eyes
UPDATE character_items SET
  metadata = COALESCE(metadata, '{}'::jsonb) ||
    '{"spritesheet_key": "assets/sprites/character/eyes/eyes_round.png", "frameWidth": 32, "frameHeight": 48, "frameColumns": 5, "frameRows": 4}'::jsonb
WHERE is_default = true AND category = 'eyes';

-- Eyebrows
UPDATE character_items SET
  metadata = COALESCE(metadata, '{}'::jsonb) ||
    '{"spritesheet_key": "assets/sprites/character/eyebrows/eyebrows_natural.png", "frameWidth": 32, "frameHeight": 48, "frameColumns": 5, "frameRows": 4}'::jsonb
WHERE is_default = true AND category = 'eyebrows';

-- Nose
UPDATE character_items SET
  metadata = COALESCE(metadata, '{}'::jsonb) ||
    '{"spritesheet_key": "assets/sprites/character/nose/nose_button.png", "frameWidth": 32, "frameHeight": 48, "frameColumns": 5, "frameRows": 4}'::jsonb
WHERE is_default = true AND category = 'nose';

-- Mouth
UPDATE character_items SET
  metadata = COALESCE(metadata, '{}'::jsonb) ||
    '{"spritesheet_key": "assets/sprites/character/mouth/mouth_smile.png", "frameWidth": 32, "frameHeight": 48, "frameColumns": 5, "frameRows": 4}'::jsonb
WHERE is_default = true AND category = 'mouth';

-- Top
UPDATE character_items SET
  metadata = COALESCE(metadata, '{}'::jsonb) ||
    '{"spritesheet_key": "assets/sprites/character/top/top_tshirt.png", "frameWidth": 32, "frameHeight": 48, "frameColumns": 5, "frameRows": 4}'::jsonb
WHERE is_default = true AND category = 'top';

COMMIT;
