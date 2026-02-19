import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../stage0_lesson_content.dart';
import '../widgets/lemon_reward_animation.dart';

/// Mission results screen showing score, time, and lemon reward.
class StepMissionResults extends StatelessWidget {
  final LessonStep step;
  final int scorePercent;
  final int missionTimeSeconds;
  final int missionCompleted;
  final int lemonsEarned;
  final VoidCallback onNext;

  const StepMissionResults({
    required this.step,
    required this.scorePercent,
    required this.missionTimeSeconds,
    required this.missionCompleted,
    required this.lemonsEarned,
    required this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = missionTimeSeconds ~/ 60;
    final seconds = missionTimeSeconds % 60;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          // Trophy
          const Text('🏆', style: TextStyle(fontSize: 56))
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: 20),
          const Text(
            '미션 완료!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 24),
          // Stats cards
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _StatRow(
                  icon: Icons.check_circle,
                  label: '완성한 블록',
                  value: '$missionCompleted개',
                  color: const Color(0xFF4CAF50),
                ),
                const Divider(height: 20),
                _StatRow(
                  icon: Icons.timer,
                  label: '소요 시간',
                  value: '${minutes}분 ${seconds}초',
                  color: const Color(0xFF42A5F5),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 400.ms),
          const SizedBox(height: 32),
          // Lemon reward
          LemonRewardAnimation(lemonsEarned: lemonsEarned),
          const Spacer(flex: 3),
          // Next button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
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
          ).animate().fadeIn(delay: 1200.ms, duration: 400.ms),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
