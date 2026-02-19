import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/gamification_provider.dart';
import '../../../providers/hangul_provider.dart';
import '../../hangul/hangul_level0_learning_screen.dart';
import '../../hangul/stage0/hangul_stage0_lesson_list_screen.dart';
import '../../hangul/hangul_practice_screen.dart';
import '../../hangul/hangul_syllable_screen.dart';
import '../../hangul/hangul_batchim_screen.dart';
import '../../hangul/hangul_discrimination_screen.dart';
import '../../hangul/hangul_table_screen.dart';
import '../../hangul/widgets/hangul_stage_path_view.dart';
import '../../hangul/widgets/hangul_stats_bar.dart';

/// Lemon orchard dashboard for Level 0 (Hangul).
/// Shows action buttons, stats bar, and inline lemon stage path.
class HangulDashboardView extends StatefulWidget {
  const HangulDashboardView({super.key});

  @override
  State<HangulDashboardView> createState() => _HangulDashboardViewState();
}

class _HangulDashboardViewState extends State<HangulDashboardView> {
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final hangul = context.read<HangulProvider>();
    final auth = context.read<AuthProvider>();

    await hangul.loadAlphabetTable();
    await hangul.loadLessonProgress();
    if (auth.currentUser != null) {
      await hangul.loadProgress(auth.currentUser!.id);
    }
    if (mounted) setState(() => _loaded = true);
  }

  static const _stages = <({int stage, String title, String subtitle})>[
    (stage: 0, title: '한글 구조 이해', subtitle: '자음 + 모음 = 글자(음절) 개념'),
    (stage: 1, title: '핵심 모음', subtitle: '기본 모음과 확장 모음'),
    (stage: 2, title: '기본 자음', subtitle: '조합 가능한 기본 자음 세트'),
    (stage: 3, title: '본격 조합 훈련', subtitle: '자음×모음 리듬 읽기와 대비 훈련'),
    (stage: 4, title: '된소리 / 거센소리', subtitle: '혼동쌍 집중 훈련'),
    (stage: 5, title: '받침(종성) 1차', subtitle: '핵심 받침부터 읽기 강화'),
    (stage: 6, title: '받침 확장', subtitle: '확장 받침 및 소리 변동 도입'),
    (stage: 7, title: '복합 받침', subtitle: '고급 받침 조합'),
    (stage: 8, title: '단어 읽기 확장', subtitle: '받침 유무 단어 읽기'),
  ];

  // ── Progress helpers ──────────────────────────────────────────

  static List<double> _getStageProgress(HangulProvider provider) {
    final overall = provider.overallProgress.clamp(0.0, 1.0);
    final stageSpan = _stages.length.toDouble();
    final completedStages = overall * stageSpan;

    return List<double>.generate(_stages.length, (index) {
      final stageCompletion = (completedStages - index).clamp(0.0, 1.0);
      return stageCompletion * 5.0;
    });
  }

  static List<StageVisualState> _getStageStates(List<double> stageProgress) {
    return stageProgress.map((mastery) {
      if (mastery <= 0) return StageVisualState.notStarted;
      if (mastery >= 5) return StageVisualState.completed;
      return StageVisualState.inProgress;
    }).toList();
  }

  // ── Navigation ────────────────────────────────────────────────

  static void _navigateToStage(BuildContext context, int stage) {
    Widget screen;
    switch (stage) {
      case 0:
        screen = const HangulStage0LessonListScreen();
        break;
      case 1:
        screen = const HangulStage1VowelsScreen();
        break;
      case 2:
        screen = const HangulStage2ConsonantsScreen();
        break;
      case 3:
        screen = const HangulStage3SyllableReadingScreen();
        break;
      case 4:
        screen = const HangulStage4ContrastScreen();
        break;
      case 5:
        screen = const HangulStage5BatchimBasicScreen();
        break;
      case 6:
        screen = const HangulStage6BatchimExtendedScreen();
        break;
      case 7:
        screen = const HangulStage7AdvancedBatchimScreen();
        break;
      case 8:
        screen = const HangulStage8WordReadingScreen();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$stage단계 상세 내용은 다음 지시 후 추가됩니다.')),
        );
        return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // ── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Consumer2<HangulProvider, GamificationProvider>(
      builder: (context, hangul, gamification, _) {
        if (!_loaded || hangul.isLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 80),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final stageProgress = _getStageProgress(hangul);
        final stageStates = _getStageStates(stageProgress);
        final stats = hangul.stats;
        final isBossUnlocked =
            stageStates.every((s) => s == StageVisualState.completed);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                // Action buttons
                _buildActionButtons(context),

                const SizedBox(height: 8),

                // Stats bar
                HangulStatsBar(
                  totalLemons: gamification.totalLemons,
                  charactersLearned: stats?.charactersLearned ?? 0,
                  totalCharacters: stats?.totalCharacters ?? 40,
                  dueForReview: stats?.dueForReview ?? 0,
                  onReviewTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HangulPracticeScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // Inline lemon stage path
                HangulStagePathView(
                  stages: _stages,
                  stageProgress: stageProgress,
                  stageStates: stageStates,
                  levelColor: const Color(0xFFFFD54F),
                  onStageTap: (stage) => _navigateToStage(context, stage),
                  isBossUnlocked: isBossUnlocked,
                  isBossCompleted: false,
                  completedLessonsMap: {
                    0: hangul.getCompletedLessonCount(0),
                  },
                  onBossTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('보스 퀴즈는 준비 중입니다.'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Action buttons ────────────────────────────────────────────

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.grid_view,
              label: '자모표',
              color: const Color(0xFF4CAF50),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HangulTableScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              icon: Icons.extension,
              label: '음절조합',
              color: const Color(0xFF2196F3),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HangulSyllableScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              icon: Icons.abc,
              label: '받침연습',
              color: const Color(0xFF9C27B0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HangulBatchimScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildActionButton(
              icon: Icons.hearing,
              label: '소리구분훈련',
              color: const Color(0xFFFF9800),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HangulDiscriminationScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(
          begin: 0.12,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
