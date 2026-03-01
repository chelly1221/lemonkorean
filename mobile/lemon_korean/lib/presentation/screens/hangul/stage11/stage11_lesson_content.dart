import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 11 lessons — 단어 읽기 확장.
List<LessonData> getStage11Lessons(AppLocalizations l10n) => <LessonData>[
  LessonData(
    id: '11-1',
    title: l10n.hangulS11L1Title,
    subtitle: l10n.hangulS11L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS11L1Step0Title,
        description: l10n.hangulS11L1Step0Desc,
        data: {
          'highlights': l10n.hangulS11L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS11L1Step1Title,
        description: l10n.hangulS11L1Step1Desc,
        data: {
          'characters': ['바나나', '나비', '하마', '모자'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS11L1Step2Title,
        description: l10n.hangulS11L1Step2Desc,
        data: {
          'characters': ['바나나', '나비', '하마', '모자'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11L1Step3Title,
        data: {'lessonId': '11-1', 'message': l10n.hangulS11L1Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '11-2',
    title: l10n.hangulS11L2Title,
    subtitle: l10n.hangulS11L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS11L2Step0Title,
        description: l10n.hangulS11L2Step0Desc,
        data: {
          'characters': ['학교', '친구', '한국', '공부'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS11L2Step1Title,
        description: l10n.hangulS11L2Step1Desc,
        data: {
          'characters': ['학교', '친구', '한국', '공부'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS11L2Step2Title,
        description: l10n.hangulS11L2Step2Desc,
        data: {
          'questions': [
            {
              'answer': '학교',
              'choices': ['하교', '학교', '학구']
            },
            {
              'answer': '한국',
              'choices': ['한구', '한국', '하눅']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11L2Step3Title,
        data: {'lessonId': '11-2', 'message': l10n.hangulS11L2Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '11-3',
    title: l10n.hangulS11L3Title,
    subtitle: l10n.hangulS11L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS11L3Step0Title,
        description: l10n.hangulS11L3Step0Desc,
        data: {
          'highlights': l10n.hangulS11L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS11L3Step1Title,
        description: l10n.hangulS11L3Step1Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS11L3Step1Q0,
              'answer': '없다',
              'choices': ['업다', '없다', '엇다']
            },
            {
              'question': l10n.hangulS11L3Step1Q1,
              'answer': '읽기',
              'choices': ['익기', '일기', '읽기']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11L3Step2Title,
        data: {'lessonId': '11-3', 'message': l10n.hangulS11L3Step2Msg},
      ),
    ],
  ),
  LessonData(
    id: '11-4',
    title: l10n.hangulS11L4Title,
    subtitle: l10n.hangulS11L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS11L4Step0Title,
        description: l10n.hangulS11L4Step0Desc,
        data: {
          'characters': ['김치', '라면', '학교', '시장', '학생', '선생님'],
          'type': 'word',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS11L4Step1Title,
        description: l10n.hangulS11L4Step1Desc,
        data: {
          'characters': ['김치', '라면', '학교', '시장', '학생', '선생님'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS11L4Step2Title,
        description: l10n.hangulS11L4Step2Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS11L4Step2Q0,
              'answer': l10n.hangulS11L4Step2CatFood,
              'choices': [
                l10n.hangulS11L4Step2CatFood,
                l10n.hangulS11L4Step2CatPlace,
                l10n.hangulS11L4Step2CatPerson,
              ]
            },
            {
              'question': l10n.hangulS11L4Step2Q1,
              'answer': l10n.hangulS11L4Step2CatPlace,
              'choices': [
                l10n.hangulS11L4Step2CatFood,
                l10n.hangulS11L4Step2CatPlace,
                l10n.hangulS11L4Step2CatPerson,
              ]
            },
            {
              'question': l10n.hangulS11L4Step2Q2,
              'answer': l10n.hangulS11L4Step2CatPerson,
              'choices': [
                l10n.hangulS11L4Step2CatFood,
                l10n.hangulS11L4Step2CatPlace,
                l10n.hangulS11L4Step2CatPerson,
              ]
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11L4Step3Title,
        data: {'lessonId': '11-4', 'message': l10n.hangulS11L4Step3Msg},
      ),
    ],
  ),
  LessonData(
    id: '11-5',
    title: l10n.hangulS11L5Title,
    subtitle: l10n.hangulS11L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS11L5Step0Title,
        description: l10n.hangulS11L5Step0Desc,
        data: {
          'questions': [
            {
              'answer': '친구',
              'choices': ['친구', '친구들', '친국']
            },
            {
              'answer': '공부',
              'choices': ['공부', '공부해', '콩부']
            },
            {
              'answer': '학교',
              'choices': ['학고', '학교', '하교']
            },
            {
              'answer': '모자',
              'choices': ['모자', '모차', '모사']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11L5Step1Title,
        data: {'lessonId': '11-5', 'message': l10n.hangulS11L5Step1Msg},
      ),
    ],
  ),
  LessonData(
    id: '11-6',
    title: l10n.hangulS11L6Title,
    subtitle: l10n.hangulS11L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS11L6Step0Title,
        description: l10n.hangulS11L6Step0Desc,
        data: {
          'questions': [
            {
              'question': l10n.hangulS11L6Step0Q0,
              'answer': '나비',
              'choices': ['나비', '학교', '없다']
            },
            {
              'question': l10n.hangulS11L6Step0Q1,
              'answer': '한국',
              'choices': ['하누', '한국', '하국']
            },
            {
              'question': l10n.hangulS11L6Step0Q2,
              'answer': '많다',
              'choices': ['만다', '많다', '마다']
            },
            {
              'question': l10n.hangulS11L6Step0Q3,
              'answer': '시장',
              'choices': ['시장', '학생', '김치']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11L6Step1Title,
        data: {'lessonId': '11-6', 'message': l10n.hangulS11L6Step1Msg},
      ),
    ],
  ),

  // ── Lesson 11-7: 실생활 한국어 읽기 ──
  LessonData(
    id: '11-7',
    title: l10n.hangulS11L7Title,
    subtitle: l10n.hangulS11L7Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS11L7Step0Title,
        description: l10n.hangulS11L7Step0Desc,
        data: {
          'emoji': '🇰🇷',
          'highlights': l10n.hangulS11L7Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS11L7Step1Title,
        data: {
          'characters': ['아메리카노', '카페라떼', '녹차', '케이크'],
          'descriptions': l10n.hangulS11L7Step1Descs.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS11L7Step2Title,
        data: {
          'characters': ['서울역', '강남', '홍대입구', '명동'],
          'descriptions': l10n.hangulS11L7Step2Descs.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS11L7Step3Title,
        data: {
          'characters': ['안녕하세요', '감사합니다', '네', '아니요'],
          'descriptions': l10n.hangulS11L7Step3Descs.split(','),
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS11L7Step4Title,
        description: l10n.hangulS11L7Step4Desc,
        data: {
          'characters': ['안녕하세요', '감사합니다', '네', '아니요'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS11L7Step5Title,
        data: {
          'questions': [
            {
              'question': l10n.hangulS11L7Step5Q0,
              'answer': l10n.hangulS11L7Step5Q0Ans,
              'choices': [
                l10n.hangulS11L7Step5Q0C0,
                l10n.hangulS11L7Step5Q0C1,
                l10n.hangulS11L7Step5Q0C2,
              ]
            },
            {
              'question': l10n.hangulS11L7Step5Q1,
              'answer': l10n.hangulS11L7Step5Q1Ans,
              'choices': [
                l10n.hangulS11L7Step5Q1C0,
                l10n.hangulS11L7Step5Q1C1,
                l10n.hangulS11L7Step5Q1C2,
              ]
            },
            {
              'question': l10n.hangulS11L7Step5Q2,
              'answer': l10n.hangulS11L7Step5Q2Ans,
              'choices': [
                l10n.hangulS11L7Step5Q2C0,
                l10n.hangulS11L7Step5Q2C1,
                l10n.hangulS11L7Step5Q2C2,
              ]
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11L7Step6Title,
        data: {
          'message': l10n.hangulS11L7Step6Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '11-M',
    title: l10n.hangulS11LMTitle,
    subtitle: l10n.hangulS11LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS11LMStep0Title,
        description: l10n.hangulS11LMStep0Desc,
        data: {'timeLimit': 90, 'targetCount': 10},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS11LMStep1Title,
        data: {
          'timeLimitSeconds': 90,
          'targetCount': 10,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅎ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ', 'ㅡ', 'ㅣ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS11LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS11LMStep3Title,
        data: {'message': l10n.hangulS11LMStep3Msg},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS11LMStep4Title,
        data: {
          'message': l10n.hangulS11LMStep4Msg,
          'stageNumber': 11,
        },
      ),
    ],
  ),
];
