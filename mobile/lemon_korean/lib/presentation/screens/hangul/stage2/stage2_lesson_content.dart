import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 2 lessons — Y-모음(ㅑ, ㅕ, ㅛ, ㅠ).
List<LessonData> getStage2Lessons(AppLocalizations l10n) => <LessonData>[
  // ── Lesson 2-1: ㅑ ──
  LessonData(
    id: '2-1',
    title: l10n.hangulS2L1Title,
    subtitle: l10n.hangulS2L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS2L1Step0Title,
        description: l10n.hangulS2L1Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅑ',
            'result': '야',
          },
          'highlights': l10n.hangulS2L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS2L1Step1Title,
        description: l10n.hangulS2L1Step1Desc,
        data: {
          'characters': ['야', '갸', '냐'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS2L1Step2Title,
        description: l10n.hangulS2L1Step2Desc,
        data: {
          'characters': ['야', '갸', '냐'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS2L1Step3Title,
        description: l10n.hangulS2L1Step3Desc,
        data: {
          'questions': [
            {
              'answer': '야',
              'choices': ['아', '야']
            },
            {
              'answer': '갸',
              'choices': ['가', '갸']
            },
            {
              'answer': '냐',
              'choices': ['냐', '나']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS2L1Step4Title,
        description: l10n.hangulS2L1Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅑ', 'result': '야'},
            {'consonant': 'ㄱ', 'vowel': 'ㅑ', 'result': '갸'},
            {'consonant': 'ㄴ', 'vowel': 'ㅑ', 'result': '냐'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅑ', 'ㅏ', 'ㅕ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS2L1Step5Title,
        description: l10n.hangulS2L1Step5Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS2L1Step5Q0,
              'answer': 'ㅑ',
              'choices': ['ㅏ', 'ㅑ', 'ㅕ']
            },
            {
              'question': l10n.hangulS2L1Step5Q1,
              'answer': '야',
              'choices': ['야', '아', '여']
            },
            {
              'question': l10n.hangulS2L1Step5Q2,
              'answer': '냐',
              'choices': ['나', '냐', '너']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS2L1Step6Title,
        data: {
          'lessonId': '2-1',
          'message': l10n.hangulS2L1Step6Msg,
        },
      ),
    ],
  ),

  // ── Lesson 2-2: ㅕ ──
  LessonData(
    id: '2-2',
    title: l10n.hangulS2L2Title,
    subtitle: l10n.hangulS2L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS2L2Step0Title,
        description: l10n.hangulS2L2Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅕ',
            'result': '여',
          },
          'highlights': l10n.hangulS2L2Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS2L2Step1Title,
        description: l10n.hangulS2L2Step1Desc,
        data: {
          'characters': ['여', '겨', '녀'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS2L2Step2Title,
        description: l10n.hangulS2L2Step2Desc,
        data: {
          'characters': ['여', '겨', '녀'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS2L2Step3Title,
        description: l10n.hangulS2L2Step3Desc,
        data: {
          'questions': [
            {
              'answer': '여',
              'choices': ['어', '여']
            },
            {
              'answer': '겨',
              'choices': ['거', '겨']
            },
            {
              'answer': '녀',
              'choices': ['너', '녀']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS2L2Step4Title,
        description: l10n.hangulS2L2Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅕ', 'result': '여'},
            {'consonant': 'ㄱ', 'vowel': 'ㅕ', 'result': '겨'},
            {'consonant': 'ㄴ', 'vowel': 'ㅕ', 'result': '녀'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅕ', 'ㅓ', 'ㅑ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS2L2Step5Title,
        data: {
          'lessonId': '2-2',
          'message': l10n.hangulS2L2Step5Msg,
        },
      ),
    ],
  ),

  // ── Lesson 2-3: ㅛ ──
  LessonData(
    id: '2-3',
    title: l10n.hangulS2L3Title,
    subtitle: l10n.hangulS2L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS2L3Step0Title,
        description: l10n.hangulS2L3Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅛ',
            'result': '요',
          },
          'highlights': l10n.hangulS2L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS2L3Step1Title,
        description: l10n.hangulS2L3Step1Desc,
        data: {
          'characters': ['요', '교', '뇨'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS2L3Step2Title,
        description: l10n.hangulS2L3Step2Desc,
        data: {
          'characters': ['요', '교', '뇨'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS2L3Step3Title,
        description: l10n.hangulS2L3Step3Desc,
        data: {
          'questions': [
            {
              'answer': '요',
              'choices': ['오', '요']
            },
            {
              'answer': '교',
              'choices': ['고', '교']
            },
            {
              'answer': '뇨',
              'choices': ['노', '뇨']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS2L3Step4Title,
        description: l10n.hangulS2L3Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅛ', 'result': '요'},
            {'consonant': 'ㄱ', 'vowel': 'ㅛ', 'result': '교'},
            {'consonant': 'ㄴ', 'vowel': 'ㅛ', 'result': '뇨'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅛ', 'ㅗ', 'ㅠ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS2L3Step5Title,
        data: {
          'lessonId': '2-3',
          'message': l10n.hangulS2L3Step5Msg,
        },
      ),
    ],
  ),

  // ── Lesson 2-4: ㅠ ──
  LessonData(
    id: '2-4',
    title: l10n.hangulS2L4Title,
    subtitle: l10n.hangulS2L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS2L4Step0Title,
        description: l10n.hangulS2L4Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅠ',
            'result': '유',
          },
          'highlights': l10n.hangulS2L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS2L4Step1Title,
        description: l10n.hangulS2L4Step1Desc,
        data: {
          'characters': ['유', '규', '뉴'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS2L4Step2Title,
        description: l10n.hangulS2L4Step2Desc,
        data: {
          'characters': ['유', '규', '뉴'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS2L4Step3Title,
        description: l10n.hangulS2L4Step3Desc,
        data: {
          'questions': [
            {
              'answer': '유',
              'choices': ['우', '유']
            },
            {
              'answer': '규',
              'choices': ['구', '규']
            },
            {
              'answer': '뉴',
              'choices': ['누', '뉴']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS2L4Step4Title,
        description: l10n.hangulS2L4Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅠ', 'result': '유'},
            {'consonant': 'ㄱ', 'vowel': 'ㅠ', 'result': '규'},
            {'consonant': 'ㄴ', 'vowel': 'ㅠ', 'result': '뉴'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅠ', 'ㅜ', 'ㅛ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS2L4Step5Title,
        data: {
          'lessonId': '2-4',
          'message': l10n.hangulS2L4Step5Msg,
        },
      ),
    ],
  ),

  // ── Lesson 2-5: Y-모음 묶음 구분 ──
  LessonData(
    id: '2-5',
    title: l10n.hangulS2L5Title,
    subtitle: l10n.hangulS2L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS2L5Step0Title,
        description: l10n.hangulS2L5Step0Desc,
        data: {
          'emoji': '⚡',
          'highlights': l10n.hangulS2L5Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS2L5Step1Title,
        description: l10n.hangulS2L5Step1Desc,
        data: {
          'characters': ['야', '여', '요', '유'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS2L5Step2Title,
        description: l10n.hangulS2L5Step2Desc,
        data: {
          'characters': ['야', '여', '요', '유'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS2L5Step3Title,
        description: l10n.hangulS2L5Step3Desc,
        data: {
          'questions': [
            {
              'answer': '야',
              'choices': ['야', '여']
            },
            {
              'answer': '요',
              'choices': ['요', '유']
            },
            {
              'answer': '여',
              'choices': ['야', '여']
            },
            {
              'answer': '유',
              'choices': ['요', '유']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS2L5Step4Title,
        description: l10n.hangulS2L5Step4Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS2L5Step4Q0,
              'answer': 'ㅑ',
              'choices': ['ㅑ', 'ㅏ', 'ㅕ']
            },
            {
              'question': l10n.hangulS2L5Step4Q1,
              'answer': 'ㅕ',
              'choices': ['ㅓ', 'ㅕ', 'ㅠ']
            },
            {
              'question': l10n.hangulS2L5Step4Q2,
              'answer': 'ㅛ',
              'choices': ['ㅛ', 'ㅗ', 'ㅠ']
            },
            {
              'question': l10n.hangulS2L5Step4Q3,
              'answer': 'ㅠ',
              'choices': ['ㅜ', 'ㅛ', 'ㅠ']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS2L5Step5Title,
        data: {
          'lessonId': '2-5',
          'message': l10n.hangulS2L5Step5Msg,
        },
      ),
    ],
  ),

  // ── Lesson 2-6: 기본 vs Y-모음 대비 ──
  LessonData(
    id: '2-6',
    title: l10n.hangulS2L6Title,
    subtitle: l10n.hangulS2L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS2L6Step0Title,
        description: l10n.hangulS2L6Step0Desc,
        data: {
          'emoji': '🧠',
          'highlights': l10n.hangulS2L6Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS2L6Step1Title,
        description: l10n.hangulS2L6Step1Desc,
        data: {
          'questions': [
            {
              'answer': '야',
              'choices': ['아', '야']
            },
            {
              'answer': '여',
              'choices': ['어', '여']
            },
            {
              'answer': '요',
              'choices': ['오', '요']
            },
            {
              'answer': '유',
              'choices': ['우', '유']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS2L6Step2Title,
        description: l10n.hangulS2L6Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS2L6Step2Q0,
              'answer': 'ㅑ',
              'choices': ['ㅏ', 'ㅑ']
            },
            {
              'question': l10n.hangulS2L6Step2Q1,
              'answer': 'ㅕ',
              'choices': ['ㅓ', 'ㅕ']
            },
            {
              'question': l10n.hangulS2L6Step2Q2,
              'answer': 'ㅛ',
              'choices': ['ㅗ', 'ㅛ']
            },
            {
              'question': l10n.hangulS2L6Step2Q3,
              'answer': 'ㅠ',
              'choices': ['ㅜ', 'ㅠ']
            },
            {
              'question': l10n.hangulS2L6Step2Q4,
              'answer': '유',
              'choices': ['우', '유', '요']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS2L6Step3Title,
        data: {
          'lessonId': '2-6',
          'message': l10n.hangulS2L6Step3Msg,
        },
      ),
    ],
  ),

  // ── Lesson 2-7: Stage 2 Mission ──
  LessonData(
    id: '2-7',
    title: l10n.hangulS2L7Title,
    subtitle: l10n.hangulS2L7Subtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS2L7Step0Title,
        description: l10n.hangulS2L7Step0Desc,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS2L7Step1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㅇ', 'ㄱ', 'ㄴ', 'ㄷ'],
          'vowels': ['ㅑ', 'ㅕ', 'ㅛ', 'ㅠ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS2L7Step2Title,
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS2L7Step3Title,
        data: {
          'lessonId': '2-7',
          'message': l10n.hangulS2L7Step3Msg,
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS2CompleteTitle,
        data: {
          'message': l10n.hangulS2CompleteMsg,
          'stageNumber': 2,
        },
      ),
    ],
  ),
];
