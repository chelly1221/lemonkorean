-- ==================== Migration: Add Pronunciation Guides ====================
-- Version: 002
-- Date: 2026-02-03
-- Description: Add tables for enhanced hangul pronunciation features
-- 한글 발음 가이드, 음절 조합, 유사음 훈련을 위한 테이블 추가

-- ==================== Pronunciation Guides Table ====================
CREATE TABLE IF NOT EXISTS hangul_pronunciation_guides (
    character_id INTEGER PRIMARY KEY REFERENCES hangul_characters(id) ON DELETE CASCADE,
    mouth_shape_url TEXT,
    tongue_position_url TEXT,
    air_flow_description JSONB DEFAULT '{}',
    native_comparisons JSONB DEFAULT '{}',
    similar_character_ids INTEGER[],
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE hangul_pronunciation_guides IS '한글 발음 가이드 (입모양, 혀위치 등)';
COMMENT ON COLUMN hangul_pronunciation_guides.mouth_shape_url IS '입모양 이미지 URL';
COMMENT ON COLUMN hangul_pronunciation_guides.tongue_position_url IS '혀위치 이미지 URL';
COMMENT ON COLUMN hangul_pronunciation_guides.air_flow_description IS '기류 설명 JSON: {type, description_zh, description_ko, description_en}';
COMMENT ON COLUMN hangul_pronunciation_guides.native_comparisons IS '모국어별 비교 JSON: {zh: {comparison, tip}, en: {...}, ja: {...}}';
COMMENT ON COLUMN hangul_pronunciation_guides.similar_character_ids IS '유사음 캐릭터 ID 배열';

-- ==================== Syllables Table ====================
CREATE TABLE IF NOT EXISTS hangul_syllables (
    id SERIAL PRIMARY KEY,
    syllable VARCHAR(10) NOT NULL UNIQUE,
    initial_consonant_id INTEGER REFERENCES hangul_characters(id),
    vowel_id INTEGER REFERENCES hangul_characters(id),
    final_consonant_id INTEGER REFERENCES hangul_characters(id),
    audio_url TEXT,
    example_word VARCHAR(50),
    example_word_meanings JSONB DEFAULT '{}',
    frequency_rank INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_hangul_syllables_initial ON hangul_syllables(initial_consonant_id);
CREATE INDEX IF NOT EXISTS idx_hangul_syllables_vowel ON hangul_syllables(vowel_id);
CREATE INDEX IF NOT EXISTS idx_hangul_syllables_final ON hangul_syllables(final_consonant_id);
CREATE INDEX IF NOT EXISTS idx_hangul_syllables_frequency ON hangul_syllables(frequency_rank);

COMMENT ON TABLE hangul_syllables IS '한글 음절 조합 테이블';
COMMENT ON COLUMN hangul_syllables.syllable IS '음절 (예: 가, 나, 다)';
COMMENT ON COLUMN hangul_syllables.initial_consonant_id IS '초성 자음 ID';
COMMENT ON COLUMN hangul_syllables.vowel_id IS '중성 모음 ID';
COMMENT ON COLUMN hangul_syllables.final_consonant_id IS '종성 (받침) ID (null = 받침 없음)';
COMMENT ON COLUMN hangul_syllables.example_word_meanings IS 'JSON: {zh, en, ko, ja}';
COMMENT ON COLUMN hangul_syllables.frequency_rank IS '사용 빈도 순위 (1이 가장 높음)';

-- ==================== Similar Sound Groups Table ====================
CREATE TABLE IF NOT EXISTS hangul_similar_sound_groups (
    id SERIAL PRIMARY KEY,
    group_name VARCHAR(50) NOT NULL,
    group_name_ko VARCHAR(50) NOT NULL,
    description TEXT,
    description_ko TEXT,
    category VARCHAR(20) NOT NULL CHECK (category IN ('consonant', 'vowel')),
    character_ids INTEGER[] NOT NULL,
    difficulty_level INTEGER DEFAULT 1 CHECK (difficulty_level BETWEEN 1 AND 5),
    practice_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE hangul_similar_sound_groups IS '유사음 그룹 (소리 구분 훈련용)';
COMMENT ON COLUMN hangul_similar_sound_groups.group_name IS '그룹명 (예: ㄱ/ㅋ/ㄲ)';
COMMENT ON COLUMN hangul_similar_sound_groups.category IS '카테고리 (consonant/vowel)';
COMMENT ON COLUMN hangul_similar_sound_groups.character_ids IS '그룹에 포함된 캐릭터 ID 배열';
COMMENT ON COLUMN hangul_similar_sound_groups.difficulty_level IS '난이도 (1-5)';

-- ==================== Writing Practice Progress Table ====================
CREATE TABLE IF NOT EXISTS hangul_writing_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    character_id INTEGER NOT NULL REFERENCES hangul_characters(id) ON DELETE CASCADE,
    total_attempts INTEGER DEFAULT 0,
    successful_attempts INTEGER DEFAULT 0,
    average_accuracy DECIMAL(5, 2) DEFAULT 0,
    best_accuracy DECIMAL(5, 2) DEFAULT 0,
    last_practiced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, character_id)
);

CREATE INDEX IF NOT EXISTS idx_hangul_writing_progress_user ON hangul_writing_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_hangul_writing_progress_character ON hangul_writing_progress(character_id);

COMMENT ON TABLE hangul_writing_progress IS '쓰기 연습 진도';
COMMENT ON COLUMN hangul_writing_progress.average_accuracy IS '평균 정확도 (0-100)';
COMMENT ON COLUMN hangul_writing_progress.best_accuracy IS '최고 정확도 (0-100)';

-- ==================== Discrimination Practice Progress Table ====================
CREATE TABLE IF NOT EXISTS hangul_discrimination_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    group_id INTEGER NOT NULL REFERENCES hangul_similar_sound_groups(id) ON DELETE CASCADE,
    total_attempts INTEGER DEFAULT 0,
    correct_attempts INTEGER DEFAULT 0,
    accuracy_percent DECIMAL(5, 2) DEFAULT 0,
    best_streak INTEGER DEFAULT 0,
    last_practiced TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, group_id)
);

CREATE INDEX IF NOT EXISTS idx_hangul_disc_progress_user ON hangul_discrimination_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_hangul_disc_progress_group ON hangul_discrimination_progress(group_id);

COMMENT ON TABLE hangul_discrimination_progress IS '소리 구분 훈련 진도';

-- ==================== Pronunciation Attempt Records ====================
CREATE TABLE IF NOT EXISTS hangul_pronunciation_attempts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    character_id INTEGER NOT NULL REFERENCES hangul_characters(id) ON DELETE CASCADE,
    recording_url TEXT,
    self_rating VARCHAR(20) CHECK (self_rating IN ('accurate', 'almost', 'needs_practice')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_hangul_pronunciation_user ON hangul_pronunciation_attempts(user_id);
CREATE INDEX IF NOT EXISTS idx_hangul_pronunciation_character ON hangul_pronunciation_attempts(character_id);
CREATE INDEX IF NOT EXISTS idx_hangul_pronunciation_date ON hangul_pronunciation_attempts(created_at);

COMMENT ON TABLE hangul_pronunciation_attempts IS '발음 녹음 기록 (쉐도잉 연습)';
COMMENT ON COLUMN hangul_pronunciation_attempts.self_rating IS '자기 평가 (accurate/almost/needs_practice)';

-- ==================== Triggers ====================

CREATE TRIGGER update_hangul_pronunciation_guides_updated_at
    BEFORE UPDATE ON hangul_pronunciation_guides
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hangul_syllables_updated_at
    BEFORE UPDATE ON hangul_syllables
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hangul_similar_sound_groups_updated_at
    BEFORE UPDATE ON hangul_similar_sound_groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hangul_writing_progress_updated_at
    BEFORE UPDATE ON hangul_writing_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_hangul_discrimination_progress_updated_at
    BEFORE UPDATE ON hangul_discrimination_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==================== Seed Similar Sound Groups ====================
INSERT INTO hangul_similar_sound_groups (group_name, group_name_ko, description, description_ko, category, character_ids, difficulty_level) VALUES
    ('ㄱ/ㅋ/ㄲ', '기역 계열', 'Plain/Aspirated/Tense velar stops', '평음/격음/경음', 'consonant', ARRAY[1, 15, 16], 3),
    ('ㄷ/ㅌ/ㄸ', '디귿 계열', 'Plain/Aspirated/Tense alveolar stops', '평음/격음/경음', 'consonant', ARRAY[4, 17, 18], 3),
    ('ㅂ/ㅍ/ㅃ', '비읍 계열', 'Plain/Aspirated/Tense bilabial stops', '평음/격음/경음', 'consonant', ARRAY[7, 19, 20], 3),
    ('ㅈ/ㅊ/ㅉ', '지읒 계열', 'Plain/Aspirated/Tense affricates', '평음/격음/경음', 'consonant', ARRAY[13, 14, 21], 3),
    ('ㅅ/ㅆ', '시옷 계열', 'Plain/Tense fricatives', '평음/경음', 'consonant', ARRAY[10, 22], 2),
    ('ㅓ/ㅗ', '어/오', 'Unrounded vs Rounded mid vowels', '입 모양이 비슷함', 'vowel', ARRAY[25, 29], 2),
    ('ㅡ/ㅜ', '으/우', 'Unrounded vs Rounded close vowels', '입술 모양 차이', 'vowel', ARRAY[39, 33], 2),
    ('ㅐ/ㅔ', '애/에', 'Similar front mid vowels', '현대 한국어에서 거의 동일', 'vowel', ARRAY[24, 26], 1)
ON CONFLICT DO NOTHING;

-- ==================== End of Migration ====================
