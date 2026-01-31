import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../widgets/convertible_text.dart';

/// Vocabulary result from quiz
class VocabularyQuizResult {
  final int vocabularyId;
  final bool isCorrect;

  VocabularyQuizResult({required this.vocabularyId, required this.isCorrect});

  Map<String, dynamic> toJson() => {
    'vocabulary_id': vocabularyId,
    'is_correct': isCorrect,
  };
}

/// Stage 6: Quiz
/// Comprehensive quiz to test lesson understanding
class Stage6Quiz extends StatefulWidget {
  final LessonModel lesson;
  final Map<String, dynamic>? stageData;
  final VoidCallback onNext;
  final VoidCallback? onPrevious;
  final Function(int)? onScoreUpdate;
  final Function(List<VocabularyQuizResult>)? onVocabularyResults;

  const Stage6Quiz({
    required this.lesson,
    this.stageData,
    required this.onNext,
    this.onPrevious,
    this.onScoreUpdate,
    this.onVocabularyResults,
    super.key,
  });

  @override
  State<Stage6Quiz> createState() => _Stage6QuizState();
}

class _Stage6QuizState extends State<Stage6Quiz> {
  int _currentQuestionIndex = 0;
  final Map<int, String> _userAnswers = {};
  bool _quizCompleted = false;

  late List<Map<String, dynamic>> _quizQuestions;

  @override
  void initState() {
    super.initState();

    // Load questions from stageData or use mock data
    List<Map<String, dynamic>> sourceQuestions;
    if (widget.stageData != null && widget.stageData!.containsKey('questions')) {
      final rawQuestions = List<Map<String, dynamic>>.from(widget.stageData!['questions']);
      // Normalize API format to app format
      sourceQuestions = rawQuestions.map((q) {
        final options = List<String>.from(q['options'] ?? []);
        String correctAnswer;

        // Handle both formats: correct_answer (index) and correctAnswer (string)
        if (q.containsKey('correct_answer') && q['correct_answer'] is int) {
          // API format: correct_answer is an index
          final index = q['correct_answer'] as int;
          correctAnswer = (index >= 0 && index < options.length)
              ? options[index]
              : options.isNotEmpty ? options[0] : '';
        } else if (q.containsKey('correctAnswer')) {
          // Legacy format: correctAnswer is the answer string
          correctAnswer = q['correctAnswer'] as String;
        } else {
          correctAnswer = options.isNotEmpty ? options[0] : '';
        }

        return {
          'question': q['question'] ?? '',
          'options': options,
          'correctAnswer': correctAnswer,
          'type': q['type'] ?? 'general',
          // Track vocabulary_id for vocabulary questions
          'vocabulary_id': q['vocabulary_id'],
        };
      }).toList();
    } else {
      // Use mock questions
      sourceQuestions = [
        {
          'question': '"안녕하세요"的意思是？',
          'options': ['你好', '谢谢', '再见', '对不起'],
          'correctAnswer': '你好',
          'type': 'vocabulary',
        },
        {
          'question': '"감사합니다"的中文翻译是？',
          'options': ['你好', '谢谢', '再见', '对不起'],
          'correctAnswer': '谢谢',
          'type': 'vocabulary',
        },
        {
          'question': '当名词以辅音结尾时，应该使用哪个主题助词？',
          'options': ['은', '는', '이', '가'],
          'correctAnswer': '은',
          'type': 'grammar',
        },
        {
          'question': '选择正确的句子："我是学生"',
          'options': [
            '저는 학생입니다',
            '저는 학생이에요',
            '저는 학생예요',
            '以上都对',
          ],
          'correctAnswer': '以上都对',
          'type': 'grammar',
        },
        {
          'question': '"이름이 뭐예요?"的意思是？',
          'options': [
            '你好吗？',
            '你叫什么名字？',
            '你是谁？',
            '你在哪里？',
          ],
          'correctAnswer': '你叫什么名字？',
          'type': 'dialogue',
        },
        {
          'question': '如何用韩语说"很高兴认识你"？',
          'options': ['안녕하세요', '감사합니다', '반갑습니다', '죄송합니다'],
          'correctAnswer': '반갑습니다',
          'type': 'dialogue',
        },
        {
          'question': '"학생이에요?"的意思是？',
          'options': [
            '你是学生',
            '你是学生吗？',
            '我是学生',
            '我是学生吗？',
          ],
          'correctAnswer': '你是学生吗？',
          'type': 'grammar',
        },
        {
          'question': '选择"对不起"的韩语',
          'options': ['안녕하세요', '감사합니다', '죄송합니다', '반갑습니다'],
          'correctAnswer': '죄송합니다',
          'type': 'vocabulary',
        },
      ];
    }

    // Keep question order (no shuffle)
    _quizQuestions = List.from(sourceQuestions);

    // Shuffle only the options for each question (but keep correctAnswer reference)
    for (var question in _quizQuestions) {
      if (question['options'] != null && question['options'] is List) {
        question['options'] = List.from(question['options'])..shuffle();
      }
    }
  }

  void _selectAnswer(String answer) {
    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _completeQuiz() {
    setState(() {
      _quizCompleted = true;
    });

    // Update quiz score
    final score = _calculateScore();
    final percentage = _calculatePercentage();
    widget.onScoreUpdate?.call(percentage.toInt());

    // Collect vocabulary results for tracking
    final vocabularyResults = <VocabularyQuizResult>[];
    for (int i = 0; i < _quizQuestions.length; i++) {
      final question = _quizQuestions[i];
      // Only track vocabulary questions with vocabulary_id
      if (question['type'] == 'vocabulary' && question['vocabulary_id'] != null) {
        final vocabId = question['vocabulary_id'];
        final isCorrect = _userAnswers[i] == question['correctAnswer'];
        vocabularyResults.add(VocabularyQuizResult(
          vocabularyId: vocabId is int ? vocabId : int.tryParse(vocabId.toString()) ?? 0,
          isCorrect: isCorrect,
        ));
      }
    }

    // Pass vocabulary results to parent
    if (vocabularyResults.isNotEmpty) {
      widget.onVocabularyResults?.call(vocabularyResults);
    }
  }

  int _calculateScore() {
    int correct = 0;
    for (int i = 0; i < _quizQuestions.length; i++) {
      if (_userAnswers[i] == _quizQuestions[i]['correctAnswer']) {
        correct++;
      }
    }
    return correct;
  }

  double _calculatePercentage() {
    return (_calculateScore() / _quizQuestions.length) * 100;
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultScreen();
    }

    final question = _quizQuestions[_currentQuestionIndex];
    final selectedAnswer = _userAnswers[_currentQuestionIndex];

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          // Stage Title
          const Text(
            '测验',
            style: TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentQuestionIndex + 1} / ${_quizQuestions.length}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondary,
                ),
              ),
              // Answered Count
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '已答 ${_userAnswers.length}/${_quizQuestions.length}',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _quizQuestions.length,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Question Type Badge
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: _getQuestionTypeColor(question['type']).withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _getQuestionTypeLabel(question['type']),
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: _getQuestionTypeColor(question['type']),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

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
                fontSize: 22,
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
                final isSelected = selectedAnswer == option;

                return GestureDetector(
                  onTap: () => _selectAnswer(option),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(AppConstants.paddingMedium),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.primaryColor.withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(
                        AppConstants.radiusMedium,
                      ),
                      border: Border.all(
                        color: isSelected
                            ? AppConstants.primaryColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        // Radio Circle
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppConstants.primaryColor
                                : Colors.transparent,
                            border: Border.all(
                              color: isSelected
                                  ? AppConstants.primaryColor
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),

                        const SizedBox(width: 16),

                        // Option Text
                        Expanded(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // Navigation Buttons
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
                    child: const ConvertibleText('上一题'),
                  ),
                ),

              if (_currentQuestionIndex > 0) const SizedBox(width: 16),

              // Next/Submit Button
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: selectedAnswer != null ? _nextQuestion : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex < _quizQuestions.length - 1
                        ? '下一题'
                        : '提交',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    final score = _calculateScore();
    final percentage = _calculatePercentage();
    final isPassed = percentage >= 80;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Result Icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPassed
                  ? AppConstants.successColor.withOpacity(0.1)
                  : AppConstants.errorColor.withOpacity(0.1),
            ),
            child: Icon(
              isPassed ? Icons.celebration : Icons.replay,
              size: 64,
              color: isPassed
                  ? AppConstants.successColor
                  : AppConstants.errorColor,
            ),
          ),

          const SizedBox(height: 30),

          // Result Title
          Text(
            isPassed ? '太棒了！' : '继续加油！',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isPassed
                  ? AppConstants.successColor
                  : AppConstants.errorColor,
            ),
          ),

          const SizedBox(height: 16),

          // Score
          Text(
            '得分：$score / ${_quizQuestions.length}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          // Percentage
          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isPassed
                  ? AppConstants.successColor
                  : AppConstants.errorColor,
            ),
          ),

          const SizedBox(height: 30),

          // Pass/Fail Message
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: isPassed
                  ? AppConstants.successColor.withOpacity(0.1)
                  : AppConstants.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Text(
              isPassed
                  ? '你已经很好地掌握了本课内容！'
                  : '建议复习一下课程内容，再来挑战吧！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: isPassed
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Spacer(),

          // Continue Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(
                  vertical: AppConstants.paddingLarge,
                ),
              ),
              child: const Text(
                '继续',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getQuestionTypeColor(String type) {
    switch (type) {
      case 'vocabulary':
        return Colors.blue;
      case 'grammar':
        return Colors.purple;
      case 'dialogue':
        return Colors.green;
      default:
        return AppConstants.primaryColor;
    }
  }

  String _getQuestionTypeLabel(String type) {
    switch (type) {
      case 'vocabulary':
        return '词汇';
      case 'grammar':
        return '语法';
      case 'dialogue':
        return '对话';
      default:
        return '综合';
    }
  }
}
