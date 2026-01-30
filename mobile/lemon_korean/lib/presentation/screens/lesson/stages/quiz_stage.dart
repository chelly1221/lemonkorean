import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../widgets/convertible_text.dart';

// Import split quiz components
import 'quiz/quiz.dart';
export 'quiz/quiz.dart';

/// Quiz Stage with Multiple Question Types
/// Comprehensive quiz with listening, fill-in-blank, translation, word order, and pronunciation questions
class QuizStage extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool enableTimer;

  const QuizStage({
    required this.lesson,
    required this.onNext,
    required this.onPrevious,
    this.enableTimer = false,
    super.key,
  });

  @override
  State<QuizStage> createState() => _QuizStageState();
}

class _QuizStageState extends State<QuizStage> {
  int _currentQuestionIndex = 0;
  final Map<int, dynamic> _userAnswers = {};
  final Map<int, bool> _isCorrect = {};
  int _score = 0;
  bool _quizCompleted = false;
  Timer? _timer;
  int _remainingSeconds = AppConstants.quizTimeLimitSeconds;

  final List<Map<String, dynamic>> _questions = [
    {
      'type': 'listening',
      'question': '听音频，选择正确的翻译',
      'audio': 'quiz/question1.mp3',
      'korean': '안녕하세요',
      'options': ['你好', '谢谢', '再见', '对不起'],
      'correct': '你好',
    },
    {
      'type': 'fill_in_blank',
      'question': '填入正确的助词',
      'sentence': '저___ 학생입니다',
      'translation': '我是学生',
      'blank_word': '저',
      'options': ['은', '는', '이', '가'],
      'correct': '는',
      'explanation': '"저"以元音结尾，使用"는"',
    },
    {
      'type': 'translation',
      'question': '选择正确的翻译',
      'korean': '감사합니다',
      'options': ['你好', '谢谢', '对不起', '再见'],
      'correct': '谢谢',
    },
    {
      'type': 'word_order',
      'question': '按正确顺序排列单词',
      'translation': '我是学生',
      'words': ['학생', '입니다', '저는'],
      'correct': ['저는', '학생', '입니다'],
    },
    {
      'type': 'pronunciation',
      'question': '选择正确的发音',
      'korean': '안녕하세요',
      'options': [
        'an-nyeong-ha-se-yo',
        'an-yong-ha-se-yo',
        'an-neong-ha-se-yo',
        'an-nyong-ha-yo',
      ],
      'correct': 'an-nyeong-ha-se-yo',
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.enableTimer) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _completeQuiz();
      }
    });
  }

  void _submitAnswer(dynamic answer) {
    final question = _questions[_currentQuestionIndex];
    final isCorrect = _checkAnswer(question, answer);

    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
      _isCorrect[_currentQuestionIndex] = isCorrect;
      if (isCorrect) {
        _score++;
      }
    });
  }

  bool _checkAnswer(Map<String, dynamic> question, dynamic answer) {
    switch (question['type']) {
      case 'word_order':
        final correctOrder = question['correct'] as List;
        final userOrder = answer as List;
        return correctOrder.toString() == userOrder.toString();
      default:
        return question['correct'] == answer;
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
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
    _timer?.cancel();
    setState(() {
      _quizCompleted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizCompleted) {
      return _buildResultScreen();
    }

    final question = _questions[_currentQuestionIndex];
    final hasAnswered = _userAnswers.containsKey(_currentQuestionIndex);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: _buildQuestion(question, _currentQuestionIndex),
            ),
          ),
          const SizedBox(height: 20),
          _buildNavigation(hasAnswered),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final percentage = (_currentQuestionIndex + 1) / _questions.length;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Semantics(
              label: 'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
              child: Text(
                '${_currentQuestionIndex + 1} / ${_questions.length}',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Semantics(
              label: 'Score: $_score points',
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars, size: 16, color: AppConstants.successColor),
                    const SizedBox(width: 4),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.successColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.enableTimer)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _remainingSeconds < AppConstants.quizWarningThresholdSeconds
                      ? AppConstants.errorColor.withOpacity(0.1)
                      : AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: _remainingSeconds < AppConstants.quizWarningThresholdSeconds
                          ? AppConstants.errorColor
                          : AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: _remainingSeconds < AppConstants.quizWarningThresholdSeconds
                            ? AppConstants.errorColor
                            : AppConstants.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Semantics(
          label: 'Quiz progress: ${(percentage * 100).toInt()} percent complete',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigation(bool hasAnswered) {
    return Row(
      children: [
        if (_currentQuestionIndex > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousQuestion,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
              ),
              child: const ConvertibleText('上一题'),
            ),
          ),
        if (_currentQuestionIndex > 0) const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: hasAnswered ? _nextQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingMedium),
            ),
            child: Text(
              _currentQuestionIndex < _questions.length - 1 ? '下一题' : '完成',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestion(Map<String, dynamic> question, int index) {
    switch (question['type']) {
      case 'listening':
        return ListeningQuestion(
          question: question,
          onAnswer: _submitAnswer,
          userAnswer: _userAnswers[index],
          isCorrect: _isCorrect[index],
        );
      case 'fill_in_blank':
        return FillInBlankQuestion(
          question: question,
          onAnswer: _submitAnswer,
          userAnswer: _userAnswers[index],
          isCorrect: _isCorrect[index],
        );
      case 'translation':
        return TranslationQuestion(
          question: question,
          onAnswer: _submitAnswer,
          userAnswer: _userAnswers[index],
          isCorrect: _isCorrect[index],
        );
      case 'word_order':
        return WordOrderQuestion(
          question: question,
          onAnswer: _submitAnswer,
          userAnswer: _userAnswers[index],
          isCorrect: _isCorrect[index],
        );
      case 'pronunciation':
        return PronunciationQuestion(
          question: question,
          onAnswer: _submitAnswer,
          userAnswer: _userAnswers[index],
          isCorrect: _isCorrect[index],
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildResultScreen() {
    final percentage = (_score / _questions.length) * 100;
    final isPassed = percentage >= 80;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isPassed
                    ? [AppConstants.successColor, AppConstants.successColor.withOpacity(0.7)]
                    : [AppConstants.errorColor, AppConstants.errorColor.withOpacity(0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isPassed ? AppConstants.successColor : AppConstants.errorColor)
                      .withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              isPassed ? Icons.celebration : Icons.replay,
              size: 64,
              color: Colors.white,
            ),
          )
              .animate()
              .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
              .then()
              .shake(duration: 500.ms),

          const SizedBox(height: 30),

          Text(
            isPassed ? '太棒了！' : '继续加油！',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isPassed ? AppConstants.successColor : AppConstants.errorColor,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

          const SizedBox(height: 16),

          Text(
            '得分：$_score / ${_questions.length}',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

          const SizedBox(height: 8),

          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isPassed ? AppConstants.successColor : AppConstants.errorColor,
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                delay: 800.ms,
              ),

          const SizedBox(height: 30),

          if (widget.enableTimer)
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 8),
                  Text(
                    '用时: ${_formatTime(AppConstants.quizTimeLimitSeconds - _remainingSeconds)}',
                    style: const TextStyle(fontSize: AppConstants.fontSizeMedium),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 30),

          Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              color: isPassed
                  ? AppConstants.successColor.withOpacity(0.1)
                  : AppConstants.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: Text(
              isPassed ? '你已经很好地掌握了本课内容！' : '建议复习一下课程内容，再来挑战吧！',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: isPassed ? AppConstants.successColor : AppConstants.errorColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingLarge),
              ),
              child: const Text(
                '继续',
                style: TextStyle(fontSize: AppConstants.fontSizeXLarge, fontWeight: FontWeight.bold),
              ),
            ),
          ).animate().fadeIn(delay: 1400.ms, duration: 600.ms).slideY(
                begin: 0.3,
                end: 0,
                delay: 1400.ms,
              ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
