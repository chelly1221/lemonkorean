import 'dart:math';

import '../data/reference_embeddings.dart';
import '../utils/app_logger.dart';
import '../utils/korean_phoneme_utils.dart';
import '../utils/pronunciation_feedback.dart';
import 'gop_service.dart';

/// Embedding-based pronunciation scorer with per-phoneme analysis.
///
/// Scoring pipeline:
/// 1. Extract frame-level [T, 1024] hidden states from user audio via wav2vec2
/// 2. Mean-pool into 1024-dim embedding for overall score
/// 3. Segment frames proportionally by phoneme count
/// 4. Compute per-segment similarity to reference for per-phoneme scores
/// 5. Generate specific feedback for weak phonemes
class PronunciationScorer {
  static final PronunciationScorer instance = PronunciationScorer._();
  static const String _tag = 'PronunciationScorer';

  /// Cosine similarity thresholds for score mapping.
  /// score = ((similarity - low) / (high - low) * 100).clamp(0, 100)
  ///
  /// wav2vec2 embeddings share general speech features (prosody, speaker),
  /// so even unrelated pronunciations yield ~0.65-0.70 similarity.
  /// The discriminative range is narrow (0.70-0.92):
  /// - 0.90+ : near-native pronunciation
  /// - 0.85  : good, clearly correct
  /// - 0.80  : fair, recognizable
  /// - 0.70  : wrong phoneme / very poor
  static const double _simLow = 0.70;
  static const double _simHigh = 0.90;

  /// Per-phoneme similarity thresholds (slightly wider range since segments
  /// are noisier than full-utterance embeddings).
  static const double _phonemeSimLow = 0.55;
  static const double _phonemeSimHigh = 0.88;

  /// Duration weights for phoneme types (vowels are longer than consonants).
  static const double _vowelWeight = 2.0;
  static const double _consonantWeight = 1.0;

  PronunciationScorer._();

  /// End-to-end scoring: audio file → embedding → cosine similarity → score.
  Future<SpeechResult> score({
    required String expectedText,
    required String audioPath,
    String language = 'ko',
  }) async {
    final expectedPhonemes = KoreanPhonemeUtils.toPhonemeSequence(expectedText);

    if (expectedPhonemes.isEmpty) {
      AppLogger.w('No phonemes from expected text: "$expectedText"', tag: _tag);
      return SpeechResult.empty();
    }

    // Look up reference embedding
    final refEmbedding = ReferenceEmbeddings.get(expectedText);
    if (refEmbedding == null) {
      AppLogger.w(
        'No reference embedding for "$expectedText"',
        tag: _tag,
      );
      return SpeechResult.empty();
    }

    // Extract user embedding with frame-level data
    if (!GopService.instance.isInitialized) {
      AppLogger.w('GopService not initialized', tag: _tag);
      return SpeechResult.empty();
    }

    final embResult = await GopService.instance.extractEmbeddingWithFrames(audioPath);
    if (embResult == null) {
      AppLogger.w('Failed to extract embedding from audio', tag: _tag);
      return SpeechResult.empty();
    }

    // Compute overall cosine similarity
    final similarity = _cosineSimilarity(embResult.embedding, refEmbedding);

    // Map similarity to 0-100 score
    final rawScore =
        ((similarity - _simLow) / (_simHigh - _simLow) * 100.0).clamp(0.0, 100.0);
    final overallScore = rawScore.round();

    AppLogger.i(
      'Scored "$expectedText": similarity=${similarity.toStringAsFixed(4)}, '
      'score=$overallScore, frames=${embResult.frames.length}',
      tag: _tag,
    );

    // Compute per-phoneme scores using frame-level analysis
    final phonemeDetails = _computePhonemeScores(
      expectedText: expectedText,
      expectedPhonemes: expectedPhonemes,
      frames: embResult.frames,
      refEmbedding: refEmbedding,
      overallScore: overallScore,
    );

    // Compute detail score as weighted average of phoneme scores
    final detailScore = phonemeDetails.isNotEmpty
        ? (phonemeDetails.fold<double>(0.0, (s, p) => s + p.score) /
                phonemeDetails.length)
            .round()
        : overallScore;

    // Generate feedback based on actual per-phoneme scores
    final feedback = PronunciationFeedback.generateFeedback(
      phonemeScores: phonemeDetails,
      overallScore: overallScore,
      language: language,
    );

    return SpeechResult(
      overallScore: overallScore,
      gopScore: overallScore,
      detailScore: detailScore,
      expectedText: expectedText,
      phonemeDetails: phonemeDetails,
      expectedPhonemes: expectedPhonemes,
      feedback: feedback,
    );
  }

  /// Compute per-phoneme scores by segmenting frame-level embeddings.
  ///
  /// The T model output frames are divided proportionally across phonemes,
  /// with vowels getting ~2x the frames of consonants (reflecting natural
  /// phoneme duration). Each segment is mean-pooled and compared to the
  /// reference embedding.
  static List<PhonemeScoreDetail> _computePhonemeScores({
    required String expectedText,
    required List<String> expectedPhonemes,
    required List<List<double>> frames,
    required List<double> refEmbedding,
    required int overallScore,
  }) {
    final decompositions = KoreanPhonemeUtils.decomposeAll(expectedText);
    final details = <PhonemeScoreDetail>[];
    int phonemeIdx = 0;

    // Build flat list of (phoneme, position, weight)
    final phonemeEntries = <_PhonemeEntry>[];
    for (final decomp in decompositions) {
      final syllablePhonemes = decomp.toList();
      for (int posInSyllable = 0;
          posInSyllable < syllablePhonemes.length;
          posInSyllable++) {
        if (phonemeIdx >= expectedPhonemes.length) break;
        final position = KoreanPhonemeUtils.getPosition(posInSyllable);
        final isVowel = position == PhonemePosition.medial;
        phonemeEntries.add(_PhonemeEntry(
          phoneme: syllablePhonemes[posInSyllable],
          position: position,
          weight: isVowel ? _vowelWeight : _consonantWeight,
        ));
        phonemeIdx++;
      }
    }

    if (phonemeEntries.isEmpty || frames.isEmpty) return details;

    // Not enough frames for per-phoneme analysis — fall back to uniform
    if (frames.length < phonemeEntries.length * 2) {
      AppLogger.d(
        'Too few frames (${frames.length}) for ${phonemeEntries.length} phonemes, '
        'using uniform scores',
        tag: _tag,
      );
      for (final entry in phonemeEntries) {
        details.add(PhonemeScoreDetail(
          expected: entry.phoneme,
          score: overallScore,
          position: _positionToString(entry.position),
        ));
      }
      return details;
    }

    // Compute frame allocation based on weights
    final totalWeight =
        phonemeEntries.fold<double>(0.0, (s, e) => s + e.weight);
    final totalFrames = frames.length;

    int frameOffset = 0;
    for (int i = 0; i < phonemeEntries.length; i++) {
      final entry = phonemeEntries[i];
      // Proportional frame count, minimum 1
      int segmentFrames =
          (totalFrames * entry.weight / totalWeight).round();
      segmentFrames = max(1, segmentFrames);

      // Adjust last segment to use remaining frames
      if (i == phonemeEntries.length - 1) {
        segmentFrames = totalFrames - frameOffset;
      } else if (frameOffset + segmentFrames > totalFrames) {
        segmentFrames = totalFrames - frameOffset;
      }

      if (segmentFrames <= 0 || frameOffset >= totalFrames) {
        details.add(PhonemeScoreDetail(
          expected: entry.phoneme,
          score: overallScore,
          position: _positionToString(entry.position),
        ));
        continue;
      }

      // Mean-pool this segment's frames and L2-normalize
      final segmentEmbedding =
          _meanPoolSegment(frames, frameOffset, frameOffset + segmentFrames);

      // Compare segment to reference
      final segSimilarity = _cosineSimilarity(segmentEmbedding, refEmbedding);
      final segScore = ((segSimilarity - _phonemeSimLow) /
              (_phonemeSimHigh - _phonemeSimLow) *
              100.0)
          .clamp(0.0, 100.0)
          .round();

      details.add(PhonemeScoreDetail(
        expected: entry.phoneme,
        score: segScore,
        position: _positionToString(entry.position),
      ));

      frameOffset += segmentFrames;
    }

    AppLogger.d(
      'Per-phoneme scores: ${details.map((d) => "${d.expected}=${d.score}").join(", ")}',
      tag: _tag,
    );

    return details;
  }

  /// Mean-pool a segment of frames and L2-normalize the result.
  static List<double> _meanPoolSegment(
    List<List<double>> frames,
    int start,
    int end,
  ) {
    final dim = frames[0].length;
    final mean = List<double>.filled(dim, 0.0);
    final count = end - start;

    for (int t = start; t < end; t++) {
      final frame = frames[t];
      for (int i = 0; i < dim; i++) {
        mean[i] += frame[i];
      }
    }

    double normSq = 0.0;
    for (int i = 0; i < dim; i++) {
      mean[i] /= count;
      normSq += mean[i] * mean[i];
    }

    final norm = sqrt(normSq);
    if (norm > 1e-8) {
      for (int i = 0; i < dim; i++) {
        mean[i] /= norm;
      }
    }

    return mean;
  }

  /// Compute cosine similarity between two L2-normalized vectors.
  /// Both vectors should already be L2-normalized, so dot product = cosine sim.
  static double _cosineSimilarity(List<double> a, List<double> b) {
    if (a.length != b.length) return 0.0;
    double dot = 0.0;
    for (int i = 0; i < a.length; i++) {
      dot += a[i] * b[i];
    }
    return dot.clamp(-1.0, 1.0);
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

/// Internal entry for phoneme frame allocation.
class _PhonemeEntry {
  final String phoneme;
  final PhonemePosition position;
  final double weight;
  const _PhonemeEntry({
    required this.phoneme,
    required this.position,
    required this.weight,
  });
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
