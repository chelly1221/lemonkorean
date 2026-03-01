import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 9 lessons — 받침 확장.
List<LessonData> getStage9Lessons(AppLocalizations l10n) => <LessonData>[
  LessonData(
    id: '9-1',
    title: l10n.hangulS9L1Title,
    subtitle: l10n.hangulS9L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS9L1Step0Title,
        description: l10n.hangulS9L1Step0Desc,
        data: {
          'highlights': l10n.hangulS9L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS9L1Step1Title,
        description: l10n.hangulS9L1Step1Desc,
        data: {
          'characters': ['닫', '곧', '묻'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS9L1Step2Title,
        description: l10n.hangulS9L1Step2Desc,
        data: {
          'characters': ['닫', '곧', '묻'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS9L1Step3Title,
        description: l10n.hangulS9L1Step3Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS9L1Step3Q0,
              'answer': '곧',
              'choices': ['곤', '곧', '골']
            },
            {
              'question': l10n.hangulS9L1Step3Q1,
              'answer': '닫',
              'choices': ['단', '닫', '달']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9L1Step4Title,
        data: {'lessonId': '9-1', 'message': l10n.hangulS9L1Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '9-2',
    title: l10n.hangulS9L2Title,
    subtitle: l10n.hangulS9L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS9L2Step0Title,
        description: l10n.hangulS9L2Step0Desc,
        data: {
          'characters': ['낮', '잊', '젖'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS9L2Step1Title,
        description: l10n.hangulS9L2Step1Desc,
        data: {
          'characters': ['낮', '잊', '젖'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS9L2Step2Title,
        description: l10n.hangulS9L2Step2Desc,
        data: {
          'questions': [
            {
              'answer': '낮',
              'choices': ['낮', '난', '날']
            },
            {
              'answer': '젖',
              'choices': ['전', '절', '젖']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9L2Step3Title,
        data: {'lessonId': '9-2', 'message': l10n.hangulS9L2Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '9-3',
    title: l10n.hangulS9L3Title,
    subtitle: l10n.hangulS9L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS9L3Step0Title,
        description: l10n.hangulS9L3Step0Desc,
        data: {
          'characters': ['꽃', '닻', '빚'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS9L3Step1Title,
        description: l10n.hangulS9L3Step1Desc,
        data: {
          'characters': ['꽃', '닻', '빚'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS9L3Step2Title,
        description: l10n.hangulS9L3Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS9L3Step2Q0,
              'answer': '꽃',
              'choices': ['꽃', '꼰', '꼴']
            },
            {
              'question': l10n.hangulS9L3Step2Q1,
              'answer': '닻',
              'choices': ['단', '닫', '닻']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9L3Step3Title,
        data: {'lessonId': '9-3', 'message': l10n.hangulS9L3Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '9-4',
    title: l10n.hangulS9L4Title,
    subtitle: l10n.hangulS9L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS9L4Step0Title,
        description: l10n.hangulS9L4Step0Desc,
        data: {
          'highlights': l10n.hangulS9L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS9L4Step1Title,
        description: l10n.hangulS9L4Step1Desc,
        data: {
          'characters': ['부엌', '밭', '앞'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS9L4Step2Title,
        description: l10n.hangulS9L4Step2Desc,
        data: {
          'characters': ['부엌', '밭', '앞'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS9L4Step3Title,
        description: l10n.hangulS9L4Step3Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS9L4Step3Q0,
              'answer': '밭',
              'choices': ['밭', '반', '발']
            },
            {
              'question': l10n.hangulS9L4Step3Q1,
              'answer': '앞',
              'choices': ['암', '앞', '안']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9L4Step4Title,
        data: {'lessonId': '9-4', 'message': l10n.hangulS9L4Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '9-5',
    title: l10n.hangulS9L5Title,
    subtitle: l10n.hangulS9L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS9L5Step0Title,
        description: l10n.hangulS9L5Step0Desc,
        data: {
          'characters': ['좋', '놓', '않'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS9L5Step1Title,
        description: l10n.hangulS9L5Step1Desc,
        data: {
          'characters': ['좋', '놓', '않'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS9L5Step2Title,
        description: l10n.hangulS9L5Step2Desc,
        data: {
          'questions': [
            {
              'answer': '좋',
              'choices': ['좋', '존', '졸']
            },
            {
              'answer': '놓',
              'choices': ['논', '놀', '놓']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9L5Step3Title,
        data: {'lessonId': '9-5', 'message': l10n.hangulS9L5Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '9-6',
    title: l10n.hangulS9L6Title,
    subtitle: l10n.hangulS9L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS9L6Step0Title,
        description: l10n.hangulS9L6Step0Desc,
        data: {'emoji': '🎯'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS9L6Step1Title,
        description: l10n.hangulS9L6Step1Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS9L6Step1Q0,
              'answer': '곧',
              'choices': ['곤', '골', '곧']
            },
            {
              'question': l10n.hangulS9L6Step1Q1,
              'answer': '낮',
              'choices': ['낮', '난', '날']
            },
            {
              'question': l10n.hangulS9L6Step1Q2,
              'answer': '꽃',
              'choices': ['꽃', '꼰', '꼴']
            },
            {
              'question': l10n.hangulS9L6Step1Q3,
              'answer': '좋',
              'choices': ['존', '좋', '졸']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9L6Step2Title,
        data: {'lessonId': '9-6', 'message': l10n.hangulS9L6Step2Msg},
      ),
    ],
  ),
  LessonData(
    id: '9-7',
    title: l10n.hangulS9L7Title,
    subtitle: l10n.hangulS9L7Subtitle,
    steps: [
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS9L7Step0Title,
        description: l10n.hangulS9L7Step0Desc,
        data: {
          'questions': [
            {
              'question': '부 + ㅌ = ?',
              'answer': '붙',
              'choices': ['분', '불', '붙']
            },
            {
              'question': '조 + ㅎ = ?',
              'answer': '좋',
              'choices': ['존', '종', '좋']
            },
            {
              'question': '아 + ㅍ = ?',
              'answer': '앞',
              'choices': ['안', '앞', '암']
            },
            {
              'question': '노 + ㅎ = ?',
              'answer': '놓',
              'choices': ['논', '놀', '놓']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9L7Step1Title,
        data: {
          'lessonId': '9-7',
          'message': l10n.hangulS9L7Step1Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '9-M',
    title: l10n.hangulS9LMTitle,
    subtitle: l10n.hangulS9LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS9LMStep0Title,
        description: l10n.hangulS9LMStep0Desc,
        data: {'timeLimit': 90, 'targetCount': 6},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS9LMStep1Title,
        data: {
          'timeLimitSeconds': 90,
          'targetCount': 6,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅈ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS9LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS9LMStep3Title,
        data: {'message': l10n.hangulS9LMStep3Msg},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS9CompleteTitle,
        data: {
          'message': l10n.hangulS9CompleteMsg,
          'stageNumber': 9,
        },
      ),
    ],
  ),
];
