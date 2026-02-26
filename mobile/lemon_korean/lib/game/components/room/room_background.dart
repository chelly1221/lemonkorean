import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/foundation.dart';

/// Room wallpaper/background sprite that fills the game viewport.
class RoomBackground extends PositionComponent with HasGameReference {
  final String? assetKey;
  Sprite? _sprite;

  /// Fallback gradient colors when no asset is available.
  static const _defaultTopColor = 0xFFD6EAF8;
  static const _defaultBottomColor = 0xFFEBF5FB;

  RoomBackground({this.assetKey});

  @override
  Future<void> onLoad() async {
    size = game.size;
    position = Vector2.zero();

    if (assetKey != null) {
      if (!_isSupportedRaster(assetKey!)) {
        debugPrint('[RoomBackground] Skip unsupported asset: $assetKey');
        return;
      }
      try {
        final image = await Flame.images.load(assetKey!);
        _sprite = Sprite(image);
      } catch (e) {
        debugPrint('[RoomBackground] Failed to load $assetKey: $e');
        // Fallback: no sprite, render gradient in render()
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(ui.Canvas canvas) {
    if (_sprite != null) {
      _sprite!.render(canvas, size: size);
    } else {
      // Default gradient background
      final rect = size.toRect();
      final paint = ui.Paint()
        ..shader = ui.Gradient.linear(
          const ui.Offset(0, 0),
          ui.Offset(0, size.y * 0.65),
          [const ui.Color(_defaultTopColor), const ui.Color(_defaultBottomColor)],
        );
      canvas.drawRect(rect, paint);
    }
  }

  bool _isSupportedRaster(String key) {
    final lower = key.toLowerCase();
    return lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.bmp');
  }
}
