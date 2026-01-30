import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../widgets/bilingual_text.dart';

/// Stage 4: Practice
/// Interactive exercises to practice vocabulary and grammar
class Stage4Practice extends StatefulWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;

  const Stage4Practice({
    required this.lesson,
    this.stageData,
    required this.onNext,
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

  late List<Map<String, dynamic>> _questions;

  @override
  void initState() {
    super.initState();

    // Load questions from stageData or use mock data
    List<Map<String, dynamic>> sourceQuestions;
    if (widget.stageData != null && widget.stageData!.containsKey('exercises')) {
      sourceQuestions = List<Map<String, dynamic>>.from(widget.stageData!['exercises']);
    } else {
      // Use mock questions
      sourceQuestions = [
        {
          'type': 'multiple_choice',
          'question': '请选择正确的翻译：안녕하세요',
          'options': ['你好', '谢谢', '再见', '对不起'],
          'correctAnswer': '你好',
        },
        {
          'type': 'multiple_choice',
          'question': '哪个是"谢谢"的韩语？',
          'options': ['안녕하세요', '감사합니다', '죄송합니다', '잘 가요'],
          'correctAnswer': '감사합니다',
        },
        {
          'type': 'fill_blank',
          'question': '填空：저___ 학생입니다 (我是学生)',
          'options': ['은', '는', '이', '가'],
          'correctAnswer': '는',
        },
        {
          'type': 'multiple_choice',
          'question': '选择正确的助词：책___ 재미있어요',
          'options': ['은', '는', '이', '가'],
          'correctAnswer': '은',
        },
        {
          'type': 'matching',
          'question': '选择"对不起"的韩语',
          'options': ['안녕하세요', '감사합니다', '죄송합니다', '반갑습니다'],
          'correctAnswer': '죄송합니다',
        },
      ];
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

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestionIndex];
    final isCorrect = _selectedAnswer == question['correctAnswer'];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const BilingualText(
            chinese: '练习',
            korean: '연습',
            chineseStyle: TextStyle(
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
                  color: AppConstants.successColor.withOpacity(0.1),
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
              color: AppConstants.primaryColor.withOpacity(0.1),
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
                    backgroundColor = AppConstants.successColor.withOpacity(0.1);
                    borderColor = AppConstants.successColor;
                    textColor = AppConstants.successColor;
                  } else if (isSelected && !isCorrectOption) {
                    backgroundColor = AppConstants.errorColor.withOpacity(0.1);
                    borderColor = AppConstants.errorColor;
                    textColor = AppConstants.errorColor;
                  }
                } else if (isSelected) {
                  backgroundColor = AppConstants.primaryColor.withOpacity(0.1);
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
                    ? AppConstants.successColor.withOpacity(0.1)
                    : AppConstants.errorColor.withOpacity(0.1),
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
                      isCorrect ? '太棒了！答对了！' : '不对哦，再想想看',
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
                    child: const InlineBilingualText(
                      chinese: '上一题',
                      korean: '이전',
                    ),
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
                  child: InlineBilingualText(
                    chinese: _showResult
                        ? (_currentQuestionIndex < _questions.length - 1
                            ? '下一题'
                            : '继续')
                        : '检查答案',
                    korean: _showResult
                        ? (_currentQuestionIndex < _questions.length - 1
                            ? '다음'
                            : '계속')
                        : '답안 확인',
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
