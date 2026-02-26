import '../stage0/stage0_lesson_content.dart';

/// All Stage 3 lessons — ㅐ/ㅔ 계열 모음.
const stage3Lessons = <LessonData>[
  LessonData(
    id: '3-1',
    title: 'ㅐ 모양과 소리',
    subtitle: 'ㅏ + ㅣ 조합 느낌 익히기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅐ는 이렇게 생겨요',
        description: 'ㅐ는 ㅏ 계열에서 파생된 모음이에요.\n'
            '대표 소리는 "애"로 익혀요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅐ',
            'result': '애',
          },
          'highlights': ['ㅐ', '애', '모양 인식'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅐ 소리 듣기',
        description: '애/개/내 소리를 들어보세요',
        data: {
          'characters': ['애', '개', '내'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅏ vs ㅐ 듣기',
        description: '아/애를 구분해요',
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
        title: '레슨 완료!',
        data: {
          'lessonId': '3-1',
          'message': '좋아요!\nㅐ(애) 모양과 소리를 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '3-2',
    title: 'ㅔ 모양과 소리',
    subtitle: 'ㅓ + ㅣ 조합 느낌 익히기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅔ는 이렇게 생겨요',
        description: 'ㅔ는 ㅓ 계열에서 파생된 모음이에요.\n'
            '대표 소리는 "에"로 익혀요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅔ',
            'result': '에',
          },
          'highlights': ['ㅔ', '에', '모양 인식'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅔ 소리 듣기',
        description: '에/게/네 소리를 들어보세요',
        data: {
          'characters': ['에', '게', '네'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅓ vs ㅔ 듣기',
        description: '어/에를 구분해요',
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
        title: '레슨 완료!',
        data: {
          'lessonId': '3-2',
          'message': '좋아요!\nㅔ(에) 모양과 소리를 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '3-3',
    title: 'ㅐ vs ㅔ 구분',
    subtitle: '모양 중심 구분 훈련',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '핵심은 모양 구분이에요',
        description: '초급에서는 ㅐ/ㅔ 소리가 비슷하게 들릴 수 있어요.\n'
            '그래서 먼저 모양 구분을 정확히 해요.',
        data: {
          'emoji': '🔍',
          'highlights': ['ㅐ', 'ㅔ', '모양 구분'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양 구분 퀴즈',
        description: 'ㅐ와 ㅔ를 정확히 선택해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅐ는?',
              'answer': 'ㅐ',
              'choices': ['ㅐ', 'ㅔ']
            },
            {
              'question': '다음 중 ㅔ는?',
              'answer': 'ㅔ',
              'choices': ['ㅔ', 'ㅐ']
            },
            {
              'question': 'ㅇ + ㅐ = ?',
              'answer': '애',
              'choices': ['애', '에']
            },
            {
              'question': 'ㅇ + ㅔ = ?',
              'answer': '에',
              'choices': ['애', '에']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '3-3',
          'message': '좋아요!\nㅐ/ㅔ 구분이 더 정확해졌어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '3-4',
    title: 'ㅒ 모양과 소리',
    subtitle: 'Y-ㅐ 계열 모음',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅒ를 익혀요',
        description: 'ㅒ는 ㅐ 계열의 Y-모음이에요.\n대표 소리는 "얘"예요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅒ',
            'result': '얘',
          },
          'highlights': ['ㅒ', '얘'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅒ 소리 듣기',
        description: '얘/걔/냬 소리를 들어보세요',
        data: {
          'characters': ['얘', '걔', '냬'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '3-4',
          'message': '좋아요!\nㅒ(얘) 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '3-5',
    title: 'ㅖ 모양과 소리',
    subtitle: 'Y-ㅔ 계열 모음',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅖ를 익혀요',
        description: 'ㅖ는 ㅔ 계열의 Y-모음이에요.\n대표 소리는 "예"예요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅖ',
            'result': '예',
          },
          'highlights': ['ㅖ', '예'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅖ 소리 듣기',
        description: '예/계/녜 소리를 들어보세요',
        data: {
          'characters': ['예', '계', '녜'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '3-5',
          'message': '좋아요!\nㅖ(예) 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '3-6',
    title: 'ㅐ/ㅔ 계열 종합',
    subtitle: 'ㅐ ㅔ ㅒ ㅖ 통합 점검',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '네 가지를 한 번에 구분해요',
        description: 'ㅐ/ㅔ/ㅒ/ㅖ를 모양과 소리로 함께 점검해요.',
        data: {
          'emoji': '🧩',
          'highlights': ['ㅐ', 'ㅔ', 'ㅒ', 'ㅖ'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 구분',
        description: '비슷한 소리 중 정답을 골라요',
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
        title: '모양 구분',
        description: '모양을 보고 빠르게 선택해요',
        data: {
          'questions': [
            {
              'question': '다음 중 Y-ㅐ 계열은?',
              'answer': 'ㅒ',
              'choices': ['ㅐ', 'ㅒ', 'ㅔ']
            },
            {
              'question': '다음 중 Y-ㅔ 계열은?',
              'answer': 'ㅖ',
              'choices': ['ㅔ', 'ㅖ', 'ㅐ']
            },
            {
              'question': 'ㅇ + ㅖ = ?',
              'answer': '예',
              'choices': ['얘', '예']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '3-6',
          'message': '좋아요!\n3단계 핵심 모음 구분이 안정됐어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '3-7',
    title: '3단계 미션',
    subtitle: 'ㅐ/ㅔ 계열 빠른 구분 미션',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '3단계 최종 미션',
        description: 'ㅐ/ㅔ 계열 조합을 빠르고 정확하게 맞춰요.',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '타임 미션',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㅇ', 'ㄱ', 'ㄴ', 'ㄷ'],
          'vowels': ['ㅐ', 'ㅔ', 'ㅒ', 'ㅖ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: '미션 결과',
      ),
      LessonStep(
        type: StepType.summary,
        title: '3단계 완료!',
        data: {
          'lessonId': '3-7',
          'message': '축하해요!\n3단계 ㅐ/ㅔ 계열 모음을 모두 마쳤어요.',
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 3 완료!',
        data: {
          'message': '모든 모음을 배웠어요!',
          'stageNumber': 3,
        },
      ),
    ],
  ),
];
