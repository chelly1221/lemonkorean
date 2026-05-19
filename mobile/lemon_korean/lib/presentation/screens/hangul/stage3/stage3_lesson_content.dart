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
          'characters': ['애', '개', '내', '매', '배'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L1Step2Title,
        description: l10n.hangulS3L1Step2Desc,
        data: {
          'characters': ['애', '개', '내', '매', '배'],
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
            {
              'answer': '매',
              'choices': ['마', '매']
            },
            {
              'answer': '배',
              'choices': ['바', '배']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.writingPractice,
        title: '쓰기 연습',
        description: '배운 음절을 직접 써 보세요',
        data: {
          'characters': ['애', '개', '내'],
          'mode': 'trace',
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
          'characters': ['에', '게', '네', '메', '베'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L2Step2Title,
        description: l10n.hangulS3L2Step2Desc,
        data: {
          'characters': ['에', '게', '네', '메', '베'],
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
            {
              'answer': '메',
              'choices': ['머', '메']
            },
            {
              'answer': '베',
              'choices': ['버', '베']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.writingPractice,
        title: '쓰기 연습',
        description: '배운 음절을 직접 써 보세요',
        data: {
          'characters': ['에', '게', '네'],
          'mode': 'trace',
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
        title: 'ㅐ와 ㅔ — 현대 한국어에서의 발음',
        description:
            '현대 한국어에서 ㅐ와 ㅔ의 발음 차이는 거의 사라졌습니다. '
            '대부분의 한국인도 이 두 소리를 구분하지 않습니다. '
            '하지만 맞춤법에서는 여전히 구분하므로, 글자의 모양 차이를 기억하는 것이 중요합니다.',
        data: {
          'emoji': '🔍',
          'highlights': [
            '현대 한국어에서 발음 동일',
            '맞춤법에서만 구분',
            '모양으로 기억하기',
          ],
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
            {
              'question': l10n.hangulS3L3Step1Q3,
              'answer': '매',
              'choices': ['매', '메']
            },
            {
              'question': l10n.hangulS3L3Step1Q3,
              'answer': '베',
              'choices': ['배', '베']
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
        title: 'ㅒ 배우기',
        description:
            'ㅒ는 ㅐ에 \'ㅣ\'를 더한 것입니다. '
            '현대 한국어에서 ㅒ와 ㅐ의 발음 차이도 거의 없어졌지만, '
            '\'얘기\'(이야기)처럼 일부 단어에서 사용됩니다.',
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
          'characters': ['얘', '걔', '냬', '먜', '뱨'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 듣고 고르기',
        description: '소리를 듣고 맞는 글자를 고르세요',
        data: {
          'questions': [
            {'answer': '얘', 'choices': ['얘', '예']},
            {'answer': '걔', 'choices': ['걔', '계']},
            {'answer': '얘', 'choices': ['얘', '애']},
          ],
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L4Step2Title,
        description: l10n.hangulS3L4Step2Desc,
        data: {
          'characters': ['얘', '걔', '냬', '먜', '뱨'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: 'ㅒ 퀴즈',
        description: '배운 내용을 확인해 보세요',
        data: {
          'questions': [
            {
              'question': 'ㅒ가 들어간 글자는?',
              'answer': '얘',
              'choices': ['얘', '에', '예', '애'],
            },
            {
              'question': '걔의 모음은?',
              'answer': 'ㅒ',
              'choices': ['ㅒ', 'ㅔ', 'ㅐ', 'ㅖ'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.writingPractice,
        title: '쓰기 연습',
        description: '배운 음절을 직접 써 보세요',
        data: {
          'characters': ['얘', '걔', '냬'],
          'mode': 'trace',
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
        title: 'ㅖ 배우기',
        description:
            'ㅖ는 ㅔ에 \'ㅣ\'를 더한 것입니다. '
            '현대 한국어에서 ㅖ는 \'예\'를 제외하면 거의 ㅔ와 같이 발음됩니다. '
            '\'예의\', \'시계\' 등의 단어에서 사용합니다.',
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
          'characters': ['예', '계', '녜', '몌', '볘'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 듣고 고르기',
        description: '소리를 듣고 맞는 글자를 고르세요',
        data: {
          'questions': [
            {'answer': '예', 'choices': ['예', '에']},
            {'answer': '계', 'choices': ['계', '개']},
            {'answer': '예', 'choices': ['예', '얘']},
          ],
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS3L5Step2Title,
        description: l10n.hangulS3L5Step2Desc,
        data: {
          'characters': ['예', '계', '녜', '몌', '볘'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: 'ㅖ 퀴즈',
        description: '배운 내용을 확인해 보세요',
        data: {
          'questions': [
            {
              'question': 'ㅖ가 들어간 글자는?',
              'answer': '예',
              'choices': ['예', '에', '얘', '애'],
            },
            {
              'question': '계의 모음은?',
              'answer': 'ㅖ',
              'choices': ['ㅖ', 'ㅒ', 'ㅔ', 'ㅐ'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.writingPractice,
        title: '쓰기 연습',
        description: '배운 음절을 직접 써 보세요',
        data: {
          'characters': ['예', '계', '녜'],
          'mode': 'trace',
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
        title: 'ㅐ/ㅔ 계열 총정리',
        description:
            'ㅐ, ㅔ, ㅒ, ㅖ 네 모음은 현대 한국어에서 발음이 거의 같습니다. '
            '[e] 하나의 소리로 발음해도 자연스럽습니다. '
            '중요한 것은 맞춤법에서의 구분입니다.',
        data: {
          'emoji': '🧩',
          'highlights': [
            '네 모음 발음 거의 동일',
            '[e] 소리로 통일',
            '맞춤법 구분이 핵심',
          ],
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
            {
              'answer': '매',
              'choices': ['매', '메']
            },
            {
              'answer': '베',
              'choices': ['배', '베']
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

  // ── Lesson 3-7W: 보너스 - 단어 읽기 ──
  LessonData(
    id: '3-7W',
    title: '보너스: 단어 읽기',
    subtitle: '배운 글자로 단어를 읽어보세요',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '단어 소리 탐색',
        description: '단어를 들어보세요',
        data: {
          'characters': ['메뉴', '레고', '배', '게', '매미', '베개'],
          'type': 'word',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '단어 발음 연습',
        description: '단어를 따라 읽어보세요',
        data: {
          'characters': ['메뉴', '레고', '배', '게', '매미', '베개'],
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
            {'answer': '메뉴', 'choices': ['메뉴', '레고', '배']},
            {'answer': '레고', 'choices': ['레고', '게', '매미']},
            {'answer': '배', 'choices': ['배', '게', '베개']},
            {'answer': '매미', 'choices': ['메뉴', '매미', '베개']},
            {'answer': '베개', 'choices': ['베개', '배', '게']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '잘했어요!',
        data: {'lessonId': '3-7W', 'message': '단어 읽기 연습을 완료했어요!'},
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
          'consonants': ['ㅇ', 'ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ'],
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
