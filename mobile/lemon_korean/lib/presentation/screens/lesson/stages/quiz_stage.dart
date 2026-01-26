import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/media_loader.dart';
import '../../../../data/models/lesson_model.dart';

/// Quiz Stage with Multiple Question Types
/// Comprehensive quiz with listening, fill-in-blank, translation, word order, and pronunciation questions
class QuizStage extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool enableTimer;

  const QuizStage({
    required this.lesson, required this.onNext, required this.onPrevious, super.key,
    this.enableTimer = false,
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
  int _remainingSeconds = 300; // 5 minutes

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
          // Header
          _buildHeader(),

          const SizedBox(height: 20),

          // Question
          Expanded(
            child: SingleChildScrollView(
              child: _buildQuestion(question, _currentQuestionIndex),
            ),
          ),

          const SizedBox(height: 20),

          // Navigation
          Row(
            children: [
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _previousQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                    ),
                    child: const Text('上一题'),
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
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.paddingMedium,
                    ),
                  ),
                  child: Text(
                    _currentQuestionIndex < _questions.length - 1
                        ? '下一题'
                        : '完成',
                  ),
                ),
              ),
            ],
          ),
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
            // Question count
            Text(
              '${_currentQuestionIndex + 1} / ${_questions.length}',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Score
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
                    Icons.stars,
                    size: 16,
                    color: AppConstants.successColor,
                  ),
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

            // Timer (if enabled)
            if (widget.enableTimer)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _remainingSeconds < 60
                      ? AppConstants.errorColor.withOpacity(0.1)
                      : AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: _remainingSeconds < 60
                          ? AppConstants.errorColor
                          : AppConstants.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatTime(_remainingSeconds),
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.bold,
                        color: _remainingSeconds < 60
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

        // Progress bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(
              AppConstants.primaryColor,
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
          // Result icon
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isPassed
                    ? [
                        AppConstants.successColor,
                        AppConstants.successColor.withOpacity(0.7),
                      ]
                    : [
                        AppConstants.errorColor,
                        AppConstants.errorColor.withOpacity(0.7),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isPassed
                          ? AppConstants.successColor
                          : AppConstants.errorColor)
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
              color: isPassed
                  ? AppConstants.successColor
                  : AppConstants.errorColor,
            ),
          ).animate().fadeIn(delay: 400.ms, duration: 600.ms),

          const SizedBox(height: 16),

          Text(
            '得分：$_score / ${_questions.length}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

          const SizedBox(height: 8),

          Text(
            '${percentage.toInt()}%',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: isPassed
                  ? AppConstants.successColor
                  : AppConstants.errorColor,
            ),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1, 1),
                delay: 800.ms,
              ),

          const SizedBox(height: 30),

          // Time taken (if timer enabled)
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
                    '用时: ${_formatTime(300 - _remainingSeconds)}',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 1000.ms),

          const SizedBox(height: 30),

          // Pass/Fail message
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
          ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),

          const Spacer(),

          // Continue button
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

// ============================================================================
// QUESTION TYPE WIDGETS
// ============================================================================

/// Listening Question Widget
class ListeningQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const ListeningQuestion({
    required this.question, required this.onAnswer, super.key,
    this.userAnswer,
    this.isCorrect,
  });

  @override
  State<ListeningQuestion> createState() => _ListeningQuestionState();
}

class _ListeningQuestionState extends State<ListeningQuestion> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen to player state
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    final audioPath = widget.question['audio'] as String?;

    if (audioPath != null) {
      try {
        // Stop if already playing
        if (_isPlaying) {
          await _audioPlayer.stop();
          return;
        }

        // Get audio path (local or remote)
        final localPath = await MediaLoader.getAudioPath(audioPath);

        // Play audio
        if (localPath.startsWith('http')) {
          await _audioPlayer.play(UrlSource(localPath));
        } else {
          await _audioPlayer.play(DeviceFileSource(localPath));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('音频播放失败: $e'),
              backgroundColor: AppConstants.errorColor,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswered = widget.userAnswer != null;

    return Column(
      children: [
        // Question type badge
        _buildTypeBadge('听力', Icons.headphones, Colors.blue),

        const SizedBox(height: 20),

        // Question text
        Text(
          widget.question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        // Audio player
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade50,
                Colors.blue.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Column(
            children: [
              Icon(
                Icons.graphic_eq,
                size: 80,
                color: Colors.blue.shade700,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _playAudio,
                icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                label: Text(_isPlaying ? '停止' : '播放音频'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Options
        ...List.generate(
          (widget.question['options'] as List).length,
          (index) => _buildOption(
            widget.question['options'][index],
            widget.question['correct'],
            hasAnswered,
          ),
        ),

        // Feedback
        if (hasAnswered) _buildFeedback(widget.question['correct']),
      ],
    );
  }

  Widget _buildOption(String option, String correct, bool hasAnswered) {
    final isSelected = widget.userAnswer == option;
    final isCorrectOption = option == correct;

    Color? backgroundColor;
    Color? borderColor;

    if (hasAnswered) {
      if (isCorrectOption) {
        backgroundColor = AppConstants.successColor.withOpacity(0.1);
        borderColor = AppConstants.successColor;
      } else if (isSelected) {
        backgroundColor = AppConstants.errorColor.withOpacity(0.1);
        borderColor = AppConstants.errorColor;
      }
    } else if (isSelected) {
      backgroundColor = AppConstants.primaryColor.withOpacity(0.1);
      borderColor = AppConstants.primaryColor;
    }

    return GestureDetector(
      onTap: hasAnswered ? null : () => widget.onAnswer(option),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: borderColor ?? Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (hasAnswered && isCorrectOption)
              const Icon(Icons.check_circle, color: AppConstants.successColor),
            if (hasAnswered && isSelected && !isCorrectOption)
              const Icon(Icons.cancel, color: AppConstants.errorColor),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedback(String correct) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: (widget.isCorrect ?? false)
            ? AppConstants.successColor.withOpacity(0.1)
            : AppConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            (widget.isCorrect ?? false) ? Icons.celebration : Icons.info_outline,
            color: (widget.isCorrect ?? false)
                ? AppConstants.successColor
                : AppConstants.errorColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              (widget.isCorrect ?? false) ? '太棒了！' : '正确答案是: $correct',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: (widget.isCorrect ?? false)
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }

  Widget _buildTypeBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Fill in Blank Question Widget
class FillInBlankQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const FillInBlankQuestion({
    required this.question, required this.onAnswer, super.key,
    this.userAnswer,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnswered = userAnswer != null;

    return Column(
      children: [
        _buildTypeBadge('填空', Icons.edit_note, Colors.green),

        const SizedBox(height: 20),

        Text(
          question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        // Sentence with blank
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          ),
          child: Column(
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: _buildSentenceSpans(question['sentence']),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                question['translation'],
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        // Options
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: (question['options'] as List).map((option) {
            final isSelected = userAnswer == option;
            final isCorrectOption = option == question['correct'];

            Color? backgroundColor;
            Color? borderColor;

            if (hasAnswered) {
              if (isCorrectOption) {
                backgroundColor = AppConstants.successColor.withOpacity(0.2);
                borderColor = AppConstants.successColor;
              } else if (isSelected) {
                backgroundColor = AppConstants.errorColor.withOpacity(0.2);
                borderColor = AppConstants.errorColor;
              }
            } else if (isSelected) {
              backgroundColor = AppConstants.primaryColor.withOpacity(0.2);
              borderColor = AppConstants.primaryColor;
            }

            return GestureDetector(
              onTap: hasAnswered ? null : () => onAnswer(option),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: borderColor ?? Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        if (hasAnswered) ...[
          const SizedBox(height: 20),
          _buildFeedback(),
        ],
      ],
    );
  }

  List<TextSpan> _buildSentenceSpans(String sentence) {
    final parts = sentence.split('___');
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
              decoration: TextDecoration.underline,
              decorationStyle: TextDecorationStyle.dashed,
            ),
          ),
        );
      }
    }

    return spans;
  }

  Widget _buildFeedback() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: (isCorrect ?? false)
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
                (isCorrect ?? false) ? Icons.celebration : Icons.info_outline,
                color: (isCorrect ?? false)
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
              const SizedBox(width: 12),
              Text(
                (isCorrect ?? false)
                    ? '太棒了！'
                    : '正确答案是: ${question['correct']}',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: (isCorrect ?? false)
                      ? AppConstants.successColor
                      : AppConstants.errorColor,
                ),
              ),
            ],
          ),
          if (question['explanation'] != null) ...[
            const SizedBox(height: 8),
            Text(
              question['explanation'],
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: (isCorrect ?? false)
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }

  Widget _buildTypeBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Translation Question Widget
class TranslationQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const TranslationQuestion({
    required this.question, required this.onAnswer, super.key,
    this.userAnswer,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnswered = userAnswer != null;

    return Column(
      children: [
        _buildTypeBadge('翻译', Icons.translate, Colors.purple),

        const SizedBox(height: 20),

        Text(
          question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        // Korean text
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple.shade50,
                Colors.purple.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Text(
            question['korean'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Options
        ...List.generate(
          (question['options'] as List).length,
          (index) {
            final option = question['options'][index];
            final isSelected = userAnswer == option;
            final isCorrectOption = option == question['correct'];

            Color? backgroundColor;
            Color? borderColor;

            if (hasAnswered) {
              if (isCorrectOption) {
                backgroundColor = AppConstants.successColor.withOpacity(0.1);
                borderColor = AppConstants.successColor;
              } else if (isSelected) {
                backgroundColor = AppConstants.errorColor.withOpacity(0.1);
                borderColor = AppConstants.errorColor;
              }
            } else if (isSelected) {
              backgroundColor = AppConstants.primaryColor.withOpacity(0.1);
              borderColor = AppConstants.primaryColor;
            }

            return GestureDetector(
              onTap: hasAnswered ? null : () => onAnswer(option),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: borderColor ?? Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (hasAnswered && isCorrectOption)
                      const Icon(
                        Icons.check_circle,
                        color: AppConstants.successColor,
                      ),
                    if (hasAnswered && isSelected && !isCorrectOption)
                      const Icon(Icons.cancel, color: AppConstants.errorColor),
                  ],
                ),
              ),
            );
          },
        ),

        if (hasAnswered) _buildFeedback(),
      ],
    );
  }

  Widget _buildFeedback() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: (isCorrect ?? false)
            ? AppConstants.successColor.withOpacity(0.1)
            : AppConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            (isCorrect ?? false) ? Icons.celebration : Icons.info_outline,
            color: (isCorrect ?? false)
                ? AppConstants.successColor
                : AppConstants.errorColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              (isCorrect ?? false)
                  ? '太棒了！'
                  : '正确答案是: ${question['correct']}',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: (isCorrect ?? false)
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }

  Widget _buildTypeBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Word Order Question Widget
class WordOrderQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final Function(List<String>) onAnswer;
  final List<String>? userAnswer;
  final bool? isCorrect;

  const WordOrderQuestion({
    required this.question, required this.onAnswer, super.key,
    this.userAnswer,
    this.isCorrect,
  });

  @override
  State<WordOrderQuestion> createState() => _WordOrderQuestionState();
}

class _WordOrderQuestionState extends State<WordOrderQuestion> {
  List<String> _orderedWords = [];
  List<String> _availableWords = [];

  @override
  void initState() {
    super.initState();
    if (widget.userAnswer != null) {
      _orderedWords = List.from(widget.userAnswer!);
      _availableWords = [];
    } else {
      _availableWords = List.from(widget.question['words'] as List<String>);
      _availableWords.shuffle();
    }
  }

  void _addWord(String word) {
    setState(() {
      _orderedWords.add(word);
      _availableWords.remove(word);
    });
    if (_availableWords.isEmpty) {
      widget.onAnswer(_orderedWords);
    }
  }

  void _removeWord(String word) {
    if (widget.userAnswer != null) return; // Already answered

    setState(() {
      _orderedWords.remove(word);
      _availableWords.add(word);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasAnswered = widget.userAnswer != null;

    return Column(
      children: [
        _buildTypeBadge('排序', Icons.reorder, Colors.orange),

        const SizedBox(height: 20),

        Text(
          widget.question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        // Translation hint
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Text(
            widget.question['translation'],
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.orange.shade700,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Ordered words area
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 100),
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: BoxDecoration(
            color: hasAnswered
                ? (widget.isCorrect ?? false)
                    ? AppConstants.successColor.withOpacity(0.1)
                    : AppConstants.errorColor.withOpacity(0.1)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            border: Border.all(
              color: hasAnswered
                  ? (widget.isCorrect ?? false)
                      ? AppConstants.successColor
                      : AppConstants.errorColor
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _orderedWords.map((word) {
              return GestureDetector(
                onTap: () => _removeWord(word),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 30),

        // Available words
        if (_availableWords.isNotEmpty)
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availableWords.map((word) {
              return GestureDetector(
                onTap: () => _addWord(word),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusSmall,
                    ),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    word,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

        if (hasAnswered) ...[
          const SizedBox(height: 20),
          _buildFeedback(),
        ],
      ],
    );
  }

  Widget _buildFeedback() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: (widget.isCorrect ?? false)
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
                (widget.isCorrect ?? false)
                    ? Icons.celebration
                    : Icons.info_outline,
                color: (widget.isCorrect ?? false)
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
              const SizedBox(width: 12),
              Text(
                (widget.isCorrect ?? false) ? '太棒了！' : '正确顺序是:',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: (widget.isCorrect ?? false)
                      ? AppConstants.successColor
                      : AppConstants.errorColor,
                ),
              ),
            ],
          ),
          if (!(widget.isCorrect ?? false)) ...[
            const SizedBox(height: 8),
            Text(
              (widget.question['correct'] as List).join(' '),
              style: const TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: AppConstants.errorColor,
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }

  Widget _buildTypeBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Pronunciation Question Widget
class PronunciationQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  const PronunciationQuestion({
    required this.question, required this.onAnswer, super.key,
    this.userAnswer,
    this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    final hasAnswered = userAnswer != null;

    return Column(
      children: [
        _buildTypeBadge('发音', Icons.record_voice_over, Colors.red),

        const SizedBox(height: 20),

        Text(
          question['question'],
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 30),

        // Korean text
        Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red.shade50,
                Colors.red.shade100,
              ],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
          child: Text(
            question['korean'],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 30),

        // Options (pronunciation)
        ...List.generate(
          (question['options'] as List).length,
          (index) {
            final option = question['options'][index];
            final isSelected = userAnswer == option;
            final isCorrectOption = option == question['correct'];

            Color? backgroundColor;
            Color? borderColor;

            if (hasAnswered) {
              if (isCorrectOption) {
                backgroundColor = AppConstants.successColor.withOpacity(0.1);
                borderColor = AppConstants.successColor;
              } else if (isSelected) {
                backgroundColor = AppConstants.errorColor.withOpacity(0.1);
                borderColor = AppConstants.errorColor;
              }
            } else if (isSelected) {
              backgroundColor = AppConstants.primaryColor.withOpacity(0.1);
              borderColor = AppConstants.primaryColor;
            }

            return GestureDetector(
              onTap: hasAnswered ? null : () => onAnswer(option),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: backgroundColor ?? Colors.white,
                  borderRadius:
                      BorderRadius.circular(AppConstants.radiusMedium),
                  border: Border.all(
                    color: borderColor ?? Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    if (hasAnswered && isCorrectOption)
                      const Icon(
                        Icons.check_circle,
                        color: AppConstants.successColor,
                      ),
                    if (hasAnswered && isSelected && !isCorrectOption)
                      const Icon(Icons.cancel, color: AppConstants.errorColor),
                  ],
                ),
              ),
            );
          },
        ),

        if (hasAnswered) _buildFeedback(),
      ],
    );
  }

  Widget _buildFeedback() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: (isCorrect ?? false)
            ? AppConstants.successColor.withOpacity(0.1)
            : AppConstants.errorColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
      ),
      child: Row(
        children: [
          Icon(
            (isCorrect ?? false) ? Icons.celebration : Icons.info_outline,
            color: (isCorrect ?? false)
                ? AppConstants.successColor
                : AppConstants.errorColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              (isCorrect ?? false)
                  ? '太棒了！'
                  : '正确发音是: ${question['correct']}',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: (isCorrect ?? false)
                    ? AppConstants.successColor
                    : AppConstants.errorColor,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms);
  }

  Widget _buildTypeBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
