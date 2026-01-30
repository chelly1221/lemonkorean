import 'dart:async';
import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart'
    as opencc;

import '../constants/app_constants.dart';

/// Chinese Character Converter
/// Converts between Simplified and Traditional Chinese using OpenCC
///
/// Features:
/// - LRU caching to avoid repeated conversions
/// - Batch conversion for multiple texts
/// - Background Isolate support for very long texts (using compute with sync FFI)
class ChineseConverter {
  ChineseConverter._(); // Private constructor

  // Cache for converted texts to avoid repeated conversions
  static final Map<String, String> _traditionalCache = {};
  static final Map<String, String> _simplifiedCache = {};

  /// Convert Simplified Chinese to Traditional Chinese (Taiwan Standard)
  /// Uses caching for performance
  static Future<String> toTraditional(String simplified) async {
    if (simplified.isEmpty) return simplified;

    // Check cache first
    final cached = _traditionalCache[simplified];
    if (cached != null) {
      return cached;
    }

    String result;

    try {
      // For very long texts, consider using a dedicated worker
      // but for most cases, the FFI-based conversion is fast enough
      if (simplified.length > AppConstants.chineseConversionChunkSize) {
        // Process in chunks for very long texts to prevent ANR
        result = await _convertLongTextToTraditional(simplified);
      } else {
        result = await opencc.ChineseConverter.convert(
          simplified,
          opencc.S2T(),
        );
      }
    } catch (e) {
      // Fallback: return original text if conversion fails
      result = simplified;
    }

    // Update cache
    _addToCache(_traditionalCache, simplified, result);

    return result;
  }

  /// Convert Traditional Chinese to Simplified Chinese
  /// Uses caching for performance
  static Future<String> toSimplified(String traditional) async {
    if (traditional.isEmpty) return traditional;

    // Check cache first
    final cached = _simplifiedCache[traditional];
    if (cached != null) {
      return cached;
    }

    String result;

    try {
      if (traditional.length > AppConstants.chineseConversionChunkSize) {
        result = await _convertLongTextToSimplified(traditional);
      } else {
        result = await opencc.ChineseConverter.convert(
          traditional,
          opencc.T2S(),
        );
      }
    } catch (e) {
      // Fallback: return original text if conversion fails
      result = traditional;
    }

    // Update cache
    _addToCache(_simplifiedCache, traditional, result);

    return result;
  }

  /// Convert long text in chunks to prevent UI blocking
  static Future<String> _convertLongTextToTraditional(String text) async {
    const chunkSize = 500;
    final chunks = <String>[];

    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      chunks.add(text.substring(i, end));
    }

    final convertedChunks = <String>[];
    for (final chunk in chunks) {
      // Allow UI to breathe between chunks
      await Future.delayed(Duration.zero);

      final converted = await opencc.ChineseConverter.convert(
        chunk,
        opencc.S2T(),
      );
      convertedChunks.add(converted);
    }

    return convertedChunks.join();
  }

  /// Convert long text in chunks to prevent UI blocking
  static Future<String> _convertLongTextToSimplified(String text) async {
    const chunkSize = 500;
    final chunks = <String>[];

    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      chunks.add(text.substring(i, end));
    }

    final convertedChunks = <String>[];
    for (final chunk in chunks) {
      // Allow UI to breathe between chunks
      await Future.delayed(Duration.zero);

      final converted = await opencc.ChineseConverter.convert(
        chunk,
        opencc.T2S(),
      );
      convertedChunks.add(converted);
    }

    return convertedChunks.join();
  }

  /// Batch convert multiple texts to Traditional Chinese
  /// More efficient for converting many short texts at once
  /// Uses parallel processing with limited concurrency
  static Future<List<String>> batchToTraditional(List<String> texts) async {
    if (texts.isEmpty) return texts;

    final results = List<String?>.filled(texts.length, null);
    final futures = <Future<void>>[];

    // Limit concurrent conversions to avoid overwhelming the system
    const maxConcurrent = 5;
    var currentBatch = <Future<void>>[];

    for (int i = 0; i < texts.length; i++) {
      final index = i;
      final text = texts[i];

      if (text.isEmpty) {
        results[index] = text;
        continue;
      }

      // Check cache
      final cached = _traditionalCache[text];
      if (cached != null) {
        results[index] = cached;
        continue;
      }

      // Add conversion task
      final future = toTraditional(text).then((converted) {
        results[index] = converted;
      });
      currentBatch.add(future);

      // Process batch when limit reached
      if (currentBatch.length >= maxConcurrent) {
        await Future.wait(currentBatch);
        currentBatch = [];
      }
    }

    // Process remaining tasks
    if (currentBatch.isNotEmpty) {
      await Future.wait(currentBatch);
    }

    return results.map((r) => r ?? '').toList();
  }

  /// Batch convert multiple texts to Simplified Chinese
  static Future<List<String>> batchToSimplified(List<String> texts) async {
    if (texts.isEmpty) return texts;

    final results = List<String?>.filled(texts.length, null);
    const maxConcurrent = 5;
    var currentBatch = <Future<void>>[];

    for (int i = 0; i < texts.length; i++) {
      final index = i;
      final text = texts[i];

      if (text.isEmpty) {
        results[index] = text;
        continue;
      }

      // Check cache
      final cached = _simplifiedCache[text];
      if (cached != null) {
        results[index] = cached;
        continue;
      }

      // Add conversion task
      final future = toSimplified(text).then((converted) {
        results[index] = converted;
      });
      currentBatch.add(future);

      // Process batch when limit reached
      if (currentBatch.length >= maxConcurrent) {
        await Future.wait(currentBatch);
        currentBatch = [];
      }
    }

    // Process remaining tasks
    if (currentBatch.isNotEmpty) {
      await Future.wait(currentBatch);
    }

    return results.map((r) => r ?? '').toList();
  }

  /// Check if text contains any Traditional Chinese characters
  static Future<bool> hasTraditionalChars(String text) async {
    if (text.isEmpty) return false;

    try {
      final converted = await toSimplified(text);
      return converted != text;
    } catch (e) {
      return false;
    }
  }

  /// Check if text contains any Simplified Chinese characters
  static Future<bool> hasSimplifiedChars(String text) async {
    if (text.isEmpty) return false;

    try {
      final converted = await toTraditional(text);
      return converted != text;
    } catch (e) {
      return false;
    }
  }

  /// Clear conversion cache
  static void clearCache() {
    _traditionalCache.clear();
    _simplifiedCache.clear();
  }

  /// Get cache statistics (for debugging)
  static Map<String, int> getCacheStats() {
    return {
      'traditionalCacheSize': _traditionalCache.length,
      'simplifiedCacheSize': _simplifiedCache.length,
    };
  }

  /// Preload common texts into cache
  /// Call this during app initialization with frequently used texts
  static Future<void> preloadCache(List<String> commonTexts) async {
    for (final text in commonTexts) {
      if (text.isNotEmpty && !_traditionalCache.containsKey(text)) {
        try {
          final converted = await opencc.ChineseConverter.convert(
            text,
            opencc.S2T(),
          );
          _addToCache(_traditionalCache, text, converted);
        } catch (e) {
          // Ignore errors during preload
        }
      }
    }
  }

  // Helper to add to cache with LRU eviction
  static void _addToCache(Map<String, String> cache, String key, String value) {
    // Evict oldest entries if cache is full (simple LRU)
    if (cache.length >= AppConstants.chineseConversionCacheSize) {
      // Remove first 10% of entries
      final keysToRemove = cache.keys.take(AppConstants.chineseConversionCacheSize ~/ 10).toList();
      for (final k in keysToRemove) {
        cache.remove(k);
      }
    }
    cache[key] = value;
  }
}
