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
}

class SpeechProvider extends ChangeNotifier {
  final AudioRecorderService _recorder = AudioRecorderService();

  SpeechRecordingState _recordingState = SpeechRecordingState.idle;
  SpeechResult? _lastResult;
  bool _isInitialized = false;
  bool _servicesReady = false;

  SpeechRecordingState get recordingState => _recordingState;
  SpeechResult? get lastResult => _lastResult;
  bool get isRecording => _recordingState == SpeechRecordingState.recording;
  bool get isProcessing => _recordingState == SpeechRecordingState.processing;
  bool get isReady => _servicesReady;

  /// Initialize the speech system.
  /// Copies bundled models from assets if needed, then initializes
  /// Whisper + GOP services. Fully offline.
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    await _recorder.initialize();

    try {
      // Ensure bundled models are copied to documents directory
      await SpeechModelManager.instance.ensureModelsReady();

      // Initialize GOP speech service (Whisper removed — GOP-only scoring)
      await GopService.instance.initialize();
      _servicesReady = true;
      AppLogger.i('Speech services initialized', tag: 'SpeechProvider');
    } catch (e) {
      AppLogger.e('Failed to initialize speech services',
          error: e, tag: 'SpeechProvider');
    }
    notifyListeners();
  }

  /// Start recording for pronunciation practice.
  Future<bool> startRecording() async {
    if (!_recorder.isSupported) return false;

    final path = await _recorder.startRecording();
    if (path != null) {
      _recordingState = SpeechRecordingState.recording;
      _lastResult = null;
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
      AppLogger.e('Speech analysis failed', error: e, tag: 'SpeechProvider');
      _recordingState = SpeechRecordingState.idle;
      notifyListeners();
      return null;
    } finally {
      AudioRecorderService.cleanupFile(path);
    }
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
