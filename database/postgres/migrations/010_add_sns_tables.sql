-- ================================================================
-- SNS TABLES - Phase 1: Feed + Friend Search
-- ================================================================
-- Migration: 010_add_sns_tables.sql
-- Date: 2026-02-10
-- Description: Add SNS functionality tables for community features
-- ================================================================

BEGIN;

-- ================================================================
-- 1. EXTEND USERS TABLE
-- ================================================================

ALTER TABLE users ADD COLUMN IF NOT EXISTS bio TEXT;
ALTER TABLE users ADD COLUMN IF NOT EXISTS follower_count INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS following_count INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS post_count INTEGER DEFAULT 0;
ALTER TABLE users ADD COLUMN IF NOT EXISTS is_public BOOLEAN DEFAULT true;
ALTER TABLE users ADD COLUMN IF NOT EXISTS sns_banned BOOLEAN DEFAULT false;

-- ================================================================
-- 2. USER FOLLOWS (1-directional, Instagram model)
-- ================================================================

CREATE TABLE IF NOT EXISTS user_follows (
    id SERIAL PRIMARY KEY,
    follower_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_follow UNIQUE (follower_id, following_id),
    CONSTRAINT no_self_follow CHECK (follower_id != following_id)
);

CREATE INDEX IF NOT EXISTS idx_user_follows_follower ON user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following ON user_follows(following_id);

-- ================================================================
-- 3. POSTS
-- ================================================================

CREATE TABLE IF NOT EXISTS sns_posts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    category VARCHAR(20) NOT NULL DEFAULT 'general' CHECK (category IN ('learning', 'general')),
    tags TEXT[] DEFAULT '{}',
    visibility VARCHAR(20) NOT NULL DEFAULT 'public' CHECK (visibility IN ('public', 'followers')),
    image_urls TEXT[] DEFAULT '{}',
    like_count INTEGER DEFAULT 0,
    comment_count INTEGER DEFAULT 0,
    is_deleted BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sns_posts_user_id ON sns_posts(user_id);
CREATE INDEX IF NOT EXISTS idx_sns_posts_category ON sns_posts(category);
CREATE INDEX IF NOT EXISTS idx_sns_posts_created_at ON sns_posts(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sns_posts_visibility ON sns_posts(visibility);
CREATE INDEX IF NOT EXISTS idx_sns_posts_not_deleted ON sns_posts(id) WHERE is_deleted = false;

-- ================================================================
-- 4. POST LIKES
-- ================================================================

CREATE TABLE IF NOT EXISTS post_likes (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES sns_posts(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_post_like UNIQUE (post_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_post_likes_post_id ON post_likes(post_id);
CREATE INDEX IF NOT EXISTS idx_post_likes_user_id ON post_likes(user_id);

-- ================================================================
-- 5. POST COMMENTS
-- ================================================================

CREATE TABLE IF NOT EXISTS sns_comments (
    id SERIAL PRIMARY KEY,
    post_id INTEGER NOT NULL REFERENCES sns_posts(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    parent_id INTEGER REFERENCES sns_comments(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    is_deleted BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sns_comments_post_id ON sns_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_sns_comments_user_id ON sns_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_sns_comments_parent_id ON sns_comments(parent_id);

-- ================================================================
-- 6. SNS REPORTS
-- ================================================================

CREATE TABLE IF NOT EXISTS sns_reports (
    id SERIAL PRIMARY KEY,
    reporter_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    target_type VARCHAR(20) NOT NULL CHECK (target_type IN ('post', 'comment', 'user')),
    target_id INTEGER NOT NULL,
    reason TEXT NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved', 'dismissed')),
    admin_notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_sns_reports_status ON sns_reports(status);
CREATE INDEX IF NOT EXISTS idx_sns_reports_target ON sns_reports(target_type, target_id);

-- ================================================================
-- 7. USER BLOCKS
-- ================================================================

CREATE TABLE IF NOT EXISTS user_blocks (
    id SERIAL PRIMARY KEY,
    blocker_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    blocked_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    CONSTRAINT unique_block UNIQUE (blocker_id, blocked_id),
    CONSTRAINT no_self_block CHECK (blocker_id != blocked_id)
);

CREATE INDEX IF NOT EXISTS idx_user_blocks_blocker ON user_blocks(blocker_id);
CREATE INDEX IF NOT EXISTS idx_user_blocks_blocked ON user_blocks(blocked_id);

-- ================================================================
-- TRIGGER: Auto-update updated_at for posts
-- ================================================================

CREATE OR REPLACE FUNCTION update_posts_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trigger_posts_updated_at ON sns_posts;
CREATE TRIGGER trigger_posts_updated_at
    BEFORE UPDATE ON sns_posts
    FOR EACH ROW
    EXECUTE FUNCTION update_posts_updated_at();

DROP TRIGGER IF EXISTS trigger_sns_reports_updated_at ON sns_reports;
CREATE TRIGGER trigger_sns_reports_updated_at
    BEFORE UPDATE ON sns_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_posts_updated_at();

COMMIT;
