import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../widgets/convertible_text.dart';

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

  final List<Map<String, dynamic>> _mockGrammarPoints = [
    {
      'title_ko': '은/는',
      'title_zh': '主题助词',
      'rule': '은/는 用于标记句子的主题。\n- 前一个字以辅音结尾时使用 은\n- 前一个字以元音结尾时使用 는',
      'chinese_comparison': {
        'title': '与中文对比',
        'korean': '저는 학생입니다',
        'chinese': '我是学生',
        'explanation': '中文"是"表达身份，韩语用"是"+ 은/는 标记主题',
      },
      'examples': [
        {
          'korean': '저는 학생입니다',
          'chinese': '我是学生',
          'highlight': '는',
          'explanation': '"저"以元音结尾，使用"는"',
        },
        {
          'korean': '책은 재미있어요',
          'chinese': '书很有趣',
          'highlight': '은',
          'explanation': '"책"以辅音结尾，使用"은"',
        },
        {
          'korean': '선생님은 친절해요',
          'chinese': '老师很亲切',
          'highlight': '은',
          'explanation': '"선생님"以辅音结尾，使用"은"',
        },
      ],
      'exercise': {
        'question': '이것___ 사과예요',
        'question_zh': '这是苹果',
        'blank_word': '이것',
        'options': ['은', '는', '이', '가'],
        'correct': '은',
        'explanation': '"이것"以辅音 ㅅ 结尾，使用"은"',
      },
    },
    {
      'title_ko': '이/가',
      'title_zh': '主格助词',
      'rule': '이/가 用于标记句子的主语。\n- 前一个字以辅音结尾时使用 이\n- 前一个字以元音结尾时使用 가',
      'chinese_comparison': {
        'title': '与"은/는"的区别',
        'korean': '누가 왔어요? - 민수가 왔어요',
        'chinese': '谁来了？ - 民秀来了',
        'explanation': '回答疑问词时用 이/가，强调新信息',
      },
      'examples': [
        {
          'korean': '비가 와요',
          'chinese': '下雨了',
          'highlight': '가',
          'explanation': '"비"以元音结尾，使用"가"',
        },
        {
          'korean': '꽃이 예뻐요',
          'chinese': '花很漂亮',
          'highlight': '이',
          'explanation': '"꽃"以辅音结尾，使用"이"',
        },
        {
          'korean': '누가 왔어요?',
          'chinese': '谁来了？',
          'highlight': '가',
          'explanation': '疑问词"누구"使用"가"',
        },
      ],
      'exercise': {
        'question': '사과___ 맛있어요',
        'question_zh': '苹果很好吃',
        'blank_word': '사과',
        'options': ['은', '는', '이', '가'],
        'correct': '가',
        'explanation': '"사과"以元音结尾，作为主语使用"가"',
      },
    },
    {
      'title_ko': '을/를',
      'title_zh': '宾格助词',
      'rule': '을/를 用于标记句子的宾语（动作的对象）。\n- 前一个字以辅音结尾时使用 을\n- 前一个字以元音结尾时使用 를',
      'chinese_comparison': {
        'title': '与中文对比',
        'korean': '저는 한국어를 공부해요',
        'chinese': '我学习韩语',
        'explanation': '中文靠语序表达宾语，韩语用 을/를 标记',
      },
      'examples': [
        {
          'korean': '커피를 마셔요',
          'chinese': '喝咖啡',
          'highlight': '를',
          'explanation': '"커피"以元音结尾，使用"를"',
        },
        {
          'korean': '밥을 먹어요',
          'chinese': '吃饭',
          'highlight': '을',
          'explanation': '"밥"以辅音结尾，使用"을"',
        },
        {
          'korean': '책을 읽어요',
          'chinese': '看书',
          'highlight': '을',
          'explanation': '"책"以辅音结尾，使用"을"',
        },
      ],
      'exercise': {
        'question': '친구___ 만났어요',
        'question_zh': '见了朋友',
        'blank_word': '친구',
        'options': ['은', '는', '을', '를'],
        'correct': '를',
        'explanation': '"친구"以元音结尾，作为宾语使用"를"',
      },
    },
    {
      'title_ko': '이에요/예요',
      'title_zh': '判断句结尾',
      'rule': '이에요/예요 是"是"的敬语形式，用于判断句。\n- 名词以辅音结尾时使用 이에요\n- 名词以元音结尾时使用 예요',
      'chinese_comparison': {
        'title': '与中文对比',
        'korean': '저는 학생이에요',
        'chinese': '我是学生',
        'explanation': '中文用"是"连接，韩语用 이에요/예요',
      },
      'examples': [
        {
          'korean': '이것은 사과예요',
          'chinese': '这是苹果',
          'highlight': '예요',
          'explanation': '"사과"以元音结尾，使用"예요"',
        },
        {
          'korean': '저는 학생이에요',
          'chinese': '我是学生',
          'highlight': '이에요',
          'explanation': '"학생"以辅音结尾，使用"이에요"',
        },
        {
          'korean': '오늘은 월요일이에요',
          'chinese': '今天是星期一',
          'highlight': '이에요',
          'explanation': '"월요일"以辅音结尾，使用"이에요"',
        },
      ],
      'exercise': {
        'question': '이것은 물___',
        'question_zh': '这是水',
        'blank_word': '물',
        'options': ['이에요', '예요', '입니다', '아니에요'],
        'correct': '이에요',
        'explanation': '"물"以辅音结尾，使用"이에요"',
      },
    },
  ];

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
    if (_currentPointIndex < _mockGrammarPoints.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const Text(
            '语法讲解',
            style: TextStyle(
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
                '${_currentPointIndex + 1} / ${_mockGrammarPoints.length}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Grammar points navigation dots
              Row(
                children: List.generate(
                  _mockGrammarPoints.length,
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
              itemCount: _mockGrammarPoints.length,
              itemBuilder: (context, index) {
                return _buildGrammarPoint(
                  _mockGrammarPoints[index],
                  index,
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
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousPoint,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: const ConvertibleText('上一个'),
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
                    _currentPointIndex < _mockGrammarPoints.length - 1
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

  Widget _buildGrammarPoint(Map<String, dynamic> point, int pointIndex) {
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
          _buildRuleSection(point)
              .animate()
              .fadeIn(delay: 200.ms, duration: 500.ms)
              .slideX(begin: -0.2, end: 0, delay: 200.ms),

          const SizedBox(height: 24),

          // Chinese Comparison Section
          _buildChineseComparisonSection(point)
              .animate()
              .fadeIn(delay: 300.ms, duration: 500.ms)
              .slideX(begin: -0.2, end: 0, delay: 300.ms),

          const SizedBox(height: 24),

          // Examples Section
          _buildExamplesSection(point)
              .animate()
              .fadeIn(delay: 400.ms, duration: 500.ms)
              .slideY(begin: 0.2, end: 0, delay: 400.ms),

          const SizedBox(height: 24),

          // Exercise Section
          _buildExerciseSection(point, pointIndex)
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

  Widget _buildRuleSection(Map<String, dynamic> point) {
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
                '规则',
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

  Widget _buildChineseComparisonSection(Map<String, dynamic> point) {
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
                const Text(
                  '🇰🇷 韩语',
                  style: TextStyle(
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
                const Text(
                  '🇨🇳 中文',
                  style: TextStyle(
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

  Widget _buildExamplesSection(Map<String, dynamic> point) {
    final examples = point['examples'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '例句',
          style: TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          examples.length,
          (index) => _buildExampleCard(examples[index], index),
        ),
      ],
    );
  }

  Widget _buildExampleCard(Map<String, dynamic> example, int index) {
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
              '例 ${index + 1}',
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

  Widget _buildExerciseSection(Map<String, dynamic> point, int pointIndex) {
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
                '练习',
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
            '填空：',
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
                        isCorrect ? '太棒了！' : '正确答案是: ${exercise['correct']}',
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
