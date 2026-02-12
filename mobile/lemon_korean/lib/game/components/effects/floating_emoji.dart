import 'dart:ui' as ui;

import 'package:flame/components.dart';

import '../../core/game_constants.dart';

/// Floating emoji reaction that drifts upward and fades out.
class FloatingEmoji extends PositionComponent {
  final String emoji;
  double _life = 0;

  FloatingEmoji({
    required this.emoji,
    required Vector2 startPosition,
  }) : super(
    position: startPosition,
    size: Vector2.all(28),
    priority: 900,
  );

  @override
  void update(double dt) {
    super.update(dt);
    _life += dt;

    if (_life >= GameConstants.reactionLifetime) {
      removeFromParent();
      return;
    }

    // Float upward
    position.y -= GameConstants.reactionFloatSpeed * dt;
  }

  @override
  void render(ui.Canvas canvas) {
    final progress = _life / GameConstants.reactionLifetime;
    final opacity = 1.0 - progress;

    // Render emoji as text
    final paragraph = _buildParagraph(opacity);
    canvas.drawParagraph(paragraph, ui.Offset.zero);
  }

  ui.Paragraph _buildParagraph(double opacity) {
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: ui.TextAlign.center,
      fontSize: 28,
    ))
      ..pushStyle(ui.TextStyle(
        fontSize: 28,
        color: ui.Color.fromRGBO(255, 255, 255, opacity),
      ))
      ..addText(emoji);

    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: 40));
    return paragraph;
  }
}
