-- ==================== Lemon Korean Seed Data ====================
-- Test data for development and testing
-- 테스트 및 개발용 시드 데이터

-- ==================== Users ====================

-- Admin user (email: admin@lemon.com, password: admin123)
-- bcrypt hash for "admin123": $2b$10$rKG3YK3qF6gF8mQBH0KqJ.nH6vXYYxJXqXZ0XqXqXqXqXqXqXqXqW
INSERT INTO users (email, password_hash, name, language_preference, subscription_type, is_active, email_verified, created_at) VALUES
('admin@lemon.com', '$2b$10$rKG3YK3qF6gF8mQBH0KqJ.nH6vXYYxJXqXZ0XqXqXqXqXqXqXqXqW', '管理员', 'zh', 'lifetime', true, true, CURRENT_TIMESTAMP);

-- Regular users (password: user123)
-- bcrypt hash for "user123": $2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
INSERT INTO users (email, password_hash, name, language_preference, subscription_type, is_active, email_verified, created_at, last_login) VALUES
('zhang.wei@example.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '张伟', 'zh', 'premium', true, true, CURRENT_TIMESTAMP - INTERVAL '30 days', CURRENT_TIMESTAMP - INTERVAL '1 day'),
('li.na@example.com', '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', '李娜', 'zh', 'free', true, true, CURRENT_TIMESTAMP - INTERVAL '15 days', CURRENT_TIMESTAMP - INTERVAL '3 hours');

-- Update subscription expiry for premium user
UPDATE users SET subscription_expires_at = CURRENT_TIMESTAMP + INTERVAL '1 year' WHERE email = 'zhang.wei@example.com';

-- ==================== Lessons (Level 0 - Hangeul Learning) ====================

INSERT INTO lessons (
    level, week, order_num, title_ko, title_zh, description_ko, description_zh,
    duration_minutes, difficulty, thumbnail_url, version, status, published_at, tags
) VALUES
-- Lesson 1: Basic Consonants
(
    0, 1, 1,
    '한글 기본 자음',
    '韩文基本辅音',
    '한글의 기본 자음 14개를 배웁니다. ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ',
    '学习韩文的14个基本辅音。掌握发音规则和书写方法。',
    25, 'beginner',
    '/media/thumbnails/lesson-0-1-consonants.jpg',
    '1.0.0', 'published',
    CURRENT_TIMESTAMP - INTERVAL '60 days',
    ARRAY['한글', '자음', 'hangeul', 'consonants']
),
-- Lesson 2: Basic Vowels
(
    0, 1, 2,
    '한글 기본 모음',
    '韩文基本元音',
    '한글의 기본 모음 10개를 배웁니다. ㅏ, ㅑ, ㅓ, ㅕ, ㅗ, ㅛ, ㅜ, ㅠ, ㅡ, ㅣ',
    '学习韩文的10个基本元音。通过天地人原理理解元音构造。',
    25, 'beginner',
    '/media/thumbnails/lesson-0-2-vowels.jpg',
    '1.0.0', 'published',
    CURRENT_TIMESTAMP - INTERVAL '58 days',
    ARRAY['한글', '모음', 'hangeul', 'vowels']
),
-- Lesson 3: Combining Characters
(
    0, 1, 3,
    '한글 조합 연습',
    '韩文组合练习',
    '자음과 모음을 조합하여 글자를 만드는 연습을 합니다. 받침이 없는 글자부터 시작합니다.',
    '练习组合辅音和元音形成完整的音节。从无收音的字开始。',
    30, 'beginner',
    '/media/thumbnails/lesson-0-3-combinations.jpg',
    '1.0.0', 'published',
    CURRENT_TIMESTAMP - INTERVAL '56 days',
    ARRAY['한글', '조합', 'hangeul', 'combination']
);

-- ==================== Vocabulary (Basic Korean Words) ====================

INSERT INTO vocabulary (
    korean, hanja, chinese, pinyin, part_of_speech, level, similarity_score,
    image_url, audio_url_male, audio_url_female, example_sentence_ko, example_sentence_zh
) VALUES
-- Greetings
('안녕하세요', NULL, '你好', 'nǐ hǎo', 'interjection', 1, 0.0,
 '/media/images/vocab/hello.jpg',
 '/media/audio/male/hello.mp3',
 '/media/audio/female/hello.mp3',
 '안녕하세요? 만나서 반갑습니다.',
 '你好，很高兴见到你。'),

('감사합니다', '感謝', '谢谢', 'xièxie', 'interjection', 1, 0.85,
 '/media/images/vocab/thanks.jpg',
 '/media/audio/male/thanks.mp3',
 '/media/audio/female/thanks.mp3',
 '도와주셔서 감사합니다.',
 '谢谢你的帮助。'),

('죄송합니다', NULL, '对不起', 'duìbuqǐ', 'interjection', 1, 0.0,
 '/media/images/vocab/sorry.jpg',
 '/media/audio/male/sorry.mp3',
 '/media/audio/female/sorry.mp3',
 '늦어서 죄송합니다.',
 '对不起，我来晚了。'),

-- Basic nouns with Hanja
('학생', '學生', '学生', 'xuésheng', 'noun', 1, 1.0,
 '/media/images/vocab/student.jpg',
 '/media/audio/male/student.mp3',
 '/media/audio/female/student.mp3',
 '저는 대학생입니다.',
 '我是大学生。'),

('선생님', '先生', '老师', 'lǎoshī', 'noun', 1, 0.65,
 '/media/images/vocab/teacher.jpg',
 '/media/audio/male/teacher.mp3',
 '/media/audio/female/teacher.mp3',
 '우리 선생님은 친절합니다.',
 '我们的老师很亲切。'),

('학교', '學校', '学校', 'xuéxiào', 'noun', 1, 1.0,
 '/media/images/vocab/school.jpg',
 '/media/audio/male/school.mp3',
 '/media/audio/female/school.mp3',
 '학교에 갑니다.',
 '去学校。'),

('도서관', '圖書館', '图书馆', 'túshūguǎn', 'noun', 1, 1.0,
 '/media/images/vocab/library.jpg',
 '/media/audio/male/library.mp3',
 '/media/audio/female/library.mp3',
 '도서관에서 공부합니다.',
 '在图书馆学习。'),

('친구', '親舊', '朋友', 'péngyou', 'noun', 1, 0.45,
 '/media/images/vocab/friend.jpg',
 '/media/audio/male/friend.mp3',
 '/media/audio/female/friend.mp3',
 '친구를 만납니다.',
 '见朋友。'),

-- Family terms
('가족', '家族', '家人', 'jiārén', 'noun', 1, 0.90,
 '/media/images/vocab/family.jpg',
 '/media/audio/male/family.mp3',
 '/media/audio/female/family.mp3',
 '우리 가족은 네 명입니다.',
 '我们家有四口人。'),

('어머니', NULL, '妈妈', 'māma', 'noun', 1, 0.0,
 '/media/images/vocab/mother.jpg',
 '/media/audio/male/mother.mp3',
 '/media/audio/female/mother.mp3',
 '어머니는 요리를 잘하십니다.',
 '妈妈很会做菜。'),

('아버지', NULL, '爸爸', 'bàba', 'noun', 1, 0.0,
 '/media/images/vocab/father.jpg',
 '/media/audio/male/father.mp3',
 '/media/audio/female/father.mp3',
 '아버지는 회사원입니다.',
 '爸爸是公司职员。'),

-- Common verbs
('먹다', NULL, '吃', 'chī', 'verb', 1, 0.0,
 '/media/images/vocab/eat.jpg',
 '/media/audio/male/eat.mp3',
 '/media/audio/female/eat.mp3',
 '밥을 먹습니다.',
 '吃饭。'),

('마시다', NULL, '喝', 'hē', 'verb', 1, 0.0,
 '/media/images/vocab/drink.jpg',
 '/media/audio/male/drink.mp3',
 '/media/audio/female/drink.mp3',
 '물을 마십니다.',
 '喝水。'),

('가다', NULL, '去', 'qù', 'verb', 1, 0.0,
 '/media/images/vocab/go.jpg',
 '/media/audio/male/go.mp3',
 '/media/audio/female/go.mp3',
 '학교에 갑니다.',
 '去学校。'),

('오다', NULL, '来', 'lái', 'verb', 1, 0.0,
 '/media/images/vocab/come.jpg',
 '/media/audio/male/come.mp3',
 '/media/audio/female/come.mp3',
 '친구가 옵니다.',
 '朋友来了。'),

-- Common adjectives
('좋다', NULL, '好', 'hǎo', 'adjective', 1, 0.0,
 '/media/images/vocab/good.jpg',
 '/media/audio/male/good.mp3',
 '/media/audio/female/good.mp3',
 '날씨가 좋습니다.',
 '天气很好。'),

('크다', NULL, '大', 'dà', 'adjective', 1, 0.0,
 '/media/images/vocab/big.jpg',
 '/media/audio/male/big.mp3',
 '/media/audio/female/big.mp3',
 '집이 큽니다.',
 '房子很大。'),

('작다', NULL, '小', 'xiǎo', 'adjective', 1, 0.0,
 '/media/images/vocab/small.jpg',
 '/media/audio/male/small.mp3',
 '/media/audio/female/small.mp3',
 '방이 작습니다.',
 '房间很小。'),

-- Numbers
('하나', NULL, '一', 'yī', 'noun', 1, 0.0,
 '/media/images/vocab/one.jpg',
 '/media/audio/male/one.mp3',
 '/media/audio/female/one.mp3',
 '사과 하나 주세요.',
 '请给我一个苹果。'),

('둘', NULL, '二', 'èr', 'noun', 1, 0.0,
 '/media/images/vocab/two.jpg',
 '/media/audio/male/two.mp3',
 '/media/audio/female/two.mp3',
 '친구가 둘 있습니다.',
 '我有两个朋友。');

-- ==================== Grammar Rules ====================

INSERT INTO grammar_rules (
    name_ko, name_zh, category, level, difficulty, description, chinese_comparison, examples, usage_notes, common_mistakes
) VALUES
-- Grammar 1: Subject particle
(
    '주격 조사: 이/가',
    '主格助词：이/가',
    '조사',
    1,
    'beginner',
    '주어를 나타내는 조사입니다. 받침이 있으면 "이", 없으면 "가"를 사용합니다.',
    '类似于中文的主语，但韩语必须使用助词标记。中文不需要助词。',
    '[
        {
            "ko": "친구가 옵니다.",
            "zh": "朋友来了。",
            "explanation": "친구(无收音) + 가"
        },
        {
            "ko": "학생이 공부합니다.",
            "zh": "学生在学习。",
            "explanation": "학생(有收音) + 이"
        },
        {
            "ko": "물이 차갑습니다.",
            "zh": "水很凉。",
            "explanation": "물(有收音) + 이"
        }
    ]'::jsonb,
    '새로운 정보나 대조할 때 주로 사용합니다. "은/는"과 구별해서 사용하세요.',
    '받침 유무를 확인하지 않고 사용하는 경우가 많습니다. 반드시 확인하세요.'
),

-- Grammar 2: Object particle
(
    '목적격 조사: 을/를',
    '宾格助词：을/를',
    '조사',
    1,
    'beginner',
    '목적어를 나타내는 조사입니다. 받침이 있으면 "을", 없으면 "를"을 사용합니다.',
    '类似于中文的宾语，但韩语必须使用助词标记。相当于中文的"把"字结构，但更常用。',
    '[
        {
            "ko": "밥을 먹습니다.",
            "zh": "吃饭。",
            "explanation": "밥(有收音) + 을"
        },
        {
            "ko": "물을 마십니다.",
            "zh": "喝水。",
            "explanation": "물(有收音) + 을"
        },
        {
            "ko": "책을 읽습니다.",
            "zh": "看书。",
            "explanation": "책(有收音) + 을"
        }
    ]'::jsonb,
    '동작의 대상이 되는 명사에 붙입니다.',
    '받침이 있어도 "를"을 사용하는 실수가 많습니다.'
),

-- Grammar 3: Topic particle
(
    '주제 조사: 은/는',
    '主题助词：은/는',
    '조사',
    1,
    'beginner',
    '주제를 나타내는 조사입니다. 받침이 있으면 "은", 없으면 "는"을 사용합니다.',
    '类似于中文的"关于...""至于..."。强调话题，不是新信息。',
    '[
        {
            "ko": "저는 학생입니다.",
            "zh": "我是学生。",
            "explanation": "저(无收音) + 는"
        },
        {
            "ko": "날씨는 좋습니다.",
            "zh": "天气很好。",
            "explanation": "날씨(无收音) + 는"
        },
        {
            "ko": "친구는 한국 사람입니다.",
            "zh": "朋友是韩国人。",
            "explanation": "친구(无收音) + 는"
        }
    ]'::jsonb,
    '이미 알려진 정보나 일반적인 사실을 말할 때 사용합니다. "이/가"와 구별이 중요합니다.',
    '"이/가"와 혼동하기 쉽습니다. 문맥에 따라 선택하세요.'
),

-- Grammar 4: Polite ending -습니다/ㅂ니다
(
    '격식체 종결어미: -습니다/ㅂ니다',
    '敬语终结词尾：-습니다/ㅂ니다',
    '종결어미',
    1,
    'beginner',
    '격식을 갖춘 존댓말 종결어미입니다. 동사/형용사 어간에 받침이 있으면 "-습니다", 없으면 "-ㅂ니다"를 사용합니다.',
    '类似于中文的"您""请"等敬语，但韩语必须改变动词词尾。非常正式的场合使用。',
    '[
        {
            "ko": "공부합니다.",
            "zh": "学习。",
            "explanation": "공부하다 → 공부하(无收音) + ㅂ니다"
        },
        {
            "ko": "먹습니다.",
            "zh": "吃。",
            "explanation": "먹다 → 먹(有收音) + 습니다"
        },
        {
            "ko": "좋습니다.",
            "zh": "好。",
            "explanation": "좋다 → 좋(有收音) + 습니다"
        }
    ]'::jsonb,
    '뉴스, 발표, 공식 석상에서 주로 사용합니다. 일상 대화에서는 "-아요/어요"를 더 많이 씁니다.',
    '어간의 받침 유무를 확인하지 않는 경우가 많습니다.'
),

-- Grammar 5: Location particle -에
(
    '처소 조사: -에',
    '处所助词：-에',
    '조사',
    1,
    'beginner',
    '장소나 시간을 나타낼 때 사용하는 조사입니다.',
    '类似于中文的"在""到""于"。表示地点或时间。',
    '[
        {
            "ko": "학교에 갑니다.",
            "zh": "去学校。",
            "explanation": "목적지를 나타냄"
        },
        {
            "ko": "집에 있습니다.",
            "zh": "在家。",
            "explanation": "위치를 나타냄"
        },
        {
            "ko": "9시에 만납니다.",
            "zh": "9点见面。",
            "explanation": "시간을 나타냄"
        }
    ]'::jsonb,
    '존재, 이동의 목적지, 시간을 나타낼 때 사용합니다. 출발점은 "-에서"를 씁니다.',
    '"에"와 "에서"를 혼동하는 경우가 많습니다. 동작이 일어나는 장소는 "에서"입니다.'
);

-- ==================== Lesson-Vocabulary Mapping ====================

-- Lesson 1 vocabulary (basic consonants lesson)
INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
(1, 1, true, 1),   -- 안녕하세요
(1, 2, true, 2),   -- 감사합니다
(1, 4, false, 3);  -- 학생

-- Lesson 2 vocabulary (basic vowels lesson)
INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
(2, 8, true, 1),   -- 친구
(2, 9, true, 2),   -- 가족
(2, 12, false, 3); -- 먹다

-- Lesson 3 vocabulary (combination practice)
INSERT INTO lesson_vocabulary (lesson_id, vocab_id, is_primary, display_order) VALUES
(3, 4, true, 1),   -- 학생
(3, 5, true, 2),   -- 선생님
(3, 6, true, 3),   -- 학교
(3, 12, false, 4), -- 먹다
(3, 14, false, 5); -- 가다

-- ==================== Lesson-Grammar Mapping ====================

INSERT INTO lesson_grammar (lesson_id, grammar_id, is_primary, display_order) VALUES
(3, 1, true, 1),  -- 이/가
(3, 2, true, 2),  -- 을/를
(3, 3, false, 3); -- 은/는

-- ==================== Sample User Progress ====================

-- User 2 (zhang.wei@example.com) progress
INSERT INTO user_progress (user_id, lesson_id, status, progress_percent, quiz_score, time_spent_minutes, completed_at, last_accessed_at, attempt_count, stage_progress) VALUES
(2, 1, 'completed', 100, 95, 25, CURRENT_TIMESTAMP - INTERVAL '25 days', CURRENT_TIMESTAMP - INTERVAL '25 days', 1,
 '{"stage1": 100, "stage2": 100, "stage3": 100, "stage4": 100, "stage5": 100, "stage6": 100, "stage7": 100}'::jsonb),
(2, 2, 'completed', 100, 88, 27, CURRENT_TIMESTAMP - INTERVAL '20 days', CURRENT_TIMESTAMP - INTERVAL '20 days', 2,
 '{"stage1": 100, "stage2": 100, "stage3": 100, "stage4": 100, "stage5": 100, "stage6": 100, "stage7": 100}'::jsonb),
(2, 3, 'in_progress', 60, NULL, 15, NULL, CURRENT_TIMESTAMP - INTERVAL '1 day', 1,
 '{"stage1": 100, "stage2": 100, "stage3": 100, "stage4": 80, "stage5": 0, "stage6": 0, "stage7": 0}'::jsonb);

-- User 3 (li.na@example.com) progress
INSERT INTO user_progress (user_id, lesson_id, status, progress_percent, quiz_score, time_spent_minutes, completed_at, last_accessed_at, attempt_count, stage_progress) VALUES
(3, 1, 'completed', 100, 78, 35, CURRENT_TIMESTAMP - INTERVAL '10 days', CURRENT_TIMESTAMP - INTERVAL '10 days', 2,
 '{"stage1": 100, "stage2": 100, "stage3": 100, "stage4": 100, "stage5": 100, "stage6": 100, "stage7": 100}'::jsonb),
(3, 2, 'in_progress', 45, NULL, 11, NULL, CURRENT_TIMESTAMP - INTERVAL '3 hours', 1,
 '{"stage1": 100, "stage2": 100, "stage3": 50, "stage4": 0, "stage5": 0, "stage6": 0, "stage7": 0}'::jsonb);

-- ==================== Vocabulary Progress (SRS) ====================

-- User 2 vocabulary progress
INSERT INTO vocabulary_progress (user_id, vocab_id, mastery_level, correct_count, wrong_count, streak_count, last_reviewed, next_review, ease_factor, interval_days) VALUES
(2, 1, 3, 5, 1, 3, CURRENT_TIMESTAMP - INTERVAL '2 days', CURRENT_TIMESTAMP + INTERVAL '3 days', 2.60, 5),
(2, 2, 4, 8, 0, 4, CURRENT_TIMESTAMP - INTERVAL '5 days', CURRENT_TIMESTAMP + INTERVAL '2 days', 2.70, 7),
(2, 4, 3, 6, 2, 2, CURRENT_TIMESTAMP - INTERVAL '3 days', CURRENT_TIMESTAMP + INTERVAL '2 days', 2.50, 5),
(2, 12, 2, 3, 1, 2, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP + INTERVAL '2 days', 2.50, 3);

-- User 3 vocabulary progress
INSERT INTO vocabulary_progress (user_id, vocab_id, mastery_level, correct_count, wrong_count, streak_count, last_reviewed, next_review, ease_factor, interval_days) VALUES
(3, 1, 2, 3, 2, 1, CURRENT_TIMESTAMP - INTERVAL '1 day', CURRENT_TIMESTAMP + INTERVAL '1 day', 2.36, 2),
(3, 2, 1, 2, 1, 1, CURRENT_TIMESTAMP - INTERVAL '6 hours', CURRENT_TIMESTAMP + INTERVAL '1 day', 2.46, 1);

-- ==================== Learning Sessions ====================

INSERT INTO learning_sessions (user_id, started_at, ended_at, lessons_completed, words_reviewed, device_type, app_version, is_synced) VALUES
(2, CURRENT_TIMESTAMP - INTERVAL '25 days 1 hour', CURRENT_TIMESTAMP - INTERVAL '25 days 35 minutes', 1, 5, 'android', '1.0.0', true),
(2, CURRENT_TIMESTAMP - INTERVAL '20 days 2 hours', CURRENT_TIMESTAMP - INTERVAL '20 days 1 hour 10 minutes', 1, 8, 'android', '1.0.0', true),
(2, CURRENT_TIMESTAMP - INTERVAL '1 day 30 minutes', CURRENT_TIMESTAMP - INTERVAL '1 day 15 minutes', 0, 4, 'android', '1.0.1', true),
(3, CURRENT_TIMESTAMP - INTERVAL '10 days 50 minutes', CURRENT_TIMESTAMP - INTERVAL '10 days 15 minutes', 1, 3, 'ios', '1.0.0', true),
(3, CURRENT_TIMESTAMP - INTERVAL '3 hours 15 minutes', CURRENT_TIMESTAMP - INTERVAL '3 hours 4 minutes', 0, 2, 'ios', '1.0.1', true);

-- ==================== User Bookmarks ====================

INSERT INTO user_bookmarks (user_id, resource_type, resource_id, notes) VALUES
(2, 'vocabulary', 12, '这个动词变化规则需要多复习'),
(2, 'grammar', 1, '이/가 和 은/는 的区别要注意'),
(3, 'lesson', 2, '元音部分需要反复练习发音');

-- ==================== User Achievements ====================

INSERT INTO user_achievements (user_id, achievement_type, achievement_data, earned_at) VALUES
(2, 'first_lesson_completed', '{"lesson_id": 1, "score": 95}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '25 days'),
(2, 'streak_7_days', '{"streak_count": 7}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '18 days'),
(3, 'first_lesson_completed', '{"lesson_id": 1, "score": 78}'::jsonb, CURRENT_TIMESTAMP - INTERVAL '10 days');

-- ==================== Update Lesson Statistics ====================

UPDATE lessons SET
    view_count = 150,
    completion_count = 89
WHERE id = 1;

UPDATE lessons SET
    view_count = 120,
    completion_count = 67
WHERE id = 2;

UPDATE lessons SET
    view_count = 95,
    completion_count = 34
WHERE id = 3;

-- ==================== End of Seed Data ====================

-- Display summary
DO $$
BEGIN
    RAISE NOTICE '==================== Seed Data Summary ====================';
    RAISE NOTICE 'Users created: %', (SELECT COUNT(*) FROM users);
    RAISE NOTICE 'Lessons created: %', (SELECT COUNT(*) FROM lessons);
    RAISE NOTICE 'Vocabulary entries: %', (SELECT COUNT(*) FROM vocabulary);
    RAISE NOTICE 'Grammar rules: %', (SELECT COUNT(*) FROM grammar_rules);
    RAISE NOTICE 'User progress records: %', (SELECT COUNT(*) FROM user_progress);
    RAISE NOTICE 'Vocabulary progress records: %', (SELECT COUNT(*) FROM vocabulary_progress);
    RAISE NOTICE 'Learning sessions: %', (SELECT COUNT(*) FROM learning_sessions);
    RAISE NOTICE '============================================================';
    RAISE NOTICE 'Admin login: admin@lemon.com / admin123';
    RAISE NOTICE 'User login: zhang.wei@example.com / user123';
    RAISE NOTICE 'User login: li.na@example.com / user123';
    RAISE NOTICE '============================================================';
END $$;
