import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'hangul_stats_bar.dart';
import 'lemon_cross_section_painter.dart';

/// A single lemon-shaped node in the hangul stage path.
///
/// Three visual states:
/// - Completed (mastery >= 5.0): filled lemon + white check icon + lemon reward icons
/// - In progress (0 < mastery < 5.0): colored border + stage number + pulse glow
/// - Not started (mastery <= 0): grey border + grey stage number
class HangulStagePathNode extends StatelessWidget {
  final int stageIndex; // 0-8
  final String title; // e.g., '한글 구조 이해'
  final StageVisualState state;
  final double mastery; // 0-5
  final bool isRecommended; // first incomplete stage
  final Color levelColor;
  final VoidCallback onTap;
  final int animationIndex; // staggered fadeIn delay
  final int? completedLessonsOverride; // real lesson count (from provider)

  static const double nodeWidth = 80;
  static const double nodeHeight = 80;

  const HangulStagePathNode({
    required this.stageIndex,
    required this.title,
    required this.state,
    required this.mastery,
    required this.levelColor,
    required this.onTap,
    required this.animationIndex,
    this.isRecommended = false,
    this.completedLessonsOverride,
    super.key,
  });

  bool get _isCompleted => state == StageVisualState.completed;
  bool get _isInProgress => state == StageVisualState.inProgress;

  int get _lemonsEarned {
    if (mastery >= 5.0) return 3;
    if (mastery >= 3.0) return 2;
    if (mastery >= 1.0) return 1;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final totalLessons = kStageLessonCounts[stageIndex];
    final completedLessons = completedLessonsOverride ?? ((mastery / 5.0) * totalLessons).round();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: nodeWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lemon node
            SizedBox(
              width: nodeWidth,
              height: nodeHeight,
              child: _isInProgress ? _buildAnimatedNode() : _buildStaticNode(),
            ),
            // Lemon reward icons (only for completed stages)
            if (_isCompleted && _lemonsEarned > 0) ...[
              const SizedBox(height: 2),
              _buildLemonIcons(),
            ],
            const SizedBox(height: 4),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: _isCompleted ? FontWeight.w600 : FontWeight.w500,
                color: _isCompleted || _isInProgress
                    ? Colors.black87
                    : Colors.grey.shade500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            // Lesson count sublabel
            Text(
              '$completedLessons/$totalLessons 레슨',
              style: TextStyle(
                fontSize: 10,
                color: _isCompleted || _isInProgress
                    ? Colors.grey.shade600
                    : Colors.grey.shade400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLemonIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isEarned = i < _lemonsEarned;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: Text(
            isEarned ? '🍋' : '·',
            style: TextStyle(
              fontSize: isEarned ? 10 : 12,
              color: isEarned ? null : Colors.grey.shade400,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStaticNode() {
    final totalLessons = kStageLessonCounts[stageIndex];
    final completedLessons = ((mastery / 5.0) * totalLessons).round();

    return CustomPaint(
      painter: LemonCrossSectionPainter(
        color: _isCompleted ? levelColor : Colors.grey.shade300,
        totalSlices: totalLessons,
        filledSlices: completedLessons,
        isFilled: _isCompleted,
      ),
      child: Center(
        child: _isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '$stageIndex',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                ),
              ),
      ),
    );
  }

  Widget _buildAnimatedNode() {
    final totalLessons = kStageLessonCounts[stageIndex];
    final completedLessons = ((mastery / 5.0) * totalLessons).round();

    return Animate(
      onPlay: (controller) => controller.repeat(reverse: true),
      effects: [
        CustomEffect(
          duration: 1500.ms,
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return CustomPaint(
              painter: LemonCrossSectionPainter(
                color: levelColor,
                totalSlices: totalLessons,
                filledSlices: completedLessons,
                isFilled: false,
                glowIntensity: value,
              ),
              child: child,
            );
          },
        ),
      ],
      child: Center(
        child: Text(
          '$stageIndex',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: levelColor,
          ),
        ),
      ),
    );
  }
}
