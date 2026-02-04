import 'package:flutter/material.dart';
import '../utils/onboarding_colors.dart';
import '../utils/onboarding_text_styles.dart';

/// Feature showcase card for app introduction
class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(OnboardingSpacing.md),
      decoration: BoxDecoration(
        // Toss-style: white card with subtle shadow
        color: OnboardingColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: OnboardingColors.border,
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: OnboardingColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon - Toss style: rounded square with subtle color
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: OnboardingColors.cardSelected,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: OnboardingColors.primaryYellow,
              size: 24,
            ),
          ),
          const SizedBox(width: OnboardingSpacing.md),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: OnboardingTextStyles.cardTitle,
                ),
                const SizedBox(height: OnboardingSpacing.xs),
                Text(
                  description,
                  style: OnboardingTextStyles.body2,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
