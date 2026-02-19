import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';
import '../widgets/syllable_combine_animation.dart';

/// Shows a consonant + vowel → syllable split/combine animation.
class StepSyllableAnimation extends StatefulWidget {
  final LessonStep step;
  final VoidCallback onNext;

  const StepSyllableAnimation({
    required this.step,
    required this.onNext,
    super.key,
  });

  @override
  State<StepSyllableAnimation> createState() => _StepSyllableAnimationState();
}

class _StepSyllableAnimationState extends State<StepSyllableAnimation> {
  bool _animationComplete = false;

  @override
  Widget build(BuildContext context) {
    final consonant = widget.step.data['consonant'] as String? ?? 'ㄱ';
    final vowel = widget.step.data['vowel'] as String? ?? 'ㅏ';
    final result = widget.step.data['result'] as String? ?? '가';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Title
          Text(
            widget.step.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 12),
          if (widget.step.description != null)
            Text(
              widget.step.description!,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 40),
          // Animation widget
          SyllableCombineAnimation(
            consonant: consonant,
            vowel: vowel,
            result: result,
            onComplete: () => setState(() => _animationComplete = true),
          ),
          const Spacer(flex: 3),
          // Next button
          if (_animationComplete)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD54F),
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  '다음',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ).animate().fadeIn(duration: 300.ms),
        ],
      ),
    );
  }
}
