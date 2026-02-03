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
  String get lessonComplete => '강의 완료!';

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
  String get grammarExplanation => '문법 설명';

  @override
  String get exampleSentences => '예문';

  @override
  String get previous => '이전';

  @override
  String get next => '다음';

  @override
  String get continueBtn => '계속';

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
  String get fillBlank => '빈칸 채우기';

  @override
  String get translation => '번역';

  @override
  String get wordOrder => '순서 맞추기';

  @override
  String get pronunciation => '발음';

  @override
  String get excellent => '훌륭합니다!';

  @override
  String get correctOrderIs => '올바른 순서:';

  @override
  String get correctAnswerIs => '정답:';

  @override
  String get previousQuestion => '이전 문제';

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
  String get home => '홈';

  @override
  String get lessons => '강의';

  @override
  String get review => '복습';

  @override
  String get profile => '내 정보';

  @override
  String get continueLearning => '계속 학습';

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
  String get onboardingLanguageTitle => '레몬 한국어';

  @override
  String get onboardingLanguagePrompt => '선호하는 언어를 선택하세요';

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
  String get goalCasualTime => '~주당 10-20분';

  @override
  String get goalCasualHelper => '바쁜 일정에 완벽';

  @override
  String get goalRegular => '규칙적으로';

  @override
  String get goalRegularDesc => '주당 3-4과';

  @override
  String get goalRegularTime => '~주당 30-40분';

  @override
  String get goalRegularHelper => '부담 없이 꾸준한 진전';

  @override
  String get goalSerious => '열심히';

  @override
  String get goalSeriousDesc => '주당 5-6과';

  @override
  String get goalSeriousTime => '~주당 50-60분';

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
}
