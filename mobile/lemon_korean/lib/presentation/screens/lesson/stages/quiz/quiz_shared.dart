import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/constants/app_constants.dart';

/// Shared components for quiz questions

/// Question type badge widget
class QuestionTypeBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const QuestionTypeBadge({
    required this.label,
    required this.icon,
    required this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Feedback widget shown after answering a question
class QuestionFeedback extends StatelessWidget {
  final bool isCorrect;
  final String correctAnswer;
  final String? explanation;

  const QuestionFeedback({
    required this.isCorrect,
    required this.correctAnswer,
    this.explanation,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: isCorrect
            ? AppConstants.successColor.withOpacity(0.1)
            : AppConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.celebration : Icons.info_outline,
                color: isCorrect
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isCorrect ? '太棒了！' : '正确答案是: $correctAnswer',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: isCorrect
                        ? AppConstants.successColor
                        : AppConstants.errorColor,
                  ),
                ),
              ),
            ],
          ),
          if (explanation != null) ...[
            const SizedBox(height: 8),
            Text(
              explanation!,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: isCorrect
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }
}

/// Option tile widget for multiple choice questions
class OptionTile extends StatelessWidget {
  final String option;
  final bool isSelected;
  final bool isCorrect;
  final bool hasAnswered;
  final VoidCallback? onTap;

  const OptionTile({
    required this.option,
    required this.isSelected,
    required this.isCorrect,
    required this.hasAnswered,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    Color? borderColor;

    if (hasAnswered) {
      if (isCorrect) {
        backgroundColor = AppConstants.successColor.withOpacity(0.1);
        borderColor = AppConstants.successColor;
      } else if (isSelected) {
        backgroundColor = AppConstants.errorColor.withOpacity(0.1);
        borderColor = AppConstants.errorColor;
      }
    } else if (isSelected) {
      backgroundColor = AppConstants.primaryColor.withOpacity(0.1);
      borderColor = AppConstants.primaryColor;
    }

    return GestureDetector(
      onTap: hasAnswered ? null : onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasAnswered && isCorrect)
              const Icon(Icons.check_circle, color: AppConstants.successColor),
            if (hasAnswered && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: AppConstants.errorColor),
          ],
        ),
      ),
    );
  }
}
