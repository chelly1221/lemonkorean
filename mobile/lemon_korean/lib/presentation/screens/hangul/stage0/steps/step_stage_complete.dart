import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';

/// Stage complete celebration screen.
class StepStageComplete extends StatelessWidget {
  final LessonStep step;
  final VoidCallback onDone;

  const StepStageComplete({required this.step, required this.onDone, super.key});

  @override
  Widget build(BuildContext context) {
    final stage = step.data['stage'] as int? ?? 0;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Celebration emoji
          const Text('🎊', style: TextStyle(fontSize: 64))
              .animate()
              .scale(
                begin: const Offset(0.3, 0.3),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          // Title
          Text(
            step.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0, duration: 500.ms),
          const SizedBox(height: 16),
          if (step.description != null)
            Text(
              step.description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 500.ms, duration: 400.ms),
          const SizedBox(height: 32),
          // Badge / achievement card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFF9C4), Color(0xFFFFECB3)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFFD54F), width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD54F).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text('🍋', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text(
                  '$stage단계 마스터',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF57F17),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '한글 구조 이해 완료!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.brown.shade400,
                  ),
                ),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 700.ms, duration: 500.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                delay: 700.ms,
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),
          const Spacer(flex: 3),
          // Done button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: const Text(
                '돌아가기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
