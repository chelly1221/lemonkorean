import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/gamification_provider.dart';
import '../../../providers/hangul_provider.dart';
import '../../hangul/stage0/hangul_stage0_lesson_list_screen.dart';
import '../../hangul/stage1/hangul_stage1_lesson_list_screen.dart';
import '../../hangul/stage2/hangul_stage2_lesson_list_screen.dart';
import '../../hangul/stage3/hangul_stage3_lesson_list_screen.dart';
import '../../hangul/stage4/hangul_stage4_lesson_list_screen.dart';
import '../../hangul/stage5/hangul_stage5_lesson_list_screen.dart';
import '../../hangul/stage6/hangul_stage6_lesson_list_screen.dart';
import '../../hangul/stage7/hangul_stage7_lesson_list_screen.dart';
import '../../hangul/stage8/hangul_stage8_lesson_list_screen.dart';
import '../../hangul/stage9/hangul_stage9_lesson_list_screen.dart';
import '../../hangul/stage10/hangul_stage10_lesson_list_screen.dart';
import '../../hangul/stage11/hangul_stage11_lesson_list_screen.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadData();
    });
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
    (stage: 1, title: '기본 모음', subtitle: '기본 모음 6개 모양 + 소리 연결'),
    (stage: 2, title: 'Y-모음', subtitle: '기본 모음에 획 추가 = Y-소리'),
    (stage: 3, title: 'ㅐ/ㅔ 모음', subtitle: 'ㅐ/ㅔ 구분과 복합 단모음'),
    (stage: 4, title: '기본 자음 1', subtitle: 'ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ'),
    (stage: 5, title: '기본 자음 2', subtitle: 'ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ'),
    (stage: 6, title: '본격 조합 훈련', subtitle: '자음×모음 리듬 읽기와 복합모음'),
    (stage: 7, title: '된소리 / 거센소리', subtitle: '혼동쌍 집중 훈련'),
    (stage: 8, title: '받침(종성) 1차', subtitle: '핵심 받침부터 읽기 강화'),
    (stage: 9, title: '받침 확장', subtitle: '확장 받침 및 소리 변동 도입'),
    (stage: 10, title: '복합 받침', subtitle: '고급 받침 조합'),
    (stage: 11, title: '단어 읽기 확장', subtitle: '받침 유무 단어 읽기'),
  ];

  // ── Progress helpers ──────────────────────────────────────────

  static List<double> _getStageProgress(HangulProvider provider) {
    final overall = provider.overallProgress.clamp(0.0, 1.0);
    final stageSpan = _stages.length.toDouble();
    final completedStages = overall * stageSpan;

    final progress = List<double>.generate(_stages.length, (index) {
      final stageCompletion = (completedStages - index).clamp(0.0, 1.0);
      return stageCompletion * 5.0;
    });

    // Stage 0 is lesson-driven. Reflect real lesson completion so the lemon
    // slices and completion state match what user completed in Stage 0.
    final stage0Completed = provider.getCompletedLessonCount(0);
    final stage0Total = kStageLessonCounts[0];
    if (stage0Completed > 0) {
      final lessonBasedMastery =
          ((stage0Completed / stage0Total) * 5.0).clamp(0.0, 5.0);
      progress[0] =
          progress[0] < lessonBasedMastery ? lessonBasedMastery : progress[0];
    }

    // Split Stage 4 into two outer nodes (4-1 / 4-2) using real completion.
    final stage4Completed = provider.getCompletedLessonCount(4);
    if (stage4Completed > 0 && progress.length > 5) {
      final stage41Mastery =
          (((stage4Completed.clamp(0, 7)) / 7) * 5.0).clamp(0.0, 5.0);
      progress[4] = progress[4] < stage41Mastery ? stage41Mastery : progress[4];

      final stage42Completed = (stage4Completed - 7).clamp(0, 10);
      if (stage42Completed > 0) {
        final stage42Mastery = ((stage42Completed / 10) * 5.0).clamp(0.0, 5.0);
        progress[5] =
            progress[5] < stage42Mastery ? stage42Mastery : progress[5];
      }
    }

    return progress;
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
        screen = const HangulStage1LessonListScreen();
        break;
      case 2:
        screen = const HangulStage2LessonListScreen();
        break;
      case 3:
        screen = const HangulStage3LessonListScreen();
        break;
      case 4:
        screen = const HangulStage4LessonListScreen();
        break;
      case 5:
        screen = const HangulStage5LessonListScreen();
        break;
      case 6:
        screen = const HangulStage6LessonListScreen();
        break;
      case 7:
        screen = const HangulStage7LessonListScreen();
        break;
      case 8:
        screen = const HangulStage8LessonListScreen();
        break;
      case 9:
        screen = const HangulStage9LessonListScreen();
        break;
      case 10:
        screen = const HangulStage10LessonListScreen();
        break;
      case 11:
        screen = const HangulStage11LessonListScreen();
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
        final stage4Completed = hangul.getCompletedLessonCount(4);
        final stage41Completed = stage4Completed > 7 ? 7 : stage4Completed;
        final stage42Raw = stage4Completed > 7 ? stage4Completed - 7 : 0;
        final stage42Completed = stage42Raw > 10 ? 10 : stage42Raw;
        final isBossUnlocked =
            stageStates.every((s) => s == StageVisualState.completed);

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
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
                    1: hangul.getCompletedLessonCount(1),
                    2: hangul.getCompletedLessonCount(2),
                    3: hangul.getCompletedLessonCount(3),
                    4: stage41Completed,
                    5: stage42Completed,
                    6: hangul.getCompletedLessonCount(5),
                    7: hangul.getCompletedLessonCount(6),
                    8: hangul.getCompletedLessonCount(7),
                    9: hangul.getCompletedLessonCount(8),
                    10: hangul.getCompletedLessonCount(9),
                    11: hangul.getCompletedLessonCount(10),
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
}
