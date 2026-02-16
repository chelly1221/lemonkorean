# Lemon Korean Mobile App (柠檬韩语)

중국어 화자를 위한 한국어 학습 앱 - Flutter 모바일 애플리케이션

## 프로젝트 개요

**핵심 특징:**
- 📱 오프라인 우선 (Offline-First) 아키텍처
- 🔄 자동 동기화 시스템
- 📦 레슨 다운로드 및 오프라인 학습
- 🎯 7단계 몰입형 학습 경험
- 🧠 SRS (Spaced Repetition System) 복습
- 🎨 Material Design 3

---

## 기술 스택

### 프레임워크
- **Flutter**: 3.0+
- **Dart**: 3.0+

### 주요 패키지
- `dio`: HTTP 클라이언트
- `hive_flutter`: 로컬 NoSQL 데이터베이스
- `sqflite`: SQLite 데이터베이스 (미디어 메타데이터)
- `flutter_secure_storage`: 보안 저장소 (토큰)
- `provider`: 상태 관리
- `connectivity_plus`: 네트워크 상태 감지
- `audioplayers`: 오디오 재생
- `cached_network_image`: 이미지 캐싱
- `just_audio`: 속도 조절 오디오 재생 (Hangul 모듈)
- `record`: 오디오 녹음 (Hangul 모듈, 모바일 전용)
- `audio_waveforms`: 파형 시각화 (Hangul 모듈)
- `perfect_freehand`: 필기 렌더링 (Hangul 모듈)
- `socket_io_client`: Socket.IO 실시간 메시징 (DM)
- `livekit_client`: LiveKit 음성 대화방
- `image_picker`: 이미지 선택 (DM 미디어 전송)

---

## 프로젝트 구조

```
lib/
├── core/
│   ├── constants/
│   │   ├── api_constants.dart      # API 엔드포인트
│   │   ├── app_constants.dart      # 앱 전역 상수
│   │   ├── level_constants.dart    # 레벨 색상/SVG/개수 (10 레벨)
│   │   └── settings_keys.dart      # SharedPreferences 키
│   ├── storage/
│   │   ├── local_storage.dart      # Hive 로컬 저장소
│   │   └── database_helper.dart    # SQLite 헬퍼
│   ├── network/
│   │   └── api_client.dart         # Dio API 클라이언트
│   ├── platform/                   # 플랫폼 추상화 (23개 파일)
│   │   ├── interfaces/             # 5개 인터페이스
│   │   ├── io/                     # 4개 모바일 구현
│   │   └── web/                    # 13개 웹 스텁/구현
│   ├── services/
│   │   ├── notification_service.dart  # 푸시 알림
│   │   ├── socket_service.dart        # Socket.IO 실시간 연결
│   │   ├── ad_service.dart            # 광고 서비스 추상화
│   │   ├── admob_service.dart         # AdMob (모바일)
│   │   ├── admob_service_web.dart     # AdMob 웹 스텁
│   │   └── adsense_service.dart       # AdSense (웹)
│   └── utils/
│       ├── download_manager.dart   # 다운로드 관리
│       ├── sync_manager.dart       # 동기화 관리
│       ├── media_loader.dart       # 미디어 로딩
│       ├── media_helper.dart       # 미디어 헬퍼
│       ├── chinese_converter.dart  # 간체/번체 변환
│       └── storage_utils.dart      # 저장소 유틸
├── data/
│   ├── models/                     # 데이터 모델
│   └── repositories/               # 레포지토리 패턴
├── presentation/
│   ├── screens/
│   │   ├── auth/                   # 인증 화면
│   │   ├── home/                   # 홈 화면 + 학습 경로
│   │   │   └── widgets/            # 레벨 셀렉터, 경로 뷰, 레몬 노드
│   │   ├── lesson/                 # 레슨 화면
│   │   │   └── stages/             # 7단계 레슨
│   │   │       └── quiz/           # 5개 퀴즈 유형
│   │   ├── download/               # 다운로드 관리
│   │   ├── profile/                # 프로필
│   │   ├── review/                 # SRS 복습
│   │   ├── settings/               # 설정 화면 (4개)
│   │   ├── stats/                  # 통계 화면 (2개)
│   │   ├── vocabulary_book/        # 단어장 (2개)
│   │   ├── vocabulary_browser/     # 단어 검색
│   │   └── onboarding/             # 온보딩 화면 (16개 파일)
│   │       ├── language_selection_screen.dart
│   │       ├── welcome_introduction_screen.dart
│   │       ├── level_selection_screen.dart
│   │       ├── weekly_goal_screen.dart
│   │       ├── personalization_complete_screen.dart
│   │       ├── account_choice_screen.dart
│   │       ├── welcome_level_screen.dart
│   │       ├── utils/              # 디자인 시스템 (2개)
│   │       └── widgets/            # 재사용 위젯 (7개)
│   │   ├── community/              # 커뮤니티 피드
│   │   ├── create_post/            # 게시물 작성
│   │   ├── friend_search/          # 친구 검색
│   │   ├── post_detail/            # 게시물 상세
│   │   ├── user_profile/           # 사용자 프로필
│   │   ├── dm/                     # DM (1:1 메시징)
│   │   │   ├── dm_list_screen.dart         # 대화 목록
│   │   │   └── dm_chat_screen.dart         # 채팅 화면
│   │   ├── voice_rooms/            # 음성 대화방
│   │   │   ├── voice_room_list_screen.dart  # 방 목록
│   │   │   ├── voice_room_screen.dart       # 음성 대화 화면
│   │   │   └── widgets/                     # 6개 위젯
│   │   │       ├── stage_area_widget.dart
│   │   │       ├── audience_bar_widget.dart
│   │   │       ├── voice_chat_widget.dart
│   │   │       ├── stage_controls_widget.dart
│   │   │       ├── reaction_tray_widget.dart
│   │   │       └── gesture_tray_widget.dart
│   │   └── my_room/                # 캐릭터 커스터마이징 & 마이룸
│   │       ├── my_room_screen.dart          # 마이룸 메인
│   │       ├── character_editor_screen.dart # 캐릭터 편집
│   │       ├── room_editor_screen.dart      # 방 꾸미기
│   │       ├── shop_screen.dart             # 아이템 상점
│   │       └── character_detail_screen.dart # 아이템 상세
│   ├── providers/                  # 상태 관리 (16개 Providers)
│   │   └── character_provider.dart # 캐릭터 상태 관리
│   └── widgets/                    # 재사용 위젯
│       └── character_avatar_widget.dart # 캐릭터 아바타
├── l10n/                           # 다국어 지원 (6개 언어)
│   ├── app_zh.arb                  # 중국어 간체
│   ├── app_zh_TW.arb               # 중국어 번체
│   ├── app_ko.arb                  # 한국어
│   ├── app_en.arb                  # 영어
│   ├── app_ja.arb                  # 일본어
│   ├── app_es.arb                  # 스페인어
│   └── generated/                  # 자동 생성된 클래스
└── main.dart                       # 앱 진입점
```

**총 Dart 파일 수**: 230+개 (소스 + 생성 + l10n + 온보딩 + 게임화 + SNS + DM + 음성대화방 + 캐릭터 커스터마이징)

---

## Build Scripts

The project includes automated build scripts for production deployments.

### Web Build (`build_web.sh`)

Builds the Flutter web app and deploys to local storage.

**Features:**
- Flutter clean and dependency fetch
- WebAssembly bypass for compatibility (uses JS compilation)
- Automatic deployment to `./data/flutter-build/web/`
- 3-minute average build time
- 35MB output with optimized assets

**Usage:**
```bash
cd /home/sanchan/lemonkorean/mobile/lemon_korean
./build_web.sh
```

**Output:** `https://lemon.3chan.kr/app/`

### APK Build (`build_apk.sh`)

Builds Android APK in release mode and stores on NAS.

**Features:**
- Flutter clean and dependency fetch
- Release mode APK compilation
- Automatic naming with timestamp
- Local storage at `./data/apk-builds/`
- File size reporting

**Usage:**
```bash
cd /home/sanchan/lemonkorean/mobile/lemon_korean
./build_apk.sh
```

**Output:** `lemon_korean_YYYYMMDD_HHMMSS.apk`

**Note:** These scripts are also invoked by the Admin Dashboard's deployment automation.

---

## 시작하기

### 1. 환경 설정

```bash
# Flutter SDK 설치 확인
flutter --version

# 의존성 설치
cd mobile/lemon_korean
flutter pub get
```

### 2. API 엔드포인트 설정

`lib/core/constants/app_constants.dart` 파일에서 API URL 설정:

```dart
static const String baseUrl = 'http://your-api-url';
```

### 3. 앱 실행

```bash
# 연결된 기기 확인
flutter devices

# Android 실행
flutter run

# iOS 실행 (macOS only)
flutter run -d ios

# 웹 실행
flutter run -d chrome
```

---

## 핵심 기능

### 0. 온보딩 플로우 (2026-02-03 업데이트)

앱을 처음 실행하면 6단계 개인화 온보딩이 시작됩니다:

1. **언어 선택** (`language_selection_screen.dart`)
   - 6개 언어 중 선택 (중국어 간체/번체, 한국어, 영어, 일본어, 스페인어)
   - 선택 즉시 앱 전체 언어 변경

2. **소개 화면** (`welcome_introduction_screen.dart`)
   - 앱의 핵심 기능 소개 (오프라인 학습, SRS, 중국어 맞춤)
   - 부드러운 애니메이션

3. **레벨 선택** (`level_selection_screen.dart`)
   - 완전 초보/초급/중급/고급 4단계
   - 레벨에 따른 맞춤 콘텐츠 추천

4. **주간 목표** (`weekly_goal_screen.dart`)
   - 가벼운 (5분)/보통 (15분)/집중 (30분)/프로 (60분)
   - 일일 학습 시간 목표 설정

5. **개인화 완료** (`personalization_complete_screen.dart`)
   - 설정 요약 표시 (언어, 레벨, 목표)
   - 다음 단계로 이동 버튼

6. **계정 선택** (`account_choice_screen.dart`)
   - 로그인 또는 회원가입 선택
   - 기존 계정이 있으면 로그인, 없으면 새 계정 생성

**디자인 시스템:**
- `utils/onboarding_colors.dart` - 토스 스타일 컬러 팔레트
- `utils/onboarding_text_styles.dart` - 일관된 타이포그래피
- `widgets/` - 재사용 가능한 카드 컴포넌트 7개

**Provider 연동:**
- `SettingsProvider.setHasCompletedOnboarding(true)` - 온보딩 완료 상태
- `SettingsProvider.setWeeklyGoal()` - 주간 목표 저장
- `SettingsProvider.setUserLevel()` - 사용자 레벨 저장

---

### Hangul Learning Module (2026-02-03)

Comprehensive Korean alphabet learning system with level-0 roadmap and practice screens.

**Location**: `lib/presentation/screens/hangul/`

**Screens**:
- `hangul_level0_learning_screen.dart` - Level 0 roadmap (0~8 stages) and lesson skeletons
- `hangul_table_screen.dart` - Organized alphabet table (consonants/vowels)
- `hangul_lesson_screen.dart` - Structured sequential lessons
- `hangul_practice_screen.dart` - General character practice
- `hangul_character_detail.dart` - Character details with pronunciation guide
- `hangul_discrimination_screen.dart` - Sound discrimination training
- `hangul_syllable_screen.dart` - Syllable combination practice
- `hangul_batchim_screen.dart` - Final consonant (받침) practice
- `hangul_shadowing_screen.dart` - Pronunciation recording (mobile only, web stub exists)

**Widgets** (`lib/presentation/screens/hangul/widgets/`):
- `pronunciation_player.dart` - Audio playback with speed control (0.5x, 0.75x, 1x, 1.5x)
- `writing_canvas.dart` - Handwriting practice with perfect_freehand
- `mouth_animation_widget.dart` - Mouth shape and tongue position visualization
- `native_comparison_card.dart` - Native language pronunciation comparisons
- `recording_widget.dart` - Audio recording for shadowing practice (mobile only)

**Features**:
- 🌱 Level 0 roadmap with stage-by-stage lesson planning (0~8)
- 🎵 Pronunciation guides with native language comparisons (6 languages)
- 🎨 Visual pronunciation mechanics (mouth shapes, tongue positions, airflow)
- 🎧 Speed-controlled audio playback (0.5x to 1.5x)
- ✍️ Writing practice with stroke guidance (guide → trace → free-write)
- 👂 Sound discrimination training for similar characters (ㄱ/ㅋ, ㅂ/ㅍ, etc.)
- 🔤 Interactive syllable combination tool
- 🗣️ Shadowing mode with self-assessment (mobile only, uses `record` package)
- 📊 Progress tracking for all practice types

**Backend Integration**:
- **9 API endpoints** in Content Service (`/api/content/hangul/*`)
- **6 database tables** for hangul data (characters, guides, syllables, etc.)
- **4-language pronunciation comparisons** (Chinese, English, Japanese, Spanish)
- **SVG assets** for visual pronunciation guides

**New Packages** (2026-02-03):
- `just_audio: ^0.9.36` - Speed-controlled audio playback
- `record: ^5.0.4` - Audio recording (mobile platforms only)
- `audio_waveforms: ^1.0.5` - Waveform visualization during recording
- `perfect_freehand: ^2.3.0` - Smooth handwriting stroke rendering

**Platform Support**:
- ✅ Mobile (Android/iOS): Full support including recording
- ✅ Web: Visual practice only (recording disabled, stub implementations)

---

### App Theme System (2026-02-04)

Dynamic theme loading from backend API for complete app customization.

**Files**:
- `lib/data/models/app_theme_model.dart` (282 lines) - Theme data model
- `lib/presentation/providers/theme_provider.dart` - Theme state management

**Features**:
- 🎨 **Dynamic Color Scheme**: 20+ colors loaded from API
  - Brand colors (primary, secondary, accent)
  - Status colors (error, success, warning, info)
  - Text colors (primary, secondary, hint)
  - Background colors (light, dark, card)
  - Lesson stage colors (7 stages)
- 🖼️ **Remote Logo Loading**: Splash, login, and favicon from server
- 📝 **Custom Font Support**: Google Fonts + custom uploads
- 💾 **Offline Caching**: Hive-based local storage
- 🔄 **Version-Based Cache Invalidation**: Auto-update on theme changes

**Architecture**:
```dart
// Fetch theme from API (public endpoint, no auth)
final theme = await apiClient.getAppTheme();

// Cache locally in Hive
await LocalStorage.saveAppTheme(theme);

// Apply to MaterialApp
ThemeProvider.loadTheme();
```

**Backend Integration**:
- **API Endpoint**: GET `/api/admin/app-theme` (public, no auth required)
- **Cache Storage**: Hive box `appTheme`
- **Update Detection**: Version number comparison
- **Fallback**: Built-in default theme if API unavailable

**Admin Configuration**:
- Managed via Admin Dashboard at `#/app-theme`
- 8 API endpoints for color, logo, and font management
- Real-time preview and version control

**Provider Usage**:
```dart
// Load theme on app start
await ThemeProvider.loadTheme();

// Check for updates
await ThemeProvider.checkForUpdates();

// Access current theme
final theme = ThemeProvider.currentTheme;
```

---

### Level Selector & Learning Path (2026-02-09)

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

### Gamification System (2026-02-10)

Lemon reward system with boss quizzes, lemon tree, and ad integration.

**New Files**:
- `lib/presentation/providers/gamification_provider.dart` - Gamification state management
- `lib/presentation/screens/lesson/boss_quiz_screen.dart` - Boss quiz at end of each week
- `lib/presentation/screens/home/widgets/boss_quiz_node.dart` - Boss quiz node in lesson path
- `lib/presentation/screens/lesson/stages/stage7_summary.dart` - Updated with lemon rewards
- `lib/presentation/screens/profile/widgets/lemon_tree_widget.dart` - Lemon tree visualization
- `lib/core/services/ad_service.dart` - Ad service abstraction
- `lib/core/services/admob_service.dart` - AdMob for mobile
- `lib/core/services/admob_service_web.dart` - Web stub
- `lib/core/services/adsense_service.dart` - AdSense for web

**Features**:
- 🍋 1-3 lemon rewards per lesson based on quiz score
- 🏆 Boss quizzes at end of each week (bonus 5 lemons)
- 🌳 Lemon tree grows with earned lemons, harvest after ad
- 📱 AdMob rewarded ads (mobile), AdSense placeholder (web)
- ⚙️ Admin-configurable thresholds and ad settings

---

### SNS Community (2026-02-10)

Social features: feed, posts, comments, follows, friend search.

**New Files**:
- `lib/presentation/providers/feed_provider.dart` - Feed state management
- `lib/presentation/providers/social_provider.dart` - Social interactions
- `lib/presentation/screens/community/community_screen.dart` - Community feed
- `lib/presentation/screens/community/widgets/` - Post cards, image grid, category filters
- `lib/presentation/screens/create_post/create_post_screen.dart` - Create post with images
- `lib/presentation/screens/post_detail/post_detail_screen.dart` - Post detail with comments
- `lib/presentation/screens/friend_search/friend_search_screen.dart` - User search
- `lib/presentation/screens/user_profile/user_profile_screen.dart` - User profile view

**Features**:
- 📝 Create/delete posts with categories (learning/general)
- 🖼️ Image attachments
- 💬 Comments with nested replies
- ❤️ Like/unlike posts
- 👥 Follow/unfollow users
- 🔍 User search by name
- 🚫 Block/report users
- 🛡️ Admin moderation tools

**Backend**: SNS Service (port 3007) with 21 API endpoints

---

### Direct Messaging (DM) (2026-02-10)

Real-time 1:1 messaging with Socket.IO.

**New Files**:
- `lib/core/services/socket_service.dart` - Socket.IO connection manager (JWT auth, auto-reconnect)
- `lib/presentation/providers/dm_provider.dart` - DM state management
- `lib/presentation/screens/dm/dm_list_screen.dart` - Conversation list
- `lib/presentation/screens/dm/dm_chat_screen.dart` - Chat screen with message bubbles

**Features**:
- 💬 Real-time messaging via Socket.IO (path: `/api/sns/socket.io`)
- 📷 Image and voice message support
- ✅ Read receipts and typing indicators
- 🟢 Online/offline status (Redis TTL 300s)
- 🔔 Unread message count badges
- 🔄 Auto-reconnection on network change
- 🚫 Block check before sending messages

**Message Types**: `text`, `image`, `voice`

**Socket.IO Events**:
- Client → Server: `dm:send_message`, `dm:typing_start/stop`, `dm:mark_read`, `dm:join/leave_conversation`
- Server → Client: `dm:new_message`, `dm:typing`, `dm:read_receipt`, `dm:user_online/offline`

---

### Voice Rooms (2026-02-10)

Voice chat rooms with LiveKit integration (max 4 participants).

**New Files**:
- `lib/presentation/providers/voice_room_provider.dart` - Voice room state management
- `lib/presentation/screens/voice_rooms/voice_room_list_screen.dart` - Room list
- `lib/presentation/screens/voice_rooms/voice_room_screen.dart` - Voice room UI

**Features**:
- 🎤 Real-time voice chat via LiveKit
- 🏠 Create rooms with title, topic, and language level
- 👥 Max 4 participants per room
- 🔇 Mute/unmute toggle
- 📊 Participant list with mute status
- 🚪 Join/leave rooms with token-based auth

**Backend Integration**:
- **7 API endpoints** in SNS Service (`/api/sns/voice-rooms/*`)
- **LiveKit token** generated server-side on join
- **2 database tables**: `voice_rooms`, `voice_room_participants`

**Platform Support**:
- ✅ Mobile (Android): Full LiveKit audio support
- ⚠️ Web: UI only, LiveKit skipped (`kIsWeb` check), no audio

---

### 1. 오프라인 우선 아키텍처

```dart
// 데이터 조회 패턴
Future<Lesson> getLesson(int id) async {
  // 1. 로컬에서 먼저 찾기
  final localLesson = LocalStorage.getLesson(id);
  if (localLesson != null) return localLesson;

  // 2. 네트워크에서 가져오기
  final networkLesson = await apiClient.getLesson(id);

  // 3. 로컬에 저장
  await LocalStorage.saveLesson(networkLesson);

  return networkLesson;
}
```

### 2. 자동 동기화

```dart
// 사용자 동작 → 로컬 저장 → 동기화 큐
await LocalStorage.saveProgress(progress);
await LocalStorage.addToSyncQueue({
  'type': 'lesson_complete',
  'data': progress,
});

// 네트워크 복구 시 자동 동기화
SyncProvider.sync();
```

### 3. 레슨 다운로드

```dart
// 레슨 패키지 다운로드
final package = await apiClient.downloadLessonPackage(lessonId);

// 미디어 파일 다운로드
for (final media in package['media_urls']) {
  await DownloadManager.downloadMedia(media);
}
```

---

## 상태 관리 (Provider)

### AuthProvider
- 로그인/로그아웃
- JWT 토큰 관리
- 사용자 정보

### LessonProvider
- 레슨 목록 조회
- 레슨 상세 정보
- 레슨 다운로드

### ProgressProvider
- 학습 진도 관리
- 레슨 완료 처리
- 복습 스케줄

### SyncProvider
- 오프라인 데이터 동기화
- 네트워크 상태 감지
- 동기화 큐 관리

### DmProvider (2026-02-10)
- Socket.IO 연결 관리
- 대화 목록/메시지 히스토리
- 실시간 메시지 수신/전송
- 읽음 확인, 타이핑 표시
- 안읽은 메시지 카운트

### VoiceRoomProvider (2026-02-10)
- 음성 대화방 목록/상세
- LiveKit 연결 및 토큰 관리
- 방 생성/입장/퇴장
- 뮤트 토글

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

### API 예제

```dart
// 로그인
final response = await apiClient.login(
  email: 'user@example.com',
  password: 'password123',
);

// 레슨 목록
final lessons = await apiClient.getLessons(level: 1);

// 진도 동기화
await apiClient.syncProgress(progressData);
```

---

## 웹 플랫폼 지원 (2026-01-31 추가)

### 개요
Flutter 앱은 웹 플랫폼도 지원합니다. 웹 버전은 브라우저 `localStorage`를 사용하여 모바일과 동일한 오프라인 우선 경험을 제공합니다.

### 웹 스텁 아키텍처

웹 빌드 시 Hive (모바일 전용)를 사용할 수 없으므로, 웹 플랫폼용 스텁을 사용합니다:

**스텁 파일 위치:**
```
lib/core/platform/web/stubs/
├── local_storage_stub.dart      # Hive → localStorage 대체 (562줄, 50+ 메서드)
├── hive_stub.dart               # Hive API 스텁
├── notification_stub.dart       # 알림 스텁 (제한된 기능)
└── secure_storage_web.dart      # 웹 보안 저장소
```

**LocalStorage 웹 스텁 상세:**
- **저장소**: 브라우저 `localStorage` API + JSON 인코딩
- **키 접두사**: `lk_` (예: `lk_setting_chineseVariant`)
- **메서드**: 모바일과 동일한 50+ 정적 메서드 제공
  - Settings (4): getSetting, saveSetting, deleteSetting, clearSettings
  - Lessons (6): saveLesson, getLesson, getAllLessons, hasLesson, deleteLesson, clearLessons
  - Vocabulary (7): 전체 단어 관리 + 레벨별 캐싱
  - Progress (5): 학습 진도 저장/로드
  - Reviews (4): SRS 복습 데이터
  - Bookmarks (9): 북마크 관리
  - Sync Queue (5): 웹에서는 no-op (항상 온라인 가정)
  - User Data (6): 사용자 캐시 및 ID
  - General (3): init, clearAll, close
- **에러 처리**: 모든 메서드에 try-catch, 기본값 반환
- **저장 한계**: 브라우저 localStorage 5-10MB (설정/소규모 데이터에 충분)

### 웹 빌드

```bash
# 웹 앱 빌드
flutter build web

# 빌드 출력: build/web/
# 빌드 시간: ~9-10분
# 최적화:
#   - Icon tree-shaking (99%+ 크기 감소)
#   - JS 압축 및 최적화
```

### 로컬 테스트

```bash
# 개발 모드로 실행
flutter run -d chrome

# 또는 빌드된 웹 앱 서빙
cd build/web
python3 -m http.server 8080

# 브라우저에서 접속
# http://localhost:8080
```

### 프로덕션 배포

**Docker Compose 배포:**
```bash
# 1. 웹 빌드
flutter build web

# 2. Nginx 재시작 (새 빌드 로드)
docker compose restart nginx

# Volume 매핑:
# ./mobile/lemon_korean/build/web:/var/www/lemon_korean_web:ro
```

**배포 URL:**
- **프로덕션**: https://lemon.3chan.kr/app/
- **로컬**: http://localhost/app/
- **Nginx 위치**: `location /app/`

### 웹 앱 검증

```bash
# 브라우저에서 접속 후 DevTools (F12) 확인:

# 1. Console 탭
#    - 에러 없는지 확인
#    - LateInitializationError 없음 확인

# 2. Application → Local Storage
#    - lk_setting_chineseVariant: "simplified"
#    - lk_setting_notificationsEnabled: false
#    - lk_setting_dailyReminderEnabled: true

# 3. 기능 테스트
#    - Settings 변경 후 새로고침 시 유지 확인
#    - 중국어 간체/번체 토글 동작 확인
```

### 웹 vs 모바일 차이점

| 항목 | 모바일 (Hive) | 웹 (localStorage) |
|------|---------------|-------------------|
| 저장 용량 | 무제한 (기기 저장소) | 5-10MB |
| 오프라인 지원 | ✅ 완전 지원 | ❌ 온라인 전용 |
| 동기화 큐 | ✅ 완전 동작 | ⚠️ No-op (즉시 동기화) |
| 미디어 다운로드 | ✅ 지원 | ⚠️ 제한적 |
| 성능 | ⚡ 매우 빠름 | 🔵 빠름 |
| 데이터 지속성 | ✅ 앱 삭제 전까지 | ⚠️ 브라우저 캐시 정리 시 삭제 |

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

### ARB 파일 구조

```json
{
  "@@locale": "zh",
  "appTitle": "柠檬韩语",
  "@appTitle": {
    "description": "应用标题"
  },
  "login": "登录",
  "register": "注册",
  ...
}
```

### 번역 추가하기

```bash
# 1. ARB 파일에 새 키 추가
# lib/l10n/app_zh.arb 등

# 2. 번역 클래스 생성
flutter gen-l10n

# 3. 코드에서 사용
Text(AppLocalizations.of(context)!.appTitle)
```

### 번역 키 수

- **총 키 수**: 206개
- **카테고리**: UI, 레슨, 설정, 오류 메시지, 알림 등

### 언어 변경

```dart
// SettingsProvider에서 언어 변경
context.read<SettingsProvider>().setLanguage('ko');

// 또는 시스템 언어 자동 감지
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
)
```

### 문제 해결

**Q: 웹 빌드 시 LateInitializationError 발생**

A: 웹 스텁이 올바르게 구현되어 있는지 확인:
```dart
// lib/core/platform/web/stubs/local_storage_stub.dart
// 50+ 메서드가 모두 구현되어 있어야 함
```

**Q: localStorage 저장 용량 초과**

A: 브라우저 localStorage는 5-10MB 제한이 있습니다. 큰 데이터는 서버에서 직접 로드하세요:
```dart
// 캐시하지 않고 직접 API 호출
final lesson = await apiClient.getLesson(id);
```

**Q: 웹에서 오프라인 모드 지원**

A: 현재 웹 버전은 온라인 전용입니다. Service Worker 기반 오프라인 지원은 향후 개선 예정입니다.

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

### iOS 빌드

```bash
# Release IPA
flutter build ios --release

# Archive
flutter build ipa
```

---

## 환경 변수

개발/프로덕션 환경별 설정:

```dart
// lib/core/constants/app_constants.dart

// Development
static const String baseUrl = 'http://localhost';

// Production
static const String baseUrl = 'https://api.lemonkorean.com';
```

---

## 디버깅

### 로그 출력

```bash
# 실시간 로그
flutter logs

# 특정 레벨
flutter logs --verbose
```

### DevTools

```bash
# DevTools 실행
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 테스트

### Unit Tests

```bash
flutter test
```

### Widget Tests

```dart
testWidgets('Login button test', (WidgetTester tester) async {
  await tester.pumpWidget(LoginScreen());
  expect(find.text('登录'), findsOneWidget);
});
```

---

## 성능 최적화

### 1. 이미지 캐싱
```dart
CachedNetworkImage(
  imageUrl: imageUrl,
  cacheManager: CacheManager(
    Config('customCacheKey', maxNrOfCacheObjects: 100),
  ),
)
```

### 2. Lazy Loading
```dart
ListView.builder(
  itemCount: lessons.length,
  itemBuilder: (context, index) => LessonCard(lessons[index]),
)
```

### 3. 메모리 관리
```dart
@override
void dispose() {
  controller.dispose();
  subscription.cancel();
  super.dispose();
}
```

---

## 문제 해결

### Q: Pod install 실패 (iOS)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

### Q: Gradle 빌드 실패 (Android)
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### Q: 네트워크 권한 에러 (Android)
`android/app/src/main/AndroidManifest.xml`에 추가:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
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

---

## 연락처

프로젝트 링크: [https://github.com/your-repo/lemon-korean](https://github.com/your-repo/lemon-korean)
