/// Step types for hangul interactive lessons.
enum StepType {
  intro,
  syllableAnimation,
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
    this.isMission = false,
    required this.steps,
  });

  int get totalSteps => steps.length;
}

/// All Stage 0 lessons.
const stage0Lessons = <LessonData>[
  // ── Lesson 0-1: 가 블록 조립하기 ──
  LessonData(
    id: '0-1',
    title: '가 블록 조립하기',
    subtitle: '자음 + 모음 = 글자',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '한글은 블록이에요!',
        description: '한글은 자음과 모음을 합쳐서 글자를 만들어요.\n자음(ㄱ) + 모음(ㅏ) = 가',
        data: {
          'emoji': '🧱',
          'highlights': ['자음', '모음', '글자'],
        },
      ),
      LessonStep(
        type: StepType.syllableAnimation,
        title: '가 = ㄱ + ㅏ',
        description: '자음과 모음이 합쳐져서 "가"가 됩니다',
        data: {
          'consonant': 'ㄱ',
          'vowel': 'ㅏ',
          'result': '가',
        },
      ),
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
        title: '나, 다 조립하기',
        description: '자음과 모음을 조합해보세요',
        data: {
          'items': [
            {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
            {'consonant': 'ㄷ', 'vowel': 'ㅏ', 'result': '다'},
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

  // ── Lesson 0-2: 소리와 입모양 감각 켜기 ──
  LessonData(
    id: '0-2',
    title: '소리와 입모양 감각 켜기',
    subtitle: '소리로 자음과 모음 느끼기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '소리를 느껴보세요',
        description: '한글의 자음과 모음은 각각 고유한 소리를 가지고 있어요.\n소리를 듣고 입모양을 관찰해보세요.',
        data: {'emoji': '👂'},
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄱ 소리 탐색',
        description: 'ㄱ 소리를 듣고 입모양을 살펴보세요',
        data: {'character': 'ㄱ', 'type': 'consonant'},
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄴ, ㄷ 소리 탐색',
        description: 'ㄴ과 ㄷ의 소리를 비교해보세요',
        data: {
          'characters': ['ㄴ', 'ㄷ'],
          'type': 'consonant',
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅏ, ㅗ 모음 소리',
        description: '모음의 소리를 듣고 입모양 차이를 느껴보세요',
        data: {
          'characters': ['ㅏ', 'ㅗ'],
          'type': 'vowel',
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 퀴즈',
        description: '소리를 듣고 알맞은 글자를 골라보세요',
        data: {
          'questions': [
            {'answer': 'ㄱ', 'choices': ['ㄱ', 'ㄴ']},
            {'answer': 'ㄴ', 'choices': ['ㄷ', 'ㄴ']},
            {'answer': 'ㅏ', 'choices': ['ㅏ', 'ㅗ']},
            {'answer': 'ㅗ', 'choices': ['ㅏ', 'ㅗ']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '0-2',
          'message': '자음(ㄱ, ㄴ, ㄷ)과 모음(ㅏ, ㅗ)의\n소리를 느낄 수 있게 되었어요!',
        },
      ),
    ],
  ),

  // ── Lesson 0-3: 내 첫 글자 만들기 ──
  LessonData(
    id: '0-3',
    title: '내 첫 글자 만들기',
    subtitle: '자음 + 모음 선택해서 글자 만들기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '글자를 만들어보세요!',
        description: '자음과 모음을 골라서\n직접 글자를 조합해보세요.',
        data: {'emoji': '✨'},
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: '가 만들기',
        data: {
          'targetConsonant': 'ㄱ',
          'targetVowel': 'ㅏ',
          'result': '가',
          'consonantChoices': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: '나 만들기',
        data: {
          'targetConsonant': 'ㄴ',
          'targetVowel': 'ㅏ',
          'result': '나',
          'consonantChoices': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: '다 만들기',
        data: {
          'targetConsonant': 'ㄷ',
          'targetVowel': 'ㅏ',
          'result': '다',
          'consonantChoices': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: '고, 노 만들기',
        description: 'ㅗ 모음을 사용해보세요',
        data: {
          'targets': [
            {'consonant': 'ㄱ', 'vowel': 'ㅗ', 'result': '고'},
            {'consonant': 'ㄴ', 'vowel': 'ㅗ', 'result': '노'},
          ],
          'consonantChoices': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '글자 조합 퀴즈',
        description: '알맞은 글자를 고르세요',
        data: {
          'questions': [
            {'question': 'ㄱ + ㅏ = ?', 'answer': '가', 'choices': ['가', '나', '다', '고']},
            {'question': 'ㄴ + ㅏ = ?', 'answer': '나', 'choices': ['가', '나', '다', '노']},
            {'question': 'ㄷ + ㅏ = ?', 'answer': '다', 'choices': ['가', '나', '다', '도']},
            {'question': 'ㄱ + ㅗ = ?', 'answer': '고', 'choices': ['가', '고', '노', '도']},
            {'question': 'ㄴ + ㅗ = ?', 'answer': '노', 'choices': ['나', '고', '노', '도']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '0-3',
          'message': '가, 나, 다, 고, 노를\n직접 만들 수 있게 되었어요!',
        },
      ),
    ],
  ),

  // ── Lesson 0-M: 블록 미션 ──
  LessonData(
    id: '0-M',
    title: '블록 미션',
    subtitle: '3분 안에 글자 블록 5개 완성!',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '블록 미션!',
        description: '3분 안에 글자 블록 5개를 완성하세요!',
        data: {
          'timeLimitSeconds': 180,
          'targetCount': 5,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '미션 진행 중',
        data: {
          'timeLimitSeconds': 180,
          'targetCount': 5,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowels': ['ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: '미션 결과',
        data: {'lessonId': '0-M'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: '0단계 완료!',
        description: '한글 구조 이해를 모두 마쳤어요!',
        data: {'stage': 0},
      ),
    ],
  ),
];
