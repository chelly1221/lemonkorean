-- Migration 018: Hangul lesson progress table
-- Stores interactive lesson completion for Stage 0+ hangul lessons.

CREATE TABLE IF NOT EXISTS hangul_lesson_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id VARCHAR(10) NOT NULL,  -- e.g. '0-1', '0-2', '0-M'
    completed_steps INTEGER NOT NULL DEFAULT 0,
    total_steps INTEGER NOT NULL DEFAULT 0,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    best_score INTEGER NOT NULL DEFAULT 0,  -- 0-100
    lemons_earned INTEGER NOT NULL DEFAULT 0,  -- 0-3
    completed_at TIMESTAMPTZ,
    last_accessed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, lesson_id)
);

-- Index for user lookups
CREATE INDEX IF NOT EXISTS idx_hangul_lesson_progress_user_id
    ON hangul_lesson_progress(user_id);

-- Index for lesson_id queries
CREATE INDEX IF NOT EXISTS idx_hangul_lesson_progress_lesson_id
    ON hangul_lesson_progress(lesson_id);
