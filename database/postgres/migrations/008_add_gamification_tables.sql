-- Migration: Add gamification tables for lemon reward system
-- Date: 2026-02-10

-- Lesson lemon rewards (1-3 lemons per lesson based on quiz score)
CREATE TABLE IF NOT EXISTS lesson_rewards (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    lemons_earned INTEGER NOT NULL DEFAULT 0 CHECK (lemons_earned BETWEEN 0 AND 3),
    best_quiz_score INTEGER CHECK (best_quiz_score BETWEEN 0 AND 100),
    earned_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, lesson_id)
);

-- Lemon currency (per-user balance)
CREATE TABLE IF NOT EXISTS lemon_currency (
    user_id INTEGER PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    total_lemons INTEGER NOT NULL DEFAULT 0,
    tree_lemons_available INTEGER NOT NULL DEFAULT 0,
    tree_lemons_harvested INTEGER NOT NULL DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Lemon transaction history
CREATE TABLE IF NOT EXISTS lemon_transactions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('lesson', 'boss', 'harvest', 'bonus')),
    source_id INTEGER, -- lesson_id or boss quiz identifier
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Boss quiz completion tracking
CREATE TABLE IF NOT EXISTS boss_quiz_completions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    level INTEGER NOT NULL,
    week INTEGER NOT NULL,
    score INTEGER,
    bonus_lemons INTEGER NOT NULL DEFAULT 5,
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, level, week)
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_lesson_rewards_user ON lesson_rewards(user_id);
CREATE INDEX IF NOT EXISTS idx_lesson_rewards_lesson ON lesson_rewards(lesson_id);
CREATE INDEX IF NOT EXISTS idx_lemon_transactions_user ON lemon_transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_lemon_transactions_type ON lemon_transactions(type);
CREATE INDEX IF NOT EXISTS idx_boss_quiz_user ON boss_quiz_completions(user_id);
