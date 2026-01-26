import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Daily Goal Card Widget
/// Shows daily learning progress
class DailyGoalCard extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final int completedLessons;
  final int targetLessons;

  const DailyGoalCard({
    required this.progress, required this.completedLessons, required this.targetLessons, super.key,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();
    final isCompleted = progress >= 1.0;

    return Card(
      elevation: 0,
      color: isCompleted
          ? AppConstants.primaryColor.withOpacity(0.1)
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
                    const Text(
                      '今日目标',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: isCompleted
                        ? AppConstants.primaryColor
                        : AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isCompleted
                      ? AppConstants.primaryColor
                      : AppConstants.primaryColor.withOpacity(0.7),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.paddingSmall),

            // Progress Text
            Text(
              '$completedLessons/$targetLessons 课完成',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textSecondary,
              ),
            ),

            if (isCompleted) ...[
              const SizedBox(height: AppConstants.paddingSmall),
              const Row(
                children: [
                  Icon(
                    Icons.celebration,
                    size: 16,
                    color: AppConstants.primaryColor,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '太棒了！今日目标已完成！',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
