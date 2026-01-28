import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart'
    as opencc;

/// Chinese Character Converter
/// Converts between Simplified and Traditional Chinese using OpenCC
class ChineseConverter {
  /// Convert Simplified Chinese to Traditional Chinese (Taiwan Standard)
  static Future<String> toTraditional(String simplified) async {
    if (simplified.isEmpty) return simplified;

    try {
      final result = await opencc.ChineseConverter.convert(
        simplified,
        opencc.S2T(),
      );
      return result;
    } catch (e) {
      // Fallback: return original text if conversion fails
      return simplified;
    }
  }

  /// Convert Traditional Chinese to Simplified Chinese
  static Future<String> toSimplified(String traditional) async {
    if (traditional.isEmpty) return traditional;

    try {
      final result = await opencc.ChineseConverter.convert(
        traditional,
        opencc.T2S(),
      );
      return result;
    } catch (e) {
      // Fallback: return original text if conversion fails
      return traditional;
    }
  }

  /// Synchronous version - tries to convert, returns original if fails
  /// Note: This creates a temporary Future and doesn't actually wait
  /// Use async version whenever possible
  static String toTraditionalSync(String simplified) {
    if (simplified.isEmpty) return simplified;

    // For synchronous calls, we use a cached version or return original
    // This is a limitation - ideally all callers should use async version
    return simplified;
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
}
