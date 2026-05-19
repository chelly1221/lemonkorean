# 레슨 엔진 및 스텝 타입 상세

> 한글 레슨의 기술적 구조, 11가지 스텝 타입 상세, 채점/보상 시스템, 진행 저장 메커니즘

---

## 1. 레슨 엔진 (HangulLessonFlowScreen)

### 아키텍처
```
HangulLessonFlowScreen (PageView 기반)
├── PageController (NeverScrollableScrollPhysics - 수동 진행만)
├── 진행 바 (현재+1) / 전체
├── Step 위젯들 (각 페이지)
└── 점수 누적 (_correctAnswers / _totalAnswers)
```

### 핵심 로직
```dart
// 점수 계산
int get _scorePercent {
  if (_totalAnswers == 0) return 100;
  return ((_correctAnswers / _totalAnswers) * 100).round();
}

// 레몬 보상 계산 (일반 레슨)
int _calculateLemonsEarned(int score) {
  if (score >= 95) return 3;
  if (score >= 80) return 2;
  return 1;
}

// 레몬 보상 계산 (미션)
int _calculateMissionLemons(int timeSeconds, int completed) {
  if (timeSeconds < 120) return 3;
  if (timeSeconds < 180) return 2;
  if (completed >= 3) return 1;
  return 0;
}
```

### 네비게이션
```
레슨 목록 화면 → [레슨 탭] → HangulLessonFlowScreen → [완료/종료] → 레슨 목록
```

- 이전 레슨 완료 필수 (잠금 해제 순차적)
- 중단 시: AlertDialog 확인 → 진행도 손실
- 완료 후: 최고점만 저장 (기존 점수보다 높을 때만 업데이트)

---

## 2. 스텝 타입 상세

### 2.1 StepIntro (소개)

**용도**: 텍스트/이모지 소개, 개념 설명

```
구조: 이모지/애니메이션 → 제목 → 설명 → 하이라이트 칩 → 다음 버튼
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `emoji` | String | 대형 이모지 (기본값 '📖') |
| `animation` | Map | `{consonant, vowel, result}` → BlockCombineIntroAnimation |
| `highlights` | List<String> | 강조 텍스트 칩 목록 |

**애니메이션**: scale(0.5→1.0, 500ms) → fadeIn(400ms) → title(200ms delay)

**채점**: 없음

---

### 2.2 StepSoundExplore (소리 탐색)

**용도**: 음절/단어 청취, 입모양 시각화

```
구조: 제목 → [문자 탭(미청취 배지)] → 중앙 원형 플레이 버튼 → [입모양] → 다음
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `characters` | List<String> | 탐색할 문자/단어 목록 |
| `type` | String | `consonant`, `vowel`, `syllable`, `word` |
| `showMouth` | bool | 입모양 애니메이션 표시 여부 |
| `pronunciationMap` | Map | 자음→참조 음절 매핑 (예: ㄱ→가) |

**로직**:
- 단일 문자: 즉시 진행 가능
- 다중 문자: **모든 문자 듣기 완료 시에만** 다음 버튼 활성화
- 미청취 문자: 빨간 배지 표시

**채점**: 없음

---

### 2.3 StepSoundMatch (소리 매칭)

**용도**: 소리 듣고 올바른 문자 선택

```
구조: 제목 → 진행도(현재/전체) → 스피커 버튼 → 선택지(2~5개) → [피드백]
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `questions` | List | `[{answer, choices}]` |

**플로우**:
1. initState: 첫 문제 TTS 자동 재생 (500ms 후)
2. 선택 → 피드백 표시 (정답=녹색, 오답=빨강)
3. 다음 버튼 → 300ms 후 다음 문제 TTS 재생
4. 마지막 → onCompleted(정답수, 전체수)

**채점**: O

---

### 2.4 StepQuizMcq (객관식 퀴즈)

**용도**: 문자 인식, 규칙 식별, 상황 파악

```
구조: 제목 → 진행도(닷) → 질문 박스(28px) → 2×2 선택지(140×64) → [피드백]
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `questions` | List | `[{question, choices, answer}]` |

**진행도 닷(8×8 원)**:
- 완료: 초록색
- 현재: 노란색
- 미완료: 회색

**채점**: O

---

### 2.5 StepDragDropAssembly (드래그 드롭 조립)

**용도**: 자음+모음 드래그하여 음절 생성

```
구조: 제목 → 진행도 → [힌트] → 드롭 영역(자음+모음 슬롯) → 문자 풀(Draggable)
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `items` | List | `[{consonant, vowel, result, hint?}]` |
| `consonantPool` | List | 드래그 가능한 자음 [ㄱ,ㄴ,ㄷ] |
| `vowelPool` | List | 드래그 가능한 모음 [ㅏ,ㅗ] |

**상호작용**:
- 올바른 드롭: 가벼운 진동 + TTS + 확대 → 1.2초 후 자동 진행
- 잘못된 드롭: 중진동 + 빨간 테두리 0.4초 → 리셋
- 힌트: 800ms 후 자동 사라짐

**채점**: O

---

### 2.6 StepSyllableBuild (음절 조립 - 탭)

**용도**: 자음+모음 탭하여 음절 생성

```
구조: 제목 → 목표("'가' 만들기") → [결과 블록/슬롯] → 자음 선택 → 모음 선택
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `targets` | List | `[{consonant, vowel, result}]` |
| `consonantChoices` | List | 선택 가능한 자음 |
| `vowelChoices` | List | 선택 가능한 모음 |

**플로우**:
1. 자음 탭 → 모음 탭
2. 정답: TTS + 확대 → 1.2초 후 다음
3. 오답: shake 애니메이션 + "다시 시도해요" 1초

**채점**: O

---

### 2.7 StepMissionIntro (미션 소개)

```
구조: 🚩 이모지 → 제목 → 설명 → 미션 카드(시간+목표) → 시작 버튼
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `timeLimitSeconds` | int | 제한 시간 (초) |
| `targetCount` | int | 목표 음절 수 |

**채점**: 없음

---

### 2.8 StepTimedMission (시간 제한 미션)

```
구조: [상단] 타이머+진행도 → [중앙] 목표 음절 → 자음 선택 → 모음 선택
```

**데이터 필드**:
| 필드 | 타입 | 설명 |
|------|------|------|
| `timeLimitSeconds` | int | 제한 시간 |
| `targetCount` | int | 목표 수 |
| `consonants` | List | 사용 자음 |
| `vowels` | List | 사용 모음 |

**한글 음절 생성 공식**:
```
음절 코드 = 0xAC00 + (초성인덱스 × 588) + (중성인덱스 × 28) + 종성인덱스
```

**채점**: O (onCompleted(소요시간, 완성수))

---

### 2.9 StepMissionResults (미션 결과)

```
구조: 🏆 → "미션 완료!" → 통계(블록 수+시간) → 레몬 보상 → [재시도/다음]
```

**채점**: 없음 (표시만)

---

### 2.10 StepSummary (레슨 요약)

```
구조: 🎉 → 제목 → 메시지 → 레몬 보상 애니메이션 → 완료 버튼
```

**채점**: 없음 (최종 점수 저장 트리거)

---

### 2.11 StepStageComplete (Stage 완료)

```
구조: 🎊 → 제목 → 설명 → Stage Master 배지(🍋) → 돌아가기 버튼
```

**채점**: 없음

---

## 3. 진행 저장 시스템

### 로컬 저장 (Hive)

| Box | 키 | 값 |
|-----|-----|-----|
| `hangul_lesson_progress` | `'0-1'` | `HangulLessonProgressModel.toJson()` |
| `hangul_progress` | `'userId_charId'` | `HangulProgressModel.toJson()` (SRS) |

### 서버 동기화

**동기화 키 변환**:
```
lessonId → 90000 + (stage × 100) + lesson
'0-1'  → 90001
'5-M'  → 90599  (M = 99)
'12-6' → 91206
```

**동기화 큐 항목**:
```json
{
  "type": "lesson_complete",
  "data": {
    "lesson_id": 90001,
    "status": "completed",
    "quiz_score": 85,
    "stage_progress": {
      "hangul_lesson_id": "0-1",
      "total_steps": 5,
      "completed_steps": 5,
      "lemons_earned": 2
    }
  }
}
```

### 최고점 유지 정책
```dart
if (existing != null && existing.bestScore >= bestScore) {
  return; // 기존 점수가 높으면 업데이트 안 함
}
```

---

## 4. 파일 구조

### 레슨 엔진 코어
```
stage0/
├── hangul_lesson_flow_screen.dart    # PageView 메인 엔진
├── stage0_lesson_content.dart        # Stage 0 데이터
└── steps/
    ├── step_intro.dart
    ├── step_sound_explore.dart
    ├── step_sound_match.dart
    ├── step_quiz_mcq.dart
    ├── step_drag_drop_assembly.dart
    ├── step_syllable_build.dart
    ├── step_mission_intro.dart
    ├── step_timed_mission.dart
    ├── step_mission_results.dart
    ├── step_summary.dart
    └── step_stage_complete.dart
```

### 스테이지별 콘텐츠 정의
```
stage1/stage1_lesson_content.dart
stage2/stage2_lesson_content.dart
...
stage12/stage12_lesson_content.dart
```

### 공유 위젯
```
widgets/
├── hangul_stage_path_view.dart     # 스테이지 경로 맵
├── hangul_stats_bar.dart           # 통계 바
├── pronunciation_player.dart       # 발음 재생
└── mouth_animation_widget.dart     # 입모양 애니메이션
```

### 데이터 레이어
```
providers/hangul_provider.dart      # 상태 관리
repositories/hangul_repository.dart # 저장소
models/
├── hangul_progress_model.dart      # SRS 진행도
└── hangul_lesson_progress_model.dart # 레슨 진행도
```

---

## 5. 채점 대상 스텝

발음 채점(GOP) 기능이 커리큘럼에서 제거되었으며, `passScore` 설정은 더 이상 사용되지 않는다.

채점은 퀴즈 정답 기반으로만 수행된다:

| 채점 스텝 | 채점 방식 |
|----------|----------|
| SoundMatch | 정답 선택 수 / 전체 문제 수 |
| QuizMCQ | 정답 선택 수 / 전체 문제 수 |
| SyllableBuild | 정답 조합 수 / 전체 목표 수 |
| DragDrop | 정답 조합 수 / 전체 목표 수 |
| TimedMission | 소요시간 + 완성 수 (미션 레몬 계산) |

## 6. 미션 설정 총 정리

| Stage | 시간(초) | 목표(개) | 자음 수 | 모음 수 |
|-------|---------|---------|---------|---------|
| 1-9 | 120 | 8 | 3 | 2 |
| 2-7 | 120 | 8 | 5 | 4 |
| 3-7 | 120 | 8 | 7 | 4 |
| 4-M | 120 | 8 | 7 | 4 |
| 5-M | **90** | **6** | 7 | 4 |
| 6-M | 120 | 8 | 9 | 6 |
| 7-M | 120 | 8 | 9 | 4 |
| 8-M | 120 | 8 | 6 | 4 |
| 9-M | **90** | **6** | 7 | 4 |
| 10-M | 120 | 6 | 6 | 4 |
| 11-M | **90** | **10** | 10 | 6 |
| 12-M | 120 | 8 | **14** | **8** |

---

**마지막 업데이트**: 2026-03-11
