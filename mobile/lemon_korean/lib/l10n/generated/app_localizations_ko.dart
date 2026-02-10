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
  String get lessonComplete => '과정 완료! 진행 상황이 저장되었습니다';

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
  String correctAnswerIs(String answer) {
    return '정답: $answer';
  }

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
  String grammarPattern(String pattern) {
    return '문법 · $pattern';
  }

  @override
  String get conjugationRule => '활용 규칙';

  @override
  String get comparisonWithChinese => '중국어와 비교';

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
  String get checkAnswerBtn => '정답 확인';

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
  String get userNotFound => '유저를 찾을 수 없습니다';
}
