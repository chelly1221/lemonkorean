/// Step types for hangul interactive lessons.
enum StepType {
  intro,
  dragDrop,
  soundExplore,
  soundMatch,
  syllableBuild,
  quizMcq,
  missionIntro,
  timedMission,
  missionResults,
  summary,
  stageComplete,
}

/// Data for a single step within a lesson.
class LessonStep {
  final StepType type;
  final String title;
  final String? description;
  final Map<String, dynamic> data;

  const LessonStep({
    required this.type,
    required this.title,
    this.description,
    this.data = const {},
  });
}

/// Data for a lesson (collection of steps).
class LessonData {
  final String id; // e.g. '0-1'
  final String title;
  final String subtitle;
  final bool isMission;
  final List<LessonStep> steps;

  const LessonData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.steps,
    this.isMission = false,
  });

  int get totalSteps => steps.length;
}

/// All Stage 0 lessons.
const stage0Lessons = <LessonData>[
  // ── Lesson 0-0: 한글 소개 ──
  LessonData(
    id: '0-0',
    title: '한글은 어떻게 생겼을까요?',
    subtitle: '한글이 만들어진 과정을 짧게 알아봐요',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '옛날에는 글을 배우기 어려웠어요',
        description: '예전에는 한자를 중심으로 글을 썼기 때문에\n많은 사람들이 읽고 쓰기 어려웠어요.',
        data: {
          'emoji': '📜',
          'highlights': ['한자', '어려움', '읽기', '쓰기'],
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: '세종대왕이 새 글자를 만들었어요',
        description:
            '백성이 쉽게 배우도록\n세종대왕이 직접 훈민정음을 만들었어요.\n(1443년 창제, 1446년 반포)',
        data: {
          'emoji': '👑',
          'highlights': ['세종대왕', '훈민정음', '1443', '1446'],
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: '그래서 지금의 한글이 되었어요',
        description:
            '한글은 소리를 쉽게 적을 수 있게 만든 글자예요.\n이제 다음 레슨에서 자음과 모음 구조를 배워볼게요.',
        data: {
          'emoji': '📝',
          'highlights': ['소리', '쉬운 글자', '한글'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '소개 레슨 완료!',
        data: {
          'lessonId': '0-0',
          'message': '좋아요!\n한글이 왜 만들어졌는지 알았어요.\n이제 자음/모음 구조를 배워볼게요.',
        },
      ),
    ],
  ),

  // ── Lesson 0-1: 가 블록 조립하기 (시각 중심) ──
  LessonData(
    id: '0-1',
    title: '가 블록 조립하기',
    subtitle: '보면서 조립하기 (시각 중심)',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '한글은 블록이에요!',
        description: '한글은 자음과 모음을 합쳐서 글자를 만들어요.\n자음(ㄱ) + 모음(ㅏ) = 가'
            '\n\n더 복잡한 글자는 아래에 받침이 들어가기도 해요.\n(나중에 배울 거예요!)',
        data: {
          'animation': {
            'consonant': 'ㄱ',
            'vowel': 'ㅏ',
            'result': '가',
          },
          'highlights': ['자음', '모음', '글자'],
        },
      ),
      // A1: syllableAnimation step removed — intro animation covers it
      LessonStep(
        type: StepType.dragDrop,
        title: '가 조립하기',
        description: 'ㄱ과 ㅏ를 빈 칸에 끌어다 놓으세요',
        data: {
          'items': [
            {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
          ],
        },
      ),
      LessonStep(
        type: StepType.dragDrop,
        title: '나 조립하기',
        description: '새로운 자음 ㄴ을 사용해보세요',
        data: {
          'items': [
            {
              'consonant': 'ㄴ',
              'vowel': 'ㅏ',
              'result': '나',
              'hint': 'ㄴ + ㅏ = 나'
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.dragDrop,
        title: '다 조립하기',
        description: '새로운 자음 ㄷ을 사용해보세요',
        data: {
          'items': [
            {
              'consonant': 'ㄷ',
              'vowel': 'ㅏ',
              'result': '다',
              'hint': 'ㄷ + ㅏ = 다'
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '0-1',
          'message': '자음 + 모음 = 글자 블록!\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다',
        },
      ),
    ],
  ),

  // ── Lesson 0-2: 소리 탐색 (청각 중심) ──
  LessonData(
    id: '0-2',
    title: '소리 탐색',
    subtitle: '소리로 자음과 모음 느끼기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '소리를 느껴보세요',
        description: '한글의 자음과 모음은 각각 고유한 소리를 가지고 있어요.\n소리를 듣고 느껴보세요.',
        data: {'emoji': '👂'},
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄱ, ㄴ, ㄷ 자음 기준 소리',
        description: 'ㅏ를 붙인 기준 소리(가, 나, 다)를 들어보세요',
        data: {
          'characters': ['ㄱ', 'ㄴ', 'ㄷ'],
          'type': 'consonant',
          'showMouth': false,
          'pronunciationMap': {'ㄱ': '가', 'ㄴ': '나', 'ㄷ': '다'},
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅏ, ㅗ 모음 소리',
        description: '두 모음의 소리를 들어보세요',
        data: {
          'characters': ['ㅏ', 'ㅗ'],
          'type': 'vowel',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '가, 나, 다 소리 듣기',
        description: '자음과 모음이 합쳐진 글자의 소리를 들어보세요',
        data: {
          'characters': ['가', '나', '다'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '0-2',
          'message': '자음은 ㅏ를 붙인 기준 소리(가, 나, 다)로,\n모음은 그대로 소리를 느낄 수 있게 되었어요!',
        },
      ),
    ],
  ),

  // ── Lesson 0-3: 듣고 고르기 (청각 집중) ──
  LessonData(
    id: '0-3',
    title: '듣고 고르기',
    subtitle: '소리를 듣고 글자를 구분해요',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '이번엔 귀로 구분해요',
        description: '화면보다 소리에 집중해서\n같은 소리와 다른 소리를 찾아보세요.',
        data: {'emoji': '🎧'},
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '가/나/다/고/노 소리 확인',
        description: '먼저 5개 소리를 충분히 들어보세요',
        data: {
          'characters': ['가', '나', '다', '고', '노'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 듣고 같은 글자 고르기',
        description: '재생된 소리와 같은 글자를 고르세요',
        data: {
          'questions': [
            {
              'answer': '가',
              'choices': ['가', '나']
            },
            {
              'answer': '다',
              'choices': ['나', '다']
            },
            {
              'answer': '고',
              'choices': ['고', '노']
            },
            {
              'answer': '노',
              'choices': ['가', '노']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅏ / ㅗ 소리 구분',
        description: '비슷한 자음에서 모음 소리를 구분해보세요',
        data: {
          'questions': [
            {
              'answer': '가',
              'choices': ['가', '고']
            },
            {
              'answer': '고',
              'choices': ['가', '고']
            },
            {
              'answer': '나',
              'choices': ['나', '노']
            },
            {
              'answer': '노',
              'choices': ['나', '노']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '0-3',
          'message': '좋아요!\n이제 눈(조립)과 귀(소리)를 함께 써서\n한글 구조를 이해할 수 있어요.',
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 0 완료!',
        data: {
          'message': '한글의 구조를 이해했어요!',
          'stageNumber': 0,
        },
      ),
    ],
  ),
];
