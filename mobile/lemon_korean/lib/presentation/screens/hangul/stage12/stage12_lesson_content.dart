import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 12 lessons — 간단한 문장 읽기.
List<LessonData> getStage12Lessons(AppLocalizations l10n) => <LessonData>[
  // ── Lesson 12-1: 인사 표현 ──
  LessonData(
    id: '12-1',
    title: '인사 표현',
    subtitle: '기본 인사말 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '문장 읽기 시작!',
        description: '한글을 모두 배웠으니 이제 실제 문장을 읽어봅시다!',
        data: {
          'highlights': ['문장', '읽기', '인사'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '인사 표현 듣기',
        description: '한국어 기본 인사 표현을 들어보세요.',
        data: {
          'characters': ['안녕하세요', '감사합니다', '죄송합니다', '안녕히 가세요'],
          'type': 'sentence',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '인사 표현 따라 읽기',
        description: '인사 표현을 소리 내어 읽어보세요.',
        data: {
          'characters': ['안녕하세요', '감사합니다', '죄송합니다', '안녕히 가세요'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '인사 표현 완료!',
        data: {'lessonId': '12-1', 'message': '기본 인사 표현을 배웠습니다!'},
      ),
    ],
  ),

  // ── Lesson 12-2: 자기소개 ──
  LessonData(
    id: '12-2',
    title: '자기소개',
    subtitle: '자기소개 문장 읽기',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '자기소개 표현 듣기',
        description: '자기소개에 쓰이는 문장을 들어보세요.',
        data: {
          'characters': ['저는 학생입니다', '이름이 뭐예요?', '만나서 반갑습니다', '한국어를 공부해요'],
          'type': 'sentence',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '자기소개 따라 읽기',
        description: '자기소개 문장을 소리 내어 읽어보세요.',
        data: {
          'characters': ['저는 학생입니다', '이름이 뭐예요?', '만나서 반갑습니다', '한국어를 공부해요'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '자기소개 문장 듣고 고르기',
        description: '문장을 듣고 올바른 문장을 고르세요.',
        data: {
          'questions': [
            {
              'answer': '저는 학생입니다',
              'choices': ['저는 학생입니다', '저는 선생님입니다', '저는 회사원입니다'],
            },
            {
              'answer': '이름이 뭐예요?',
              'choices': ['이름이 뭐예요?', '나이가 몇이에요?', '어디에서 왔어요?'],
            },
            {
              'answer': '만나서 반갑습니다',
              'choices': ['만나서 반갑습니다', '감사합니다', '안녕하세요'],
            },
            {
              'answer': '한국어를 공부해요',
              'choices': ['한국어를 공부해요', '영어를 공부해요', '일본어를 공부해요'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '자기소개 완료!',
        data: {'lessonId': '12-2', 'message': '자기소개 표현을 배웠습니다!'},
      ),
    ],
  ),

  // ── Lesson 12-3: 카페에서 ──
  LessonData(
    id: '12-3',
    title: '카페에서',
    subtitle: '카페 주문 표현',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '카페에서 사용하는 표현',
        description: '카페에서 자주 쓰는 한국어 표현을 배워봅시다!',
        data: {
          'highlights': ['카페', '주문', '표현'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '카페 표현 듣기',
        description: '카페에서 사용하는 표현을 들어보세요.',
        data: {
          'characters': ['아메리카노 하나 주세요', '얼마예요?', '여기 앉아도 돼요?', '계산해 주세요'],
          'type': 'sentence',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '카페 표현 따라 읽기',
        description: '카페 표현을 소리 내어 읽어보세요.',
        data: {
          'characters': ['아메리카노 하나 주세요', '얼마예요?', '여기 앉아도 돼요?', '계산해 주세요'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '카페 표현 완료!',
        data: {'lessonId': '12-3', 'message': '카페에서 쓸 수 있는 표현을 배웠습니다!'},
      ),
    ],
  ),

  // ── Lesson 12-4: 길 찾기 ──
  LessonData(
    id: '12-4',
    title: '길 찾기',
    subtitle: '길 묻기와 안내 표현',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '길 찾기 표현 듣기',
        description: '길을 찾을 때 사용하는 표현을 들어보세요.',
        data: {
          'characters': ['지하철역이 어디예요?', '오른쪽으로 가세요', '여기에서 가까워요', '몇 번 출구예요?'],
          'type': 'sentence',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '길 찾기 표현 따라 읽기',
        description: '길 찾기 표현을 소리 내어 읽어보세요.',
        data: {
          'characters': ['지하철역이 어디예요?', '오른쪽으로 가세요', '여기에서 가까워요', '몇 번 출구예요?'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '길 찾기 문장 듣고 고르기',
        description: '문장을 듣고 올바른 문장을 고르세요.',
        data: {
          'questions': [
            {
              'answer': '지하철역이 어디예요?',
              'choices': ['지하철역이 어디예요?', '버스정류장이 어디예요?', '공항이 어디예요?'],
            },
            {
              'answer': '오른쪽으로 가세요',
              'choices': ['왼쪽으로 가세요', '오른쪽으로 가세요', '직진하세요'],
            },
            {
              'answer': '여기에서 가까워요',
              'choices': ['여기에서 가까워요', '여기에서 멀어요', '여기에서 걸어가세요'],
            },
            {
              'answer': '몇 번 출구예요?',
              'choices': ['몇 번 출구예요?', '몇 시예요?', '몇 층이에요?'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '길 찾기 표현 완료!',
        data: {'lessonId': '12-4', 'message': '길을 찾을 때 쓸 수 있는 표현을 배웠습니다!'},
      ),
    ],
  ),

  // ── Lesson 12-5: 음식 주문 ──
  LessonData(
    id: '12-5',
    title: '음식 주문',
    subtitle: '식당에서 주문하기',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '음식 주문 표현 듣기',
        description: '식당에서 사용하는 표현을 들어보세요.',
        data: {
          'characters': ['비빔밥 하나 주세요', '맵지 않게 해 주세요', '맛있어요!', '물 좀 주세요'],
          'type': 'sentence',
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '음식 주문 따라 읽기',
        description: '음식 주문 표현을 소리 내어 읽어보세요.',
        data: {
          'characters': ['비빔밥 하나 주세요', '맵지 않게 해 주세요', '맛있어요!', '물 좀 주세요'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '음식 주문 완료!',
        data: {'lessonId': '12-5', 'message': '식당에서 쓸 수 있는 표현을 배웠습니다!'},
      ),
    ],
  ),

  // ── Lesson 12-6: 종합 문장 읽기 ──
  LessonData(
    id: '12-6',
    title: '종합 문장 읽기',
    subtitle: '다양한 일상 문장 읽기',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '일상 문장 듣기',
        description: '다양한 일상 문장을 들어보세요.',
        data: {
          'characters': ['오늘 날씨가 좋아요', '내일 시간 있어요?', '같이 가요', '고마워요', '잘 먹겠습니다', '잘 먹었습니다'],
          'type': 'sentence',
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '일상 문장 듣고 고르기',
        description: '문장을 듣고 올바른 문장을 고르세요.',
        data: {
          'questions': [
            {
              'answer': '오늘 날씨가 좋아요',
              'choices': ['오늘 날씨가 좋아요', '어제 날씨가 좋았어요', '내일 날씨가 좋을 거예요'],
            },
            {
              'answer': '내일 시간 있어요?',
              'choices': ['오늘 시간 있어요?', '내일 시간 있어요?', '어제 시간 있었어요?'],
            },
            {
              'answer': '같이 가요',
              'choices': ['같이 가요', '혼자 가요', '빨리 가요'],
            },
            {
              'answer': '잘 먹겠습니다',
              'choices': ['잘 먹겠습니다', '잘 먹었습니다', '맛있겠습니다'],
            },
            {
              'answer': '잘 먹었습니다',
              'choices': ['잘 먹겠습니다', '잘 먹었습니다', '맛있었습니다'],
            },
            {
              'answer': '고마워요',
              'choices': ['고마워요', '미안해요', '괜찮아요'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '문장 의미 퀴즈',
        description: '문장의 의미나 상황을 골라보세요.',
        data: {
          'questions': [
            {
              'question': '"안녕하세요"는 어떤 상황에서 쓰나요?',
              'answer': '처음 만났을 때 인사',
              'choices': ['처음 만났을 때 인사', '헤어질 때 인사', '고마울 때'],
            },
            {
              'question': '"잘 먹겠습니다"는 언제 말하나요?',
              'answer': '식사 시작 전',
              'choices': ['식사 시작 전', '식사 후', '주문할 때'],
            },
            {
              'question': '"얼마예요?"는 무엇을 묻는 표현인가요?',
              'answer': '가격',
              'choices': ['가격', '시간', '장소'],
            },
            {
              'question': '"오른쪽으로 가세요"는 어떤 상황인가요?',
              'answer': '길 안내',
              'choices': ['음식 주문', '길 안내', '자기소개'],
            },
            {
              'question': '"감사합니다"는 어떤 의미인가요?',
              'answer': '고마움',
              'choices': ['미안함', '고마움', '반가움'],
            },
            {
              'question': '"비빔밥 하나 주세요"는 어디에서 쓰나요?',
              'answer': '식당',
              'choices': ['카페', '식당', '지하철역'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '종합 문장 읽기 완료!',
        data: {'lessonId': '12-6', 'message': '다양한 일상 문장을 읽을 수 있게 되었습니다!'},
      ),
    ],
  ),

  // ── Lesson 12-M: 최종 미션 ──
  LessonData(
    id: '12-M',
    title: '최종 미션',
    subtitle: '한글 학습 마무리 미션',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '최종 미션!',
        description: '120초 안에 8개의 음절을 조합하세요!\n한글의 모든 자음과 모음을 활용합니다.',
        data: {'timeLimit': 120, 'targetCount': 8},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '최종 음절 조합 미션',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ', 'ㅡ', 'ㅣ', 'ㅐ', 'ㅔ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: '미션 결과',
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: '최종 미션 완료!',
        data: {'message': '최종 미션을 완료했습니다!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: '한글 학습 완료!',
        data: {
          'message': '축하합니다! 한글의 모든 과정을 완료했습니다!\n이제 한국어 문장을 읽을 수 있습니다!',
          'stageNumber': 12,
        },
      ),
    ],
  ),
];
