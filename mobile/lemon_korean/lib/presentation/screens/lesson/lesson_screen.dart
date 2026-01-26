import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../../providers/progress_provider.dart';
import 'stages/stage1_intro.dart';
import 'stages/stage2_vocabulary.dart';
import 'stages/stage3_grammar.dart';
import 'stages/stage4_practice.dart';
import 'stages/stage5_dialogue.dart';
import 'stages/stage6_quiz.dart';
import 'stages/stage7_summary.dart';

/// Lesson Screen
/// Full-screen immersive learning experience with 7 stages
class LessonScreen extends StatefulWidget {
  final LessonModel lesson;

  const LessonScreen({
    required this.lesson, super.key,
  });

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int _currentStage = 0;
  final int _totalStages = 7;
  final PageController _pageController = PageController();

  // Track lesson progress
  int _quizScore = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _enterImmersiveMode();
  }

  @override
  void dispose() {
    _exitImmersiveMode();
    _pageController.dispose();
    super.dispose();
  }

  /// Enter immersive mode (hide system UI)
  void _enterImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  /// Exit immersive mode (show system UI)
  void _exitImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Move to next stage
  void _nextStage() {
    if (_currentStage < _totalStages - 1) {
      setState(() {
        _currentStage++;
      });
      _pageController.animateToPage(
        _currentStage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Lesson completed
      _completeLessonAndExit();
    }
  }

  /// Move to previous stage
  void _previousStage() {
    if (_currentStage > 0) {
      setState(() {
        _currentStage--;
      });
      _pageController.animateToPage(
        _currentStage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Show exit confirmation dialog
  Future<void> _showExitDialog() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出学习'),
        content: const Text('确定要退出当前课程吗？进度将会保存。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('继续学习'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.errorColor,
            ),
            child: const Text('退出'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      _saveProgressAndExit();
    }
  }

  /// Save progress and exit
  void _saveProgressAndExit() {
    // Progress is auto-saved during the lesson
    Navigator.pop(context);
  }

  /// Complete lesson and exit
  Future<void> _completeLessonAndExit() async {
    if (!mounted) return;

    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final timeSpent = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;

    // Save lesson completion
    await progressProvider.completeLesson(
      lessonId: widget.lesson.id,
      quizScore: _quizScore,
      timeSpent: timeSpent,
    );

    if (mounted) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('课程完成！进度已保存'),
          backgroundColor: AppConstants.successColor,
          duration: Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }

  /// Update quiz score (called by quiz stage)
  void _updateQuizScore(int score) {
    setState(() {
      _quizScore = score;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _showExitDialog();
        return false; // Prevent default back action
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Top Bar (Progress + Close Button)
              _buildTopBar(),

              // Stage Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Disable swipe
                  onPageChanged: (index) {
                    setState(() {
                      _currentStage = index;
                    });
                  },
                  children: [
                    Stage1Intro(
                      lesson: widget.lesson,
                      onNext: _nextStage,
                    ),
                    Stage2Vocabulary(
                      lesson: widget.lesson,
                      onNext: _nextStage,
                      onPrevious: _previousStage,
                    ),
                    Stage3Grammar(
                      lesson: widget.lesson,
                      onNext: _nextStage,
                      onPrevious: _previousStage,
                    ),
                    Stage4Practice(
                      lesson: widget.lesson,
                      onNext: _nextStage,
                      onPrevious: _previousStage,
                    ),
                    Stage5Dialogue(
                      lesson: widget.lesson,
                      onNext: _nextStage,
                      onPrevious: _previousStage,
                    ),
                    Stage6Quiz(
                      lesson: widget.lesson,
                      onNext: _nextStage,
                      onPrevious: _previousStage,
                      onScoreUpdate: _updateQuizScore,
                    ),
                    Stage7Summary(
                      lesson: widget.lesson,
                      onComplete: _completeLessonAndExit,
                      onPrevious: _previousStage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final progress = (_currentStage + 1) / _totalStages;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Row(
        children: [
          // Close Button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showExitDialog,
            tooltip: '退出',
          ),

          const SizedBox(width: 8),

          // Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stage indicator
                Text(
                  '第 ${_currentStage + 1} 阶段 / $_totalStages',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusSmall,
                  ),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppConstants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Progress percentage
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
