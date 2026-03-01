import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Stage 1: Introduction
/// Shows lesson overview and objectives
class Stage1Intro extends StatelessWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;

  const Stage1Intro({
    required this.lesson,
    required this.onNext,
    this.stageData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                // Lesson Number Badge
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppConstants.primaryColor,
                        AppConstants.primaryColor.withValues(alpha: 0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${lesson.level}',
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ).animate().scale(
                      delay: 200.ms,
                      duration: 600.ms,
                      curve: Curves.elasticOut,
                    ),

                const SizedBox(height: 24),

                // Korean Title
                Text(
                  lesson.titleKo,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

                const SizedBox(height: 12),

                // Chinese Title
                Text(
                  lesson.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    color: AppConstants.textSecondary,
                    height: 1.3,
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

                const SizedBox(height: 24),

                // Description
                if (lesson.description != null)
                  Container(
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
                    ),
                    child: Text(
                      lesson.description!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        height: 1.6,
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

                const SizedBox(height: 24),

                // Lesson Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildInfoChip(
                      Icons.access_time,
                      lesson.estimatedTime,
                    ),
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      Icons.translate,
                      l10n.wordsCount(lesson.vocabularyCount ?? 0),
                    ),
                  ],
                ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),

        // Start Button (fixed at bottom)
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingMedium, 8,
            AppConstants.paddingMedium, AppConstants.paddingMedium,
          ),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingMedium,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.startLearning,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 1200.ms, duration: 600.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 1200.ms,
                duration: 600.ms,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: AppConstants.primaryColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
