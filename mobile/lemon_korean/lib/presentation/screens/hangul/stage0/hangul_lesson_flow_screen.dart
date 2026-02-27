import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/gamification_provider.dart';
import '../../../providers/hangul_provider.dart';
import 'stage0_lesson_content.dart';
import 'steps/step_intro.dart';
import 'steps/step_drag_drop_assembly.dart';
import 'steps/step_sound_explore.dart';
import 'steps/step_sound_match.dart';
import 'steps/step_syllable_build.dart';
import 'steps/step_quiz_mcq.dart';
import 'steps/step_mission_intro.dart';
import 'steps/step_timed_mission.dart';
import 'steps/step_mission_results.dart';
import 'steps/step_summary.dart';
import 'steps/step_speech_practice.dart';
import 'steps/step_stage_complete.dart';

/// Runs a lesson as a PageView of steps with a progress bar.
class HangulLessonFlowScreen extends StatefulWidget {
  final LessonData lesson;

  const HangulLessonFlowScreen({required this.lesson, super.key});

  @override
  State<HangulLessonFlowScreen> createState() => _HangulLessonFlowScreenState();
}

class _HangulLessonFlowScreenState extends State<HangulLessonFlowScreen> {
  late final PageController _pageController;
  int _currentStep = 0;

  // Scoring state collected across steps
  int _correctAnswers = 0;
  int _totalAnswers = 0;
  int _missionTimeSeconds = 0;
  int _missionCompleted = 0;
  bool _lessonCompleted = false;

  @override
  void initState() {
    super.initState();
    final hangul = context.read<HangulProvider>();
    final saved = hangul.getLessonProgress(widget.lesson.id);
    final canResume =
        saved != null && !saved.isCompleted && saved.completedSteps > 0;
    final maxIndex = widget.lesson.steps.length - 1;
    if (canResume) {
      _currentStep = saved.completedSteps.clamp(0, maxIndex);
    }
    _pageController = PageController(initialPage: _currentStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentStep < widget.lesson.steps.length - 1) {
      final nextStep = _currentStep + 1;
      final hangul = context.read<HangulProvider>();
      hangul.saveLessonCheckpoint(
        lessonId: widget.lesson.id,
        completedSteps: nextStep,
        totalSteps: widget.lesson.totalSteps,
      );
      setState(() => _currentStep = nextStep);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onStepCompleted({int correct = 0, int total = 0}) {
    _correctAnswers += correct;
    _totalAnswers += total;
    _goNext();
  }

  void _onMissionCompleted({
    required int timeSeconds,
    required int completed,
  }) {
    _missionTimeSeconds = timeSeconds;
    _missionCompleted = completed;
    _goNext();
  }

  int get _scorePercent {
    if (_totalAnswers == 0) return 100;
    return ((_correctAnswers / _totalAnswers) * 100).round();
  }

  int _calculateLemonsEarned() {
    if (widget.lesson.isMission) {
      if (_missionTimeSeconds > 0 && _missionTimeSeconds < 120) return 3;
      if (_missionTimeSeconds > 0 && _missionTimeSeconds < 180) return 2;
      if (_missionCompleted >= 3) return 1;
      return 1;
    }
    final score = _scorePercent;
    if (score >= 95) return 3;
    if (score >= 80) return 2;
    return 1;
  }

  Future<void> _completeLesson() async {
    if (_lessonCompleted) return;
    _lessonCompleted = true;

    final hangul = context.read<HangulProvider>();
    final gamification = context.read<GamificationProvider>();
    final lemons = _calculateLemonsEarned();

    await hangul.completeLesson(
      lessonId: widget.lesson.id,
      totalSteps: widget.lesson.totalSteps,
      bestScore: _scorePercent,
      lemonsEarned: lemons,
    );

    // Record lemon reward using a unique numeric key for hangul lessons
    final lessonKey = _hangulLessonKey(widget.lesson.id);
    await gamification.recordLessonReward(
      lessonId: lessonKey,
      quizScorePercent: _scorePercent,
    );
  }

  /// Convert lesson ID (e.g. '0-1', '5-M') to a unique numeric key for gamification.
  /// Uses 90000+ range to avoid collision with regular lesson IDs.
  /// Mission lessons (suffix 'M') use 99 as the lesson number.
  static int _hangulLessonKey(String lessonId) {
    final match = RegExp(r'^(\d+)-(\d+|M)$').firstMatch(lessonId);
    if (match == null) return 90000;
    final stage = int.tryParse(match.group(1) ?? '');
    if (stage == null) return 90000;
    final lessonPart = match.group(2) ?? '';
    final lesson = lessonPart == 'M' ? 99 : int.tryParse(lessonPart);
    if (lesson == null) return 90000;
    return 90000 + (stage * 100) + lesson;
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = widget.lesson.steps.length;
    final progress = (totalSteps > 0) ? (_currentStep + 1) / totalSteps : 0.0;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar: close + progress
            _buildTopBar(context, progress),
            // Step content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalSteps,
                itemBuilder: (context, index) {
                  final step = widget.lesson.steps[index];
                  return _buildStep(step, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, size: 22),
            onPressed: () => _showExitDialog(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey.shade200,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(Color(0xFFFFD54F)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_currentStep + 1}/${widget.lesson.steps.length}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('레슨 나가기'),
        content: const Text('진행 중인 레슨을 종료하시겠어요?\n현재 단계까지 자동 저장됩니다.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('계속하기'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('나가기'),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(LessonStep step, int index) {
    switch (step.type) {
      case StepType.intro:
        return StepIntro(
          step: step,
          onNext: _goNext,
        );
      case StepType.dragDrop:
        return StepDragDropAssembly(
          step: step,
          onCompleted: (correct, total) =>
              _onStepCompleted(correct: correct, total: total),
        );
      case StepType.soundExplore:
        return StepSoundExplore(
          step: step,
          onNext: _goNext,
        );
      case StepType.soundMatch:
        return StepSoundMatch(
          step: step,
          onCompleted: (correct, total) =>
              _onStepCompleted(correct: correct, total: total),
        );
      case StepType.speechPractice:
        return StepSpeechPractice(
          step: step,
          onCompleted: (correct, total) =>
              _onStepCompleted(correct: correct, total: total),
        );
      case StepType.syllableBuild:
        return StepSyllableBuild(
          step: step,
          onCompleted: (correct, total) =>
              _onStepCompleted(correct: correct, total: total),
        );
      case StepType.quizMcq:
        return StepQuizMcq(
          step: step,
          onCompleted: (correct, total) =>
              _onStepCompleted(correct: correct, total: total),
        );
      case StepType.missionIntro:
        return StepMissionIntro(
          step: step,
          onNext: _goNext,
        );
      case StepType.timedMission:
        return StepTimedMission(
          step: step,
          onCompleted: (timeSeconds, completed) => _onMissionCompleted(
              timeSeconds: timeSeconds, completed: completed),
        );
      case StepType.missionResults:
        return StepMissionResults(
          step: step,
          scorePercent: _scorePercent,
          missionTimeSeconds: _missionTimeSeconds,
          missionCompleted: _missionCompleted,
          lemonsEarned: _calculateLemonsEarned(),
          onNext: () async {
            await _completeLesson();
            _goNext();
          },
        );
      case StepType.summary:
        final hasNextStep = index < widget.lesson.steps.length - 1;
        final nextIsStageComplete = hasNextStep &&
            widget.lesson.steps[index + 1].type == StepType.stageComplete;
        return StepSummary(
          step: step,
          scorePercent: _scorePercent,
          lemonsEarned: _calculateLemonsEarned(),
          onComplete: () async {
            await _completeLesson();
            if (!mounted) return;
            if (nextIsStageComplete) {
              _goNext();
            } else {
              Navigator.pop(context);
            }
          },
        );
      case StepType.stageComplete:
        return StepStageComplete(
          step: step,
          onDone: () {
            if (mounted) Navigator.pop(context);
          },
        );
    }
  }
}
