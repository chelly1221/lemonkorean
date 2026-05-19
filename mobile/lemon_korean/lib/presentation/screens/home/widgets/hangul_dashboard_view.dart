import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/generated/app_localizations.dart';
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
import '../../hangul/stage12/hangul_stage12_lesson_list_screen.dart';
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
    (stage: 11, title: '음운 변화 규칙', subtitle: '자연스러운 발음을 위한 규칙'),
    (stage: 12, title: '문장 읽기', subtitle: '간단한 문장으로 한글 완성'),
  ];

  // ── Progress helpers ──────────────────────────────────────────

  static List<double> _getStageProgress(HangulProvider provider) {
    return List<double>.generate(_stages.length, (index) {
      final completed = provider.getCompletedLessonCount(index);
      final total = kStageLessonCounts[index];
      return ((completed / total) * 5.0).clamp(0.0, 5.0);
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
      case 12:
        screen = const HangulStage12LessonListScreen();
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.stageDetailComingSoon ?? '$stage단계 상세 내용은 다음 지시 후 추가됩니다.')),
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
        final stage4LessonCount = hangul.getCompletedLessonCount(4);
        final stage5LessonCount = hangul.getCompletedLessonCount(5);
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
                    4: stage4LessonCount,
                    5: stage5LessonCount,
                    6: hangul.getCompletedLessonCount(6),
                    7: hangul.getCompletedLessonCount(7),
                    8: hangul.getCompletedLessonCount(8),
                    9: hangul.getCompletedLessonCount(9),
                    10: hangul.getCompletedLessonCount(10),
                    11: hangul.getCompletedLessonCount(11),
                    12: hangul.getCompletedLessonCount(12),
                  },
                  onBossTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(AppLocalizations.of(context)?.bossQuizComingSoon ?? '보스 퀴즈는 준비 중입니다.'),
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
