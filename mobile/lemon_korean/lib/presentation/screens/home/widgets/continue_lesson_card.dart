import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../data/models/progress_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../utils/localized_display.dart';

/// Continue Lesson Card Widget
/// Shows current lesson with progress
class ContinueLessonCard extends StatelessWidget {
  final LessonModel lesson;
  final ProgressModel progress;
  final VoidCallback onTap;

  const ContinueLessonCard({
    required this.lesson, required this.progress, required this.onTap, super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Lesson Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${lesson.level}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: AppConstants.paddingMedium),

                  // Lesson Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lesson.titleKo,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeLarge,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lesson.title,
                          style: const TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            color: AppConstants.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Continue Arrow
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.black87,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingMedium),

              // Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Builder(
                        builder: (context) {
                          final l10n = AppLocalizations.of(context)!;
                          return Text(
                            _getLocalizedStatus(l10n, progress.status),
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: AppConstants.textSecondary,
                            ),
                          );
                        },
                      ),
                      Text(
                        '${progress.progressPercentage}%',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                    child: LinearProgressIndicator(
                      value: progress.progressPercentage / 100,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.paddingSmall),

              // Time Spent
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppConstants.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Builder(
                    builder: (context) {
                      final l10n = AppLocalizations.of(context)!;
                      return Text(
                        l10n.timeStudied(progress.getTimeSpentDisplay(l10n)),
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocalizedStatus(AppLocalizations l10n, String status) {
    switch (status) {
      case 'not_started':
        return l10n.statusNotStarted;
      case 'in_progress':
        return l10n.statusInProgress;
      case 'completed':
        return l10n.statusCompleted;
      case 'failed':
        return l10n.statusFailed;
      default:
        return l10n.statusNotStarted;
    }
  }
}
