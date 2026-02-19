import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';

/// Intro step: shows a title, description, and emoji with a "다음" button.
class StepIntro extends StatelessWidget {
  final LessonStep step;
  final VoidCallback onNext;

  const StepIntro({required this.step, required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    final emoji = step.data['emoji'] as String? ?? '📖';
    final highlights = (step.data['highlights'] as List?)?.cast<String>() ?? [];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Emoji
          Text(emoji, style: const TextStyle(fontSize: 64))
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          // Title
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms),
          const SizedBox(height: 16),
          // Description
          if (step.description != null)
            Text(
              step.description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 400.ms),
          // Highlight chips
          if (highlights.isNotEmpty) ...[
            const SizedBox(height: 20),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: highlights.map((h) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFD54F)),
                  ),
                  child: Text(
                    h,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
          ],
          const Spacer(flex: 3),
          // Next button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: Colors.black87,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: const Text(
                '시작하기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
