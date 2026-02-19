import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// Shared enum for stage visual states across hub widgets.
enum StageVisualState { notStarted, inProgress, completed }

/// Lesson counts for each stage (0-8), shared across hangul widgets.
const List<int> kStageLessonCounts = [
  4, // Stage 0: 한글 구조 이해
  9, // Stage 1: 핵심 모음
  17, // Stage 2: 기본 자음
  6, // Stage 3: 본격 조합 훈련
  14, // Stage 4: 된소리/거센소리
  10, // Stage 5: 받침 1차
  7, // Stage 6: 받침 확장
  7, // Stage 7: 복합 받침
  6, // Stage 8: 단어 읽기
];

/// Compact horizontal stats bar showing lemons, characters learned, and review nudge.
class HangulStatsBar extends StatelessWidget {
  final int totalLemons;
  final int charactersLearned;
  final int totalCharacters;
  final int dueForReview;
  final VoidCallback? onReviewTap;

  const HangulStatsBar({
    super.key,
    required this.totalLemons,
    required this.charactersLearned,
    required this.totalCharacters,
    required this.dueForReview,
    this.onReviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingLarge,
      ),
      child: Row(
        children: [
          // Lemon count
          _StatChip(
            icon: Icons.circle,
            iconColor: const Color(0xFFFFD54F),
            value: totalLemons,
            iconSize: 14,
          ),
          const SizedBox(width: 6),
          Container(
            width: 1,
            height: 16,
            color: Colors.grey.shade300,
          ),
          const SizedBox(width: 6),
          // Characters learned
          _StatChip(
            icon: Icons.auto_stories_outlined,
            iconColor: AppConstants.infoColor,
            value: charactersLearned,
            suffix: '/$totalCharacters',
            iconSize: 14,
          ),
          const Spacer(),
          // Review nudge pill
          if (dueForReview > 0)
            GestureDetector(
              onTap: onReviewTap,
              child: _ReviewNudgePill(count: dueForReview),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int value;
  final String? suffix;
  final double iconSize;

  const _StatChip({
    required this.icon,
    required this.iconColor,
    required this.value,
    this.suffix,
    this.iconSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: iconColor, size: iconSize),
        const SizedBox(width: 4),
        TweenAnimationBuilder<int>(
          tween: IntTween(begin: 0, end: value),
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOutCubic,
          builder: (context, val, _) {
            return Text(
              '$val${suffix ?? ''}',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimary,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ReviewNudgePill extends StatefulWidget {
  final int count;

  const _ReviewNudgePill({required this.count});

  @override
  State<_ReviewNudgePill> createState() => _ReviewNudgePillState();
}

class _ReviewNudgePillState extends State<_ReviewNudgePill>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    // Shimmer every 10 seconds when count > 3
    if (widget.count > 3) {
      _startPeriodicShimmer();
    }
  }

  void _startPeriodicShimmer() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _shimmerController.forward(from: 0.0).then((_) {
          if (mounted) _startPeriodicShimmer();
        });
      }
    });
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        final shimmerValue = _shimmerController.value;
        final opacity = shimmerValue < 0.5
            ? 1.0 - (shimmerValue * 0.3)
            : 0.85 + ((shimmerValue - 0.5) * 0.3);

        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppConstants.warningColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppConstants.warningColor.withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.refresh,
              size: 12,
              color: AppConstants.warningColor,
            ),
            const SizedBox(width: 4),
            Text(
              '복습 ${widget.count}자',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.w600,
                color: AppConstants.warningColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
