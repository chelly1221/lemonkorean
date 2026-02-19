import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Lemon reward celebration widget showing earned lemons with animation.
class LemonRewardAnimation extends StatelessWidget {
  final int lemonsEarned; // 1-3

  const LemonRewardAnimation({required this.lemonsEarned, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Lemons row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            final isEarned = i < lemonsEarned;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Text(
                isEarned ? '🍋' : '·',
                style: TextStyle(
                  fontSize: isEarned ? 40 : 32,
                  color: isEarned ? null : Colors.grey.shade400,
                ),
              )
                  .animate()
                  .scale(
                    begin: isEarned ? const Offset(0, 0) : const Offset(1, 1),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                    delay: (200 * i).ms,
                    curve: Curves.easeOutBack,
                  )
                  .fadeIn(
                    duration: 300.ms,
                    delay: (200 * i).ms,
                  ),
            );
          }),
        ),
        const SizedBox(height: 12),
        // Label
        Text(
          _rewardMessage,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFFF9A825),
          ),
        )
            .animate()
            .fadeIn(delay: 800.ms, duration: 400.ms),
      ],
    );
  }

  String get _rewardMessage {
    switch (lemonsEarned) {
      case 3:
        return '완벽해요! 🍋🍋🍋';
      case 2:
        return '잘했어요! 🍋🍋';
      default:
        return '좋아요! 🍋';
    }
  }
}
