import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../screens/hangul/widgets/lemon_cross_section_painter.dart';

/// A special boss quiz node displayed at the end of each chapter.
/// Shows a crown icon when unlocked, lock icon when locked.
class BossQuizNode extends StatelessWidget {
  final int chapterNumber;
  final bool isUnlocked; // all chapter lessons completed
  final bool isCompleted; // boss quiz passed
  final Color levelColor;
  final VoidCallback onTap;

  static const double nodeWidth = 80;
  static const double nodeHeight = 80;

  const BossQuizNode({
    required this.chapterNumber,
    required this.isUnlocked,
    required this.isCompleted,
    required this.levelColor,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: SizedBox(
        width: nodeWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: nodeWidth,
              height: nodeHeight,
              child: isCompleted
                  ? _buildCompletedNode()
                  : isUnlocked
                      ? _buildUnlockedNode()
                      : _buildLockedNode(),
            ),
            const SizedBox(height: 6),
            Text(
              'BOSS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isCompleted
                    ? levelColor
                    : isUnlocked
                        ? Colors.amber.shade700
                        : Colors.grey.shade400,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static const int _bossSlices = 8;

  Widget _buildCompletedNode() {
    return CustomPaint(
      painter: LemonCrossSectionPainter(
        color: Colors.amber,
        totalSlices: _bossSlices,
        filledSlices: _bossSlices,
        isFilled: true,
      ),
      child: const Center(
        child: Icon(Icons.workspace_premium, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildUnlockedNode() {
    return Animate(
      onPlay: (controller) => controller.repeat(reverse: true),
      effects: [
        CustomEffect(
          duration: 1200.ms,
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return CustomPaint(
              painter: LemonCrossSectionPainter(
                color: Colors.amber,
                totalSlices: _bossSlices,
                filledSlices: 0,
                isFilled: false,
                glowIntensity: value,
              ),
              child: child,
            );
          },
        ),
      ],
      child: Center(
        child: Icon(
          Icons.workspace_premium,
          size: 20,
          color: Colors.amber.shade700,
        ),
      ),
    );
  }

  Widget _buildLockedNode() {
    return CustomPaint(
      painter: LemonCrossSectionPainter(
        color: Colors.grey.shade300,
        totalSlices: _bossSlices,
        filledSlices: 0,
        isFilled: false,
      ),
      child: Center(
        child: Icon(
          Icons.lock,
          size: 18,
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
