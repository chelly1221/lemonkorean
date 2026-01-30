import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../core/constants/app_constants.dart';
import 'quiz_shared.dart';

/// Word Order Question Widget
/// Sentence ordering/rearrangement question
class WordOrderQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(List<String>) onAnswer;
  final List<String>? userAnswer;
  final bool? isCorrect;

  const WordOrderQuestion({
    required this.question,
    required this.onAnswer,
    this.userAnswer,
    this.isCorrect,
    super.key,
  });

  @override
  State<WordOrderQuestion> createState() => _WordOrderQuestionState();
}

class _WordOrderQuestionState extends State<WordOrderQuestion> {
  List<String> _orderedWords = [];
  List<String> _availableWords = [];

  @override
  void initState() {
    super.initState();
    if (widget.userAnswer != null) {
      _orderedWords = List.from(widget.userAnswer!);
      _availableWords = [];
    } else {
      _availableWords = List.from(widget.question['words'] as List<String>);
      _availableWords.shuffle();
    }
  }

  void _addWord(String word) {
    setState(() {
      _orderedWords.add(word);
      _availableWords.remove(word);
    });
    if (_availableWords.isEmpty) {
      widget.onAnswer(_orderedWords);
    }
  }

  void _removeWord(String word) {
    if (widget.userAnswer != null) return;

    setState(() {
      _orderedWords.remove(word);
      _availableWords.add(word);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswered = widget.userAnswer != null;
    final correctOrder = widget.question['correct'] as List;

    return Column(
      children: [
        const QuestionTypeBadge(
          label: '排序',
          icon: Icons.reorder,
          color: Colors.orange,
        ),

        const SizedBox(height: 20),

        Text(
          widget.question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        // Translation hint
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Text(
            widget.question['translation'],
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.orange.shade700,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Ordered words area
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: hasAnswered
                ? (widget.isCorrect ?? false)
                    ? AppConstants.successColor.withOpacity(0.1)
                    : AppConstants.errorColor.withOpacity(0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: hasAnswered
                  ? (widget.isCorrect ?? false)
                      ? AppConstants.successColor
                      : AppConstants.errorColor
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _orderedWords.map((word) {
              return GestureDetector(
                onTap: () => _removeWord(word),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 30),

        // Available words
        if (_availableWords.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availableWords.map((word) {
              return GestureDetector(
                onTap: () => _addWord(word),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

        if (hasAnswered) ...[
          const SizedBox(height: 20),
          _buildFeedback(correctOrder),
        ],
      ],
    );
  }

  Widget _buildFeedback(List correctOrder) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: (widget.isCorrect ?? false)
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
                (widget.isCorrect ?? false)
                    ? Icons.celebration
                    : Icons.info_outline,
                color: (widget.isCorrect ?? false)
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
              const SizedBox(width: 12),
              Text(
                (widget.isCorrect ?? false) ? '太棒了！' : '正确顺序是:',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: (widget.isCorrect ?? false)
                      ? AppConstants.successColor
                      : AppConstants.errorColor,
                ),
              ),
            ],
          ),
          if (!(widget.isCorrect ?? false)) ...[
            const SizedBox(height: 8),
            Text(
              correctOrder.join(' '),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.errorColor,
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
