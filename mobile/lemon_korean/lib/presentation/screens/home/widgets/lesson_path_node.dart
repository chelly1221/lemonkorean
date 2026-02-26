import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../data/models/lesson_model.dart';
import '../../../screens/hangul/widgets/lemon_cross_section_painter.dart';

/// A single lemon-shaped node in the learning path.
///
/// Three visual states:
/// - Completed (progress >= 1.0): filled lemon + white check icon + lemon reward icons
/// - In-progress (0 < progress < 1.0): colored border + lesson number + pulse glow
/// - Not started (progress == null): grey border + grey lesson number
class LessonPathNode extends StatelessWidget {
  final LessonModel lesson;
  final double? progress; // null = not started, 0..1
  final Color levelColor;
  final VoidCallback onTap;
  final int index; // for ordering display
  final int lemonsEarned; // 0-3 lemons earned for this lesson

  static const double nodeWidth = 80;
  static const double nodeHeight = 80;
  static const int _totalSteps = 7; // 7단계 레슨
  static const TextStyle _centerNumberStyle = TextStyle(
    fontFamily: 'Pretendard',
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFFBDBDBD),
    height: 1.0,
  );

  const LessonPathNode({
    required this.lesson,
    required this.levelColor,
    required this.onTap,
    required this.index,
    super.key,
    this.progress,
    this.lemonsEarned = 0,
  });

  bool get _isCompleted => progress != null && progress! >= 1.0;
  bool get _isInProgress =>
      progress != null && progress! > 0 && progress! < 1.0;

  @override
  Widget build(BuildContext context) {
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
            // Lemon reward icons (only for completed lessons)
            if (_isCompleted && lemonsEarned > 0) ...[
              const SizedBox(height: 2),
              _buildLemonIcons(),
            ],
            const SizedBox(height: 4),
            // Korean title
            Text(
              lesson.titleKo,
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
            // Translated title
            Text(
              lesson.title,
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

  /// Build small lemon icons showing 1-3 earned lemons
  Widget _buildLemonIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final isEarned = i < lemonsEarned;
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

  int get _filledSteps =>
      progress != null ? (progress! * _totalSteps).round() : 0;

  Widget _buildStaticNode() {
    return CustomPaint(
      painter: LemonCrossSectionPainter(
        color: _isCompleted ? levelColor : Colors.grey.shade300,
        totalSlices: _totalSteps,
        filledSlices: _filledSteps,
        isFilled: _isCompleted,
      ),
      child: Center(
        child: _isCompleted
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
                '${lesson.id}',
                style: _centerNumberStyle,
                textScaler: TextScaler.noScaling,
              ),
      ),
    );
  }

  Widget _buildAnimatedNode() {
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
                totalSlices: _totalSteps,
                filledSlices: _filledSteps,
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
          '${lesson.id}',
          style: _centerNumberStyle,
          textScaler: TextScaler.noScaling,
        ),
      ),
    );
  }
}
