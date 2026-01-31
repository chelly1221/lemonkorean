import 'package:flutter/material.dart';

/// Platform-agnostic media loader interface
/// Mobile: Loads from local files if available, otherwise remote
/// Web: Always streams from remote server
abstract class IMediaLoader {
  /// Get media path (local file path on mobile, remote URL on web)
  Future<String> getMediaPath(String remoteKey);

  /// Load an image widget
  Widget loadImage(String url, {BoxFit fit = BoxFit.cover});

  /// Play audio from URL
  Future<void> playAudio(String url);

  /// Stop audio playback
  Future<void> stopAudio();

  /// Dispose resources
  Future<void> dispose();
}
