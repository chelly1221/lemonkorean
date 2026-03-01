import '../../../../l10n/generated/app_localizations.dart';

/// Step types for hangul interactive lessons.
enum StepType {
  intro,
  dragDrop,
  soundExplore,
  soundMatch,
  speechPractice,
  syllableBuild,
  quizMcq,
  missionIntro,
  timedMission,
  missionResults,
  summary,
  stageComplete,
}

/// Data for a single step within a lesson.
class LessonStep {
  final StepType type;
  final String title;
  final String? description;
  final Map<String, dynamic> data;

  const LessonStep({
    required this.type,
    required this.title,
    this.description,
    this.data = const {},
  });
}

/// Data for a lesson (collection of steps).
class LessonData {
  final String id; // e.g. '0-1'
  final String title;
  final String subtitle;
  final bool isMission;
  final List<LessonStep> steps;

  const LessonData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.steps,
    this.isMission = false,
  });

  int get totalSteps => steps.length;
}

/// All Stage 0 lessons, localized via [l10n].
List<LessonData> getStage0Lessons(AppLocalizations l10n) => <LessonData>[
  // ── Lesson 0-0: Hangul Introduction ──
  LessonData(
    id: '0-0',
    title: l10n.hangulS0L0Title,
    subtitle: l10n.hangulS0L0Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS0L0Step0Title,
        description: l10n.hangulS0L0Step0Desc,
        data: {
          'emoji': '📜',
          'highlights': l10n.hangulS0L0Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS0L0Step1Title,
        description: l10n.hangulS0L0Step1Desc,
        data: {
          'emoji': '👑',
          'highlights': l10n.hangulS0L0Step1Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS0L0Step2Title,
        description: l10n.hangulS0L0Step2Desc,
        data: {
          'emoji': '📝',
          'highlights': l10n.hangulS0L0Step2Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS0L0SummaryTitle,
        data: {
          'lessonId': '0-0',
          'message': l10n.hangulS0L0SummaryMsg,
        },
      ),
    ],
  ),

  // ── Lesson 0-1: Block Assembly (visual) ──
  LessonData(
    id: '0-1',
    title: l10n.hangulS0L1Title,
    subtitle: l10n.hangulS0L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS0L1IntroTitle,
        description: l10n.hangulS0L1IntroDesc,
        data: {
          'animation': {
            'consonant': 'ㄱ',
            'vowel': 'ㅏ',
            'result': '가',
          },
          'highlights': l10n.hangulS0L1IntroHighlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.dragDrop,
        title: l10n.hangulS0L1DragGaTitle,
        description: l10n.hangulS0L1DragGaDesc,
        data: {
          'items': [
            {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
          ],
        },
      ),
      LessonStep(
        type: StepType.dragDrop,
        title: l10n.hangulS0L1DragNaTitle,
        description: l10n.hangulS0L1DragNaDesc,
        data: {
          'items': [
            {
              'consonant': 'ㄴ',
              'vowel': 'ㅏ',
              'result': '나',
              'hint': 'ㄴ + ㅏ = 나'
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.dragDrop,
        title: l10n.hangulS0L1DragDaTitle,
        description: l10n.hangulS0L1DragDaDesc,
        data: {
          'items': [
            {
              'consonant': 'ㄷ',
              'vowel': 'ㅏ',
              'result': '다',
              'hint': 'ㄷ + ㅏ = 다'
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS0L1SummaryTitle,
        data: {
          'lessonId': '0-1',
          'message': l10n.hangulS0L1SummaryMsg,
        },
      ),
    ],
  ),

  // ── Lesson 0-2: Sound Exploration (audio) ──
  LessonData(
    id: '0-2',
    title: l10n.hangulS0L2Title,
    subtitle: l10n.hangulS0L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS0L2IntroTitle,
        description: l10n.hangulS0L2IntroDesc,
        data: {'emoji': '👂'},
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS0L2Sound1Title,
        description: l10n.hangulS0L2Sound1Desc,
        data: {
          'characters': ['ㄱ', 'ㄴ', 'ㄷ'],
          'type': 'consonant',
          'showMouth': false,
          'pronunciationMap': {'ㄱ': '가', 'ㄴ': '나', 'ㄷ': '다'},
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS0L2Sound2Title,
        description: l10n.hangulS0L2Sound2Desc,
        data: {
          'characters': ['ㅏ', 'ㅗ'],
          'type': 'vowel',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS0L2Sound3Title,
        description: l10n.hangulS0L2Sound3Desc,
        data: {
          'characters': ['가', '나', '다'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS0L2SummaryTitle,
        data: {
          'lessonId': '0-2',
          'message': l10n.hangulS0L2SummaryMsg,
        },
      ),
    ],
  ),

  // ── Lesson 0-3: Listen and Choose (audio quiz) ──
  LessonData(
    id: '0-3',
    title: l10n.hangulS0L3Title,
    subtitle: l10n.hangulS0L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS0L3IntroTitle,
        description: l10n.hangulS0L3IntroDesc,
        data: {'emoji': '🎧'},
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS0L3Sound1Title,
        description: l10n.hangulS0L3Sound1Desc,
        data: {
          'characters': ['가', '나', '다', '고', '노'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS0L3Match1Title,
        description: l10n.hangulS0L3Match1Desc,
        data: {
          'questions': [
            {'answer': '가', 'choices': ['가', '나']},
            {'answer': '다', 'choices': ['나', '다']},
            {'answer': '고', 'choices': ['고', '노']},
            {'answer': '노', 'choices': ['가', '노']},
          ],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS0L3Match2Title,
        description: l10n.hangulS0L3Match2Desc,
        data: {
          'questions': [
            {'answer': '가', 'choices': ['가', '고']},
            {'answer': '고', 'choices': ['가', '고']},
            {'answer': '나', 'choices': ['나', '노']},
            {'answer': '노', 'choices': ['나', '노']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS0L3SummaryTitle,
        data: {
          'lessonId': '0-3',
          'message': l10n.hangulS0L3SummaryMsg,
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS0CompleteTitle,
        data: {
          'message': l10n.hangulS0CompleteMsg,
          'stageNumber': 0,
        },
      ),
    ],
  ),
];
