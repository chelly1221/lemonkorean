-- ==================== Grammar Multi-Language Seed Data ====================
-- Version: 1.0
-- Date: 2026-02-04
-- Description: Seed grammar translations for all 6 supported languages
-- Requires: 01_schema.sql, 02_seed.sql, migrations/001_add_translations.sql
-- ==================================================================================

-- ==================== English Translations ====================
INSERT INTO grammar_translations (grammar_id, language_code, name, description, language_comparison, usage_notes, common_mistakes) VALUES
-- Grammar 1: Subject particle 이/가
(1, 'en', 'Subject Particle: 이/가',
    'A particle that marks the subject of a sentence. Use 이 when the preceding word ends with a consonant, and 가 when it ends with a vowel.',
    'Unlike English which relies on word order to indicate the subject, Korean uses particles. English: "My friend came" (subject identified by position). Korean: "친구가 왔어요" (subject marked by 가).',
    'Use when introducing new information or when answering "who/what" questions. Contrasts with 은/는 which marks the topic.',
    'Confusing 이/가 with 은/는. Remember: 이/가 introduces new information, 은/는 marks already known topics.'),

-- Grammar 2: Object particle 을/를
(2, 'en', 'Object Particle: 을/를',
    'A particle that marks the direct object of a sentence. Use 을 when the preceding word ends with a consonant, and 를 when it ends with a vowel.',
    'English marks objects through word order (Verb + Object). Korean explicitly marks objects with 을/를. English: "I eat rice" → Korean: "밥을 먹어요" (밥 marked as object).',
    'Attach to nouns that receive the action of the verb. Essential for transitive verbs.',
    'Using 을 with vowel-ending words or 를 with consonant-ending words. Always check the final sound.'),

-- Grammar 3: Topic particle 은/는
(3, 'en', 'Topic Particle: 은/는',
    'A particle that marks the topic of a sentence. Use 은 when the preceding word ends with a consonant, and 는 when it ends with a vowel.',
    'Similar to "As for..." or "Speaking of..." in English. Marks contrast or already-known information. Different from "the" in English.',
    'Use for general statements, contrasts, or when referring to something already mentioned.',
    'Overusing 은/는 when 이/가 would be more appropriate for new information.'),

-- Grammar 4: Polite ending -습니다/ㅂ니다
(4, 'en', 'Formal Polite Ending: -습니다/ㅂ니다',
    'A formal polite sentence ending. Use -습니다 when the verb stem ends with a consonant, and -ㅂ니다 when it ends with a vowel.',
    'Korean has multiple speech levels. This is the most formal polite form, used in news, presentations, and formal situations. English lacks this grammatical distinction.',
    'Use in news broadcasts, presentations, business meetings, and when speaking to elders or superiors.',
    'Forgetting to check the verb stem''s final sound. Also, using this overly formal ending in casual conversations.'),

-- Grammar 5: Location particle -에
(5, 'en', 'Location Particle: -에',
    'A particle indicating location, time, or direction. Attaches directly to nouns without variation.',
    'Combines the functions of English "at," "in," "to," and "on" for time and static location. "I go to school" → "학교에 갑니다". "At 9 o''clock" → "9시에".',
    'Use for: 1) Destination with movement verbs, 2) Location with existence verbs, 3) Time expressions.',
    'Confusing 에 with 에서. Use 에 for destinations and existence; use 에서 for action locations.')
ON CONFLICT (grammar_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    language_comparison = EXCLUDED.language_comparison,
    usage_notes = EXCLUDED.usage_notes,
    common_mistakes = EXCLUDED.common_mistakes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Japanese Translations ====================
INSERT INTO grammar_translations (grammar_id, language_code, name, description, language_comparison, usage_notes, common_mistakes) VALUES
-- Grammar 1: Subject particle 이/가
(1, 'ja', '主格助詞：이/가',
    '主語を表す助詞です。前の単語がパッチム（子音終わり）なら「이」、母音終わりなら「가」を使います。',
    '日本語の「が」に相当します。「友達が来ました」→「친구가 왔어요」。新しい情報を導入する時に使います。',
    '疑問詞に答える時や新情報を提示する時に使用。은/는との使い分けに注意。',
    '日本語の「は」と「が」の区別と似ていますが、完全に同じではありません。文脈で判断しましょう。'),

-- Grammar 2: Object particle 을/를
(2, 'ja', '目的格助詞：을/를',
    '目的語を表す助詞です。前の単語がパッチム（子音終わり）なら「을」、母音終わりなら「를」を使います。',
    '日本語の「を」に相当します。「ご飯を食べます」→「밥을 먹어요」。',
    '動作の対象となる名詞に付けます。他動詞と一緒に使用。',
    'パッチムの有無を確認せずに使う間違いが多いです。'),

-- Grammar 3: Topic particle 은/는
(3, 'ja', '主題助詞：은/는',
    '主題を表す助詞です。前の単語がパッチム（子音終わり）なら「은」、母音終わりなら「는」を使います。',
    '日本語の「は」に相当します。「私は学生です」→「저는 학생입니다」。対比や既知情報を示す時に使います。',
    '一般的な事実や対比を表す時、既出の話題に言及する時に使用。',
    '이/가との混同が多いです。文脈で使い分けましょう。'),

-- Grammar 4: Polite ending -습니다/ㅂ니다
(4, 'ja', '格式体終結語尾：-습니다/ㅂ니다',
    '丁寧な格式体の終結語尾です。動詞・形容詞の語幹がパッチム終わりなら「-습니다」、母音終わりなら「-ㅂ니다」。',
    '日本語の「です・ます」の最も丁寧な形に相当。ニュース、発表、公式な場面で使用されます。',
    'ニュース放送、プレゼン、ビジネスミーティング、目上の人への話し方。',
    '語幹のパッチム確認を忘れる。また、友達同士でこの形を使うと不自然。'),

-- Grammar 5: Location particle -에
(5, 'ja', '処所助詞：-에',
    '場所や時間を表す助詞です。名詞に直接付きます。',
    '日本語の「に」「へ」に相当。「学校に行きます」→「학교에 갑니다」。「9時に」→「9시에」。',
    '移動の目的地、存在の場所、時間表現に使用。',
    '「에」と「에서」の混同。目的地・存在には「에」、動作の場所には「에서」。')
ON CONFLICT (grammar_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    language_comparison = EXCLUDED.language_comparison,
    usage_notes = EXCLUDED.usage_notes,
    common_mistakes = EXCLUDED.common_mistakes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Spanish Translations ====================
INSERT INTO grammar_translations (grammar_id, language_code, name, description, language_comparison, usage_notes, common_mistakes) VALUES
-- Grammar 1: Subject particle 이/가
(1, 'es', 'Partícula de sujeto: 이/가',
    'Partícula que marca el sujeto de una oración. Usa 이 cuando la palabra anterior termina en consonante, y 가 cuando termina en vocal.',
    'A diferencia del español que identifica el sujeto por la conjugación del verbo o posición, el coreano usa partículas explícitas. Español: "Mi amigo vino" → Coreano: "친구가 왔어요" (가 marca el sujeto).',
    'Usar al introducir información nueva o al responder preguntas de "quién/qué". Contrasta con 은/는 que marca el tema.',
    'Confundir 이/가 con 은/는. Recuerda: 이/가 introduce información nueva, 은/는 marca temas ya conocidos.'),

-- Grammar 2: Object particle 을/를
(2, 'es', 'Partícula de objeto: 을/를',
    'Partícula que marca el objeto directo de una oración. Usa 을 cuando la palabra anterior termina en consonante, y 를 cuando termina en vocal.',
    'El español marca objetos a través del orden de palabras. El coreano marca explícitamente objetos con 을/를. Español: "Como arroz" → Coreano: "밥을 먹어요".',
    'Se adjunta a sustantivos que reciben la acción del verbo. Esencial para verbos transitivos.',
    'Usar 을 con palabras que terminan en vocal o 를 con palabras que terminan en consonante.'),

-- Grammar 3: Topic particle 은/는
(3, 'es', 'Partícula de tema: 은/는',
    'Partícula que marca el tema de una oración. Usa 은 cuando la palabra anterior termina en consonante, y 는 cuando termina en vocal.',
    'Similar a "En cuanto a..." o "Hablando de..." en español. Marca contraste o información ya conocida.',
    'Usar para declaraciones generales, contrastes, o al referirse a algo ya mencionado.',
    'Sobreusar 은/는 cuando 이/가 sería más apropiado para información nueva.'),

-- Grammar 4: Polite ending -습니다/ㅂ니다
(4, 'es', 'Terminación formal cortés: -습니다/ㅂ니다',
    'Terminación formal y cortés. Usa -습니다 cuando la raíz verbal termina en consonante, y -ㅂ니다 cuando termina en vocal.',
    'El coreano tiene múltiples niveles de cortesía. Esta es la forma más formal, usada en noticias y presentaciones. El español usa "usted" pero no cambia la terminación verbal de forma tan compleja.',
    'Usar en transmisiones de noticias, presentaciones, reuniones de negocios.',
    'Olvidar verificar el sonido final de la raíz verbal. También, usar esta forma excesivamente formal en conversaciones casuales.'),

-- Grammar 5: Location particle -에
(5, 'es', 'Partícula de lugar: -에',
    'Partícula que indica lugar, tiempo o dirección. Se adjunta directamente a los sustantivos.',
    'Combina las funciones de "a", "en" del español para tiempo y ubicación estática. "Voy a la escuela" → "학교에 갑니다". "A las 9" → "9시에".',
    'Usar para: 1) Destino con verbos de movimiento, 2) Ubicación con verbos de existencia, 3) Expresiones de tiempo.',
    'Confundir 에 con 에서. Usa 에 para destinos y existencia; usa 에서 para ubicaciones de acción.')
ON CONFLICT (grammar_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    language_comparison = EXCLUDED.language_comparison,
    usage_notes = EXCLUDED.usage_notes,
    common_mistakes = EXCLUDED.common_mistakes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Korean Translations (for reference) ====================
INSERT INTO grammar_translations (grammar_id, language_code, name, description, language_comparison, usage_notes, common_mistakes) VALUES
(1, 'ko', '주격 조사: 이/가',
    '주어를 나타내는 조사입니다. 받침이 있으면 "이", 없으면 "가"를 사용합니다.',
    NULL,
    '새로운 정보나 대조할 때 주로 사용합니다. "은/는"과 구별해서 사용하세요.',
    '받침 유무를 확인하지 않고 사용하는 경우가 많습니다.'),
(2, 'ko', '목적격 조사: 을/를',
    '목적어를 나타내는 조사입니다. 받침이 있으면 "을", 없으면 "를"을 사용합니다.',
    NULL,
    '동작의 대상이 되는 명사에 붙입니다.',
    '받침이 있어도 "를"을 사용하는 실수가 많습니다.'),
(3, 'ko', '주제 조사: 은/는',
    '주제를 나타내는 조사입니다. 받침이 있으면 "은", 없으면 "는"을 사용합니다.',
    NULL,
    '이미 알려진 정보나 일반적인 사실을 말할 때 사용합니다.',
    '"이/가"와 혼동하기 쉽습니다. 문맥에 따라 선택하세요.'),
(4, 'ko', '격식체 종결어미: -습니다/ㅂ니다',
    '격식을 갖춘 존댓말 종결어미입니다. 동사/형용사 어간에 받침이 있으면 "-습니다", 없으면 "-ㅂ니다"를 사용합니다.',
    NULL,
    '뉴스, 발표, 공식 석상에서 주로 사용합니다.',
    '어간의 받침 유무를 확인하지 않는 경우가 많습니다.'),
(5, 'ko', '처소 조사: -에',
    '장소나 시간을 나타낼 때 사용하는 조사입니다.',
    NULL,
    '존재, 이동의 목적지, 시간을 나타낼 때 사용합니다.',
    '"에"와 "에서"를 혼동하는 경우가 많습니다.')
ON CONFLICT (grammar_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    language_comparison = EXCLUDED.language_comparison,
    usage_notes = EXCLUDED.usage_notes,
    common_mistakes = EXCLUDED.common_mistakes,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Verify Translations ====================
DO $$
BEGIN
    RAISE NOTICE '==================== Grammar Translations Summary ====================';
    RAISE NOTICE 'Total translations: %', (SELECT COUNT(*) FROM grammar_translations);
    RAISE NOTICE 'By language:';
    RAISE NOTICE '  - Korean (ko): %', (SELECT COUNT(*) FROM grammar_translations WHERE language_code = 'ko');
    RAISE NOTICE '  - English (en): %', (SELECT COUNT(*) FROM grammar_translations WHERE language_code = 'en');
    RAISE NOTICE '  - Japanese (ja): %', (SELECT COUNT(*) FROM grammar_translations WHERE language_code = 'ja');
    RAISE NOTICE '  - Spanish (es): %', (SELECT COUNT(*) FROM grammar_translations WHERE language_code = 'es');
    RAISE NOTICE '  - Chinese Simplified (zh): %', (SELECT COUNT(*) FROM grammar_translations WHERE language_code = 'zh');
    RAISE NOTICE '  - Chinese Traditional (zh_TW): %', (SELECT COUNT(*) FROM grammar_translations WHERE language_code = 'zh_TW');
    RAISE NOTICE '=====================================================================';
END $$;

-- ==================== End of Grammar Seed ====================
