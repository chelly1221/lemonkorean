import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Grammar Stage with Interactive Exercises
/// Animated grammar explanations with Chinese comparisons and practice
class GrammarStage extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const GrammarStage({
    required this.lesson, required this.onNext, required this.onPrevious, super.key,
  });

  @override
  State<GrammarStage> createState() => _GrammarStageState();
}

class _GrammarStageState extends State<GrammarStage> {
  final PageController _pageController = PageController();
  int _currentPointIndex = 0;
  final Map<int, String?> _userAnswers = {};
  final Map<int, bool> _showExerciseFeedback = {};
  List<Map<String, dynamic>> _grammarPoints = [];
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _loadGrammarPoints();
  }

  /// Load grammar points from lesson content
  /// Returns empty list if no data available - UI shows "no content" message
  void _loadGrammarPoints() {
    if (widget.lesson.content != null) {
      final grammarData = widget.lesson.content!['grammar'];
      if (grammarData != null && grammarData['grammar_points'] != null) {
        _grammarPoints = List<Map<String, dynamic>>.from(grammarData['grammar_points']);
      } else {
        // Try alternate structure
        final altGrammarData = widget.lesson.content!['stage3_grammar'];
        _grammarPoints = altGrammarData != null && altGrammarData['grammar_points'] != null
            ? List<Map<String, dynamic>>.from(altGrammarData['grammar_points'])
            : [];
      }
    } else {
      // No data available - return empty list, UI will show appropriate message
      _grammarPoints = [];
    }
    _initialized = true;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPointIndex = index;
    });
  }

  void _nextPoint() {
    if (_currentPointIndex < _grammarPoints.length - 1) {
      _pageController.animateToPage(
        _currentPointIndex + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onNext();
    }
  }

  void _previousPoint() {
    if (_currentPointIndex > 0) {
      _pageController.animateToPage(
        _currentPointIndex - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _checkAnswer(int pointIndex, String answer) {
    setState(() {
      _userAnswers[pointIndex] = answer;
      _showExerciseFeedback[pointIndex] = true;
    });
  }

  /// Build empty state widget when no grammar data is available
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            size: 80,
            color: AppConstants.textHint,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noGrammar,
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

    // Handle empty grammar points case
    if (_grammarPoints.isEmpty) {
      return _buildEmptyState(l10n);
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          Text(
            l10n.grammarExplanation,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Progress Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentPointIndex + 1} / ${_grammarPoints.length}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Grammar points navigation dots
              Row(
                children: List.generate(
                  _grammarPoints.length,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == _currentPointIndex
                          ? AppConstants.primaryColor
                          : Colors.grey.shade300,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // PageView with grammar points
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _grammarPoints.length,
              itemBuilder: (context, index) {
                return _buildGrammarPoint(
                  _grammarPoints[index],
                  index,
                  l10n,
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Navigation Buttons
          Row(
            children: [
              // Previous Button
              if (_currentPointIndex > 0)
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    return Expanded(
                      child: OutlinedButton(
                        onPressed: _previousPoint,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingMedium,
                          ),
                        ),
                        child: Text(l10n.previousItem),
                      ),
                    );
                  },
                ),

              if (_currentPointIndex > 0) const SizedBox(width: 16),

              // Next Button
              Builder(
                builder: (context) {
                  final l10n = AppLocalizations.of(context)!;
                  return Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _nextPoint,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.paddingMedium,
                        ),
                      ),
                      child: Text(
                        _currentPointIndex < _grammarPoints.length - 1
                            ? l10n.nextItem
                            : l10n.continueBtn,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrammarPoint(Map<String, dynamic> point, int pointIndex, AppLocalizations l10n) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          _buildTitleSection(point)
              .animate()
              .fadeIn(delay: 100.ms, duration: 500.ms)
              .slideX(begin: -0.2, end: 0, delay: 100.ms),

          const SizedBox(height: 24),

          // Rule Section
          _buildRuleSection(point, l10n)
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideX(begin: -0.2, end: 0, delay: 200.ms),

          const SizedBox(height: 24),

          // Chinese Comparison Section
          _buildChineseComparisonSection(point, l10n)
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideX(begin: -0.2, end: 0, delay: 300.ms),

          const SizedBox(height: 24),

          // Examples Section
          _buildExamplesSection(point, l10n)
              .animate()
              .fadeIn(delay: 400.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0, delay: 400.ms),

          const SizedBox(height: 24),

          // Exercise Section
          _buildExerciseSection(point, pointIndex, l10n)
              .animate()
              .fadeIn(delay: 500.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0, delay: 500.ms),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTitleSection(Map<String, dynamic> point) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor.withOpacity(0.2),
            AppConstants.primaryColor.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Column(
        children: [
          // Korean Title
          Text(
            point['title_ko'],
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          // Chinese Title
          Text(
            point['title_zh'],
            style: const TextStyle(
              fontSize: 20,
              color: AppConstants.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRuleSection(Map<String, dynamic> point, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: Colors.blue.shade200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.blue.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.rules,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            point['rule'],
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChineseComparisonSection(Map<String, dynamic> point, AppLocalizations l10n) {
    final comparison = point['chinese_comparison'] as Map<String, dynamic>;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: Colors.purple.shade200,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.compare_arrows,
                color: Colors.purple.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                comparison['title'],
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Korean
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.koreanLanguage,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comparison['korean'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Chinese
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.chineseLanguage,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comparison['chinese'],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Explanation
          Text(
            '💡 ${comparison['explanation']}',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.purple.shade700,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesSection(Map<String, dynamic> point, AppLocalizations l10n) {
    final examples = point['examples'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.exampleSentences,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          examples.length,
          (index) => _buildExampleCard(examples[index], index, l10n),
        ),
      ],
    );
  }

  Widget _buildExampleCard(Map<String, dynamic> example, int index, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Example number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.exampleNumber(index + 1),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Korean with highlight
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                height: 1.4,
              ),
              children: _buildHighlightedText(
                example['korean'],
                example['highlight'],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Chinese translation
          Text(
            example['chinese'],
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),

          const SizedBox(height: 8),

          // Explanation
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Text(
              '📌 ${example['explanation']}',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseSection(Map<String, dynamic> point, int pointIndex, AppLocalizations l10n) {
    final exercise = point['exercise'] as Map<String, dynamic>;
    final userAnswer = _userAnswers[pointIndex];
    final showFeedback = _showExerciseFeedback[pointIndex] ?? false;
    final isCorrect = userAnswer == exercise['correct'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.shade50,
            Colors.green.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: Colors.green.shade300,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note,
                color: Colors.green.shade700,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.practice,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Question
          Text(
            l10n.fillInBlankPrompt,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.green.shade700,
            ),
          ),

          const SizedBox(height: 8),

          // Korean question with blank
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              children: _buildQuestionText(exercise['question']),
            ),
          ),

          const SizedBox(height: 8),

          // Chinese translation
          Text(
            exercise['question_zh'],
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),

          const SizedBox(height: 16),

          // Options
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (exercise['options'] as List).map((option) {
              final isSelected = userAnswer == option;
              final isCorrectOption = option == exercise['correct'];

              Color? backgroundColor;
              Color? borderColor;
              Color? textColor;

              if (showFeedback) {
                if (isCorrectOption) {
                  backgroundColor = AppConstants.successColor.withOpacity(0.2);
                  borderColor = AppConstants.successColor;
                  textColor = AppConstants.successColor;
                } else if (isSelected && !isCorrectOption) {
                  backgroundColor = AppConstants.errorColor.withOpacity(0.2);
                  borderColor = AppConstants.errorColor;
                  textColor = AppConstants.errorColor;
                }
              } else if (isSelected) {
                backgroundColor = AppConstants.primaryColor.withOpacity(0.2);
                borderColor = AppConstants.primaryColor;
                textColor = AppConstants.primaryColor;
              }

              return GestureDetector(
                onTap: showFeedback
                    ? null
                    : () => _checkAnswer(pointIndex, option),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        option,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor ?? Colors.black87,
                        ),
                      ),
                      if (showFeedback && isCorrectOption) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.check_circle,
                          color: AppConstants.successColor,
                          size: 20,
                        ),
                      ],
                      if (showFeedback && isSelected && !isCorrectOption) ...[
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.cancel,
                          color: AppConstants.errorColor,
                          size: 20,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          // Feedback
          if (showFeedback) ...[
            const SizedBox(height: 16),
            Container(
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
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isCorrect ? l10n.excellent : l10n.correctAnswerIs(exercise['correct']),
                        style: TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          fontWeight: FontWeight.bold,
                          color: isCorrect
                              ? AppConstants.successColor
                              : AppConstants.errorColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    exercise['explanation'],
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: isCorrect
                          ? AppConstants.successColor
                          : AppConstants.errorColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(String text, String highlight) {
    final parts = text.split(highlight);
    final spans = <TextSpan>[];

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }
      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: highlight,
            style: const TextStyle(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.bold,
              backgroundColor: Color(0xFFFFEB3B),
            ),
          ),
        );
      }
    }

    return spans;
  }

  List<TextSpan> _buildQuestionText(String question) {
    final parts = question.split('___');
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
              fontWeight: FontWeight.bold,
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
