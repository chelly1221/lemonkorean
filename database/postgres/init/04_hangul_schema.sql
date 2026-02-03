-- ==================== Hangul Characters Schema ====================
-- Korean alphabet (한글) learning feature
-- 한글 학습 기능을 위한 스키마

-- ==================== Hangul Characters Table ====================
CREATE TABLE hangul_characters (
    id SERIAL PRIMARY KEY,
    character VARCHAR(10) NOT NULL,
    character_type VARCHAR(20) NOT NULL CHECK (character_type IN (
        'basic_consonant', 'double_consonant',
        'basic_vowel', 'compound_vowel', 'final_consonant'
    )),
    romanization VARCHAR(50) NOT NULL,
    pronunciation_zh VARCHAR(100) NOT NULL,
    pronunciation_tip_zh TEXT,
    stroke_count INTEGER DEFAULT 1,
    stroke_order_url TEXT,
    audio_url TEXT,
    display_order INTEGER NOT NULL,
    example_words JSONB DEFAULT '[]',
    mnemonics_zh TEXT,
    status VARCHAR(20) DEFAULT 'published' CHECK (status IN ('draft', 'published', 'archived')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_hangul_characters_type ON hangul_characters(character_type);
CREATE INDEX idx_hangul_characters_order ON hangul_characters(character_type, display_order);
CREATE INDEX idx_hangul_characters_status ON hangul_characters(status);
CREATE UNIQUE INDEX idx_hangul_characters_unique ON hangul_characters(character, character_type);

COMMENT ON TABLE hangul_characters IS '한글 자모 테이블';
COMMENT ON COLUMN hangul_characters.character IS '한글 자모 (ㄱ, ㅏ 등)';
COMMENT ON COLUMN hangul_characters.character_type IS '자모 유형 (basic_consonant, double_consonant, basic_vowel, compound_vowel, final_consonant)';
COMMENT ON COLUMN hangul_characters.romanization IS '로마자 표기';
COMMENT ON COLUMN hangul_characters.pronunciation_zh IS '중국어 발음 설명';
COMMENT ON COLUMN hangul_characters.pronunciation_tip_zh IS '중국어 발음 팁';
COMMENT ON COLUMN hangul_characters.stroke_order_url IS '획순 이미지/애니메이션 URL';
COMMENT ON COLUMN hangul_characters.example_words IS 'JSON 배열: [{korean, chinese, pinyin}]';
COMMENT ON COLUMN hangul_characters.mnemonics_zh IS '중국어 기억법';

-- ==================== Hangul Progress Table ====================
CREATE TABLE hangul_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    character_id INTEGER NOT NULL REFERENCES hangul_characters(id) ON DELETE CASCADE,
    mastery_level INTEGER DEFAULT 0 CHECK (mastery_level BETWEEN 0 AND 5),
    correct_count INTEGER DEFAULT 0,
    wrong_count INTEGER DEFAULT 0,
    streak_count INTEGER DEFAULT 0,
    last_practiced TIMESTAMP,
    next_review TIMESTAMP,
    ease_factor DECIMAL(3, 2) DEFAULT 2.50,
    interval_days INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, character_id)
);

CREATE INDEX idx_hangul_progress_user ON hangul_progress(user_id);
CREATE INDEX idx_hangul_progress_character ON hangul_progress(character_id);
CREATE INDEX idx_hangul_progress_mastery ON hangul_progress(mastery_level);
CREATE INDEX idx_hangul_progress_next_review ON hangul_progress(next_review);
CREATE INDEX idx_hangul_progress_user_review ON hangul_progress(user_id, next_review);

COMMENT ON TABLE hangul_progress IS '사용자별 한글 학습 진도 (SRS)';
COMMENT ON COLUMN hangul_progress.mastery_level IS '숙달 레벨 (0: 새로운, 5: 완전 숙달)';
COMMENT ON COLUMN hangul_progress.ease_factor IS 'SM-2 알고리즘 ease factor';
COMMENT ON COLUMN hangul_progress.interval_days IS '다음 복습까지 일수';

-- ==================== Triggers ====================

CREATE TRIGGER update_hangul_characters_updated_at BEFORE UPDATE ON hangul_characters
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hangul_progress_updated_at BEFORE UPDATE ON hangul_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==================== Hangul Learning Stats View ====================
CREATE OR REPLACE VIEW user_hangul_stats AS
SELECT
    u.id AS user_id,
    u.email,
    COUNT(DISTINCT hp.character_id) FILTER (WHERE hp.mastery_level >= 1) AS characters_learned,
    COUNT(DISTINCT hp.character_id) FILTER (WHERE hp.mastery_level >= 3) AS characters_mastered,
    COUNT(DISTINCT hp.character_id) FILTER (WHERE hp.mastery_level = 5) AS characters_perfected,
    SUM(hp.correct_count) AS total_correct,
    SUM(hp.wrong_count) AS total_wrong,
    CASE
        WHEN SUM(hp.correct_count) + SUM(hp.wrong_count) > 0
        THEN ROUND(100.0 * SUM(hp.correct_count) / (SUM(hp.correct_count) + SUM(hp.wrong_count)), 2)
        ELSE 0
    END AS accuracy_percent,
    MAX(hp.last_practiced) AS last_practice_date
FROM users u
LEFT JOIN hangul_progress hp ON u.id = hp.user_id
GROUP BY u.id, u.email;

COMMENT ON VIEW user_hangul_stats IS '사용자별 한글 학습 통계 뷰';

-- ==================== End of Hangul Schema ====================
