import '../stage0/stage0_lesson_content.dart';

/// All Stage 8 lessons — 받침(종성) 1차.
const stage8Lessons = <LessonData>[
  LessonData(
    id: '8-0',
    title: '받침 개념',
    subtitle: '글자 아래 들어가는 소리',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '받침은 아래에 있어요',
        description: '받침은 음절 블록 아래쪽에 들어가요.\n'
            '예: 가 + ㄴ = 간',
        data: {
          'highlights': ['받침', '간', '말', '집']
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: '받침의 7가지 대표 소리',
        description: '받침에는 7가지 대표 소리만 있어요.\n\n'
            'ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\n'
            '여러 받침이 이 7가지 소리 중 하나로 발음돼요.\n'
            '예: ㅅ, ㅈ, ㅊ, ㅎ 받침 → 모두 [ㄷ] 소리',
        data: {
          'emoji': '🔑',
          'highlights': ['7가지', 'ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ', '대표 소리'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '위치 확인',
        description: '받침 위치를 확인해요',
        data: {
          'questions': [
            {
              'question': '간에서 받침은?',
              'answer': 'ㄴ',
              'choices': ['ㄱ', 'ㅏ', 'ㄴ']
            },
            {
              'question': '말에서 받침은?',
              'answer': 'ㄹ',
              'choices': ['ㅁ', 'ㅏ', 'ㄹ']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '8-0', 'message': '좋아요!\n받침 개념을 이해했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-1',
    title: 'ㄴ 받침',
    subtitle: '간 · 난 · 단',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄴ 받침 소리 듣기',
        description: '간/난/단을 들어보세요',
        data: {
          'characters': ['간', '난', '단'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['간', '난', '단'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: 'ㄴ 받침 음절을 선택하세요',
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
        title: '레슨 완료!',
        data: {'lessonId': '8-1', 'message': '좋아요!\nㄴ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-2',
    title: 'ㄹ 받침',
    subtitle: '말 · 갈 · 물',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄹ 받침 소리 듣기',
        description: '말/갈/물을 들어보세요',
        data: {
          'characters': ['말', '갈', '물'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['말', '갈', '물'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: 'ㄹ 받침 음절을 선택하세요',
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
        title: '레슨 완료!',
        data: {'lessonId': '8-2', 'message': '좋아요!\nㄹ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-3',
    title: 'ㅁ 받침',
    subtitle: '감 · 밤 · 숨',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅁ 받침 소리 듣기',
        description: '감/밤/숨을 들어보세요',
        data: {
          'characters': ['감', '밤', '숨'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['감', '밤', '숨'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '받침 구분',
        description: 'ㅁ 받침을 골라요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅁ 받침은?',
              'answer': '밤',
              'choices': ['발', '밤', '밥']
            },
            {
              'question': '다음 중 ㅁ 받침은?',
              'answer': '감',
              'choices': ['간', '감', '갓']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '8-3', 'message': '좋아요!\nㅁ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-4',
    title: 'ㅇ 받침',
    subtitle: '방 · 공 · 종',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅇ은 특별해요!',
        description: 'ㅇ은 특별해요!\n'
            '위(초성)에 있으면 소리가 없지만 (아, 오)\n'
            '아래(받침)에 있으면 "ng" 소리가 나요 (방, 공)',
        data: {
          'emoji': '💡',
          'highlights': ['초성', '받침', 'ng', '방', '공'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅇ 받침 소리 듣기',
        description: '방/공/종을 들어보세요',
        data: {
          'characters': ['방', '공', '종'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['방', '공', '종'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: 'ㅇ 받침 음절을 선택하세요',
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
        title: '레슨 완료!',
        data: {'lessonId': '8-4', 'message': '좋아요!\nㅇ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-5',
    title: 'ㄱ 받침',
    subtitle: '박 · 각 · 국',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄱ 받침 소리 듣기',
        description: '박/각/국을 들어보세요',
        data: {
          'characters': ['박', '각', '국'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['박', '각', '국'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '받침 구분',
        description: 'ㄱ 받침을 골라요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㄱ 받침은?',
              'answer': '박',
              'choices': ['박', '밤', '발']
            },
            {
              'question': '다음 중 ㄱ 받침은?',
              'answer': '국',
              'choices': ['군', '국', '굴']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '8-5', 'message': '좋아요!\nㄱ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-6',
    title: 'ㅂ 받침',
    subtitle: '밥 · 집 · 숲',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅂ 받침 소리 듣기',
        description: '밥/집/숲을 들어보세요',
        data: {
          'characters': ['밥', '집', '숲'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['밥', '집', '숲'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: 'ㅂ 받침 음절을 선택하세요',
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
        title: '레슨 완료!',
        data: {'lessonId': '8-6', 'message': '좋아요!\nㅂ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-7',
    title: 'ㅅ 받침',
    subtitle: '옷 · 맛 · 빛',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅅ 받침 소리 듣기',
        description: '옷/맛/빛을 들어보세요',
        data: {
          'characters': ['옷', '맛', '빛'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['옷', '맛', '빛'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '받침 구분',
        description: 'ㅅ 받침을 골라요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅅ 받침은?',
              'answer': '옷',
              'choices': ['옷', '온', '옹']
            },
            {
              'question': '다음 중 ㅅ 받침은?',
              'answer': '빛',
              'choices': ['빈', '빔', '빛']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '8-7', 'message': '좋아요!\nㅅ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-8',
    title: '받침 섞기 종합',
    subtitle: '핵심 받침 랜덤 점검',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '핵심 받침 섞기',
        description: 'ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ을 함께 점검해요.',
        data: {'emoji': '🧩'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '랜덤 퀴즈',
        description: '여러 받침을 섞어서 확인해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㄴ 받침은?',
              'answer': '문',
              'choices': ['문', '물', '묵']
            },
            {
              'question': '다음 중 ㅇ 받침은?',
              'answer': '공',
              'choices': ['공', '곱', '곤']
            },
            {
              'question': '다음 중 ㄹ 받침은?',
              'answer': '발',
              'choices': ['반', '밥', '발']
            },
            {
              'question': '다음 중 ㅂ 받침은?',
              'answer': '집',
              'choices': ['짐', '집', '진']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '8-8', 'message': '좋아요!\n핵심 받침 종합을 완료했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '8-M',
    title: '미션: 받침 도전!',
    subtitle: '받침이 있는 음절을 조합해요',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '받침 미션!',
        description: '기본 받침이 있는 음절을 읽고\n빠르게 맞춰봐요!',
        data: {'timeLimit': 120, 'targetCount': 8},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㅁ', 'ㅂ', 'ㅅ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: '미션 결과',
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: '미션 완료!',
        data: {'message': '받침의 기초를 완전히 다졌어요!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 8 완료!',
        data: {
          'message': '받침의 기초를 다졌어요!',
          'stageNumber': 8,
        },
      ),
    ],
  ),
];
