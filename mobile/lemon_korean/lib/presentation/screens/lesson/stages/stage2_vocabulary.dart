import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';

/// Stage 2: Vocabulary
/// Learn new words with flashcards and examples
class Stage2Vocabulary extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Stage2Vocabulary({
    super.key,
    required this.lesson,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  State<Stage2Vocabulary> createState() => _Stage2VocabularyState();
}

class _Stage2VocabularyState extends State<Stage2Vocabulary> {
  int _currentWordIndex = 0;
  final List<Map<String, String>> _mockWords = [
    {'korean': '안녕하세요', 'chinese': '您好', 'pinyin': 'nín hǎo'},
    {'korean': '감사합니다', 'chinese': '谢谢', 'pinyin': 'xiè xie'},
    {'korean': '죄송합니다', 'chinese': '对不起', 'pinyin': 'duì bu qǐ'},
  ];

  void _nextWord() {
    if (_currentWordIndex < _mockWords.length - 1) {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final word = _mockWords[_currentWordIndex];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const Text(
            '词汇学习',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Word Counter
          Text(
            '${_currentWordIndex + 1} / ${_mockWords.length}',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
            ),
          ),

          const Spacer(),

          // Flashcard
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
                Text(
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
                    child: const Text('上一个'),
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
                  child: Text(
                    _currentWordIndex < _mockWords.length - 1
                        ? '下一个'
                        : '继续',
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
