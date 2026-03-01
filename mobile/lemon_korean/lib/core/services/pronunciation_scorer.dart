import '../utils/app_logger.dart';
import '../utils/korean_phoneme_utils.dart';
import '../utils/pronunciation_feedback.dart';
import 'gop_service.dart';

/// GOP-only pronunciation scorer.
///
/// Scoring pipeline:
/// 1. Per-phoneme GOP scores from wav2vec2 acoustic model
/// 2. Position-weighted syllable analysis (initial 40%, medial 40%, final 20%)
/// 3. Overall score = weighted average across all phonemes
///
/// No Whisper dependency — purely acoustic scoring for consistent results,
/// especially on short utterances (1-2 syllables) where Whisper is unreliable.
class PronunciationScorer {
  static final PronunciationScorer instance = PronunciationScorer._();
  static const String _tag = 'PronunciationScorer';

  // Positional weights within each syllable
  static const double _initialWeight = 0.40;
  static const double _medialWeight = 0.40;
  static const double _finalWeight = 0.20;

  PronunciationScorer._();

  /// End-to-end scoring: audio file → GOP → combined score + feedback.
  Future<SpeechResult> score({
    required String expectedText,
    required String audioPath,
    String language = 'ko',
  }) async {
    final expectedPhonemes = KoreanPhonemeUtils.toPhonemeSequence(expectedText);

    if (expectedPhonemes.isEmpty) {
      AppLogger.w('No phonemes extracted from expected text: "$expectedText"',
          tag: _tag);
      return SpeechResult.empty();
    }

    // Compute GOP scores
    GopResult? gopResult;
    if (GopService.instance.isInitialized) {
      gopResult = await GopService.instance.computeGopScores(
        audioPath: audioPath,
        expectedPhonemes: expectedPhonemes,
      );
    }

    final coreResult = scoreFromGop(
      expectedText: expectedText,
      expectedPhonemes: expectedPhonemes,
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
      gopScore: coreResult.gopScore,
      detailScore: coreResult.detailScore,
      expectedText: coreResult.expectedText,
      phonemeDetails: coreResult.phonemeDetails,
      expectedPhonemes: coreResult.expectedPhonemes,
      feedback: feedback,
    );
  }

  /// Score from pre-computed GOP results (used internally and for testing).
  static SpeechResult scoreFromGop({
    required String expectedText,
    required List<String> expectedPhonemes,
    GopResult? gopResult,
  }) {
    try {
      if (expectedPhonemes.isEmpty) {
        AppLogger.w('No phonemes extracted from expected text: "$expectedText"',
            tag: _tag);
        return SpeechResult.empty();
      }

      final hasGop = gopResult != null && gopResult.phonemeScores.isNotEmpty;

      if (!hasGop) {
        AppLogger.w('No GOP data available for "$expectedText"', tag: _tag);
        return SpeechResult.empty();
      }

      // Raw GOP average
      final gopScore = gopResult.overallGop;

      // Position-weighted syllable analysis
      final detailResult = _computeDetailAnalysis(
        expectedText: expectedText,
        expectedPhonemes: expectedPhonemes,
        gopScores: gopResult.phonemeScores,
      );

      // Final score: blend raw GOP average and position-weighted detail
      // GOP average treats all phonemes equally;
      // detail score weights by syllable position (초/중/종).
      // 40% raw GOP + 60% position-weighted gives better accuracy
      // for Korean where 초성/중성 matter more than 종성.
      final finalScore = gopScore * 0.40 + detailResult.score * 0.60;

      final result = SpeechResult(
        overallScore: finalScore.round().clamp(0, 100),
        gopScore: gopScore.round().clamp(0, 100),
        detailScore: detailResult.score.round().clamp(0, 100),
        expectedText: expectedText,
        phonemeDetails: detailResult.details,
        expectedPhonemes: expectedPhonemes,
      );

      AppLogger.d(
        'Scored "$expectedText" -> '
        'gop=${result.gopScore}, detail=${result.detailScore}, '
        'overall=${result.overallScore}',
        tag: _tag,
      );

      return result;
    } catch (e, st) {
      AppLogger.e('Scoring failed for "$expectedText"',
          error: e, stackTrace: st, tag: _tag);
      return SpeechResult.empty();
    }
  }

  /// Compute position-weighted phoneme analysis.
  ///
  /// For each syllable in the expected text, scores the initial consonant
  /// (40%), medial vowel (40%), and final consonant (20%) separately
  /// using GOP scores.
  static _DetailResult _computeDetailAnalysis({
    required String expectedText,
    required List<String> expectedPhonemes,
    required List<PhonemeGopScore> gopScores,
  }) {
    final decompositions = KoreanPhonemeUtils.decomposeAll(expectedText);
    if (decompositions.isEmpty) {
      return const _DetailResult(score: 0.0, details: []);
    }

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

        // Get GOP score for this phoneme
        double gopSim = 0.0;
        if (phonemeIdx < gopScores.length) {
          gopSim = gopScores[phonemeIdx].gopScore;
        }

        details.add(PhonemeScoreDetail(
          expected: expectedPhoneme,
          score: gopSim.round().clamp(0, 100),
          position: _positionToString(position),
        ));

        totalWeightedScore += gopSim * positionWeight;
        totalWeight += positionWeight;
        phonemeIdx++;
      }
    }

    final score = totalWeight > 0 ? totalWeightedScore / totalWeight : 0.0;
    return _DetailResult(score: score.clamp(0.0, 100.0), details: details);
  }

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
}

/// Overall result from pronunciation scoring.
class SpeechResult {
  /// Overall pronunciation score (0-100).
  final int overallScore;

  /// GOP (Goodness of Pronunciation) sub-score (0-100).
  final int gopScore;

  /// Position-weighted detail sub-score (0-100).
  final int detailScore;

  /// The Korean text the user was expected to pronounce.
  final String expectedText;

  /// Per-phoneme scoring details for feedback generation.
  final List<PhonemeScoreDetail> phonemeDetails;

  /// Flat phoneme sequence from expected text.
  final List<String> expectedPhonemes;

  /// Localized feedback strings for the user.
  final List<String> feedback;

  const SpeechResult({
    required this.overallScore,
    required this.gopScore,
    required this.detailScore,
    required this.expectedText,
    required this.phonemeDetails,
    required this.expectedPhonemes,
    this.feedback = const [],
  });

  /// Create an empty result for error/unavailable cases.
  factory SpeechResult.empty() => const SpeechResult(
        overallScore: 0,
        gopScore: 0,
        detailScore: 0,
        expectedText: '',
        phonemeDetails: [],
        expectedPhonemes: [],
      );

  int get starRating {
    if (overallScore >= 90) return 5;
    if (overallScore >= 80) return 4;
    if (overallScore >= 70) return 3;
    if (overallScore >= 50) return 2;
    return 1;
  }

  List<PhonemeScoreDetail> get phonemeScores => phonemeDetails;

  SpeechGrade get gradeEnum {
    if (overallScore >= 90) return SpeechGrade.excellent;
    if (overallScore >= 70) return SpeechGrade.good;
    if (overallScore >= 50) return SpeechGrade.fair;
    return SpeechGrade.needsPractice;
  }

  String get grade {
    if (overallScore >= 90) return 'excellent';
    if (overallScore >= 70) return 'good';
    if (overallScore >= 50) return 'fair';
    return 'needsPractice';
  }

  bool get isPassing => overallScore >= 70;

  List<PhonemeScoreDetail> weakPhonemes({int threshold = 70}) {
    return phonemeDetails
        .where((p) => p.score < threshold)
        .toList()
      ..sort((a, b) => a.score.compareTo(b.score));
  }

  Map<String, dynamic> toJson() => {
        'overallScore': overallScore,
        'gopScore': gopScore,
        'detailScore': detailScore,
        'expectedText': expectedText,
        'phonemeDetails': phonemeDetails.map((p) => p.toJson()).toList(),
      };

  factory SpeechResult.fromJson(Map<String, dynamic> json) => SpeechResult(
        overallScore: json['overallScore'] as int? ?? 0,
        gopScore: json['gopScore'] as int? ?? 0,
        detailScore: json['detailScore'] as int? ?? 0,
        expectedText: json['expectedText'] as String? ?? '',
        phonemeDetails: (json['phonemeDetails'] as List<dynamic>?)
                ?.map((p) =>
                    PhonemeScoreDetail.fromJson(p as Map<String, dynamic>))
                .toList() ??
            [],
        expectedPhonemes: [],
      );

  @override
  String toString() =>
      'SpeechResult(overall=$overallScore, '
      'gop=$gopScore, detail=$detailScore, '
      'expected="$expectedText")';
}

/// Per-phoneme scoring detail for feedback generation.
class PhonemeScoreDetail {
  final String expected;
  final int score;
  final String position;

  const PhonemeScoreDetail({
    required this.expected,
    required this.score,
    required this.position,
  });

  bool needsPractice({int threshold = 70}) => score < threshold;

  Map<String, dynamic> toJson() => {
        'expected': expected,
        'score': score,
        'position': position,
      };

  factory PhonemeScoreDetail.fromJson(Map<String, dynamic> json) =>
      PhonemeScoreDetail(
        expected: json['expected'] as String? ?? '',
        score: json['score'] as int? ?? 0,
        position: json['position'] as String? ?? 'initial',
      );

  @override
  String toString() => 'PhonemeScore($expected: $score, $position)';
}

/// Overall grade categories for pronunciation results.
enum SpeechGrade {
  excellent,
  good,
  fair,
  needsPractice,
}

/// Internal helper for detail analysis result.
class _DetailResult {
  final double score;
  final List<PhonemeScoreDetail> details;
  const _DetailResult({required this.score, required this.details});
}
