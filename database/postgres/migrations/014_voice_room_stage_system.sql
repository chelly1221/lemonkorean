-- Migration 014: Voice Room Stage/Audience System
-- Transforms voice rooms from simple group calls to stage-based experience
-- Stage (speakers) + Audience (listeners) + Text Chat + Raise Hand

BEGIN;

-- ============================================================
-- 1. Modify voice_rooms table: rename columns for stage system
-- ============================================================

-- Rename max_participants → max_speakers
ALTER TABLE voice_rooms RENAME COLUMN max_participants TO max_speakers;

-- Rename participant_count → speaker_count
ALTER TABLE voice_rooms RENAME COLUMN participant_count TO speaker_count;

-- Add listener_count
ALTER TABLE voice_rooms ADD COLUMN listener_count INTEGER NOT NULL DEFAULT 0;

-- ============================================================
-- 2. Modify voice_room_participants: add role column
-- ============================================================

-- Add role column (speaker or listener)
ALTER TABLE voice_room_participants
  ADD COLUMN role VARCHAR(10) NOT NULL DEFAULT 'listener'
  CHECK (role IN ('speaker', 'listener'));

-- Backfill existing active participants as speakers (they were all speakers before)
UPDATE voice_room_participants SET role = 'speaker' WHERE left_at IS NULL;

-- Add index for efficient role-based queries
CREATE INDEX idx_voice_room_participants_role
  ON voice_room_participants (room_id, role) WHERE left_at IS NULL;

-- ============================================================
-- 3. New table: voice_room_messages (ephemeral chat)
-- ============================================================

CREATE TABLE voice_room_messages (
  id SERIAL PRIMARY KEY,
  room_id INTEGER NOT NULL REFERENCES voice_rooms(id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  message_type VARCHAR(10) NOT NULL DEFAULT 'text' CHECK (message_type IN ('text', 'system')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_voice_room_messages_room_time
  ON voice_room_messages (room_id, created_at DESC);

-- ============================================================
-- 4. New table: voice_room_stage_requests (raise hand)
-- ============================================================

CREATE TABLE voice_room_stage_requests (
  id SERIAL PRIMARY KEY,
  room_id INTEGER NOT NULL REFERENCES voice_rooms(id) ON DELETE CASCADE,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(10) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'denied', 'cancelled')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ,
  UNIQUE(room_id, user_id)
);

COMMIT;
