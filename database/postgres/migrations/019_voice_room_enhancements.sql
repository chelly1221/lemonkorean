-- ================================================================
-- 019: Voice Room Enhancements
-- ================================================================
-- Adds room_type and duration columns to voice_rooms table
-- ================================================================

BEGIN;

-- Add room_type column with CHECK constraint
ALTER TABLE voice_rooms
  ADD COLUMN IF NOT EXISTS room_type VARCHAR(20) NOT NULL DEFAULT 'free_talk'
  CHECK (room_type IN ('free_talk', 'pronunciation', 'roleplay', 'qna', 'listening', 'debate'));

-- Add duration column (NULL = unlimited)
ALTER TABLE voice_rooms
  ADD COLUMN IF NOT EXISTS duration INTEGER;

COMMIT;
