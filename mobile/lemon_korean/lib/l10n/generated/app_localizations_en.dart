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
  String get lessonComplete => 'Lesson Complete!';

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
  String get fillBlank => 'Fill in the Blank';

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
  String get correctAnswerIs => 'Correct answer:';

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
}
