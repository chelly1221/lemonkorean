import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Stage 3: Grammar
/// Grammar explanations with examples
class Stage3Grammar extends StatefulWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const Stage3Grammar({
    required this.lesson,
    required this.onNext,
    this.stageData,
    this.onPrevious,
    super.key,
  });

  @override
  State<Stage3Grammar> createState() => _Stage3GrammarState();
}

class _Stage3GrammarState extends State<Stage3Grammar> {
  int _currentPointIndex = 0;
  List<Map<String, dynamic>> _grammarPoints = [];
  bool _initialized = false;

  List<Map<String, dynamic>> get _currentGrammarPoints => _grammarPoints;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _loadGrammarPoints();
      _initialized = true;
    }
  }

  /// Load grammar points from stageData or lesson content
  /// Returns empty list if no data available - UI shows "no content" message
  void _loadGrammarPoints() {
    if (widget.stageData != null && widget.stageData!.containsKey('grammar_points')) {
      _grammarPoints = List<Map<String, dynamic>>.from(widget.stageData!['grammar_points']);
    } else if (widget.lesson.content != null) {
      final grammarData = widget.lesson.content!['stage3_grammar'];
      _grammarPoints = grammarData != null
          ? List<Map<String, dynamic>>.from(grammarData['grammar_points'] ?? [])
          : [];
    } else {
      // No data available - return empty list, UI will show appropriate message
      _grammarPoints = [];
    }
  }

  void _nextPoint() {
    if (_currentPointIndex < _currentGrammarPoints.length - 1) {
      setState(() {
        _currentPointIndex++;
      });
    } else {
      widget.onNext();
    }
  }

  void _previousPoint() {
    if (_currentPointIndex > 0) {
      setState(() {
        _currentPointIndex--;
      });
    }
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
    if (_currentGrammarPoints.isEmpty) {
      return _buildEmptyState(l10n);
    }

    final point = _currentGrammarPoints[_currentPointIndex];

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

          // Grammar Point Counter
          Text(
            '${_currentPointIndex + 1} / ${_currentGrammarPoints.length}',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),

          const SizedBox(height: 20),

          // Grammar Point Card
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Korean Title
                    Text(
                      point['title'],
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Chinese Title
                    Text(
                      point['titleZh'],
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppConstants.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Divider
                    Container(
                      height: 2,
                      color: AppConstants.primaryColor.withValues(alpha: 0.2),
                    ),

                    const SizedBox(height: 24),

                    // Explanation
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusMedium,
                        ),
                      ),
                      child: Text(
                        point['explanation'],
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeMedium,
                          height: 1.6,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Examples Label
                    Text(
                      l10n.exampleSentences,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Examples
                    ...List.generate(
                      (point['examples'] as List).length,
                      (index) {
                        final example = point['examples'][index];
                        return _buildExampleCard(
                          korean: example['korean'],
                          chinese: example['chinese'],
                          highlight: example['highlight'],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Navigation Buttons
          Row(
            children: [
              // Previous Button
              if (_currentPointIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousPoint,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: Text(l10n.previousItem),
                  ),
                ),

              if (_currentPointIndex > 0) const SizedBox(width: 16),

              // Next Button
              Expanded(
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
                    _currentPointIndex < _currentGrammarPoints.length - 1
                        ? l10n.nextItem
                        : l10n.continueBtn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard({
    required String korean,
    required String chinese,
    required String highlight,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Korean with highlight
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                height: 1.4,
              ),
              children: _buildHighlightedText(korean, highlight),
            ),
          ),

          const SizedBox(height: 8),

          // Chinese
          Text(
            chinese,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),
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
}
