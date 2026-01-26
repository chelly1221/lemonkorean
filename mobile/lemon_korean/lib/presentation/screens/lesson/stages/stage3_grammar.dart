import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../widgets/bilingual_text.dart';

/// Stage 3: Grammar
/// Grammar explanations with examples
class Stage3Grammar extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const Stage3Grammar({
    required this.lesson, required this.onNext, required this.onPrevious, super.key,
  });

  @override
  State<Stage3Grammar> createState() => _Stage3GrammarState();
}

class _Stage3GrammarState extends State<Stage3Grammar> {
  int _currentPointIndex = 0;
  final List<Map<String, dynamic>> _mockGrammarPoints = [
    {
      'title': '助词 은/는',
      'titleZh': '主题助词',
      'explanation': '은/는 用于标记句子的主题。当前一个字以辅音结尾时使用 은，以元音结尾时使用 는。',
      'examples': [
        {'korean': '저는 학생입니다', 'chinese': '我是学生', 'highlight': '는'},
        {'korean': '책은 재미있어요', 'chinese': '书很有趣', 'highlight': '은'},
      ],
    },
    {
      'title': '이에요/예요',
      'titleZh': '敬语结尾',
      'explanation': '이에요/예요 是"是"的敬语形式。当名词以辅音结尾时使用 이에요，以元音结尾时使用 예요。',
      'examples': [
        {'korean': '학생이에요', 'chinese': '是学生', 'highlight': '이에요'},
        {'korean': '선생님이에요', 'chinese': '是老师', 'highlight': '이에요'},
      ],
    },
    {
      'title': '疑问词 뭐',
      'titleZh': '什么',
      'explanation': '뭐 是"什么"的口语形式，用于询问事物。正式场合使用 무엇。',
      'examples': [
        {'korean': '이게 뭐예요?', 'chinese': '这是什么？', 'highlight': '뭐'},
        {'korean': '뭐 하세요?', 'chinese': '在做什么？', 'highlight': '뭐'},
      ],
    },
  ];

  void _nextPoint() {
    if (_currentPointIndex < _mockGrammarPoints.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    final point = _mockGrammarPoints[_currentPointIndex];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const BilingualText(
            chinese: '语法讲解',
            korean: '문법 설명',
            chineseStyle: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Grammar Point Counter
          Text(
            '${_currentPointIndex + 1} / ${_mockGrammarPoints.length}',
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
                      color: Colors.black.withOpacity(0.1),
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
                      color: AppConstants.primaryColor.withOpacity(0.2),
                    ),

                    const SizedBox(height: 24),

                    // Explanation
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.1),
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
                    const BilingualText(
                      chinese: '例句',
                      korean: '예문',
                      chineseStyle: TextStyle(
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
                    child: const InlineBilingualText(
                      chinese: '上一个',
                      korean: '이전',
                    ),
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
                  child: InlineBilingualText(
                    chinese: _currentPointIndex < _mockGrammarPoints.length - 1
                        ? '下一个'
                        : '继续',
                    korean: _currentPointIndex < _mockGrammarPoints.length - 1
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
