import 'dart:math';

import '../data/reference_embeddings.dart';
import '../utils/app_logger.dart';
import '../utils/korean_phoneme_utils.dart';
import '../utils/pronunciation_feedback.dart';
import 'gop_service.dart';
import 'whisper_service.dart';

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
  /// Thresholds calibrated from real data:
  ///   silence/noise baseline: ~0.78-0.80 similarity
  ///   correct pronunciation:  ~0.83-0.91 similarity
  ///
  /// - 0.88+ : excellent → 100
  /// - 0.85  : good → 70
  /// - 0.83  : fair → 50
  /// - 0.78  : noise floor → 0
  static const double _simLow = 0.78;
  static const double _simHigh = 0.88;

  /// Per-phoneme similarity thresholds (aligned with overall).
  static const double _phonemeSimLow = 0.78;
  static const double _phonemeSimHigh = 0.88;

  /// Duration weights for phoneme types (vowels are longer than consonants).
  static const double _vowelWeight = 2.0;
  static const double _consonantWeight = 1.0;

  PronunciationScorer._();

  /// End-to-end scoring: Whisper gate → wav2vec2 embedding → score.
  ///
  /// Pipeline:
  /// 1. Whisper transcribes audio → recognized text
  /// 2. Compare recognized vs expected text at jamo level
  /// 3. If exact match → wav2vec2 fine-grained scoring (full range 0-100)
  /// 4. If partial match → cap score + specific feedback
  /// 5. If Whisper fails → fall back to wav2vec2 only
  Future<SpeechResult> score({
    required String expectedText,
    required String audioPath,
    String language = 'ko',
  }) async {
    final expectedPhonemes = KoreanPhonemeUtils.toPhonemeSequence(expectedText);

    if (expectedPhonemes.isEmpty) {
      return SpeechResult.empty();
    }

    // Look up reference embedding
    final refEmbedding = ReferenceEmbeddings.get(expectedText);
    if (refEmbedding == null) {
      AppLogger.w('No reference embedding for "$expectedText"', tag: _tag);
      return SpeechResult.empty();
    }

    // Extract user embedding with frame-level data
    if (!GopService.instance.isInitialized) {
      AppLogger.w('GopService not initialized', tag: _tag);
      return SpeechResult.empty();
    }

    final embResult = await GopService.instance.extractEmbeddingWithFrames(audioPath);
    if (embResult == null) {
      return SpeechResult.empty();
    }

    // Compute overall cosine similarity
    final similarity = _cosineSimilarity(embResult.embedding, refEmbedding);
    final embeddingScore =
        ((similarity - _simLow) / (_simHigh - _simLow) * 100.0).clamp(0.0, 100.0).round();

    AppLogger.i(
      'wav2vec2: similarity=${similarity.toStringAsFixed(4)}, embeddingScore=$embeddingScore',
      tag: _tag,
    );

    // ── Whisper gate ──
    final jamoComparison = await _whisperGate(expectedText, audioPath);

    // Compute per-phoneme scores using frame-level analysis
    final phonemeDetails = _computePhonemeScores(
      expectedText: expectedText,
      expectedPhonemes: expectedPhonemes,
      frames: embResult.frames,
      refEmbedding: refEmbedding,
      fallbackScore: embeddingScore,
    );

    // Base overall score from phoneme analysis
    int overallScore = phonemeDetails.isNotEmpty
        ? (phonemeDetails.fold<double>(0.0, (s, p) => s + p.score) /
                phonemeDetails.length)
            .round()
        : embeddingScore;

    // Apply Whisper gate score cap
    final feedback = <String>[];
    if (jamoComparison != null) {
      switch (jamoComparison.type) {
        case JamoMatchType.exactMatch:
          // Whisper confirmed correct syllable → use full wav2vec2 score
          break;
        case JamoMatchType.vowelMismatch:
          overallScore = min(overallScore, 40);
          feedback.add(PronunciationFeedback.generateWhisperFeedback(
            type: 'vowelMismatch',
            language: language,
          ));
          break;
        case JamoMatchType.consonantMismatch:
          overallScore = min(overallScore, 40);
          feedback.add(PronunciationFeedback.generateWhisperFeedback(
            type: 'consonantMismatch',
            language: language,
          ));
          break;
        case JamoMatchType.totalMismatch:
          overallScore = min(overallScore, 20);
          feedback.add(PronunciationFeedback.generateWhisperFeedback(
            type: 'totalMismatch',
            language: language,
          ));
          break;
      }

      AppLogger.i(
        'Whisper gate: expected="$expectedText", '
        'recognized="${jamoComparison.recognizedText}", '
        'type=${jamoComparison.type.name}, score=$overallScore',
        tag: _tag,
      );
    }

    // Add phoneme-level feedback (from wav2vec2 analysis)
    feedback.addAll(PronunciationFeedback.generateFeedback(
      phonemeScores: phonemeDetails,
      overallScore: overallScore,
      language: language,
    ));

    final detailScore = overallScore;

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

  /// Run Whisper transcription and compare jamo with expected text.
  /// Returns null if Whisper is not available or transcription fails
  /// (in which case, fall back to wav2vec2-only scoring).
  Future<JamoComparisonResult?> _whisperGate(
    String expectedText,
    String audioPath,
  ) async {
    if (!WhisperService.instance.isInitialized) return null;

    try {
      final result = await WhisperService.instance.transcribe(audioPath);
      if (result == null || result.text.isEmpty) {
        // Whisper couldn't recognize anything → fall back to wav2vec2 only
        return null;
      }

      final recognizedText = result.text.replaceAll(RegExp(r'\s+'), '');
      return _compareJamo(expectedText, recognizedText);
    } catch (e) {
      AppLogger.w('Whisper gate failed: $e', tag: _tag);
      return null;
    }
  }

  /// Compare two Korean texts at the jamo (초성/중성/종성) level.
  ///
  /// Uses phonetic similarity groups so that Whisper's common confusions
  /// (ㄱ/ㅋ/ㄲ, ㅐ/ㅔ, etc.) don't trigger false mismatches.
  ///
  /// Returns the match type for score cap decisions.
  static JamoComparisonResult _compareJamo(String expected, String recognized) {
    final expectedDecomp = KoreanPhonemeUtils.decomposeAll(expected);
    final recognizedDecomp = KoreanPhonemeUtils.decomposeAll(recognized);

    if (expectedDecomp.isEmpty || recognizedDecomp.isEmpty) {
      return JamoComparisonResult(
        type: JamoMatchType.totalMismatch,
        recognizedText: recognized,
      );
    }

    final target = expectedDecomp.first;

    // Check for exact or phonetically-similar match
    for (final recSyl in recognizedDecomp) {
      final initialOk = _initialsSimilar(target.initial, recSyl.initial);
      final medialOk = _medialsSimilar(target.medial, recSyl.medial);
      if (initialOk && medialOk) {
        return JamoComparisonResult(
          type: JamoMatchType.exactMatch,
          recognizedText: recognized,
        );
      }
    }

    // No full match — check partial matches
    bool initialMatch = false;
    bool medialMatch = false;
    for (final recSyl in recognizedDecomp) {
      if (_initialsSimilar(target.initial, recSyl.initial)) initialMatch = true;
      if (_medialsSimilar(target.medial, recSyl.medial)) medialMatch = true;
    }

    if (initialMatch && !medialMatch) {
      return JamoComparisonResult(
        type: JamoMatchType.vowelMismatch,
        recognizedText: recognized,
      );
    } else if (!initialMatch && medialMatch) {
      return JamoComparisonResult(
        type: JamoMatchType.consonantMismatch,
        recognizedText: recognized,
      );
    }

    return JamoComparisonResult(
      type: JamoMatchType.totalMismatch,
      recognizedText: recognized,
    );
  }

  /// Check if two initial consonants are the same or in the same
  /// phonetic group (plain/aspirated/tense triad).
  ///
  /// Whisper frequently confuses consonants within the same articulation
  /// place (e.g. ㄱ↔ㅋ↔ㄲ), so we treat them as equivalent for the gate.
  static bool _initialsSimilar(String a, String b) {
    if (a == b) return true;
    for (final group in _consonantGroups) {
      if (group.contains(a) && group.contains(b)) return true;
    }
    return false;
  }

  /// Check if two medial vowels are the same or in the same
  /// phonetic group (commonly merged or confused by Whisper).
  static bool _medialsSimilar(String a, String b) {
    if (a == b) return true;
    for (final group in _vowelGroups) {
      if (group.contains(a) && group.contains(b)) return true;
    }
    return false;
  }

  /// Consonant groups: same articulation place, different manner.
  /// Whisper base frequently confuses these for single syllables.
  static const List<Set<String>> _consonantGroups = [
    {'ㄱ', 'ㅋ', 'ㄲ'}, // velar
    {'ㄷ', 'ㅌ', 'ㄸ'}, // alveolar
    {'ㅂ', 'ㅍ', 'ㅃ'}, // bilabial
    {'ㅈ', 'ㅊ', 'ㅉ'}, // palatal
    {'ㅅ', 'ㅆ'},       // sibilant
  ];

  /// Vowel groups: commonly merged or confused in Whisper recognition.
  static const List<Set<String>> _vowelGroups = [
    {'ㅐ', 'ㅔ'},       // merged in modern Korean
    {'ㅒ', 'ㅖ'},       // y-glide merged
    {'ㅘ', 'ㅏ'},       // Whisper often drops w-glide
    {'ㅝ', 'ㅓ'},       // Whisper often drops w-glide
    {'ㅙ', 'ㅚ', 'ㅐ'}, // complex vowel confusion
    {'ㅞ', 'ㅟ', 'ㅔ'}, // complex vowel confusion
  ];

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
    required int fallbackScore,
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
          score: fallbackScore,
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
          score: fallbackScore,
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

/// Result of jamo-level comparison between expected and recognized text.
class JamoComparisonResult {
  final JamoMatchType type;
  final String recognizedText;

  const JamoComparisonResult({
    required this.type,
    required this.recognizedText,
  });
}

/// Types of jamo match for Whisper gate scoring.
enum JamoMatchType {
  /// 초성+중성 both match → full wav2vec2 scoring
  exactMatch,
  /// 초성 matches but 중성 differs → score cap 40, "check vowel"
  vowelMismatch,
  /// 중성 matches but 초성 differs → score cap 40, "check consonant"
  consonantMismatch,
  /// Neither matches → score cap 20, "try again"
  totalMismatch,
}
