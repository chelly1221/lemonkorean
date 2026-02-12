import 'dart:math';
import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../../core/game_constants.dart';

/// Pulsing green glow around unmuted speakers on the voice stage.
class SpeakingAura extends PositionComponent {
  bool isMuted;
  double _timer = 0;

  SpeakingAura({this.isMuted = false})
      : super(
          size: Vector2(
            GameConstants.displayWidth + 16,
            GameConstants.displayHeight + 16,
          ),
          anchor: Anchor.center,
        );

  @override
  void update(double dt) {
    super.update(dt);
    if (!isMuted) {
      _timer += dt * GameConstants.speakingAuraPulseSpeed;
    }
  }

  @override
  void render(ui.Canvas canvas) {
    if (isMuted) return;

    final pulseT = (sin(_timer * 2 * pi) + 1) / 2; // 0..1 oscillation
    final alpha = 0.1 + pulseT * 0.15;
    final spread = 4.0 + pulseT * 6.0;

    final center = ui.Offset(size.x / 2, size.y / 2);
    final radius = size.x / 2 + spread;

    canvas.drawCircle(
      center,
      radius,
      ui.Paint()
        ..color = ui.Color.fromRGBO(76, 175, 80, alpha)
        ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 12),
    );
  }
}
