import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../screens/home/widgets/boss_quiz_node.dart';
import 'hangul_stage_path_node.dart';
import 'hangul_stats_bar.dart';

/// Displays hangul stages as a zigzag vertical learning path with lemon-shaped
/// nodes connected by S-curve lines. Includes a BOSS node at the end.
class HangulStagePathView extends StatelessWidget {
  final List<({int stage, String title, String subtitle})> stages; // 9 items
  final List<double> stageProgress; // 9 items, mastery 0-5
  final List<StageVisualState> stageStates; // 9 items
  final Color levelColor;
  final void Function(int stageIndex) onStageTap;
  final VoidCallback? onBossTap;
  final bool isBossUnlocked;
  final bool isBossCompleted;
  final Map<int, int>? completedLessonsMap; // stageIndex -> real completed count

  static const double _verticalSpacing = 130.0;
  static const double _maxWidth = 420.0;
  static const List<double> _alignments = [-0.5, 0.0, 0.5, 0.0];

  const HangulStagePathView({
    required this.stages,
    required this.stageProgress,
    required this.stageStates,
    required this.levelColor,
    required this.onStageTap,
    this.onBossTap,
    this.isBossUnlocked = false,
    this.isBossCompleted = false,
    this.completedLessonsMap,
    super.key,
  });

  /// First incomplete stage index, or -1 if all completed.
  int get _recommendedStage {
    for (int i = 0; i < stageStates.length; i++) {
      if (stageStates[i] != StageVisualState.completed) return i;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final totalNodes = stages.length + 1; // 9 stages + 1 BOSS

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;

            // Calculate positions for each node
            final nodePositions = <Offset>[];
            for (int i = 0; i < totalNodes; i++) {
              final align = _alignments[i % _alignments.length];
              final cx = availableWidth / 2 +
                  align *
                      (availableWidth / 2 -
                          HangulStagePathNode.nodeWidth / 2 -
                          16);
              final cy = i * _verticalSpacing + HangulStagePathNode.nodeHeight / 2;
              nodePositions.add(Offset(cx, cy));
            }

            final totalHeight =
                totalNodes * _verticalSpacing + 60; // extra bottom padding

            return SizedBox(
              height: totalHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // S-curve connection lines
                  CustomPaint(
                    size: Size(availableWidth, totalHeight),
                    painter: _HangulPathPainter(
                      nodePositions: nodePositions,
                      stageProgress: stageProgress,
                      levelColor: levelColor,
                    ),
                  ),

                  // Stage nodes (0-8)
                  for (int i = 0; i < stages.length; i++)
                    Positioned(
                      left: nodePositions[i].dx -
                          HangulStagePathNode.nodeWidth / 2,
                      top: nodePositions[i].dy -
                          HangulStagePathNode.nodeHeight / 2,
                      child: HangulStagePathNode(
                        stageIndex: stages[i].stage,
                        title: stages[i].title,
                        state: stageStates[i],
                        mastery: stageProgress[i],
                        isRecommended: i == _recommendedStage,
                        levelColor: levelColor,
                        animationIndex: i,
                        onTap: () => onStageTap(stages[i].stage),
                        completedLessonsOverride: completedLessonsMap?[stages[i].stage],
                      )
                          .animate()
                          .fadeIn(
                              duration: 400.ms, delay: (80 * i).ms)
                          .slideY(
                            begin: 0.3,
                            end: 0,
                            duration: 400.ms,
                            delay: (80 * i).ms,
                            curve: Curves.easeOut,
                          ),
                    ),

                  // BOSS node (index 9)
                  Positioned(
                    left: nodePositions[totalNodes - 1].dx -
                        BossQuizNode.nodeWidth / 2,
                    top: nodePositions[totalNodes - 1].dy -
                        BossQuizNode.nodeHeight / 2,
                    child: BossQuizNode(
                      chapterNumber: 1,
                      isUnlocked: isBossUnlocked,
                      isCompleted: isBossCompleted,
                      levelColor: levelColor,
                      onTap: onBossTap ?? () {},
                    )
                        .animate()
                        .fadeIn(
                            duration: 400.ms,
                            delay: (80 * stages.length).ms)
                        .slideY(
                          begin: 0.3,
                          end: 0,
                          duration: 400.ms,
                          delay: (80 * stages.length).ms,
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
class _HangulPathPainter extends CustomPainter {
  final List<Offset> nodePositions;
  final List<double> stageProgress; // mastery 0-5 for 9 stages
  final Color levelColor;

  _HangulPathPainter({
    required this.nodePositions,
    required this.stageProgress,
    required this.levelColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < nodePositions.length - 1; i++) {
      final from = nodePositions[i];
      final to = nodePositions[i + 1];

      // Segment is completed if the source stage mastery >= 5
      final isCompleted =
          i < stageProgress.length && stageProgress[i] >= 5.0;

      final paint = Paint()
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (isCompleted) {
        paint.color = levelColor;
      } else {
        paint.color = Colors.grey.shade300;
      }

      // S-curve path
      final midY = (from.dy + to.dy) / 2;
      final path = Path()
        ..moveTo(from.dx, from.dy)
        ..cubicTo(
          from.dx, midY,
          to.dx, midY,
          to.dx, to.dy,
        );

      if (isCompleted) {
        canvas.drawPath(path, paint);
      } else {
        _drawDashedPath(canvas, path, paint);
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
  bool shouldRepaint(covariant _HangulPathPainter oldDelegate) => true;
}
