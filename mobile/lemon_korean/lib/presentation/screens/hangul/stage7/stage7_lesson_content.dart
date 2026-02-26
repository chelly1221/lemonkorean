import '../stage0/stage0_lesson_content.dart';

/// All Stage 7 lessons — 된소리/거센소리 (5 contrast groups).
const stage7Lessons = <LessonData>[
  LessonData(
    id: '7-1',
    title: 'ㄱ / ㅋ / ㄲ 구분',
    subtitle: '가 · 카 · 까 대비',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '세 소리를 나눠 들어요',
        description: 'ㄱ(기본), ㅋ(거센), ㄲ(된) 느낌을 구분해요.',
        data: {
          'highlights': ['ㄱ', 'ㅋ', 'ㄲ', '가', '카', '까']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 탐색',
        description: '가/카/까를 반복해서 들어보세요',
        data: {
          'characters': ['가', '카', '까'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '세 보기 중 정답을 선택하세요',
        data: {
          'questions': [
            {
              'answer': '가',
              'choices': ['가', '카', '까']
            },
            {
              'answer': '카',
              'choices': ['가', '카', '까']
            },
            {
              'answer': '까',
              'choices': ['가', '카', '까']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '빠른 확인',
        description: '모양과 소리를 함께 확인해요',
        data: {
          'questions': [
            {
              'question': '거센소리는?',
              'answer': 'ㅋ',
              'choices': ['ㄱ', 'ㅋ', 'ㄲ']
            },
            {
              'question': '된소리는?',
              'answer': 'ㄲ',
              'choices': ['ㄱ', 'ㅋ', 'ㄲ']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '7-1', 'message': '좋아요!\nㄱ/ㅋ/ㄲ 구분을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '7-2',
    title: 'ㄷ / ㅌ / ㄸ 구분',
    subtitle: '다 · 타 · 따 대비',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '두 번째 대비 묶음',
        description: 'ㄷ/ㅌ/ㄸ 소리를 비교해요.',
        data: {
          'highlights': ['ㄷ', 'ㅌ', 'ㄸ', '다', '타', '따']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 탐색',
        description: '다/타/따를 반복해서 들어보세요',
        data: {
          'characters': ['다', '타', '따'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '세 보기 중 정답을 선택하세요',
        data: {
          'questions': [
            {
              'answer': '다',
              'choices': ['다', '타', '따']
            },
            {
              'answer': '타',
              'choices': ['다', '타', '따']
            },
            {
              'answer': '따',
              'choices': ['다', '타', '따']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '7-2', 'message': '좋아요!\nㄷ/ㅌ/ㄸ 구분을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '7-3',
    title: 'ㅂ / ㅍ / ㅃ 구분',
    subtitle: '바 · 파 · 빠 대비',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '세 번째 대비 묶음',
        description: 'ㅂ/ㅍ/ㅃ 소리를 비교해요.',
        data: {
          'highlights': ['ㅂ', 'ㅍ', 'ㅃ', '바', '파', '빠']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 탐색',
        description: '바/파/빠를 반복해서 들어보세요',
        data: {
          'characters': ['바', '파', '빠'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '세 보기 중 정답을 선택하세요',
        data: {
          'questions': [
            {
              'answer': '바',
              'choices': ['바', '파', '빠']
            },
            {
              'answer': '파',
              'choices': ['바', '파', '빠']
            },
            {
              'answer': '빠',
              'choices': ['바', '파', '빠']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '7-3', 'message': '좋아요!\nㅂ/ㅍ/ㅃ 구분을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '7-4',
    title: 'ㅅ / ㅆ 구분',
    subtitle: '사 · 싸 대비',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '두 소리 대비',
        description: 'ㅅ/ㅆ 소리를 구분해요.',
        data: {
          'highlights': ['ㅅ', 'ㅆ', '사', '싸']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 탐색',
        description: '사/싸를 반복해서 들어보세요',
        data: {
          'characters': ['사', '싸'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '두 보기 중 정답을 선택하세요',
        data: {
          'questions': [
            {
              'answer': '사',
              'choices': ['사', '싸']
            },
            {
              'answer': '싸',
              'choices': ['사', '싸']
            },
            {
              'answer': '싸',
              'choices': ['사', '싸']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '7-4', 'message': '좋아요!\nㅅ/ㅆ 구분을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '7-5',
    title: 'ㅈ / ㅊ / ㅉ 구분',
    subtitle: '자 · 차 · 짜 대비',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '마지막 대비 묶음',
        description: 'ㅈ/ㅊ/ㅉ 소리를 비교해요.',
        data: {
          'highlights': ['ㅈ', 'ㅊ', 'ㅉ', '자', '차', '짜']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '소리 탐색',
        description: '자/차/짜를 반복해서 들어보세요',
        data: {
          'characters': ['자', '차', '짜'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '세 보기 중 정답을 선택하세요',
        data: {
          'questions': [
            {
              'answer': '자',
              'choices': ['자', '차', '짜']
            },
            {
              'answer': '차',
              'choices': ['자', '차', '짜']
            },
            {
              'answer': '짜',
              'choices': ['자', '차', '짜']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '7단계 완료!',
        data: {
          'lessonId': '7-5',
          'message': '축하해요!\n7단계 5개 대비 묶음을 모두 완료했어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '7-M',
    title: '미션: 소리 구분 도전!',
    subtitle: '평음, 거센소리, 된소리를 구분해요',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '소리 구분 미션!',
        description: '평음, 거센소리, 된소리를 섞어서\n음절을 빠르게 조합해요!',
        data: {'timeLimit': 120, 'targetCount': 8},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㅋ', 'ㄲ', 'ㄷ', 'ㅌ', 'ㄸ', 'ㅂ', 'ㅍ', 'ㅃ'],
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
        data: {'message': '평음, 거센소리, 된소리를 구분할 수 있어요!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 7 완료!',
        data: {
          'message': '된소리와 거센소리를 구분할 수 있어요!',
          'stageNumber': 7,
        },
      ),
    ],
  ),
];
