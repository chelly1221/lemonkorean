import 'package:flutter/material.dart';

class HangulStage0TutorialScreen extends StatelessWidget {
  const HangulStage0TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('0단계: 한글 구조 이해'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '자음 + 모음 = 음절 블록 구조를 눈으로 이해',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['학습 60%', '쓰기(선택) 20%', '퀴즈 20%']),
          SizedBox(height: 8),
          _StageSectionHeader(
            title: '운영 팁',
            subtitle: '쓰기 기능은 연필 아이콘(선택)으로만 제공',
          ),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '0-1',
            title: '가 블록 조립하기',
            points: [
              '자음/모음을 분리해서 보여주기',
              '합치면 "가"가 되는 애니메이션',
            ],
            activityTitle: '액티비티',
            activityDetail: '조각 맞추기: ㄱ + ㅏ → 가 (3문항)',
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '0-2',
            title: '소리 탐색',
            points: [
              '자음(ㄱ, ㄴ, ㄷ)의 소리 듣기',
              '모음(ㅏ, ㅗ)의 소리 듣기',
              '음절(가, 나, 다) 소리 탐색',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '0-3',
            title: '내 첫 글자 만들기',
            points: [
              '자음: ㄱ/ㄴ/ㄷ',
              '모음: ㅏ/ㅗ',
              '직접 조합: 가, 나, 다, 고, 노',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '0-M',
            title: '블록 미션',
            mission: '3분 안에 글자 블록 5개 완성하기',
          ),
        ],
      ),
    );
  }
}

class HangulStage1VowelsScreen extends StatelessWidget {
  const HangulStage1VowelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('1단계: 기본 모음'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '모음 6개를 확실히 익히고, 모양 + 소리를 연결',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['학습 60%', '쓰기(선택) 20%', '퀴즈 20%']),
          SizedBox(height: 8),
          _StageSectionHeader(
            title: '운영 팁',
            subtitle: '쓰기 강제 X, 연필 아이콘 선택 진입',
          ),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '1-1',
            title: '아 소리 찾기 (ㅏ)',
            points: [
              '"ㅏ" 크게 보여주기 + 소리 재생',
              '소리 듣고 맞추기(2지선다)',
              '모양 찾기(ㅏ vs ㅓ)',
              '따라쓰기(선택 기능)',
              '조합 맛보기: ㅇ + ㅏ = 아',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '1-2',
            title: '어 소리 찾기 (ㅓ)',
            points: [
              '"ㅓ" 단일 모음 집중 학습',
              '소리/모양 구분 연습(2지선다)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '1-3',
            title: '오 소리 찾기 (ㅗ)',
            points: [
              '"ㅗ" 단일 모음 집중 학습',
              '소리/모양 구분 연습(2지선다)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '1-4',
            title: '우 소리 찾기 (ㅜ)',
            points: [
              '"ㅜ" 단일 모음 집중 학습',
              '소리/모양 구분 연습(2지선다)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '1-5',
            title: '으 소리 찾기 (ㅡ)',
            points: [
              '"ㅡ" 단일 모음 집중 학습',
              '소리/모양 구분 연습(2지선다)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '1-6',
            title: '이 소리 찾기 (ㅣ)',
            points: [
              '"ㅣ" 단일 모음 집중 학습',
              '소리/모양 구분 연습(2지선다)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '1-7',
            title: '모음 랜덤 챌린지',
            points: [
              '대상: ㅏ ㅓ ㅗ ㅜ ㅡ ㅣ',
              '랜덤 퀴즈 진행',
              '필요 시 4지선다로 난이도 상승',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '1-8',
            title: '헷갈림 해결전 (선택)',
            points: [
              'ㅏ vs ㅓ',
              'ㅗ vs ㅜ',
              'ㅡ vs ㅣ',
              '헷갈림 대비 집중으로 이탈률 완화',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '1-M',
            title: '모음 미션',
            mission: '랜덤 모음 6개를 연속으로 맞추기',
          ),
        ],
      ),
    );
  }
}

class HangulStage2YVowelsScreen extends StatelessWidget {
  const HangulStage2YVowelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('2단계: Y-모음'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '기본 모음에 획 하나 추가 = Y-소리 패턴 인식',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['학습 60%', '쓰기(선택) 20%', '퀴즈 20%']),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '2-1',
            title: 'ㅏ → ㅑ 변신!',
            points: [
              'ㅏ에 획 추가 시각 비교',
              'ㅑ 소리 듣기',
              '2지선다(ㅏ vs ㅑ)',
              '조합: ㅇ + ㅑ = 야',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '2-2',
            title: 'ㅓ → ㅕ 변신!',
            points: [
              'ㅓ에 획 추가 시각 비교',
              'ㅕ 소리 듣기',
              '2지선다(ㅓ vs ㅕ)',
              '조합: ㅇ + ㅕ = 여',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '2-3',
            title: 'ㅗ → ㅛ 변신!',
            points: [
              'ㅗ에 획 추가 시각 비교',
              'ㅛ 소리 듣기',
              '2지선다(ㅗ vs ㅛ)',
              '조합: ㅇ + ㅛ = 요',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '2-4',
            title: 'ㅜ → ㅠ 변신!',
            points: [
              'ㅜ에 획 추가 시각 비교',
              'ㅠ 소리 듣기',
              '2지선다(ㅜ vs ㅠ)',
              '조합: ㅇ + ㅠ = 유',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '2-5',
            title: 'Y-모음 랜덤 챌린지',
            points: [
              '대상: ㅑ, ㅕ, ㅛ, ㅠ',
              '기본 모음과 혼합 4지선다',
              '랜덤 퀴즈 진행',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '2-6',
            title: '기본 vs Y-모음 구분',
            points: [
              'ㅏ/ㅑ 대비 집중',
              'ㅓ/ㅕ 대비 집중',
              'ㅗ/ㅛ 대비 집중',
              'ㅜ/ㅠ 대비 집중',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '2-M',
            title: 'Y-모음 미션',
            mission: '랜덤 Y-모음 6개 연속 맞추기',
          ),
        ],
      ),
    );
  }
}

class HangulStage3AeEVowelsScreen extends StatelessWidget {
  const HangulStage3AeEVowelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3단계: ㅐ/ㅔ 모음'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: 'ㅐ/ㅔ 구분 인식, 단어 수준 맥락 학습',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['학습 60%', '쓰기(선택) 20%', '퀴즈 20%']),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '3-1',
            title: 'ㅐ 소리 찾기',
            points: [
              'ㅏ + ㅣ = ㅐ 시각 안내',
              '2지선다(ㅐ vs ㅏ)',
              '조합: ㅇ + ㅐ = 애',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '3-2',
            title: 'ㅔ 소리 찾기',
            points: [
              'ㅓ + ㅣ = ㅔ 시각 안내',
              '2지선다(ㅔ vs ㅓ)',
              '조합: ㅇ + ㅔ = 에',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '3-3',
            title: 'ㅐ vs ㅔ 구분 (핵심)',
            points: [
              '"소리는 거의 같아요" 안내',
              '단어 구분: 개 vs 게',
              '모양 시각 집중 훈련',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '3-4',
            title: 'ㅒ 소리 찾기',
            points: [
              'ㅑ + ㅣ = ㅒ 시각 안내',
              '대표 단어: 얘',
              '짧은 3문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '3-5',
            title: 'ㅖ 소리 찾기',
            points: [
              'ㅕ + ㅣ = ㅖ 시각 안내',
              '대표 단어: 예',
              '짧은 3문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '3-6',
            title: 'ㅐ/ㅔ 계열 종합 퀴즈',
            points: [
              'ㅐ, ㅔ, ㅒ, ㅖ 4종 혼합 랜덤',
              '단어 읽기 포함',
              '종합 구분 훈련',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '3-M',
            title: 'ㅐ/ㅔ 미션',
            mission: 'ㅐ/ㅔ 계열 단어 5개 듣고 선택',
          ),
        ],
      ),
    );
  }
}

class HangulStage4ConsonantsScreen extends StatelessWidget {
  const HangulStage4ConsonantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('4단계: 기본 자음 1'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '자음 모양/소리를 익히고, 모음과 합쳐 읽기 시작',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['학습 60%', '쓰기(선택) 20%', '퀴즈 20%']),
          SizedBox(height: 8),
          _StageSectionHeader(
            title: '운영 팁',
            subtitle: '쓰기 활동은 선택 버튼으로만 노출',
          ),
          SizedBox(height: 12),
          _StageSectionHeader(
            title: '4-1단계',
            subtitle: 'ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ',
          ),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '4-1',
            title: 'ㄱ 소리 잡기',
            points: [
              'ㄱ 소리 감각 듣기("그"보다 자음 느낌 중심)',
              '듣고 맞추기: ㄱ vs ㄴ',
              '모양 찾기: ㄱ vs ㄷ',
              '따라쓰기',
              '조합: ㄱ + ㅏ = 가 / ㄱ + ㅗ = 고',
              '읽기 퀴즈 5문항(가/고/구 중 고르기)',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '4-2',
            title: 'ㄴ 소리 잡기',
            points: [
              'ㄴ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(나/노) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '4-3',
            title: 'ㄷ 소리 잡기',
            points: [
              'ㄷ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(다/도) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '4-4',
            title: 'ㄹ 소리 잡기',
            points: [
              'ㄹ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(라/로) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '4-5',
            title: 'ㅁ 소리 잡기',
            points: [
              'ㅁ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(마/모) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '4-6',
            title: 'ㅂ 소리 잡기',
            points: [
              'ㅂ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(바/보) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '4-7',
            title: 'ㅅ 소리 잡기',
            points: [
              'ㅅ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(사/소) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '4-M',
            title: '자음 미션',
            mission: 'ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅅ로 자음 조합 5개 완성',
          ),
        ],
      ),
    );
  }
}

class HangulStage5ConsonantsScreen extends StatelessWidget {
  const HangulStage5ConsonantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5단계: 기본 자음 2'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: 'ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ 자음을 익히고 읽기에 연결',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['학습 60%', '쓰기(선택) 20%', '퀴즈 20%']),
          SizedBox(height: 8),
          _StageSectionHeader(
            title: '운영 팁',
            subtitle: '쓰기 활동은 선택 버튼으로만 노출',
          ),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '5-1',
            title: 'ㅇ 자리 이해하기',
            points: [
              '초성 ㅇ은 소리가 거의 없다는 감각만 소개',
              '모양 인식 + 조합 읽기(아/오)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-2',
            title: 'ㅈ 소리 잡기',
            points: [
              'ㅈ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(자/조) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-3',
            title: 'ㅊ 소리 잡기',
            points: [
              '추가 자음 확장(ㅊ) 단일 집중',
              '소리/모양 인식 + 조합 읽기(차/초)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-4',
            title: 'ㅋ 소리 잡기',
            points: [
              '추가 자음 확장(ㅋ) 단일 집중',
              '소리/모양 인식 + 조합 읽기(카/코)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-5',
            title: 'ㅌ 소리 잡기',
            points: [
              '추가 자음 확장(ㅌ) 단일 집중',
              '소리/모양 인식 + 조합 읽기(타/토)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-6',
            title: 'ㅍ 소리 잡기',
            points: [
              '추가 자음 확장(ㅍ) 단일 집중',
              '소리/모양 인식 + 조합 읽기(파/포)',
              '5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-7',
            title: 'ㅎ 소리 잡기',
            points: [
              'ㅎ 단일 자음 소리/모양 학습',
              '2지선다 청취 + 모양 구분',
              '조합 읽기(하/호) + 5문항 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-8',
            title: '자음 랜덤 챌린지',
            points: [
              '대상: ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ',
              '랜덤 청취/모양/읽기 문제 혼합',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-9',
            title: '자음 혼동쌍 미리보기 (중요)',
            points: [
              '대비 묶음: ㅈ/ㅊ',
              '대비 묶음: ㅋ/ㅌ/ㅍ',
              '대비 묶음: ㅇ/ㅎ',
              '다음 단계 대비용 사전 구분 훈련',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '5-M',
            title: '자음 미션',
            mission: 'ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ로 자음 조합 5개 완성',
          ),
        ],
      ),
    );
  }
}

class HangulStage5SyllableReadingScreen extends StatelessWidget {
  const HangulStage5SyllableReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('6단계: 본격 조합 훈련'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '자모 암기에서 음절 읽기로 전환 + 복합모음 도입',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['읽기/조합 60%', '대비 퀴즈 40%']),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '5-1',
            title: '가~기 패턴 읽기',
            points: [
              'ㄱ + (ㅏ ㅓ ㅗ ㅜ ㅡ ㅣ)',
              '가 거 고 구 그 기 패턴 반복',
              '리듬 읽기로 자동화 시작',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-2',
            title: '나~니, 다~디, 라~리 확장',
            points: [
              'ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅎ 확장',
              '같은 모음 패턴에 자음만 바꿔 읽기',
              '읽기 속도보다 정확도 우선',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-3',
            title: '랜덤 음절 읽기',
            points: [
              '예: 고 / 누 / 다 / 시 / 하 랜덤 카드',
              '순차 패턴이 아닌 실제 읽기 감각 훈련',
              '제한시간은 선택 기능(강요하지 않음)',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-4',
            title: '소리 듣고 음절 찾기',
            points: [
              'TTS 또는 녹음 음성 듣기',
              '3~4개 보기 중 정답 음절 선택',
              '청각-문자 연결 강화',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-5',
            title: '내가 만드는 음절 (조합 놀이)',
            points: [
              '자음/모음 선택 후 음절 자동 생성',
              '생성된 글자 바로 읽어보기',
              '"지금 만든 글자를 읽어보세요" 안내 중심',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-6',
            title: '복합 모음: ㅘ, ㅝ',
            points: [
              'ㅗ + ㅏ = ㅘ, ㅜ + ㅓ = ㅝ 시각 안내',
              '음절 읽기: 와/워/화/뭐',
              '소리 듣고 맞추기 + 조합 연습',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-7',
            title: '복합 모음: ㅙ, ㅞ, ㅚ, ㅟ',
            points: [
              '조합 원리 시각 안내',
              '음절 읽기: 왜/웨/외/위',
              '인식 수준 반복 훈련',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '5-8',
            title: '복합 모음: ㅢ + 종합',
            points: [
              'ㅡ + ㅣ = ㅢ 시각 안내',
              '대표 단어: 의사, 회의',
              '복합모음 종합 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '5-M',
            title: '조합 미션',
            mission: '랜덤 자모로 목표 음절 5개 완성하기',
          ),
        ],
      ),
    );
  }
}

class HangulStage6ContrastScreen extends StatelessWidget {
  const HangulStage6ContrastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('7단계: 된소리/거센소리 집중'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '헷갈리는 소리를 대비 학습으로 구분',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['읽기/조합 60%', '대비 퀴즈 40%']),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '6-1',
            title: 'ㄱ vs ㅋ',
            points: [
              '2개만 비교: ㄱ / ㅋ',
              '모양 대비 + 소리 대비 + 음절 대비(가/카)',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-2',
            title: 'ㄱ vs ㄲ',
            points: [
              '2개만 비교: ㄱ / ㄲ',
              '소리 대비 + 음절 대비(가/까)',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-3',
            title: 'ㅋ vs ㄲ',
            points: [
              '2개만 비교: ㅋ / ㄲ',
              '소리 대비 + 음절 대비(카/까)',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-4',
            title: 'ㄷ vs ㅌ',
            points: [
              '2개만 비교: ㄷ / ㅌ',
              '모양/소리/음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-5',
            title: 'ㄷ vs ㄸ',
            points: [
              '2개만 비교: ㄷ / ㄸ',
              '소리 대비 + 음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-6',
            title: 'ㅌ vs ㄸ',
            points: [
              '2개만 비교: ㅌ / ㄸ',
              '소리 대비 + 음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-7',
            title: 'ㅂ vs ㅍ',
            points: [
              '2개만 비교: ㅂ / ㅍ',
              '모양/소리/음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-8',
            title: 'ㅂ vs ㅃ',
            points: [
              '2개만 비교: ㅂ / ㅃ',
              '소리 대비 + 음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-9',
            title: 'ㅍ vs ㅃ',
            points: [
              '2개만 비교: ㅍ / ㅃ',
              '소리 대비 + 음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-10',
            title: 'ㅅ vs ㅆ',
            points: [
              '2개만 비교: ㅅ / ㅆ',
              '모양/소리/음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-11',
            title: 'ㅈ vs ㅊ',
            points: [
              '2개만 비교: ㅈ / ㅊ',
              '모양/소리/음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-12',
            title: 'ㅈ vs ㅉ',
            points: [
              '2개만 비교: ㅈ / ㅉ',
              '소리 대비 + 음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '6-13',
            title: 'ㅊ vs ㅉ',
            points: [
              '2개만 비교: ㅊ / ㅉ',
              '소리 대비 + 음절 대비',
              '빠른 퀴즈 8문항 반복',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '6-M',
            title: '대비 미션',
            mission: '헷갈리는 소리쌍 8문항 연속 클리어',
          ),
        ],
      ),
    );
  }
}

class HangulStage7BatchimBasicScreen extends StatelessWidget {
  const HangulStage7BatchimBasicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('8단계: 받침(종성) 1차'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '받침이 들어간 글자를 읽고, 가장 자주 쓰는 받침부터 익히기',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['받침 읽기 70%', '단어 30%']),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '7-0',
            title: '받침 개념 레슨 (필수)',
            points: [
              '받침은 글자 밑에 들어감(위치 강조)',
              '"밑에 오면 소리가 바뀐다" 감각 중심 소개',
              '받침 유무 비교로 첫 인식 만들기',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-1',
            title: 'ㄴ 받침',
            points: [
              '예시 음절: 간, 난, 단',
              '짧은 읽기 예시 중심',
              '소리 듣고 맞추기 + 받침 조합 + 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-2',
            title: 'ㄹ 받침',
            points: [
              '예시 음절: 말, 갈, 물',
              '받침 위치를 시각적으로 반복 강조',
              '소리 듣고 맞추기 + 받침 조합 + 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-3',
            title: 'ㅁ 받침',
            points: [
              '예시 음절: 감, 밤, 숨',
              '받침 읽기 리듬 훈련',
              '소리 듣고 맞추기 + 받침 조합 + 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-4',
            title: 'ㅇ 받침',
            points: [
              '예시 음절: 방, 공, 종',
              '종성 ㅇ 소리 인식 강화',
              '소리 듣고 맞추기 + 받침 조합 + 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-5',
            title: 'ㄱ 받침',
            points: [
              '예시 음절: 박, 각',
              '확장 예시: 먹(뒤 단계에서 본격)',
              '소리 듣고 맞추기 + 받침 조합 + 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-6',
            title: 'ㅂ 받침',
            points: [
              '예시 음절/단어: 밥, 집',
              '받침 위치 인식 + 읽기 연결',
              '소리 듣고 맞추기 + 받침 조합 + 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-7',
            title: 'ㅅ 받침',
            points: [
              '예시 음절/단어: 옷, 맛',
              '기본 받침군 마지막 정리',
              '소리 듣고 맞추기 + 받침 조합 + 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '7-8',
            title: '받침 섞기 퀴즈',
            points: [
              '랜덤 받침 음절 읽기',
              '단어 3개 읽기 포함',
              '최종 퀴즈로 1차 받침 마무리',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '공통 시나리오',
            title: '받침형 레슨 진행 템플릿',
            points: [
              '1) 받침 위치 강조(밑에 들어감)',
              '2) 예시 3개 읽기',
              '3) 소리 듣고 맞추기',
              '4) 받침 있는 음절 만들기(조합)',
              '5) 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '7-M',
            title: '받침 미션',
            mission: '숨겨진 받침 단어 5개 찾아 읽기',
          ),
        ],
      ),
    );
  }
}

class HangulStage8BatchimExtendedScreen extends StatelessWidget {
  const HangulStage8BatchimExtendedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('9단계: 받침 확장'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '받침 종류를 확장하되, 복잡한 발음 규칙은 뒤 단계로 미루기',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['받침 읽기 70%', '단어 30%']),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '8-1',
            title: 'ㄷ 받침',
            points: [
              'ㄷ 받침 읽기 패턴 익히기',
              '예시 읽기 + 소리 듣고 맞추기 + 조합',
              '규칙 설명보다 읽기 정확도 중심',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '8-2',
            title: 'ㅈ 받침',
            points: [
              'ㅈ 받침 읽기 패턴 익히기',
              '예시 읽기 + 소리 듣고 맞추기 + 조합',
              '읽기 중심 반복 훈련',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '8-3',
            title: 'ㅊ 받침',
            points: [
              'ㅊ 받침 읽기 패턴 익히기',
              '예시 읽기 + 소리 듣고 맞추기 + 조합',
              '읽기 중심 반복 훈련',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '8-4',
            title: 'ㅋ / ㅌ / ㅍ 묶음',
            points: [
              '유사 패턴 받침 묶음 학습',
              '세 받침 비교 읽기 + 구분 퀴즈',
              '읽기 속도보다 구분 정확도 우선',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '8-5',
            title: 'ㅎ 받침',
            points: [
              'ㅎ 받침 읽기 패턴 익히기',
              '예시 읽기 + 소리 듣고 맞추기 + 조합',
              '복잡한 음운변동 설명은 제외',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '8-6',
            title: '받침 확장 섞기 퀴즈',
            points: [
              '대상: ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ',
              '랜덤 읽기 문제 + 청취 선택 문제',
              '확장 받침 읽기 안정화',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '8-M',
            title: '확장 받침 미션',
            mission: '확장 받침 단어 5개를 시간 내 읽기',
          ),
        ],
      ),
    );
  }
}

class HangulStage9AdvancedBatchimScreen extends StatelessWidget {
  const HangulStage9AdvancedBatchimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('10단계: 복합 받침 (고급)'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '복합 받침을 규칙 암기보다 단어 읽기 중심으로 익히기',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['받침 읽기 70%', '단어 30%']),
          SizedBox(height: 8),
          _StageSectionHeader(
            title: '학습 성격',
            subtitle: '선택(고급) 단계로 운영 권장 - 완주 필수 아님',
          ),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '9-1',
            title: 'ㄳ',
            points: [
              '대표 예시: 몫, 넋',
              '단어 난이도가 높으면 스킵 가능',
              '규칙 설명보다 단어 읽기 노출 중심',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '9-2',
            title: 'ㄵ / ㄶ',
            points: [
              '대표 예시: 앉다, 많다',
              '고빈도 단어 중심 읽기 반복',
              '청취-읽기 매칭으로 인식 강화',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '9-3',
            title: 'ㄺ / ㄻ',
            points: [
              '대표 예시: 읽다, 삶',
              '낱자 규칙보다 단어 단위 처리',
              '반복 읽기 + 짧은 퀴즈',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '9-4',
            title: 'ㄼ / ㄾ / ㄿ / ㅀ (고급 묶음)',
            points: [
              '고급 복합 받침을 짧게 묶어서 노출',
              '과도한 설명 없이 인식 레벨만 확보',
              '선택 학습으로 부담 최소화',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '9-5',
            title: 'ㅄ',
            points: [
              '대표 예시: 없다',
              '실사용 빈도 높은 단어 중심',
              '읽기/청취 매칭 반복',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '9-6',
            title: '복합 받침 단어 읽기',
            points: [
              '핵심 단어: 읽다 / 없다 / 앉다 / 많다',
              '문제 유형: 읽기 + 듣고 고르기',
              '고급 단계 마무리',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '9-M',
            title: '고급 미션',
            mission: '읽다/없다/앉다/많다 포함 단어 5개 클리어',
          ),
        ],
      ),
    );
  }
}

class HangulStage10WordReadingScreen extends StatelessWidget {
  const HangulStage10WordReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('11단계: 단어 읽기 확장'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _StageSectionHeader(
            title: '목표',
            subtitle: '자모 학습을 실제 단어 읽기 성취감으로 연결',
          ),
          SizedBox(height: 8),
          _StageMixCard(items: ['단어 읽기 80%', '퀴즈 20%']),
          SizedBox(height: 12),
          _LessonCard(
            lessonId: '10-1',
            title: '받침 없는 단어 (아주 쉬운 단계)',
            points: [
              '예시: 바나나, 나비, 하마, 모자',
              '자음+모음 패턴만으로 읽기 자신감 확보',
              '짧은 단어 중심의 성공 경험 제공',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '10-2',
            title: '받침 있는 단어 (1차 받침 중심)',
            points: [
              '예시: 학교, 친구, 한국, 공부, 밥, 집, 문',
              '기본 받침(ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ) 읽기 적용',
              '단어 단위 읽기 안정화',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '10-3',
            title: '받침 섞인 단어 (난이도 상승)',
            points: [
              '예시: 읽기, 닭, 많다, 없다',
              '기본+복합 받침 혼합 노출',
              '완벽한 규칙보다 읽기 실전 감각 우선',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '10-4',
            title: '카테고리별 단어팩 (선택)',
            points: [
              '카테고리: 음식 / 동물 / 장소 / 사람 / 물건',
              '콘텐츠 확장성과 리텐션에 유리',
              '선택형 학습으로 개인화 가능',
            ],
          ),
          SizedBox(height: 10),
          _LessonCard(
            lessonId: '10-5',
            title: '단어 읽기 퀴즈 모드',
            points: [
              '소리 듣고 단어 고르기',
              '단어 보고 소리 고르기',
              '최종 읽기 성취 확인',
            ],
          ),
          SizedBox(height: 10),
          _MissionLessonCard(
            lessonId: '10-M',
            title: '단어 미션',
            mission: '오늘의 단어 5개를 듣고 읽고 맞히기',
          ),
        ],
      ),
    );
  }
}

class _StageSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _StageSectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _StageMixCard extends StatelessWidget {
  final List<String> items;

  const _StageMixCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final item in items)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MissionLessonCard extends StatelessWidget {
  final String lessonId;
  final String title;
  final String mission;

  const _MissionLessonCard({
    required this.lessonId,
    required this.title,
    required this.mission,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFFF8E1),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(Icons.flag_circle, color: Color(0xFFF9A825)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$lessonId. $title',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mission,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final String lessonId;
  final String title;
  final List<String> points;
  final String? activityTitle;
  final String? activityDetail;

  const _LessonCard({
    required this.lessonId,
    required this.title,
    required this.points,
    this.activityTitle,
    this.activityDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$lessonId. $title',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            for (final point in points)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(point)),
                  ],
                ),
              ),
            if (activityTitle != null && activityDetail != null) ...[
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$activityTitle: $activityDetail',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
