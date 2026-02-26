import '../stage0/stage0_lesson_content.dart';

/// All Stage 2 lessons — Y-모음(ㅑ, ㅕ, ㅛ, ㅠ).
const stage2Lessons = <LessonData>[
  // ── Lesson 2-1: ㅑ ──
  LessonData(
    id: '2-1',
    title: 'ㅑ 모양과 소리',
    subtitle: 'ㅏ에서 획 하나 추가: ㅑ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅏ가 ㅑ로 변해요',
        description: 'ㅏ에 획 하나가 더해지면 ㅑ가 돼요.\n'
            '소리는 "아"보다 더 튀는 "야"예요.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅑ',
            'result': '야',
          },
          'highlights': ['ㅏ → ㅑ', '야', 'Y-모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅑ 소리 듣기',
        description: '야/갸/냐 소리를 들어보세요',
        data: {
          'characters': ['야', '갸', '냐'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅏ vs ㅑ 듣기',
        description: '비슷한 소리를 구분해요',
        data: {
          'questions': [
            {
              'answer': '야',
              'choices': ['아', '야']
            },
            {
              'answer': '갸',
              'choices': ['가', '갸']
            },
            {
              'answer': '냐',
              'choices': ['냐', '나']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅑ로 글자 만들기',
        description: '자음 + ㅑ 조합을 완성해요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅑ', 'result': '야'},
            {'consonant': 'ㄱ', 'vowel': 'ㅑ', 'result': '갸'},
            {'consonant': 'ㄴ', 'vowel': 'ㅑ', 'result': '냐'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅑ', 'ㅏ', 'ㅕ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양/소리 퀴즈',
        description: 'ㅑ를 정확히 고르세요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅑ는?',
              'answer': 'ㅑ',
              'choices': ['ㅏ', 'ㅑ', 'ㅕ']
            },
            {
              'question': 'ㅇ + ㅑ = ?',
              'answer': '야',
              'choices': ['야', '아', '여']
            },
            {
              'question': '다음 중 ㅑ가 들어간 것은?',
              'answer': '냐',
              'choices': ['나', '냐', '너']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '2-1',
          'message': '좋아요!\nㅑ(야) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 2-2: ㅕ ──
  LessonData(
    id: '2-2',
    title: 'ㅕ 모양과 소리',
    subtitle: 'ㅓ에서 획 하나 추가: ㅕ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅓ가 ㅕ로 변해요',
        description: 'ㅓ에 획 하나가 더해지면 ㅕ가 돼요.\n'
            '소리는 "어"에서 "여"로 바뀝니다.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅕ',
            'result': '여',
          },
          'highlights': ['ㅓ → ㅕ', '여', 'Y-모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅕ 소리 듣기',
        description: '여/겨/녀 소리를 들어보세요',
        data: {
          'characters': ['여', '겨', '녀'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅓ vs ㅕ 듣기',
        description: '어/여를 구분해요',
        data: {
          'questions': [
            {
              'answer': '여',
              'choices': ['어', '여']
            },
            {
              'answer': '겨',
              'choices': ['거', '겨']
            },
            {
              'answer': '녀',
              'choices': ['너', '녀']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅕ로 글자 만들기',
        description: '자음 + ㅕ 조합을 완성해요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅕ', 'result': '여'},
            {'consonant': 'ㄱ', 'vowel': 'ㅕ', 'result': '겨'},
            {'consonant': 'ㄴ', 'vowel': 'ㅕ', 'result': '녀'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅕ', 'ㅓ', 'ㅑ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '2-2',
          'message': '좋아요!\nㅕ(여) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 2-3: ㅛ ──
  LessonData(
    id: '2-3',
    title: 'ㅛ 모양과 소리',
    subtitle: 'ㅗ에서 획 하나 추가: ㅛ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅗ가 ㅛ로 변해요',
        description: 'ㅗ에 획 하나가 더해지면 ㅛ가 돼요.\n'
            '소리는 "오"에서 "요"로 바뀝니다.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅛ',
            'result': '요',
          },
          'highlights': ['ㅗ → ㅛ', '요', 'Y-모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅛ 소리 듣기',
        description: '요/교/뇨 소리를 들어보세요',
        data: {
          'characters': ['요', '교', '뇨'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅗ vs ㅛ 듣기',
        description: '오/요를 구분해요',
        data: {
          'questions': [
            {
              'answer': '요',
              'choices': ['오', '요']
            },
            {
              'answer': '교',
              'choices': ['고', '교']
            },
            {
              'answer': '뇨',
              'choices': ['노', '뇨']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅛ로 글자 만들기',
        description: '자음 + ㅛ 조합을 완성해요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅛ', 'result': '요'},
            {'consonant': 'ㄱ', 'vowel': 'ㅛ', 'result': '교'},
            {'consonant': 'ㄴ', 'vowel': 'ㅛ', 'result': '뇨'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅛ', 'ㅗ', 'ㅠ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '2-3',
          'message': '좋아요!\nㅛ(요) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 2-4: ㅠ ──
  LessonData(
    id: '2-4',
    title: 'ㅠ 모양과 소리',
    subtitle: 'ㅜ에서 획 하나 추가: ㅠ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅜ가 ㅠ로 변해요',
        description: 'ㅜ에 획 하나가 더해지면 ㅠ가 돼요.\n'
            '소리는 "우"에서 "유"로 바뀝니다.',
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅠ',
            'result': '유',
          },
          'highlights': ['ㅜ → ㅠ', '유', 'Y-모음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅠ 소리 듣기',
        description: '유/규/뉴 소리를 들어보세요',
        data: {
          'characters': ['유', '규', '뉴'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅜ vs ㅠ 듣기',
        description: '우/유를 구분해요',
        data: {
          'questions': [
            {
              'answer': '유',
              'choices': ['우', '유']
            },
            {
              'answer': '규',
              'choices': ['구', '규']
            },
            {
              'answer': '뉴',
              'choices': ['누', '뉴']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅠ로 글자 만들기',
        description: '자음 + ㅠ 조합을 완성해요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅠ', 'result': '유'},
            {'consonant': 'ㄱ', 'vowel': 'ㅠ', 'result': '규'},
            {'consonant': 'ㄴ', 'vowel': 'ㅠ', 'result': '뉴'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅠ', 'ㅜ', 'ㅛ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '2-4',
          'message': '좋아요!\nㅠ(유) 소리를 익혔어요.',
        },
      ),
    ],
  ),

  // ── Lesson 2-5: Y-모음 묶음 구분 ──
  LessonData(
    id: '2-5',
    title: 'Y-모음 묶음 구분',
    subtitle: 'ㅑ · ㅕ · ㅛ · ㅠ 집중 훈련',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'Y-모음 한 번에 보기',
        description: 'ㅑ/ㅕ/ㅛ/ㅠ는 기본 모음에 획을 추가한 모음이에요.\n'
            '소리와 모양을 빠르게 구분해요.',
        data: {
          'emoji': '⚡',
          'highlights': ['ㅑ', 'ㅕ', 'ㅛ', 'ㅠ'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '네 소리 다시 듣기',
        description: '야/여/요/유를 확인해요',
        data: {
          'characters': ['야', '여', '요', '유'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 구분 퀴즈',
        description: 'Y-모음 소리를 구분해요',
        data: {
          'questions': [
            {
              'answer': '야',
              'choices': ['야', '여']
            },
            {
              'answer': '요',
              'choices': ['요', '유']
            },
            {
              'answer': '여',
              'choices': ['야', '여']
            },
            {
              'answer': '유',
              'choices': ['요', '유']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양 구분 퀴즈',
        description: '모양도 정확히 구분해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㅑ는?',
              'answer': 'ㅑ',
              'choices': ['ㅑ', 'ㅏ', 'ㅕ']
            },
            {
              'question': '다음 중 ㅕ는?',
              'answer': 'ㅕ',
              'choices': ['ㅓ', 'ㅕ', 'ㅠ']
            },
            {
              'question': '다음 중 ㅛ는?',
              'answer': 'ㅛ',
              'choices': ['ㅛ', 'ㅗ', 'ㅠ']
            },
            {
              'question': '다음 중 ㅠ는?',
              'answer': 'ㅠ',
              'choices': ['ㅜ', 'ㅛ', 'ㅠ']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '2-5',
          'message': '좋아요!\nY-모음 4개 구분이 좋아졌어요.',
        },
      ),
    ],
  ),

  // ── Lesson 2-6: 기본 vs Y-모음 대비 ──
  LessonData(
    id: '2-6',
    title: '기본 vs Y-모음 대비',
    subtitle: 'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '헷갈리는 짝 정리',
        description: '기본 모음과 Y-모음을 짝으로 비교해요.',
        data: {
          'emoji': '🧠',
          'highlights': ['ㅏ/ㅑ', 'ㅓ/ㅕ', 'ㅗ/ㅛ', 'ㅜ/ㅠ'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '짝 소리 구분',
        description: '비슷한 소리 중 정답을 골라요',
        data: {
          'questions': [
            {
              'answer': '야',
              'choices': ['아', '야']
            },
            {
              'answer': '여',
              'choices': ['어', '여']
            },
            {
              'answer': '요',
              'choices': ['오', '요']
            },
            {
              'answer': '유',
              'choices': ['우', '유']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '짝 모양 구분',
        description: '추가 획 유무를 확인해요',
        data: {
          'questions': [
            {
              'question': '획이 추가된 모음은?',
              'answer': 'ㅑ',
              'choices': ['ㅏ', 'ㅑ']
            },
            {
              'question': '획이 추가된 모음은?',
              'answer': 'ㅕ',
              'choices': ['ㅓ', 'ㅕ']
            },
            {
              'question': '획이 추가된 모음은?',
              'answer': 'ㅛ',
              'choices': ['ㅗ', 'ㅛ']
            },
            {
              'question': '획이 추가된 모음은?',
              'answer': 'ㅠ',
              'choices': ['ㅜ', 'ㅠ']
            },
            {
              'question': 'ㅇ + ㅠ = ?',
              'answer': '유',
              'choices': ['우', '유', '요']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '2-6',
          'message': '좋아요!\n기본/ Y-모음 대비가 안정됐어요.',
        },
      ),
    ],
  ),

  // ── Lesson 2-7: Stage 2 Mission ──
  LessonData(
    id: '2-7',
    title: 'Y-모음 미션',
    subtitle: '시간 안에 Y-모음 조합 완성하기',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '2단계 최종 미션',
        description: 'Y-모음 조합을 빠르고 정확하게 맞춰요.\n'
            '완성 수와 시간으로 레몬 보상이 정해져요.',
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
          'vowels': ['ㅑ', 'ㅕ', 'ㅛ', 'ㅠ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: '미션 결과',
      ),
      LessonStep(
        type: StepType.summary,
        title: '2단계 완료!',
        data: {
          'lessonId': '2-7',
          'message': '축하해요!\n2단계 Y-모음을 모두 마쳤어요.',
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 2 완료!',
        data: {
          'message': 'Y-모음까지 정복했어요!',
          'stageNumber': 2,
        },
      ),
    ],
  ),
];
