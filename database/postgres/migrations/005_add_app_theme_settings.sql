-- Migration: Add App Theme Settings
-- Description: Create table for managing Flutter app theme configuration (colors, logos, fonts)
-- Date: 2026-02-04
-- Note: This is separate from design_settings (which controls admin dashboard theme)

-- Create app_theme_settings table
CREATE TABLE IF NOT EXISTS app_theme_settings (
    id SERIAL PRIMARY KEY,

    -- Brand Colors (3)
    primary_color VARCHAR(7) NOT NULL DEFAULT '#FFEF5F',
    secondary_color VARCHAR(7) NOT NULL DEFAULT '#4CAF50',
    accent_color VARCHAR(7) NOT NULL DEFAULT '#FF9800',

    -- Status Colors (4)
    error_color VARCHAR(7) NOT NULL DEFAULT '#F44336',
    success_color VARCHAR(7) NOT NULL DEFAULT '#4CAF50',
    warning_color VARCHAR(7) NOT NULL DEFAULT '#FF9800',
    info_color VARCHAR(7) NOT NULL DEFAULT '#2196F3',

    -- Text Colors (3)
    text_primary VARCHAR(7) NOT NULL DEFAULT '#212121',
    text_secondary VARCHAR(7) NOT NULL DEFAULT '#757575',
    text_hint VARCHAR(7) NOT NULL DEFAULT '#BDBDBD',

    -- Background Colors (3)
    background_light VARCHAR(7) NOT NULL DEFAULT '#FAFAFA',
    background_dark VARCHAR(7) NOT NULL DEFAULT '#303030',
    card_background VARCHAR(7) NOT NULL DEFAULT '#FFFFFF',

    -- Lesson Stage Colors (7)
    stage1_color VARCHAR(7) NOT NULL DEFAULT '#2196F3',
    stage2_color VARCHAR(7) NOT NULL DEFAULT '#4CAF50',
    stage3_color VARCHAR(7) NOT NULL DEFAULT '#FF9800',
    stage4_color VARCHAR(7) NOT NULL DEFAULT '#9C27B0',
    stage5_color VARCHAR(7) NOT NULL DEFAULT '#E91E63',
    stage6_color VARCHAR(7) NOT NULL DEFAULT '#F44336',
    stage7_color VARCHAR(7) NOT NULL DEFAULT '#607D8B',

    -- Media Settings
    splash_logo_key TEXT,
    splash_logo_url TEXT,
    login_logo_key TEXT,
    login_logo_url TEXT,
    favicon_key TEXT,
    favicon_url TEXT,

    -- Font Settings
    font_family VARCHAR(100) NOT NULL DEFAULT 'NotoSansKR',
    font_source VARCHAR(20) NOT NULL DEFAULT 'google',
    custom_font_key TEXT,
    custom_font_url TEXT,

    -- Metadata
    version INTEGER NOT NULL DEFAULT 1,
    updated_by INTEGER REFERENCES users(id),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    -- Constraints
    CONSTRAINT valid_hex_colors CHECK (
        primary_color ~ '^#[0-9A-Fa-f]{6}$' AND
        secondary_color ~ '^#[0-9A-Fa-f]{6}$' AND
        accent_color ~ '^#[0-9A-Fa-f]{6}$' AND
        error_color ~ '^#[0-9A-Fa-f]{6}$' AND
        success_color ~ '^#[0-9A-Fa-f]{6}$' AND
        warning_color ~ '^#[0-9A-Fa-f]{6}$' AND
        info_color ~ '^#[0-9A-Fa-f]{6}$' AND
        text_primary ~ '^#[0-9A-Fa-f]{6}$' AND
        text_secondary ~ '^#[0-9A-Fa-f]{6}$' AND
        text_hint ~ '^#[0-9A-Fa-f]{6}$' AND
        background_light ~ '^#[0-9A-Fa-f]{6}$' AND
        background_dark ~ '^#[0-9A-Fa-f]{6}$' AND
        card_background ~ '^#[0-9A-Fa-f]{6}$' AND
        stage1_color ~ '^#[0-9A-Fa-f]{6}$' AND
        stage2_color ~ '^#[0-9A-Fa-f]{6}$' AND
        stage3_color ~ '^#[0-9A-Fa-f]{6}$' AND
        stage4_color ~ '^#[0-9A-Fa-f]{6}$' AND
        stage5_color ~ '^#[0-9A-Fa-f]{6}$' AND
        stage6_color ~ '^#[0-9A-Fa-f]{6}$' AND
        stage7_color ~ '^#[0-9A-Fa-f]{6}$'
    ),
    CONSTRAINT valid_font_source CHECK (font_source IN ('google', 'custom', 'system'))
);

-- Create index on updated_at for efficient queries
CREATE INDEX idx_app_theme_settings_updated_at ON app_theme_settings(updated_at DESC);

-- Insert default settings (single row for system-wide config)
INSERT INTO app_theme_settings (
    id,
    primary_color,
    secondary_color,
    accent_color,
    error_color,
    success_color,
    warning_color,
    info_color,
    text_primary,
    text_secondary,
    text_hint,
    background_light,
    background_dark,
    card_background,
    stage1_color,
    stage2_color,
    stage3_color,
    stage4_color,
    stage5_color,
    stage6_color,
    stage7_color,
    font_family,
    font_source,
    version
) VALUES (
    1,
    '#FFEF5F', -- primary_color (Lemon Yellow)
    '#4CAF50', -- secondary_color
    '#FF9800', -- accent_color
    '#F44336', -- error_color
    '#4CAF50', -- success_color
    '#FF9800', -- warning_color
    '#2196F3', -- info_color
    '#212121', -- text_primary
    '#757575', -- text_secondary
    '#BDBDBD', -- text_hint
    '#FAFAFA', -- background_light
    '#303030', -- background_dark
    '#FFFFFF', -- card_background
    '#2196F3', -- stage1_color (Intro - Blue)
    '#4CAF50', -- stage2_color (Vocabulary - Green)
    '#FF9800', -- stage3_color (Grammar - Orange)
    '#9C27B0', -- stage4_color (Practice - Purple)
    '#E91E63', -- stage5_color (Dialogue - Pink)
    '#F44336', -- stage6_color (Quiz - Red)
    '#607D8B', -- stage7_color (Summary - Grey)
    'NotoSansKR', -- font_family
    'google', -- font_source
    1 -- version
) ON CONFLICT (id) DO NOTHING;

-- Create trigger to auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_app_theme_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    NEW.version = OLD.version + 1;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_app_theme_settings_updated_at
    BEFORE UPDATE ON app_theme_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_app_theme_settings_updated_at();

-- Add comment to table
COMMENT ON TABLE app_theme_settings IS 'System-wide Flutter app theme configuration (colors, logos, fonts). Single row (id=1) for all users.';
COMMENT ON COLUMN app_theme_settings.version IS 'Increments on each update for cache invalidation in Flutter app';
COMMENT ON COLUMN app_theme_settings.font_source IS 'Font source: google (Google Fonts), custom (uploaded TTF/OTF), system (device default)';
COMMENT ON COLUMN app_theme_settings.splash_logo_key IS 'MinIO object key for splash screen logo';
COMMENT ON COLUMN app_theme_settings.login_logo_key IS 'MinIO object key for login screen logo';
COMMENT ON COLUMN app_theme_settings.favicon_key IS 'MinIO object key for web app favicon';
COMMENT ON COLUMN app_theme_settings.custom_font_key IS 'MinIO object key for custom font file';
