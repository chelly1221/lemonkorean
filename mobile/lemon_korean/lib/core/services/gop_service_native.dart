import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:onnxruntime_v2/onnxruntime_v2.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_logger.dart';

/// Result containing both mean-pooled embedding and frame-level data.
class EmbeddingResult {
  /// 1024-dim L2-normalized mean-pooled embedding.
  final List<double> embedding;

  /// [T, 1024] frame-level hidden states for per-phoneme analysis.
  final List<List<double>> frames;

  const EmbeddingResult({required this.embedding, required this.frames});
}

/// Embedding-based pronunciation scoring service.
///
/// Uses a trimmed wav2vec2-korean ONNX model that outputs 1024-dim hidden
/// state embeddings instead of CTC logits. The CTC head was removed because
/// its 1205 output classes don't match the 46 jamo labels we need.
///
/// Scoring approach:
/// 1. Extract 1024-dim embedding from user audio (mean pool across time)
/// 2. Compare with pre-computed TTS reference embedding via cosine similarity
/// 3. Map similarity to 0-100 score
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

  /// Embedding dimension of the wav2vec2 hidden state.
  static const int embeddingDim = 1024;

  /// Minimum audio samples for valid scoring (0.15s at 16kHz).
  static const int _minAudioSamples = 2400;

  /// Initialize the ONNX model.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _modelPath = '${dir.path}/models/gop/wav2vec2_korean_emb_q8.onnx';

      final modelFile = File(_modelPath!);
      if (!modelFile.existsSync()) {
        AppLogger.w(
          '[GopService] Model not found at $_modelPath',
          tag: 'GopService',
        );
        throw Exception('Model file not found: $_modelPath');
      }

      final fileSize = modelFile.lengthSync();
      AppLogger.i(
        '[GopService] Model found: path=$_modelPath, size=${(fileSize / 1024 / 1024).toStringAsFixed(1)}MB',
        tag: 'GopService',
      );

      AppLogger.i('[GopService] Initializing ORT environment...', tag: 'GopService');
      OrtEnv.instance.init();

      AppLogger.i('[GopService] Creating ORT session options...', tag: 'GopService');
      _sessionOptions = OrtSessionOptions()
        ..setInterOpNumThreads(1)
        ..setIntraOpNumThreads(1)
        ..setSessionGraphOptimizationLevel(
            GraphOptimizationLevel.ortEnableAll);

      AppLogger.i('[GopService] Loading ONNX session (${(fileSize / 1024 / 1024).toStringAsFixed(0)}MB)...', tag: 'GopService');
      _session = OrtSession.fromFile(modelFile, _sessionOptions!);
      AppLogger.i(
        '[GopService] ONNX session loaded: '
        'inputs=${_session!.inputNames}, outputs=${_session!.outputNames}',
        tag: 'GopService',
      );

      _isInitialized = true;
      AppLogger.i('[GopService] Service initialized (embedding mode)', tag: 'GopService');
    } catch (e, st) {
      AppLogger.e(
        '[GopService] Failed to initialize: $e',
        error: e,
        stackTrace: st,
        tag: 'GopService',
      );
      _isInitialized = false;
      rethrow;
    }
  }

  /// Extract a mean-pooled, L2-normalized embedding from an audio file.
  ///
  /// Returns a 1024-dim embedding vector, or null if extraction fails.
  Future<List<double>?> extractEmbedding(String audioPath) async {
    final result = await extractEmbeddingWithFrames(audioPath);
    return result?.embedding;
  }

  /// Extract embedding with frame-level data for per-phoneme analysis.
  ///
  /// Returns both the mean-pooled embedding and raw [T, 1024] frames,
  /// or null if extraction fails.
  Future<EmbeddingResult?> extractEmbeddingWithFrames(String audioPath) async {
    if (!_isInitialized || _session == null) {
      AppLogger.w('[GopService] Not initialized, cannot extract embedding', tag: 'GopService');
      return null;
    }

    try {
      final audioData = await _parseWavToFloat32(audioPath);
      if (audioData.isEmpty) return null;

      if (audioData.length < _minAudioSamples) {
        AppLogger.w(
          '[GopService] Audio too short: ${audioData.length} samples '
          '(min $_minAudioSamples, ${(_minAudioSamples / 16000 * 1000).round()}ms)',
          tag: 'GopService',
        );
        return null;
      }

      final rawRms = _computeRms(audioData, 0, audioData.length);

      // Reject if no speech detected (ambient noise only)
      // Silent recordings: rms ~0.01-0.02, actual speech: rms ~0.05+
      if (rawRms < 0.03) {
        AppLogger.w(
          'Audio too quiet (rms=${rawRms.toStringAsFixed(4)}), no speech detected',
          tag: 'GopService',
        );
        return null;
      }

      final processed = _preprocessAudio(audioData);
      if (processed.isEmpty) {
        return null;
      }

      final frames = _runOnnxInference(processed);
      if (frames.isEmpty) {
        return null;
      }

      final embedding = _meanPool(frames);
      AppLogger.d(
        '[GopService] Embedding extracted: dim=${embedding.length}, '
        'frames=${frames.length}',
        tag: 'GopService',
      );
      return EmbeddingResult(embedding: embedding, frames: frames);
    } catch (e, st) {
      AppLogger.e(
        '[GopService] Failed to extract embedding',
        error: e,
        stackTrace: st,
        tag: 'GopService',
      );
      return null;
    }
  }

  /// Mean pool across time axis and L2 normalize.
  ///
  /// Input: [T, 1024] frames from model output.
  /// Output: [1024] L2-normalized embedding vector.
  List<double> _meanPool(List<List<double>> frames) {
    final dim = frames[0].length;
    final mean = List<double>.filled(dim, 0.0);

    for (final frame in frames) {
      for (int i = 0; i < dim; i++) {
        mean[i] += frame[i];
      }
    }

    final n = frames.length.toDouble();
    double normSq = 0.0;
    for (int i = 0; i < dim; i++) {
      mean[i] /= n;
      normSq += mean[i] * mean[i];
    }

    // L2 normalize
    final norm = sqrt(normSq);
    if (norm > 1e-8) {
      for (int i = 0; i < dim; i++) {
        mean[i] /= norm;
      }
    }

    return mean;
  }

  /// Preprocess audio: DC removal → VAD (trim silence).
  /// Minimal processing to match reference embeddings generated from raw TTS audio.
  Float32List _preprocessAudio(Float32List raw) {
    const frameSize = 160; // 10ms at 16kHz

    // ---- Step 1: DC offset removal ----
    double sum = 0.0;
    for (int i = 0; i < raw.length; i++) {
      sum += raw[i];
    }
    final dcOffset = sum / raw.length;
    final dcRemoved = Float32List(raw.length);
    for (int i = 0; i < raw.length; i++) {
      dcRemoved[i] = raw[i] - dcOffset;
    }

    // ---- Step 2: VAD — keep only voiced frames ----
    final signalRms = _computeRms(dcRemoved, 0, dcRemoved.length);
    final vadThreshold = max(signalRms * 0.05, 1e-4);
    final voicedSamples = <double>[];

    for (int i = 0; i < dcRemoved.length; i += frameSize) {
      final end = min(i + frameSize, dcRemoved.length);
      final frameRms = _computeRms(dcRemoved, i, end);
      if (frameRms > vadThreshold) {
        for (int j = i; j < end; j++) {
          voicedSamples.add(dcRemoved[j]);
        }
      }
    }

    if (voicedSamples.isEmpty) {
      return Float32List(0);
    }

    final trimmed = Float32List.fromList(voicedSamples);

    if (trimmed.length < _minAudioSamples) {
      return Float32List(0);
    }

    return trimmed;
  }

  /// Compute RMS of a float32 audio segment.
  static double _computeRms(Float32List data, int start, int end) {
    if (end <= start) return 0.0;
    double sumSq = 0.0;
    for (int i = start; i < end; i++) {
      sumSq += data[i] * data[i];
    }
    return sqrt(sumSq / (end - start));
  }


  /// Run ONNX model inference on audio data.
  /// Returns [T, 1024] hidden state frames.
  List<List<double>> _runOnnxInference(Float32List audioData) {
    final inputTensor = OrtValueTensor.createTensorWithDataList(
      Float32List.fromList(audioData),
      [1, audioData.length],
    );

    final runOptions = OrtRunOptions();

    try {
      final inputName =
          _session!.inputNames.isNotEmpty ? _session!.inputNames[0] : 'input_values';
      final inputs = {inputName: inputTensor};
      final outputs = _session!.run(runOptions, inputs);

      if (outputs.isEmpty || outputs[0] == null) {
        AppLogger.w('[GopService] ONNX inference returned empty output', tag: 'GopService');
        return [];
      }

      final outputValue = outputs[0]!.value;

      List<List<double>> frames;
      if (outputValue is List<List<List<double>>>) {
        // [1, T, 1024] → [T, 1024]
        frames = outputValue[0]
            .map((frame) => frame.map((v) => v.toDouble()).toList())
            .toList();
      } else if (outputValue is List<List<double>>) {
        // [T, 1024]
        frames = outputValue
            .map((frame) => frame.map((v) => v.toDouble()).toList())
            .toList();
      } else {
        AppLogger.w(
          '[GopService] Unexpected ONNX output type: ${outputValue.runtimeType}',
          tag: 'GopService',
        );
        frames = [];
      }

      if (frames.isNotEmpty) {
        AppLogger.d(
          '[GopService] ONNX output: frames=${frames.length}, dim=${frames[0].length}',
          tag: 'GopService',
        );
      }

      for (final output in outputs) {
        output?.release();
      }

      return frames;
    } finally {
      inputTensor.release();
      runOptions.release();
    }
  }

  /// Parse WAV file with proper header handling and convert to Float32.
  Future<Float32List> _parseWavToFloat32(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!file.existsSync()) {
        AppLogger.w('[GopService] Audio file not found: $audioPath', tag: 'GopService');
        return Float32List(0);
      }

      final bytes = await file.readAsBytes();
      AppLogger.d(
        '[GopService] Audio file: $audioPath, size=${bytes.length} bytes',
        tag: 'GopService',
      );

      if (!audioPath.endsWith('.wav') || bytes.length < 44) {
        AppLogger.w('[GopService] Not a valid WAV file or too small', tag: 'GopService');
        return Float32List(0);
      }

      // Validate RIFF header
      final riff = String.fromCharCodes(bytes.sublist(0, 4));
      final wave = String.fromCharCodes(bytes.sublist(8, 12));
      if (riff != 'RIFF' || wave != 'WAVE') {
        AppLogger.w('[GopService] Invalid WAV header: RIFF=$riff, WAVE=$wave', tag: 'GopService');
        return Float32List(0);
      }

      // Walk chunks to find 'fmt ' and 'data'
      int offset = 12;
      int? dataOffset;
      int? dataSize;
      int audioFormat = 0;
      int numChannels = 0;
      int sampleRate = 0;
      int bitsPerSample = 0;

      while (offset < bytes.length - 8) {
        final chunkId = String.fromCharCodes(bytes.sublist(offset, offset + 4));
        final chunkSize = ByteData.view(bytes.buffer, bytes.offsetInBytes + offset + 4, 4)
            .getUint32(0, Endian.little);

        if (chunkId == 'fmt ') {
          if (offset + 8 + chunkSize > bytes.length) break;
          final fmt = ByteData.view(bytes.buffer, bytes.offsetInBytes + offset + 8, chunkSize);
          audioFormat = fmt.getUint16(0, Endian.little);
          numChannels = fmt.getUint16(2, Endian.little);
          sampleRate = fmt.getUint32(4, Endian.little);
          bitsPerSample = fmt.getUint16(14, Endian.little);

          AppLogger.d(
            '[GopService] WAV fmt: format=$audioFormat, channels=$numChannels, '
            'sampleRate=$sampleRate, bitsPerSample=$bitsPerSample',
            tag: 'GopService',
          );
        } else if (chunkId == 'data') {
          dataOffset = offset + 8;
          dataSize = chunkSize;
          break;
        }

        offset += 8 + chunkSize;
        if (chunkSize % 2 != 0) offset += 1;
      }

      if (dataOffset == null || dataSize == null) {
        AppLogger.w('[GopService] WAV data chunk not found', tag: 'GopService');
        return Float32List(0);
      }

      if (audioFormat != 1) {
        AppLogger.w('[GopService] WAV not PCM format (audioFormat=$audioFormat)', tag: 'GopService');
        return Float32List(0);
      }

      final availableBytes = bytes.length - dataOffset;
      if (dataSize > availableBytes) {
        dataSize = availableBytes;
      }

      final pcmData = bytes.sublist(dataOffset, dataOffset + dataSize);
      final int16View = Int16List.view(
          pcmData.buffer, pcmData.offsetInBytes, pcmData.lengthInBytes ~/ 2);
      final floats = Float32List(int16View.length);
      for (int i = 0; i < int16View.length; i++) {
        floats[i] = int16View[i] / 32768.0;
      }

      final rms = _computeRms(floats, 0, floats.length);
      final maxAbs = floats.fold<double>(0.0, (m, v) => max(m, v.abs()));
      AppLogger.d(
        '[GopService] PCM loaded: ${floats.length} samples, '
        'rms=${rms.toStringAsFixed(4)}, maxAbs=${maxAbs.toStringAsFixed(4)}, '
        'duration=${(floats.length / 16000 * 1000).round()}ms',
        tag: 'GopService',
      );

      return floats;
    } catch (e, st) {
      AppLogger.e('[GopService] Failed to parse WAV', error: e, stackTrace: st, tag: 'GopService');
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
