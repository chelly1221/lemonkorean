import '../stage0/stage0_lesson_content.dart';

/// All Stage 10 lessons — 복합 받침 (고급).
const stage10Lessons = <LessonData>[
  LessonData(
    id: '10-1',
    title: 'ㄳ 받침',
    subtitle: '몫 · 넋 중심 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '겹받침의 발음 규칙',
        description: '겹받침은 두 자음이 합쳐진 받침이에요.\n\n'
            '대부분 왼쪽 자음이 발음돼요:\n'
            'ㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\n'
            '일부는 오른쪽 자음이 발음돼요:\n'
            'ㄺ→[ㄹ], ㄼ→[ㄹ]',
        data: {
          'emoji': '🧩',
          'highlights': ['왼쪽 자음', '오른쪽 자음', '겹받침'],
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: '복합 받침 시작',
        description: 'ㄳ 받침이 들어간 단어를 읽어봐요.',
        data: {
          'highlights': ['몫', '넋']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 듣기',
        description: '몫/넋을 들어보세요',
        data: {
          'characters': ['몫', '넋'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '읽기 확인',
        description: '단어를 보고 고르세요',
        data: {
          'questions': [
            {
              'question': 'ㄳ 받침 단어는?',
              'answer': '몫',
              'choices': ['목', '몫', '몬']
            },
            {
              'question': 'ㄳ 받침 단어는?',
              'answer': '넋',
              'choices': ['넋', '넌', '널']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '10-1', 'message': '좋아요!\nㄳ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '10-2',
    title: 'ㄵ / ㄶ 받침',
    subtitle: '앉다 · 많다',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 듣기',
        description: '앉다/많다를 들어보세요',
        data: {
          'characters': ['앉다', '많다'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '정답 단어를 선택하세요',
        data: {
          'questions': [
            {
              'answer': '앉다',
              'choices': ['안다', '앉다', '않다']
            },
            {
              'answer': '많다',
              'choices': ['만다', '많다', '맑다']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '10-2', 'message': '좋아요!\nㄵ/ㄶ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '10-3',
    title: 'ㄺ / ㄻ 받침',
    subtitle: '읽다 · 삶',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 듣기',
        description: '읽다/삶을 들어보세요',
        data: {
          'characters': ['읽다', '삶'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '읽기 확인',
        description: '복합 받침 단어를 고르세요',
        data: {
          'questions': [
            {
              'question': 'ㄺ 받침 단어는?',
              'answer': '읽다',
              'choices': ['일다', '읽다', '익다']
            },
            {
              'question': 'ㄻ 받침 단어는?',
              'answer': '삶',
              'choices': ['삼', '삶', '살']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '10-3', 'message': '좋아요!\nㄺ/ㄻ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '10-4',
    title: '고급 묶음 1',
    subtitle: 'ㄼ · ㄾ · ㄿ · ㅀ',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '고급 묶음 노출',
        description: '자주 보이는 예시 중심으로 짧게 익혀요.',
        data: {
          'highlights': ['넓다', '핥다', '읊다', '싫다']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '단어 소리 듣기',
        description: '넓다/핥다/읊다/싫다를 들어보세요',
        data: {
          'characters': ['넓다', '핥다', '읊다', '싫다'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '10-4', 'message': '좋아요!\n고급 묶음 1을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '10-5',
    title: 'ㅄ 받침',
    subtitle: '없다 중심 읽기',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 듣기',
        description: '없다/없어를 들어보세요',
        data: {
          'characters': ['없다', '없어'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '정답 단어를 고르세요',
        data: {
          'questions': [
            {
              'answer': '없다',
              'choices': ['업다', '없다', '엇다']
            },
            {
              'answer': '없어',
              'choices': ['없어', '업어', '엇어']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '10-5', 'message': '좋아요!\nㅄ 받침을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '10-6',
    title: '10단계 종합',
    subtitle: '복합 받침 단어 통합',
    steps: [
      LessonStep(
        type: StepType.quizMcq,
        title: '종합 점검',
        description: '복합 받침 단어를 최종 점검해요',
        data: {
          'questions': [
            {
              'question': '다음 중 ㄶ 받침 단어는?',
              'answer': '많다',
              'choices': ['만다', '많다', '말다']
            },
            {
              'question': '다음 중 ㄺ 받침 단어는?',
              'answer': '읽다',
              'choices': ['익다', '읽다', '일다']
            },
            {
              'question': '다음 중 ㅄ 받침 단어는?',
              'answer': '없다',
              'choices': ['업다', '엇다', '없다']
            },
            {
              'question': '다음 중 ㄳ 받침 단어는?',
              'answer': '몫',
              'choices': ['목', '몫', '몰']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '10단계 완료!',
        data: {'lessonId': '10-6', 'message': '축하해요!\n10단계 복합 받침을 완료했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '10-M',
    title: '미션: 겹받침 도전!',
    subtitle: '겹받침 단어를 빠르게 읽어요',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '겹받침 미션!',
        description: '겹받침이 포함된 음절을\n빠르게 조합해요!',
        data: {'timeLimit': 120, 'targetCount': 6},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 6,
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
        data: {'message': '겹받침까지 마스터했어요!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 10 완료!',
        data: {
          'message': '겹받침까지 마스터했어요!',
          'stageNumber': 10,
        },
      ),
    ],
  ),
];
