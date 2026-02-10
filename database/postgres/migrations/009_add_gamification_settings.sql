-- Migration 009: Add gamification settings table
-- Stores ad configuration and lemon reward parameters
-- Single-row design (id=1) for global settings

CREATE TABLE IF NOT EXISTS gamification_settings (
    id INTEGER PRIMARY KEY DEFAULT 1 CHECK (id = 1),

    -- 광고 설정
    admob_app_id VARCHAR(100) DEFAULT 'ca-app-pub-3940256099942544~3347511713',
    admob_rewarded_ad_id VARCHAR(100) DEFAULT 'ca-app-pub-3940256099942544/5224354917',
    adsense_publisher_id VARCHAR(100) DEFAULT '',
    adsense_ad_slot VARCHAR(100) DEFAULT '',
    ads_enabled BOOLEAN DEFAULT true,
    web_ads_enabled BOOLEAN DEFAULT false,

    -- 레몬 보상 설정
    lemon_3_threshold INTEGER DEFAULT 95,       -- 3레몬 퀴즈 점수 임계값
    lemon_2_threshold INTEGER DEFAULT 80,       -- 2레몬 퀴즈 점수 임계값
    boss_quiz_bonus INTEGER DEFAULT 5,          -- 보스 퀴즈 보너스 레몬
    boss_quiz_pass_percent INTEGER DEFAULT 70,  -- 보스 퀴즈 통과 기준 %
    max_tree_lemons INTEGER DEFAULT 10,         -- 나무 최대 레몬 수

    -- 메타
    version INTEGER DEFAULT 1,
    updated_by INTEGER,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

INSERT INTO gamification_settings (id) VALUES (1) ON CONFLICT DO NOTHING;
