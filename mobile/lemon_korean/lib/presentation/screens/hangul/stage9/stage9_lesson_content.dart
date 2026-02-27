import '../stage0/stage0_lesson_content.dart';

/// All Stage 9 lessons — 받침 확장.
const stage9Lessons = <LessonData>[
  LessonData(
    id: '9-1',
    title: 'ㄷ 받침 확장',
    subtitle: '닫 · 곧 · 묻',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㄷ 받침 패턴',
        description: '받침 ㄷ이 들어간 음절을 읽어봐요.',
        data: {
          'highlights': ['닫', '곧', '묻']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄷ 받침 소리 듣기',
        description: '닫/곧/묻을 들어보세요',
        data: {
          'characters': ['닫', '곧', '묻'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['닫', '곧', '묻'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '받침 구분',
        description: 'ㄷ 받침을 선택하세요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㄷ 받침은?',
              'answer': '곧',
              'choices': ['곤', '곧', '골']
            },
            {
              'question': '다음 중 ㄷ 받침은?',
              'answer': '닫',
              'choices': ['단', '닫', '달']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '9-1', 'message': '좋아요!\nㄷ 받침 확장을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '9-2',
    title: 'ㅈ 받침 확장',
    subtitle: '낮 · 잊 · 젖',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅈ 받침 소리 듣기',
        description: '낮/잊/젖을 들어보세요',
        data: {
          'characters': ['낮', '잊', '젖'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['낮', '잊', '젖'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: 'ㅈ 받침 음절을 고르세요',
        data: {
          'questions': [
            {
              'answer': '낮',
              'choices': ['낮', '난', '날']
            },
            {
              'answer': '젖',
              'choices': ['전', '절', '젖']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '9-2', 'message': '좋아요!\nㅈ 받침 확장을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '9-3',
    title: 'ㅊ 받침 확장',
    subtitle: '꽃 · 닻 · 빚',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅊ 받침 소리 듣기',
        description: '꽃/닻/빚을 들어보세요',
        data: {
          'characters': ['꽃', '닻', '빚'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['꽃', '닻', '빚'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '받침 구분',
        description: 'ㅊ 받침을 선택하세요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅊ 받침은?',
              'answer': '꽃',
              'choices': ['꽃', '꼰', '꼴']
            },
            {
              'question': '다음 중 ㅊ 받침은?',
              'answer': '닻',
              'choices': ['단', '닫', '닻']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '9-3', 'message': '좋아요!\nㅊ 받침 확장을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '9-4',
    title: 'ㅋ / ㅌ / ㅍ 받침',
    subtitle: '부엌 · 밭 · 앞',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '세 받침 묶음',
        description: 'ㅋ/ㅌ/ㅍ 받침을 묶어서 익혀요.',
        data: {
          'highlights': ['부엌', '밭', '앞']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 듣기',
        description: '부엌/밭/앞을 들어보세요',
        data: {
          'characters': ['부엌', '밭', '앞'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['부엌', '밭', '앞'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '받침 구분',
        description: '세 받침을 구분해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅌ 받침은?',
              'answer': '밭',
              'choices': ['밭', '반', '발']
            },
            {
              'question': '다음 중 ㅍ 받침은?',
              'answer': '앞',
              'choices': ['암', '앞', '안']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '9-4', 'message': '좋아요!\nㅋ/ㅌ/ㅍ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '9-5',
    title: 'ㅎ 받침 확장',
    subtitle: '좋 · 놓 · 않',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅎ 받침 소리 듣기',
        description: '좋/놓/않을 들어보세요',
        data: {
          'characters': ['좋', '놓', '않'],
          'type': 'syllable'
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['좋', '놓', '않'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: 'ㅎ 받침 음절을 고르세요',
        data: {
          'questions': [
            {
              'answer': '좋',
              'choices': ['좋', '존', '졸']
            },
            {
              'answer': '놓',
              'choices': ['논', '놀', '놓']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '9-5', 'message': '좋아요!\nㅎ 받침 확장을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '9-6',
    title: '확장 받침 랜덤',
    subtitle: 'ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ 섞기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '확장 받침 섞기',
        description: '확장 받침군을 랜덤으로 점검해요.',
        data: {'emoji': '🎯'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '랜덤 퀴즈',
        description: '문제를 풀며 구분해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㄷ 받침은?',
              'answer': '곧',
              'choices': ['곤', '골', '곧']
            },
            {
              'question': '다음 중 ㅈ 받침은?',
              'answer': '낮',
              'choices': ['낮', '난', '날']
            },
            {
              'question': '다음 중 ㅊ 받침은?',
              'answer': '꽃',
              'choices': ['꽃', '꼰', '꼴']
            },
            {
              'question': '다음 중 ㅎ 받침은?',
              'answer': '좋',
              'choices': ['존', '좋', '졸']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '9-6', 'message': '좋아요!\n확장 받침 랜덤 점검을 완료했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '9-7',
    title: '9단계 종합',
    subtitle: '확장 받침 읽기 마무리',
    steps: [
      LessonStep(
        type: StepType.quizMcq,
        title: '종합 확인',
        description: '9단계 핵심을 최종 점검해요',
        data: {
          'questions': [
            {
              'question': '부 + ㅌ = ?',
              'answer': '붙',
              'choices': ['분', '불', '붙']
            },
            {
              'question': '조 + ㅎ = ?',
              'answer': '좋',
              'choices': ['존', '종', '좋']
            },
            {
              'question': '아 + ㅍ = ?',
              'answer': '앞',
              'choices': ['안', '앞', '암']
            },
            {
              'question': '노 + ㅎ = ?',
              'answer': '놓',
              'choices': ['논', '놀', '놓']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '9단계 완료!',
        data: {
          'lessonId': '9-7',
          'message': '축하해요!\n9단계 받침 확장을 완료했어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '9-M',
    title: '미션: 확장 받침 도전!',
    subtitle: '다양한 받침을 빠르게 읽어요',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '확장 받침 미션!',
        description: '확장 받침이 포함된 음절을\n빠르게 조합해요!',
        data: {'timeLimit': 90, 'targetCount': 6},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 90,
          'targetCount': 6,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅈ'],
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
        data: {'message': '확장 받침까지 정복했어요!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 9 완료!',
        data: {
          'message': '확장 받침까지 정복했어요!',
          'stageNumber': 9,
        },
      ),
    ],
  ),
];
