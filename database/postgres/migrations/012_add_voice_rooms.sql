-- ================================================================
-- 012: Voice Chat Rooms Tables
-- ================================================================
-- Adds voice chat rooms with LiveKit integration (max 4 participants)
-- ================================================================

BEGIN;

-- ================================================================
-- voice_rooms - voice chat room sessions
-- ================================================================
CREATE TABLE IF NOT EXISTS voice_rooms (
    id SERIAL PRIMARY KEY,
    creator_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(100) NOT NULL,
    topic VARCHAR(200),
    language_level VARCHAR(20) DEFAULT 'all' CHECK (language_level IN ('beginner', 'intermediate', 'advanced', 'all')),
    max_participants INTEGER NOT NULL DEFAULT 4 CHECK (max_participants BETWEEN 2 AND 4),
    livekit_room_name VARCHAR(100) NOT NULL UNIQUE,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'closed')),
    participant_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    closed_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_voice_rooms_status ON voice_rooms(status, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_voice_rooms_creator ON voice_rooms(creator_id);

-- ================================================================
-- voice_room_participants - current and past participants
-- ================================================================
CREATE TABLE IF NOT EXISTS voice_room_participants (
    id SERIAL PRIMARY KEY,
    room_id INTEGER NOT NULL REFERENCES voice_rooms(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    is_muted BOOLEAN NOT NULL DEFAULT FALSE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    left_at TIMESTAMPTZ
);

CREATE INDEX IF NOT EXISTS idx_voice_room_participants_room ON voice_room_participants(room_id);
CREATE INDEX IF NOT EXISTS idx_voice_room_participants_user ON voice_room_participants(user_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_voice_room_active_participant
    ON voice_room_participants(room_id, user_id) WHERE left_at IS NULL;

COMMIT;
