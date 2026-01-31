/// Media Helper - Web Stub
/// Web platform: all media served from CDN, no local files

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Media Helper - Web Implementation
/// All media loaded from CDN (no local file support)
class MediaHelper {
  // ================================================================
  // MEDIA URL RESOLUTION
  // ================================================================

  /// Get media URL (always CDN URL on web)
  static Future<String> getMediaUrl(String remoteKey) async {
    return _buildRemoteUrl(remoteKey);
  }

  /// Build remote URL from media key
  static String _buildRemoteUrl(String remoteKey) {
    // Check if already a full URL
    if (remoteKey.startsWith('http://') || remoteKey.startsWith('https://')) {
      return remoteKey;
    }

    // Build URL based on media type
    final type = _getMediaType(remoteKey);
    const baseUrl = 'https://3chan.kr';
    return '$baseUrl/media/$type/$remoteKey';
  }

  /// Get media type from file extension
  static String _getMediaType(String fileName) {
    if (fileName.contains('images/') || _isImage(fileName)) {
      return 'images';
    } else if (fileName.contains('audio/') || _isAudio(fileName)) {
      return 'audio';
    } else if (fileName.contains('video/') || _isVideo(fileName)) {
      return 'video';
    }
    return 'images'; // default
  }

  /// Check if file is an image
  static bool _isImage(String fileName) {
    final ext = fileName.toLowerCase();
    return ext.endsWith('.jpg') ||
        ext.endsWith('.jpeg') ||
        ext.endsWith('.png') ||
        ext.endsWith('.gif') ||
        ext.endsWith('.webp');
  }

  /// Check if file is audio
  static bool _isAudio(String fileName) {
    final ext = fileName.toLowerCase();
    return ext.endsWith('.mp3') ||
        ext.endsWith('.wav') ||
        ext.endsWith('.ogg') ||
        ext.endsWith('.m4a');
  }

  /// Check if file is video
  static bool _isVideo(String fileName) {
    final ext = fileName.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.webm') ||
        ext.endsWith('.mov');
  }

  // ================================================================
  // WIDGET BUILDERS
  // ================================================================

  /// Build image widget (CDN only on web)
  static Widget buildImage(
    String remoteKey, {
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return FutureBuilder<String>(
      future: getMediaUrl(remoteKey),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return placeholder ??
              const Center(child: CircularProgressIndicator());
        }

        final imageUrl = snapshot.data!;

        // Always use cached network image on web
        return CachedNetworkImage(
          imageUrl: imageUrl,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          placeholder: (context, url) =>
              placeholder ?? const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              errorWidget ?? _buildErrorWidget(),
        );
      },
    );
  }

  /// Build thumbnail widget
  static Widget buildThumbnail(
    String remoteKey, {
    double size = 100,
    BoxFit? fit,
  }) {
    return buildImage(
      remoteKey,
      width: size,
      height: size,
      fit: fit ?? BoxFit.cover,
    );
  }

  /// Build error widget
  static Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey,
          size: 48,
        ),
      ),
    );
  }

  // ================================================================
  // MEDIA INFO
  // ================================================================

  /// Check if media is available locally (always false on web)
  static Future<bool> isMediaAvailableLocally(String remoteKey) async {
    return false;
  }

  /// Get media file info (returns null on web)
  static Future<MediaInfo?> getMediaInfo(String remoteKey) async {
    return null;
  }

  /// Get total media size for lesson (returns 0 on web)
  static Future<int> getLessonMediaSize(int lessonId) async {
    return 0;
  }

  // ================================================================
  // CACHE MANAGEMENT
  // ================================================================

  /// Delete media cache for lesson (no-op on web)
  static Future<void> deleteLessonMedia(int lessonId) async {
    // No-op: browser manages cache
  }

  /// Get total cache size (returns 0 on web)
  static Future<int> getTotalCacheSize() async {
    return 0;
  }

  /// Clear old cache (no-op on web)
  static Future<void> clearOldCache({int maxSizeBytes = 0}) async {
    // No-op: browser manages cache
  }

  // ================================================================
  // FORMAT HELPERS
  // ================================================================

  /// Format file size for display
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Format duration for display
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
  }
}

// ================================================================
// MODELS
// ================================================================

/// Media info model
class MediaInfo {
  final String remoteKey;
  final String localPath;
  final String fileType;
  final int fileSize;
  final DateTime downloadedAt;

  MediaInfo({
    required this.remoteKey,
    required this.localPath,
    required this.fileType,
    required this.fileSize,
    required this.downloadedAt,
  });

  String get formattedSize => MediaHelper.formatFileSize(fileSize);

  bool get isImage => fileType == 'image';
  bool get isAudio => fileType == 'audio';
  bool get isVideo => fileType == 'video';
}
