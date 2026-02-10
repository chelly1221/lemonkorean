import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/gamification_provider.dart';
import '../../providers/settings_provider.dart';

/// Boss Quiz Screen - comprehensive quiz combining questions from all
/// lessons in a chapter. Rewards bonus lemons on completion.
class BossQuizScreen extends StatefulWidget {
  final List<LessonModel> chapterLessons;
  final int level;
  final int week;
  final Color levelColor;

  const BossQuizScreen({
    required this.chapterLessons,
    required this.level,
    required this.week,
    required this.levelColor,
    super.key,
  });

  @override
  State<BossQuizScreen> createState() => _BossQuizScreenState();
}

class _BossQuizScreenState extends State<BossQuizScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _questions = [];
  int _currentIndex = 0;
  final Map<int, String> _userAnswers = {};
  bool _quizCompleted = false;
  int _correctCount = 0;
  final _contentRepository = ContentRepository();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final language = settingsProvider.contentLanguageCode;
    final allQuestions = <Map<String, dynamic>>[];

    for (final lesson in widget.chapterLessons) {
      try {
        final fullLesson = await _contentRepository.getLesson(lesson.id, language: language);
        if (fullLesson?.content == null) continue;

        final content = fullLesson!.content!;
        List<Map<String, dynamic>>? quizQuestions;

        // v2 structure
        if (content.containsKey('stages') && content['stages'] is List) {
          final stages = List<Map<String, dynamic>>.from(content['stages']);
          for (final stage in stages) {
            if (stage['type'] == 'quiz' && stage['data'] != null) {
              final data = stage['data'] as Map<String, dynamic>;
              if (data.containsKey('questions')) {
                quizQuestions = List<Map<String, dynamic>>.from(data['questions']);
              }
            }
          }
        }
        // v1 structure
        else if (content.containsKey('stage6_quiz')) {
          final quizData = content['stage6_quiz'] as Map<String, dynamic>?;
          if (quizData != null && quizData.containsKey('questions')) {
            quizQuestions = List<Map<String, dynamic>>.from(quizData['questions']);
          }
        }

        if (quizQuestions != null) {
          // Tag questions with lesson info
          for (final q in quizQuestions) {
            q['_source_lesson_id'] = lesson.id;
            q['_source_lesson_title'] = lesson.titleKo;
          }
          allQuestions.addAll(quizQuestions);
        }
      } catch (e) {
        debugPrint('[BossQuiz] Failed to load lesson ${lesson.id}: $e');
      }
    }

    // Shuffle and pick up to 15 questions
    allQuestions.shuffle(Random());
    final selected = allQuestions.take(15).toList();

    // Normalize questions
    final normalized = selected.map((q) {
      final options = List<String>.from(q['options'] ?? []);
      String correctAnswer;

      if (q.containsKey('correct_answer') && q['correct_answer'] is int) {
        final index = q['correct_answer'] as int;
        correctAnswer = (index >= 0 && index < options.length)
            ? options[index]
            : options.isNotEmpty ? options[0] : '';
      } else if (q.containsKey('correctAnswer')) {
        correctAnswer = q['correctAnswer'] as String? ?? '';
      } else {
        correctAnswer = options.isNotEmpty ? options[0] : '';
      }

      return {
        'question': q['question'] ?? '',
        'options': options,
        'correctAnswer': correctAnswer,
        'type': q['type'] ?? 'translation',
        '_source_lesson_title': q['_source_lesson_title'] ?? '',
      };
    }).toList();

    if (mounted) {
      setState(() {
        _questions = normalized;
        _isLoading = false;
      });
    }
  }

  void _selectAnswer(String answer) {
    if (_userAnswers.containsKey(_currentIndex)) return;

    setState(() {
      _userAnswers[_currentIndex] = answer;
    });

    final isCorrect = answer == _questions[_currentIndex]['correctAnswer'];
    if (isCorrect) _correctCount++;

    // Auto-advance after delay
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (_currentIndex < _questions.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _completeQuiz();
      }
    });
  }

  Future<void> _completeQuiz() async {
    setState(() {
      _quizCompleted = true;
    });

    // Only award bonus if passed
    final gamificationProvider = Provider.of<GamificationProvider>(context, listen: false);
    final percent = _questions.isNotEmpty
        ? (_correctCount / _questions.length * 100).round()
        : 0;
    if (percent >= gamificationProvider.bossQuizPassPercent) {
      await gamificationProvider.recordBossQuizBonus(
        level: widget.level,
        week: widget.week,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${l10n.bossQuiz} - Chapter ${widget.week}'),
          backgroundColor: Colors.amber.shade50,
          foregroundColor: Colors.black87,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${l10n.bossQuiz} - Chapter ${widget.week}'),
          backgroundColor: Colors.amber.shade50,
          foregroundColor: Colors.black87,
        ),
        body: Center(
          child: Text(l10n.noQuiz),
        ),
      );
    }

    if (_quizCompleted) {
      return _buildResultScreen(l10n);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${l10n.bossQuiz} - Chapter ${widget.week}'),
        backgroundColor: Colors.amber.shade50,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_currentIndex + 1) / _questions.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
            minHeight: 6,
          ),
          Expanded(
            child: _buildQuestionCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard() {
    final question = _questions[_currentIndex];
    final options = List<String>.from(question['options']);
    final selectedAnswer = _userAnswers[_currentIndex];
    final correctAnswer = question['correctAnswer'] as String;
    final lessonTitle = question['_source_lesson_title'] as String?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question counter
          Text(
            '${_currentIndex + 1} / ${_questions.length}',
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey.shade600,
            ),
          ),
          if (lessonTitle != null && lessonTitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              lessonTitle,
              style: TextStyle(
                fontSize: 11,
                color: Colors.amber.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          const SizedBox(height: 20),

          // Question text
          Text(
            question['question'] as String,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),

          // Options
          ...options.map((option) {
            final isSelected = selectedAnswer == option;
            final isCorrect = option == correctAnswer;
            final showResult = selectedAnswer != null;

            Color bgColor = Colors.white;
            Color borderColor = Colors.grey.shade300;
            Color textColor = Colors.black87;

            if (showResult) {
              if (isCorrect) {
                bgColor = AppConstants.successColor.withValues(alpha: 0.1);
                borderColor = AppConstants.successColor;
                textColor = AppConstants.successColor;
              } else if (isSelected && !isCorrect) {
                bgColor = AppConstants.errorColor.withValues(alpha: 0.1);
                borderColor = AppConstants.errorColor;
                textColor = AppConstants.errorColor;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: selectedAnswer == null ? () => _selectAnswer(option) : null,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: AppConstants.fontSizeMedium,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                          ),
                        ),
                      ),
                      if (showResult && isCorrect)
                        const Icon(Icons.check_circle, color: AppConstants.successColor),
                      if (showResult && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: AppConstants.errorColor),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultScreen(AppLocalizations l10n) {
    final gamification = Provider.of<GamificationProvider>(context, listen: false);
    final percent = _questions.isNotEmpty
        ? (_correctCount / _questions.length * 100).round()
        : 0;
    final passed = percent >= gamification.bossQuizPassPercent;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Trophy/icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: passed ? Colors.amber : Colors.grey.shade300,
                    boxShadow: passed
                        ? [
                            BoxShadow(
                              color: Colors.amber.withValues(alpha: 0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ]
                        : null,
                  ),
                  child: Icon(
                    passed ? Icons.workspace_premium : Icons.refresh,
                    size: 64,
                    color: passed ? Colors.white : Colors.grey.shade500,
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut),

                const SizedBox(height: 32),

                Text(
                  passed
                      ? l10n.bossQuizCleared
                      : (l10n.keepPracticing),
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 16),

                Text(
                  '$_correctCount / ${_questions.length} ($percent%)',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.grey.shade600,
                  ),
                ).animate().fadeIn(delay: 500.ms),

                if (passed) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      border: Border.all(color: Colors.yellow.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('🍋', style: TextStyle(fontSize: 24)),
                        const SizedBox(width: 8),
                        Text(
                          '+${gamification.bossQuizBonus} ${l10n.bossQuizBonus}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 700.ms).scale(
                        delay: 700.ms,
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                      ),
                ],

                const SizedBox(height: 48),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: passed ? Colors.amber : AppConstants.primaryColor,
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: AppConstants.paddingLarge),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                      ),
                    ),
                    child: Text(
                      l10n.finish,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeXLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 900.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
