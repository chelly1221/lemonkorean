import '../services/pronunciation_scorer.dart';

/// Multilingual pronunciation feedback generator.
///
/// Generates specific, actionable feedback tips based on per-phoneme scores
/// and common Korean pronunciation difficulties. Supports all 6 app languages:
/// ko (Korean), en (English), zh (Simplified Chinese), zh_TW (Traditional Chinese),
/// ja (Japanese), es (Spanish).
///
/// Feedback includes:
/// - Overall grade message (excellent/good/fair/needs practice)
/// - Per-phoneme tips for low-scoring phonemes (<70)
/// - Articulatory guidance tailored to each phoneme category
class PronunciationFeedback {
  // Private constructor - all methods are static
  PronunciationFeedback._();

  /// Generate feedback strings based on phoneme scores and overall grade.
  ///
  /// [phonemeScores] - per-phoneme score details from PronunciationScorer
  /// [overallScore] - 0-100 overall pronunciation score
  /// [language] - user's UI language code ('ko', 'en', 'zh', 'zh_TW', 'ja', 'es')
  ///
  /// Returns a list of feedback strings. The first item is always the overall
  /// grade message, followed by specific tips for problematic phonemes.
  /// Returns at most [maxTips]+1 strings (1 grade + N tips).
  static List<String> generateFeedback({
    required List<PhonemeScoreDetail> phonemeScores,
    required int overallScore,
    required String language,
  }) {
    final feedback = <String>[];
    final lang = _normalizeLanguage(language);

    // 1. Overall grade feedback
    feedback.add(_getGradeMessage(overallScore, lang));

    // 2. Collect low-scoring phonemes (score < 70)
    final weakPhonemes = phonemeScores
        .where((p) => p.score < 70 && p.expected.isNotEmpty)
        .toList()
      ..sort((a, b) => a.score.compareTo(b.score));

    if (weakPhonemes.isEmpty) return feedback;

    // 3. Generate specific tips, deduplicating by phoneme category
    final processedCategories = <String>{};
    int tipCount = 0;
    const maxTips = 3;

    for (final phoneme in weakPhonemes) {
      if (tipCount >= maxTips) break;

      final category = _getPhonemeCategory(phoneme.expected);
      if (category == null || processedCategories.contains(category)) continue;

      final tip = _getPhoneTip(
        expected: phoneme.expected,
        category: category,
        position: phoneme.position,
        lang: lang,
      );

      if (tip != null) {
        feedback.add(tip);
        processedCategories.add(category);
        tipCount++;
      }
    }

    return feedback;
  }

  /// Generate a single summary feedback string (for compact UI display).
  static String generateSummary({
    required int overallScore,
    required String language,
  }) {
    return _getGradeMessage(overallScore, _normalizeLanguage(language));
  }

  /// Normalize language code to supported values.
  static String _normalizeLanguage(String language) {
    switch (language.toLowerCase().replaceAll('-', '_')) {
      case 'ko':
        return 'ko';
      case 'en':
        return 'en';
      case 'zh':
      case 'zh_cn':
      case 'zh_hans':
        return 'zh';
      case 'zh_tw':
      case 'zh_hant':
        return 'zh_TW';
      case 'ja':
        return 'ja';
      case 'es':
        return 'es';
      default:
        return 'en';
    }
  }

  /// Get the overall grade message in the target language.
  static String _getGradeMessage(int score, String lang) {
    if (score >= 90) {
      return _gradeExcellent[lang]!;
    } else if (score >= 70) {
      return _gradeGood[lang]!;
    } else if (score >= 50) {
      return _gradeFair[lang]!;
    } else {
      return _gradeNeedsPractice[lang]!;
    }
  }

  /// Categorize a phoneme for tip grouping.
  /// Returns null for phonemes without specific tips.
  static String? _getPhonemeCategory(String phoneme) {
    // Aspirated consonant confusion (ㄱ/ㅋ, ㄷ/ㅌ, ㅂ/ㅍ, ㅈ/ㅊ)
    if (_aspiratedSets.any((set) => set.contains(phoneme))) {
      return 'aspiration';
    }
    // Tense consonant confusion (ㄲ, ㄸ, ㅃ, ㅆ, ㅉ)
    if (_tenseConsonants.contains(phoneme)) {
      return 'tense';
    }
    // ㄹ/ㄴ distinction
    if (phoneme == 'ㄹ' || phoneme == 'ㄴ') {
      return 'rieul_nieun';
    }
    // ㅐ/ㅔ distinction
    if (phoneme == 'ㅐ' || phoneme == 'ㅔ') {
      return 'ae_e_merge';
    }
    // Open vowel distinction (ㅏ/ㅓ)
    if (phoneme == 'ㅏ' || phoneme == 'ㅓ') {
      return 'open_vowels';
    }
    // Rounded vowels (ㅗ/ㅜ)
    if (phoneme == 'ㅗ' || phoneme == 'ㅜ') {
      return 'rounded_vowels';
    }
    // ㅡ/ㅣ distinction
    if (phoneme == 'ㅡ' || phoneme == 'ㅣ') {
      return 'eu_i';
    }
    // ㅎ (glottal)
    if (phoneme == 'ㅎ') {
      return 'hieut';
    }
    // ㅇ as initial (silent) vs final (ng)
    if (phoneme == 'ㅇ') {
      return 'ieung';
    }

    return null;
  }

  /// Generate a specific pronunciation tip for a problematic phoneme.
  static String? _getPhoneTip({
    required String expected,
    required String category,
    required String position,
    required String lang,
  }) {
    final tips = _categoryTips[category];
    if (tips == null) return null;
    return tips[lang];
  }

  // ================================================================
  // Phoneme classification data
  // ================================================================

  static const List<Set<String>> _aspiratedSets = [
    {'ㄱ', 'ㅋ'},
    {'ㄷ', 'ㅌ'},
    {'ㅂ', 'ㅍ'},
    {'ㅈ', 'ㅊ'},
  ];

  static const Set<String> _tenseConsonants = {
    'ㄲ', 'ㄸ', 'ㅃ', 'ㅆ', 'ㅉ',
  };

  // ================================================================
  // Overall grade messages (6 languages)
  // ================================================================

  static const Map<String, String> _gradeExcellent = {
    'ko': '훌륭해요! 발음이 정말 좋습니다!',
    'en': 'Excellent! Your pronunciation is great!',
    'zh': '太棒了！你的发音非常好！',
    'zh_TW': '太棒了！你的發音非常好！',
    'ja': '素晴らしい！発音がとても上手です！',
    'es': '!Excelente! !Tu pronunciacion es genial!',
  };

  static const Map<String, String> _gradeGood = {
    'ko': '잘했어요! 조금만 더 연습하면 완벽해질 거예요.',
    'en': 'Good job! A little more practice and you\'ll be perfect.',
    'zh': '做得好！再多练习一点就完美了。',
    'zh_TW': '做得好！再多練習一點就完美了。',
    'ja': 'よくできました！もう少し練習すれば完璧です。',
    'es': '!Buen trabajo! Un poco mas de practica y seras perfecto.',
  };

  static const Map<String, String> _gradeFair = {
    'ko': '점점 나아지고 있어요! 아래 팁을 참고해 보세요.',
    'en': 'Getting better! Check out the tips below.',
    'zh': '在进步！请参考下面的提示。',
    'zh_TW': '在進步！請參考下面的提示。',
    'ja': '上達しています！下のヒントを参考にしてください。',
    'es': '!Vas mejorando! Revisa los consejos de abajo.',
  };

  static const Map<String, String> _gradeNeedsPractice = {
    'ko': '계속 연습해 봐요! 천천히 따라 해 보세요.',
    'en': 'Keep practicing! Try saying it slowly.',
    'zh': '继续加油！试着慢慢地跟读。',
    'zh_TW': '繼續加油！試著慢慢地跟讀。',
    'ja': '練習を続けましょう！ゆっくり言ってみてください。',
    'es': '!Sigue practicando! Intenta decirlo lentamente.',
  };

  // ================================================================
  // Per-category pronunciation tips (6 languages)
  // ================================================================

  static const Map<String, Map<String, String>> _categoryTips = {
    'aspiration': {
      'ko': '예사소리(ㄱ,ㄷ,ㅂ,ㅈ)와 거센소리(ㅋ,ㅌ,ㅍ,ㅊ)를 구별해 보세요. '
          '거센소리는 입에서 바람이 세게 나와야 합니다.',
      'en': 'Distinguish between plain (ㄱ,ㄷ,ㅂ,ㅈ) and aspirated (ㅋ,ㅌ,ㅍ,ㅊ) consonants. '
          'For aspirated sounds, release a strong puff of air.',
      'zh': '区分松音（ㄱ,ㄷ,ㅂ,ㅈ）和送气音（ㅋ,ㅌ,ㅍ,ㅊ）。'
          '送气音需要从嘴里送出强气流。',
      'zh_TW': '區分鬆音（ㄱ,ㄷ,ㅂ,ㅈ）和送氣音（ㅋ,ㅌ,ㅍ,ㅊ）。'
          '送氣音需要從嘴裡送出強氣流。',
      'ja': '平音（ㄱ,ㄷ,ㅂ,ㅈ）と激音（ㅋ,ㅌ,ㅍ,ㅊ）を区別しましょう。'
          '激音は口から強い息を出します。',
      'es': 'Distingue entre consonantes simples (ㄱ,ㄷ,ㅂ,ㅈ) y aspiradas (ㅋ,ㅌ,ㅍ,ㅊ). '
          'Para las aspiradas, libera un soplo fuerte de aire.',
    },
    'tense': {
      'ko': '된소리(ㄲ,ㄸ,ㅃ,ㅆ,ㅉ)는 목에 힘을 주고 '
          '바람 없이 짧고 강하게 발음하세요.',
      'en': 'For tense consonants (ㄲ,ㄸ,ㅃ,ㅆ,ㅉ), tighten your throat '
          'and pronounce with a short, strong burst without air.',
      'zh': '紧音（ㄲ,ㄸ,ㅃ,ㅆ,ㅉ）需要收紧喉咙，'
          '不送气，短促有力地发音。',
      'zh_TW': '緊音（ㄲ,ㄸ,ㅃ,ㅆ,ㅉ）需要收緊喉嚨，'
          '不送氣，短促有力地發音。',
      'ja': '濃音（ㄲ,ㄸ,ㅃ,ㅆ,ㅉ）は喉を緊張させ、'
          '息を出さずに短く強く発音します。',
      'es': 'Para las consonantes tensas (ㄲ,ㄸ,ㅃ,ㅆ,ㅉ), tensa la garganta '
          'y pronuncia con un golpe corto y fuerte sin aire.',
    },
    'rieul_nieun': {
      'ko': 'ㄹ은 혀끝이 윗잇몸에 가볍게 닿았다 떨어지는 소리예요. '
          'ㄴ과 혼동하지 않도록 혀의 위치에 집중하세요.',
      'en': 'For ㄹ, lightly tap the tip of your tongue against the gum ridge. '
          'It\'s between English L and R. Don\'t confuse it with ㄴ (N sound).',
      'zh': 'ㄹ发音时舌尖轻触上牙龈然后弹开，'
          '介于L和R之间。不要和ㄴ（N音）混淆。',
      'zh_TW': 'ㄹ發音時舌尖輕觸上牙齦然後彈開，'
          '介於L和R之間。不要和ㄴ（N音）混淆。',
      'ja': 'ㄹは舌先を歯茎に軽く当てて弾く音です。'
          '日本語のラ行に近いですが、ㄴ（ナ行）と混同しないようにしましょう。',
      'es': 'Para ㄹ, toca ligeramente la punta de la lengua en la cresta alveolar. '
          'Es similar a la R suave en espanol. No lo confundas con ㄴ (sonido N).',
    },
    'ae_e_merge': {
      'ko': 'ㅐ와 ㅔ는 현대 한국어에서 거의 같은 소리입니다. '
          '크게 걱정하지 않아도 돼요!',
      'en': 'ㅐ and ㅔ sound nearly identical in modern Korean. '
          'Don\'t worry too much about distinguishing them!',
      'zh': 'ㅐ和ㅔ在现代韩语中发音几乎相同，'
          '不用太担心区分它们！',
      'zh_TW': 'ㅐ和ㅔ在現代韓語中發音幾乎相同，'
          '不用太擔心區分它們！',
      'ja': 'ㅐとㅔは現代韓国語ではほぼ同じ音です。'
          'あまり区別を気にしなくて大丈夫です！',
      'es': 'ㅐ y ㅔ suenan casi identicos en el coreano moderno. '
          '!No te preocupes demasiado por distinguirlos!',
    },
    'open_vowels': {
      'ko': 'ㅏ는 입을 크게 벌리고, ㅓ는 입을 약간만 벌리세요. '
          '입 모양의 차이에 집중해 보세요.',
      'en': 'For ㅏ, open your mouth wide (like "ah"). '
          'For ㅓ, open less (like "uh"). Focus on the mouth shape difference.',
      'zh': 'ㅏ要张大嘴（类似"啊"），'
          'ㅓ嘴张得小一些（类似"呃"）。注意口型的区别。',
      'zh_TW': 'ㅏ要張大嘴（類似「啊」），'
          'ㅓ嘴張得小一些（類似「呃」）。注意口型的區別。',
      'ja': 'ㅏは口を大きく開けて（「あ」のように）、'
          'ㅓは少しだけ開けます（「お」に近い）。口の形の違いに注目しましょう。',
      'es': 'Para ㅏ, abre la boca ampliamente (como "ah"). '
          'Para ㅓ, abre menos (como "uh"). Enfocate en la forma de la boca.',
    },
    'rounded_vowels': {
      'ko': 'ㅗ는 입술을 둥글게 모아 "오"로, '
          'ㅜ는 입술을 더 좁게 모아 "우"로 발음하세요.',
      'en': 'For ㅗ, round your lips into an "O" shape. '
          'For ㅜ, round them tighter into an "OO" shape.',
      'zh': 'ㅗ嘴唇要圆（像"哦"），'
          'ㅜ嘴唇更圆更收紧（像"乌"）。',
      'zh_TW': 'ㅗ嘴唇要圓（像「哦」），'
          'ㅜ嘴唇更圓更收緊（像「烏」）。',
      'ja': 'ㅗは唇を丸く「オ」の形に、'
          'ㅜは唇をもっと丸く絞って「ウ」の形にしましょう。',
      'es': 'Para ㅗ, redondea los labios en forma de "O". '
          'Para ㅜ, redondealos mas en forma de "U".',
    },
    'eu_i': {
      'ko': 'ㅡ는 입을 옆으로 벌리고 혀를 뒤로 빼세요. '
          'ㅣ는 입을 옆으로 벌리고 혀를 앞으로 하세요.',
      'en': 'For ㅡ, spread your lips and pull your tongue back. '
          'For ㅣ, spread your lips and push your tongue forward (like "ee").',
      'zh': 'ㅡ嘴唇横向展开，舌头向后缩。'
          'ㅣ嘴唇横向展开，舌头向前（像"衣"）。',
      'zh_TW': 'ㅡ嘴唇橫向展開，舌頭向後縮。'
          'ㅣ嘴唇橫向展開，舌頭向前（像「衣」）。',
      'ja': 'ㅡは唇を横に広げて舌を後ろに引きます。'
          'ㅣは唇を横に広げて舌を前に出します（「い」のように）。',
      'es': 'Para ㅡ, extiende los labios y retrae la lengua. '
          'Para ㅣ, extiende los labios y empuja la lengua hacia adelante (como "i").',
    },
    'hieut': {
      'ko': 'ㅎ은 목에서 나오는 바람 소리예요. '
          '영어의 H와 비슷하지만 조금 더 강하게 발음하세요.',
      'en': 'ㅎ is a breathy sound from the throat, similar to English H. '
          'Make sure to produce a clear puff of air.',
      'zh': 'ㅎ是从喉咙发出的气音，类似英语的H。'
          '确保送出清晰的气流。',
      'zh_TW': 'ㅎ是從喉嚨發出的氣音，類似英語的H。'
          '確保送出清晰的氣流。',
      'ja': 'ㅎは喉から出る息の音で、英語のHに似ています。'
          'はっきりと息を出しましょう。',
      'es': 'ㅎ es un sonido aspirado de la garganta, similar a la H en ingles. '
          'Asegurate de producir un soplo claro de aire.',
    },
    'ieung': {
      'ko': '초성 ㅇ은 소리가 없고, 받침 ㅇ은 콧소리 "ng"예요. '
          '받침 ㅇ 발음할 때 혀 뒤쪽을 올려 보세요.',
      'en': 'ㅇ is silent at the start of a syllable. As a final consonant, '
          'it\'s the "ng" sound. Raise the back of your tongue for the nasal sound.',
      'zh': 'ㅇ在音节开头不发音。作为收音时，'
          '发"ng"音。将舌根抬起发出鼻音。',
      'zh_TW': 'ㅇ在音節開頭不發音。作為收音時，'
          '發「ng」音。將舌根抬起發出鼻音。',
      'ja': 'ㅇは音節の最初では無音です。パッチムの場合は'
          '「ng」の音になります。舌の後ろを上げて鼻音を出しましょう。',
      'es': 'ㅇ es silenciosa al inicio de una silaba. Como consonante final, '
          'es el sonido "ng". Levanta la parte posterior de la lengua para el sonido nasal.',
    },
  };
}
