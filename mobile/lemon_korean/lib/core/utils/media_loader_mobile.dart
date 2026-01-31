import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../constants/api_constants.dart';
import '../storage/database_helper.dart';

/// Media Loader Utility
/// Handles loading images and audio from local storage or remote URLs
class MediaLoader {
  /// Get image path (local if downloaded, otherwise remote URL)
  static Future<String> getImagePath(String remoteKey) async {
    try {
      // 1. Try to get local path from database
      final localPath = await DatabaseHelper.instance.getLocalPath(remoteKey);

      if (localPath != null) {
        // 2. Verify file exists
        final file = File(localPath);
        if (await file.exists()) {
          return localPath;
        }
      }

      // 3. Return remote URL if not available locally
      return _getRemoteImageUrl(remoteKey);
    } catch (e) {
      // Fallback to remote URL on error
      return _getRemoteImageUrl(remoteKey);
    }
  }

  /// Get audio path (local if downloaded, otherwise remote URL)
  static Future<String> getAudioPath(String remoteKey) async {
    try {
      // 1. Try to get local path from database
      final localPath = await DatabaseHelper.instance.getLocalPath(remoteKey);

      if (localPath != null) {
        // 2. Verify file exists
        final file = File(localPath);
        if (await file.exists()) {
          return localPath;
        }
      }

      // 3. Return remote URL if not available locally
      return _getRemoteAudioUrl(remoteKey);
    } catch (e) {
      // Fallback to remote URL on error
      return _getRemoteAudioUrl(remoteKey);
    }
  }

  /// Check if media is available locally
  static Future<bool> isMediaAvailableLocally(String remoteKey) async {
    try {
      final localPath = await DatabaseHelper.instance.getLocalPath(remoteKey);
      if (localPath == null) return false;

      final file = File(localPath);
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get local media directory
  static Future<Directory> getMediaDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${appDir.path}/media');

    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    return mediaDir;
  }

  /// Get local images directory
  static Future<Directory> getImagesDirectory() async {
    final mediaDir = await getMediaDirectory();
    final imagesDir = Directory('${mediaDir.path}/images');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    return imagesDir;
  }

  /// Get local audio directory
  static Future<Directory> getAudioDirectory() async {
    final mediaDir = await getMediaDirectory();
    final audioDir = Directory('${mediaDir.path}/audio');

    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }

    return audioDir;
  }

  /// Save image to local storage
  static Future<String> saveImage(
    String remoteKey,
    List<int> bytes, {
    int? lessonId,
  }) async {
    final imagesDir = await getImagesDirectory();
    final fileName = remoteKey.replaceAll('/', '_');
    final file = File('${imagesDir.path}/$fileName');

    await file.writeAsBytes(bytes);

    // Save mapping to database
    await DatabaseHelper.instance.insertMediaFile({
      'remote_key': remoteKey,
      'local_path': file.path,
      'file_type': 'image',
      'file_size': bytes.length,
      'lesson_id': lessonId,
      'downloaded_at': DateTime.now().millisecondsSinceEpoch,
      'last_accessed': DateTime.now().millisecondsSinceEpoch,
    });

    return file.path;
  }

  /// Save audio to local storage
  static Future<String> saveAudio(
    String remoteKey,
    List<int> bytes, {
    int? lessonId,
  }) async {
    final audioDir = await getAudioDirectory();
    final fileName = remoteKey.replaceAll('/', '_');
    final file = File('${audioDir.path}/$fileName');

    await file.writeAsBytes(bytes);

    // Save mapping to database
    await DatabaseHelper.instance.insertMediaFile({
      'remote_key': remoteKey,
      'local_path': file.path,
      'file_type': 'audio',
      'file_size': bytes.length,
      'lesson_id': lessonId,
      'downloaded_at': DateTime.now().millisecondsSinceEpoch,
      'last_accessed': DateTime.now().millisecondsSinceEpoch,
    });

    return file.path;
  }

  /// Delete local media file
  static Future<void> deleteMedia(String remoteKey) async {
    try {
      await DatabaseHelper.instance.deleteMediaFile(remoteKey);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Get total media storage size in bytes
  static Future<int> getMediaStorageSize() async {
    try {
      final mediaDir = await getMediaDirectory();
      int totalSize = 0;

      await for (final entity in mediaDir.list(recursive: true)) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  /// Clear all media cache
  static Future<void> clearMediaCache() async {
    try {
      final mediaDir = await getMediaDirectory();
      if (await mediaDir.exists()) {
        await mediaDir.delete(recursive: true);
      }
      await DatabaseHelper.instance.clearAll();
    } catch (e) {
      // Ignore errors
    }
  }

  // Private helper methods

  static String _getRemoteImageUrl(String remoteKey) {
    return '${ApiConstants.baseUrl}/media/images/$remoteKey';
  }

  static String _getRemoteAudioUrl(String remoteKey) {
    return '${ApiConstants.baseUrl}/media/audio/$remoteKey';
  }
}
