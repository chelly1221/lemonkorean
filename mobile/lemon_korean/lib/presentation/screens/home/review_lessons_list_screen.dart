import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../lesson/lesson_screen.dart';

/// Simple review lesson list screen.
/// SRS sequencing will be added later; for now we list lessons with any progress.
class ReviewLessonsListScreen extends StatelessWidget {
  final List<LessonModel> lessons;
  final Map<int, double> lessonProgress;

  const ReviewLessonsListScreen({
    required this.lessons,
    required this.lessonProgress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final reviewLessons = lessons
        .where((l) => lessonProgress.containsKey(l.id))
        .toList()
      ..sort((a, b) => a.level.compareTo(b.level));

    return Scaffold(
      appBar: AppBar(
        title: const Text('복습 레슨'),
      ),
      body: reviewLessons.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.replay, size: 44, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    '복습할 레슨이 아직 없어요',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: reviewLessons.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final lesson = reviewLessons[index];
                final progress = lessonProgress[lesson.id] ?? 0.0;
                final percent = (progress * 100).round().clamp(0, 100);
                final isCompleted = progress >= 1.0;

                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonScreen(lesson: lesson),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: isCompleted
                          ? AppConstants.successColor.withValues(alpha: 0.18)
                          : Colors.grey.shade200,
                      child: Text(
                        '${lesson.level}',
                        style: TextStyle(
                          color: isCompleted
                              ? AppConstants.successColor
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(lesson.titleKo),
                    subtitle: Text('Level ${lesson.level} • ${lesson.title}'),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? AppConstants.successColor.withValues(alpha: 0.12)
                            : Colors.amber.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        isCompleted ? '완료' : '$percent%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? AppConstants.successColor
                              : Colors.amber.shade800,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
