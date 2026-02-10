import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'lemon_clipper.dart';

/// A special boss quiz node displayed at the end of each chapter.
/// Shows a crown icon when unlocked, lock icon when locked.
class BossQuizNode extends StatelessWidget {
  final int chapterNumber;
  final bool isUnlocked; // all chapter lessons completed
  final bool isCompleted; // boss quiz passed
  final Color levelColor;
  final VoidCallback onTap;

  static const double nodeWidth = 80;
  static const double nodeHeight = 90;

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

  Widget _buildCompletedNode() {
    return CustomPaint(
      painter: LemonShapePainter(
        color: Colors.amber,
        isFilled: true,
        strokeWidth: 3.0,
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Icon(Icons.workspace_premium, color: Colors.white, size: 36),
        ),
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
              painter: LemonShapePainter(
                color: Colors.amber,
                isFilled: false,
                strokeWidth: 3.0,
                glowIntensity: value,
              ),
              child: child,
            );
          },
        ),
      ],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Icon(
            Icons.workspace_premium,
            size: 36,
            color: Colors.amber.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildLockedNode() {
    return CustomPaint(
      painter: LemonShapePainter(
        color: Colors.grey.shade300,
        isFilled: false,
        strokeWidth: 3.0,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Icon(
            Icons.lock,
            size: 28,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
