import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Stage 4: Practice
/// Interactive exercises to practice vocabulary and grammar
class Stage4Practice extends StatefulWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const Stage4Practice({
    required this.lesson,
    required this.onNext,
    this.stageData,
    this.onPrevious,
    super.key,
  });

  @override
  State<Stage4Practice> createState() => _Stage4PracticeState();
}

class _Stage4PracticeState extends State<Stage4Practice> {
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _correctCount = 0;
  bool _initialized = false;

  List<Map<String, dynamic>> _questions = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initializeQuestions();
      _initialized = true;
    }
  }

  /// Load questions from stageData or lesson content
  /// Returns empty list if no data available - UI shows "no content" message
  void _initializeQuestions() {
    // Load questions from stageData or lesson content
    List<Map<String, dynamic>> sourceQuestions;
    if (widget.stageData != null && widget.stageData!.containsKey('exercises')) {
      sourceQuestions = List<Map<String, dynamic>>.from(widget.stageData!['exercises']);
    } else if (widget.lesson.content != null) {
      final practiceData = widget.lesson.content!['stage4_practice'];
      sourceQuestions = practiceData != null
          ? List<Map<String, dynamic>>.from(practiceData['exercises'] ?? [])
          : [];
    } else {
      // No data available - return empty list, UI will show appropriate message
      sourceQuestions = [];
    }

    // Keep question order (no shuffle)
    _questions = List.from(sourceQuestions);

    // Shuffle only the options for each question
    for (var question in _questions) {
      if (question['options'] != null && question['options'] is List) {
        question['options'] = List.from(question['options'])..shuffle();
      }
    }
  }

  void _checkAnswer() {
    if (_selectedAnswer == null) return;

    setState(() {
      _showResult = true;
      if (_selectedAnswer == _questions[_currentQuestionIndex]['correctAnswer']) {
        _correctCount++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      widget.onNext();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswer = null;
        _showResult = false;
        // Don't decrease correct count when going back
      });
    }
  }

  /// Build empty state widget when no practice data is available
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.quiz_outlined,
            size: 80,
            color: AppConstants.textHint,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noPractice,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: widget.onNext,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: AppConstants.paddingMedium,
              ),
            ),
            child: Text(l10n.continueBtn),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Handle empty questions case
    if (_questions.isEmpty) {
      return _buildEmptyState(l10n);
    }

    final question = _questions[_currentQuestionIndex];
    final isCorrect = _selectedAnswer == question['correctAnswer'];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          Text(
            l10n.practice,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Question Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentQuestionIndex + 1} / ${_questions.length}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondary,
                ),
              ),
              // Correct Count
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppConstants.successColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_correctCount',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.successColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Question Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
            child: Text(
              question['question'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: (question['options'] as List).length,
              itemBuilder: (context, index) {
                final option = question['options'][index];
                final isSelected = _selectedAnswer == option;
                final isCorrectOption = option == question['correctAnswer'];

                Color? backgroundColor;
                Color? borderColor;
                Color? textColor;

                if (_showResult) {
                  if (isCorrectOption) {
                    backgroundColor = AppConstants.successColor.withValues(alpha: 0.1);
                    borderColor = AppConstants.successColor;
                    textColor = AppConstants.successColor;
                  } else if (isSelected && !isCorrectOption) {
                    backgroundColor = AppConstants.errorColor.withValues(alpha: 0.1);
                    borderColor = AppConstants.errorColor;
                    textColor = AppConstants.errorColor;
                  }
                } else if (isSelected) {
                  backgroundColor = AppConstants.primaryColor.withValues(alpha: 0.1);
                  borderColor = AppConstants.primaryColor;
                }

                return GestureDetector(
                  onTap: _showResult ? null : () {
                    setState(() {
                      _selectedAnswer = option;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: backgroundColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
                      border: Border.all(
                        color: borderColor ?? Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Option Circle
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? (borderColor ?? AppConstants.primaryColor)
                                : Colors.transparent,
                            border: Border.all(
                              color: borderColor ?? Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              String.fromCharCode(65 + index), // A, B, C, D
                              style: TextStyle(
                                fontSize: AppConstants.fontSizeMedium,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.grey,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        // Option Text
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: textColor ?? Colors.black87,
                            ),
                          ),
                        ),

                        // Result Icon
                        if (_showResult && (isCorrectOption || isSelected))
                          Icon(
                            isCorrectOption
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: isCorrectOption
                                ? AppConstants.successColor
                                : AppConstants.errorColor,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Result Message
          if (_showResult)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppConstants.successColor.withValues(alpha: 0.1)
                    : AppConstants.errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Row(
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
                      isCorrect ? l10n.correctFeedback : l10n.incorrectFeedback,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: isCorrect
                            ? AppConstants.successColor
                            : AppConstants.errorColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Action Buttons
          Row(
            children: [
              // Previous Button
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: Text(l10n.previousQuestion),
                  ),
                ),

              if (_currentQuestionIndex > 0) const SizedBox(width: 16),

              // Check/Next Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _showResult ? _nextQuestion : _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                  child: Text(
                    _showResult
                        ? (_currentQuestionIndex < _questions.length - 1
                            ? l10n.nextQuestionBtn
                            : l10n.continueBtn)
                        : l10n.checkAnswerBtn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
