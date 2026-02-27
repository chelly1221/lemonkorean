import 'dart:math';

import '../utils/app_logger.dart';
import '../utils/korean_phoneme_utils.dart';
import '../utils/pronunciation_feedback.dart';
import 'gop_service.dart';
import 'whisper_service.dart';

/// Hybrid pronunciation scorer combining Whisper transcription and GOP analysis.
///
/// Scoring pipeline:
/// 1. Text comparison score (30% weight) - phoneme-level alignment between
///    expected text and Whisper transcription using similarity matrix
/// 2. GOP phoneme quality score (50% weight) - acoustic model confidence
///    from wav2vec2-based GOP analysis
/// 3. Position-weighted phoneme analysis (20% weight) - per-syllable scoring
///    with initial/medial/final positional weights (40%/40%/20%)
///
/// Gracefully degrades when either Whisper or GOP is unavailable,
/// redistributing weights to available signals.
class PronunciationScorer {
  static final PronunciationScorer instance = PronunciationScorer._();
  static const String _tag = 'PronunciationScorer';

  // Scoring weights for the three components
  static const double _textWeight = 0.30;
  static const double _gopWeight = 0.50;
  static const double _detailWeight = 0.20;

  // Positional weights within each syllable
  static const double _initialWeight = 0.40;
  static const double _medialWeight = 0.40;
  static const double _finalWeight = 0.20;

  PronunciationScorer._();

  /// End-to-end scoring: audio file → Whisper + GOP → combined score + feedback.
  ///
  /// Primary API called by SpeechProvider.
  Future<SpeechResult> score({
    required String expectedText,
    required String audioPath,
    String language = 'ko',
  }) async {
    // Run Whisper + GOP in parallel
    final expectedPhonemes = KoreanPhonemeUtils.toPhonemeSequence(expectedText);

    final whisperFuture = WhisperService.instance.isInitialized
        ? WhisperService.instance.transcribe(audioPath)
        : Future.value(null);

    final gopFuture = GopService.instance.isInitialized && expectedPhonemes.isNotEmpty
        ? GopService.instance.computeGopScores(
            audioPath: audioPath,
            expectedPhonemes: expectedPhonemes,
          )
        : Future.value(null);

    final results = await Future.wait([whisperFuture, gopFuture]);
    final whisperResult = results[0] as WhisperTranscribeResult?;
    final gopResult = results[1] as GopResult?;

    // Run core scoring algorithm
    final coreResult = scoreFromResults(
      expectedText: expectedText,
      transcription: whisperResult,
      gopResult: gopResult,
    );

    // Generate multilingual feedback
    final feedback = PronunciationFeedback.generateFeedback(
      phonemeScores: coreResult.phonemeDetails,
      overallScore: coreResult.overallScore,
      language: language,
    );

    return SpeechResult(
      overallScore: coreResult.overallScore,
      textScore: coreResult.textScore,
      gopScore: coreResult.gopScore,
      detailScore: coreResult.detailScore,
      expectedText: coreResult.expectedText,
      actualText: coreResult.actualText,
      phonemeDetails: coreResult.phonemeDetails,
      expectedPhonemes: coreResult.expectedPhonemes,
      actualPhonemes: coreResult.actualPhonemes,
      feedback: feedback,
    );
  }

  /// Score from pre-computed results (used internally and for testing).
  static SpeechResult scoreFromResults({
    required String expectedText,
    WhisperTranscribeResult? transcription,
    GopResult? gopResult,
  }) {
    try {
      final expectedPhonemes =
          KoreanPhonemeUtils.toPhonemeSequence(expectedText);

      if (expectedPhonemes.isEmpty) {
        AppLogger.w('No phonemes extracted from expected text: "$expectedText"',
            tag: _tag);
        return SpeechResult.empty();
      }

      // Determine which scoring signals are available
      final hasTranscription =
          transcription != null && transcription.text.isNotEmpty;
      final hasGop = gopResult != null && gopResult.phonemeScores.isNotEmpty;

      if (!hasTranscription && !hasGop) {
        AppLogger.w('No transcription or GOP data available', tag: _tag);
        return SpeechResult.empty();
      }

      // 1. Text comparison score (Whisper transcription vs expected)
      double textScore = 0.0;
      List<String> actualPhonemes = [];
      if (hasTranscription) {
        actualPhonemes =
            KoreanPhonemeUtils.toPhonemeSequence(transcription.text);
        textScore =
            _computeTextComparisonScore(expectedPhonemes, actualPhonemes);
      }

      // 2. GOP phoneme quality score
      double gopScore = 0.0;
      if (hasGop) {
        gopScore = gopResult.overallGop;
      }

      // 3. Position-weighted phoneme analysis
      double detailScore = 0.0;
      final phonemeDetails = <PhonemeScoreDetail>[];
      if (hasTranscription || hasGop) {
        final detailResult = _computeDetailAnalysis(
          expectedText: expectedText,
          expectedPhonemes: expectedPhonemes,
          actualPhonemes: actualPhonemes,
          gopScores: hasGop ? gopResult.phonemeScores : null,
        );
        detailScore = detailResult.score;
        phonemeDetails.addAll(detailResult.details);
      }

      // Compute final weighted score with dynamic weight redistribution
      final finalScore = _computeWeightedScore(
        textScore: textScore,
        gopScore: gopScore,
        detailScore: detailScore,
        hasTranscription: hasTranscription,
        hasGop: hasGop,
      );

      final result = SpeechResult(
        overallScore: finalScore.round().clamp(0, 100),
        textScore: textScore.round().clamp(0, 100),
        gopScore: gopScore.round().clamp(0, 100),
        detailScore: detailScore.round().clamp(0, 100),
        expectedText: expectedText,
        actualText: hasTranscription ? transcription.text : '',
        phonemeDetails: phonemeDetails,
        expectedPhonemes: expectedPhonemes,
        actualPhonemes: actualPhonemes,
      );

      AppLogger.d(
        'Scored "$expectedText" -> '
        'text=${result.textScore}, gop=${result.gopScore}, '
        'detail=${result.detailScore}, overall=${result.overallScore}',
        tag: _tag,
      );

      return result;
    } catch (e, st) {
      AppLogger.e('Scoring failed for "$expectedText"',
          error: e, stackTrace: st, tag: _tag);
      return SpeechResult.empty();
    }
  }

  /// Compute text comparison score using phoneme sequence alignment.
  ///
  /// Aligns expected and actual phoneme sequences using the phoneme
  /// similarity matrix, then averages similarity across all aligned pairs.
  static double _computeTextComparisonScore(
    List<String> expected,
    List<String> actual,
  ) {
    if (expected.isEmpty && actual.isEmpty) return 100.0;
    if (expected.isEmpty || actual.isEmpty) return 0.0;

    // Quick exact match check
    if (_listsEqual(expected, actual)) return 100.0;

    // Use the sequence similarity from KoreanPhonemeUtils which
    // performs Needleman-Wunsch alignment with phoneme similarity matrix
    // We reimplement here to get per-pair details
    final aligned = _alignWithScores(expected, actual);
    if (aligned.isEmpty) return 0.0;

    double totalScore = 0.0;
    int pairCount = 0;
    for (final pair in aligned) {
      totalScore += pair.score;
      pairCount++;
    }

    // Penalize length mismatches (extra/missing phonemes)
    final lengthRatio = min(expected.length, actual.length) /
        max(expected.length, actual.length);
    final lengthPenalty = 1.0 - (1.0 - lengthRatio) * 0.5;

    return (totalScore / pairCount * lengthPenalty).clamp(0.0, 100.0);
  }

  /// Align two phoneme sequences and return scored pairs.
  static List<_ScoredPair> _alignWithScores(
    List<String> expected,
    List<String> actual,
  ) {
    const double gapPenalty = -30.0;
    final int m = expected.length;
    final int n = actual.length;

    // DP matrix
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0.0));
    for (int i = 1; i <= m; i++) {
      dp[i][0] = dp[i - 1][0] + gapPenalty;
    }
    for (int j = 1; j <= n; j++) {
      dp[0][j] = dp[0][j - 1] + gapPenalty;
    }

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        final sim =
            KoreanPhonemeUtils.phonemeSimilarity(expected[i - 1], actual[j - 1])
                .toDouble();
        final matchScore = sim > 0 ? sim : -30.0;

        dp[i][j] = max(
          dp[i - 1][j - 1] + matchScore,
          max(dp[i - 1][j] + gapPenalty, dp[i][j - 1] + gapPenalty),
        );
      }
    }

    // Traceback
    final pairs = <_ScoredPair>[];
    int i = m, j = n;
    while (i > 0 || j > 0) {
      if (i > 0 && j > 0) {
        final sim =
            KoreanPhonemeUtils.phonemeSimilarity(expected[i - 1], actual[j - 1])
                .toDouble();
        final matchScore = sim > 0 ? sim : -30.0;

        if ((dp[i][j] - (dp[i - 1][j - 1] + matchScore)).abs() < 0.001) {
          pairs.add(_ScoredPair(expected[i - 1], actual[j - 1], sim));
          i--;
          j--;
          continue;
        }
      }
      if (i > 0 &&
          (dp[i][j] - (dp[i - 1][j] + gapPenalty)).abs() < 0.001) {
        pairs.add(_ScoredPair(expected[i - 1], '', 0.0));
        i--;
      } else {
        pairs.add(_ScoredPair('', actual[j - 1], 0.0));
        j--;
      }
    }

    return pairs.reversed.toList();
  }

  /// Compute position-weighted phoneme analysis.
  ///
  /// For each syllable in the expected text, scores the initial consonant
  /// (40%), medial vowel (40%), and final consonant (20%) separately,
  /// combining text similarity and GOP scores when available.
  static _DetailResult _computeDetailAnalysis({
    required String expectedText,
    required List<String> expectedPhonemes,
    required List<String> actualPhonemes,
    List<PhonemeGopScore>? gopScores,
  }) {
    final decompositions = KoreanPhonemeUtils.decomposeAll(expectedText);
    if (decompositions.isEmpty) {
      return const _DetailResult(score: 0.0, details: []);
    }

    // Build aligned phoneme pairs for text comparison
    final alignedPairs = actualPhonemes.isNotEmpty
        ? _alignWithScores(expectedPhonemes, actualPhonemes)
        : <_ScoredPair>[];

    final details = <PhonemeScoreDetail>[];
    double totalWeightedScore = 0.0;
    double totalWeight = 0.0;
    int phonemeIdx = 0;

    for (final decomp in decompositions) {
      final syllablePhonemes = decomp.toList();

      for (int posInSyllable = 0;
          posInSyllable < syllablePhonemes.length;
          posInSyllable++) {
        final expectedPhoneme = syllablePhonemes[posInSyllable];
        final position = KoreanPhonemeUtils.getPosition(posInSyllable);
        final positionWeight = _getPositionWeight(position);

        // Get text similarity score for this phoneme
        double textSim = 0.0;
        String actualPhoneme = '';
        if (phonemeIdx < alignedPairs.length) {
          textSim = alignedPairs[phonemeIdx].score;
          actualPhoneme = alignedPairs[phonemeIdx].actual;
        }

        // Get GOP score for this phoneme if available
        double gopSim = 0.0;
        if (gopScores != null && phonemeIdx < gopScores.length) {
          gopSim = gopScores[phonemeIdx].gopScore;
        }

        // Combine text similarity and GOP score
        double combinedScore;
        if (gopScores != null && actualPhonemes.isNotEmpty) {
          combinedScore = textSim * 0.4 + gopSim * 0.6;
        } else if (gopScores != null) {
          combinedScore = gopSim;
        } else {
          combinedScore = textSim;
        }

        details.add(PhonemeScoreDetail(
          expected: expectedPhoneme,
          actual: actualPhoneme,
          score: combinedScore.round().clamp(0, 100),
          position: _positionToString(position),
        ));

        totalWeightedScore += combinedScore * positionWeight;
        totalWeight += positionWeight;
        phonemeIdx++;
      }
    }

    final score = totalWeight > 0 ? totalWeightedScore / totalWeight : 0.0;
    return _DetailResult(score: score.clamp(0.0, 100.0), details: details);
  }

  /// Get the weight for a phoneme position within a syllable.
  static double _getPositionWeight(PhonemePosition position) {
    switch (position) {
      case PhonemePosition.initial:
        return _initialWeight;
      case PhonemePosition.medial:
        return _medialWeight;
      case PhonemePosition.final_:
        return _finalWeight;
    }
  }

  /// Convert PhonemePosition enum to string for serialization.
  static String _positionToString(PhonemePosition position) {
    switch (position) {
      case PhonemePosition.initial:
        return 'initial';
      case PhonemePosition.medial:
        return 'medial';
      case PhonemePosition.final_:
        return 'final';
    }
  }

  /// Compute the final weighted score with dynamic weight redistribution.
  ///
  /// When a scoring signal is unavailable (Whisper or GOP), its weight
  /// is redistributed proportionally to the remaining signals.
  static double _computeWeightedScore({
    required double textScore,
    required double gopScore,
    required double detailScore,
    required bool hasTranscription,
    required bool hasGop,
  }) {
    if (hasTranscription && hasGop) {
      // All signals available: standard weights
      return textScore * _textWeight +
          gopScore * _gopWeight +
          detailScore * _detailWeight;
    }

    if (hasTranscription && !hasGop) {
      // No GOP: redistribute GOP weight to text and detail
      // text: 0.30 + 0.50 * (0.30 / 0.50) = 0.60
      // detail: 0.20 + 0.50 * (0.20 / 0.50) = 0.40
      return textScore * 0.60 + detailScore * 0.40;
    }

    if (!hasTranscription && hasGop) {
      // No transcription: redistribute text weight to GOP and detail
      // gop: 0.50 + 0.30 * (0.50 / 0.70) = 0.714
      // detail: 0.20 + 0.30 * (0.20 / 0.70) = 0.286
      return gopScore * 0.714 + detailScore * 0.286;
    }

    // Neither available - should not reach here (handled in score())
    return 0.0;
  }

  /// Check if two string lists are equal.
  static bool _listsEqual(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Overall result from pronunciation scoring.
class SpeechResult {
  /// Overall pronunciation score (0-100).
  final int overallScore;

  /// Text comparison sub-score (0-100).
  /// How well the Whisper transcription matches expected text at phoneme level.
  final int textScore;

  /// GOP (Goodness of Pronunciation) sub-score (0-100).
  /// Acoustic model confidence in phoneme quality.
  final int gopScore;

  /// Position-weighted detail sub-score (0-100).
  /// Syllable-aware scoring with initial/medial/final weights.
  final int detailScore;

  /// The Korean text the user was expected to pronounce.
  final String expectedText;

  /// The text Whisper recognized from the user's speech.
  final String actualText;

  /// Per-phoneme scoring details for feedback generation.
  final List<PhonemeScoreDetail> phonemeDetails;

  /// Flat phoneme sequence from expected text.
  final List<String> expectedPhonemes;

  /// Flat phoneme sequence from actual (recognized) text.
  final List<String> actualPhonemes;

  /// Localized feedback strings for the user.
  final List<String> feedback;

  const SpeechResult({
    required this.overallScore,
    required this.textScore,
    required this.gopScore,
    required this.detailScore,
    required this.expectedText,
    required this.actualText,
    required this.phonemeDetails,
    required this.expectedPhonemes,
    required this.actualPhonemes,
    this.feedback = const [],
  });

  /// Create an empty result for error/unavailable cases.
  factory SpeechResult.empty() => const SpeechResult(
        overallScore: 0,
        textScore: 0,
        gopScore: 0,
        detailScore: 0,
        expectedText: '',
        actualText: '',
        phonemeDetails: [],
        expectedPhonemes: [],
        actualPhonemes: [],
      );

  /// Alias getters for UI compatibility
  String get transcription => actualText;
  int get whisperScore => textScore;
  int get starRating {
    if (overallScore >= 90) return 5;
    if (overallScore >= 80) return 4;
    if (overallScore >= 70) return 3;
    if (overallScore >= 50) return 2;
    return 1;
  }

  /// Get phoneme scores mapped for UI display
  List<PhonemeScoreDetail> get phonemeScores => phonemeDetails;

  /// Overall grade category for UI display (enum).
  SpeechGrade get gradeEnum {
    if (overallScore >= 90) return SpeechGrade.excellent;
    if (overallScore >= 70) return SpeechGrade.good;
    if (overallScore >= 50) return SpeechGrade.fair;
    return SpeechGrade.needsPractice;
  }

  /// Overall grade as string for UI display.
  String get grade {
    if (overallScore >= 90) return 'excellent';
    if (overallScore >= 70) return 'good';
    if (overallScore >= 50) return 'fair';
    return 'needsPractice';
  }

  /// Whether the pronunciation is considered passing (>= 70).
  bool get isPassing => overallScore >= 70;

  /// Get phonemes that scored below threshold, sorted by score ascending.
  /// Useful for identifying what to practice.
  List<PhonemeScoreDetail> weakPhonemes({int threshold = 70}) {
    return phonemeDetails
        .where((p) => p.score < threshold)
        .toList()
      ..sort((a, b) => a.score.compareTo(b.score));
  }

  /// Serialize to JSON map for storage/sync.
  Map<String, dynamic> toJson() => {
        'overallScore': overallScore,
        'textScore': textScore,
        'gopScore': gopScore,
        'detailScore': detailScore,
        'expectedText': expectedText,
        'actualText': actualText,
        'phonemeDetails': phonemeDetails.map((p) => p.toJson()).toList(),
      };

  /// Deserialize from JSON map.
  factory SpeechResult.fromJson(Map<String, dynamic> json) => SpeechResult(
        overallScore: json['overallScore'] as int? ?? 0,
        textScore: json['textScore'] as int? ?? 0,
        gopScore: json['gopScore'] as int? ?? 0,
        detailScore: json['detailScore'] as int? ?? 0,
        expectedText: json['expectedText'] as String? ?? '',
        actualText: json['actualText'] as String? ?? '',
        phonemeDetails: (json['phonemeDetails'] as List<dynamic>?)
                ?.map((p) =>
                    PhonemeScoreDetail.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [],
        expectedPhonemes: [],
        actualPhonemes: [],
      );

  @override
  String toString() =>
      'SpeechResult(overall=$overallScore, text=$textScore, '
      'gop=$gopScore, detail=$detailScore, '
      'expected="$expectedText", actual="$actualText")';
}

/// Per-phoneme scoring detail for feedback generation.
class PhonemeScoreDetail {
  /// Expected phoneme (jamo).
  final String expected;

  /// Actually recognized phoneme (jamo). Empty if not recognized.
  final String actual;

  /// Score for this phoneme (0-100).
  final int score;

  /// Position within the syllable: 'initial', 'medial', or 'final'.
  final String position;

  const PhonemeScoreDetail({
    required this.expected,
    required this.actual,
    required this.score,
    required this.position,
  });

  /// Whether this phoneme needs practice (score below threshold).
  bool needsPractice({int threshold = 70}) => score < threshold;

  /// Serialize to JSON map.
  Map<String, dynamic> toJson() => {
        'expected': expected,
        'actual': actual,
        'score': score,
        'position': position,
      };

  /// Deserialize from JSON map.
  factory PhonemeScoreDetail.fromJson(Map<String, dynamic> json) =>
      PhonemeScoreDetail(
        expected: json['expected'] as String? ?? '',
        actual: json['actual'] as String? ?? '',
        score: json['score'] as int? ?? 0,
        position: json['position'] as String? ?? 'initial',
      );

  @override
  String toString() =>
      'PhonemeScore($expected->$actual: $score, $position)';
}

/// Overall grade categories for pronunciation results.
enum SpeechGrade {
  /// 90-100: Near-native pronunciation
  excellent,

  /// 70-89: Clearly intelligible with minor issues
  good,

  /// 50-69: Understandable but with noticeable issues
  fair,

  /// 0-49: Significant pronunciation difficulties
  needsPractice,
}

/// Internal helper for aligned phoneme pair scoring.
class _ScoredPair {
  final String expected;
  final String actual;
  final double score;
  const _ScoredPair(this.expected, this.actual, this.score);
}

/// Internal helper for detail analysis result.
class _DetailResult {
  final double score;
  final List<PhonemeScoreDetail> details;
  const _DetailResult({required this.score, required this.details});
}
