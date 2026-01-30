import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';

/// Stage 1: Introduction
/// Shows lesson overview and objectives
class Stage1Intro extends StatelessWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;

  const Stage1Intro({
    required this.lesson,
    this.stageData,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Lesson Number Badge
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '${lesson.level}',
                style: const TextStyle(
                  fontSize: 48,
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

          const SizedBox(height: 40),

          // Korean Title
          Text(
            lesson.titleKo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

          const SizedBox(height: 16),

          // Chinese Title
          Text(
            lesson.titleZh,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              color: AppConstants.textSecondary,
              height: 1.3,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

          const SizedBox(height: 40),

          // Description
          if (lesson.description != null)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
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

          const SizedBox(height: 40),

          // Lesson Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInfoChip(
                Icons.access_time,
                lesson.estimatedTime,
              ),
              const SizedBox(width: 16),
              _buildInfoChip(
                Icons.translate,
                '${lesson.vocabularyCount} 个单词',
              ),
            ],
          ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),

          const Spacer(),

          // Start Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
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
              child: const Text(
                '开始学习',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
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
        ],
      ),
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
