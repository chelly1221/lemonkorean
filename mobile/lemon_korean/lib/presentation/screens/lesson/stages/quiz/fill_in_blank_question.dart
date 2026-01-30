import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import 'quiz_shared.dart';

/// Fill in Blank Question Widget
/// Grammar particle or word fill-in question
class FillInBlankQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const FillInBlankQuestion({
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
          label: '填空',
          icon: Icons.edit_note,
          color: Colors.green,
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

        // Sentence with blank
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: _buildSentenceSpans(question['sentence']),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                question['translation'],
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Options
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: options.map((option) {
            final isSelected = userAnswer == option;
            final isCorrectOption = option == correct;

            Color? backgroundColor;
            Color? borderColor;

            if (hasAnswered) {
              if (isCorrectOption) {
                backgroundColor = AppConstants.successColor.withOpacity(0.2);
                borderColor = AppConstants.successColor;
              } else if (isSelected) {
                backgroundColor = AppConstants.errorColor.withOpacity(0.2);
                borderColor = AppConstants.errorColor;
              }
            } else if (isSelected) {
              backgroundColor = AppConstants.primaryColor.withOpacity(0.2);
              borderColor = AppConstants.primaryColor;
            }

            return GestureDetector(
              onTap: hasAnswered ? null : () => onAnswer(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: borderColor ?? Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        if (hasAnswered) ...[
          const SizedBox(height: 20),
          QuestionFeedback(
            isCorrect: isCorrect ?? false,
            correctAnswer: correct,
            explanation: question['explanation'],
          ),
        ],
      ],
    );
  }

  List<TextSpan> _buildSentenceSpans(String sentence) {
    final parts = sentence.split('___');
    final spans = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }
      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: ' ___ ',
            style: TextStyle(
              color: Colors.green.shade700,
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          ),
        );
      }
    }

    return spans;
  }
}
