import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 1 lessons — Basic Vowels.
List<LessonData> getStage1Lessons(AppLocalizations l10n) => <LessonData>[
  // ── Lesson 1-1: ㅏ ──
  LessonData(
    id: '1-1',
    title: l10n.hangulS1L1Title,
    subtitle: l10n.hangulS1L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L1Step0Title,
        description: l10n.hangulS1L1Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅏ',
            'result': '아',
          },
          'highlights': l10n.hangulS1L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L1Step1Title,
        description: l10n.hangulS1L1Step1Desc,
        data: {
          'characters': ['아', '가', '나'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L1Step2Title,
        description: l10n.hangulS1L1Step2Desc,
        data: {
          'characters': ['아', '가', '나'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L1Step3Title,
        description: l10n.hangulS1L1Step3Desc,
        data: {
          'questions': [
            {'answer': '아', 'choices': ['아', '어']},
            {'answer': '가', 'choices': ['가', '거']},
            {'answer': '나', 'choices': ['나', '너']},
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L1Step4Title,
        description: l10n.hangulS1L1Step4Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L1Step4Q0, 'answer': 'ㅏ', 'choices': ['ㅏ', 'ㅓ']},
            {'question': l10n.hangulS1L1Step4Q1, 'answer': '가', 'choices': ['가', '고', '거']},
            {'question': l10n.hangulS1L1Step4Q2, 'answer': '아', 'choices': ['아', '어', '오']},
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS1L1Step5Title,
        description: l10n.hangulS1L1Step5Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅏ', 'result': '아'},
            {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
            {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅏ', 'ㅓ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L1Step6Title,
        description: l10n.hangulS1L1Step6Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L1Step6Q0, 'answer': 'ㅏ', 'choices': ['ㅏ', 'ㅓ', 'ㅗ']},
            {'question': l10n.hangulS1L1Step6Q1, 'answer': '아', 'choices': ['아', '어', '오']},
            {'question': l10n.hangulS1L1Step6Q2, 'answer': '나', 'choices': ['너', '나', '노']},
            {'question': l10n.hangulS1L1Step6Q3, 'answer': 'ㅓ', 'choices': ['ㅏ', 'ㅓ']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L1Step7Title,
        data: {
          'lessonId': '1-1',
          'message': l10n.hangulS1L1Step7Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-2: ㅓ ──
  LessonData(
    id: '1-2',
    title: l10n.hangulS1L2Title,
    subtitle: l10n.hangulS1L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L2Step0Title,
        description: l10n.hangulS1L2Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅓ',
            'result': '어',
          },
          'highlights': l10n.hangulS1L2Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L2Step1Title,
        description: l10n.hangulS1L2Step1Desc,
        data: {
          'characters': ['어', '거', '너'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L2Step2Title,
        description: l10n.hangulS1L2Step2Desc,
        data: {
          'characters': ['어', '거', '너'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L2Step3Title,
        description: l10n.hangulS1L2Step3Desc,
        data: {
          'questions': [
            {'answer': '어', 'choices': ['어', '아']},
            {'answer': '거', 'choices': ['가', '거']},
            {'answer': '너', 'choices': ['나', '너']},
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L2Step4Title,
        description: l10n.hangulS1L2Step4Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L2Step4Q0, 'answer': 'ㅓ', 'choices': ['ㅏ', 'ㅓ']},
            {'question': l10n.hangulS1L2Step4Q1, 'answer': '어', 'choices': ['아', '어', '오']},
            {'question': l10n.hangulS1L2Step4Q2, 'answer': '너', 'choices': ['나', '너', '노']},
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS1L2Step5Title,
        description: l10n.hangulS1L2Step5Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅓ', 'result': '어'},
            {'consonant': 'ㄱ', 'vowel': 'ㅓ', 'result': '거'},
            {'consonant': 'ㄴ', 'vowel': 'ㅓ', 'result': '너'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅓ', 'ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L2Step6Title,
        data: {
          'lessonId': '1-2',
          'message': l10n.hangulS1L2Step6Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-3: ㅗ ──
  LessonData(
    id: '1-3',
    title: l10n.hangulS1L3Title,
    subtitle: l10n.hangulS1L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L3Step0Title,
        description: l10n.hangulS1L3Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅗ',
            'result': '오',
          },
          'highlights': l10n.hangulS1L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L3Step1Title,
        description: l10n.hangulS1L3Step1Desc,
        data: {
          'characters': ['오', '고', '노'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L3Step2Title,
        description: l10n.hangulS1L3Step2Desc,
        data: {
          'characters': ['오', '고', '노'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L3Step3Title,
        description: l10n.hangulS1L3Step3Desc,
        data: {
          'questions': [
            {'answer': '오', 'choices': ['오', '우']},
            {'answer': '고', 'choices': ['고', '구']},
            {'answer': '노', 'choices': ['노', '누']},
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS1L3Step4Title,
        description: l10n.hangulS1L3Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅗ', 'result': '오'},
            {'consonant': 'ㄱ', 'vowel': 'ㅗ', 'result': '고'},
            {'consonant': 'ㄴ', 'vowel': 'ㅗ', 'result': '노'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅗ', 'ㅜ', 'ㅡ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L3Step5Title,
        description: l10n.hangulS1L3Step5Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L3Step5Q0, 'answer': 'ㅗ', 'choices': ['ㅗ', 'ㅜ', 'ㅡ']},
            {'question': l10n.hangulS1L3Step5Q1, 'answer': '오', 'choices': ['오', '우', '어']},
            {'question': l10n.hangulS1L3Step5Q2, 'answer': '고', 'choices': ['고', '거', '구']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L3Step6Title,
        data: {
          'lessonId': '1-3',
          'message': l10n.hangulS1L3Step6Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-4: ㅜ ──
  LessonData(
    id: '1-4',
    title: l10n.hangulS1L4Title,
    subtitle: l10n.hangulS1L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L4Step0Title,
        description: l10n.hangulS1L4Step0Desc,
        data: {
          'animation': {
            'consonant': 'ㅇ',
            'vowel': 'ㅜ',
            'result': '우',
          },
          'highlights': l10n.hangulS1L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L4Step1Title,
        description: l10n.hangulS1L4Step1Desc,
        data: {
          'characters': ['우', '구', '누'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L4Step2Title,
        description: l10n.hangulS1L4Step2Desc,
        data: {
          'characters': ['우', '구', '누'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L4Step3Title,
        description: l10n.hangulS1L4Step3Desc,
        data: {
          'questions': [
            {'answer': '우', 'choices': ['우', '오']},
            {'answer': '구', 'choices': ['고', '구']},
            {'answer': '누', 'choices': ['노', '누']},
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS1L4Step4Title,
        description: l10n.hangulS1L4Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅜ', 'result': '우'},
            {'consonant': 'ㄱ', 'vowel': 'ㅜ', 'result': '구'},
            {'consonant': 'ㄴ', 'vowel': 'ㅜ', 'result': '누'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅜ', 'ㅗ', 'ㅡ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L4Step5Title,
        description: l10n.hangulS1L4Step5Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L4Step5Q0, 'answer': 'ㅜ', 'choices': ['ㅗ', 'ㅜ', 'ㅡ']},
            {'question': l10n.hangulS1L4Step5Q1, 'answer': '우', 'choices': ['오', '우', '어']},
            {'question': l10n.hangulS1L4Step5Q2, 'answer': '누', 'choices': ['누', '노', '너']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L4Step6Title,
        data: {
          'lessonId': '1-4',
          'message': l10n.hangulS1L4Step6Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-5: ㅡ ──
  LessonData(
    id: '1-5',
    title: l10n.hangulS1L5Title,
    subtitle: l10n.hangulS1L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L5Step0Title,
        description: l10n.hangulS1L5Step0Desc,
        data: {
          'emoji': '📏',
          'highlights': l10n.hangulS1L5Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L5Step1Title,
        description: l10n.hangulS1L5Step1Desc,
        data: {
          'characters': ['으', '그', '느'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L5Step2Title,
        description: l10n.hangulS1L5Step2Desc,
        data: {
          'characters': ['으', '그', '느'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L5Step3Title,
        description: l10n.hangulS1L5Step3Desc,
        data: {
          'questions': [
            {'answer': '으', 'choices': ['으', '우']},
            {'answer': '그', 'choices': ['구', '그']},
            {'answer': '느', 'choices': ['느', '누']},
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS1L5Step4Title,
        description: l10n.hangulS1L5Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅡ', 'result': '으'},
            {'consonant': 'ㄱ', 'vowel': 'ㅡ', 'result': '그'},
            {'consonant': 'ㄴ', 'vowel': 'ㅡ', 'result': '느'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅡ', 'ㅜ', 'ㅣ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L5Step5Title,
        description: l10n.hangulS1L5Step5Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L5Step5Q0, 'answer': 'ㅡ', 'choices': ['ㅜ', 'ㅡ', 'ㅣ']},
            {'question': l10n.hangulS1L5Step5Q1, 'answer': '으', 'choices': ['우', '으', '이']},
            {'question': l10n.hangulS1L5Step5Q2, 'answer': '그', 'choices': ['구', '그', '거']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L5Step6Title,
        data: {
          'lessonId': '1-5',
          'message': l10n.hangulS1L5Step6Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-6: ㅣ ──
  LessonData(
    id: '1-6',
    title: l10n.hangulS1L6Title,
    subtitle: l10n.hangulS1L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L6Step0Title,
        description: l10n.hangulS1L6Step0Desc,
        data: {
          'emoji': '📐',
          'highlights': l10n.hangulS1L6Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L6Step1Title,
        description: l10n.hangulS1L6Step1Desc,
        data: {
          'characters': ['이', '기', '니'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L6Step2Title,
        description: l10n.hangulS1L6Step2Desc,
        data: {
          'characters': ['이', '기', '니'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L6Step3Title,
        description: l10n.hangulS1L6Step3Desc,
        data: {
          'questions': [
            {'answer': '이', 'choices': ['으', '이']},
            {'answer': '기', 'choices': ['그', '기']},
            {'answer': '니', 'choices': ['니', '느']},
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS1L6Step4Title,
        description: l10n.hangulS1L6Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅇ', 'vowel': 'ㅣ', 'result': '이'},
            {'consonant': 'ㄱ', 'vowel': 'ㅣ', 'result': '기'},
            {'consonant': 'ㄴ', 'vowel': 'ㅣ', 'result': '니'},
          ],
          'consonantChoices': ['ㅇ', 'ㄱ', 'ㄴ'],
          'vowelChoices': ['ㅣ', 'ㅡ', 'ㅏ'],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L6Step5Title,
        description: l10n.hangulS1L6Step5Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L6Step5Q0, 'answer': 'ㅣ', 'choices': ['ㅡ', 'ㅣ', 'ㅏ']},
            {'question': l10n.hangulS1L6Step5Q1, 'answer': '이', 'choices': ['이', '아', '으']},
            {'question': l10n.hangulS1L6Step5Q2, 'answer': '기', 'choices': ['구', '기', '거']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L6Step6Title,
        data: {
          'lessonId': '1-6',
          'message': l10n.hangulS1L6Step6Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-7: 세로 모음 구분 (ㅏ/ㅓ/ㅣ) ──
  LessonData(
    id: '1-7',
    title: l10n.hangulS1L7Title,
    subtitle: l10n.hangulS1L7Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L7Step0Title,
        description: l10n.hangulS1L7Step0Desc,
        data: {
          'emoji': '🧭',
          'highlights': l10n.hangulS1L7Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L7Step1Title,
        description: l10n.hangulS1L7Step1Desc,
        data: {
          'characters': ['아', '어', '이'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L7Step2Title,
        description: l10n.hangulS1L7Step2Desc,
        data: {
          'characters': ['아', '어', '이'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L7Step3Title,
        description: l10n.hangulS1L7Step3Desc,
        data: {
          'questions': [
            {'answer': '아', 'choices': ['아', '어']},
            {'answer': '어', 'choices': ['어', '이']},
            {'answer': '이', 'choices': ['아', '이']},
            {'answer': '기', 'choices': ['거', '기']},
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L7Step4Title,
        description: l10n.hangulS1L7Step4Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L7Step4Q0, 'answer': 'ㅏ', 'choices': ['ㅏ', 'ㅓ', 'ㅣ']},
            {'question': l10n.hangulS1L7Step4Q1, 'answer': 'ㅓ', 'choices': ['ㅏ', 'ㅓ', 'ㅣ']},
            {'question': l10n.hangulS1L7Step4Q2, 'answer': 'ㅣ', 'choices': ['ㅓ', 'ㅡ', 'ㅣ']},
            {'question': l10n.hangulS1L7Step4Q3, 'answer': '너', 'choices': ['나', '너', '니']},
            {'question': l10n.hangulS1L7Step4Q4, 'answer': '기', 'choices': ['거', '기', '그']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L7Step5Title,
        data: {
          'lessonId': '1-7',
          'message': l10n.hangulS1L7Step5Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-8: 가로 모음 구분 (ㅗ/ㅜ/ㅡ) ──
  LessonData(
    id: '1-8',
    title: l10n.hangulS1L8Title,
    subtitle: l10n.hangulS1L8Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L8Step0Title,
        description: l10n.hangulS1L8Step0Desc,
        data: {
          'emoji': '🧩',
          'highlights': l10n.hangulS1L8Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L8Step1Title,
        description: l10n.hangulS1L8Step1Desc,
        data: {
          'characters': ['오', '우', '으'],
          'type': 'syllable',
          'showMouth': false,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L8Step2Title,
        description: l10n.hangulS1L8Step2Desc,
        data: {
          'characters': ['오', '우', '으'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L8Step3Title,
        description: l10n.hangulS1L8Step3Desc,
        data: {
          'questions': [
            {'answer': '오', 'choices': ['오', '우']},
            {'answer': '우', 'choices': ['우', '으']},
            {'answer': '으', 'choices': ['오', '으']},
            {'answer': '구', 'choices': ['구', '그']},
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS1L8Step4Title,
        description: l10n.hangulS1L8Step4Desc,
        data: {
          'questions': [
            {'question': l10n.hangulS1L8Step4Q0, 'answer': 'ㅗ', 'choices': ['ㅗ', 'ㅜ', 'ㅡ']},
            {'question': l10n.hangulS1L8Step4Q1, 'answer': 'ㅜ', 'choices': ['ㅗ', 'ㅜ', 'ㅡ']},
            {'question': l10n.hangulS1L8Step4Q2, 'answer': 'ㅡ', 'choices': ['ㅜ', 'ㅣ', 'ㅡ']},
            {'question': l10n.hangulS1L8Step4Q3, 'answer': '고', 'choices': ['고', '구', '그']},
            {'question': l10n.hangulS1L8Step4Q4, 'answer': '누', 'choices': ['노', '느', '누']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L8Step5Title,
        data: {
          'lessonId': '1-8',
          'message': l10n.hangulS1L8Step5Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-9: Stage 1 Mission ──
  LessonData(
    id: '1-9',
    title: l10n.hangulS1L9Title,
    subtitle: l10n.hangulS1L9Subtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS1L9Step0Title,
        description: l10n.hangulS1L9Step0Desc,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS1L9Step1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowels': ['ㅏ', 'ㅗ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS1L9Step2Title,
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L9Step3Title,
        data: {
          'lessonId': '1-9',
          'message': l10n.hangulS1L9Step3Msg,
        },
      ),
    ],
  ),

  // ── Lesson 1-10: 보너스 - 첫 한국어 단어! ──
  LessonData(
    id: '1-10',
    title: l10n.hangulS1L10Title,
    subtitle: l10n.hangulS1L10Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS1L10Step0Title,
        description: l10n.hangulS1L10Step0Desc,
        data: {
          'emoji': '🎊',
          'highlights': l10n.hangulS1L10Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS1L10Step1Title,
        data: {
          'characters': ['아이', '우유', '오이', '이', '아우'],
          'descriptions': l10n.hangulS1L10Step1Descs.split(','),
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS1L10Step2Title,
        description: l10n.hangulS1L10Step2Desc,
        data: {
          'characters': ['아이', '우유', '오이'],
          'maxAttempts': 3,
          'passScore': 60,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS1L10Step3Title,
        data: {
          'questions': [
            {'audio': '아이', 'choices': ['아이', '오이', '우유'], 'answer': '아이'},
            {'audio': '우유', 'choices': ['이유', '우유', '아우'], 'answer': '우유'},
            {'audio': '오이', 'choices': ['오이', '아이', '우이'], 'answer': '오이'},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS1L10Step4Title,
        data: {
          'message': l10n.hangulS1L10Step4Msg,
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS1CompleteTitle,
        data: {
          'message': l10n.hangulS1CompleteMsg,
          'stageNumber': 1,
        },
      ),
    ],
  ),
];
