/// Storage Utilities - Web Stub
/// Web platform: localStorage capacity estimation

import 'dart:html' as html;

/// Storage Utilities - Web Implementation
/// Estimates browser localStorage capacity and usage
class StorageUtils {
  /// Get available storage space (estimated for web)
  static Future<int> getAvailableStorageBytes() async {
    // Most browsers have 5-10MB localStorage limit
    // Return conservative estimate
    return 50 * 1024 * 1024; // 50MB
  }

  /// Get total storage space (estimated for web)
  static Future<int> getTotalStorageBytes() async {
    // Browser localStorage typical limit
    return 10 * 1024 * 1024; // 10MB
  }

  /// Get used storage by app (from localStorage)
  static int getUsedStorageBytes(int mediaBytes, int hiveBytes) {
    int total = 0;

    try {
      // Calculate localStorage usage for lk_* keys
      final storage = html.window.localStorage;
      final keys = storage.keys.where((key) => key.startsWith('lk_'));

      for (final key in keys) {
        final value = storage[key] ?? '';
        // UTF-16 encoding: 2 bytes per character
        total += ((key.length + value.length) * 2) as int;
      }
    } catch (e) {
      print('[StorageUtils] Error calculating localStorage usage: $e');
      return 0;
    }

    return total;
  }

  /// Format bytes to MB string
  static String formatMB(int bytes) {
    return (bytes / (1024 * 1024)).toStringAsFixed(1);
  }

  /// Format bytes to GB string
  static String formatGB(int bytes) {
    return (bytes / (1024 * 1024 * 1024)).toStringAsFixed(2);
  }

  /// Get localStorage usage breakdown (web-specific helper)
  static Map<String, int> getLocalStorageBreakdown() {
    final breakdown = <String, int>{};

    try {
      final storage = html.window.localStorage;
      final keys = storage.keys.where((key) => key.startsWith('lk_'));

      for (final key in keys) {
        final value = storage[key] ?? '';
        final size = ((key.length + value.length) * 2) as int;

        // Group by prefix
        final prefix = key.split('_').take(2).join('_');
        breakdown[prefix] = ((breakdown[prefix] ?? 0) + size) as int;
      }
    } catch (e) {
      print('[StorageUtils] Error getting localStorage breakdown: $e');
    }

    return breakdown;
  }
}
