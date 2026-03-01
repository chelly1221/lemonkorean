import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 4 lessons — 기본 자음 1 (ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ).
List<LessonData> getStage4Lessons(AppLocalizations l10n) => <LessonData>[
  LessonData(
    id: '4-1',
    title: l10n.hangulS4L1Title,
    subtitle: l10n.hangulS4L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L1Step0Title,
        description: l10n.hangulS4L1Step0Desc,
        data: {
          'animation': {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
          'highlights': l10n.hangulS4L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L1Step1Title,
        description: l10n.hangulS4L1Step1Desc,
        data: {
          'characters': ['가', '고', '구'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L1Step2Title,
        description: l10n.hangulS4L1Step2Desc,
        data: {
          'characters': ['가', '고', '구'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L1Step3Title,
        description: l10n.hangulS4L1Step3Desc,
        data: {
          'questions': [
            {
              'answer': '가',
              'choices': ['가', '나']
            },
            {
              'answer': '고',
              'choices': ['고', '도']
            },
            {
              'answer': '구',
              'choices': ['구', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS4L1Step4Title,
        description: l10n.hangulS4L1Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㄱ', 'vowel': 'ㅏ', 'result': '가'},
            {'consonant': 'ㄱ', 'vowel': 'ㅗ', 'result': '고'},
            {'consonant': 'ㄱ', 'vowel': 'ㅜ', 'result': '구'},
          ],
          'consonantChoices': ['ㄱ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L1SummaryTitle,
        data: {
          'lessonId': '4-1',
          'message': l10n.hangulS4L1SummaryMsg,
        },
      ),
    ],
  ),
  LessonData(
    id: '4-2',
    title: l10n.hangulS4L2Title,
    subtitle: l10n.hangulS4L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L2Step0Title,
        description: l10n.hangulS4L2Step0Desc,
        data: {
          'animation': {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
          'highlights': l10n.hangulS4L2Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L2Step1Title,
        description: l10n.hangulS4L2Step1Desc,
        data: {
          'characters': ['나', '노', '누'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L2Step2Title,
        description: l10n.hangulS4L2Step2Desc,
        data: {
          'characters': ['나', '노', '누'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L2Step3Title,
        description: l10n.hangulS4L2Step3Desc,
        data: {
          'questions': [
            {
              'answer': '나',
              'choices': ['나', '다']
            },
            {
              'answer': '노',
              'choices': ['노', '도']
            },
            {
              'answer': '누',
              'choices': ['누', '두']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS4L2Step4Title,
        description: l10n.hangulS4L2Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㄴ', 'vowel': 'ㅏ', 'result': '나'},
            {'consonant': 'ㄴ', 'vowel': 'ㅗ', 'result': '노'},
            {'consonant': 'ㄴ', 'vowel': 'ㅜ', 'result': '누'},
          ],
          'consonantChoices': ['ㄴ', 'ㄷ', 'ㄹ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L2SummaryTitle,
        data: {
          'lessonId': '4-2',
          'message': l10n.hangulS4L2SummaryMsg,
        },
      ),
    ],
  ),
  LessonData(
    id: '4-3',
    title: l10n.hangulS4L3Title,
    subtitle: l10n.hangulS4L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L3Step0Title,
        description: l10n.hangulS4L3Step0Desc,
        data: {
          'animation': {'consonant': 'ㄷ', 'vowel': 'ㅏ', 'result': '다'},
          'highlights': l10n.hangulS4L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L3Step1Title,
        description: l10n.hangulS4L3Step1Desc,
        data: {
          'characters': ['다', '도', '두'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L3Step2Title,
        description: l10n.hangulS4L3Step2Desc,
        data: {
          'characters': ['다', '도', '두'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L3Step3Title,
        description: l10n.hangulS4L3Step3Desc,
        data: {
          'questions': [
            {
              'answer': '다',
              'choices': ['다', '나']
            },
            {
              'answer': '도',
              'choices': ['도', '노']
            },
            {
              'answer': '두',
              'choices': ['두', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS4L3Step4Title,
        description: l10n.hangulS4L3Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㄷ', 'vowel': 'ㅏ', 'result': '다'},
            {'consonant': 'ㄷ', 'vowel': 'ㅗ', 'result': '도'},
            {'consonant': 'ㄷ', 'vowel': 'ㅜ', 'result': '두'},
          ],
          'consonantChoices': ['ㄷ', 'ㄴ', 'ㅂ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L3SummaryTitle,
        data: {
          'lessonId': '4-3',
          'message': l10n.hangulS4L3SummaryMsg,
        },
      ),
    ],
  ),
  LessonData(
    id: '4-4',
    title: l10n.hangulS4L4Title,
    subtitle: l10n.hangulS4L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L4Step0Title,
        description: l10n.hangulS4L4Step0Desc,
        data: {
          'animation': {'consonant': 'ㄹ', 'vowel': 'ㅏ', 'result': '라'},
          'highlights': l10n.hangulS4L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L4Step1Title,
        description: l10n.hangulS4L4Step1Desc,
        data: {
          'characters': ['라', '로', '루'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L4Step2Title,
        description: l10n.hangulS4L4Step2Desc,
        data: {
          'characters': ['라', '로', '루'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L4Step3Title,
        description: l10n.hangulS4L4Step3Desc,
        data: {
          'questions': [
            {
              'answer': '라',
              'choices': ['라', '나']
            },
            {
              'answer': '로',
              'choices': ['로', '노']
            },
            {
              'answer': '루',
              'choices': ['루', '누']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS4L4Step4Title,
        description: l10n.hangulS4L4Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㄹ', 'vowel': 'ㅏ', 'result': '라'},
            {'consonant': 'ㄹ', 'vowel': 'ㅗ', 'result': '로'},
            {'consonant': 'ㄹ', 'vowel': 'ㅜ', 'result': '루'},
          ],
          'consonantChoices': ['ㄹ', 'ㄴ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L4SummaryTitle,
        data: {
          'lessonId': '4-4',
          'message': l10n.hangulS4L4SummaryMsg,
        },
      ),
    ],
  ),
  LessonData(
    id: '4-5',
    title: l10n.hangulS4L5Title,
    subtitle: l10n.hangulS4L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L5Step0Title,
        description: l10n.hangulS4L5Step0Desc,
        data: {
          'animation': {'consonant': 'ㅁ', 'vowel': 'ㅏ', 'result': '마'},
          'highlights': l10n.hangulS4L5Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L5Step1Title,
        description: l10n.hangulS4L5Step1Desc,
        data: {
          'characters': ['마', '모', '무'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L5Step2Title,
        description: l10n.hangulS4L5Step2Desc,
        data: {
          'characters': ['마', '모', '무'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L5Step3Title,
        description: l10n.hangulS4L5Step3Desc,
        data: {
          'questions': [
            {
              'answer': '마',
              'choices': ['마', '바']
            },
            {
              'answer': '모',
              'choices': ['모', '보']
            },
            {
              'answer': '무',
              'choices': ['무', '부']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS4L5Step4Title,
        description: l10n.hangulS4L5Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅁ', 'vowel': 'ㅏ', 'result': '마'},
            {'consonant': 'ㅁ', 'vowel': 'ㅗ', 'result': '모'},
            {'consonant': 'ㅁ', 'vowel': 'ㅜ', 'result': '무'},
          ],
          'consonantChoices': ['ㅁ', 'ㅂ', 'ㄴ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L5SummaryTitle,
        data: {
          'lessonId': '4-5',
          'message': l10n.hangulS4L5SummaryMsg,
        },
      ),
    ],
  ),
  LessonData(
    id: '4-6',
    title: l10n.hangulS4L6Title,
    subtitle: l10n.hangulS4L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L6Step0Title,
        description: l10n.hangulS4L6Step0Desc,
        data: {
          'animation': {'consonant': 'ㅂ', 'vowel': 'ㅏ', 'result': '바'},
          'highlights': l10n.hangulS4L6Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L6Step1Title,
        description: l10n.hangulS4L6Step1Desc,
        data: {
          'characters': ['바', '보', '부'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L6Step2Title,
        description: l10n.hangulS4L6Step2Desc,
        data: {
          'characters': ['바', '보', '부'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L6Step3Title,
        description: l10n.hangulS4L6Step3Desc,
        data: {
          'questions': [
            {
              'answer': '바',
              'choices': ['바', '마']
            },
            {
              'answer': '보',
              'choices': ['보', '모']
            },
            {
              'answer': '부',
              'choices': ['부', '무']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS4L6Step4Title,
        description: l10n.hangulS4L6Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅂ', 'vowel': 'ㅏ', 'result': '바'},
            {'consonant': 'ㅂ', 'vowel': 'ㅗ', 'result': '보'},
            {'consonant': 'ㅂ', 'vowel': 'ㅜ', 'result': '부'},
          ],
          'consonantChoices': ['ㅂ', 'ㅁ', 'ㄷ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L6SummaryTitle,
        data: {
          'lessonId': '4-6',
          'message': l10n.hangulS4L6SummaryMsg,
        },
      ),
    ],
  ),
  LessonData(
    id: '4-7',
    title: l10n.hangulS4L7Title,
    subtitle: l10n.hangulS4L7Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L7Step0Title,
        description: l10n.hangulS4L7Step0Desc,
        data: {
          'animation': {'consonant': 'ㅅ', 'vowel': 'ㅏ', 'result': '사'},
          'highlights': l10n.hangulS4L7Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L7Step1Title,
        description: l10n.hangulS4L7Step1Desc,
        data: {
          'characters': ['사', '소', '수'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L7Step2Title,
        description: l10n.hangulS4L7Step2Desc,
        data: {
          'characters': ['사', '소', '수'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L7Step3Title,
        description: l10n.hangulS4L7Step3Desc,
        data: {
          'questions': [
            {
              'answer': '사',
              'choices': ['사', '자']
            },
            {
              'answer': '소',
              'choices': ['소', '조']
            },
            {
              'answer': '수',
              'choices': ['수', '주']
            },
          ],
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS4L7Step4Title,
        description: l10n.hangulS4L7Step4Desc,
        data: {
          'targets': [
            {'consonant': 'ㅅ', 'vowel': 'ㅏ', 'result': '사'},
            {'consonant': 'ㅅ', 'vowel': 'ㅗ', 'result': '소'},
            {'consonant': 'ㅅ', 'vowel': 'ㅜ', 'result': '수'},
          ],
          'consonantChoices': ['ㅅ', 'ㅈ', 'ㄴ'],
          'vowelChoices': ['ㅏ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L7SummaryTitle,
        data: {
          'lessonId': '4-7',
          'message': l10n.hangulS4L7SummaryMsg,
        },
      ),
    ],
  ),

  // ── Lesson 4-8: 보너스 - 단어 읽기 도전! ──
  LessonData(
    id: '4-8',
    title: l10n.hangulS4L8Title,
    subtitle: l10n.hangulS4L8Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS4L8Step0Title,
        description: l10n.hangulS4L8Step0Desc,
        data: {
          'emoji': '🌟',
          'highlights': l10n.hangulS4L8Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS4L8Step1Title,
        data: {
          'characters': ['나무', '바다', '나비', '모자', '가구', '두부'],
          'descriptions': l10n.hangulS4L8Step1Descs.split(','),
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS4L8Step2Title,
        description: l10n.hangulS4L8Step2Desc,
        data: {
          'characters': ['나무', '바다', '나비'],
          'maxAttempts': 3,
          'passScore': 65,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS4L8Step3Title,
        data: {
          'questions': [
            {'audio': '나무', 'choices': ['나무', '나비', '바다'], 'answer': '나무'},
            {'audio': '바다', 'choices': ['모자', '바다', '가구'], 'answer': '바다'},
            {'audio': '두부', 'choices': ['나비', '가구', '두부'], 'answer': '두부'},
            {'audio': '모자', 'choices': ['모자', '나무', '두부'], 'answer': '모자'},
          ],
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS4L8Step4Title,
        data: {
          'questions': [
            {'question': l10n.hangulS4L8Step4Q0, 'answer': 'butterfly', 'choices': ['tree', 'butterfly', 'sea']},
            {'question': l10n.hangulS4L8Step4Q1, 'answer': 'sea', 'choices': ['hat', 'sea', 'tofu']},
          ],
        },
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4L8SummaryTitle,
        data: {
          'message': l10n.hangulS4L8SummaryMsg,
        },
      ),
    ],
  ),
  LessonData(
    id: '4-M',
    title: l10n.hangulS4LMTitle,
    subtitle: l10n.hangulS4LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS4LMStep0Title,
        description: l10n.hangulS4LMStep0Desc,
        data: {'timeLimit': 120, 'targetCount': 8},
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS4LMStep1Title,
        data: {
          'timeLimitSeconds': 120,
          'targetCount': 8,
          'consonants': ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ', 'ㅁ', 'ㅂ', 'ㅅ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS4LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS4LMSummaryTitle,
        data: {'message': l10n.hangulS4LMSummaryMsg},
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS4CompleteTitle,
        data: {
          'message': l10n.hangulS4CompleteMsg,
          'stageNumber': 4,
        },
      ),
    ],
  ),
];
