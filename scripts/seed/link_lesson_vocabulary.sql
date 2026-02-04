-- Link vocabulary words to lessons
-- Distribute 48 vocabulary words across 13 lessons (3-4 words per lesson)

-- Existing vocabulary IDs: 1,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60

DO $$
BEGIN
    -- Clear existing associations
    DELETE FROM lesson_vocabulary;

    -- Lesson 1: 한글 기초 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (1, 1, true, 1),   -- 안녕하세요
    (1, 20, true, 2),  -- 안녕히 가세요
    (1, 21, true, 3),  -- 미안합니다
    (1, 22, true, 4);  -- 환영합니다

    -- Lesson 2: 인사하기 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (2, 18, true, 1),  -- 네
    (2, 19, true, 2),  -- 아니요
    (2, 23, true, 3),
    (2, 24, true, 4);

    -- Lesson 3: 숫자 배우기 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (3, 25, true, 1),
    (3, 26, true, 2),
    (3, 27, true, 3),
    (3, 28, true, 4);

    -- Lesson 4: 자기소개 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (4, 29, true, 1),
    (4, 30, true, 2),
    (4, 31, true, 3),
    (4, 32, true, 4);

    -- Lesson 5: 가족 소개 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (5, 33, true, 1),
    (5, 34, true, 2),
    (5, 35, true, 3),
    (5, 36, true, 4);

    -- Lesson 6: 날씨와 계절 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (6, 37, true, 1),
    (6, 38, true, 2),
    (6, 39, true, 3),
    (6, 40, true, 4);

    -- Lesson 7: 시간 말하기 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (7, 41, true, 1),
    (7, 42, true, 2),
    (7, 43, true, 3),
    (7, 44, true, 4);

    -- Lesson 8: 음식 주문하기 (4 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (8, 45, true, 1),
    (8, 46, true, 2),
    (8, 47, true, 3),
    (8, 48, true, 4);

    -- Lesson 9: 쇼핑하기 (3 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (9, 49, true, 1),
    (9, 50, true, 2),
    (9, 51, true, 3);

    -- Lesson 10: 길 찾기 (3 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (10, 52, true, 1),
    (10, 53, true, 2),
    (10, 54, true, 3);

    -- Lesson 11: 취미와 관심사 (3 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (11, 55, true, 1),
    (11, 56, true, 2),
    (11, 57, true, 3);

    -- Lesson 12: 일상생활 (3 words)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (12, 58, true, 1),
    (12, 59, true, 2),
    (12, 60, true, 3);

    -- Lesson 13: 전화 통화 (4 words - add some vocabulary from earlier lessons)
    INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
    (13, 14, true, 1),  -- 사과
    (13, 15, true, 2),  -- 먹다
    (13, 16, true, 3),  -- 아름답다
    (13, 17, true, 4);  -- 빨리

    RAISE NOTICE '==================== Lesson-Vocabulary Linking Summary ====================';
    RAISE NOTICE 'Total associations created: %', (SELECT COUNT(*) FROM lesson_vocabulary);
    RAISE NOTICE 'Lessons with vocabulary: %', (SELECT COUNT(DISTINCT lesson_id) FROM lesson_vocabulary);
    RAISE NOTICE '===========================================================================';

END $$;
