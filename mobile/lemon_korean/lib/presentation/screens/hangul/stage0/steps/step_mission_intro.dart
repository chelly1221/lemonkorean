import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';

/// Mission intro: countdown and description before the timed mission starts.
class StepMissionIntro extends StatelessWidget {
  final LessonStep step;
  final VoidCallback onNext;

  const StepMissionIntro({required this.step, required this.onNext, super.key});

  @override
  Widget build(BuildContext context) {
    final timeLimit = step.data['timeLimitSeconds'] as int? ?? 180;
    final targetCount = step.data['targetCount'] as int? ?? 5;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Flag icon
          const Text('🚩', style: TextStyle(fontSize: 64))
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: 24),
          // Title
          Text(
            step.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 16),
          if (step.description != null)
            Text(
              step.description!,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          const SizedBox(height: 24),
          // Mission details card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF8E1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFD54F)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer, color: Color(0xFFF9A825)),
                    const SizedBox(width: 8),
                    Text(
                      '제한시간: ${timeLimit ~/ 60}분',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Color(0xFFF9A825)),
                    const SizedBox(width: 8),
                    Text(
                      '목표: 글자 블록 $targetCount개',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
          const Spacer(flex: 3),
          // Start button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF9A825),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: const Text(
                '미션 시작!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
