import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

/// Storage Utilities
/// Get actual device storage information
class StorageUtils {
  /// Get available storage space in bytes
  static Future<int> getAvailableStorageBytes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      if (Platform.isAndroid || Platform.isLinux) {
        // Android/Linux: df 명령어 사용
        final result = await Process.run('df', [directory.path]);
        final lines = result.stdout.toString().split('\n');

        if (lines.length >= 2) {
          // df 출력 파싱
          // Filesystem     1K-blocks    Used Available Use% Mounted on
          // /dev/sda1      102400000 5000000  97400000   5% /data
          final parts = lines[1].split(RegExp(r'\s+'));

          if (parts.length >= 4) {
            // parts[3]는 Available (KB 단위)
            final availableKB = int.tryParse(parts[3]);
            if (availableKB != null) {
              final bytes = availableKB * 1024; // KB to bytes
              if (kDebugMode) {
                print('[StorageUtils] Available: ${formatMB(bytes)} MB');
              }
              return bytes;
            }
          }
        }
      }

      // 폴백: 대략적인 기본값
      if (kDebugMode) {
        print('[StorageUtils] Failed to get available storage, using default');
      }
      return 1024 * 1024 * 1024; // 1GB 기본값
    } catch (e) {
      if (kDebugMode) {
        print('[StorageUtils] Error getting available storage: $e');
      }
      return 1024 * 1024 * 1024; // 1GB 폴백
    }
  }

  /// Get total storage space in bytes (approximate)
  static Future<int> getTotalStorageBytes() async {
    try {
      final directory = await getApplicationDocumentsDirectory();

      if (Platform.isAndroid || Platform.isLinux) {
        final result = await Process.run('df', [directory.path]);
        final lines = result.stdout.toString().split('\n');

        if (lines.length >= 2) {
          final parts = lines[1].split(RegExp(r'\s+'));

          if (parts.length >= 2) {
            // parts[1]는 1K-blocks (전체 크기, KB 단위)
            final totalKB = int.tryParse(parts[1]);
            if (totalKB != null) {
              final bytes = totalKB * 1024; // KB to bytes
              if (kDebugMode) {
                print('[StorageUtils] Total: ${formatMB(bytes)} MB');
              }
              return bytes;
            }
          }
        }
      }

      // 폴백: 기본값
      if (kDebugMode) {
        print('[StorageUtils] Failed to get total storage, using default');
      }
      return 2 * 1024 * 1024 * 1024; // 2GB 기본값
    } catch (e) {
      if (kDebugMode) {
        print('[StorageUtils] Error getting total storage: $e');
      }
      return 2 * 1024 * 1024 * 1024; // 2GB 폴백
    }
  }

  /// Get used storage by app (from StorageStats)
  static int getUsedStorageBytes(int mediaBytes, int hiveBytes) {
    return mediaBytes + hiveBytes;
  }

  /// Format bytes to MB string
  static String formatMB(int bytes) {
    return (bytes / (1024 * 1024)).toStringAsFixed(1);
  }

  /// Format bytes to GB string
  static String formatGB(int bytes) {
    return (bytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
  }
}
