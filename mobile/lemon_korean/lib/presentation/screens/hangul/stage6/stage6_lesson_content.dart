import '../stage0/stage0_lesson_content.dart';

/// All Stage 6 lessons — 본격 조합 훈련.
const stage6Lessons = <LessonData>[
  LessonData(
    id: '6-1',
    title: '가~기 패턴 읽기',
    subtitle: 'ㄱ + 기본 모음 패턴',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '패턴으로 읽기 시작',
        description: 'ㄱ에 모음을 바꿔 붙이며 읽어보면\n읽기 리듬이 생겨요.',
        data: {
          'highlights': ['가', '거', '고', '구', '그', '기'],
          'emoji': '🔤',
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '패턴 소리 듣기',
        description: '가/거/고/구/그/기를 순서대로 들어보세요',
        data: {
          'characters': ['가', '거', '고', '구', '그', '기'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '패턴 퀴즈',
        description: '같은 자음 패턴을 맞춰요',
        data: {
          'questions': [
            {
              'question': 'ㄱ + ㅏ = ?',
              'answer': '가',
              'choices': ['가', '나', '다']
            },
            {
              'question': 'ㄱ + ㅓ = ?',
              'answer': '거',
              'choices': ['거', '고', '구']
            },
            {
              'question': 'ㄱ + ㅡ = ?',
              'answer': '그',
              'choices': ['그', '기', '구']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-1', 'message': '좋아요!\n가~기 패턴 읽기를 시작했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-2',
    title: '나~니 확장',
    subtitle: 'ㄴ 패턴 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㄴ 패턴 확장',
        description: 'ㄴ에 모음을 바꿔 붙여 나~니를 읽어요.',
        data: {
          'highlights': ['나', '너', '노', '누', '느', '니']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '나~니 듣기',
        description: 'ㄴ 패턴 소리를 들어보세요',
        data: {
          'characters': ['나', '너', '노', '누', '느', '니'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㄴ 조합 만들기',
        description: 'ㄴ + 모음으로 글자를 만들어요',
        data: {
          'targets': [
            {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
            {'consonant': 'ㄴ', 'vowel': 'ㅗ', 'result': '노'},
            {'consonant': 'ㄴ', 'vowel': 'ㅣ', 'result': '니'},
          ],
          'consonantChoices': ['ㄴ', 'ㄷ', 'ㄹ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅣ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-2', 'message': '좋아요!\n나~니 패턴을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-3',
    title: '다~디, 라~리 확장',
    subtitle: 'ㄷ/ㄹ 패턴 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '자음만 바꿔 읽기',
        description: '같은 모음에 자음을 바꿔 읽으면\n속도가 빨라져요.',
        data: {
          'highlights': ['다/라', '도/로', '두/루', '디/리']
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㄷ/ㄹ 구분 듣기',
        description: '소리를 듣고 맞게 선택하세요',
        data: {
          'questions': [
            {
              'answer': '다',
              'choices': ['다', '라']
            },
            {
              'answer': '로',
              'choices': ['도', '로']
            },
            {
              'answer': '루',
              'choices': ['두', '루']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '읽기 퀴즈',
        description: '패턴을 확인해요',
        data: {
          'questions': [
            {
              'question': 'ㄷ + ㅣ = ?',
              'answer': '디',
              'choices': ['디', '리', '니']
            },
            {
              'question': 'ㄹ + ㅗ = ?',
              'answer': '로',
              'choices': ['도', '로', '노']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-3', 'message': '좋아요!\nㄷ/ㄹ 패턴을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-4',
    title: '랜덤 음절 읽기 1',
    subtitle: '기본 패턴 섞기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '순서 없이 읽기',
        description: '이제 랜덤 카드처럼 읽어볼게요.',
        data: {'emoji': '🎲'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '랜덤 읽기',
        description: '랜덤으로 제시된 음절을 맞춰요',
        data: {
          'questions': [
            {
              'question': 'ㄱ + ㅗ = ?',
              'answer': '고',
              'choices': ['고', '구', '거']
            },
            {
              'question': 'ㄴ + ㅜ = ?',
              'answer': '누',
              'choices': ['누', '노', '너']
            },
            {
              'question': 'ㄹ + ㅏ = ?',
              'answer': '라',
              'choices': ['라', '다', '나']
            },
            {
              'question': 'ㅁ + ㅣ = ?',
              'answer': '미',
              'choices': ['미', '머', '모']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-4', 'message': '좋아요!\n랜덤 읽기 1을 완료했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-5',
    title: '소리 듣고 음절 찾기',
    subtitle: '청각-문자 연결 강화',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '듣고 찾는 연습',
        description: '소리를 듣고 해당 음절을 고르며\n읽기 연결을 강화해요.',
        data: {'emoji': '👂'},
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '소리 매칭',
        description: '정답 음절을 골라보세요',
        data: {
          'questions': [
            {
              'answer': '바',
              'choices': ['바', '마', '다']
            },
            {
              'answer': '서',
              'choices': ['서', '저', '더']
            },
            {
              'answer': '호',
              'choices': ['호', '오', '코']
            },
            {
              'answer': '주',
              'choices': ['주', '수', '부']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-5', 'message': '좋아요!\n듣고 찾기 연습을 완료했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-6',
    title: '복합 모음 조합 1',
    subtitle: 'ㅘ, ㅝ 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '복합 모음 시작',
        description: 'ㅘ, ㅝ를 조합해서 읽어봐요.',
        data: {
          'highlights': ['ㅘ', 'ㅝ', '와', '워']
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '와/워 듣기',
        description: '대표 음절 소리를 들어보세요',
        data: {
          'characters': ['와', '워', '과', '권'],
          'type': 'syllable',
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '복합 모음 퀴즈',
        description: 'ㅘ/ㅝ를 구분해요',
        data: {
          'questions': [
            {
              'question': 'ㅇ + ㅘ = ?',
              'answer': '와',
              'choices': ['와', '워', '왜']
            },
            {
              'question': 'ㄱ + ㅝ = ?',
              'answer': '궈',
              'choices': ['과', '궈', '괴']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-6', 'message': '좋아요!\nㅘ/ㅝ 조합을 익혔어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-7',
    title: '복합 모음 조합 2',
    subtitle: 'ㅙ, ㅞ, ㅚ, ㅟ, ㅢ 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '복합 모음 확장',
        description: '조합형 모음을 짧게 익히고 읽기 중심으로 갑니다.',
        data: {
          'highlights': ['왜', '웨', '외', '위', '의']
        },
      ),
      LessonStep(
        type: StepType.intro,
        title: 'ㅢ의 특별한 발음',
        description: 'ㅢ는 위치에 따라 소리가 달라지는 특별한 모음이에요.\n\n'
            '• 첫소리: [의] → 의사, 의자\n'
            '• 자음 뒤: [이] → 희망→[히망]\n'
            '• 조사 "의": [에] → 나의→[나에]',
        data: {
          'emoji': '✨',
          'highlights': ['ㅢ', '의', '이', '에'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '복합 모음 선택',
        description: '알맞은 음절을 고르세요',
        data: {
          'questions': [
            {
              'question': 'ㅇ + ㅙ = ?',
              'answer': '왜',
              'choices': ['왜', '외', '웨']
            },
            {
              'question': 'ㅇ + ㅟ = ?',
              'answer': '위',
              'choices': ['의', '외', '위']
            },
            {
              'question': 'ㅇ + ㅢ = ?',
              'answer': '의',
              'choices': ['의', '위', '왜']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-7', 'message': '좋아요!\n복합 모음 확장을 완료했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-8',
    title: '랜덤 음절 읽기 2',
    subtitle: '기본+복합 모음 종합',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '종합 랜덤 읽기',
        description: '기본/복합 모음을 함께 섞어 읽어요.',
        data: {'emoji': '🧩'},
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '종합 퀴즈',
        description: '랜덤 조합을 맞춰요',
        data: {
          'questions': [
            {
              'question': 'ㄱ + ㅢ = ?',
              'answer': '긔',
              'choices': ['기', '귀', '긔']
            },
            {
              'question': 'ㅎ + ㅘ = ?',
              'answer': '화',
              'choices': ['호', '화', '휘']
            },
            {
              'question': 'ㅂ + ㅟ = ?',
              'answer': '뷔',
              'choices': ['비', '뵈', '뷔']
            },
            {
              'question': 'ㅈ + ㅝ = ?',
              'answer': '줘',
              'choices': ['조', '줘', '쥐']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {'lessonId': '6-8', 'message': '좋아요!\n6단계 종합 읽기를 완료했어요.'},
      ),
    ],
  ),
  LessonData(
    id: '6-M',
    title: '6단계 미션',
    subtitle: '조합 읽기 최종 점검',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '미션 시작!',
        description: '본격 조합 훈련을 최종 점검합니다.\n제한 시간 안에 목표를 달성하세요!',
        data: {
          'timeLimit': 120,
          'targetCount': 8,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ', 'ㅇ', 'ㅈ'],
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
        title: '6단계 완료!',
        data: {
          'lessonId': '6-M',
          'message': '축하해요!\n6단계 본격 조합 훈련을 완료했어요.',
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 6 완료!',
        data: {
          'message': '자유롭게 음절을 조합할 수 있어요!',
          'stageNumber': 6,
        },
      ),
    ],
  ),
];
