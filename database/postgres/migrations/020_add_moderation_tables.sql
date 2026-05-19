-- ============================================================
-- 020: AI Content Moderation Tables
-- NPU-accelerated content moderation integration
-- ============================================================

-- Add moderation status to posts
ALTER TABLE sns_posts ADD COLUMN IF NOT EXISTS moderation_status VARCHAR(20) DEFAULT 'unmoderated'
    CHECK (moderation_status IN ('unmoderated', 'allowed', 'flagged', 'rejected'));
ALTER TABLE sns_posts ADD COLUMN IF NOT EXISTS moderation_categories JSONB;
ALTER TABLE sns_posts ADD COLUMN IF NOT EXISTS moderation_score REAL;

-- Add moderation status to comments
ALTER TABLE sns_comments ADD COLUMN IF NOT EXISTS moderation_status VARCHAR(20) DEFAULT 'unmoderated'
    CHECK (moderation_status IN ('unmoderated', 'allowed', 'flagged', 'rejected'));
ALTER TABLE sns_comments ADD COLUMN IF NOT EXISTS moderation_categories JSONB;
ALTER TABLE sns_comments ADD COLUMN IF NOT EXISTS moderation_score REAL;

-- Moderation logs: track every moderation decision
CREATE TABLE IF NOT EXISTS moderation_logs (
    id SERIAL PRIMARY KEY,
    content_type VARCHAR(20) NOT NULL CHECK (content_type IN ('post', 'comment', 'bio', 'dm')),
    content_id INTEGER,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    content_text TEXT,
    action VARCHAR(20) NOT NULL CHECK (action IN ('allow', 'flag', 'reject')),
    max_score REAL NOT NULL,
    categories JSONB NOT NULL,
    processing_time_ms REAL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Indexes for admin queries
CREATE INDEX IF NOT EXISTS idx_moderation_logs_user ON moderation_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_moderation_logs_action ON moderation_logs(action);
CREATE INDEX IF NOT EXISTS idx_moderation_logs_created ON moderation_logs(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_moderation_logs_content_type ON moderation_logs(content_type);

-- Index for finding flagged/rejected content
CREATE INDEX IF NOT EXISTS idx_sns_posts_moderation ON sns_posts(moderation_status) WHERE moderation_status IN ('flagged', 'rejected');
CREATE INDEX IF NOT EXISTS idx_sns_comments_moderation ON sns_comments(moderation_status) WHERE moderation_status IN ('flagged', 'rejected');
