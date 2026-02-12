import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/flame.dart';

import '../../core/game_constants.dart';

/// Walkable floor area in the room (bottom 35%).
///
/// Handles both pixel art floor tiles and solid color fallback.
class FloorComponent extends PositionComponent with HasGameReference {
  final String? assetKey;

  static const _defaultFloorColor = 0xFFDEB887;

  FloorComponent({this.assetKey});

  Sprite? _floorSprite;

  @override
  Future<void> onLoad() async {
    final gameSize = game.size;
    final floorHeight = gameSize.y * 0.35;

    position = Vector2(0, gameSize.y - floorHeight);
    size = Vector2(gameSize.x, floorHeight);

    if (assetKey != null) {
      try {
        final image = await Flame.images.load(assetKey!);
        _floorSprite = Sprite(image);
      } catch (_) {
        // Use fallback color
      }
    }
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    final floorHeight = size.y * 0.35;
    position = Vector2(0, size.y - floorHeight);
    this.size = Vector2(size.x, floorHeight);
  }

  @override
  void render(ui.Canvas canvas) {
    if (_floorSprite != null) {
      _floorSprite!.render(canvas, size: size);
    } else {
      canvas.drawRect(
        size.toRect(),
        ui.Paint()..color = const ui.Color(_defaultFloorColor),
      );
    }
  }

  /// Check if a world position is within the walkable floor area.
  bool isWalkable(Vector2 worldPos) {
    final gameSize = game.size;
    final normalizedY = worldPos.y / gameSize.y;
    return normalizedY >= GameConstants.floorTopFraction &&
        normalizedY <= GameConstants.floorBottomFraction;
  }

  /// Clamp a world position to the walkable floor bounds.
  Vector2 clampToFloor(Vector2 worldPos) {
    final gameSize = game.size;
    const halfCharW = GameConstants.displayWidth / 2;

    return Vector2(
      worldPos.x.clamp(halfCharW, gameSize.x - halfCharW),
      worldPos.y.clamp(
        gameSize.y * GameConstants.floorTopFraction,
        gameSize.y * GameConstants.floorBottomFraction,
      ),
    );
  }
}
