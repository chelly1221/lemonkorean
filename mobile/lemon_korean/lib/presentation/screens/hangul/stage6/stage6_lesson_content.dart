import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 6 lessons — 본격 조합 훈련.
List<LessonData> getStage6Lessons(AppLocalizations l10n) => <LessonData>[
  LessonData(
    id: '6-1',
    title: l10n.hangulS6L1Title,
    subtitle: l10n.hangulS6L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L1Step0Title,
        description: l10n.hangulS6L1Step0Desc,
        data: {
          'highlights': l10n.hangulS6L1Step0Highlights.split(','),
          'emoji': '🔤',
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS6L1Step1Title,
        description: l10n.hangulS6L1Step1Desc,
        data: {
          'characters': ['가', '거', '고', '구', '그', '기'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS6L1Step2Title,
        description: l10n.hangulS6L1Step2Desc,
        data: {
          'characters': ['가', '거', '고', '구', '그', '기'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS6L1Step3Title,
        description: l10n.hangulS6L1Step3Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS6L1Step3Q0,
              'answer': '가',
              'choices': ['가', '나', '다']
            },
            {
              'question': l10n.hangulS6L1Step3Q1,
              'answer': '거',
              'choices': ['거', '고', '구']
            },
            {
              'question': l10n.hangulS6L1Step3Q2,
              'answer': '그',
              'choices': ['그', '기', '구']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L1Step4Title,
        data: {'lessonId': '6-1', 'message': l10n.hangulS6L1Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-2',
    title: l10n.hangulS6L2Title,
    subtitle: l10n.hangulS6L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L2Step0Title,
        description: l10n.hangulS6L2Step0Desc,
        data: {
          'highlights': l10n.hangulS6L2Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS6L2Step1Title,
        description: l10n.hangulS6L2Step1Desc,
        data: {
          'characters': ['나', '너', '노', '누', '느', '니'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS6L2Step2Title,
        description: l10n.hangulS6L2Step2Desc,
        data: {
          'characters': ['나', '너', '노', '누', '느', '니'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS6L2Step3Title,
        description: l10n.hangulS6L2Step3Desc,
        data: {
          'targets': [
            {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
            {'consonant': 'ㄴ', 'vowel': 'ㅗ', 'result': '노'},
            {'consonant': 'ㄴ', 'vowel': 'ㅣ', 'result': '니'},
          ],
          'consonantChoices': ['ㄴ', 'ㄷ', 'ㄹ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅣ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L2Step4Title,
        data: {'lessonId': '6-2', 'message': l10n.hangulS6L2Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-3',
    title: l10n.hangulS6L3Title,
    subtitle: l10n.hangulS6L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L3Step0Title,
        description: l10n.hangulS6L3Step0Desc,
        data: {
          'highlights': l10n.hangulS6L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS6L3Step1Title,
        description: l10n.hangulS6L3Step1Desc,
        data: {
          'questions': [
            {
              'answer': '다',
              'choices': ['다', '라']
            },
            {
              'answer': '로',
              'choices': ['도', '로']
            },
            {
              'answer': '루',
              'choices': ['두', '루']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS6L3Step2Title,
        description: l10n.hangulS6L3Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS6L3Step2Q0,
              'answer': '디',
              'choices': ['디', '리', '니']
            },
            {
              'question': l10n.hangulS6L3Step2Q1,
              'answer': '로',
              'choices': ['도', '로', '노']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L3Step3Title,
        data: {'lessonId': '6-3', 'message': l10n.hangulS6L3Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-4',
    title: l10n.hangulS6L4Title,
    subtitle: l10n.hangulS6L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L4Step0Title,
        description: l10n.hangulS6L4Step0Desc,
        data: {'emoji': '🎲'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS6L4Step1Title,
        description: l10n.hangulS6L4Step1Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS6L4Step1Q0,
              'answer': '고',
              'choices': ['고', '구', '거']
            },
            {
              'question': l10n.hangulS6L4Step1Q1,
              'answer': '누',
              'choices': ['누', '노', '너']
            },
            {
              'question': l10n.hangulS6L4Step1Q2,
              'answer': '라',
              'choices': ['라', '다', '나']
            },
            {
              'question': l10n.hangulS6L4Step1Q3,
              'answer': '미',
              'choices': ['미', '머', '모']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L4Step2Title,
        data: {'lessonId': '6-4', 'message': l10n.hangulS6L4Step2Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-5',
    title: l10n.hangulS6L5Title,
    subtitle: l10n.hangulS6L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L5Step0Title,
        description: l10n.hangulS6L5Step0Desc,
        data: {'emoji': '👂'},
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS6L5Step1Title,
        description: l10n.hangulS6L5Step1Desc,
        data: {
          'questions': [
            {
              'answer': '바',
              'choices': ['바', '마', '다']
            },
            {
              'answer': '서',
              'choices': ['서', '저', '더']
            },
            {
              'answer': '호',
              'choices': ['호', '오', '코']
            },
            {
              'answer': '주',
              'choices': ['주', '수', '부']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L5Step2Title,
        data: {'lessonId': '6-5', 'message': l10n.hangulS6L5Step2Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-6',
    title: l10n.hangulS6L6Title,
    subtitle: l10n.hangulS6L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L6Step0Title,
        description: l10n.hangulS6L6Step0Desc,
        data: {
          'highlights': l10n.hangulS6L6Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS6L6Step1Title,
        description: l10n.hangulS6L6Step1Desc,
        data: {
          'characters': ['와', '워', '과', '권'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS6L6Step2Title,
        description: l10n.hangulS6L6Step2Desc,
        data: {
          'characters': ['와', '워', '과'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS6L6Step3Title,
        description: l10n.hangulS6L6Step3Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS6L6Step3Q0,
              'answer': '와',
              'choices': ['와', '워', '왜']
            },
            {
              'question': l10n.hangulS6L6Step3Q1,
              'answer': '궈',
              'choices': ['과', '궈', '괴']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L6Step4Title,
        data: {'lessonId': '6-6', 'message': l10n.hangulS6L6Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-7',
    title: l10n.hangulS6L7Title,
    subtitle: l10n.hangulS6L7Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L7Step0Title,
        description: l10n.hangulS6L7Step0Desc,
        data: {
          'highlights': l10n.hangulS6L7Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L7Step1Title,
        description: l10n.hangulS6L7Step1Desc,
        data: {
          'emoji': '✨',
          'highlights': l10n.hangulS6L7Step1Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS6L7Step2Title,
        description: l10n.hangulS6L7Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS6L7Step2Q0,
              'answer': '왜',
              'choices': ['왜', '외', '웨']
            },
            {
              'question': l10n.hangulS6L7Step2Q1,
              'answer': '위',
              'choices': ['의', '외', '위']
            },
            {
              'question': l10n.hangulS6L7Step2Q2,
              'answer': '의',
              'choices': ['의', '위', '왜']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L7Step3Title,
        data: {'lessonId': '6-7', 'message': l10n.hangulS6L7Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-8',
    title: l10n.hangulS6L8Title,
    subtitle: l10n.hangulS6L8Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS6L8Step0Title,
        description: l10n.hangulS6L8Step0Desc,
        data: {'emoji': '🧩'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS6L8Step1Title,
        description: l10n.hangulS6L8Step1Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS6L8Step1Q0,
              'answer': '긔',
              'choices': ['기', '귀', '긔']
            },
            {
              'question': l10n.hangulS6L8Step1Q1,
              'answer': '화',
              'choices': ['호', '화', '휘']
            },
            {
              'question': l10n.hangulS6L8Step1Q2,
              'answer': '뷔',
              'choices': ['비', '뵈', '뷔']
            },
            {
              'question': l10n.hangulS6L8Step1Q3,
              'answer': '줘',
              'choices': ['조', '줘', '쥐']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6L8Step2Title,
        data: {'lessonId': '6-8', 'message': l10n.hangulS6L8Step2Msg},
      ),
    ],
  ),
  LessonData(
    id: '6-M',
    title: l10n.hangulS6LMTitle,
    subtitle: l10n.hangulS6LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS6LMStep0Title,
        description: l10n.hangulS6LMStep0Desc,
        data: {
          'timeLimit': 120,
          'targetCount': 8,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS6LMStep1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ', 'ㅡ', 'ㅣ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS6LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS6LMStep3Title,
        data: {
          'lessonId': '6-M',
          'message': l10n.hangulS6LMStep3Msg,
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS6CompleteTitle,
        data: {
          'message': l10n.hangulS6CompleteMsg,
          'stageNumber': 6,
        },
      ),
    ],
  ),
];
