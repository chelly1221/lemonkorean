-- ================================================================
-- 011: Direct Messaging Tables
-- ================================================================
-- Adds 1:1 DM support: conversations, messages, read receipts
-- ================================================================

BEGIN;

-- ================================================================
-- dm_conversations - conversation pairs (user1_id < user2_id normalization)
-- ================================================================
CREATE TABLE IF NOT EXISTS dm_conversations (
    id SERIAL PRIMARY KEY,
    user1_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    user2_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    last_message_id INTEGER,
    last_message_at TIMESTAMPTZ,
    last_message_preview TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT dm_conversations_user_pair UNIQUE (user1_id, user2_id),
    CONSTRAINT dm_conversations_user_order CHECK (user1_id < user2_id)
);

CREATE INDEX IF NOT EXISTS idx_dm_conversations_user1 ON dm_conversations(user1_id);
CREATE INDEX IF NOT EXISTS idx_dm_conversations_user2 ON dm_conversations(user2_id);
CREATE INDEX IF NOT EXISTS idx_dm_conversations_last_message ON dm_conversations(last_message_at DESC NULLS LAST);

-- ================================================================
-- dm_messages - individual messages
-- ================================================================
CREATE TABLE IF NOT EXISTS dm_messages (
    id SERIAL PRIMARY KEY,
    conversation_id INTEGER NOT NULL REFERENCES dm_conversations(id) ON DELETE CASCADE,
    sender_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message_type VARCHAR(10) NOT NULL DEFAULT 'text' CHECK (message_type IN ('text', 'image', 'voice')),
    content TEXT,
    media_url TEXT,
    media_metadata JSONB DEFAULT '{}',
    client_message_id UUID,
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT dm_messages_content_check CHECK (content IS NOT NULL OR media_url IS NOT NULL)
);

CREATE INDEX IF NOT EXISTS idx_dm_messages_conversation ON dm_messages(conversation_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_dm_messages_sender ON dm_messages(sender_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_dm_messages_client_id ON dm_messages(client_message_id) WHERE client_message_id IS NOT NULL;

-- Add FK for last_message_id after dm_messages table exists
ALTER TABLE dm_conversations
    ADD CONSTRAINT dm_conversations_last_message_fk
    FOREIGN KEY (last_message_id) REFERENCES dm_messages(id) ON DELETE SET NULL;

-- ================================================================
-- dm_read_receipts - read tracking per user per conversation
-- ================================================================
CREATE TABLE IF NOT EXISTS dm_read_receipts (
    id SERIAL PRIMARY KEY,
    conversation_id INTEGER NOT NULL REFERENCES dm_conversations(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    last_read_message_id INTEGER REFERENCES dm_messages(id) ON DELETE SET NULL,
    last_read_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT dm_read_receipts_unique UNIQUE (conversation_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_dm_read_receipts_user ON dm_read_receipts(user_id);

COMMIT;
