import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Returns a lemon-shaped Path fitting within [size].
/// Top is slightly pointed, bottom is rounded, middle is wide.
/// Width:Height ratio ≈ 0.85:1.0
Path getLemonPath(Size size) {
  final w = size.width;
  final h = size.height;
  final cx = w / 2;

  final path = Path();

  // Start at the top center (pointed tip)
  path.moveTo(cx, 0);

  // Top-right curve → right side
  path.cubicTo(
    cx + w * 0.28, h * 0.02, // cp1: pull right near top
    w * 0.92, h * 0.28,      // cp2: right shoulder
    w * 0.92, h * 0.50,      // end: rightmost at mid-height
  );

  // Right side → bottom curve
  path.cubicTo(
    w * 0.92, h * 0.72,      // cp1: right belly
    w * 0.72, h * 0.98,      // cp2: right bottom
    cx, h,                    // end: bottom center
  );

  // Bottom → left side
  path.cubicTo(
    w * 0.28, h * 0.98,      // cp1: left bottom
    w * 0.08, h * 0.72,      // cp2: left belly
    w * 0.08, h * 0.50,      // end: leftmost at mid-height
  );

  // Left side → back to top
  path.cubicTo(
    w * 0.08, h * 0.28,      // cp1: left shoulder
    cx - w * 0.28, h * 0.02, // cp2: pull left near top
    cx, 0,                    // end: back to top center
  );

  path.close();
  return path;
}

/// Paints a lemon shape with optional fill, stroke, glow, and leaf.
class LemonShapePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isFilled;
  final double glowIntensity; // 0.0–1.0

  LemonShapePainter({
    required this.color,
    this.strokeWidth = 3.0,
    this.isFilled = false,
    this.glowIntensity = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Reserve top 12% for the leaf
    final bodyTop = size.height * 0.12;
    final bodySize = Size(size.width, size.height - bodyTop);

    canvas.save();
    canvas.translate(0, bodyTop);

    final path = getLemonPath(bodySize);

    // Glow shadow
    if (glowIntensity > 0) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.4 * glowIntensity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 * glowIntensity);
      canvas.drawPath(path, glowPaint);
    }

    // Fill or stroke
    final paint = Paint()..color = color;
    if (isFilled) {
      paint.style = PaintingStyle.fill;
      canvas.drawPath(path, paint);

      // Subtle highlight gradient on filled lemons
      final highlightPaint = Paint()
        ..shader = ui.Gradient.linear(
          Offset(bodySize.width * 0.3, 0),
          Offset(bodySize.width * 0.7, bodySize.height * 0.6),
          [
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.0),
          ],
        );
      canvas.drawPath(path, highlightPaint);
    } else {
      paint.style = PaintingStyle.stroke;
      paint.strokeWidth = strokeWidth;
      canvas.drawPath(path, paint);
    }

    canvas.restore();

    // Draw leaf at the top
    _drawLeaf(canvas, size);
  }

  void _drawLeaf(Canvas canvas, Size size) {
    final leafColor = isFilled
        ? const Color(0xFF43A047)
        : (color == Colors.grey.shade300 ? Colors.grey.shade400 : const Color(0xFF66BB6A));

    final paint = Paint()
      ..color = leafColor
      ..style = PaintingStyle.fill;

    final leafPath = Path();
    final startX = size.width * 0.55;
    final startY = size.height * 0.12;

    leafPath.moveTo(startX, startY);
    leafPath.quadraticBezierTo(
      startX + size.width * 0.18,
      startY - size.height * 0.10,
      startX + size.width * 0.22,
      startY - size.height * 0.02,
    );
    leafPath.quadraticBezierTo(
      startX + size.width * 0.10,
      startY + size.height * 0.04,
      startX,
      startY,
    );

    canvas.drawPath(leafPath, paint);

    // Leaf stem
    final stemPaint = Paint()
      ..color = leafColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(startX + size.width * 0.02, startY - size.height * 0.01),
      Offset(startX + size.width * 0.15, startY - size.height * 0.06),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(covariant LemonShapePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.isFilled != isFilled ||
        oldDelegate.glowIntensity != glowIntensity;
  }
}
