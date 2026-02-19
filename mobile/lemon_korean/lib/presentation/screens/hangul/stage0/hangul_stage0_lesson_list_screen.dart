import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../providers/hangul_provider.dart';
import 'hangul_lesson_flow_screen.dart';
import 'stage0_lesson_content.dart';

/// Shows the 4 lessons of Stage 0 with completion status and lemon rewards.
class HangulStage0LessonListScreen extends StatelessWidget {
  const HangulStage0LessonListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('0단계: 한글 구조 이해')),
      body: Consumer<HangulProvider>(
        builder: (context, hangul, _) {
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: stage0Lessons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lesson = stage0Lessons[index];
              final progress = hangul.getLessonProgress(lesson.id);
              final isCompleted = progress?.isCompleted ?? false;
              final lemonsEarned = progress?.lemonsEarned ?? 0;
              final isLocked = index > 0 && !_isPreviousCompleted(hangul, index);

              return _LessonCard(
                lesson: lesson,
                index: index,
                isCompleted: isCompleted,
                lemonsEarned: lemonsEarned,
                isLocked: isLocked,
                onTap: isLocked
                    ? null
                    : () => _startLesson(context, lesson),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: (80 * index).ms)
                  .slideX(
                    begin: 0.1,
                    end: 0,
                    duration: 400.ms,
                    delay: (80 * index).ms,
                    curve: Curves.easeOut,
                  );
            },
          );
        },
      ),
    );
  }

  bool _isPreviousCompleted(HangulProvider hangul, int index) {
    if (index == 0) return true;
    final prevLesson = stage0Lessons[index - 1];
    final prevProgress = hangul.getLessonProgress(prevLesson.id);
    return prevProgress?.isCompleted ?? false;
  }

  void _startLesson(BuildContext context, LessonData lesson) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HangulLessonFlowScreen(lesson: lesson),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final LessonData lesson;
  final int index;
  final bool isCompleted;
  final int lemonsEarned;
  final bool isLocked;
  final VoidCallback? onTap;

  const _LessonCard({
    required this.lesson,
    required this.index,
    required this.isCompleted,
    required this.lemonsEarned,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMission = lesson.isMission;
    final bgColor = isLocked
        ? Colors.grey.shade100
        : isMission
            ? const Color(0xFFFFF8E1)
            : isCompleted
                ? const Color(0xFFE8F5E9)
                : Colors.white;

    return Card(
      elevation: isLocked ? 0 : 2,
      color: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isCompleted
            ? const BorderSide(color: Color(0xFF4CAF50), width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Status icon
              _buildStatusIcon(),
              const SizedBox(width: 14),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isLocked ? Colors.grey : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      lesson.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: isLocked ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Step count
                    Text(
                      '${lesson.totalSteps} 단계',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              // Lemon reward display
              if (isCompleted) _buildLemonReward(),
              // Arrow
              if (!isLocked)
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    if (isLocked) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Icon(Icons.lock, color: Colors.grey.shade400, size: 20),
      );
    }

    if (isCompleted) {
      return Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFF4CAF50),
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 22),
      );
    }

    if (lesson.isMission) {
      return Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber.shade100,
          border: Border.all(color: Colors.amber, width: 2),
        ),
        child: const Icon(Icons.flag, color: Colors.amber, size: 22),
      );
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFEF5F).withValues(alpha: 0.3),
        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
      ),
      child: Center(
        child: Text(
          lesson.id.split('-').last,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFF9A825),
          ),
        ),
      ),
    );
  }

  Widget _buildLemonReward() {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final earned = i < lemonsEarned;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              earned ? '🍋' : '·',
              style: TextStyle(
                fontSize: earned ? 14 : 16,
                color: earned ? null : Colors.grey.shade400,
              ),
            ),
          );
        }),
      ),
    );
  }
}
