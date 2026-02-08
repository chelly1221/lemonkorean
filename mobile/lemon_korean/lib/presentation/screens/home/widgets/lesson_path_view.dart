import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../data/models/lesson_model.dart';
import 'lesson_path_node.dart';

/// Displays lessons as a zigzag vertical learning path with lemon-shaped nodes
/// connected by S-curve lines.
class LessonPathView extends StatelessWidget {
  final List<LessonModel> lessons;
  final Map<int, double> lessonProgress; // lesson_id -> 0.0-1.0
  final Color levelColor;
  final void Function(LessonModel lesson) onLessonTap;

  /// Vertical spacing between node centers
  static const double _verticalSpacing = 130.0;

  /// Max content width (for web)
  static const double _maxWidth = 420.0;

  /// Zigzag alignment pattern: left, center, right, center, ...
  static const List<double> _alignments = [-0.5, 0.0, 0.5, 0.0];

  const LessonPathView({
    required this.lessons,
    required this.lessonProgress,
    required this.levelColor,
    required this.onLessonTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) return const SizedBox.shrink();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final totalHeight =
                _verticalSpacing * (lessons.length - 1) +
                LessonPathNode.nodeHeight +
                60; // extra for titles below last node

            // Compute node center positions
            final nodePositions = <Offset>[];
            for (int i = 0; i < lessons.length; i++) {
              final align = _alignments[i % _alignments.length];
              final cx = availableWidth / 2 +
                  align * (availableWidth / 2 - LessonPathNode.nodeWidth / 2 - 16);
              final cy = _verticalSpacing * i + LessonPathNode.nodeHeight / 2;
              nodePositions.add(Offset(cx, cy));
            }

            return SizedBox(
              height: totalHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Background path lines
                  CustomPaint(
                    size: Size(availableWidth, totalHeight),
                    painter: _PathRoutePainter(
                      nodePositions: nodePositions,
                      lessonProgress: lessonProgress,
                      lessons: lessons,
                      levelColor: levelColor,
                    ),
                  ),

                  // Lesson nodes
                  for (int i = 0; i < lessons.length; i++)
                    Positioned(
                      left: nodePositions[i].dx - LessonPathNode.nodeWidth / 2,
                      top: nodePositions[i].dy - LessonPathNode.nodeHeight / 2,
                      child: LessonPathNode(
                        lesson: lessons[i],
                        progress: lessonProgress[lessons[i].id],
                        levelColor: levelColor,
                        index: i,
                        onTap: () => onLessonTap(lessons[i]),
                      )
                          .animate()
                          .fadeIn(
                            duration: 400.ms,
                            delay: (80 * i).ms,
                          )
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 400.ms,
                            delay: (80 * i).ms,
                            curve: Curves.easeOut,
                          ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Paints S-curve connection lines between consecutive nodes.
class _PathRoutePainter extends CustomPainter {
  final List<Offset> nodePositions;
  final Map<int, double> lessonProgress;
  final List<LessonModel> lessons;
  final Color levelColor;

  _PathRoutePainter({
    required this.nodePositions,
    required this.lessonProgress,
    required this.lessons,
    required this.levelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < nodePositions.length - 1; i++) {
      final from = nodePositions[i];
      final to = nodePositions[i + 1];

      // A segment is "completed" if the source node's lesson is completed
      final fromProgress = lessonProgress[lessons[i].id];
      final isCompleted = fromProgress != null && fromProgress >= 1.0;

      final paint = Paint()
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (isCompleted) {
        paint.color = levelColor;
      } else {
        paint.color = Colors.grey.shade300;
      }

      // Build S-curve path
      final midY = (from.dy + to.dy) / 2;
      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..cubicTo(
          from.dx, midY, // cp1: vertical from start
          to.dx, midY,   // cp2: vertical to end
          to.dx, to.dy,  // end point
        );

      if (isCompleted) {
        canvas.drawPath(path, paint);
      } else {
        // Draw dashed line
        _drawDashedPath(canvas, path, paint, dashWidth: 8, gapWidth: 4);
      }
    }
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint, {
    double dashWidth = 8,
    double gapWidth = 4,
  }) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0, metric.length).toDouble();
        final extractPath = metric.extractPath(distance, end);
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + gapWidth;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PathRoutePainter oldDelegate) {
    return oldDelegate.levelColor != levelColor ||
        oldDelegate.nodePositions != nodePositions ||
        oldDelegate.lessonProgress != lessonProgress;
  }
}
