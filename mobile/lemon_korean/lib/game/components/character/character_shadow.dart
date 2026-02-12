import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/game_constants.dart';

/// Drop shadow rendered under the character.
class CharacterShadow extends PositionComponent {
  CharacterShadow()
      : super(
          size: Vector2(GameConstants.displayWidth * 0.6, 8),
          anchor: Anchor.topCenter,
        );

  @override
  void render(ui.Canvas canvas) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final paint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.x / 2, size.y / 2),
        size.x / 2,
        [
          Colors.black.withValues(alpha: 0.25),
          Colors.transparent,
        ],
      );

    canvas.drawOval(rect, paint);
  }
}
