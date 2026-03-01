import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 3 lessons — ㅐ/ㅔ 계열 모음, localized via [l10n].
List<LessonData> getStage3Lessons(AppLocalizations l10n) => <LessonData>[
  // ── Lesson 3-1: ㅐ ──
  LessonData(
    id: '3-1',
    title: l10n.hangulS3L1Title,
    subtitle: l10n.hangulS3L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS3L1Step0Title,
        description: l10n.hangulS3L1Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅐ',
            'result': '애',
          },
          'highlights': l10n.hangulS3L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS3L1Step1Title,
        description: l10n.hangulS3L1Step1Desc,
        data: {
          'characters': ['애', '개', '내'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L1Step2Title,
        description: l10n.hangulS3L1Step2Desc,
        data: {
          'characters': ['애', '개', '내'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS3L1Step3Title,
        description: l10n.hangulS3L1Step3Desc,
        data: {
          'questions': [
            {
              'answer': '애',
              'choices': ['아', '애']
            },
            {
              'answer': '개',
              'choices': ['가', '개']
            },
            {
              'answer': '내',
              'choices': ['나', '내']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS3L1Step4Title,
        data: {
          'lessonId': '3-1',
          'message': l10n.hangulS3L1Step4Msg,
        },
      ),
    ],
  ),

  // ── Lesson 3-2: ㅔ ──
  LessonData(
    id: '3-2',
    title: l10n.hangulS3L2Title,
    subtitle: l10n.hangulS3L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS3L2Step0Title,
        description: l10n.hangulS3L2Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅔ',
            'result': '에',
          },
          'highlights': l10n.hangulS3L2Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS3L2Step1Title,
        description: l10n.hangulS3L2Step1Desc,
        data: {
          'characters': ['에', '게', '네'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L2Step2Title,
        description: l10n.hangulS3L2Step2Desc,
        data: {
          'characters': ['에', '게', '네'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS3L2Step3Title,
        description: l10n.hangulS3L2Step3Desc,
        data: {
          'questions': [
            {
              'answer': '에',
              'choices': ['어', '에']
            },
            {
              'answer': '게',
              'choices': ['거', '게']
            },
            {
              'answer': '네',
              'choices': ['너', '네']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS3L2Step4Title,
        data: {
          'lessonId': '3-2',
          'message': l10n.hangulS3L2Step4Msg,
        },
      ),
    ],
  ),

  // ── Lesson 3-3: ㅐ vs ㅔ 구분 ──
  LessonData(
    id: '3-3',
    title: l10n.hangulS3L3Title,
    subtitle: l10n.hangulS3L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS3L3Step0Title,
        description: l10n.hangulS3L3Step0Desc,
        data: {
          'emoji': '🔍',
          'highlights': l10n.hangulS3L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS3L3Step1Title,
        description: l10n.hangulS3L3Step1Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS3L3Step1Q0,
              'answer': 'ㅐ',
              'choices': ['ㅐ', 'ㅔ']
            },
            {
              'question': l10n.hangulS3L3Step1Q1,
              'answer': 'ㅔ',
              'choices': ['ㅔ', 'ㅐ']
            },
            {
              'question': l10n.hangulS3L3Step1Q2,
              'answer': '애',
              'choices': ['애', '에']
            },
            {
              'question': l10n.hangulS3L3Step1Q3,
              'answer': '에',
              'choices': ['애', '에']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS3L3Step2Title,
        data: {
          'lessonId': '3-3',
          'message': l10n.hangulS3L3Step2Msg,
        },
      ),
    ],
  ),

  // ── Lesson 3-4: ㅒ ──
  LessonData(
    id: '3-4',
    title: l10n.hangulS3L4Title,
    subtitle: l10n.hangulS3L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS3L4Step0Title,
        description: l10n.hangulS3L4Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅒ',
            'result': '얘',
          },
          'highlights': l10n.hangulS3L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS3L4Step1Title,
        description: l10n.hangulS3L4Step1Desc,
        data: {
          'characters': ['얘', '걔', '냬'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L4Step2Title,
        description: l10n.hangulS3L4Step2Desc,
        data: {
          'characters': ['얘', '걔', '냬'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS3L4Step3Title,
        data: {
          'lessonId': '3-4',
          'message': l10n.hangulS3L4Step3Msg,
        },
      ),
    ],
  ),

  // ── Lesson 3-5: ㅖ ──
  LessonData(
    id: '3-5',
    title: l10n.hangulS3L5Title,
    subtitle: l10n.hangulS3L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS3L5Step0Title,
        description: l10n.hangulS3L5Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅖ',
            'result': '예',
          },
          'highlights': l10n.hangulS3L5Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS3L5Step1Title,
        description: l10n.hangulS3L5Step1Desc,
        data: {
          'characters': ['예', '계', '녜'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L5Step2Title,
        description: l10n.hangulS3L5Step2Desc,
        data: {
          'characters': ['예', '계', '녜'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS3L5Step3Title,
        data: {
          'lessonId': '3-5',
          'message': l10n.hangulS3L5Step3Msg,
        },
      ),
    ],
  ),

  // ── Lesson 3-6: ㅐ/ㅔ 계열 종합 ──
  LessonData(
    id: '3-6',
    title: l10n.hangulS3L6Title,
    subtitle: l10n.hangulS3L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS3L6Step0Title,
        description: l10n.hangulS3L6Step0Desc,
        data: {
          'emoji': '🧩',
          'highlights': l10n.hangulS3L6Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS3L6Step1Title,
        description: l10n.hangulS3L6Step1Desc,
        data: {
          'questions': [
            {
              'answer': '애',
              'choices': ['애', '에']
            },
            {
              'answer': '예',
              'choices': ['얘', '예']
            },
            {
              'answer': '걔',
              'choices': ['개', '걔']
            },
            {
              'answer': '게',
              'choices': ['게', '계']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS3L6Step2Title,
        description: l10n.hangulS3L6Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS3L6Step2Q0,
              'answer': 'ㅒ',
              'choices': ['ㅐ', 'ㅒ', 'ㅔ']
            },
            {
              'question': l10n.hangulS3L6Step2Q1,
              'answer': 'ㅖ',
              'choices': ['ㅔ', 'ㅖ', 'ㅐ']
            },
            {
              'question': l10n.hangulS3L6Step2Q2,
              'answer': '예',
              'choices': ['얘', '예']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS3L6Step3Title,
        data: {
          'lessonId': '3-6',
          'message': l10n.hangulS3L6Step3Msg,
        },
      ),
    ],
  ),

  // ── Lesson 3-7: Stage 3 Mission ──
  LessonData(
    id: '3-7',
    title: l10n.hangulS3L7Title,
    subtitle: l10n.hangulS3L7Subtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS3L7Step0Title,
        description: l10n.hangulS3L7Step0Desc,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS3L7Step1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㅇ', 'ㄱ', 'ㄴ', 'ㄷ'],
          'vowels': ['ㅐ', 'ㅔ', 'ㅒ', 'ㅖ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS3L7Step2Title,
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS3L7Step3Title,
        data: {
          'lessonId': '3-7',
          'message': l10n.hangulS3L7Step3Msg,
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS3CompleteTitle,
        data: {
          'message': l10n.hangulS3CompleteMsg,
          'stageNumber': 3,
        },
      ),
    ],
  ),
];
