# QuizStage - 다양한 문제 유형의 퀴즈

5가지 문제 유형이 포함된 종합 퀴즈 화면. 즉시 피드백, 점수 추적, 선택적 타이머 기능.

---

## 핵심 특성

### 1. 5가지 문제 유형
- **듣기 (Listening)** - 오디오 재생 + 선택
- **빈칸 (Fill-in-Blank)** - 조사 선택
- **번역 (Translation)** - 한국어→중문 번역
- **어순 (Word Order)** - 드래그 앤 드롭 단어 배열
- **발음 (Pronunciation)** - 정확한 발음 선택

### 2. 즉시 피드백
- 답변 선택 시 즉시 정오답 표시
- 녹색✓ 정답 / 빨강✗ 오답
- 애니메이션 피드백 (fadeIn + slideY)

### 3. 점수 추적
- 실시간 점수 표시 (⭐ 아이콘)
- 진행 바 표시
- 최종 결과 화면 (백분율)

### 4. 선택적 타이머
```dart
QuizStage(
  lesson: lesson,
  enableTimer: true,  // ← 타이머 활성화
  onNext: _nextStage,
)
```
- 5분 카운트다운
- 1분 미만 시 빨간색 경고
- 시간 초과 시 자동 완료

### 5. 최종 결과 화면
- 80% 이상 합격
- 애니메이션 아이콘 (scale + shake)
- 점수, 백분율, 소요 시간
- 합격/불합격 메시지

---

## 기술 구현

### QuizStage 메인 위젯

```dart
class QuizStage extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool enableTimer;  // 타이머 활성화 여부

  const QuizStage({
    required this.lesson,
    required this.onNext,
    required this.onPrevious,
    this.enableTimer = false,
  });
}
```

### 상태 관리

```dart
class _QuizStageState extends State<QuizStage> {
  int _currentQuestionIndex = 0;                // 현재 문제 인덱스
  final Map<int, dynamic> _userAnswers = {};    // 사용자 답변
  final Map<int, bool> _isCorrect = {};         // 정오답 여부
  int _score = 0;                               // 총 점수
  bool _quizCompleted = false;                  // 완료 여부
  Timer? _timer;                                // 타이머
  int _remainingSeconds = 300;                  // 남은 시간 (5분)
}
```

### 타이머 구현

```dart
void _startTimer() {
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_remainingSeconds > 0) {
      setState(() {
        _remainingSeconds--;
      });
    } else {
      _completeQuiz();  // 시간 초과
    }
  });
}

@override
void dispose() {
  _timer?.cancel();  // 타이머 해제
  super.dispose();
}
```

### 답변 제출

```dart
void _submitAnswer(dynamic answer) {
  final question = _questions[_currentQuestionIndex];
  final isCorrect = _checkAnswer(question, answer);

  setState(() {
    _userAnswers[_currentQuestionIndex] = answer;
    _isCorrect[_currentQuestionIndex] = isCorrect;
    if (isCorrect) {
      _score++;  // 정답 시 점수 증가
    }
  });
}
```

### 답변 검증

```dart
bool _checkAnswer(Map<String, dynamic> question, dynamic answer) {
  switch (question['type']) {
    case 'word_order':
      // 리스트 순서 비교
      final correctOrder = question['correct'] as List;
      final userOrder = answer as List;
      return correctOrder.toString() == userOrder.toString();
    default:
      // 단순 문자열 비교
      return question['correct'] == answer;
  }
}
```

---

## 문제 유형별 위젯

### 1. ListeningQuestion - 듣기 문제

#### UI 구조
```
    [🎧 听力]           ← 타입 배지 (파란색)

    听音频，选择正确的翻译

    ┌─────────────────┐
    │      📊         │  ← 오디오 플레이어
    │                 │
    │  [▶ 播放音频]   │  ← 재생 버튼
    └─────────────────┘

    [你好] ✓            ← 옵션 (정답 = 녹색)
    [谢谢]
    [再见]
    [对不起]

    🎉 太棒了！         ← 피드백 (애니메이션)
```

#### 구현
```dart
class ListeningQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(String) onAnswer;
  final String? userAnswer;
  final bool? isCorrect;

  @override
  Widget build(BuildContext context) {
    return Column([
      _buildTypeBadge('听力', Icons.headphones, Colors.blue),

      // 오디오 플레이어
      Container(
        gradient: LinearGradient([Colors.blue.shade50, ...]),
        child: Column([
          Icon(Icons.graphic_eq, size: 80),
          ElevatedButton.icon(
            icon: Icon(Icons.play_arrow),
            label: Text('播放音频'),
            onPressed: _playAudio,
          ),
        ]),
      ),

      // 선택지
      ...options.map((option) => _buildOption(option)),

      // 피드백
      if (hasAnswered) _buildFeedback(),
    ]);
  }
}
```

### 2. FillInBlankQuestion - 빈칸 채우기

#### UI 구조
```
    [✏️ 填空]          ← 타입 배지 (녹색)

    填入正确的助词

    ┌─────────────────┐
    │ 저 ___ 학생입니다│  ← 빈칸 (점선 밑줄)
    │ 我是学生         │
    └─────────────────┘

    [은] [는✓] [이] [가] ← 옵션 (Wrap)

    🎉 太棒了！
    "저"以元音结尾，使用"는"
```

#### RichText 빈칸 표시
```dart
List<TextSpan> _buildSentenceSpans(String sentence) {
  final parts = sentence.split('___');

  return [
    TextSpan(text: '저'),
    TextSpan(
      text: ' ___ ',
      style: TextStyle(
        color: Colors.green.shade700,
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dashed,  // 점선
      ),
    ),
    TextSpan(text: ' 학생입니다'),
  ];
}
```

### 3. TranslationQuestion - 번역 문제

#### UI 구조
```
    [🌐 翻译]          ← 타입 배지 (보라색)

    选择正确的翻译

    ┌─────────────────┐
    │   감사합니다     │  ← 한국어 (큰 글씨)
    └─────────────────┘

    [你好]
    [谢谢] ✓            ← 정답
    [对不起]
    [再见]

    🎉 太棒了！
```

#### 구현
```dart
class TranslationQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column([
      _buildTypeBadge('翻译', Icons.translate, Colors.purple),

      // 한국어 텍스트
      Container(
        gradient: LinearGradient([Colors.purple.shade50, ...]),
        child: Text(
          question['korean'],
          fontSize: 36,
          fontWeight: bold,
        ),
      ),

      // 선택지
      ...options.map((option) => _buildOption(option)),

      if (hasAnswered) _buildFeedback(),
    ]);
  }
}
```

### 4. WordOrderQuestion - 어순 배열

#### UI 구조
```
    [🔀 排序]          ← 타입 배지 (주황색)

    按正确顺序排列单词

    我是学生            ← 번역 힌트

    ┌─────────────────┐
    │ [저는] [학생] [입니다]│ ← 정렬된 단어 (노란색)
    └─────────────────┘

    [밥을] [먹어요]     ← 사용 가능한 단어 (흰색)

    🎉 太棒了！
```

#### 드래그 앤 드롭 구현

```dart
class _WordOrderQuestionState extends State<WordOrderQuestion> {
  List<String> _orderedWords = [];       // 정렬된 단어
  List<String> _availableWords = [];     // 사용 가능한 단어

  @override
  void initState() {
    super.initState();
    _availableWords = List.from(question['words']);
    _availableWords.shuffle();  // 랜덤 섞기
  }

  void _addWord(String word) {
    setState(() {
      _orderedWords.add(word);
      _availableWords.remove(word);
    });

    // 모든 단어 배열 완료 시 자동 제출
    if (_availableWords.isEmpty) {
      widget.onAnswer(_orderedWords);
    }
  }

  void _removeWord(String word) {
    setState(() {
      _orderedWords.remove(word);
      _availableWords.add(word);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column([
      // 정렬된 단어 영역
      Container(
        minHeight: 100,
        color: isCorrect ? greenBg : redBg,
        child: Wrap(
          children: _orderedWords.map((word) =>
            GestureDetector(
              onTap: () => _removeWord(word),
              child: Container(
                color: primaryColor,
                child: Text(word),
              ),
            ),
          ).toList(),
        ),
      ),

      // 사용 가능한 단어 영역
      Wrap(
        children: _availableWords.map((word) =>
          GestureDetector(
            onTap: () => _addWord(word),
            child: Container(
              color: Colors.white,
              child: Text(word),
            ),
          ),
        ).toList(),
      ),
    ]);
  }
}
```

**상호작용 플로우**:
```
1. 사용 가능한 단어 표시 (섞인 순서)
    ↓
2. 사용자가 단어 클릭
    ↓
3. 정렬된 영역으로 이동
    ↓
4. 잘못 클릭 시 다시 클릭하여 제거
    ↓
5. 모든 단어 배열 완료
    ↓
6. 자동 제출 및 정오답 확인
```

### 5. PronunciationQuestion - 발음 문제

#### UI 구조
```
    [🗣️ 发音]         ← 타입 배지 (빨간색)

    选择正确的发音

    ┌─────────────────┐
    │  안녕하세요      │  ← 한국어 (큰 글씨)
    └─────────────────┘

    [an-nyeong-ha-se-yo] ✓  ← 정답 (이탤릭)
    [an-yong-ha-se-yo]
    [an-neong-ha-se-yo]
    [an-nyong-ha-yo]

    🎉 太棒了！
```

#### 구현
```dart
class PronunciationQuestion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column([
      _buildTypeBadge('发音', Icons.record_voice_over, Colors.red),

      // 한국어 텍스트
      Container(
        gradient: LinearGradient([Colors.red.shade50, ...]),
        child: Text(
          question['korean'],
          fontSize: 36,
          fontWeight: bold,
        ),
      ),

      // 발음 선택지 (이탤릭체)
      ...options.map((option) =>
        Container(
          child: Text(
            option,
            fontStyle: FontStyle.italic,  // ← 발음 표시
          ),
        ),
      ),

      if (hasAnswered) _buildFeedback(),
    ]);
  }
}
```

---

## 헤더 구현

### 진행 상황 표시

```dart
Widget _buildHeader() {
  final percentage = (_currentQuestionIndex + 1) / _questions.length;

  return Column([
    Row([
      // 문제 카운트
      Text('${_currentQuestionIndex + 1} / ${_questions.length}'),

      // 점수 배지
      Container(
        decoration: BoxDecoration(
          color: successColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row([
          Icon(Icons.stars, color: successColor),
          Text('$_score'),  // 현재 점수
        ]),
      ),

      // 타이머 (enableTimer = true인 경우)
      if (widget.enableTimer)
        Container(
          color: _remainingSeconds < 60 ? redBg : yellowBg,
          child: Row([
            Icon(Icons.timer_outlined),
            Text(_formatTime(_remainingSeconds)),  // 05:00
          ]),
        ),
    ]),

    // 진행 바
    LinearProgressIndicator(
      value: percentage,  // 0.2, 0.4, 0.6, 0.8, 1.0
    ),
  ]);
}
```

### 시간 포맷

```dart
String _formatTime(int seconds) {
  final minutes = seconds ~/ 60;      // 5분 = 5
  final secs = seconds % 60;          // 30초 = 30
  return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  // 출력: '05:30', '04:59', '00:30'
}
```

---

## 피드백 애니메이션

### 즉시 피드백

```dart
Widget _buildFeedback() {
  return Container(
    decoration: BoxDecoration(
      color: isCorrect
          ? successColor.withOpacity(0.1)
          : errorColor.withOpacity(0.1),
    ),
    child: Row([
      Icon(
        isCorrect ? Icons.celebration : Icons.info_outline,
        color: isCorrect ? successColor : errorColor,
      ),
      Text(
        isCorrect ? '太棒了！' : '正确答案是: ${question['correct']}',
        color: isCorrect ? successColor : errorColor,
      ),
    ]),
  )
    .animate()
    .fadeIn(duration: 300.ms)                  // 페이드인
    .slideY(begin: -0.2, end: 0, duration: 300.ms);  // 위에서 슬라이드
}
```

### 결과 화면 애니메이션

```dart
Widget _buildResultScreen() {
  return Column([
    // 아이콘 (scale + shake)
    Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient([successColor, ...]),
        boxShadow: [...],
      ),
      child: Icon(
        isPassed ? Icons.celebration : Icons.replay,
        size: 64,
      ),
    )
      .animate()
      .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
      .then()
      .shake(duration: 500.ms),

    // 제목 (fadeIn)
    Text(isPassed ? '太棒了！' : '继续加油！')
      .animate()
      .fadeIn(delay: 400.ms, duration: 600.ms),

    // 점수 (fadeIn)
    Text('得分：$_score / ${_questions.length}')
      .animate()
      .fadeIn(delay: 600.ms),

    // 백분율 (fadeIn + scale)
    Text('${percentage.toInt()}%')
      .animate()
      .fadeIn(delay: 800.ms)
      .scale(begin: Offset(0.5, 0.5), delay: 800.ms),

    // 메시지 (fadeIn)
    Container(...)
      .animate()
      .fadeIn(delay: 1200.ms),

    // 계속 버튼 (fadeIn + slideY)
    ElevatedButton(...)
      .animate()
      .fadeIn(delay: 1400.ms)
      .slideY(begin: 0.3, end: 0, delay: 1400.ms),
  ]);
}
```

**애니메이션 시퀀스**:
```
200ms  → 아이콘 scale + shake
400ms  → 제목 fadeIn
600ms  → 점수 fadeIn
800ms  → 백분율 fadeIn + scale
1200ms → 메시지 fadeIn
1400ms → 버튼 fadeIn + slideY
```

---

## 옵션 렌더링

### 공통 옵션 위젯

```dart
Widget _buildOption(String option, String correct, bool hasAnswered) {
  final isSelected = userAnswer == option;
  final isCorrectOption = option == correct;

  Color? backgroundColor;
  Color? borderColor;

  if (hasAnswered) {
    if (isCorrectOption) {
      // 정답은 항상 녹색
      backgroundColor = successColor.withOpacity(0.1);
      borderColor = successColor;
    } else if (isSelected) {
      // 사용자가 선택했지만 오답
      backgroundColor = errorColor.withOpacity(0.1);
      borderColor = errorColor;
    }
  } else if (isSelected) {
    // 답변 전 선택 상태
    backgroundColor = primaryColor.withOpacity(0.1);
    borderColor = primaryColor;
  }

  return GestureDetector(
    onTap: hasAnswered ? null : () => onAnswer(option),
    child: Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        border: Border.all(
          color: borderColor ?? Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: Row([
        Expanded(child: Text(option)),
        if (hasAnswered && isCorrectOption)
          Icon(Icons.check_circle, color: successColor),  // ✓
        if (hasAnswered && isSelected && !isCorrectOption)
          Icon(Icons.cancel, color: errorColor),  // ✗
      ]),
    ),
  );
}
```

### 상태별 색상

| 상태 | 배경 | 테두리 | 아이콘 |
|------|------|--------|--------|
| 미선택 | 흰색 | 회색 | 없음 |
| 선택 (답변 전) | 연노랑 | 노랑 | 없음 |
| 정답 | 연녹색 | 녹색 | ✓ 녹색 |
| 오답 (선택) | 연빨강 | 빨강 | ✗ 빨강 |

---

## 타입 배지

### 공통 배지 위젯

```dart
Widget _buildTypeBadge(String label, IconData icon, Color color) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: color, width: 2),
    ),
    child: Row([
      Icon(icon, size: 20, color: color),
      SizedBox(width: 8),
      Text(
        label,
        style: TextStyle(
          fontWeight: bold,
          color: color,
        ),
      ),
    ]),
  );
}
```

### 문제 유형별 색상

| 유형 | 라벨 | 아이콘 | 색상 |
|------|------|--------|------|
| Listening | 听力 | headphones | 파란색 |
| Fill-in-Blank | 填空 | edit_note | 녹색 |
| Translation | 翻译 | translate | 보라색 |
| Word Order | 排序 | reorder | 주황색 |
| Pronunciation | 发音 | record_voice_over | 빨간색 |

---

## 결과 화면

### 합격/불합격 기준

```dart
final percentage = (_score / _questions.length) * 100;
final isPassed = percentage >= 80;  // 80% 이상 합격
```

### UI 구조

```
    ┌───────┐
    │  🎉   │           ← 아이콘 (합격=celebration, 불합격=replay)
    └───────┘

    太棒了！            ← 제목 (합격=녹색, 불합격=빨강)

    得分：4 / 5         ← 점수

    80%                 ← 백분율 (큰 글씨)

    ┌─────────────────┐
    │ ⏱️ 用时: 03:25  │  ← 소요 시간 (타이머 활성화 시)
    └─────────────────┘

    ┌─────────────────┐
    │ 你已经很好地     │  ← 메시지
    │ 掌握了本课内容！ │
    └─────────────────┘

    [继续]              ← 계속 버튼
```

### 소요 시간 계산

```dart
if (widget.enableTimer) {
  final elapsedSeconds = 300 - _remainingSeconds;
  // 300초 (5분) - 남은 시간 = 소요 시간

  Text('用时: ${_formatTime(elapsedSeconds)}');
  // 출력: '用时: 03:25' (3분 25초)
}
```

---

## 데이터 구조

### 문제 객체

```dart
final List<Map<String, dynamic>> _questions = [
  // 듣기 문제
  {
    'type': 'listening',
    'question': '听音频，选择正确的翻译',
    'audio': 'quiz/question1.mp3',
    'korean': '안녕하세요',
    'options': ['你好', '谢谢', '再见', '对不起'],
    'correct': '你好',
  },

  // 빈칸 채우기
  {
    'type': 'fill_in_blank',
    'question': '填入正确的助词',
    'sentence': '저___ 학생입니다',
    'translation': '我是学生',
    'blank_word': '저',
    'options': ['은', '는', '이', '가'],
    'correct': '는',
    'explanation': '"저"以元音结尾，使用"는"',
  },

  // 번역 문제
  {
    'type': 'translation',
    'question': '选择正确的翻译',
    'korean': '감사합니다',
    'options': ['你好', '谢谢', '对不起', '再见'],
    'correct': '谢谢',
  },

  // 어순 배열
  {
    'type': 'word_order',
    'question': '按正确顺序排列单词',
    'translation': '我是学生',
    'words': ['학생', '입니다', '저는'],  // 섞인 순서
    'correct': ['저는', '학생', '입니다'],  // 정답 순서
  },

  // 발음 문제
  {
    'type': 'pronunciation',
    'question': '选择正确的发音',
    'korean': '안녕하세요',
    'options': [
      'an-nyeong-ha-se-yo',
      'an-yong-ha-se-yo',
      'an-neong-ha-se-yo',
      'an-nyong-ha-yo',
    ],
    'correct': 'an-nyeong-ha-se-yo',
  },
];
```

---

## 사용 예제

### lesson_screen.dart에서 통합

```dart
import 'stages/quiz_stage.dart';

PageView(
  children: [
    Stage1Intro(...),
    VocabularyStage(...),
    GrammarStage(...),
    Stage4Practice(...),
    Stage5Dialogue(...),

    // 퀴즈 (타이머 활성화)
    QuizStage(
      lesson: lesson,
      onNext: _nextStage,
      onPrevious: _previousStage,
      enableTimer: true,  // ← 타이머 활성화
    ),

    Stage7Summary(...),
  ],
)
```

### 타이머 비활성화

```dart
// 타이머 없이 퀴즈
QuizStage(
  lesson: lesson,
  onNext: _nextStage,
  onPrevious: _previousStage,
  // enableTimer 생략 (기본값 false)
)
```

### 실제 데이터 사용

```dart
@override
void initState() {
  super.initState();

  // lesson.content에서 퀴즈 데이터 로드
  final quizData = widget.lesson.content['stage6_quiz'];
  _questions = (quizData['questions'] as List)
      .map((q) => q as Map<String, dynamic>)
      .toList();

  if (widget.enableTimer) {
    _startTimer();
  }
}
```

---

## 성능 최적화

### 1. 위젯 분리
```dart
// 각 문제 유형을 별도 위젯으로 분리
// → build 메서드 간소화, 재사용성 향상

ListeningQuestion(...)
FillInBlankQuestion(...)
TranslationQuestion(...)
WordOrderQuestion(...)
PronunciationQuestion(...)
```

### 2. 상태 보존
```dart
// Map으로 모든 답변 저장
// → 이전 문제로 돌아가도 답변 유지

final Map<int, dynamic> _userAnswers = {
  0: '你好',     // 문제 1 답변
  1: '는',       // 문제 2 답변
  2: '谢谢',     // 문제 3 답변
  // ...
};
```

### 3. 타이머 정리
```dart
@override
void dispose() {
  _timer?.cancel();  // 메모리 누수 방지
  super.dispose();
}
```

### 4. 조건부 렌더링
```dart
// 타이머 활성화 시에만 타이머 위젯 표시
if (widget.enableTimer)
  Container(...타이머 UI...)

// 답변 후에만 피드백 표시
if (hasAnswered)
  _buildFeedback()
```

---

## 상호작용 플로우

### 퀴즈 진행 흐름

```
1. 퀴즈 시작
    ↓
2. 타이머 시작 (enableTimer = true)
    ↓
3. 문제 1 표시
    ↓
4. 사용자 답변 선택
    ↓
5. _submitAnswer() 호출
    ↓
6. 정오답 확인 + 점수 업데이트
    ↓
7. 피드백 표시 (애니메이션)
    ↓
8. [다음 문제] 버튼 활성화
    ↓
9. 다음 문제로 이동
    ↓
10. 반복 (문제 2~5)
    ↓
11. 마지막 문제 완료
    ↓
12. _completeQuiz() 호출
    ↓
13. 타이머 중지
    ↓
14. 결과 화면 표시 (애니메이션)
    ↓
15. [계속] 버튼 → onNext() → Stage7Summary
```

### 어순 문제 특수 플로우

```
1. 단어 목록 섞기 (shuffle)
    ↓
2. 사용 가능 영역에 표시
    ↓
3. 사용자가 단어 클릭
    ↓
4. _addWord() → 정렬 영역으로 이동
    ↓
5. 잘못 선택 시 다시 클릭
    ↓
6. _removeWord() → 사용 가능 영역으로 복귀
    ↓
7. 모든 단어 배열 완료
    ↓
8. 자동 제출 (onAnswer 콜백)
    ↓
9. 정오답 확인 + 피드백
```

---

## 테스트 요점

### Widget 테스트

```dart
testWidgets('shows correct question type', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: QuizStage(
        lesson: testLesson,
        onNext: () {},
        onPrevious: () {},
      ),
    ),
  );

  // 첫 번째 문제는 듣기
  expect(find.text('听力'), findsOneWidget);
  expect(find.byIcon(Icons.headphones), findsOneWidget);
});
```

### 답변 제출 테스트

```dart
testWidgets('submits answer and shows feedback', (tester) async {
  await tester.pumpWidget(...);

  // 옵션 선택
  await tester.tap(find.text('你好'));
  await tester.pump();

  // 피드백 표시 확인
  expect(find.text('太棒了！'), findsOneWidget);
  expect(find.byIcon(Icons.celebration), findsOneWidget);
});
```

### 점수 계산 테스트

```dart
test('calculates score correctly', () async {
  final state = _QuizStageState();

  // 정답 2개, 오답 1개
  state._submitAnswer('你好');      // 정답
  state._nextQuestion();
  state._submitAnswer('는');        // 정답
  state._nextQuestion();
  state._submitAnswer('你好');      // 오답

  expect(state._score, 2);
});
```

### 타이머 테스트

```dart
testWidgets('timer counts down', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: QuizStage(
        lesson: testLesson,
        enableTimer: true,
        onNext: () {},
        onPrevious: () {},
      ),
    ),
  );

  // 초기 시간 확인
  expect(find.text('05:00'), findsOneWidget);

  // 1초 대기
  await tester.pump(Duration(seconds: 1));

  // 시간 감소 확인
  expect(find.text('04:59'), findsOneWidget);
});
```

---

## 고급 기능 (향후 개선)

### 1. 음성 인식 (발음 문제)

```dart
import 'package:speech_to_text/speech_to_text.dart';

class PronunciationQuestion extends StatefulWidget {
  // ...
}

class _PronunciationQuestionState extends State<PronunciationQuestion> {
  final SpeechToText _speech = SpeechToText();
  bool _isListening = false;

  Future<void> _startListening() async {
    await _speech.listen(
      onResult: (result) {
        final recognized = result.recognizedWords;
        _checkPronunciation(recognized);
      },
    );
    setState(() => _isListening = true);
  }

  void _checkPronunciation(String recognized) {
    // 발음 유사도 비교
    final similarity = _calculateSimilarity(
      recognized,
      widget.question['korean'],
    );

    if (similarity > 0.8) {
      widget.onAnswer(widget.question['correct']);
    }
  }
}
```

### 2. 힌트 시스템

```dart
class QuizStage extends StatefulWidget {
  final int maxHints;  // 최대 힌트 횟수

  const QuizStage({
    this.maxHints = 3,  // 기본 3회
  });
}

void _useHint() {
  if (_hintsRemaining > 0) {
    setState(() {
      _hintsRemaining--;
      _showHint = true;
    });
  }
}

// UI
if (_showHint)
  Container(
    child: Text('💡 提示: ${question['hint']}'),
  );
```

### 3. 난이도 조절

```dart
final List<Map<String, dynamic>> _questions = [
  {
    'type': 'listening',
    'difficulty': 'easy',      // 난이도 추가
    'question': '...',
    // ...
  },
];

// 난이도별 점수 가중치
int _calculateScore(String difficulty, bool isCorrect) {
  if (!isCorrect) return 0;

  switch (difficulty) {
    case 'easy':
      return 1;
    case 'medium':
      return 2;
    case 'hard':
      return 3;
    default:
      return 1;
  }
}
```

### 4. 재시험 기능

```dart
Widget _buildResultScreen() {
  return Column([
    // ...

    // 합격 실패 시 재시험 버튼
    if (!isPassed)
      ElevatedButton(
        child: Text('重新测试'),
        onPressed: _retryQuiz,
      ),
  ]);
}

void _retryQuiz() {
  setState(() {
    _currentQuestionIndex = 0;
    _userAnswers.clear();
    _isCorrect.clear();
    _score = 0;
    _quizCompleted = false;
    _remainingSeconds = 300;
  });

  if (widget.enableTimer) {
    _startTimer();
  }
}
```

---

## 접근성 개선

### 1. 색맹 대응

```dart
// 색상 + 아이콘으로 정오답 표시
Row([
  Icon(Icons.check_circle),  // 정답 아이콘
  Text('你好'),
])

Row([
  Icon(Icons.cancel),  // 오답 아이콘
  Text('谢谢'),
])
```

### 2. 화면 읽기 지원

```dart
Semantics(
  label: '问题 ${_currentQuestionIndex + 1}，总共 ${_questions.length} 题',
  child: Text('${_currentQuestionIndex + 1} / ${_questions.length}'),
)

Semantics(
  label: '当前得分 $_score 分',
  child: Text('$_score'),
)
```

---

## 주의사항

1. **타이머 정리**: dispose에서 반드시 _timer?.cancel() 호출
2. **상태 보존**: Map으로 답변 저장하여 이전 문제 복귀 시 유지
3. **자동 제출**: WordOrderQuestion은 모든 단어 배열 시 자동 제출
4. **애니메이션 충돌**: 피드백 애니메이션은 300ms로 통일
5. **답변 후 비활성화**: hasAnswered = true일 때 onTap = null로 설정

---

## 의존성

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_animate: ^4.0.0    # 애니메이션

  # 향후 추가
  # audioplayers: ^5.0.0     # 오디오 재생
  # speech_to_text: ^6.0.0   # 음성 인식 (발음 문제)
```
