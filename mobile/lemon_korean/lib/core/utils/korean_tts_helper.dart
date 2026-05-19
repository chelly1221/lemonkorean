import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

/// Helper for playing Korean text audio from bundled assets.
/// All audio files are pre-generated using Google Cloud TTS (Wavenet).
/// No device TTS fallback — bundled audio only.
class KoreanTtsHelper {
  static AudioPlayer? _player;
  static Set<String>? _bundledTexts;

  static AudioPlayer _getPlayer() {
    _player ??= AudioPlayer();
    return _player!;
  }

  /// Lazily load the set of bundled audio texts from asset manifest.
  static Future<Set<String>> _getBundledTexts() async {
    if (_bundledTexts != null) return _bundledTexts!;
    _bundledTexts = <String>{};
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      final assets = manifest.listAssets();
      const prefix = 'assets/audio/ko/';
      const suffix = '.mp3';
      for (final asset in assets) {
        if (asset.startsWith(prefix) && asset.endsWith(suffix)) {
          final text = Uri.decodeFull(
            asset.substring(prefix.length, asset.length - suffix.length),
          );
          _bundledTexts!.add(text);
        }
      }
    } catch (_) {
      // Asset manifest not available.
    }
    return _bundledTexts!;
  }

  /// Check if bundled audio exists for [text].
  static Future<bool> hasAudio(String text) async {
    final bundled = await _getBundledTexts();
    return bundled.contains(text);
  }

  /// Play Korean text from bundled audio asset.
  /// [text] - Korean text to pronounce
  /// [speed] - playback speed multiplier (default 1.0)
  static Future<void> playKoreanText(
    String text, {
    double speed = 1.0,
  }) async {
    final player = _getPlayer();
    await player.stop();
    await player.setAsset('assets/audio/ko/$text.mp3');
    await player.setSpeed(speed > 0 ? speed : 1.0);
    await player.play();
    // Wait for playback to finish
    await player.playerStateStream.firstWhere(
      (state) => state.processingState == ProcessingState.completed,
    );
  }

  /// Dispose resources when no longer needed.
  static Future<void> dispose() async {
    await _player?.dispose();
    _player = null;
    _bundledTexts = null;
  }
}
