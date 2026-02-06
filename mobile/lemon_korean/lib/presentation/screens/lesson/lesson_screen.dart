import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/repositories/content_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/settings_provider.dart';
import 'stages/stage1_intro.dart';
import 'stages/stage2_vocabulary.dart';
import 'stages/stage3_grammar.dart';
import 'stages/stage4_practice.dart';
import 'stages/stage5_dialogue.dart';
import 'stages/stage6_quiz.dart' show Stage6Quiz, VocabularyQuizResult;
import 'stages/stage7_summary.dart';

/// Lesson Screen
/// Full-screen immersive learning experience with dynamic stages
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
  late int _totalStages;
  late List<Map<String, dynamic>> _stages;
  final PageController _pageController = PageController();

  // Track lesson progress
  int _quizScore = 0;
  DateTime? _startTime;

  // Track vocabulary results from quiz
  List<Map<String, dynamic>> _vocabularyResults = [];

  // Lesson content loading state
  bool _isLoadingContent = true;
  String? _loadError;
  LessonModel? _fullLesson;
  final _contentRepository = ContentRepository();

  @override
  void initState() {
    super.initState();
    _stages = [];
    _totalStages = 0;
    _loadLessonContent();
    _enterImmersiveMode();
  }

  /// Load lesson content from API
  Future<void> _loadLessonContent() async {
    setState(() {
      _isLoadingContent = true;
      _loadError = null;
    });

    try {
      // Get user's language preference
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      final language = settingsProvider.contentLanguageCode;

      // Fetch full lesson content from API
      final fullLesson = await _contentRepository.getLesson(widget.lesson.id, language: language);

      if (fullLesson != null && fullLesson.content != null) {
        _fullLesson = fullLesson;
        _initializeStages();
        _startTime = DateTime.now();
      } else {
        _loadError = '레슨 콘텐츠를 불러올 수 없습니다';
      }
    } catch (e) {
      AppLogger.e('Load error', error: e, tag: 'LessonScreen');
      _loadError = '네트워크 오류가 발생했습니다';
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingContent = false;
        });
      }
    }
  }

  /// Initialize stages from lesson content (supports v1 and v2)
  void _initializeStages() {
    // Use _fullLesson (from API) if available, otherwise fall back to widget.lesson
    final content = _fullLesson?.content ?? widget.lesson.content;
    if (content == null) {
      _stages = [];
      _totalStages = 0;
      return;
    }

    // Check if v2 structure (stages array)
    if (content.containsKey('stages') && content['stages'] is List) {
      _stages = List<Map<String, dynamic>>.from(content['stages']);
      _stages.sort((a, b) => (a['order'] ?? 0).compareTo(b['order'] ?? 0));
    } else {
      // v1: Auto-migrate to v2 structure
      _stages = _migrateV1ToV2(content);
    }

    _totalStages = _stages.length;
  }

  /// Migrate v1 content structure to v2
  List<Map<String, dynamic>> _migrateV1ToV2(Map<String, dynamic> content) {
    final stages = <Map<String, dynamic>>[];
    final mapping = [
      {'key': 'stage1_intro', 'type': 'intro'},
      {'key': 'stage2_vocabulary', 'type': 'vocabulary'},
      {'key': 'stage3_grammar', 'type': 'grammar'},
      {'key': 'stage4_practice', 'type': 'practice'},
      {'key': 'stage5_dialogue', 'type': 'dialogue'},
      {'key': 'stage6_quiz', 'type': 'quiz'},
      {'key': 'stage7_summary', 'type': 'summary'},
    ];

    for (var i = 0; i < mapping.length; i++) {
      final m = mapping[i];
      if (content.containsKey(m['key'])) {
        stages.add({
          'id': 'stage_$i',
          'type': m['type'],
          'order': i,
          'data': content[m['key']],
        });
      }
    }

    return stages;
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
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exitLesson),
        content: Text(l10n.exitLessonConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.continueLearning),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.errorColor,
            ),
            child: Text(l10n.exitBtn),
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

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final timeSpent = _startTime != null
        ? DateTime.now().difference(_startTime!).inSeconds
        : 0;

    // Update vocabulary progress if we have results
    if (_vocabularyResults.isNotEmpty) {
      await progressProvider.updateVocabularyBatch(
        lessonId: widget.lesson.id,
        vocabularyResults: _vocabularyResults,
      );
    }

    // Save lesson completion
    if (authProvider.currentUser != null) {
      await progressProvider.completeLesson(
        userId: authProvider.currentUser!.id,
        lessonId: widget.lesson.id,
        quizScore: _quizScore,
        timeSpent: timeSpent,
      );
    }

    if (mounted) {
      // Show success message
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.lessonComplete),
          backgroundColor: AppConstants.successColor,
          duration: const Duration(seconds: 2),
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

  /// Update vocabulary results from quiz
  void _updateVocabularyResults(List<VocabularyQuizResult> results) {
    setState(() {
      _vocabularyResults = results.map((r) => r.toJson()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Show loading state
    if (_isLoadingContent) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.loadingLesson(widget.lesson.title),
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: Color(0xFF001F3F), // 짙은 남색
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Show error state
    if (_loadError != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget.lesson.title),
          backgroundColor: Colors.white,
          foregroundColor: AppConstants.textPrimary,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _loadError!,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  color: AppConstants.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadLessonContent,
                icon: const Icon(Icons.refresh),
                label: Text(l10n.retry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
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
      );
    }

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (didPop) return;
        await _showExitDialog();
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
                child: _totalStages == 0
                    ? _buildEmptyState()
                    : PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(), // Disable swipe
                        itemCount: _totalStages,
                        onPageChanged: (index) {
                          setState(() {
                            _currentStage = index;
                          });
                        },
                        itemBuilder: (context, index) =>
                            _buildStageWidget(_stages[index], index),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final l10n = AppLocalizations.of(context)!;
    final progress = _totalStages > 0 ? (_currentStage + 1) / _totalStages : 0.0;

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
            tooltip: l10n.exitBtn,
          ),

          const SizedBox(width: 8),

          // Progress Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stage indicator
                Text(
                  l10n.stageProgress(_currentStage + 1, _totalStages),
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

  /// Build stage widget based on type
  Widget _buildStageWidget(Map<String, dynamic> stage, int index) {
    final type = stage['type'] as String;
    final data = stage['data'] as Map<String, dynamic>?;
    final isFirst = index == 0;
    final isLast = index == _totalStages - 1;

    // Use _fullLesson (from API) if available, otherwise fall back to widget.lesson
    final lesson = _fullLesson ?? widget.lesson;

    switch (type) {
      case 'intro':
        return Stage1Intro(
          lesson: lesson,
          stageData: data,
          onNext: _nextStage,
        );
      case 'vocabulary':
        return Stage2Vocabulary(
          lesson: lesson,
          stageData: data,
          onNext: _nextStage,
          onPrevious: isFirst ? null : _previousStage,
        );
      case 'grammar':
        return Stage3Grammar(
          lesson: lesson,
          stageData: data,
          onNext: _nextStage,
          onPrevious: isFirst ? null : _previousStage,
        );
      case 'practice':
        return Stage4Practice(
          lesson: lesson,
          stageData: data,
          onNext: _nextStage,
          onPrevious: isFirst ? null : _previousStage,
        );
      case 'dialogue':
        return Stage5Dialogue(
          lesson: lesson,
          stageData: data,
          onNext: _nextStage,
          onPrevious: isFirst ? null : _previousStage,
        );
      case 'quiz':
        return Stage6Quiz(
          lesson: lesson,
          stageData: data,
          onNext: isLast ? _completeLessonAndExit : _nextStage,
          onPrevious: isFirst ? null : _previousStage,
          onScoreUpdate: _updateQuizScore,
          onVocabularyResults: _updateVocabularyResults,
        );
      case 'summary':
        return Stage7Summary(
          lesson: lesson,
          stageData: data,
          onComplete: _completeLessonAndExit,
          onPrevious: isFirst ? null : _previousStage,
        );
      default:
        final l10n = AppLocalizations.of(context)!;
        return Center(
          child: Text(
            l10n.unknownStageType(type),
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }

  /// Build empty state when no stages
  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noLessonContent,
            style: const TextStyle(
              fontSize: 18,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.back),
          ),
        ],
      ),
    );
  }
}
