-- ==================== Lemon Korean Database Schema ====================
-- PostgreSQL 15+ compatible
-- Encoding: UTF-8

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For fuzzy text search

-- ==================== Users Table ====================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    name VARCHAR(100),
    language_preference VARCHAR(10) DEFAULT 'ko' CHECK (language_preference IN ('ko', 'en', 'es', 'ja', 'zh', 'zh_TW')),
    subscription_type VARCHAR(20) DEFAULT 'free' CHECK (subscription_type IN ('free', 'premium', 'lifetime')),
    subscription_expires_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    profile_image_url TEXT
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_subscription ON users(subscription_type, subscription_expires_at);
CREATE INDEX idx_users_created_at ON users(created_at DESC);

COMMENT ON TABLE users IS '사용자 계정 정보';
COMMENT ON COLUMN users.language_preference IS '콘텐츠 언어 (ko, en, es, ja, zh, zh_TW)';
COMMENT ON COLUMN users.subscription_type IS '구독 유형 (free: 무료, premium: 유료, lifetime: 평생)';

-- ==================== Sessions Table ====================
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token VARCHAR(500) NOT NULL,
    refresh_token VARCHAR(500),
    expires_at TIMESTAMP NOT NULL,
    device_info JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_activity TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_sessions_user_id ON sessions(user_id);
CREATE INDEX idx_sessions_token ON sessions(token);
CREATE INDEX idx_sessions_refresh_token ON sessions(refresh_token);
CREATE INDEX idx_sessions_expires_at ON sessions(expires_at);

COMMENT ON TABLE sessions IS '사용자 세션 및 토큰 관리';
COMMENT ON COLUMN sessions.device_info IS 'JSON: {device_type, os, app_version, device_id}';

-- ==================== Lessons Table ====================
-- NOTE: title_zh, description_zh columns are DEPRECATED
-- Use lesson_translations table for localized content (see migrations/001_add_translations.sql)
-- These columns are kept for backwards compatibility during transition
CREATE TABLE lessons (
    id SERIAL PRIMARY KEY,
    level INTEGER NOT NULL CHECK (level BETWEEN 1 AND 6),
    week INTEGER NOT NULL CHECK (week >= 1),
    order_num INTEGER NOT NULL,
    title_ko VARCHAR(255) NOT NULL,
    title_zh VARCHAR(255) NOT NULL, -- DEPRECATED: Use lesson_translations table
    description_ko TEXT,
    description_zh TEXT, -- DEPRECATED: Use lesson_translations table
    duration_minutes INTEGER DEFAULT 30,
    difficulty VARCHAR(20) CHECK (difficulty IN ('beginner', 'elementary', 'intermediate', 'advanced')),
    thumbnail_url TEXT,
    version VARCHAR(20) DEFAULT '1.0.0',
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
    published_at TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    prerequisites INTEGER[] DEFAULT ARRAY[]::INTEGER[],
    tags TEXT[] DEFAULT ARRAY[]::TEXT[],
    view_count INTEGER DEFAULT 0,
    completion_count INTEGER DEFAULT 0
);

CREATE INDEX idx_lessons_level_week ON lessons(level, week, order_num);
CREATE INDEX idx_lessons_status ON lessons(status);
CREATE INDEX idx_lessons_published_at ON lessons(published_at DESC);
CREATE INDEX idx_lessons_difficulty ON lessons(difficulty);
CREATE UNIQUE INDEX idx_lessons_unique_order ON lessons(level, week, order_num) WHERE status = 'published';

COMMENT ON TABLE lessons IS '레슨 메타데이터 (콘텐츠는 MongoDB에 저장)';
COMMENT ON COLUMN lessons.level IS 'TOPIK 레벨 (1-6)';
COMMENT ON COLUMN lessons.prerequisites IS '선수 레슨 ID 배열';

-- ==================== Vocabulary Table ====================
-- NOTE: chinese, pinyin, example_sentence_zh columns are DEPRECATED
-- Use vocabulary_translations table for localized content (see migrations/001_add_translations.sql)
-- These columns are kept for backwards compatibility during transition
CREATE TABLE vocabulary (
    id SERIAL PRIMARY KEY,
    korean VARCHAR(100) NOT NULL,
    hanja VARCHAR(100),
    chinese VARCHAR(100) NOT NULL, -- DEPRECATED: Use vocabulary_translations table
    pinyin VARCHAR(200), -- DEPRECATED: Use vocabulary_translations table
    part_of_speech VARCHAR(20) CHECK (part_of_speech IN ('noun', 'verb', 'adjective', 'adverb', 'particle', 'conjunction', 'interjection', 'pronoun')),
    level INTEGER CHECK (level BETWEEN 1 AND 6),
    similarity_score DECIMAL(3, 2) CHECK (similarity_score BETWEEN 0 AND 1),
    image_url TEXT,
    audio_url_male TEXT,
    audio_url_female TEXT,
    example_sentence_ko TEXT,
    example_sentence_zh TEXT, -- DEPRECATED: Use vocabulary_translations table
    notes TEXT, -- DEPRECATED: Use vocabulary_translations table
    frequency_rank INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_vocabulary_korean ON vocabulary USING gin(korean gin_trgm_ops);
CREATE INDEX idx_vocabulary_chinese ON vocabulary USING gin(chinese gin_trgm_ops);
CREATE INDEX idx_vocabulary_level ON vocabulary(level);
CREATE INDEX idx_vocabulary_pos ON vocabulary(part_of_speech);
CREATE INDEX idx_vocabulary_similarity ON vocabulary(similarity_score DESC);
CREATE INDEX idx_vocabulary_frequency ON vocabulary(frequency_rank);

COMMENT ON TABLE vocabulary IS '단어장 (한-중 매핑)';
COMMENT ON COLUMN vocabulary.similarity_score IS '한자어 유사도 (0.0-1.0)';
COMMENT ON COLUMN vocabulary.hanja IS '한국어 단어의 한자 표기';

-- ==================== Grammar Rules Table ====================
-- NOTE: name_zh, chinese_comparison columns are DEPRECATED
-- Use grammar_translations table for localized content (see migrations/001_add_translations.sql)
-- These columns are kept for backwards compatibility during transition
CREATE TABLE grammar_rules (
    id SERIAL PRIMARY KEY,
    name_ko VARCHAR(255) NOT NULL,
    name_zh VARCHAR(255) NOT NULL, -- DEPRECATED: Use grammar_translations table
    category VARCHAR(50),
    level INTEGER CHECK (level BETWEEN 1 AND 6),
    difficulty VARCHAR(20) CHECK (difficulty IN ('beginner', 'elementary', 'intermediate', 'advanced')),
    description TEXT, -- DEPRECATED: Use grammar_translations table
    chinese_comparison TEXT, -- DEPRECATED: Use grammar_translations table
    examples JSONB NOT NULL DEFAULT '[]',
    usage_notes TEXT,
    common_mistakes TEXT,
    related_grammar INTEGER[] DEFAULT ARRAY[]::INTEGER[],
    version VARCHAR(20) DEFAULT '1.0.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_grammar_level ON grammar_rules(level);
CREATE INDEX idx_grammar_category ON grammar_rules(category);
CREATE INDEX idx_grammar_difficulty ON grammar_rules(difficulty);
CREATE INDEX idx_grammar_examples ON grammar_rules USING gin(examples);

COMMENT ON TABLE grammar_rules IS '문법 규칙 및 패턴';
COMMENT ON COLUMN grammar_rules.examples IS 'JSON 배열: [{ko, zh, explanation}]';
COMMENT ON COLUMN grammar_rules.chinese_comparison IS '중국어와 비교 설명';

-- ==================== User Progress Table ====================
CREATE TABLE user_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    status VARCHAR(20) DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed', 'reviewing')),
    progress_percent INTEGER DEFAULT 0 CHECK (progress_percent BETWEEN 0 AND 100),
    quiz_score INTEGER CHECK (quiz_score BETWEEN 0 AND 100),
    time_spent_minutes INTEGER DEFAULT 0,
    completed_at TIMESTAMP,
    last_accessed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    attempt_count INTEGER DEFAULT 0,
    stage_progress JSONB DEFAULT '{}',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, lesson_id)
);

CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_lesson ON user_progress(lesson_id);
CREATE INDEX idx_user_progress_status ON user_progress(status);
CREATE INDEX idx_user_progress_completed ON user_progress(completed_at DESC);
CREATE INDEX idx_user_progress_last_accessed_at ON user_progress(last_accessed_at DESC);
CREATE INDEX idx_user_progress_user_status ON user_progress(user_id, status);

COMMENT ON TABLE user_progress IS '사용자별 레슨 진도 추적';
COMMENT ON COLUMN user_progress.stage_progress IS 'JSON: {stage1: 100, stage2: 50, ...}';

-- ==================== Vocabulary Progress Table ====================
CREATE TABLE vocabulary_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    vocab_id INTEGER NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
    mastery_level INTEGER DEFAULT 0 CHECK (mastery_level BETWEEN 0 AND 5),
    correct_count INTEGER DEFAULT 0,
    wrong_count INTEGER DEFAULT 0,
    streak_count INTEGER DEFAULT 0,
    last_reviewed TIMESTAMP,
    next_review TIMESTAMP,
    ease_factor DECIMAL(3, 2) DEFAULT 2.50,
    interval_days INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, vocab_id)
);

CREATE INDEX idx_vocab_progress_user ON vocabulary_progress(user_id);
CREATE INDEX idx_vocab_progress_vocab ON vocabulary_progress(vocab_id);
CREATE INDEX idx_vocab_progress_mastery ON vocabulary_progress(mastery_level);
CREATE INDEX idx_vocab_progress_next_review ON vocabulary_progress(next_review);
CREATE INDEX idx_vocab_progress_user_review ON vocabulary_progress(user_id, next_review);

COMMENT ON TABLE vocabulary_progress IS '단어 학습 진도 (SRS 알고리즘)';
COMMENT ON COLUMN vocabulary_progress.mastery_level IS '숙달 레벨 (0: 새로운, 5: 완전 숙달)';
COMMENT ON COLUMN vocabulary_progress.ease_factor IS 'SM-2 알고리즘 ease factor';
COMMENT ON COLUMN vocabulary_progress.interval_days IS '다음 복습까지 일수';

-- ==================== Learning Sessions Table ====================
CREATE TABLE learning_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ended_at TIMESTAMP,
    duration_seconds INTEGER,
    lessons_completed INTEGER DEFAULT 0,
    words_reviewed INTEGER DEFAULT 0,
    quiz_score_avg DECIMAL(5, 2),
    device_type VARCHAR(20),
    app_version VARCHAR(20),
    is_synced BOOLEAN DEFAULT true,
    sync_data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_learning_sessions_user ON learning_sessions(user_id);
CREATE INDEX idx_learning_sessions_started ON learning_sessions(started_at DESC);
CREATE INDEX idx_learning_sessions_device ON learning_sessions(device_type);
CREATE INDEX idx_learning_sessions_sync ON learning_sessions(is_synced);

COMMENT ON TABLE learning_sessions IS '학습 세션 기록 (분석용)';
COMMENT ON COLUMN learning_sessions.sync_data IS '오프라인 동기화 데이터';

-- ==================== Sync Queue Table ====================
CREATE TABLE sync_queue (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    data_type VARCHAR(50) NOT NULL CHECK (data_type IN ('lesson_progress', 'vocab_progress', 'quiz_result', 'session', 'bookmark', 'note')),
    payload JSONB NOT NULL,
    priority INTEGER DEFAULT 5 CHECK (priority BETWEEN 1 AND 10),
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'completed', 'failed')),
    retry_count INTEGER DEFAULT 0,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    synced_at TIMESTAMP,
    processed_at TIMESTAMP
);

CREATE INDEX idx_sync_queue_user ON sync_queue(user_id);
CREATE INDEX idx_sync_queue_status ON sync_queue(status);
CREATE INDEX idx_sync_queue_created ON sync_queue(created_at);
CREATE INDEX idx_sync_queue_priority ON sync_queue(priority DESC, created_at);
CREATE INDEX idx_sync_queue_user_status ON sync_queue(user_id, status);

COMMENT ON TABLE sync_queue IS '오프라인 동기화 큐';
COMMENT ON COLUMN sync_queue.priority IS '우선순위 (1: 최고, 10: 최저)';

-- ==================== Lesson Vocabulary Mapping Table ====================
CREATE TABLE lesson_vocabulary (
    lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    vocab_id INTEGER NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT false,
    display_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (lesson_id, vocab_id)
);

CREATE INDEX idx_lesson_vocab_lesson ON lesson_vocabulary(lesson_id);
CREATE INDEX idx_lesson_vocab_vocab ON lesson_vocabulary(vocab_id);
CREATE INDEX idx_lesson_vocab_primary ON lesson_vocabulary(is_primary);

COMMENT ON TABLE lesson_vocabulary IS '레슨-단어 매핑 테이블';

-- ==================== Lesson Grammar Mapping Table ====================
CREATE TABLE lesson_grammar (
    lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    grammar_id INTEGER NOT NULL REFERENCES grammar_rules(id) ON DELETE CASCADE,
    is_primary BOOLEAN DEFAULT false,
    display_order INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (lesson_id, grammar_id)
);

CREATE INDEX idx_lesson_grammar_lesson ON lesson_grammar(lesson_id);
CREATE INDEX idx_lesson_grammar_grammar ON lesson_grammar(grammar_id);

COMMENT ON TABLE lesson_grammar IS '레슨-문법 매핑 테이블';

-- ==================== User Bookmarks Table ====================
CREATE TABLE user_bookmarks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    resource_type VARCHAR(20) CHECK (resource_type IN ('lesson', 'vocabulary', 'grammar')),
    resource_id INTEGER NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, resource_type, resource_id)
);

CREATE INDEX idx_bookmarks_user ON user_bookmarks(user_id);
CREATE INDEX idx_bookmarks_type ON user_bookmarks(resource_type, resource_id);

COMMENT ON TABLE user_bookmarks IS '사용자 북마크';

-- ==================== User Achievements Table ====================
CREATE TABLE user_achievements (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    achievement_type VARCHAR(50) NOT NULL,
    achievement_data JSONB,
    earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, achievement_type)
);

CREATE INDEX idx_achievements_user ON user_achievements(user_id);
CREATE INDEX idx_achievements_type ON user_achievements(achievement_type);
CREATE INDEX idx_achievements_earned ON user_achievements(earned_at DESC);

COMMENT ON TABLE user_achievements IS '사용자 업적 및 배지';

-- ==================== Triggers ====================

-- Auto-update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_lessons_updated_at BEFORE UPDATE ON lessons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vocabulary_updated_at BEFORE UPDATE ON vocabulary
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_grammar_rules_updated_at BEFORE UPDATE ON grammar_rules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_progress_updated_at BEFORE UPDATE ON user_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vocabulary_progress_updated_at BEFORE UPDATE ON vocabulary_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Auto-calculate learning session duration
CREATE OR REPLACE FUNCTION calculate_session_duration()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ended_at IS NOT NULL AND NEW.started_at IS NOT NULL THEN
        NEW.duration_seconds = EXTRACT(EPOCH FROM (NEW.ended_at - NEW.started_at))::INTEGER;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER calculate_learning_session_duration BEFORE INSERT OR UPDATE ON learning_sessions
    FOR EACH ROW EXECUTE FUNCTION calculate_session_duration();

-- ==================== Views ====================

-- User learning statistics view
CREATE OR REPLACE VIEW user_learning_stats AS
SELECT
    u.id AS user_id,
    u.email,
    COUNT(DISTINCT up.lesson_id) FILTER (WHERE up.status = 'completed') AS lessons_completed,
    COUNT(DISTINCT vp.vocab_id) FILTER (WHERE vp.mastery_level >= 3) AS words_mastered,
    ROUND(AVG(up.quiz_score), 2) AS avg_quiz_score,
    SUM(up.time_spent_minutes) AS total_study_time_minutes,
    MAX(up.last_accessed_at) AS last_study_date,
    COUNT(DISTINCT DATE(ls.started_at)) AS study_days_count
FROM users u
LEFT JOIN user_progress up ON u.id = up.user_id
LEFT JOIN vocabulary_progress vp ON u.id = vp.user_id
LEFT JOIN learning_sessions ls ON u.id = ls.user_id
GROUP BY u.id, u.email;

COMMENT ON VIEW user_learning_stats IS '사용자별 학습 통계 뷰';

-- Daily active users view
CREATE OR REPLACE VIEW daily_active_users AS
SELECT
    DATE(started_at) AS date,
    COUNT(DISTINCT user_id) AS active_users,
    SUM(lessons_completed) AS total_lessons_completed,
    ROUND(AVG(duration_seconds), 2) AS avg_session_duration
FROM learning_sessions
WHERE started_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE(started_at)
ORDER BY date DESC;

COMMENT ON VIEW daily_active_users IS '일별 활성 사용자 통계';

-- ==================== Initial Data ====================

-- Insert sample admin user (password: admin123)
INSERT INTO users (email, password_hash, name, subscription_type, is_active, email_verified) VALUES
('admin@lemonkorean.com', '$2b$10$X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0X0', 'Admin', 'lifetime', true, true);

COMMENT ON DATABASE lemon_korean IS 'Lemon Korean Learning Platform Database';

-- ==================== End of Schema ====================
