import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 8 lessons — 받침(종성) 1차, localized via [l10n].
List<LessonData> getStage8Lessons(AppLocalizations l10n) => <LessonData>[
  // ── Lesson 8-0: 받침 개념 ──
  LessonData(
    id: '8-0',
    title: l10n.hangulS8L0Title,
    subtitle: l10n.hangulS8L0Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS8L0Step0Title,
        description: l10n.hangulS8L0Step0Desc,
        data: {
          'highlights': l10n.hangulS8L0Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS8L0Step1Title,
        description: l10n.hangulS8L0Step1Desc,
        data: {
          'emoji': '🔑',
          'highlights': l10n.hangulS8L0Step1Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS8L0Step2Title,
        description: l10n.hangulS8L0Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS8L0Step2Q0,
              'answer': 'ㄴ',
              'choices': ['ㄱ', 'ㅏ', 'ㄴ']
            },
            {
              'question': l10n.hangulS8L0Step2Q1,
              'answer': 'ㄹ',
              'choices': ['ㅁ', 'ㅏ', 'ㄹ']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L0SummaryTitle,
        data: {'lessonId': '8-0', 'message': l10n.hangulS8L0SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-1: ㄴ 받침 ──
  LessonData(
    id: '8-1',
    title: l10n.hangulS8L1Title,
    subtitle: l10n.hangulS8L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS8L1Step0Title,
        description: l10n.hangulS8L1Step0Desc,
        data: {
          'characters': ['간', '난', '단'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS8L1Step1Title,
        description: l10n.hangulS8L1Step1Desc,
        data: {
          'characters': ['간', '난', '단'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS8L1Step2Title,
        description: l10n.hangulS8L1Step2Desc,
        data: {
          'questions': [
            {
              'answer': '간',
              'choices': ['가', '간', '감']
            },
            {
              'answer': '난',
              'choices': ['난', '나', '날']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L1SummaryTitle,
        data: {'lessonId': '8-1', 'message': l10n.hangulS8L1SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-2: ㄹ 받침 ──
  LessonData(
    id: '8-2',
    title: l10n.hangulS8L2Title,
    subtitle: l10n.hangulS8L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS8L2Step0Title,
        description: l10n.hangulS8L2Step0Desc,
        data: {
          'characters': ['말', '갈', '물'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS8L2Step1Title,
        description: l10n.hangulS8L2Step1Desc,
        data: {
          'characters': ['말', '갈', '물'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS8L2Step2Title,
        description: l10n.hangulS8L2Step2Desc,
        data: {
          'questions': [
            {
              'answer': '말',
              'choices': ['말', '만', '맛']
            },
            {
              'answer': '물',
              'choices': ['물', '문', '무']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L2SummaryTitle,
        data: {'lessonId': '8-2', 'message': l10n.hangulS8L2SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-3: ㅁ 받침 ──
  LessonData(
    id: '8-3',
    title: l10n.hangulS8L3Title,
    subtitle: l10n.hangulS8L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS8L3Step0Title,
        description: l10n.hangulS8L3Step0Desc,
        data: {
          'characters': ['감', '밤', '숨'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS8L3Step1Title,
        description: l10n.hangulS8L3Step1Desc,
        data: {
          'characters': ['감', '밤', '숨'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS8L3Step2Title,
        description: l10n.hangulS8L3Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS8L3Step2Q0,
              'answer': '밤',
              'choices': ['발', '밤', '밥']
            },
            {
              'question': l10n.hangulS8L3Step2Q1,
              'answer': '감',
              'choices': ['간', '감', '갓']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L3SummaryTitle,
        data: {'lessonId': '8-3', 'message': l10n.hangulS8L3SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-4: ㅇ 받침 ──
  LessonData(
    id: '8-4',
    title: l10n.hangulS8L4Title,
    subtitle: l10n.hangulS8L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS8L4Step0Title,
        description: l10n.hangulS8L4Step0Desc,
        data: {
          'emoji': '💡',
          'highlights': l10n.hangulS8L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS8L4Step1Title,
        description: l10n.hangulS8L4Step1Desc,
        data: {
          'characters': ['방', '공', '종'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS8L4Step2Title,
        description: l10n.hangulS8L4Step2Desc,
        data: {
          'characters': ['방', '공', '종'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS8L4Step3Title,
        description: l10n.hangulS8L4Step3Desc,
        data: {
          'questions': [
            {
              'answer': '방',
              'choices': ['방', '반', '밤']
            },
            {
              'answer': '공',
              'choices': ['공', '곰', '고']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L4SummaryTitle,
        data: {'lessonId': '8-4', 'message': l10n.hangulS8L4SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-5: ㄱ 받침 ──
  LessonData(
    id: '8-5',
    title: l10n.hangulS8L5Title,
    subtitle: l10n.hangulS8L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS8L5Step0Title,
        description: l10n.hangulS8L5Step0Desc,
        data: {
          'characters': ['박', '각', '국'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS8L5Step1Title,
        description: l10n.hangulS8L5Step1Desc,
        data: {
          'characters': ['박', '각', '국'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS8L5Step2Title,
        description: l10n.hangulS8L5Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS8L5Step2Q0,
              'answer': '박',
              'choices': ['박', '밤', '발']
            },
            {
              'question': l10n.hangulS8L5Step2Q1,
              'answer': '국',
              'choices': ['군', '국', '굴']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L5SummaryTitle,
        data: {'lessonId': '8-5', 'message': l10n.hangulS8L5SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-6: ㅂ 받침 ──
  LessonData(
    id: '8-6',
    title: l10n.hangulS8L6Title,
    subtitle: l10n.hangulS8L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS8L6Step0Title,
        description: l10n.hangulS8L6Step0Desc,
        data: {
          'characters': ['밥', '집', '숲'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS8L6Step1Title,
        description: l10n.hangulS8L6Step1Desc,
        data: {
          'characters': ['밥', '집', '숲'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS8L6Step2Title,
        description: l10n.hangulS8L6Step2Desc,
        data: {
          'questions': [
            {
              'answer': '밥',
              'choices': ['밥', '밤', '반']
            },
            {
              'answer': '집',
              'choices': ['짐', '집', '질']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L6SummaryTitle,
        data: {'lessonId': '8-6', 'message': l10n.hangulS8L6SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-7: ㅅ 받침 ──
  LessonData(
    id: '8-7',
    title: l10n.hangulS8L7Title,
    subtitle: l10n.hangulS8L7Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS8L7Step0Title,
        description: l10n.hangulS8L7Step0Desc,
        data: {
          'characters': ['옷', '맛', '빛'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS8L7Step1Title,
        description: l10n.hangulS8L7Step1Desc,
        data: {
          'characters': ['옷', '맛', '빛'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS8L7Step2Title,
        description: l10n.hangulS8L7Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS8L7Step2Q0,
              'answer': '옷',
              'choices': ['옷', '온', '옹']
            },
            {
              'question': l10n.hangulS8L7Step2Q1,
              'answer': '빛',
              'choices': ['빈', '빔', '빛']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L7SummaryTitle,
        data: {'lessonId': '8-7', 'message': l10n.hangulS8L7SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-8: 받침 섞기 종합 ──
  LessonData(
    id: '8-8',
    title: l10n.hangulS8L8Title,
    subtitle: l10n.hangulS8L8Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS8L8Step0Title,
        description: l10n.hangulS8L8Step0Desc,
        data: {'emoji': '🧩'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS8L8Step1Title,
        description: l10n.hangulS8L8Step1Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS8L8Step1Q0,
              'answer': '문',
              'choices': ['문', '물', '묵']
            },
            {
              'question': l10n.hangulS8L8Step1Q1,
              'answer': '공',
              'choices': ['공', '곱', '곤']
            },
            {
              'question': l10n.hangulS8L8Step1Q2,
              'answer': '발',
              'choices': ['반', '밥', '발']
            },
            {
              'question': l10n.hangulS8L8Step1Q3,
              'answer': '집',
              'choices': ['짐', '집', '진']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8L8SummaryTitle,
        data: {'lessonId': '8-8', 'message': l10n.hangulS8L8SummaryMsg},
      ),
    ],
  ),

  // ── Lesson 8-M: 미션 ──
  LessonData(
    id: '8-M',
    title: l10n.hangulS8LMTitle,
    subtitle: l10n.hangulS8LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS8LMStep0Title,
        description: l10n.hangulS8LMStep0Desc,
        data: {'timeLimit': 120, 'targetCount': 8},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS8LMStep1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㅁ', 'ㅂ', 'ㅅ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS8LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS8LMSummaryTitle,
        data: {'message': l10n.hangulS8LMSummaryMsg},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS8CompleteTitle,
        data: {
          'message': l10n.hangulS8CompleteMsg,
          'stageNumber': 8,
        },
      ),
    ],
  ),
];
