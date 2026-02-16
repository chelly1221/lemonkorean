import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// CustomPainter that renders a giant lemon cross-section with 9 radial slices.
/// Each slice represents a learning stage (0-8) with progress-based coloring.
/// The center slice is highlighted with enhanced scale, brightness, and border.
class GiantLemonSlicePainter extends CustomPainter {
  final int centerIndex; // Currently centered slice (0-8)
  final List<double> stageProgress; // Mastery level for each stage (0-5)

  GiantLemonSlicePainter({
    required this.centerIndex,
    required this.stageProgress,
  }) : assert(stageProgress.length == 9, 'Must have exactly 9 stages');

  // Reusable paint objects for performance
  static final _slicePaint = Paint()..style = PaintingStyle.fill;
  static final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0
    ..color = Colors.white;
  static final _rindPaint = Paint()..style = PaintingStyle.fill;
  static final _labelPaint = TextPainter(textDirection: TextDirection.ltr);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw outer rind (golden gradient)
    _drawOuterRind(canvas, center, radius);

    // 2. Draw pith (thin white border)
    _drawPith(canvas, center, radius * 0.95);

    // 3. Draw 9 radial slices
    const sliceCount = 9;
    const sliceAngle = 2 * pi / sliceCount;
    const gapAngle = 0.02; // Small gap between slices

    for (int i = 0; i < sliceCount; i++) {
      final startAngle = i * sliceAngle - pi / 2; // Start from top
      final sweepAngle = sliceAngle - gapAngle;

      // Create slice path
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius * 0.94),
          startAngle,
          sweepAngle,
          false,
        )
        ..close();

      // Get color based on progress
      final color = _getProgressColor(stageProgress[i]);

      // Check if this is the center slice
      final isCenterSlice = (i == centerIndex);

      // Apply scale and glow for center slice
      if (isCenterSlice) {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.scale(1.05, 1.05);
        canvas.translate(-center.dx, -center.dy);
        _drawGlowEffect(canvas, path, color);
      }

      // Draw slice with brightness adjustment
      _slicePaint.color = isCenterSlice
          ? color.withValues(alpha: 1.0)
          : color.withValues(alpha: 0.3); // More transparent for non-selected slices
      canvas.drawPath(path, _slicePaint);

      // Draw border with emphasis for center slice
      if (isCenterSlice) {
        _borderPaint
          ..color = const Color(0xFFFF6F00)
          ..strokeWidth = 6.0; // Thicker border for emphasis
      } else {
        _borderPaint
          ..color = Colors.white
          ..strokeWidth = 2.0;
      }
      canvas.drawPath(path, _borderPaint);

      if (isCenterSlice) {
        canvas.restore();
      }

      // Draw stage label
      final labelAngle = startAngle + sweepAngle / 2;
      _drawLabel(canvas, i, center, radius * 0.7, labelAngle, isCenterSlice);
    }

    // 4. Draw center core (seed area)
    _drawCenterCore(canvas, center, 60);
  }

  void _drawOuterRind(Canvas canvas, Offset center, double radius) {
    final rindGradient = ui.Gradient.radial(
      center,
      radius,
      [
        const Color(0xFFFFD54F), // Gold
        const Color(0xFFFFA000), // Darker gold
      ],
      [0.85, 1.0],
    );

    _rindPaint.shader = rindGradient;
    canvas.drawCircle(center, radius, _rindPaint);
  }

  void _drawPith(Canvas canvas, Offset center, double radius) {
    final pithPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFFF9E5); // Light cream

    canvas.drawCircle(center, radius, pithPaint);
  }

  void _drawGlowEffect(Canvas canvas, Path path, Color color) {
    final glowPaint = Paint()
      ..color = const Color(0xFFFF6F00).withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, glowPaint);
  }

  void _drawLabel(
    Canvas canvas,
    int stage,
    Offset center,
    double labelRadius,
    double angle,
    bool isCenterSlice,
  ) {
    final x = center.dx + labelRadius * cos(angle);
    final y = center.dy + labelRadius * sin(angle);

    final textSpan = TextSpan(
      text: '$stage',
      style: TextStyle(
        fontSize: isCenterSlice ? 24 : 16,
        fontWeight: isCenterSlice ? FontWeight.bold : FontWeight.w600,
        color: isCenterSlice
            ? const Color(0xFFFF6F00)
            : Colors.black87,
      ),
    );

    _labelPaint.text = textSpan;
    _labelPaint.layout();

    final offsetX = x - _labelPaint.width / 2;
    final offsetY = y - _labelPaint.height / 2;

    _labelPaint.paint(canvas, Offset(offsetX, offsetY));
  }

  void _drawCenterCore(Canvas canvas, Offset center, double diameter) {
    final corePaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.radial(
        center,
        diameter / 2,
        [
          const Color(0xFFFFF59D), // Light yellow
          const Color(0xFFFFEE58), // Yellow
        ],
      );

    canvas.drawCircle(center, diameter / 2, corePaint);

    // Draw small shadow for depth
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(center, diameter / 2, shadowPaint);
  }

  Color _getProgressColor(double mastery) {
    final level = mastery.clamp(0, 5).toInt();
    const colors = [
      Color(0xFFBDBDBD), // 0: grey (not started)
      Color(0xFFC5E1A5), // 1: light green
      Color(0xFF81C784), // 2: green
      Color(0xFFCDDC39), // 3: yellow-green
      Color(0xFFFFEE58), // 4: yellow
      Color(0xFFFFD54F), // 5: gold (mastered)
    ];
    return colors[level];
  }

  @override
  bool shouldRepaint(covariant GiantLemonSlicePainter oldDelegate) {
    return oldDelegate.centerIndex != centerIndex ||
        !_listEquals(oldDelegate.stageProgress, stageProgress);
  }

  bool _listEquals(List<double> a, List<double> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
