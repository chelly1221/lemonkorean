import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:onnxruntime/onnxruntime.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

/// GOP (Goodness of Pronunciation) service.
/// Uses wav2vec2-korean ONNX model to compute per-phoneme pronunciation quality scores.
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

  /// Korean phoneme labels for wav2vec2-large-xlsr-korean model
  /// These map to the output logit indices of the model
  static const List<String> phonemeLabels = [
    '<pad>', '<s>', '</s>', '<unk>',
    // Korean consonants (초성)
    'ㄱ', 'ㄲ', 'ㄴ', 'ㄷ', 'ㄸ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅃ',
    'ㅅ', 'ㅆ', 'ㅇ', 'ㅈ', 'ㅉ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ',
    // Korean vowels (중성)
    'ㅏ', 'ㅐ', 'ㅑ', 'ㅒ', 'ㅓ', 'ㅔ', 'ㅕ', 'ㅖ', 'ㅗ', 'ㅘ',
    'ㅙ', 'ㅚ', 'ㅛ', 'ㅜ', 'ㅝ', 'ㅞ', 'ㅟ', 'ㅠ', 'ㅡ', 'ㅢ', 'ㅣ',
    // Final consonants (종성) - subset
    '|', // word boundary
  ];

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

  /// Extract per-frame phoneme logits from audio
  /// Returns a 2D list: [timeFrames][numPhonemes] of log probabilities
  Future<List<List<double>>> extractPhonemeLogits(String audioPath) async {
    if (!_isInitialized) {
      AppLogger.w('GOP service not initialized', tag: 'GopService');
      return [];
    }

    try {
      // Read and preprocess audio to float32 array (16kHz mono)
      final audioData = await _loadAudioAsFloat32(audioPath);
      if (audioData.isEmpty) return [];

      // Run ONNX inference if session is available, otherwise fall back
      if (_session != null) {
        return _runOnnxInference(audioData);
      }

      // Fallback: generate synthetic logits for development/testing
      return _generateDevelopmentLogits(audioData.length);
    } catch (e) {
      AppLogger.e('Failed to extract phoneme logits',
          error: e, tag: 'GopService');
      return [];
    }
  }

  /// Run ONNX model inference on audio data
  List<List<double>> _runOnnxInference(Float32List audioData) {
    // Create input tensor: shape [1, audioLength] (batch=1)
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList(audioData),
      [1, audioData.length],
    );

    final runOptions = OrtRunOptions();

    try {
      // Build inputs map using the model's input names
      final inputName =
          _session!.inputNames.isNotEmpty ? _session!.inputNames[0] : 'input';
      final inputs = {inputName: inputTensor};

      // Run inference
      final outputs = _session!.run(runOptions, inputs);

      if (outputs.isEmpty || outputs[0] == null) {
        AppLogger.w('ONNX inference returned empty output', tag: 'GopService');
        return [];
      }

      // Extract logits from output tensor
      // Expected output shape: [1, timeFrames, numPhonemes]
      final outputValue = outputs[0]!.value;

      List<List<double>> logits;
      if (outputValue is List<List<List<double>>>) {
        // Shape [1, T, C] -> take batch 0
        logits = outputValue[0]
            .map((frame) => frame.map((v) => v.toDouble()).toList())
            .toList();
      } else if (outputValue is List<List<double>>) {
        // Shape [T, C] -> use directly
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

      // Release output tensors
      for (final output in outputs) {
        output?.release();
      }

      return logits;
    } finally {
      // Always release input resources
      inputTensor.release();
      runOptions.release();
    }
  }

  /// Compute GOP scores using forced alignment
  /// [audioPath] - path to recorded audio file
  /// [expectedPhonemes] - list of expected phonemes e.g. ['ㄱ', 'ㅏ']
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

      // Forced alignment: divide audio frames equally among expected phonemes
      final framesPerPhoneme = logits.length ~/ expectedPhonemes.length;
      if (framesPerPhoneme == 0) {
        return const GopResult(phonemeScores: [], overallGop: 0.0);
      }

      final scores = <PhonemeGopScore>[];
      double totalGop = 0.0;

      for (int i = 0; i < expectedPhonemes.length; i++) {
        final startFrame = i * framesPerPhoneme;
        final endFrame = (i == expectedPhonemes.length - 1)
            ? logits.length
            : (i + 1) * framesPerPhoneme;

        final phoneme = expectedPhonemes[i];
        final phonemeIdx = phonemeLabels.indexOf(phoneme);

        if (phonemeIdx < 0) {
          // Unknown phoneme, skip
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
            // Convert logit to log probability using log-softmax
            final logProb = _logSoftmax(logits[f], phonemeIdx);
            sumLogProb += logProb;
            frameCount++;
          }
        }

        final avgLogProb = frameCount > 0 ? sumLogProb / frameCount : -10.0;
        // Normalize GOP to 0-100 scale
        // Typical GOP range: -10 (very bad) to 0 (perfect)
        final normalizedGop =
            ((avgLogProb + 10.0) / 10.0 * 100.0).clamp(0.0, 100.0);

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

  /// Generate development/testing logits when model is not available
  /// Simulates reasonable phoneme distributions for testing the scoring pipeline
  List<List<double>> _generateDevelopmentLogits(int audioSamples) {
    final random = Random(42);
    final numFrames = audioSamples ~/ 320; // 20ms frames at 16kHz
    final numPhonemes = phonemeLabels.length;

    return List.generate(numFrames, (f) {
      return List.generate(numPhonemes, (p) {
        // Generate somewhat realistic logit distribution
        // Most phonemes have low probability, a few have higher
        return -5.0 + random.nextDouble() * 4.0;
      });
    });
  }

  void dispose() {
    _session?.release();
    _session = null;
    _sessionOptions?.release();
    _sessionOptions = null;
    _isInitialized = false;
  }
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
