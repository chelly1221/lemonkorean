import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 10 lessons — 복합 받침 (고급).
List<LessonData> getStage10Lessons(AppLocalizations l10n) => <LessonData>[
  LessonData(
    id: '10-1',
    title: l10n.hangulS10L1Title,
    subtitle: l10n.hangulS10L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS10L1Step0Title,
        description: l10n.hangulS10L1Step0Desc,
        data: {
          'emoji': '🧩',
          'highlights': l10n.hangulS10L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS10L1Step1Title,
        description: l10n.hangulS10L1Step1Desc,
        data: {
          'highlights': l10n.hangulS10L1Step1Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS10L1Step2Title,
        description: l10n.hangulS10L1Step2Desc,
        data: {
          'characters': ['몫', '넋'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS10L1Step3Title,
        description: l10n.hangulS10L1Step3Desc,
        data: {
          'characters': ['몫', '넋'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS10L1Step4Title,
        description: l10n.hangulS10L1Step4Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS10L1Step4Q0,
              'answer': '몫',
              'choices': ['목', '몫', '몬']
            },
            {
              'question': l10n.hangulS10L1Step4Q1,
              'answer': '넋',
              'choices': ['넋', '넌', '널']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS10L1Step5Title,
        data: {'lessonId': '10-1', 'message': l10n.hangulS10L1Step5Msg},
      ),
    ],
  ),
  LessonData(
    id: '10-2',
    title: l10n.hangulS10L2Title,
    subtitle: l10n.hangulS10L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS10L2Step0Title,
        description: l10n.hangulS10L2Step0Desc,
        data: {
          'characters': ['앉다', '많다'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS10L2Step1Title,
        description: l10n.hangulS10L2Step1Desc,
        data: {
          'characters': ['앉다', '많다'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS10L2Step2Title,
        description: l10n.hangulS10L2Step2Desc,
        data: {
          'questions': [
            {
              'answer': '앉다',
              'choices': ['안다', '앉다', '않다']
            },
            {
              'answer': '많다',
              'choices': ['만다', '많다', '맑다']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS10L2Step3Title,
        data: {'lessonId': '10-2', 'message': l10n.hangulS10L2Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '10-3',
    title: l10n.hangulS10L3Title,
    subtitle: l10n.hangulS10L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS10L3Step0Title,
        description: l10n.hangulS10L3Step0Desc,
        data: {
          'characters': ['읽다', '삶'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS10L3Step1Title,
        description: l10n.hangulS10L3Step1Desc,
        data: {
          'characters': ['읽다', '삶'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS10L3Step2Title,
        description: l10n.hangulS10L3Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS10L3Step2Q0,
              'answer': '읽다',
              'choices': ['일다', '읽다', '익다']
            },
            {
              'question': l10n.hangulS10L3Step2Q1,
              'answer': '삶',
              'choices': ['삼', '삶', '살']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS10L3Step3Title,
        data: {'lessonId': '10-3', 'message': l10n.hangulS10L3Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '10-4',
    title: l10n.hangulS10L4Title,
    subtitle: l10n.hangulS10L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS10L4Step0Title,
        description: l10n.hangulS10L4Step0Desc,
        data: {
          'highlights': l10n.hangulS10L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS10L4Step1Title,
        description: l10n.hangulS10L4Step1Desc,
        data: {
          'characters': ['넓다', '핥다', '읊다', '싫다'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS10L4Step2Title,
        description: l10n.hangulS10L4Step2Desc,
        data: {
          'characters': ['넓다', '핥다', '읊다', '싫다'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS10L4Step3Title,
        data: {'lessonId': '10-4', 'message': l10n.hangulS10L4Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '10-5',
    title: l10n.hangulS10L5Title,
    subtitle: l10n.hangulS10L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS10L5Step0Title,
        description: l10n.hangulS10L5Step0Desc,
        data: {
          'characters': ['없다', '없어'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS10L5Step1Title,
        description: l10n.hangulS10L5Step1Desc,
        data: {
          'characters': ['없다', '없어'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS10L5Step2Title,
        description: l10n.hangulS10L5Step2Desc,
        data: {
          'questions': [
            {
              'answer': '없다',
              'choices': ['업다', '없다', '엇다']
            },
            {
              'answer': '없어',
              'choices': ['없어', '업어', '엇어']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS10L5Step3Title,
        data: {'lessonId': '10-5', 'message': l10n.hangulS10L5Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '10-6',
    title: l10n.hangulS10L6Title,
    subtitle: l10n.hangulS10L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS10L6Step0Title,
        description: l10n.hangulS10L6Step0Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS10L6Step0Q0,
              'answer': '많다',
              'choices': ['만다', '많다', '말다']
            },
            {
              'question': l10n.hangulS10L6Step0Q1,
              'answer': '읽다',
              'choices': ['익다', '읽다', '일다']
            },
            {
              'question': l10n.hangulS10L6Step0Q2,
              'answer': '없다',
              'choices': ['업다', '엇다', '없다']
            },
            {
              'question': l10n.hangulS10L6Step0Q3,
              'answer': '몫',
              'choices': ['목', '몫', '몰']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS10L6Step1Title,
        data: {'lessonId': '10-6', 'message': l10n.hangulS10L6Step1Msg},
      ),
    ],
  ),
  LessonData(
    id: '10-M',
    title: l10n.hangulS10LMTitle,
    subtitle: l10n.hangulS10LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS10LMStep0Title,
        description: l10n.hangulS10LMStep0Desc,
        data: {'timeLimit': 120, 'targetCount': 6},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS10LMStep1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 6,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㅁ', 'ㅂ', 'ㅅ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS10LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS10LMStep3Title,
        data: {'message': l10n.hangulS10LMStep3Msg},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS10LMStep4Title,
        data: {
          'message': l10n.hangulS10CompleteMsg,
          'stageNumber': 10,
        },
      ),
    ],
  ),
];
