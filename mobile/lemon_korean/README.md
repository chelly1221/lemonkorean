# Lemon Korean Mobile App (柠檬韩语)

다국어 한국어 학습 앱 - Flutter Android 모바일 애플리케이션 (6개 언어 지원)

## 프로젝트 개요

**핵심 특징:**
- 오프라인 우선 (Offline-First) 아키텍처
- 자동 동기화 시스템
- 레슨 다운로드 및 오프라인 학습
- 7단계 몰입형 학습 경험
- SRS (Spaced Repetition System) 복습
- 13단계 한글 커리큘럼 (Stage 0~12)
- 번들 오디오 (Google Cloud TTS 11,295개 MP3)
- 온디바이스 발음 채점 (wav2vec2 + ONNX)
- AI 콘텐츠 모더레이션 (AVX2/AVX-VNNI 최적화)
- Material Design 3

### 2026-02 아키텍처 기준 (필수)

- 앱 런타임 기본 원칙은 **Minimal Server**입니다.
- 서버 필수 의존:
  - `Auth` (로그인/토큰)
  - `Progress` (진도/동기화/SRS)
  - `SNS` (커뮤니티/DM/음성)
- 앱 내장(서버 비의존) 대상:
  - 한글/레슨/단어/문법 콘텐츠
  - 테마 기본값, 게임화 기본값
  - 캐릭터 카탈로그(상점 기본 아이템)
  - TTS 오디오 (Google Cloud TTS 번들)
  - 발음 채점 모델 (wav2vec2 ONNX 번들)
- 신규 기능 개발 시:
  - 사용자별 동기화 상태 -> 서버
  - 정적/버전형 학습 데이터 -> 앱 번들(`lib/data/local/`) 우선

---

## 기술 스택

### 프레임워크
- **Flutter**: 3.41.0 (stable)
- **Dart**: 3.11.0 (SDK >=3.0.0 <4.0.0)

### 주요 패키지 (35개 의존성)
- `dio`: HTTP 클라이언트
- `hive_flutter`: 로컬 NoSQL 데이터베이스
- `sqflite`: SQLite 데이터베이스 (미디어 메타데이터)
- `flutter_secure_storage`: 보안 저장소 (토큰)
- `provider`: 상태 관리
- `connectivity_plus`: 네트워크 상태 감지
- `audioplayers`: 오디오 재생
- `just_audio`: 속도 조절 오디오 재생 (Hangul 모듈)
- `record`: 오디오 녹음 (Hangul 모듈, 모바일 전용)
- `audio_waveforms`: 파형 시각화 (Hangul 모듈)
- `whisper_flutter_new`: Whisper ASR (모바일 전용)
- `onnxruntime_v2`: ONNX 추론 (v1.23.2, wav2vec2/GOP 모델)
- `perfect_freehand`: 필기 렌더링 (Hangul 모듈)
- `socket_io_client`: Socket.IO 실시간 메시징 (DM)
- `livekit_client`: LiveKit 음성 대화방
- `flame` / `flame_audio`: 게임 엔진 (음성방 시각화, 미니게임)
- `cached_network_image`: 이미지 캐싱
- `image_picker`: 이미지 선택 (DM 미디어 전송)
- `flutter_svg`: SVG 에셋 렌더링 (아이콘, 국기, 마스코트 등)
- `flutter_open_chinese_convert`: 간체/번체 자동 변환
- `google_mobile_ads`: 광고 (모바일)
- `share_plus`: 공유 기능
- `permission_handler`: 권한 관리
- `flutter_local_notifications` / `timezone`: 로컬 알림
- `flutter_dotenv`: 환경 변수
- `logger`: 로깅

---

## 프로젝트 구조

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart      # API 엔드포인트 (https://lemon.3chan.kr)
│   │   ├── app_constants.dart      # 앱 전역 상수
│   │   ├── level_constants.dart    # 레벨 색상/SVG/개수 (10 레벨)
│   │   └── settings_keys.dart      # SharedPreferences 키
│   ├── storage/
│   │   ├── local_storage.dart      # Hive 로컬 저장소
│   │   └── database_helper.dart    # SQLite 헬퍼
│   ├── network/
│   │   └── api_client.dart         # Dio API 클라이언트
│   ├── services/                   # 서비스 파일
│   │   ├── notification_service.dart    # 푸시 알림
│   │   ├── socket_service.dart          # Socket.IO 실시간 연결
│   │   ├── audio_recorder_service.dart  # 오디오 녹음 (발음 채점용)
│   │   ├── ad_service.dart              # 광고 서비스 추상화
│   │   ├── admob_service.dart           # AdMob
│   │   ├── whisper_service.dart         # Whisper ASR
│   │   ├── gop_service.dart             # GOP 서비스 (임베딩 추출)
│   │   ├── gop_service_native.dart      # 임베딩 추출 (ONNX)
│   │   ├── gop_models.dart              # GOP 데이터 모델
│   │   ├── pronunciation_scorer.dart    # 코사인 유사도 채점
│   │   └── speech_model_manager.dart    # ONNX 모델 관리
│   ├── data/
│   │   └── reference_embeddings.dart    # TTS 참조 임베딩 (152개, 1.7MB)
│   └── utils/
│       ├── download_manager.dart     # 다운로드 관리
│       ├── sync_manager.dart         # 동기화 관리
│       ├── media_loader.dart         # 미디어 로딩
│       ├── media_helper.dart         # 미디어 헬퍼
│       ├── chinese_converter.dart    # 간체/번체 변환
│       ├── korean_tts_helper.dart    # 한국어 TTS (번들 오디오 재생)
│       ├── pronunciation_feedback.dart  # 발음 피드백 생성
│       ├── error_localizer.dart      # 에러 코드 → l10n 문자열 변환
│       └── storage_utils.dart        # 저장소 유틸
├── data/
│   ├── local/                        # 앱 내장 정적 콘텐츠
│   │   ├── bundled_learning_content.dart  # 한글/레슨/단어 번들
│   │   └── conversation_prompts.dart     # 음성방 대화 주제 59개
│   ├── models/                       # 데이터 모델
│   │   ├── speech_result_model.dart      # 발음 채점 결과
│   │   └── ...
│   └── repositories/                 # 레포지토리 패턴
├── game/                             # Flame 게임 엔진 (26개 파일)
│   ├── components/                   # 효과, 캐릭터, 펫, 방, UI
│   ├── core/                         # game_bridge, constants, palette_swap, sprite_loader
│   ├── mini_games/                   # korean_quiz_game, word_puzzle_game
│   ├── my_room/                      # my_room_game.dart
│   └── voice_stage/                  # voice_stage_game, remote_character
├── presentation/
│   ├── screens/
│   │   ├── auth/                     # 인증 화면
│   │   ├── home/                     # 홈 화면 + 학습 경로
│   │   │   └── widgets/              # 레벨 셀렉터, 경로 뷰, 레몬 노드
│   │   ├── lesson/                   # 레슨 화면
│   │   │   └── stages/               # 7단계 레슨
│   │   │       └── quiz/             # 5개 퀴즈 유형
│   │   ├── download/                 # 다운로드 관리
│   │   ├── profile/                  # 프로필
│   │   ├── review/                   # SRS 복습
│   │   ├── settings/                 # 설정 화면 (4개)
│   │   ├── stats/                    # 통계 화면 (2개)
│   │   ├── vocabulary_book/          # 단어장 (2개)
│   │   ├── vocabulary_browser/       # 단어 검색
│   │   ├── onboarding/               # 온보딩 화면 (14개 파일)
│   │   ├── hangul/                   # 한글 학습 모듈
│   │   │   ├── stage0/ ~ stage12/    # 13단계 레슨 (각 2파일)
│   │   │   └── widgets/              # 한글 위젯 (10+개)
│   │   ├── community/                # 커뮤니티 피드
│   │   ├── create_post/              # 게시물 작성
│   │   ├── friend_search/            # 친구 검색
│   │   ├── post_detail/              # 게시물 상세
│   │   ├── user_profile/             # 사용자 프로필
│   │   ├── dm/                       # DM (1:1 메시징)
│   │   ├── voice_rooms/              # 음성 대화방 (6가지 방 유형)
│   │   │   └── widgets/              # 8개 위젯
│   │   └── my_room/                  # 캐릭터 커스터마이징 & 마이룸
│   ├── providers/                    # 상태 관리 (17개 Providers)
│   └── widgets/                      # 재사용 위젯
├── l10n/                             # 다국어 지원 (6개 언어, ~4,259 키)
│   ├── app_zh.arb                    # 중국어 간체
│   ├── app_zh_TW.arb                 # 중국어 번체
│   ├── app_ko.arb                    # 한국어
│   ├── app_en.arb                    # 영어
│   ├── app_ja.arb                    # 일본어
│   ├── app_es.arb                    # 스페인어
│   └── generated/                    # 자동 생성된 클래스
└── main.dart                         # 앱 진입점 (17개 Provider 등록)
```

**총 Dart 파일 수**: 323개 (소스 + 생성 + l10n + 온보딩 + 게임화 + SNS + DM + 음성대화방 + 캐릭터 + 한글 13단계 + 미니게임)

---

## 에셋 (Assets)

### 번들 오디오 (`assets/audio/ko/`)
- **11,295개 MP3 파일**: Google Cloud TTS로 사전 생성된 한국어 음성
- 한글 문자, 음절, 단어, 문장 발음
- 앱 번들에 포함 (서버 의존 없음, flutter_tts 미사용)
- `korean_tts_helper.dart`가 로컬 오디오 파일 재생 관리

### ML 모델
- **wav2vec2 ONNX**: 발음 임베딩 추출 (모바일 전용)
- **참조 임베딩**: 152개 문자/단어 TTS 기준 임베딩 (`reference_embeddings.dart`, 1.7MB)

### 기타 에셋
- `assets/levels/`: 10개 레벨 SVG 아이콘
- `assets/hangul/stroke_order/`: 83개 필기 순서 WebP/GIF
- `assets/characters/`: 캐릭터 스프라이트
- `assets/images/`: UI 이미지

---

## Build Scripts

### APK Build (`build_apk.sh`)

Android APK를 릴리즈 모드로 빌드합니다.

**Features:**
- Flutter clean + 의존성 설치
- Release 모드 APK 컴파일
- 타임스탬프 자동 네이밍
- `./data/apk-builds/`에 저장

**Usage:**
```bash
cd /mnt/lemonkorean/mobile/lemon_korean
./build_apk.sh
```

**Output:** `lemon_korean_YYYYMMDD_HHMMSS.apk`

**Note:** Admin Dashboard의 배포 자동화에서도 이 스크립트를 호출합니다.

---

## 시작하기

### 1. 환경 설정

```bash
# Flutter SDK 설치 확인
flutter --version
# Flutter 3.41.0 • Dart 3.11.0

# 의존성 설치
cd mobile/lemon_korean
flutter pub get
```

### 2. API 엔드포인트

`lib/core/constants/api_constants.dart`에서 설정:
- **프로덕션**: `https://lemon.3chan.kr`
- **로컬**: `http://localhost`

### 3. 앱 실행

```bash
# 연결된 기기 확인
flutter devices

# Android 실행
flutter run
```

---

## 핵심 기능

### 0. 온보딩 플로우

앱을 처음 실행하면 4단계 개인화 온보딩이 시작됩니다:

1. **언어 선택** (`language_selection_screen.dart`)
   - 6개 언어 중 선택 (중국어 간체/번체, 한국어, 영어, 일본어, 스페인어)
   - 선택 즉시 앱 전체 언어 변경

2. **레벨 선택** (`level_selection_screen.dart`)
   - 완전 초보/초급/중급/고급 4단계
   - 레벨에 따른 맞춤 콘텐츠 추천

3. **주간 목표** (`weekly_goal_screen.dart`)
   - 가벼운 (5분)/보통 (15분)/집중 (30분)/프로 (60분)
   - 일일 학습 시간 목표 설정

4. **계정 선택** (`account_choice_screen.dart`)
   - 로그인 또는 회원가입 선택

**디자인 시스템:**
- `utils/onboarding_colors.dart` - 컬러 팔레트
- `utils/onboarding_text_styles.dart` - 일관된 타이포그래피
- `widgets/` - 재사용 가능한 카드 컴포넌트 7개
- **폰트**: Pretendard (w400/w500/w600/w700)
- **주요 색상**: `#43240D` (기본 텍스트), `#FEFFF4` (배경), `#FFEC6D` (CTA 버튼), `#FFA323` (링크 강조)

**Provider 연동:**
- `SettingsProvider.setHasCompletedOnboarding(true)` - 온보딩 완료 상태
- `SettingsProvider.setWeeklyGoal()` - 주간 목표 저장
- `SettingsProvider.setUserLevel()` - 사용자 레벨 저장

---

### Hangul Learning Module (한글 학습)

13단계(Stage 0~12) 체계적 한글 커리큘럼. 인터랙티브 레슨, 필기 애니메이션, 번들 오디오 비교, 온디바이스 발음 채점. 전 단계 6개 언어 완전 로컬라이제이션 완료.

**Location**: `lib/presentation/screens/hangul/`

**13단계 커리큘럼 (Stage 0~12)**:

| Stage | 주제 | 학습 내용 | 레슨 수 |
|-------|------|----------|---------|
| 0 | 한글 소개 | 한글 블록 구조, 조합 원리 | 4 |
| 1 | 기본 모음 - ㅏ | ㅏ 모음 학습 | 4 |
| 2 | 기본 모음 - ㅑㅓㅕ | 추가 모음 | 4 |
| 3 | 기본 모음 - ㅗㅜㅠㅣㅡ | 나머지 기본 모음 | 4 |
| 4 | 기본 자음 1 | ㄱ,ㄴ,ㄷ,ㄹ,ㅁ,ㅂ | 4 |
| 5 | 기본 자음 2 | ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ | 4 |
| 6 | 조합 자음 | 쌍자음 (ㄲ,ㄸ,ㅃ,ㅆ,ㅉ) | 4 |
| 7 | 경음화 (된소리) | 경음/격음 구별 | 4 |
| 8 | 받침 기초 | 기본 받침 7개 | 4 |
| 9 | 받침 심화 | 확장 받침 | 4 |
| 10 | 겹받침 | 이중 받침 | 4 |
| 11 | 단어 읽기 확장 | 실전 단어 읽기 | 4 |
| 12 | 간단한 문장 읽기 | 문장 단위 읽기 연습 | 4 |

**레슨 구조 (각 레슨 6단계)**:
1. `intro` - 소개 (이모지 + 하이라이트)
2. `soundExplore` - 음성 탐색 (입모양 애니메이션)
3. `soundMatch` - 소리-글자 매칭 퀴즈
4. `syllableBuild` - 드래그앤드롭 음절 조합
5. `quizMcq` - 객관식 퀴즈
6. `summary` - 레슨 완료 요약

**추가 스텝 유형** (스테이지별):
- `step_writing_practice.dart` - 필기 연습
- `step_speech_practice.dart` - 발음 연습 (녹음 + 채점)

**Screens**:
- `hangul_level0_learning_screen.dart` - 13단계 학습 로드맵
- `hangul_table_screen.dart` - 자모 표 (자음/모음 정리)
- `hangul_syllable_screen.dart` - 음절 조합 연습
- `hangul_discrimination_screen.dart` - 소리 구분 훈련
- `stage0/` ~ `stage12/` - 각 단계별 레슨 목록 + 콘텐츠

**Widgets** (`lib/presentation/screens/hangul/widgets/`):
- `pronunciation_player.dart` - 속도 조절 오디오 (0.5x~1.5x)
- `stroke_order_animation.dart` - 필기 순서 애니메이션 (region clipping)
- `hangul_stroke_data.dart` - 35개 문자 필기 데이터 (7가지 방향)
- `native_comparison_card.dart` - 모국어 발음 비교 (6개 언어)
- `hangul_stage_path_view.dart` - 단계별 경로 시각화
- `hangul_stage_path_node.dart` - 경로 노드 (완료/진행/잠금)
- `hangul_stats_bar.dart` - 학습 진행률 바
- `character_card.dart` - 문자 카드
- `block_combine_intro_animation.dart` - 블록 조합 애니메이션 (5단계)

**필기 애니메이션 시스템**:
- Region-based 클리핑: 정규화 사각형(0.0~1.0) + wipe 방향
- 7가지 방향: leftToRight, rightToLeft, topToBottom, bottomToTop, 대각선 3종, radial
- 35개 문자 지원 (자음 19 + 모음 16+)
- 쌍자음: `_double()` 헬퍼로 자동 생성
- 에셋: `assets/hangul/stroke_order/` (83개 WebP/GIF)

**Features**:
- 13단계 로드맵 (52개 레슨)
- 모국어 발음 비교 (6개 언어)
- 입모양/혀 위치 시각화
- 속도 조절 오디오 (0.5x~1.5x)
- 필기 순서 애니메이션 (region clipping 방식)
- 소리 구분 훈련
- 드래그앤드롭 음절 조합
- 쉐도잉 모드 + 온디바이스 발음 채점 (모바일 전용)
- 단계별 진도 추적

**Packages**:
- `just_audio` - 속도 조절 오디오
- `record` - 오디오 녹음 (모바일 전용)
- `audio_waveforms` - 파형 시각화
- `perfect_freehand` - 필기 렌더링
- `whisper_flutter_new` - Whisper ASR (모바일 전용)
- `onnxruntime_v2` - ONNX 추론 (wav2vec2/GOP)

**i18n 구조**:
- Stage 0~12 콘텐츠가 `getStageNLessons(AppLocalizations l10n)` 함수로 로컬라이즈
- ARB 키 네이밍: `hangulS{N}L{M}Title`, `hangulS{N}L{M}Step{I}Title` 등

**Platform Support**:
- Android: 전체 지원 (녹음 + 발음 채점 포함)

---

### Pronunciation Scoring (온디바이스 발음 채점)

wav2vec2 임베딩 기반 코사인 유사도 채점 시스템. 모든 추론은 디바이스에서 실행 (서버 비의존).

**아키텍처**:
```
AudioRecorderService → WhisperService (ASR) → GopService (임베딩 추출)
                                                    ↓
                                            PronunciationScorer (코사인 유사도)
                                                    ↓
                                            SpeechResultModel (결과)
```

**서비스 구성** (`lib/core/services/`):
- `audio_recorder_service.dart` - 16kHz WAV 녹음
- `whisper_service.dart` - Whisper ASR (텍스트 변환)
- `gop_service.dart` / `gop_service_native.dart` - wav2vec2 ONNX 임베딩 추출
- `pronunciation_scorer.dart` - 코사인 유사도 채점 (0.30~0.85 → 0~100점 매핑)
- `speech_model_manager.dart` - ONNX 모델 로드/관리
- `gop_models.dart` - GOP 데이터 모델

**기술 상세**:
- 트리밍된 ONNX 모델: CTC 헤드 제거, 1024차원 은닉 상태 추출
- TTS 참조 임베딩: edge-tts 생성 + 평균 풀링 (152개 문자/단어)
- 6단계 오디오 전처리: DC 제거 → 80Hz 고역통과 → 노이즈 게이트 → 프리엠퍼시스
- WAV 파싱: RIFF/WAVE 청크 유효성 검증, data 청크 탐색
- 최소 녹음 길이: 0.5초 (16kHz 기준 8000 샘플)
- 패키지: `onnxruntime_v2` (v1.23.2, ConvInteger 지원)

**플랫폼**:
- Android: 전체 지원 (wav2vec2 ONNX + Whisper)

---

### App Theme System

Dynamic theme loading from backend API for complete app customization.

**Files**:
- `lib/data/models/app_theme_model.dart` - Theme data model
- `lib/presentation/providers/theme_provider.dart` - Theme state management

**Features**:
- **Dynamic Color Scheme**: 20+ colors loaded from API
  - Brand colors (primary, secondary, accent)
  - Status colors (error, success, warning, info)
  - Text colors (primary, secondary, hint)
  - Background colors (light, dark, card)
  - Lesson stage colors (7 stages)
- **Remote Logo Loading**: Splash, login, and favicon from server
- **Custom Font Support**: Google Fonts + custom uploads
- **Offline Caching**: Hive-based local storage
- **Version-Based Cache Invalidation**: Auto-update on theme changes

**Backend Integration**:
- **API Endpoint**: GET `/api/admin/app-theme` (public, no auth required)
- **Cache Storage**: Hive box `appTheme`
- **Update Detection**: Version number comparison
- **Fallback**: Built-in default theme if API unavailable

---

### Level Selector & Learning Path

Home screen level carousel and lesson path visualization.

**Location**: `lib/presentation/screens/home/widgets/`

**Widgets**:
- `level_selector.dart` - PageView carousel with 10 level icons (SVG)
- `lesson_path_view.dart` - Zigzag S-curve path connecting lesson nodes
- `lesson_path_node.dart` - Lemon-shaped node with 3 states (completed/in-progress/locked)
- `hangul_dashboard_view.dart` - Level 0 dashboard (action buttons + character lemon grid)
- `lemon_clipper.dart` - Custom lemon shape painter with glow effects

**Features**:
- Snap-to-select carousel with auto level switching on page change
- 10 levels with unique SVG icons and colors (defined in `level_constants.dart`)
- Level 0 (Hangul) shown inline as dashboard with quick actions:
  - 학습 (level roadmap)
  - 음절조합
  - 받침연습
  - 소리구분훈련
- Lemon-shaped nodes with completion states and pulse animation
- S-curve bezier path lines between nodes (solid=completed, dashed=incomplete)

**Assets**: `assets/levels/level_*.svg` (10 SVG files)

---

### Gamification System

Lemon reward system with boss quizzes, lemon tree, and ad integration.

**Files**:
- `lib/presentation/providers/gamification_provider.dart` - Gamification state management
- `lib/presentation/screens/lesson/boss_quiz_screen.dart` - Boss quiz at end of each week
- `lib/presentation/screens/home/widgets/boss_quiz_node.dart` - Boss quiz node in lesson path
- `lib/presentation/screens/lesson/stages/stage7_summary.dart` - Lemon rewards
- `lib/presentation/screens/profile/widgets/lemon_tree_widget.dart` - Lemon tree visualization
- `lib/core/services/ad_service.dart` - Ad service abstraction
- `lib/core/services/admob_service.dart` - AdMob for Android

**Features**:
- 1-3 lemon rewards per lesson based on quiz score
- Boss quizzes at end of each week (bonus 5 lemons)
- Lemon tree grows with earned lemons, harvest after ad
- AdMob rewarded ads (Android)
- Admin-configurable thresholds and ad settings

---

### Game Module (Flame 엔진)

Flame 게임 엔진 기반 시각화 및 미니게임. 26개 Dart 파일.

**Location**: `lib/game/`

**구조**:
- `components/` - 효과, 캐릭터, 펫, 방, UI 컴포넌트
- `core/` - game_bridge, game_constants, palette_swap, sprite_loader
- `mini_games/` - korean_quiz_game, word_puzzle_game, mini_game_base
- `my_room/` - 마이룸 게임 렌더링
- `voice_stage/` - 음성방 무대 시각화 (캐릭터 배치, 스파클 효과)

**음성방 연동** (`voice_stage/`):
- `voice_stage_game.dart` - 무대 렌더링, 앰비언트 스파클
- `remote_character.dart` - 원격 참가자 캐릭터 (프레임 독립 보간)
- 호스트 왕관, 골드 오라, 스팟 마커

---

### SNS Community

Social features: feed, posts, comments, follows, friend search. AI 콘텐츠 모더레이션 적용.

**Files**:
- `lib/presentation/providers/feed_provider.dart` - Feed state management
- `lib/presentation/providers/social_provider.dart` - Social interactions
- `lib/presentation/screens/community/community_screen.dart` - Community feed
- `lib/presentation/screens/community/widgets/` - Post cards, image grid, category filters
- `lib/presentation/screens/create_post/create_post_screen.dart` - Create post with images
- `lib/presentation/screens/post_detail/post_detail_screen.dart` - Post detail with comments
- `lib/presentation/screens/friend_search/friend_search_screen.dart` - User search
- `lib/presentation/screens/user_profile/user_profile_screen.dart` - User profile view

**Features**:
- Create/delete posts with categories (learning/general)
- Image attachments
- Comments with nested replies
- Like/unlike posts
- Follow/unfollow users
- User search by name
- Block/report users
- AI 콘텐츠 모더레이션 (게시물/댓글/프로필 바이오 자동 검사)

**Backend**: SNS Service (port 3007) + Moderation Service (port 3008)

---

### Direct Messaging (DM)

Real-time 1:1 messaging with Socket.IO.

**Files**:
- `lib/core/services/socket_service.dart` - Socket.IO connection manager (JWT auth, auto-reconnect)
- `lib/presentation/providers/dm_provider.dart` - DM state management
- `lib/presentation/screens/dm/dm_list_screen.dart` - Conversation list
- `lib/presentation/screens/dm/dm_chat_screen.dart` - Chat screen with message bubbles

**Features**:
- Real-time messaging via Socket.IO (path: `/api/sns/socket.io`)
- Image and voice message support
- Read receipts and typing indicators
- Online/offline status (Redis TTL 300s)
- Unread message count badges
- Auto-reconnection on network change
- Block check before sending messages

**Message Types**: `text`, `image`, `voice`

**Socket.IO Events**:
- Client → Server: `dm:send_message`, `dm:typing_start/stop`, `dm:mark_read`, `dm:join/leave_conversation`
- Server → Client: `dm:new_message`, `dm:typing`, `dm:read_receipt`, `dm:user_online/offline`

---

### Voice Rooms

LiveKit 기반 음성 대화방. 6가지 방 유형, Flame 게임 엔진 시각화, 대화 주제 자동 제공.

**Files**:
- `lib/presentation/providers/voice_room_provider.dart` - 음성방 상태 관리
- `lib/presentation/screens/voice_rooms/voice_rooms_list_screen.dart` - 방 목록
- `lib/presentation/screens/voice_rooms/voice_room_screen.dart` - 음성 대화 UI
- `lib/presentation/screens/voice_rooms/create_voice_room_screen.dart` - 방 생성
- `lib/presentation/screens/voice_rooms/widgets/` - 8개 위젯
- `lib/data/local/conversation_prompts.dart` - 59개 대화 주제 번들

**6가지 방 유형**:
| 유형 | 설명 |
|------|------|
| `free_talk` | 자유 대화 |
| `pronunciation` | 발음 연습 |
| `roleplay` | 역할극 (식당, 편의점 등) |
| `qna` | 질의응답 |
| `listening` | 듣기 연습 |
| `debate` | 토론 |

**Features**:
- LiveKit 실시간 음성 채팅
- 6가지 유형 + 시간 제한 (15/30/45/60분)
- 최대 4명 스피커 (무제한 리스너)
- 뮤트/언뮤트 토글 (desiredState 파라미터)
- 호스트 표시 (왕관 아이콘, 골드 오라)
- Flame 게임 엔진 무대 시각화 (캐릭터 배치, 스파클 효과)
- 59개 대화 주제 자동 제공 (수준별/유형별 필터)
- 리액션 트레이 (슬라이드/페이드 애니메이션, 3초 자동 닫기)
- 제스처 트레이 (쿨다운 인디케이터)
- WCAG AA 색상 대비, Semantics 라벨
- 연결 상태 배너, 재접속 로직

**안정화 (2026-03-01)**:
- `_disposed` 플래그 + `_safeNotifyListeners()` (use-after-dispose 방지)
- `_isJoiningOrCreating` 동시 입장/생성 가드
- LiveKit 재진입 방지 가드
- 메시지 목록 500개 제한 (메모리 누수 방지)
- 컬렉션 getter `List.unmodifiable` / `Map.unmodifiable` 반환
- 소켓 재연결 시 자동 음성방 재입장
- 스마트 자동 스크롤 (사용자 스크롤 위치 존중)
- `refreshParticipants` 500ms 디바운스
- 제스처별 개별 쿨다운 맵
- `sendMessage()` null/중복 전송 가드 + `maxLength: 500`
- FlameGame GPU 리소스 해제 수정
- LiveKit 토큰 50분마다 자동 갱신 (1시간 TTL 대응)
- 강퇴 사용자 재입장 차단 (인메모리 추적, 방 종료 시 해제)
- 방 목록 참가자에 `skin_color` + `equipped_items` 포함
- broadcast StreamController 이벤트 손실 수정
- 원격 캐릭터 화면 리사이즈 시 스케일링 수정
- 6개 소켓 핸들러에 room_id 유효성 검증 추가

**Backend Integration**:
- **10 API endpoints** in SNS Service (`/api/sns/voice-rooms/*`)
- **LiveKit token** generated server-side on join
- **4 database tables**: `voice_rooms`, `voice_room_participants`, `voice_room_messages`, `voice_room_stage_requests`
- **Socket.IO**: 12개+ 이벤트 (인증/유효성검사 강화, 30초 유예 기간 후 정리)

**Platform Support**:
- Android: Full LiveKit audio support

---

### Bundled Content

앱 내장 정적 콘텐츠로 서버 의존도 최소화.

**Location**: `lib/data/local/`

**bundled_learning_content.dart**:
- 41개 한글 문자 (자음 19 + 모음 21 + 확장)
- 24개 레슨 (6레벨 × 4레슨)
- 72개 단어 (레슨당 3개, 한-중 이중언어)
- 7단계 레슨 구조 정의

**conversation_prompts.dart**:
- 59개 대화 주제 (수준별/유형별)
- `getPrompts(level?, roomType?)` - 필터 검색
- `getRandomPrompt()` - 랜덤 선택
- `getDailyTopic()` - 일일 주제 (전 사용자 동일)

---

## 상태 관리 (17 Providers)

### AuthProvider
- 로그인/로그아웃, JWT 토큰 관리, 사용자 정보

### LessonProvider
- 레슨 목록 조회, 레슨 상세 정보, 레슨 다운로드

### ProgressProvider
- 학습 진도 관리, 레슨 완료 처리, 복습 스케줄

### SyncProvider
- 오프라인 데이터 동기화, 네트워크 상태 감지, 동기화 큐 관리

### SettingsProvider
- 앱 설정 (언어, 알림, 목표), 온보딩 상태

### ThemeProvider
- 동적 테마 로딩/캐싱, 버전 기반 업데이트

### HangulProvider
- 한글 학습 진도, 스테이지/레슨 상태 관리

### GamificationProvider
- 레몬 보상, 보스 퀴즈, 레몬 트리

### BookmarkProvider
- 북마크 관리 (단어, 레슨)

### VocabularyBrowserProvider
- 단어 검색/필터링

### FeedProvider
- 커뮤니티 피드, 게시물 목록 (무한 스크롤)

### SocialProvider
- 팔로우/차단/신고, 좋아요

### DmProvider
- Socket.IO 연결 관리, 대화 목록/메시지 히스토리
- 실시간 메시지 수신/전송, 읽음 확인, 타이핑 표시, 안읽은 메시지 카운트

### VoiceRoomProvider
- 음성 대화방 목록/상세, LiveKit 연결 및 토큰 관리
- 방 생성/입장/퇴장 (동시 작업 가드)
- use-after-dispose 방지, 소켓 재연결 자동 복구
- 채팅 메시지 관리 (500개 제한, 스마트 스크롤)

### CharacterProvider
- 캐릭터 커스터마이징, 아이템 관리

### SpeechProvider (모바일 전용)
- 발음 채점 세션 관리, 녹음 → 채점 플로우

### DownloadProvider (모바일 전용)
- 레슨 패키지 다운로드, 진행률 추적

**main.dart 등록**: 15개 공통 + 2개 모바일 전용 = 17개

---

## 백엔드 서비스 연동

### 마이크로서비스 (8개)

| 서비스 | 포트 | 기술 | 역할 |
|--------|------|------|------|
| Auth | 3001 | Node.js | JWT 인증 |
| Progress | 3003 | Go | 진도/SRS |
| Media | 3004 | Go | 미디어 서빙 |
| Analytics | 3005 | Python | 통계 |
| Admin | 3006 | Node.js | 운영/관리 도구 |
| SNS | 3007 | Node.js | 커뮤니티, DM, 음성대화방 |
| Moderation | 3008 | Python (FastAPI) | AI 콘텐츠 모더레이션 |

### AI 콘텐츠 모더레이션 (Moderation Service)

SNS 서비스와 연동되어 게시물, 댓글, 프로필 바이오를 자동으로 검사합니다.

**모델**: `unitary/multilingual-toxic-xlm-roberta` (ONNX + INT8 양자화)
- 지원 언어: 한국어, 영어, 일본어, 중국어, 스페인어 등 13개 언어
- 분류 카테고리: toxic, severe_toxic, obscene, threat, insult, identity_hate

**CPU 최적화**:
- INT8 동적 양자화 → AVX-VNNI 명령어 활용
- AVX2 SIMD 벡터 연산 병렬화
- ONNX Runtime 그래프 최적화 (ORT_ENABLE_ALL)

**처리 흐름**:
- `allow` (score < 0.3): 정상 저장
- `flag` (0.3 ≤ score < 0.7): 저장 + 관리자 검토 대기
- `reject` (score ≥ 0.7): 저장 거부, HTTP 422 반환
- 서비스 장애 시: `moderation_status = 'unmoderated'`로 저장 (fail-open)

**앱에서의 영향**:
- 게시물/댓글 작성 시 reject되면 에러 메시지 표시
- 피드에서 rejected 콘텐츠 자동 필터링 (서버 쿼리)
- 플래그된 콘텐츠는 정상 표시되지만 관리자 대시보드에서 검토 가능

---

## 로컬 저장소

### Hive (NoSQL)
```dart
// 레슨 데이터
LocalStorage.saveLesson(lesson);
LocalStorage.getLesson(lessonId);

// 진도 데이터
LocalStorage.saveProgress(progress);
LocalStorage.getProgress(lessonId);

// 동기화 큐
LocalStorage.addToSyncQueue(syncItem);
LocalStorage.getSyncQueue();
```

### SQLite (미디어 메타데이터)
```dart
// 미디어 파일 매핑
DatabaseHelper.insertMediaFile({
  'remote_key': 'images/lesson1.jpg',
  'local_path': '/storage/lesson1.jpg',
  'file_size': 1024000,
});

// 로컬 경로 조회
final localPath = await DatabaseHelper.getLocalPath('images/lesson1.jpg');
```

---

## API 통신

### Dio 인터셉터

```dart
// 1. Auth Interceptor - JWT 자동 추가
dio.interceptors.add(AuthInterceptor());

// 2. Logging Interceptor - 디버그 로깅
dio.interceptors.add(LoggingInterceptor());

// 3. Error Interceptor - 에러 처리
dio.interceptors.add(ErrorInterceptor());
```

---

## 다국어 지원 (i18n)

### 지원 언어

| 언어 | 코드 | ARB 파일 |
|------|------|----------|
| 중국어 간체 | zh | app_zh.arb |
| 중국어 번체 | zh_TW | app_zh_TW.arb |
| 한국어 | ko | app_ko.arb |
| 영어 | en | app_en.arb |
| 일본어 | ja | app_ja.arb |
| 스페인어 | es | app_es.arb |

### 번역 키 수

- **총 키 수**: ~4,250+개
- **카테고리**: UI, 레슨 7단계, 한글 Stage 0~12, 음성 대화방, 커뮤니티, DM, 설정, 오류 메시지, 알림, 발음 피드백 등
- **에러 로컬라이제이션**: `ErrorLocalizer.localize()` 패턴 — core/provider 레이어에서 에러 코드 키 저장, UI에서 l10n 문자열로 변환

### 번역 추가하기

```bash
# 1. ARB 파일에 새 키 추가 (6개 언어 모두)
# lib/l10n/app_*.arb

# 2. 번역 클래스 생성
flutter gen-l10n

# 3. 코드에서 사용
Text(AppLocalizations.of(context)!.appTitle)
```

### 언어 변경

```dart
// SettingsProvider에서 언어 변경
context.read<SettingsProvider>().setLanguage('ko');

// 시스템 언어 자동 감지
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
)
```

---

## 빌드 및 배포

### Android 빌드

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release
```

### APK 설치 (데이터 보존)

```bash
# adb install -r 사용 (데이터 보존)
ADB=/home/chell/android-sdk/platform-tools/adb
APK=build/app/outputs/flutter-apk/app-release.apk
$ADB -s <device-serial> install -r "$APK"
```

> `flutter install`은 기존 앱 삭제 후 재설치 (데이터 손실). 반드시 `adb install -r` 사용.

---

## 디버깅

```bash
# 실시간 로그
flutter logs

# DevTools 실행
flutter pub global activate devtools
flutter pub global run devtools
```

### Hot Reload / Hot Restart

```bash
# flutter run PID 확인
pgrep -a flutter | grep "run -d"

# 핫 리로드 (코드 변경 반영, 상태 유지)
kill -SIGUSR1 <PID>

# 핫 리스타트 (전체 재시작, 상태 초기화)
kill -SIGUSR2 <PID>
```

---

## 문제 해결

### Q: Gradle 빌드 실패 (Android)
```bash
cd android && ./gradlew clean && cd ..
flutter clean && flutter pub get
```

### Q: Flutter 캐시 정리
```bash
flutter clean && flutter pub get
```

---

## 라이센스

MIT License

---

## 기여

Pull Request 환영합니다!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
