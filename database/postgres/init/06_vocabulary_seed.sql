-- ==================== Vocabulary Multi-Language Seed Data ====================
-- Version: 1.0
-- Date: 2026-02-04
-- Description: Seed vocabulary translations for all 6 supported languages
-- Requires: 01_schema.sql, 02_seed.sql, migrations/001_add_translations.sql
-- ==================================================================================

-- ==================== English Translations ====================
INSERT INTO vocabulary_translations (vocabulary_id, language_code, translation, pronunciation, example_sentence, notes) VALUES
-- Greetings
(1, 'en', 'Hello', 'həˈloʊ', 'Hello, nice to meet you.', 'Formal greeting, used any time of day'),
(2, 'en', 'Thank you', 'θæŋk juː', 'Thank you for your help.', 'Formal expression of gratitude'),
(3, 'en', 'I''m sorry', 'aɪm ˈsɒri', 'I''m sorry for being late.', 'Formal apology'),
-- Basic nouns with Hanja
(4, 'en', 'student', 'ˈstjuːdənt', 'I am a college student.', 'Sino-Korean word, 100% similar to Chinese'),
(5, 'en', 'teacher', 'ˈtiːtʃər', 'Our teacher is kind.', 'Honorific form used for teachers'),
(6, 'en', 'school', 'skuːl', 'I go to school.', 'Sino-Korean word'),
(7, 'en', 'library', 'ˈlaɪbreri', 'I study at the library.', 'Sino-Korean word'),
(8, 'en', 'friend', 'frend', 'I meet a friend.', NULL),
-- Family terms
(9, 'en', 'family', 'ˈfæməli', 'My family has four people.', 'Sino-Korean word'),
(10, 'en', 'mother', 'ˈmʌðər', 'Mother is good at cooking.', 'Native Korean word'),
(11, 'en', 'father', 'ˈfɑːðər', 'Father is an office worker.', 'Native Korean word'),
-- Common verbs
(12, 'en', 'to eat', 'tuː iːt', 'I eat rice.', NULL),
(13, 'en', 'to drink', 'tuː drɪŋk', 'I drink water.', NULL),
(14, 'en', 'to go', 'tuː ɡoʊ', 'I go to school.', NULL),
(15, 'en', 'to come', 'tuː kʌm', 'A friend comes.', NULL),
-- Common adjectives
(16, 'en', 'good', 'ɡʊd', 'The weather is good.', NULL),
(17, 'en', 'big', 'bɪɡ', 'The house is big.', NULL),
(18, 'en', 'small', 'smɔːl', 'The room is small.', NULL),
-- Numbers
(19, 'en', 'one', 'wʌn', 'Please give me one apple.', 'Native Korean number'),
(20, 'en', 'two', 'tuː', 'I have two friends.', 'Native Korean number')
ON CONFLICT (vocabulary_id, language_code) DO UPDATE SET
    translation = EXCLUDED.translation,
    pronunciation = EXCLUDED.pronunciation,
    example_sentence = EXCLUDED.example_sentence,
    notes = EXCLUDED.notes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Japanese Translations ====================
INSERT INTO vocabulary_translations (vocabulary_id, language_code, translation, pronunciation, example_sentence, notes) VALUES
-- Greetings
(1, 'ja', 'こんにちは', 'konnichiwa', 'こんにちは、お会いできて嬉しいです。', '丁寧な挨拶'),
(2, 'ja', 'ありがとうございます', 'arigatou gozaimasu', '助けてくれてありがとうございます。', '丁寧な感謝表現'),
(3, 'ja', 'すみません', 'sumimasen', '遅れてすみません。', '丁寧な謝罪'),
-- Basic nouns
(4, 'ja', '学生', 'gakusei', '私は大学生です。', '漢字語、中国語と100%類似'),
(5, 'ja', '先生', 'sensei', '先生は親切です。', '敬称として使用'),
(6, 'ja', '学校', 'gakkou', '学校に行きます。', '漢字語'),
(7, 'ja', '図書館', 'toshokan', '図書館で勉強します。', '漢字語'),
(8, 'ja', '友達', 'tomodachi', '友達に会います。', NULL),
-- Family terms
(9, 'ja', '家族', 'kazoku', '私の家族は4人です。', '漢字語'),
(10, 'ja', 'お母さん', 'okaasan', 'お母さんは料理が上手です。', '固有語'),
(11, 'ja', 'お父さん', 'otousan', 'お父さんは会社員です。', '固有語'),
-- Common verbs
(12, 'ja', '食べる', 'taberu', 'ご飯を食べます。', NULL),
(13, 'ja', '飲む', 'nomu', '水を飲みます。', NULL),
(14, 'ja', '行く', 'iku', '学校に行きます。', NULL),
(15, 'ja', '来る', 'kuru', '友達が来ます。', NULL),
-- Common adjectives
(16, 'ja', '良い', 'yoi/ii', '天気がいいです。', NULL),
(17, 'ja', '大きい', 'ookii', '家が大きいです。', NULL),
(18, 'ja', '小さい', 'chiisai', '部屋が小さいです。', NULL),
-- Numbers
(19, 'ja', '一つ', 'hitotsu', 'りんごを一つください。', '固有数詞'),
(20, 'ja', '二つ', 'futatsu', '友達が二人います。', '固有数詞')
ON CONFLICT (vocabulary_id, language_code) DO UPDATE SET
    translation = EXCLUDED.translation,
    pronunciation = EXCLUDED.pronunciation,
    example_sentence = EXCLUDED.example_sentence,
    notes = EXCLUDED.notes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Spanish Translations ====================
INSERT INTO vocabulary_translations (vocabulary_id, language_code, translation, pronunciation, example_sentence, notes) VALUES
-- Greetings
(1, 'es', 'Hola', 'ola', 'Hola, encantado de conocerte.', 'Saludo formal'),
(2, 'es', 'Gracias', 'grasjas', 'Gracias por tu ayuda.', 'Expresión formal de gratitud'),
(3, 'es', 'Lo siento', 'lo sjento', 'Lo siento por llegar tarde.', 'Disculpa formal'),
-- Basic nouns
(4, 'es', 'estudiante', 'estuðjante', 'Soy estudiante universitario.', 'Palabra sino-coreana'),
(5, 'es', 'profesor/a', 'profesor', 'Nuestro profesor es amable.', 'Forma honorífica'),
(6, 'es', 'escuela', 'eskwela', 'Voy a la escuela.', 'Palabra sino-coreana'),
(7, 'es', 'biblioteca', 'biβlioteka', 'Estudio en la biblioteca.', 'Palabra sino-coreana'),
(8, 'es', 'amigo/a', 'amiɣo', 'Me encuentro con un amigo.', NULL),
-- Family terms
(9, 'es', 'familia', 'familja', 'Mi familia tiene cuatro personas.', 'Palabra sino-coreana'),
(10, 'es', 'madre', 'maðre', 'Mamá cocina bien.', 'Palabra nativa coreana'),
(11, 'es', 'padre', 'paðre', 'Papá es oficinista.', 'Palabra nativa coreana'),
-- Common verbs
(12, 'es', 'comer', 'komer', 'Como arroz.', NULL),
(13, 'es', 'beber', 'beβer', 'Bebo agua.', NULL),
(14, 'es', 'ir', 'ir', 'Voy a la escuela.', NULL),
(15, 'es', 'venir', 'benir', 'Un amigo viene.', NULL),
-- Common adjectives
(16, 'es', 'bueno', 'bweno', 'El clima está bueno.', NULL),
(17, 'es', 'grande', 'grande', 'La casa es grande.', NULL),
(18, 'es', 'pequeño', 'pekeɲo', 'La habitación es pequeña.', NULL),
-- Numbers
(19, 'es', 'uno', 'uno', 'Dame una manzana, por favor.', 'Número nativo coreano'),
(20, 'es', 'dos', 'dos', 'Tengo dos amigos.', 'Número nativo coreano')
ON CONFLICT (vocabulary_id, language_code) DO UPDATE SET
    translation = EXCLUDED.translation,
    pronunciation = EXCLUDED.pronunciation,
    example_sentence = EXCLUDED.example_sentence,
    notes = EXCLUDED.notes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Korean Translations (for reference) ====================
INSERT INTO vocabulary_translations (vocabulary_id, language_code, translation, pronunciation, example_sentence, notes) VALUES
-- Greetings
(1, 'ko', '안녕하세요', 'an-nyeong-ha-se-yo', '안녕하세요? 만나서 반갑습니다.', '격식체 인사'),
(2, 'ko', '감사합니다', 'gam-sa-ham-ni-da', '도와주셔서 감사합니다.', '격식체 감사 표현'),
(3, 'ko', '죄송합니다', 'joe-song-ham-ni-da', '늦어서 죄송합니다.', '격식체 사과'),
-- Basic nouns
(4, 'ko', '학생', 'hak-saeng', '저는 대학생입니다.', '한자어'),
(5, 'ko', '선생님', 'seon-saeng-nim', '우리 선생님은 친절합니다.', '존칭'),
(6, 'ko', '학교', 'hak-gyo', '학교에 갑니다.', '한자어'),
(7, 'ko', '도서관', 'do-seo-gwan', '도서관에서 공부합니다.', '한자어'),
(8, 'ko', '친구', 'chin-gu', '친구를 만납니다.', NULL),
-- Family terms
(9, 'ko', '가족', 'ga-jok', '우리 가족은 네 명입니다.', '한자어'),
(10, 'ko', '어머니', 'eo-meo-ni', '어머니는 요리를 잘하십니다.', '고유어'),
(11, 'ko', '아버지', 'a-beo-ji', '아버지는 회사원입니다.', '고유어'),
-- Common verbs
(12, 'ko', '먹다', 'meok-da', '밥을 먹습니다.', NULL),
(13, 'ko', '마시다', 'ma-si-da', '물을 마십니다.', NULL),
(14, 'ko', '가다', 'ga-da', '학교에 갑니다.', NULL),
(15, 'ko', '오다', 'o-da', '친구가 옵니다.', NULL),
-- Common adjectives
(16, 'ko', '좋다', 'jo-ta', '날씨가 좋습니다.', NULL),
(17, 'ko', '크다', 'keu-da', '집이 큽니다.', NULL),
(18, 'ko', '작다', 'jak-da', '방이 작습니다.', NULL),
-- Numbers
(19, 'ko', '하나', 'ha-na', '사과 하나 주세요.', '고유어 수사'),
(20, 'ko', '둘', 'dul', '친구가 둘 있습니다.', '고유어 수사')
ON CONFLICT (vocabulary_id, language_code) DO UPDATE SET
    translation = EXCLUDED.translation,
    pronunciation = EXCLUDED.pronunciation,
    example_sentence = EXCLUDED.example_sentence,
    notes = EXCLUDED.notes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Verify Translations ====================
DO $$
BEGIN
    RAISE NOTICE '==================== Vocabulary Translations Summary ====================';
    RAISE NOTICE 'Total translations: %', (SELECT COUNT(*) FROM vocabulary_translations);
    RAISE NOTICE 'By language:';
    RAISE NOTICE '  - Korean (ko): %', (SELECT COUNT(*) FROM vocabulary_translations WHERE language_code = 'ko');
    RAISE NOTICE '  - English (en): %', (SELECT COUNT(*) FROM vocabulary_translations WHERE language_code = 'en');
    RAISE NOTICE '  - Japanese (ja): %', (SELECT COUNT(*) FROM vocabulary_translations WHERE language_code = 'ja');
    RAISE NOTICE '  - Spanish (es): %', (SELECT COUNT(*) FROM vocabulary_translations WHERE language_code = 'es');
    RAISE NOTICE '  - Chinese Simplified (zh): %', (SELECT COUNT(*) FROM vocabulary_translations WHERE language_code = 'zh');
    RAISE NOTICE '  - Chinese Traditional (zh_TW): %', (SELECT COUNT(*) FROM vocabulary_translations WHERE language_code = 'zh_TW');
    RAISE NOTICE '======================================================================';
END $$;

-- ==================== End of Vocabulary Seed ====================
