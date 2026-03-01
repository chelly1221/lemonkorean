import 'package:flutter/foundation.dart';

import '../../core/services/gop_service.dart';
import '../../core/services/audio_recorder_service.dart';
import '../../core/services/speech_model_manager.dart';
import '../../core/services/pronunciation_scorer.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/app_logger.dart';

enum SpeechRecordingState {
  idle,
  recording,
  processing,
  scored,
  error,
}

class SpeechProvider extends ChangeNotifier {
  final AudioRecorderService _recorder = AudioRecorderService();

  SpeechRecordingState _recordingState = SpeechRecordingState.idle;
  SpeechResult? _lastResult;
  bool _isInitialized = false;
  bool _servicesReady = false;
  bool _isInitializing = false;
  String? _initError;
  String? _initErrorDetail;
  String? _errorMessage;

  SpeechRecordingState get recordingState => _recordingState;
  SpeechResult? get lastResult => _lastResult;
  bool get isRecording => _recordingState == SpeechRecordingState.recording;
  bool get isProcessing => _recordingState == SpeechRecordingState.processing;
  bool get isReady => _servicesReady;
  bool get isInitializing => _isInitializing;
  String? get initError => _initError;
  String? get initErrorDetail => _initErrorDetail;
  String? get errorMessage => _errorMessage;

  /// Initialize the speech system.
  /// Copies bundled models from assets if needed, then initializes
  /// Whisper + GOP services. Fully offline.
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    _isInitializing = true;
    _initError = null;
    notifyListeners();

    await _recorder.initialize();

    try {
      // Ensure bundled GOP model is copied to documents directory
      AppLogger.i('[SpeechProvider] Copying models...', tag: 'SpeechProvider');
      await SpeechModelManager.instance.ensureModelsReady();
      AppLogger.i('[SpeechProvider] Models ready, initializing GOP...', tag: 'SpeechProvider');

      // Initialize GOP speech service (Whisper removed — GOP-only scoring)
      await GopService.instance.initialize();

      if (!GopService.instance.isInitialized) {
        _initError = 'modelLoadFailed';
        _initErrorDetail = 'GOP 서비스 초기화 실패 (ONNX 세션 생성 불가)';
        _isInitializing = false;
        AppLogger.e('[SpeechProvider] GOP service failed to initialize',
            tag: 'SpeechProvider');
        notifyListeners();
        return;
      }

      _servicesReady = true;
      _isInitializing = false;
      AppLogger.i('[SpeechProvider] Speech services initialized', tag: 'SpeechProvider');
    } catch (e) {
      _initError = 'modelLoadFailed';
      _initErrorDetail = e.toString();
      _isInitializing = false;
      AppLogger.e('[SpeechProvider] Failed to initialize speech services',
          error: e, tag: 'SpeechProvider');
    }
    notifyListeners();
  }

  /// Retry initialization after a failure.
  Future<void> retryInitialize() async {
    _isInitialized = false;
    _servicesReady = false;
    _initError = null;
    _initErrorDetail = null;
    notifyListeners();
    await initialize();
  }

  /// Start recording for pronunciation practice.
  Future<bool> startRecording() async {
    if (!_recorder.isSupported) return false;

    final path = await _recorder.startRecording();
    if (path != null) {
      _recordingState = SpeechRecordingState.recording;
      _lastResult = null;
      _errorMessage = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Stop recording and analyze pronunciation.
  Future<SpeechResult?> stopAndAnalyze({
    required String expectedText,
    String language = 'ko',
  }) async {
    final path = await _recorder.stopRecording();
    if (path == null) {
      _recordingState = SpeechRecordingState.idle;
      notifyListeners();
      return null;
    }

    _recordingState = SpeechRecordingState.processing;
    notifyListeners();

    try {
      final result = await PronunciationScorer.instance.score(
        expectedText: expectedText,
        audioPath: path,
        language: language,
      );

      _lastResult = result;
      _recordingState = SpeechRecordingState.scored;

      await LocalStorage.updatePronunciationStats(
        character: expectedText,
        score: result.overallScore,
      );

      notifyListeners();
      return result;
    } catch (e) {
      AppLogger.e('[SpeechProvider] Speech analysis failed', error: e, tag: 'SpeechProvider');
      _errorMessage = _classifyError(e);
      _recordingState = SpeechRecordingState.error;
      notifyListeners();
      return null;
    } finally {
      AudioRecorderService.cleanupFile(path);
    }
  }

  /// Classify error into user-facing error code.
  String _classifyError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('too short') || msg.contains('duration')) {
      return 'audioTooShort';
    }
    if (msg.contains('onnx') || msg.contains('model') || msg.contains('session')) {
      return 'modelError';
    }
    if (msg.contains('embedding') || msg.contains('reference')) {
      return 'modelError';
    }
    return 'analysisError';
  }

  /// Cancel current recording.
  Future<void> cancelRecording() async {
    await _recorder.cancelRecording();
    _recordingState = SpeechRecordingState.idle;
    notifyListeners();
  }

  /// Reset state for next character.
  void resetForNext() {
    _lastResult = null;
    _errorMessage = null;
    _recordingState = SpeechRecordingState.idle;
    notifyListeners();
  }

  /// Check if microphone permission is granted.
  Future<bool> hasMicPermission() async {
    return _recorder.hasPermission;
  }

  /// Request microphone permission.
  Future<bool> requestMicPermission() async {
    return _recorder.requestPermission();
  }

  /// Get pronunciation mastery for a character.
  int getMastery(String character) {
    return LocalStorage.getPronunciationMastery(character);
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
