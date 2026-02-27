import 'dart:math';

/// Korean phoneme utilities for Hangul decomposition and phoneme sequence generation.
/// Used by the pronunciation scorer to compare expected vs actual phonemes.
///
/// Handles:
/// - Decomposing Hangul syllables (가-힣) into jamo (초성/중성/종성)
/// - Generating flat phoneme sequences from Korean text
/// - Computing phoneme-level similarity for scoring
class KoreanPhonemeUtils {
  // Unicode constants for Hangul syllable decomposition
  static const int _hangulBase = 0xAC00; // '가'
  static const int _hangulEnd = 0xD7A3; // '힣'
  // Note: initial count is implicitly 19 (initials.length).
  static const int _medialCount = 21;
  static const int _finalCount = 28; // includes empty (0)

  /// Korean initial consonants (초성) in Unicode order
  static const List<String> initials = [
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  /// Korean medial vowels (중성) in Unicode order
  static const List<String> medials = [
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
    'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
  ];

  /// Korean final consonants (종성) in Unicode order.
  /// Index 0 is empty string representing no final consonant.
  static const List<String> finals = [
    '', 'ㄱ', 'ㄲ', 'ㄳ', 'ㄴ', 'ㄵ', 'ㄶ', 'ㄷ', 'ㄹ', 'ㄺ',
    'ㄻ', 'ㄼ', 'ㄽ', 'ㄾ', 'ㄿ', 'ㅀ', 'ㅁ', 'ㅂ', 'ㅄ', 'ㅅ',
    'ㅆ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
  ];

  /// Check if a character is a Hangul syllable (가-힣).
  static bool isHangulSyllable(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return code >= _hangulBase && code <= _hangulEnd;
  }

  /// Check if a character is a single jamo (ㄱ-ㅎ, ㅏ-ㅣ).
  static bool isJamo(String char) {
    if (char.isEmpty) return false;
    final code = char.codeUnitAt(0);
    return code >= 0x3131 && code <= 0x3163; // consonants + vowels
  }

  /// Check if a jamo is a consonant.
  static bool isConsonant(String jamo) {
    if (jamo.isEmpty) return false;
    return initials.contains(jamo) || finals.contains(jamo);
  }

  /// Check if a jamo is a vowel.
  static bool isVowel(String jamo) {
    if (jamo.isEmpty) return false;
    return medials.contains(jamo);
  }

  /// Decompose a single Hangul syllable into (initial, medial, final).
  /// Returns null if not a valid Hangul syllable (가-힣).
  static HangulDecomposition? decompose(String syllable) {
    if (syllable.isEmpty) return null;
    final code = syllable.codeUnitAt(0);

    if (code < _hangulBase || code > _hangulEnd) return null;

    final offset = code - _hangulBase;
    final initialIdx = offset ~/ (_medialCount * _finalCount);
    final medialIdx = (offset % (_medialCount * _finalCount)) ~/ _finalCount;
    final finalIdx = offset % _finalCount;

    return HangulDecomposition(
      initial: initials[initialIdx],
      medial: medials[medialIdx],
      final_: finals[finalIdx],
    );
  }

  /// Decompose all Hangul syllables in a string.
  /// Non-Hangul characters are skipped.
  static List<HangulDecomposition> decomposeAll(String text) {
    final results = <HangulDecomposition>[];
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final d = decompose(char);
      if (d != null) {
        results.add(d);
      }
    }
    return results;
  }

  /// Convert text to a flat phoneme sequence.
  ///
  /// Examples:
  /// - '가' -> ['ㄱ', 'ㅏ']
  /// - '한' -> ['ㅎ', 'ㅏ', 'ㄴ']
  /// - '한국어' -> ['ㅎ', 'ㅏ', 'ㄴ', 'ㄱ', 'ㅜ', 'ㄱ', 'ㅇ', 'ㅓ']
  ///
  /// Non-Korean characters are silently skipped.
  static List<String> toPhonemeSequence(String text) {
    final phonemes = <String>[];
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      if (isHangulSyllable(char)) {
        final d = decompose(char);
        if (d != null) {
          phonemes.add(d.initial);
          phonemes.add(d.medial);
          if (d.final_.isNotEmpty) {
            phonemes.add(d.final_);
          }
        }
      } else if (isJamo(char)) {
        phonemes.add(char);
      }
      // Skip non-Korean characters (spaces, punctuation, etc.)
    }
    return phonemes;
  }

  /// Get the phoneme position type for scoring weights.
  ///
  /// [indexInSyllable] is 0-based within the syllable:
  /// 0 = initial consonant, 1 = medial vowel, 2 = final consonant.
  static PhonemePosition getPosition(int indexInSyllable) {
    switch (indexInSyllable) {
      case 0:
        return PhonemePosition.initial;
      case 1:
        return PhonemePosition.medial;
      default:
        return PhonemePosition.final_;
    }
  }

  /// Compute phoneme-level similarity between two phonemes.
  /// Returns a score from 0 (completely different) to 100 (identical).
  ///
  /// Uses linguistically-motivated similarity matrices that reflect
  /// common L1 interference patterns (learner confusion pairs).
  static int phonemeSimilarity(String expected, String actual) {
    if (expected == actual) return 100;
    if (expected.isEmpty || actual.isEmpty) return 0;

    // Check similar consonants
    final consonantMap = similarConsonants[expected];
    if (consonantMap != null && consonantMap.containsKey(actual)) {
      return consonantMap[actual]!;
    }

    // Check similar vowels
    final vowelMap = similarVowels[expected];
    if (vowelMap != null && vowelMap.containsKey(actual)) {
      return vowelMap[actual]!;
    }

    return 0;
  }

  /// Compute sequence-level phoneme similarity between two Korean texts.
  ///
  /// Uses a modified Needleman-Wunsch alignment with the phoneme similarity
  /// matrix instead of binary match/mismatch, then averages aligned pair
  /// scores.
  ///
  /// Returns 0-100 overall similarity score.
  static double sequenceSimilarity(String expected, String actual) {
    final expectedPhonemes = toPhonemeSequence(expected);
    final actualPhonemes = toPhonemeSequence(actual);

    if (expectedPhonemes.isEmpty && actualPhonemes.isEmpty) return 100.0;
    if (expectedPhonemes.isEmpty || actualPhonemes.isEmpty) return 0.0;

    // Build alignment using Needleman-Wunsch with phoneme similarity scores
    final aligned = _alignPhonemes(expectedPhonemes, actualPhonemes);
    if (aligned.isEmpty) return 0.0;

    double totalScore = 0.0;
    for (final pair in aligned) {
      totalScore += pair.score;
    }
    return totalScore / aligned.length;
  }

  /// Align two phoneme sequences using Needleman-Wunsch dynamic programming.
  ///
  /// Uses the phoneme similarity matrix for substitution scores and a
  /// gap penalty for insertions/deletions.
  static List<AlignedPhonemePair> _alignPhonemes(
    List<String> expected,
    List<String> actual,
  ) {
    const double gapPenalty = -30.0;
    final int m = expected.length;
    final int n = actual.length;

    // DP matrix: score[i][j] = best score aligning expected[0..i-1] with actual[0..j-1]
    final score = List.generate(
      m + 1,
      (_) => List.filled(n + 1, 0.0),
    );

    // Initialize gap rows/columns
    for (int i = 1; i <= m; i++) {
      score[i][0] = score[i - 1][0] + gapPenalty;
    }
    for (int j = 1; j <= n; j++) {
      score[0][j] = score[0][j - 1] + gapPenalty;
    }

    // Fill DP matrix
    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        final sim = phonemeSimilarity(expected[i - 1], actual[j - 1]).toDouble();
        // Convert 0-100 similarity to alignment score range (-30 to +100)
        final matchScore = sim > 0 ? sim : -30.0;

        final diagScore = score[i - 1][j - 1] + matchScore;
        final upScore = score[i - 1][j] + gapPenalty;
        final leftScore = score[i][j - 1] + gapPenalty;

        score[i][j] = max(diagScore, max(upScore, leftScore));
      }
    }

    // Traceback to recover alignment
    final aligned = <AlignedPhonemePair>[];
    int i = m, j = n;
    while (i > 0 || j > 0) {
      if (i > 0 && j > 0) {
        final sim = phonemeSimilarity(expected[i - 1], actual[j - 1]).toDouble();
        final matchScore = sim > 0 ? sim : -30.0;

        if (score[i][j] == score[i - 1][j - 1] + matchScore) {
          aligned.add(AlignedPhonemePair(
            expected: expected[i - 1],
            actual: actual[j - 1],
            score: sim,
          ));
          i--;
          j--;
          continue;
        }
      }
      if (i > 0 && score[i][j] == score[i - 1][j] + gapPenalty) {
        // Deletion: expected phoneme has no match in actual
        aligned.add(AlignedPhonemePair(
          expected: expected[i - 1],
          actual: '',
          score: 0.0,
        ));
        i--;
      } else {
        // Insertion: actual has extra phoneme not in expected
        aligned.add(AlignedPhonemePair(
          expected: '',
          actual: actual[j - 1],
          score: 0.0,
        ));
        j--;
      }
    }

    return aligned.reversed.toList();
  }

  /// Similar consonant pairs with similarity scores (0-100).
  ///
  /// Scores are based on articulatory proximity and common L1 interference:
  /// - Plain/aspirated pairs (ㄱ/ㅋ, ㄷ/ㅌ, etc.): 70 (same place, different aspiration)
  /// - Plain/tense pairs (ㄱ/ㄲ, ㄷ/ㄸ, etc.): 60 (same place, different tension)
  /// - Aspirated/tense pairs: 50 (same place, different manner)
  /// - Nasal/liquid (ㄴ/ㄹ): 50 (common confusion for many L1 speakers)
  /// - Cross-manner pairs: 20-30 (rare confusion)
  static const Map<String, Map<String, int>> similarConsonants = {
    'ㄱ': {'ㅋ': 70, 'ㄲ': 60, 'ㅇ': 20},
    'ㄲ': {'ㄱ': 60, 'ㅋ': 50},
    'ㅋ': {'ㄱ': 70, 'ㄲ': 50},
    'ㄴ': {'ㄹ': 50, 'ㅁ': 30},
    'ㄷ': {'ㅌ': 70, 'ㄸ': 60, 'ㄹ': 25},
    'ㄸ': {'ㄷ': 60, 'ㅌ': 50},
    'ㅌ': {'ㄷ': 70, 'ㄸ': 50},
    'ㄹ': {'ㄴ': 50},
    'ㅁ': {'ㄴ': 30, 'ㅂ': 20},
    'ㅂ': {'ㅍ': 70, 'ㅃ': 60, 'ㅁ': 20},
    'ㅃ': {'ㅂ': 60, 'ㅍ': 50},
    'ㅍ': {'ㅂ': 70, 'ㅃ': 50},
    'ㅅ': {'ㅆ': 60, 'ㅈ': 30},
    'ㅆ': {'ㅅ': 60},
    'ㅇ': {'ㄱ': 20},
    'ㅈ': {'ㅊ': 70, 'ㅉ': 60, 'ㅅ': 30},
    'ㅉ': {'ㅈ': 60, 'ㅊ': 50},
    'ㅊ': {'ㅈ': 70, 'ㅉ': 50},
    'ㅎ': {},
  };

  /// Similar vowel pairs with similarity scores (0-100).
  ///
  /// Scores reflect articulatory distance and common learner confusion:
  /// - ㅐ/ㅔ: 80 (merged in modern Seoul Korean, nearly identical)
  /// - ㅒ/ㅖ: 80 (y-glide variants of ㅐ/ㅔ, also merged)
  /// - Front/back pairs (ㅏ/ㅓ, ㅗ/ㅜ): 50 (same height, different backness)
  /// - Y-glide variants (ㅏ/ㅑ, ㅓ/ㅕ): 40 (same quality, +/- glide)
  /// - Diphthong/monophthong: 50-60 (partial overlap)
  static const Map<String, Map<String, int>> similarVowels = {
    'ㅏ': {'ㅓ': 50, 'ㅗ': 30, 'ㅐ': 40},
    'ㅐ': {'ㅔ': 80, 'ㅏ': 40},
    'ㅑ': {'ㅕ': 50, 'ㅏ': 40},
    'ㅒ': {'ㅖ': 80, 'ㅐ': 50},
    'ㅓ': {'ㅏ': 50, 'ㅡ': 30, 'ㅔ': 40},
    'ㅔ': {'ㅐ': 80, 'ㅓ': 40},
    'ㅕ': {'ㅑ': 50, 'ㅓ': 40},
    'ㅖ': {'ㅒ': 80, 'ㅔ': 50},
    'ㅗ': {'ㅜ': 50, 'ㅏ': 30},
    'ㅘ': {'ㅗ': 60, 'ㅏ': 50},
    'ㅙ': {'ㅚ': 70, 'ㅐ': 50},
    'ㅚ': {'ㅙ': 70, 'ㅔ': 50},
    'ㅛ': {'ㅠ': 50, 'ㅗ': 40},
    'ㅜ': {'ㅗ': 50, 'ㅡ': 40},
    'ㅝ': {'ㅜ': 60, 'ㅓ': 50},
    'ㅞ': {'ㅟ': 70, 'ㅔ': 50},
    'ㅟ': {'ㅞ': 70, 'ㅣ': 50},
    'ㅠ': {'ㅛ': 50, 'ㅜ': 40},
    'ㅡ': {'ㅜ': 40, 'ㅓ': 30, 'ㅣ': 20},
    'ㅢ': {'ㅡ': 50, 'ㅣ': 50},
    'ㅣ': {'ㅡ': 20, 'ㅔ': 50},
  };

  // Private constructor to prevent instantiation
  KoreanPhonemeUtils._();
}

/// Result of decomposing a Hangul syllable into its constituent jamo.
class HangulDecomposition {
  /// Initial consonant (초성), e.g. 'ㄱ', 'ㅎ'
  final String initial;

  /// Medial vowel (중성), e.g. 'ㅏ', 'ㅜ'
  final String medial;

  /// Final consonant (종성), e.g. 'ㄴ', 'ㄱ'
  /// Empty string if the syllable has no final consonant.
  final String final_;

  const HangulDecomposition({
    required this.initial,
    required this.medial,
    required this.final_,
  });

  /// Get as a flat list of phonemes, excluding empty final consonant.
  List<String> toList() {
    final result = [initial, medial];
    if (final_.isNotEmpty) result.add(final_);
    return result;
  }

  /// Number of phonemes in this syllable (2 or 3).
  int get phonemeCount => final_.isEmpty ? 2 : 3;

  @override
  String toString() => '($initial, $medial${final_.isNotEmpty ? ', $final_' : ''})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HangulDecomposition &&
        other.initial == initial &&
        other.medial == medial &&
        other.final_ == final_;
  }

  @override
  int get hashCode => Object.hash(initial, medial, final_);
}

/// Position of a phoneme within a syllable, used for scoring weights.
enum PhonemePosition {
  /// 초성 - beginning consonant
  initial,

  /// 중성 - vowel
  medial,

  /// 종성 - final consonant
  final_,
}

/// A pair of aligned phonemes from sequence alignment.
class AlignedPhonemePair {
  /// Expected phoneme (empty string if insertion in actual)
  final String expected;

  /// Actual phoneme (empty string if deletion from expected)
  final String actual;

  /// Similarity score 0-100
  final double score;

  const AlignedPhonemePair({
    required this.expected,
    required this.actual,
    required this.score,
  });

  /// Whether this pair represents a gap (insertion or deletion).
  bool get isGap => expected.isEmpty || actual.isEmpty;

  /// Whether the phonemes are an exact match.
  bool get isExactMatch => expected == actual && expected.isNotEmpty;

  @override
  String toString() => '[$expected -> $actual: ${score.toStringAsFixed(0)}]';
}
