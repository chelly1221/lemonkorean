// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Lemon Korean';

  @override
  String get login => 'Log In';

  @override
  String get register => 'Sign Up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get username => 'Username';

  @override
  String get enterEmail => 'Enter your email address';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get enterConfirmPassword => 'Enter your password again';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get createAccount => 'Create Account';

  @override
  String get startJourney => 'Start your Korean learning journey';

  @override
  String get interfaceLanguage => 'Interface Language';

  @override
  String get simplifiedChinese => 'Simplified Chinese';

  @override
  String get traditionalChinese => 'Traditional Chinese';

  @override
  String get passwordRequirements => 'Password Requirements';

  @override
  String minCharacters(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'At least $count characters',
      one: 'At least $count character',
    );
    return '$_temp0';
  }

  @override
  String get containLettersNumbers => 'Contains letters and numbers';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get loginNow => 'Log in now';

  @override
  String get registerNow => 'Sign up now';

  @override
  String get registerSuccess => 'Registration successful';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get networkError =>
      'Unable to connect. Please check your internet connection and try again.';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get emailAlreadyExists => 'Email is already registered';

  @override
  String get requestTimeout => 'Request timed out. Please try again.';

  @override
  String get operationFailed => 'Something went wrong. Please try again later.';

  @override
  String get settings => 'Settings';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String get chineseDisplay => 'Chinese Display';

  @override
  String get chineseDisplayDesc =>
      'Choose how Chinese characters are displayed. Changes will be applied to all screens immediately.';

  @override
  String get switchedToSimplified => 'Switched to Simplified Chinese';

  @override
  String get switchedToTraditional => 'Switched to Traditional Chinese';

  @override
  String get displayTip =>
      'Tip: Lesson content will be displayed using your selected Chinese font.';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get enableNotificationsDesc => 'Turn on to receive learning reminders';

  @override
  String get permissionRequired =>
      'Please allow notification permissions in system settings';

  @override
  String get dailyLearningReminder => 'Daily Learning Reminder';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String get dailyReminderDesc => 'Get a daily reminder at your chosen time';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String reminderTimeSet(String time) {
    return 'Reminder time set to $time';
  }

  @override
  String get reviewReminder => 'Review Reminder';

  @override
  String get reviewReminderDesc =>
      'Get review reminders based on spaced repetition';

  @override
  String get notificationTip => 'Tip:';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get offlineLearning => 'Offline Learning';

  @override
  String get howToDownload => 'How do I download lessons?';

  @override
  String get howToDownloadAnswer =>
      'In the lesson list, tap the download icon on the right to download a lesson. You can study offline after downloading.';

  @override
  String get howToUseDownloaded => 'How do I use downloaded lessons?';

  @override
  String get howToUseDownloadedAnswer =>
      'You can study downloaded lessons normally even without network connection. Progress is saved locally and automatically synced when you reconnect.';

  @override
  String get storageManagement => 'Storage Management';

  @override
  String get howToCheckStorage => 'How do I check storage space?';

  @override
  String get howToCheckStorageAnswer =>
      'Go to [Settings → Storage Management] to view used and available storage space.';

  @override
  String get howToDeleteDownloaded => 'How do I delete downloaded lessons?';

  @override
  String get howToDeleteDownloadedAnswer =>
      'In [Storage Management], tap the delete button next to the lesson to delete it.';

  @override
  String get notificationSection => 'Notification Settings';

  @override
  String get howToEnableReminder => 'How do I enable learning reminders?';

  @override
  String get howToEnableReminderAnswer =>
      'Go to [Settings → Notification Settings] and turn on [Enable Notifications]. You need to grant notification permissions on first use.';

  @override
  String get whatIsReviewReminder => 'What is a review reminder?';

  @override
  String get whatIsReviewReminderAnswer =>
      'Based on the spaced repetition algorithm (SRS), the app will remind you to review completed lessons at optimal times. Review intervals: 1 day → 3 days → 7 days → 14 days → 30 days.';

  @override
  String get languageSection => 'Language Settings';

  @override
  String get howToSwitchChinese =>
      'How do I switch between Simplified and Traditional Chinese?';

  @override
  String get howToSwitchChineseAnswer =>
      'Go to [Settings → Language Settings] and select [Simplified Chinese] or [Traditional Chinese]. Changes take effect immediately.';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get howToStart => 'How do I start learning?';

  @override
  String get howToStartAnswer =>
      'On the main screen, select a lesson appropriate for your level and start from Lesson 1. Each lesson consists of 7 stages.';

  @override
  String get progressNotSaved => 'What if my progress isn\'t saved?';

  @override
  String get progressNotSavedAnswer =>
      'Progress is automatically saved locally. If online, it will automatically sync to the server. Please check your network connection.';

  @override
  String get aboutApp => 'About App';

  @override
  String get moreInfo => 'More Information';

  @override
  String get versionInfo => 'Version Info';

  @override
  String get developer => 'Developer';

  @override
  String get appIntro => 'App Introduction';

  @override
  String get appIntroContent =>
      'A Korean learning app with offline learning, smart review reminders, and more.';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get termsComingSoon => 'Terms of Service page is under development...';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyComingSoon => 'Privacy Policy page is under development...';

  @override
  String get openSourceLicenses => 'Open Source Licenses';

  @override
  String get notStarted => 'Not Started';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get notPassed => 'Not Passed';

  @override
  String get timeToReview => 'Time to Review';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String daysLater(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'In $count day',
    );
    return '$_temp0';
  }

  @override
  String get noun => 'Noun';

  @override
  String get verb => 'Verb';

  @override
  String get adjective => 'Adjective';

  @override
  String get adverb => 'Adverb';

  @override
  String get particle => 'Particle';

  @override
  String get pronoun => 'Pronoun';

  @override
  String get highSimilarity => 'High Similarity';

  @override
  String get mediumSimilarity => 'Medium Similarity';

  @override
  String get lowSimilarity => 'Low Similarity';

  @override
  String get learningComplete => 'Learning Complete';

  @override
  String experiencePoints(int points) {
    return '+$points XP';
  }

  @override
  String get keepLearning => 'Keep up your learning momentum';

  @override
  String get streakDays => 'Streak +1 day';

  @override
  String streakDaysCount(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Learning streak: $days days',
      one: 'Learning streak: $days day',
    );
    return '$_temp0';
  }

  @override
  String get lessonContent => 'Lesson Content';

  @override
  String get words => 'Words';

  @override
  String get grammarPoints => 'Grammar Points';

  @override
  String get dialogues => 'Dialogues';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get topicParticle => 'Topic Particle';

  @override
  String get honorificEnding => 'Honorific Ending';

  @override
  String get questionWord => 'What';

  @override
  String get hello => 'Hello';

  @override
  String get thankYou => 'Thank you';

  @override
  String get goodbye => 'Goodbye';

  @override
  String get sorry => 'Sorry';

  @override
  String get imStudent => 'I am a student';

  @override
  String get bookInteresting => 'The book is interesting';

  @override
  String get isStudent => 'is a student';

  @override
  String get isTeacher => 'is a teacher';

  @override
  String get whatIsThis => 'What is this?';

  @override
  String get whatDoingPolite => 'What are you doing?';

  @override
  String get listenAndChoose => 'Listen and choose the correct translation';

  @override
  String get fillInBlank => 'Fill in the correct particle';

  @override
  String get chooseTranslation => 'Choose the correct translation';

  @override
  String get arrangeWords => 'Arrange the words in the correct order';

  @override
  String get choosePronunciation => 'Choose the correct pronunciation';

  @override
  String get consonantEnding =>
      'Which topic particle should be used when a noun ends in a consonant?';

  @override
  String get correctSentence => 'Choose the correct sentence';

  @override
  String get allCorrect => 'All of the above';

  @override
  String get howAreYou => 'How are you?';

  @override
  String get whatIsYourName => 'What is your name?';

  @override
  String get whoAreYou => 'Who are you?';

  @override
  String get whereAreYou => 'Where are you?';

  @override
  String get niceToMeetYou => 'Nice to meet you';

  @override
  String get areYouStudent => 'You are a student';

  @override
  String get areYouStudentQuestion => 'Are you a student?';

  @override
  String get amIStudent => 'Am I a student?';

  @override
  String get listening => 'Listening';

  @override
  String get translation => 'Translation';

  @override
  String get wordOrder => 'Word Order';

  @override
  String get excellent => 'Excellent!';

  @override
  String get correctOrderIs => 'Correct order:';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get finish => 'Finish';

  @override
  String get quizComplete => 'Quiz Complete!';

  @override
  String get greatJob => 'Great Job!';

  @override
  String get keepPracticing => 'Keep it up!';

  @override
  String score(int correct, int total) {
    return 'Score: $correct / $total';
  }

  @override
  String get masteredContent => 'You\'ve mastered this lesson\'s content!';

  @override
  String get reviewSuggestion =>
      'Try reviewing the lesson content before trying again!';

  @override
  String timeUsed(String time) {
    return 'Time: $time';
  }

  @override
  String get playAudio => 'Play Audio';

  @override
  String get replayAudio => 'Replay';

  @override
  String get vowelEnding => 'When ending in a vowel, use:';

  @override
  String lessonNumber(int number) {
    return 'Lesson $number';
  }

  @override
  String get stageIntro => 'Introduction';

  @override
  String get stageVocabulary => 'Vocabulary';

  @override
  String get stageGrammar => 'Grammar';

  @override
  String get stagePractice => 'Practice';

  @override
  String get stageDialogue => 'Dialogue';

  @override
  String get stageQuiz => 'Quiz';

  @override
  String get stageSummary => 'Summary';

  @override
  String get downloadLesson => 'Download Lesson';

  @override
  String get downloading => 'Downloading...';

  @override
  String get downloaded => 'Downloaded';

  @override
  String get downloadFailed => 'Download Failed';

  @override
  String get home => 'Home';

  @override
  String get lessons => 'Lessons';

  @override
  String get review => 'Review';

  @override
  String get profile => 'Profile';

  @override
  String get continueLearning => 'Continue Learning';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String lessonsCompleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lessons completed',
      one: '$count lesson completed',
    );
    return '$_temp0';
  }

  @override
  String minutesLearned(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min studied',
      one: '$minutes min studied',
    );
    return '$_temp0';
  }

  @override
  String get welcome => 'Welcome back';

  @override
  String get goodMorning => 'Good morning';

  @override
  String get goodAfternoon => 'Good afternoon';

  @override
  String get goodEvening => 'Good evening';

  @override
  String get logout => 'Log Out';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get error => 'An error occurred';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get reload => 'Reload';

  @override
  String get noCharactersAvailable => 'No characters available';

  @override
  String get success => 'Success';

  @override
  String get filter => 'Filter';

  @override
  String get reviewSchedule => 'Review Schedule';

  @override
  String get todayReview => 'Today\'s Review';

  @override
  String get startReview => 'Start Review';

  @override
  String get learningStats => 'Learning Statistics';

  @override
  String get completedLessonsCount => 'Completed Lessons';

  @override
  String get studyDays => 'Study Days';

  @override
  String get masteredWordsCount => 'Mastered Words';

  @override
  String get myVocabularyBook => 'My Vocabulary Book';

  @override
  String get vocabularyBrowser => 'Vocabulary Browser';

  @override
  String get about => 'About';

  @override
  String get premiumMember => 'Premium Member';

  @override
  String get freeUser => 'Free User';

  @override
  String wordsWaitingReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words to review',
      one: '$count word to review',
    );
    return '$_temp0';
  }

  @override
  String get user => 'User';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingLanguageTitle => 'Nice to meet you! I\'m Moni';

  @override
  String get onboardingLanguagePrompt =>
      'Which language shall we start learning?';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingWelcome =>
      'Hi! I\'m Lemon from Lemon Korean 🍋\nWant to learn Korean together?';

  @override
  String get onboardingLevelQuestion => 'What\'s your current Korean level?';

  @override
  String get onboardingStart => 'Get Started';

  @override
  String get onboardingStartWithoutLevel => 'Skip and Get Started';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelBeginnerDesc => 'Let\'s start from Hangul!';

  @override
  String get levelElementary => 'Elementary';

  @override
  String get levelElementaryDesc => 'Practice basic conversations!';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelIntermediateDesc => 'Let\'s speak more naturally!';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelAdvancedDesc => 'Master detailed expressions!';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Lemon Korean!';

  @override
  String get onboardingWelcomeSubtitle => 'Your journey to fluency starts here';

  @override
  String get onboardingFeature1Title => 'Learn Offline Anytime';

  @override
  String get onboardingFeature1Desc =>
      'Download lessons and study without internet';

  @override
  String get onboardingFeature2Title => 'Smart Review System';

  @override
  String get onboardingFeature2Desc =>
      'AI-powered spaced repetition for better retention';

  @override
  String get onboardingFeature3Title => '7-Stage Learning Path';

  @override
  String get onboardingFeature3Desc =>
      'Structured curriculum from beginner to advanced';

  @override
  String get onboardingLevelTitle => 'What\'s your Korean level?';

  @override
  String get onboardingLevelSubtitle => 'We\'ll personalize your experience';

  @override
  String get onboardingGoalTitle => 'Set your weekly goal';

  @override
  String get onboardingGoalSubtitle => 'How much time can you dedicate?';

  @override
  String get goalCasual => 'Casual';

  @override
  String get goalCasualDesc => '1-2 lessons per week';

  @override
  String get goalCasualTime => '~10-20 min/week';

  @override
  String get goalCasualHelper => 'Perfect for busy schedules';

  @override
  String get goalRegular => 'Regular';

  @override
  String get goalRegularDesc => '3-4 lessons per week';

  @override
  String get goalRegularTime => '~30-40 min/week';

  @override
  String get goalRegularHelper => 'Steady progress without pressure';

  @override
  String get goalSerious => 'Serious';

  @override
  String get goalSeriousDesc => '5-6 lessons per week';

  @override
  String get goalSeriousTime => '~50-60 min/week';

  @override
  String get goalSeriousHelper => 'Committed to fast improvement';

  @override
  String get goalIntensive => 'Intensive';

  @override
  String get goalIntensiveDesc => 'Daily practice';

  @override
  String get goalIntensiveTime => '60+ min/week';

  @override
  String get goalIntensiveHelper => 'Maximum learning speed';

  @override
  String get onboardingCompleteTitle => 'You\'re all set!';

  @override
  String get onboardingCompleteSubtitle => 'Let\'s start your learning journey';

  @override
  String get onboardingSummaryLanguage => 'Interface Language';

  @override
  String get onboardingSummaryLevel => 'Korean Level';

  @override
  String get onboardingSummaryGoal => 'Weekly Goal';

  @override
  String get onboardingStartLearning => 'Start Learning';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingAccountTitle => 'Ready to start?';

  @override
  String get onboardingAccountSubtitle =>
      'Log in or create an account to save your progress';

  @override
  String levelTopik(String level) {
    return 'TOPIK $level';
  }

  @override
  String get appLanguage => 'App Language';

  @override
  String get appLanguageDesc => 'Select the language for the app interface.';

  @override
  String languageSelected(String language) {
    return '$language selected';
  }

  @override
  String get sort => 'Sort';

  @override
  String get notificationTipContent =>
      '• Review reminders are automatically scheduled after completing a lesson\n• Some devices may need to disable battery saver in system settings to receive notifications properly';

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '$count day ago',
    );
    return '$_temp0';
  }

  @override
  String dateFormat(int month, int day) {
    return '$month/$day';
  }

  @override
  String get downloadManager => 'Download Manager';

  @override
  String get storageInfo => 'Storage Info';

  @override
  String get clearAllDownloads => 'Clear All';

  @override
  String get downloadedTab => 'Downloaded';

  @override
  String get availableTab => 'Available';

  @override
  String get downloadedLessons => 'Downloaded Lessons';

  @override
  String get mediaFiles => 'Media Files';

  @override
  String get usedStorage => 'In Use';

  @override
  String get cacheStorage => 'Cache';

  @override
  String get totalStorage => 'Total';

  @override
  String get allDownloadsCleared => 'All downloads cleared';

  @override
  String get availableStorage => 'Available';

  @override
  String get noDownloadedLessons => 'No downloaded lessons';

  @override
  String get goToAvailableTab => 'Go to \"Available\" tab to download lessons';

  @override
  String get allLessonsDownloaded => 'All lessons downloaded';

  @override
  String get deleteDownload => 'Delete Download';

  @override
  String confirmDeleteDownload(String title) {
    return 'Are you sure you want to delete \"$title\"?';
  }

  @override
  String confirmClearAllDownloads(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Are you sure you want to delete all $count downloads?',
      one: 'Are you sure you want to delete $count download?',
    );
    return '$_temp0';
  }

  @override
  String downloadingCount(int count) {
    return 'Downloading ($count)';
  }

  @override
  String get preparing => 'Preparing...';

  @override
  String lessonId(int id) {
    return 'Lesson $id';
  }

  @override
  String get searchWords => 'Search words...';

  @override
  String wordCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '$count word',
    );
    return '$_temp0';
  }

  @override
  String get sortByLesson => 'By Lesson';

  @override
  String get sortByKorean => 'By Korean';

  @override
  String get sortByChinese => 'By Chinese';

  @override
  String get noWordsFound => 'No words found';

  @override
  String get noMasteredWords => 'No mastered words yet';

  @override
  String get hanja => 'Hanja';

  @override
  String get exampleSentence => 'Example';

  @override
  String get mastered => 'Mastered';

  @override
  String get completedLessons => 'Completed Lessons';

  @override
  String get noCompletedLessons => 'No completed lessons';

  @override
  String get startFirstLesson => 'Start your first lesson!';

  @override
  String get masteredWords => 'Mastered Words';

  @override
  String get download => 'Download';

  @override
  String get hangulLearning => 'Korean Alphabet';

  @override
  String get hangulLearningSubtitle => 'Learn 40 Korean alphabet letters';

  @override
  String get editNotes => 'Edit Notes';

  @override
  String get notes => 'Notes';

  @override
  String get notesHint => 'Why are you bookmarking this word?';

  @override
  String get sortBy => 'Sort by';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sortKorean => 'Korean';

  @override
  String get sortChinese => 'Chinese';

  @override
  String get sortMastery => 'Mastery level';

  @override
  String get filterAll => 'All';

  @override
  String get filterNew => 'New (Level 0)';

  @override
  String get filterBeginner => 'Beginner (Level 1)';

  @override
  String get filterIntermediate => 'Intermediate (Level 2-3)';

  @override
  String get filterAdvanced => 'Advanced (Level 4-5)';

  @override
  String get searchWordsNotesChinese => 'Search words, meaning, or notes...';

  @override
  String startReviewCount(int count) {
    return 'Start Review ($count)';
  }

  @override
  String get remove => 'Remove';

  @override
  String get confirmRemove => 'Confirm Remove';

  @override
  String confirmRemoveWord(String word) {
    return 'Remove \"$word\" from vocabulary book?';
  }

  @override
  String get noBookmarkedWords => 'No bookmarked words yet';

  @override
  String get bookmarkHint =>
      'Tap the bookmark icon on word cards while learning';

  @override
  String get noMatchingWords => 'No matching words found';

  @override
  String weeksAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks ago',
      one: '$count week ago',
    );
    return '$_temp0';
  }

  @override
  String get reviewComplete => 'Review Complete!';

  @override
  String reviewCompleteCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reviewed $count words',
      one: 'Reviewed $count word',
    );
    return '$_temp0';
  }

  @override
  String get correct => 'Correct';

  @override
  String get wrong => 'Wrong';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get vocabularyBookReview => 'Vocabulary Book Review';

  @override
  String get noWordsToReview => 'No words to review';

  @override
  String get bookmarkWordsToReview =>
      'Bookmark words while learning to review them later';

  @override
  String get returnToVocabularyBook => 'Return to Vocabulary Book';

  @override
  String get exit => 'Exit';

  @override
  String get showAnswer => 'Show Answer';

  @override
  String get didYouRemember => 'Did you remember?';

  @override
  String get forgot => 'Forgot';

  @override
  String get hard => 'Hard';

  @override
  String get remembered => 'Remembered';

  @override
  String get easy => 'Easy';

  @override
  String get addedToVocabularyBook => 'Added to vocabulary book';

  @override
  String get addFailed => 'Failed to add';

  @override
  String get removedFromVocabularyBook => 'Removed from vocabulary book';

  @override
  String get removeFailed => 'Failed to remove';

  @override
  String get addToVocabularyBook => 'Add to Vocabulary Book';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get add => 'Add';

  @override
  String get bookmarked => 'Bookmarked';

  @override
  String get bookmark => 'Bookmark';

  @override
  String get removeFromVocabularyBook => 'Remove from vocabulary book';

  @override
  String similarityPercent(int percent) {
    return 'Similarity: $percent%';
  }

  @override
  String addedOrRemoved(String added) {
    String _temp0 = intl.Intl.selectLogic(
      added,
      {
        'true': 'Added to vocabulary book',
        'other': 'Bookmark removed',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => 'days';

  @override
  String lessonsCompletedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lessons completed',
      one: '$count lesson completed',
    );
    return '$_temp0';
  }

  @override
  String get dailyGoalComplete => 'Daily goal achieved!';

  @override
  String get hangulAlphabet => 'Hangul';

  @override
  String get alphabetTable => 'Table';

  @override
  String get learn => 'Learn';

  @override
  String get practice => 'Practice';

  @override
  String get learningProgress => 'Learning Progress';

  @override
  String dueForReviewCount(int count) {
    return '$count due for review';
  }

  @override
  String get completion => 'Completion';

  @override
  String get totalCharacters => 'Total';

  @override
  String get learned => 'Learned';

  @override
  String get dueForReview => 'Due for Review';

  @override
  String overallAccuracy(String percent) {
    return 'Overall accuracy: $percent%';
  }

  @override
  String charactersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count characters',
      one: '$count character',
    );
    return '$_temp0';
  }

  @override
  String get lesson1Title => 'Lesson 1: Basic Consonants (1)';

  @override
  String get lesson1Desc => 'Learn 7 most common consonants';

  @override
  String get lesson2Title => 'Lesson 2: Basic Consonants (2)';

  @override
  String get lesson2Desc => 'Learn remaining 7 basic consonants';

  @override
  String get lesson3Title => 'Lesson 3: Basic Vowels (1)';

  @override
  String get lesson3Desc => 'Learn 5 basic vowels';

  @override
  String get lesson4Title => 'Lesson 4: Basic Vowels (2)';

  @override
  String get lesson4Desc => 'Learn remaining 5 basic vowels';

  @override
  String get lesson5Title => 'Lesson 5: Double Consonants';

  @override
  String get lesson5Desc => 'Learn 5 double consonants - tense sounds';

  @override
  String get lesson6Title => 'Lesson 6: Compound Vowels (1)';

  @override
  String get lesson6Desc => 'Learn 6 compound vowels';

  @override
  String get lesson7Title => 'Lesson 7: Compound Vowels (2)';

  @override
  String get lesson7Desc => 'Learn remaining compound vowels';

  @override
  String get loadAlphabetFirst => 'Please visit the Alphabet section first';

  @override
  String get noContentForLesson => 'No content for this lesson';

  @override
  String get exampleWords => 'Example Words';

  @override
  String get thisLessonCharacters => 'Characters in this lesson';

  @override
  String congratsLessonComplete(String title) {
    return 'Congratulations on completing $title!';
  }

  @override
  String get continuePractice => 'Continue Practice';

  @override
  String get nextLesson => 'Next Lesson';

  @override
  String get basicConsonants => 'Basic Consonants';

  @override
  String get doubleConsonants => 'Double Consonants';

  @override
  String get basicVowels => 'Basic Vowels';

  @override
  String get compoundVowels => 'Compound Vowels';

  @override
  String get dailyLearningReminderTitle => 'Daily Learning Reminder';

  @override
  String get dailyLearningReminderBody =>
      'Time to complete today\'s Korean study!';

  @override
  String get reviewReminderTitle => 'Time to Review!';

  @override
  String reviewReminderBody(String title) {
    return 'Time to review \"$title\"!';
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
  String get strokeOrder => 'Stroke Order';

  @override
  String get reset => 'Reset';

  @override
  String get pronunciationGuide => 'Pronunciation Guide';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String loadingFailed(String error) {
    return 'Loading failed: $error';
  }

  @override
  String learnedCount(int count) {
    return 'Learned: $count';
  }

  @override
  String get hangulPractice => 'Hangul Practice';

  @override
  String charactersNeedReview(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count characters need review',
      one: '$count character needs review',
    );
    return '$_temp0';
  }

  @override
  String charactersAvailable(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count characters available',
      one: '$count character available',
    );
    return '$_temp0';
  }

  @override
  String get selectPracticeMode => 'Select Practice Mode';

  @override
  String get characterRecognition => 'Character Recognition';

  @override
  String get characterRecognitionDesc =>
      'See the character, choose the correct pronunciation';

  @override
  String get pronunciationPractice => 'Pronunciation Practice';

  @override
  String get pronunciationPracticeDesc =>
      'See the pronunciation, choose the correct character';

  @override
  String get startPractice => 'Start Practice';

  @override
  String get learnSomeCharactersFirst =>
      'Please learn some characters in the alphabet first';

  @override
  String get practiceComplete => 'Practice Complete!';

  @override
  String get back => 'Back';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get howToReadThis => 'How do you read this character?';

  @override
  String get selectCorrectCharacter => 'Select the correct character';

  @override
  String get correctExclamation => 'Correct!';

  @override
  String get incorrectExclamation => 'Incorrect';

  @override
  String get correctAnswerLabel => 'Correct answer: ';

  @override
  String get nextQuestionBtn => 'Next Question';

  @override
  String get viewResults => 'View Results';

  @override
  String get share => 'Share';

  @override
  String get mnemonics => 'Memory Tips';

  @override
  String nextReviewLabel(String date) {
    return 'Next review: $date';
  }

  @override
  String get expired => 'Expired';

  @override
  String get practiceFunctionDeveloping => 'Practice mode coming soon';

  @override
  String get romanization => 'Romanization: ';

  @override
  String get pronunciationLabel => 'Pronunciation: ';

  @override
  String get playPronunciation => 'Play pronunciation';

  @override
  String strokesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count strokes',
      one: '$count stroke',
    );
    return '$_temp0';
  }

  @override
  String get perfectCount => 'Perfect';

  @override
  String get loadFailed => 'Load failed';

  @override
  String countUnit(int count) {
    return '$count';
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
  String get lesson1TitleKo => 'Lesson 1: Basic Consonants (1)';

  @override
  String get lesson2TitleKo => 'Lesson 2: Basic Consonants (2)';

  @override
  String get lesson3TitleKo => 'Lesson 3: Basic Vowels (1)';

  @override
  String get lesson4TitleKo => 'Lesson 4: Basic Vowels (2)';

  @override
  String get lesson5TitleKo => 'Lesson 5: Double Consonants';

  @override
  String get lesson6TitleKo => 'Lesson 6: Compound Vowels (1)';

  @override
  String get lesson7TitleKo => 'Lesson 7: Compound Vowels (2)';

  @override
  String get exitLesson => 'Exit Lesson';

  @override
  String get exitLessonConfirm =>
      'Are you sure you want to exit? Your progress will be saved.';

  @override
  String get exitBtn => 'Exit';

  @override
  String get lessonComplete => 'Lesson complete! Progress saved';

  @override
  String loadingLesson(String title) {
    return 'Loading $title...';
  }

  @override
  String get cannotLoadContent => 'Cannot load lesson content';

  @override
  String get noLessonContent => 'No content available for this lesson';

  @override
  String stageProgress(int current, int total) {
    return 'Stage $current / $total';
  }

  @override
  String unknownStageType(String type) {
    return 'Unknown stage type: $type';
  }

  @override
  String wordsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count words',
      one: '$count word',
    );
    return '$_temp0';
  }

  @override
  String get startLearning => 'Start Learning';

  @override
  String get vocabularyLearning => 'Vocabulary Learning';

  @override
  String get noImage => 'No image';

  @override
  String get previousItem => 'Previous';

  @override
  String get nextItem => 'Next';

  @override
  String get continueBtn => 'Continue';

  @override
  String get previousQuestion => 'Previous Question';

  @override
  String get playingAudio => 'Playing...';

  @override
  String get playAll => 'Play All';

  @override
  String audioPlayFailed(String error) {
    return 'Audio playback failed: $error';
  }

  @override
  String get stopBtn => 'Stop';

  @override
  String get playAudioBtn => 'Play Audio';

  @override
  String get playingAudioShort => 'Playing audio...';

  @override
  String get pronunciation => 'Pronunciation';

  @override
  String grammarPattern(String pattern) {
    return 'Grammar · $pattern';
  }

  @override
  String get grammarExplanation => 'Grammar Explanation';

  @override
  String get conjugationRule => 'Conjugation Rule';

  @override
  String get comparisonWithChinese => 'Comparison with Chinese';

  @override
  String get exampleSentences => 'Example Sentences';

  @override
  String get dialogueTitle => 'Dialogue Practice';

  @override
  String get dialogueExplanation => 'Dialogue Analysis';

  @override
  String speaker(String name) {
    return 'Speaker $name';
  }

  @override
  String get practiceTitle => 'Practice';

  @override
  String get practiceInstructions => 'Complete the following exercises';

  @override
  String get fillBlank => 'Fill in the blank';

  @override
  String get checkAnswerBtn => 'Check Answer';

  @override
  String correctAnswerIs(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String get quizTitle => 'Quiz';

  @override
  String get quizResult => 'Quiz Result';

  @override
  String quizScoreDisplay(int correct, int total) {
    return '$correct/$total';
  }

  @override
  String quizAccuracy(int percent) {
    return 'Accuracy: $percent%';
  }

  @override
  String get summaryTitle => 'Lesson Summary';

  @override
  String get vocabLearned => 'Vocabulary Learned';

  @override
  String get grammarLearned => 'Grammar Learned';

  @override
  String get finishLesson => 'Finish Lesson';

  @override
  String get reviewVocab => 'Review Vocabulary';

  @override
  String similarity(int percent) {
    return 'Similarity: $percent%';
  }

  @override
  String get partOfSpeechNoun => 'Noun';

  @override
  String get partOfSpeechVerb => 'Verb';

  @override
  String get partOfSpeechAdjective => 'Adjective';

  @override
  String get partOfSpeechAdverb => 'Adverb';

  @override
  String get partOfSpeechPronoun => 'Pronoun';

  @override
  String get partOfSpeechParticle => 'Particle';

  @override
  String get partOfSpeechConjunction => 'Conjunction';

  @override
  String get partOfSpeechInterjection => 'Interjection';

  @override
  String get noVocabulary => 'No vocabulary data';

  @override
  String get noGrammar => 'No grammar data';

  @override
  String get noPractice => 'No practice questions';

  @override
  String get noDialogue => 'No dialogue content';

  @override
  String get noQuiz => 'No quiz questions';

  @override
  String get tapToFlip => 'Tap to flip';

  @override
  String get listeningQuestion => 'Listening';

  @override
  String get submit => 'Submit';

  @override
  String timeStudied(String time) {
    return 'Studied $time';
  }

  @override
  String get statusNotStarted => 'Not Started';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusFailed => 'Not Passed';

  @override
  String get masteryNew => 'New';

  @override
  String get masteryLearning => 'Learning';

  @override
  String get masteryFamiliar => 'Familiar';

  @override
  String get masteryMastered => 'Mastered';

  @override
  String get masteryExpert => 'Expert';

  @override
  String get masteryPerfect => 'Perfect';

  @override
  String get masteryUnknown => 'Unknown';

  @override
  String get dueForReviewNow => 'Due for review';

  @override
  String get similarityHigh => 'High similarity';

  @override
  String get similarityMedium => 'Medium similarity';

  @override
  String get similarityLow => 'Low similarity';

  @override
  String get typeBasicConsonant => 'Basic Consonant';

  @override
  String get typeDoubleConsonant => 'Double Consonant';

  @override
  String get typeBasicVowel => 'Basic Vowel';

  @override
  String get typeCompoundVowel => 'Compound Vowel';

  @override
  String get typeFinalConsonant => 'Final Consonant';

  @override
  String get dailyReminderChannel => 'Daily Study Reminder';

  @override
  String get dailyReminderChannelDesc =>
      'Reminds you to study Korean at a set time daily';

  @override
  String get reviewReminderChannel => 'Review Reminder';

  @override
  String get reviewReminderChannelDesc =>
      'Spaced repetition based review reminders';

  @override
  String get notificationStudyTime => 'Time to study!';

  @override
  String get notificationStudyReminder =>
      'Don\'t forget to complete your daily Korean practice!';

  @override
  String get notificationReviewTime => 'Time to review!';

  @override
  String get notificationReviewReminder =>
      'Let\'s review what you\'ve learned!';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return 'Time to review \"$lessonTitle\"!';
  }

  @override
  String get keepGoing => 'Keep going!';

  @override
  String scoreDisplay(int correct, int total) {
    return 'Score: $correct / $total';
  }

  @override
  String loadDataError(String error) {
    return 'Failed to load data: $error';
  }

  @override
  String downloadError(String error) {
    return 'Download error: $error';
  }

  @override
  String deleteError(String error) {
    return 'Delete failed: $error';
  }

  @override
  String clearAllError(String error) {
    return 'Clear all failed: $error';
  }

  @override
  String cleanupError(String error) {
    return 'Cleanup failed: $error';
  }

  @override
  String downloadLessonFailed(String title) {
    return 'Download failed: $title';
  }

  @override
  String get comprehensive => 'Comprehensive';

  @override
  String answeredCount(int answered, int total) {
    return 'Answered $answered/$total';
  }

  @override
  String get hanjaWord => 'Hanja word';

  @override
  String get tapToFlipBack => 'Tap to flip back';

  @override
  String get similarityWithChinese => 'Similarity with Chinese';

  @override
  String get hanjaWordSimilarPronunciation =>
      'Hanja word, similar pronunciation';

  @override
  String get sameEtymologyEasyToRemember => 'Same etymology, easy to remember';

  @override
  String get someConnection => 'Some connection';

  @override
  String get nativeWordNeedsMemorization => 'Native word, needs memorization';

  @override
  String get rules => 'Rules';

  @override
  String get koreanLanguage => '🇰🇷 Korean';

  @override
  String get chineseLanguage => '🇨🇳 Chinese';

  @override
  String exampleNumber(int number) {
    return 'Ex. $number';
  }

  @override
  String get fillInBlankPrompt => 'Fill in blank:';

  @override
  String get correctFeedback => 'Excellent! Correct!';

  @override
  String get incorrectFeedback => 'Not quite, try again';

  @override
  String get allStagesPassed => 'All 7 stages passed';

  @override
  String get continueToLearnMore => 'Continue learning more';

  @override
  String timeFormatHMS(int hours, int minutes, int seconds) {
    return '${hours}h ${minutes}m ${seconds}s';
  }

  @override
  String timeFormatMS(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String timeFormatS(int seconds) {
    return '${seconds}s';
  }

  @override
  String get repeatEnabled => 'Repeat enabled';

  @override
  String get repeatDisabled => 'Repeat disabled';

  @override
  String get stop => 'Stop';

  @override
  String get playbackSpeed => 'Playback speed';

  @override
  String get slowSpeed => 'Slow';

  @override
  String get normalSpeed => 'Normal';

  @override
  String get mouthShape => 'Mouth shape';

  @override
  String get tonguePosition => 'Tongue position';

  @override
  String get airFlow => 'Air flow';

  @override
  String get nativeComparison => 'Native language comparison';

  @override
  String get similarSounds => 'Similar sounds';

  @override
  String get soundDiscrimination => 'Sound discrimination';

  @override
  String get listenAndSelect => 'Listen and select the correct character';

  @override
  String get similarSoundGroups => 'Similar sound groups';

  @override
  String get plainSound => 'Plain';

  @override
  String get aspiratedSound => 'Aspirated';

  @override
  String get tenseSound => 'Tense';

  @override
  String get writingPractice => 'Writing practice';

  @override
  String get watchAnimation => 'Watch animation';

  @override
  String get traceWithGuide => 'Trace with guide';

  @override
  String get freehandWriting => 'Freehand writing';

  @override
  String get clearCanvas => 'Clear';

  @override
  String get showGuide => 'Show guide';

  @override
  String get hideGuide => 'Hide guide';

  @override
  String get writingAccuracy => 'Accuracy';

  @override
  String get tryAgainWriting => 'Try again';

  @override
  String get nextStep => 'Next step';

  @override
  String strokeOrderStep(int current, int total) {
    return 'Step $current/$total';
  }

  @override
  String get syllableCombination => 'Syllable combination';

  @override
  String get selectConsonant => 'Select consonant';

  @override
  String get selectVowel => 'Select vowel';

  @override
  String get selectFinalConsonant => 'Select final consonant (optional)';

  @override
  String get noFinalConsonant => 'No final consonant';

  @override
  String get combinedSyllable => 'Combined syllable';

  @override
  String get playSyllable => 'Play syllable';

  @override
  String get decomposeSyllable => 'Decompose syllable';

  @override
  String get batchimPractice => 'Batchim practice';

  @override
  String get batchimExplanation => 'Batchim explanation';

  @override
  String get recordPronunciation => 'Record pronunciation';

  @override
  String get startRecording => 'Start recording';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get playRecording => 'Play recording';

  @override
  String get compareWithNative => 'Compare with native';

  @override
  String get shadowingMode => 'Shadowing mode';

  @override
  String get listenThenRepeat => 'Listen then repeat';

  @override
  String get selfEvaluation => 'Self evaluation';

  @override
  String get accurate => 'Accurate';

  @override
  String get almostCorrect => 'Almost correct';

  @override
  String get needsPractice => 'Needs practice';

  @override
  String get recordingNotSupported =>
      'Recording is not supported on this platform';

  @override
  String get showMeaning => 'Show meaning';

  @override
  String get hideMeaning => 'Hide meaning';

  @override
  String get exampleWord => 'Example word';

  @override
  String get meaningToggle => 'Meaning display setting';

  @override
  String get microphonePermissionRequired =>
      'Microphone permission is required for recording';

  @override
  String get activities => 'Activities';

  @override
  String get listeningAndSpeaking => 'Listening & Speaking';

  @override
  String get readingAndWriting => 'Reading & Writing';

  @override
  String get soundDiscriminationDesc =>
      'Train your ear to distinguish similar sounds';

  @override
  String get shadowingDesc => 'Listen and repeat after native speakers';

  @override
  String get syllableCombinationDesc =>
      'Learn how consonants and vowels combine';

  @override
  String get batchimPracticeDesc => 'Practice final consonant sounds';

  @override
  String get writingPracticeDesc => 'Practice writing Korean characters';

  @override
  String get webNotSupported => 'Not available on web';

  @override
  String get chapter => 'Chapter';

  @override
  String get bossQuiz => 'Boss Quiz';

  @override
  String get bossQuizCleared => 'Boss Quiz Cleared!';

  @override
  String get bossQuizBonus => 'Bonus Lemons';

  @override
  String get lemonsScoreHint95 => 'Score 95%+ for 3 lemons';

  @override
  String get lemonsScoreHint80 => 'Score 80%+ for 2 lemons';

  @override
  String get myLemonTree => 'My Lemon Tree';

  @override
  String get harvestLemon => 'Harvest Lemon';

  @override
  String get watchAdToHarvest => 'Watch an ad to harvest this lemon?';

  @override
  String get lemonHarvested => 'Lemon harvested!';

  @override
  String get lemonsAvailable => 'lemons available';

  @override
  String get completeMoreLessons => 'Complete more lessons to grow lemons';

  @override
  String get totalLemons => 'Total Lemons';

  @override
  String get community => 'Community';

  @override
  String get following => 'Following';

  @override
  String get discover => 'Discover';

  @override
  String get createPost => 'Create Post';

  @override
  String get writePost => 'Write a post...';

  @override
  String get postCategory => 'Category';

  @override
  String get categoryLearning => 'Learning';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categoryAll => 'All';

  @override
  String get post => 'Post';

  @override
  String get like => 'Like';

  @override
  String get comment => 'Comment';

  @override
  String get writeComment => 'Write a comment...';

  @override
  String replyingTo(String name) {
    return 'Replying to $name';
  }

  @override
  String get reply => 'Reply';

  @override
  String get deletePost => 'Delete Post';

  @override
  String get deletePostConfirm => 'Are you sure you want to delete this post?';

  @override
  String get deleteComment => 'Delete Comment';

  @override
  String get postDeleted => 'Post deleted';

  @override
  String get commentDeleted => 'Comment deleted';

  @override
  String get noPostsYet => 'No posts yet';

  @override
  String get followToSeePosts => 'Follow users to see their posts here';

  @override
  String get discoverPosts => 'Discover posts from the community';

  @override
  String get seeMore => 'See more';

  @override
  String get followers => 'Followers';

  @override
  String get followingLabel => 'Following';

  @override
  String get posts => 'Posts';

  @override
  String get follow => 'Follow';

  @override
  String get unfollow => 'Unfollow';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Tell us about yourself...';

  @override
  String get searchUsers => 'Search users...';

  @override
  String get suggestedUsers => 'Suggested Users';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get report => 'Report';

  @override
  String get reportContent => 'Report Content';

  @override
  String get reportReason => 'Reason for reporting';

  @override
  String get reportSubmitted => 'Report submitted';

  @override
  String get blockUser => 'Block User';

  @override
  String get unblockUser => 'Unblock User';

  @override
  String get userBlocked => 'User blocked';

  @override
  String get userUnblocked => 'User unblocked';

  @override
  String get postCreated => 'Post created!';

  @override
  String likesCount(int count) {
    return '$count likes';
  }

  @override
  String commentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comments',
      one: '$count comment',
    );
    return '$_temp0';
  }

  @override
  String followersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count followers',
      one: '$count follower',
    );
    return '$_temp0';
  }

  @override
  String followingCount(int count) {
    return '$count following';
  }

  @override
  String get findFriends => 'Find Friends';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String maxPhotos(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Max $count photos',
      one: 'Max $count photo',
    );
    return '$_temp0';
  }

  @override
  String get visibility => 'Visibility';

  @override
  String get visibilityPublic => 'Public';

  @override
  String get visibilityFollowers => 'Followers Only';

  @override
  String get noFollowingPosts => 'No posts from people you follow yet';

  @override
  String get all => 'All';

  @override
  String get learning => 'Learning';

  @override
  String get general => 'General';

  @override
  String get linkCopied => 'Link copied';

  @override
  String get postFailed => 'Failed to post';

  @override
  String get newPost => 'New Post';

  @override
  String get category => 'Category';

  @override
  String get writeYourThoughts => 'Share your thoughts...';

  @override
  String get photos => 'Photos';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get imageUrlHint => 'Enter image URL';

  @override
  String get noSuggestions =>
      'No suggestions available. Try searching for users!';

  @override
  String get noResults => 'No users found';

  @override
  String get postDetail => 'Post';

  @override
  String get comments => 'Comments';

  @override
  String get noComments => 'No comments yet. Be the first!';

  @override
  String get deleteCommentConfirm =>
      'Are you sure you want to delete this comment?';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get userNotFound => 'User not found';

  @override
  String get message => 'Message';

  @override
  String get messages => 'Messages';

  @override
  String get noMessages => 'No messages yet';

  @override
  String get startConversation => 'Start a conversation with someone!';

  @override
  String get noMessagesYet => 'No messages yet. Say hello!';

  @override
  String get typing => 'typing...';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get createVoiceRoom => 'Create Voice Room';

  @override
  String get roomTitle => 'Room Title';

  @override
  String get roomTitleHint => 'e.g. Korean Conversation Practice';

  @override
  String get topic => 'Topic';

  @override
  String get topicHint => 'What would you like to talk about?';

  @override
  String get languageLevel => 'Language Level';

  @override
  String get allLevels => 'All Levels';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get stageSlots => 'Max Speakers';

  @override
  String get anyoneCanListen => 'Anyone can join to listen';

  @override
  String get createAndJoin => 'Create & Join';

  @override
  String get unmute => 'Unmute';

  @override
  String get mute => 'Mute';

  @override
  String get leave => 'Leave';

  @override
  String get closeRoom => 'Close Room';

  @override
  String get emojiReaction => 'React';

  @override
  String get gesture => 'Gesture';

  @override
  String get raiseHand => 'Raise Hand';

  @override
  String get cancelRequest => 'Cancel';

  @override
  String get leaveStage => 'Leave Stage';

  @override
  String get pendingRequests => 'Requests';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String get stageRequests => 'Stage Requests';

  @override
  String get noPendingRequests => 'No pending requests';

  @override
  String get onStage => 'On Stage';

  @override
  String get voiceRooms => 'Voice Rooms';

  @override
  String get noVoiceRooms => 'No active voice rooms';

  @override
  String get createVoiceRoomHint => 'Create one to start talking!';

  @override
  String get createRoom => 'Create Room';

  @override
  String get voiceRoomMicPermission =>
      'Microphone permission is required for voice rooms';

  @override
  String get voiceRoomEnterTitle => 'Please enter a room title';

  @override
  String get voiceRoomCreateFailed => 'Failed to create room';

  @override
  String get voiceRoomNotAvailable => 'Room not available';

  @override
  String get voiceRoomGoBack => 'Go Back';

  @override
  String get voiceRoomConnecting => 'Connecting...';

  @override
  String voiceRoomReconnecting(int attempts, int max) {
    return 'Reconnecting ($attempts/$max)...';
  }

  @override
  String get voiceRoomDisconnected => 'Disconnected';

  @override
  String get voiceRoomRetry => 'Retry';

  @override
  String get voiceRoomHostLabel => '(Host)';

  @override
  String get voiceRoomDemoteToListener => 'Demote to listener';

  @override
  String get voiceRoomKickFromRoom => 'Kick from room';

  @override
  String get voiceRoomListeners => 'Listeners';

  @override
  String get voiceRoomInviteToStage => 'Invite to Stage';

  @override
  String voiceRoomInviteConfirm(String name) {
    return 'Invite $name to speak on stage?';
  }

  @override
  String get voiceRoomInvite => 'Invite';

  @override
  String get voiceRoomCloseConfirmTitle => 'Close Room?';

  @override
  String get voiceRoomCloseConfirmBody =>
      'This will end the call for everyone.';

  @override
  String get voiceRoomNoMessagesYet => 'No messages yet';

  @override
  String get voiceRoomTypeMessage => 'Type a message...';

  @override
  String get voiceRoomStageFull => 'Stage Full';

  @override
  String voiceRoomListenerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count listeners',
      one: '$count listener',
    );
    return '$_temp0';
  }

  @override
  String get voiceRoomRemoveFromStage => 'Remove from Stage?';

  @override
  String voiceRoomRemoveFromStageConfirm(String name) {
    return 'Remove $name from stage? They will become a listener.';
  }

  @override
  String get voiceRoomDemote => 'Demote';

  @override
  String get voiceRoomRemoveFromRoom => 'Remove from Room?';

  @override
  String voiceRoomRemoveFromRoomConfirm(String name) {
    return 'Remove $name from the room? They will be disconnected.';
  }

  @override
  String get voiceRoomRemove => 'Remove';

  @override
  String get voiceRoomPressBackToLeave => 'Press back again to leave';

  @override
  String get voiceRoomLeaveTitle => 'Leave Room?';

  @override
  String get voiceRoomLeaveBody =>
      'You are currently on stage. Are you sure you want to leave?';

  @override
  String get voiceRoomReturningToList => 'Returning to room list...';

  @override
  String get voiceRoomConnected => 'Connected!';

  @override
  String get voiceRoomStageFailedToLoad => 'Stage failed to load';

  @override
  String get voiceRoomPreparingStage => 'Preparing stage...';

  @override
  String voiceRoomAcceptToStage(Object name) {
    return 'Accept $name to stage';
  }

  @override
  String voiceRoomRejectFromStage(Object name) {
    return 'Reject $name';
  }

  @override
  String get voiceRoomQuickCreate => 'Quick Create';

  @override
  String get voiceRoomRoomType => 'Room Type';

  @override
  String get voiceRoomSessionDuration => 'Session Duration';

  @override
  String get voiceRoomOptionalTimer => 'Optional timer for the session';

  @override
  String get voiceRoomDurationNone => 'None';

  @override
  String get voiceRoomDuration15 => '15 min';

  @override
  String get voiceRoomDuration30 => '30 min';

  @override
  String get voiceRoomDuration45 => '45 min';

  @override
  String get voiceRoomDuration60 => '60 min';

  @override
  String get voiceRoomTypeFreeTalk => 'Free Talk';

  @override
  String get voiceRoomTypePronunciation => 'Pronunciation';

  @override
  String get voiceRoomTypeRolePlay => 'Role Play';

  @override
  String get voiceRoomTypeQnA => 'Q&A';

  @override
  String get voiceRoomTypeListening => 'Listening';

  @override
  String get voiceRoomTypeDebate => 'Debate';

  @override
  String get voiceRoomTemplateFreeTalk => 'Korean Free Talk';

  @override
  String get voiceRoomTemplatePronunciation => 'Pronunciation Practice';

  @override
  String get voiceRoomTemplateDailyKorean => 'Daily Korean';

  @override
  String get voiceRoomTemplateTopikSpeaking => 'TOPIK Speaking';

  @override
  String get voiceRoomCreateTooltip => 'Create voice room';

  @override
  String get voiceRoomSendReaction => 'Send reaction';

  @override
  String get voiceRoomLeaveRoom => 'Leave room';

  @override
  String get voiceRoomUnmuteMic => 'Unmute microphone';

  @override
  String get voiceRoomMuteMic => 'Mute microphone';

  @override
  String get voiceRoomCancelHandRaise => 'Cancel hand raise';

  @override
  String get voiceRoomRaiseHandSemantic => 'Raise hand';

  @override
  String get voiceRoomSendGesture => 'Send gesture';

  @override
  String get voiceRoomLeaveStageAction => 'Leave stage';

  @override
  String get voiceRoomManageStage => 'Manage stage';

  @override
  String get voiceRoomMoreOptions => 'More options';

  @override
  String get voiceRoomMore => 'More';

  @override
  String get voiceRoomStageWithSpeakers => 'Voice room stage with speakers';

  @override
  String voiceRoomStageRequestsPending(int count) {
    return 'Stage requests, $count pending';
  }

  @override
  String voiceRoomSpeakerListenerCount(
      int speakers, int maxSpeakers, int listeners) {
    return '$speakers of $maxSpeakers speakers, $listeners listeners';
  }

  @override
  String get voiceRoomChatInput => 'Chat message input';

  @override
  String get voiceRoomSendMessage => 'Send message';

  @override
  String voiceRoomSendReactionNamed(Object name) {
    return 'Send $name reaction';
  }

  @override
  String get voiceRoomCloseReactionTray => 'Close reaction tray';

  @override
  String voiceRoomPerformGesture(Object name) {
    return 'Perform $name gesture';
  }

  @override
  String get voiceRoomCloseGestureTray => 'Close gesture tray';

  @override
  String get voiceRoomGestureWave => 'Wave';

  @override
  String get voiceRoomGestureBow => 'Bow';

  @override
  String get voiceRoomGestureDance => 'Dance';

  @override
  String get voiceRoomGestureJump => 'Jump';

  @override
  String get voiceRoomGestureClap => 'Clap';

  @override
  String get voiceRoomStageLabel => 'STAGE';

  @override
  String get voiceRoomYouLabel => '(You)';

  @override
  String voiceRoomListenerTapToManage(Object name) {
    return 'Listener $name, tap to manage';
  }

  @override
  String voiceRoomListenerName(Object name) {
    return 'Listener $name';
  }

  @override
  String get voiceRoomMicPermissionDenied =>
      'Microphone access was denied. To use voice features, please enable it in your device settings.';

  @override
  String get voiceRoomMicPermissionTitle => 'Microphone Permission';

  @override
  String get voiceRoomOpenSettings => 'Open Settings';

  @override
  String get voiceRoomMicNeededForStage =>
      'Microphone permission is needed to speak on stage';

  @override
  String get batchimDescriptionText =>
      'Korean final consonants (batchim) are pronounced as 7 sounds.\nMultiple batchim sharing the same pronunciation are called \"representative sounds\".';

  @override
  String get syllableInputLabel => 'Enter syllable';

  @override
  String get syllableInputHint => 'e.g. 한';

  @override
  String totalPracticedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Total: $count characters practiced',
      one: 'Total: $count character practiced',
    );
    return '$_temp0';
  }

  @override
  String get audioLoadError => 'Failed to load audio';

  @override
  String get writingPracticeCompleteMessage => 'Writing practice complete!';

  @override
  String get sevenRepresentativeSounds => '7 Representative Sounds';

  @override
  String get myRoom => 'My Room';

  @override
  String get characterEditor => 'Character Editor';

  @override
  String get roomEditor => 'Room Editor';

  @override
  String get shop => 'Shop';

  @override
  String get character => 'Character';

  @override
  String get room => 'Room';

  @override
  String get hair => 'Hair';

  @override
  String get eyes => 'Eyes';

  @override
  String get brows => 'Brows';

  @override
  String get nose => 'Nose';

  @override
  String get mouth => 'Mouth';

  @override
  String get top => 'Top';

  @override
  String get bottom => 'Bottom';

  @override
  String get hatItem => 'Hat';

  @override
  String get accessory => 'Acc.';

  @override
  String get wallpaper => 'Wallpaper';

  @override
  String get floorItem => 'Floor';

  @override
  String get petItem => 'Pet';

  @override
  String get none => 'None';

  @override
  String get noItemsYet => 'No items yet';

  @override
  String get visitShopToGetItems => 'Visit the shop to get items!';

  @override
  String get alreadyOwned => 'Already owned!';

  @override
  String get buy => 'Buy';

  @override
  String purchasedItem(String name) {
    return 'Purchased $name!';
  }

  @override
  String get notEnoughLemons => 'Not enough lemons!';

  @override
  String get owned => 'Owned';

  @override
  String get free => 'Free';

  @override
  String get comingSoon => 'Coming soon!';

  @override
  String balanceLemons(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Balance: $count lemons',
      one: 'Balance: $count lemon',
    );
    return '$_temp0';
  }

  @override
  String get furnitureItem => 'Furn.';

  @override
  String get hangulWelcome => 'Welcome to Hangul!';

  @override
  String get hangulWelcomeDesc => 'Learn 40 Korean alphabet letters one by one';

  @override
  String get hangulStartLearning => 'Start Learning';

  @override
  String get hangulLearnNext => 'Learn Next';

  @override
  String hangulLearnedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count/40 letters learned!',
      one: '$count/40 letter learned!',
    );
    return '$_temp0';
  }

  @override
  String hangulReviewNeeded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count letters due for review today!',
      one: '$count letter due for review today!',
    );
    return '$_temp0';
  }

  @override
  String get hangulReviewNow => 'Review Now';

  @override
  String get hangulPracticeSuggestion =>
      'Almost there! Strengthen skills with activities';

  @override
  String get hangulStartActivities => 'Start Activities';

  @override
  String get hangulMastered => 'Congratulations! You\'ve mastered Hangul!';

  @override
  String get hangulGoToLevel1 => 'Go to Level 1';

  @override
  String get completedLessonsLabel => 'Completed';

  @override
  String get wordsLearnedLabel => 'Words';

  @override
  String get totalStudyTimeLabel => 'Study Time';

  @override
  String get streakDetails => 'Streak Details';

  @override
  String get consecutiveDays => 'Consecutive Days';

  @override
  String get totalStudyDaysLabel => 'Total Study Days';

  @override
  String get studyRecord => 'Study Record';

  @override
  String get noFriendsPrompt => 'Find friends to study together!';

  @override
  String get moreStats => 'View All';

  @override
  String remainingLessons(int count) {
    return '$count more to reach today\'s goal!';
  }

  @override
  String get streakMotivation0 => 'Start learning today!';

  @override
  String get streakMotivation1 => 'Great start! Keep going!';

  @override
  String get streakMotivation7 => 'Over a week of learning! Amazing!';

  @override
  String get streakMotivation14 => 'Two weeks strong! It\'s becoming a habit!';

  @override
  String get streakMotivation30 => 'Over a month! You\'re a true learner!';

  @override
  String minutesShort(int count) {
    return '${count}m';
  }

  @override
  String hoursShort(int count) {
    return '${count}h';
  }

  @override
  String get speechPractice => 'Pronunciation Practice';

  @override
  String get tapToRecord => 'Tap to record';

  @override
  String get recording => 'Recording...';

  @override
  String get analyzing => 'Analyzing...';

  @override
  String get pronunciationScore => 'Pronunciation Score';

  @override
  String get phonemeBreakdown => 'Phoneme Breakdown';

  @override
  String tryAgainCount(String current, String max) {
    return 'Try again ($current/$max)';
  }

  @override
  String get nextCharacter => 'Next character';

  @override
  String get excellentPronunciation => 'Excellent!';

  @override
  String get goodPronunciation => 'Good job!';

  @override
  String get fairPronunciation => 'Getting better!';

  @override
  String get needsMorePractice => 'Keep practicing!';

  @override
  String get downloadModels => 'Download';

  @override
  String get modelDownloading => 'Downloading model';

  @override
  String get modelReady => 'Ready';

  @override
  String get modelNotReady => 'Not installed';

  @override
  String get modelSize => 'Model size';

  @override
  String get speechModelTitle => 'Speech Recognition AI Model';

  @override
  String get skipSpeechPractice => 'Skip';

  @override
  String get deleteModel => 'Delete model';

  @override
  String get overallScore => 'Overall Score';

  @override
  String get appTagline => 'Fresh like a lemon, solid like your skills!';

  @override
  String get passwordHint => 'At least 8 characters with letters and numbers';

  @override
  String get findAccount => 'Find Account';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get registerTitle => 'Start your fresh Korean journey!';

  @override
  String get registerSubtitle =>
      'It\'s OK to start light! I\'ll guide you along';

  @override
  String get nickname => 'Nickname';

  @override
  String get nicknameHint =>
      'Up to 15 characters: letters, numbers, underscores';

  @override
  String get confirmPasswordHint => 'Enter your password once more';

  @override
  String get accountChoiceTitle =>
      'Welcome! Shall we build\na study routine with Moni?';

  @override
  String get accountChoiceSubtitle =>
      'Start fresh, and I\'ll make sure you learn well!';

  @override
  String get startWithEmail => 'Start with Email';

  @override
  String get deleteMessageTitle => 'Delete message?';

  @override
  String get deleteMessageContent =>
      'This message will be deleted for everyone.';

  @override
  String get messageDeleted => 'Message deleted';

  @override
  String get beFirstToPost => 'Be the first to post!';

  @override
  String get typeTagHint => 'Type a tag...';

  @override
  String get userInfoLoadFailed => 'Failed to load user info';

  @override
  String get loginErrorOccurred => 'An error occurred during login';

  @override
  String get registerErrorOccurred => 'An error occurred during registration';

  @override
  String get logoutErrorOccurred => 'An error occurred during logout';

  @override
  String get hangulStage0Title => 'Stage 0: Understanding Hangul Structure';

  @override
  String get hangulStage1Title => 'Stage 1: Basic Vowels';

  @override
  String get hangulStage2Title => 'Stage 2: Y-Vowels';

  @override
  String get hangulStage3Title => 'Stage 3: ㅐ/ㅔ Vowels';

  @override
  String get hangulStage4Title => 'Stage 4: Basic Consonants 1';

  @override
  String get hangulStage5Title => 'Stage 5: Basic Consonants 2';

  @override
  String get hangulStage6Title => 'Stage 6: Syllable Combination Training';

  @override
  String get hangulStage7Title => 'Stage 7: Tense/Aspirated Consonants';

  @override
  String get hangulStage8Title => 'Stage 8: Final Consonants (Batchim) 1';

  @override
  String get hangulStage9Title => 'Stage 9: Extended Batchim';

  @override
  String get hangulStage10Title => 'Stage 10: Double Batchim';

  @override
  String get hangulStage11Title => 'Stage 11: Extended Word Reading';

  @override
  String get sortAlphabetical => 'Alphabetical';

  @override
  String get sortByLevel => 'By Level';

  @override
  String get sortBySimilarity => 'By Similarity';

  @override
  String get searchWordsKoreanMeaning => 'Search words (Korean/meaning)';

  @override
  String get groupedView => 'Grouped';

  @override
  String get matrixView => 'Consonant×Vowel';

  @override
  String get reviewLessons => 'Review Lessons';

  @override
  String get stageDetailComingSoon => 'Details coming soon.';

  @override
  String get bossQuizComingSoon => 'Boss Quiz coming soon.';

  @override
  String get exitLessonDialogTitle => 'Exit Lesson';

  @override
  String get exitLessonDialogContent =>
      'Do you want to exit the lesson?\nYour progress up to this step will be saved.';

  @override
  String get continueButton => 'Continue';

  @override
  String get exitLessonButton => 'Exit';

  @override
  String get noQuestions => 'No questions available';

  @override
  String get noCharactersDefined => 'No characters defined';

  @override
  String get recordingStartFailed => 'Failed to start recording';

  @override
  String get consonant => 'Consonant';

  @override
  String get vowel => 'Vowel';

  @override
  String get validationEmailRequired => 'Please enter your email';

  @override
  String get validationEmailTooLong => 'Email address is too long';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address';

  @override
  String get validationPasswordRequired => 'Please enter your password';

  @override
  String validationPasswordMinLength(int minLength) {
    return 'Password must be at least $minLength characters';
  }

  @override
  String get validationPasswordNeedLetter => 'Password must contain letters';

  @override
  String get validationPasswordNeedNumber => 'Password must contain numbers';

  @override
  String get validationPasswordNeedSpecial =>
      'Password must contain special characters';

  @override
  String get validationPasswordTooLong => 'Password is too long';

  @override
  String get validationConfirmPasswordRequired =>
      'Please confirm your password';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationUsernameRequired => 'Please enter a username';

  @override
  String validationUsernameTooShort(int minLength) {
    return 'Username must be at least $minLength characters';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return 'Username cannot exceed $maxLength characters';
  }

  @override
  String get validationUsernameInvalidChars =>
      'Username can only contain letters, numbers, and underscores';

  @override
  String validationFieldRequired(String fieldName) {
    return 'Please enter $fieldName';
  }

  @override
  String validationFieldMinLength(String fieldName, int minLength) {
    return '$fieldName must be at least $minLength characters';
  }

  @override
  String validationFieldMaxLength(String fieldName, int maxLength) {
    return '$fieldName cannot exceed $maxLength characters';
  }

  @override
  String validationFieldNumeric(String fieldName) {
    return '$fieldName must be a number';
  }

  @override
  String get errorNetworkConnection =>
      'Network connection failed. Please check your network settings';

  @override
  String get errorServer => 'Server error. Please try again later';

  @override
  String get errorAuthFailed => 'Authentication failed. Please log in again';

  @override
  String get errorUnknown => 'Unknown error. Please try again later';

  @override
  String get errorTimeout => 'Connection timed out. Please check your network';

  @override
  String get errorRequestCancelled => 'Request was cancelled';

  @override
  String get errorForbidden => 'Access denied';

  @override
  String get errorNotFound => 'The requested resource was not found';

  @override
  String get errorRequestParam => 'Request parameter error';

  @override
  String get errorParseData => 'Data parsing error';

  @override
  String get errorParseFormat => 'Data format error';

  @override
  String get errorRateLimited => 'Too many requests. Please try again later';

  @override
  String get successLogin => 'Login successful';

  @override
  String get successRegister => 'Registration successful';

  @override
  String get successSync => 'Sync successful';

  @override
  String get successDownload => 'Download successful';

  @override
  String get failedToCreateComment => 'Failed to create comment';

  @override
  String get failedToDeleteComment => 'Failed to delete comment';

  @override
  String get failedToSubmitReport => 'Failed to submit report';

  @override
  String get failedToBlockUser => 'Failed to block user';

  @override
  String get failedToUnblockUser => 'Failed to unblock user';

  @override
  String get failedToCreatePost => 'Failed to create post';

  @override
  String get failedToDeletePost => 'Failed to delete post';

  @override
  String noVocabularyForLevel(int level) {
    return 'No vocabulary found for level $level';
  }

  @override
  String get uploadingImage => '[Uploading image...]';

  @override
  String get uploadingVoice => '[Uploading voice...]';

  @override
  String get imagePreview => '[Image]';

  @override
  String get voicePreview => '[Voice]';

  @override
  String get voiceServerConnectFailed =>
      'Could not connect to the voice server. Please check your connection.';

  @override
  String get connectionLostRetry => 'Connection lost. Tap to retry.';

  @override
  String get noInternetConnection =>
      'No internet connection. Please check your network.';

  @override
  String get couldNotLoadRooms => 'Could not load rooms. Please try again.';

  @override
  String get couldNotCreateRoom =>
      'Could not create the room. Please try again.';

  @override
  String get couldNotJoinRoom =>
      'Could not join the room. Please check your connection.';

  @override
  String get roomClosedByHost => 'Room was closed by the host.';

  @override
  String get removedFromRoomByHost =>
      'You were removed from the room by the host.';

  @override
  String get connectionTimedOut => 'Connection timed out. Please try again.';

  @override
  String get missingLiveKitCredentials =>
      'Missing voice connection credentials.';

  @override
  String get microphoneEnableFailed =>
      'Microphone could not be enabled. Check your permissions and try unmuting.';

  @override
  String get voiceRoomNewMessages => 'New messages';

  @override
  String get voiceRoomChatRateLimited =>
      'You are sending messages too fast. Please wait a moment.';

  @override
  String get voiceRoomMessageSendFailed =>
      'Failed to send message. Please try again.';

  @override
  String get voiceRoomChatError => 'Chat error occurred.';

  @override
  String retryAttempt(int current, int max) {
    return 'Retry ($current/$max)';
  }

  @override
  String get nextButton => 'Next';

  @override
  String get completeButton => 'Complete';

  @override
  String get startButton => 'Start';

  @override
  String get doneButton => 'Done';

  @override
  String get goBackButton => 'Go back';

  @override
  String get tapToListen => 'Tap to listen';

  @override
  String get listenAllSoundsFirst => 'Listen to all sounds first';

  @override
  String get nextCharButton => 'Next character';

  @override
  String get listenAndChooseCorrect =>
      'Listen and choose the correct character';

  @override
  String get lessonCompletedMsg => 'You completed the lesson!';

  @override
  String stageMasterLabel(int stage) {
    return 'Stage $stage Master';
  }

  @override
  String get hangulS0L0Title => 'How was Hangul born?';

  @override
  String get hangulS0L0Subtitle => 'A brief look at how Hangul was created';

  @override
  String get hangulS0L0Step0Title => 'Long ago, writing was very difficult';

  @override
  String get hangulS0L0Step0Desc =>
      'In the past, writing relied on Chinese characters (Hanja),\nmaking it difficult for most people to read and write.';

  @override
  String get hangulS0L0Step0Highlights => 'Hanja,Difficulty,Reading,Writing';

  @override
  String get hangulS0L0Step1Title => 'King Sejong created a new writing system';

  @override
  String get hangulS0L0Step1Desc =>
      'To help common people learn easily,\nKing Sejong personally created Hunminjeongeum.\n(Created in 1443, proclaimed in 1446)';

  @override
  String get hangulS0L0Step1Highlights =>
      'King Sejong,Hunminjeongeum,1443,1446';

  @override
  String get hangulS0L0Step2Title => 'And that became today\'s Hangul';

  @override
  String get hangulS0L0Step2Desc =>
      'Hangul is a writing system designed to easily represent sounds.\nIn the next lesson, we\'ll learn about consonant and vowel structure.';

  @override
  String get hangulS0L0Step2Highlights => 'Sound,Easy writing,Hangul';

  @override
  String get hangulS0L0SummaryTitle => 'Introduction complete!';

  @override
  String get hangulS0L0SummaryMsg =>
      'Great!\nNow you know why Hangul was created.\nLet\'s learn about consonant/vowel structure next.';

  @override
  String get hangulS0L1Title => 'Assembling the 가 block';

  @override
  String get hangulS0L1Subtitle => 'See how Hangul characters are built';

  @override
  String get hangulS0L1IntroTitle => 'Hangul works like blocks!';

  @override
  String get hangulS0L1IntroDesc =>
      'Hangul combines consonants and vowels to form characters.\nConsonant (ㄱ) + Vowel (ㅏ) = 가\n\nSome characters also have an extra consonant at the bottom, called batchim.\n(We\'ll learn that later!)';

  @override
  String get hangulS0L1IntroHighlights => 'Consonant,Vowel,Character';

  @override
  String get hangulS0L1DragGaTitle => 'Assemble 가';

  @override
  String get hangulS0L1DragGaDesc => 'Drag ㄱ and ㅏ into the empty slots';

  @override
  String get hangulS0L1DragNaTitle => 'Assemble 나';

  @override
  String get hangulS0L1DragNaDesc => 'Try using the new consonant ㄴ';

  @override
  String get hangulS0L1DragDaTitle => 'Assemble 다';

  @override
  String get hangulS0L1DragDaDesc => 'Try using the new consonant ㄷ';

  @override
  String get hangulS0L1SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS0L1SummaryMsg =>
      'Consonant + Vowel = Syllable block!\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다';

  @override
  String get hangulS0L2Title => 'Sound Exploration';

  @override
  String get hangulS0L2Subtitle => 'Explore consonant and vowel sounds';

  @override
  String get hangulS0L2IntroTitle => 'Listen to the sounds';

  @override
  String get hangulS0L2IntroDesc =>
      'Each Hangul consonant and vowel has its own unique sound.\nListen carefully to each one.';

  @override
  String get hangulS0L2Sound1Title => 'Consonant sounds: ㄱ, ㄴ, ㄷ';

  @override
  String get hangulS0L2Sound1Desc =>
      'Each consonant is paired with vowel ㅏ to make a syllable: 가, 나, 다';

  @override
  String get hangulS0L2Sound2Title => 'ㅏ, ㅗ vowel sounds';

  @override
  String get hangulS0L2Sound2Desc => 'Listen to the sounds of these two vowels';

  @override
  String get hangulS0L2Sound3Title => 'Listening to 가, 나, 다';

  @override
  String get hangulS0L2Sound3Desc =>
      'Listen to the sounds of characters formed by combining consonants and vowels';

  @override
  String get hangulS0L2SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS0L2SummaryMsg =>
      'Consonants are pronounced with ㅏ as syllables (가, 나, 다),\nand now you\'ve heard how vowels sound on their own too!';

  @override
  String get hangulS0L3Title => 'Listen and Choose';

  @override
  String get hangulS0L3Subtitle => 'Distinguish characters by their sounds';

  @override
  String get hangulS0L3IntroTitle => 'This time, use your ears';

  @override
  String get hangulS0L3IntroDesc =>
      'Focus on what you hear rather than what you see.\nYou\'ll match sounds to their Hangul characters.';

  @override
  String get hangulS0L3Sound1Title => 'Review 가/나/다/고/노 sounds';

  @override
  String get hangulS0L3Sound1Desc => 'Listen to all 5 sounds before continuing';

  @override
  String get hangulS0L3Match1Title => 'Listen and pick the matching character';

  @override
  String get hangulS0L3Match1Desc =>
      'Choose the character that matches the sound played';

  @override
  String get hangulS0L3Match2Title => 'Distinguish ㅏ / ㅗ sounds';

  @override
  String get hangulS0L3Match2Desc =>
      'The consonant is the same — focus on the vowel to tell them apart';

  @override
  String get hangulS0L3SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS0L3SummaryMsg =>
      'Great!\nNow you can recognize Hangul by sight and by sound.\nYou\'re ready to learn the letters!';

  @override
  String get hangulS0CompleteTitle => 'Stage 0 complete!';

  @override
  String get hangulS0CompleteMsg =>
      'You now understand the structure of Hangul!';

  @override
  String get hangulS1L1Title => 'Shape and Sound of ㅏ';

  @override
  String get hangulS1L1Subtitle =>
      'Short stroke to the right of a vertical line: ㅏ';

  @override
  String get hangulS1L1Step0Title => 'Learn the First Vowel ㅏ';

  @override
  String get hangulS1L1Step0Desc =>
      'ㅏ makes the bright sound \"아\".\nLet\'s learn the shape and sound together.';

  @override
  String get hangulS1L1Step0Highlights => 'ㅏ,아,basic vowel';

  @override
  String get hangulS1L1Step1Title => 'Listen to ㅏ';

  @override
  String get hangulS1L1Step1Desc => 'Listen to sounds containing ㅏ';

  @override
  String get hangulS1L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L1Step2Desc => 'Try speaking the characters out loud';

  @override
  String get hangulS1L1Step3Title => 'Pick the ㅏ Sound';

  @override
  String get hangulS1L1Step3Desc => 'Listen and choose the correct character';

  @override
  String get hangulS1L1Step4Title => 'Shape Quiz';

  @override
  String get hangulS1L1Step4Desc => 'Find ㅏ accurately';

  @override
  String get hangulS1L1Step4Q0 => 'Which one is ㅏ?';

  @override
  String get hangulS1L1Step4Q1 => 'Which contains ㅏ?';

  @override
  String get hangulS1L1Step4Q2 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step5Title => 'Build Characters with ㅏ';

  @override
  String get hangulS1L1Step5Desc =>
      'Combine consonants with ㅏ to complete characters';

  @override
  String get hangulS1L1Step6Title => 'Comprehensive Quiz';

  @override
  String get hangulS1L1Step6Desc => 'Review what you learned this lesson';

  @override
  String get hangulS1L1Step6Q0 => 'What is the vowel in \"아\"?';

  @override
  String get hangulS1L1Step6Q1 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step6Q2 => 'Which character contains ㅏ?';

  @override
  String get hangulS1L1Step6Q3 => 'Which sounds most different from ㅏ?';

  @override
  String get hangulS1L1Step7Title => 'Lesson Complete!';

  @override
  String get hangulS1L1Step7Msg =>
      'Great!\nYou\'ve learned the shape and sound of ㅏ.';

  @override
  String get hangulS1L2Title => 'Shape and Sound of ㅓ';

  @override
  String get hangulS1L2Subtitle =>
      'Short stroke to the left of a vertical line: ㅓ';

  @override
  String get hangulS1L2Step0Title => 'The Second Vowel ㅓ';

  @override
  String get hangulS1L2Step0Desc =>
      'ㅓ makes the sound \"어\".\nNote that the stroke direction is opposite to ㅏ.';

  @override
  String get hangulS1L2Step0Highlights => 'ㅓ,어,opposite direction to ㅏ';

  @override
  String get hangulS1L2Step1Title => 'Listen to ㅓ';

  @override
  String get hangulS1L2Step1Desc => 'Listen to sounds containing ㅓ';

  @override
  String get hangulS1L2Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L2Step2Desc => 'Try speaking the characters out loud';

  @override
  String get hangulS1L2Step3Title => 'Pick the ㅓ Sound';

  @override
  String get hangulS1L2Step3Desc => 'Distinguish ㅏ/ㅓ by ear';

  @override
  String get hangulS1L2Step4Title => 'Shape Quiz';

  @override
  String get hangulS1L2Step4Desc => 'Find ㅓ';

  @override
  String get hangulS1L2Step4Q0 => 'Which one is ㅓ?';

  @override
  String get hangulS1L2Step4Q1 => 'ㅇ + ㅓ = ?';

  @override
  String get hangulS1L2Step4Q2 => 'Which character contains ㅓ?';

  @override
  String get hangulS1L2Step5Title => 'Build Characters with ㅓ';

  @override
  String get hangulS1L2Step5Desc => 'Combine consonants with ㅓ';

  @override
  String get hangulS1L2Step6Title => 'Lesson Complete!';

  @override
  String get hangulS1L2Step6Msg =>
      'Excellent!\nYou\'ve learned the sound of ㅓ(어).';

  @override
  String get hangulS1L3Title => 'Shape and Sound of ㅗ';

  @override
  String get hangulS1L3Subtitle =>
      'Vertical stroke above the horizontal line: ㅗ';

  @override
  String get hangulS1L3Step0Title => 'The Third Vowel ㅗ';

  @override
  String get hangulS1L3Step0Desc =>
      'ㅗ makes the sound \"오\".\nA vertical stroke rises above the horizontal line.';

  @override
  String get hangulS1L3Step0Highlights => 'ㅗ,오,horizontal vowel';

  @override
  String get hangulS1L3Step1Title => 'Listen to ㅗ';

  @override
  String get hangulS1L3Step1Desc => 'Listen to sounds with ㅗ (오/고/노)';

  @override
  String get hangulS1L3Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L3Step2Desc => 'Try speaking the characters out loud';

  @override
  String get hangulS1L3Step3Title => 'Pick the ㅗ Sound';

  @override
  String get hangulS1L3Step3Desc => 'Distinguish 오/우 sounds';

  @override
  String get hangulS1L3Step4Title => 'Build Characters with ㅗ';

  @override
  String get hangulS1L3Step4Desc => 'Combine consonants with ㅗ';

  @override
  String get hangulS1L3Step5Title => 'Shape & Sound Quiz';

  @override
  String get hangulS1L3Step5Desc => 'Select ㅗ accurately';

  @override
  String get hangulS1L3Step5Q0 => 'Which one is ㅗ?';

  @override
  String get hangulS1L3Step5Q1 => 'ㅇ + ㅗ = ?';

  @override
  String get hangulS1L3Step5Q2 => 'Which contains ㅗ?';

  @override
  String get hangulS1L3Step6Title => 'Lesson Complete!';

  @override
  String get hangulS1L3Step6Msg => 'Great!\nYou\'ve learned the sound of ㅗ(오).';

  @override
  String get hangulS1L4Title => 'Shape and Sound of ㅜ';

  @override
  String get hangulS1L4Subtitle =>
      'Vertical stroke below the horizontal line: ㅜ';

  @override
  String get hangulS1L4Step0Title => 'The Fourth Vowel ㅜ';

  @override
  String get hangulS1L4Step0Desc =>
      'ㅜ makes the sound \"우\".\nThe vertical stroke position is opposite to ㅗ.';

  @override
  String get hangulS1L4Step0Highlights => 'ㅜ,우,compare position with ㅗ';

  @override
  String get hangulS1L4Step1Title => 'Listen to ㅜ';

  @override
  String get hangulS1L4Step1Desc => 'Listen to 우/구/누';

  @override
  String get hangulS1L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L4Step2Desc => 'Try speaking the characters out loud';

  @override
  String get hangulS1L4Step3Title => 'Pick the ㅜ Sound';

  @override
  String get hangulS1L4Step3Desc => 'Distinguish ㅗ/ㅜ';

  @override
  String get hangulS1L4Step4Title => 'Build Characters with ㅜ';

  @override
  String get hangulS1L4Step4Desc => 'Combine consonants with ㅜ';

  @override
  String get hangulS1L4Step5Title => 'Shape & Sound Quiz';

  @override
  String get hangulS1L4Step5Desc => 'Select ㅜ accurately';

  @override
  String get hangulS1L4Step5Q0 => 'Which one is ㅜ?';

  @override
  String get hangulS1L4Step5Q1 => 'ㅇ + ㅜ = ?';

  @override
  String get hangulS1L4Step5Q2 => 'Which contains ㅜ?';

  @override
  String get hangulS1L4Step6Title => 'Lesson Complete!';

  @override
  String get hangulS1L4Step6Msg => 'Great!\nYou\'ve learned the sound of ㅜ(우).';

  @override
  String get hangulS1L5Title => 'Shape and Sound of ㅡ';

  @override
  String get hangulS1L5Subtitle => 'Single horizontal line vowel: ㅡ';

  @override
  String get hangulS1L5Step0Title => 'The Fifth Vowel ㅡ';

  @override
  String get hangulS1L5Step0Desc =>
      'ㅡ is pronounced by spreading your lips sideways.\nThe shape is a single horizontal line.';

  @override
  String get hangulS1L5Step0Highlights => 'ㅡ,으,single horizontal line';

  @override
  String get hangulS1L5Step1Title => 'Listen to ㅡ';

  @override
  String get hangulS1L5Step1Desc => 'Listen to 으/그/느 sounds';

  @override
  String get hangulS1L5Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L5Step2Desc => 'Try speaking the characters out loud';

  @override
  String get hangulS1L5Step3Title => 'Pick the ㅡ Sound';

  @override
  String get hangulS1L5Step3Desc => 'Distinguish ㅡ and ㅜ sounds';

  @override
  String get hangulS1L5Step4Title => 'Build Characters with ㅡ';

  @override
  String get hangulS1L5Step4Desc => 'Combine consonants with ㅡ';

  @override
  String get hangulS1L5Step5Title => 'Shape & Sound Quiz';

  @override
  String get hangulS1L5Step5Desc => 'Select ㅡ accurately';

  @override
  String get hangulS1L5Step5Q0 => 'Which one is ㅡ?';

  @override
  String get hangulS1L5Step5Q1 => 'ㅇ + ㅡ = ?';

  @override
  String get hangulS1L5Step5Q2 => 'Which contains ㅡ?';

  @override
  String get hangulS1L5Step6Title => 'Lesson Complete!';

  @override
  String get hangulS1L5Step6Msg => 'Great!\nYou\'ve learned the sound of ㅡ(으).';

  @override
  String get hangulS1L6Title => 'Shape and Sound of ㅣ';

  @override
  String get hangulS1L6Subtitle => 'Single vertical line vowel: ㅣ';

  @override
  String get hangulS1L6Step0Title => 'The Sixth Vowel ㅣ';

  @override
  String get hangulS1L6Step0Desc =>
      'ㅣ makes the sound \"이\".\nThe shape is a single vertical line.';

  @override
  String get hangulS1L6Step0Highlights => 'ㅣ,이,single vertical line';

  @override
  String get hangulS1L6Step1Title => 'Listen to ㅣ';

  @override
  String get hangulS1L6Step1Desc => 'Listen to 이/기/니 sounds';

  @override
  String get hangulS1L6Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L6Step2Desc => 'Try speaking the characters out loud';

  @override
  String get hangulS1L6Step3Title => 'Pick the ㅣ Sound';

  @override
  String get hangulS1L6Step3Desc => 'Distinguish ㅣ and ㅡ sounds';

  @override
  String get hangulS1L6Step4Title => 'Build Characters with ㅣ';

  @override
  String get hangulS1L6Step4Desc => 'Combine consonants with ㅣ';

  @override
  String get hangulS1L6Step5Title => 'Shape & Sound Quiz';

  @override
  String get hangulS1L6Step5Desc => 'Select ㅣ accurately';

  @override
  String get hangulS1L6Step5Q0 => 'Which one is ㅣ?';

  @override
  String get hangulS1L6Step5Q1 => 'ㅇ + ㅣ = ?';

  @override
  String get hangulS1L6Step5Q2 => 'Which contains ㅣ?';

  @override
  String get hangulS1L6Step6Title => 'Lesson Complete!';

  @override
  String get hangulS1L6Step6Msg => 'Great!\nYou\'ve learned the sound of ㅣ(이).';

  @override
  String get hangulS1L7Title => 'Vertical Vowel Review';

  @override
  String get hangulS1L7Subtitle => 'Distinguish ㅏ · ㅓ · ㅣ quickly';

  @override
  String get hangulS1L7Step0Title => 'Vertical Vowel Group Review';

  @override
  String get hangulS1L7Step0Desc =>
      'ㅏ, ㅓ, and ㅣ are vertical vowels.\nDistinguish them by stroke position and sound.';

  @override
  String get hangulS1L7Step0Highlights => 'ㅏ,ㅓ,ㅣ,vertical vowels';

  @override
  String get hangulS1L7Step1Title => 'Listen Again';

  @override
  String get hangulS1L7Step1Desc => 'Check the sounds 아/어/이';

  @override
  String get hangulS1L7Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L7Step2Desc => 'Say each character out loud';

  @override
  String get hangulS1L7Step3Title => 'Vertical Vowel Listening Quiz';

  @override
  String get hangulS1L7Step3Desc => 'Match the sound to the correct character';

  @override
  String get hangulS1L7Step4Title => 'Vertical Vowel Shape Quiz';

  @override
  String get hangulS1L7Step4Desc => 'Distinguish shapes precisely';

  @override
  String get hangulS1L7Step4Q0 => 'Short stroke on the right?';

  @override
  String get hangulS1L7Step4Q1 => 'Short stroke on the left?';

  @override
  String get hangulS1L7Step4Q2 => 'Single vertical line?';

  @override
  String get hangulS1L7Step4Q3 => 'ㄴ + ㅓ = ?';

  @override
  String get hangulS1L7Step4Q4 => 'ㄱ + ㅣ = ?';

  @override
  String get hangulS1L7Step5Title => 'Lesson Complete!';

  @override
  String get hangulS1L7Step5Msg =>
      'Great!\nYou can now distinguish the vertical vowels (ㅏ/ㅓ/ㅣ).';

  @override
  String get hangulS1L8Title => 'Horizontal Vowel Review';

  @override
  String get hangulS1L8Subtitle => 'Distinguish ㅗ · ㅜ · ㅡ quickly';

  @override
  String get hangulS1L8Step0Title => 'Horizontal Vowel Group Review';

  @override
  String get hangulS1L8Step0Desc =>
      'ㅗ, ㅜ, and ㅡ are horizontal vowels.\nRemember the vertical stroke position and mouth shape.';

  @override
  String get hangulS1L8Step0Highlights => 'ㅗ,ㅜ,ㅡ,horizontal vowels';

  @override
  String get hangulS1L8Step1Title => 'Listen Again';

  @override
  String get hangulS1L8Step1Desc => 'Check the sounds 오/우/으';

  @override
  String get hangulS1L8Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L8Step2Desc => 'Say each character out loud';

  @override
  String get hangulS1L8Step3Title => 'Horizontal Vowel Listening Quiz';

  @override
  String get hangulS1L8Step3Desc => 'Match the sound to the correct character';

  @override
  String get hangulS1L8Step4Title => 'Horizontal Vowel Shape Quiz';

  @override
  String get hangulS1L8Step4Desc => 'Check shape and sound together';

  @override
  String get hangulS1L8Step4Q0 => 'Vertical stroke above the horizontal line?';

  @override
  String get hangulS1L8Step4Q1 => 'Vertical stroke below the horizontal line?';

  @override
  String get hangulS1L8Step4Q2 => 'Single horizontal line?';

  @override
  String get hangulS1L8Step4Q3 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS1L8Step4Q4 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS1L8Step5Title => 'Lesson Complete!';

  @override
  String get hangulS1L8Step5Msg =>
      'Great!\nYou can now distinguish the horizontal vowels (ㅗ/ㅜ/ㅡ).';

  @override
  String get hangulS1L9Title => 'Basic Vowels Mission';

  @override
  String get hangulS1L9Subtitle =>
      'Complete vowel combinations within the time limit';

  @override
  String get hangulS1L9Step0Title => 'Stage 1 Final Mission';

  @override
  String get hangulS1L9Step0Desc =>
      'Complete syllable combinations within the time limit.\nEarn lemon rewards for accuracy and speed!';

  @override
  String get hangulS1L9Step1Title => 'Timed Mission';

  @override
  String get hangulS1L9Step2Title => 'Mission Results';

  @override
  String get hangulS1L9Step3Title => 'Stage 1 Complete!';

  @override
  String get hangulS1L9Step3Msg =>
      'Congratulations!\nYou have finished all Stage 1 basic vowels.';

  @override
  String get hangulS1L10Title => 'First Korean Words!';

  @override
  String get hangulS1L10Subtitle =>
      'Read real words with the characters you learned';

  @override
  String get hangulS1L10Step0Title => 'Now You Can Read Words!';

  @override
  String get hangulS1L10Step0Desc =>
      'You have learned the basic vowels.\nShall we try reading some real Korean words?';

  @override
  String get hangulS1L10Step0Highlights => 'real words,reading challenge';

  @override
  String get hangulS1L10Step1Title => 'Read the First Words';

  @override
  String get hangulS1L10Step1Descs =>
      'child,milk,cucumber,this/tooth,younger brother';

  @override
  String get hangulS1L10Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS1L10Step2Desc => 'Say each character out loud';

  @override
  String get hangulS1L10Step3Title => 'Listen and Choose';

  @override
  String get hangulS1L10Step4Title => 'Amazing!';

  @override
  String get hangulS1L10Step4Msg =>
      'You read Korean words!\nLearn more consonants and\nyou can read even more words.';

  @override
  String get hangulS1CompleteTitle => 'Stage 1 Complete!';

  @override
  String get hangulS1CompleteMsg => 'You have mastered all 6 basic vowels!';

  @override
  String get hangulS2L1Title => 'ㅑ Shape & Sound';

  @override
  String get hangulS2L1Subtitle => 'ㅏ with one extra stroke: ㅑ';

  @override
  String get hangulS2L1Step0Title => 'ㅏ becomes ㅑ';

  @override
  String get hangulS2L1Step0Desc =>
      'Add one stroke to ㅏ and you get ㅑ.\nThe sound changes from \"a\" to the bouncier \"ya\".';

  @override
  String get hangulS2L1Step0Highlights => 'ㅏ → ㅑ,야,Y-vowel';

  @override
  String get hangulS2L1Step1Title => 'Listen to ㅑ';

  @override
  String get hangulS2L1Step1Desc => 'Listen to the sounds 야/갸/냐';

  @override
  String get hangulS2L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS2L1Step2Desc => 'Say each character out loud';

  @override
  String get hangulS2L1Step3Title => 'ㅏ vs ㅑ Listening';

  @override
  String get hangulS2L1Step3Desc => 'Tell apart similar sounds';

  @override
  String get hangulS2L1Step4Title => 'Build syllables with ㅑ';

  @override
  String get hangulS2L1Step4Desc => 'Complete consonant + ㅑ combinations';

  @override
  String get hangulS2L1Step5Title => 'Shape & Sound Quiz';

  @override
  String get hangulS2L1Step5Desc => 'Pick ㅑ correctly';

  @override
  String get hangulS2L1Step5Q0 => 'Which one is ㅑ?';

  @override
  String get hangulS2L1Step5Q1 => 'ㅇ + ㅑ = ?';

  @override
  String get hangulS2L1Step5Q2 => 'Which contains ㅑ?';

  @override
  String get hangulS2L1Step6Title => 'Lesson Complete!';

  @override
  String get hangulS2L1Step6Msg => 'Great!\nYou\'ve learned the ㅑ (야) sound.';

  @override
  String get hangulS2L2Title => 'ㅕ Shape & Sound';

  @override
  String get hangulS2L2Subtitle => 'ㅓ with one extra stroke: ㅕ';

  @override
  String get hangulS2L2Step0Title => 'ㅓ becomes ㅕ';

  @override
  String get hangulS2L2Step0Desc =>
      'Add one stroke to ㅓ and you get ㅕ.\nThe sound changes from \"eo\" to \"yeo\".';

  @override
  String get hangulS2L2Step0Highlights => 'ㅓ → ㅕ,여,Y-vowel';

  @override
  String get hangulS2L2Step1Title => 'Listen to ㅕ';

  @override
  String get hangulS2L2Step1Desc => 'Listen to the sounds 여/겨/녀';

  @override
  String get hangulS2L2Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS2L2Step2Desc => 'Say each character out loud';

  @override
  String get hangulS2L2Step3Title => 'ㅓ vs ㅕ Listening';

  @override
  String get hangulS2L2Step3Desc => 'Tell apart 어 and 여';

  @override
  String get hangulS2L2Step4Title => 'Build syllables with ㅕ';

  @override
  String get hangulS2L2Step4Desc => 'Complete consonant + ㅕ combinations';

  @override
  String get hangulS2L2Step5Title => 'Lesson Complete!';

  @override
  String get hangulS2L2Step5Msg => 'Great!\nYou\'ve learned the ㅕ (여) sound.';

  @override
  String get hangulS2L3Title => 'ㅛ Shape & Sound';

  @override
  String get hangulS2L3Subtitle => 'ㅗ with one extra stroke: ㅛ';

  @override
  String get hangulS2L3Step0Title => 'ㅗ becomes ㅛ';

  @override
  String get hangulS2L3Step0Desc =>
      'Add one stroke to ㅗ and you get ㅛ.\nThe sound changes from \"o\" to \"yo\".';

  @override
  String get hangulS2L3Step0Highlights => 'ㅗ → ㅛ,요,Y-vowel';

  @override
  String get hangulS2L3Step1Title => 'Listen to ㅛ';

  @override
  String get hangulS2L3Step1Desc => 'Listen to the sounds 요/교/뇨';

  @override
  String get hangulS2L3Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS2L3Step2Desc => 'Say each character out loud';

  @override
  String get hangulS2L3Step3Title => 'ㅗ vs ㅛ Listening';

  @override
  String get hangulS2L3Step3Desc => 'Tell apart 오 and 요';

  @override
  String get hangulS2L3Step4Title => 'Build syllables with ㅛ';

  @override
  String get hangulS2L3Step4Desc => 'Complete consonant + ㅛ combinations';

  @override
  String get hangulS2L3Step5Title => 'Lesson Complete!';

  @override
  String get hangulS2L3Step5Msg => 'Great!\nYou\'ve learned the ㅛ (요) sound.';

  @override
  String get hangulS2L4Title => 'ㅠ Shape & Sound';

  @override
  String get hangulS2L4Subtitle => 'ㅜ with one extra stroke: ㅠ';

  @override
  String get hangulS2L4Step0Title => 'ㅜ becomes ㅠ';

  @override
  String get hangulS2L4Step0Desc =>
      'Add one stroke to ㅜ and you get ㅠ.\nThe sound changes from \"u\" to \"yu\".';

  @override
  String get hangulS2L4Step0Highlights => 'ㅜ → ㅠ,유,Y-vowel';

  @override
  String get hangulS2L4Step1Title => 'Listen to ㅠ';

  @override
  String get hangulS2L4Step1Desc => 'Listen to the sounds 유/규/뉴';

  @override
  String get hangulS2L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS2L4Step2Desc => 'Say each character out loud';

  @override
  String get hangulS2L4Step3Title => 'ㅜ vs ㅠ Listening';

  @override
  String get hangulS2L4Step3Desc => 'Tell apart 우 and 유';

  @override
  String get hangulS2L4Step4Title => 'Build syllables with ㅠ';

  @override
  String get hangulS2L4Step4Desc => 'Complete consonant + ㅠ combinations';

  @override
  String get hangulS2L4Step5Title => 'Lesson Complete!';

  @override
  String get hangulS2L4Step5Msg => 'Great!\nYou\'ve learned the ㅠ (유) sound.';

  @override
  String get hangulS2L5Title => 'Y-Vowel Group Drill';

  @override
  String get hangulS2L5Subtitle => 'Intensive training: ㅑ · ㅕ · ㅛ · ㅠ';

  @override
  String get hangulS2L5Step0Title => 'All Y-Vowels at a Glance';

  @override
  String get hangulS2L5Step0Desc =>
      'ㅑ/ㅕ/ㅛ/ㅠ are base vowels with an extra stroke.\nQuickly distinguish their shapes and sounds.';

  @override
  String get hangulS2L5Step0Highlights => 'ㅑ,ㅕ,ㅛ,ㅠ';

  @override
  String get hangulS2L5Step1Title => 'Listen to All Four';

  @override
  String get hangulS2L5Step1Desc => 'Review the sounds 야/여/요/유';

  @override
  String get hangulS2L5Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS2L5Step2Desc => 'Say each character out loud';

  @override
  String get hangulS2L5Step3Title => 'Sound Distinction Quiz';

  @override
  String get hangulS2L5Step3Desc => 'Tell apart Y-vowel sounds';

  @override
  String get hangulS2L5Step4Title => 'Shape Distinction Quiz';

  @override
  String get hangulS2L5Step4Desc => 'Distinguish the shapes accurately';

  @override
  String get hangulS2L5Step4Q0 => 'Which one is ㅑ?';

  @override
  String get hangulS2L5Step4Q1 => 'Which one is ㅕ?';

  @override
  String get hangulS2L5Step4Q2 => 'Which one is ㅛ?';

  @override
  String get hangulS2L5Step4Q3 => 'Which one is ㅠ?';

  @override
  String get hangulS2L5Step5Title => 'Lesson Complete!';

  @override
  String get hangulS2L5Step5Msg =>
      'Great!\nYou\'re getting better at telling the 4 Y-vowels apart.';

  @override
  String get hangulS2L6Title => 'Basic vs Y-Vowel Contrast';

  @override
  String get hangulS2L6Subtitle => 'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ';

  @override
  String get hangulS2L6Step0Title => 'Sort Out the Confusing Pairs';

  @override
  String get hangulS2L6Step0Desc =>
      'Compare basic vowels and Y-vowels side by side.';

  @override
  String get hangulS2L6Step0Highlights => 'ㅏ/ㅑ,ㅓ/ㅕ,ㅗ/ㅛ,ㅜ/ㅠ';

  @override
  String get hangulS2L6Step1Title => 'Pair Sound Distinction';

  @override
  String get hangulS2L6Step1Desc =>
      'Choose the correct answer from similar sounds';

  @override
  String get hangulS2L6Step2Title => 'Pair Shape Distinction';

  @override
  String get hangulS2L6Step2Desc => 'Check whether the extra stroke is present';

  @override
  String get hangulS2L6Step2Q0 => 'Which vowel has an extra stroke?';

  @override
  String get hangulS2L6Step2Q1 => 'Which vowel has an extra stroke?';

  @override
  String get hangulS2L6Step2Q2 => 'Which vowel has an extra stroke?';

  @override
  String get hangulS2L6Step2Q3 => 'Which vowel has an extra stroke?';

  @override
  String get hangulS2L6Step2Q4 => 'ㅇ + ㅠ = ?';

  @override
  String get hangulS2L6Step3Title => 'Lesson Complete!';

  @override
  String get hangulS2L6Step3Msg =>
      'Great!\nYour basic / Y-vowel contrast is solid.';

  @override
  String get hangulS2L7Title => 'Y-Vowel Mission';

  @override
  String get hangulS2L7Subtitle =>
      'Complete Y-vowel combinations before time runs out';

  @override
  String get hangulS2L7Step0Title => 'Stage 2 Final Mission';

  @override
  String get hangulS2L7Step0Desc =>
      'Match Y-vowel combinations quickly and accurately.\nYour lemon reward depends on accuracy and speed.';

  @override
  String get hangulS2L7Step1Title => 'Timed Mission';

  @override
  String get hangulS2L7Step2Title => 'Mission Results';

  @override
  String get hangulS2L7Step3Title => 'Stage 2 Complete!';

  @override
  String get hangulS2L7Step3Msg =>
      'Congratulations!\nYou\'ve finished all Stage 2 Y-vowels.';

  @override
  String get hangulS2CompleteTitle => 'Stage 2 Complete!';

  @override
  String get hangulS2CompleteMsg => 'You\'ve mastered the Y-vowels!';

  @override
  String get hangulS3L1Title => 'ㅐ Shape and Sound';

  @override
  String get hangulS3L1Subtitle => 'Feel the ㅏ + ㅣ combination';

  @override
  String get hangulS3L1Step0Title => 'This is what ㅐ looks like';

  @override
  String get hangulS3L1Step0Desc =>
      'ㅐ is a vowel derived from the ㅏ family.\nLearn its representative sound as \"애\".';

  @override
  String get hangulS3L1Step0Highlights => 'ㅐ,애,shape recognition';

  @override
  String get hangulS3L1Step1Title => 'Listen to ㅐ Sounds';

  @override
  String get hangulS3L1Step1Desc => 'Listen to the sounds 애/개/내';

  @override
  String get hangulS3L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS3L1Step2Desc => 'Say each character out loud';

  @override
  String get hangulS3L1Step3Title => 'Listen: ㅏ vs ㅐ';

  @override
  String get hangulS3L1Step3Desc => 'Distinguish 아/애';

  @override
  String get hangulS3L1Step4Title => 'Lesson Complete!';

  @override
  String get hangulS3L1Step4Msg =>
      'Great!\nYou\'ve learned the shape and sound of ㅐ(애).';

  @override
  String get hangulS3L2Title => 'ㅔ Shape and Sound';

  @override
  String get hangulS3L2Subtitle => 'Feel the ㅓ + ㅣ combination';

  @override
  String get hangulS3L2Step0Title => 'This is what ㅔ looks like';

  @override
  String get hangulS3L2Step0Desc =>
      'ㅔ is a vowel derived from the ㅓ family.\nLearn its representative sound as \"에\".';

  @override
  String get hangulS3L2Step0Highlights => 'ㅔ,에,shape recognition';

  @override
  String get hangulS3L2Step1Title => 'Listen to ㅔ Sounds';

  @override
  String get hangulS3L2Step1Desc => 'Listen to the sounds 에/게/네';

  @override
  String get hangulS3L2Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS3L2Step2Desc => 'Say each character out loud';

  @override
  String get hangulS3L2Step3Title => 'Listen: ㅓ vs ㅔ';

  @override
  String get hangulS3L2Step3Desc => 'Distinguish 어/에';

  @override
  String get hangulS3L2Step4Title => 'Lesson Complete!';

  @override
  String get hangulS3L2Step4Msg =>
      'Great!\nYou\'ve learned the shape and sound of ㅔ(에).';

  @override
  String get hangulS3L3Title => 'Distinguishing ㅐ vs ㅔ';

  @override
  String get hangulS3L3Subtitle => 'Shape-focused distinction training';

  @override
  String get hangulS3L3Step0Title => 'The Key Is Distinguishing the Shapes';

  @override
  String get hangulS3L3Step0Desc =>
      'At the beginner level, ㅐ/ㅔ can sound very similar.\nSo let\'s first focus on distinguishing the shapes accurately.';

  @override
  String get hangulS3L3Step0Highlights => 'ㅐ,ㅔ,shape distinction';

  @override
  String get hangulS3L3Step1Title => 'Shape Distinction Quiz';

  @override
  String get hangulS3L3Step1Desc => 'Choose ㅐ and ㅔ accurately';

  @override
  String get hangulS3L3Step1Q0 => 'Which one is ㅐ?';

  @override
  String get hangulS3L3Step1Q1 => 'Which one is ㅔ?';

  @override
  String get hangulS3L3Step1Q2 => 'ㅇ + ㅐ = ?';

  @override
  String get hangulS3L3Step1Q3 => 'ㅇ + ㅔ = ?';

  @override
  String get hangulS3L3Step2Title => 'Lesson Complete!';

  @override
  String get hangulS3L3Step2Msg =>
      'Great!\nYou can now distinguish ㅐ/ㅔ more accurately.';

  @override
  String get hangulS3L4Title => 'ㅒ Shape and Sound';

  @override
  String get hangulS3L4Subtitle => 'Y-ㅐ family vowel';

  @override
  String get hangulS3L4Step0Title => 'Let\'s learn ㅒ';

  @override
  String get hangulS3L4Step0Desc =>
      'ㅒ is a Y-vowel in the ㅐ family.\nIts representative sound is \"얘\".';

  @override
  String get hangulS3L4Step0Highlights => 'ㅒ,얘';

  @override
  String get hangulS3L4Step1Title => 'Listen to ㅒ Sounds';

  @override
  String get hangulS3L4Step1Desc => 'Listen to the sounds 얘/걔/냬';

  @override
  String get hangulS3L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS3L4Step2Desc => 'Say each character out loud';

  @override
  String get hangulS3L4Step3Title => 'Lesson Complete!';

  @override
  String get hangulS3L4Step3Msg => 'Great!\nYou\'ve learned the shape of ㅒ(얘).';

  @override
  String get hangulS3L5Title => 'ㅖ Shape and Sound';

  @override
  String get hangulS3L5Subtitle => 'Y-ㅔ family vowel';

  @override
  String get hangulS3L5Step0Title => 'Let\'s learn ㅖ';

  @override
  String get hangulS3L5Step0Desc =>
      'ㅖ is a Y-vowel in the ㅔ family.\nIts representative sound is \"예\".';

  @override
  String get hangulS3L5Step0Highlights => 'ㅖ,예';

  @override
  String get hangulS3L5Step1Title => 'Listen to ㅖ Sounds';

  @override
  String get hangulS3L5Step1Desc => 'Listen to the sounds 예/계/녜';

  @override
  String get hangulS3L5Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS3L5Step2Desc => 'Say each character out loud';

  @override
  String get hangulS3L5Step3Title => 'Lesson Complete!';

  @override
  String get hangulS3L5Step3Msg => 'Great!\nYou\'ve learned the shape of ㅖ(예).';

  @override
  String get hangulS3L6Title => 'ㅐ/ㅔ Family Comprehensive Review';

  @override
  String get hangulS3L6Subtitle => 'Integrated check: ㅐ ㅔ ㅒ ㅖ';

  @override
  String get hangulS3L6Step0Title => 'Distinguish all four at once';

  @override
  String get hangulS3L6Step0Desc => 'Check ㅐ/ㅔ/ㅒ/ㅖ by both shape and sound.';

  @override
  String get hangulS3L6Step0Highlights => 'ㅐ,ㅔ,ㅒ,ㅖ';

  @override
  String get hangulS3L6Step1Title => 'Sound Distinction';

  @override
  String get hangulS3L6Step1Desc =>
      'Choose the correct answer from similar sounds';

  @override
  String get hangulS3L6Step2Title => 'Shape Distinction';

  @override
  String get hangulS3L6Step2Desc => 'Look at the shape and choose quickly';

  @override
  String get hangulS3L6Step2Q0 => 'Which one belongs to the Y-ㅐ family?';

  @override
  String get hangulS3L6Step2Q1 => 'Which one belongs to the Y-ㅔ family?';

  @override
  String get hangulS3L6Step2Q2 => 'ㅇ + ㅖ = ?';

  @override
  String get hangulS3L6Step3Title => 'Lesson Complete!';

  @override
  String get hangulS3L6Step3Msg =>
      'Great!\nYou\'ve mastered distinguishing the Stage 3 key vowels.';

  @override
  String get hangulS3L7Title => 'Stage 3 Mission';

  @override
  String get hangulS3L7Subtitle => 'Fast distinction mission: ㅐ/ㅔ family';

  @override
  String get hangulS3L7Step0Title => 'Stage 3 Final Mission';

  @override
  String get hangulS3L7Step0Desc =>
      'Match ㅐ/ㅔ family combinations quickly and accurately.';

  @override
  String get hangulS3L7Step1Title => 'Timed Mission';

  @override
  String get hangulS3L7Step2Title => 'Mission Results';

  @override
  String get hangulS3L7Step3Title => 'Stage 3 Complete!';

  @override
  String get hangulS3L7Step3Msg =>
      'Congratulations!\nYou\'ve completed all ㅐ/ㅔ family vowels in Stage 3.';

  @override
  String get hangulS3L7Step4Title => 'Stage 3 Complete!';

  @override
  String get hangulS3L7Step4Msg => 'You\'ve learned all the vowels!';

  @override
  String get hangulS3CompleteTitle => 'Stage 3 Complete!';

  @override
  String get hangulS3CompleteMsg => 'You\'ve learned all the vowels!';

  @override
  String get hangulS4L1Title => 'ㄱ Shape and Sound';

  @override
  String get hangulS4L1Subtitle => 'First basic consonant: ㄱ';

  @override
  String get hangulS4L1Step0Title => 'Let\'s learn ㄱ';

  @override
  String get hangulS4L1Step0Desc =>
      'ㄱ is the first basic consonant.\nCombined with ㅏ, it makes the sound \"가\".';

  @override
  String get hangulS4L1Step0Highlights => 'ㄱ,가,basic consonant';

  @override
  String get hangulS4L1Step1Title => 'Listen to ㄱ Sounds';

  @override
  String get hangulS4L1Step1Desc => 'Listen to the sounds 가/고/구';

  @override
  String get hangulS4L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L1Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L1Step3Title => 'Choose the ㄱ Sound';

  @override
  String get hangulS4L1Step3Desc => 'Listen and select the correct character';

  @override
  String get hangulS4L1Step4Title => 'Build Characters with ㄱ';

  @override
  String get hangulS4L1Step4Desc => 'Combine ㄱ with vowels';

  @override
  String get hangulS4L1SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS4L1SummaryMsg =>
      'Great!\nYou\'ve learned the shape and sound of ㄱ.';

  @override
  String get hangulS4L2Title => 'ㄴ Shape and Sound';

  @override
  String get hangulS4L2Subtitle => 'Second basic consonant: ㄴ';

  @override
  String get hangulS4L2Step0Title => 'Let\'s learn ㄴ';

  @override
  String get hangulS4L2Step0Desc => 'ㄴ creates the \"나\" sound family.';

  @override
  String get hangulS4L2Step0Highlights => 'ㄴ,나';

  @override
  String get hangulS4L2Step1Title => 'Listen to ㄴ Sounds';

  @override
  String get hangulS4L2Step1Desc => 'Listen to the sounds 나/노/누';

  @override
  String get hangulS4L2Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L2Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L2Step3Title => 'Choose the ㄴ Sound';

  @override
  String get hangulS4L2Step3Desc => 'Distinguish 나/다';

  @override
  String get hangulS4L2Step4Title => 'Build Characters with ㄴ';

  @override
  String get hangulS4L2Step4Desc => 'Combine ㄴ with vowels';

  @override
  String get hangulS4L2SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS4L2SummaryMsg =>
      'Great!\nYou\'ve learned the shape and sound of ㄴ.';

  @override
  String get hangulS4L3Title => 'ㄷ Shape and Sound';

  @override
  String get hangulS4L3Subtitle => 'Third basic consonant: ㄷ';

  @override
  String get hangulS4L3Step0Title => 'Let\'s learn ㄷ';

  @override
  String get hangulS4L3Step0Desc => 'ㄷ creates the \"다\" sound family.';

  @override
  String get hangulS4L3Step0Highlights => 'ㄷ,다';

  @override
  String get hangulS4L3Step1Title => 'Listen to ㄷ Sounds';

  @override
  String get hangulS4L3Step1Desc => 'Listen to the sounds 다/도/두';

  @override
  String get hangulS4L3Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L3Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L3Step3Title => 'Choose the ㄷ Sound';

  @override
  String get hangulS4L3Step3Desc => 'Distinguish 다/나';

  @override
  String get hangulS4L3Step4Title => 'Build Characters with ㄷ';

  @override
  String get hangulS4L3Step4Desc => 'Combine ㄷ with vowels';

  @override
  String get hangulS4L3SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS4L3SummaryMsg =>
      'Great!\nYou\'ve learned the shape and sound of ㄷ.';

  @override
  String get hangulS4L4Title => 'ㄹ Shape and Sound';

  @override
  String get hangulS4L4Subtitle => 'Fourth basic consonant: ㄹ';

  @override
  String get hangulS4L4Step0Title => 'Let\'s learn ㄹ';

  @override
  String get hangulS4L4Step0Desc => 'ㄹ creates the \"라\" sound family.';

  @override
  String get hangulS4L4Step0Highlights => 'ㄹ,라';

  @override
  String get hangulS4L4Step1Title => 'Listen to ㄹ Sounds';

  @override
  String get hangulS4L4Step1Desc => 'Listen to the sounds 라/로/루';

  @override
  String get hangulS4L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L4Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L4Step3Title => 'Choose the ㄹ Sound';

  @override
  String get hangulS4L4Step3Desc => 'Distinguish 라/나';

  @override
  String get hangulS4L4Step4Title => 'Build Characters with ㄹ';

  @override
  String get hangulS4L4Step4Desc => 'Combine ㄹ with vowels';

  @override
  String get hangulS4L4SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS4L4SummaryMsg =>
      'Great!\nYou\'ve learned the shape and sound of ㄹ.';

  @override
  String get hangulS4L5Title => 'ㅁ Shape and Sound';

  @override
  String get hangulS4L5Subtitle => 'Fifth basic consonant: ㅁ';

  @override
  String get hangulS4L5Step0Title => 'Let\'s learn ㅁ';

  @override
  String get hangulS4L5Step0Desc => 'ㅁ creates the \"마\" sound family.';

  @override
  String get hangulS4L5Step0Highlights => 'ㅁ,마';

  @override
  String get hangulS4L5Step1Title => 'Listen to ㅁ Sounds';

  @override
  String get hangulS4L5Step1Desc => 'Listen to the sounds 마/모/무';

  @override
  String get hangulS4L5Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L5Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L5Step3Title => 'Choose the ㅁ Sound';

  @override
  String get hangulS4L5Step3Desc => 'Distinguish 마/바';

  @override
  String get hangulS4L5Step4Title => 'Build Characters with ㅁ';

  @override
  String get hangulS4L5Step4Desc => 'Combine ㅁ with vowels';

  @override
  String get hangulS4L5SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS4L5SummaryMsg =>
      'Great!\nYou\'ve learned the shape and sound of ㅁ.';

  @override
  String get hangulS4L6Title => 'ㅂ Shape and Sound';

  @override
  String get hangulS4L6Subtitle => 'Sixth basic consonant: ㅂ';

  @override
  String get hangulS4L6Step0Title => 'Let\'s learn ㅂ';

  @override
  String get hangulS4L6Step0Desc => 'ㅂ creates the \"바\" sound family.';

  @override
  String get hangulS4L6Step0Highlights => 'ㅂ,바';

  @override
  String get hangulS4L6Step1Title => 'Listen to ㅂ Sounds';

  @override
  String get hangulS4L6Step1Desc => 'Listen to the sounds 바/보/부';

  @override
  String get hangulS4L6Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L6Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L6Step3Title => 'Choose the ㅂ Sound';

  @override
  String get hangulS4L6Step3Desc => 'Distinguish 바/마';

  @override
  String get hangulS4L6Step4Title => 'Build Characters with ㅂ';

  @override
  String get hangulS4L6Step4Desc => 'Combine ㅂ with vowels';

  @override
  String get hangulS4L6SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS4L6SummaryMsg =>
      'Great!\nYou\'ve learned the shape and sound of ㅂ.';

  @override
  String get hangulS4L7Title => 'ㅅ Shape and Sound';

  @override
  String get hangulS4L7Subtitle => 'Seventh basic consonant: ㅅ';

  @override
  String get hangulS4L7Step0Title => 'Let\'s learn ㅅ';

  @override
  String get hangulS4L7Step0Desc => 'ㅅ creates the \"사\" sound family.';

  @override
  String get hangulS4L7Step0Highlights => 'ㅅ,사';

  @override
  String get hangulS4L7Step1Title => 'Listen to ㅅ Sounds';

  @override
  String get hangulS4L7Step1Desc => 'Listen to the sounds 사/소/수';

  @override
  String get hangulS4L7Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L7Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L7Step3Title => 'Choose the ㅅ Sound';

  @override
  String get hangulS4L7Step3Desc => 'Distinguish 사/자';

  @override
  String get hangulS4L7Step4Title => 'Build Characters with ㅅ';

  @override
  String get hangulS4L7Step4Desc => 'Combine ㅅ with vowels';

  @override
  String get hangulS4L7SummaryTitle => 'Stage 4 complete!';

  @override
  String get hangulS4L7SummaryMsg =>
      'Congratulations!\nYou\'ve completed Stage 4 Basic Consonants 1 (ㄱ~ㅅ).';

  @override
  String get hangulS4L8Title => 'Word Reading Challenge!';

  @override
  String get hangulS4L8Subtitle => 'Read words using consonants and vowels';

  @override
  String get hangulS4L8Step0Title => 'You can now read even more words!';

  @override
  String get hangulS4L8Step0Desc =>
      'You\'ve learned all 7 basic consonants and vowels.\nShall we read some real words made from these characters?';

  @override
  String get hangulS4L8Step0Highlights => '7 consonants,vowels,real words';

  @override
  String get hangulS4L8Step1Title => 'Read the words';

  @override
  String get hangulS4L8Step1Descs => 'tree,sea,butterfly,hat,furniture,tofu';

  @override
  String get hangulS4L8Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS4L8Step2Desc => 'Try saying the characters aloud';

  @override
  String get hangulS4L8Step3Title => 'Listen and Choose';

  @override
  String get hangulS4L8Step4Title => 'What does it mean?';

  @override
  String get hangulS4L8Step4Q0 => 'What is \"나비\" in English?';

  @override
  String get hangulS4L8Step4Q1 => 'What is \"바다\" in English?';

  @override
  String get hangulS4L8SummaryTitle => 'Excellent!';

  @override
  String get hangulS4L8SummaryMsg =>
      'You read 6 Korean words!\nLearn more consonants and you\'ll be able to read even more.';

  @override
  String get hangulS4LMTitle => 'Mission: Basic Consonant Combinations!';

  @override
  String get hangulS4LMSubtitle => 'Build syllables within the time limit';

  @override
  String get hangulS4LMStep0Title => 'Mission start!';

  @override
  String get hangulS4LMStep0Desc =>
      'Combine basic consonants ㄱ~ㅅ with vowels.\nReach your goal within the time limit!';

  @override
  String get hangulS4LMStep1Title => 'Combine the syllables!';

  @override
  String get hangulS4LMStep2Title => 'Mission results';

  @override
  String get hangulS4LMSummaryTitle => 'Mission complete!';

  @override
  String get hangulS4LMSummaryMsg =>
      'You can freely combine all 7 basic consonants!';

  @override
  String get hangulS4CompleteTitle => 'Stage 4 complete!';

  @override
  String get hangulS4CompleteMsg => 'You\'ve mastered all 7 basic consonants!';

  @override
  String get hangulS5L1Title => 'Understanding ㅇ';

  @override
  String get hangulS5L1Subtitle => 'Reading ㅇ in initial position';

  @override
  String get hangulS5L1Step0Title => 'ㅇ is a special consonant';

  @override
  String get hangulS5L1Step0Desc =>
      'ㅇ in the initial position is nearly silent,\nand sounds like 아/오/우 when combined with vowels.';

  @override
  String get hangulS5L1Step0Highlights => 'ㅇ,아,Initial position';

  @override
  String get hangulS5L1Step1Title => 'Listen to ㅇ Combinations';

  @override
  String get hangulS5L1Step1Desc => 'Listen to the sounds 아/오/우';

  @override
  String get hangulS5L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS5L1Step2Desc => 'Say each character out loud';

  @override
  String get hangulS5L1Step3Title => 'Build syllables with ㅇ';

  @override
  String get hangulS5L1Step3Desc => 'Combine ㅇ + vowel';

  @override
  String get hangulS5L1Step4Title => 'Lesson Complete!';

  @override
  String get hangulS5L1Step4Msg => 'Great!\nYou understand how ㅇ works.';

  @override
  String get hangulS5L2Title => 'ㅈ Shape and Sound';

  @override
  String get hangulS5L2Subtitle => 'Basic reading of ㅈ';

  @override
  String get hangulS5L2Step0Title => 'Let\'s learn ㅈ';

  @override
  String get hangulS5L2Step0Desc => 'ㅈ makes the \"자\" sound family.';

  @override
  String get hangulS5L2Step0Highlights => 'ㅈ,자';

  @override
  String get hangulS5L2Step1Title => 'Listen to ㅈ Sounds';

  @override
  String get hangulS5L2Step1Desc => 'Listen to 자/조/주';

  @override
  String get hangulS5L2Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS5L2Step2Desc => 'Say each character out loud';

  @override
  String get hangulS5L2Step3Title => 'Pick the ㅈ Sound';

  @override
  String get hangulS5L2Step3Desc => 'Distinguish 자 from 사';

  @override
  String get hangulS5L2Step4Title => 'Build syllables with ㅈ';

  @override
  String get hangulS5L2Step4Desc => 'Combine ㅈ + vowel';

  @override
  String get hangulS5L2Step5Title => 'Lesson Complete!';

  @override
  String get hangulS5L2Step5Msg =>
      'Great!\nYou\'ve learned ㅈ\'s sound and shape.';

  @override
  String get hangulS5L3Title => 'ㅊ Shape and Sound';

  @override
  String get hangulS5L3Subtitle => 'Basic reading of ㅊ';

  @override
  String get hangulS5L3Step0Title => 'Let\'s learn ㅊ';

  @override
  String get hangulS5L3Step0Desc => 'ㅊ makes the \"차\" sound family.';

  @override
  String get hangulS5L3Step0Highlights => 'ㅊ,차';

  @override
  String get hangulS5L3Step1Title => 'Listen to ㅊ Sounds';

  @override
  String get hangulS5L3Step1Desc => 'Listen to 차/초/추';

  @override
  String get hangulS5L3Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS5L3Step2Desc => 'Say each character out loud';

  @override
  String get hangulS5L3Step3Title => 'Pick the ㅊ Sound';

  @override
  String get hangulS5L3Step3Desc => 'Distinguish 차 from 자';

  @override
  String get hangulS5L3Step4Title => 'Lesson Complete!';

  @override
  String get hangulS5L3Step4Msg =>
      'Great!\nYou\'ve learned ㅊ\'s sound and shape.';

  @override
  String get hangulS5L4Title => 'ㅋ Shape and Sound';

  @override
  String get hangulS5L4Subtitle => 'Basic reading of ㅋ';

  @override
  String get hangulS5L4Step0Title => 'Let\'s learn ㅋ';

  @override
  String get hangulS5L4Step0Desc => 'ㅋ makes the \"카\" sound family.';

  @override
  String get hangulS5L4Step0Highlights => 'ㅋ,카';

  @override
  String get hangulS5L4Step1Title => 'Listen to ㅋ Sounds';

  @override
  String get hangulS5L4Step1Desc => 'Listen to 카/코/쿠';

  @override
  String get hangulS5L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS5L4Step2Desc => 'Say each character out loud';

  @override
  String get hangulS5L4Step3Title => 'Pick the ㅋ Sound';

  @override
  String get hangulS5L4Step3Desc => 'Distinguish 카 from 가';

  @override
  String get hangulS5L4Step4Title => 'Lesson Complete!';

  @override
  String get hangulS5L4Step4Msg =>
      'Great!\nYou\'ve learned ㅋ\'s sound and shape.';

  @override
  String get hangulS5L5Title => 'ㅌ Shape and Sound';

  @override
  String get hangulS5L5Subtitle => 'Basic reading of ㅌ';

  @override
  String get hangulS5L5Step0Title => 'Let\'s learn ㅌ';

  @override
  String get hangulS5L5Step0Desc => 'ㅌ makes the \"타\" sound family.';

  @override
  String get hangulS5L5Step0Highlights => 'ㅌ,타';

  @override
  String get hangulS5L5Step1Title => 'Listen to ㅌ Sounds';

  @override
  String get hangulS5L5Step1Desc => 'Listen to 타/토/투';

  @override
  String get hangulS5L5Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS5L5Step2Desc => 'Say each character out loud';

  @override
  String get hangulS5L5Step3Title => 'Pick the ㅌ Sound';

  @override
  String get hangulS5L5Step3Desc => 'Distinguish 타 from 다';

  @override
  String get hangulS5L5Step4Title => 'Lesson Complete!';

  @override
  String get hangulS5L5Step4Msg =>
      'Great!\nYou\'ve learned ㅌ\'s sound and shape.';

  @override
  String get hangulS5L6Title => 'ㅍ Shape and Sound';

  @override
  String get hangulS5L6Subtitle => 'Basic reading of ㅍ';

  @override
  String get hangulS5L6Step0Title => 'Let\'s learn ㅍ';

  @override
  String get hangulS5L6Step0Desc => 'ㅍ makes the \"파\" sound family.';

  @override
  String get hangulS5L6Step0Highlights => 'ㅍ,파';

  @override
  String get hangulS5L6Step1Title => 'Listen to ㅍ Sounds';

  @override
  String get hangulS5L6Step1Desc => 'Listen to 파/포/푸';

  @override
  String get hangulS5L6Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS5L6Step2Desc => 'Say each character out loud';

  @override
  String get hangulS5L6Step3Title => 'Pick the ㅍ Sound';

  @override
  String get hangulS5L6Step3Desc => 'Distinguish 파 from 바';

  @override
  String get hangulS5L6Step4Title => 'Lesson Complete!';

  @override
  String get hangulS5L6Step4Msg =>
      'Great!\nYou\'ve learned ㅍ\'s sound and shape.';

  @override
  String get hangulS5L7Title => 'ㅎ Shape and Sound';

  @override
  String get hangulS5L7Subtitle => 'Basic reading of ㅎ';

  @override
  String get hangulS5L7Step0Title => 'Let\'s learn ㅎ';

  @override
  String get hangulS5L7Step0Desc => 'ㅎ makes the \"하\" sound family.';

  @override
  String get hangulS5L7Step0Highlights => 'ㅎ,하';

  @override
  String get hangulS5L7Step1Title => 'Listen to ㅎ Sounds';

  @override
  String get hangulS5L7Step1Desc => 'Listen to 하/호/후';

  @override
  String get hangulS5L7Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS5L7Step2Desc => 'Say each character out loud';

  @override
  String get hangulS5L7Step3Title => 'Pick the ㅎ Sound';

  @override
  String get hangulS5L7Step3Desc => 'Distinguish 하 from 아';

  @override
  String get hangulS5L7Step4Title => 'Lesson Complete!';

  @override
  String get hangulS5L7Step4Msg =>
      'Great!\nYou\'ve learned ㅎ\'s sound and shape.';

  @override
  String get hangulS5L8Title => 'Random Reading: Remaining Consonants';

  @override
  String get hangulS5L8Subtitle => 'Mixed review of ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS5L8Step0Title => 'Random Review Time';

  @override
  String get hangulS5L8Step0Desc =>
      'Let\'s read all 7 remaining consonants mixed together.';

  @override
  String get hangulS5L8Step0Highlights => 'ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ';

  @override
  String get hangulS5L8Step1Title => 'Shape/Sound Quiz';

  @override
  String get hangulS5L8Step1Desc => 'Match sounds to characters';

  @override
  String get hangulS5L8Step2Title => 'Lesson Complete!';

  @override
  String get hangulS5L8Step2Msg =>
      'Great!\nYou\'ve reviewed all 7 remaining consonants.';

  @override
  String get hangulS5L9Title => 'Confusion Pairs Preview';

  @override
  String get hangulS5L9Subtitle => 'Practice distinguishing similar pairs';

  @override
  String get hangulS5L9Step0Title => 'Preview the tricky pairs';

  @override
  String get hangulS5L9Step0Desc =>
      'Practice telling apart ㅈ/ㅊ, ㄱ/ㅋ, ㄷ/ㅌ, and ㅂ/ㅍ.';

  @override
  String get hangulS5L9Step0Highlights => 'ㅈ/ㅊ,ㄱ/ㅋ,ㄷ/ㅌ,ㅂ/ㅍ';

  @override
  String get hangulS5L9Step1Title => 'Contrast Listening';

  @override
  String get hangulS5L9Step1Desc => 'Choose the correct sound from two options';

  @override
  String get hangulS5L9Step2Title => 'Lesson Complete!';

  @override
  String get hangulS5L9Step2Msg => 'Great!\nYou\'re ready for the next stage.';

  @override
  String get hangulS5LMTitle => 'Stage 5 Mission';

  @override
  String get hangulS5LMSubtitle => 'Comprehensive Mission: Basic Consonants 2';

  @override
  String get hangulS5LMStep0Title => 'Mission Start!';

  @override
  String get hangulS5LMStep0Desc =>
      'Combine basic consonants 2 (ㅇ~ㅎ) with vowels.\nReach your goal within the time limit!';

  @override
  String get hangulS5LMStep1Title => 'Build Syllables!';

  @override
  String get hangulS5LMStep2Title => 'Mission Results';

  @override
  String get hangulS5LMStep3Title => 'Stage 5 Complete!';

  @override
  String get hangulS5LMStep3Msg =>
      'Congratulations!\nYou\'ve finished Stage 5: basic consonants 2 (ㅇ~ㅎ).';

  @override
  String get hangulS5LMStep4Title => 'Stage 5 Complete!';

  @override
  String get hangulS5LMStep4Msg => 'You\'ve mastered all basic consonants!';

  @override
  String get hangulS5CompleteTitle => 'Stage 5 Complete!';

  @override
  String get hangulS5CompleteMsg => 'You\'ve mastered all basic consonants!';

  @override
  String get hangulS6L1Title => 'Reading 가~기 Patterns';

  @override
  String get hangulS6L1Subtitle => 'ㄱ + Basic Vowel Patterns';

  @override
  String get hangulS6L1Step0Title => 'Start Reading with Patterns';

  @override
  String get hangulS6L1Step0Desc =>
      'Try changing the vowel attached to ㄱ\nand you\'ll find a reading rhythm.';

  @override
  String get hangulS6L1Step0Highlights => '가,거,고,구,그,기';

  @override
  String get hangulS6L1Step1Title => 'Listen to Pattern Sounds';

  @override
  String get hangulS6L1Step1Desc => 'Listen to 가/거/고/구/그/기 in order';

  @override
  String get hangulS6L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS6L1Step2Desc => 'Say each syllable out loud';

  @override
  String get hangulS6L1Step3Title => 'Pattern Quiz';

  @override
  String get hangulS6L1Step3Desc => 'Match the same consonant pattern';

  @override
  String get hangulS6L1Step3Q0 => 'ㄱ + ㅏ = ?';

  @override
  String get hangulS6L1Step3Q1 => 'ㄱ + ㅓ = ?';

  @override
  String get hangulS6L1Step3Q2 => 'ㄱ + ㅡ = ?';

  @override
  String get hangulS6L1Step4Title => 'Lesson Complete!';

  @override
  String get hangulS6L1Step4Msg =>
      'Great!\nYou\'ve started reading 가~기 patterns.';

  @override
  String get hangulS6L2Title => 'Expanding 나~니';

  @override
  String get hangulS6L2Subtitle => 'Reading ㄴ Patterns';

  @override
  String get hangulS6L2Step0Title => 'Expanding ㄴ Patterns';

  @override
  String get hangulS6L2Step0Desc => 'Change the vowel on ㄴ to read 나~니.';

  @override
  String get hangulS6L2Step0Highlights => '나,너,노,누,느,니';

  @override
  String get hangulS6L2Step1Title => 'Listen to 나~니';

  @override
  String get hangulS6L2Step1Desc => 'Listen to the ㄴ pattern sounds';

  @override
  String get hangulS6L2Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS6L2Step2Desc => 'Say each syllable out loud';

  @override
  String get hangulS6L2Step3Title => 'Build ㄴ Combinations';

  @override
  String get hangulS6L2Step3Desc => 'Build syllables with ㄴ + vowel';

  @override
  String get hangulS6L2Step4Title => 'Lesson Complete!';

  @override
  String get hangulS6L2Step4Msg => 'Great!\nYou\'ve mastered the 나~니 patterns.';

  @override
  String get hangulS6L3Title => 'Expanding 다~디 and 라~리';

  @override
  String get hangulS6L3Subtitle => 'Reading ㄷ/ㄹ Patterns';

  @override
  String get hangulS6L3Step0Title => 'Reading by Changing Only the Consonant';

  @override
  String get hangulS6L3Step0Desc =>
      'Switching only the consonant with the same vowel\nbuilds your reading speed.';

  @override
  String get hangulS6L3Step0Highlights => '다/라,도/로,두/루,디/리';

  @override
  String get hangulS6L3Step1Title => 'Listen: Distinguish ㄷ/ㄹ';

  @override
  String get hangulS6L3Step1Desc => 'Listen and choose the correct syllable';

  @override
  String get hangulS6L3Step2Title => 'Reading Quiz';

  @override
  String get hangulS6L3Step2Desc => 'Check the patterns';

  @override
  String get hangulS6L3Step2Q0 => 'ㄷ + ㅣ = ?';

  @override
  String get hangulS6L3Step2Q1 => 'ㄹ + ㅗ = ?';

  @override
  String get hangulS6L3Step3Title => 'Lesson Complete!';

  @override
  String get hangulS6L3Step3Msg => 'Great!\nYou\'ve learned the ㄷ/ㄹ patterns.';

  @override
  String get hangulS6L4Title => 'Random Syllable Reading 1';

  @override
  String get hangulS6L4Subtitle => 'Mixing Basic Patterns';

  @override
  String get hangulS6L4Step0Title => 'Reading Without Order';

  @override
  String get hangulS6L4Step0Desc => 'Now let\'s read like random flashcards.';

  @override
  String get hangulS6L4Step1Title => 'Random Reading';

  @override
  String get hangulS6L4Step1Desc => 'Match the randomly presented syllables';

  @override
  String get hangulS6L4Step1Q0 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS6L4Step1Q1 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS6L4Step1Q2 => 'ㄹ + ㅏ = ?';

  @override
  String get hangulS6L4Step1Q3 => 'ㅁ + ㅣ = ?';

  @override
  String get hangulS6L4Step2Title => 'Lesson Complete!';

  @override
  String get hangulS6L4Step2Msg =>
      'Great!\nYou\'ve completed Random Reading 1.';

  @override
  String get hangulS6L5Title => 'Find the Syllable by Sound';

  @override
  String get hangulS6L5Subtitle => 'Strengthening Sound-Letter Connection';

  @override
  String get hangulS6L5Step0Title => 'Listen and Find Practice';

  @override
  String get hangulS6L5Step0Desc =>
      'Listen to the sound and choose the matching syllable\nto strengthen your reading connection.';

  @override
  String get hangulS6L5Step1Title => 'Sound Matching';

  @override
  String get hangulS6L5Step1Desc => 'Choose the correct syllable';

  @override
  String get hangulS6L5Step2Title => 'Lesson Complete!';

  @override
  String get hangulS6L5Step2Msg =>
      'Great!\nYou\'ve completed the listen-and-find practice.';

  @override
  String get hangulS6L6Title => 'Compound Vowel Combination 1';

  @override
  String get hangulS6L6Subtitle => 'Reading ㅘ, ㅝ';

  @override
  String get hangulS6L6Step0Title => 'Starting Compound Vowels';

  @override
  String get hangulS6L6Step0Desc =>
      'Let\'s read syllables formed with ㅘ and ㅝ.';

  @override
  String get hangulS6L6Step0Highlights => 'ㅘ,ㅝ,와,워';

  @override
  String get hangulS6L6Step1Title => 'Listen to 와/워';

  @override
  String get hangulS6L6Step1Desc =>
      'Listen to the representative syllable sounds';

  @override
  String get hangulS6L6Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS6L6Step2Desc => 'Say each syllable out loud';

  @override
  String get hangulS6L6Step3Title => 'Compound Vowel Quiz';

  @override
  String get hangulS6L6Step3Desc => 'Distinguish ㅘ and ㅝ';

  @override
  String get hangulS6L6Step3Q0 => 'ㅇ + ㅘ = ?';

  @override
  String get hangulS6L6Step3Q1 => 'ㄱ + ㅝ = ?';

  @override
  String get hangulS6L6Step4Title => 'Lesson Complete!';

  @override
  String get hangulS6L6Step4Msg =>
      'Great!\nYou\'ve learned the ㅘ/ㅝ combinations.';

  @override
  String get hangulS6L7Title => 'Compound Vowel Combination 2';

  @override
  String get hangulS6L7Subtitle => 'Reading ㅙ, ㅞ, ㅚ, ㅟ, ㅢ';

  @override
  String get hangulS6L7Step0Title => 'Expanding Compound Vowels';

  @override
  String get hangulS6L7Step0Desc =>
      'Briefly learn compound vowels and focus on reading.';

  @override
  String get hangulS6L7Step0Highlights => '왜,웨,외,위,의';

  @override
  String get hangulS6L7Step1Title => 'The Special Pronunciation of ㅢ';

  @override
  String get hangulS6L7Step1Desc =>
      'ㅢ is a special vowel whose sound changes by position.\n\n• Initial position: [의] → 의사, 의자\n• After a consonant: [이] → 희망→[히망]\n• Particle \"의\": [에] → 나의→[나에]';

  @override
  String get hangulS6L7Step1Highlights => 'ㅢ,의,이,에';

  @override
  String get hangulS6L7Step2Title => 'Choose the Compound Vowel';

  @override
  String get hangulS6L7Step2Desc => 'Choose the correct syllable';

  @override
  String get hangulS6L7Step2Q0 => 'ㅇ + ㅙ = ?';

  @override
  String get hangulS6L7Step2Q1 => 'ㅇ + ㅟ = ?';

  @override
  String get hangulS6L7Step2Q2 => 'ㅇ + ㅢ = ?';

  @override
  String get hangulS6L7Step3Title => 'Lesson Complete!';

  @override
  String get hangulS6L7Step3Msg =>
      'Great!\nYou\'ve completed the compound vowel expansion.';

  @override
  String get hangulS6L8Title => 'Random Syllable Reading 2';

  @override
  String get hangulS6L8Subtitle => 'Basic + Compound Vowel Review';

  @override
  String get hangulS6L8Step0Title => 'Comprehensive Random Reading';

  @override
  String get hangulS6L8Step0Desc =>
      'Read basic and compound vowel syllables all mixed together.';

  @override
  String get hangulS6L8Step1Title => 'Comprehensive Quiz';

  @override
  String get hangulS6L8Step1Desc => 'Match the random combinations';

  @override
  String get hangulS6L8Step1Q0 => 'ㄱ + ㅢ = ?';

  @override
  String get hangulS6L8Step1Q1 => 'ㅎ + ㅘ = ?';

  @override
  String get hangulS6L8Step1Q2 => 'ㅂ + ㅟ = ?';

  @override
  String get hangulS6L8Step1Q3 => 'ㅈ + ㅝ = ?';

  @override
  String get hangulS6L8Step2Title => 'Lesson Complete!';

  @override
  String get hangulS6L8Step2Msg =>
      'Great!\nYou\'ve completed the Stage 6 comprehensive reading.';

  @override
  String get hangulS6LMTitle => 'Stage 6 Mission';

  @override
  String get hangulS6LMSubtitle => 'Final Check: Syllable Combination Reading';

  @override
  String get hangulS6LMStep0Title => 'Mission Start!';

  @override
  String get hangulS6LMStep0Desc =>
      'This is the final check for syllable combination training.\nReach your goal within the time limit!';

  @override
  String get hangulS6LMStep1Title => 'Combine the Syllables!';

  @override
  String get hangulS6LMStep2Title => 'Mission Results';

  @override
  String get hangulS6LMStep3Title => 'Stage 6 Complete!';

  @override
  String get hangulS6LMStep3Msg =>
      'Congratulations!\nYou\'ve completed Stage 6 syllable combination training.';

  @override
  String get hangulS6CompleteTitle => 'Stage 6 Complete!';

  @override
  String get hangulS6CompleteMsg => 'You can now freely combine syllables!';

  @override
  String get hangulS7L1Title => 'ㄱ / ㅋ / ㄲ Contrast';

  @override
  String get hangulS7L1Subtitle => '가 · 카 · 까 Comparison';

  @override
  String get hangulS7L1Step0Title => 'Listen to Three Sounds';

  @override
  String get hangulS7L1Step0Desc =>
      'Distinguish ㄱ (plain), ㅋ (aspirated), ㄲ (tense) sounds.';

  @override
  String get hangulS7L1Step0Highlights => 'ㄱ,ㅋ,ㄲ,가,카,까';

  @override
  String get hangulS7L1Step1Title => 'Sound Exploration';

  @override
  String get hangulS7L1Step1Desc => 'Listen to 가/카/까 repeatedly';

  @override
  String get hangulS7L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS7L1Step2Desc => 'Pronounce each character aloud';

  @override
  String get hangulS7L1Step3Title => 'Listen and Choose';

  @override
  String get hangulS7L1Step3Desc =>
      'Select the correct answer from three choices';

  @override
  String get hangulS7L1Step4Title => 'Quick Check';

  @override
  String get hangulS7L1Step4Desc => 'Check shape and sound together';

  @override
  String get hangulS7L1Step4Q0 => 'Which is the aspirated consonant?';

  @override
  String get hangulS7L1Step4Q1 => 'Which is the tense consonant?';

  @override
  String get hangulS7L1Step5Title => 'Lesson Complete!';

  @override
  String get hangulS7L1Step5Msg =>
      'Great!\nYou\'ve learned to distinguish ㄱ/ㅋ/ㄲ.';

  @override
  String get hangulS7L2Title => 'ㄷ / ㅌ / ㄸ Contrast';

  @override
  String get hangulS7L2Subtitle => '다 · 타 · 따 Comparison';

  @override
  String get hangulS7L2Step0Title => 'Second Contrast Group';

  @override
  String get hangulS7L2Step0Desc => 'Compare ㄷ/ㅌ/ㄸ sounds.';

  @override
  String get hangulS7L2Step0Highlights => 'ㄷ,ㅌ,ㄸ,다,타,따';

  @override
  String get hangulS7L2Step1Title => 'Sound Exploration';

  @override
  String get hangulS7L2Step1Desc => 'Listen to 다/타/따 repeatedly';

  @override
  String get hangulS7L2Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS7L2Step2Desc => 'Pronounce each character aloud';

  @override
  String get hangulS7L2Step3Title => 'Listen and Choose';

  @override
  String get hangulS7L2Step3Desc =>
      'Select the correct answer from three choices';

  @override
  String get hangulS7L2Step4Title => 'Lesson Complete!';

  @override
  String get hangulS7L2Step4Msg =>
      'Great!\nYou\'ve learned to distinguish ㄷ/ㅌ/ㄸ.';

  @override
  String get hangulS7L3Title => 'ㅂ / ㅍ / ㅃ Contrast';

  @override
  String get hangulS7L3Subtitle => '바 · 파 · 빠 Comparison';

  @override
  String get hangulS7L3Step0Title => 'Third Contrast Group';

  @override
  String get hangulS7L3Step0Desc => 'Compare ㅂ/ㅍ/ㅃ sounds.';

  @override
  String get hangulS7L3Step0Highlights => 'ㅂ,ㅍ,ㅃ,바,파,빠';

  @override
  String get hangulS7L3Step1Title => 'Sound Exploration';

  @override
  String get hangulS7L3Step1Desc => 'Listen to 바/파/빠 repeatedly';

  @override
  String get hangulS7L3Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS7L3Step2Desc => 'Pronounce each character aloud';

  @override
  String get hangulS7L3Step3Title => 'Listen and Choose';

  @override
  String get hangulS7L3Step3Desc =>
      'Select the correct answer from three choices';

  @override
  String get hangulS7L3Step4Title => 'Lesson Complete!';

  @override
  String get hangulS7L3Step4Msg =>
      'Great!\nYou\'ve learned to distinguish ㅂ/ㅍ/ㅃ.';

  @override
  String get hangulS7L4Title => 'ㅅ / ㅆ Contrast';

  @override
  String get hangulS7L4Subtitle => '사 · 싸 Comparison';

  @override
  String get hangulS7L4Step0Title => 'Two-Sound Contrast';

  @override
  String get hangulS7L4Step0Desc => 'Distinguish ㅅ/ㅆ sounds.';

  @override
  String get hangulS7L4Step0Highlights => 'ㅅ,ㅆ,사,싸';

  @override
  String get hangulS7L4Step1Title => 'Sound Exploration';

  @override
  String get hangulS7L4Step1Desc => 'Listen to 사/싸 repeatedly';

  @override
  String get hangulS7L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS7L4Step2Desc => 'Pronounce each character aloud';

  @override
  String get hangulS7L4Step3Title => 'Listen and Choose';

  @override
  String get hangulS7L4Step3Desc =>
      'Select the correct answer from two choices';

  @override
  String get hangulS7L4Step4Title => 'Lesson Complete!';

  @override
  String get hangulS7L4Step4Msg =>
      'Great!\nYou\'ve learned to distinguish ㅅ/ㅆ.';

  @override
  String get hangulS7L5Title => 'ㅈ / ㅊ / ㅉ Contrast';

  @override
  String get hangulS7L5Subtitle => '자 · 차 · 짜 Comparison';

  @override
  String get hangulS7L5Step0Title => 'Final Contrast Group';

  @override
  String get hangulS7L5Step0Desc => 'Compare ㅈ/ㅊ/ㅉ sounds.';

  @override
  String get hangulS7L5Step0Highlights => 'ㅈ,ㅊ,ㅉ,자,차,짜';

  @override
  String get hangulS7L5Step1Title => 'Sound Exploration';

  @override
  String get hangulS7L5Step1Desc => 'Listen to 자/차/짜 repeatedly';

  @override
  String get hangulS7L5Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS7L5Step2Desc => 'Pronounce each character aloud';

  @override
  String get hangulS7L5Step3Title => 'Listen and Choose';

  @override
  String get hangulS7L5Step3Desc =>
      'Select the correct answer from three choices';

  @override
  String get hangulS7L5Step4Title => 'Stage 7 Complete!';

  @override
  String get hangulS7L5Step4Msg =>
      'Congratulations!\nYou\'ve completed all 5 contrast groups in Stage 7.';

  @override
  String get hangulS7LMTitle => 'Mission: Sound Distinction Challenge!';

  @override
  String get hangulS7LMSubtitle =>
      'Distinguish plain, aspirated, and tense consonants';

  @override
  String get hangulS7LMStep0Title => 'Sound Distinction Mission!';

  @override
  String get hangulS7LMStep0Desc =>
      'Mix plain, aspirated, and tense consonants\nto quickly assemble syllables!';

  @override
  String get hangulS7LMStep1Title => 'Assemble the Syllables!';

  @override
  String get hangulS7LMStep2Title => 'Mission Results';

  @override
  String get hangulS7LMStep3Title => 'Mission Complete!';

  @override
  String get hangulS7LMStep3Msg =>
      'You can distinguish plain, aspirated, and tense consonants!';

  @override
  String get hangulS7LMStep4Title => 'Stage 7 Complete!';

  @override
  String get hangulS7LMStep4Msg =>
      'You can distinguish tense and aspirated consonants!';

  @override
  String get hangulS7CompleteTitle => 'Stage 7 Complete!';

  @override
  String get hangulS7CompleteMsg =>
      'You can distinguish tense and aspirated consonants!';

  @override
  String get hangulS8L0Title => 'Batchim Basics';

  @override
  String get hangulS8L0Subtitle => 'The sound beneath the syllable block';

  @override
  String get hangulS8L0Step0Title => 'Batchim Sits at the Bottom';

  @override
  String get hangulS8L0Step0Desc =>
      'Batchim (final consonant) goes at the bottom of a syllable block.\nExample: 가 + ㄴ = 간';

  @override
  String get hangulS8L0Step0Highlights => 'batchim,간,말,집';

  @override
  String get hangulS8L0Step1Title => '7 Representative Batchim Sounds';

  @override
  String get hangulS8L0Step1Desc =>
      'There are only 7 representative sounds for batchim.\n\nㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\nMany batchim letters are pronounced as one of these 7 sounds.\nExample: ㅅ, ㅈ, ㅊ, ㅎ as batchim → all pronounced [ㄷ]';

  @override
  String get hangulS8L0Step1Highlights =>
      '7 sounds,ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ,representative';

  @override
  String get hangulS8L0Step2Title => 'Find the Batchim';

  @override
  String get hangulS8L0Step2Desc => 'Identify the batchim position';

  @override
  String get hangulS8L0Step2Q0 => 'What is the batchim in 간?';

  @override
  String get hangulS8L0Step2Q1 => 'What is the batchim in 말?';

  @override
  String get hangulS8L0SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L0SummaryMsg =>
      'Great!\nYou understand the concept of batchim.';

  @override
  String get hangulS8L1Title => 'ㄴ Batchim';

  @override
  String get hangulS8L1Subtitle => '간 · 난 · 단';

  @override
  String get hangulS8L1Step0Title => 'Listen to ㄴ Batchim';

  @override
  String get hangulS8L1Step0Desc => 'Listen to 간/난/단';

  @override
  String get hangulS8L1Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS8L1Step1Desc => 'Say each character out loud';

  @override
  String get hangulS8L1Step2Title => 'Listen and Choose';

  @override
  String get hangulS8L1Step2Desc => 'Select the syllable with ㄴ batchim';

  @override
  String get hangulS8L1SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L1SummaryMsg => 'Great!\nYou\'ve learned ㄴ batchim.';

  @override
  String get hangulS8L2Title => 'ㄹ Batchim';

  @override
  String get hangulS8L2Subtitle => '말 · 갈 · 물';

  @override
  String get hangulS8L2Step0Title => 'Listen to ㄹ Batchim';

  @override
  String get hangulS8L2Step0Desc => 'Listen to 말/갈/물';

  @override
  String get hangulS8L2Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS8L2Step1Desc => 'Say each character out loud';

  @override
  String get hangulS8L2Step2Title => 'Listen and Choose';

  @override
  String get hangulS8L2Step2Desc => 'Select the syllable with ㄹ batchim';

  @override
  String get hangulS8L2SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L2SummaryMsg => 'Great!\nYou\'ve learned ㄹ batchim.';

  @override
  String get hangulS8L3Title => 'ㅁ Batchim';

  @override
  String get hangulS8L3Subtitle => '감 · 밤 · 숨';

  @override
  String get hangulS8L3Step0Title => 'Listen to ㅁ Batchim';

  @override
  String get hangulS8L3Step0Desc => 'Listen to 감/밤/숨';

  @override
  String get hangulS8L3Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS8L3Step1Desc => 'Say each character out loud';

  @override
  String get hangulS8L3Step2Title => 'Identify the Batchim';

  @override
  String get hangulS8L3Step2Desc => 'Choose the ㅁ batchim syllable';

  @override
  String get hangulS8L3Step2Q0 => 'Which has ㅁ batchim?';

  @override
  String get hangulS8L3Step2Q1 => 'Which has ㅁ batchim?';

  @override
  String get hangulS8L3SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L3SummaryMsg => 'Great!\nYou\'ve learned ㅁ batchim.';

  @override
  String get hangulS8L4Title => 'ㅇ Batchim';

  @override
  String get hangulS8L4Subtitle => '방 · 공 · 종';

  @override
  String get hangulS8L4Step0Title => 'ㅇ is special!';

  @override
  String get hangulS8L4Step0Desc =>
      'ㅇ is special!\nAs an initial consonant it is silent (아, 오),\nbut as batchim it makes an \"ng\" sound (방, 공).';

  @override
  String get hangulS8L4Step0Highlights => 'initial consonant,batchim,ng,방,공';

  @override
  String get hangulS8L4Step1Title => 'Listen to ㅇ Batchim';

  @override
  String get hangulS8L4Step1Desc => 'Listen to 방/공/종';

  @override
  String get hangulS8L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS8L4Step2Desc => 'Say each character out loud';

  @override
  String get hangulS8L4Step3Title => 'Listen and Choose';

  @override
  String get hangulS8L4Step3Desc => 'Select the syllable with ㅇ batchim';

  @override
  String get hangulS8L4SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L4SummaryMsg => 'Great!\nYou\'ve learned ㅇ batchim.';

  @override
  String get hangulS8L5Title => 'ㄱ Batchim';

  @override
  String get hangulS8L5Subtitle => '박 · 각 · 국';

  @override
  String get hangulS8L5Step0Title => 'Listen to ㄱ Batchim';

  @override
  String get hangulS8L5Step0Desc => 'Listen to 박/각/국';

  @override
  String get hangulS8L5Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS8L5Step1Desc => 'Say each character out loud';

  @override
  String get hangulS8L5Step2Title => 'Identify the Batchim';

  @override
  String get hangulS8L5Step2Desc => 'Choose the ㄱ batchim syllable';

  @override
  String get hangulS8L5Step2Q0 => 'Which has ㄱ batchim?';

  @override
  String get hangulS8L5Step2Q1 => 'Which has ㄱ batchim?';

  @override
  String get hangulS8L5SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L5SummaryMsg => 'Great!\nYou\'ve learned ㄱ batchim.';

  @override
  String get hangulS8L6Title => 'ㅂ Batchim';

  @override
  String get hangulS8L6Subtitle => '밥 · 집 · 숲';

  @override
  String get hangulS8L6Step0Title => 'Listen to ㅂ Batchim';

  @override
  String get hangulS8L6Step0Desc => 'Listen to 밥/집/숲';

  @override
  String get hangulS8L6Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS8L6Step1Desc => 'Say each character out loud';

  @override
  String get hangulS8L6Step2Title => 'Listen and Choose';

  @override
  String get hangulS8L6Step2Desc => 'Select the syllable with ㅂ batchim';

  @override
  String get hangulS8L6SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L6SummaryMsg => 'Great!\nYou\'ve learned ㅂ batchim.';

  @override
  String get hangulS8L7Title => 'ㅅ Batchim';

  @override
  String get hangulS8L7Subtitle => '옷 · 맛 · 빛';

  @override
  String get hangulS8L7Step0Title => 'Listen to ㅅ Batchim';

  @override
  String get hangulS8L7Step0Desc => 'Listen to 옷/맛/빛';

  @override
  String get hangulS8L7Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS8L7Step1Desc => 'Say each character out loud';

  @override
  String get hangulS8L7Step2Title => 'Identify the Batchim';

  @override
  String get hangulS8L7Step2Desc => 'Choose the ㅅ batchim syllable';

  @override
  String get hangulS8L7Step2Q0 => 'Which has ㅅ batchim?';

  @override
  String get hangulS8L7Step2Q1 => 'Which has ㅅ batchim?';

  @override
  String get hangulS8L7SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L7SummaryMsg => 'Great!\nYou\'ve learned ㅅ batchim.';

  @override
  String get hangulS8L8Title => 'Mixed Batchim Review';

  @override
  String get hangulS8L8Subtitle => 'Random check of key batchim';

  @override
  String get hangulS8L8Step0Title => 'Mix It All Together';

  @override
  String get hangulS8L8Step0Desc => 'Let\'s review ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ together.';

  @override
  String get hangulS8L8Step1Title => 'Random Quiz';

  @override
  String get hangulS8L8Step1Desc => 'Test yourself on mixed batchim';

  @override
  String get hangulS8L8Step1Q0 => 'Which has ㄴ batchim?';

  @override
  String get hangulS8L8Step1Q1 => 'Which has ㅇ batchim?';

  @override
  String get hangulS8L8Step1Q2 => 'Which has ㄹ batchim?';

  @override
  String get hangulS8L8Step1Q3 => 'Which has ㅂ batchim?';

  @override
  String get hangulS8L8SummaryTitle => 'Lesson Complete!';

  @override
  String get hangulS8L8SummaryMsg =>
      'Great!\nYou finished the mixed batchim review.';

  @override
  String get hangulS8LMTitle => 'Mission: Batchim Challenge!';

  @override
  String get hangulS8LMSubtitle => 'Combine syllables with batchim';

  @override
  String get hangulS8LMStep0Title => 'Batchim Mission!';

  @override
  String get hangulS8LMStep0Desc =>
      'Read syllables with basic batchim\nand answer quickly!';

  @override
  String get hangulS8LMStep1Title => 'Build the Syllables!';

  @override
  String get hangulS8LMStep2Title => 'Mission Results';

  @override
  String get hangulS8LMSummaryTitle => 'Mission Complete!';

  @override
  String get hangulS8LMSummaryMsg =>
      'You\'ve fully mastered the basics of batchim!';

  @override
  String get hangulS8CompleteTitle => 'Stage 8 Complete!';

  @override
  String get hangulS8CompleteMsg =>
      'You\'ve built a solid foundation in batchim!';

  @override
  String get hangulS9L1Title => 'ㄷ Batchim Extended';

  @override
  String get hangulS9L1Subtitle => '닫 · 곧 · 묻';

  @override
  String get hangulS9L1Step0Title => 'ㄷ Batchim Pattern';

  @override
  String get hangulS9L1Step0Desc => 'Read syllables that contain ㄷ as batchim.';

  @override
  String get hangulS9L1Step0Highlights => '닫,곧,묻';

  @override
  String get hangulS9L1Step1Title => 'Listen: ㄷ Batchim';

  @override
  String get hangulS9L1Step1Desc => 'Listen to 닫/곧/묻';

  @override
  String get hangulS9L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS9L1Step2Desc => 'Say each character out loud';

  @override
  String get hangulS9L1Step3Title => 'Spot the Batchim';

  @override
  String get hangulS9L1Step3Desc => 'Choose the syllable with ㄷ batchim';

  @override
  String get hangulS9L1Step3Q0 => 'Which one has ㄷ batchim?';

  @override
  String get hangulS9L1Step3Q1 => 'Which one has ㄷ batchim?';

  @override
  String get hangulS9L1Step4Title => 'Lesson Complete!';

  @override
  String get hangulS9L1Step4Msg => 'Great!\nYou\'ve learned ㄷ batchim.';

  @override
  String get hangulS9L2Title => 'ㅈ Batchim Extended';

  @override
  String get hangulS9L2Subtitle => '낮 · 잊 · 젖';

  @override
  String get hangulS9L2Step0Title => 'Listen: ㅈ Batchim';

  @override
  String get hangulS9L2Step0Desc => 'Listen to 낮/잊/젖';

  @override
  String get hangulS9L2Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS9L2Step1Desc => 'Say each character out loud';

  @override
  String get hangulS9L2Step2Title => 'Listen and Choose';

  @override
  String get hangulS9L2Step2Desc => 'Pick the syllable with ㅈ batchim';

  @override
  String get hangulS9L2Step3Title => 'Lesson Complete!';

  @override
  String get hangulS9L2Step3Msg => 'Great!\nYou\'ve learned ㅈ batchim.';

  @override
  String get hangulS9L3Title => 'ㅊ Batchim Extended';

  @override
  String get hangulS9L3Subtitle => '꽃 · 닻 · 빚';

  @override
  String get hangulS9L3Step0Title => 'Listen: ㅊ Batchim';

  @override
  String get hangulS9L3Step0Desc => 'Listen to 꽃/닻/빚';

  @override
  String get hangulS9L3Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS9L3Step1Desc => 'Say each character out loud';

  @override
  String get hangulS9L3Step2Title => 'Spot the Batchim';

  @override
  String get hangulS9L3Step2Desc => 'Choose the syllable with ㅊ batchim';

  @override
  String get hangulS9L3Step2Q0 => 'Which one has ㅊ batchim?';

  @override
  String get hangulS9L3Step2Q1 => 'Which one has ㅊ batchim?';

  @override
  String get hangulS9L3Step3Title => 'Lesson Complete!';

  @override
  String get hangulS9L3Step3Msg => 'Great!\nYou\'ve learned ㅊ batchim.';

  @override
  String get hangulS9L4Title => 'ㅋ / ㅌ / ㅍ Batchim';

  @override
  String get hangulS9L4Subtitle => '부엌 · 밭 · 앞';

  @override
  String get hangulS9L4Step0Title => 'Three Batchim Together';

  @override
  String get hangulS9L4Step0Desc => 'Learn ㅋ, ㅌ, and ㅍ batchim as a group.';

  @override
  String get hangulS9L4Step0Highlights => '부엌,밭,앞';

  @override
  String get hangulS9L4Step1Title => 'Listen to the Sounds';

  @override
  String get hangulS9L4Step1Desc => 'Listen to 부엌/밭/앞';

  @override
  String get hangulS9L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS9L4Step2Desc => 'Say each character out loud';

  @override
  String get hangulS9L4Step3Title => 'Spot the Batchim';

  @override
  String get hangulS9L4Step3Desc => 'Tell the three batchim apart';

  @override
  String get hangulS9L4Step3Q0 => 'Which one has ㅌ batchim?';

  @override
  String get hangulS9L4Step3Q1 => 'Which one has ㅍ batchim?';

  @override
  String get hangulS9L4Step4Title => 'Lesson Complete!';

  @override
  String get hangulS9L4Step4Msg => 'Great!\nYou\'ve learned ㅋ/ㅌ/ㅍ batchim.';

  @override
  String get hangulS9L5Title => 'ㅎ Batchim Extended';

  @override
  String get hangulS9L5Subtitle => '좋 · 놓 · 않';

  @override
  String get hangulS9L5Step0Title => 'Listen: ㅎ Batchim';

  @override
  String get hangulS9L5Step0Desc => 'Listen to 좋/놓/않';

  @override
  String get hangulS9L5Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS9L5Step1Desc => 'Say each character out loud';

  @override
  String get hangulS9L5Step2Title => 'Listen and Choose';

  @override
  String get hangulS9L5Step2Desc => 'Pick the syllable with ㅎ batchim';

  @override
  String get hangulS9L5Step3Title => 'Lesson Complete!';

  @override
  String get hangulS9L5Step3Msg => 'Great!\nYou\'ve learned ㅎ batchim.';

  @override
  String get hangulS9L6Title => 'Extended Batchim Mix';

  @override
  String get hangulS9L6Subtitle => 'Mixing ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS9L6Step0Title => 'Mix It Up';

  @override
  String get hangulS9L6Step0Desc => 'Review all extended batchim at random.';

  @override
  String get hangulS9L6Step1Title => 'Random Quiz';

  @override
  String get hangulS9L6Step1Desc => 'Solve and distinguish each batchim';

  @override
  String get hangulS9L6Step1Q0 => 'Which one has ㄷ batchim?';

  @override
  String get hangulS9L6Step1Q1 => 'Which one has ㅈ batchim?';

  @override
  String get hangulS9L6Step1Q2 => 'Which one has ㅊ batchim?';

  @override
  String get hangulS9L6Step1Q3 => 'Which one has ㅎ batchim?';

  @override
  String get hangulS9L6Step2Title => 'Lesson Complete!';

  @override
  String get hangulS9L6Step2Msg =>
      'Great!\nYou\'ve completed the extended batchim review.';

  @override
  String get hangulS9L7Title => 'Stage 9 Review';

  @override
  String get hangulS9L7Subtitle => 'Finishing extended batchim reading';

  @override
  String get hangulS9L7Step0Title => 'Final Check';

  @override
  String get hangulS9L7Step0Desc => 'Final review of Stage 9 key points';

  @override
  String get hangulS9L7Step1Title => 'Stage 9 Complete!';

  @override
  String get hangulS9L7Step1Msg =>
      'Congratulations!\nYou\'ve completed Stage 9 extended batchim.';

  @override
  String get hangulS9LMTitle => 'Mission: Extended Batchim Challenge!';

  @override
  String get hangulS9LMSubtitle => 'Read various batchim quickly';

  @override
  String get hangulS9LMStep0Title => 'Extended Batchim Mission!';

  @override
  String get hangulS9LMStep0Desc =>
      'Assemble syllables with extended batchim\nas fast as you can!';

  @override
  String get hangulS9LMStep1Title => 'Assemble Syllables!';

  @override
  String get hangulS9LMStep2Title => 'Mission Results';

  @override
  String get hangulS9LMStep3Title => 'Mission Complete!';

  @override
  String get hangulS9LMStep3Msg => 'You\'ve mastered extended batchim!';

  @override
  String get hangulS9CompleteTitle => 'Stage 9 Complete!';

  @override
  String get hangulS9CompleteMsg => 'You\'ve mastered extended batchim!';

  @override
  String get hangulS10L1Title => 'ㄳ Batchim';

  @override
  String get hangulS10L1Subtitle => 'Reading centered on 몫 · 넋';

  @override
  String get hangulS10L1Step0Title => 'Pronunciation Rules for Double Batchim';

  @override
  String get hangulS10L1Step0Desc =>
      'Double batchim is a final consonant made of two consonants combined.\n\nMost are pronounced with the left consonant:\nㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\nSome are pronounced with the right consonant:\nㄺ→[ㄹ], ㄼ→[ㄹ]';

  @override
  String get hangulS10L1Step0Highlights =>
      'left consonant,right consonant,double batchim';

  @override
  String get hangulS10L1Step1Title => 'Starting Double Batchim';

  @override
  String get hangulS10L1Step1Desc =>
      'Let\'s read words that contain the ㄳ batchim.';

  @override
  String get hangulS10L1Step1Highlights => '몫,넋';

  @override
  String get hangulS10L1Step2Title => 'Listen to the Sounds';

  @override
  String get hangulS10L1Step2Desc => 'Listen to 몫/넋';

  @override
  String get hangulS10L1Step3Title => 'Pronunciation Practice';

  @override
  String get hangulS10L1Step3Desc => 'Say each character out loud';

  @override
  String get hangulS10L1Step4Title => 'Reading Check';

  @override
  String get hangulS10L1Step4Desc =>
      'Look at the word and choose the correct one';

  @override
  String get hangulS10L1Step4Q0 => 'Which word has the ㄳ batchim?';

  @override
  String get hangulS10L1Step4Q1 => 'Which word has the ㄳ batchim?';

  @override
  String get hangulS10L1Step5Title => 'Lesson Complete!';

  @override
  String get hangulS10L1Step5Msg => 'Great!\nYou\'ve learned the ㄳ batchim.';

  @override
  String get hangulS10L2Title => 'ㄵ / ㄶ Batchim';

  @override
  String get hangulS10L2Subtitle => '앉다 · 많다';

  @override
  String get hangulS10L2Step0Title => 'Listen to the Sounds';

  @override
  String get hangulS10L2Step0Desc => 'Listen to 앉다/많다';

  @override
  String get hangulS10L2Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS10L2Step1Desc => 'Say each character out loud';

  @override
  String get hangulS10L2Step2Title => 'Listen and Choose';

  @override
  String get hangulS10L2Step2Desc => 'Select the correct word';

  @override
  String get hangulS10L2Step3Title => 'Lesson Complete!';

  @override
  String get hangulS10L2Step3Msg => 'Great!\nYou\'ve learned the ㄵ/ㄶ batchim.';

  @override
  String get hangulS10L3Title => 'ㄺ / ㄻ Batchim';

  @override
  String get hangulS10L3Subtitle => '읽다 · 삶';

  @override
  String get hangulS10L3Step0Title => 'Listen to the Sounds';

  @override
  String get hangulS10L3Step0Desc => 'Listen to 읽다/삶';

  @override
  String get hangulS10L3Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS10L3Step1Desc => 'Say each character out loud';

  @override
  String get hangulS10L3Step2Title => 'Reading Check';

  @override
  String get hangulS10L3Step2Desc => 'Choose the double batchim word';

  @override
  String get hangulS10L3Step2Q0 => 'Which word has the ㄺ batchim?';

  @override
  String get hangulS10L3Step2Q1 => 'Which word has the ㄻ batchim?';

  @override
  String get hangulS10L3Step3Title => 'Lesson Complete!';

  @override
  String get hangulS10L3Step3Msg => 'Great!\nYou\'ve learned the ㄺ/ㄻ batchim.';

  @override
  String get hangulS10L4Title => 'Advanced Set 1';

  @override
  String get hangulS10L4Subtitle => 'ㄼ · ㄾ · ㄿ · ㅀ';

  @override
  String get hangulS10L4Step0Title => 'Introducing the Advanced Set';

  @override
  String get hangulS10L4Step0Desc =>
      'Let\'s briefly learn through common examples.';

  @override
  String get hangulS10L4Step0Highlights => '넓다,핥다,읊다,싫다';

  @override
  String get hangulS10L4Step1Title => 'Listen to the Words';

  @override
  String get hangulS10L4Step1Desc => 'Listen to 넓다/핥다/읊다/싫다';

  @override
  String get hangulS10L4Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS10L4Step2Desc => 'Say each character out loud';

  @override
  String get hangulS10L4Step3Title => 'Lesson Complete!';

  @override
  String get hangulS10L4Step3Msg => 'Great!\nYou\'ve learned Advanced Set 1.';

  @override
  String get hangulS10L5Title => 'ㅄ Batchim';

  @override
  String get hangulS10L5Subtitle => 'Reading centered on 없다';

  @override
  String get hangulS10L5Step0Title => 'Listen to the Sounds';

  @override
  String get hangulS10L5Step0Desc => 'Listen to 없다/없어';

  @override
  String get hangulS10L5Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS10L5Step1Desc => 'Say each character out loud';

  @override
  String get hangulS10L5Step2Title => 'Listen and Choose';

  @override
  String get hangulS10L5Step2Desc => 'Choose the correct word';

  @override
  String get hangulS10L5Step3Title => 'Lesson Complete!';

  @override
  String get hangulS10L5Step3Msg => 'Great!\nYou\'ve learned the ㅄ batchim.';

  @override
  String get hangulS10L6Title => 'Stage 10 Summary';

  @override
  String get hangulS10L6Subtitle => 'Double Batchim Word Review';

  @override
  String get hangulS10L6Step0Title => 'Comprehensive Review';

  @override
  String get hangulS10L6Step0Desc =>
      'Let\'s do a final check on double batchim words.';

  @override
  String get hangulS10L6Step0Q0 => 'Which of the following has the ㄶ batchim?';

  @override
  String get hangulS10L6Step0Q1 => 'Which of the following has the ㄺ batchim?';

  @override
  String get hangulS10L6Step0Q2 => 'Which of the following has the ㅄ batchim?';

  @override
  String get hangulS10L6Step0Q3 => 'Which of the following has the ㄳ batchim?';

  @override
  String get hangulS10L6Step1Title => 'Stage 10 Complete!';

  @override
  String get hangulS10L6Step1Msg =>
      'Congratulations!\nYou\'ve completed Stage 10 double batchim.';

  @override
  String get hangulS10LMTitle => 'Mission: Double Batchim Challenge!';

  @override
  String get hangulS10LMSubtitle => 'Read double batchim words quickly';

  @override
  String get hangulS10LMStep0Title => 'Double Batchim Mission!';

  @override
  String get hangulS10LMStep0Desc =>
      'Quickly combine syllables\nthat include double batchim!';

  @override
  String get hangulS10LMStep1Title => 'Combine the Syllables!';

  @override
  String get hangulS10LMStep2Title => 'Mission Results';

  @override
  String get hangulS10LMStep3Title => 'Mission Complete!';

  @override
  String get hangulS10LMStep3Msg => 'You\'ve mastered double batchim too!';

  @override
  String get hangulS10LMStep4Title => 'Stage 10 Complete!';

  @override
  String get hangulS10CompleteTitle => 'Stage 10 Complete!';

  @override
  String get hangulS10CompleteMsg => 'You\'ve mastered double batchim too!';

  @override
  String get hangulS11L1Title => 'Words without Batchim';

  @override
  String get hangulS11L1Subtitle => 'Easy 2–3 syllable words';

  @override
  String get hangulS11L1Step0Title => 'Start Reading Words';

  @override
  String get hangulS11L1Step0Desc =>
      'Let\'s build confidence with words that have no final consonant.';

  @override
  String get hangulS11L1Step0Highlights => '바나나,나비,하마,모자';

  @override
  String get hangulS11L1Step1Title => 'Listen to Words';

  @override
  String get hangulS11L1Step1Desc => 'Listen to 바나나 / 나비 / 하마 / 모자';

  @override
  String get hangulS11L1Step2Title => 'Pronunciation Practice';

  @override
  String get hangulS11L1Step2Desc => 'Say each word out loud';

  @override
  String get hangulS11L1Step3Title => 'Lesson Complete!';

  @override
  String get hangulS11L1Step3Msg =>
      'Great!\nYou started reading words without batchim.';

  @override
  String get hangulS11L2Title => 'Basic Batchim Words';

  @override
  String get hangulS11L2Subtitle => 'School · Friend · Korea · Study';

  @override
  String get hangulS11L2Step0Title => 'Listen to Words';

  @override
  String get hangulS11L2Step0Desc => 'Listen to 학교 / 친구 / 한국 / 공부';

  @override
  String get hangulS11L2Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS11L2Step1Desc => 'Say each word out loud';

  @override
  String get hangulS11L2Step2Title => 'Listen and Choose';

  @override
  String get hangulS11L2Step2Desc => 'Select the word you heard';

  @override
  String get hangulS11L2Step3Title => 'Lesson Complete!';

  @override
  String get hangulS11L2Step3Msg => 'Great!\nYou read basic batchim words.';

  @override
  String get hangulS11L3Title => 'Mixed Batchim Words';

  @override
  String get hangulS11L3Subtitle => '읽기 · 없다 · 많다 · 닭';

  @override
  String get hangulS11L3Step0Title => 'Level Up';

  @override
  String get hangulS11L3Step0Desc =>
      'Let\'s read words that mix basic and double batchim.';

  @override
  String get hangulS11L3Step0Highlights => '읽기,없다,많다,닭';

  @override
  String get hangulS11L3Step1Title => 'Distinguish Words';

  @override
  String get hangulS11L3Step1Desc => 'Tell apart similar-looking words';

  @override
  String get hangulS11L3Step1Q0 => 'Which word has a double batchim?';

  @override
  String get hangulS11L3Step1Q1 => 'Which word has a double batchim?';

  @override
  String get hangulS11L3Step2Title => 'Lesson Complete!';

  @override
  String get hangulS11L3Step2Msg => 'Great!\nYou read mixed batchim words.';

  @override
  String get hangulS11L4Title => 'Category Word Pack';

  @override
  String get hangulS11L4Subtitle => 'Food · Place · Person';

  @override
  String get hangulS11L4Step0Title => 'Listen to Category Words';

  @override
  String get hangulS11L4Step0Desc => 'Listen to food / place / person words';

  @override
  String get hangulS11L4Step1Title => 'Pronunciation Practice';

  @override
  String get hangulS11L4Step1Desc => 'Say each word out loud';

  @override
  String get hangulS11L4Step2Title => 'Sort by Category';

  @override
  String get hangulS11L4Step2Desc => 'Look at the word and choose its category';

  @override
  String get hangulS11L4Step2Q0 => 'What is \"김치\"?';

  @override
  String get hangulS11L4Step2Q1 => 'What is \"시장\"?';

  @override
  String get hangulS11L4Step2Q2 => 'What is \"학생\"?';

  @override
  String get hangulS11L4Step2CatFood => 'Food';

  @override
  String get hangulS11L4Step2CatPlace => 'Place';

  @override
  String get hangulS11L4Step2CatPerson => 'Person';

  @override
  String get hangulS11L4Step3Title => 'Lesson Complete!';

  @override
  String get hangulS11L4Step3Msg => 'Great!\nYou learned category words.';

  @override
  String get hangulS11L5Title => 'Listen and Pick Words';

  @override
  String get hangulS11L5Subtitle => 'Strengthening audio–reading connection';

  @override
  String get hangulS11L5Step0Title => 'Sound Matching';

  @override
  String get hangulS11L5Step0Desc => 'Listen and choose the correct word';

  @override
  String get hangulS11L5Step1Title => 'Lesson Complete!';

  @override
  String get hangulS11L5Step1Msg =>
      'Great!\nYou completed the listen-and-pick word training.';

  @override
  String get hangulS11L6Title => 'Stage 11 Review';

  @override
  String get hangulS11L6Subtitle => 'Final check on word reading';

  @override
  String get hangulS11L6Step0Title => 'Comprehensive Quiz';

  @override
  String get hangulS11L6Step0Desc => 'Final review of Stage 11 words';

  @override
  String get hangulS11L6Step0Q0 => 'Which word has no batchim?';

  @override
  String get hangulS11L6Step0Q1 => 'Which word has a basic batchim?';

  @override
  String get hangulS11L6Step0Q2 => 'Which word has a double batchim?';

  @override
  String get hangulS11L6Step0Q3 => 'Which word is a place?';

  @override
  String get hangulS11L6Step1Title => 'Stage 11 Complete!';

  @override
  String get hangulS11L6Step1Msg =>
      'Congratulations!\nYou completed Stage 11 extended word reading.';

  @override
  String get hangulS11L7Title => 'Reading Korean in Real Life';

  @override
  String get hangulS11L7Subtitle =>
      'Read café menus, subway stations, and greetings';

  @override
  String get hangulS11L7Step0Title => 'Reading Hangul in Korea!';

  @override
  String get hangulS11L7Step0Desc =>
      'You\'ve learned all of Hangul!\nShall we read words you\'d see in real Korea?';

  @override
  String get hangulS11L7Step0Highlights => 'Café,Subway,Greetings';

  @override
  String get hangulS11L7Step1Title => 'Reading Café Menus';

  @override
  String get hangulS11L7Step1Descs => 'Americano,Caffe Latte,Green Tea,Cake';

  @override
  String get hangulS11L7Step2Title => 'Reading Subway Station Names';

  @override
  String get hangulS11L7Step2Descs =>
      'Seoul Station,Gangnam,Hongdae,Myeongdong';

  @override
  String get hangulS11L7Step3Title => 'Reading Basic Greetings';

  @override
  String get hangulS11L7Step3Descs => 'Hello,Thank you,Yes,No';

  @override
  String get hangulS11L7Step4Title => 'Pronunciation Practice';

  @override
  String get hangulS11L7Step4Desc => 'Say each word out loud';

  @override
  String get hangulS11L7Step5Title => 'Where can you see it?';

  @override
  String get hangulS11L7Step5Q0 => 'Where can you see \"아메리카노\"?';

  @override
  String get hangulS11L7Step5Q0Ans => 'Café';

  @override
  String get hangulS11L7Step5Q0C0 => 'Café';

  @override
  String get hangulS11L7Step5Q0C1 => 'Subway';

  @override
  String get hangulS11L7Step5Q0C2 => 'School';

  @override
  String get hangulS11L7Step5Q1 => 'What is \"강남\"?';

  @override
  String get hangulS11L7Step5Q1Ans => 'Subway station name';

  @override
  String get hangulS11L7Step5Q1C0 => 'Food name';

  @override
  String get hangulS11L7Step5Q1C1 => 'Subway station name';

  @override
  String get hangulS11L7Step5Q1C2 => 'Greeting';

  @override
  String get hangulS11L7Step5Q2 => 'What does \"감사합니다\" mean in English?';

  @override
  String get hangulS11L7Step5Q2Ans => 'Thank you';

  @override
  String get hangulS11L7Step5Q2C0 => 'Hello';

  @override
  String get hangulS11L7Step5Q2C1 => 'Thank you';

  @override
  String get hangulS11L7Step5Q2C2 => 'Goodbye';

  @override
  String get hangulS11L7Step6Title => 'Congratulations!';

  @override
  String get hangulS11L7Step6Msg =>
      'You can now read café menus, subway stations, and greetings in Korea!\nYou\'re almost a Hangul master!';

  @override
  String get hangulS11LMTitle => 'Mission: Hangul Speed Reading!';

  @override
  String get hangulS11LMSubtitle => 'Read Korean words quickly';

  @override
  String get hangulS11LMStep0Title => 'Hangul Speed Reading Mission!';

  @override
  String get hangulS11LMStep0Desc =>
      'Read and match Korean words as fast as you can!\nIt\'s time to prove your skills!';

  @override
  String get hangulS11LMStep1Title => 'Combine the Syllables!';

  @override
  String get hangulS11LMStep2Title => 'Mission Results';

  @override
  String get hangulS11LMStep3Title => 'Hangul Master!';

  @override
  String get hangulS11LMStep3Msg =>
      'You\'ve completely mastered Hangul!\nYou can now read Korean words and sentences!';

  @override
  String get hangulS11LMStep4Title => 'Stage 11 Complete!';

  @override
  String get hangulS11LMStep4Msg => 'You can now read Hangul completely!';

  @override
  String get hangulS11CompleteTitle => 'Stage 11 Complete!';

  @override
  String get hangulS11CompleteMsg => 'You can now read Hangul completely!';

  @override
  String get stageRequestFailed =>
      'Failed to send stage request. Please try again.';

  @override
  String get stageRequestRejected =>
      'Your stage request was declined by the host.';

  @override
  String get inviteToStageFailed =>
      'Failed to invite to stage. The stage may be full.';

  @override
  String get demoteFailed => 'Failed to remove from stage. Please try again.';

  @override
  String get voiceRoomCloseRoomFailed =>
      'Failed to close room. Please try again.';
}
