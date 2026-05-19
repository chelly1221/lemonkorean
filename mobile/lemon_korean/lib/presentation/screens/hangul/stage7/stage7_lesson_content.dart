import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 7 lessons — 된소리/거센소리 (5 contrast groups).
List<LessonData> getStage7Lessons(AppLocalizations l10n) => <LessonData>[
  LessonData(
    id: '7-1',
    title: l10n.hangulS7L1Title,
    subtitle: l10n.hangulS7L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS7L1Step0Title,
        description: l10n.hangulS7L1Step0Desc,
        data: {
          'highlights': l10n.hangulS7L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS7L1Step1Title,
        description: l10n.hangulS7L1Step1Desc,
        data: {
          'characters': ['가', '카', '까'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS7L1Step2Title,
        description: l10n.hangulS7L1Step2Desc,
        data: {
          'characters': ['가', '카', '까'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS7L1Step3Title,
        description: l10n.hangulS7L1Step3Desc,
        data: {
          'questions': [
            {
              'answer': '가',
              'choices': ['가', '카', '까']
            },
            {
              'answer': '카',
              'choices': ['가', '카', '까']
            },
            {
              'answer': '까',
              'choices': ['가', '카', '까']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS7L1Step4Title,
        description: l10n.hangulS7L1Step4Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS7L1Step4Q0,
              'answer': 'ㅋ',
              'choices': ['ㄱ', 'ㅋ', 'ㄲ']
            },
            {
              'question': l10n.hangulS7L1Step4Q1,
              'answer': 'ㄲ',
              'choices': ['ㄱ', 'ㅋ', 'ㄲ']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS7L1Step5Title,
        data: {'lessonId': '7-1', 'message': l10n.hangulS7L1Step5Msg},
      ),
    ],
  ),
  LessonData(
    id: '7-2',
    title: l10n.hangulS7L2Title,
    subtitle: l10n.hangulS7L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS7L2Step0Title,
        description: l10n.hangulS7L2Step0Desc,
        data: {
          'highlights': l10n.hangulS7L2Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS7L2Step1Title,
        description: l10n.hangulS7L2Step1Desc,
        data: {
          'characters': ['다', '타', '따'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS7L2Step2Title,
        description: l10n.hangulS7L2Step2Desc,
        data: {
          'characters': ['다', '타', '따'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS7L2Step3Title,
        description: l10n.hangulS7L2Step3Desc,
        data: {
          'questions': [
            {
              'answer': '다',
              'choices': ['다', '타', '따']
            },
            {
              'answer': '타',
              'choices': ['다', '타', '따']
            },
            {
              'answer': '따',
              'choices': ['다', '타', '따']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS7L2Step4Title,
        data: {'lessonId': '7-2', 'message': l10n.hangulS7L2Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '7-3',
    title: l10n.hangulS7L3Title,
    subtitle: l10n.hangulS7L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS7L3Step0Title,
        description: l10n.hangulS7L3Step0Desc,
        data: {
          'highlights': l10n.hangulS7L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS7L3Step1Title,
        description: l10n.hangulS7L3Step1Desc,
        data: {
          'characters': ['바', '파', '빠'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS7L3Step2Title,
        description: l10n.hangulS7L3Step2Desc,
        data: {
          'characters': ['바', '파', '빠'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS7L3Step3Title,
        description: l10n.hangulS7L3Step3Desc,
        data: {
          'questions': [
            {
              'answer': '바',
              'choices': ['바', '파', '빠']
            },
            {
              'answer': '파',
              'choices': ['바', '파', '빠']
            },
            {
              'answer': '빠',
              'choices': ['바', '파', '빠']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS7L3Step4Title,
        data: {'lessonId': '7-3', 'message': l10n.hangulS7L3Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '7-4',
    title: l10n.hangulS7L4Title,
    subtitle: l10n.hangulS7L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS7L4Step0Title,
        description: l10n.hangulS7L4Step0Desc,
        data: {
          'highlights': l10n.hangulS7L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS7L4Step1Title,
        description: l10n.hangulS7L4Step1Desc,
        data: {
          'characters': ['사', '싸'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS7L4Step2Title,
        description: l10n.hangulS7L4Step2Desc,
        data: {
          'characters': ['사', '싸'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS7L4Step3Title,
        description: l10n.hangulS7L4Step3Desc,
        data: {
          'questions': [
            {
              'answer': '사',
              'choices': ['사', '싸']
            },
            {
              'answer': '싸',
              'choices': ['사', '싸']
            },
            {
              'answer': '사',
              'choices': ['사', '싸']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS7L4Step4Title,
        data: {'lessonId': '7-4', 'message': l10n.hangulS7L4Step4Msg},
      ),
    ],
  ),
  LessonData(
    id: '7-5',
    title: l10n.hangulS7L5Title,
    subtitle: l10n.hangulS7L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS7L5Step0Title,
        description: l10n.hangulS7L5Step0Desc,
        data: {
          'highlights': l10n.hangulS7L5Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS7L5Step1Title,
        description: l10n.hangulS7L5Step1Desc,
        data: {
          'characters': ['자', '차', '짜'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS7L5Step2Title,
        description: l10n.hangulS7L5Step2Desc,
        data: {
          'characters': ['자', '차', '짜'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS7L5Step3Title,
        description: l10n.hangulS7L5Step3Desc,
        data: {
          'questions': [
            {
              'answer': '자',
              'choices': ['자', '차', '짜']
            },
            {
              'answer': '차',
              'choices': ['자', '차', '짜']
            },
            {
              'answer': '짜',
              'choices': ['자', '차', '짜']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS7L5Step4Title,
        data: {
          'lessonId': '7-5',
          'message': l10n.hangulS7L5Step4Msg,
        },
      ),
    ],
  ),
  // ── Lesson 7-5W: 보너스 - 단어 읽기 ──
  LessonData(
    id: '7-5W',
    title: '보너스: 단어 읽기',
    subtitle: '배운 글자로 단어를 읽어보세요',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '단어 소리 탐색',
        description: '단어를 들어보세요',
        data: {
          'characters': ['까치', '토끼', '뿌리', '따로', '쓰다', '아빠', '오빠', '까마귀'],
          'type': 'word',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '단어 발음 연습',
        description: '단어를 따라 읽어보세요',
        data: {
          'characters': ['까치', '토끼', '뿌리', '따로', '쓰다', '아빠', '오빠', '까마귀'],
          'maxAttempts': 3,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '단어 듣고 고르기',
        description: '소리를 듣고 맞는 단어를 고르세요',
        data: {
          'questions': [
            {'answer': '까치', 'choices': ['까치', '토끼', '뿌리']},
            {'answer': '토끼', 'choices': ['따로', '토끼', '쓰다']},
            {'answer': '뿌리', 'choices': ['뿌리', '아빠', '오빠']},
            {'answer': '아빠', 'choices': ['아빠', '오빠', '까치']},
            {'answer': '까마귀', 'choices': ['까마귀', '토끼', '따로']},
            {'answer': '쓰다', 'choices': ['쓰다', '뿌리', '아빠']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '잘했어요!',
        data: {'lessonId': '7-5W', 'message': '단어 읽기 연습을 완료했어요!'},
      ),
    ],
  ),

  LessonData(
    id: '7-M',
    title: l10n.hangulS7LMTitle,
    subtitle: l10n.hangulS7LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS7LMStep0Title,
        description: l10n.hangulS7LMStep0Desc,
        data: {'timeLimit': 120, 'targetCount': 8},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS7LMStep1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㅋ', 'ㄲ', 'ㄷ', 'ㅌ', 'ㄸ', 'ㅂ', 'ㅍ', 'ㅃ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS7LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS7LMStep3Title,
        data: {'message': l10n.hangulS7LMStep3Msg},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS7LMStep4Title,
        data: {
          'message': l10n.hangulS7LMStep4Msg,
          'stageNumber': 7,
        },
      ),
    ],
  ),
];
