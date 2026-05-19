import 'package:whisper_flutter_new/whisper_flutter_new.dart';
import 'speech_model_manager.dart';
import '../utils/app_logger.dart';

/// On-device Whisper service for Korean speech transcription.
/// Provides offline speech-to-text using whisper.cpp.
///
/// Models are downloaded from the on-premise media server via
/// [SpeechModelManager], NOT from HuggingFace. The Whisper instance
/// is pointed at the locally managed model directory so it never
/// reaches out to external hosts.
class WhisperService {
  static final WhisperService instance = WhisperService._();
  WhisperService._();

  Whisper? _whisper;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Initialize using the model already downloaded by [SpeechModelManager].
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final modelDir = await SpeechModelManager.instance.getModelDir('whisper');

      _whisper = Whisper(
        model: WhisperModel.base,
        modelDir: modelDir,
        downloadHost: '',
      );
      _isInitialized = true;
      AppLogger.i('Whisper initialized (on-premise model at $modelDir)',
          tag: 'WhisperService');
    } catch (e) {
      AppLogger.e('Failed to initialize Whisper',
          error: e, tag: 'WhisperService');
      _isInitialized = false;
    }
  }

  /// Transcribe audio file to Korean text.
  Future<WhisperTranscribeResult?> transcribe(String audioPath) async {
    if (!_isInitialized || _whisper == null) {
      AppLogger.w('Whisper not initialized, cannot transcribe',
          tag: 'WhisperService');
      return null;
    }

    try {
      final response = await _whisper!.transcribe(
        transcribeRequest: TranscribeRequest(
          audio: audioPath,
          isTranslate: false,
          language: 'ko',
          isNoTimestamps: false,
        ),
      );

      final segments = response.segments
              ?.map((s) => WhisperSegmentData(
                    text: s.text.trim(),
                    start: s.fromTs,
                    end: s.toTs,
                  ))
              .toList() ??
          [];

      return WhisperTranscribeResult(
        text: response.text.trim(),
        segments: segments,
      );
    } catch (e) {
      AppLogger.e('Transcription failed', error: e, tag: 'WhisperService');
      return null;
    }
  }

  void dispose() {
    _whisper = null;
    _isInitialized = false;
  }
}

/// Result from Whisper transcription.
class WhisperTranscribeResult {
  final String text;
  final List<WhisperSegmentData> segments;

  const WhisperTranscribeResult({
    required this.text,
    required this.segments,
  });

  double get confidence => text.isNotEmpty ? 0.8 : 0.0;
}

/// A single segment from Whisper with timing.
class WhisperSegmentData {
  final String text;
  final Duration start;
  final Duration end;

  const WhisperSegmentData({
    required this.text,
    required this.start,
    required this.end,
  });

  Duration get duration => end - start;
}
