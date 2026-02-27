import '../stage0/stage0_lesson_content.dart';

/// All Stage 5 lessons — 기본 자음 2 (ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ).
const stage5Lessons = <LessonData>[
  LessonData(
    id: '5-1',
    title: 'ㅇ 자리 이해하기',
    subtitle: '초성 ㅇ과 조합 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅇ은 특별한 자음이에요',
        description: '초성 ㅇ은 소리가 거의 없고,\n'
            '모음과 만나면 아/오/우처럼 읽혀요.',
        data: {
          'animation': {'consonant': 'ㅇ', 'vowel': 'ㅏ', 'result': '아'},
          'highlights': ['ㅇ', '아', '초성 자리'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅇ 조합 소리 듣기',
        description: '아/오/우 소리를 들어보세요',
        data: {
          'characters': ['아', '오', '우'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['아', '오', '우'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅇ으로 글자 만들기',
        description: 'ㅇ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅏ', 'result': '아'},
            {'consonant': 'ㅇ', 'vowel': 'ㅗ', 'result': '오'},
            {'consonant': 'ㅇ', 'vowel': 'ㅜ', 'result': '우'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-1',
          'message': '좋아요!\nㅇ 자리를 이해했어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-2',
    title: 'ㅈ 모양과 소리',
    subtitle: 'ㅈ 기본 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅈ을 배워요',
        description: 'ㅈ은 "자" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅈ', 'vowel': 'ㅏ', 'result': '자'},
          'highlights': ['ㅈ', '자'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅈ 소리 듣기',
        description: '자/조/주 소리를 들어보세요',
        data: {
          'characters': ['자', '조', '주'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['자', '조', '주'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅈ 소리 고르기',
        description: '자/사를 구분해요',
        data: {
          'questions': [
            {
              'answer': '자',
              'choices': ['자', '사']
            },
            {
              'answer': '조',
              'choices': ['조', '소']
            },
            {
              'answer': '주',
              'choices': ['주', '수']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: 'ㅈ으로 글자 만들기',
        description: 'ㅈ + 모음을 조합해보세요',
        data: {
          'targets': [
            {'consonant': 'ㅈ', 'vowel': 'ㅏ', 'result': '자'},
            {'consonant': 'ㅈ', 'vowel': 'ㅗ', 'result': '조'},
            {'consonant': 'ㅈ', 'vowel': 'ㅜ', 'result': '주'},
          ],
          'consonantChoices': ['ㅈ', 'ㅅ', 'ㅊ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-2',
          'message': '좋아요!\nㅈ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-3',
    title: 'ㅊ 모양과 소리',
    subtitle: 'ㅊ 기본 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅊ을 배워요',
        description: 'ㅊ은 "차" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅊ', 'vowel': 'ㅏ', 'result': '차'},
          'highlights': ['ㅊ', '차'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅊ 소리 듣기',
        description: '차/초/추 소리를 들어보세요',
        data: {
          'characters': ['차', '초', '추'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['차', '초', '추'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅊ 소리 고르기',
        description: '차/자를 구분해요',
        data: {
          'questions': [
            {
              'answer': '차',
              'choices': ['차', '자']
            },
            {
              'answer': '초',
              'choices': ['초', '조']
            },
            {
              'answer': '추',
              'choices': ['추', '주']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-3',
          'message': '좋아요!\nㅊ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-4',
    title: 'ㅋ 모양과 소리',
    subtitle: 'ㅋ 기본 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅋ을 배워요',
        description: 'ㅋ은 "카" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅋ', 'vowel': 'ㅏ', 'result': '카'},
          'highlights': ['ㅋ', '카'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅋ 소리 듣기',
        description: '카/코/쿠 소리를 들어보세요',
        data: {
          'characters': ['카', '코', '쿠'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['카', '코', '쿠'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅋ 소리 고르기',
        description: '카/가를 구분해요',
        data: {
          'questions': [
            {
              'answer': '카',
              'choices': ['가', '카']
            },
            {
              'answer': '코',
              'choices': ['고', '코']
            },
            {
              'answer': '쿠',
              'choices': ['구', '쿠']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-4',
          'message': '좋아요!\nㅋ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-5',
    title: 'ㅌ 모양과 소리',
    subtitle: 'ㅌ 기본 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅌ을 배워요',
        description: 'ㅌ은 "타" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅌ', 'vowel': 'ㅏ', 'result': '타'},
          'highlights': ['ㅌ', '타'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅌ 소리 듣기',
        description: '타/토/투 소리를 들어보세요',
        data: {
          'characters': ['타', '토', '투'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['타', '토', '투'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅌ 소리 고르기',
        description: '타/다를 구분해요',
        data: {
          'questions': [
            {
              'answer': '타',
              'choices': ['다', '타']
            },
            {
              'answer': '토',
              'choices': ['도', '토']
            },
            {
              'answer': '투',
              'choices': ['두', '투']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-5',
          'message': '좋아요!\nㅌ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-6',
    title: 'ㅍ 모양과 소리',
    subtitle: 'ㅍ 기본 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅍ을 배워요',
        description: 'ㅍ은 "파" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅍ', 'vowel': 'ㅏ', 'result': '파'},
          'highlights': ['ㅍ', '파'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅍ 소리 듣기',
        description: '파/포/푸 소리를 들어보세요',
        data: {
          'characters': ['파', '포', '푸'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['파', '포', '푸'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅍ 소리 고르기',
        description: '파/바를 구분해요',
        data: {
          'questions': [
            {
              'answer': '파',
              'choices': ['바', '파']
            },
            {
              'answer': '포',
              'choices': ['보', '포']
            },
            {
              'answer': '푸',
              'choices': ['부', '푸']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-6',
          'message': '좋아요!\nㅍ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-7',
    title: 'ㅎ 모양과 소리',
    subtitle: 'ㅎ 기본 읽기',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㅎ을 배워요',
        description: 'ㅎ은 "하" 소리 계열을 만들어요.',
        data: {
          'animation': {'consonant': 'ㅎ', 'vowel': 'ㅏ', 'result': '하'},
          'highlights': ['ㅎ', '하'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㅎ 소리 듣기',
        description: '하/호/후 소리를 들어보세요',
        data: {
          'characters': ['하', '호', '후'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: '발음 연습',
        description: '글자를 직접 소리내어 보세요',
        data: {
          'characters': ['하', '호', '후'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㅎ 소리 고르기',
        description: '하/아를 구분해요',
        data: {
          'questions': [
            {
              'answer': '하',
              'choices': ['아', '하']
            },
            {
              'answer': '호',
              'choices': ['오', '호']
            },
            {
              'answer': '후',
              'choices': ['우', '후']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-7',
          'message': '좋아요!\nㅎ 소리와 모양을 익혔어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-8',
    title: '추가 자음 랜덤 읽기',
    subtitle: 'ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ 섞어서 점검',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '랜덤으로 점검해요',
        description: '추가 자음 7개를 섞어서 읽어볼게요.',
        data: {
          'emoji': '🎯',
          'highlights': ['ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '모양/소리 퀴즈',
        description: '소리와 글자를 연결해요',
        data: {
          'questions': [
            {
              'question': 'ㅇ + ㅗ = ?',
              'answer': '오',
              'choices': ['오', '호', '고']
            },
            {
              'question': 'ㅈ + ㅏ = ?',
              'answer': '자',
              'choices': ['자', '차', '사']
            },
            {
              'question': 'ㅋ + ㅜ = ?',
              'answer': '쿠',
              'choices': ['구', '쿠', '투']
            },
            {
              'question': 'ㅍ + ㅗ = ?',
              'answer': '포',
              'choices': ['보', '호', '포']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-8',
          'message': '좋아요!\n기본 자음 2를 랜덤으로 점검했어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-9',
    title: '혼동쌍 미리보기',
    subtitle: '다음 단계 대비 구분 연습',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '헷갈리는 쌍을 먼저 봐요',
        description: 'ㅈ/ㅊ, ㄱ/ㅋ, ㄷ/ㅌ, ㅂ/ㅍ를 미리 익혀요.',
        data: {
          'emoji': '🔍',
          'highlights': ['ㅈ/ㅊ', 'ㄱ/ㅋ', 'ㄷ/ㅌ', 'ㅂ/ㅍ'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '대비 듣기',
        description: '두 소리 중 맞는 것을 고르세요',
        data: {
          'questions': [
            {
              'answer': '차',
              'choices': ['자', '차']
            },
            {
              'answer': '카',
              'choices': ['가', '카']
            },
            {
              'answer': '타',
              'choices': ['다', '타']
            },
            {
              'answer': '파',
              'choices': ['바', '파']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '레슨 완료!',
        data: {
          'lessonId': '5-9',
          'message': '좋아요!\n다음 단계 대비를 마쳤어요.',
        },
      ),
    ],
  ),
  LessonData(
    id: '5-M',
    title: '5단계 미션',
    subtitle: '기본 자음 2 종합 미션',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '미션 시작!',
        description: '기본 자음 2 ㅇ~ㅎ과 모음을 조합해요.\n제한 시간 안에 목표를 달성하세요!',
        data: {
          'timeLimit': 90,
          'targetCount': 6,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음절을 조합하세요!',
        data: {
          'timeLimitSeconds': 90,
          'targetCount': 6,
          'consonants': ['ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'],
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
        title: '5단계 완료!',
        data: {
          'lessonId': '5-M',
          'message': '축하해요!\n5단계 기본 자음 2(ㅇ~ㅎ)를 완료했어요.',
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: 'Stage 5 완료!',
        data: {
          'message': '모든 기본 자음을 마스터했어요!',
          'stageNumber': 5,
        },
      ),
    ],
  ),
];
