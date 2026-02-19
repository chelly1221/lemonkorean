import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Paints a realistic circular lemon cross-section.
///
/// Layers (outside → inside):
///   1. Rind (flavedo) — thick colored outer ring
///   2. Pith (albedo) — thin white/cream ring
///   3. Segments — fan-shaped (부채꼴) flesh segments with juice vesicle texture
///   4. Membrane walls — gaps and outlines separating segments
///   5. Columella — central white core
class LemonCrossSectionPainter extends CustomPainter {
  final Color color;
  final int totalSlices;
  final int filledSlices;
  final bool isFilled;
  final double glowIntensity;

  LemonCrossSectionPainter({
    required this.color,
    required this.totalSlices,
    required this.filledSlices,
    this.isFilled = false,
    this.glowIntensity = 0.0,
  });

  bool get _isNotStarted => filledSlices <= 0 && !isFilled;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = math.min(size.width, size.height) / 2 - 4;

    // --- Glow (in-progress pulse) ---
    if (glowIntensity > 0) {
      canvas.drawCircle(
        Offset(cx, cy),
        radius + 3,
        Paint()
          ..color = color.withValues(alpha: 0.35 * glowIntensity)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10 * glowIntensity),
      );
    }

    // --- Drop shadow for depth ---
    canvas.drawCircle(
      Offset(cx + 1, cy + 1.5),
      radius,
      Paint()
        ..color = Colors.black.withValues(alpha: 0.08)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // === Layer 1: Rind (flavedo) ===
    final rindThickness = radius * 0.13;
    final rindColor = isFilled
        ? color
        : _isNotStarted
            ? Colors.grey.shade300
            : color;
    canvas.drawCircle(Offset(cx, cy), radius, Paint()..color = rindColor);

    // Rind inner gradient (darker at outside, lighter inside)
    final rindGradient = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.08),
        ],
        stops: const [0.7, 1.0],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: radius));
    canvas.drawCircle(Offset(cx, cy), radius, rindGradient);

    // === Layer 2: Pith (albedo) — white ring ===
    final pithOuter = radius - rindThickness;
    final pithThickness = radius * 0.06;
    final pithInner = pithOuter - pithThickness;

    final bgWhite = isFilled
        ? Colors.white.withValues(alpha: 0.60)
        : _isNotStarted
            ? Colors.white
            : Colors.white.withValues(alpha: 0.50);
    canvas.drawCircle(Offset(cx, cy), pithOuter, Paint()..color = bgWhite);
    canvas.drawCircle(Offset(cx, cy), pithInner, Paint()..color = bgWhite);

    // === Layer 4: Segments (fan/wedge) + straight membrane walls ===
    if (totalSlices > 0) {
      final sliceAngle = 2 * math.pi / totalSlices;
      final startAngle = -math.pi / 2;
      final columellaRadius = pithInner * 0.18;
      final segOuterR = pithInner * 0.95;
      final segInnerR = columellaRadius * 1.15;

      // Draw each segment as a full pie wedge (no gap)
      for (int i = 0; i < totalSlices; i++) {
        final isFull = isFilled || i < filledSlices;
        final angle = startAngle + sliceAngle * i;
        final midAngle = angle + sliceAngle / 2;

        // Fan wedge with rounded corners at all 3 vertices
        final a0 = angle;
        final a1 = angle + sliceAngle;
        // Dynamic rounding: larger for fewer slices, smaller for many
        final cornerR = segOuterR *
            (totalSlices >= 9
                ? 0.22
                : (1.8 / totalSlices).clamp(0.22, 0.45));

        // Corner offsets along edges
        final innerOffset = cornerR * 1.2; // offset from center along radial
        final outerOffset = cornerR; // offset from outer corners along radial
        final arcInset = outerOffset / segOuterR; // angular inset on outer arc

        final segPath = Path();

        // Start: offset from center along first radial
        segPath.moveTo(
          cx + innerOffset * math.cos(a0),
          cy + innerOffset * math.sin(a0),
        );

        // Line along first radial toward outer, stop short
        segPath.lineTo(
          cx + (segOuterR - outerOffset) * math.cos(a0),
          cy + (segOuterR - outerOffset) * math.sin(a0),
        );

        // Round corner: first radial → outer arc
        segPath.quadraticBezierTo(
          cx + segOuterR * math.cos(a0),
          cy + segOuterR * math.sin(a0),
          cx + segOuterR * math.cos(a0 + arcInset),
          cy + segOuterR * math.sin(a0 + arcInset),
        );

        // Outer arc (slightly inset at both ends)
        segPath.arcTo(
          Rect.fromCircle(center: Offset(cx, cy), radius: segOuterR),
          a0 + arcInset,
          sliceAngle - arcInset * 2,
          false,
        );

        // Round corner: outer arc → second radial
        segPath.quadraticBezierTo(
          cx + segOuterR * math.cos(a1),
          cy + segOuterR * math.sin(a1),
          cx + (segOuterR - outerOffset) * math.cos(a1),
          cy + (segOuterR - outerOffset) * math.sin(a1),
        );

        // Line back toward center, stop short
        segPath.lineTo(
          cx + innerOffset * math.cos(a1),
          cy + innerOffset * math.sin(a1),
        );

        // Round corner: second radial → first radial (at center)
        segPath.quadraticBezierTo(
          cx, cy,
          cx + innerOffset * math.cos(a0),
          cy + innerOffset * math.sin(a0),
        );

        segPath.close();

        // Segment fill color
        Color segColor;
        if (isFull) {
          segColor = isFilled
              ? color
              : color.withValues(alpha: 0.55);
        } else {
          segColor = _isNotStarted
              ? const Color(0xFFF2F2F2)
              : const Color(0xFFFFFDE7);
        }

        canvas.drawPath(segPath, Paint()..color = segColor);

        // --- Juice vesicle lines inside filled segments ---
        if (isFull) {
          canvas.save();
          canvas.clipPath(segPath);

          final vesicleColor = isFilled
              ? Colors.white.withValues(alpha: 0.18)
              : color.withValues(alpha: 0.15);
          final vesiclePaint = Paint()
            ..color = vesicleColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.5
            ..strokeCap = StrokeCap.round;

          final vesicleCount = totalSlices <= 6 ? 4 : (totalSlices <= 10 ? 3 : 2);
          for (int v = 0; v < vesicleCount; v++) {
            final vFrac = (v + 1) / (vesicleCount + 1);
            final vAngle = angle + sliceAngle * vFrac;
            final vStartX = cx + segInnerR * 1.3 * math.cos(vAngle);
            final vStartY = cy + segInnerR * 1.3 * math.sin(vAngle);
            final vEndX = cx + segOuterR * 0.88 * math.cos(vAngle);
            final vEndY = cy + segOuterR * 0.88 * math.sin(vAngle);
            canvas.drawLine(
              Offset(vStartX, vStartY),
              Offset(vEndX, vEndY),
              vesiclePaint,
            );
          }

          canvas.restore();
        }
      }

      // --- Straight radial membrane lines on top ---
      final membraneColor = bgWhite;
      final membranePaint = Paint()
        ..color = membraneColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _isNotStarted ? 2.5 : 3.5
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < totalSlices; i++) {
        final angle = startAngle + sliceAngle * i;
        canvas.drawLine(
          Offset(cx + segInnerR * math.cos(angle), cy + segInnerR * math.sin(angle)),
          Offset(cx + segOuterR * math.cos(angle), cy + segOuterR * math.sin(angle)),
          membranePaint,
        );
      }

      // === Layer 5: Columella (central core) ===
      final columellaColor = isFilled
          ? Colors.white
          : _isNotStarted
              ? Colors.white
              : Colors.white;
      canvas.drawCircle(
        Offset(cx, cy),
        columellaRadius,
        Paint()..color = columellaColor,
      );
      canvas.drawCircle(
        Offset(cx, cy),
        columellaRadius,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.6,
      );
    }

    // === Outer stroke ===
    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = rindColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // === Highlight arc (top-left specular) ===
    if (isFilled) {
      final highlightPath = Path()
        ..addArc(
          Rect.fromCircle(center: Offset(cx, cy), radius: radius - 1),
          -math.pi * 0.85,
          math.pi * 0.4,
        );
      canvas.drawPath(
        highlightPath,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.25)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LemonCrossSectionPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.totalSlices != totalSlices ||
        oldDelegate.filledSlices != filledSlices ||
        oldDelegate.isFilled != isFilled ||
        oldDelegate.glowIntensity != glowIntensity;
  }
}
