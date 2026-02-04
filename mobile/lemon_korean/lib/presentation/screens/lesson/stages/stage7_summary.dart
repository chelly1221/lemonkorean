import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Stage 7: Summary
/// Lesson completion summary with achievements and next steps
class Stage7Summary extends StatelessWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onComplete;
  final VoidCallback? onPrevious;

  const Stage7Summary({
    required this.lesson,
    required this.onComplete,
    this.stageData,
    this.onPrevious,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Column(
          children: [
            const SizedBox(height: 40),

          // Completion Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.celebration,
              size: 64,
              color: Colors.black87,
            ),
          )
              .animate()
              .scale(
                delay: 200.ms,
                duration: 600.ms,
                curve: Curves.elasticOut,
              )
              .then()
              .shake(duration: 500.ms),

          const SizedBox(height: 40),

          // Completion Title
          Text(
            l10n.lessonComplete,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

          const SizedBox(height: 16),

          // Lesson Title
          Text(
            lesson.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: AppConstants.textSecondary,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

          const SizedBox(height: 40),

          // Achievement Cards
          _buildAchievementCard(
            icon: Icons.check_circle,
            title: l10n.learningComplete,
            subtitle: l10n.allStagesPassed,
            color: AppConstants.successColor,
          )
              .animate()
              .fadeIn(delay: 800.ms, duration: 600.ms)
              .slideX(begin: -0.2, end: 0, delay: 800.ms),

          const SizedBox(height: 12),

          _buildAchievementCard(
            icon: Icons.military_tech,
            title: l10n.experiencePoints(lesson.level * 10),
            subtitle: l10n.keepLearning,
            color: AppConstants.primaryColor,
          )
              .animate()
              .fadeIn(delay: 1000.ms, duration: 600.ms)
              .slideX(begin: -0.2, end: 0, delay: 1000.ms),

          const SizedBox(height: 12),

          _buildAchievementCard(
            icon: Icons.local_fire_department,
            title: l10n.streakDays,
            subtitle: l10n.streakDaysCount(7),
            color: Colors.orange,
          )
              .animate()
              .fadeIn(delay: 1200.ms, duration: 600.ms)
              .slideX(begin: -0.2, end: 0, delay: 1200.ms),

          const SizedBox(height: 40),

          // Review Stats
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Column(
              children: [
                Text(
                  l10n.lessonContent,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      icon: Icons.translate,
                      label: l10n.words,
                      value: '${lesson.vocabularyCount}',
                    ),
                    _buildStatItem(
                      icon: Icons.menu_book,
                      label: l10n.grammarPoints,
                      value: '3',
                    ),
                    _buildStatItem(
                      icon: Icons.chat_bubble_outline,
                      label: l10n.dialogues,
                      value: '2',
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 1400.ms, duration: 600.ms),

          const SizedBox(height: 30),

          // Next Lesson Preview
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${lesson.level + 1}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.nextLesson,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.continueToLearnMore,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppConstants.textSecondary,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 1600.ms, duration: 600.ms),

          const SizedBox(height: 30),

          // Complete Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingLarge,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                elevation: 0,
              ),
              child: Text(
                l10n.finish,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ).animate().fadeIn(delay: 1800.ms, duration: 600.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 1800.ms,
                duration: 600.ms,
              ),

          const SizedBox(height: 16),
        ],
      ),
      ),
    );
  }

  Widget _buildAchievementCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Icon(
              icon,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }
}
