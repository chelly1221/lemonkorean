/// Stub for DatabaseHelper (web build)
/// This file is imported when building for web to avoid importing sqflite
library;

import 'package:web/web.dart' as web;
import 'dart:convert';
import '../../../utils/app_logger.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  DatabaseHelper._internal();

  // ================================================================
  // MEDIA PATH LOOKUP
  // ================================================================

  Future<String?> getLocalPath(String remoteKey) async {
    // Stub - web doesn't have local files
    return null;
  }

  Future<void> updateMediaLastAccessed(
    String remoteKey,
    DateTime lastAccessed,
  ) async {
    // Stub - no-op on web
  }

  // ================================================================
  // MEDIA FILE MANAGEMENT
  // ================================================================

  /// Insert media file mapping (stores in localStorage on web)
  Future<void> insertMediaFile(Map<String, dynamic> data) async {
    try {
      final remoteKey = data['remote_key'] as String?;
      if (remoteKey != null) {
        // Store mapping in localStorage for reference
        web.window.localStorage['lk_media_$remoteKey'] = json.encode({
          'downloaded': true,
          'lesson_id': data['lesson_id'],
          'file_type': data['file_type'],
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
      }
    } catch (e) {
      AppLogger.e('Failed to insert media file', error: e, tag: 'DatabaseHelper');
    }
  }

  /// Delete media file mapping
  Future<void> deleteMediaFile(String remoteKey) async {
    try {
      web.window.localStorage.remove('lk_media_$remoteKey');
    } catch (e) {
      AppLogger.e('Failed to delete media file', error: e, tag: 'DatabaseHelper');
    }
  }

  /// Delete all media files for a lesson
  Future<void> deleteMediaFilesByLesson(int lessonId) async {
    try {
      final keysToRemove = <String>[];

      for (final key in web.window.localStorage.keys) {
        if (key.startsWith('lk_media_')) {
          try {
            final value = web.window.localStorage[key];
            if (value != null) {
              final data = json.decode(value) as Map<String, dynamic>;
              if (data['lesson_id'] == lessonId) {
                keysToRemove.add(key);
              }
            }
          } catch (e) {
            // Skip invalid entries
          }
        }
      }

      for (final key in keysToRemove) {
        web.window.localStorage.remove(key);
      }
    } catch (e) {
      AppLogger.e('Failed to delete media files by lesson', error: e, tag: 'DatabaseHelper');
    }
  }

  /// Get media file info
  Future<Map<String, dynamic>?> getMediaFile(String remoteKey) async {
    try {
      final value = web.window.localStorage['lk_media_$remoteKey'];
      if (value != null) {
        final data = json.decode(value) as Map<String, dynamic>;
        return {
          'remote_key': remoteKey,
          'local_path': '', // No local path on web
          'file_type': data['file_type'] ?? 'unknown',
          'file_size': 0,
          'lesson_id': data['lesson_id'],
          'downloaded_at': data['timestamp'] ?? 0,
          'last_accessed': data['timestamp'] ?? 0,
        };
      }
    } catch (e) {
      AppLogger.e('Failed to get media file', error: e, tag: 'DatabaseHelper');
    }
    return null;
  }

  /// Get all media files for a lesson
  Future<List<Map<String, dynamic>>> getMediaFilesByLesson(int lessonId) async {
    final results = <Map<String, dynamic>>[];

    try {
      for (final key in web.window.localStorage.keys) {
        if (key.startsWith('lk_media_')) {
          try {
            final value = web.window.localStorage[key];
            if (value != null) {
              final data = json.decode(value) as Map<String, dynamic>;
              if (data['lesson_id'] == lessonId) {
                final remoteKey = key.substring(9); // Remove 'lk_media_'
                results.add({
                  'remote_key': remoteKey,
                  'file_type': data['file_type'] ?? 'unknown',
                  'file_size': 0,
                  'lesson_id': lessonId,
                });
              }
            }
          } catch (e) {
            // Skip invalid entries
          }
        }
      }
    } catch (e) {
      AppLogger.e('Failed to get media files by lesson', error: e, tag: 'DatabaseHelper');
    }

    return results;
  }

  /// Get all media mappings
  Future<List<Map<String, dynamic>>> getAllMediaMappings() async {
    // Return empty list on web (no local files)
    return [];
  }

  /// Get total storage used by media files
  Future<int> getTotalStorageUsed() async {
    // Return 0 on web (browser manages cache)
    return 0;
  }

  /// Cleanup old files
  Future<void> cleanupOldFiles(int maxSizeBytes) async {
    // No-op on web (browser manages cache)
  }

  /// Clear all media data
  Future<void> clearAll() async {
    try {
      final keysToRemove = <String>[];

      for (final key in web.window.localStorage.keys) {
        if (key.startsWith('lk_media_')) {
          keysToRemove.add(key);
        }
      }

      for (final key in keysToRemove) {
        web.window.localStorage.remove(key);
      }
    } catch (e) {
      AppLogger.e('Failed to clear all', error: e, tag: 'DatabaseHelper');
    }
  }
}
