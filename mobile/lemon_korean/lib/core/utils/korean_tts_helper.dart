import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

import '../constants/app_constants.dart';

/// Helper for playing Korean text audio.
/// Tries server audio first, falls back to flutter_tts.
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

  /// Play Korean text using server audio first, then TTS fallback.
  /// [text] - Korean text to pronounce
  /// [audioPlayer] - existing AudioPlayer instance to reuse for server audio
  /// [speed] - playback speed (default 1.0)
  static Future<void> playKoreanText(
    String text,
    AudioPlayer audioPlayer, {
    double speed = 1.0,
  }) async {
    // 1. Try server audio
    try {
      final audioUrl =
          '${AppConstants.mediaUrl}/hangul/audio/${Uri.encodeComponent(text)}.mp3';
      await audioPlayer.setUrl(audioUrl);
      await audioPlayer.setSpeed(speed);
      await audioPlayer.play();
      await audioPlayer.processingStateStream
          .firstWhere((s) => s == ProcessingState.completed);
      return;
    } catch (e) {
      debugPrint('[KoreanTtsHelper] Server audio failed for "$text": $e');
    }

    // 2. Fall back to flutter_tts
    try {
      final tts = await _getTts();
      await tts.setSpeechRate(speed * 0.5);
      await tts.speak(text);
    } catch (e) {
      debugPrint('[KoreanTtsHelper] TTS also failed for "$text": $e');
      rethrow;
    }
  }
}
