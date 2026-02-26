import '../stage0/stage0_lesson_content.dart';

/// All Stage 11 lessons — 단어 읽기 확장.
const stage11Lessons = <LessonData>[
  LessonData(
    id: '11-1',
    title: '받침 없는 단어',
    subtitle: '아주 쉬운 2~3음절 단어',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '단어 읽기 시작',
        description: '먼저 받침 없는 단어로 자신감을 만들어요.',
        data: {
          'highlights': ['바나나', '나비', '하마', '모자']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '단어 소리 듣기',
        description: '바나나/나비/하마/모자를 들어보세요',
        data: {
          'characters': ['바나나', '나비', '하마', '모자'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '11-1', 'message': '좋아요!\n받침 없는 단어 읽기를 시작했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '11-2',
    title: '기본 받침 단어',
    subtitle: '학교 · 친구 · 한국 · 공부',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '단어 소리 듣기',
        description: '학교/친구/한국/공부를 들어보세요',
        data: {
          'characters': ['학교', '친구', '한국', '공부'],
          'type': 'word'
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '듣고 고르기',
        description: '들린 단어를 선택하세요',
        data: {
          'questions': [
            {
              'answer': '학교',
              'choices': ['하교', '학교', '학구']
            },
            {
              'answer': '한국',
              'choices': ['한구', '한국', '하눅']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '11-2', 'message': '좋아요!\n기본 받침 단어를 읽었어요.'},
      ),
    ],
  ),
  LessonData(
    id: '11-3',
    title: '받침 혼합 단어',
    subtitle: '읽기 · 없다 · 많다 · 닭',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '난이도 올리기',
        description: '기본/복합 받침이 섞인 단어를 읽어봐요.',
        data: {
          'highlights': ['읽기', '없다', '많다', '닭']
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '단어 구분',
        description: '비슷한 단어를 구분해요',
        data: {
          'questions': [
            {
              'question': '다음 중 복합 받침 단어는?',
              'answer': '없다',
              'choices': ['업다', '없다', '엇다']
            },
            {
              'question': '다음 중 복합 받침 단어는?',
              'answer': '읽기',
              'choices': ['익기', '일기', '읽기']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '11-3', 'message': '좋아요!\n받침 혼합 단어를 읽었어요.'},
      ),
    ],
  ),
  LessonData(
    id: '11-4',
    title: '카테고리 단어팩',
    subtitle: '음식 · 장소 · 사람',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '카테고리 단어 듣기',
        description: '음식/장소/사람 단어를 들어보세요',
        data: {
          'characters': ['김치', '라면', '학교', '시장', '학생', '선생님'],
          'type': 'word',
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '카테고리 분류',
        description: '단어를 보고 카테고리를 고르세요',
        data: {
          'questions': [
            {
              'question': '"김치"는?',
              'answer': '음식',
              'choices': ['음식', '장소', '사람']
            },
            {
              'question': '"시장"은?',
              'answer': '장소',
              'choices': ['음식', '장소', '사람']
            },
            {
              'question': '"학생"은?',
              'answer': '사람',
              'choices': ['음식', '장소', '사람']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '11-4', 'message': '좋아요!\n카테고리 단어를 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '11-5',
    title: '듣고 고르는 단어',
    subtitle: '청각-읽기 연결 강화',
    steps: [
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 매칭',
        description: '소리를 듣고 정답 단어를 고르세요',
        data: {
          'questions': [
            {
              'answer': '친구',
              'choices': ['친구', '친구들', '친국']
            },
            {
              'answer': '공부',
              'choices': ['공부', '공부해', '콩부']
            },
            {
              'answer': '학교',
              'choices': ['학고', '학교', '하교']
            },
            {
              'answer': '모자',
              'choices': ['모자', '모차', '모사']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '11-5', 'message': '좋아요!\n듣고 고르는 단어 훈련을 마쳤어요.'},
      ),
    ],
  ),
  LessonData(
    id: '11-6',
    title: '11단계 종합',
    subtitle: '단어 읽기 최종 점검',
    steps: [
      LessonStep(
        type: StepType.quizMcq,
        title: '종합 퀴즈',
        description: '11단계 단어를 종합 점검해요',
        data: {
          'questions': [
            {
              'question': '다음 중 받침 없는 단어는?',
              'answer': '나비',
              'choices': ['나비', '학교', '없다']
            },
            {
              'question': '다음 중 기본 받침 단어는?',
              'answer': '한국',
              'choices': ['하누', '한국', '하국']
            },
            {
              'question': '다음 중 복합 받침 단어는?',
              'answer': '많다',
              'choices': ['만다', '많다', '마다']
            },
            {
              'question': '다음 중 장소 단어는?',
              'answer': '시장',
              'choices': ['시장', '학생', '김치']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '11단계 완료!',
        data: {'lessonId': '11-6', 'message': '축하해요!\n11단계 단어 읽기 확장을 완료했어요.'},
      ),
    ],
  ),

  // ── Lesson 11-7: 실생활 한국어 읽기 ──
  LessonData(
    id: '11-7',
    title: '실생활 한국어 읽기',
    subtitle: '카페 메뉴, 지하철, 인사를 읽어봐요',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '한국에서 한글 읽기!',
        description: '이제 한글을 다 배웠어요!\n실제 한국에서 볼 수 있는 글자를 읽어볼까요?',
        data: {
          'emoji': '🇰🇷',
          'highlights': ['카페', '지하철', '인사'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '카페 메뉴 읽기',
        data: {
          'characters': ['아메리카노', '카페라떼', '녹차', '케이크'],
          'descriptions': ['Americano', 'Caffe Latte', 'Green tea', 'Cake'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '지하철역 이름 읽기',
        data: {
          'characters': ['서울역', '강남', '홍대입구', '명동'],
          'descriptions': ['Seoul Station', 'Gangnam', 'Hongdae', 'Myeongdong'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '기본 인사 읽기',
        data: {
          'characters': ['안녕하세요', '감사합니다', '네', '아니요'],
          'descriptions': ['Hello', 'Thank you', 'Yes', 'No'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '어디에서 볼 수 있을까요?',
        data: {
          'questions': [
            {'question': '"아메리카노"는 어디에서 볼 수 있을까요?', 'answer': '카페', 'choices': ['카페', '지하철', '학교']},
            {'question': '"강남"은 무엇일까요?', 'answer': '지하철역 이름', 'choices': ['음식 이름', '지하철역 이름', '인사']},
            {'question': '"감사합니다"는 영어로?', 'answer': 'Thank you', 'choices': ['Hello', 'Thank you', 'Goodbye']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '축하해요!',
        data: {
          'message': '이제 한국에서 카페 메뉴, 지하철역, 인사를 읽을 수 있어요!\n한글 마스터까지 거의 다 왔어요!',
        },
      ),
    ],
  ),
  LessonData(
    id: '11-M',
    title: '미션: 한글 속독!',
    subtitle: '한국어 단어를 빠르게 읽어요',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '한글 속독 미션!',
        description: '한국어 단어를 빠르게 읽고 맞춰봐요!\n실력을 증명할 시간이에요!',
        data: {'timeLimit': 90, 'targetCount': 10},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 90,
          'targetCount': 10,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅎ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ', 'ㅡ', 'ㅣ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: '미션 결과',
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: '한글 마스터!',
        data: {'message': '한글을 완전히 마스터했어요!\n이제 한국어 단어와 문장을 읽을 수 있어요!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 11 완료!',
        data: {
          'message': '한글을 완전히 읽을 수 있어요!',
          'stageNumber': 11,
        },
      ),
    ],
  ),
];
