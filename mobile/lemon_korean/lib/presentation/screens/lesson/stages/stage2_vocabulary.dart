import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/media_helper.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../../data/models/vocabulary_model.dart';
import '../../../widgets/bilingual_text.dart';
import '../../../widgets/bookmark_button.dart';
import '../../../widgets/convertible_text.dart';

/// Stage 2: Vocabulary
/// Learn new words with flashcards and examples
class Stage2Vocabulary extends StatefulWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const Stage2Vocabulary({
    required this.lesson,
    this.stageData,
    required this.onNext,
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

  /// Load words from stageData (v2) or lesson content (v1) or mock data
  void _loadWords() {
    if (widget.stageData != null && widget.stageData!.containsKey('words')) {
      // v2 structure: use stageData
      _words = List<Map<String, dynamic>>.from(widget.stageData!['words']);
    } else if (widget.lesson.content != null) {
      // v1 structure: fallback to lesson content
      final vocabData = widget.lesson.content!['stage2_vocabulary'];
      _words = vocabData != null
          ? List<Map<String, dynamic>>.from(vocabData['words'])
          : _getMockWords();
    } else {
      _words = _getMockWords();
    }
  }

  /// Get mock words for fallback
  List<Map<String, dynamic>> _getMockWords() {
    return [
      {
        'korean': '안녕하세요',
        'chinese': '您好',
        'pinyin': 'nín hǎo',
        'image_url': null,
      },
      {
        'korean': '감사합니다',
        'chinese': '谢谢',
        'pinyin': 'xiè xie',
        'image_url': null,
      },
      {
        'korean': '죄송합니다',
        'chinese': '对不起',
        'pinyin': 'duì bu qǐ',
        'image_url': null,
      },
    ];
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
      chinese: word['chinese'] ?? '',
      pinyin: word['pinyin'],
      partOfSpeech: word['part_of_speech'] ?? 'noun',
      level: widget.lesson.level,
      imageUrl: word['image_url'],
      audioUrl: word['audio_url'],
      createdAt: DateTime.now(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppConstants.primaryColor.withOpacity(0.05),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 80,
              color: AppConstants.textHint,
            ),
            SizedBox(height: 8),
            ConvertibleText(
              '暂无图片',
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
    final word = _words[_currentWordIndex];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const BilingualText(
            chinese: '词汇学习',
            korean: '단어 학습',
            chineseStyle: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Word Counter
          Text(
            '${_currentWordIndex + 1} / ${_words.length}',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),

          const Spacer(),

          // Flashcard with Bookmark Button
          Stack(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                // Image or Placeholder
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(
                      color: AppConstants.primaryColor.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    child: word['imageUrl'] != null
                        ? MediaHelper.buildImage(
                            word['imageUrl']!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            placeholder: _buildImagePlaceholder(),
                            errorWidget: _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                ),

                const SizedBox(height: 30),

                // Korean
                Text(
                  word['korean']!,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Chinese
                ConvertibleText(
                  word['chinese']!,
                  style: const TextStyle(
                    fontSize: 32,
                    color: AppConstants.textSecondary,
                  ),
                ),

                const SizedBox(height: 12),

                    // Pinyin
                    Text(
                      word['pinyin']!,
                      style: const TextStyle(
                        fontSize: 20,
                        color: AppConstants.textHint,
                        fontStyle: FontStyle.italic,
                      ),
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

          const Spacer(),

          // Navigation Buttons
          Row(
            children: [
              // Previous Button
              if (_currentWordIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousWord,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: const InlineBilingualText(
                      chinese: '上一个',
                      korean: '이전',
                    ),
                  ),
                ),

              if (_currentWordIndex > 0) const SizedBox(width: 16),

              // Next Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _nextWord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                  child: InlineBilingualText(
                    chinese: _currentWordIndex < _words.length - 1
                        ? '下一个'
                        : '继续',
                    korean: _currentWordIndex < _words.length - 1
                        ? '다음'
                        : '계속',
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
