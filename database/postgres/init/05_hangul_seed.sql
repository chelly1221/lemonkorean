-- ==================== Hangul Characters Seed Data ====================
-- 한글 자모 시드 데이터 (40개)
-- All Korean alphabet characters with Chinese pronunciation guides

-- ==================== Basic Consonants (기본 자음) - 14개 ====================

INSERT INTO hangul_characters (
    character, character_type, romanization, pronunciation_zh, pronunciation_tip_zh,
    stroke_count, display_order, example_words, mnemonics_zh, status
) VALUES
-- ㄱ (g/k)
('ㄱ', 'basic_consonant', 'g/k', '类似"g"或"k"',
'在词首发音像轻声的"g"，在词尾发音像"k"。介于中文"格"和"克"之间。',
2, 1,
'[{"korean": "가", "chinese": "去", "pinyin": "qù"}, {"korean": "김치", "chinese": "泡菜", "pinyin": "pàocài"}, {"korean": "고기", "chinese": "肉", "pinyin": "ròu"}]',
'形状像数字"7"，发音时舌根接触软腭', 'published'),

-- ㄴ (n)
('ㄴ', 'basic_consonant', 'n', '类似"n"',
'与中文"那"的声母相同。舌尖抵住上齿龈。',
2, 2,
'[{"korean": "나", "chinese": "我", "pinyin": "wǒ"}, {"korean": "나라", "chinese": "国家", "pinyin": "guójiā"}, {"korean": "눈", "chinese": "雪/眼睛", "pinyin": "xuě/yǎnjīng"}]',
'形状像英文字母"L"的镜像', 'published'),

-- ㄷ (d/t)
('ㄷ', 'basic_consonant', 'd/t', '类似"d"或"t"',
'在词首发音像轻声的"d"，在词尾发音像"t"。介于中文"大"和"他"之间。',
3, 3,
'[{"korean": "다", "chinese": "都", "pinyin": "dōu"}, {"korean": "도시", "chinese": "城市", "pinyin": "chéngshì"}, {"korean": "달", "chinese": "月亮", "pinyin": "yuèliàng"}]',
'形状像一个方框的上半部分', 'published'),

-- ㄹ (r/l)
('ㄹ', 'basic_consonant', 'r/l', '类似"r"或"l"',
'在词首和元音之间发音像弹舌的"r"，在词尾发音像"l"。中国人容易混淆，需要多练习。',
5, 4,
'[{"korean": "라면", "chinese": "拉面", "pinyin": "lāmiàn"}, {"korean": "사랑", "chinese": "爱", "pinyin": "ài"}, {"korean": "말", "chinese": "马/话", "pinyin": "mǎ/huà"}]',
'形状像一条弯曲的丝带', 'published'),

-- ㅁ (m)
('ㅁ', 'basic_consonant', 'm', '类似"m"',
'与中文"妈"的声母完全相同。双唇紧闭后发音。',
4, 5,
'[{"korean": "마", "chinese": "马", "pinyin": "mǎ"}, {"korean": "물", "chinese": "水", "pinyin": "shuǐ"}, {"korean": "엄마", "chinese": "妈妈", "pinyin": "māmā"}]',
'形状像一个正方形，代表闭合的嘴巴', 'published'),

-- ㅂ (b/p)
('ㅂ', 'basic_consonant', 'b/p', '类似"b"或"p"',
'在词首发音像轻声的"b"，在词尾发音像"p"。介于中文"爸"和"趴"之间。',
4, 6,
'[{"korean": "바다", "chinese": "大海", "pinyin": "dàhǎi"}, {"korean": "밥", "chinese": "饭", "pinyin": "fàn"}, {"korean": "아빠", "chinese": "爸爸", "pinyin": "bàba"}]',
'形状像一个带腿的桶', 'published'),

-- ㅅ (s)
('ㅅ', 'basic_consonant', 's', '类似"s"',
'与中文"四"的声母相似，但更轻柔。在"ㅣ"前面发音像"sh"。',
2, 7,
'[{"korean": "사람", "chinese": "人", "pinyin": "rén"}, {"korean": "시간", "chinese": "时间", "pinyin": "shíjiān"}, {"korean": "소", "chinese": "牛", "pinyin": "niú"}]',
'形状像一个人字形或帽子', 'published'),

-- ㅇ (ng/silent)
('ㅇ', 'basic_consonant', 'ng/silent', '词首无声，词尾"ng"',
'在词首作为占位符，不发音。在词尾发音像"ng"，类似中文"昂"的韵尾。',
1, 8,
'[{"korean": "아", "chinese": "啊", "pinyin": "a"}, {"korean": "오", "chinese": "五", "pinyin": "wǔ"}, {"korean": "강", "chinese": "江", "pinyin": "jiāng"}]',
'形状是一个圆圈，代表嘴巴张开', 'published'),

-- ㅈ (j)
('ㅈ', 'basic_consonant', 'j', '类似"j"或"z"',
'介于中文"机"和"资"之间。舌尖接触上齿龈后方。',
3, 9,
'[{"korean": "자", "chinese": "字", "pinyin": "zì"}, {"korean": "지하철", "chinese": "地铁", "pinyin": "dìtiě"}, {"korean": "점심", "chinese": "午餐", "pinyin": "wǔcān"}]',
'形状像ㅅ加一横，像一个亭子', 'published'),

-- ㅊ (ch)
('ㅊ', 'basic_consonant', 'ch', '类似"ch"',
'送气音，类似中文"吃"的声母。比ㅈ更用力。',
4, 10,
'[{"korean": "차", "chinese": "茶/车", "pinyin": "chá/chē"}, {"korean": "친구", "chinese": "朋友", "pinyin": "péngyǒu"}, {"korean": "책", "chinese": "书", "pinyin": "shū"}]',
'形状像ㅈ上面加一横，表示送气', 'published'),

-- ㅋ (k)
('ㅋ', 'basic_consonant', 'k', '类似"k"',
'送气音，类似中文"科"的声母。比ㄱ更用力。',
3, 11,
'[{"korean": "카", "chinese": "卡", "pinyin": "kǎ"}, {"korean": "커피", "chinese": "咖啡", "pinyin": "kāfēi"}, {"korean": "코", "chinese": "鼻子", "pinyin": "bízi"}]',
'形状像ㄱ加一横，表示送气', 'published'),

-- ㅌ (t)
('ㅌ', 'basic_consonant', 't', '类似"t"',
'送气音，类似中文"他"的声母。比ㄷ更用力。',
4, 12,
'[{"korean": "타다", "chinese": "乘坐", "pinyin": "chéngzuò"}, {"korean": "토끼", "chinese": "兔子", "pinyin": "tùzi"}, {"korean": "태양", "chinese": "太阳", "pinyin": "tàiyáng"}]',
'形状像ㄷ加一横，表示送气', 'published'),

-- ㅍ (p)
('ㅍ', 'basic_consonant', 'p', '类似"p"',
'送气音，类似中文"怕"的声母。比ㅂ更用力。',
4, 13,
'[{"korean": "파", "chinese": "葱", "pinyin": "cōng"}, {"korean": "포도", "chinese": "葡萄", "pinyin": "pútáo"}, {"korean": "피아노", "chinese": "钢琴", "pinyin": "gāngqín"}]',
'形状像ㅂ中间加两横', 'published'),

-- ㅎ (h)
('ㅎ', 'basic_consonant', 'h', '类似"h"',
'类似中文"哈"的声母，气息从喉咙送出。',
3, 14,
'[{"korean": "하나", "chinese": "一", "pinyin": "yī"}, {"korean": "한국", "chinese": "韩国", "pinyin": "hánguó"}, {"korean": "행복", "chinese": "幸福", "pinyin": "xìngfú"}]',
'形状像一个戴帽子的人', 'published');

-- ==================== Double Consonants (쌍자음) - 5개 ====================

INSERT INTO hangul_characters (
    character, character_type, romanization, pronunciation_zh, pronunciation_tip_zh,
    stroke_count, display_order, example_words, mnemonics_zh, status
) VALUES
-- ㄲ (kk)
('ㄲ', 'double_consonant', 'kk', '紧音"kk"',
'比ㄱ更紧张有力，不送气。类似中文"格"但喉咙更紧。',
4, 1,
'[{"korean": "까치", "chinese": "喜鹊", "pinyin": "xǐquè"}, {"korean": "꽃", "chinese": "花", "pinyin": "huā"}, {"korean": "빨간", "chinese": "红色的", "pinyin": "hóngsè de"}]',
'双写的ㄱ，发音时喉咙紧张', 'published'),

-- ㄸ (tt)
('ㄸ', 'double_consonant', 'tt', '紧音"tt"',
'比ㄷ更紧张有力，不送气。类似中文"打"但喉咙更紧。',
6, 2,
'[{"korean": "따", "chinese": "摘", "pinyin": "zhāi"}, {"korean": "딸기", "chinese": "草莓", "pinyin": "cǎoméi"}, {"korean": "뚜껑", "chinese": "盖子", "pinyin": "gàizi"}]',
'双写的ㄷ，发音时喉咙紧张', 'published'),

-- ㅃ (pp)
('ㅃ', 'double_consonant', 'pp', '紧音"pp"',
'比ㅂ更紧张有力，不送气。类似中文"爸"但喉咙更紧。',
8, 3,
'[{"korean": "빠르다", "chinese": "快", "pinyin": "kuài"}, {"korean": "빵", "chinese": "面包", "pinyin": "miànbāo"}, {"korean": "예쁘다", "chinese": "漂亮", "pinyin": "piàoliang"}]',
'双写的ㅂ，发音时喉咙紧张', 'published'),

-- ㅆ (ss)
('ㅆ', 'double_consonant', 'ss', '紧音"ss"',
'比ㅅ更紧张有力。类似中文"丝"但更用力。',
4, 4,
'[{"korean": "쓰다", "chinese": "写/苦", "pinyin": "xiě/kǔ"}, {"korean": "씨", "chinese": "种子", "pinyin": "zhǒngzi"}, {"korean": "싸다", "chinese": "便宜/包", "pinyin": "piányi/bāo"}]',
'双写的ㅅ，发音时更用力', 'published'),

-- ㅉ (jj)
('ㅉ', 'double_consonant', 'jj', '紧音"jj"',
'比ㅈ更紧张有力，不送气。类似中文"机"但喉咙更紧。',
6, 5,
'[{"korean": "짜다", "chinese": "咸", "pinyin": "xián"}, {"korean": "찌개", "chinese": "汤", "pinyin": "tāng"}, {"korean": "짧다", "chinese": "短", "pinyin": "duǎn"}]',
'双写的ㅈ，发音时喉咙紧张', 'published');

-- ==================== Basic Vowels (기본 모음) - 10개 ====================

INSERT INTO hangul_characters (
    character, character_type, romanization, pronunciation_zh, pronunciation_tip_zh,
    stroke_count, display_order, example_words, mnemonics_zh, status
) VALUES
-- ㅏ (a)
('ㅏ', 'basic_vowel', 'a', '类似"a"',
'类似中文"啊"的发音。嘴巴张大，舌头放低。',
2, 1,
'[{"korean": "아", "chinese": "啊", "pinyin": "a"}, {"korean": "아버지", "chinese": "父亲", "pinyin": "fùqīn"}, {"korean": "사랑", "chinese": "爱", "pinyin": "ài"}]',
'一竖加一横向右，代表太阳在东方升起', 'published'),

-- ㅑ (ya)
('ㅑ', 'basic_vowel', 'ya', '类似"ya"',
'类似中文"呀"的发音。在ㅏ前加"y"音。',
3, 2,
'[{"korean": "야", "chinese": "呀", "pinyin": "ya"}, {"korean": "야구", "chinese": "棒球", "pinyin": "bàngqiú"}, {"korean": "약", "chinese": "药", "pinyin": "yào"}]',
'比ㅏ多一横，代表y的加入', 'published'),

-- ㅓ (eo)
('ㅓ', 'basic_vowel', 'eo', '类似"eo/o"',
'介于"哦"和"呃"之间。嘴巴半开，比ㅏ更收敛。中国人容易与ㅗ混淆。',
2, 3,
'[{"korean": "어머니", "chinese": "母亲", "pinyin": "mǔqīn"}, {"korean": "언니", "chinese": "姐姐", "pinyin": "jiějie"}, {"korean": "서울", "chinese": "首尔", "pinyin": "shǒuěr"}]',
'一竖加一横向左，代表太阳在西方落下', 'published'),

-- ㅕ (yeo)
('ㅕ', 'basic_vowel', 'yeo', '类似"yeo"',
'在ㅓ前加"y"音。类似"约"但嘴巴不那么圆。',
3, 4,
'[{"korean": "여자", "chinese": "女人", "pinyin": "nǚrén"}, {"korean": "여행", "chinese": "旅行", "pinyin": "lǚxíng"}, {"korean": "겨울", "chinese": "冬天", "pinyin": "dōngtiān"}]',
'比ㅓ多一横，代表y的加入', 'published'),

-- ㅗ (o)
('ㅗ', 'basic_vowel', 'o', '类似"o"',
'类似中文"哦"的发音。嘴唇收圆，向前突出。',
2, 5,
'[{"korean": "오", "chinese": "五", "pinyin": "wǔ"}, {"korean": "오빠", "chinese": "哥哥", "pinyin": "gēge"}, {"korean": "고기", "chinese": "肉", "pinyin": "ròu"}]',
'一横加一竖向上，代表天', 'published'),

-- ㅛ (yo)
('ㅛ', 'basic_vowel', 'yo', '类似"yo"',
'在ㅗ前加"y"音。类似中文"哟"。',
3, 6,
'[{"korean": "요리", "chinese": "料理", "pinyin": "liàolǐ"}, {"korean": "교실", "chinese": "教室", "pinyin": "jiàoshì"}, {"korean": "요일", "chinese": "星期", "pinyin": "xīngqī"}]',
'比ㅗ多一竖，代表y的加入', 'published'),

-- ㅜ (u)
('ㅜ', 'basic_vowel', 'u', '类似"u"',
'类似中文"乌"的发音。嘴唇收圆向前突出，比ㅗ更紧。',
2, 7,
'[{"korean": "우유", "chinese": "牛奶", "pinyin": "niúnǎi"}, {"korean": "누나", "chinese": "姐姐", "pinyin": "jiějie"}, {"korean": "주스", "chinese": "果汁", "pinyin": "guǒzhī"}]',
'一横加一竖向下，代表地', 'published'),

-- ㅠ (yu)
('ㅠ', 'basic_vowel', 'yu', '类似"yu"',
'在ㅜ前加"y"音。类似中文"优"。',
3, 8,
'[{"korean": "유월", "chinese": "六月", "pinyin": "liùyuè"}, {"korean": "우유", "chinese": "牛奶", "pinyin": "niúnǎi"}, {"korean": "휴일", "chinese": "休息日", "pinyin": "xiūxīrì"}]',
'比ㅜ多一竖，代表y的加入', 'published'),

-- ㅡ (eu)
('ㅡ', 'basic_vowel', 'eu', '类似"eu/ü"',
'嘴唇扁平，舌头放平。类似中文"资"的韵母但不发舌尖音。中国人较难发音。',
1, 9,
'[{"korean": "으", "chinese": "（语助词）", "pinyin": "-"}, {"korean": "그", "chinese": "那/他", "pinyin": "nà/tā"}, {"korean": "크다", "chinese": "大", "pinyin": "dà"}]',
'一横线，代表地平线', 'published'),

-- ㅣ (i)
('ㅣ', 'basic_vowel', 'i', '类似"i"',
'类似中文"衣"的发音。嘴唇扁平向两边拉。',
1, 10,
'[{"korean": "이", "chinese": "二/这", "pinyin": "èr/zhè"}, {"korean": "기차", "chinese": "火车", "pinyin": "huǒchē"}, {"korean": "김치", "chinese": "泡菜", "pinyin": "pàocài"}]',
'一竖线，代表人站立', 'published');

-- ==================== Compound Vowels (복합 모음) - 11개 ====================

INSERT INTO hangul_characters (
    character, character_type, romanization, pronunciation_zh, pronunciation_tip_zh,
    stroke_count, display_order, example_words, mnemonics_zh, status
) VALUES
-- ㅐ (ae)
('ㅐ', 'compound_vowel', 'ae', '类似"ae/e"',
'介于"a"和"e"之间。现代韩语中与ㅔ发音几乎相同。',
3, 1,
'[{"korean": "애", "chinese": "孩子/爱", "pinyin": "háizi/ài"}, {"korean": "개", "chinese": "狗", "pinyin": "gǒu"}, {"korean": "새", "chinese": "鸟", "pinyin": "niǎo"}]',
'ㅏ + ㅣ 的组合', 'published'),

-- ㅒ (yae)
('ㅒ', 'compound_vowel', 'yae', '类似"yae"',
'在ㅐ前加"y"音。现代韩语中很少使用。',
4, 2,
'[{"korean": "얘기", "chinese": "故事/话", "pinyin": "gùshì/huà"}, {"korean": "걔", "chinese": "那个孩子", "pinyin": "nàge háizi"}]',
'ㅑ + ㅣ 的组合', 'published'),

-- ㅔ (e)
('ㅔ', 'compound_vowel', 'e', '类似"e"',
'类似中文"诶"的发音。与ㅐ发音几乎相同。',
3, 3,
'[{"korean": "에", "chinese": "在", "pinyin": "zài"}, {"korean": "네", "chinese": "是/你的", "pinyin": "shì/nǐde"}, {"korean": "세계", "chinese": "世界", "pinyin": "shìjiè"}]',
'ㅓ + ㅣ 的组合', 'published'),

-- ㅖ (ye)
('ㅖ', 'compound_vowel', 'ye', '类似"ye"',
'在ㅔ前加"y"音。类似中文"耶"。',
4, 4,
'[{"korean": "예", "chinese": "是", "pinyin": "shì"}, {"korean": "시계", "chinese": "钟表", "pinyin": "zhōngbiǎo"}, {"korean": "예쁘다", "chinese": "漂亮", "pinyin": "piàoliang"}]',
'ㅕ + ㅣ 的组合', 'published'),

-- ㅘ (wa)
('ㅘ', 'compound_vowel', 'wa', '类似"wa"',
'类似中文"哇"的发音。ㅗ和ㅏ快速连读。',
4, 5,
'[{"korean": "와", "chinese": "哇", "pinyin": "wa"}, {"korean": "과일", "chinese": "水果", "pinyin": "shuǐguǒ"}, {"korean": "화", "chinese": "火/画", "pinyin": "huǒ/huà"}]',
'ㅗ + ㅏ 的组合', 'published'),

-- ㅙ (wae)
('ㅙ', 'compound_vowel', 'wae', '类似"wae/we"',
'ㅗ和ㅐ快速连读。类似英语"way"。',
5, 6,
'[{"korean": "왜", "chinese": "为什么", "pinyin": "wèishénme"}, {"korean": "돼지", "chinese": "猪", "pinyin": "zhū"}, {"korean": "괜찮다", "chinese": "没关系", "pinyin": "méiguānxì"}]',
'ㅗ + ㅐ 的组合', 'published'),

-- ㅚ (oe)
('ㅚ', 'compound_vowel', 'oe', '类似"oe/we"',
'现代韩语中发音接近ㅙ或ㅞ。嘴唇圆后发"e"音。',
3, 7,
'[{"korean": "외", "chinese": "外", "pinyin": "wài"}, {"korean": "회사", "chinese": "公司", "pinyin": "gōngsī"}, {"korean": "외국", "chinese": "外国", "pinyin": "wàiguó"}]',
'ㅗ + ㅣ 的组合', 'published'),

-- ㅝ (wo)
('ㅝ', 'compound_vowel', 'wo', '类似"wo"',
'类似中文"我"的发音。ㅜ和ㅓ快速连读。',
4, 8,
'[{"korean": "원", "chinese": "韩元/愿望", "pinyin": "hányuán/yuànwàng"}, {"korean": "월", "chinese": "月", "pinyin": "yuè"}, {"korean": "권", "chinese": "卷/权", "pinyin": "juàn/quán"}]',
'ㅜ + ㅓ 的组合', 'published'),

-- ㅞ (we)
('ㅞ', 'compound_vowel', 'we', '类似"we"',
'ㅜ和ㅔ快速连读。类似英语"wet"中的元音。',
5, 9,
'[{"korean": "웨", "chinese": "（音节）", "pinyin": "-"}, {"korean": "웨이터", "chinese": "服务员", "pinyin": "fúwùyuán"}]',
'ㅜ + ㅔ 的组合', 'published'),

-- ㅟ (wi)
('ㅟ', 'compound_vowel', 'wi', '类似"wi"',
'类似中文"危"的发音。ㅜ和ㅣ快速连读。',
3, 10,
'[{"korean": "위", "chinese": "上/胃", "pinyin": "shàng/wèi"}, {"korean": "귀", "chinese": "耳朵", "pinyin": "ěrduo"}, {"korean": "취미", "chinese": "爱好", "pinyin": "àihào"}]',
'ㅜ + ㅣ 的组合', 'published'),

-- ㅢ (ui)
('ㅢ', 'compound_vowel', 'ui', '类似"ui/i"',
'词首发"ui"，词中常发"i"。"의"作为所有格时读"e"。发音规则较复杂。',
2, 11,
'[{"korean": "의사", "chinese": "医生", "pinyin": "yīshēng"}, {"korean": "의자", "chinese": "椅子", "pinyin": "yǐzi"}, {"korean": "희망", "chinese": "希望", "pinyin": "xīwàng"}]',
'ㅡ + ㅣ 的组合，发音规则多变', 'published');

-- ==================== End of Hangul Seed Data ====================
