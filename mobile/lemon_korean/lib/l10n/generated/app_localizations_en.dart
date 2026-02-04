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
    return 'At least $count characters';
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
      'Network connection failed. Please check your network settings.';

  @override
  String get invalidCredentials => 'Invalid email or password';

  @override
  String get emailAlreadyExists => 'Email is already registered';

  @override
  String get requestTimeout => 'Request timed out. Please try again.';

  @override
  String get operationFailed => 'Operation failed. Please try again later.';

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
  String get dailyReminderDesc =>
      'Receive a reminder at a fixed time every day';

  @override
  String get reminderTime => 'Reminder Time';

  @override
  String reminderTimeSet(String time) {
    return 'Reminder time set to $time';
  }

  @override
  String get reviewReminder => 'Review Reminder';

  @override
  String get reviewReminderDesc => 'Receive reminders based on memory curve';

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
      'A Korean learning app designed for Chinese speakers, supporting offline learning, smart review reminders, and more.';

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
    return '$count days later';
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
  String get lessonComplete => 'Lesson complete! Progress saved';

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
    return '$days day streak';
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
  String get grammarExplanation => 'Grammar Explanation';

  @override
  String get exampleSentences => 'Example Sentences';

  @override
  String get previous => 'Previous';

  @override
  String get next => 'Next';

  @override
  String get continueBtn => 'Continue';

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
  String get fillBlank => 'Fill in the blank';

  @override
  String get translation => 'Translation';

  @override
  String get wordOrder => 'Word Order';

  @override
  String get pronunciation => 'Pronunciation';

  @override
  String get excellent => 'Excellent!';

  @override
  String get correctOrderIs => 'Correct order:';

  @override
  String correctAnswerIs(String answer) {
    return 'Correct answer: $answer';
  }

  @override
  String get previousQuestion => 'Previous Question';

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
    return '$count lessons completed';
  }

  @override
  String minutesLearned(int minutes) {
    return '$minutes minutes learned';
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
    return '$count words waiting for review';
  }

  @override
  String get user => 'User';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingLanguageTitle => 'Lemon Korean';

  @override
  String get onboardingLanguagePrompt => 'Choose your preferred language';

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
    return '$count days ago';
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
    return 'Are you sure you want to delete all $count downloads?';
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
    return '$count words';
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
  String get searchWordsNotesChinese => 'Search words, Chinese, or notes...';

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
    return '$count weeks ago';
  }

  @override
  String get reviewComplete => 'Review Complete!';

  @override
  String reviewCompleteCount(int count) {
    return 'Reviewed $count words';
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
      'Bookmark words during learning to start reviewing';

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
    return '$count completed';
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
    return '$count characters';
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
  String get loadAlphabetFirst => 'Please load alphabet data first';

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
      'Time to complete today\'s Korean study~';

  @override
  String get reviewReminderTitle => 'Time to Review!';

  @override
  String reviewReminderBody(String title) {
    return 'Time to review \"$title\"~';
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
    return '$count characters need review';
  }

  @override
  String charactersAvailable(int count) {
    return '$count characters available';
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
  String get practiceFunctionDeveloping =>
      'Practice function under development';

  @override
  String get romanization => 'Romanization: ';

  @override
  String get pronunciationLabel => 'Pronunciation: ';

  @override
  String get playPronunciation => 'Play pronunciation';

  @override
  String strokesCount(int count) {
    return '$count strokes';
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
    return '$count words';
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
  String grammarPattern(String pattern) {
    return 'Grammar · $pattern';
  }

  @override
  String get conjugationRule => 'Conjugation Rule';

  @override
  String get comparisonWithChinese => 'Comparison with Chinese';

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
  String get checkAnswerBtn => 'Check Answer';

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
  String get statusFailed => 'Failed';

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
      'Don\'t forget to complete your daily Korean practice~';

  @override
  String get notificationReviewTime => 'Time to review!';

  @override
  String get notificationReviewReminder =>
      'Let\'s review what you\'ve learned before~';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return 'Time to review \"$lessonTitle\"~';
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
}
