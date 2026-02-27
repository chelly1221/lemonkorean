import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../utils/app_logger.dart';

/// Audio recording service optimized for speech recognition.
/// Records in WAV 16kHz mono format for ASR compatibility.
class AudioRecorderService {
  AudioRecorder? _recorder;
  bool _isRecording = false;
  bool _hasPermission = false;
  bool _isSupported = false;
  String? _currentPath;

  bool get isRecording => _isRecording;
  bool get hasPermission => _hasPermission;
  bool get isSupported => _isSupported;
  String? get currentPath => _currentPath;

  /// Initialize the recorder and check platform support
  Future<void> initialize() async {
    _isSupported = !kIsWeb && (Platform.isIOS || Platform.isAndroid);
    if (!_isSupported) {
      AppLogger.w('Recording not supported on this platform',
          tag: 'AudioRecorder');
      return;
    }
    _recorder = AudioRecorder();
    await checkPermission();
  }

  /// Check current microphone permission status
  Future<bool> checkPermission() async {
    if (!_isSupported) return false;
    final status = await Permission.microphone.status;
    _hasPermission = status.isGranted;
    return _hasPermission;
  }

  /// Request microphone permission
  Future<bool> requestPermission() async {
    if (!_isSupported) return false;
    final status = await Permission.microphone.request();
    _hasPermission = status.isGranted;
    return _hasPermission;
  }

  /// Start recording in WAV 16kHz mono format (optimized for ASR)
  /// Returns the file path where audio will be saved
  Future<String?> startRecording() async {
    if (!_isSupported || _recorder == null || _isRecording) return null;

    if (!_hasPermission) {
      final granted = await requestPermission();
      if (!granted) return null;
    }

    try {
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentPath = '${tempDir.path}/speech_$timestamp.wav';

      await _recorder!.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 256000,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: _currentPath!,
      );

      _isRecording = true;
      AppLogger.d('Recording started: $_currentPath', tag: 'AudioRecorder');
      return _currentPath;
    } catch (e) {
      AppLogger.e('Failed to start recording',
          error: e, tag: 'AudioRecorder');
      _isRecording = false;
      _currentPath = null;
      return null;
    }
  }

  /// Stop recording and return the file path
  Future<String?> stopRecording() async {
    if (!_isSupported || _recorder == null || !_isRecording) return null;

    try {
      final path = await _recorder!.stop();
      _isRecording = false;
      AppLogger.d('Recording stopped: $path', tag: 'AudioRecorder');
      return path ?? _currentPath;
    } catch (e) {
      AppLogger.e('Failed to stop recording',
          error: e, tag: 'AudioRecorder');
      _isRecording = false;
      return null;
    }
  }

  /// Cancel recording and delete the file
  Future<void> cancelRecording() async {
    await stopRecording();
    if (_currentPath != null) {
      final file = File(_currentPath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
      _currentPath = null;
    }
  }

  /// Clean up a specific recording file
  static Future<void> cleanupFile(String? path) async {
    if (path == null) return;
    try {
      final file = File(path);
      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  void dispose() {
    _recorder?.dispose();
    _recorder = null;
    _isRecording = false;
  }
}
