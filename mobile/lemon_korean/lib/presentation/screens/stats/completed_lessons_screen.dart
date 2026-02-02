import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/convertible_text.dart';
import '../lesson/lesson_screen.dart';

/// Screen showing all completed lessons
class CompletedLessonsScreen extends StatelessWidget {
  const CompletedLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progressProvider = Provider.of<ProgressProvider>(context);
    final completedLessons = progressProvider.getCompletedLessons();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.completedLessons,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: completedLessons.isEmpty
          ? _buildEmptyState(l10n)
          : ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: completedLessons.length,
              itemBuilder: (context, index) {
                final lesson = completedLessons[index];
                return _buildLessonCard(context, lesson, l10n);
              },
            ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Text(
            l10n.noCompletedLessons,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Text(
            l10n.startFirstLesson,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context, Map<String, dynamic> lesson, AppLocalizations l10n) {
    final lessonId = lesson['lesson_id'] as int;
    final titleKo = lesson['title_ko'] as String? ?? '레슨 $lessonId';
    final titleZh = lesson['title_zh'] as String? ?? '课程 $lessonId';
    final level = lesson['level'] as int? ?? 1;
    final quizScore = lesson['quiz_score'] as int? ?? 0;
    final completedAt = lesson['completed_at'] != null
        ? DateTime.parse(lesson['completed_at'])
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: InkWell(
        onTap: () {
          // Navigate to lesson for review
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonScreen(
                lesson: LessonModel(
                  id: lessonId,
                  level: level,
                  titleKo: titleKo,
                  titleZh: titleZh,
                  description: '',
                  version: '1.0.0',
                  status: 'published',
                  estimatedMinutes: 30,
                  vocabularyCount: lesson['vocabulary_count'] as int? ?? 0,
                  isDownloaded: true,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Lesson icon with level badge
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.successColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                child: Stack(
                  children: [
                    const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: AppConstants.successColor,
                        size: 32,
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'L$level',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppConstants.paddingMedium),

              // Lesson info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ConvertibleText(
                      titleZh,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      titleKo,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (completedAt != null)
                      Text(
                        _formatDate(completedAt, l10n),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: Colors.grey.shade500,
                        ),
                      ),
                  ],
                ),
              ),

              // Quiz score
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getScoreColor(quizScore).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$quizScore%',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: _getScoreColor(quizScore),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Icon(
                    Icons.chevron_right,
                    color: AppConstants.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return AppConstants.successColor;
    if (score >= 70) return Colors.orange;
    return AppConstants.errorColor;
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return l10n.today;
    } else if (diff.inDays == 1) {
      return l10n.yesterday;
    } else if (diff.inDays < 7) {
      return l10n.daysAgo(diff.inDays);
    } else {
      return l10n.dateFormat(date.month, date.day);
    }
  }
}
