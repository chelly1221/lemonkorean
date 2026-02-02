import 'package:flutter/material.dart';
import '../utils/onboarding_colors.dart';
import '../utils/onboarding_text_styles.dart';

/// Summary card showing selected preferences
class SummaryCard extends StatelessWidget {
  final String languageLabel;
  final String languageEmoji;
  final String languageValue;
  final String levelLabel;
  final String levelEmoji;
  final String levelValue;
  final String goalLabel;
  final String goalEmoji;
  final String goalValue;

  const SummaryCard({
    super.key,
    required this.languageLabel,
    required this.languageEmoji,
    required this.languageValue,
    required this.levelLabel,
    required this.levelEmoji,
    required this.levelValue,
    required this.goalLabel,
    required this.goalEmoji,
    required this.goalValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OnboardingSpacing.lg),
      decoration: BoxDecoration(
        // Toss-style: white card with subtle shadow
        color: OnboardingColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: OnboardingColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: OnboardingColors.cardShadow,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow(languageLabel, languageEmoji, languageValue),
          Divider(
            height: OnboardingSpacing.lg,
            color: OnboardingColors.border,
          ),
          _buildRow(levelLabel, levelEmoji, levelValue),
          Divider(
            height: OnboardingSpacing.lg,
            color: OnboardingColors.border,
          ),
          _buildRow(goalLabel, goalEmoji, goalValue),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String emoji, String value) {
    return Row(
      children: [
        // Emoji
        Text(
          emoji,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: OnboardingSpacing.sm),
        // Label and value
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: OnboardingTextStyles.caption,
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: OnboardingColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
