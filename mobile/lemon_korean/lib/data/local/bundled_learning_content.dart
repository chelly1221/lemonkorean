import '../models/hangul_character_model.dart';
import '../models/lesson_model.dart';
import '../models/vocabulary_model.dart';

class BundledLearningContent {
  BundledLearningContent._();

  static final DateTime _seededAt = DateTime.utc(2026, 2, 25);

  static String _strokeAsset(String char) {
    final hex = char.codeUnitAt(0).toRadixString(16);
    return 'assets/hangul/stroke_order/u$hex.webp';
  }

  static List<HangulCharacterModel> get hangulCharacters => [
        ..._buildHangul(
            'basic_consonant',
            const [
              ['ㄱ', 'g/k'],
              ['ㄴ', 'n'],
              ['ㄷ', 'd/t'],
              ['ㄹ', 'r/l'],
              ['ㅁ', 'm'],
              ['ㅂ', 'b/p'],
              ['ㅅ', 's'],
              ['ㅇ', 'ng/silent'],
              ['ㅈ', 'j'],
              ['ㅊ', 'ch'],
              ['ㅋ', 'k'],
              ['ㅌ', 't'],
              ['ㅍ', 'p'],
              ['ㅎ', 'h'],
            ],
            startId: 1),
        ..._buildHangul(
            'double_consonant',
            const [
              ['ㄲ', 'kk'],
              ['ㄸ', 'tt'],
              ['ㅃ', 'pp'],
              ['ㅆ', 'ss'],
              ['ㅉ', 'jj'],
            ],
            startId: 15),
        ..._buildHangul(
            'basic_vowel',
            const [
              ['ㅏ', 'a'],
              ['ㅑ', 'ya'],
              ['ㅓ', 'eo'],
              ['ㅕ', 'yeo'],
              ['ㅗ', 'o'],
              ['ㅛ', 'yo'],
              ['ㅜ', 'u'],
              ['ㅠ', 'yu'],
              ['ㅡ', 'eu'],
              ['ㅣ', 'i'],
            ],
            startId: 20),
        ..._buildHangul(
            'compound_vowel',
            const [
              ['ㅐ', 'ae'],
              ['ㅒ', 'yae'],
              ['ㅔ', 'e'],
              ['ㅖ', 'ye'],
              ['ㅘ', 'wa'],
              ['ㅙ', 'wae'],
              ['ㅚ', 'oe'],
              ['ㅝ', 'wo'],
              ['ㅞ', 'we'],
              ['ㅟ', 'wi'],
              ['ㅢ', 'ui'],
            ],
            startId: 30),
      ];

  static List<HangulCharacterModel> _buildHangul(
    String type,
    List<List<String>> items, {
    required int startId,
  }) {
    return List<HangulCharacterModel>.generate(items.length, (index) {
      final item = items[index];
      final char = item[0];
      final roman = item[1];
      return HangulCharacterModel(
        id: startId + index,
        character: char,
        characterType: type,
        romanization: roman,
        pronunciationZh: roman,
        strokeCount: 1,
        strokeOrderUrl: _strokeAsset(char),
        displayOrder: index + 1,
        status: 'published',
        createdAt: _seededAt,
        updatedAt: _seededAt,
      );
    });
  }

  static final List<VocabularyModel> vocabulary = _buildVocabulary();
  static final List<LessonModel> lessons = _buildLessons();
  static final Map<int, List<int>> lessonVocabularyMap =
      _buildLessonVocabularyMap();

  static List<LessonModel> _buildLessons() {
    final out = <LessonModel>[];

    const plans = <int, List<List<String>>>{
      1: [
        ['인사하기', 'Greetings'],
        ['자기소개', 'Self Introduction'],
        ['감사와 사과', 'Thanks and Sorry'],
        ['숫자와 시간', 'Numbers and Time'],
      ],
      2: [
        ['장소 묻기', 'Asking Places'],
        ['음식 주문', 'Ordering Food'],
        ['취미 말하기', 'Talking Hobbies'],
        ['하루 일과', 'Daily Routine'],
      ],
      3: [
        ['쇼핑 표현', 'Shopping Expressions'],
        ['교통 이용', 'Using Transportation'],
        ['약속 잡기', 'Making Appointments'],
        ['날씨 이야기', 'Talking Weather'],
      ],
      4: [
        ['경험 말하기', 'Talking Experience'],
        ['의견 표현', 'Expressing Opinions'],
        ['비교하기', 'Making Comparisons'],
        ['계획 세우기', 'Making Plans'],
      ],
      5: [
        ['문제 해결', 'Problem Solving'],
        ['감정 표현', 'Expressing Emotions'],
        ['설명과 안내', 'Explanation and Guidance'],
        ['뉴스 이해', 'Understanding News'],
      ],
      6: [
        ['토론 기초', 'Discussion Basics'],
        ['공식 표현', 'Formal Expressions'],
        ['발표 연습', 'Presentation Practice'],
        ['종합 복습', 'Comprehensive Review'],
      ],
    };

    for (final entry in plans.entries) {
      final level = entry.key;
      final lessonTitles = entry.value;
      for (var i = 0; i < lessonTitles.length; i++) {
        final id = level * 100 + (i + 1);
        final titleKo = lessonTitles[i][0];
        final title = lessonTitles[i][1];
        final wordIds = [id * 10 + 1, id * 10 + 2, id * 10 + 3];
        out.add(
          LessonModel(
            id: id,
            level: level,
            week: i + 1,
            orderNum: i + 1,
            titleKo: titleKo,
            title: title,
            description: '$titleKo 레슨입니다.',
            estimatedMinutes: 20,
            vocabularyCount: wordIds.length,
            status: 'published',
            version: 'local-1.0.0',
            createdAt: _seededAt,
            updatedAt: _seededAt,
            content: _lessonContent(level, id, titleKo, title, wordIds),
          ),
        );
      }
    }
    return out;
  }

  static Map<String, dynamic> _lessonContent(
    int level,
    int lessonId,
    String titleKo,
    String title,
    List<int> wordIds,
  ) {
    final words = wordIds.map((id) {
      final word = vocabulary.firstWhere((v) => v.id == id);
      return {
        'id': word.id,
        'korean': word.korean,
        'chinese': word.translation,
        'translation': word.translation,
        'pinyin': word.pronunciation,
        'pronunciation': word.pronunciation,
        'part_of_speech': word.partOfSpeech,
      };
    }).toList();

    return {
      'stages': [
        {
          'id': 'intro',
          'type': 'intro',
          'order': 1,
          'data': {
            'title': titleKo,
            'description': '$title 레슨 시작',
          },
        },
        {
          'id': 'vocabulary',
          'type': 'vocabulary',
          'order': 2,
          'data': {'words': words},
        },
        {
          'id': 'grammar',
          'type': 'grammar',
          'order': 3,
          'data': {
            'grammar_points': [
              {
                'title': '-아요/어요',
                'titleZh': '现在时表达',
                'explanation': '동사 어간 뒤에 -아요/어요를 붙입니다.',
                'examples': [
                  {
                    'korean': '저는 한국어를 공부해요.',
                    'chinese': '我学习韩语。',
                    'highlight': '공부해요'
                  }
                ]
              }
            ]
          },
        },
        {
          'id': 'practice',
          'type': 'practice',
          'order': 4,
          'data': {
            'exercises': [
              {
                'question': '${words[0]['korean']}의 뜻은?',
                'options': [
                  words[0]['chinese'],
                  words[1]['chinese'],
                  words[2]['chinese']
                ],
                'correctAnswer': words[0]['chinese'],
              }
            ]
          },
        },
        {
          'id': 'dialogue',
          'type': 'dialogue',
          'order': 5,
          'data': {
            'dialogues': [
              {
                'title': '$titleKo 대화',
                'titleZh': '$title Dialogue',
                'speakerA': {'name': '민수', 'avatarUrl': null},
                'speakerB': {'name': '지영', 'avatarUrl': null},
                'lines': [
                  {
                    'speaker': 'A',
                    'korean': '${words[0]['korean']}!',
                    'chinese': words[0]['chinese']
                  },
                  {
                    'speaker': 'B',
                    'korean': '${words[1]['korean']}.',
                    'chinese': words[1]['chinese']
                  },
                ]
              }
            ]
          },
        },
        {
          'id': 'quiz',
          'type': 'quiz',
          'order': 6,
          'data': {
            'questions': [
              {
                'type': 'vocabulary',
                'vocabulary_id': words[0]['id'],
                'question': '${words[0]['korean']}의 뜻을 고르세요.',
                'options': [
                  words[0]['chinese'],
                  words[1]['chinese'],
                  words[2]['chinese']
                ],
                'correctAnswer': words[0]['chinese'],
              },
              {
                'type': 'vocabulary',
                'vocabulary_id': words[1]['id'],
                'question': '${words[1]['chinese']}에 해당하는 단어는?',
                'options': [
                  words[0]['korean'],
                  words[1]['korean'],
                  words[2]['korean']
                ],
                'correctAnswer': words[1]['korean'],
              }
            ]
          },
        },
        {
          'id': 'summary',
          'type': 'summary',
          'order': 7,
          'data': {
            'lesson_id': lessonId,
            'level': level,
            'vocabulary_count': words.length,
          },
        },
      ],
    };
  }

  static List<VocabularyModel> _buildVocabulary() {
    final out = <VocabularyModel>[];

    for (var level = 1; level <= 6; level++) {
      for (var lessonOrder = 1; lessonOrder <= 4; lessonOrder++) {
        final lessonId = level * 100 + lessonOrder;
        out.addAll([
          VocabularyModel(
            id: lessonId * 10 + 1,
            korean: '안녕하세요',
            translation: '你好',
            pronunciation: 'annyeonghaseyo',
            partOfSpeech: 'interjection',
            level: level,
            similarityScore: 0.8,
            createdAt: _seededAt,
          ),
          VocabularyModel(
            id: lessonId * 10 + 2,
            korean: '감사합니다',
            translation: '谢谢',
            pronunciation: 'gamsahamnida',
            partOfSpeech: 'interjection',
            level: level,
            similarityScore: 0.65,
            createdAt: _seededAt,
          ),
          VocabularyModel(
            id: lessonId * 10 + 3,
            korean: '학생',
            translation: '学生',
            pronunciation: 'haksaeng',
            partOfSpeech: 'noun',
            level: level,
            similarityScore: 0.9,
            createdAt: _seededAt,
          ),
        ]);
      }
    }

    return out;
  }

  static Map<int, List<int>> _buildLessonVocabularyMap() {
    final map = <int, List<int>>{};
    for (var level = 1; level <= 6; level++) {
      for (var lessonOrder = 1; lessonOrder <= 4; lessonOrder++) {
        final lessonId = level * 100 + lessonOrder;
        map[lessonId] = [
          lessonId * 10 + 1,
          lessonId * 10 + 2,
          lessonId * 10 + 3
        ];
      }
    }
    return map;
  }
}
