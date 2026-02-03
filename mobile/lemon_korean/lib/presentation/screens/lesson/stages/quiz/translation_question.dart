import 'package:flutter/material.dart';

import '../../../../../core/constants/app_constants.dart';
import '../../../../../l10n/generated/app_localizations.dart';
import 'quiz_shared.dart';

/// Translation Question Widget
/// Korean to Chinese translation question
class TranslationQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const TranslationQuestion({
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

    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        QuestionTypeBadge(
          label: l10n.translation,
          icon: Icons.translate,
          color: Colors.purple,
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
                Colors.purple.shade50,
                Colors.purple.shade100,
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

        // Options
        ...options.map((option) => OptionTile(
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
}
