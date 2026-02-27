import 'package:flutter_tts/flutter_tts.dart';

/// Helper for playing Korean text audio using on-device TTS.
class KoreanTtsHelper {
  static FlutterTts? _tts;

  static Future<FlutterTts> _getTts() async {
    if (_tts == null) {
      _tts = FlutterTts();
      await _tts!.setLanguage('ko-KR');
      await _tts!.setSpeechRate(0.5);
      await _tts!.setVolume(1.0);
      await _tts!.setPitch(1.0);
    }
    return _tts!;
  }

  /// Play Korean text using on-device TTS.
  /// [text] - Korean text to pronounce
  /// [speed] - playback speed (default 1.0)
  static Future<void> playKoreanText(
    String text, {
    double speed = 1.0,
  }) async {
    final tts = await _getTts();
    await tts.setSpeechRate(speed * 0.5);
    await tts.speak(text);
  }
}
