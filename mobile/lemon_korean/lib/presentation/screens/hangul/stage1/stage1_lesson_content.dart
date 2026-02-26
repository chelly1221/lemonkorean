import '../stage0/stage0_lesson_content.dart';

/// All Stage 1 lessons — 기본 모음.
const stage1Lessons = <LessonData>[
  // ── Lesson 1-1: ㅏ ──
  LessonData(
    id: '1-1',
    title: 'ㅏ 모양과 소리',
    subtitle: '세로선 오른쪽 짧은 획: ㅏ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '첫 모음 ㅏ를 배워요',
        description: 'ㅏ는 밝은 소리 "아"를 만들어요.\n'
            '모양과 소리를 함께 익혀볼게요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅏ',
            'result': '아',
          },
          'highlights': ['ㅏ', '아', '기본 모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅏ 소리 듣기',
        description: 'ㅏ가 들어간 소리를 들어보세요',
        data: {
          'characters': ['아', '가', '나'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅏ 소리 고르기',
        description: '소리를 듣고 맞는 글자를 선택하세요',
        data: {
          'questions': [
            {
              'answer': '아',
              'choices': ['아', '어']
            },
            {
              'answer': '가',
              'choices': ['가', '거']
            },
            {
              'answer': '나',
              'choices': ['나', '너']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양 퀴즈',
        description: 'ㅏ를 정확히 찾아보세요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅏ는?',
              'answer': 'ㅏ',
              'choices': ['ㅏ', 'ㅓ']
            },
            {
              'question': '다음 중 ㅏ가 들어간 것은?',
              'answer': '가',
              'choices': ['가', '고', '거']
            },
            {
              'question': 'ㅇ + ㅏ = ?',
              'answer': '아',
              'choices': ['아', '어', '오']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅏ로 글자 만들기',
        description: '자음과 ㅏ를 합쳐 글자를 완성하세요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅏ', 'result': '아'},
            {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
            {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅏ', 'ㅓ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '종합 퀴즈',
        description: '이번 레슨 내용을 정리해요',
        data: {
          'questions': [
            {
              'question': '"아"의 모음은?',
              'answer': 'ㅏ',
              'choices': ['ㅏ', 'ㅓ', 'ㅗ']
            },
            {
              'question': 'ㅇ + ㅏ = ?',
              'answer': '아',
              'choices': ['아', '어', '오']
            },
            {
              'question': '다음 중 ㅏ가 들어간 글자는?',
              'answer': '나',
              'choices': ['너', '나', '노']
            },
            {
              'question': 'ㅏ와 가장 다른 소리는?',
              'answer': 'ㅓ',
              'choices': ['ㅏ', 'ㅓ']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-1',
          'message': '좋아요!\nㅏ 모양과 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-2: ㅓ ──
  LessonData(
    id: '1-2',
    title: 'ㅓ 모양과 소리',
    subtitle: '세로선 왼쪽 짧은 획: ㅓ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '두 번째 모음 ㅓ',
        description: 'ㅓ는 "어" 소리를 만들어요.\n'
            'ㅏ와 획 방향이 반대라는 점이 중요해요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅓ',
            'result': '어',
          },
          'highlights': ['ㅓ', '어', 'ㅏ와 방향 반대'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅓ 소리 듣기',
        description: 'ㅓ가 들어간 소리를 들어보세요',
        data: {
          'characters': ['어', '거', '너'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅓ 소리 고르기',
        description: 'ㅏ/ㅓ를 귀로 구분해요',
        data: {
          'questions': [
            {
              'answer': '어',
              'choices': ['어', '아']
            },
            {
              'answer': '거',
              'choices': ['가', '거']
            },
            {
              'answer': '너',
              'choices': ['나', '너']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양 퀴즈',
        description: 'ㅓ를 찾아보세요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅓ는?',
              'answer': 'ㅓ',
              'choices': ['ㅏ', 'ㅓ']
            },
            {
              'question': 'ㅇ + ㅓ = ?',
              'answer': '어',
              'choices': ['아', '어', '오']
            },
            {
              'question': '다음 중 ㅓ가 들어간 글자는?',
              'answer': '너',
              'choices': ['나', '너', '노']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅓ로 글자 만들기',
        description: '자음과 ㅓ를 합쳐 보세요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅓ', 'result': '어'},
            {'consonant': 'ㄱ', 'vowel': 'ㅓ', 'result': '거'},
            {'consonant': 'ㄴ', 'vowel': 'ㅓ', 'result': '너'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅓ', 'ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-2',
          'message': '훌륭해요!\nㅓ(어) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-3: ㅗ ──
  LessonData(
    id: '1-3',
    title: 'ㅗ 모양과 소리',
    subtitle: '가로선 위로 세로획: ㅗ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '세 번째 모음 ㅗ',
        description: 'ㅗ는 "오" 소리를 만들어요.\n'
            '가로선 위로 세로획이 올라옵니다.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅗ',
            'result': '오',
          },
          'highlights': ['ㅗ', '오', '가로형 모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅗ 소리 듣기',
        description: 'ㅗ가 들어간 소리(오/고/노)를 들어보세요',
        data: {
          'characters': ['오', '고', '노'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅗ 소리 고르기',
        description: '오/우 소리를 구분해요',
        data: {
          'questions': [
            {
              'answer': '오',
              'choices': ['오', '우']
            },
            {
              'answer': '고',
              'choices': ['고', '구']
            },
            {
              'answer': '노',
              'choices': ['노', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅗ로 글자 만들기',
        description: '자음과 ㅗ를 합쳐 보세요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅗ', 'result': '오'},
            {'consonant': 'ㄱ', 'vowel': 'ㅗ', 'result': '고'},
            {'consonant': 'ㄴ', 'vowel': 'ㅗ', 'result': '노'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅗ', 'ㅜ', 'ㅡ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양/소리 퀴즈',
        description: 'ㅗ를 정확히 선택해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅗ는?',
              'answer': 'ㅗ',
              'choices': ['ㅗ', 'ㅜ', 'ㅡ']
            },
            {
              'question': 'ㅇ + ㅗ = ?',
              'answer': '오',
              'choices': ['오', '우', '어']
            },
            {
              'question': '다음 중 ㅗ가 들어간 것은?',
              'answer': '고',
              'choices': ['고', '거', '구']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-3',
          'message': '좋아요!\nㅗ(오) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-4: ㅜ ──
  LessonData(
    id: '1-4',
    title: 'ㅜ 모양과 소리',
    subtitle: '가로선 아래로 세로획: ㅜ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '네 번째 모음 ㅜ',
        description: 'ㅜ는 "우" 소리를 만들어요.\n'
            'ㅗ와는 세로획 위치가 반대예요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅜ',
            'result': '우',
          },
          'highlights': ['ㅜ', '우', 'ㅗ와 위치 비교'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅜ 소리 듣기',
        description: '우/구/누를 들어보세요',
        data: {
          'characters': ['우', '구', '누'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅜ 소리 고르기',
        description: 'ㅗ/ㅜ를 구분해요',
        data: {
          'questions': [
            {
              'answer': '우',
              'choices': ['우', '오']
            },
            {
              'answer': '구',
              'choices': ['고', '구']
            },
            {
              'answer': '누',
              'choices': ['노', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅜ로 글자 만들기',
        description: '자음과 ㅜ를 합쳐 보세요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅜ', 'result': '우'},
            {'consonant': 'ㄱ', 'vowel': 'ㅜ', 'result': '구'},
            {'consonant': 'ㄴ', 'vowel': 'ㅜ', 'result': '누'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅜ', 'ㅗ', 'ㅡ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양/소리 퀴즈',
        description: 'ㅜ를 정확히 선택해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅜ는?',
              'answer': 'ㅜ',
              'choices': ['ㅗ', 'ㅜ', 'ㅡ']
            },
            {
              'question': 'ㅇ + ㅜ = ?',
              'answer': '우',
              'choices': ['오', '우', '어']
            },
            {
              'question': '다음 중 ㅜ가 들어간 것은?',
              'answer': '누',
              'choices': ['누', '노', '너']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-4',
          'message': '좋아요!\nㅜ(우) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-5: ㅡ ──
  LessonData(
    id: '1-5',
    title: 'ㅡ 모양과 소리',
    subtitle: '가로 한 줄 모음: ㅡ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '다섯 번째 모음 ㅡ',
        description: 'ㅡ는 입을 옆으로 당겨 내는 소리예요.\n'
            '모양은 가로 한 줄입니다.',
        data: {
          'emoji': '📏',
          'highlights': ['ㅡ', '으', '가로 한 줄'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅡ 소리 듣기',
        description: '으/그/느 소리를 들어보세요',
        data: {
          'characters': ['으', '그', '느'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅡ 소리 고르기',
        description: 'ㅡ와 ㅜ 소리를 구분해요',
        data: {
          'questions': [
            {
              'answer': '으',
              'choices': ['으', '우']
            },
            {
              'answer': '그',
              'choices': ['구', '그']
            },
            {
              'answer': '느',
              'choices': ['느', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅡ로 글자 만들기',
        description: '자음과 ㅡ를 합쳐 보세요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅡ', 'result': '으'},
            {'consonant': 'ㄱ', 'vowel': 'ㅡ', 'result': '그'},
            {'consonant': 'ㄴ', 'vowel': 'ㅡ', 'result': '느'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅡ', 'ㅜ', 'ㅣ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양/소리 퀴즈',
        description: 'ㅡ를 정확히 선택해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅡ는?',
              'answer': 'ㅡ',
              'choices': ['ㅜ', 'ㅡ', 'ㅣ']
            },
            {
              'question': 'ㅇ + ㅡ = ?',
              'answer': '으',
              'choices': ['우', '으', '이']
            },
            {
              'question': '다음 중 ㅡ가 들어간 것은?',
              'answer': '그',
              'choices': ['구', '그', '거']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-5',
          'message': '좋아요!\nㅡ(으) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-6: ㅣ ──
  LessonData(
    id: '1-6',
    title: 'ㅣ 모양과 소리',
    subtitle: '세로 한 줄 모음: ㅣ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '여섯 번째 모음 ㅣ',
        description: 'ㅣ는 "이" 소리를 만들어요.\n'
            '모양은 세로 한 줄입니다.',
        data: {
          'emoji': '📐',
          'highlights': ['ㅣ', '이', '세로 한 줄'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅣ 소리 듣기',
        description: '이/기/니 소리를 들어보세요',
        data: {
          'characters': ['이', '기', '니'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅣ 소리 고르기',
        description: 'ㅣ와 ㅡ 소리를 구분해요',
        data: {
          'questions': [
            {
              'answer': '이',
              'choices': ['으', '이']
            },
            {
              'answer': '기',
              'choices': ['그', '기']
            },
            {
              'answer': '니',
              'choices': ['니', '느']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅣ로 글자 만들기',
        description: '자음과 ㅣ를 합쳐 보세요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅣ', 'result': '이'},
            {'consonant': 'ㄱ', 'vowel': 'ㅣ', 'result': '기'},
            {'consonant': 'ㄴ', 'vowel': 'ㅣ', 'result': '니'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅣ', 'ㅡ', 'ㅏ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양/소리 퀴즈',
        description: 'ㅣ를 정확히 선택해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅣ는?',
              'answer': 'ㅣ',
              'choices': ['ㅡ', 'ㅣ', 'ㅏ']
            },
            {
              'question': 'ㅇ + ㅣ = ?',
              'answer': '이',
              'choices': ['이', '아', '으']
            },
            {
              'question': '다음 중 ㅣ가 들어간 것은?',
              'answer': '기',
              'choices': ['구', '기', '거']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-6',
          'message': '좋아요!\nㅣ(이) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-7: 세로 모음 구분 (ㅏ/ㅓ/ㅣ) ──
  LessonData(
    id: '1-7',
    title: '세로 모음 구분',
    subtitle: 'ㅏ · ㅓ · ㅣ 빠르게 구분하기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '세로 모음 묶음 복습',
        description: 'ㅏ, ㅓ, ㅣ는 세로축 모음이에요.\n'
            '획 위치와 소리를 함께 구분해요.',
        data: {
          'emoji': '🧭',
          'highlights': ['ㅏ', 'ㅓ', 'ㅣ', '세로 모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 한 번씩 다시 듣기',
        description: '아/어/이 소리를 확인해요',
        data: {
          'characters': ['아', '어', '이'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '세로 모음 듣기 퀴즈',
        description: '소리와 글자를 연결하세요',
        data: {
          'questions': [
            {
              'answer': '아',
              'choices': ['아', '어']
            },
            {
              'answer': '어',
              'choices': ['어', '이']
            },
            {
              'answer': '이',
              'choices': ['아', '이']
            },
            {
              'answer': '기',
              'choices': ['거', '기']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '세로 모음 모양 퀴즈',
        description: '모양도 정확히 구분해요',
        data: {
          'questions': [
            {
              'question': '오른쪽 짧은 획은?',
              'answer': 'ㅏ',
              'choices': ['ㅏ', 'ㅓ', 'ㅣ']
            },
            {
              'question': '왼쪽 짧은 획은?',
              'answer': 'ㅓ',
              'choices': ['ㅏ', 'ㅓ', 'ㅣ']
            },
            {
              'question': '세로 한 줄은?',
              'answer': 'ㅣ',
              'choices': ['ㅓ', 'ㅡ', 'ㅣ']
            },
            {
              'question': 'ㄴ + ㅓ = ?',
              'answer': '너',
              'choices': ['나', '너', '니']
            },
            {
              'question': 'ㄱ + ㅣ = ?',
              'answer': '기',
              'choices': ['거', '기', '그']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-7',
          'message': '좋아요!\n세로 모음(ㅏ/ㅓ/ㅣ) 구분이 안정됐어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-8: 가로 모음 구분 (ㅗ/ㅜ/ㅡ) ──
  LessonData(
    id: '1-8',
    title: '가로 모음 구분',
    subtitle: 'ㅗ · ㅜ · ㅡ 빠르게 구분하기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '가로 모음 묶음 복습',
        description: 'ㅗ, ㅜ, ㅡ는 가로축 중심 모음이에요.\n'
            '세로획 위치와 입모양을 함께 기억해요.',
        data: {
          'emoji': '🧩',
          'highlights': ['ㅗ', 'ㅜ', 'ㅡ', '가로 모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 한 번씩 다시 듣기',
        description: '오/우/으 소리를 확인해요',
        data: {
          'characters': ['오', '우', '으'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '가로 모음 듣기 퀴즈',
        description: '소리와 글자를 연결하세요',
        data: {
          'questions': [
            {
              'answer': '오',
              'choices': ['오', '우']
            },
            {
              'answer': '우',
              'choices': ['우', '으']
            },
            {
              'answer': '으',
              'choices': ['오', '으']
            },
            {
              'answer': '구',
              'choices': ['구', '그']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '가로 모음 모양 퀴즈',
        description: '모양과 소리를 같이 점검해요',
        data: {
          'questions': [
            {
              'question': '가로선 위로 세로획은?',
              'answer': 'ㅗ',
              'choices': ['ㅗ', 'ㅜ', 'ㅡ']
            },
            {
              'question': '가로선 아래로 세로획은?',
              'answer': 'ㅜ',
              'choices': ['ㅗ', 'ㅜ', 'ㅡ']
            },
            {
              'question': '가로 한 줄은?',
              'answer': 'ㅡ',
              'choices': ['ㅜ', 'ㅣ', 'ㅡ']
            },
            {
              'question': 'ㄱ + ㅗ = ?',
              'answer': '고',
              'choices': ['고', '구', '그']
            },
            {
              'question': 'ㄴ + ㅜ = ?',
              'answer': '누',
              'choices': ['노', '느', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '1-8',
          'message': '좋아요!\n가로 모음(ㅗ/ㅜ/ㅡ) 구분이 안정됐어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-9: Stage 1 Mission ──
  LessonData(
    id: '1-9',
    title: '기본 모음 미션',
    subtitle: '시간 안에 모음 조합 완성하기',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '1단계 최종 미션',
        description: '제한시간 안에 글자 조합을 완성해요.\n'
            '정확도와 속도로 레몬 보상을 받아요!',
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
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowels': ['ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: '미션 결과',
      ),
      LessonStep(
        type: StepType.summary,
        title: '1단계 완료!',
        data: {
          'lessonId': '1-9',
          'message': '축하해요!\n1단계 기본 모음을 모두 마쳤어요.',
        },
      ),
    ],
  ),

  // ── Lesson 1-10: 보너스 - 첫 한국어 단어! ──
  LessonData(
    id: '1-10',
    title: '첫 한국어 단어!',
    subtitle: '배운 글자로 진짜 단어를 읽어봐요',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '이제 단어를 읽을 수 있어요!',
        description: '모음과 기본 자음을 배웠으니\n진짜 한국어 단어를 읽어볼까요?',
        data: {
          'emoji': '🎊',
          'highlights': ['진짜 단어', '읽기 도전'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '첫 단어 읽기',
        data: {
          'characters': ['아이', '우유', '오이', '이', '아우'],
          'descriptions': ['child', 'milk', 'cucumber', 'this/tooth', 'younger brother'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '들어보고 골라요',
        data: {
          'questions': [
            {'audio': '아이', 'choices': ['아이', '오이', '우유'], 'answer': '아이'},
            {'audio': '우유', 'choices': ['이유', '우유', '아우'], 'answer': '우유'},
            {'audio': '오이', 'choices': ['오이', '아이', '우이'], 'answer': '오이'},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '대단해요!',
        data: {
          'message': '한국어 단어를 읽었어요!\n이제 자음을 더 배우면\n더 많은 단어를 읽을 수 있어요.',
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 1 완료!',
        data: {
          'message': '기본 모음 6개를 마스터했어요!',
          'stageNumber': 1,
        },
      ),
    ],
  ),
];
