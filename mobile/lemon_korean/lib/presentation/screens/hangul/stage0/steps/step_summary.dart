import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';
import '../widgets/lemon_reward_animation.dart';

/// Summary step shown at the end of a lesson: score + lemon reward + done button.
class StepSummary extends StatelessWidget {
  final LessonStep step;
  final int scorePercent;
  final int lemonsEarned;
  final VoidCallback onComplete;

  const StepSummary({
    required this.step,
    required this.scorePercent,
    required this.lemonsEarned,
    required this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final message = step.data['message'] as String? ?? '레슨을 완료했어요!';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Celebration icon
          const Text('🎉', style: TextStyle(fontSize: 56))
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
          // Message
          Text(
            message,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          const SizedBox(height: 32),
          // Lemon reward
          LemonRewardAnimation(lemonsEarned: lemonsEarned),
          const Spacer(flex: 3),
          // Done button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: const Text(
                '완료',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(delay: 1000.ms, duration: 400.ms),
        ],
      ),
    );
  }
}
