/// Media Loader - Web Stub
/// Web platform doesn't have file system - all media served from CDN
library;

/// Media Loader Utility - Web Implementation
/// All media is loaded directly from CDN URLs (no local storage)
class MediaLoader {
  /// Get image path (always returns CDN URL on web)
  static Future<String> getImagePath(String remoteKey) async {
    return _getRemoteImageUrl(remoteKey);
  }

  /// Get audio path (always returns CDN URL on web)
  static Future<String> getAudioPath(String remoteKey) async {
    return _getRemoteAudioUrl(remoteKey);
  }

  /// Check if media is available locally (always false on web)
  static Future<bool> isMediaAvailableLocally(String remoteKey) async {
    return false;
  }

  /// Get local media directory (throws on web)
  static Future<void> getMediaDirectory() async {
    throw UnsupportedError('File system not available on web');
  }

  /// Get local images directory (throws on web)
  static Future<void> getImagesDirectory() async {
    throw UnsupportedError('File system not available on web');
  }

  /// Get local audio directory (throws on web)
  static Future<void> getAudioDirectory() async {
    throw UnsupportedError('File system not available on web');
  }

  /// Save image (no-op on web, browser handles caching)
  static Future<String> saveImage(
    String remoteKey,
    List<int> bytes, {
    int? lessonId,
  }) async {
    // No-op: browser automatically caches images
    return _getRemoteImageUrl(remoteKey);
  }

  /// Save audio (no-op on web, browser handles caching)
  static Future<String> saveAudio(
    String remoteKey,
    List<int> bytes, {
    int? lessonId,
  }) async {
    // No-op: browser automatically caches audio
    return _getRemoteAudioUrl(remoteKey);
  }

  /// Delete local media file (no-op on web)
  static Future<void> deleteMedia(String remoteKey) async {
    // No-op
  }

  /// Get total media storage size (returns 0 on web)
  static Future<int> getMediaStorageSize() async {
    return 0;
  }

  /// Clear all media cache (no-op on web)
  static Future<void> clearMediaCache() async {
    // No-op: browser manages cache
  }

  // Private helper methods

  static String _getRemoteImageUrl(String remoteKey) {
    // Use production URL for web
    const baseUrl = 'https://lemon.3chan.kr';
    return '$baseUrl/media/images/$remoteKey';
  }

  static String _getRemoteAudioUrl(String remoteKey) {
    // Use production URL for web
    const baseUrl = 'https://lemon.3chan.kr';
    return '$baseUrl/media/audio/$remoteKey';
  }
}
