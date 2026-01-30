import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import 'quiz_shared.dart';

/// Pronunciation Question Widget
/// Korean pronunciation selection question
class PronunciationQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const PronunciationQuestion({
    required this.question,
    required this.onAnswer,
    this.userAnswer,
    this.isCorrect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnswered = userAnswer != null;
    final options = question['options'] as List;
    final correct = question['correct'] as String;

    return Column(
      children: [
        const QuestionTypeBadge(
          label: '发音',
          icon: Icons.record_voice_over,
          color: Colors.red,
        ),

        const SizedBox(height: 20),

        Text(
          question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        // Korean text
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.shade50,
                Colors.red.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Text(
            question['korean'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Options (pronunciation)
        ...options.map((option) => _buildPronunciationOption(
              option: option,
              isSelected: userAnswer == option,
              isCorrect: option == correct,
              hasAnswered: hasAnswered,
              onTap: () => onAnswer(option),
            )),

        if (hasAnswered)
          QuestionFeedback(
            isCorrect: isCorrect ?? false,
            correctAnswer: correct,
          ),
      ],
    );
  }

  Widget _buildPronunciationOption({
    required String option,
    required bool isSelected,
    required bool isCorrect,
    required bool hasAnswered,
    required VoidCallback onTap,
  }) {
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
                  fontStyle: FontStyle.italic,
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
