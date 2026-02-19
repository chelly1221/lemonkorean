-- Migration 017: Update app theme colors to Toss-style warm palette
-- Aligns the global theme with onboarding screen design
-- Date: 2026-02-19

UPDATE app_theme_settings
SET text_primary = '#191F28',
    text_secondary = '#6B7684',
    text_hint = '#8B95A1',
    background_light = '#FEFFF4',
    updated_at = CURRENT_TIMESTAMP
WHERE id = 1;
