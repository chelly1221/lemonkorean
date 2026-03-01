// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => '레몬 한국어';

  @override
  String get login => '로그인';

  @override
  String get register => '회원가입';

  @override
  String get email => '이메일';

  @override
  String get password => '비밀번호';

  @override
  String get confirmPassword => '비밀번호 확인';

  @override
  String get username => '사용자 이름';

  @override
  String get enterEmail => '이메일 주소를 입력하세요';

  @override
  String get enterPassword => '비밀번호를 입력하세요';

  @override
  String get enterConfirmPassword => '비밀번호를 다시 입력하세요';

  @override
  String get enterUsername => '사용자 이름을 입력하세요';

  @override
  String get createAccount => '계정 만들기';

  @override
  String get startJourney => '한국어 학습 여정을 시작하세요';

  @override
  String get interfaceLanguage => '인터페이스 언어';

  @override
  String get simplifiedChinese => '중국어(간체)';

  @override
  String get traditionalChinese => '중국어(번체)';

  @override
  String get passwordRequirements => '비밀번호 요구사항';

  @override
  String minCharacters(int count) {
    return '최소 $count자 이상';
  }

  @override
  String get containLettersNumbers => '문자와 숫자를 포함해야 합니다';

  @override
  String get haveAccount => '이미 계정이 있으신가요?';

  @override
  String get noAccount => '계정이 없으신가요?';

  @override
  String get loginNow => '로그인하기';

  @override
  String get registerNow => '회원가입하기';

  @override
  String get registerSuccess => '가입 완료';

  @override
  String get registerFailed => '가입 실패';

  @override
  String get loginSuccess => '로그인 성공';

  @override
  String get loginFailed => '로그인 실패';

  @override
  String get networkError => '네트워크 연결에 실패했습니다. 네트워크 설정을 확인해 주세요.';

  @override
  String get invalidCredentials => '이메일 또는 비밀번호가 올바르지 않습니다';

  @override
  String get emailAlreadyExists => '이미 등록된 이메일입니다';

  @override
  String get requestTimeout => '요청 시간이 초과되었습니다. 다시 시도해 주세요.';

  @override
  String get operationFailed => '작업에 실패했습니다. 잠시 후 다시 시도해 주세요.';

  @override
  String get settings => '설정';

  @override
  String get languageSettings => '언어 설정';

  @override
  String get chineseDisplay => '중국어 표시';

  @override
  String get chineseDisplayDesc => '중국어 문자 표시 방식을 선택하세요. 변경 시 즉시 모든 화면에 적용됩니다.';

  @override
  String get switchedToSimplified => '중국어(간체)로 전환되었습니다';

  @override
  String get switchedToTraditional => '중국어(번체)로 전환되었습니다';

  @override
  String get displayTip => '팁: 강의 내용은 선택한 중국어 글꼴로 표시됩니다.';

  @override
  String get notificationSettings => '알림 설정';

  @override
  String get enableNotifications => '알림 사용';

  @override
  String get enableNotificationsDesc => '켜면 학습 알림을 받을 수 있습니다';

  @override
  String get permissionRequired => '시스템 설정에서 알림 권한을 허용해 주세요';

  @override
  String get dailyLearningReminder => '일일 학습 알림';

  @override
  String get dailyReminder => '일일 알림';

  @override
  String get dailyReminderDesc => '매일 정해진 시간에 학습 알림을 보냅니다';

  @override
  String get reminderTime => '알림 시간';

  @override
  String reminderTimeSet(String time) {
    return '알림 시간이 $time으로 설정되었습니다';
  }

  @override
  String get reviewReminder => '복습 알림';

  @override
  String get reviewReminderDesc => '기억 곡선에 따라 복습 알림을 보냅니다';

  @override
  String get notificationTip => '팁:';

  @override
  String get helpCenter => '도움말';

  @override
  String get offlineLearning => '오프라인 학습';

  @override
  String get howToDownload => '강의를 어떻게 다운로드하나요?';

  @override
  String get howToDownloadAnswer =>
      '강의 목록에서 오른쪽의 다운로드 아이콘을 탭하면 강의를 다운로드할 수 있습니다. 다운로드 후 오프라인으로 학습할 수 있습니다.';

  @override
  String get howToUseDownloaded => '다운로드한 강의는 어떻게 사용하나요?';

  @override
  String get howToUseDownloadedAnswer =>
      '네트워크에 연결되어 있지 않아도 다운로드한 강의를 정상적으로 학습할 수 있습니다. 진도는 로컬에 저장되며 네트워크 연결 시 자동으로 동기화됩니다.';

  @override
  String get storageManagement => '저장 공간 관리';

  @override
  String get howToCheckStorage => '저장 공간은 어떻게 확인하나요?';

  @override
  String get howToCheckStorageAnswer =>
      '【설정 → 저장 공간 관리】에서 사용된 저장 공간과 사용 가능한 공간을 확인할 수 있습니다.';

  @override
  String get howToDeleteDownloaded => '다운로드한 강의는 어떻게 삭제하나요?';

  @override
  String get howToDeleteDownloadedAnswer =>
      '【저장 공간 관리】에서 강의 옆의 삭제 버튼을 탭하면 삭제됩니다.';

  @override
  String get notificationSection => '알림 설정';

  @override
  String get howToEnableReminder => '학습 알림은 어떻게 켜나요?';

  @override
  String get howToEnableReminderAnswer =>
      '【설정 → 알림 설정】에서 【알림 사용】 스위치를 켜세요. 처음 사용 시 알림 권한을 허용해야 합니다.';

  @override
  String get whatIsReviewReminder => '복습 알림이란 무엇인가요?';

  @override
  String get whatIsReviewReminderAnswer =>
      '간격 반복 알고리즘(SRS)에 기반하여 학습한 강의를 최적의 시간에 복습하도록 알림을 보냅니다. 복습 간격: 1일 → 3일 → 7일 → 14일 → 30일.';

  @override
  String get languageSection => '언어 설정';

  @override
  String get howToSwitchChinese => '간체와 번체는 어떻게 전환하나요?';

  @override
  String get howToSwitchChineseAnswer =>
      '【설정 → 언어 설정】에서 【중국어(간체)】 또는 【중국어(번체)】를 선택하세요. 변경 시 즉시 적용됩니다.';

  @override
  String get faq => '자주 묻는 질문';

  @override
  String get howToStart => '학습은 어떻게 시작하나요?';

  @override
  String get howToStartAnswer =>
      '메인 화면에서 본인 수준에 맞는 강의를 선택하고 1과부터 시작하세요. 각 강의는 7단계로 구성되어 있습니다.';

  @override
  String get progressNotSaved => '진도가 저장되지 않으면 어떻게 하나요?';

  @override
  String get progressNotSavedAnswer =>
      '진도는 자동으로 로컬에 저장됩니다. 네트워크에 연결되면 서버에 자동으로 동기화됩니다. 네트워크 연결을 확인해 주세요.';

  @override
  String get aboutApp => '앱 정보';

  @override
  String get moreInfo => '추가 정보';

  @override
  String get versionInfo => '버전 정보';

  @override
  String get developer => '개발자';

  @override
  String get appIntro => '앱 소개';

  @override
  String get appIntroContent =>
      '중국어 사용자를 위한 한국어 학습 앱입니다. 오프라인 학습, 스마트 복습 알림 등의 기능을 지원합니다.';

  @override
  String get termsOfService => '서비스 이용약관';

  @override
  String get termsComingSoon => '서비스 이용약관 페이지는 준비 중입니다...';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyComingSoon => '개인정보 처리방침 페이지는 준비 중입니다...';

  @override
  String get openSourceLicenses => '오픈소스 라이선스';

  @override
  String get notStarted => '시작 전';

  @override
  String get inProgress => '진행 중';

  @override
  String get completed => '완료';

  @override
  String get notPassed => '미통과';

  @override
  String get timeToReview => '복습할 시간입니다';

  @override
  String get today => '오늘';

  @override
  String get tomorrow => '내일';

  @override
  String daysLater(int count) {
    return '$count일 후';
  }

  @override
  String get noun => '명사';

  @override
  String get verb => '동사';

  @override
  String get adjective => '형용사';

  @override
  String get adverb => '부사';

  @override
  String get particle => '조사';

  @override
  String get pronoun => '대명사';

  @override
  String get highSimilarity => '높은 유사도';

  @override
  String get mediumSimilarity => '중간 유사도';

  @override
  String get lowSimilarity => '낮은 유사도';

  @override
  String get learningComplete => '학습 완료';

  @override
  String experiencePoints(int points) {
    return '경험치 +$points';
  }

  @override
  String get keepLearning => '학습 열정을 유지하세요';

  @override
  String get streakDays => '연속 학습 +1일';

  @override
  String streakDaysCount(int days) {
    return '연속 $days일 학습 중';
  }

  @override
  String get lessonContent => '이번 강의 학습 내용';

  @override
  String get words => '단어';

  @override
  String get grammarPoints => '문법 포인트';

  @override
  String get dialogues => '대화';

  @override
  String get previous => '이전';

  @override
  String get next => '다음';

  @override
  String get topicParticle => '주제 조사';

  @override
  String get honorificEnding => '존경 어미';

  @override
  String get questionWord => '무엇';

  @override
  String get hello => '안녕하세요';

  @override
  String get thankYou => '감사합니다';

  @override
  String get goodbye => '안녕히 가세요';

  @override
  String get sorry => '죄송합니다';

  @override
  String get imStudent => '저는 학생입니다';

  @override
  String get bookInteresting => '책이 재미있습니다';

  @override
  String get isStudent => '학생입니다';

  @override
  String get isTeacher => '선생님입니다';

  @override
  String get whatIsThis => '이것은 무엇입니까?';

  @override
  String get whatDoingPolite => '뭐 하세요?';

  @override
  String get listenAndChoose => '듣고 올바른 번역을 선택하세요';

  @override
  String get fillInBlank => '올바른 조사를 채워 넣으세요';

  @override
  String get chooseTranslation => '올바른 번역을 선택하세요';

  @override
  String get arrangeWords => '올바른 순서로 단어를 배열하세요';

  @override
  String get choosePronunciation => '올바른 발음을 선택하세요';

  @override
  String get consonantEnding => '명사가 자음으로 끝날 때 어떤 주제 조사를 사용해야 할까요?';

  @override
  String get correctSentence => '올바른 문장을 선택하세요';

  @override
  String get allCorrect => '모두 맞음';

  @override
  String get howAreYou => '잘 지내세요?';

  @override
  String get whatIsYourName => '이름이 뭐예요?';

  @override
  String get whoAreYou => '누구세요?';

  @override
  String get whereAreYou => '어디에 계세요?';

  @override
  String get niceToMeetYou => '만나서 반갑습니다';

  @override
  String get areYouStudent => '당신은 학생입니다';

  @override
  String get areYouStudentQuestion => '학생이에요?';

  @override
  String get amIStudent => '저 학생이에요?';

  @override
  String get listening => '듣기';

  @override
  String get translation => '번역';

  @override
  String get wordOrder => '순서 맞추기';

  @override
  String get excellent => '훌륭합니다!';

  @override
  String get correctOrderIs => '올바른 순서:';

  @override
  String get nextQuestion => '다음 문제';

  @override
  String get finish => '완료';

  @override
  String get quizComplete => '퀴즈 완료!';

  @override
  String get greatJob => '잘했습니다!';

  @override
  String get keepPracticing => '계속 화이팅!';

  @override
  String score(int correct, int total) {
    return '점수: $correct / $total';
  }

  @override
  String get masteredContent => '이 강의 내용을 잘 익혔습니다!';

  @override
  String get reviewSuggestion => '강의 내용을 다시 복습한 후 도전해 보세요!';

  @override
  String timeUsed(String time) {
    return '소요 시간: $time';
  }

  @override
  String get playAudio => '오디오 재생';

  @override
  String get replayAudio => '다시 재생';

  @override
  String get vowelEnding => '모음으로 끝날 때 사용:';

  @override
  String lessonNumber(int number) {
    return '$number과';
  }

  @override
  String get stageIntro => '강의 소개';

  @override
  String get stageVocabulary => '어휘 학습';

  @override
  String get stageGrammar => '문법 설명';

  @override
  String get stagePractice => '연습';

  @override
  String get stageDialogue => '대화 연습';

  @override
  String get stageQuiz => '퀴즈';

  @override
  String get stageSummary => '요약';

  @override
  String get downloadLesson => '강의 다운로드';

  @override
  String get downloading => '다운로드 중...';

  @override
  String get downloaded => '다운로드됨';

  @override
  String get downloadFailed => '다운로드 실패';

  @override
  String get home => '학습';

  @override
  String get lessons => '강의';

  @override
  String get review => '복습';

  @override
  String get profile => '프로필';

  @override
  String get continueLearning => '학습 계속';

  @override
  String get dailyGoal => '일일 목표';

  @override
  String lessonsCompleted(int count) {
    return '$count과 완료';
  }

  @override
  String minutesLearned(int minutes) {
    return '$minutes분 학습';
  }

  @override
  String get welcome => '다시 오신 것을 환영합니다';

  @override
  String get goodMorning => '좋은 아침입니다';

  @override
  String get goodAfternoon => '좋은 오후입니다';

  @override
  String get goodEvening => '좋은 저녁입니다';

  @override
  String get logout => '로그아웃';

  @override
  String get confirmLogout => '정말 로그아웃하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get delete => '삭제';

  @override
  String get save => '저장';

  @override
  String get edit => '편집';

  @override
  String get close => '닫기';

  @override
  String get retry => '재시도';

  @override
  String get loading => '로드 중...';

  @override
  String get noData => '데이터가 없습니다';

  @override
  String get error => '오류가 발생했습니다';

  @override
  String get errorOccurred => '오류가 발생했습니다';

  @override
  String get reload => '다시 불러오기';

  @override
  String get noCharactersAvailable => '사용 가능한 문자가 없습니다';

  @override
  String get success => '성공';

  @override
  String get filter => '필터';

  @override
  String get reviewSchedule => '복습 계획';

  @override
  String get todayReview => '오늘의 복습';

  @override
  String get startReview => '복습 시작';

  @override
  String get learningStats => '학습 통계';

  @override
  String get completedLessonsCount => '완료한 강의';

  @override
  String get studyDays => '학습 일수';

  @override
  String get masteredWordsCount => '습득 단어';

  @override
  String get myVocabularyBook => '나의 단어장';

  @override
  String get vocabularyBrowser => '단어 브라우저';

  @override
  String get about => '정보';

  @override
  String get premiumMember => '프리미엄 회원';

  @override
  String get freeUser => '무료 사용자';

  @override
  String wordsWaitingReview(int count) {
    return '$count개 단어 복습 대기 중';
  }

  @override
  String get user => '사용자';

  @override
  String get onboardingSkip => '건너뛰기';

  @override
  String get onboardingLanguageTitle => '반가워요! 모니라고 해요';

  @override
  String get onboardingLanguagePrompt => '어떤 언어부터 함께 배울까요?';

  @override
  String get onboardingNext => '다음';

  @override
  String get onboardingWelcome => '안녕! 나는 레몬한국어의 레몬이야 🍋\n우리 같이 한국어 공부해볼래?';

  @override
  String get onboardingLevelQuestion => '지금 한국어는 어느 정도야?';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get onboardingStartWithoutLevel => '건너뛰고 시작하기';

  @override
  String get levelBeginner => '입문';

  @override
  String get levelBeginnerDesc => '괜찮아! 한글부터 시작하자';

  @override
  String get levelElementary => '초급';

  @override
  String get levelElementaryDesc => '기초 회화부터 연습하자!';

  @override
  String get levelIntermediate => '중급';

  @override
  String get levelIntermediateDesc => '더 자연스럽게 말해보자!';

  @override
  String get levelAdvanced => '고급';

  @override
  String get levelAdvancedDesc => '디테일한 표현까지 파보자!';

  @override
  String get onboardingWelcomeTitle => '레몬 한국어에 오신 것을 환영합니다!';

  @override
  String get onboardingWelcomeSubtitle => '유창함을 향한 여정이 여기서 시작됩니다';

  @override
  String get onboardingFeature1Title => '언제든지 오프라인 학습';

  @override
  String get onboardingFeature1Desc => '레슨을 다운로드하여 인터넷 없이 학습하세요';

  @override
  String get onboardingFeature2Title => '스마트 복습 시스템';

  @override
  String get onboardingFeature2Desc => 'AI 기반 간격 반복으로 더 나은 기억력';

  @override
  String get onboardingFeature3Title => '7단계 학습 경로';

  @override
  String get onboardingFeature3Desc => '입문부터 고급까지 체계적인 커리큘럼';

  @override
  String get onboardingLevelTitle => '당신의 한국어 수준은?';

  @override
  String get onboardingLevelSubtitle => '맞춤형 경험을 제공해 드립니다';

  @override
  String get onboardingGoalTitle => '주간 목표를 설정하세요';

  @override
  String get onboardingGoalSubtitle => '얼마나 많은 시간을 할애할 수 있나요?';

  @override
  String get goalCasual => '가볍게';

  @override
  String get goalCasualDesc => '주당 1-2과';

  @override
  String get goalCasualTime => '10 - 20분';

  @override
  String get goalCasualHelper => '바쁜 일정에 완벽';

  @override
  String get goalRegular => '규칙적으로';

  @override
  String get goalRegularDesc => '주당 3-4과';

  @override
  String get goalRegularTime => '30 - 40분';

  @override
  String get goalRegularHelper => '부담 없이 꾸준한 진전';

  @override
  String get goalSerious => '열심히';

  @override
  String get goalSeriousDesc => '주당 5-6과';

  @override
  String get goalSeriousTime => '50 - 60분';

  @override
  String get goalSeriousHelper => '빠른 향상을 위한 헌신';

  @override
  String get goalIntensive => '집중적으로';

  @override
  String get goalIntensiveDesc => '매일 연습';

  @override
  String get goalIntensiveTime => '주당 60분 이상';

  @override
  String get goalIntensiveHelper => '최고 학습 속도';

  @override
  String get onboardingCompleteTitle => '모든 준비가 완료되었습니다!';

  @override
  String get onboardingCompleteSubtitle => '학습 여정을 시작해볼까요';

  @override
  String get onboardingSummaryLanguage => '인터페이스 언어';

  @override
  String get onboardingSummaryLevel => '한국어 수준';

  @override
  String get onboardingSummaryGoal => '주간 목표';

  @override
  String get onboardingStartLearning => '학습 시작하기';

  @override
  String get onboardingBack => '뒤로';

  @override
  String get onboardingAccountTitle => '시작할 준비가 되셨나요?';

  @override
  String get onboardingAccountSubtitle => '로그인하거나 계정을 만들어 학습 진도를 저장하세요';

  @override
  String levelTopik(String level) {
    return 'TOPIK $level';
  }

  @override
  String get appLanguage => '앱 언어';

  @override
  String get appLanguageDesc => '앱 인터페이스에 사용할 언어를 선택하세요.';

  @override
  String languageSelected(String language) {
    return '$language 선택됨';
  }

  @override
  String get sort => '정렬';

  @override
  String get notificationTipContent =>
      '• 복습 알림은 레슨 완료 후 자동으로 예약됩니다\n• 일부 기기에서는 시스템 설정에서 절전 모드를 해제해야 알림을 정상적으로 받을 수 있습니다';

  @override
  String get yesterday => '어제';

  @override
  String daysAgo(int count) {
    return '$count일 전';
  }

  @override
  String dateFormat(int month, int day) {
    return '$month월 $day일';
  }

  @override
  String get downloadManager => '다운로드 관리';

  @override
  String get storageInfo => '저장공간 정보';

  @override
  String get clearAllDownloads => '전체 삭제';

  @override
  String get downloadedTab => '다운로드 완료';

  @override
  String get availableTab => '다운로드 가능';

  @override
  String get downloadedLessons => '다운로드한 레슨';

  @override
  String get mediaFiles => '미디어 파일';

  @override
  String get usedStorage => '사용 중';

  @override
  String get cacheStorage => '캐시';

  @override
  String get totalStorage => '총계';

  @override
  String get allDownloadsCleared => '전체 삭제 완료';

  @override
  String get availableStorage => '사용 가능';

  @override
  String get noDownloadedLessons => '다운로드한 레슨이 없습니다';

  @override
  String get goToAvailableTab => '\"다운로드 가능\" 탭에서 레슨을 다운로드하세요';

  @override
  String get allLessonsDownloaded => '모든 레슨이 다운로드되었습니다';

  @override
  String get deleteDownload => '다운로드 삭제';

  @override
  String confirmDeleteDownload(String title) {
    return '\"$title\"을(를) 삭제하시겠습니까?';
  }

  @override
  String confirmClearAllDownloads(int count) {
    return '$count개의 다운로드를 모두 삭제하시겠습니까?';
  }

  @override
  String downloadingCount(int count) {
    return '다운로드 중 ($count)';
  }

  @override
  String get preparing => '준비 중...';

  @override
  String lessonId(int id) {
    return '레슨 $id';
  }

  @override
  String get searchWords => '단어 검색...';

  @override
  String wordCount(int count) {
    return '$count개 단어';
  }

  @override
  String get sortByLesson => '레슨순';

  @override
  String get sortByKorean => '한국어순';

  @override
  String get sortByChinese => '중국어순';

  @override
  String get noWordsFound => '검색 결과 없음';

  @override
  String get noMasteredWords => '습득한 단어가 없습니다';

  @override
  String get hanja => '한자';

  @override
  String get exampleSentence => '예문';

  @override
  String get mastered => '습득 완료';

  @override
  String get completedLessons => '완료한 레슨';

  @override
  String get noCompletedLessons => '완료한 레슨이 없습니다';

  @override
  String get startFirstLesson => '첫 레슨을 시작해보세요!';

  @override
  String get masteredWords => '습득한 단어';

  @override
  String get download => '다운로드';

  @override
  String get hangulLearning => '한글 학습';

  @override
  String get hangulLearningSubtitle => '한글 자모 40자 배우기';

  @override
  String get editNotes => '메모 수정';

  @override
  String get notes => '메모';

  @override
  String get notesHint => '이 단어를 저장하는 이유는?';

  @override
  String get sortBy => '정렬 방식';

  @override
  String get sortNewest => '최신순';

  @override
  String get sortOldest => '오래된순';

  @override
  String get sortKorean => '한국어순';

  @override
  String get sortChinese => '중국어순';

  @override
  String get sortMastery => '숙달도순';

  @override
  String get filterAll => '전체';

  @override
  String get filterNew => '새 단어 (0레벨)';

  @override
  String get filterBeginner => '초급 (1레벨)';

  @override
  String get filterIntermediate => '중급 (2-3레벨)';

  @override
  String get filterAdvanced => '고급 (4-5레벨)';

  @override
  String get searchWordsNotesChinese => '단어, 중국어 또는 메모 검색...';

  @override
  String startReviewCount(int count) {
    return '복습 시작 ($count)';
  }

  @override
  String get remove => '삭제';

  @override
  String get confirmRemove => '삭제 확인';

  @override
  String confirmRemoveWord(String word) {
    return '단어장에서 「$word」를 삭제하시겠습니까?';
  }

  @override
  String get noBookmarkedWords => '저장된 단어가 없습니다';

  @override
  String get bookmarkHint => '학습 중 단어 카드의 북마크 아이콘을 탭하세요';

  @override
  String get noMatchingWords => '일치하는 단어가 없습니다';

  @override
  String weeksAgo(int count) {
    return '$count주 전';
  }

  @override
  String get reviewComplete => '복습 완료!';

  @override
  String reviewCompleteCount(int count) {
    return '$count개 단어 복습 완료';
  }

  @override
  String get correct => '정답';

  @override
  String get wrong => '오답';

  @override
  String get accuracy => '정확도';

  @override
  String get vocabularyBookReview => '단어장 복습';

  @override
  String get noWordsToReview => '복습할 단어가 없습니다';

  @override
  String get bookmarkWordsToReview => '단어를 저장한 후 복습을 시작하세요';

  @override
  String get returnToVocabularyBook => '단어장으로 돌아가기';

  @override
  String get exit => '나가기';

  @override
  String get showAnswer => '정답 보기';

  @override
  String get didYouRemember => '기억했나요?';

  @override
  String get forgot => '잊었음';

  @override
  String get hard => '어려움';

  @override
  String get remembered => '기억함';

  @override
  String get easy => '쉬움';

  @override
  String get addedToVocabularyBook => '단어장에 추가됨';

  @override
  String get addFailed => '추가 실패';

  @override
  String get removedFromVocabularyBook => '단어장에서 삭제됨';

  @override
  String get removeFailed => '삭제 실패';

  @override
  String get addToVocabularyBook => '단어장에 추가';

  @override
  String get notesOptional => '메모 (선택사항)';

  @override
  String get add => '추가';

  @override
  String get bookmarked => '저장됨';

  @override
  String get bookmark => '저장';

  @override
  String get removeFromVocabularyBook => '단어장에서 삭제';

  @override
  String similarityPercent(int percent) {
    return '유사도: $percent%';
  }

  @override
  String addedOrRemoved(String added) {
    String _temp0 = intl.Intl.selectLogic(
      added,
      {
        'true': '단어장에 추가됨',
        'other': '북마크 취소됨',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => '일';

  @override
  String lessonsCompletedCount(int count) {
    return '$count개 완료';
  }

  @override
  String get dailyGoalComplete => '오늘의 목표 달성!';

  @override
  String get hangulAlphabet => '한글';

  @override
  String get alphabetTable => '자모표';

  @override
  String get learn => '학습';

  @override
  String get practice => '연습';

  @override
  String get learningProgress => '학습 진도';

  @override
  String dueForReviewCount(int count) {
    return '$count개 복습 필요';
  }

  @override
  String get completion => '완성도';

  @override
  String get totalCharacters => '전체 글자';

  @override
  String get learned => '학습됨';

  @override
  String get dueForReview => '복습 필요';

  @override
  String overallAccuracy(String percent) {
    return '전체 정확도: $percent%';
  }

  @override
  String charactersCount(int count) {
    return '$count개 글자';
  }

  @override
  String get lesson1Title => '1과: 기본 자음 (상)';

  @override
  String get lesson1Desc => '가장 많이 쓰이는 자음 7개 학습';

  @override
  String get lesson2Title => '2과: 기본 자음 (하)';

  @override
  String get lesson2Desc => '나머지 기본 자음 7개 학습';

  @override
  String get lesson3Title => '3과: 기본 모음 (상)';

  @override
  String get lesson3Desc => '기본 모음 5개 학습';

  @override
  String get lesson4Title => '4과: 기본 모음 (하)';

  @override
  String get lesson4Desc => '나머지 기본 모음 5개 학습';

  @override
  String get lesson5Title => '5과: 쌍자음';

  @override
  String get lesson5Desc => '쌍자음 5개 학습 - 된소리';

  @override
  String get lesson6Title => '6과: 복합 모음 (상)';

  @override
  String get lesson6Desc => '복합 모음 6개 학습';

  @override
  String get lesson7Title => '7과: 복합 모음 (하)';

  @override
  String get lesson7Desc => '나머지 복합 모음 학습';

  @override
  String get loadAlphabetFirst => '먼저 자모표 데이터를 로드하세요';

  @override
  String get noContentForLesson => '이 과에 내용이 없습니다';

  @override
  String get exampleWords => '예시 단어';

  @override
  String get thisLessonCharacters => '이 과의 글자';

  @override
  String congratsLessonComplete(String title) {
    return '$title 완료를 축하합니다!';
  }

  @override
  String get continuePractice => '연습 계속하기';

  @override
  String get nextLesson => '다음 과';

  @override
  String get basicConsonants => '기본 자음';

  @override
  String get doubleConsonants => '쌍자음';

  @override
  String get basicVowels => '기본 모음';

  @override
  String get compoundVowels => '복합 모음';

  @override
  String get dailyLearningReminderTitle => '매일 학습 알림';

  @override
  String get dailyLearningReminderBody => '오늘의 한국어 학습을 완료하세요~';

  @override
  String get reviewReminderTitle => '복습 시간입니다!';

  @override
  String reviewReminderBody(String title) {
    return '「$title」을(를) 복습할 시간입니다~';
  }

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get spanish => 'Español';

  @override
  String get strokeOrder => '획순';

  @override
  String get reset => '초기화';

  @override
  String get pronunciationGuide => '발음 가이드';

  @override
  String get play => '재생';

  @override
  String get pause => '일시정지';

  @override
  String loadingFailed(String error) {
    return '로드 실패: $error';
  }

  @override
  String learnedCount(int count) {
    return '학습: $count';
  }

  @override
  String get hangulPractice => '한글 연습';

  @override
  String charactersNeedReview(int count) {
    return '$count개 글자 복습 필요';
  }

  @override
  String charactersAvailable(int count) {
    return '$count개 글자 연습 가능';
  }

  @override
  String get selectPracticeMode => '연습 모드 선택';

  @override
  String get characterRecognition => '글자 인식';

  @override
  String get characterRecognitionDesc => '글자를 보고 올바른 발음을 선택하세요';

  @override
  String get pronunciationPractice => '발음 연습';

  @override
  String get pronunciationPracticeDesc => '발음을 보고 올바른 글자를 선택하세요';

  @override
  String get startPractice => '연습 시작';

  @override
  String get learnSomeCharactersFirst => '먼저 자모표에서 글자를 학습하세요';

  @override
  String get practiceComplete => '연습 완료!';

  @override
  String get back => '뒤로';

  @override
  String get tryAgain => '다시 하기';

  @override
  String get howToReadThis => '이 글자의 발음은?';

  @override
  String get selectCorrectCharacter => '올바른 글자를 선택하세요';

  @override
  String get correctExclamation => '정답!';

  @override
  String get incorrectExclamation => '오답';

  @override
  String get correctAnswerLabel => '정답: ';

  @override
  String get nextQuestionBtn => '다음 문제';

  @override
  String get viewResults => '결과 보기';

  @override
  String get share => '공유';

  @override
  String get mnemonics => '암기 요령';

  @override
  String nextReviewLabel(String date) {
    return '다음 복습: $date';
  }

  @override
  String get expired => '기한 지남';

  @override
  String get practiceFunctionDeveloping => '연습 기능 개발 중';

  @override
  String get romanization => '로마자: ';

  @override
  String get pronunciationLabel => '발음: ';

  @override
  String get playPronunciation => '발음 재생';

  @override
  String strokesCount(int count) {
    return '$count획';
  }

  @override
  String get perfectCount => '완벽';

  @override
  String get loadFailed => '로드 실패';

  @override
  String countUnit(int count) {
    return '$count개';
  }

  @override
  String get basicConsonantsKo => '기본 자음';

  @override
  String get doubleConsonantsKo => '쌍자음';

  @override
  String get basicVowelsKo => '기본 모음';

  @override
  String get compoundVowelsKo => '복합 모음';

  @override
  String get lesson1TitleKo => '1과: 기본 자음 (상)';

  @override
  String get lesson2TitleKo => '2과: 기본 자음 (하)';

  @override
  String get lesson3TitleKo => '3과: 기본 모음 (상)';

  @override
  String get lesson4TitleKo => '4과: 기본 모음 (하)';

  @override
  String get lesson5TitleKo => '5과: 쌍자음';

  @override
  String get lesson6TitleKo => '6과: 복합 모음 (상)';

  @override
  String get lesson7TitleKo => '7과: 복합 모음 (하)';

  @override
  String get exitLesson => '학습 종료';

  @override
  String get exitLessonConfirm => '정말 현재 과정을 종료하시겠습니까? 진행 상황은 저장됩니다.';

  @override
  String get exitBtn => '종료';

  @override
  String get lessonComplete => '과정 완료! 진행 상황이 저장되었습니다';

  @override
  String loadingLesson(String title) {
    return '$title 로딩 중...';
  }

  @override
  String get cannotLoadContent => '레슨 콘텐츠를 불러올 수 없습니다';

  @override
  String get noLessonContent => '이 과정에는 아직 콘텐츠가 없습니다';

  @override
  String stageProgress(int current, int total) {
    return '$current단계 / $total단계';
  }

  @override
  String unknownStageType(String type) {
    return '알 수 없는 단계 유형: $type';
  }

  @override
  String wordsCount(int count) {
    return '단어 $count개';
  }

  @override
  String get startLearning => '학습 시작';

  @override
  String get vocabularyLearning => '어휘 학습';

  @override
  String get noImage => '이미지 없음';

  @override
  String get previousItem => '이전';

  @override
  String get nextItem => '다음';

  @override
  String get continueBtn => '계속';

  @override
  String get previousQuestion => '이전 문제';

  @override
  String get playingAudio => '재생 중...';

  @override
  String get playAll => '전체 재생';

  @override
  String audioPlayFailed(String error) {
    return '오디오 재생 실패: $error';
  }

  @override
  String get stopBtn => '정지';

  @override
  String get playAudioBtn => '오디오 재생';

  @override
  String get playingAudioShort => '오디오 재생 중...';

  @override
  String get pronunciation => '발음';

  @override
  String grammarPattern(String pattern) {
    return '문법 · $pattern';
  }

  @override
  String get grammarExplanation => '문법 설명';

  @override
  String get conjugationRule => '활용 규칙';

  @override
  String get comparisonWithChinese => '중국어와 비교';

  @override
  String get exampleSentences => '예문';

  @override
  String get dialogueTitle => '대화 연습';

  @override
  String get dialogueExplanation => '대화 해설';

  @override
  String speaker(String name) {
    return '화자 $name';
  }

  @override
  String get practiceTitle => '연습';

  @override
  String get practiceInstructions => '다음 연습 문제를 완료하세요';

  @override
  String get fillBlank => '빈칸 채우기';

  @override
  String get checkAnswerBtn => '정답 확인';

  @override
  String correctAnswerIs(String answer) {
    return '정답: $answer';
  }

  @override
  String get quizTitle => '퀴즈';

  @override
  String get quizResult => '퀴즈 결과';

  @override
  String quizScoreDisplay(int correct, int total) {
    return '$correct/$total';
  }

  @override
  String quizAccuracy(int percent) {
    return '정확도: $percent%';
  }

  @override
  String get summaryTitle => '과정 요약';

  @override
  String get vocabLearned => '학습한 단어';

  @override
  String get grammarLearned => '학습한 문법';

  @override
  String get finishLesson => '과정 완료';

  @override
  String get reviewVocab => '단어 복습';

  @override
  String similarity(int percent) {
    return '유사도: $percent%';
  }

  @override
  String get partOfSpeechNoun => '명사';

  @override
  String get partOfSpeechVerb => '동사';

  @override
  String get partOfSpeechAdjective => '형용사';

  @override
  String get partOfSpeechAdverb => '부사';

  @override
  String get partOfSpeechPronoun => '대명사';

  @override
  String get partOfSpeechParticle => '조사';

  @override
  String get partOfSpeechConjunction => '접속사';

  @override
  String get partOfSpeechInterjection => '감탄사';

  @override
  String get noVocabulary => '단어 데이터가 없습니다';

  @override
  String get noGrammar => '문법 데이터가 없습니다';

  @override
  String get noPractice => '연습 문제가 없습니다';

  @override
  String get noDialogue => '대화 콘텐츠가 없습니다';

  @override
  String get noQuiz => '퀴즈 문제가 없습니다';

  @override
  String get tapToFlip => '탭하여 뒤집기';

  @override
  String get listeningQuestion => '듣기';

  @override
  String get submit => '제출';

  @override
  String timeStudied(String time) {
    return '학습 시간 $time';
  }

  @override
  String get statusNotStarted => '시작 안 함';

  @override
  String get statusInProgress => '진행 중';

  @override
  String get statusCompleted => '완료됨';

  @override
  String get statusFailed => '불합격';

  @override
  String get masteryNew => '새로움';

  @override
  String get masteryLearning => '학습 중';

  @override
  String get masteryFamiliar => '익숙함';

  @override
  String get masteryMastered => '숙달됨';

  @override
  String get masteryExpert => '능숙함';

  @override
  String get masteryPerfect => '완벽함';

  @override
  String get masteryUnknown => '알 수 없음';

  @override
  String get dueForReviewNow => '복습 필요';

  @override
  String get similarityHigh => '높은 유사도';

  @override
  String get similarityMedium => '중간 유사도';

  @override
  String get similarityLow => '낮은 유사도';

  @override
  String get typeBasicConsonant => '기본 자음';

  @override
  String get typeDoubleConsonant => '쌍자음';

  @override
  String get typeBasicVowel => '기본 모음';

  @override
  String get typeCompoundVowel => '복합 모음';

  @override
  String get typeFinalConsonant => '받침';

  @override
  String get dailyReminderChannel => '매일 학습 알림';

  @override
  String get dailyReminderChannelDesc => '매일 정해진 시간에 한국어 학습을 알려줍니다';

  @override
  String get reviewReminderChannel => '복습 알림';

  @override
  String get reviewReminderChannelDesc => '간격 반복 알고리즘 기반 복습 알림';

  @override
  String get notificationStudyTime => '학습 시간이에요!';

  @override
  String get notificationStudyReminder => '오늘의 한국어 학습을 완료하세요~';

  @override
  String get notificationReviewTime => '복습할 시간이에요!';

  @override
  String get notificationReviewReminder => '이전에 배운 내용을 복습해보세요~';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return '「$lessonTitle」을(를) 복습할 시간이에요~';
  }

  @override
  String get keepGoing => '계속 화이팅!';

  @override
  String scoreDisplay(int correct, int total) {
    return '점수: $correct / $total';
  }

  @override
  String loadDataError(String error) {
    return '데이터 로드 실패: $error';
  }

  @override
  String downloadError(String error) {
    return '다운로드 오류: $error';
  }

  @override
  String deleteError(String error) {
    return '삭제 실패: $error';
  }

  @override
  String clearAllError(String error) {
    return '전체 삭제 실패: $error';
  }

  @override
  String cleanupError(String error) {
    return '정리 실패: $error';
  }

  @override
  String downloadLessonFailed(String title) {
    return '다운로드 실패: $title';
  }

  @override
  String get comprehensive => '종합';

  @override
  String answeredCount(int answered, int total) {
    return '답변 $answered/$total';
  }

  @override
  String get hanjaWord => '한자어';

  @override
  String get tapToFlipBack => '뒤집으려면 탭하세요';

  @override
  String get similarityWithChinese => '중국어 유사도';

  @override
  String get hanjaWordSimilarPronunciation => '한자어, 발음이 비슷함';

  @override
  String get sameEtymologyEasyToRemember => '어원이 같아서 외우기 쉬움';

  @override
  String get someConnection => '어느 정도 연관됨';

  @override
  String get nativeWordNeedsMemorization => '고유어, 암기 필요';

  @override
  String get rules => '규칙';

  @override
  String get koreanLanguage => '🇰🇷 한국어';

  @override
  String get chineseLanguage => '🇨🇳 중국어';

  @override
  String exampleNumber(int number) {
    return '예 $number';
  }

  @override
  String get fillInBlankPrompt => '빈칸 채우기:';

  @override
  String get correctFeedback => '훌륭해요! 정답!';

  @override
  String get incorrectFeedback => '다시 생각해 보세요';

  @override
  String get allStagesPassed => '7단계 모두 통과';

  @override
  String get continueToLearnMore => '더 많은 내용 학습';

  @override
  String timeFormatHMS(int hours, int minutes, int seconds) {
    return '$hours시간 $minutes분 $seconds초';
  }

  @override
  String timeFormatMS(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String timeFormatS(int seconds) {
    return '$seconds초';
  }

  @override
  String get repeatEnabled => '반복 재생 켜짐';

  @override
  String get repeatDisabled => '반복 재생 꺼짐';

  @override
  String get stop => '정지';

  @override
  String get playbackSpeed => '재생 속도';

  @override
  String get slowSpeed => '느리게';

  @override
  String get normalSpeed => '보통';

  @override
  String get mouthShape => '입 모양';

  @override
  String get tonguePosition => '혀 위치';

  @override
  String get airFlow => '기류';

  @override
  String get nativeComparison => '모국어 비교';

  @override
  String get similarSounds => '유사음';

  @override
  String get soundDiscrimination => '소리 구분 훈련';

  @override
  String get listenAndSelect => '소리를 듣고 올바른 글자를 선택하세요';

  @override
  String get similarSoundGroups => '유사음 그룹';

  @override
  String get plainSound => '평음';

  @override
  String get aspiratedSound => '격음';

  @override
  String get tenseSound => '경음';

  @override
  String get writingPractice => '쓰기 연습';

  @override
  String get watchAnimation => '획순 애니메이션 보기';

  @override
  String get traceWithGuide => '가이드 따라 쓰기';

  @override
  String get freehandWriting => '자유 쓰기';

  @override
  String get clearCanvas => '지우기';

  @override
  String get showGuide => '가이드 표시';

  @override
  String get hideGuide => '가이드 숨기기';

  @override
  String get writingAccuracy => '정확도';

  @override
  String get tryAgainWriting => '다시 쓰기';

  @override
  String get nextStep => '다음 단계';

  @override
  String strokeOrderStep(int current, int total) {
    return '획순 $current/$total';
  }

  @override
  String get syllableCombination => '음절 조합';

  @override
  String get selectConsonant => '자음 선택';

  @override
  String get selectVowel => '모음 선택';

  @override
  String get selectFinalConsonant => '받침 선택 (선택사항)';

  @override
  String get noFinalConsonant => '받침 없음';

  @override
  String get combinedSyllable => '조합된 음절';

  @override
  String get playSyllable => '음절 듣기';

  @override
  String get decomposeSyllable => '음절 분해';

  @override
  String get batchimPractice => '받침 연습';

  @override
  String get batchimExplanation => '받침 설명';

  @override
  String get recordPronunciation => '발음 녹음';

  @override
  String get startRecording => '녹음 시작';

  @override
  String get stopRecording => '녹음 중지';

  @override
  String get playRecording => '녹음 재생';

  @override
  String get compareWithNative => '원어민 발음과 비교';

  @override
  String get shadowingMode => '쉐도잉 모드';

  @override
  String get listenThenRepeat => '듣고 따라 말하세요';

  @override
  String get selfEvaluation => '자기 평가';

  @override
  String get accurate => '정확함';

  @override
  String get almostCorrect => '거의 맞음';

  @override
  String get needsPractice => '연습 필요';

  @override
  String get recordingNotSupported => '이 플랫폼에서는 녹음이 지원되지 않습니다';

  @override
  String get showMeaning => '뜻 표시';

  @override
  String get hideMeaning => '뜻 숨기기';

  @override
  String get exampleWord => '예시 단어';

  @override
  String get meaningToggle => '뜻 표시 설정';

  @override
  String get microphonePermissionRequired => '녹음을 위해 마이크 권한이 필요합니다';

  @override
  String get activities => '활동';

  @override
  String get listeningAndSpeaking => '듣기 & 말하기';

  @override
  String get readingAndWriting => '읽기 & 쓰기';

  @override
  String get soundDiscriminationDesc => '비슷한 소리 구별 훈련';

  @override
  String get shadowingDesc => '원어민 발음 따라하기';

  @override
  String get syllableCombinationDesc => '자음과 모음 조합 배우기';

  @override
  String get batchimPracticeDesc => '받침 소리 연습';

  @override
  String get writingPracticeDesc => '한글 글자 쓰기 연습';

  @override
  String get webNotSupported => '웹에서 사용 불가';

  @override
  String get chapter => '챕터';

  @override
  String get bossQuiz => '보스 퀴즈';

  @override
  String get bossQuizCleared => '보스 퀴즈 클리어!';

  @override
  String get bossQuizBonus => '보너스 레몬';

  @override
  String get lemonsScoreHint95 => '95% 이상이면 레몬 3개';

  @override
  String get lemonsScoreHint80 => '80% 이상이면 레몬 2개';

  @override
  String get myLemonTree => '나의 레몬 나무';

  @override
  String get harvestLemon => '레몬 수확';

  @override
  String get watchAdToHarvest => '광고를 보고 레몬을 수확하시겠습니까?';

  @override
  String get lemonHarvested => '레몬을 수확했습니다!';

  @override
  String get lemonsAvailable => '개 레몬 수확 가능';

  @override
  String get completeMoreLessons => '레슨을 완료하면 레몬이 자랍니다';

  @override
  String get totalLemons => '총 레몬';

  @override
  String get community => '커뮤니티';

  @override
  String get following => '팔로잉';

  @override
  String get discover => '탐색';

  @override
  String get createPost => '게시글 작성';

  @override
  String get writePost => '무엇이든 나눠보세요...';

  @override
  String get postCategory => '카테고리';

  @override
  String get categoryLearning => '학습';

  @override
  String get categoryGeneral => '일반';

  @override
  String get categoryAll => '전체';

  @override
  String get post => '게시';

  @override
  String get like => '좋아요';

  @override
  String get comment => '댓글';

  @override
  String get writeComment => '댓글을 입력하세요...';

  @override
  String replyingTo(String name) {
    return '$name님에게 답글';
  }

  @override
  String get reply => '답글';

  @override
  String get deletePost => '게시글 삭제';

  @override
  String get deletePostConfirm => '이 게시글을 삭제하시겠습니까?';

  @override
  String get deleteComment => '댓글 삭제';

  @override
  String get postDeleted => '게시글이 삭제되었습니다';

  @override
  String get commentDeleted => '댓글이 삭제되었습니다';

  @override
  String get noPostsYet => '아직 게시글이 없습니다';

  @override
  String get followToSeePosts => '유저를 팔로우하면 게시글이 여기에 표시됩니다';

  @override
  String get discoverPosts => '커뮤니티의 다양한 게시글을 확인하세요';

  @override
  String get seeMore => '더 보기';

  @override
  String get followers => '팔로워';

  @override
  String get followingLabel => '팔로잉';

  @override
  String get posts => '게시글';

  @override
  String get follow => '팔로우';

  @override
  String get unfollow => '언팔로우';

  @override
  String get editProfile => '프로필 수정';

  @override
  String get bio => '자기소개';

  @override
  String get bioHint => '자기소개를 입력하세요...';

  @override
  String get searchUsers => '유저 검색...';

  @override
  String get suggestedUsers => '추천 유저';

  @override
  String get noUsersFound => '유저를 찾을 수 없습니다';

  @override
  String get report => '신고';

  @override
  String get reportContent => '콘텐츠 신고';

  @override
  String get reportReason => '신고 사유를 입력하세요';

  @override
  String get reportSubmitted => '신고가 접수되었습니다';

  @override
  String get blockUser => '유저 차단';

  @override
  String get unblockUser => '차단 해제';

  @override
  String get userBlocked => '유저가 차단되었습니다';

  @override
  String get userUnblocked => '차단이 해제되었습니다';

  @override
  String get postCreated => '게시글이 작성되었습니다!';

  @override
  String likesCount(int count) {
    return '좋아요 $count개';
  }

  @override
  String commentsCount(int count) {
    return '댓글 $count개';
  }

  @override
  String followersCount(int count) {
    return '팔로워 $count명';
  }

  @override
  String followingCount(int count) {
    return '팔로잉 $count명';
  }

  @override
  String get findFriends => '친구 찾기';

  @override
  String get addPhotos => '사진 추가';

  @override
  String maxPhotos(int count) {
    return '최대 $count장까지 가능';
  }

  @override
  String get visibility => '공개 범위';

  @override
  String get visibilityPublic => '전체 공개';

  @override
  String get visibilityFollowers => '팔로워만';

  @override
  String get noFollowingPosts => '팔로우한 유저의 게시글이 아직 없습니다';

  @override
  String get all => '전체';

  @override
  String get learning => '학습';

  @override
  String get general => '일반';

  @override
  String get linkCopied => '링크가 복사되었습니다';

  @override
  String get postFailed => '게시 실패';

  @override
  String get newPost => '새 게시글';

  @override
  String get category => '카테고리';

  @override
  String get writeYourThoughts => '생각을 나눠보세요...';

  @override
  String get photos => '사진';

  @override
  String get addPhoto => '사진 추가';

  @override
  String get imageUrlHint => '이미지 URL을 입력하세요';

  @override
  String get noSuggestions => '추천이 없습니다. 유저를 검색해 보세요!';

  @override
  String get noResults => '유저를 찾을 수 없습니다';

  @override
  String get postDetail => '게시글';

  @override
  String get comments => '댓글';

  @override
  String get noComments => '아직 댓글이 없습니다. 첫 댓글을 남겨보세요!';

  @override
  String get deleteCommentConfirm => '이 댓글을 삭제하시겠습니까?';

  @override
  String get failedToLoadProfile => '프로필을 불러올 수 없습니다';

  @override
  String get userNotFound => '사용자를 찾을 수 없습니다';

  @override
  String get message => '메시지';

  @override
  String get messages => '메시지';

  @override
  String get noMessages => '아직 메시지가 없습니다';

  @override
  String get startConversation => '누군가와 대화를 시작해보세요!';

  @override
  String get noMessagesYet => '아직 메시지가 없습니다. 인사해보세요!';

  @override
  String get typing => '입력 중...';

  @override
  String get typeMessage => '메시지를 입력하세요...';

  @override
  String get createVoiceRoom => '음성 대화방 만들기';

  @override
  String get roomTitle => '방 제목';

  @override
  String get roomTitleHint => '예: 한국어 회화 연습';

  @override
  String get topic => '주제';

  @override
  String get topicHint => '어떤 이야기를 하고 싶으세요?';

  @override
  String get languageLevel => '언어 레벨';

  @override
  String get allLevels => '모든 레벨';

  @override
  String get beginner => '초급';

  @override
  String get intermediate => '중급';

  @override
  String get advanced => '고급';

  @override
  String get stageSlots => '최대 발언자';

  @override
  String get anyoneCanListen => '누구나 청취자로 참여할 수 있습니다';

  @override
  String get createAndJoin => '만들고 참가하기';

  @override
  String get unmute => '음소거 해제';

  @override
  String get mute => '음소거';

  @override
  String get leave => '나가기';

  @override
  String get closeRoom => '방 닫기';

  @override
  String get emojiReaction => '리액션';

  @override
  String get gesture => '제스처';

  @override
  String get raiseHand => '손들기';

  @override
  String get cancelRequest => '취소';

  @override
  String get leaveStage => '스테이지 내리기';

  @override
  String get pendingRequests => '요청';

  @override
  String get typeAMessage => '메시지를 입력하세요...';

  @override
  String get stageRequests => '스테이지 요청';

  @override
  String get noPendingRequests => '대기 중인 요청이 없습니다';

  @override
  String get onStage => '스테이지';

  @override
  String get voiceRooms => '음성 대화방';

  @override
  String get noVoiceRooms => '활성 음성 대화방이 없습니다';

  @override
  String get createVoiceRoomHint => '대화방을 만들어 대화를 시작하세요!';

  @override
  String get createRoom => '방 만들기';

  @override
  String get voiceRoomMicPermission => '음성 대화방을 이용하려면 마이크 권한이 필요합니다';

  @override
  String get voiceRoomEnterTitle => '방 제목을 입력해 주세요';

  @override
  String get voiceRoomCreateFailed => '방 생성에 실패했습니다';

  @override
  String get voiceRoomNotAvailable => '방을 이용할 수 없습니다';

  @override
  String get voiceRoomGoBack => '돌아가기';

  @override
  String get voiceRoomConnecting => '연결 중...';

  @override
  String voiceRoomReconnecting(int attempts, int max) {
    return '재연결 중 ($attempts/$max)...';
  }

  @override
  String get voiceRoomDisconnected => '연결이 끊어졌습니다';

  @override
  String get voiceRoomRetry => '재시도';

  @override
  String get voiceRoomHostLabel => '(호스트)';

  @override
  String get voiceRoomDemoteToListener => '청취자로 내리기';

  @override
  String get voiceRoomKickFromRoom => '방에서 내보내기';

  @override
  String get voiceRoomListeners => '청취자';

  @override
  String get voiceRoomInviteToStage => '스테이지에 초대';

  @override
  String voiceRoomInviteConfirm(String name) {
    return '$name님을 스테이지에 초대할까요?';
  }

  @override
  String get voiceRoomInvite => '초대';

  @override
  String get voiceRoomCloseConfirmTitle => '방을 닫으시겠습니까?';

  @override
  String get voiceRoomCloseConfirmBody => '모든 참가자의 통화가 종료됩니다.';

  @override
  String get voiceRoomNoMessagesYet => '아직 메시지가 없습니다';

  @override
  String get voiceRoomTypeMessage => '메시지를 입력하세요...';

  @override
  String get voiceRoomStageFull => '스테이지 만석';

  @override
  String voiceRoomListenerCount(int count) {
    return '청취자 $count명';
  }

  @override
  String get voiceRoomRemoveFromStage => '스테이지에서 내리기';

  @override
  String voiceRoomRemoveFromStageConfirm(String name) {
    return '$name님을 스테이지에서 내릴까요? 청취자로 전환됩니다.';
  }

  @override
  String get voiceRoomDemote => '내리기';

  @override
  String get voiceRoomRemoveFromRoom => '방에서 내보내기';

  @override
  String voiceRoomRemoveFromRoomConfirm(String name) {
    return '$name님을 방에서 내보낼까요? 연결이 끊어집니다.';
  }

  @override
  String get voiceRoomRemove => '내보내기';

  @override
  String get voiceRoomPressBackToLeave => '한 번 더 누르면 나갑니다';

  @override
  String get voiceRoomLeaveTitle => '방에서 나가시겠습니까?';

  @override
  String get voiceRoomLeaveBody => '현재 스테이지에 있습니다. 정말 나가시겠습니까?';

  @override
  String get voiceRoomReturningToList => '대화방 목록으로 돌아갑니다...';

  @override
  String get voiceRoomConnected => '연결되었습니다!';

  @override
  String get voiceRoomStageFailedToLoad => '스테이지를 불러올 수 없습니다';

  @override
  String get voiceRoomPreparingStage => '스테이지 준비 중...';

  @override
  String voiceRoomAcceptToStage(Object name) {
    return '$name님을 스테이지에 수락';
  }

  @override
  String voiceRoomRejectFromStage(Object name) {
    return '$name님 거절';
  }

  @override
  String get voiceRoomQuickCreate => '빠른 생성';

  @override
  String get voiceRoomRoomType => '방 유형';

  @override
  String get voiceRoomSessionDuration => '세션 시간';

  @override
  String get voiceRoomOptionalTimer => '선택 사항: 세션 타이머';

  @override
  String get voiceRoomDurationNone => '없음';

  @override
  String get voiceRoomDuration15 => '15분';

  @override
  String get voiceRoomDuration30 => '30분';

  @override
  String get voiceRoomDuration45 => '45분';

  @override
  String get voiceRoomDuration60 => '60분';

  @override
  String get voiceRoomTypeFreeTalk => '자유 대화';

  @override
  String get voiceRoomTypePronunciation => '발음 연습';

  @override
  String get voiceRoomTypeRolePlay => '역할극';

  @override
  String get voiceRoomTypeQnA => '질문 & 답변';

  @override
  String get voiceRoomTypeListening => '듣기 연습';

  @override
  String get voiceRoomTypeDebate => '토론';

  @override
  String get voiceRoomTemplateFreeTalk => '한국어 자유 대화';

  @override
  String get voiceRoomTemplatePronunciation => '발음 연습';

  @override
  String get voiceRoomTemplateDailyKorean => '데일리 한국어';

  @override
  String get voiceRoomTemplateTopikSpeaking => 'TOPIK 말하기';

  @override
  String get voiceRoomCreateTooltip => '음성 대화방 만들기';

  @override
  String get voiceRoomSendReaction => '리액션 보내기';

  @override
  String get voiceRoomLeaveRoom => '방 나가기';

  @override
  String get voiceRoomUnmuteMic => '마이크 음소거 해제';

  @override
  String get voiceRoomMuteMic => '마이크 음소거';

  @override
  String get voiceRoomCancelHandRaise => '손들기 취소';

  @override
  String get voiceRoomRaiseHandSemantic => '손들기';

  @override
  String get voiceRoomSendGesture => '제스처 보내기';

  @override
  String get voiceRoomLeaveStageAction => '스테이지 내리기';

  @override
  String get voiceRoomManageStage => '스테이지 관리';

  @override
  String get voiceRoomMoreOptions => '더 보기';

  @override
  String get voiceRoomMore => '더보기';

  @override
  String get voiceRoomStageWithSpeakers => '스피커가 있는 음성 대화 스테이지';

  @override
  String voiceRoomStageRequestsPending(int count) {
    return '스테이지 요청, $count건 대기 중';
  }

  @override
  String voiceRoomSpeakerListenerCount(
      int speakers, int maxSpeakers, int listeners) {
    return '스피커 $speakers/$maxSpeakers명, 청취자 $listeners명';
  }

  @override
  String get voiceRoomChatInput => '채팅 메시지 입력';

  @override
  String get voiceRoomSendMessage => '메시지 보내기';

  @override
  String voiceRoomSendReactionNamed(Object name) {
    return '$name 리액션 보내기';
  }

  @override
  String get voiceRoomCloseReactionTray => '리액션 트레이 닫기';

  @override
  String voiceRoomPerformGesture(Object name) {
    return '$name 제스처 수행';
  }

  @override
  String get voiceRoomCloseGestureTray => '제스처 트레이 닫기';

  @override
  String get voiceRoomGestureWave => '흔들기';

  @override
  String get voiceRoomGestureBow => '인사';

  @override
  String get voiceRoomGestureDance => '춤추기';

  @override
  String get voiceRoomGestureJump => '점프';

  @override
  String get voiceRoomGestureClap => '박수';

  @override
  String get voiceRoomStageLabel => '스테이지';

  @override
  String get voiceRoomYouLabel => '(나)';

  @override
  String voiceRoomListenerTapToManage(Object name) {
    return '청취자 $name, 탭하여 관리';
  }

  @override
  String voiceRoomListenerName(Object name) {
    return '청취자 $name';
  }

  @override
  String get voiceRoomMicPermissionDenied =>
      '마이크 접근이 거부되었습니다. 음성 기능을 사용하려면 기기 설정에서 권한을 활성화해 주세요.';

  @override
  String get voiceRoomMicPermissionTitle => '마이크 권한';

  @override
  String get voiceRoomOpenSettings => '설정 열기';

  @override
  String get voiceRoomMicNeededForStage => '스테이지에서 발언하려면 마이크 권한이 필요합니다';

  @override
  String get batchimDescriptionText =>
      '한국어 받침은 7가지 소리로 발음됩니다.\n여러 받침이 같은 소리로 발음되는 것을 \"받침 대표음\"이라고 합니다.';

  @override
  String get syllableInputLabel => '음절 입력';

  @override
  String get syllableInputHint => '예: 한';

  @override
  String totalPracticedCount(int count) {
    return '총 $count개 글자 연습 완료';
  }

  @override
  String get audioLoadError => '오디오를 불러올 수 없습니다';

  @override
  String get writingPracticeCompleteMessage => '쓰기 연습을 완료했습니다!';

  @override
  String get sevenRepresentativeSounds => '7가지 대표음';

  @override
  String get myRoom => '마이룸';

  @override
  String get characterEditor => '캐릭터 편집';

  @override
  String get roomEditor => '룸 편집';

  @override
  String get shop => '상점';

  @override
  String get character => '캐릭터';

  @override
  String get room => '룸';

  @override
  String get hair => '헤어';

  @override
  String get eyes => '눈';

  @override
  String get brows => '눈썹';

  @override
  String get nose => '코';

  @override
  String get mouth => '입';

  @override
  String get top => '상의';

  @override
  String get bottom => '하의';

  @override
  String get hatItem => '모자';

  @override
  String get accessory => '악세';

  @override
  String get wallpaper => '벽지';

  @override
  String get floorItem => '바닥';

  @override
  String get petItem => '펫';

  @override
  String get none => '없음';

  @override
  String get noItemsYet => '아이템이 없습니다';

  @override
  String get visitShopToGetItems => '상점에서 아이템을 구매하세요!';

  @override
  String get alreadyOwned => '이미 보유 중!';

  @override
  String get buy => '구매';

  @override
  String purchasedItem(String name) {
    return '$name 구매 완료!';
  }

  @override
  String get notEnoughLemons => '레몬이 부족합니다!';

  @override
  String get owned => '보유';

  @override
  String get free => '무료';

  @override
  String get comingSoon => '준비 중!';

  @override
  String balanceLemons(int count) {
    return '잔액: $count 레몬';
  }

  @override
  String get furnitureItem => '가구';

  @override
  String get hangulWelcome => '한글의 세계에 오신 것을 환영합니다!';

  @override
  String get hangulWelcomeDesc => '40개 자모를 하나씩 배워보세요';

  @override
  String get hangulStartLearning => '학습 시작하기';

  @override
  String get hangulLearnNext => '다음 글자 배우기';

  @override
  String hangulLearnedCount(int count) {
    return '$count/40 글자를 배웠어요!';
  }

  @override
  String hangulReviewNeeded(int count) {
    return '오늘 복습할 글자가 $count개 있어요!';
  }

  @override
  String get hangulReviewNow => '지금 복습하기';

  @override
  String get hangulPracticeSuggestion => '거의 다 배웠어요! 활동으로 실력을 다져보세요';

  @override
  String get hangulStartActivities => '활동 시작';

  @override
  String get hangulMastered => '축하합니다! 한글 자모를 마스터했어요!';

  @override
  String get hangulGoToLevel1 => 'Level 1 시작';

  @override
  String get completedLessonsLabel => '완료 레슨';

  @override
  String get wordsLearnedLabel => '습득 단어';

  @override
  String get totalStudyTimeLabel => '학습 시간';

  @override
  String get streakDetails => '연속 학습 기록';

  @override
  String get consecutiveDays => '연속 학습일';

  @override
  String get totalStudyDaysLabel => '총 학습일';

  @override
  String get studyRecord => '학습 기록';

  @override
  String get noFriendsPrompt => '함께 공부할 친구를 찾아보세요!';

  @override
  String get moreStats => '전체 보기';

  @override
  String remainingLessons(int count) {
    return '$count개 더 하면 오늘 목표 달성!';
  }

  @override
  String get streakMotivation0 => '오늘부터 시작해보세요!';

  @override
  String get streakMotivation1 => '좋은 시작이에요! 계속 이어가세요!';

  @override
  String get streakMotivation7 => '일주일 넘게 연속 학습 중! 대단해요!';

  @override
  String get streakMotivation14 => '2주 넘게 꾸준히! 습관이 되고 있어요!';

  @override
  String get streakMotivation30 => '한 달 이상 연속 학습! 진정한 학습자입니다!';

  @override
  String minutesShort(int count) {
    return '$count분';
  }

  @override
  String hoursShort(int count) {
    return '$count시간';
  }

  @override
  String get speechPractice => '발음 연습';

  @override
  String get tapToRecord => '탭하여 녹음';

  @override
  String get recording => '녹음 중...';

  @override
  String get analyzing => '분석 중...';

  @override
  String get pronunciationScore => '발음 점수';

  @override
  String get phonemeBreakdown => '음소별 분석';

  @override
  String tryAgainCount(String current, String max) {
    return '다시 시도 ($current/$max)';
  }

  @override
  String get nextCharacter => '다음 글자';

  @override
  String get excellentPronunciation => '훌륭해요!';

  @override
  String get goodPronunciation => '잘했어요!';

  @override
  String get fairPronunciation => '괜찮아요!';

  @override
  String get needsMorePractice => '더 연습해요!';

  @override
  String get downloadModels => '다운로드';

  @override
  String get modelDownloading => '모델 다운로드 중';

  @override
  String get modelReady => '준비완료';

  @override
  String get modelNotReady => '미설치';

  @override
  String get modelSize => '모델 크기';

  @override
  String get speechModelTitle => '발음 인식 AI 모델';

  @override
  String get skipSpeechPractice => '건너뛰기';

  @override
  String get deleteModel => '모델 삭제';

  @override
  String get overallScore => '종합 점수';

  @override
  String get appTagline => '레몬처럼 상큼하게, 실력은 탄탄하게!';

  @override
  String get passwordHint => '문자와 숫자를 포함한 8자 이상을 입력해주세요';

  @override
  String get findAccount => '아이디찾기';

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String get registerTitle => '상큼한 한국어 여행, 지금 출발!';

  @override
  String get registerSubtitle => '가볍게 출발해도 괜찮아! 내가 꽉 잡아줄게';

  @override
  String get nickname => '별명';

  @override
  String get nicknameHint => '15자 이내로 문자,숫자,밑줄로 입력해주세요';

  @override
  String get confirmPasswordHint => '비밀번호를 한 번 더 입력해주세요';

  @override
  String get accountChoiceTitle => '어서와요! 모니와 함께\n공부 루틴을 만들어볼까요?';

  @override
  String get accountChoiceSubtitle => '상큼하게 시작하고, 실력은 내가 꽉 잡아줄게!';

  @override
  String get startWithEmail => '이메일로 시작하기';

  @override
  String get deleteMessageTitle => '메시지 삭제';

  @override
  String get deleteMessageContent => '이 메시지가 모든 사람에게서 삭제됩니다.';

  @override
  String get messageDeleted => '삭제된 메시지';

  @override
  String get beFirstToPost => '첫 게시글을 올려보세요!';

  @override
  String get typeTagHint => '태그 입력...';

  @override
  String get userInfoLoadFailed => '사용자 정보 로드 실패';

  @override
  String get loginErrorOccurred => '로그인 중 오류가 발생했습니다';

  @override
  String get registerErrorOccurred => '회원가입 중 오류가 발생했습니다';

  @override
  String get logoutErrorOccurred => '로그아웃 중 오류가 발생했습니다';

  @override
  String get hangulStage0Title => '0단계: 한글 구조 이해';

  @override
  String get hangulStage1Title => '1단계: 기본 모음';

  @override
  String get hangulStage2Title => '2단계: Y-모음';

  @override
  String get hangulStage3Title => '3단계: ㅐ/ㅔ 모음';

  @override
  String get hangulStage4Title => '4단계: 기본 자음 1';

  @override
  String get hangulStage5Title => '5단계: 기본 자음 2';

  @override
  String get hangulStage6Title => '6단계: 본격 조합 훈련';

  @override
  String get hangulStage7Title => '7단계: 된소리/거센소리';

  @override
  String get hangulStage8Title => '8단계: 받침(종성) 1차';

  @override
  String get hangulStage9Title => '9단계: 받침 확장';

  @override
  String get hangulStage10Title => '10단계: 복합 받침';

  @override
  String get hangulStage11Title => '11단계: 단어 읽기 확장';

  @override
  String get sortAlphabetical => '알파벳순';

  @override
  String get sortByLevel => '레벨순';

  @override
  String get sortBySimilarity => '유사도순';

  @override
  String get searchWordsKoreanMeaning => '단어 검색 (한국어/뜻)';

  @override
  String get groupedView => '그룹형';

  @override
  String get matrixView => '자음×모음';

  @override
  String get reviewLessons => '복습 레슨';

  @override
  String get stageDetailComingSoon => '상세 내용은 준비 중입니다.';

  @override
  String get bossQuizComingSoon => '보스 퀴즈는 준비 중입니다.';

  @override
  String get exitLessonDialogTitle => '레슨 나가기';

  @override
  String get exitLessonDialogContent => '진행 중인 레슨을 종료하시겠어요?\n현재 단계까지 자동 저장됩니다.';

  @override
  String get continueButton => '계속하기';

  @override
  String get exitLessonButton => '나가기';

  @override
  String get noQuestions => '문제가 없습니다';

  @override
  String get noCharactersDefined => '문자가 정의되지 않았습니다';

  @override
  String get recordingStartFailed => '녹음 시작 실패';

  @override
  String get consonant => '자음';

  @override
  String get vowel => '모음';

  @override
  String get validationEmailRequired => '이메일을 입력하세요';

  @override
  String get validationEmailTooLong => '이메일 주소가 너무 깁니다';

  @override
  String get validationEmailInvalid => '유효한 이메일 주소를 입력하세요';

  @override
  String get validationPasswordRequired => '비밀번호를 입력하세요';

  @override
  String validationPasswordMinLength(int minLength) {
    return '비밀번호는 최소 $minLength자 이상이어야 합니다';
  }

  @override
  String get validationPasswordNeedLetter => '비밀번호에 문자가 포함되어야 합니다';

  @override
  String get validationPasswordNeedNumber => '비밀번호에 숫자가 포함되어야 합니다';

  @override
  String get validationPasswordNeedSpecial => '비밀번호에 특수문자가 포함되어야 합니다';

  @override
  String get validationPasswordTooLong => '비밀번호가 너무 깁니다';

  @override
  String get validationConfirmPasswordRequired => '비밀번호를 다시 입력하세요';

  @override
  String get validationPasswordMismatch => '비밀번호가 일치하지 않습니다';

  @override
  String get validationUsernameRequired => '사용자명을 입력하세요';

  @override
  String validationUsernameTooShort(int minLength) {
    return '사용자명은 최소 $minLength자 이상이어야 합니다';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return '사용자명은 $maxLength자를 초과할 수 없습니다';
  }

  @override
  String get validationUsernameInvalidChars => '사용자명은 문자, 숫자, 밑줄만 포함할 수 있습니다';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldName을(를) 입력하세요';
  }

  @override
  String validationFieldMinLength(String fieldName, int minLength) {
    return '$fieldName은(는) 최소 $minLength자 이상이어야 합니다';
  }

  @override
  String validationFieldMaxLength(String fieldName, int maxLength) {
    return '$fieldName은(는) $maxLength자를 초과할 수 없습니다';
  }

  @override
  String validationFieldNumeric(String fieldName) {
    return '$fieldName은(는) 숫자여야 합니다';
  }

  @override
  String get errorNetworkConnection => '네트워크 연결 실패. 네트워크 설정을 확인하세요';

  @override
  String get errorServer => '서버 오류. 나중에 다시 시도하세요';

  @override
  String get errorAuthFailed => '인증 실패. 다시 로그인하세요';

  @override
  String get errorUnknown => '알 수 없는 오류. 나중에 다시 시도하세요';

  @override
  String get errorTimeout => '연결 시간 초과. 네트워크를 확인하세요';

  @override
  String get errorRequestCancelled => '요청이 취소되었습니다';

  @override
  String get errorForbidden => '접근 권한이 없습니다';

  @override
  String get errorNotFound => '요청한 리소스가 존재하지 않습니다';

  @override
  String get errorRequestParam => '요청 파라미터 오류';

  @override
  String get errorParseData => '데이터 파싱 오류';

  @override
  String get errorParseFormat => '데이터 형식 오류';

  @override
  String get errorRateLimited => '요청이 너무 많습니다. 나중에 다시 시도하세요';

  @override
  String get successLogin => '로그인 성공';

  @override
  String get successRegister => '회원가입 성공';

  @override
  String get successSync => '동기화 성공';

  @override
  String get successDownload => '다운로드 성공';

  @override
  String get failedToCreateComment => '댓글 작성에 실패했습니다';

  @override
  String get failedToDeleteComment => '댓글 삭제에 실패했습니다';

  @override
  String get failedToSubmitReport => '신고 제출에 실패했습니다';

  @override
  String get failedToBlockUser => '사용자 차단에 실패했습니다';

  @override
  String get failedToUnblockUser => '사용자 차단 해제에 실패했습니다';

  @override
  String get failedToCreatePost => '게시물 작성에 실패했습니다';

  @override
  String get failedToDeletePost => '게시물 삭제에 실패했습니다';

  @override
  String noVocabularyForLevel(int level) {
    return '레벨 $level의 단어가 없습니다';
  }

  @override
  String get uploadingImage => '[이미지 업로드 중...]';

  @override
  String get uploadingVoice => '[음성 업로드 중...]';

  @override
  String get imagePreview => '[이미지]';

  @override
  String get voicePreview => '[음성]';

  @override
  String get voiceServerConnectFailed => '음성 서버에 연결할 수 없습니다. 연결을 확인하세요.';

  @override
  String get connectionLostRetry => '연결이 끊어졌습니다. 탭하여 재시도하세요.';

  @override
  String get noInternetConnection => '인터넷에 연결되어 있지 않습니다. 네트워크를 확인하세요.';

  @override
  String get couldNotLoadRooms => '방 목록을 불러올 수 없습니다. 다시 시도하세요.';

  @override
  String get couldNotCreateRoom => '방을 만들 수 없습니다. 다시 시도하세요.';

  @override
  String get couldNotJoinRoom => '방에 참가할 수 없습니다. 연결을 확인하세요.';

  @override
  String get roomClosedByHost => '호스트가 방을 닫았습니다.';

  @override
  String get removedFromRoomByHost => '호스트에 의해 방에서 제거되었습니다.';

  @override
  String get connectionTimedOut => '연결 시간이 초과되었습니다. 다시 시도해 주세요.';

  @override
  String get missingLiveKitCredentials => '음성 연결 자격 증명이 없습니다.';

  @override
  String get microphoneEnableFailed =>
      '마이크를 활성화할 수 없습니다. 권한을 확인하고 음소거 해제를 시도하세요.';

  @override
  String get voiceRoomNewMessages => '새 메시지';

  @override
  String get voiceRoomChatRateLimited => '메시지를 너무 빨리 보내고 있습니다. 잠시 기다려 주세요.';

  @override
  String get voiceRoomMessageSendFailed => '메시지 전송에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get voiceRoomChatError => '채팅 오류가 발생했습니다.';

  @override
  String retryAttempt(int current, int max) {
    return '다시 시도 ($current/$max)';
  }

  @override
  String get nextButton => '다음';

  @override
  String get completeButton => '완료';

  @override
  String get startButton => '시작하기';

  @override
  String get doneButton => '완료';

  @override
  String get goBackButton => '돌아가기';

  @override
  String get tapToListen => '탭하여 소리 듣기';

  @override
  String get listenAllSoundsFirst => '모든 소리를 들어보세요';

  @override
  String get nextCharButton => '다음 글자';

  @override
  String get listenAndChooseCorrect => '소리를 듣고 맞는 글자를 고르세요';

  @override
  String get lessonCompletedMsg => '레슨을 완료했어요!';

  @override
  String stageMasterLabel(int stage) {
    return '$stage단계 마스터';
  }

  @override
  String get hangulS0L0Title => '한글은 어떻게 생겼을까요?';

  @override
  String get hangulS0L0Subtitle => '한글이 만들어진 과정을 짧게 알아봐요';

  @override
  String get hangulS0L0Step0Title => '옛날에는 글을 배우기 어려웠어요';

  @override
  String get hangulS0L0Step0Desc =>
      '예전에는 한자를 중심으로 글을 썼기 때문에\n많은 사람들이 읽고 쓰기 어려웠어요.';

  @override
  String get hangulS0L0Step0Highlights => '한자,어려움,읽기,쓰기';

  @override
  String get hangulS0L0Step1Title => '세종대왕이 새 글자를 만들었어요';

  @override
  String get hangulS0L0Step1Desc =>
      '백성이 쉽게 배우도록\n세종대왕이 직접 훈민정음을 만들었어요.\n(1443년 창제, 1446년 반포)';

  @override
  String get hangulS0L0Step1Highlights => '세종대왕,훈민정음,1443,1446';

  @override
  String get hangulS0L0Step2Title => '그래서 지금의 한글이 되었어요';

  @override
  String get hangulS0L0Step2Desc =>
      '한글은 소리를 쉽게 적을 수 있게 만든 글자예요.\n이제 다음 레슨에서 자음과 모음 구조를 배워볼게요.';

  @override
  String get hangulS0L0Step2Highlights => '소리,쉬운 글자,한글';

  @override
  String get hangulS0L0SummaryTitle => '소개 레슨 완료!';

  @override
  String get hangulS0L0SummaryMsg =>
      '좋아요!\n한글이 왜 만들어졌는지 알았어요.\n이제 자음/모음 구조를 배워볼게요.';

  @override
  String get hangulS0L1Title => '가 블록 조립하기';

  @override
  String get hangulS0L1Subtitle => '보면서 조립하기 (시각 중심)';

  @override
  String get hangulS0L1IntroTitle => '한글은 블록이에요!';

  @override
  String get hangulS0L1IntroDesc =>
      '한글은 자음과 모음을 합쳐서 글자를 만들어요.\n자음(ㄱ) + 모음(ㅏ) = 가\n\n더 복잡한 글자는 아래에 받침이 들어가기도 해요.\n(나중에 배울 거예요!)';

  @override
  String get hangulS0L1IntroHighlights => '자음,모음,글자';

  @override
  String get hangulS0L1DragGaTitle => '가 조립하기';

  @override
  String get hangulS0L1DragGaDesc => 'ㄱ과 ㅏ를 빈 칸에 끌어다 놓으세요';

  @override
  String get hangulS0L1DragNaTitle => '나 조립하기';

  @override
  String get hangulS0L1DragNaDesc => '새로운 자음 ㄴ을 사용해보세요';

  @override
  String get hangulS0L1DragDaTitle => '다 조립하기';

  @override
  String get hangulS0L1DragDaDesc => '새로운 자음 ㄷ을 사용해보세요';

  @override
  String get hangulS0L1SummaryTitle => '레슨 완료!';

  @override
  String get hangulS0L1SummaryMsg => '자음 + 모음 = 글자 블록!\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다';

  @override
  String get hangulS0L2Title => '소리 탐색';

  @override
  String get hangulS0L2Subtitle => '소리로 자음과 모음 느끼기';

  @override
  String get hangulS0L2IntroTitle => '소리를 느껴보세요';

  @override
  String get hangulS0L2IntroDesc =>
      '한글의 자음과 모음은 각각 고유한 소리를 가지고 있어요.\n소리를 듣고 느껴보세요.';

  @override
  String get hangulS0L2Sound1Title => 'ㄱ, ㄴ, ㄷ 자음 기준 소리';

  @override
  String get hangulS0L2Sound1Desc => 'ㅏ를 붙인 기준 소리(가, 나, 다)를 들어보세요';

  @override
  String get hangulS0L2Sound2Title => 'ㅏ, ㅗ 모음 소리';

  @override
  String get hangulS0L2Sound2Desc => '두 모음의 소리를 들어보세요';

  @override
  String get hangulS0L2Sound3Title => '가, 나, 다 소리 듣기';

  @override
  String get hangulS0L2Sound3Desc => '자음과 모음이 합쳐진 글자의 소리를 들어보세요';

  @override
  String get hangulS0L2SummaryTitle => '레슨 완료!';

  @override
  String get hangulS0L2SummaryMsg =>
      '자음은 ㅏ를 붙인 기준 소리(가, 나, 다)로,\n모음은 그대로 소리를 느낄 수 있게 되었어요!';

  @override
  String get hangulS0L3Title => '듣고 고르기';

  @override
  String get hangulS0L3Subtitle => '소리를 듣고 글자를 구분해요';

  @override
  String get hangulS0L3IntroTitle => '이번엔 귀로 구분해요';

  @override
  String get hangulS0L3IntroDesc => '화면보다 소리에 집중해서\n같은 소리와 다른 소리를 찾아보세요.';

  @override
  String get hangulS0L3Sound1Title => '가/나/다/고/노 소리 확인';

  @override
  String get hangulS0L3Sound1Desc => '먼저 5개 소리를 충분히 들어보세요';

  @override
  String get hangulS0L3Match1Title => '소리 듣고 같은 글자 고르기';

  @override
  String get hangulS0L3Match1Desc => '재생된 소리와 같은 글자를 고르세요';

  @override
  String get hangulS0L3Match2Title => 'ㅏ / ㅗ 소리 구분';

  @override
  String get hangulS0L3Match2Desc => '비슷한 자음에서 모음 소리를 구분해보세요';

  @override
  String get hangulS0L3SummaryTitle => '레슨 완료!';

  @override
  String get hangulS0L3SummaryMsg =>
      '좋아요!\n이제 눈(조립)과 귀(소리)를 함께 써서\n한글 구조를 이해할 수 있어요.';

  @override
  String get hangulS0CompleteTitle => 'Stage 0 완료!';

  @override
  String get hangulS0CompleteMsg => '한글의 구조를 이해했어요!';

  @override
  String get hangulS1L1Title => 'ㅏ 모양과 소리';

  @override
  String get hangulS1L1Subtitle => '세로선 오른쪽 짧은 획: ㅏ';

  @override
  String get hangulS1L1Step0Title => '첫 모음 ㅏ를 배워요';

  @override
  String get hangulS1L1Step0Desc => 'ㅏ는 밝은 소리 \"아\"를 만들어요.\n모양과 소리를 함께 익혀볼게요.';

  @override
  String get hangulS1L1Step0Highlights => 'ㅏ,아,기본 모음';

  @override
  String get hangulS1L1Step1Title => 'ㅏ 소리 듣기';

  @override
  String get hangulS1L1Step1Desc => 'ㅏ가 들어간 소리를 들어보세요';

  @override
  String get hangulS1L1Step2Title => '발음 연습';

  @override
  String get hangulS1L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L1Step3Title => 'ㅏ 소리 고르기';

  @override
  String get hangulS1L1Step3Desc => '소리를 듣고 맞는 글자를 선택하세요';

  @override
  String get hangulS1L1Step4Title => '모양 퀴즈';

  @override
  String get hangulS1L1Step4Desc => 'ㅏ를 정확히 찾아보세요';

  @override
  String get hangulS1L1Step4Q0 => '다음 중 ㅏ는?';

  @override
  String get hangulS1L1Step4Q1 => '다음 중 ㅏ가 들어간 것은?';

  @override
  String get hangulS1L1Step4Q2 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step5Title => 'ㅏ로 글자 만들기';

  @override
  String get hangulS1L1Step5Desc => '자음과 ㅏ를 합쳐 글자를 완성하세요';

  @override
  String get hangulS1L1Step6Title => '종합 퀴즈';

  @override
  String get hangulS1L1Step6Desc => '이번 레슨 내용을 정리해요';

  @override
  String get hangulS1L1Step6Q0 => '\"아\"의 모음은?';

  @override
  String get hangulS1L1Step6Q1 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step6Q2 => '다음 중 ㅏ가 들어간 글자는?';

  @override
  String get hangulS1L1Step6Q3 => 'ㅏ와 가장 다른 소리는?';

  @override
  String get hangulS1L1Step7Title => '레슨 완료!';

  @override
  String get hangulS1L1Step7Msg => '좋아요!\nㅏ 모양과 소리를 익혔어요.';

  @override
  String get hangulS1L2Title => 'ㅓ 모양과 소리';

  @override
  String get hangulS1L2Subtitle => '세로선 왼쪽 짧은 획: ㅓ';

  @override
  String get hangulS1L2Step0Title => '두 번째 모음 ㅓ';

  @override
  String get hangulS1L2Step0Desc =>
      'ㅓ는 \"어\" 소리를 만들어요.\nㅏ와 획 방향이 반대라는 점이 중요해요.';

  @override
  String get hangulS1L2Step0Highlights => 'ㅓ,어,ㅏ와 방향 반대';

  @override
  String get hangulS1L2Step1Title => 'ㅓ 소리 듣기';

  @override
  String get hangulS1L2Step1Desc => 'ㅓ가 들어간 소리를 들어보세요';

  @override
  String get hangulS1L2Step2Title => '발음 연습';

  @override
  String get hangulS1L2Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L2Step3Title => 'ㅓ 소리 고르기';

  @override
  String get hangulS1L2Step3Desc => 'ㅏ/ㅓ를 귀로 구분해요';

  @override
  String get hangulS1L2Step4Title => '모양 퀴즈';

  @override
  String get hangulS1L2Step4Desc => 'ㅓ를 찾아보세요';

  @override
  String get hangulS1L2Step4Q0 => '다음 중 ㅓ는?';

  @override
  String get hangulS1L2Step4Q1 => 'ㅇ + ㅓ = ?';

  @override
  String get hangulS1L2Step4Q2 => '다음 중 ㅓ가 들어간 글자는?';

  @override
  String get hangulS1L2Step5Title => 'ㅓ로 글자 만들기';

  @override
  String get hangulS1L2Step5Desc => '자음과 ㅓ를 합쳐 보세요';

  @override
  String get hangulS1L2Step6Title => '레슨 완료!';

  @override
  String get hangulS1L2Step6Msg => '훌륭해요!\nㅓ(어) 소리를 익혔어요.';

  @override
  String get hangulS1L3Title => 'ㅗ 모양과 소리';

  @override
  String get hangulS1L3Subtitle => '가로선 위로 세로획: ㅗ';

  @override
  String get hangulS1L3Step0Title => '세 번째 모음 ㅗ';

  @override
  String get hangulS1L3Step0Desc => 'ㅗ는 \"오\" 소리를 만들어요.\n가로선 위로 세로획이 올라옵니다.';

  @override
  String get hangulS1L3Step0Highlights => 'ㅗ,오,가로형 모음';

  @override
  String get hangulS1L3Step1Title => 'ㅗ 소리 듣기';

  @override
  String get hangulS1L3Step1Desc => 'ㅗ가 들어간 소리(오/고/노)를 들어보세요';

  @override
  String get hangulS1L3Step2Title => '발음 연습';

  @override
  String get hangulS1L3Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L3Step3Title => 'ㅗ 소리 고르기';

  @override
  String get hangulS1L3Step3Desc => '오/우 소리를 구분해요';

  @override
  String get hangulS1L3Step4Title => 'ㅗ로 글자 만들기';

  @override
  String get hangulS1L3Step4Desc => '자음과 ㅗ를 합쳐 보세요';

  @override
  String get hangulS1L3Step5Title => '모양/소리 퀴즈';

  @override
  String get hangulS1L3Step5Desc => 'ㅗ를 정확히 선택해요';

  @override
  String get hangulS1L3Step5Q0 => '다음 중 ㅗ는?';

  @override
  String get hangulS1L3Step5Q1 => 'ㅇ + ㅗ = ?';

  @override
  String get hangulS1L3Step5Q2 => '다음 중 ㅗ가 들어간 것은?';

  @override
  String get hangulS1L3Step6Title => '레슨 완료!';

  @override
  String get hangulS1L3Step6Msg => '좋아요!\nㅗ(오) 소리를 익혔어요.';

  @override
  String get hangulS1L4Title => 'ㅜ 모양과 소리';

  @override
  String get hangulS1L4Subtitle => '가로선 아래로 세로획: ㅜ';

  @override
  String get hangulS1L4Step0Title => '네 번째 모음 ㅜ';

  @override
  String get hangulS1L4Step0Desc => 'ㅜ는 \"우\" 소리를 만들어요.\nㅗ와는 세로획 위치가 반대예요.';

  @override
  String get hangulS1L4Step0Highlights => 'ㅜ,우,ㅗ와 위치 비교';

  @override
  String get hangulS1L4Step1Title => 'ㅜ 소리 듣기';

  @override
  String get hangulS1L4Step1Desc => '우/구/누를 들어보세요';

  @override
  String get hangulS1L4Step2Title => '발음 연습';

  @override
  String get hangulS1L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L4Step3Title => 'ㅜ 소리 고르기';

  @override
  String get hangulS1L4Step3Desc => 'ㅗ/ㅜ를 구분해요';

  @override
  String get hangulS1L4Step4Title => 'ㅜ로 글자 만들기';

  @override
  String get hangulS1L4Step4Desc => '자음과 ㅜ를 합쳐 보세요';

  @override
  String get hangulS1L4Step5Title => '모양/소리 퀴즈';

  @override
  String get hangulS1L4Step5Desc => 'ㅜ를 정확히 선택해요';

  @override
  String get hangulS1L4Step5Q0 => '다음 중 ㅜ는?';

  @override
  String get hangulS1L4Step5Q1 => 'ㅇ + ㅜ = ?';

  @override
  String get hangulS1L4Step5Q2 => '다음 중 ㅜ가 들어간 것은?';

  @override
  String get hangulS1L4Step6Title => '레슨 완료!';

  @override
  String get hangulS1L4Step6Msg => '좋아요!\nㅜ(우) 소리를 익혔어요.';

  @override
  String get hangulS1L5Title => 'ㅡ 모양과 소리';

  @override
  String get hangulS1L5Subtitle => '가로 한 줄 모음: ㅡ';

  @override
  String get hangulS1L5Step0Title => '다섯 번째 모음 ㅡ';

  @override
  String get hangulS1L5Step0Desc => 'ㅡ는 입을 옆으로 당겨 내는 소리예요.\n모양은 가로 한 줄입니다.';

  @override
  String get hangulS1L5Step0Highlights => 'ㅡ,으,가로 한 줄';

  @override
  String get hangulS1L5Step1Title => 'ㅡ 소리 듣기';

  @override
  String get hangulS1L5Step1Desc => '으/그/느 소리를 들어보세요';

  @override
  String get hangulS1L5Step2Title => '발음 연습';

  @override
  String get hangulS1L5Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L5Step3Title => 'ㅡ 소리 고르기';

  @override
  String get hangulS1L5Step3Desc => 'ㅡ와 ㅜ 소리를 구분해요';

  @override
  String get hangulS1L5Step4Title => 'ㅡ로 글자 만들기';

  @override
  String get hangulS1L5Step4Desc => '자음과 ㅡ를 합쳐 보세요';

  @override
  String get hangulS1L5Step5Title => '모양/소리 퀴즈';

  @override
  String get hangulS1L5Step5Desc => 'ㅡ를 정확히 선택해요';

  @override
  String get hangulS1L5Step5Q0 => '다음 중 ㅡ는?';

  @override
  String get hangulS1L5Step5Q1 => 'ㅇ + ㅡ = ?';

  @override
  String get hangulS1L5Step5Q2 => '다음 중 ㅡ가 들어간 것은?';

  @override
  String get hangulS1L5Step6Title => '레슨 완료!';

  @override
  String get hangulS1L5Step6Msg => '좋아요!\nㅡ(으) 소리를 익혔어요.';

  @override
  String get hangulS1L6Title => 'ㅣ 모양과 소리';

  @override
  String get hangulS1L6Subtitle => '세로 한 줄 모음: ㅣ';

  @override
  String get hangulS1L6Step0Title => '여섯 번째 모음 ㅣ';

  @override
  String get hangulS1L6Step0Desc => 'ㅣ는 \"이\" 소리를 만들어요.\n모양은 세로 한 줄입니다.';

  @override
  String get hangulS1L6Step0Highlights => 'ㅣ,이,세로 한 줄';

  @override
  String get hangulS1L6Step1Title => 'ㅣ 소리 듣기';

  @override
  String get hangulS1L6Step1Desc => '이/기/니 소리를 들어보세요';

  @override
  String get hangulS1L6Step2Title => '발음 연습';

  @override
  String get hangulS1L6Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L6Step3Title => 'ㅣ 소리 고르기';

  @override
  String get hangulS1L6Step3Desc => 'ㅣ와 ㅡ 소리를 구분해요';

  @override
  String get hangulS1L6Step4Title => 'ㅣ로 글자 만들기';

  @override
  String get hangulS1L6Step4Desc => '자음과 ㅣ를 합쳐 보세요';

  @override
  String get hangulS1L6Step5Title => '모양/소리 퀴즈';

  @override
  String get hangulS1L6Step5Desc => 'ㅣ를 정확히 선택해요';

  @override
  String get hangulS1L6Step5Q0 => '다음 중 ㅣ는?';

  @override
  String get hangulS1L6Step5Q1 => 'ㅇ + ㅣ = ?';

  @override
  String get hangulS1L6Step5Q2 => '다음 중 ㅣ가 들어간 것은?';

  @override
  String get hangulS1L6Step6Title => '레슨 완료!';

  @override
  String get hangulS1L6Step6Msg => '좋아요!\nㅣ(이) 소리를 익혔어요.';

  @override
  String get hangulS1L7Title => '세로 모음 구분';

  @override
  String get hangulS1L7Subtitle => 'ㅏ · ㅓ · ㅣ 빠르게 구분하기';

  @override
  String get hangulS1L7Step0Title => '세로 모음 묶음 복습';

  @override
  String get hangulS1L7Step0Desc => 'ㅏ, ㅓ, ㅣ는 세로축 모음이에요.\n획 위치와 소리를 함께 구분해요.';

  @override
  String get hangulS1L7Step0Highlights => 'ㅏ,ㅓ,ㅣ,세로 모음';

  @override
  String get hangulS1L7Step1Title => '소리 한 번씩 다시 듣기';

  @override
  String get hangulS1L7Step1Desc => '아/어/이 소리를 확인해요';

  @override
  String get hangulS1L7Step2Title => '발음 연습';

  @override
  String get hangulS1L7Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L7Step3Title => '세로 모음 듣기 퀴즈';

  @override
  String get hangulS1L7Step3Desc => '소리와 글자를 연결하세요';

  @override
  String get hangulS1L7Step4Title => '세로 모음 모양 퀴즈';

  @override
  String get hangulS1L7Step4Desc => '모양도 정확히 구분해요';

  @override
  String get hangulS1L7Step4Q0 => '오른쪽 짧은 획은?';

  @override
  String get hangulS1L7Step4Q1 => '왼쪽 짧은 획은?';

  @override
  String get hangulS1L7Step4Q2 => '세로 한 줄은?';

  @override
  String get hangulS1L7Step4Q3 => 'ㄴ + ㅓ = ?';

  @override
  String get hangulS1L7Step4Q4 => 'ㄱ + ㅣ = ?';

  @override
  String get hangulS1L7Step5Title => '레슨 완료!';

  @override
  String get hangulS1L7Step5Msg => '좋아요!\n세로 모음(ㅏ/ㅓ/ㅣ) 구분이 안정됐어요.';

  @override
  String get hangulS1L8Title => '가로 모음 구분';

  @override
  String get hangulS1L8Subtitle => 'ㅗ · ㅜ · ㅡ 빠르게 구분하기';

  @override
  String get hangulS1L8Step0Title => '가로 모음 묶음 복습';

  @override
  String get hangulS1L8Step0Desc =>
      'ㅗ, ㅜ, ㅡ는 가로축 중심 모음이에요.\n세로획 위치와 입모양을 함께 기억해요.';

  @override
  String get hangulS1L8Step0Highlights => 'ㅗ,ㅜ,ㅡ,가로 모음';

  @override
  String get hangulS1L8Step1Title => '소리 한 번씩 다시 듣기';

  @override
  String get hangulS1L8Step1Desc => '오/우/으 소리를 확인해요';

  @override
  String get hangulS1L8Step2Title => '발음 연습';

  @override
  String get hangulS1L8Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L8Step3Title => '가로 모음 듣기 퀴즈';

  @override
  String get hangulS1L8Step3Desc => '소리와 글자를 연결하세요';

  @override
  String get hangulS1L8Step4Title => '가로 모음 모양 퀴즈';

  @override
  String get hangulS1L8Step4Desc => '모양과 소리를 같이 점검해요';

  @override
  String get hangulS1L8Step4Q0 => '가로선 위로 세로획은?';

  @override
  String get hangulS1L8Step4Q1 => '가로선 아래로 세로획은?';

  @override
  String get hangulS1L8Step4Q2 => '가로 한 줄은?';

  @override
  String get hangulS1L8Step4Q3 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS1L8Step4Q4 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS1L8Step5Title => '레슨 완료!';

  @override
  String get hangulS1L8Step5Msg => '좋아요!\n가로 모음(ㅗ/ㅜ/ㅡ) 구분이 안정됐어요.';

  @override
  String get hangulS1L9Title => '기본 모음 미션';

  @override
  String get hangulS1L9Subtitle => '시간 안에 모음 조합 완성하기';

  @override
  String get hangulS1L9Step0Title => '1단계 최종 미션';

  @override
  String get hangulS1L9Step0Desc =>
      '제한시간 안에 글자 조합을 완성해요.\n정확도와 속도로 레몬 보상을 받아요!';

  @override
  String get hangulS1L9Step1Title => '타임 미션';

  @override
  String get hangulS1L9Step2Title => '미션 결과';

  @override
  String get hangulS1L9Step3Title => '1단계 완료!';

  @override
  String get hangulS1L9Step3Msg => '축하해요!\n1단계 기본 모음을 모두 마쳤어요.';

  @override
  String get hangulS1L10Title => '첫 한국어 단어!';

  @override
  String get hangulS1L10Subtitle => '배운 글자로 진짜 단어를 읽어봐요';

  @override
  String get hangulS1L10Step0Title => '이제 단어를 읽을 수 있어요!';

  @override
  String get hangulS1L10Step0Desc => '모음과 기본 자음을 배웠으니\n진짜 한국어 단어를 읽어볼까요?';

  @override
  String get hangulS1L10Step0Highlights => '진짜 단어,읽기 도전';

  @override
  String get hangulS1L10Step1Title => '첫 단어 읽기';

  @override
  String get hangulS1L10Step1Descs => '아이,우유,오이,이/치아,남동생';

  @override
  String get hangulS1L10Step2Title => '발음 연습';

  @override
  String get hangulS1L10Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS1L10Step3Title => '들어보고 골라요';

  @override
  String get hangulS1L10Step4Title => '대단해요!';

  @override
  String get hangulS1L10Step4Msg =>
      '한국어 단어를 읽었어요!\n이제 자음을 더 배우면\n더 많은 단어를 읽을 수 있어요.';

  @override
  String get hangulS1CompleteTitle => 'Stage 1 완료!';

  @override
  String get hangulS1CompleteMsg => '기본 모음 6개를 마스터했어요!';

  @override
  String get hangulS2L1Title => 'ㅑ 모양과 소리';

  @override
  String get hangulS2L1Subtitle => 'ㅏ에서 획 하나 추가: ㅑ';

  @override
  String get hangulS2L1Step0Title => 'ㅏ가 ㅑ로 변해요';

  @override
  String get hangulS2L1Step0Desc =>
      'ㅏ에 획 하나가 더해지면 ㅑ가 돼요.\n소리는 \"아\"보다 더 튀는 \"야\"예요.';

  @override
  String get hangulS2L1Step0Highlights => 'ㅏ → ㅑ,야,Y-모음';

  @override
  String get hangulS2L1Step1Title => 'ㅑ 소리 듣기';

  @override
  String get hangulS2L1Step1Desc => '야/갸/냐 소리를 들어보세요';

  @override
  String get hangulS2L1Step2Title => '발음 연습';

  @override
  String get hangulS2L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS2L1Step3Title => 'ㅏ vs ㅑ 듣기';

  @override
  String get hangulS2L1Step3Desc => '비슷한 소리를 구분해요';

  @override
  String get hangulS2L1Step4Title => 'ㅑ로 글자 만들기';

  @override
  String get hangulS2L1Step4Desc => '자음 + ㅑ 조합을 완성해요';

  @override
  String get hangulS2L1Step5Title => '모양/소리 퀴즈';

  @override
  String get hangulS2L1Step5Desc => 'ㅑ를 정확히 고르세요';

  @override
  String get hangulS2L1Step5Q0 => '다음 중 ㅑ는?';

  @override
  String get hangulS2L1Step5Q1 => 'ㅇ + ㅑ = ?';

  @override
  String get hangulS2L1Step5Q2 => '다음 중 ㅑ가 들어간 것은?';

  @override
  String get hangulS2L1Step6Title => '레슨 완료!';

  @override
  String get hangulS2L1Step6Msg => '좋아요!\nㅑ(야) 소리를 익혔어요.';

  @override
  String get hangulS2L2Title => 'ㅕ 모양과 소리';

  @override
  String get hangulS2L2Subtitle => 'ㅓ에서 획 하나 추가: ㅕ';

  @override
  String get hangulS2L2Step0Title => 'ㅓ가 ㅕ로 변해요';

  @override
  String get hangulS2L2Step0Desc =>
      'ㅓ에 획 하나가 더해지면 ㅕ가 돼요.\n소리는 \"어\"에서 \"여\"로 바뀝니다.';

  @override
  String get hangulS2L2Step0Highlights => 'ㅓ → ㅕ,여,Y-모음';

  @override
  String get hangulS2L2Step1Title => 'ㅕ 소리 듣기';

  @override
  String get hangulS2L2Step1Desc => '여/겨/녀 소리를 들어보세요';

  @override
  String get hangulS2L2Step2Title => '발음 연습';

  @override
  String get hangulS2L2Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS2L2Step3Title => 'ㅓ vs ㅕ 듣기';

  @override
  String get hangulS2L2Step3Desc => '어/여를 구분해요';

  @override
  String get hangulS2L2Step4Title => 'ㅕ로 글자 만들기';

  @override
  String get hangulS2L2Step4Desc => '자음 + ㅕ 조합을 완성해요';

  @override
  String get hangulS2L2Step5Title => '레슨 완료!';

  @override
  String get hangulS2L2Step5Msg => '좋아요!\nㅕ(여) 소리를 익혔어요.';

  @override
  String get hangulS2L3Title => 'ㅛ 모양과 소리';

  @override
  String get hangulS2L3Subtitle => 'ㅗ에서 획 하나 추가: ㅛ';

  @override
  String get hangulS2L3Step0Title => 'ㅗ가 ㅛ로 변해요';

  @override
  String get hangulS2L3Step0Desc =>
      'ㅗ에 획 하나가 더해지면 ㅛ가 돼요.\n소리는 \"오\"에서 \"요\"로 바뀝니다.';

  @override
  String get hangulS2L3Step0Highlights => 'ㅗ → ㅛ,요,Y-모음';

  @override
  String get hangulS2L3Step1Title => 'ㅛ 소리 듣기';

  @override
  String get hangulS2L3Step1Desc => '요/교/뇨 소리를 들어보세요';

  @override
  String get hangulS2L3Step2Title => '발음 연습';

  @override
  String get hangulS2L3Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS2L3Step3Title => 'ㅗ vs ㅛ 듣기';

  @override
  String get hangulS2L3Step3Desc => '오/요를 구분해요';

  @override
  String get hangulS2L3Step4Title => 'ㅛ로 글자 만들기';

  @override
  String get hangulS2L3Step4Desc => '자음 + ㅛ 조합을 완성해요';

  @override
  String get hangulS2L3Step5Title => '레슨 완료!';

  @override
  String get hangulS2L3Step5Msg => '좋아요!\nㅛ(요) 소리를 익혔어요.';

  @override
  String get hangulS2L4Title => 'ㅠ 모양과 소리';

  @override
  String get hangulS2L4Subtitle => 'ㅜ에서 획 하나 추가: ㅠ';

  @override
  String get hangulS2L4Step0Title => 'ㅜ가 ㅠ로 변해요';

  @override
  String get hangulS2L4Step0Desc =>
      'ㅜ에 획 하나가 더해지면 ㅠ가 돼요.\n소리는 \"우\"에서 \"유\"로 바뀝니다.';

  @override
  String get hangulS2L4Step0Highlights => 'ㅜ → ㅠ,유,Y-모음';

  @override
  String get hangulS2L4Step1Title => 'ㅠ 소리 듣기';

  @override
  String get hangulS2L4Step1Desc => '유/규/뉴 소리를 들어보세요';

  @override
  String get hangulS2L4Step2Title => '발음 연습';

  @override
  String get hangulS2L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS2L4Step3Title => 'ㅜ vs ㅠ 듣기';

  @override
  String get hangulS2L4Step3Desc => '우/유를 구분해요';

  @override
  String get hangulS2L4Step4Title => 'ㅠ로 글자 만들기';

  @override
  String get hangulS2L4Step4Desc => '자음 + ㅠ 조합을 완성해요';

  @override
  String get hangulS2L4Step5Title => '레슨 완료!';

  @override
  String get hangulS2L4Step5Msg => '좋아요!\nㅠ(유) 소리를 익혔어요.';

  @override
  String get hangulS2L5Title => 'Y-모음 묶음 구분';

  @override
  String get hangulS2L5Subtitle => 'ㅑ · ㅕ · ㅛ · ㅠ 집중 훈련';

  @override
  String get hangulS2L5Step0Title => 'Y-모음 한 번에 보기';

  @override
  String get hangulS2L5Step0Desc =>
      'ㅑ/ㅕ/ㅛ/ㅠ는 기본 모음에 획을 추가한 모음이에요.\n소리와 모양을 빠르게 구분해요.';

  @override
  String get hangulS2L5Step0Highlights => 'ㅑ,ㅕ,ㅛ,ㅠ';

  @override
  String get hangulS2L5Step1Title => '네 소리 다시 듣기';

  @override
  String get hangulS2L5Step1Desc => '야/여/요/유를 확인해요';

  @override
  String get hangulS2L5Step2Title => '발음 연습';

  @override
  String get hangulS2L5Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS2L5Step3Title => '소리 구분 퀴즈';

  @override
  String get hangulS2L5Step3Desc => 'Y-모음 소리를 구분해요';

  @override
  String get hangulS2L5Step4Title => '모양 구분 퀴즈';

  @override
  String get hangulS2L5Step4Desc => '모양도 정확히 구분해요';

  @override
  String get hangulS2L5Step4Q0 => '다음 중 ㅑ는?';

  @override
  String get hangulS2L5Step4Q1 => '다음 중 ㅕ는?';

  @override
  String get hangulS2L5Step4Q2 => '다음 중 ㅛ는?';

  @override
  String get hangulS2L5Step4Q3 => '다음 중 ㅠ는?';

  @override
  String get hangulS2L5Step5Title => '레슨 완료!';

  @override
  String get hangulS2L5Step5Msg => '좋아요!\nY-모음 4개 구분이 좋아졌어요.';

  @override
  String get hangulS2L6Title => '기본 vs Y-모음 대비';

  @override
  String get hangulS2L6Subtitle => 'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ';

  @override
  String get hangulS2L6Step0Title => '헷갈리는 짝 정리';

  @override
  String get hangulS2L6Step0Desc => '기본 모음과 Y-모음을 짝으로 비교해요.';

  @override
  String get hangulS2L6Step0Highlights => 'ㅏ/ㅑ,ㅓ/ㅕ,ㅗ/ㅛ,ㅜ/ㅠ';

  @override
  String get hangulS2L6Step1Title => '짝 소리 구분';

  @override
  String get hangulS2L6Step1Desc => '비슷한 소리 중 정답을 골라요';

  @override
  String get hangulS2L6Step2Title => '짝 모양 구분';

  @override
  String get hangulS2L6Step2Desc => '추가 획 유무를 확인해요';

  @override
  String get hangulS2L6Step2Q0 => '획이 추가된 모음은?';

  @override
  String get hangulS2L6Step2Q1 => '획이 추가된 모음은?';

  @override
  String get hangulS2L6Step2Q2 => '획이 추가된 모음은?';

  @override
  String get hangulS2L6Step2Q3 => '획이 추가된 모음은?';

  @override
  String get hangulS2L6Step2Q4 => 'ㅇ + ㅠ = ?';

  @override
  String get hangulS2L6Step3Title => '레슨 완료!';

  @override
  String get hangulS2L6Step3Msg => '좋아요!\n기본/ Y-모음 대비가 안정됐어요.';

  @override
  String get hangulS2L7Title => 'Y-모음 미션';

  @override
  String get hangulS2L7Subtitle => '시간 안에 Y-모음 조합 완성하기';

  @override
  String get hangulS2L7Step0Title => '2단계 최종 미션';

  @override
  String get hangulS2L7Step0Desc =>
      'Y-모음 조합을 빠르고 정확하게 맞춰요.\n완성 수와 시간으로 레몬 보상이 정해져요.';

  @override
  String get hangulS2L7Step1Title => '타임 미션';

  @override
  String get hangulS2L7Step2Title => '미션 결과';

  @override
  String get hangulS2L7Step3Title => '2단계 완료!';

  @override
  String get hangulS2L7Step3Msg => '축하해요!\n2단계 Y-모음을 모두 마쳤어요.';

  @override
  String get hangulS2CompleteTitle => 'Stage 2 완료!';

  @override
  String get hangulS2CompleteMsg => 'Y-모음까지 정복했어요!';

  @override
  String get hangulS3L1Title => 'ㅐ 모양과 소리';

  @override
  String get hangulS3L1Subtitle => 'ㅏ + ㅣ 조합 느낌 익히기';

  @override
  String get hangulS3L1Step0Title => 'ㅐ는 이렇게 생겨요';

  @override
  String get hangulS3L1Step0Desc => 'ㅐ는 ㅏ 계열에서 파생된 모음이에요.\n대표 소리는 \"애\"로 익혀요.';

  @override
  String get hangulS3L1Step0Highlights => 'ㅐ,애,모양 인식';

  @override
  String get hangulS3L1Step1Title => 'ㅐ 소리 듣기';

  @override
  String get hangulS3L1Step1Desc => '애/개/내 소리를 들어보세요';

  @override
  String get hangulS3L1Step2Title => '발음 연습';

  @override
  String get hangulS3L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS3L1Step3Title => 'ㅏ vs ㅐ 듣기';

  @override
  String get hangulS3L1Step3Desc => '아/애를 구분해요';

  @override
  String get hangulS3L1Step4Title => '레슨 완료!';

  @override
  String get hangulS3L1Step4Msg => '좋아요!\nㅐ(애) 모양과 소리를 익혔어요.';

  @override
  String get hangulS3L2Title => 'ㅔ 모양과 소리';

  @override
  String get hangulS3L2Subtitle => 'ㅓ + ㅣ 조합 느낌 익히기';

  @override
  String get hangulS3L2Step0Title => 'ㅔ는 이렇게 생겨요';

  @override
  String get hangulS3L2Step0Desc => 'ㅔ는 ㅓ 계열에서 파생된 모음이에요.\n대표 소리는 \"에\"로 익혀요.';

  @override
  String get hangulS3L2Step0Highlights => 'ㅔ,에,모양 인식';

  @override
  String get hangulS3L2Step1Title => 'ㅔ 소리 듣기';

  @override
  String get hangulS3L2Step1Desc => '에/게/네 소리를 들어보세요';

  @override
  String get hangulS3L2Step2Title => '발음 연습';

  @override
  String get hangulS3L2Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS3L2Step3Title => 'ㅓ vs ㅔ 듣기';

  @override
  String get hangulS3L2Step3Desc => '어/에를 구분해요';

  @override
  String get hangulS3L2Step4Title => '레슨 완료!';

  @override
  String get hangulS3L2Step4Msg => '좋아요!\nㅔ(에) 모양과 소리를 익혔어요.';

  @override
  String get hangulS3L3Title => 'ㅐ vs ㅔ 구분';

  @override
  String get hangulS3L3Subtitle => '모양 중심 구분 훈련';

  @override
  String get hangulS3L3Step0Title => '핵심은 모양 구분이에요';

  @override
  String get hangulS3L3Step0Desc =>
      '초급에서는 ㅐ/ㅔ 소리가 비슷하게 들릴 수 있어요.\n그래서 먼저 모양 구분을 정확히 해요.';

  @override
  String get hangulS3L3Step0Highlights => 'ㅐ,ㅔ,모양 구분';

  @override
  String get hangulS3L3Step1Title => '모양 구분 퀴즈';

  @override
  String get hangulS3L3Step1Desc => 'ㅐ와 ㅔ를 정확히 선택해요';

  @override
  String get hangulS3L3Step1Q0 => '다음 중 ㅐ는?';

  @override
  String get hangulS3L3Step1Q1 => '다음 중 ㅔ는?';

  @override
  String get hangulS3L3Step1Q2 => 'ㅇ + ㅐ = ?';

  @override
  String get hangulS3L3Step1Q3 => 'ㅇ + ㅔ = ?';

  @override
  String get hangulS3L3Step2Title => '레슨 완료!';

  @override
  String get hangulS3L3Step2Msg => '좋아요!\nㅐ/ㅔ 구분이 더 정확해졌어요.';

  @override
  String get hangulS3L4Title => 'ㅒ 모양과 소리';

  @override
  String get hangulS3L4Subtitle => 'Y-ㅐ 계열 모음';

  @override
  String get hangulS3L4Step0Title => 'ㅒ를 익혀요';

  @override
  String get hangulS3L4Step0Desc => 'ㅒ는 ㅐ 계열의 Y-모음이에요.\n대표 소리는 \"얘\"예요.';

  @override
  String get hangulS3L4Step0Highlights => 'ㅒ,얘';

  @override
  String get hangulS3L4Step1Title => 'ㅒ 소리 듣기';

  @override
  String get hangulS3L4Step1Desc => '얘/걔/냬 소리를 들어보세요';

  @override
  String get hangulS3L4Step2Title => '발음 연습';

  @override
  String get hangulS3L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS3L4Step3Title => '레슨 완료!';

  @override
  String get hangulS3L4Step3Msg => '좋아요!\nㅒ(얘) 모양을 익혔어요.';

  @override
  String get hangulS3L5Title => 'ㅖ 모양과 소리';

  @override
  String get hangulS3L5Subtitle => 'Y-ㅔ 계열 모음';

  @override
  String get hangulS3L5Step0Title => 'ㅖ를 익혀요';

  @override
  String get hangulS3L5Step0Desc => 'ㅖ는 ㅔ 계열의 Y-모음이에요.\n대표 소리는 \"예\"예요.';

  @override
  String get hangulS3L5Step0Highlights => 'ㅖ,예';

  @override
  String get hangulS3L5Step1Title => 'ㅖ 소리 듣기';

  @override
  String get hangulS3L5Step1Desc => '예/계/녜 소리를 들어보세요';

  @override
  String get hangulS3L5Step2Title => '발음 연습';

  @override
  String get hangulS3L5Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS3L5Step3Title => '레슨 완료!';

  @override
  String get hangulS3L5Step3Msg => '좋아요!\nㅖ(예) 모양을 익혔어요.';

  @override
  String get hangulS3L6Title => 'ㅐ/ㅔ 계열 종합';

  @override
  String get hangulS3L6Subtitle => 'ㅐ ㅔ ㅒ ㅖ 통합 점검';

  @override
  String get hangulS3L6Step0Title => '네 가지를 한 번에 구분해요';

  @override
  String get hangulS3L6Step0Desc => 'ㅐ/ㅔ/ㅒ/ㅖ를 모양과 소리로 함께 점검해요.';

  @override
  String get hangulS3L6Step0Highlights => 'ㅐ,ㅔ,ㅒ,ㅖ';

  @override
  String get hangulS3L6Step1Title => '소리 구분';

  @override
  String get hangulS3L6Step1Desc => '비슷한 소리 중 정답을 골라요';

  @override
  String get hangulS3L6Step2Title => '모양 구분';

  @override
  String get hangulS3L6Step2Desc => '모양을 보고 빠르게 선택해요';

  @override
  String get hangulS3L6Step2Q0 => '다음 중 Y-ㅐ 계열은?';

  @override
  String get hangulS3L6Step2Q1 => '다음 중 Y-ㅔ 계열은?';

  @override
  String get hangulS3L6Step2Q2 => 'ㅇ + ㅖ = ?';

  @override
  String get hangulS3L6Step3Title => '레슨 완료!';

  @override
  String get hangulS3L6Step3Msg => '좋아요!\n3단계 핵심 모음 구분이 안정됐어요.';

  @override
  String get hangulS3L7Title => '3단계 미션';

  @override
  String get hangulS3L7Subtitle => 'ㅐ/ㅔ 계열 빠른 구분 미션';

  @override
  String get hangulS3L7Step0Title => '3단계 최종 미션';

  @override
  String get hangulS3L7Step0Desc => 'ㅐ/ㅔ 계열 조합을 빠르고 정확하게 맞춰요.';

  @override
  String get hangulS3L7Step1Title => '타임 미션';

  @override
  String get hangulS3L7Step2Title => '미션 결과';

  @override
  String get hangulS3L7Step3Title => '3단계 완료!';

  @override
  String get hangulS3L7Step3Msg => '축하해요!\n3단계 ㅐ/ㅔ 계열 모음을 모두 마쳤어요.';

  @override
  String get hangulS3L7Step4Title => 'Stage 3 완료!';

  @override
  String get hangulS3L7Step4Msg => '모든 모음을 배웠어요!';

  @override
  String get hangulS3CompleteTitle => 'Stage 3 완료!';

  @override
  String get hangulS3CompleteMsg => '모든 모음을 배웠어요!';

  @override
  String get hangulS4L1Title => 'ㄱ 모양과 소리';

  @override
  String get hangulS4L1Subtitle => '기본 자음 시작: ㄱ';

  @override
  String get hangulS4L1Step0Title => 'ㄱ을 배워요';

  @override
  String get hangulS4L1Step0Desc => 'ㄱ은 기본 자음의 시작이에요.\nㅏ와 합치면 \"가\" 소리가 나요.';

  @override
  String get hangulS4L1Step0Highlights => 'ㄱ,가,기본 자음';

  @override
  String get hangulS4L1Step1Title => 'ㄱ 소리 듣기';

  @override
  String get hangulS4L1Step1Desc => '가/고/구 소리를 들어보세요';

  @override
  String get hangulS4L1Step2Title => '발음 연습';

  @override
  String get hangulS4L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L1Step3Title => 'ㄱ 소리 고르기';

  @override
  String get hangulS4L1Step3Desc => '소리를 듣고 맞는 글자를 선택하세요';

  @override
  String get hangulS4L1Step4Title => 'ㄱ으로 글자 만들기';

  @override
  String get hangulS4L1Step4Desc => 'ㄱ + 모음을 조합해보세요';

  @override
  String get hangulS4L1SummaryTitle => '레슨 완료!';

  @override
  String get hangulS4L1SummaryMsg => '좋아요!\nㄱ 소리와 모양을 익혔어요.';

  @override
  String get hangulS4L2Title => 'ㄴ 모양과 소리';

  @override
  String get hangulS4L2Subtitle => '두 번째 기본 자음: ㄴ';

  @override
  String get hangulS4L2Step0Title => 'ㄴ을 배워요';

  @override
  String get hangulS4L2Step0Desc => 'ㄴ은 \"나\" 소리 계열을 만들어요.';

  @override
  String get hangulS4L2Step0Highlights => 'ㄴ,나';

  @override
  String get hangulS4L2Step1Title => 'ㄴ 소리 듣기';

  @override
  String get hangulS4L2Step1Desc => '나/노/누 소리를 들어보세요';

  @override
  String get hangulS4L2Step2Title => '발음 연습';

  @override
  String get hangulS4L2Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L2Step3Title => 'ㄴ 소리 고르기';

  @override
  String get hangulS4L2Step3Desc => '나/다를 구분해요';

  @override
  String get hangulS4L2Step4Title => 'ㄴ으로 글자 만들기';

  @override
  String get hangulS4L2Step4Desc => 'ㄴ + 모음을 조합해보세요';

  @override
  String get hangulS4L2SummaryTitle => '레슨 완료!';

  @override
  String get hangulS4L2SummaryMsg => '좋아요!\nㄴ 소리와 모양을 익혔어요.';

  @override
  String get hangulS4L3Title => 'ㄷ 모양과 소리';

  @override
  String get hangulS4L3Subtitle => '세 번째 기본 자음: ㄷ';

  @override
  String get hangulS4L3Step0Title => 'ㄷ을 배워요';

  @override
  String get hangulS4L3Step0Desc => 'ㄷ은 \"다\" 소리 계열을 만들어요.';

  @override
  String get hangulS4L3Step0Highlights => 'ㄷ,다';

  @override
  String get hangulS4L3Step1Title => 'ㄷ 소리 듣기';

  @override
  String get hangulS4L3Step1Desc => '다/도/두 소리를 들어보세요';

  @override
  String get hangulS4L3Step2Title => '발음 연습';

  @override
  String get hangulS4L3Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L3Step3Title => 'ㄷ 소리 고르기';

  @override
  String get hangulS4L3Step3Desc => '다/나를 구분해요';

  @override
  String get hangulS4L3Step4Title => 'ㄷ으로 글자 만들기';

  @override
  String get hangulS4L3Step4Desc => 'ㄷ + 모음을 조합해보세요';

  @override
  String get hangulS4L3SummaryTitle => '레슨 완료!';

  @override
  String get hangulS4L3SummaryMsg => '좋아요!\nㄷ 소리와 모양을 익혔어요.';

  @override
  String get hangulS4L4Title => 'ㄹ 모양과 소리';

  @override
  String get hangulS4L4Subtitle => '네 번째 기본 자음: ㄹ';

  @override
  String get hangulS4L4Step0Title => 'ㄹ을 배워요';

  @override
  String get hangulS4L4Step0Desc => 'ㄹ은 \"라\" 소리 계열을 만들어요.';

  @override
  String get hangulS4L4Step0Highlights => 'ㄹ,라';

  @override
  String get hangulS4L4Step1Title => 'ㄹ 소리 듣기';

  @override
  String get hangulS4L4Step1Desc => '라/로/루 소리를 들어보세요';

  @override
  String get hangulS4L4Step2Title => '발음 연습';

  @override
  String get hangulS4L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L4Step3Title => 'ㄹ 소리 고르기';

  @override
  String get hangulS4L4Step3Desc => '라/나를 구분해요';

  @override
  String get hangulS4L4Step4Title => 'ㄹ로 글자 만들기';

  @override
  String get hangulS4L4Step4Desc => 'ㄹ + 모음을 조합해보세요';

  @override
  String get hangulS4L4SummaryTitle => '레슨 완료!';

  @override
  String get hangulS4L4SummaryMsg => '좋아요!\nㄹ 소리와 모양을 익혔어요.';

  @override
  String get hangulS4L5Title => 'ㅁ 모양과 소리';

  @override
  String get hangulS4L5Subtitle => '다섯 번째 기본 자음: ㅁ';

  @override
  String get hangulS4L5Step0Title => 'ㅁ을 배워요';

  @override
  String get hangulS4L5Step0Desc => 'ㅁ은 \"마\" 소리 계열을 만들어요.';

  @override
  String get hangulS4L5Step0Highlights => 'ㅁ,마';

  @override
  String get hangulS4L5Step1Title => 'ㅁ 소리 듣기';

  @override
  String get hangulS4L5Step1Desc => '마/모/무 소리를 들어보세요';

  @override
  String get hangulS4L5Step2Title => '발음 연습';

  @override
  String get hangulS4L5Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L5Step3Title => 'ㅁ 소리 고르기';

  @override
  String get hangulS4L5Step3Desc => '마/바를 구분해요';

  @override
  String get hangulS4L5Step4Title => 'ㅁ으로 글자 만들기';

  @override
  String get hangulS4L5Step4Desc => 'ㅁ + 모음을 조합해보세요';

  @override
  String get hangulS4L5SummaryTitle => '레슨 완료!';

  @override
  String get hangulS4L5SummaryMsg => '좋아요!\nㅁ 소리와 모양을 익혔어요.';

  @override
  String get hangulS4L6Title => 'ㅂ 모양과 소리';

  @override
  String get hangulS4L6Subtitle => '여섯 번째 기본 자음: ㅂ';

  @override
  String get hangulS4L6Step0Title => 'ㅂ을 배워요';

  @override
  String get hangulS4L6Step0Desc => 'ㅂ은 \"바\" 소리 계열을 만들어요.';

  @override
  String get hangulS4L6Step0Highlights => 'ㅂ,바';

  @override
  String get hangulS4L6Step1Title => 'ㅂ 소리 듣기';

  @override
  String get hangulS4L6Step1Desc => '바/보/부 소리를 들어보세요';

  @override
  String get hangulS4L6Step2Title => '발음 연습';

  @override
  String get hangulS4L6Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L6Step3Title => 'ㅂ 소리 고르기';

  @override
  String get hangulS4L6Step3Desc => '바/마를 구분해요';

  @override
  String get hangulS4L6Step4Title => 'ㅂ으로 글자 만들기';

  @override
  String get hangulS4L6Step4Desc => 'ㅂ + 모음을 조합해보세요';

  @override
  String get hangulS4L6SummaryTitle => '레슨 완료!';

  @override
  String get hangulS4L6SummaryMsg => '좋아요!\nㅂ 소리와 모양을 익혔어요.';

  @override
  String get hangulS4L7Title => 'ㅅ 모양과 소리';

  @override
  String get hangulS4L7Subtitle => '일곱 번째 기본 자음: ㅅ';

  @override
  String get hangulS4L7Step0Title => 'ㅅ을 배워요';

  @override
  String get hangulS4L7Step0Desc => 'ㅅ은 \"사\" 소리 계열을 만들어요.';

  @override
  String get hangulS4L7Step0Highlights => 'ㅅ,사';

  @override
  String get hangulS4L7Step1Title => 'ㅅ 소리 듣기';

  @override
  String get hangulS4L7Step1Desc => '사/소/수 소리를 들어보세요';

  @override
  String get hangulS4L7Step2Title => '발음 연습';

  @override
  String get hangulS4L7Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L7Step3Title => 'ㅅ 소리 고르기';

  @override
  String get hangulS4L7Step3Desc => '사/자를 구분해요';

  @override
  String get hangulS4L7Step4Title => 'ㅅ으로 글자 만들기';

  @override
  String get hangulS4L7Step4Desc => 'ㅅ + 모음을 조합해보세요';

  @override
  String get hangulS4L7SummaryTitle => '4단계 완료!';

  @override
  String get hangulS4L7SummaryMsg => '축하해요!\n4단계 기본 자음 1(ㄱ~ㅅ)을 완료했어요.';

  @override
  String get hangulS4L8Title => '단어 읽기 도전!';

  @override
  String get hangulS4L8Subtitle => '자음과 모음으로 단어를 읽어봐요';

  @override
  String get hangulS4L8Step0Title => '이제 더 많은 단어를 읽을 수 있어요!';

  @override
  String get hangulS4L8Step0Desc =>
      '기본 자음 7개와 모음을 모두 배웠어요.\n이 글자들로 만든 진짜 단어를 읽어볼까요?';

  @override
  String get hangulS4L8Step0Highlights => '자음 7개,모음,진짜 단어';

  @override
  String get hangulS4L8Step1Title => '단어 읽기';

  @override
  String get hangulS4L8Step1Descs => '나무,바다,나비,모자,가구,두부';

  @override
  String get hangulS4L8Step2Title => '발음 연습';

  @override
  String get hangulS4L8Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS4L8Step3Title => '듣고 골라요';

  @override
  String get hangulS4L8Step4Title => '무슨 뜻일까요?';

  @override
  String get hangulS4L8Step4Q0 => '\"나비\"는 영어로?';

  @override
  String get hangulS4L8Step4Q1 => '\"바다\"는 영어로?';

  @override
  String get hangulS4L8SummaryTitle => '훌륭해요!';

  @override
  String get hangulS4L8SummaryMsg =>
      '한국어 단어 6개를 읽었어요!\n자음을 더 배우면 훨씬 더 많은 단어를 읽을 수 있어요.';

  @override
  String get hangulS4LMTitle => '미션: 기본 자음 조합!';

  @override
  String get hangulS4LMSubtitle => '시간 안에 음절을 만들어요';

  @override
  String get hangulS4LMStep0Title => '미션 시작!';

  @override
  String get hangulS4LMStep0Desc => '기본 자음 ㄱ~ㅅ과 모음을 조합해요.\n제한 시간 안에 목표를 달성하세요!';

  @override
  String get hangulS4LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS4LMStep2Title => '미션 결과';

  @override
  String get hangulS4LMSummaryTitle => '미션 완료!';

  @override
  String get hangulS4LMSummaryMsg => '기본 자음 7개를 자유롭게 조합할 수 있어요!';

  @override
  String get hangulS4CompleteTitle => 'Stage 4 완료!';

  @override
  String get hangulS4CompleteMsg => '기본 자음 7개를 익혔어요!';

  @override
  String get hangulS5L1Title => 'ㅇ 자리 이해하기';

  @override
  String get hangulS5L1Subtitle => '초성 ㅇ과 조합 읽기';

  @override
  String get hangulS5L1Step0Title => 'ㅇ은 특별한 자음이에요';

  @override
  String get hangulS5L1Step0Desc => '초성 ㅇ은 소리가 거의 없고,\n모음과 만나면 아/오/우처럼 읽혀요.';

  @override
  String get hangulS5L1Step0Highlights => 'ㅇ,아,초성 자리';

  @override
  String get hangulS5L1Step1Title => 'ㅇ 조합 소리 듣기';

  @override
  String get hangulS5L1Step1Desc => '아/오/우 소리를 들어보세요';

  @override
  String get hangulS5L1Step2Title => '발음 연습';

  @override
  String get hangulS5L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS5L1Step3Title => 'ㅇ으로 글자 만들기';

  @override
  String get hangulS5L1Step3Desc => 'ㅇ + 모음을 조합해보세요';

  @override
  String get hangulS5L1Step4Title => '레슨 완료!';

  @override
  String get hangulS5L1Step4Msg => '좋아요!\nㅇ 자리를 이해했어요.';

  @override
  String get hangulS5L2Title => 'ㅈ 모양과 소리';

  @override
  String get hangulS5L2Subtitle => 'ㅈ 기본 읽기';

  @override
  String get hangulS5L2Step0Title => 'ㅈ을 배워요';

  @override
  String get hangulS5L2Step0Desc => 'ㅈ은 \"자\" 소리 계열을 만들어요.';

  @override
  String get hangulS5L2Step0Highlights => 'ㅈ,자';

  @override
  String get hangulS5L2Step1Title => 'ㅈ 소리 듣기';

  @override
  String get hangulS5L2Step1Desc => '자/조/주 소리를 들어보세요';

  @override
  String get hangulS5L2Step2Title => '발음 연습';

  @override
  String get hangulS5L2Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS5L2Step3Title => 'ㅈ 소리 고르기';

  @override
  String get hangulS5L2Step3Desc => '자/사를 구분해요';

  @override
  String get hangulS5L2Step4Title => 'ㅈ으로 글자 만들기';

  @override
  String get hangulS5L2Step4Desc => 'ㅈ + 모음을 조합해보세요';

  @override
  String get hangulS5L2Step5Title => '레슨 완료!';

  @override
  String get hangulS5L2Step5Msg => '좋아요!\nㅈ 소리와 모양을 익혔어요.';

  @override
  String get hangulS5L3Title => 'ㅊ 모양과 소리';

  @override
  String get hangulS5L3Subtitle => 'ㅊ 기본 읽기';

  @override
  String get hangulS5L3Step0Title => 'ㅊ을 배워요';

  @override
  String get hangulS5L3Step0Desc => 'ㅊ은 \"차\" 소리 계열을 만들어요.';

  @override
  String get hangulS5L3Step0Highlights => 'ㅊ,차';

  @override
  String get hangulS5L3Step1Title => 'ㅊ 소리 듣기';

  @override
  String get hangulS5L3Step1Desc => '차/초/추 소리를 들어보세요';

  @override
  String get hangulS5L3Step2Title => '발음 연습';

  @override
  String get hangulS5L3Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS5L3Step3Title => 'ㅊ 소리 고르기';

  @override
  String get hangulS5L3Step3Desc => '차/자를 구분해요';

  @override
  String get hangulS5L3Step4Title => '레슨 완료!';

  @override
  String get hangulS5L3Step4Msg => '좋아요!\nㅊ 소리와 모양을 익혔어요.';

  @override
  String get hangulS5L4Title => 'ㅋ 모양과 소리';

  @override
  String get hangulS5L4Subtitle => 'ㅋ 기본 읽기';

  @override
  String get hangulS5L4Step0Title => 'ㅋ을 배워요';

  @override
  String get hangulS5L4Step0Desc => 'ㅋ은 \"카\" 소리 계열을 만들어요.';

  @override
  String get hangulS5L4Step0Highlights => 'ㅋ,카';

  @override
  String get hangulS5L4Step1Title => 'ㅋ 소리 듣기';

  @override
  String get hangulS5L4Step1Desc => '카/코/쿠 소리를 들어보세요';

  @override
  String get hangulS5L4Step2Title => '발음 연습';

  @override
  String get hangulS5L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS5L4Step3Title => 'ㅋ 소리 고르기';

  @override
  String get hangulS5L4Step3Desc => '카/가를 구분해요';

  @override
  String get hangulS5L4Step4Title => '레슨 완료!';

  @override
  String get hangulS5L4Step4Msg => '좋아요!\nㅋ 소리와 모양을 익혔어요.';

  @override
  String get hangulS5L5Title => 'ㅌ 모양과 소리';

  @override
  String get hangulS5L5Subtitle => 'ㅌ 기본 읽기';

  @override
  String get hangulS5L5Step0Title => 'ㅌ을 배워요';

  @override
  String get hangulS5L5Step0Desc => 'ㅌ은 \"타\" 소리 계열을 만들어요.';

  @override
  String get hangulS5L5Step0Highlights => 'ㅌ,타';

  @override
  String get hangulS5L5Step1Title => 'ㅌ 소리 듣기';

  @override
  String get hangulS5L5Step1Desc => '타/토/투 소리를 들어보세요';

  @override
  String get hangulS5L5Step2Title => '발음 연습';

  @override
  String get hangulS5L5Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS5L5Step3Title => 'ㅌ 소리 고르기';

  @override
  String get hangulS5L5Step3Desc => '타/다를 구분해요';

  @override
  String get hangulS5L5Step4Title => '레슨 완료!';

  @override
  String get hangulS5L5Step4Msg => '좋아요!\nㅌ 소리와 모양을 익혔어요.';

  @override
  String get hangulS5L6Title => 'ㅍ 모양과 소리';

  @override
  String get hangulS5L6Subtitle => 'ㅍ 기본 읽기';

  @override
  String get hangulS5L6Step0Title => 'ㅍ을 배워요';

  @override
  String get hangulS5L6Step0Desc => 'ㅍ은 \"파\" 소리 계열을 만들어요.';

  @override
  String get hangulS5L6Step0Highlights => 'ㅍ,파';

  @override
  String get hangulS5L6Step1Title => 'ㅍ 소리 듣기';

  @override
  String get hangulS5L6Step1Desc => '파/포/푸 소리를 들어보세요';

  @override
  String get hangulS5L6Step2Title => '발음 연습';

  @override
  String get hangulS5L6Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS5L6Step3Title => 'ㅍ 소리 고르기';

  @override
  String get hangulS5L6Step3Desc => '파/바를 구분해요';

  @override
  String get hangulS5L6Step4Title => '레슨 완료!';

  @override
  String get hangulS5L6Step4Msg => '좋아요!\nㅍ 소리와 모양을 익혔어요.';

  @override
  String get hangulS5L7Title => 'ㅎ 모양과 소리';

  @override
  String get hangulS5L7Subtitle => 'ㅎ 기본 읽기';

  @override
  String get hangulS5L7Step0Title => 'ㅎ을 배워요';

  @override
  String get hangulS5L7Step0Desc => 'ㅎ은 \"하\" 소리 계열을 만들어요.';

  @override
  String get hangulS5L7Step0Highlights => 'ㅎ,하';

  @override
  String get hangulS5L7Step1Title => 'ㅎ 소리 듣기';

  @override
  String get hangulS5L7Step1Desc => '하/호/후 소리를 들어보세요';

  @override
  String get hangulS5L7Step2Title => '발음 연습';

  @override
  String get hangulS5L7Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS5L7Step3Title => 'ㅎ 소리 고르기';

  @override
  String get hangulS5L7Step3Desc => '하/아를 구분해요';

  @override
  String get hangulS5L7Step4Title => '레슨 완료!';

  @override
  String get hangulS5L7Step4Msg => '좋아요!\nㅎ 소리와 모양을 익혔어요.';

  @override
  String get hangulS5L8Title => '추가 자음 랜덤 읽기';

  @override
  String get hangulS5L8Subtitle => 'ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ 섞어서 점검';

  @override
  String get hangulS5L8Step0Title => '랜덤으로 점검해요';

  @override
  String get hangulS5L8Step0Desc => '추가 자음 7개를 섞어서 읽어볼게요.';

  @override
  String get hangulS5L8Step0Highlights => 'ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ';

  @override
  String get hangulS5L8Step1Title => '모양/소리 퀴즈';

  @override
  String get hangulS5L8Step1Desc => '소리와 글자를 연결해요';

  @override
  String get hangulS5L8Step2Title => '레슨 완료!';

  @override
  String get hangulS5L8Step2Msg => '좋아요!\n기본 자음 2를 랜덤으로 점검했어요.';

  @override
  String get hangulS5L9Title => '혼동쌍 미리보기';

  @override
  String get hangulS5L9Subtitle => '다음 단계 대비 구분 연습';

  @override
  String get hangulS5L9Step0Title => '헷갈리는 쌍을 먼저 봐요';

  @override
  String get hangulS5L9Step0Desc => 'ㅈ/ㅊ, ㄱ/ㅋ, ㄷ/ㅌ, ㅂ/ㅍ를 미리 익혀요.';

  @override
  String get hangulS5L9Step0Highlights => 'ㅈ/ㅊ,ㄱ/ㅋ,ㄷ/ㅌ,ㅂ/ㅍ';

  @override
  String get hangulS5L9Step1Title => '대비 듣기';

  @override
  String get hangulS5L9Step1Desc => '두 소리 중 맞는 것을 고르세요';

  @override
  String get hangulS5L9Step2Title => '레슨 완료!';

  @override
  String get hangulS5L9Step2Msg => '좋아요!\n다음 단계 대비를 마쳤어요.';

  @override
  String get hangulS5LMTitle => '5단계 미션';

  @override
  String get hangulS5LMSubtitle => '기본 자음 2 종합 미션';

  @override
  String get hangulS5LMStep0Title => '미션 시작!';

  @override
  String get hangulS5LMStep0Desc =>
      '기본 자음 2 ㅇ~ㅎ과 모음을 조합해요.\n제한 시간 안에 목표를 달성하세요!';

  @override
  String get hangulS5LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS5LMStep2Title => '미션 결과';

  @override
  String get hangulS5LMStep3Title => '5단계 완료!';

  @override
  String get hangulS5LMStep3Msg => '축하해요!\n5단계 기본 자음 2(ㅇ~ㅎ)를 완료했어요.';

  @override
  String get hangulS5LMStep4Title => 'Stage 5 완료!';

  @override
  String get hangulS5LMStep4Msg => '모든 기본 자음을 마스터했어요!';

  @override
  String get hangulS5CompleteTitle => '5단계 완료!';

  @override
  String get hangulS5CompleteMsg => '모든 기본 자음을 마스터했어요!';

  @override
  String get hangulS6L1Title => '가~기 패턴 읽기';

  @override
  String get hangulS6L1Subtitle => 'ㄱ + 기본 모음 패턴';

  @override
  String get hangulS6L1Step0Title => '패턴으로 읽기 시작';

  @override
  String get hangulS6L1Step0Desc => 'ㄱ에 모음을 바꿔 붙이며 읽어보면\n읽기 리듬이 생겨요.';

  @override
  String get hangulS6L1Step0Highlights => '가,거,고,구,그,기';

  @override
  String get hangulS6L1Step1Title => '패턴 소리 듣기';

  @override
  String get hangulS6L1Step1Desc => '가/거/고/구/그/기를 순서대로 들어보세요';

  @override
  String get hangulS6L1Step2Title => '발음 연습';

  @override
  String get hangulS6L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS6L1Step3Title => '패턴 퀴즈';

  @override
  String get hangulS6L1Step3Desc => '같은 자음 패턴을 맞춰요';

  @override
  String get hangulS6L1Step3Q0 => 'ㄱ + ㅏ = ?';

  @override
  String get hangulS6L1Step3Q1 => 'ㄱ + ㅓ = ?';

  @override
  String get hangulS6L1Step3Q2 => 'ㄱ + ㅡ = ?';

  @override
  String get hangulS6L1Step4Title => '레슨 완료!';

  @override
  String get hangulS6L1Step4Msg => '좋아요!\n가~기 패턴 읽기를 시작했어요.';

  @override
  String get hangulS6L2Title => '나~니 확장';

  @override
  String get hangulS6L2Subtitle => 'ㄴ 패턴 읽기';

  @override
  String get hangulS6L2Step0Title => 'ㄴ 패턴 확장';

  @override
  String get hangulS6L2Step0Desc => 'ㄴ에 모음을 바꿔 붙여 나~니를 읽어요.';

  @override
  String get hangulS6L2Step0Highlights => '나,너,노,누,느,니';

  @override
  String get hangulS6L2Step1Title => '나~니 듣기';

  @override
  String get hangulS6L2Step1Desc => 'ㄴ 패턴 소리를 들어보세요';

  @override
  String get hangulS6L2Step2Title => '발음 연습';

  @override
  String get hangulS6L2Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS6L2Step3Title => 'ㄴ 조합 만들기';

  @override
  String get hangulS6L2Step3Desc => 'ㄴ + 모음으로 글자를 만들어요';

  @override
  String get hangulS6L2Step4Title => '레슨 완료!';

  @override
  String get hangulS6L2Step4Msg => '좋아요!\n나~니 패턴을 익혔어요.';

  @override
  String get hangulS6L3Title => '다~디, 라~리 확장';

  @override
  String get hangulS6L3Subtitle => 'ㄷ/ㄹ 패턴 읽기';

  @override
  String get hangulS6L3Step0Title => '자음만 바꿔 읽기';

  @override
  String get hangulS6L3Step0Desc => '같은 모음에 자음을 바꿔 읽으면\n속도가 빨라져요.';

  @override
  String get hangulS6L3Step0Highlights => '다/라,도/로,두/루,디/리';

  @override
  String get hangulS6L3Step1Title => 'ㄷ/ㄹ 구분 듣기';

  @override
  String get hangulS6L3Step1Desc => '소리를 듣고 맞게 선택하세요';

  @override
  String get hangulS6L3Step2Title => '읽기 퀴즈';

  @override
  String get hangulS6L3Step2Desc => '패턴을 확인해요';

  @override
  String get hangulS6L3Step2Q0 => 'ㄷ + ㅣ = ?';

  @override
  String get hangulS6L3Step2Q1 => 'ㄹ + ㅗ = ?';

  @override
  String get hangulS6L3Step3Title => '레슨 완료!';

  @override
  String get hangulS6L3Step3Msg => '좋아요!\nㄷ/ㄹ 패턴을 익혔어요.';

  @override
  String get hangulS6L4Title => '랜덤 음절 읽기 1';

  @override
  String get hangulS6L4Subtitle => '기본 패턴 섞기';

  @override
  String get hangulS6L4Step0Title => '순서 없이 읽기';

  @override
  String get hangulS6L4Step0Desc => '이제 랜덤 카드처럼 읽어볼게요.';

  @override
  String get hangulS6L4Step1Title => '랜덤 읽기';

  @override
  String get hangulS6L4Step1Desc => '랜덤으로 제시된 음절을 맞춰요';

  @override
  String get hangulS6L4Step1Q0 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS6L4Step1Q1 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS6L4Step1Q2 => 'ㄹ + ㅏ = ?';

  @override
  String get hangulS6L4Step1Q3 => 'ㅁ + ㅣ = ?';

  @override
  String get hangulS6L4Step2Title => '레슨 완료!';

  @override
  String get hangulS6L4Step2Msg => '좋아요!\n랜덤 읽기 1을 완료했어요.';

  @override
  String get hangulS6L5Title => '소리 듣고 음절 찾기';

  @override
  String get hangulS6L5Subtitle => '청각-문자 연결 강화';

  @override
  String get hangulS6L5Step0Title => '듣고 찾는 연습';

  @override
  String get hangulS6L5Step0Desc => '소리를 듣고 해당 음절을 고르며\n읽기 연결을 강화해요.';

  @override
  String get hangulS6L5Step1Title => '소리 매칭';

  @override
  String get hangulS6L5Step1Desc => '정답 음절을 골라보세요';

  @override
  String get hangulS6L5Step2Title => '레슨 완료!';

  @override
  String get hangulS6L5Step2Msg => '좋아요!\n듣고 찾기 연습을 완료했어요.';

  @override
  String get hangulS6L6Title => '복합 모음 조합 1';

  @override
  String get hangulS6L6Subtitle => 'ㅘ, ㅝ 읽기';

  @override
  String get hangulS6L6Step0Title => '복합 모음 시작';

  @override
  String get hangulS6L6Step0Desc => 'ㅘ, ㅝ를 조합해서 읽어봐요.';

  @override
  String get hangulS6L6Step0Highlights => 'ㅘ,ㅝ,와,워';

  @override
  String get hangulS6L6Step1Title => '와/워 듣기';

  @override
  String get hangulS6L6Step1Desc => '대표 음절 소리를 들어보세요';

  @override
  String get hangulS6L6Step2Title => '발음 연습';

  @override
  String get hangulS6L6Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS6L6Step3Title => '복합 모음 퀴즈';

  @override
  String get hangulS6L6Step3Desc => 'ㅘ/ㅝ를 구분해요';

  @override
  String get hangulS6L6Step3Q0 => 'ㅇ + ㅘ = ?';

  @override
  String get hangulS6L6Step3Q1 => 'ㄱ + ㅝ = ?';

  @override
  String get hangulS6L6Step4Title => '레슨 완료!';

  @override
  String get hangulS6L6Step4Msg => '좋아요!\nㅘ/ㅝ 조합을 익혔어요.';

  @override
  String get hangulS6L7Title => '복합 모음 조합 2';

  @override
  String get hangulS6L7Subtitle => 'ㅙ, ㅞ, ㅚ, ㅟ, ㅢ 읽기';

  @override
  String get hangulS6L7Step0Title => '복합 모음 확장';

  @override
  String get hangulS6L7Step0Desc => '조합형 모음을 짧게 익히고 읽기 중심으로 갑니다.';

  @override
  String get hangulS6L7Step0Highlights => '왜,웨,외,위,의';

  @override
  String get hangulS6L7Step1Title => 'ㅢ의 특별한 발음';

  @override
  String get hangulS6L7Step1Desc =>
      'ㅢ는 위치에 따라 소리가 달라지는 특별한 모음이에요.\n\n• 첫소리: [의] → 의사, 의자\n• 자음 뒤: [이] → 희망→[히망]\n• 조사 \"의\": [에] → 나의→[나에]';

  @override
  String get hangulS6L7Step1Highlights => 'ㅢ,의,이,에';

  @override
  String get hangulS6L7Step2Title => '복합 모음 선택';

  @override
  String get hangulS6L7Step2Desc => '알맞은 음절을 고르세요';

  @override
  String get hangulS6L7Step2Q0 => 'ㅇ + ㅙ = ?';

  @override
  String get hangulS6L7Step2Q1 => 'ㅇ + ㅟ = ?';

  @override
  String get hangulS6L7Step2Q2 => 'ㅇ + ㅢ = ?';

  @override
  String get hangulS6L7Step3Title => '레슨 완료!';

  @override
  String get hangulS6L7Step3Msg => '좋아요!\n복합 모음 확장을 완료했어요.';

  @override
  String get hangulS6L8Title => '랜덤 음절 읽기 2';

  @override
  String get hangulS6L8Subtitle => '기본+복합 모음 종합';

  @override
  String get hangulS6L8Step0Title => '종합 랜덤 읽기';

  @override
  String get hangulS6L8Step0Desc => '기본/복합 모음을 함께 섞어 읽어요.';

  @override
  String get hangulS6L8Step1Title => '종합 퀴즈';

  @override
  String get hangulS6L8Step1Desc => '랜덤 조합을 맞춰요';

  @override
  String get hangulS6L8Step1Q0 => 'ㄱ + ㅢ = ?';

  @override
  String get hangulS6L8Step1Q1 => 'ㅎ + ㅘ = ?';

  @override
  String get hangulS6L8Step1Q2 => 'ㅂ + ㅟ = ?';

  @override
  String get hangulS6L8Step1Q3 => 'ㅈ + ㅝ = ?';

  @override
  String get hangulS6L8Step2Title => '레슨 완료!';

  @override
  String get hangulS6L8Step2Msg => '좋아요!\n6단계 종합 읽기를 완료했어요.';

  @override
  String get hangulS6LMTitle => '6단계 미션';

  @override
  String get hangulS6LMSubtitle => '조합 읽기 최종 점검';

  @override
  String get hangulS6LMStep0Title => '미션 시작!';

  @override
  String get hangulS6LMStep0Desc => '본격 조합 훈련을 최종 점검합니다.\n제한 시간 안에 목표를 달성하세요!';

  @override
  String get hangulS6LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS6LMStep2Title => '미션 결과';

  @override
  String get hangulS6LMStep3Title => '6단계 완료!';

  @override
  String get hangulS6LMStep3Msg => '축하해요!\n6단계 본격 조합 훈련을 완료했어요.';

  @override
  String get hangulS6CompleteTitle => 'Stage 6 완료!';

  @override
  String get hangulS6CompleteMsg => '자유롭게 음절을 조합할 수 있어요!';

  @override
  String get hangulS7L1Title => 'ㄱ / ㅋ / ㄲ 구분';

  @override
  String get hangulS7L1Subtitle => '가 · 카 · 까 대비';

  @override
  String get hangulS7L1Step0Title => '세 소리를 나눠 들어요';

  @override
  String get hangulS7L1Step0Desc => 'ㄱ(기본), ㅋ(거센), ㄲ(된) 느낌을 구분해요.';

  @override
  String get hangulS7L1Step0Highlights => 'ㄱ,ㅋ,ㄲ,가,카,까';

  @override
  String get hangulS7L1Step1Title => '소리 탐색';

  @override
  String get hangulS7L1Step1Desc => '가/카/까를 반복해서 들어보세요';

  @override
  String get hangulS7L1Step2Title => '발음 연습';

  @override
  String get hangulS7L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS7L1Step3Title => '듣고 고르기';

  @override
  String get hangulS7L1Step3Desc => '세 보기 중 정답을 선택하세요';

  @override
  String get hangulS7L1Step4Title => '빠른 확인';

  @override
  String get hangulS7L1Step4Desc => '모양과 소리를 함께 확인해요';

  @override
  String get hangulS7L1Step4Q0 => '거센소리는?';

  @override
  String get hangulS7L1Step4Q1 => '된소리는?';

  @override
  String get hangulS7L1Step5Title => '레슨 완료!';

  @override
  String get hangulS7L1Step5Msg => '좋아요!\nㄱ/ㅋ/ㄲ 구분을 익혔어요.';

  @override
  String get hangulS7L2Title => 'ㄷ / ㅌ / ㄸ 구분';

  @override
  String get hangulS7L2Subtitle => '다 · 타 · 따 대비';

  @override
  String get hangulS7L2Step0Title => '두 번째 대비 묶음';

  @override
  String get hangulS7L2Step0Desc => 'ㄷ/ㅌ/ㄸ 소리를 비교해요.';

  @override
  String get hangulS7L2Step0Highlights => 'ㄷ,ㅌ,ㄸ,다,타,따';

  @override
  String get hangulS7L2Step1Title => '소리 탐색';

  @override
  String get hangulS7L2Step1Desc => '다/타/따를 반복해서 들어보세요';

  @override
  String get hangulS7L2Step2Title => '발음 연습';

  @override
  String get hangulS7L2Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS7L2Step3Title => '듣고 고르기';

  @override
  String get hangulS7L2Step3Desc => '세 보기 중 정답을 선택하세요';

  @override
  String get hangulS7L2Step4Title => '레슨 완료!';

  @override
  String get hangulS7L2Step4Msg => '좋아요!\nㄷ/ㅌ/ㄸ 구분을 익혔어요.';

  @override
  String get hangulS7L3Title => 'ㅂ / ㅍ / ㅃ 구분';

  @override
  String get hangulS7L3Subtitle => '바 · 파 · 빠 대비';

  @override
  String get hangulS7L3Step0Title => '세 번째 대비 묶음';

  @override
  String get hangulS7L3Step0Desc => 'ㅂ/ㅍ/ㅃ 소리를 비교해요.';

  @override
  String get hangulS7L3Step0Highlights => 'ㅂ,ㅍ,ㅃ,바,파,빠';

  @override
  String get hangulS7L3Step1Title => '소리 탐색';

  @override
  String get hangulS7L3Step1Desc => '바/파/빠를 반복해서 들어보세요';

  @override
  String get hangulS7L3Step2Title => '발음 연습';

  @override
  String get hangulS7L3Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS7L3Step3Title => '듣고 고르기';

  @override
  String get hangulS7L3Step3Desc => '세 보기 중 정답을 선택하세요';

  @override
  String get hangulS7L3Step4Title => '레슨 완료!';

  @override
  String get hangulS7L3Step4Msg => '좋아요!\nㅂ/ㅍ/ㅃ 구분을 익혔어요.';

  @override
  String get hangulS7L4Title => 'ㅅ / ㅆ 구분';

  @override
  String get hangulS7L4Subtitle => '사 · 싸 대비';

  @override
  String get hangulS7L4Step0Title => '두 소리 대비';

  @override
  String get hangulS7L4Step0Desc => 'ㅅ/ㅆ 소리를 구분해요.';

  @override
  String get hangulS7L4Step0Highlights => 'ㅅ,ㅆ,사,싸';

  @override
  String get hangulS7L4Step1Title => '소리 탐색';

  @override
  String get hangulS7L4Step1Desc => '사/싸를 반복해서 들어보세요';

  @override
  String get hangulS7L4Step2Title => '발음 연습';

  @override
  String get hangulS7L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS7L4Step3Title => '듣고 고르기';

  @override
  String get hangulS7L4Step3Desc => '두 보기 중 정답을 선택하세요';

  @override
  String get hangulS7L4Step4Title => '레슨 완료!';

  @override
  String get hangulS7L4Step4Msg => '좋아요!\nㅅ/ㅆ 구분을 익혔어요.';

  @override
  String get hangulS7L5Title => 'ㅈ / ㅊ / ㅉ 구분';

  @override
  String get hangulS7L5Subtitle => '자 · 차 · 짜 대비';

  @override
  String get hangulS7L5Step0Title => '마지막 대비 묶음';

  @override
  String get hangulS7L5Step0Desc => 'ㅈ/ㅊ/ㅉ 소리를 비교해요.';

  @override
  String get hangulS7L5Step0Highlights => 'ㅈ,ㅊ,ㅉ,자,차,짜';

  @override
  String get hangulS7L5Step1Title => '소리 탐색';

  @override
  String get hangulS7L5Step1Desc => '자/차/짜를 반복해서 들어보세요';

  @override
  String get hangulS7L5Step2Title => '발음 연습';

  @override
  String get hangulS7L5Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS7L5Step3Title => '듣고 고르기';

  @override
  String get hangulS7L5Step3Desc => '세 보기 중 정답을 선택하세요';

  @override
  String get hangulS7L5Step4Title => '7단계 완료!';

  @override
  String get hangulS7L5Step4Msg => '축하해요!\n7단계 5개 대비 묶음을 모두 완료했어요.';

  @override
  String get hangulS7LMTitle => '미션: 소리 구분 도전!';

  @override
  String get hangulS7LMSubtitle => '평음, 거센소리, 된소리를 구분해요';

  @override
  String get hangulS7LMStep0Title => '소리 구분 미션!';

  @override
  String get hangulS7LMStep0Desc => '평음, 거센소리, 된소리를 섞어서\n음절을 빠르게 조합해요!';

  @override
  String get hangulS7LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS7LMStep2Title => '미션 결과';

  @override
  String get hangulS7LMStep3Title => '미션 완료!';

  @override
  String get hangulS7LMStep3Msg => '평음, 거센소리, 된소리를 구분할 수 있어요!';

  @override
  String get hangulS7LMStep4Title => 'Stage 7 완료!';

  @override
  String get hangulS7LMStep4Msg => '된소리와 거센소리를 구분할 수 있어요!';

  @override
  String get hangulS7CompleteTitle => 'Stage 7 완료!';

  @override
  String get hangulS7CompleteMsg => '된소리와 거센소리를 구분할 수 있어요!';

  @override
  String get hangulS8L0Title => '받침 개념';

  @override
  String get hangulS8L0Subtitle => '글자 아래 들어가는 소리';

  @override
  String get hangulS8L0Step0Title => '받침은 아래에 있어요';

  @override
  String get hangulS8L0Step0Desc => '받침은 음절 블록 아래쪽에 들어가요.\n예: 가 + ㄴ = 간';

  @override
  String get hangulS8L0Step0Highlights => '받침,간,말,집';

  @override
  String get hangulS8L0Step1Title => '받침의 7가지 대표 소리';

  @override
  String get hangulS8L0Step1Desc =>
      '받침에는 7가지 대표 소리만 있어요.\n\nㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\n여러 받침이 이 7가지 소리 중 하나로 발음돼요.\n예: ㅅ, ㅈ, ㅊ, ㅎ 받침 → 모두 [ㄷ] 소리';

  @override
  String get hangulS8L0Step1Highlights => '7가지,ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ,대표 소리';

  @override
  String get hangulS8L0Step2Title => '위치 확인';

  @override
  String get hangulS8L0Step2Desc => '받침 위치를 확인해요';

  @override
  String get hangulS8L0Step2Q0 => '간에서 받침은?';

  @override
  String get hangulS8L0Step2Q1 => '말에서 받침은?';

  @override
  String get hangulS8L0SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L0SummaryMsg => '좋아요!\n받침 개념을 이해했어요.';

  @override
  String get hangulS8L1Title => 'ㄴ 받침';

  @override
  String get hangulS8L1Subtitle => '간 · 난 · 단';

  @override
  String get hangulS8L1Step0Title => 'ㄴ 받침 소리 듣기';

  @override
  String get hangulS8L1Step0Desc => '간/난/단을 들어보세요';

  @override
  String get hangulS8L1Step1Title => '발음 연습';

  @override
  String get hangulS8L1Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS8L1Step2Title => '듣고 고르기';

  @override
  String get hangulS8L1Step2Desc => 'ㄴ 받침 음절을 선택하세요';

  @override
  String get hangulS8L1SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L1SummaryMsg => '좋아요!\nㄴ 받침을 익혔어요.';

  @override
  String get hangulS8L2Title => 'ㄹ 받침';

  @override
  String get hangulS8L2Subtitle => '말 · 갈 · 물';

  @override
  String get hangulS8L2Step0Title => 'ㄹ 받침 소리 듣기';

  @override
  String get hangulS8L2Step0Desc => '말/갈/물을 들어보세요';

  @override
  String get hangulS8L2Step1Title => '발음 연습';

  @override
  String get hangulS8L2Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS8L2Step2Title => '듣고 고르기';

  @override
  String get hangulS8L2Step2Desc => 'ㄹ 받침 음절을 선택하세요';

  @override
  String get hangulS8L2SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L2SummaryMsg => '좋아요!\nㄹ 받침을 익혔어요.';

  @override
  String get hangulS8L3Title => 'ㅁ 받침';

  @override
  String get hangulS8L3Subtitle => '감 · 밤 · 숨';

  @override
  String get hangulS8L3Step0Title => 'ㅁ 받침 소리 듣기';

  @override
  String get hangulS8L3Step0Desc => '감/밤/숨을 들어보세요';

  @override
  String get hangulS8L3Step1Title => '발음 연습';

  @override
  String get hangulS8L3Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS8L3Step2Title => '받침 구분';

  @override
  String get hangulS8L3Step2Desc => 'ㅁ 받침을 골라요';

  @override
  String get hangulS8L3Step2Q0 => '다음 중 ㅁ 받침은?';

  @override
  String get hangulS8L3Step2Q1 => '다음 중 ㅁ 받침은?';

  @override
  String get hangulS8L3SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L3SummaryMsg => '좋아요!\nㅁ 받침을 익혔어요.';

  @override
  String get hangulS8L4Title => 'ㅇ 받침';

  @override
  String get hangulS8L4Subtitle => '방 · 공 · 종';

  @override
  String get hangulS8L4Step0Title => 'ㅇ은 특별해요!';

  @override
  String get hangulS8L4Step0Desc =>
      'ㅇ은 특별해요!\n위(초성)에 있으면 소리가 없지만 (아, 오)\n아래(받침)에 있으면 \"ng\" 소리가 나요 (방, 공)';

  @override
  String get hangulS8L4Step0Highlights => '초성,받침,ng,방,공';

  @override
  String get hangulS8L4Step1Title => 'ㅇ 받침 소리 듣기';

  @override
  String get hangulS8L4Step1Desc => '방/공/종을 들어보세요';

  @override
  String get hangulS8L4Step2Title => '발음 연습';

  @override
  String get hangulS8L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS8L4Step3Title => '듣고 고르기';

  @override
  String get hangulS8L4Step3Desc => 'ㅇ 받침 음절을 선택하세요';

  @override
  String get hangulS8L4SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L4SummaryMsg => '좋아요!\nㅇ 받침을 익혔어요.';

  @override
  String get hangulS8L5Title => 'ㄱ 받침';

  @override
  String get hangulS8L5Subtitle => '박 · 각 · 국';

  @override
  String get hangulS8L5Step0Title => 'ㄱ 받침 소리 듣기';

  @override
  String get hangulS8L5Step0Desc => '박/각/국을 들어보세요';

  @override
  String get hangulS8L5Step1Title => '발음 연습';

  @override
  String get hangulS8L5Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS8L5Step2Title => '받침 구분';

  @override
  String get hangulS8L5Step2Desc => 'ㄱ 받침을 골라요';

  @override
  String get hangulS8L5Step2Q0 => '다음 중 ㄱ 받침은?';

  @override
  String get hangulS8L5Step2Q1 => '다음 중 ㄱ 받침은?';

  @override
  String get hangulS8L5SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L5SummaryMsg => '좋아요!\nㄱ 받침을 익혔어요.';

  @override
  String get hangulS8L6Title => 'ㅂ 받침';

  @override
  String get hangulS8L6Subtitle => '밥 · 집 · 숲';

  @override
  String get hangulS8L6Step0Title => 'ㅂ 받침 소리 듣기';

  @override
  String get hangulS8L6Step0Desc => '밥/집/숲을 들어보세요';

  @override
  String get hangulS8L6Step1Title => '발음 연습';

  @override
  String get hangulS8L6Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS8L6Step2Title => '듣고 고르기';

  @override
  String get hangulS8L6Step2Desc => 'ㅂ 받침 음절을 선택하세요';

  @override
  String get hangulS8L6SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L6SummaryMsg => '좋아요!\nㅂ 받침을 익혔어요.';

  @override
  String get hangulS8L7Title => 'ㅅ 받침';

  @override
  String get hangulS8L7Subtitle => '옷 · 맛 · 빛';

  @override
  String get hangulS8L7Step0Title => 'ㅅ 받침 소리 듣기';

  @override
  String get hangulS8L7Step0Desc => '옷/맛/빛을 들어보세요';

  @override
  String get hangulS8L7Step1Title => '발음 연습';

  @override
  String get hangulS8L7Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS8L7Step2Title => '받침 구분';

  @override
  String get hangulS8L7Step2Desc => 'ㅅ 받침을 골라요';

  @override
  String get hangulS8L7Step2Q0 => '다음 중 ㅅ 받침은?';

  @override
  String get hangulS8L7Step2Q1 => '다음 중 ㅅ 받침은?';

  @override
  String get hangulS8L7SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L7SummaryMsg => '좋아요!\nㅅ 받침을 익혔어요.';

  @override
  String get hangulS8L8Title => '받침 섞기 종합';

  @override
  String get hangulS8L8Subtitle => '핵심 받침 랜덤 점검';

  @override
  String get hangulS8L8Step0Title => '핵심 받침 섞기';

  @override
  String get hangulS8L8Step0Desc => 'ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ을 함께 점검해요.';

  @override
  String get hangulS8L8Step1Title => '랜덤 퀴즈';

  @override
  String get hangulS8L8Step1Desc => '여러 받침을 섞어서 확인해요';

  @override
  String get hangulS8L8Step1Q0 => '다음 중 ㄴ 받침은?';

  @override
  String get hangulS8L8Step1Q1 => '다음 중 ㅇ 받침은?';

  @override
  String get hangulS8L8Step1Q2 => '다음 중 ㄹ 받침은?';

  @override
  String get hangulS8L8Step1Q3 => '다음 중 ㅂ 받침은?';

  @override
  String get hangulS8L8SummaryTitle => '레슨 완료!';

  @override
  String get hangulS8L8SummaryMsg => '좋아요!\n핵심 받침 종합을 완료했어요.';

  @override
  String get hangulS8LMTitle => '미션: 받침 도전!';

  @override
  String get hangulS8LMSubtitle => '받침이 있는 음절을 조합해요';

  @override
  String get hangulS8LMStep0Title => '받침 미션!';

  @override
  String get hangulS8LMStep0Desc => '기본 받침이 있는 음절을 읽고\n빠르게 맞춰봐요!';

  @override
  String get hangulS8LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS8LMStep2Title => '미션 결과';

  @override
  String get hangulS8LMSummaryTitle => '미션 완료!';

  @override
  String get hangulS8LMSummaryMsg => '받침의 기초를 완전히 다졌어요!';

  @override
  String get hangulS8CompleteTitle => 'Stage 8 완료!';

  @override
  String get hangulS8CompleteMsg => '받침의 기초를 다졌어요!';

  @override
  String get hangulS9L1Title => 'ㄷ 받침 확장';

  @override
  String get hangulS9L1Subtitle => '닫 · 곧 · 묻';

  @override
  String get hangulS9L1Step0Title => 'ㄷ 받침 패턴';

  @override
  String get hangulS9L1Step0Desc => '받침 ㄷ이 들어간 음절을 읽어봐요.';

  @override
  String get hangulS9L1Step0Highlights => '닫,곧,묻';

  @override
  String get hangulS9L1Step1Title => 'ㄷ 받침 소리 듣기';

  @override
  String get hangulS9L1Step1Desc => '닫/곧/묻을 들어보세요';

  @override
  String get hangulS9L1Step2Title => '발음 연습';

  @override
  String get hangulS9L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS9L1Step3Title => '받침 구분';

  @override
  String get hangulS9L1Step3Desc => 'ㄷ 받침을 선택하세요';

  @override
  String get hangulS9L1Step3Q0 => '다음 중 ㄷ 받침은?';

  @override
  String get hangulS9L1Step3Q1 => '다음 중 ㄷ 받침은?';

  @override
  String get hangulS9L1Step4Title => '레슨 완료!';

  @override
  String get hangulS9L1Step4Msg => '좋아요!\nㄷ 받침 확장을 익혔어요.';

  @override
  String get hangulS9L2Title => 'ㅈ 받침 확장';

  @override
  String get hangulS9L2Subtitle => '낮 · 잊 · 젖';

  @override
  String get hangulS9L2Step0Title => 'ㅈ 받침 소리 듣기';

  @override
  String get hangulS9L2Step0Desc => '낮/잊/젖을 들어보세요';

  @override
  String get hangulS9L2Step1Title => '발음 연습';

  @override
  String get hangulS9L2Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS9L2Step2Title => '듣고 고르기';

  @override
  String get hangulS9L2Step2Desc => 'ㅈ 받침 음절을 고르세요';

  @override
  String get hangulS9L2Step3Title => '레슨 완료!';

  @override
  String get hangulS9L2Step3Msg => '좋아요!\nㅈ 받침 확장을 익혔어요.';

  @override
  String get hangulS9L3Title => 'ㅊ 받침 확장';

  @override
  String get hangulS9L3Subtitle => '꽃 · 닻 · 빚';

  @override
  String get hangulS9L3Step0Title => 'ㅊ 받침 소리 듣기';

  @override
  String get hangulS9L3Step0Desc => '꽃/닻/빚을 들어보세요';

  @override
  String get hangulS9L3Step1Title => '발음 연습';

  @override
  String get hangulS9L3Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS9L3Step2Title => '받침 구분';

  @override
  String get hangulS9L3Step2Desc => 'ㅊ 받침을 선택하세요';

  @override
  String get hangulS9L3Step2Q0 => '다음 중 ㅊ 받침은?';

  @override
  String get hangulS9L3Step2Q1 => '다음 중 ㅊ 받침은?';

  @override
  String get hangulS9L3Step3Title => '레슨 완료!';

  @override
  String get hangulS9L3Step3Msg => '좋아요!\nㅊ 받침 확장을 익혔어요.';

  @override
  String get hangulS9L4Title => 'ㅋ / ㅌ / ㅍ 받침';

  @override
  String get hangulS9L4Subtitle => '부엌 · 밭 · 앞';

  @override
  String get hangulS9L4Step0Title => '세 받침 묶음';

  @override
  String get hangulS9L4Step0Desc => 'ㅋ/ㅌ/ㅍ 받침을 묶어서 익혀요.';

  @override
  String get hangulS9L4Step0Highlights => '부엌,밭,앞';

  @override
  String get hangulS9L4Step1Title => '소리 듣기';

  @override
  String get hangulS9L4Step1Desc => '부엌/밭/앞을 들어보세요';

  @override
  String get hangulS9L4Step2Title => '발음 연습';

  @override
  String get hangulS9L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS9L4Step3Title => '받침 구분';

  @override
  String get hangulS9L4Step3Desc => '세 받침을 구분해요';

  @override
  String get hangulS9L4Step3Q0 => '다음 중 ㅌ 받침은?';

  @override
  String get hangulS9L4Step3Q1 => '다음 중 ㅍ 받침은?';

  @override
  String get hangulS9L4Step4Title => '레슨 완료!';

  @override
  String get hangulS9L4Step4Msg => '좋아요!\nㅋ/ㅌ/ㅍ 받침을 익혔어요.';

  @override
  String get hangulS9L5Title => 'ㅎ 받침 확장';

  @override
  String get hangulS9L5Subtitle => '좋 · 놓 · 않';

  @override
  String get hangulS9L5Step0Title => 'ㅎ 받침 소리 듣기';

  @override
  String get hangulS9L5Step0Desc => '좋/놓/않을 들어보세요';

  @override
  String get hangulS9L5Step1Title => '발음 연습';

  @override
  String get hangulS9L5Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS9L5Step2Title => '듣고 고르기';

  @override
  String get hangulS9L5Step2Desc => 'ㅎ 받침 음절을 고르세요';

  @override
  String get hangulS9L5Step3Title => '레슨 완료!';

  @override
  String get hangulS9L5Step3Msg => '좋아요!\nㅎ 받침 확장을 익혔어요.';

  @override
  String get hangulS9L6Title => '확장 받침 랜덤';

  @override
  String get hangulS9L6Subtitle => 'ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ 섞기';

  @override
  String get hangulS9L6Step0Title => '확장 받침 섞기';

  @override
  String get hangulS9L6Step0Desc => '확장 받침군을 랜덤으로 점검해요.';

  @override
  String get hangulS9L6Step1Title => '랜덤 퀴즈';

  @override
  String get hangulS9L6Step1Desc => '문제를 풀며 구분해요';

  @override
  String get hangulS9L6Step1Q0 => '다음 중 ㄷ 받침은?';

  @override
  String get hangulS9L6Step1Q1 => '다음 중 ㅈ 받침은?';

  @override
  String get hangulS9L6Step1Q2 => '다음 중 ㅊ 받침은?';

  @override
  String get hangulS9L6Step1Q3 => '다음 중 ㅎ 받침은?';

  @override
  String get hangulS9L6Step2Title => '레슨 완료!';

  @override
  String get hangulS9L6Step2Msg => '좋아요!\n확장 받침 랜덤 점검을 완료했어요.';

  @override
  String get hangulS9L7Title => '9단계 종합';

  @override
  String get hangulS9L7Subtitle => '확장 받침 읽기 마무리';

  @override
  String get hangulS9L7Step0Title => '종합 확인';

  @override
  String get hangulS9L7Step0Desc => '9단계 핵심을 최종 점검해요';

  @override
  String get hangulS9L7Step1Title => '9단계 완료!';

  @override
  String get hangulS9L7Step1Msg => '축하해요!\n9단계 받침 확장을 완료했어요.';

  @override
  String get hangulS9LMTitle => '미션: 확장 받침 도전!';

  @override
  String get hangulS9LMSubtitle => '다양한 받침을 빠르게 읽어요';

  @override
  String get hangulS9LMStep0Title => '확장 받침 미션!';

  @override
  String get hangulS9LMStep0Desc => '확장 받침이 포함된 음절을\n빠르게 조합해요!';

  @override
  String get hangulS9LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS9LMStep2Title => '미션 결과';

  @override
  String get hangulS9LMStep3Title => '미션 완료!';

  @override
  String get hangulS9LMStep3Msg => '확장 받침까지 정복했어요!';

  @override
  String get hangulS9CompleteTitle => 'Stage 9 완료!';

  @override
  String get hangulS9CompleteMsg => '확장 받침까지 정복했어요!';

  @override
  String get hangulS10L1Title => 'ㄳ 받침';

  @override
  String get hangulS10L1Subtitle => '몫 · 넋 중심 읽기';

  @override
  String get hangulS10L1Step0Title => '겹받침의 발음 규칙';

  @override
  String get hangulS10L1Step0Desc =>
      '겹받침은 두 자음이 합쳐진 받침이에요.\n\n대부분 왼쪽 자음이 발음돼요:\nㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\n일부는 오른쪽 자음이 발음돼요:\nㄺ→[ㄹ], ㄼ→[ㄹ]';

  @override
  String get hangulS10L1Step0Highlights => '왼쪽 자음,오른쪽 자음,겹받침';

  @override
  String get hangulS10L1Step1Title => '복합 받침 시작';

  @override
  String get hangulS10L1Step1Desc => 'ㄳ 받침이 들어간 단어를 읽어봐요.';

  @override
  String get hangulS10L1Step1Highlights => '몫,넋';

  @override
  String get hangulS10L1Step2Title => '소리 듣기';

  @override
  String get hangulS10L1Step2Desc => '몫/넋을 들어보세요';

  @override
  String get hangulS10L1Step3Title => '발음 연습';

  @override
  String get hangulS10L1Step3Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS10L1Step4Title => '읽기 확인';

  @override
  String get hangulS10L1Step4Desc => '단어를 보고 고르세요';

  @override
  String get hangulS10L1Step4Q0 => 'ㄳ 받침 단어는?';

  @override
  String get hangulS10L1Step4Q1 => 'ㄳ 받침 단어는?';

  @override
  String get hangulS10L1Step5Title => '레슨 완료!';

  @override
  String get hangulS10L1Step5Msg => '좋아요!\nㄳ 받침을 익혔어요.';

  @override
  String get hangulS10L2Title => 'ㄵ / ㄶ 받침';

  @override
  String get hangulS10L2Subtitle => '앉다 · 많다';

  @override
  String get hangulS10L2Step0Title => '소리 듣기';

  @override
  String get hangulS10L2Step0Desc => '앉다/많다를 들어보세요';

  @override
  String get hangulS10L2Step1Title => '발음 연습';

  @override
  String get hangulS10L2Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS10L2Step2Title => '듣고 고르기';

  @override
  String get hangulS10L2Step2Desc => '정답 단어를 선택하세요';

  @override
  String get hangulS10L2Step3Title => '레슨 완료!';

  @override
  String get hangulS10L2Step3Msg => '좋아요!\nㄵ/ㄶ 받침을 익혔어요.';

  @override
  String get hangulS10L3Title => 'ㄺ / ㄻ 받침';

  @override
  String get hangulS10L3Subtitle => '읽다 · 삶';

  @override
  String get hangulS10L3Step0Title => '소리 듣기';

  @override
  String get hangulS10L3Step0Desc => '읽다/삶을 들어보세요';

  @override
  String get hangulS10L3Step1Title => '발음 연습';

  @override
  String get hangulS10L3Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS10L3Step2Title => '읽기 확인';

  @override
  String get hangulS10L3Step2Desc => '복합 받침 단어를 고르세요';

  @override
  String get hangulS10L3Step2Q0 => 'ㄺ 받침 단어는?';

  @override
  String get hangulS10L3Step2Q1 => 'ㄻ 받침 단어는?';

  @override
  String get hangulS10L3Step3Title => '레슨 완료!';

  @override
  String get hangulS10L3Step3Msg => '좋아요!\nㄺ/ㄻ 받침을 익혔어요.';

  @override
  String get hangulS10L4Title => '고급 묶음 1';

  @override
  String get hangulS10L4Subtitle => 'ㄼ · ㄾ · ㄿ · ㅀ';

  @override
  String get hangulS10L4Step0Title => '고급 묶음 노출';

  @override
  String get hangulS10L4Step0Desc => '자주 보이는 예시 중심으로 짧게 익혀요.';

  @override
  String get hangulS10L4Step0Highlights => '넓다,핥다,읊다,싫다';

  @override
  String get hangulS10L4Step1Title => '단어 소리 듣기';

  @override
  String get hangulS10L4Step1Desc => '넓다/핥다/읊다/싫다를 들어보세요';

  @override
  String get hangulS10L4Step2Title => '발음 연습';

  @override
  String get hangulS10L4Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS10L4Step3Title => '레슨 완료!';

  @override
  String get hangulS10L4Step3Msg => '좋아요!\n고급 묶음 1을 익혔어요.';

  @override
  String get hangulS10L5Title => 'ㅄ 받침';

  @override
  String get hangulS10L5Subtitle => '없다 중심 읽기';

  @override
  String get hangulS10L5Step0Title => '소리 듣기';

  @override
  String get hangulS10L5Step0Desc => '없다/없어를 들어보세요';

  @override
  String get hangulS10L5Step1Title => '발음 연습';

  @override
  String get hangulS10L5Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS10L5Step2Title => '듣고 고르기';

  @override
  String get hangulS10L5Step2Desc => '정답 단어를 고르세요';

  @override
  String get hangulS10L5Step3Title => '레슨 완료!';

  @override
  String get hangulS10L5Step3Msg => '좋아요!\nㅄ 받침을 익혔어요.';

  @override
  String get hangulS10L6Title => '10단계 종합';

  @override
  String get hangulS10L6Subtitle => '복합 받침 단어 통합';

  @override
  String get hangulS10L6Step0Title => '종합 점검';

  @override
  String get hangulS10L6Step0Desc => '복합 받침 단어를 최종 점검해요';

  @override
  String get hangulS10L6Step0Q0 => '다음 중 ㄶ 받침 단어는?';

  @override
  String get hangulS10L6Step0Q1 => '다음 중 ㄺ 받침 단어는?';

  @override
  String get hangulS10L6Step0Q2 => '다음 중 ㅄ 받침 단어는?';

  @override
  String get hangulS10L6Step0Q3 => '다음 중 ㄳ 받침 단어는?';

  @override
  String get hangulS10L6Step1Title => '10단계 완료!';

  @override
  String get hangulS10L6Step1Msg => '축하해요!\n10단계 복합 받침을 완료했어요.';

  @override
  String get hangulS10LMTitle => '미션: 겹받침 도전!';

  @override
  String get hangulS10LMSubtitle => '겹받침 단어를 빠르게 읽어요';

  @override
  String get hangulS10LMStep0Title => '겹받침 미션!';

  @override
  String get hangulS10LMStep0Desc => '겹받침이 포함된 음절을\n빠르게 조합해요!';

  @override
  String get hangulS10LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS10LMStep2Title => '미션 결과';

  @override
  String get hangulS10LMStep3Title => '미션 완료!';

  @override
  String get hangulS10LMStep3Msg => '겹받침까지 마스터했어요!';

  @override
  String get hangulS10LMStep4Title => 'Stage 10 완료!';

  @override
  String get hangulS10CompleteTitle => '10단계 완료!';

  @override
  String get hangulS10CompleteMsg => '겹받침까지 마스터했어요!';

  @override
  String get hangulS11L1Title => '받침 없는 단어';

  @override
  String get hangulS11L1Subtitle => '아주 쉬운 2~3음절 단어';

  @override
  String get hangulS11L1Step0Title => '단어 읽기 시작';

  @override
  String get hangulS11L1Step0Desc => '먼저 받침 없는 단어로 자신감을 만들어요.';

  @override
  String get hangulS11L1Step0Highlights => '바나나,나비,하마,모자';

  @override
  String get hangulS11L1Step1Title => '단어 소리 듣기';

  @override
  String get hangulS11L1Step1Desc => '바나나/나비/하마/모자를 들어보세요';

  @override
  String get hangulS11L1Step2Title => '발음 연습';

  @override
  String get hangulS11L1Step2Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS11L1Step3Title => '레슨 완료!';

  @override
  String get hangulS11L1Step3Msg => '좋아요!\n받침 없는 단어 읽기를 시작했어요.';

  @override
  String get hangulS11L2Title => '기본 받침 단어';

  @override
  String get hangulS11L2Subtitle => '학교 · 친구 · 한국 · 공부';

  @override
  String get hangulS11L2Step0Title => '단어 소리 듣기';

  @override
  String get hangulS11L2Step0Desc => '학교/친구/한국/공부를 들어보세요';

  @override
  String get hangulS11L2Step1Title => '발음 연습';

  @override
  String get hangulS11L2Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS11L2Step2Title => '듣고 고르기';

  @override
  String get hangulS11L2Step2Desc => '들린 단어를 선택하세요';

  @override
  String get hangulS11L2Step3Title => '레슨 완료!';

  @override
  String get hangulS11L2Step3Msg => '좋아요!\n기본 받침 단어를 읽었어요.';

  @override
  String get hangulS11L3Title => '받침 혼합 단어';

  @override
  String get hangulS11L3Subtitle => '읽기 · 없다 · 많다 · 닭';

  @override
  String get hangulS11L3Step0Title => '난이도 올리기';

  @override
  String get hangulS11L3Step0Desc => '기본/복합 받침이 섞인 단어를 읽어봐요.';

  @override
  String get hangulS11L3Step0Highlights => '읽기,없다,많다,닭';

  @override
  String get hangulS11L3Step1Title => '단어 구분';

  @override
  String get hangulS11L3Step1Desc => '비슷한 단어를 구분해요';

  @override
  String get hangulS11L3Step1Q0 => '다음 중 복합 받침 단어는?';

  @override
  String get hangulS11L3Step1Q1 => '다음 중 복합 받침 단어는?';

  @override
  String get hangulS11L3Step2Title => '레슨 완료!';

  @override
  String get hangulS11L3Step2Msg => '좋아요!\n받침 혼합 단어를 읽었어요.';

  @override
  String get hangulS11L4Title => '카테고리 단어팩';

  @override
  String get hangulS11L4Subtitle => '음식 · 장소 · 사람';

  @override
  String get hangulS11L4Step0Title => '카테고리 단어 듣기';

  @override
  String get hangulS11L4Step0Desc => '음식/장소/사람 단어를 들어보세요';

  @override
  String get hangulS11L4Step1Title => '발음 연습';

  @override
  String get hangulS11L4Step1Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS11L4Step2Title => '카테고리 분류';

  @override
  String get hangulS11L4Step2Desc => '단어를 보고 카테고리를 고르세요';

  @override
  String get hangulS11L4Step2Q0 => '\"김치\"는?';

  @override
  String get hangulS11L4Step2Q1 => '\"시장\"은?';

  @override
  String get hangulS11L4Step2Q2 => '\"학생\"은?';

  @override
  String get hangulS11L4Step2CatFood => '음식';

  @override
  String get hangulS11L4Step2CatPlace => '장소';

  @override
  String get hangulS11L4Step2CatPerson => '사람';

  @override
  String get hangulS11L4Step3Title => '레슨 완료!';

  @override
  String get hangulS11L4Step3Msg => '좋아요!\n카테고리 단어를 익혔어요.';

  @override
  String get hangulS11L5Title => '듣고 고르는 단어';

  @override
  String get hangulS11L5Subtitle => '청각-읽기 연결 강화';

  @override
  String get hangulS11L5Step0Title => '소리 매칭';

  @override
  String get hangulS11L5Step0Desc => '소리를 듣고 정답 단어를 고르세요';

  @override
  String get hangulS11L5Step1Title => '레슨 완료!';

  @override
  String get hangulS11L5Step1Msg => '좋아요!\n듣고 고르는 단어 훈련을 마쳤어요.';

  @override
  String get hangulS11L6Title => '11단계 종합';

  @override
  String get hangulS11L6Subtitle => '단어 읽기 최종 점검';

  @override
  String get hangulS11L6Step0Title => '종합 퀴즈';

  @override
  String get hangulS11L6Step0Desc => '11단계 단어를 종합 점검해요';

  @override
  String get hangulS11L6Step0Q0 => '다음 중 받침 없는 단어는?';

  @override
  String get hangulS11L6Step0Q1 => '다음 중 기본 받침 단어는?';

  @override
  String get hangulS11L6Step0Q2 => '다음 중 복합 받침 단어는?';

  @override
  String get hangulS11L6Step0Q3 => '다음 중 장소 단어는?';

  @override
  String get hangulS11L6Step1Title => '11단계 완료!';

  @override
  String get hangulS11L6Step1Msg => '축하해요!\n11단계 단어 읽기 확장을 완료했어요.';

  @override
  String get hangulS11L7Title => '실생활 한국어 읽기';

  @override
  String get hangulS11L7Subtitle => '카페 메뉴, 지하철, 인사를 읽어봐요';

  @override
  String get hangulS11L7Step0Title => '한국에서 한글 읽기!';

  @override
  String get hangulS11L7Step0Desc =>
      '이제 한글을 다 배웠어요!\n실제 한국에서 볼 수 있는 글자를 읽어볼까요?';

  @override
  String get hangulS11L7Step0Highlights => '카페,지하철,인사';

  @override
  String get hangulS11L7Step1Title => '카페 메뉴 읽기';

  @override
  String get hangulS11L7Step1Descs => '아메리카노,카페라떼,녹차,케이크';

  @override
  String get hangulS11L7Step2Title => '지하철역 이름 읽기';

  @override
  String get hangulS11L7Step2Descs => '서울역,강남,홍대입구,명동';

  @override
  String get hangulS11L7Step3Title => '기본 인사 읽기';

  @override
  String get hangulS11L7Step3Descs => '안녕하세요,감사합니다,네,아니요';

  @override
  String get hangulS11L7Step4Title => '발음 연습';

  @override
  String get hangulS11L7Step4Desc => '글자를 직접 소리내어 보세요';

  @override
  String get hangulS11L7Step5Title => '어디에서 볼 수 있을까요?';

  @override
  String get hangulS11L7Step5Q0 => '\"아메리카노\"는 어디에서 볼 수 있을까요?';

  @override
  String get hangulS11L7Step5Q0Ans => '카페';

  @override
  String get hangulS11L7Step5Q0C0 => '카페';

  @override
  String get hangulS11L7Step5Q0C1 => '지하철';

  @override
  String get hangulS11L7Step5Q0C2 => '학교';

  @override
  String get hangulS11L7Step5Q1 => '\"강남\"은 무엇일까요?';

  @override
  String get hangulS11L7Step5Q1Ans => '지하철역 이름';

  @override
  String get hangulS11L7Step5Q1C0 => '음식 이름';

  @override
  String get hangulS11L7Step5Q1C1 => '지하철역 이름';

  @override
  String get hangulS11L7Step5Q1C2 => '인사';

  @override
  String get hangulS11L7Step5Q2 => '\"감사합니다\"는 영어로?';

  @override
  String get hangulS11L7Step5Q2Ans => 'Thank you';

  @override
  String get hangulS11L7Step5Q2C0 => 'Hello';

  @override
  String get hangulS11L7Step5Q2C1 => 'Thank you';

  @override
  String get hangulS11L7Step5Q2C2 => 'Goodbye';

  @override
  String get hangulS11L7Step6Title => '축하해요!';

  @override
  String get hangulS11L7Step6Msg =>
      '이제 한국에서 카페 메뉴, 지하철역, 인사를 읽을 수 있어요!\n한글 마스터까지 거의 다 왔어요!';

  @override
  String get hangulS11LMTitle => '미션: 한글 속독!';

  @override
  String get hangulS11LMSubtitle => '한국어 단어를 빠르게 읽어요';

  @override
  String get hangulS11LMStep0Title => '한글 속독 미션!';

  @override
  String get hangulS11LMStep0Desc => '한국어 단어를 빠르게 읽고 맞춰봐요!\n실력을 증명할 시간이에요!';

  @override
  String get hangulS11LMStep1Title => '음절을 조합하세요!';

  @override
  String get hangulS11LMStep2Title => '미션 결과';

  @override
  String get hangulS11LMStep3Title => '한글 마스터!';

  @override
  String get hangulS11LMStep3Msg => '한글을 완전히 마스터했어요!\n이제 한국어 단어와 문장을 읽을 수 있어요!';

  @override
  String get hangulS11LMStep4Title => 'Stage 11 완료!';

  @override
  String get hangulS11LMStep4Msg => '한글을 완전히 읽을 수 있어요!';

  @override
  String get hangulS11CompleteTitle => 'Stage 11 완료!';

  @override
  String get hangulS11CompleteMsg => '한글을 완전히 읽을 수 있어요!';

  @override
  String get stageRequestFailed => '무대 요청을 보내지 못했습니다. 다시 시도해 주세요.';

  @override
  String get stageRequestRejected => '호스트가 무대 요청을 거절했습니다.';

  @override
  String get inviteToStageFailed => '무대 초대에 실패했습니다. 무대가 가득 찼을 수 있습니다.';

  @override
  String get demoteFailed => '무대에서 내리기 실패했습니다. 다시 시도해 주세요.';

  @override
  String get voiceRoomCloseRoomFailed => '방 닫기에 실패했습니다. 다시 시도해 주세요.';
}
