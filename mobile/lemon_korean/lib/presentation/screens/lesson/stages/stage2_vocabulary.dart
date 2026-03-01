import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/media_helper.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../data/models/vocabulary_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../widgets/bookmark_button.dart';

/// Stage 2: Vocabulary
/// Learn new words with flashcards and examples
class Stage2Vocabulary extends StatefulWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const Stage2Vocabulary({
    required this.lesson,
    required this.onNext,
    this.stageData,
    this.onPrevious,
    super.key,
  });

  @override
  State<Stage2Vocabulary> createState() => _Stage2VocabularyState();
}

class _Stage2VocabularyState extends State<Stage2Vocabulary> {
  int _currentWordIndex = 0;
  late List<Map<String, dynamic>> _words;

  @override
  void initState() {
    super.initState();
    _loadWords();
  }

  /// Load words from stageData (v2) or lesson content (v1)
  /// Returns empty list if no data available - UI shows "no content" message
  void _loadWords() {
    if (widget.stageData != null && widget.stageData!.containsKey('words')) {
      // v2 structure: use stageData
      _words = List<Map<String, dynamic>>.from(widget.stageData!['words']);
    } else if (widget.lesson.content != null) {
      // v1 structure: fallback to lesson content
      final vocabData = widget.lesson.content!['stage2_vocabulary'];
      _words = vocabData != null
          ? List<Map<String, dynamic>>.from(vocabData['words'])
          : [];
    } else {
      // No data available - return empty list, UI will show appropriate message
      _words = [];
    }
  }

  void _nextWord() {
    if (_currentWordIndex < _words.length - 1) {
      setState(() {
        _currentWordIndex++;
      });
    } else {
      widget.onNext();
    }
  }

  void _previousWord() {
    if (_currentWordIndex > 0) {
      setState(() {
        _currentWordIndex--;
      });
    } else if (widget.onPrevious != null) {
      widget.onPrevious!();
    }
  }

  /// Convert word map to VocabularyModel for BookmarkButton
  VocabularyModel _convertToVocabularyModel(Map<String, dynamic> word) {
    return VocabularyModel(
      id: word['id'] ?? 0,
      korean: word['korean'] ?? '',
      translation: word['translation'] ?? word['chinese'] ?? '',
      pronunciation: word['pronunciation'] ?? word['pinyin'],
      partOfSpeech: word['part_of_speech'] ?? 'noun',
      level: widget.lesson.level,
      imageUrl: word['image_url'],
      audioUrl: word['audio_url'],
      createdAt: DateTime.now(),
    );
  }

  /// Build empty state widget when no vocabulary data is available
  Widget _buildEmptyState(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.library_books_outlined,
            size: 80,
            color: AppConstants.textHint,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noVocabulary,
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

  Widget _buildImagePlaceholder(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: AppConstants.primaryColor.withValues(alpha: 0.05),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.image_outlined,
              size: 80,
              color: AppConstants.textHint,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.noImage,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Handle empty words case
    if (_words.isEmpty) {
      return _buildEmptyState(l10n);
    }

    final word = _words[_currentWordIndex];

    return Column(
      children: [
        // Header: Title + Counter
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingMedium, AppConstants.paddingSmall,
            AppConstants.paddingMedium, 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.vocabularyLearning,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_currentWordIndex + 1} / ${_words.length}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // Flashcard (scrollable area)
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingLarge),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Image or Placeholder
                      Container(
                        height: 140,
                        width: 140,
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          border: Border.all(
                            color: AppConstants.primaryColor.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                          child: word['imageUrl'] != null
                              ? MediaHelper.buildImage(
                                  word['imageUrl']!,
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.cover,
                                  placeholder: _buildImagePlaceholder(context),
                                  errorWidget: _buildImagePlaceholder(context),
                                )
                              : _buildImagePlaceholder(context),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Korean
                      Text(
                        word['korean']!,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 12),

                      // Chinese
                      Text(
                        word['chinese']!,
                        style: const TextStyle(
                          fontSize: 28,
                          color: AppConstants.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      // Pinyin
                      Text(
                        word['pinyin']!,
                        style: const TextStyle(
                          fontSize: 18,
                          color: AppConstants.textHint,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Bookmark Button (Top-Right Corner)
                Positioned(
                  top: 8,
                  right: 8,
                  child: BookmarkButton(
                    vocabulary: _convertToVocabularyModel(word),
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Navigation Buttons (fixed at bottom)
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppConstants.paddingMedium, 8,
            AppConstants.paddingMedium, AppConstants.paddingMedium,
          ),
          child: Row(
            children: [
              // Previous Button
              if (_currentWordIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousWord,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingSmall + 4,
                      ),
                    ),
                    child: Text(l10n.previousItem),
                  ),
                ),

              if (_currentWordIndex > 0) const SizedBox(width: 12),

              // Next Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _nextWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingSmall + 4,
                    ),
                  ),
                  child: Text(
                    _currentWordIndex < _words.length - 1
                        ? l10n.nextItem
                        : l10n.continueBtn,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
