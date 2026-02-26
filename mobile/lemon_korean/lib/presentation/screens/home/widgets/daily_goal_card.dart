import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Daily Goal Card Widget
/// Shows daily learning progress with animated progress bar and haptic feedback.
class DailyGoalCard extends StatefulWidget {
  final double progress; // 0.0 - 1.0
  final int completedLessons;
  final int targetLessons;

  const DailyGoalCard({
    required this.progress,
    required this.completedLessons,
    required this.targetLessons,
    super.key,
  });

  @override
  State<DailyGoalCard> createState() => _DailyGoalCardState();
}

class _DailyGoalCardState extends State<DailyGoalCard> {
  bool _hapticFired = false;

  @override
  void didUpdateWidget(DailyGoalCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fire haptic once when progress first reaches 100%.
    if (widget.progress >= 1.0 && !_hapticFired) {
      _hapticFired = true;
      HapticFeedback.mediumImpact();
    }
    if (widget.progress < 1.0) {
      _hapticFired = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final percentage = (widget.progress * 100).toInt();
    final isCompleted = widget.progress >= 1.0;
    final remaining = widget.targetLessons - widget.completedLessons;

    return Card(
      elevation: 0,
      color: isCompleted
          ? AppConstants.primaryColor.withValues(alpha: 0.1)
          : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        side: BorderSide(
          color: isCompleted
              ? AppConstants.primaryColor
              : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: icon + title + percentage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: isCompleted
                          ? AppConstants.primaryColor
                          : AppConstants.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.dailyGoal,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Percentage — larger and bolder when progress > 0
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    fontSize: widget.progress > 0
                        ? AppConstants.fontSizeLarge
                        : AppConstants.fontSizeMedium,
                    fontWeight: widget.progress > 0
                        ? FontWeight.w800
                        : FontWeight.bold,
                    color: isCompleted
                        ? AppConstants.primaryColor
                        : AppConstants.textSecondary,
                  ),
                  child: Text('$percentage%'),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Animated Progress Bar
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: widget.progress),
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              builder: (context, animatedValue, _) {
                return ClipRRect(
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusSmall),
                  child: LinearProgressIndicator(
                    value: animatedValue,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted
                          ? AppConstants.primaryColor
                          : AppConstants.primaryColor
                              .withValues(alpha: 0.7),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            // Progress text + action-oriented remaining hint
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.lessonsCompletedCount(widget.completedLessons),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textSecondary,
                  ),
                ),
                if (!isCompleted && remaining > 0)
                  Text(
                    '$remaining개 더 하면 목표 달성!',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color:
                          AppConstants.primaryColor.withValues(alpha: 0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),

            // Celebration row — shown only on completion, with pulsing glow
            if (isCompleted) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              _CelebrationRow(l10n: l10n),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.05, end: 0);
  }
}

/// Pulsing glow celebration row shown when the daily goal is completed.
class _CelebrationRow extends StatelessWidget {
  const _CelebrationRow({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.celebration,
          size: 16,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(width: 4),
        Text(
          l10n.dailyGoalComplete,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: AppConstants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .custom(
          duration: 900.ms,
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            // Subtle shadow glow that pulses between 0 and a soft lemon-yellow.
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryColor
                        .withValues(alpha: value * 0.35),
                    blurRadius: 8 * value,
                    spreadRadius: 1 * value,
                  ),
                ],
              ),
              child: child,
            );
          },
        );
  }
}
