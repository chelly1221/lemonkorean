import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// CustomPainter that renders a giant lemon cross-section with 9 radial slices.
/// Each slice represents a learning stage (0-8) with lemon yellow theme.
/// Progress is shown through radial fill and lesson fractions (X/Y).
/// The center slice is highlighted with enhanced scale, brightness, and border.
class GiantLemonSlicePainter extends CustomPainter {
  final int centerIndex; // Currently centered slice (0-8)
  final List<double> stageProgress; // Mastery level for each stage (0-5)

  // Lesson counts for each stage (0-8)
  static const List<int> _lessonCounts = [
    4,  // Stage 0: 한글 구조 이해 (0-1, 0-2, 0-3, 0-M)
    9,  // Stage 1: 핵심 모음 (1-1 through 1-8, 1-M)
    17, // Stage 2: 기본 자음 (2-1 through 2-16, 2-M)
    6,  // Stage 3: 본격 조합 훈련 (3-1 through 3-5, 3-M)
    14, // Stage 4: 된소리/거센소리 (4-1 through 4-13, 4-M)
    10, // Stage 5: 받침 1차 (5-0 through 5-8, 5-M)
    7,  // Stage 6: 받침 확장 (6-1 through 6-6, 6-M)
    7,  // Stage 7: 복합 받침 (7-1 through 7-6, 7-M)
    6,  // Stage 8: 단어 읽기 (8-1 through 8-5, 8-M)
  ];

  GiantLemonSlicePainter({
    required this.centerIndex,
    required this.stageProgress,
  }) : assert(stageProgress.length == 9, 'Must have exactly 9 stages');

  // Reusable paint objects for performance
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

      // Check if this is the center slice
      final isCenterSlice = (i == centerIndex);

      // Apply scale and glow for center slice
      if (isCenterSlice) {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.scale(1.05, 1.05);
        canvas.translate(-center.dx, -center.dy);
        _drawGlowEffect(canvas, path);
      }

      // Draw slice with radial fill
      _drawRadialFill(canvas, center, radius * 0.94, path, i, isCenterSlice);

      // Draw border with emphasis for center slice
      if (isCenterSlice) {
        _borderPaint
          ..color = const Color(0xFFFFD54F) // Gold border
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

      // Draw lesson fraction text
      final labelAngle = startAngle + sweepAngle / 2;
      _drawLessonFraction(canvas, i, center, radius * 0.7, labelAngle, isCenterSlice);
    }

    // 4. Draw center core (seed area)
    _drawCenterCore(canvas, center, 60);
  }

  void _drawOuterRind(Canvas canvas, Offset center, double radius) {
    final rindGradient = ui.Gradient.radial(
      center,
      radius,
      [
        const Color(0xFFFFFDE7), // Very light yellow (center)
        const Color(0xFFFFEF5F), // Lemon yellow (edge)
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

  void _drawGlowEffect(Canvas canvas, Path path) {
    final glowPaint = Paint()
      ..color = const Color(0xFFFFD54F).withValues(alpha: 0.4) // Gold glow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, glowPaint);
  }

  void _drawLessonFraction(
    Canvas canvas,
    int index,
    Offset center,
    double labelRadius,
    double angle,
    bool isCenterSlice,
  ) {
    final totalLessons = _lessonCounts[index];
    final mastery = stageProgress[index].clamp(0.0, 5.0);
    final completedLessons = ((mastery / 5.0) * totalLessons).round();

    // Calculate text position at slice center
    final x = center.dx + labelRadius * cos(angle);
    final y = center.dy + labelRadius * sin(angle);

    // Text styling based on center status
    final textSpan = TextSpan(
      text: '$completedLessons/$totalLessons',
      style: TextStyle(
        fontSize: isCenterSlice ? 24 : 16,
        fontWeight: isCenterSlice ? FontWeight.bold : FontWeight.normal,
        color: isCenterSlice
            ? const Color(0xFF212121) // Dark text for center
            : const Color(0xFF212121).withValues(alpha: 0.7), // Slightly transparent for others
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
          const Color(0xFFFFFDE7), // Light yellow (center)
          const Color(0xFFFFEE58), // Bright yellow (edge)
        ],
      );

    canvas.drawCircle(center, diameter / 2, corePaint);

    // Draw small shadow for depth
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    canvas.drawCircle(center, diameter / 2, shadowPaint);
  }

  void _drawRadialFill(
    Canvas canvas,
    Offset center,
    double radius,
    Path slicePath,
    int index,
    bool isCenterSlice,
  ) {
    final totalLessons = _lessonCounts[index];
    final mastery = stageProgress[index].clamp(0.0, 5.0);

    // Calculate completed lessons from mastery (0-5 maps to 0-totalLessons)
    final completedLessons = ((mastery / 5.0) * totalLessons).round();
    final fillRatio = completedLessons / totalLessons;

    // Uniform lemon yellow color
    const lemonYellow = Color(0xFFFFEF5F);

    // Base opacity for center vs non-center slices
    final baseOpacity = isCenterSlice ? 1.0 : 0.5;

    // Create gradient shader from center to edge based on fill ratio
    final gradientShader = ui.Gradient.radial(
      center,
      radius,
      [
        lemonYellow.withValues(alpha: baseOpacity), // Full color at center
        lemonYellow.withValues(alpha: baseOpacity * 0.9), // Slightly lighter
        lemonYellow.withValues(alpha: baseOpacity * 0.2), // Very light at unfilled area
      ],
      [
        0.0,
        fillRatio * 0.9, // Filled portion
        1.0, // Unfilled portion
      ],
    );

    final fillPaint = Paint()
      ..shader = gradientShader
      ..style = PaintingStyle.fill;

    canvas.drawPath(slicePath, fillPaint);
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
