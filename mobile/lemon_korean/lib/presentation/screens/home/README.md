# 홈 화면 (Home Screen)

Material Design 3 기반 홈 화면. 5개 탭과 레벨 셀렉터 캐러셀, 레벨별 학습 경로를 제공.

## 파일 구조

```
home/
├── home_screen.dart              # 메인 화면 (5개 Tab: Home, Community, My Room, Review, Profile)
└── widgets/
    ├── level_selector.dart       # 레벨 셀렉터 캐러셀 (10 레벨)
    ├── lesson_path_view.dart     # 레슨 경로 뷰 (지그재그 S-curve)
    ├── lesson_path_node.dart     # 레몬 모양 레슨 노드
    ├── boss_quiz_node.dart       # 보스 퀴즈 노드 (주차별, 2026-02-10)
    ├── hangul_dashboard_view.dart # 한글 대시보드 뷰 (레벨 0 전용)
    ├── lemon_clipper.dart        # 레몬 모양 CustomPainter
    ├── daily_goal_card.dart      # 일일 목표 카드 (ProfileTab)
    └── continue_lesson_card.dart # 이어서 학습 카드
```

---

## 화면 구조

### 메인 화면 (HomeScreen)

`IndexedStack` + `NavigationBar`로 5개 탭 구현:

1. **학습** (HomeTab) - 레벨 셀렉터 + 레벨별 학습 콘텐츠
2. **커뮤니티** (CommunityTab)
3. **마이룸** (MyRoomTab)
4. **복습** (ReviewTab) - SRS 복습 일정
5. **프로필** (ProfileTab) - 인사말, 연속 학습, 일일 목표, 통계

---

## Tab 상세

### 1. 학습 Tab (HomeTab)

`CustomScrollView` + `Sliver` 기반:

```
LevelSelector (레벨 캐러셀, 10개 아이콘)
    ↓
[레벨 0] HangulDashboardView (액션 버튼 + 한글 자모 레몬 그리드)
[레벨 1-9] LessonPathView (레슨 노드 지그재그 경로)
    ↓
ContinueLessonCard [선택적, 진행 중 레슨 있을 때]
```

**레벨 셀렉터 동작:**
- `PageView.builder` 캐러셀 (`viewportFraction: 0.17`)
- 중앙 아이콘 80px, 거리에 따라 32px까지 축소
- 스크롤 스냅 시 `onPageChanged`로 자동 레벨 전환
- 탭 시 해당 페이지로 애니메이션 이동 (onPageChanged가 자동 트리거)
- 중앙 아이콘에 노란색 테두리 + 글로우 + 하단 점 인디케이터

**레벨 0 (한글) 인라인:**
- `HangulDashboardView`를 인라인으로 표시
- 상단 액션 버튼 4개:
  - `학습` → `HangulLevel0LearningScreen`
  - `음절조합` → `HangulSyllableScreen`
  - `받침연습` → `HangulBatchimScreen`
  - `소리구분훈련` → `HangulDiscriminationScreen`
- 하단에서 자모 레몬 그리드를 통해 문자 상세(`HangulCharacterDetailScreen`) 이동

### 2. 복습 Tab (ReviewTab)

SRS 복습 일정:
- **오늘 복습 카드**: 대기 중 단어 수 + "복습 시작" 버튼
- **향후 복습 목록**: 오늘, 내일, 2일 후, 3일 후

### 3. 프로필 Tab (ProfileTab)

사용자 정보 + 학습 통계:

**상단:**
- 그라데이션 배경 (레몬 옐로우)
- 프로필 아바타, 사용자명, 이메일
- 회원 등급 뱃지

**인사말 + 연속 학습:**
- 시간대별 인사 (좋은 아침/오후/저녁)
- 연속 학습 일수 뱃지 (불꽃 아이콘)

**일일 목표:**
- DailyGoalCard - 진행률, 완료/목표 레슨 수

**학습 통계:**
- 완료 레슨, 학습 일수, 마스터 단어, 단어장
- 단어 브라우저, 저장소 관리

---

## 주요 위젯

### LevelSelector

10개 레벨 아이콘 캐러셀. SVG 아이콘 (`assets/levels/level_*.svg`).

| 속성 | 타입 | 설명 |
|------|------|------|
| `selectedLevel` | `int` | 현재 선택된 레벨 |
| `levelsWithProgress` | `Set<int>` | 진도가 있는 레벨 |
| `onLevelSelected` | `ValueChanged<int>` | 레벨 선택 콜백 |

### LessonPathView

지그재그 경로로 레슨을 표시. S-curve 연결선 + 레몬 모양 노드.

| 속성 | 타입 | 설명 |
|------|------|------|
| `lessons` | `List<LessonModel>` | 레슨 목록 |
| `lessonProgress` | `Map<int, double>` | 레슨별 진행률 |
| `levelColor` | `Color` | 레벨 색상 |
| `onLessonTap` | `Function(LessonModel)` | 레슨 탭 콜백 |

### LessonPathNode

레몬 모양 단일 노드. 3가지 상태:
- **완료** (progress >= 1.0): 채워진 레몬 + 체크 아이콘
- **진행 중** (0 < progress < 1.0): 색상 테두리 + 펄스 글로우
- **미시작** (progress == null): 회색 테두리 + 회색 번호

### HangulDashboardView

한글 전용 대시보드 뷰.
- 상단: 학습 액션 버튼(4개)
- 하단: 기본/쌍자음/기본모음/복합모음 자모 섹션
- 자모 탭 시 상세 화면으로 진입

### DailyGoalCard

일일 학습 목표 진행률 카드.

| 속성 | 타입 | 설명 |
|------|------|------|
| `progress` | `double` | 완료율 (0.0-1.0) |
| `completedLessons` | `int` | 완료 레슨 수 |
| `targetLessons` | `int` | 목표 레슨 수 |

---

## 레벨 색상 매핑

```dart
Level 0 → #5BA3EC (한글 파랑)
Level 1 → #8B6914 (씨앗 갈색)
Level 2 → #66BB6A (새싹 초록)
Level 3 → #4CAF50 (나무 초록)
Level 4 → #43A047 (큰 나무 진녹)
Level 5 → #FFD54F (레몬 1개 노랑)
Level 6 → #FFEB3B (레몬 가득 밝은 노랑)
Level 7 → #FFB300 (황금 나무 앰버)
Level 8 → #FFA000 (황금 농장 진앰버)
Level 9 → #2E7D32 (레몬 숲 초록)
```

---

## 애니메이션

`flutter_animate` 패키지 사용:
- 레슨 노드: `fadeIn` + `slideY` (각 80ms 딜레이)
- 이어서 학습 카드: `fadeIn` + `slideY`

---

## 데이터 흐름

```dart
// Provider 기반 데이터 로딩
_loadData() {
  1. 캐시된 레슨 즉시 표시 (Provider → LocalStorage)
  2. 병렬 API 호출 (lessons, progress, stats)
  3. 진행률 맵 + 레벨별 진도 계산
  4. UI 업데이트
}
```
