import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

/// Room wallpaper/background sprite that fills the game viewport.
class RoomBackground extends SpriteComponent with HasGameReference {
  final String? assetKey;

  /// Fallback gradient colors when no asset is available.
  static const _defaultTopColor = 0xFFD6EAF8;
  static const _defaultBottomColor = 0xFFEBF5FB;

  RoomBackground({this.assetKey});

  @override
  Future<void> onLoad() async {
    size = game.size;

    if (assetKey != null) {
      try {
        final image = await Flame.images.load(assetKey!);
        sprite = Sprite(image);
      } catch (_) {
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
    if (sprite != null) {
      super.render(canvas);
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
}
