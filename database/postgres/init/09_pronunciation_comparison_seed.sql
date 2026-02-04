-- ==================== Pronunciation Comparison Seed Data ====================
-- Version: 1.0
-- Date: 2026-02-04
-- Description: Seed hangul pronunciation guides with native language comparisons
-- Requires: 04_hangul_schema.sql, 05_hangul_seed.sql, migrations/002_add_pronunciation_guides.sql
-- ==================================================================================

-- ==================== Insert Pronunciation Guides ====================
-- The native_comparisons column stores multi-language comparison data as JSONB

-- Basic Consonants
INSERT INTO hangul_pronunciation_guides (character_id, mouth_shape_url, tongue_position_url, air_flow_description, native_comparisons, similar_character_ids) VALUES

-- ㄱ (giyeok)
(1, '/media/hangul/mouth/giyeok.png', '/media/hangul/tongue/giyeok.png',
    '{"type": "unaspirated_stop", "description_ko": "기류를 막았다가 터트림", "description_zh": "气流阻断后释放", "description_en": "Airflow blocked then released", "description_ja": "気流を遮断して解放"}',
    '{
        "zh": [{"comparison": "类似\"哥\"的声母g，但更轻", "tip": "发音时声带不振动"}],
        "ja": [{"comparison": "「か」行の子音に近い", "tip": "語中では濁音化することがある"}],
        "en": [{"comparison": "Similar to \"g\" in \"go\" but unaspirated", "tip": "No puff of air like \"k\" in \"key\""}],
        "es": [{"comparison": "Similar a la \"g\" de \"gato\"", "tip": "Sin aspiración"}]
    }',
    ARRAY[15, 16]  -- ㅋ, ㄲ
),

-- ㄴ (nieun)
(2, '/media/hangul/mouth/nieun.png', '/media/hangul/tongue/nieun.png',
    '{"type": "nasal", "description_ko": "코로 공기가 나감", "description_zh": "气流从鼻腔出", "description_en": "Air flows through nose", "description_ja": "鼻から空気が出る"}',
    '{
        "zh": [{"comparison": "与\"你\"的声母n相同"}],
        "ja": [{"comparison": "「な」行の子音と同じ"}],
        "en": [{"comparison": "Same as \"n\" in \"no\""}],
        "es": [{"comparison": "Igual que la \"n\" en \"no\""}]
    }',
    NULL
),

-- ㄷ (digeut)
(3, '/media/hangul/mouth/digeut.png', '/media/hangul/tongue/digeut.png',
    '{"type": "unaspirated_stop", "description_ko": "혀끝이 윗잇몸에 닿음", "description_zh": "舌尖触上齿龈", "description_en": "Tongue tip touches upper gum", "description_ja": "舌先が上歯茎に触れる"}',
    '{
        "zh": [{"comparison": "类似\"大\"的声母d，但更轻", "tip": "发音时声带不振动"}],
        "ja": [{"comparison": "「た」行の子音に近い", "tip": "語中では濁音化することがある"}],
        "en": [{"comparison": "Like \"d\" in \"do\" but unaspirated", "tip": "Less air than \"t\" in \"top\""}],
        "es": [{"comparison": "Similar a la \"d\" de \"dar\""}]
    }',
    ARRAY[17, 18]  -- ㅌ, ㄸ
),

-- ㄹ (rieul)
(4, '/media/hangul/mouth/rieul.png', '/media/hangul/tongue/rieul.png',
    '{"type": "liquid", "description_ko": "혀끝이 윗잇몸을 가볍게 침", "description_zh": "舌尖轻触上颚", "description_en": "Tongue tip lightly taps upper gum", "description_ja": "舌先が上あごに軽く触れる"}',
    '{
        "zh": [{"comparison": "词首类似l，词中类似卷舌r", "tip": "舌尖轻触上颚"}],
        "ja": [{"comparison": "「ら」行の子音に近い", "tip": "舌先が上あごに軽く触れる"}],
        "en": [{"comparison": "Between \"l\" and \"r\"", "tip": "Flap sound, like \"tt\" in \"butter\" (American)"}],
        "es": [{"comparison": "Similar a la \"r\" simple de \"pero\"", "tip": "No es la \"rr\" fuerte"}]
    }',
    NULL
),

-- ㅁ (mieum)
(5, '/media/hangul/mouth/mieum.png', '/media/hangul/tongue/mieum.png',
    '{"type": "nasal", "description_ko": "입술을 다물고 코로 소리냄", "description_zh": "闭唇从鼻腔发声", "description_en": "Lips closed, sound through nose", "description_ja": "唇を閉じて鼻から声を出す"}',
    '{
        "zh": [{"comparison": "与\"妈\"的声母m相同"}],
        "ja": [{"comparison": "「ま」行の子音と同じ"}],
        "en": [{"comparison": "Same as \"m\" in \"mom\""}],
        "es": [{"comparison": "Igual que la \"m\" en \"mamá\""}]
    }',
    NULL
),

-- ㅂ (bieup)
(6, '/media/hangul/mouth/bieup.png', '/media/hangul/tongue/bieup.png',
    '{"type": "unaspirated_stop", "description_ko": "입술을 다물었다가 터트림", "description_zh": "闭唇后释放", "description_en": "Lips closed then released", "description_ja": "唇を閉じてから開放"}',
    '{
        "zh": [{"comparison": "类似\"把\"的声母b，但更轻", "tip": "不送气"}],
        "ja": [{"comparison": "「ば」行の子音に近い", "tip": "語中では濁音化することがある"}],
        "en": [{"comparison": "Like \"b\" in \"boy\" but unaspirated", "tip": "Less air than \"p\" in \"pie\""}],
        "es": [{"comparison": "Similar a la \"b\" de \"boca\""}]
    }',
    ARRAY[19, 20]  -- ㅍ, ㅃ
),

-- ㅅ (siot)
(7, '/media/hangul/mouth/siot.png', '/media/hangul/tongue/siot.png',
    '{"type": "fricative", "description_ko": "공기가 좁은 틈 사이로 나감", "description_zh": "气流从窄缝中出", "description_en": "Air through narrow gap", "description_ja": "空気が狭い隙間から出る"}',
    '{
        "zh": [{"comparison": "类似\"四\"的声母s", "tip": "在ㅣ前面时接近\"西\"的声母x"}],
        "ja": [{"comparison": "「さ」行の子音", "tip": "ㅣの前では「し」に近い"}],
        "en": [{"comparison": "Similar to \"s\" in \"sun\"", "tip": "Before ㅣ, more like \"sh\""}],
        "es": [{"comparison": "Similar a la \"s\" de \"sol\""}]
    }',
    ARRAY[22]  -- ㅆ
),

-- ㅇ (ieung) - as initial (silent)
(8, '/media/hangul/mouth/ieung.png', NULL,
    '{"type": "silent_or_nasal", "description_ko": "초성에서 무음, 종성에서 비음", "description_zh": "初声无音，终声为鼻音", "description_en": "Silent as initial, nasal as final", "description_ja": "初声では無音、終声では鼻音"}',
    '{
        "zh": [{"comparison": "作初声时不发音，作终声时类似\"ng\""}],
        "ja": [{"comparison": "初声では無音、終声では「ん」に近い"}],
        "en": [{"comparison": "Silent at start, \"ng\" sound at end"}],
        "es": [{"comparison": "Silencioso al inicio, como \"ng\" al final"}]
    }',
    NULL
)
ON CONFLICT (character_id) DO UPDATE SET
    mouth_shape_url = EXCLUDED.mouth_shape_url,
    tongue_position_url = EXCLUDED.tongue_position_url,
    air_flow_description = EXCLUDED.air_flow_description,
    native_comparisons = EXCLUDED.native_comparisons,
    similar_character_ids = EXCLUDED.similar_character_ids,
    updated_at = CURRENT_TIMESTAMP;

-- Basic Vowels
INSERT INTO hangul_pronunciation_guides (character_id, mouth_shape_url, tongue_position_url, air_flow_description, native_comparisons, similar_character_ids) VALUES

-- ㅏ (a)
(23, '/media/hangul/mouth/a.png', '/media/hangul/tongue/a.png',
    '{"type": "open_vowel", "description_ko": "입을 크게 벌림", "description_zh": "嘴巴张开", "description_en": "Mouth open wide", "description_ja": "口を大きく開ける"}',
    '{
        "zh": [{"comparison": "类似\"啊\"，但口型更小"}],
        "ja": [{"comparison": "「あ」とほぼ同じ"}],
        "en": [{"comparison": "Like \"a\" in \"father\""}],
        "es": [{"comparison": "Igual que la \"a\" española"}]
    }',
    NULL
),

-- ㅓ (eo)
(25, '/media/hangul/mouth/eo.png', '/media/hangul/tongue/eo.png',
    '{"type": "mid_vowel", "description_ko": "입을 세로로 벌림, 둥글지 않음", "description_zh": "嘴纵向张开，不圆", "description_en": "Mouth open vertically, unrounded", "description_ja": "口を縦に開き、丸めない"}',
    '{
        "zh": [{"comparison": "类似\"哦\"但不圆唇", "tip": "嘴唇不要圆起来"}],
        "ja": [{"comparison": "「お」より口を縦に開く", "tip": "唇を丸めない"}],
        "en": [{"comparison": "Like \"u\" in \"up\" or \"uh\"", "tip": "Keep lips unrounded"}],
        "es": [{"comparison": "Entre \"o\" y \"a\", sin redondear labios"}]
    }',
    ARRAY[29]  -- ㅗ (similar sound group)
),

-- ㅗ (o)
(29, '/media/hangul/mouth/o.png', '/media/hangul/tongue/o.png',
    '{"type": "rounded_vowel", "description_ko": "입술을 둥글게 함", "description_zh": "嘴唇圆起", "description_en": "Lips rounded", "description_ja": "唇を丸める"}',
    '{
        "zh": [{"comparison": "类似\"哦\"，嘴唇圆起"}],
        "ja": [{"comparison": "「お」とほぼ同じ"}],
        "en": [{"comparison": "Like \"o\" in \"go\""}],
        "es": [{"comparison": "Igual que la \"o\" española"}]
    }',
    ARRAY[25]  -- ㅓ (similar sound group)
),

-- ㅜ (u)
(33, '/media/hangul/mouth/u.png', '/media/hangul/tongue/u.png',
    '{"type": "rounded_vowel", "description_ko": "입술을 둥글게 모음", "description_zh": "嘴唇圆起突出", "description_en": "Lips rounded and protruded", "description_ja": "唇を丸めて突き出す"}',
    '{
        "zh": [{"comparison": "类似\"屋\"，嘴唇圆起突出"}],
        "ja": [{"comparison": "「う」とほぼ同じ"}],
        "en": [{"comparison": "Like \"oo\" in \"food\""}],
        "es": [{"comparison": "Igual que la \"u\" española"}]
    }',
    ARRAY[39]  -- ㅡ (similar sound group)
),

-- ㅡ (eu)
(39, '/media/hangul/mouth/eu.png', '/media/hangul/tongue/eu.png',
    '{"type": "unrounded_vowel", "description_ko": "입술을 양옆으로 펴고 평평하게", "description_zh": "嘴唇扁平向两边拉", "description_en": "Lips spread flat horizontally", "description_ja": "唇を横に引く"}',
    '{
        "zh": [{"comparison": "类似\"资\"的韵母，嘴唇扁平", "tip": "嘴唇向两边拉"}],
        "ja": [{"comparison": "「う」と「い」の中間", "tip": "唇を横に引く"}],
        "en": [{"comparison": "No exact equivalent", "tip": "Say \"oo\" but spread your lips like \"ee\""}],
        "es": [{"comparison": "No existe en español", "tip": "Di \"u\" con los labios estirados como \"i\""}]
    }',
    ARRAY[33]  -- ㅜ (similar sound group)
),

-- ㅣ (i)
(40, '/media/hangul/mouth/i.png', '/media/hangul/tongue/i.png',
    '{"type": "close_vowel", "description_ko": "입술을 양옆으로 펴고 입을 조금 벌림", "description_zh": "嘴唇向两边拉，微张", "description_en": "Lips spread, mouth slightly open", "description_ja": "唇を横に引き、少し開ける"}',
    '{
        "zh": [{"comparison": "与\"一\"相同"}],
        "ja": [{"comparison": "「い」と同じ"}],
        "en": [{"comparison": "Like \"ee\" in \"see\""}],
        "es": [{"comparison": "Igual que la \"i\" española"}]
    }',
    NULL
)
ON CONFLICT (character_id) DO UPDATE SET
    mouth_shape_url = EXCLUDED.mouth_shape_url,
    tongue_position_url = EXCLUDED.tongue_position_url,
    air_flow_description = EXCLUDED.air_flow_description,
    native_comparisons = EXCLUDED.native_comparisons,
    similar_character_ids = EXCLUDED.similar_character_ids,
    updated_at = CURRENT_TIMESTAMP;

-- Double Consonants (경음/된소리)
INSERT INTO hangul_pronunciation_guides (character_id, mouth_shape_url, tongue_position_url, air_flow_description, native_comparisons, similar_character_ids) VALUES

-- ㄲ (ssang-giyeok)
(15, '/media/hangul/mouth/ssang-giyeok.png', '/media/hangul/tongue/ssang-giyeok.png',
    '{"type": "tense_stop", "description_ko": "후두를 긴장시키고 강하게 발음", "description_zh": "喉咙紧张，用力发音", "description_en": "Larynx tensed, pronounced with force", "description_ja": "喉頭を緊張させ、強く発音"}',
    '{
        "zh": [{"comparison": "比ㄱ更紧，喉咙紧张", "tip": "没有类似的音，需要练习"}],
        "ja": [{"comparison": "ㄱより緊張した音", "tip": "声門を閉じてから発音"}],
        "en": [{"comparison": "Tense \"k\" with no air", "tip": "Like \"sk\" in \"sky\" but tenser"}],
        "es": [{"comparison": "\"G\" tensa sin aire", "tip": "Como \"sk\" en inglés pero más tenso"}]
    }',
    ARRAY[1, 16]  -- ㄱ, ㅋ
),

-- ㄸ (ssang-digeut)
(18, '/media/hangul/mouth/ssang-digeut.png', '/media/hangul/tongue/ssang-digeut.png',
    '{"type": "tense_stop", "description_ko": "후두를 긴장시키고 강하게 발음", "description_zh": "喉咙紧张，用力发音", "description_en": "Larynx tensed, pronounced with force", "description_ja": "喉頭を緊張させ、強く発音"}',
    '{
        "zh": [{"comparison": "比ㄷ更紧，喉咙紧张", "tip": "没有类似的音，需要练习"}],
        "ja": [{"comparison": "ㄷより緊張した音", "tip": "声門を閉じてから発音"}],
        "en": [{"comparison": "Tense \"t\" with no air", "tip": "Like \"st\" in \"stop\" but tenser"}],
        "es": [{"comparison": "\"D\" tensa sin aire", "tip": "Como \"st\" en inglés pero más tenso"}]
    }',
    ARRAY[3, 17]  -- ㄷ, ㅌ
),

-- ㅃ (ssang-bieup)
(20, '/media/hangul/mouth/ssang-bieup.png', '/media/hangul/tongue/ssang-bieup.png',
    '{"type": "tense_stop", "description_ko": "후두를 긴장시키고 강하게 발음", "description_zh": "喉咙紧张，用力发音", "description_en": "Larynx tensed, pronounced with force", "description_ja": "喉頭を緊張させ、強く発音"}',
    '{
        "zh": [{"comparison": "比ㅂ更紧，喉咙紧张", "tip": "没有类似的音，需要练习"}],
        "ja": [{"comparison": "ㅂより緊張した音", "tip": "声門を閉じてから発音"}],
        "en": [{"comparison": "Tense \"p\" with no air", "tip": "Like \"sp\" in \"spy\" but tenser"}],
        "es": [{"comparison": "\"B\" tensa sin aire", "tip": "Como \"sp\" en inglés pero más tenso"}]
    }',
    ARRAY[6, 19]  -- ㅂ, ㅍ
),

-- ㅆ (ssang-siot)
(22, '/media/hangul/mouth/ssang-siot.png', '/media/hangul/tongue/ssang-siot.png',
    '{"type": "tense_fricative", "description_ko": "후두를 긴장시키고 강하게 발음", "description_zh": "喉咙紧张，用力发音", "description_en": "Larynx tensed, pronounced with force", "description_ja": "喉頭を緊張させ、強く発音"}',
    '{
        "zh": [{"comparison": "比ㅅ更紧，类似强调的\"丝\"", "tip": "喉咙更紧张"}],
        "ja": [{"comparison": "ㅅより緊張した音", "tip": "声門を閉じてから発音"}],
        "en": [{"comparison": "Tense \"s\" sound", "tip": "More forceful than regular s"}],
        "es": [{"comparison": "\"S\" tensa", "tip": "Más fuerte que la s normal"}]
    }',
    ARRAY[7]  -- ㅅ
)
ON CONFLICT (character_id) DO UPDATE SET
    mouth_shape_url = EXCLUDED.mouth_shape_url,
    tongue_position_url = EXCLUDED.tongue_position_url,
    air_flow_description = EXCLUDED.air_flow_description,
    native_comparisons = EXCLUDED.native_comparisons,
    similar_character_ids = EXCLUDED.similar_character_ids,
    updated_at = CURRENT_TIMESTAMP;

-- ==================== Verify Pronunciation Guides ====================
DO $$
BEGIN
    RAISE NOTICE '==================== Pronunciation Guides Summary ====================';
    RAISE NOTICE 'Total pronunciation guides: %', (SELECT COUNT(*) FROM hangul_pronunciation_guides);
    RAISE NOTICE 'With native comparisons: %', (SELECT COUNT(*) FROM hangul_pronunciation_guides WHERE native_comparisons IS NOT NULL);
    RAISE NOTICE 'With similar characters: %', (SELECT COUNT(*) FROM hangul_pronunciation_guides WHERE similar_character_ids IS NOT NULL);
    RAISE NOTICE '=====================================================================';
END $$;

-- ==================== End of Pronunciation Comparison Seed ====================
