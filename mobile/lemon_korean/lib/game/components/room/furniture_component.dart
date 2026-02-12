import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';

import '../../core/game_bridge.dart';

/// A tappable furniture item placed in the room.
class FurnitureComponent extends SpriteComponent with TapCallbacks, HasGameReference {
  final int furnitureId;
  final String? assetKey;
  final String? interactionType; // 'mini_game', 'animation', null
  final GameBridge? bridge;

  FurnitureComponent({
    required this.furnitureId,
    required Vector2 position,
    this.assetKey,
    this.interactionType,
    this.bridge,
    Vector2? size,
  }) : super(
    position: position,
    size: size ?? Vector2(60, 60),
  );

  @override
  Future<void> onLoad() async {
    if (assetKey != null) {
      try {
        final image = await Flame.images.load(assetKey!);
        sprite = Sprite(image);
      } catch (_) {
        // No sprite available, render placeholder
      }
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (bridge == null) return;

    if (interactionType == 'mini_game') {
      bridge!.sendToFlutter(MiniGameRequested(gameType: 'korean_quiz'));
    } else {
      bridge!.sendToFlutter(FurnitureTapped(
        furnitureId: furnitureId,
        action: interactionType,
      ));
    }
  }

  @override
  void render(ui.Canvas canvas) {
    if (sprite != null) {
      super.render(canvas);
    } else {
      // Placeholder rectangle
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(
          size.toRect(),
          const ui.Radius.circular(4),
        ),
        ui.Paint()..color = const ui.Color(0x30795548),
      );
    }
  }
}
