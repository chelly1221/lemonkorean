import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../../core/game_constants.dart';

/// Subtle color overlay based on device local time.
///
/// Dawn/dusk get warm tint, night gets blue tint, day is transparent.
class DayNightOverlay extends PositionComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    size = game.size;
    priority = 1000; // Render on top of everything
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(ui.Canvas canvas) {
    final hour = DateTime.now().hour;
    final color = _getOverlayColor(hour);

    if (color != null) {
      canvas.drawRect(
        size.toRect(),
        ui.Paint()..color = color,
      );
    }
  }

  ui.Color? _getOverlayColor(int hour) {
    const maxAlpha = GameConstants.dayNightMaxAlpha;

    if (hour >= 6 && hour < 8) {
      // Dawn: warm orange tint
      final t = (hour - 6 + DateTime.now().minute / 60) / 2;
      final alpha = maxAlpha * (1.0 - t);
      return ui.Color.fromRGBO(255, 180, 80, alpha);
    } else if (hour >= 8 && hour < 17) {
      // Day: no overlay
      return null;
    } else if (hour >= 17 && hour < 19) {
      // Dusk: warm orange tint
      final t = (hour - 17 + DateTime.now().minute / 60) / 2;
      final alpha = maxAlpha * t;
      return ui.Color.fromRGBO(255, 140, 50, alpha);
    } else if (hour >= 19 && hour < 21) {
      // Evening: transition to blue
      final t = (hour - 19 + DateTime.now().minute / 60) / 2;
      final alpha = maxAlpha * t;
      return ui.Color.fromRGBO(30, 30, 80, alpha);
    } else {
      // Night: blue tint
      return const ui.Color.fromRGBO(20, 20, 60, maxAlpha);
    }
  }
}
