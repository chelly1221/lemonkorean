import 'dart:ui' as ui;

import 'package:flame/components.dart';

/// Mute indicator badge (red circle with mic-off icon) shown on muted characters.
class MuteBadge extends PositionComponent {
  bool isMuted;

  MuteBadge({this.isMuted = false})
      : super(
          size: Vector2.all(20),
          anchor: Anchor.center,
        );

  @override
  void render(ui.Canvas canvas) {
    if (!isMuted) return;

    // Red circle
    canvas.drawCircle(
      ui.Offset(size.x / 2, size.y / 2),
      size.x / 2,
      ui.Paint()..color = const ui.Color(0xFFF44336),
    );

    // White border
    canvas.drawCircle(
      ui.Offset(size.x / 2, size.y / 2),
      size.x / 2,
      ui.Paint()
        ..color = const ui.Color(0xFFFFFFFF)
        ..style = ui.PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // Mic-off icon (simplified: diagonal line through circle)
    final iconPaint = ui.Paint()
      ..color = const ui.Color(0xFFFFFFFF)
      ..strokeWidth = 1.5
      ..style = ui.PaintingStyle.stroke
      ..strokeCap = ui.StrokeCap.round;

    // Mic shape (simplified rectangle + top arc)
    final micCenter = ui.Offset(size.x / 2, size.y / 2 - 1);
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(
        ui.Rect.fromCenter(center: micCenter, width: 5, height: 7),
        const ui.Radius.circular(2.5),
      ),
      iconPaint,
    );

    // Strike-through line
    canvas.drawLine(
      ui.Offset(size.x * 0.25, size.y * 0.75),
      ui.Offset(size.x * 0.75, size.y * 0.25),
      iconPaint,
    );
  }
}
