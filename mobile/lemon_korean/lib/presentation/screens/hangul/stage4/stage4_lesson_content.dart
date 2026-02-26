import '../stage0/stage0_lesson_content.dart';

/// All Stage 4 lessons — 기본 자음 1 (ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ).
const stage4Lessons = <LessonData>[
  LessonData(
    id: '4-1',
    title: 'ㄱ 모양과 소리',
    subtitle: '기본 자음 시작: ㄱ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㄱ을 배워요',
        description: 'ㄱ은 기본 자음의 시작이에요.\n'
            'ㅏ와 합치면 "가" 소리가 나요.',
        data: {
          'animation': {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
          'highlights': ['ㄱ', '가', '기본 자음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄱ 소리 듣기',
        description: '가/고/구 소리를 들어보세요',
        data: {
          'characters': ['가', '고', '구'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㄱ 소리 고르기',
        description: '소리를 듣고 맞는 글자를 선택하세요',
        data: {
          'questions': [
            {
              'answer': '가',
              'choices': ['가', '나']
            },
            {
              'answer': '고',
              'choices': ['고', '도']
            },
            {
              'answer': '구',
              'choices': ['구', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㄱ으로 글자 만들기',
        description: 'ㄱ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
            {'consonant': 'ㄱ', 'vowel': 'ㅗ', 'result': '고'},
            {'consonant': 'ㄱ', 'vowel': 'ㅜ', 'result': '구'},
          ],
          'consonantChoices': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '4-1',
          'message': '좋아요!\nㄱ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '4-2',
    title: 'ㄴ 모양과 소리',
    subtitle: '두 번째 기본 자음: ㄴ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㄴ을 배워요',
        description: 'ㄴ은 "나" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
          'highlights': ['ㄴ', '나'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄴ 소리 듣기',
        description: '나/노/누 소리를 들어보세요',
        data: {
          'characters': ['나', '노', '누'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㄴ 소리 고르기',
        description: '나/다를 구분해요',
        data: {
          'questions': [
            {
              'answer': '나',
              'choices': ['나', '다']
            },
            {
              'answer': '노',
              'choices': ['노', '도']
            },
            {
              'answer': '누',
              'choices': ['누', '두']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㄴ으로 글자 만들기',
        description: 'ㄴ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
            {'consonant': 'ㄴ', 'vowel': 'ㅗ', 'result': '노'},
            {'consonant': 'ㄴ', 'vowel': 'ㅜ', 'result': '누'},
          ],
          'consonantChoices': ['ㄴ', 'ㄷ', 'ㄹ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '4-2',
          'message': '좋아요!\nㄴ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '4-3',
    title: 'ㄷ 모양과 소리',
    subtitle: '세 번째 기본 자음: ㄷ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㄷ을 배워요',
        description: 'ㄷ은 "다" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㄷ', 'vowel': 'ㅏ', 'result': '다'},
          'highlights': ['ㄷ', '다'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄷ 소리 듣기',
        description: '다/도/두 소리를 들어보세요',
        data: {
          'characters': ['다', '도', '두'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㄷ 소리 고르기',
        description: '다/나를 구분해요',
        data: {
          'questions': [
            {
              'answer': '다',
              'choices': ['다', '나']
            },
            {
              'answer': '도',
              'choices': ['도', '노']
            },
            {
              'answer': '두',
              'choices': ['두', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㄷ으로 글자 만들기',
        description: 'ㄷ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㄷ', 'vowel': 'ㅏ', 'result': '다'},
            {'consonant': 'ㄷ', 'vowel': 'ㅗ', 'result': '도'},
            {'consonant': 'ㄷ', 'vowel': 'ㅜ', 'result': '두'},
          ],
          'consonantChoices': ['ㄷ', 'ㄴ', 'ㅂ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '4-3',
          'message': '좋아요!\nㄷ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '4-4',
    title: 'ㄹ 모양과 소리',
    subtitle: '네 번째 기본 자음: ㄹ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㄹ을 배워요',
        description: 'ㄹ은 "라" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㄹ', 'vowel': 'ㅏ', 'result': '라'},
          'highlights': ['ㄹ', '라'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄹ 소리 듣기',
        description: '라/로/루 소리를 들어보세요',
        data: {
          'characters': ['라', '로', '루'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㄹ 소리 고르기',
        description: '라/나를 구분해요',
        data: {
          'questions': [
            {
              'answer': '라',
              'choices': ['라', '나']
            },
            {
              'answer': '로',
              'choices': ['로', '노']
            },
            {
              'answer': '루',
              'choices': ['루', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㄹ로 글자 만들기',
        description: 'ㄹ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㄹ', 'vowel': 'ㅏ', 'result': '라'},
            {'consonant': 'ㄹ', 'vowel': 'ㅗ', 'result': '로'},
            {'consonant': 'ㄹ', 'vowel': 'ㅜ', 'result': '루'},
          ],
          'consonantChoices': ['ㄹ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '4-4',
          'message': '좋아요!\nㄹ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '4-5',
    title: 'ㅁ 모양과 소리',
    subtitle: '다섯 번째 기본 자음: ㅁ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅁ을 배워요',
        description: 'ㅁ은 "마" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅁ', 'vowel': 'ㅏ', 'result': '마'},
          'highlights': ['ㅁ', '마'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅁ 소리 듣기',
        description: '마/모/무 소리를 들어보세요',
        data: {
          'characters': ['마', '모', '무'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅁ 소리 고르기',
        description: '마/바를 구분해요',
        data: {
          'questions': [
            {
              'answer': '마',
              'choices': ['마', '바']
            },
            {
              'answer': '모',
              'choices': ['모', '보']
            },
            {
              'answer': '무',
              'choices': ['무', '부']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅁ으로 글자 만들기',
        description: 'ㅁ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㅁ', 'vowel': 'ㅏ', 'result': '마'},
            {'consonant': 'ㅁ', 'vowel': 'ㅗ', 'result': '모'},
            {'consonant': 'ㅁ', 'vowel': 'ㅜ', 'result': '무'},
          ],
          'consonantChoices': ['ㅁ', 'ㅂ', 'ㄴ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '4-5',
          'message': '좋아요!\nㅁ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '4-6',
    title: 'ㅂ 모양과 소리',
    subtitle: '여섯 번째 기본 자음: ㅂ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅂ을 배워요',
        description: 'ㅂ은 "바" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅂ', 'vowel': 'ㅏ', 'result': '바'},
          'highlights': ['ㅂ', '바'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅂ 소리 듣기',
        description: '바/보/부 소리를 들어보세요',
        data: {
          'characters': ['바', '보', '부'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅂ 소리 고르기',
        description: '바/마를 구분해요',
        data: {
          'questions': [
            {
              'answer': '바',
              'choices': ['바', '마']
            },
            {
              'answer': '보',
              'choices': ['보', '모']
            },
            {
              'answer': '부',
              'choices': ['부', '무']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅂ으로 글자 만들기',
        description: 'ㅂ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㅂ', 'vowel': 'ㅏ', 'result': '바'},
            {'consonant': 'ㅂ', 'vowel': 'ㅗ', 'result': '보'},
            {'consonant': 'ㅂ', 'vowel': 'ㅜ', 'result': '부'},
          ],
          'consonantChoices': ['ㅂ', 'ㅁ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '4-6',
          'message': '좋아요!\nㅂ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '4-7',
    title: 'ㅅ 모양과 소리',
    subtitle: '일곱 번째 기본 자음: ㅅ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅅ을 배워요',
        description: 'ㅅ은 "사" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅅ', 'vowel': 'ㅏ', 'result': '사'},
          'highlights': ['ㅅ', '사'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅅ 소리 듣기',
        description: '사/소/수 소리를 들어보세요',
        data: {
          'characters': ['사', '소', '수'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅅ 소리 고르기',
        description: '사/자를 구분해요',
        data: {
          'questions': [
            {
              'answer': '사',
              'choices': ['사', '자']
            },
            {
              'answer': '소',
              'choices': ['소', '조']
            },
            {
              'answer': '수',
              'choices': ['수', '주']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅅ으로 글자 만들기',
        description: 'ㅅ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㅅ', 'vowel': 'ㅏ', 'result': '사'},
            {'consonant': 'ㅅ', 'vowel': 'ㅗ', 'result': '소'},
            {'consonant': 'ㅅ', 'vowel': 'ㅜ', 'result': '수'},
          ],
          'consonantChoices': ['ㅅ', 'ㅈ', 'ㄴ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '4단계 완료!',
        data: {
          'lessonId': '4-7',
          'message': '축하해요!\n4단계 기본 자음 1(ㄱ~ㅅ)을 완료했어요.',
        },
      ),
    ],
  ),

  // ── Lesson 4-8: 보너스 - 단어 읽기 도전! ──
  LessonData(
    id: '4-8',
    title: '단어 읽기 도전!',
    subtitle: '자음과 모음으로 단어를 읽어봐요',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '이제 더 많은 단어를 읽을 수 있어요!',
        description: '기본 자음 7개와 모음을 모두 배웠어요.\n이 글자들로 만든 진짜 단어를 읽어볼까요?',
        data: {
          'emoji': '🌟',
          'highlights': ['자음 7개', '모음', '진짜 단어'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '단어 읽기',
        data: {
          'characters': ['나무', '바다', '나비', '모자', '가구', '두부'],
          'descriptions': ['tree', 'sea', 'butterfly', 'hat', 'furniture', 'tofu'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 골라요',
        data: {
          'questions': [
            {'audio': '나무', 'choices': ['나무', '나비', '바다'], 'answer': '나무'},
            {'audio': '바다', 'choices': ['모자', '바다', '가구'], 'answer': '바다'},
            {'audio': '두부', 'choices': ['나비', '가구', '두부'], 'answer': '두부'},
            {'audio': '모자', 'choices': ['모자', '나무', '두부'], 'answer': '모자'},
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '무슨 뜻일까요?',
        data: {
          'questions': [
            {'question': '"나비"는 영어로?', 'answer': 'butterfly', 'choices': ['tree', 'butterfly', 'sea']},
            {'question': '"바다"는 영어로?', 'answer': 'sea', 'choices': ['hat', 'sea', 'tofu']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '훌륭해요!',
        data: {
          'message': '한국어 단어 6개를 읽었어요!\n자음을 더 배우면 훨씬 더 많은 단어를 읽을 수 있어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '4-M',
    title: '미션: 기본 자음 조합!',
    subtitle: '시간 안에 음절을 만들어요',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '미션 시작!',
        description: '기본 자음 ㄱ~ㅅ과 모음을 조합해요.\n제한 시간 안에 목표를 달성하세요!',
        data: {'timeLimit': 120, 'targetCount': 8},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ'],
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
        data: {'message': '기본 자음 7개를 자유롭게 조합할 수 있어요!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 4 완료!',
        data: {
          'message': '기본 자음 7개를 익혔어요!',
          'stageNumber': 4,
        },
      ),
    ],
  ),
];
