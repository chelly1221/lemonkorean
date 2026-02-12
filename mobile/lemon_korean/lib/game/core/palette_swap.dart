import 'dart:ui' as ui;
import 'dart:typed_data';

/// Skin color palette definitions for pixel art characters.
///
/// Each palette has 4 shades: highlight, base, shadow, dark.
/// The reference palette (in the source spritesheet) uses fixed colors
/// that get remapped to the target palette at runtime.
class SkinPalette {
  final int highlight;
  final int base;
  final int shadow;
  final int dark;

  const SkinPalette({
    required this.highlight,
    required this.base,
    required this.shadow,
    required this.dark,
  });
}

class PaletteSwap {
  /// Reference colors used in source body spritesheets.
  /// Artists paint body sprites using ONLY these 4 colors.
  static const referencePalette = SkinPalette(
    highlight: 0xFFFFF0DB, // lightest
    base:      0xFFFFDBAC, // main skin tone
    shadow:    0xFFD4A574, // shadow
    dark:      0xFFA67C52, // darkest
  );

  /// Available skin palettes indexed by hex code.
  /// The hex code matches the `skinColor` field in UserCharacterModel.
  static const Map<String, SkinPalette> palettes = {
    '#FFDBB4': SkinPalette( // Light (default)
      highlight: 0xFFFFF0DB,
      base:      0xFFFFDBB4,
      shadow:    0xFFD4A574,
      dark:      0xFFA67C52,
    ),
    '#F5C08A': SkinPalette( // Medium light
      highlight: 0xFFFDE0B5,
      base:      0xFFF5C08A,
      shadow:    0xFFCB9A5E,
      dark:      0xFF9A7041,
    ),
    '#C68642': SkinPalette( // Medium
      highlight: 0xFFE0A868,
      base:      0xFFC68642,
      shadow:    0xFF9A6530,
      dark:      0xFF6E4520,
    ),
    '#8D5524': SkinPalette( // Medium dark
      highlight: 0xFFBB7940,
      base:      0xFF8D5524,
      shadow:    0xFF6B3E18,
      dark:      0xFF4A2B10,
    ),
    '#5C3317': SkinPalette( // Dark
      highlight: 0xFF8A5530,
      base:      0xFF5C3317,
      shadow:    0xFF3E2210,
      dark:      0xFF28160A,
    ),
    '#3B1E0A': SkinPalette( // Very dark
      highlight: 0xFF6B3E1C,
      base:      0xFF3B1E0A,
      shadow:    0xFF281406,
      dark:      0xFF180C04,
    ),
  };

  /// Cache for swapped images: key = "assetKey_skinColor"
  static final Map<String, ui.Image> _cache = {};

  /// Get a cached swapped image, or null if not cached yet.
  static ui.Image? getCached(String assetKey, String skinColor) {
    return _cache['${assetKey}_$skinColor'];
  }

  /// Apply palette swap to an image and cache the result.
  ///
  /// Returns the swapped image. If the skin color matches the reference
  /// palette, returns the original image unmodified.
  static Future<ui.Image> swapPalette(
    ui.Image source,
    String assetKey,
    String skinColor,
  ) async {
    final cacheKey = '${assetKey}_$skinColor';
    if (_cache.containsKey(cacheKey)) return _cache[cacheKey]!;

    final targetPalette = palettes[skinColor];
    if (targetPalette == null) {
      // Unknown skin color, return original
      return source;
    }

    // If target matches reference, no swap needed
    if (targetPalette.base == referencePalette.base) {
      _cache[cacheKey] = source;
      return source;
    }

    // Read pixels
    final width = source.width;
    final height = source.height;
    final byteData = await source.toByteData(format: ui.ImageByteFormat.rawRgba);
    if (byteData == null) return source;

    final pixels = Uint8List.fromList(byteData.buffer.asUint8List());

    // Build color mapping: reference -> target
    final colorMap = {
      referencePalette.highlight: targetPalette.highlight,
      referencePalette.base: targetPalette.base,
      referencePalette.shadow: targetPalette.shadow,
      referencePalette.dark: targetPalette.dark,
    };

    // Remap pixels
    for (int i = 0; i < pixels.length; i += 4) {
      final r = pixels[i];
      final g = pixels[i + 1];
      final b = pixels[i + 2];
      final a = pixels[i + 3];

      if (a == 0) continue; // Skip fully transparent

      final sourceColor = (0xFF << 24) | (r << 16) | (g << 8) | b;
      final mapped = colorMap[sourceColor];
      if (mapped != null) {
        pixels[i]     = (mapped >> 16) & 0xFF; // R
        pixels[i + 1] = (mapped >> 8) & 0xFF;  // G
        pixels[i + 2] = mapped & 0xFF;          // B
        // Alpha unchanged
      }
    }

    // Create new image from modified pixels
    final completer = ui.ImmutableBuffer.fromUint8List(pixels);
    final buffer = await completer;
    final descriptor = ui.ImageDescriptor.raw(
      buffer,
      width: width,
      height: height,
      pixelFormat: ui.PixelFormat.rgba8888,
    );
    final codec = await descriptor.instantiateCodec();
    final frame = await codec.getNextFrame();
    final result = frame.image;

    codec.dispose();
    descriptor.dispose();
    buffer.dispose();

    _cache[cacheKey] = result;
    return result;
  }

  /// Clear all cached images.
  static void clearCache() {
    _cache.clear();
  }

  /// Clear cache entries for a specific skin color.
  static void clearCacheForSkin(String skinColor) {
    _cache.removeWhere((key, _) => key.endsWith('_$skinColor'));
  }
}
