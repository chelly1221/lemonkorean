import '../../../../l10n/generated/app_localizations.dart';
import '../stage0/stage0_lesson_content.dart';

/// All Stage 5 lessons — 기본 자음 2 (ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ).
List<LessonData> getStage5Lessons(AppLocalizations l10n) => <LessonData>[
  LessonData(
    id: '5-1',
    title: l10n.hangulS5L1Title,
    subtitle: l10n.hangulS5L1Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L1Step0Title,
        description: l10n.hangulS5L1Step0Desc,
        data: {
          'animation': {'consonant': 'ㅇ', 'vowel': 'ㅏ', 'result': '아'},
          'highlights': l10n.hangulS5L1Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS5L1Step1Title,
        description: l10n.hangulS5L1Step1Desc,
        data: {
          'characters': ['아', '오', '우'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS5L1Step2Title,
        description: l10n.hangulS5L1Step2Desc,
        data: {
          'characters': ['아', '오', '우'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.syllableBuild,
        title: l10n.hangulS5L1Step3Title,
        description: l10n.hangulS5L1Step3Desc,
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
        title: l10n.hangulS5L1Step4Title,
        data: {
          'lessonId': '5-1',
          'message': l10n.hangulS5L1Step4Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-2',
    title: l10n.hangulS5L2Title,
    subtitle: l10n.hangulS5L2Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L2Step0Title,
        description: l10n.hangulS5L2Step0Desc,
        data: {
          'animation': {'consonant': 'ㅈ', 'vowel': 'ㅏ', 'result': '자'},
          'highlights': l10n.hangulS5L2Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS5L2Step1Title,
        description: l10n.hangulS5L2Step1Desc,
        data: {
          'characters': ['자', '조', '주'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS5L2Step2Title,
        description: l10n.hangulS5L2Step2Desc,
        data: {
          'characters': ['자', '조', '주'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS5L2Step3Title,
        description: l10n.hangulS5L2Step3Desc,
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
        title: l10n.hangulS5L2Step4Title,
        description: l10n.hangulS5L2Step4Desc,
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
        title: l10n.hangulS5L2Step5Title,
        data: {
          'lessonId': '5-2',
          'message': l10n.hangulS5L2Step5Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-3',
    title: l10n.hangulS5L3Title,
    subtitle: l10n.hangulS5L3Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L3Step0Title,
        description: l10n.hangulS5L3Step0Desc,
        data: {
          'animation': {'consonant': 'ㅊ', 'vowel': 'ㅏ', 'result': '차'},
          'highlights': l10n.hangulS5L3Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS5L3Step1Title,
        description: l10n.hangulS5L3Step1Desc,
        data: {
          'characters': ['차', '초', '추'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS5L3Step2Title,
        description: l10n.hangulS5L3Step2Desc,
        data: {
          'characters': ['차', '초', '추'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS5L3Step3Title,
        description: l10n.hangulS5L3Step3Desc,
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
        title: l10n.hangulS5L3Step4Title,
        data: {
          'lessonId': '5-3',
          'message': l10n.hangulS5L3Step4Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-4',
    title: l10n.hangulS5L4Title,
    subtitle: l10n.hangulS5L4Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L4Step0Title,
        description: l10n.hangulS5L4Step0Desc,
        data: {
          'animation': {'consonant': 'ㅋ', 'vowel': 'ㅏ', 'result': '카'},
          'highlights': l10n.hangulS5L4Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS5L4Step1Title,
        description: l10n.hangulS5L4Step1Desc,
        data: {
          'characters': ['카', '코', '쿠'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS5L4Step2Title,
        description: l10n.hangulS5L4Step2Desc,
        data: {
          'characters': ['카', '코', '쿠'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS5L4Step3Title,
        description: l10n.hangulS5L4Step3Desc,
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
        title: l10n.hangulS5L4Step4Title,
        data: {
          'lessonId': '5-4',
          'message': l10n.hangulS5L4Step4Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-5',
    title: l10n.hangulS5L5Title,
    subtitle: l10n.hangulS5L5Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L5Step0Title,
        description: l10n.hangulS5L5Step0Desc,
        data: {
          'animation': {'consonant': 'ㅌ', 'vowel': 'ㅏ', 'result': '타'},
          'highlights': l10n.hangulS5L5Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS5L5Step1Title,
        description: l10n.hangulS5L5Step1Desc,
        data: {
          'characters': ['타', '토', '투'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS5L5Step2Title,
        description: l10n.hangulS5L5Step2Desc,
        data: {
          'characters': ['타', '토', '투'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS5L5Step3Title,
        description: l10n.hangulS5L5Step3Desc,
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
        title: l10n.hangulS5L5Step4Title,
        data: {
          'lessonId': '5-5',
          'message': l10n.hangulS5L5Step4Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-6',
    title: l10n.hangulS5L6Title,
    subtitle: l10n.hangulS5L6Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L6Step0Title,
        description: l10n.hangulS5L6Step0Desc,
        data: {
          'animation': {'consonant': 'ㅍ', 'vowel': 'ㅏ', 'result': '파'},
          'highlights': l10n.hangulS5L6Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS5L6Step1Title,
        description: l10n.hangulS5L6Step1Desc,
        data: {
          'characters': ['파', '포', '푸'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS5L6Step2Title,
        description: l10n.hangulS5L6Step2Desc,
        data: {
          'characters': ['파', '포', '푸'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS5L6Step3Title,
        description: l10n.hangulS5L6Step3Desc,
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
        title: l10n.hangulS5L6Step4Title,
        data: {
          'lessonId': '5-6',
          'message': l10n.hangulS5L6Step4Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-7',
    title: l10n.hangulS5L7Title,
    subtitle: l10n.hangulS5L7Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L7Step0Title,
        description: l10n.hangulS5L7Step0Desc,
        data: {
          'animation': {'consonant': 'ㅎ', 'vowel': 'ㅏ', 'result': '하'},
          'highlights': l10n.hangulS5L7Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundExplore,
        title: l10n.hangulS5L7Step1Title,
        description: l10n.hangulS5L7Step1Desc,
        data: {
          'characters': ['하', '호', '후'],
          'type': 'syllable',
          'showMouth': true,
        },
      ),
      LessonStep(
        type: StepType.speechPractice,
        title: l10n.hangulS5L7Step2Title,
        description: l10n.hangulS5L7Step2Desc,
        data: {
          'characters': ['하', '호', '후'],
          'maxAttempts': 4,
          'passScore': 55,
          'showPhonemeDetail': true,
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS5L7Step3Title,
        description: l10n.hangulS5L7Step3Desc,
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
        title: l10n.hangulS5L7Step4Title,
        data: {
          'lessonId': '5-7',
          'message': l10n.hangulS5L7Step4Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-8',
    title: l10n.hangulS5L8Title,
    subtitle: l10n.hangulS5L8Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L8Step0Title,
        description: l10n.hangulS5L8Step0Desc,
        data: {
          'emoji': '🎯',
          'highlights': l10n.hangulS5L8Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.quizMcq,
        title: l10n.hangulS5L8Step1Title,
        description: l10n.hangulS5L8Step1Desc,
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
        title: l10n.hangulS5L8Step2Title,
        data: {
          'lessonId': '5-8',
          'message': l10n.hangulS5L8Step2Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-9',
    title: l10n.hangulS5L9Title,
    subtitle: l10n.hangulS5L9Subtitle,
    steps: [
      LessonStep(
        type: StepType.intro,
        title: l10n.hangulS5L9Step0Title,
        description: l10n.hangulS5L9Step0Desc,
        data: {
          'emoji': '🔍',
          'highlights': l10n.hangulS5L9Step0Highlights.split(','),
        },
      ),
      LessonStep(
        type: StepType.soundMatch,
        title: l10n.hangulS5L9Step1Title,
        description: l10n.hangulS5L9Step1Desc,
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
        title: l10n.hangulS5L9Step2Title,
        data: {
          'lessonId': '5-9',
          'message': l10n.hangulS5L9Step2Msg,
        },
      ),
    ],
  ),
  LessonData(
    id: '5-M',
    title: l10n.hangulS5LMTitle,
    subtitle: l10n.hangulS5LMSubtitle,
    isMission: true,
    steps: [
      LessonStep(
        type: StepType.missionIntro,
        title: l10n.hangulS5LMStep0Title,
        description: l10n.hangulS5LMStep0Desc,
        data: {
          'timeLimit': 90,
          'targetCount': 6,
        },
      ),
      LessonStep(
        type: StepType.timedMission,
        title: l10n.hangulS5LMStep1Title,
        data: {
          'timeLimitSeconds': 90,
          'targetCount': 6,
          'consonants': ['ㅇ', 'ㅈ', 'ㅊ', 'ㅋ', 'ㅌ', 'ㅍ', 'ㅎ'],
          'vowels': ['ㅏ', 'ㅓ', 'ㅗ', 'ㅜ'],
        },
      ),
      LessonStep(
        type: StepType.missionResults,
        title: l10n.hangulS5LMStep2Title,
        data: {},
      ),
      LessonStep(
        type: StepType.summary,
        title: l10n.hangulS5LMStep3Title,
        data: {
          'lessonId': '5-M',
          'message': l10n.hangulS5LMStep3Msg,
        },
      ),
      LessonStep(
        type: StepType.stageComplete,
        title: l10n.hangulS5LMStep4Title,
        data: {
          'message': l10n.hangulS5LMStep4Msg,
          'stageNumber': 5,
        },
      ),
    ],
  ),
];
