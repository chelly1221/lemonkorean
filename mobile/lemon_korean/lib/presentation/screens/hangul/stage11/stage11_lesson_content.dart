import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 11 lessons — 음운 변화 규칙.
List<LessonData> getStage11Lessons(AppLocalizations l10n) => <LessonData>[
  // ── Lesson 11-1: 음운 변화 소개 ──
  LessonData(
    id: '11-1',
    title: '음운 변화 소개',
    subtitle: '쓰인 대로 읽히지 않는 한국어',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '음운 변화란?',
        description:
            '한글은 쓰인 대로 읽히지 않는 경우가 많습니다. '
            '받침과 다음 글자가 만나면 소리가 변하는 규칙이 있습니다. '
            '음운 변화 규칙을 배우면 자연스러운 발음이 가능합니다.',
        data: {
          'highlights': ['음운 변화', '받침', '소리 변화', '자연스러운 발음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '음운 변화 예시 듣기',
        description: '다음 단어들의 실제 발음을 들어보세요. 글자와 소리가 다릅니다.',
        data: {
          'characters': ['학교', '국물', '좋다', '없어'],
          'type': 'word',
          'pronunciations': ['학꾜', '궁물', '조타', '업써'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '음운 변화 소개 완료',
        data: {
          'lessonId': '11-1',
          'message': '음운 변화의 기본 개념을 배웠습니다. 다음 레슨부터 각 규칙을 하나씩 배워봅시다!',
        },
      ),
    ],
  ),

  // ── Lesson 11-2: 연음법칙 (Liaison) ──
  LessonData(
    id: '11-2',
    title: '연음법칙',
    subtitle: '받침이 다음 음절로 넘어가는 규칙',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '연음법칙이란?',
        description:
            '받침 뒤에 모음이 오면 받침이 다음 음절의 초성으로 넘어갑니다. '
            '예: 음악 → [으막], 한국어 → [한구거], 없어 → [업써]',
        data: {
          'highlights': ['받침', '모음', '초성으로 이동', '연음'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '연음법칙 단어 듣기',
        description: '받침이 다음 음절로 넘어가는 소리를 들어보세요.',
        data: {
          'characters': ['음악', '한국어', '없어', '읽어', '닫아'],
          'type': 'word',
          'pronunciations': ['으막', '한구거', '업써', '일거', '다다'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '연음 발음 맞추기',
        description: '소리를 듣고 올바른 발음 표기를 선택하세요.',
        data: {
          'questions': [
            {
              'answer': '으막',
              'choices': ['으막', '음악', '음앜'],
            },
            {
              'answer': '한구거',
              'choices': ['한국어', '한구거', '한쿠거'],
            },
            {
              'answer': '업써',
              'choices': ['없어', '업써', '업서'],
            },
            {
              'answer': '일거',
              'choices': ['읽어', '일거', '익거'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '연음법칙 퀴즈',
        description: '연음법칙을 적용한 올바른 발음을 고르세요.',
        data: {
          'questions': [
            {
              'question': '"닫아"의 실제 발음은?',
              'answer': '[다다]',
              'choices': ['[닫아]', '[다다]', '[다타]'],
            },
            {
              'question': '연음법칙이 적용되는 조건은?',
              'answer': '받침 뒤에 모음이 올 때',
              'choices': ['받침 뒤에 모음이 올 때', '받침 뒤에 자음이 올 때', '모음 뒤에 모음이 올 때'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '연음법칙 완료',
        data: {
          'lessonId': '11-2',
          'message': '연음법칙을 배웠습니다! 받침 + 모음 → 받침이 초성으로 이동합니다.',
        },
      ),
    ],
  ),

  // ── Lesson 11-3: 비음화 (Nasalization) ──
  LessonData(
    id: '11-3',
    title: '비음화',
    subtitle: 'ㄱ/ㄷ/ㅂ이 비음으로 변하는 규칙',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '비음화란?',
        description:
            'ㄱ/ㄷ/ㅂ 받침 뒤에 ㄴ/ㅁ이 오면 비음으로 변합니다. '
            'ㄱ→ㅇ, ㄷ→ㄴ, ㅂ→ㅁ으로 바뀝니다. '
            '예: 국물 → [궁물], 받는 → [반는], 합니다 → [함니다]',
        data: {
          'highlights': ['비음화', 'ㄱ→ㅇ', 'ㄷ→ㄴ', 'ㅂ→ㅁ'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '비음화 단어 듣기',
        description: '받침이 비음으로 변하는 소리를 들어보세요.',
        data: {
          'characters': ['국물', '받는', '합니다', '작년', '십만'],
          'type': 'word',
          'pronunciations': ['궁물', '반는', '함니다', '장년', '심만'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '비음화 발음 맞추기',
        description: '소리를 듣고 올바른 발음 표기를 선택하세요.',
        data: {
          'questions': [
            {
              'answer': '궁물',
              'choices': ['국물', '궁물', '쿵물'],
            },
            {
              'answer': '반는',
              'choices': ['받는', '반는', '밧는'],
            },
            {
              'answer': '함니다',
              'choices': ['합니다', '함니다', '합미다'],
            },
            {
              'answer': '장년',
              'choices': ['작년', '장년', '작넌'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '비음화 퀴즈',
        description: '비음화 규칙을 적용한 올바른 발음을 고르세요.',
        data: {
          'questions': [
            {
              'question': '"십만"의 실제 발음은?',
              'answer': '[심만]',
              'choices': ['[십만]', '[심만]', '[싱만]'],
            },
            {
              'question': '비음화에서 ㅂ 받침은 무엇으로 변하나요?',
              'answer': 'ㅁ',
              'choices': ['ㄴ', 'ㅁ', 'ㅇ'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '비음화 완료',
        data: {
          'lessonId': '11-3',
          'message': '비음화를 배웠습니다! ㄱ→ㅇ, ㄷ→ㄴ, ㅂ→ㅁ (비음 앞에서)',
        },
      ),
    ],
  ),

  // ── Lesson 11-4: 경음화 (Fortition/Tensification) ──
  LessonData(
    id: '11-4',
    title: '경음화',
    subtitle: '된소리로 변하는 규칙',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '경음화란?',
        description:
            '받침 ㄱ/ㄷ/ㅂ 뒤에 ㄱ/ㄷ/ㅂ/ㅅ/ㅈ이 오면 된소리로 변합니다. '
            '예: 학교 → [학꾜], 국밥 → [국빱], 식당 → [식땅]',
        data: {
          'highlights': ['경음화', '된소리', 'ㄱ/ㄷ/ㅂ 뒤', 'ㄲ/ㄸ/ㅃ/ㅆ/ㅉ'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '경음화 단어 듣기',
        description: '다음 글자가 된소리로 변하는 소리를 들어보세요.',
        data: {
          'characters': ['학교', '국밥', '식당', '숙제', '꽃집'],
          'type': 'word',
          'pronunciations': ['학꾜', '국빱', '식땅', '숙쩨', '꼳찝'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '경음화 발음 맞추기',
        description: '소리를 듣고 올바른 발음 표기를 선택하세요.',
        data: {
          'questions': [
            {
              'answer': '학꾜',
              'choices': ['학교', '학꾜', '하교'],
            },
            {
              'answer': '국빱',
              'choices': ['국밥', '국빱', '궁밥'],
            },
            {
              'answer': '식땅',
              'choices': ['식당', '식땅', '싱당'],
            },
            {
              'answer': '숙쩨',
              'choices': ['숙제', '숙쩨', '숭제'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '경음화 퀴즈',
        description: '경음화 규칙을 적용한 올바른 발음을 고르세요.',
        data: {
          'questions': [
            {
              'question': '"꽃집"의 실제 발음은?',
              'answer': '[꼳찝]',
              'choices': ['[꽃집]', '[꼳찝]', '[꼬찝]'],
            },
            {
              'question': '경음화가 일어나는 조건은?',
              'answer': 'ㄱ/ㄷ/ㅂ 받침 뒤에 ㄱ/ㄷ/ㅂ/ㅅ/ㅈ이 올 때',
              'choices': [
                'ㄱ/ㄷ/ㅂ 받침 뒤에 ㄱ/ㄷ/ㅂ/ㅅ/ㅈ이 올 때',
                '모음 뒤에 자음이 올 때',
                'ㅎ 받침 뒤에 자음이 올 때',
              ],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '경음화 완료',
        data: {
          'lessonId': '11-4',
          'message': '경음화를 배웠습니다! ㄱ/ㄷ/ㅂ 뒤의 자음이 된소리로 변합니다.',
        },
      ),
    ],
  ),

  // ── Lesson 11-5: 격음화 (Aspiration) ──
  LessonData(
    id: '11-5',
    title: '격음화',
    subtitle: 'ㅎ과 만나 거센소리가 되는 규칙',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: '격음화란?',
        description:
            'ㅎ이 ㄱ/ㄷ/ㅂ/ㅈ과 만나면 거센소리(ㅋ/ㅌ/ㅍ/ㅊ)로 변합니다. '
            '예: 좋다 → [조타], 놓고 → [노코], 입학 → [이팍], 축하 → [추카]',
        data: {
          'highlights': ['격음화', 'ㅎ', '거센소리', 'ㅋ/ㅌ/ㅍ/ㅊ'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: '격음화 단어 듣기',
        description: 'ㅎ과 만나 거센소리로 변하는 소리를 들어보세요.',
        data: {
          'characters': ['좋다', '놓고', '입학', '축하', '급행'],
          'type': 'word',
          'pronunciations': ['조타', '노코', '이팍', '추카', '그팽'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '격음화 발음 맞추기',
        description: '소리를 듣고 올바른 발음 표기를 선택하세요.',
        data: {
          'questions': [
            {
              'answer': '조타',
              'choices': ['좋다', '조타', '좋따'],
            },
            {
              'answer': '노코',
              'choices': ['놓고', '노코', '녹고'],
            },
            {
              'answer': '이팍',
              'choices': ['입학', '이팍', '입악'],
            },
            {
              'answer': '추카',
              'choices': ['축하', '추카', '축카'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '격음화 퀴즈',
        description: '격음화 규칙을 적용한 올바른 발음을 고르세요.',
        data: {
          'questions': [
            {
              'question': '"급행"의 실제 발음은?',
              'answer': '[그팽]',
              'choices': ['[급행]', '[그팽]', '[급팽]'],
            },
            {
              'question': '격음화에서 ㅎ + ㄱ은 무엇이 되나요?',
              'answer': 'ㅋ',
              'choices': ['ㄲ', 'ㅋ', 'ㄱ'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '격음화 완료',
        data: {
          'lessonId': '11-5',
          'message': '격음화를 배웠습니다! ㅎ + ㄱ/ㄷ/ㅂ/ㅈ → ㅋ/ㅌ/ㅍ/ㅊ',
        },
      ),
    ],
  ),

  // ── Lesson 11-6: ㄹ의 비음화와 유음화 ──
  LessonData(
    id: '11-6',
    title: 'ㄹ의 비음화와 유음화',
    subtitle: 'ㄹ과 ㄴ이 만날 때의 변화',
    steps: [
      LessonStep(
        type: StepType.intro,
        title: 'ㄹ의 비음화와 유음화란?',
        description:
            'ㄹ이 ㄴ 앞이나 뒤에서 소리가 변합니다.\n'
            '유음화: ㄴ+ㄹ → [ㄹㄹ] (신라 → [실라], 연락 → [열락])\n'
            'ㄹ 비음화: ㄹ 앞에 ㄱ/ㅁ/ㅇ → ㄹ이 ㄴ으로 (심리 → [심니], 능력 → [능녁])',
        data: {
          'highlights': ['유음화', 'ㄴ+ㄹ→ㄹㄹ', 'ㄹ 비음화', 'ㄹ→ㄴ'],
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: 'ㄹ 변화 단어 듣기',
        description: 'ㄹ과 ㄴ이 만나 소리가 변하는 예시를 들어보세요.',
        data: {
          'characters': ['신라', '연락', '심리', '능력', '편리'],
          'type': 'word',
          'pronunciations': ['실라', '열락', '심니', '능녁', '펼리'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: 'ㄹ 변화 발음 맞추기',
        description: '소리를 듣고 올바른 발음 표기를 선택하세요.',
        data: {
          'questions': [
            {
              'answer': '실라',
              'choices': ['신라', '실라', '신나'],
            },
            {
              'answer': '열락',
              'choices': ['연락', '열락', '연낙'],
            },
            {
              'answer': '심니',
              'choices': ['심리', '심니', '심미'],
            },
            {
              'answer': '능녁',
              'choices': ['능력', '능녁', '능렉'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: 'ㄹ 변화 규칙 완료',
        data: {
          'lessonId': '11-6',
          'message': 'ㄹ의 비음화와 유음화를 배웠습니다! ㄴ+ㄹ→ㄹㄹ, 특정 받침+ㄹ→ㄴ',
        },
      ),
    ],
  ),

  // ── Lesson 11-7: 종합 연습 ──
  LessonData(
    id: '11-7',
    title: '종합 연습',
    subtitle: '모든 음운 변화 규칙 복습',
    steps: [
      LessonStep(
        type: StepType.soundExplore,
        title: '종합 단어 듣기',
        description: '다양한 음운 변화 규칙이 적용된 단어들을 들어보세요.',
        data: {
          'characters': ['독립', '협력', '설날', '일년', '잡는'],
          'type': 'word',
          'pronunciations': ['동닙', '혐녁', '설랄', '일련', '잠는'],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '종합 발음 맞추기 (1)',
        description: '소리를 듣고 올바른 발음 표기를 선택하세요.',
        data: {
          'questions': [
            {
              'answer': '동닙',
              'choices': ['독립', '동닙', '독닙'],
            },
            {
              'answer': '혐녁',
              'choices': ['협력', '혐녁', '협녁'],
            },
            {
              'answer': '설랄',
              'choices': ['설날', '설랄', '설날'],
            },
            {
              'answer': '일련',
              'choices': ['일년', '일련', '일넌'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: '종합 발음 맞추기 (2)',
        description: '어떤 음운 변화 규칙이 적용되었는지 생각하며 풀어보세요.',
        data: {
          'questions': [
            {
              'answer': '잠는',
              'choices': ['잡는', '잠는', '잡느'],
            },
            {
              'answer': '학꾜',
              'choices': ['학교', '학꾜', '학쿄'],
            },
            {
              'answer': '조타',
              'choices': ['좋다', '조타', '종다'],
            },
            {
              'answer': '으막',
              'choices': ['음악', '으막', '은막'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: '종합 퀴즈',
        description: '각 단어에 적용된 음운 변화 규칙을 맞추세요.',
        data: {
          'questions': [
            {
              'question': '"학교 → [학꾜]"에 적용된 규칙은?',
              'answer': '경음화',
              'choices': ['연음법칙', '비음화', '경음화'],
            },
            {
              'question': '"국물 → [궁물]"에 적용된 규칙은?',
              'answer': '비음화',
              'choices': ['비음화', '격음화', '연음법칙'],
            },
            {
              'question': '"좋다 → [조타]"에 적용된 규칙은?',
              'answer': '격음화',
              'choices': ['경음화', '격음화', '비음화'],
            },
            {
              'question': '"음악 → [으막]"에 적용된 규칙은?',
              'answer': '연음법칙',
              'choices': ['연음법칙', '경음화', '유음화'],
            },
            {
              'question': '"신라 → [실라]"에 적용된 규칙은?',
              'answer': '유음화',
              'choices': ['비음화', '연음법칙', '유음화'],
            },
            {
              'question': '"합니다 → [함니다]"에 적용된 규칙은?',
              'answer': '비음화',
              'choices': ['격음화', '비음화', '경음화'],
            },
            {
              'question': '"독립 → [동닙]"에 적용된 규칙은?',
              'answer': '비음화',
              'choices': ['비음화', '유음화', '연음법칙'],
            },
            {
              'question': '"입학 → [이팍]"에 적용된 규칙은?',
              'answer': '격음화',
              'choices': ['경음화', '연음법칙', '격음화'],
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: '종합 연습 완료',
        data: {
          'lessonId': '11-7',
          'message': '모든 음운 변화 규칙을 복습했습니다! 연음, 비음화, 경음화, 격음화, 유음화를 잘 구분할 수 있게 되었습니다.',
        },
      ),
    ],
  ),

  // ── Lesson 11-M: 미션 ──
  LessonData(
    id: '11-M',
    title: '음운 변화 미션',
    subtitle: '90초 안에 10문제 도전!',
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: '음운 변화 미션',
        description: '90초 안에 10개의 음운 변화 문제를 풀어보세요!',
        data: {'timeLimit': 90, 'targetCount': 10},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: '음운 변화 미션 도전!',
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
        title: '음운 변화 미션 완료',
        data: {'message': '음운 변화 미션을 완료했습니다!'},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: '11단계 완료!',
        data: {
          'message': '음운 변화 규칙을 모두 마스터했습니다! 이제 한국어 단어를 자연스럽게 발음할 수 있습니다.',
          'stageNumber': 11,
        },
      ),
    ],
  ),
];
