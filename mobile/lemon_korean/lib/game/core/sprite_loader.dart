import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';

import '../../core/constants/api_constants.dart';
import '../../data/models/character_item_model.dart';
import 'game_constants.dart';
import 'palette_swap.dart';

/// Handles loading, caching, and compositing character spritesheets.
class SpriteLoader {
  static final _imageCache = Images(prefix: '');
  static final Map<String, ui.Image> _networkImageCache = {};
  static final _dio = Dio();

  /// Load a spritesheet image from asset key or spritesheet_key metadata.
  ///
  /// Priority: `item.spritesheetKey` (from metadata) > `item.assetKey`.
  /// For bundled assets, loads from `assets/sprites/...` via Flame.
  /// For server assets, loads from network via media service.
  static Future<ui.Image> loadSpritesheetImage(CharacterItemModel item) async {
    final key = item.spritesheetKey ?? item.assetKey;

    // Bundled asset → Flame's asset loader (determine by path, not isBundled flag,
    // because admin may upload a custom image that replaces the spritesheet_key)
    if (key.startsWith('assets/')) {
      return _imageCache.load(key);
    }

    // Network asset → fetch from media service
    if (_networkImageCache.containsKey(key)) {
      return _networkImageCache[key]!;
    }

    final url = '${ApiConstants.mediaBaseUrl}/$key';
    final response = await _dio.get<List<int>>(
      url,
      options: Options(responseType: ResponseType.bytes),
    );
    final image = await _decodeImage(Uint8List.fromList(response.data!));
    _networkImageCache[key] = image;
    return image;
  }

  /// Decode raw bytes into a dart:ui Image.
  static Future<ui.Image> _decodeImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, completer.complete);
    return completer.future;
  }

  /// Load a spritesheet image and apply palette swap for body items.
  static Future<ui.Image> loadWithPaletteSwap(
    CharacterItemModel item,
    String skinColor,
  ) async {
    final image = await loadSpritesheetImage(item);

    if (item.category == 'body') {
      return PaletteSwap.swapPalette(image, item.assetKey, skinColor);
    }

    return image;
  }

  /// Extract spritesheet metadata from item, with defaults for standard layout.
  ///
  /// For bundled assets (`assets/` prefix), always use [GameConstants] so that
  /// code-side resolution changes apply immediately without a DB update.
  /// For server-uploaded assets, use the metadata from the server.
  static SpritesheetMeta getMeta(CharacterItemModel item) {
    final key = item.spritesheetKey ?? item.assetKey;

    // Bundled assets: frame layout is defined by GameConstants
    if (key.startsWith('assets/')) {
      return const SpritesheetMeta(
        frameWidth: GameConstants.frameWidth,
        frameHeight: GameConstants.frameHeight,
        columns: GameConstants.columnsPerRow,
        rows: 4,
      );
    }

    // Server-uploaded assets: use metadata from server
    final meta = item.metadata;
    return SpritesheetMeta(
      frameWidth: (meta['frameWidth'] as num?)?.toDouble() ?? GameConstants.frameWidth,
      frameHeight: (meta['frameHeight'] as num?)?.toDouble() ?? GameConstants.frameHeight,
      columns: (meta['frameColumns'] as int?) ?? GameConstants.columnsPerRow,
      rows: (meta['frameRows'] as int?) ?? 4,
    );
  }

  /// Create a SpriteAnimation for a specific direction and state.
  static SpriteAnimation createDirectionAnimation({
    required ui.Image image,
    required SpritesheetMeta meta,
    required int row,
    required bool isWalking,
  }) {
    if (isWalking) {
      // Walk frames: columns 1..4 in the given row
      final sprites = <Sprite>[];
      for (int col = 1; col <= GameConstants.walkFrames; col++) {
        sprites.add(Sprite(
          image,
          srcPosition: Vector2(col * meta.frameWidth, row * meta.frameHeight),
          srcSize: Vector2(meta.frameWidth, meta.frameHeight),
        ));
      }
      return SpriteAnimation.spriteList(
        sprites,
        stepTime: GameConstants.walkStepTime,
        loop: true,
      );
    } else {
      // Idle: column 0
      return SpriteAnimation.spriteList(
        [
          Sprite(
            image,
            srcPosition: Vector2(0, row * meta.frameHeight),
            srcSize: Vector2(meta.frameWidth, meta.frameHeight),
          ),
        ],
        stepTime: 1.0, // doesn't matter for single frame
        loop: false,
      );
    }
  }

  /// Create a gesture animation from row 3.
  static SpriteAnimation? createGestureAnimation({
    required ui.Image image,
    required SpritesheetMeta meta,
    required String gesture,
  }) {
    int start;
    int count;
    double stepTime;

    switch (gesture) {
      case 'jump':
        start = GameConstants.gestureJumpStart;
        count = GameConstants.gestureJumpFrames;
        stepTime = 0.6 / count;
      case 'wave':
        start = GameConstants.gestureWaveStart;
        count = GameConstants.gestureWaveFrames;
        stepTime = 0.8 / count;
      case 'bow':
        start = GameConstants.gestureBowStart;
        count = GameConstants.gestureBowFrames;
        stepTime = 1.0 / count;
      case 'dance':
        start = GameConstants.gestureDanceStart;
        count = GameConstants.gestureDanceFrames;
        stepTime = 3.0 / count;
      case 'clap':
        start = GameConstants.gestureClapStart;
        count = GameConstants.gestureClapFrames;
        stepTime = 0.8 / count;
      default:
        return null;
    }

    final sprites = <Sprite>[];
    for (int i = 0; i < count; i++) {
      sprites.add(Sprite(
        image,
        srcPosition: Vector2(
          (start + i) * meta.frameWidth,
          GameConstants.rowGestures * meta.frameHeight,
        ),
        srcSize: Vector2(meta.frameWidth, meta.frameHeight),
      ));
    }

    return SpriteAnimation.spriteList(sprites, stepTime: stepTime, loop: false);
  }

  /// Get the row index for a direction string.
  static int rowForDirection(String direction) {
    switch (direction) {
      case 'front':
        return GameConstants.rowFront;
      case 'back':
        return GameConstants.rowBack;
      case 'right':
      case 'left': // Left uses Right row + horizontal flip
        return GameConstants.rowRight;
      default:
        return GameConstants.rowFront;
    }
  }

  /// Pre-warm cache for a set of items.
  static Future<void> preloadItems(
    List<CharacterItemModel> items,
    String skinColor,
  ) async {
    await Future.wait(items.map((item) async {
      if (item.hasSpritesheet) {
        await loadWithPaletteSwap(item, skinColor);
      }
    }));
  }

  /// Clear all cached images.
  static void clearCache() {
    _imageCache.clearCache();
    _networkImageCache.clear();
    PaletteSwap.clearCache();
  }
}

/// Metadata about a spritesheet's layout.
class SpritesheetMeta {
  final double frameWidth;
  final double frameHeight;
  final int columns;
  final int rows;

  const SpritesheetMeta({
    required this.frameWidth,
    required this.frameHeight,
    required this.columns,
    required this.rows,
  });
}
