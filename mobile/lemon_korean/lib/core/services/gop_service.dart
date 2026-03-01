import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';
import '../utils/korean_phoneme_utils.dart';

/// GOP (Goodness of Pronunciation) service.
/// Uses wav2vec2-korean ONNX model to compute per-phoneme pronunciation quality scores.
///
/// Improvements over naive equal-frame-division:
/// - Phoneme-type-aware frame allocation (consonants ~30%, vowels ~70%)
/// - Complex 종성 (겹받침) mapped to representative single consonant
/// - Sigmoid-based score normalization for more natural score distribution
/// - Minimum audio duration validation (rejects < 0.3s)
class GopService {
  static final GopService instance = GopService._();
  GopService._();

  bool _isInitialized = false;
  String? _modelPath;
  OrtSession? _session;
  OrtSessionOptions? _sessionOptions;

  bool get isInitialized => _isInitialized;
  bool get isModelReady =>
      _modelPath != null && File(_modelPath!).existsSync();

  /// Korean phoneme labels for wav2vec2-large-xlsr-korean model.
  /// These map to the output logit indices of the model.
  static const List<String> phonemeLabels = [
    '<pad>', '<s>', '</s>', '<unk>',
    // Korean consonants (초성)
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
    // Korean vowels (중성)
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
    'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
    // Word boundary
    '|',
  ];

  /// Relative frame weight for consonants vs vowels.
  /// Vowels are typically 2-3x longer than consonants in Korean speech.
  static const double _consonantWeight = 0.30;
  static const double _vowelWeight = 0.70;

  /// Minimum audio samples for valid scoring (0.3s at 16kHz).
  static const int _minAudioSamples = 4800;

  /// Initialize the ONNX model
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _modelPath = '${dir.path}/models/gop/wav2vec2_korean_q8.onnx';

      if (!File(_modelPath!).existsSync()) {
        AppLogger.w('GOP model not found at $_modelPath', tag: 'GopService');
        return;
      }

      // Initialize ORT environment
      OrtEnv.instance.init();

      // Configure session options
      _sessionOptions = OrtSessionOptions()
        ..setInterOpNumThreads(1)
        ..setIntraOpNumThreads(1)
        ..setSessionGraphOptimizationLevel(
            GraphOptimizationLevel.ortEnableAll);

      // Load the ONNX model
      _session = OrtSession.fromFile(File(_modelPath!), _sessionOptions!);
      AppLogger.i(
        'GOP ONNX session loaded: '
        'inputs=${_session!.inputNames}, outputs=${_session!.outputNames}',
        tag: 'GopService',
      );

      _isInitialized = true;
      AppLogger.i('GOP service initialized', tag: 'GopService');
    } catch (e) {
      AppLogger.e('Failed to initialize GOP service',
          error: e, tag: 'GopService');
      _isInitialized = false;
    }
  }

  /// Extract per-frame phoneme logits from audio.
  /// Returns a 2D list: [timeFrames][numPhonemes] of log probabilities.
  Future<List<List<double>>> extractPhonemeLogits(String audioPath) async {
    if (!_isInitialized || _session == null) {
      AppLogger.w('GOP service not initialized', tag: 'GopService');
      return [];
    }

    try {
      final audioData = await _loadAudioAsFloat32(audioPath);
      if (audioData.isEmpty) return [];

      // Reject too-short recordings
      if (audioData.length < _minAudioSamples) {
        AppLogger.w(
          'Audio too short: ${audioData.length} samples '
          '(min $_minAudioSamples, ${(_minAudioSamples / 16000 * 1000).round()}ms)',
          tag: 'GopService',
        );
        return [];
      }

      return _runOnnxInference(audioData);
    } catch (e) {
      AppLogger.e('Failed to extract phoneme logits',
          error: e, tag: 'GopService');
      return [];
    }
  }

  /// Run ONNX model inference on audio data
  List<List<double>> _runOnnxInference(Float32List audioData) {
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList(audioData),
      [1, audioData.length],
    );

    final runOptions = OrtRunOptions();

    try {
      final inputName =
          _session!.inputNames.isNotEmpty ? _session!.inputNames[0] : 'input';
      final inputs = {inputName: inputTensor};
      final outputs = _session!.run(runOptions, inputs);

      if (outputs.isEmpty || outputs[0] == null) {
        AppLogger.w('ONNX inference returned empty output', tag: 'GopService');
        return [];
      }

      final outputValue = outputs[0]!.value;

      List<List<double>> logits;
      if (outputValue is List<List<List<double>>>) {
        logits = outputValue[0]
            .map((frame) => frame.map((v) => v.toDouble()).toList())
            .toList();
      } else if (outputValue is List<List<double>>) {
        logits = outputValue
            .map((frame) => frame.map((v) => v.toDouble()).toList())
            .toList();
      } else {
        AppLogger.w(
          'Unexpected ONNX output type: ${outputValue.runtimeType}',
          tag: 'GopService',
        );
        logits = [];
      }

      for (final output in outputs) {
        output?.release();
      }

      return logits;
    } finally {
      inputTensor.release();
      runOptions.release();
    }
  }

  /// Compute GOP scores using phoneme-type-aware forced alignment.
  ///
  /// Frame allocation:
  /// - Consonants get ~30% of their syllable's frames
  /// - Vowels get ~70% of their syllable's frames
  /// - Complex 종성 are mapped to their representative single consonant
  Future<GopResult> computeGopScores({
    required String audioPath,
    required List<String> expectedPhonemes,
  }) async {
    if (!_isInitialized || expectedPhonemes.isEmpty) {
      return const GopResult(phonemeScores: [], overallGop: 0.0);
    }

    try {
      final logits = await extractPhonemeLogits(audioPath);
      if (logits.isEmpty) {
        return const GopResult(phonemeScores: [], overallGop: 0.0);
      }

      // Compute weighted frame allocation based on phoneme type
      final frameRanges = _computeFrameRanges(expectedPhonemes, logits.length);
      if (frameRanges.isEmpty) {
        return const GopResult(phonemeScores: [], overallGop: 0.0);
      }

      final scores = <PhonemeGopScore>[];
      double totalGop = 0.0;

      for (int i = 0; i < expectedPhonemes.length; i++) {
        final phoneme = expectedPhonemes[i];
        final startFrame = frameRanges[i].start;
        final endFrame = frameRanges[i].end;

        // Map complex 종성 to simple phoneme for GOP label lookup
        final gopPhoneme = KoreanPhonemeUtils.simplifyForGop(phoneme);
        final phonemeIdx = phonemeLabels.indexOf(gopPhoneme);

        if (phonemeIdx < 0) {
          // Unknown phoneme even after simplification
          AppLogger.d('Unknown GOP phoneme: $phoneme (simplified: $gopPhoneme)',
              tag: 'GopService');
          scores.add(PhonemeGopScore(
            phoneme: phoneme,
            gopScore: 0.0,
            confidence: 0.0,
            startFrame: startFrame,
            endFrame: endFrame,
          ));
          continue;
        }

        // Compute average log posterior for this phoneme across its frames
        double sumLogProb = 0.0;
        int frameCount = 0;
        for (int f = startFrame; f < endFrame && f < logits.length; f++) {
          if (phonemeIdx < logits[f].length) {
            final logProb = _logSoftmax(logits[f], phonemeIdx);
            sumLogProb += logProb;
            frameCount++;
          }
        }

        final avgLogProb = frameCount > 0 ? sumLogProb / frameCount : -10.0;

        // Sigmoid-based normalization for more natural score distribution.
        // Native speakers typically get avgLogProb in [-3, -0.5] range.
        // Learners typically get [-8, -3] range.
        // sigmoid(x * k + b) maps this to [0, 100] more gracefully.
        final normalizedGop = _sigmoidNormalize(avgLogProb);

        scores.add(PhonemeGopScore(
          phoneme: phoneme,
          gopScore: normalizedGop,
          confidence: exp(avgLogProb),
          startFrame: startFrame,
          endFrame: endFrame,
        ));
        totalGop += normalizedGop;
      }

      final overallGop = scores.isNotEmpty ? totalGop / scores.length : 0.0;

      AppLogger.d(
        'GOP computed: ${expectedPhonemes.join(",")} -> '
        'overall=${overallGop.toStringAsFixed(1)}, '
        'per-phoneme=[${scores.map((s) => '${s.phoneme}:${s.gopScore.toStringAsFixed(0)}').join(", ")}]',
        tag: 'GopService',
      );

      return GopResult(
        phonemeScores: scores,
        overallGop: overallGop,
      );
    } catch (e) {
      AppLogger.e('Failed to compute GOP scores',
          error: e, tag: 'GopService');
      return const GopResult(phonemeScores: [], overallGop: 0.0);
    }
  }

  /// Compute frame ranges for each phoneme using type-aware weighting.
  ///
  /// Consonants receive [_consonantWeight] share and vowels receive
  /// [_vowelWeight] share of the total frames, proportionally.
  List<_FrameRange> _computeFrameRanges(
    List<String> phonemes,
    int totalFrames,
  ) {
    if (phonemes.isEmpty || totalFrames == 0) return [];

    // Compute total weight
    double totalWeight = 0.0;
    final weights = <double>[];
    for (final phoneme in phonemes) {
      final type = KoreanPhonemeUtils.classifyPhoneme(phoneme);
      final w = type == PhonemeType.vowel ? _vowelWeight : _consonantWeight;
      weights.add(w);
      totalWeight += w;
    }

    // Allocate frames proportionally, ensuring at least 1 frame per phoneme
    final ranges = <_FrameRange>[];
    int usedFrames = 0;

    for (int i = 0; i < phonemes.length; i++) {
      final startFrame = usedFrames;
      int frameCount;

      if (i == phonemes.length - 1) {
        // Last phoneme gets remaining frames
        frameCount = totalFrames - usedFrames;
      } else {
        frameCount =
            ((weights[i] / totalWeight) * totalFrames).round().clamp(1, totalFrames - usedFrames);
      }

      if (frameCount <= 0) frameCount = 1;
      usedFrames += frameCount;

      ranges.add(_FrameRange(start: startFrame, end: startFrame + frameCount));
    }

    return ranges;
  }

  /// Sigmoid-based normalization for more natural score distribution.
  ///
  /// Maps log-probability to 0-100 using a sigmoid curve centered around
  /// the typical threshold between "acceptable" and "poor" pronunciation.
  ///
  /// - avgLogProb ≈ -1.0: ~95 (excellent, native-like)
  /// - avgLogProb ≈ -3.0: ~75 (good)
  /// - avgLogProb ≈ -5.0: ~50 (fair)
  /// - avgLogProb ≈ -7.0: ~25 (poor)
  /// - avgLogProb ≈ -10.0: ~5 (very poor)
  static double _sigmoidNormalize(double avgLogProb) {
    // Sigmoid: 100 / (1 + exp(-k * (x - center)))
    // k controls steepness, center is the midpoint
    const k = 0.8;
    const center = -4.5; // midpoint at ~50 score
    final sigmoid = 100.0 / (1.0 + exp(-k * (avgLogProb - center)));
    return sigmoid.clamp(0.0, 100.0);
  }

  /// Compute log-softmax for a specific index
  double _logSoftmax(List<double> logits, int index) {
    final maxLogit = logits.reduce(max);
    final sumExp =
        logits.fold<double>(0.0, (sum, l) => sum + exp(l - maxLogit));
    return (logits[index] - maxLogit) - log(sumExp);
  }

  /// Load audio file as Float32 array (16kHz mono PCM)
  Future<Float32List> _loadAudioAsFloat32(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!file.existsSync()) return Float32List(0);

      final bytes = await file.readAsBytes();
      // For WAV files, skip header (44 bytes) and convert PCM16 to float32
      if (audioPath.endsWith('.wav') && bytes.length > 44) {
        final pcmData = bytes.sublist(44);
        final int16View = Int16List.view(
            pcmData.buffer, pcmData.offsetInBytes, pcmData.lengthInBytes ~/ 2);
        final floats = Float32List(int16View.length);
        for (int i = 0; i < int16View.length; i++) {
          floats[i] = int16View[i] / 32768.0;
        }
        return floats;
      }
      return Float32List(0);
    } catch (e) {
      AppLogger.e('Failed to load audio', error: e, tag: 'GopService');
      return Float32List(0);
    }
  }

  void dispose() {
    _session?.release();
    _session = null;
    _sessionOptions?.release();
    _sessionOptions = null;
    _isInitialized = false;
  }
}

/// Frame range for a phoneme within the audio.
class _FrameRange {
  final int start;
  final int end;
  const _FrameRange({required this.start, required this.end});
}

/// Result from GOP computation
class GopResult {
  final List<PhonemeGopScore> phonemeScores;
  final double overallGop;

  const GopResult({
    required this.phonemeScores,
    required this.overallGop,
  });
}

/// GOP score for a single phoneme
class PhonemeGopScore {
  final String phoneme;
  final double gopScore; // Normalized 0-100
  final double confidence; // Posterior probability 0-1
  final int startFrame;
  final int endFrame;

  const PhonemeGopScore({
    required this.phoneme,
    required this.gopScore,
    required this.confidence,
    required this.startFrame,
    required this.endFrame,
  });
}
