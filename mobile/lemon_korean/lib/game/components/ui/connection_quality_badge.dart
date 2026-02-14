import 'dart:ui' as ui;

import 'package:flame/components.dart';

/// Signal strength badge shown on characters with degraded connection quality.
///
/// - `excellent` / `unknown` → hidden (no visual clutter)
/// - `good` → 2 yellow bars
/// - `poor` → 1 red bar
/// - `lost` → red X icon
class ConnectionQualityBadge extends PositionComponent {
  String quality;

  ConnectionQualityBadge({this.quality = 'unknown'})
      : super(
          size: Vector2(16, 16),
          anchor: Anchor.center,
        );

  @override
  void render(ui.Canvas canvas) {
    if (quality == 'excellent' || quality == 'unknown') return;

    if (quality == 'lost') {
      _renderLost(canvas);
    } else {
      _renderBars(canvas);
    }
  }

  void _renderBars(ui.Canvas canvas) {
    final isGood = quality == 'good';
    final barColor = isGood
        ? const ui.Color(0xFFFFC107) // yellow
        : const ui.Color(0xFFF44336); // red
    final barCount = isGood ? 2 : 1;

    final barWidth = 3.0;
    final gap = 2.0;
    final totalWidth = barCount * barWidth + (barCount - 1) * gap;
    final startX = (size.x - totalWidth) / 2;

    final paint = ui.Paint()..color = barColor;

    for (var i = 0; i < barCount; i++) {
      final barHeight = 5.0 + (i + 1) * 3.0;
      final x = startX + i * (barWidth + gap);
      final y = size.y - barHeight;
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(
          ui.Rect.fromLTWH(x, y, barWidth, barHeight),
          const ui.Radius.circular(1),
        ),
        paint,
      );
    }

    // Draw empty bar outlines for missing bars
    final outlinePaint = ui.Paint()
      ..color = barColor.withAlpha(60)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 0.8;

    for (var i = barCount; i < 3; i++) {
      final barHeight = 5.0 + (i + 1) * 3.0;
      final x = startX + i * (barWidth + gap);
      final y = size.y - barHeight;
      canvas.drawRRect(
        ui.RRect.fromRectAndRadius(
          ui.Rect.fromLTWH(x, y, barWidth, barHeight),
          const ui.Radius.circular(1),
        ),
        outlinePaint,
      );
    }
  }

  void _renderLost(ui.Canvas canvas) {
    final paint = ui.Paint()
      ..color = const ui.Color(0xFFF44336)
      ..strokeWidth = 2.5
      ..style = ui.PaintingStyle.stroke
      ..strokeCap = ui.StrokeCap.round;

    final cx = size.x / 2;
    final cy = size.y / 2;
    const r = 4.0;

    canvas.drawLine(
      ui.Offset(cx - r, cy - r),
      ui.Offset(cx + r, cy + r),
      paint,
    );
    canvas.drawLine(
      ui.Offset(cx + r, cy - r),
      ui.Offset(cx - r, cy + r),
      paint,
    );
  }
}
