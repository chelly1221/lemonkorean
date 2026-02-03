-- ==================== Migration: Multi-Language Content Support ====================
-- Version: 001
-- Description: Add translation tables for internationalization
-- Date: 2026-02-03
--
-- This migration transforms the app from Chinese-speaker-focused to fully international
-- by adding separate translation tables for lessons, vocabulary, and grammar.
-- ==================================================================================

-- ==================== Languages Reference Table ====================
CREATE TABLE IF NOT EXISTS languages (
    code VARCHAR(10) PRIMARY KEY,
    name_native VARCHAR(100) NOT NULL,
    name_english VARCHAR(100) NOT NULL,
    name_korean VARCHAR(100) NOT NULL,
    is_active BOOLEAN DEFAULT true,
    display_order INTEGER DEFAULT 99,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert supported languages
INSERT INTO languages (code, name_native, name_english, name_korean, is_active, display_order) VALUES
    ('ko', '한국어', 'Korean', '한국어', true, 1),
    ('en', 'English', 'English', '영어', true, 2),
    ('es', 'Español', 'Spanish', '스페인어', true, 3),
    ('ja', '日本語', 'Japanese', '일본어', true, 4),
    ('zh', '中文(简体)', 'Chinese Simplified', '중국어(간체)', true, 5),
    ('zh_TW', '中文(繁體)', 'Chinese Traditional', '중국어(번체)', true, 6)
ON CONFLICT (code) DO NOTHING;

COMMENT ON TABLE languages IS '지원 언어 참조 테이블';

-- ==================== Lesson Translations Table ====================
CREATE TABLE IF NOT EXISTS lesson_translations (
    id SERIAL PRIMARY KEY,
    lesson_id INTEGER NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    language_code VARCHAR(10) NOT NULL REFERENCES languages(code) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(lesson_id, language_code)
);

CREATE INDEX idx_lesson_translations_lesson ON lesson_translations(lesson_id);
CREATE INDEX idx_lesson_translations_language ON lesson_translations(language_code);
CREATE INDEX idx_lesson_translations_lesson_language ON lesson_translations(lesson_id, language_code);

COMMENT ON TABLE lesson_translations IS '레슨 다국어 번역 테이블';
COMMENT ON COLUMN lesson_translations.language_code IS '언어 코드 (ko, en, es, ja, zh, zh_TW)';

-- ==================== Vocabulary Translations Table ====================
CREATE TABLE IF NOT EXISTS vocabulary_translations (
    id SERIAL PRIMARY KEY,
    vocabulary_id INTEGER NOT NULL REFERENCES vocabulary(id) ON DELETE CASCADE,
    language_code VARCHAR(10) NOT NULL REFERENCES languages(code) ON DELETE CASCADE,
    translation VARCHAR(200) NOT NULL,
    pronunciation VARCHAR(200),
    example_sentence TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(vocabulary_id, language_code)
);

CREATE INDEX idx_vocabulary_translations_vocab ON vocabulary_translations(vocabulary_id);
CREATE INDEX idx_vocabulary_translations_language ON vocabulary_translations(language_code);
CREATE INDEX idx_vocabulary_translations_vocab_language ON vocabulary_translations(vocabulary_id, language_code);
CREATE INDEX idx_vocabulary_translations_translation ON vocabulary_translations USING gin(translation gin_trgm_ops);

COMMENT ON TABLE vocabulary_translations IS '단어 다국어 번역 테이블';
COMMENT ON COLUMN vocabulary_translations.translation IS '해당 언어로 번역된 단어 뜻';
COMMENT ON COLUMN vocabulary_translations.pronunciation IS '해당 언어의 발음 표기 (영어: IPA, 중국어: 병음 등)';

-- ==================== Grammar Translations Table ====================
CREATE TABLE IF NOT EXISTS grammar_translations (
    id SERIAL PRIMARY KEY,
    grammar_id INTEGER NOT NULL REFERENCES grammar_rules(id) ON DELETE CASCADE,
    language_code VARCHAR(10) NOT NULL REFERENCES languages(code) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    language_comparison TEXT,
    usage_notes TEXT,
    common_mistakes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(grammar_id, language_code)
);

CREATE INDEX idx_grammar_translations_grammar ON grammar_translations(grammar_id);
CREATE INDEX idx_grammar_translations_language ON grammar_translations(language_code);
CREATE INDEX idx_grammar_translations_grammar_language ON grammar_translations(grammar_id, language_code);

COMMENT ON TABLE grammar_translations IS '문법 다국어 번역 테이블';
COMMENT ON COLUMN grammar_translations.language_comparison IS '해당 언어와의 비교 설명';

-- ==================== Triggers for updated_at ====================
CREATE TRIGGER update_lesson_translations_updated_at BEFORE UPDATE ON lesson_translations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_vocabulary_translations_updated_at BEFORE UPDATE ON vocabulary_translations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_grammar_translations_updated_at BEFORE UPDATE ON grammar_translations
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==================== Migrate Existing Chinese Data ====================

-- Migrate lesson translations (Chinese Simplified)
INSERT INTO lesson_translations (lesson_id, language_code, title, description)
SELECT id, 'zh', title_zh, description_zh
FROM lessons
WHERE title_zh IS NOT NULL AND title_zh != ''
ON CONFLICT (lesson_id, language_code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;

-- Also insert Korean titles
INSERT INTO lesson_translations (lesson_id, language_code, title, description)
SELECT id, 'ko', title_ko, description_ko
FROM lessons
WHERE title_ko IS NOT NULL AND title_ko != ''
ON CONFLICT (lesson_id, language_code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;

-- Copy zh to zh_TW (Traditional Chinese conversion handled at API level)
INSERT INTO lesson_translations (lesson_id, language_code, title, description)
SELECT id, 'zh_TW', title_zh, description_zh
FROM lessons
WHERE title_zh IS NOT NULL AND title_zh != ''
ON CONFLICT (lesson_id, language_code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    updated_at = CURRENT_TIMESTAMP;

-- Migrate vocabulary translations (Chinese Simplified)
INSERT INTO vocabulary_translations (vocabulary_id, language_code, translation, pronunciation, example_sentence, notes)
SELECT id, 'zh', chinese, pinyin, example_sentence_zh, notes
FROM vocabulary
WHERE chinese IS NOT NULL AND chinese != ''
ON CONFLICT (vocabulary_id, language_code) DO UPDATE SET
    translation = EXCLUDED.translation,
    pronunciation = EXCLUDED.pronunciation,
    example_sentence = EXCLUDED.example_sentence,
    notes = EXCLUDED.notes,
    updated_at = CURRENT_TIMESTAMP;

-- Copy zh vocabulary to zh_TW
INSERT INTO vocabulary_translations (vocabulary_id, language_code, translation, pronunciation, example_sentence, notes)
SELECT id, 'zh_TW', chinese, pinyin, example_sentence_zh, notes
FROM vocabulary
WHERE chinese IS NOT NULL AND chinese != ''
ON CONFLICT (vocabulary_id, language_code) DO UPDATE SET
    translation = EXCLUDED.translation,
    pronunciation = EXCLUDED.pronunciation,
    example_sentence = EXCLUDED.example_sentence,
    notes = EXCLUDED.notes,
    updated_at = CURRENT_TIMESTAMP;

-- Migrate grammar translations (Chinese Simplified)
INSERT INTO grammar_translations (grammar_id, language_code, name, description, language_comparison, usage_notes, common_mistakes)
SELECT id, 'zh', name_zh, description, chinese_comparison, usage_notes, common_mistakes
FROM grammar_rules
WHERE name_zh IS NOT NULL AND name_zh != ''
ON CONFLICT (grammar_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    language_comparison = EXCLUDED.language_comparison,
    usage_notes = EXCLUDED.usage_notes,
    common_mistakes = EXCLUDED.common_mistakes,
    updated_at = CURRENT_TIMESTAMP;

-- Also insert Korean grammar names
INSERT INTO grammar_translations (grammar_id, language_code, name, description, language_comparison, usage_notes, common_mistakes)
SELECT id, 'ko', name_ko, description, NULL, usage_notes, common_mistakes
FROM grammar_rules
WHERE name_ko IS NOT NULL AND name_ko != ''
ON CONFLICT (grammar_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    usage_notes = EXCLUDED.usage_notes,
    common_mistakes = EXCLUDED.common_mistakes,
    updated_at = CURRENT_TIMESTAMP;

-- Copy zh grammar to zh_TW
INSERT INTO grammar_translations (grammar_id, language_code, name, description, language_comparison, usage_notes, common_mistakes)
SELECT id, 'zh_TW', name_zh, description, chinese_comparison, usage_notes, common_mistakes
FROM grammar_rules
WHERE name_zh IS NOT NULL AND name_zh != ''
ON CONFLICT (grammar_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    language_comparison = EXCLUDED.language_comparison,
    usage_notes = EXCLUDED.usage_notes,
    common_mistakes = EXCLUDED.common_mistakes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Update User Language Constraint ====================
-- Expand language_preference to support all 6 languages
ALTER TABLE users
    DROP CONSTRAINT IF EXISTS users_language_preference_check;

ALTER TABLE users
    ADD CONSTRAINT users_language_preference_check
    CHECK (language_preference IN ('ko', 'en', 'es', 'ja', 'zh', 'zh_TW'));

-- Update default (keep 'zh' as default for backwards compatibility)
-- For new international users, the app will determine language from device locale

COMMENT ON COLUMN users.language_preference IS '콘텐츠 언어 (ko, en, es, ja, zh, zh_TW)';

-- ==================== Verification Queries ====================
-- Run these after migration to verify data integrity

-- Check language table
-- SELECT * FROM languages ORDER BY display_order;

-- Check lesson translations count
-- SELECT language_code, COUNT(*) as count FROM lesson_translations GROUP BY language_code;

-- Check vocabulary translations count
-- SELECT language_code, COUNT(*) as count FROM vocabulary_translations GROUP BY language_code;

-- Check grammar translations count
-- SELECT language_code, COUNT(*) as count FROM grammar_translations GROUP BY language_code;

-- ==================== End of Migration ====================
