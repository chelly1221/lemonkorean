import 'dart:math' show cos, sin, pi;
import 'package:flutter/material.dart';

/// Lemon character expressions/poses
enum LemonExpression {
  welcome,    // Basic friendly lemon
  waving,     // Waving hand
  thinking,   // Thoughtful expression
  encouraging, // Cheering pose
  excited,    // Celebration pose with sparkles
}

/// Lemon character widget
/// Displays an animated lemon character with different expressions
class LemonCharacter extends StatelessWidget {
  final LemonExpression expression;
  final double size;

  const LemonCharacter({
    super.key,
    this.expression = LemonExpression.welcome,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LemonPainter(expression: expression),
      ),
    );
  }
}

class _LemonPainter extends CustomPainter {
  final LemonExpression expression;

  _LemonPainter({required this.expression});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Draw lemon body with more vibrant gradient for better contrast on yellow background
    paint.shader = const RadialGradient(
      colors: [
        Color(0xFFFFEB3B), // Brighter yellow center
        Color(0xFFFFC107), // Vivid lemon yellow (matches Toss-style button)
        Color(0xFFFFB300), // Deeper edge for contrast
      ],
      stops: [0.0, 0.5, 1.0],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final lemonRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.8,
      height: size.height * 0.9,
    );
    canvas.drawOval(lemonRect, paint);

    // Draw more visible shadow beneath for better contrast
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height * 0.88),
        width: size.width * 0.55,
        height: size.height * 0.12,
      ),
      shadowPaint,
    );

    // Reset shader
    paint.shader = null;

    // Draw leaf
    _drawLeaf(canvas, size);

    // Draw face based on expression
    switch (expression) {
      case LemonExpression.welcome:
        _drawWelcomeFace(canvas, size);
        break;
      case LemonExpression.waving:
        _drawWavingFace(canvas, size);
        _drawWavingHand(canvas, size);
        break;
      case LemonExpression.thinking:
        _drawThinkingFace(canvas, size);
        break;
      case LemonExpression.encouraging:
        _drawEncouragingFace(canvas, size);
        break;
      case LemonExpression.excited:
        _drawExcitedFace(canvas, size);
        _drawSparkles(canvas, size);
        break;
    }
  }

  void _drawLeaf(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF43A047) // Richer green for better contrast
      ..style = PaintingStyle.fill;

    final leafPath = Path();
    final startX = size.width * 0.6;
    final startY = size.height * 0.05;

    leafPath.moveTo(startX, startY);
    leafPath.quadraticBezierTo(
      startX + size.width * 0.15,
      startY - size.height * 0.05,
      startX + size.width * 0.2,
      startY + size.height * 0.05,
    );
    leafPath.quadraticBezierTo(
      startX + size.width * 0.1,
      startY + size.height * 0.08,
      startX,
      startY,
    );

    canvas.drawPath(leafPath, paint);
  }

  void _drawWelcomeFace(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Eyes
    final leftEye = Offset(size.width * 0.4, size.height * 0.45);
    final rightEye = Offset(size.width * 0.6, size.height * 0.45);
    canvas.drawCircle(leftEye, size.width * 0.04, paint);
    canvas.drawCircle(rightEye, size.width * 0.04, paint);

    // Smile
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.02;
    paint.strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(size.width * 0.35, size.height * 0.6);
    smilePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.7,
      size.width * 0.65,
      size.height * 0.6,
    );
    canvas.drawPath(smilePath, paint);
  }

  void _drawWavingFace(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Eyes (slightly to the right, looking at hand)
    final leftEye = Offset(size.width * 0.42, size.height * 0.45);
    final rightEye = Offset(size.width * 0.62, size.height * 0.45);
    canvas.drawCircle(leftEye, size.width * 0.04, paint);
    canvas.drawCircle(rightEye, size.width * 0.04, paint);

    // Big smile
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.02;
    paint.strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(size.width * 0.3, size.height * 0.58);
    smilePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.72,
      size.width * 0.7,
      size.height * 0.58,
    );
    canvas.drawPath(smilePath, paint);
  }

  void _drawWavingHand(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD700)
      ..style = PaintingStyle.fill;

    // Hand (small circle)
    final handCenter = Offset(size.width * 0.85, size.height * 0.3);
    canvas.drawCircle(handCenter, size.width * 0.12, paint);

    // Arm
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.08;
    paint.strokeCap = StrokeCap.round;

    final armPath = Path();
    armPath.moveTo(size.width * 0.7, size.height * 0.5);
    armPath.quadraticBezierTo(
      size.width * 0.8,
      size.height * 0.35,
      handCenter.dx,
      handCenter.dy,
    );
    canvas.drawPath(armPath, paint);
  }

  void _drawThinkingFace(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Eyes (one squinted)
    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.45),
      size.width * 0.04,
      paint,
    );

    // Squinted eye (line)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.02;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(size.width * 0.57, size.height * 0.45),
      Offset(size.width * 0.63, size.height * 0.45),
      paint,
    );

    // Mouth (curved line, thinking)
    final mouthPath = Path();
    mouthPath.moveTo(size.width * 0.4, size.height * 0.65);
    mouthPath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.62,
      size.width * 0.6,
      size.height * 0.65,
    );
    canvas.drawPath(mouthPath, paint);
  }

  void _drawEncouragingFace(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Happy eyes (^_^)
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.03;
    paint.strokeCap = StrokeCap.round;

    // Left eye
    final leftEyePath = Path();
    leftEyePath.moveTo(size.width * 0.35, size.height * 0.45);
    leftEyePath.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.42,
      size.width * 0.45,
      size.height * 0.45,
    );
    canvas.drawPath(leftEyePath, paint);

    // Right eye
    final rightEyePath = Path();
    rightEyePath.moveTo(size.width * 0.55, size.height * 0.45);
    rightEyePath.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.42,
      size.width * 0.65,
      size.height * 0.45,
    );
    canvas.drawPath(rightEyePath, paint);

    // Big open smile
    final smilePath = Path();
    smilePath.moveTo(size.width * 0.3, size.height * 0.6);
    smilePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.75,
      size.width * 0.7,
      size.height * 0.6,
    );
    canvas.drawPath(smilePath, paint);
  }

  void _drawExcitedFace(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Big star eyes (excited)
    _drawStar(canvas, Offset(size.width * 0.38, size.height * 0.43), size.width * 0.05, paint);
    _drawStar(canvas, Offset(size.width * 0.62, size.height * 0.43), size.width * 0.05, paint);

    // Wide open smile
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = size.width * 0.025;
    paint.strokeCap = StrokeCap.round;

    final smilePath = Path();
    smilePath.moveTo(size.width * 0.25, size.height * 0.58);
    smilePath.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.78,
      size.width * 0.75,
      size.height * 0.58,
    );
    canvas.drawPath(smilePath, paint);
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    const angle = pi * 2 / points;

    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * 0.5;
      final x = center.dx + r * cos(i * angle / 2 - pi / 2);
      final y = center.dy + r * sin(i * angle / 2 - pi / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawSparkles(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFC933)
      ..style = PaintingStyle.fill;

    // Draw sparkles around the lemon
    _drawSparkle(canvas, Offset(size.width * 0.15, size.height * 0.25), size.width * 0.04, paint);
    _drawSparkle(canvas, Offset(size.width * 0.85, size.height * 0.2), size.width * 0.05, paint);
    _drawSparkle(canvas, Offset(size.width * 0.12, size.height * 0.65), size.width * 0.045, paint);
    _drawSparkle(canvas, Offset(size.width * 0.88, size.height * 0.7), size.width * 0.04, paint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();

    // Draw a 4-pointed star sparkle
    path.moveTo(center.dx, center.dy - size); // Top
    path.lineTo(center.dx + size * 0.2, center.dy - size * 0.2);
    path.lineTo(center.dx + size, center.dy); // Right
    path.lineTo(center.dx + size * 0.2, center.dy + size * 0.2);
    path.lineTo(center.dx, center.dy + size); // Bottom
    path.lineTo(center.dx - size * 0.2, center.dy + size * 0.2);
    path.lineTo(center.dx - size, center.dy); // Left
    path.lineTo(center.dx - size * 0.2, center.dy - size * 0.2);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
