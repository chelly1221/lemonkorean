-- Migration 015: Add repetition_count to hangul_progress
-- This column is required for SM-2 SRS algorithm to track consecutive successful reviews.
-- Without it, repetition_count always resets to 0, causing SRS intervals to restart.

ALTER TABLE hangul_progress ADD COLUMN IF NOT EXISTS repetition_count INTEGER DEFAULT 0;

-- Initialize repetition_count from existing data:
-- Estimate based on correct_count and streak_count for existing rows
UPDATE hangul_progress
SET repetition_count = LEAST(correct_count, streak_count)
WHERE repetition_count = 0 AND correct_count > 0;
