import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ko'),
    Locale('zh'),
    Locale('zh', 'TW'),
    Locale('en'),
    Locale('ja'),
    Locale('es')
  ];

  /// App name
  ///
  /// In zh, this message translates to:
  /// **'柠檬韩语'**
  String get appName;

  /// Login button
  ///
  /// In zh, this message translates to:
  /// **'登录'**
  String get login;

  /// Register button
  ///
  /// In zh, this message translates to:
  /// **'注册'**
  String get register;

  /// Email field label
  ///
  /// In zh, this message translates to:
  /// **'邮箱'**
  String get email;

  /// Password field label
  ///
  /// In zh, this message translates to:
  /// **'密码'**
  String get password;

  /// Confirm password field label
  ///
  /// In zh, this message translates to:
  /// **'确认密码'**
  String get confirmPassword;

  /// Username field label
  ///
  /// In zh, this message translates to:
  /// **'用户名'**
  String get username;

  /// Email placeholder
  ///
  /// In zh, this message translates to:
  /// **'请输入邮箱地址'**
  String get enterEmail;

  /// Password placeholder
  ///
  /// In zh, this message translates to:
  /// **'请输入密码'**
  String get enterPassword;

  /// Confirm password placeholder
  ///
  /// In zh, this message translates to:
  /// **'请再次输入密码'**
  String get enterConfirmPassword;

  /// Username placeholder
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名'**
  String get enterUsername;

  /// Create account title
  ///
  /// In zh, this message translates to:
  /// **'创建账号'**
  String get createAccount;

  /// Subtitle for registration
  ///
  /// In zh, this message translates to:
  /// **'开始你的韩语学习之旅'**
  String get startJourney;

  /// Interface language label
  ///
  /// In zh, this message translates to:
  /// **'界面语言'**
  String get interfaceLanguage;

  /// Simplified Chinese option
  ///
  /// In zh, this message translates to:
  /// **'简体中文'**
  String get simplifiedChinese;

  /// Traditional Chinese option
  ///
  /// In zh, this message translates to:
  /// **'繁体中文'**
  String get traditionalChinese;

  /// Password requirements title
  ///
  /// In zh, this message translates to:
  /// **'密码要求'**
  String get passwordRequirements;

  /// Minimum characters requirement
  ///
  /// In zh, this message translates to:
  /// **'至少{count}个字符'**
  String minCharacters(int count);

  /// Letters and numbers requirement
  ///
  /// In zh, this message translates to:
  /// **'包含字母和数字'**
  String get containLettersNumbers;

  /// Already have account text
  ///
  /// In zh, this message translates to:
  /// **'已有账号？'**
  String get haveAccount;

  /// No account text
  ///
  /// In zh, this message translates to:
  /// **'没有账号？'**
  String get noAccount;

  /// Login now button
  ///
  /// In zh, this message translates to:
  /// **'立即登录'**
  String get loginNow;

  /// Register now button
  ///
  /// In zh, this message translates to:
  /// **'立即注册'**
  String get registerNow;

  /// Registration success message
  ///
  /// In zh, this message translates to:
  /// **'注册成功'**
  String get registerSuccess;

  /// Registration failed message
  ///
  /// In zh, this message translates to:
  /// **'注册失败'**
  String get registerFailed;

  /// Login success message
  ///
  /// In zh, this message translates to:
  /// **'登录成功'**
  String get loginSuccess;

  /// Login failed message
  ///
  /// In zh, this message translates to:
  /// **'登录失败'**
  String get loginFailed;

  /// Network error message
  ///
  /// In zh, this message translates to:
  /// **'网络连接失败，请检查网络设置'**
  String get networkError;

  /// Invalid credentials message
  ///
  /// In zh, this message translates to:
  /// **'邮箱或密码错误'**
  String get invalidCredentials;

  /// Email exists message
  ///
  /// In zh, this message translates to:
  /// **'邮箱已被注册'**
  String get emailAlreadyExists;

  /// Request timeout message
  ///
  /// In zh, this message translates to:
  /// **'请求超时，请重试'**
  String get requestTimeout;

  /// Generic operation failed message
  ///
  /// In zh, this message translates to:
  /// **'操作失败，请稍后重试'**
  String get operationFailed;

  /// Settings title
  ///
  /// In zh, this message translates to:
  /// **'设置'**
  String get settings;

  /// Language settings title
  ///
  /// In zh, this message translates to:
  /// **'语言设置'**
  String get languageSettings;

  /// Chinese display section title
  ///
  /// In zh, this message translates to:
  /// **'中文显示'**
  String get chineseDisplay;

  /// Chinese display description
  ///
  /// In zh, this message translates to:
  /// **'选择中文文字显示方式。更改后将立即应用到所有界面。'**
  String get chineseDisplayDesc;

  /// Switched to simplified message
  ///
  /// In zh, this message translates to:
  /// **'已切换到简体中文'**
  String get switchedToSimplified;

  /// Switched to traditional message
  ///
  /// In zh, this message translates to:
  /// **'已切换到繁体中文'**
  String get switchedToTraditional;

  /// Display tip text
  ///
  /// In zh, this message translates to:
  /// **'提示：课程内容将使用你选择的中文字体显示。'**
  String get displayTip;

  /// Notification settings title
  ///
  /// In zh, this message translates to:
  /// **'通知设置'**
  String get notificationSettings;

  /// Enable notifications toggle
  ///
  /// In zh, this message translates to:
  /// **'启用通知'**
  String get enableNotifications;

  /// Enable notifications description
  ///
  /// In zh, this message translates to:
  /// **'开启后可以接收学习提醒'**
  String get enableNotificationsDesc;

  /// Permission required message
  ///
  /// In zh, this message translates to:
  /// **'请在系统设置中允许通知权限'**
  String get permissionRequired;

  /// Daily learning reminder section
  ///
  /// In zh, this message translates to:
  /// **'每日学习提醒'**
  String get dailyLearningReminder;

  /// Daily reminder toggle
  ///
  /// In zh, this message translates to:
  /// **'每日提醒'**
  String get dailyReminder;

  /// Daily reminder description
  ///
  /// In zh, this message translates to:
  /// **'每天固定时间提醒学习'**
  String get dailyReminderDesc;

  /// Reminder time label
  ///
  /// In zh, this message translates to:
  /// **'提醒时间'**
  String get reminderTime;

  /// Reminder time set message
  ///
  /// In zh, this message translates to:
  /// **'提醒时间已设置为 {time}'**
  String reminderTimeSet(String time);

  /// Review reminder toggle
  ///
  /// In zh, this message translates to:
  /// **'复习提醒'**
  String get reviewReminder;

  /// Review reminder description
  ///
  /// In zh, this message translates to:
  /// **'根据记忆曲线提醒复习'**
  String get reviewReminderDesc;

  /// Tip prefix
  ///
  /// In zh, this message translates to:
  /// **'提示：'**
  String get notificationTip;

  /// Help center title
  ///
  /// In zh, this message translates to:
  /// **'帮助中心'**
  String get helpCenter;

  /// Offline learning section
  ///
  /// In zh, this message translates to:
  /// **'离线学习'**
  String get offlineLearning;

  /// How to download FAQ
  ///
  /// In zh, this message translates to:
  /// **'如何下载课程？'**
  String get howToDownload;

  /// How to download answer
  ///
  /// In zh, this message translates to:
  /// **'在课程列表中，点击右侧的下载图标即可下载课程。下载后可以离线学习。'**
  String get howToDownloadAnswer;

  /// How to use downloaded FAQ
  ///
  /// In zh, this message translates to:
  /// **'如何使用已下载的课程？'**
  String get howToUseDownloaded;

  /// How to use downloaded answer
  ///
  /// In zh, this message translates to:
  /// **'即使没有网络连接，你也可以正常学习已下载的课程。进度会在本地保存，联网后自动同步。'**
  String get howToUseDownloadedAnswer;

  /// Storage management section
  ///
  /// In zh, this message translates to:
  /// **'存储管理'**
  String get storageManagement;

  /// How to check storage FAQ
  ///
  /// In zh, this message translates to:
  /// **'如何查看存储空间？'**
  String get howToCheckStorage;

  /// How to check storage answer
  ///
  /// In zh, this message translates to:
  /// **'进入【设置 → 存储管理】可以查看已使用和可用的存储空间。'**
  String get howToCheckStorageAnswer;

  /// How to delete downloaded FAQ
  ///
  /// In zh, this message translates to:
  /// **'如何删除已下载的课程？'**
  String get howToDeleteDownloaded;

  /// How to delete downloaded answer
  ///
  /// In zh, this message translates to:
  /// **'在【存储管理】页面，点击课程旁边的删除按钮即可删除。'**
  String get howToDeleteDownloadedAnswer;

  /// Notification section in help
  ///
  /// In zh, this message translates to:
  /// **'通知设置'**
  String get notificationSection;

  /// How to enable reminder FAQ
  ///
  /// In zh, this message translates to:
  /// **'如何开启学习提醒？'**
  String get howToEnableReminder;

  /// How to enable reminder answer
  ///
  /// In zh, this message translates to:
  /// **'进入【设置 → 通知设置】，打开【启用通知】开关。首次使用需要授予通知权限。'**
  String get howToEnableReminderAnswer;

  /// What is review reminder FAQ
  ///
  /// In zh, this message translates to:
  /// **'什么是复习提醒？'**
  String get whatIsReviewReminder;

  /// What is review reminder answer
  ///
  /// In zh, this message translates to:
  /// **'基于间隔重复算法（SRS），应用会在最佳时间提醒你复习已学课程。复习间隔：1天 → 3天 → 7天 → 14天 → 30天。'**
  String get whatIsReviewReminderAnswer;

  /// Language section in help
  ///
  /// In zh, this message translates to:
  /// **'语言设置'**
  String get languageSection;

  /// How to switch Chinese FAQ
  ///
  /// In zh, this message translates to:
  /// **'如何切换简繁体中文？'**
  String get howToSwitchChinese;

  /// How to switch Chinese answer
  ///
  /// In zh, this message translates to:
  /// **'进入【设置 → 语言设置】，选择【简体中文】或【繁体中文】。更改后立即生效。'**
  String get howToSwitchChineseAnswer;

  /// FAQ section title
  ///
  /// In zh, this message translates to:
  /// **'常见问题'**
  String get faq;

  /// How to start learning FAQ
  ///
  /// In zh, this message translates to:
  /// **'如何开始学习？'**
  String get howToStart;

  /// How to start learning answer
  ///
  /// In zh, this message translates to:
  /// **'在主页面选择适合你水平的课程，从第1课开始。每节课包含7个学习阶段。'**
  String get howToStartAnswer;

  /// Progress not saved FAQ
  ///
  /// In zh, this message translates to:
  /// **'进度没有保存怎么办？'**
  String get progressNotSaved;

  /// Progress not saved answer
  ///
  /// In zh, this message translates to:
  /// **'进度会自动保存到本地。如果联网，会自动同步到服务器。请检查网络连接。'**
  String get progressNotSavedAnswer;

  /// About app title
  ///
  /// In zh, this message translates to:
  /// **'关于应用'**
  String get aboutApp;

  /// More info section
  ///
  /// In zh, this message translates to:
  /// **'更多信息'**
  String get moreInfo;

  /// Version info label
  ///
  /// In zh, this message translates to:
  /// **'版本信息'**
  String get versionInfo;

  /// Developer label
  ///
  /// In zh, this message translates to:
  /// **'开发者'**
  String get developer;

  /// App introduction label
  ///
  /// In zh, this message translates to:
  /// **'应用介绍'**
  String get appIntro;

  /// App introduction content
  ///
  /// In zh, this message translates to:
  /// **'专为中文使用者设计的韩语学习应用，支持离线学习、智能复习提醒等功能。'**
  String get appIntroContent;

  /// Terms of service
  ///
  /// In zh, this message translates to:
  /// **'服务条款'**
  String get termsOfService;

  /// Terms coming soon message
  ///
  /// In zh, this message translates to:
  /// **'服务条款页面开发中...'**
  String get termsComingSoon;

  /// Privacy policy
  ///
  /// In zh, this message translates to:
  /// **'隐私政策'**
  String get privacyPolicy;

  /// Privacy coming soon message
  ///
  /// In zh, this message translates to:
  /// **'隐私政策页面开发中...'**
  String get privacyComingSoon;

  /// Open source licenses
  ///
  /// In zh, this message translates to:
  /// **'开源许可'**
  String get openSourceLicenses;

  /// Status: not started
  ///
  /// In zh, this message translates to:
  /// **'未开始'**
  String get notStarted;

  /// Status: in progress
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get inProgress;

  /// Status: completed
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get completed;

  /// Status: not passed
  ///
  /// In zh, this message translates to:
  /// **'未通过'**
  String get notPassed;

  /// Time to review message
  ///
  /// In zh, this message translates to:
  /// **'该复习了'**
  String get timeToReview;

  /// Today
  ///
  /// In zh, this message translates to:
  /// **'今天'**
  String get today;

  /// Tomorrow
  ///
  /// In zh, this message translates to:
  /// **'明天'**
  String get tomorrow;

  /// Days later
  ///
  /// In zh, this message translates to:
  /// **'{count}天后'**
  String daysLater(int count);

  /// Part of speech: noun
  ///
  /// In zh, this message translates to:
  /// **'名词'**
  String get noun;

  /// Part of speech: verb
  ///
  /// In zh, this message translates to:
  /// **'动词'**
  String get verb;

  /// Part of speech: adjective
  ///
  /// In zh, this message translates to:
  /// **'形容词'**
  String get adjective;

  /// Part of speech: adverb
  ///
  /// In zh, this message translates to:
  /// **'副词'**
  String get adverb;

  /// Part of speech: particle
  ///
  /// In zh, this message translates to:
  /// **'助词'**
  String get particle;

  /// Part of speech: pronoun
  ///
  /// In zh, this message translates to:
  /// **'代词'**
  String get pronoun;

  /// High similarity level
  ///
  /// In zh, this message translates to:
  /// **'高相似度'**
  String get highSimilarity;

  /// Medium similarity level
  ///
  /// In zh, this message translates to:
  /// **'中等相似度'**
  String get mediumSimilarity;

  /// Low similarity level
  ///
  /// In zh, this message translates to:
  /// **'低相似度'**
  String get lowSimilarity;

  /// Learning complete title
  ///
  /// In zh, this message translates to:
  /// **'学习完成'**
  String get learningComplete;

  /// Experience points gained
  ///
  /// In zh, this message translates to:
  /// **'经验值 +{points}'**
  String experiencePoints(int points);

  /// Keep learning message
  ///
  /// In zh, this message translates to:
  /// **'继续保持学习热情'**
  String get keepLearning;

  /// Streak days increased
  ///
  /// In zh, this message translates to:
  /// **'学习连续天数 +1'**
  String get streakDays;

  /// Streak days count
  ///
  /// In zh, this message translates to:
  /// **'已连续学习 {days} 天'**
  String streakDaysCount(int days);

  /// Lesson content title
  ///
  /// In zh, this message translates to:
  /// **'本课学习内容'**
  String get lessonContent;

  /// Words label
  ///
  /// In zh, this message translates to:
  /// **'单词'**
  String get words;

  /// Grammar points label
  ///
  /// In zh, this message translates to:
  /// **'语法点'**
  String get grammarPoints;

  /// Dialogues label
  ///
  /// In zh, this message translates to:
  /// **'对话'**
  String get dialogues;

  /// Previous button
  ///
  /// In zh, this message translates to:
  /// **'上一个'**
  String get previous;

  /// Next button
  ///
  /// In zh, this message translates to:
  /// **'下一个'**
  String get next;

  /// Topic particle grammar
  ///
  /// In zh, this message translates to:
  /// **'主题助词'**
  String get topicParticle;

  /// Honorific ending grammar
  ///
  /// In zh, this message translates to:
  /// **'敬语结尾'**
  String get honorificEnding;

  /// Question word what
  ///
  /// In zh, this message translates to:
  /// **'什么'**
  String get questionWord;

  /// Hello
  ///
  /// In zh, this message translates to:
  /// **'你好'**
  String get hello;

  /// Thank you
  ///
  /// In zh, this message translates to:
  /// **'谢谢'**
  String get thankYou;

  /// Goodbye
  ///
  /// In zh, this message translates to:
  /// **'再见'**
  String get goodbye;

  /// Sorry
  ///
  /// In zh, this message translates to:
  /// **'对不起'**
  String get sorry;

  /// I am a student
  ///
  /// In zh, this message translates to:
  /// **'我是学生'**
  String get imStudent;

  /// Book is interesting
  ///
  /// In zh, this message translates to:
  /// **'书很有趣'**
  String get bookInteresting;

  /// Is student
  ///
  /// In zh, this message translates to:
  /// **'是学生'**
  String get isStudent;

  /// Is teacher
  ///
  /// In zh, this message translates to:
  /// **'是老师'**
  String get isTeacher;

  /// What is this?
  ///
  /// In zh, this message translates to:
  /// **'这是什么？'**
  String get whatIsThis;

  /// What are you doing? (polite)
  ///
  /// In zh, this message translates to:
  /// **'在做什么？'**
  String get whatDoingPolite;

  /// Listen and choose instruction
  ///
  /// In zh, this message translates to:
  /// **'听音频，选择正确的翻译'**
  String get listenAndChoose;

  /// Fill in blank instruction
  ///
  /// In zh, this message translates to:
  /// **'填入正确的助词'**
  String get fillInBlank;

  /// Choose translation instruction
  ///
  /// In zh, this message translates to:
  /// **'选择正确的翻译'**
  String get chooseTranslation;

  /// Arrange words instruction
  ///
  /// In zh, this message translates to:
  /// **'按正确顺序排列单词'**
  String get arrangeWords;

  /// Choose pronunciation instruction
  ///
  /// In zh, this message translates to:
  /// **'选择正确的发音'**
  String get choosePronunciation;

  /// Consonant ending quiz question
  ///
  /// In zh, this message translates to:
  /// **'当名词以辅音结尾时，应该使用哪个主题助词？'**
  String get consonantEnding;

  /// Choose correct sentence instruction
  ///
  /// In zh, this message translates to:
  /// **'选择正确的句子'**
  String get correctSentence;

  /// All of the above option
  ///
  /// In zh, this message translates to:
  /// **'以上都对'**
  String get allCorrect;

  /// How are you?
  ///
  /// In zh, this message translates to:
  /// **'你好吗？'**
  String get howAreYou;

  /// What is your name?
  ///
  /// In zh, this message translates to:
  /// **'你叫什么名字？'**
  String get whatIsYourName;

  /// Who are you?
  ///
  /// In zh, this message translates to:
  /// **'你是谁？'**
  String get whoAreYou;

  /// Where are you?
  ///
  /// In zh, this message translates to:
  /// **'你在哪里？'**
  String get whereAreYou;

  /// Nice to meet you
  ///
  /// In zh, this message translates to:
  /// **'很高兴认识你'**
  String get niceToMeetYou;

  /// You are a student
  ///
  /// In zh, this message translates to:
  /// **'你是学生'**
  String get areYouStudent;

  /// Are you a student?
  ///
  /// In zh, this message translates to:
  /// **'你是学生吗？'**
  String get areYouStudentQuestion;

  /// Am I a student?
  ///
  /// In zh, this message translates to:
  /// **'我是学生吗？'**
  String get amIStudent;

  /// Listening question type
  ///
  /// In zh, this message translates to:
  /// **'听力'**
  String get listening;

  /// Translation question type
  ///
  /// In zh, this message translates to:
  /// **'翻译'**
  String get translation;

  /// Word order question type
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get wordOrder;

  /// Excellent feedback
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get excellent;

  /// Correct order is prefix
  ///
  /// In zh, this message translates to:
  /// **'正确顺序是：'**
  String get correctOrderIs;

  /// Next question button
  ///
  /// In zh, this message translates to:
  /// **'下一题'**
  String get nextQuestion;

  /// Finish button
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get finish;

  /// Quiz complete title
  ///
  /// In zh, this message translates to:
  /// **'测验完成！'**
  String get quizComplete;

  /// Great job message
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get greatJob;

  /// Keep practicing message
  ///
  /// In zh, this message translates to:
  /// **'继续加油！'**
  String get keepPracticing;

  /// Score display
  ///
  /// In zh, this message translates to:
  /// **'得分：{correct} / {total}'**
  String score(int correct, int total);

  /// Mastered content message
  ///
  /// In zh, this message translates to:
  /// **'你已经很好地掌握了本课内容！'**
  String get masteredContent;

  /// Review suggestion message
  ///
  /// In zh, this message translates to:
  /// **'建议复习一下课程内容，再来挑战吧！'**
  String get reviewSuggestion;

  /// Time used display
  ///
  /// In zh, this message translates to:
  /// **'用时：{time}'**
  String timeUsed(String time);

  /// Play audio button
  ///
  /// In zh, this message translates to:
  /// **'播放音频'**
  String get playAudio;

  /// Replay audio button
  ///
  /// In zh, this message translates to:
  /// **'重新播放'**
  String get replayAudio;

  /// Vowel ending explanation prefix
  ///
  /// In zh, this message translates to:
  /// **'以元音结尾，使用'**
  String get vowelEnding;

  /// Lesson number
  ///
  /// In zh, this message translates to:
  /// **'第{number}课'**
  String lessonNumber(int number);

  /// Stage 1: Introduction
  ///
  /// In zh, this message translates to:
  /// **'课程介绍'**
  String get stageIntro;

  /// Stage 2: Vocabulary
  ///
  /// In zh, this message translates to:
  /// **'词汇学习'**
  String get stageVocabulary;

  /// Stage 3: Grammar
  ///
  /// In zh, this message translates to:
  /// **'语法讲解'**
  String get stageGrammar;

  /// Stage 4: Practice
  ///
  /// In zh, this message translates to:
  /// **'练习'**
  String get stagePractice;

  /// Stage 5: Dialogue
  ///
  /// In zh, this message translates to:
  /// **'对话练习'**
  String get stageDialogue;

  /// Stage 6: Quiz
  ///
  /// In zh, this message translates to:
  /// **'测验'**
  String get stageQuiz;

  /// Stage 7: Summary
  ///
  /// In zh, this message translates to:
  /// **'总结'**
  String get stageSummary;

  /// Download lesson button
  ///
  /// In zh, this message translates to:
  /// **'下载课程'**
  String get downloadLesson;

  /// Downloading status
  ///
  /// In zh, this message translates to:
  /// **'下载中...'**
  String get downloading;

  /// Downloaded status
  ///
  /// In zh, this message translates to:
  /// **'已下载'**
  String get downloaded;

  /// Download failed status
  ///
  /// In zh, this message translates to:
  /// **'下载失败'**
  String get downloadFailed;

  /// Home tab
  ///
  /// In zh, this message translates to:
  /// **'首页'**
  String get home;

  /// Lessons tab
  ///
  /// In zh, this message translates to:
  /// **'课程'**
  String get lessons;

  /// Review tab
  ///
  /// In zh, this message translates to:
  /// **'复习'**
  String get review;

  /// Profile tab
  ///
  /// In zh, this message translates to:
  /// **'我的'**
  String get profile;

  /// Continue learning button
  ///
  /// In zh, this message translates to:
  /// **'继续学习'**
  String get continueLearning;

  /// Daily goal title
  ///
  /// In zh, this message translates to:
  /// **'每日目标'**
  String get dailyGoal;

  /// Lessons completed count
  ///
  /// In zh, this message translates to:
  /// **'已完成 {count} 课'**
  String lessonsCompleted(int count);

  /// Minutes learned count
  ///
  /// In zh, this message translates to:
  /// **'已学习 {minutes} 分钟'**
  String minutesLearned(int minutes);

  /// Welcome message
  ///
  /// In zh, this message translates to:
  /// **'欢迎回来'**
  String get welcome;

  /// Good morning greeting
  ///
  /// In zh, this message translates to:
  /// **'早上好'**
  String get goodMorning;

  /// Good afternoon greeting
  ///
  /// In zh, this message translates to:
  /// **'下午好'**
  String get goodAfternoon;

  /// Good evening greeting
  ///
  /// In zh, this message translates to:
  /// **'晚上好'**
  String get goodEvening;

  /// Logout button
  ///
  /// In zh, this message translates to:
  /// **'退出登录'**
  String get logout;

  /// Logout confirmation
  ///
  /// In zh, this message translates to:
  /// **'确定要退出登录吗？'**
  String get confirmLogout;

  /// Cancel button
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancel;

  /// Confirm button
  ///
  /// In zh, this message translates to:
  /// **'确定'**
  String get confirm;

  /// Delete button
  ///
  /// In zh, this message translates to:
  /// **'删除'**
  String get delete;

  /// Save button
  ///
  /// In zh, this message translates to:
  /// **'保存'**
  String get save;

  /// Edit button
  ///
  /// In zh, this message translates to:
  /// **'编辑'**
  String get edit;

  /// Close button
  ///
  /// In zh, this message translates to:
  /// **'关闭'**
  String get close;

  /// Retry button
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get retry;

  /// Loading status
  ///
  /// In zh, this message translates to:
  /// **'加载中...'**
  String get loading;

  /// No data message
  ///
  /// In zh, this message translates to:
  /// **'暂无数据'**
  String get noData;

  /// Error title
  ///
  /// In zh, this message translates to:
  /// **'出错了'**
  String get error;

  /// Generic error message
  ///
  /// In zh, this message translates to:
  /// **'出错了'**
  String get errorOccurred;

  /// Reload button
  ///
  /// In zh, this message translates to:
  /// **'重新加载'**
  String get reload;

  /// No characters message
  ///
  /// In zh, this message translates to:
  /// **'暂无可用字符'**
  String get noCharactersAvailable;

  /// Success title
  ///
  /// In zh, this message translates to:
  /// **'成功'**
  String get success;

  /// Filter button
  ///
  /// In zh, this message translates to:
  /// **'筛选'**
  String get filter;

  /// Review schedule title
  ///
  /// In zh, this message translates to:
  /// **'复习计划'**
  String get reviewSchedule;

  /// Today's review title
  ///
  /// In zh, this message translates to:
  /// **'今日复习'**
  String get todayReview;

  /// Start review button
  ///
  /// In zh, this message translates to:
  /// **'开始复习'**
  String get startReview;

  /// Learning statistics section
  ///
  /// In zh, this message translates to:
  /// **'学习统计'**
  String get learningStats;

  /// Completed lessons label
  ///
  /// In zh, this message translates to:
  /// **'已完成课程'**
  String get completedLessonsCount;

  /// Study days label
  ///
  /// In zh, this message translates to:
  /// **'学习天数'**
  String get studyDays;

  /// Mastered words label
  ///
  /// In zh, this message translates to:
  /// **'掌握单词'**
  String get masteredWordsCount;

  /// My vocabulary book
  ///
  /// In zh, this message translates to:
  /// **'我的单词本'**
  String get myVocabularyBook;

  /// Vocabulary browser
  ///
  /// In zh, this message translates to:
  /// **'单词浏览器'**
  String get vocabularyBrowser;

  /// About section
  ///
  /// In zh, this message translates to:
  /// **'关于'**
  String get about;

  /// Premium member label
  ///
  /// In zh, this message translates to:
  /// **'高级会员'**
  String get premiumMember;

  /// Free user label
  ///
  /// In zh, this message translates to:
  /// **'免费用户'**
  String get freeUser;

  /// Words waiting for review
  ///
  /// In zh, this message translates to:
  /// **'{count}个单词等待复习'**
  String wordsWaitingReview(int count);

  /// Default user name
  ///
  /// In zh, this message translates to:
  /// **'用户'**
  String get user;

  /// Onboarding skip button
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get onboardingSkip;

  /// Onboarding language selection title
  ///
  /// In zh, this message translates to:
  /// **'你好！我是莫妮'**
  String get onboardingLanguageTitle;

  /// Onboarding language selection prompt
  ///
  /// In zh, this message translates to:
  /// **'从哪种语言开始一起学习呢？'**
  String get onboardingLanguagePrompt;

  /// Onboarding next button
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get onboardingNext;

  /// Onboarding welcome message
  ///
  /// In zh, this message translates to:
  /// **'你好！我是柠檬韩语的柠檬 🍋\n我们一起学韩语吧？'**
  String get onboardingWelcome;

  /// Onboarding level question
  ///
  /// In zh, this message translates to:
  /// **'你现在的韩语水平是？'**
  String get onboardingLevelQuestion;

  /// Onboarding start button
  ///
  /// In zh, this message translates to:
  /// **'开始学习'**
  String get onboardingStart;

  /// Onboarding start without level selection
  ///
  /// In zh, this message translates to:
  /// **'跳过并开始'**
  String get onboardingStartWithoutLevel;

  /// Beginner level
  ///
  /// In zh, this message translates to:
  /// **'入门'**
  String get levelBeginner;

  /// Beginner level description
  ///
  /// In zh, this message translates to:
  /// **'没关系！从韩文字母开始'**
  String get levelBeginnerDesc;

  /// Elementary level
  ///
  /// In zh, this message translates to:
  /// **'初级'**
  String get levelElementary;

  /// Elementary level description
  ///
  /// In zh, this message translates to:
  /// **'从基础会话开始练习！'**
  String get levelElementaryDesc;

  /// Intermediate level
  ///
  /// In zh, this message translates to:
  /// **'中级'**
  String get levelIntermediate;

  /// Intermediate level description
  ///
  /// In zh, this message translates to:
  /// **'说得更自然！'**
  String get levelIntermediateDesc;

  /// Advanced level
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get levelAdvanced;

  /// Advanced level description
  ///
  /// In zh, this message translates to:
  /// **'掌握细节表达！'**
  String get levelAdvancedDesc;

  /// Welcome screen title
  ///
  /// In zh, this message translates to:
  /// **'欢迎来到柠檬韩语！'**
  String get onboardingWelcomeTitle;

  /// Welcome screen subtitle
  ///
  /// In zh, this message translates to:
  /// **'在这里开启你的韩语之旅'**
  String get onboardingWelcomeSubtitle;

  /// Feature 1 title
  ///
  /// In zh, this message translates to:
  /// **'随时随地离线学习'**
  String get onboardingFeature1Title;

  /// Feature 1 description
  ///
  /// In zh, this message translates to:
  /// **'下载课程，无需网络即可学习'**
  String get onboardingFeature1Desc;

  /// Feature 2 title
  ///
  /// In zh, this message translates to:
  /// **'智能复习系统'**
  String get onboardingFeature2Title;

  /// Feature 2 description
  ///
  /// In zh, this message translates to:
  /// **'AI驱动的间隔重复，提升记忆效果'**
  String get onboardingFeature2Desc;

  /// Feature 3 title
  ///
  /// In zh, this message translates to:
  /// **'7阶段学习路径'**
  String get onboardingFeature3Title;

  /// Feature 3 description
  ///
  /// In zh, this message translates to:
  /// **'从入门到高级的结构化课程'**
  String get onboardingFeature3Desc;

  /// Level selection title
  ///
  /// In zh, this message translates to:
  /// **'你的韩语水平如何？'**
  String get onboardingLevelTitle;

  /// Level selection subtitle
  ///
  /// In zh, this message translates to:
  /// **'我们将为你定制学习体验'**
  String get onboardingLevelSubtitle;

  /// Goal selection title
  ///
  /// In zh, this message translates to:
  /// **'设定你的每周目标'**
  String get onboardingGoalTitle;

  /// Goal selection subtitle
  ///
  /// In zh, this message translates to:
  /// **'你能投入多少时间？'**
  String get onboardingGoalSubtitle;

  /// Casual goal option
  ///
  /// In zh, this message translates to:
  /// **'休闲'**
  String get goalCasual;

  /// Casual goal description
  ///
  /// In zh, this message translates to:
  /// **'每周1-2课'**
  String get goalCasualDesc;

  /// Casual goal time
  ///
  /// In zh, this message translates to:
  /// **'~每周10-20分钟'**
  String get goalCasualTime;

  /// Casual goal helper text
  ///
  /// In zh, this message translates to:
  /// **'适合忙碌的日程'**
  String get goalCasualHelper;

  /// Regular goal option
  ///
  /// In zh, this message translates to:
  /// **'规律'**
  String get goalRegular;

  /// Regular goal description
  ///
  /// In zh, this message translates to:
  /// **'每周3-4课'**
  String get goalRegularDesc;

  /// Regular goal time
  ///
  /// In zh, this message translates to:
  /// **'~每周30-40分钟'**
  String get goalRegularTime;

  /// Regular goal helper text
  ///
  /// In zh, this message translates to:
  /// **'稳定进步，无压力'**
  String get goalRegularHelper;

  /// Serious goal option
  ///
  /// In zh, this message translates to:
  /// **'认真'**
  String get goalSerious;

  /// Serious goal description
  ///
  /// In zh, this message translates to:
  /// **'每周5-6课'**
  String get goalSeriousDesc;

  /// Serious goal time
  ///
  /// In zh, this message translates to:
  /// **'~每周50-60分钟'**
  String get goalSeriousTime;

  /// Serious goal helper text
  ///
  /// In zh, this message translates to:
  /// **'致力于快速提升'**
  String get goalSeriousHelper;

  /// Intensive goal option
  ///
  /// In zh, this message translates to:
  /// **'强化'**
  String get goalIntensive;

  /// Intensive goal description
  ///
  /// In zh, this message translates to:
  /// **'每日练习'**
  String get goalIntensiveDesc;

  /// Intensive goal time
  ///
  /// In zh, this message translates to:
  /// **'每周60分钟以上'**
  String get goalIntensiveTime;

  /// Intensive goal helper text
  ///
  /// In zh, this message translates to:
  /// **'最快学习速度'**
  String get goalIntensiveHelper;

  /// Completion screen title
  ///
  /// In zh, this message translates to:
  /// **'一切就绪！'**
  String get onboardingCompleteTitle;

  /// Completion screen subtitle
  ///
  /// In zh, this message translates to:
  /// **'开始你的学习之旅'**
  String get onboardingCompleteSubtitle;

  /// Summary language label
  ///
  /// In zh, this message translates to:
  /// **'界面语言'**
  String get onboardingSummaryLanguage;

  /// Summary level label
  ///
  /// In zh, this message translates to:
  /// **'韩语水平'**
  String get onboardingSummaryLevel;

  /// Summary goal label
  ///
  /// In zh, this message translates to:
  /// **'每周目标'**
  String get onboardingSummaryGoal;

  /// Start learning button
  ///
  /// In zh, this message translates to:
  /// **'开始学习'**
  String get onboardingStartLearning;

  /// Back button
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get onboardingBack;

  /// Account choice screen title
  ///
  /// In zh, this message translates to:
  /// **'准备好了吗？'**
  String get onboardingAccountTitle;

  /// Account choice screen subtitle
  ///
  /// In zh, this message translates to:
  /// **'登录或创建账户以保存学习进度'**
  String get onboardingAccountSubtitle;

  /// TOPIK level indicator
  ///
  /// In zh, this message translates to:
  /// **'TOPIK {level}'**
  String levelTopik(String level);

  /// App language section title
  ///
  /// In zh, this message translates to:
  /// **'应用语言'**
  String get appLanguage;

  /// App language description
  ///
  /// In zh, this message translates to:
  /// **'选择应用界面使用的语言。'**
  String get appLanguageDesc;

  /// Language selected message
  ///
  /// In zh, this message translates to:
  /// **'已选择 {language}'**
  String languageSelected(String language);

  /// Sort button tooltip
  ///
  /// In zh, this message translates to:
  /// **'排序'**
  String get sort;

  /// No description provided for @notificationTipContent.
  ///
  /// In zh, this message translates to:
  /// **'• 复习提醒会在完成课程后自动安排\n• 部分手机需要在系统设置中关闭省电模式才能正常接收通知'**
  String get notificationTipContent;

  /// Yesterday
  ///
  /// In zh, this message translates to:
  /// **'昨天'**
  String get yesterday;

  /// Days ago
  ///
  /// In zh, this message translates to:
  /// **'{count}天前'**
  String daysAgo(int count);

  /// Date format
  ///
  /// In zh, this message translates to:
  /// **'{month}月{day}日'**
  String dateFormat(int month, int day);

  /// No description provided for @downloadManager.
  ///
  /// In zh, this message translates to:
  /// **'下载管理'**
  String get downloadManager;

  /// No description provided for @storageInfo.
  ///
  /// In zh, this message translates to:
  /// **'存储信息'**
  String get storageInfo;

  /// No description provided for @clearAllDownloads.
  ///
  /// In zh, this message translates to:
  /// **'清空下载'**
  String get clearAllDownloads;

  /// No description provided for @downloadedTab.
  ///
  /// In zh, this message translates to:
  /// **'已下载'**
  String get downloadedTab;

  /// No description provided for @availableTab.
  ///
  /// In zh, this message translates to:
  /// **'可下载'**
  String get availableTab;

  /// No description provided for @downloadedLessons.
  ///
  /// In zh, this message translates to:
  /// **'已下载课程'**
  String get downloadedLessons;

  /// No description provided for @mediaFiles.
  ///
  /// In zh, this message translates to:
  /// **'媒体文件'**
  String get mediaFiles;

  /// No description provided for @usedStorage.
  ///
  /// In zh, this message translates to:
  /// **'使用中'**
  String get usedStorage;

  /// No description provided for @cacheStorage.
  ///
  /// In zh, this message translates to:
  /// **'缓存'**
  String get cacheStorage;

  /// No description provided for @totalStorage.
  ///
  /// In zh, this message translates to:
  /// **'总计'**
  String get totalStorage;

  /// No description provided for @allDownloadsCleared.
  ///
  /// In zh, this message translates to:
  /// **'已清空所有下载'**
  String get allDownloadsCleared;

  /// No description provided for @availableStorage.
  ///
  /// In zh, this message translates to:
  /// **'可用'**
  String get availableStorage;

  /// No description provided for @noDownloadedLessons.
  ///
  /// In zh, this message translates to:
  /// **'暂无已下载课程'**
  String get noDownloadedLessons;

  /// No description provided for @goToAvailableTab.
  ///
  /// In zh, this message translates to:
  /// **'切换到\"可下载\"标签开始下载'**
  String get goToAvailableTab;

  /// No description provided for @allLessonsDownloaded.
  ///
  /// In zh, this message translates to:
  /// **'所有课程已下载'**
  String get allLessonsDownloaded;

  /// No description provided for @deleteDownload.
  ///
  /// In zh, this message translates to:
  /// **'删除下载'**
  String get deleteDownload;

  /// Confirm delete download
  ///
  /// In zh, this message translates to:
  /// **'确定要删除\"{title}\"吗？'**
  String confirmDeleteDownload(String title);

  /// Confirm clear all downloads
  ///
  /// In zh, this message translates to:
  /// **'确定要删除所有 {count} 个已下载课程吗？'**
  String confirmClearAllDownloads(int count);

  /// Downloading count
  ///
  /// In zh, this message translates to:
  /// **'下载中 ({count})'**
  String downloadingCount(int count);

  /// Preparing status
  ///
  /// In zh, this message translates to:
  /// **'准备中...'**
  String get preparing;

  /// Lesson ID
  ///
  /// In zh, this message translates to:
  /// **'课程 {id}'**
  String lessonId(int id);

  /// Search words placeholder
  ///
  /// In zh, this message translates to:
  /// **'搜索单词...'**
  String get searchWords;

  /// Word count
  ///
  /// In zh, this message translates to:
  /// **'{count}个单词'**
  String wordCount(int count);

  /// No description provided for @sortByLesson.
  ///
  /// In zh, this message translates to:
  /// **'按课程'**
  String get sortByLesson;

  /// No description provided for @sortByKorean.
  ///
  /// In zh, this message translates to:
  /// **'按韩语'**
  String get sortByKorean;

  /// No description provided for @sortByChinese.
  ///
  /// In zh, this message translates to:
  /// **'按中文'**
  String get sortByChinese;

  /// No description provided for @noWordsFound.
  ///
  /// In zh, this message translates to:
  /// **'未找到相关单词'**
  String get noWordsFound;

  /// No description provided for @noMasteredWords.
  ///
  /// In zh, this message translates to:
  /// **'暂无掌握的单词'**
  String get noMasteredWords;

  /// No description provided for @hanja.
  ///
  /// In zh, this message translates to:
  /// **'汉字'**
  String get hanja;

  /// No description provided for @exampleSentence.
  ///
  /// In zh, this message translates to:
  /// **'例句'**
  String get exampleSentence;

  /// No description provided for @mastered.
  ///
  /// In zh, this message translates to:
  /// **'已掌握'**
  String get mastered;

  /// No description provided for @completedLessons.
  ///
  /// In zh, this message translates to:
  /// **'已完成课程'**
  String get completedLessons;

  /// No description provided for @noCompletedLessons.
  ///
  /// In zh, this message translates to:
  /// **'暂无完成的课程'**
  String get noCompletedLessons;

  /// No description provided for @startFirstLesson.
  ///
  /// In zh, this message translates to:
  /// **'开始学习第一课吧！'**
  String get startFirstLesson;

  /// No description provided for @masteredWords.
  ///
  /// In zh, this message translates to:
  /// **'已掌握单词'**
  String get masteredWords;

  /// No description provided for @download.
  ///
  /// In zh, this message translates to:
  /// **'下载'**
  String get download;

  /// Hangul learning section title
  ///
  /// In zh, this message translates to:
  /// **'韩文字母学习'**
  String get hangulLearning;

  /// Hangul learning subtitle
  ///
  /// In zh, this message translates to:
  /// **'学习韩文字母表 40个字母'**
  String get hangulLearningSubtitle;

  /// Edit notes dialog title
  ///
  /// In zh, this message translates to:
  /// **'编辑笔记'**
  String get editNotes;

  /// Notes field label
  ///
  /// In zh, this message translates to:
  /// **'笔记'**
  String get notes;

  /// Notes hint text
  ///
  /// In zh, this message translates to:
  /// **'为什么要收藏这个单词？'**
  String get notesHint;

  /// Sort by title
  ///
  /// In zh, this message translates to:
  /// **'排序方式'**
  String get sortBy;

  /// Sort by newest
  ///
  /// In zh, this message translates to:
  /// **'最新收藏'**
  String get sortNewest;

  /// Sort by oldest
  ///
  /// In zh, this message translates to:
  /// **'最早收藏'**
  String get sortOldest;

  /// Sort by Korean
  ///
  /// In zh, this message translates to:
  /// **'韩文排序'**
  String get sortKorean;

  /// Sort by Chinese
  ///
  /// In zh, this message translates to:
  /// **'中文排序'**
  String get sortChinese;

  /// Sort by mastery
  ///
  /// In zh, this message translates to:
  /// **'掌握程度'**
  String get sortMastery;

  /// Filter all
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get filterAll;

  /// Filter new words
  ///
  /// In zh, this message translates to:
  /// **'新学 (0级)'**
  String get filterNew;

  /// Filter beginner
  ///
  /// In zh, this message translates to:
  /// **'初级 (1级)'**
  String get filterBeginner;

  /// Filter intermediate
  ///
  /// In zh, this message translates to:
  /// **'中级 (2-3级)'**
  String get filterIntermediate;

  /// Filter advanced
  ///
  /// In zh, this message translates to:
  /// **'高级 (4-5级)'**
  String get filterAdvanced;

  /// Search placeholder for vocabulary book
  ///
  /// In zh, this message translates to:
  /// **'搜索单词、中文或笔记...'**
  String get searchWordsNotesChinese;

  /// Start review button with count
  ///
  /// In zh, this message translates to:
  /// **'开始复习 ({count})'**
  String startReviewCount(int count);

  /// Remove button
  ///
  /// In zh, this message translates to:
  /// **'移除'**
  String get remove;

  /// Confirm remove dialog title
  ///
  /// In zh, this message translates to:
  /// **'确认移除'**
  String get confirmRemove;

  /// Confirm remove word message
  ///
  /// In zh, this message translates to:
  /// **'确定要从单词本移除「{word}」吗？'**
  String confirmRemoveWord(String word);

  /// No bookmarked words message
  ///
  /// In zh, this message translates to:
  /// **'还没有收藏的单词'**
  String get noBookmarkedWords;

  /// Bookmark hint
  ///
  /// In zh, this message translates to:
  /// **'在学习过程中点击单词卡片上的书签图标'**
  String get bookmarkHint;

  /// No matching words message
  ///
  /// In zh, this message translates to:
  /// **'没有找到匹配的单词'**
  String get noMatchingWords;

  /// Weeks ago
  ///
  /// In zh, this message translates to:
  /// **'{count}周前'**
  String weeksAgo(int count);

  /// Review complete title
  ///
  /// In zh, this message translates to:
  /// **'复习完成！'**
  String get reviewComplete;

  /// Review complete message
  ///
  /// In zh, this message translates to:
  /// **'已完成 {count} 个单词的复习'**
  String reviewCompleteCount(int count);

  /// Correct label
  ///
  /// In zh, this message translates to:
  /// **'正确'**
  String get correct;

  /// Wrong label
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get wrong;

  /// Accuracy label
  ///
  /// In zh, this message translates to:
  /// **'准确率'**
  String get accuracy;

  /// Vocabulary book review title
  ///
  /// In zh, this message translates to:
  /// **'单词本复习'**
  String get vocabularyBookReview;

  /// No words to review message
  ///
  /// In zh, this message translates to:
  /// **'暂无需要复习的单词'**
  String get noWordsToReview;

  /// Bookmark words hint
  ///
  /// In zh, this message translates to:
  /// **'在学习过程中收藏单词后开始复习'**
  String get bookmarkWordsToReview;

  /// Return to vocabulary book button
  ///
  /// In zh, this message translates to:
  /// **'返回单词本'**
  String get returnToVocabularyBook;

  /// Exit button
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get exit;

  /// Show answer button
  ///
  /// In zh, this message translates to:
  /// **'显示答案'**
  String get showAnswer;

  /// Did you remember question
  ///
  /// In zh, this message translates to:
  /// **'你记住了吗？'**
  String get didYouRemember;

  /// Forgot rating
  ///
  /// In zh, this message translates to:
  /// **'忘记了'**
  String get forgot;

  /// Hard rating
  ///
  /// In zh, this message translates to:
  /// **'困难'**
  String get hard;

  /// Remembered rating
  ///
  /// In zh, this message translates to:
  /// **'记得'**
  String get remembered;

  /// Easy rating
  ///
  /// In zh, this message translates to:
  /// **'简单'**
  String get easy;

  /// Added to vocabulary book message
  ///
  /// In zh, this message translates to:
  /// **'已添加到单词本'**
  String get addedToVocabularyBook;

  /// Add failed message
  ///
  /// In zh, this message translates to:
  /// **'添加失败'**
  String get addFailed;

  /// Removed from vocabulary book message
  ///
  /// In zh, this message translates to:
  /// **'已从单词本移除'**
  String get removedFromVocabularyBook;

  /// Remove failed message
  ///
  /// In zh, this message translates to:
  /// **'移除失败'**
  String get removeFailed;

  /// Add to vocabulary book title
  ///
  /// In zh, this message translates to:
  /// **'添加到单词本'**
  String get addToVocabularyBook;

  /// Notes optional label
  ///
  /// In zh, this message translates to:
  /// **'笔记（可选）'**
  String get notesOptional;

  /// Add button
  ///
  /// In zh, this message translates to:
  /// **'添加'**
  String get add;

  /// Bookmarked label
  ///
  /// In zh, this message translates to:
  /// **'已收藏'**
  String get bookmarked;

  /// Bookmark label
  ///
  /// In zh, this message translates to:
  /// **'收藏'**
  String get bookmark;

  /// Remove from vocabulary book tooltip
  ///
  /// In zh, this message translates to:
  /// **'从单词本移除'**
  String get removeFromVocabularyBook;

  /// Similarity percentage
  ///
  /// In zh, this message translates to:
  /// **'相似度: {percent}%'**
  String similarityPercent(int percent);

  /// Added or removed message
  ///
  /// In zh, this message translates to:
  /// **'{added, select, true{已添加到单词本} other{已取消收藏}}'**
  String addedOrRemoved(String added);

  /// Days unit
  ///
  /// In zh, this message translates to:
  /// **'天'**
  String get days;

  /// Lessons completed count short
  ///
  /// In zh, this message translates to:
  /// **'{count} 课完成'**
  String lessonsCompletedCount(int count);

  /// Daily goal complete message
  ///
  /// In zh, this message translates to:
  /// **'太棒了！今日目标已完成！'**
  String get dailyGoalComplete;

  /// Hangul alphabet
  ///
  /// In zh, this message translates to:
  /// **'韩文字母'**
  String get hangulAlphabet;

  /// Alphabet table tab
  ///
  /// In zh, this message translates to:
  /// **'字母表'**
  String get alphabetTable;

  /// Learn tab
  ///
  /// In zh, this message translates to:
  /// **'学习'**
  String get learn;

  /// Practice tab
  ///
  /// In zh, this message translates to:
  /// **'练习'**
  String get practice;

  /// Learning progress title
  ///
  /// In zh, this message translates to:
  /// **'学习进度'**
  String get learningProgress;

  /// Due for review count
  ///
  /// In zh, this message translates to:
  /// **'{count}个待复习'**
  String dueForReviewCount(int count);

  /// Completion label
  ///
  /// In zh, this message translates to:
  /// **'完成度'**
  String get completion;

  /// Total characters label
  ///
  /// In zh, this message translates to:
  /// **'总字母'**
  String get totalCharacters;

  /// Learned label
  ///
  /// In zh, this message translates to:
  /// **'已学习'**
  String get learned;

  /// Due for review label
  ///
  /// In zh, this message translates to:
  /// **'待复习'**
  String get dueForReview;

  /// Overall accuracy
  ///
  /// In zh, this message translates to:
  /// **'整体准确率: {percent}%'**
  String overallAccuracy(String percent);

  /// Characters count
  ///
  /// In zh, this message translates to:
  /// **'{count}个字母'**
  String charactersCount(int count);

  /// Lesson 1 title
  ///
  /// In zh, this message translates to:
  /// **'第1课：基本辅音 (上)'**
  String get lesson1Title;

  /// Lesson 1 description
  ///
  /// In zh, this message translates to:
  /// **'学习韩语最常用的7个辅音字母'**
  String get lesson1Desc;

  /// Lesson 2 title
  ///
  /// In zh, this message translates to:
  /// **'第2课：基本辅音 (下)'**
  String get lesson2Title;

  /// Lesson 2 description
  ///
  /// In zh, this message translates to:
  /// **'继续学习剩余的7个基本辅音'**
  String get lesson2Desc;

  /// Lesson 3 title
  ///
  /// In zh, this message translates to:
  /// **'第3课：基本元音 (上)'**
  String get lesson3Title;

  /// Lesson 3 description
  ///
  /// In zh, this message translates to:
  /// **'学习韩语的5个基本元音'**
  String get lesson3Desc;

  /// Lesson 4 title
  ///
  /// In zh, this message translates to:
  /// **'第4课：基本元音 (下)'**
  String get lesson4Title;

  /// Lesson 4 description
  ///
  /// In zh, this message translates to:
  /// **'学习剩余的5个基本元音'**
  String get lesson4Desc;

  /// Lesson 5 title
  ///
  /// In zh, this message translates to:
  /// **'第5课：双辅音'**
  String get lesson5Title;

  /// Lesson 5 description
  ///
  /// In zh, this message translates to:
  /// **'学习5个双辅音 - 紧音字母'**
  String get lesson5Desc;

  /// Lesson 6 title
  ///
  /// In zh, this message translates to:
  /// **'第6课：复合元音 (上)'**
  String get lesson6Title;

  /// Lesson 6 description
  ///
  /// In zh, this message translates to:
  /// **'学习前6个复合元音'**
  String get lesson6Desc;

  /// Lesson 7 title
  ///
  /// In zh, this message translates to:
  /// **'第7课：复合元音 (下)'**
  String get lesson7Title;

  /// Lesson 7 description
  ///
  /// In zh, this message translates to:
  /// **'学习剩余的复合元音'**
  String get lesson7Desc;

  /// Load alphabet first message
  ///
  /// In zh, this message translates to:
  /// **'请先加载字母表数据'**
  String get loadAlphabetFirst;

  /// No content for lesson
  ///
  /// In zh, this message translates to:
  /// **'本课无内容'**
  String get noContentForLesson;

  /// Example words label
  ///
  /// In zh, this message translates to:
  /// **'例词'**
  String get exampleWords;

  /// This lesson characters label
  ///
  /// In zh, this message translates to:
  /// **'本课字母'**
  String get thisLessonCharacters;

  /// Congratulations lesson complete
  ///
  /// In zh, this message translates to:
  /// **'恭喜你完成了 {title}！'**
  String congratsLessonComplete(String title);

  /// Continue practice button
  ///
  /// In zh, this message translates to:
  /// **'继续练习'**
  String get continuePractice;

  /// Next lesson button
  ///
  /// In zh, this message translates to:
  /// **'下一课'**
  String get nextLesson;

  /// Basic consonants
  ///
  /// In zh, this message translates to:
  /// **'基本辅音'**
  String get basicConsonants;

  /// Double consonants
  ///
  /// In zh, this message translates to:
  /// **'双辅音'**
  String get doubleConsonants;

  /// Basic vowels
  ///
  /// In zh, this message translates to:
  /// **'基本元音'**
  String get basicVowels;

  /// Compound vowels
  ///
  /// In zh, this message translates to:
  /// **'复合元音'**
  String get compoundVowels;

  /// Daily learning reminder notification title
  ///
  /// In zh, this message translates to:
  /// **'每日学习提醒'**
  String get dailyLearningReminderTitle;

  /// Daily learning reminder notification body
  ///
  /// In zh, this message translates to:
  /// **'今天的韩语学习还没完成哦~'**
  String get dailyLearningReminderBody;

  /// Review reminder notification title
  ///
  /// In zh, this message translates to:
  /// **'复习时间到了！'**
  String get reviewReminderTitle;

  /// Review reminder notification body
  ///
  /// In zh, this message translates to:
  /// **'该复习「{title}」了~'**
  String reviewReminderBody(String title);

  /// Korean language
  ///
  /// In zh, this message translates to:
  /// **'한국어'**
  String get korean;

  /// English language
  ///
  /// In zh, this message translates to:
  /// **'English'**
  String get english;

  /// Japanese language
  ///
  /// In zh, this message translates to:
  /// **'日本語'**
  String get japanese;

  /// Spanish language
  ///
  /// In zh, this message translates to:
  /// **'Español'**
  String get spanish;

  /// Stroke order
  ///
  /// In zh, this message translates to:
  /// **'笔画顺序'**
  String get strokeOrder;

  /// Reset button
  ///
  /// In zh, this message translates to:
  /// **'重置'**
  String get reset;

  /// Pronunciation guide
  ///
  /// In zh, this message translates to:
  /// **'发音指南'**
  String get pronunciationGuide;

  /// Play button
  ///
  /// In zh, this message translates to:
  /// **'播放'**
  String get play;

  /// Pause button
  ///
  /// In zh, this message translates to:
  /// **'暂停'**
  String get pause;

  /// Loading failed message
  ///
  /// In zh, this message translates to:
  /// **'加载失败: {error}'**
  String loadingFailed(String error);

  /// Learned count
  ///
  /// In zh, this message translates to:
  /// **'已学习：{count}'**
  String learnedCount(int count);

  /// Hangul practice title
  ///
  /// In zh, this message translates to:
  /// **'韩文字母练习'**
  String get hangulPractice;

  /// Characters need review
  ///
  /// In zh, this message translates to:
  /// **'{count}个字母需要复习'**
  String charactersNeedReview(int count);

  /// Characters available for practice
  ///
  /// In zh, this message translates to:
  /// **'{count}个字母可练习'**
  String charactersAvailable(int count);

  /// Select practice mode
  ///
  /// In zh, this message translates to:
  /// **'选择练习模式'**
  String get selectPracticeMode;

  /// Character recognition mode
  ///
  /// In zh, this message translates to:
  /// **'字母识别'**
  String get characterRecognition;

  /// Character recognition description
  ///
  /// In zh, this message translates to:
  /// **'看到字母选择正确的发音'**
  String get characterRecognitionDesc;

  /// Pronunciation practice mode
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get pronunciationPractice;

  /// Pronunciation practice description
  ///
  /// In zh, this message translates to:
  /// **'看到发音选择正确的字母'**
  String get pronunciationPracticeDesc;

  /// Start practice button
  ///
  /// In zh, this message translates to:
  /// **'开始练习'**
  String get startPractice;

  /// Learn some characters first message
  ///
  /// In zh, this message translates to:
  /// **'请先在字母表中学习一些字母'**
  String get learnSomeCharactersFirst;

  /// Practice complete title
  ///
  /// In zh, this message translates to:
  /// **'练习完成！'**
  String get practiceComplete;

  /// Back button
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get back;

  /// Try again button
  ///
  /// In zh, this message translates to:
  /// **'再来一次'**
  String get tryAgain;

  /// How to read this question
  ///
  /// In zh, this message translates to:
  /// **'这个字母怎么读？'**
  String get howToReadThis;

  /// Select correct character instruction
  ///
  /// In zh, this message translates to:
  /// **'选择正确的字母'**
  String get selectCorrectCharacter;

  /// Correct feedback
  ///
  /// In zh, this message translates to:
  /// **'正确！'**
  String get correctExclamation;

  /// Incorrect feedback
  ///
  /// In zh, this message translates to:
  /// **'错误'**
  String get incorrectExclamation;

  /// Correct answer label
  ///
  /// In zh, this message translates to:
  /// **'正确答案：'**
  String get correctAnswerLabel;

  /// Next question button
  ///
  /// In zh, this message translates to:
  /// **'下一题'**
  String get nextQuestionBtn;

  /// View results button
  ///
  /// In zh, this message translates to:
  /// **'查看结果'**
  String get viewResults;

  /// Share button
  ///
  /// In zh, this message translates to:
  /// **'分享'**
  String get share;

  /// Mnemonics section
  ///
  /// In zh, this message translates to:
  /// **'记忆技巧'**
  String get mnemonics;

  /// Next review label
  ///
  /// In zh, this message translates to:
  /// **'下次复习: {date}'**
  String nextReviewLabel(String date);

  /// Expired status
  ///
  /// In zh, this message translates to:
  /// **'已到期'**
  String get expired;

  /// Practice function developing message
  ///
  /// In zh, this message translates to:
  /// **'练习功能开发中'**
  String get practiceFunctionDeveloping;

  /// Romanization label
  ///
  /// In zh, this message translates to:
  /// **'罗马字：'**
  String get romanization;

  /// Pronunciation label
  ///
  /// In zh, this message translates to:
  /// **'发音：'**
  String get pronunciationLabel;

  /// Play pronunciation tooltip
  ///
  /// In zh, this message translates to:
  /// **'播放发音'**
  String get playPronunciation;

  /// Strokes count
  ///
  /// In zh, this message translates to:
  /// **'{count}画'**
  String strokesCount(int count);

  /// Perfect count label
  ///
  /// In zh, this message translates to:
  /// **'完美'**
  String get perfectCount;

  /// Load failed message
  ///
  /// In zh, this message translates to:
  /// **'加载失败'**
  String get loadFailed;

  /// Count unit
  ///
  /// In zh, this message translates to:
  /// **'{count}个'**
  String countUnit(int count);

  /// Basic consonants in Korean
  ///
  /// In zh, this message translates to:
  /// **'기본 자음'**
  String get basicConsonantsKo;

  /// Double consonants in Korean
  ///
  /// In zh, this message translates to:
  /// **'쌍자음'**
  String get doubleConsonantsKo;

  /// Basic vowels in Korean
  ///
  /// In zh, this message translates to:
  /// **'기본 모음'**
  String get basicVowelsKo;

  /// Compound vowels in Korean
  ///
  /// In zh, this message translates to:
  /// **'복합 모음'**
  String get compoundVowelsKo;

  /// Lesson 1 Korean title
  ///
  /// In zh, this message translates to:
  /// **'1과: 기본 자음 (상)'**
  String get lesson1TitleKo;

  /// Lesson 2 Korean title
  ///
  /// In zh, this message translates to:
  /// **'2과: 기본 자음 (하)'**
  String get lesson2TitleKo;

  /// Lesson 3 Korean title
  ///
  /// In zh, this message translates to:
  /// **'3과: 기본 모음 (상)'**
  String get lesson3TitleKo;

  /// Lesson 4 Korean title
  ///
  /// In zh, this message translates to:
  /// **'4과: 기본 모음 (하)'**
  String get lesson4TitleKo;

  /// Lesson 5 Korean title
  ///
  /// In zh, this message translates to:
  /// **'5과: 쌍자음'**
  String get lesson5TitleKo;

  /// Lesson 6 Korean title
  ///
  /// In zh, this message translates to:
  /// **'6과: 복합 모음 (상)'**
  String get lesson6TitleKo;

  /// Lesson 7 Korean title
  ///
  /// In zh, this message translates to:
  /// **'7과: 복합 모음 (하)'**
  String get lesson7TitleKo;

  /// Exit lesson dialog title
  ///
  /// In zh, this message translates to:
  /// **'退出学习'**
  String get exitLesson;

  /// Exit lesson confirmation message
  ///
  /// In zh, this message translates to:
  /// **'确定要退出当前课程吗？进度将会保存。'**
  String get exitLessonConfirm;

  /// Exit button
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get exitBtn;

  /// Lesson completion message
  ///
  /// In zh, this message translates to:
  /// **'课程完成！进度已保存'**
  String get lessonComplete;

  /// Loading lesson message
  ///
  /// In zh, this message translates to:
  /// **'正在加载{title}...'**
  String loadingLesson(String title);

  /// Cannot load lesson content error
  ///
  /// In zh, this message translates to:
  /// **'无法加载课程内容'**
  String get cannotLoadContent;

  /// No lesson content message
  ///
  /// In zh, this message translates to:
  /// **'此课程暂无内容'**
  String get noLessonContent;

  /// Stage progress indicator
  ///
  /// In zh, this message translates to:
  /// **'第 {current} 阶段 / {total}'**
  String stageProgress(int current, int total);

  /// Unknown stage type error
  ///
  /// In zh, this message translates to:
  /// **'未知阶段类型: {type}'**
  String unknownStageType(String type);

  /// Words count display
  ///
  /// In zh, this message translates to:
  /// **'{count} 个单词'**
  String wordsCount(int count);

  /// Start learning button
  ///
  /// In zh, this message translates to:
  /// **'开始学习'**
  String get startLearning;

  /// Vocabulary learning section title
  ///
  /// In zh, this message translates to:
  /// **'词汇学习'**
  String get vocabularyLearning;

  /// No image placeholder
  ///
  /// In zh, this message translates to:
  /// **'暂无图片'**
  String get noImage;

  /// Previous item button
  ///
  /// In zh, this message translates to:
  /// **'上一个'**
  String get previousItem;

  /// Next item button
  ///
  /// In zh, this message translates to:
  /// **'下一个'**
  String get nextItem;

  /// Continue button
  ///
  /// In zh, this message translates to:
  /// **'继续'**
  String get continueBtn;

  /// Previous question button
  ///
  /// In zh, this message translates to:
  /// **'上一题'**
  String get previousQuestion;

  /// Playing audio status
  ///
  /// In zh, this message translates to:
  /// **'播放中...'**
  String get playingAudio;

  /// Play all button
  ///
  /// In zh, this message translates to:
  /// **'播放全部'**
  String get playAll;

  /// Audio playback failed
  ///
  /// In zh, this message translates to:
  /// **'音频播放失败: {error}'**
  String audioPlayFailed(String error);

  /// Stop button
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get stopBtn;

  /// Play audio button
  ///
  /// In zh, this message translates to:
  /// **'播放音频'**
  String get playAudioBtn;

  /// Playing audio short message
  ///
  /// In zh, this message translates to:
  /// **'播放音频...'**
  String get playingAudioShort;

  /// Pronunciation label
  ///
  /// In zh, this message translates to:
  /// **'发音'**
  String get pronunciation;

  /// Grammar pattern title
  ///
  /// In zh, this message translates to:
  /// **'语法 · {pattern}'**
  String grammarPattern(String pattern);

  /// Grammar explanation section
  ///
  /// In zh, this message translates to:
  /// **'语法解释'**
  String get grammarExplanation;

  /// Conjugation rule section
  ///
  /// In zh, this message translates to:
  /// **'活用规则'**
  String get conjugationRule;

  /// Comparison with Chinese section
  ///
  /// In zh, this message translates to:
  /// **'与中文对比'**
  String get comparisonWithChinese;

  /// Example sentences section
  ///
  /// In zh, this message translates to:
  /// **'例句'**
  String get exampleSentences;

  /// Dialogue practice title
  ///
  /// In zh, this message translates to:
  /// **'对话练习'**
  String get dialogueTitle;

  /// Dialogue explanation section
  ///
  /// In zh, this message translates to:
  /// **'对话解析'**
  String get dialogueExplanation;

  /// Speaker label
  ///
  /// In zh, this message translates to:
  /// **'发言人 {name}'**
  String speaker(String name);

  /// Practice section title
  ///
  /// In zh, this message translates to:
  /// **'练习'**
  String get practiceTitle;

  /// Practice instructions
  ///
  /// In zh, this message translates to:
  /// **'请完成以下练习题'**
  String get practiceInstructions;

  /// Fill in the blank
  ///
  /// In zh, this message translates to:
  /// **'填空'**
  String get fillBlank;

  /// Check answer button
  ///
  /// In zh, this message translates to:
  /// **'检查答案'**
  String get checkAnswerBtn;

  /// Correct answer display
  ///
  /// In zh, this message translates to:
  /// **'正确答案：{answer}'**
  String correctAnswerIs(String answer);

  /// Quiz section title
  ///
  /// In zh, this message translates to:
  /// **'测验'**
  String get quizTitle;

  /// Quiz result title
  ///
  /// In zh, this message translates to:
  /// **'测验结果'**
  String get quizResult;

  /// Quiz score display
  ///
  /// In zh, this message translates to:
  /// **'{correct}/{total}'**
  String quizScoreDisplay(int correct, int total);

  /// Quiz accuracy percentage
  ///
  /// In zh, this message translates to:
  /// **'准确率: {percent}%'**
  String quizAccuracy(int percent);

  /// Lesson summary title
  ///
  /// In zh, this message translates to:
  /// **'课程总结'**
  String get summaryTitle;

  /// Vocabulary learned label
  ///
  /// In zh, this message translates to:
  /// **'已学单词'**
  String get vocabLearned;

  /// Grammar learned label
  ///
  /// In zh, this message translates to:
  /// **'已学语法'**
  String get grammarLearned;

  /// Finish lesson button
  ///
  /// In zh, this message translates to:
  /// **'完成课程'**
  String get finishLesson;

  /// Review vocabulary button
  ///
  /// In zh, this message translates to:
  /// **'复习单词'**
  String get reviewVocab;

  /// Similarity percentage
  ///
  /// In zh, this message translates to:
  /// **'相似度: {percent}%'**
  String similarity(int percent);

  /// Part of speech: noun
  ///
  /// In zh, this message translates to:
  /// **'名词'**
  String get partOfSpeechNoun;

  /// Part of speech: verb
  ///
  /// In zh, this message translates to:
  /// **'动词'**
  String get partOfSpeechVerb;

  /// Part of speech: adjective
  ///
  /// In zh, this message translates to:
  /// **'形容词'**
  String get partOfSpeechAdjective;

  /// Part of speech: adverb
  ///
  /// In zh, this message translates to:
  /// **'副词'**
  String get partOfSpeechAdverb;

  /// Part of speech: pronoun
  ///
  /// In zh, this message translates to:
  /// **'代词'**
  String get partOfSpeechPronoun;

  /// Part of speech: particle
  ///
  /// In zh, this message translates to:
  /// **'助词'**
  String get partOfSpeechParticle;

  /// Part of speech: conjunction
  ///
  /// In zh, this message translates to:
  /// **'连词'**
  String get partOfSpeechConjunction;

  /// Part of speech: interjection
  ///
  /// In zh, this message translates to:
  /// **'感叹词'**
  String get partOfSpeechInterjection;

  /// No vocabulary data
  ///
  /// In zh, this message translates to:
  /// **'暂无单词数据'**
  String get noVocabulary;

  /// No grammar data
  ///
  /// In zh, this message translates to:
  /// **'暂无语法数据'**
  String get noGrammar;

  /// No practice questions
  ///
  /// In zh, this message translates to:
  /// **'暂无练习题'**
  String get noPractice;

  /// No dialogue content
  ///
  /// In zh, this message translates to:
  /// **'暂无对话内容'**
  String get noDialogue;

  /// No quiz questions
  ///
  /// In zh, this message translates to:
  /// **'暂无测验题目'**
  String get noQuiz;

  /// Tap to flip card hint
  ///
  /// In zh, this message translates to:
  /// **'点击翻转'**
  String get tapToFlip;

  /// Listening question type
  ///
  /// In zh, this message translates to:
  /// **'听力'**
  String get listeningQuestion;

  /// Submit button
  ///
  /// In zh, this message translates to:
  /// **'提交'**
  String get submit;

  /// Time studied display
  ///
  /// In zh, this message translates to:
  /// **'已学习 {time}'**
  String timeStudied(String time);

  /// Progress status: not started
  ///
  /// In zh, this message translates to:
  /// **'未开始'**
  String get statusNotStarted;

  /// Progress status: in progress
  ///
  /// In zh, this message translates to:
  /// **'进行中'**
  String get statusInProgress;

  /// Progress status: completed
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get statusCompleted;

  /// Progress status: failed
  ///
  /// In zh, this message translates to:
  /// **'未通过'**
  String get statusFailed;

  /// Mastery level: new
  ///
  /// In zh, this message translates to:
  /// **'新'**
  String get masteryNew;

  /// Mastery level: learning
  ///
  /// In zh, this message translates to:
  /// **'学习中'**
  String get masteryLearning;

  /// Mastery level: familiar
  ///
  /// In zh, this message translates to:
  /// **'熟悉'**
  String get masteryFamiliar;

  /// Mastery level: mastered
  ///
  /// In zh, this message translates to:
  /// **'掌握'**
  String get masteryMastered;

  /// Mastery level: expert
  ///
  /// In zh, this message translates to:
  /// **'精通'**
  String get masteryExpert;

  /// Mastery level: perfect
  ///
  /// In zh, this message translates to:
  /// **'完美'**
  String get masteryPerfect;

  /// Mastery level: unknown
  ///
  /// In zh, this message translates to:
  /// **'未知'**
  String get masteryUnknown;

  /// Due for review now
  ///
  /// In zh, this message translates to:
  /// **'该复习了'**
  String get dueForReviewNow;

  /// High similarity
  ///
  /// In zh, this message translates to:
  /// **'高相似度'**
  String get similarityHigh;

  /// Medium similarity
  ///
  /// In zh, this message translates to:
  /// **'中等相似度'**
  String get similarityMedium;

  /// Low similarity
  ///
  /// In zh, this message translates to:
  /// **'低相似度'**
  String get similarityLow;

  /// Hangul type: basic consonant
  ///
  /// In zh, this message translates to:
  /// **'基本辅音'**
  String get typeBasicConsonant;

  /// Hangul type: double consonant
  ///
  /// In zh, this message translates to:
  /// **'双辅音'**
  String get typeDoubleConsonant;

  /// Hangul type: basic vowel
  ///
  /// In zh, this message translates to:
  /// **'基本元音'**
  String get typeBasicVowel;

  /// Hangul type: compound vowel
  ///
  /// In zh, this message translates to:
  /// **'复合元音'**
  String get typeCompoundVowel;

  /// Hangul type: final consonant
  ///
  /// In zh, this message translates to:
  /// **'收音'**
  String get typeFinalConsonant;

  /// Daily reminder notification channel name
  ///
  /// In zh, this message translates to:
  /// **'每日学习提醒'**
  String get dailyReminderChannel;

  /// Daily reminder channel description
  ///
  /// In zh, this message translates to:
  /// **'每天固定时间提醒你学习韩语'**
  String get dailyReminderChannelDesc;

  /// Review reminder notification channel name
  ///
  /// In zh, this message translates to:
  /// **'复习提醒'**
  String get reviewReminderChannel;

  /// Review reminder channel description
  ///
  /// In zh, this message translates to:
  /// **'基于间隔重复算法的复习提醒'**
  String get reviewReminderChannelDesc;

  /// Notification title for study time
  ///
  /// In zh, this message translates to:
  /// **'学习时间到了！'**
  String get notificationStudyTime;

  /// Notification body for study reminder
  ///
  /// In zh, this message translates to:
  /// **'今天的韩语学习还没完成哦~'**
  String get notificationStudyReminder;

  /// Notification title for review time
  ///
  /// In zh, this message translates to:
  /// **'该复习了！'**
  String get notificationReviewTime;

  /// Notification body for review reminder
  ///
  /// In zh, this message translates to:
  /// **'复习一下之前学过的内容吧~'**
  String get notificationReviewReminder;

  /// Notification body for review reminder with lesson title
  ///
  /// In zh, this message translates to:
  /// **'该复习「{lessonTitle}」了~'**
  String notificationReviewLesson(String lessonTitle);

  /// Encouraging message when quiz is not passed
  ///
  /// In zh, this message translates to:
  /// **'继续加油！'**
  String get keepGoing;

  /// Quiz score display
  ///
  /// In zh, this message translates to:
  /// **'得分：{correct} / {total}'**
  String scoreDisplay(int correct, int total);

  /// Error loading data
  ///
  /// In zh, this message translates to:
  /// **'加载数据失败: {error}'**
  String loadDataError(String error);

  /// Download error message
  ///
  /// In zh, this message translates to:
  /// **'下载错误: {error}'**
  String downloadError(String error);

  /// Delete error message
  ///
  /// In zh, this message translates to:
  /// **'删除失败: {error}'**
  String deleteError(String error);

  /// Clear all error message
  ///
  /// In zh, this message translates to:
  /// **'清空失败: {error}'**
  String clearAllError(String error);

  /// Cleanup error message
  ///
  /// In zh, this message translates to:
  /// **'清理失败: {error}'**
  String cleanupError(String error);

  /// Download lesson failed message
  ///
  /// In zh, this message translates to:
  /// **'下载失败: {title}'**
  String downloadLessonFailed(String title);

  /// Comprehensive quiz type
  ///
  /// In zh, this message translates to:
  /// **'综合'**
  String get comprehensive;

  /// Answered count display
  ///
  /// In zh, this message translates to:
  /// **'已答 {answered}/{total}'**
  String answeredCount(int answered, int total);

  /// Hanja (Chinese-origin) word label
  ///
  /// In zh, this message translates to:
  /// **'汉字词'**
  String get hanjaWord;

  /// Tap to flip card back
  ///
  /// In zh, this message translates to:
  /// **'点击返回'**
  String get tapToFlipBack;

  /// Similarity with Chinese label
  ///
  /// In zh, this message translates to:
  /// **'与中文相似度'**
  String get similarityWithChinese;

  /// Hanja word with similar pronunciation hint
  ///
  /// In zh, this message translates to:
  /// **'汉字词，发音相似'**
  String get hanjaWordSimilarPronunciation;

  /// Same etymology easy to remember hint
  ///
  /// In zh, this message translates to:
  /// **'词源相同，便于记忆'**
  String get sameEtymologyEasyToRemember;

  /// Some connection hint
  ///
  /// In zh, this message translates to:
  /// **'有一定联系'**
  String get someConnection;

  /// Native Korean word needs memorization hint
  ///
  /// In zh, this message translates to:
  /// **'固有词，需要记忆'**
  String get nativeWordNeedsMemorization;

  /// Rules label
  ///
  /// In zh, this message translates to:
  /// **'规则'**
  String get rules;

  /// Korean language label with flag
  ///
  /// In zh, this message translates to:
  /// **'🇰🇷 韩语'**
  String get koreanLanguage;

  /// Chinese language label with flag
  ///
  /// In zh, this message translates to:
  /// **'🇨🇳 中文'**
  String get chineseLanguage;

  /// Example number label
  ///
  /// In zh, this message translates to:
  /// **'例 {number}'**
  String exampleNumber(int number);

  /// Fill in blank prompt
  ///
  /// In zh, this message translates to:
  /// **'填空：'**
  String get fillInBlankPrompt;

  /// Correct answer feedback
  ///
  /// In zh, this message translates to:
  /// **'太棒了！答对了！'**
  String get correctFeedback;

  /// Incorrect answer feedback
  ///
  /// In zh, this message translates to:
  /// **'不对哦，再想想看'**
  String get incorrectFeedback;

  /// All stages passed message
  ///
  /// In zh, this message translates to:
  /// **'7个阶段全部通过'**
  String get allStagesPassed;

  /// Continue to learn more content
  ///
  /// In zh, this message translates to:
  /// **'继续学习更多内容'**
  String get continueToLearnMore;

  /// Time format with hours, minutes, seconds
  ///
  /// In zh, this message translates to:
  /// **'{hours}时{minutes}分{seconds}秒'**
  String timeFormatHMS(int hours, int minutes, int seconds);

  /// Time format with minutes and seconds
  ///
  /// In zh, this message translates to:
  /// **'{minutes}分{seconds}秒'**
  String timeFormatMS(int minutes, int seconds);

  /// Time format with seconds only
  ///
  /// In zh, this message translates to:
  /// **'{seconds}秒'**
  String timeFormatS(int seconds);

  /// Repeat enabled message
  ///
  /// In zh, this message translates to:
  /// **'已开启重复'**
  String get repeatEnabled;

  /// Repeat disabled message
  ///
  /// In zh, this message translates to:
  /// **'已关闭重复'**
  String get repeatDisabled;

  /// Stop button
  ///
  /// In zh, this message translates to:
  /// **'停止'**
  String get stop;

  /// Playback speed label
  ///
  /// In zh, this message translates to:
  /// **'播放速度'**
  String get playbackSpeed;

  /// Slow speed option
  ///
  /// In zh, this message translates to:
  /// **'慢速'**
  String get slowSpeed;

  /// Normal speed option
  ///
  /// In zh, this message translates to:
  /// **'正常'**
  String get normalSpeed;

  /// Mouth shape label
  ///
  /// In zh, this message translates to:
  /// **'口型'**
  String get mouthShape;

  /// Tongue position label
  ///
  /// In zh, this message translates to:
  /// **'舌位'**
  String get tonguePosition;

  /// Air flow label
  ///
  /// In zh, this message translates to:
  /// **'气流'**
  String get airFlow;

  /// Native language comparison label
  ///
  /// In zh, this message translates to:
  /// **'母语对比'**
  String get nativeComparison;

  /// Similar sounds label
  ///
  /// In zh, this message translates to:
  /// **'相似音'**
  String get similarSounds;

  /// Sound discrimination practice
  ///
  /// In zh, this message translates to:
  /// **'辨音练习'**
  String get soundDiscrimination;

  /// Listen and select instruction
  ///
  /// In zh, this message translates to:
  /// **'听音选择正确的字母'**
  String get listenAndSelect;

  /// Similar sound groups
  ///
  /// In zh, this message translates to:
  /// **'相似音组'**
  String get similarSoundGroups;

  /// Plain sound
  ///
  /// In zh, this message translates to:
  /// **'平音'**
  String get plainSound;

  /// Aspirated sound
  ///
  /// In zh, this message translates to:
  /// **'送气音'**
  String get aspiratedSound;

  /// Tense sound
  ///
  /// In zh, this message translates to:
  /// **'紧音'**
  String get tenseSound;

  /// Writing practice
  ///
  /// In zh, this message translates to:
  /// **'书写练习'**
  String get writingPractice;

  /// Watch animation step
  ///
  /// In zh, this message translates to:
  /// **'观看动画'**
  String get watchAnimation;

  /// Trace with guide step
  ///
  /// In zh, this message translates to:
  /// **'描摹练习'**
  String get traceWithGuide;

  /// Freehand writing step
  ///
  /// In zh, this message translates to:
  /// **'自由书写'**
  String get freehandWriting;

  /// Clear canvas button
  ///
  /// In zh, this message translates to:
  /// **'清除'**
  String get clearCanvas;

  /// Show guide button
  ///
  /// In zh, this message translates to:
  /// **'显示引导'**
  String get showGuide;

  /// Hide guide button
  ///
  /// In zh, this message translates to:
  /// **'隐藏引导'**
  String get hideGuide;

  /// Writing accuracy label
  ///
  /// In zh, this message translates to:
  /// **'准确度'**
  String get writingAccuracy;

  /// Try again writing button
  ///
  /// In zh, this message translates to:
  /// **'再试一次'**
  String get tryAgainWriting;

  /// Next step button
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get nextStep;

  /// Stroke order step indicator
  ///
  /// In zh, this message translates to:
  /// **'第 {current}/{total} 步'**
  String strokeOrderStep(int current, int total);

  /// Syllable combination
  ///
  /// In zh, this message translates to:
  /// **'音节组合'**
  String get syllableCombination;

  /// Select consonant instruction
  ///
  /// In zh, this message translates to:
  /// **'选择辅音'**
  String get selectConsonant;

  /// Select vowel instruction
  ///
  /// In zh, this message translates to:
  /// **'选择元音'**
  String get selectVowel;

  /// Select final consonant instruction
  ///
  /// In zh, this message translates to:
  /// **'选择收音（可选）'**
  String get selectFinalConsonant;

  /// No final consonant option
  ///
  /// In zh, this message translates to:
  /// **'无收音'**
  String get noFinalConsonant;

  /// Combined syllable label
  ///
  /// In zh, this message translates to:
  /// **'组合音节'**
  String get combinedSyllable;

  /// Play syllable button
  ///
  /// In zh, this message translates to:
  /// **'播放音节'**
  String get playSyllable;

  /// Decompose syllable button
  ///
  /// In zh, this message translates to:
  /// **'分解音节'**
  String get decomposeSyllable;

  /// Batchim practice
  ///
  /// In zh, this message translates to:
  /// **'收音练习'**
  String get batchimPractice;

  /// Batchim explanation
  ///
  /// In zh, this message translates to:
  /// **'收音说明'**
  String get batchimExplanation;

  /// Record pronunciation
  ///
  /// In zh, this message translates to:
  /// **'录音练习'**
  String get recordPronunciation;

  /// Start recording button
  ///
  /// In zh, this message translates to:
  /// **'开始录音'**
  String get startRecording;

  /// Stop recording button
  ///
  /// In zh, this message translates to:
  /// **'停止录音'**
  String get stopRecording;

  /// Play recording button
  ///
  /// In zh, this message translates to:
  /// **'播放录音'**
  String get playRecording;

  /// Compare with native button
  ///
  /// In zh, this message translates to:
  /// **'与原音对比'**
  String get compareWithNative;

  /// Shadowing mode
  ///
  /// In zh, this message translates to:
  /// **'跟读模式'**
  String get shadowingMode;

  /// Listen then repeat instruction
  ///
  /// In zh, this message translates to:
  /// **'先听后说'**
  String get listenThenRepeat;

  /// Self evaluation
  ///
  /// In zh, this message translates to:
  /// **'自我评价'**
  String get selfEvaluation;

  /// Accurate evaluation
  ///
  /// In zh, this message translates to:
  /// **'准确'**
  String get accurate;

  /// Almost correct evaluation
  ///
  /// In zh, this message translates to:
  /// **'接近'**
  String get almostCorrect;

  /// Needs practice evaluation
  ///
  /// In zh, this message translates to:
  /// **'需要练习'**
  String get needsPractice;

  /// Recording not supported message
  ///
  /// In zh, this message translates to:
  /// **'此平台不支持录音功能'**
  String get recordingNotSupported;

  /// Show meaning toggle
  ///
  /// In zh, this message translates to:
  /// **'显示释义'**
  String get showMeaning;

  /// Hide meaning toggle
  ///
  /// In zh, this message translates to:
  /// **'隐藏释义'**
  String get hideMeaning;

  /// Example word label
  ///
  /// In zh, this message translates to:
  /// **'示例单词'**
  String get exampleWord;

  /// Meaning toggle setting
  ///
  /// In zh, this message translates to:
  /// **'释义显示设置'**
  String get meaningToggle;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In zh, this message translates to:
  /// **'录音需要麦克风权限'**
  String get microphonePermissionRequired;

  /// No description provided for @activities.
  ///
  /// In zh, this message translates to:
  /// **'活动'**
  String get activities;

  /// No description provided for @listeningAndSpeaking.
  ///
  /// In zh, this message translates to:
  /// **'听力 & 口语'**
  String get listeningAndSpeaking;

  /// No description provided for @readingAndWriting.
  ///
  /// In zh, this message translates to:
  /// **'阅读 & 写作'**
  String get readingAndWriting;

  /// No description provided for @soundDiscriminationDesc.
  ///
  /// In zh, this message translates to:
  /// **'训练耳朵区分相似的声音'**
  String get soundDiscriminationDesc;

  /// No description provided for @shadowingDesc.
  ///
  /// In zh, this message translates to:
  /// **'跟读原生发音'**
  String get shadowingDesc;

  /// No description provided for @syllableCombinationDesc.
  ///
  /// In zh, this message translates to:
  /// **'学习辅音和元音如何组合'**
  String get syllableCombinationDesc;

  /// No description provided for @batchimPracticeDesc.
  ///
  /// In zh, this message translates to:
  /// **'练习收音发音'**
  String get batchimPracticeDesc;

  /// No description provided for @writingPracticeDesc.
  ///
  /// In zh, this message translates to:
  /// **'练习书写韩文字母'**
  String get writingPracticeDesc;

  /// No description provided for @webNotSupported.
  ///
  /// In zh, this message translates to:
  /// **'网页版不支持'**
  String get webNotSupported;

  /// No description provided for @chapter.
  ///
  /// In zh, this message translates to:
  /// **'章节'**
  String get chapter;

  /// No description provided for @bossQuiz.
  ///
  /// In zh, this message translates to:
  /// **'Boss测验'**
  String get bossQuiz;

  /// No description provided for @bossQuizCleared.
  ///
  /// In zh, this message translates to:
  /// **'Boss测验通过！'**
  String get bossQuizCleared;

  /// No description provided for @bossQuizBonus.
  ///
  /// In zh, this message translates to:
  /// **'奖励柠檬'**
  String get bossQuizBonus;

  /// No description provided for @lemonsScoreHint95.
  ///
  /// In zh, this message translates to:
  /// **'95%以上获得3个柠檬'**
  String get lemonsScoreHint95;

  /// No description provided for @lemonsScoreHint80.
  ///
  /// In zh, this message translates to:
  /// **'80%以上获得2个柠檬'**
  String get lemonsScoreHint80;

  /// No description provided for @myLemonTree.
  ///
  /// In zh, this message translates to:
  /// **'我的柠檬树'**
  String get myLemonTree;

  /// No description provided for @harvestLemon.
  ///
  /// In zh, this message translates to:
  /// **'收获柠檬'**
  String get harvestLemon;

  /// No description provided for @watchAdToHarvest.
  ///
  /// In zh, this message translates to:
  /// **'观看广告来收获这个柠檬？'**
  String get watchAdToHarvest;

  /// No description provided for @lemonHarvested.
  ///
  /// In zh, this message translates to:
  /// **'柠檬已收获！'**
  String get lemonHarvested;

  /// No description provided for @lemonsAvailable.
  ///
  /// In zh, this message translates to:
  /// **'个柠檬可收获'**
  String get lemonsAvailable;

  /// No description provided for @completeMoreLessons.
  ///
  /// In zh, this message translates to:
  /// **'完成更多课程来种植柠檬'**
  String get completeMoreLessons;

  /// No description provided for @totalLemons.
  ///
  /// In zh, this message translates to:
  /// **'柠檬总数'**
  String get totalLemons;

  /// No description provided for @community.
  ///
  /// In zh, this message translates to:
  /// **'社区'**
  String get community;

  /// No description provided for @following.
  ///
  /// In zh, this message translates to:
  /// **'关注'**
  String get following;

  /// No description provided for @discover.
  ///
  /// In zh, this message translates to:
  /// **'发现'**
  String get discover;

  /// No description provided for @createPost.
  ///
  /// In zh, this message translates to:
  /// **'发帖'**
  String get createPost;

  /// No description provided for @writePost.
  ///
  /// In zh, this message translates to:
  /// **'分享你的想法...'**
  String get writePost;

  /// No description provided for @postCategory.
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get postCategory;

  /// No description provided for @categoryLearning.
  ///
  /// In zh, this message translates to:
  /// **'学习'**
  String get categoryLearning;

  /// No description provided for @categoryGeneral.
  ///
  /// In zh, this message translates to:
  /// **'日常'**
  String get categoryGeneral;

  /// No description provided for @categoryAll.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get categoryAll;

  /// No description provided for @post.
  ///
  /// In zh, this message translates to:
  /// **'发布'**
  String get post;

  /// No description provided for @like.
  ///
  /// In zh, this message translates to:
  /// **'点赞'**
  String get like;

  /// No description provided for @comment.
  ///
  /// In zh, this message translates to:
  /// **'评论'**
  String get comment;

  /// No description provided for @writeComment.
  ///
  /// In zh, this message translates to:
  /// **'写评论...'**
  String get writeComment;

  /// No description provided for @replyingTo.
  ///
  /// In zh, this message translates to:
  /// **'回复 {name}'**
  String replyingTo(String name);

  /// No description provided for @reply.
  ///
  /// In zh, this message translates to:
  /// **'回复'**
  String get reply;

  /// No description provided for @deletePost.
  ///
  /// In zh, this message translates to:
  /// **'删除帖子'**
  String get deletePost;

  /// No description provided for @deletePostConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条帖子吗？'**
  String get deletePostConfirm;

  /// No description provided for @deleteComment.
  ///
  /// In zh, this message translates to:
  /// **'删除评论'**
  String get deleteComment;

  /// No description provided for @postDeleted.
  ///
  /// In zh, this message translates to:
  /// **'帖子已删除'**
  String get postDeleted;

  /// No description provided for @commentDeleted.
  ///
  /// In zh, this message translates to:
  /// **'评论已删除'**
  String get commentDeleted;

  /// No description provided for @noPostsYet.
  ///
  /// In zh, this message translates to:
  /// **'还没有帖子'**
  String get noPostsYet;

  /// No description provided for @followToSeePosts.
  ///
  /// In zh, this message translates to:
  /// **'关注用户后可以在这里看到他们的帖子'**
  String get followToSeePosts;

  /// No description provided for @discoverPosts.
  ///
  /// In zh, this message translates to:
  /// **'发现社区中的精彩帖子'**
  String get discoverPosts;

  /// No description provided for @seeMore.
  ///
  /// In zh, this message translates to:
  /// **'查看更多'**
  String get seeMore;

  /// No description provided for @followers.
  ///
  /// In zh, this message translates to:
  /// **'粉丝'**
  String get followers;

  /// No description provided for @followingLabel.
  ///
  /// In zh, this message translates to:
  /// **'关注'**
  String get followingLabel;

  /// No description provided for @posts.
  ///
  /// In zh, this message translates to:
  /// **'帖子'**
  String get posts;

  /// No description provided for @follow.
  ///
  /// In zh, this message translates to:
  /// **'关注'**
  String get follow;

  /// No description provided for @unfollow.
  ///
  /// In zh, this message translates to:
  /// **'取消关注'**
  String get unfollow;

  /// No description provided for @editProfile.
  ///
  /// In zh, this message translates to:
  /// **'编辑资料'**
  String get editProfile;

  /// No description provided for @bio.
  ///
  /// In zh, this message translates to:
  /// **'个人简介'**
  String get bio;

  /// No description provided for @bioHint.
  ///
  /// In zh, this message translates to:
  /// **'介绍一下自己...'**
  String get bioHint;

  /// No description provided for @searchUsers.
  ///
  /// In zh, this message translates to:
  /// **'搜索用户...'**
  String get searchUsers;

  /// No description provided for @suggestedUsers.
  ///
  /// In zh, this message translates to:
  /// **'推荐用户'**
  String get suggestedUsers;

  /// No description provided for @noUsersFound.
  ///
  /// In zh, this message translates to:
  /// **'未找到用户'**
  String get noUsersFound;

  /// No description provided for @report.
  ///
  /// In zh, this message translates to:
  /// **'举报'**
  String get report;

  /// No description provided for @reportContent.
  ///
  /// In zh, this message translates to:
  /// **'举报内容'**
  String get reportContent;

  /// No description provided for @reportReason.
  ///
  /// In zh, this message translates to:
  /// **'请输入举报原因'**
  String get reportReason;

  /// No description provided for @reportSubmitted.
  ///
  /// In zh, this message translates to:
  /// **'举报已提交'**
  String get reportSubmitted;

  /// No description provided for @blockUser.
  ///
  /// In zh, this message translates to:
  /// **'屏蔽用户'**
  String get blockUser;

  /// No description provided for @unblockUser.
  ///
  /// In zh, this message translates to:
  /// **'取消屏蔽'**
  String get unblockUser;

  /// No description provided for @userBlocked.
  ///
  /// In zh, this message translates to:
  /// **'已屏蔽该用户'**
  String get userBlocked;

  /// No description provided for @userUnblocked.
  ///
  /// In zh, this message translates to:
  /// **'已取消屏蔽'**
  String get userUnblocked;

  /// No description provided for @postCreated.
  ///
  /// In zh, this message translates to:
  /// **'发布成功！'**
  String get postCreated;

  /// Number of likes
  ///
  /// In zh, this message translates to:
  /// **'{count}个赞'**
  String likesCount(int count);

  /// Number of comments
  ///
  /// In zh, this message translates to:
  /// **'{count}条评论'**
  String commentsCount(int count);

  /// Number of followers
  ///
  /// In zh, this message translates to:
  /// **'{count}位粉丝'**
  String followersCount(int count);

  /// No description provided for @followingCount.
  ///
  /// In zh, this message translates to:
  /// **'关注{count}人'**
  String followingCount(int count);

  /// No description provided for @findFriends.
  ///
  /// In zh, this message translates to:
  /// **'找朋友'**
  String get findFriends;

  /// No description provided for @addPhotos.
  ///
  /// In zh, this message translates to:
  /// **'添加照片'**
  String get addPhotos;

  /// Maximum photos allowed
  ///
  /// In zh, this message translates to:
  /// **'最多{count}张照片'**
  String maxPhotos(int count);

  /// No description provided for @visibility.
  ///
  /// In zh, this message translates to:
  /// **'可见范围'**
  String get visibility;

  /// No description provided for @visibilityPublic.
  ///
  /// In zh, this message translates to:
  /// **'公开'**
  String get visibilityPublic;

  /// No description provided for @visibilityFollowers.
  ///
  /// In zh, this message translates to:
  /// **'仅粉丝可见'**
  String get visibilityFollowers;

  /// No description provided for @noFollowingPosts.
  ///
  /// In zh, this message translates to:
  /// **'关注的用户还没有发帖'**
  String get noFollowingPosts;

  /// No description provided for @all.
  ///
  /// In zh, this message translates to:
  /// **'全部'**
  String get all;

  /// No description provided for @learning.
  ///
  /// In zh, this message translates to:
  /// **'学习'**
  String get learning;

  /// No description provided for @general.
  ///
  /// In zh, this message translates to:
  /// **'日常'**
  String get general;

  /// No description provided for @linkCopied.
  ///
  /// In zh, this message translates to:
  /// **'链接已复制'**
  String get linkCopied;

  /// No description provided for @postFailed.
  ///
  /// In zh, this message translates to:
  /// **'发布失败'**
  String get postFailed;

  /// No description provided for @newPost.
  ///
  /// In zh, this message translates to:
  /// **'新帖子'**
  String get newPost;

  /// No description provided for @category.
  ///
  /// In zh, this message translates to:
  /// **'分类'**
  String get category;

  /// No description provided for @writeYourThoughts.
  ///
  /// In zh, this message translates to:
  /// **'分享你的想法...'**
  String get writeYourThoughts;

  /// No description provided for @photos.
  ///
  /// In zh, this message translates to:
  /// **'照片'**
  String get photos;

  /// No description provided for @addPhoto.
  ///
  /// In zh, this message translates to:
  /// **'添加照片'**
  String get addPhoto;

  /// No description provided for @imageUrlHint.
  ///
  /// In zh, this message translates to:
  /// **'输入图片链接'**
  String get imageUrlHint;

  /// No description provided for @noSuggestions.
  ///
  /// In zh, this message translates to:
  /// **'暂无推荐，试试搜索用户吧！'**
  String get noSuggestions;

  /// No description provided for @noResults.
  ///
  /// In zh, this message translates to:
  /// **'未找到用户'**
  String get noResults;

  /// No description provided for @postDetail.
  ///
  /// In zh, this message translates to:
  /// **'帖子详情'**
  String get postDetail;

  /// No description provided for @comments.
  ///
  /// In zh, this message translates to:
  /// **'评论'**
  String get comments;

  /// No description provided for @noComments.
  ///
  /// In zh, this message translates to:
  /// **'还没有评论，来抢沙发吧！'**
  String get noComments;

  /// No description provided for @deleteCommentConfirm.
  ///
  /// In zh, this message translates to:
  /// **'确定要删除这条评论吗？'**
  String get deleteCommentConfirm;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In zh, this message translates to:
  /// **'加载资料失败'**
  String get failedToLoadProfile;

  /// No description provided for @userNotFound.
  ///
  /// In zh, this message translates to:
  /// **'找不到用户'**
  String get userNotFound;

  /// No description provided for @message.
  ///
  /// In zh, this message translates to:
  /// **'私信'**
  String get message;

  /// No description provided for @messages.
  ///
  /// In zh, this message translates to:
  /// **'私信'**
  String get messages;

  /// No description provided for @noMessages.
  ///
  /// In zh, this message translates to:
  /// **'还没有消息'**
  String get noMessages;

  /// No description provided for @startConversation.
  ///
  /// In zh, this message translates to:
  /// **'和别人开始聊天吧！'**
  String get startConversation;

  /// No description provided for @noMessagesYet.
  ///
  /// In zh, this message translates to:
  /// **'还没有消息，打个招呼吧！'**
  String get noMessagesYet;

  /// No description provided for @typing.
  ///
  /// In zh, this message translates to:
  /// **'正在输入...'**
  String get typing;

  /// No description provided for @typeMessage.
  ///
  /// In zh, this message translates to:
  /// **'输入消息...'**
  String get typeMessage;

  /// No description provided for @createVoiceRoom.
  ///
  /// In zh, this message translates to:
  /// **'创建语音房间'**
  String get createVoiceRoom;

  /// No description provided for @roomTitle.
  ///
  /// In zh, this message translates to:
  /// **'房间标题'**
  String get roomTitle;

  /// No description provided for @roomTitleHint.
  ///
  /// In zh, this message translates to:
  /// **'例如：韩语会话练习'**
  String get roomTitleHint;

  /// No description provided for @topic.
  ///
  /// In zh, this message translates to:
  /// **'主题'**
  String get topic;

  /// No description provided for @topicHint.
  ///
  /// In zh, this message translates to:
  /// **'你想聊什么？'**
  String get topicHint;

  /// No description provided for @languageLevel.
  ///
  /// In zh, this message translates to:
  /// **'语言水平'**
  String get languageLevel;

  /// No description provided for @allLevels.
  ///
  /// In zh, this message translates to:
  /// **'所有水平'**
  String get allLevels;

  /// No description provided for @beginner.
  ///
  /// In zh, this message translates to:
  /// **'初级'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In zh, this message translates to:
  /// **'中级'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In zh, this message translates to:
  /// **'高级'**
  String get advanced;

  /// No description provided for @stageSlots.
  ///
  /// In zh, this message translates to:
  /// **'上台名额'**
  String get stageSlots;

  /// No description provided for @anyoneCanListen.
  ///
  /// In zh, this message translates to:
  /// **'任何人都可以加入聆听'**
  String get anyoneCanListen;

  /// No description provided for @createAndJoin.
  ///
  /// In zh, this message translates to:
  /// **'创建并加入'**
  String get createAndJoin;

  /// No description provided for @unmute.
  ///
  /// In zh, this message translates to:
  /// **'取消静音'**
  String get unmute;

  /// No description provided for @mute.
  ///
  /// In zh, this message translates to:
  /// **'静音'**
  String get mute;

  /// No description provided for @leave.
  ///
  /// In zh, this message translates to:
  /// **'离开'**
  String get leave;

  /// No description provided for @closeRoom.
  ///
  /// In zh, this message translates to:
  /// **'关闭房间'**
  String get closeRoom;

  /// No description provided for @emojiReaction.
  ///
  /// In zh, this message translates to:
  /// **'表情'**
  String get emojiReaction;

  /// No description provided for @gesture.
  ///
  /// In zh, this message translates to:
  /// **'动作'**
  String get gesture;

  /// No description provided for @raiseHand.
  ///
  /// In zh, this message translates to:
  /// **'举手'**
  String get raiseHand;

  /// No description provided for @cancelRequest.
  ///
  /// In zh, this message translates to:
  /// **'取消'**
  String get cancelRequest;

  /// No description provided for @leaveStage.
  ///
  /// In zh, this message translates to:
  /// **'退出发言席'**
  String get leaveStage;

  /// No description provided for @pendingRequests.
  ///
  /// In zh, this message translates to:
  /// **'请求'**
  String get pendingRequests;

  /// No description provided for @typeAMessage.
  ///
  /// In zh, this message translates to:
  /// **'输入消息...'**
  String get typeAMessage;

  /// No description provided for @stageRequests.
  ///
  /// In zh, this message translates to:
  /// **'上台请求'**
  String get stageRequests;

  /// No description provided for @noPendingRequests.
  ///
  /// In zh, this message translates to:
  /// **'暂无待处理请求'**
  String get noPendingRequests;

  /// No description provided for @onStage.
  ///
  /// In zh, this message translates to:
  /// **'发言中'**
  String get onStage;

  /// No description provided for @voiceRooms.
  ///
  /// In zh, this message translates to:
  /// **'语音房间'**
  String get voiceRooms;

  /// No description provided for @noVoiceRooms.
  ///
  /// In zh, this message translates to:
  /// **'暂无活跃语音房间'**
  String get noVoiceRooms;

  /// No description provided for @createVoiceRoomHint.
  ///
  /// In zh, this message translates to:
  /// **'创建一个开始聊天吧！'**
  String get createVoiceRoomHint;

  /// No description provided for @createRoom.
  ///
  /// In zh, this message translates to:
  /// **'创建房间'**
  String get createRoom;

  /// Microphone permission required message
  ///
  /// In zh, this message translates to:
  /// **'语音房间需要麦克风权限'**
  String get voiceRoomMicPermission;

  /// Validation message when room title is empty
  ///
  /// In zh, this message translates to:
  /// **'请输入房间标题'**
  String get voiceRoomEnterTitle;

  /// Error when room creation fails
  ///
  /// In zh, this message translates to:
  /// **'创建房间失败'**
  String get voiceRoomCreateFailed;

  /// Message when room is no longer available
  ///
  /// In zh, this message translates to:
  /// **'房间不可用'**
  String get voiceRoomNotAvailable;

  /// Button to go back from unavailable room
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get voiceRoomGoBack;

  /// Connection status banner
  ///
  /// In zh, this message translates to:
  /// **'连接中...'**
  String get voiceRoomConnecting;

  /// Reconnection status with attempt count
  ///
  /// In zh, this message translates to:
  /// **'重新连接中 ({attempts}/{max})...'**
  String voiceRoomReconnecting(int attempts, int max);

  /// Disconnected status
  ///
  /// In zh, this message translates to:
  /// **'已断开连接'**
  String get voiceRoomDisconnected;

  /// Retry connection button
  ///
  /// In zh, this message translates to:
  /// **'重试'**
  String get voiceRoomRetry;

  /// Label for room host
  ///
  /// In zh, this message translates to:
  /// **'（主持人）'**
  String get voiceRoomHostLabel;

  /// Tooltip for demoting speaker to listener
  ///
  /// In zh, this message translates to:
  /// **'降为听众'**
  String get voiceRoomDemoteToListener;

  /// Tooltip for kicking participant
  ///
  /// In zh, this message translates to:
  /// **'踢出房间'**
  String get voiceRoomKickFromRoom;

  /// Section header for listeners list
  ///
  /// In zh, this message translates to:
  /// **'听众'**
  String get voiceRoomListeners;

  /// Dialog title and tooltip for inviting to stage
  ///
  /// In zh, this message translates to:
  /// **'邀请上台'**
  String get voiceRoomInviteToStage;

  /// Confirmation message for stage invitation
  ///
  /// In zh, this message translates to:
  /// **'邀请{name}上台发言？'**
  String voiceRoomInviteConfirm(String name);

  /// Invite button label
  ///
  /// In zh, this message translates to:
  /// **'邀请'**
  String get voiceRoomInvite;

  /// Close room confirmation dialog title
  ///
  /// In zh, this message translates to:
  /// **'关闭房间？'**
  String get voiceRoomCloseConfirmTitle;

  /// Close room confirmation dialog body
  ///
  /// In zh, this message translates to:
  /// **'这将结束所有人的通话。'**
  String get voiceRoomCloseConfirmBody;

  /// Empty chat placeholder
  ///
  /// In zh, this message translates to:
  /// **'暂无消息'**
  String get voiceRoomNoMessagesYet;

  /// Chat input placeholder
  ///
  /// In zh, this message translates to:
  /// **'输入消息...'**
  String get voiceRoomTypeMessage;

  /// Indicator when stage is full
  ///
  /// In zh, this message translates to:
  /// **'舞台已满'**
  String get voiceRoomStageFull;

  /// Listener count for accessibility
  ///
  /// In zh, this message translates to:
  /// **'{count}位听众'**
  String voiceRoomListenerCount(int count);

  /// No description provided for @voiceRoomRemoveFromStage.
  ///
  /// In zh, this message translates to:
  /// **'移出舞台？'**
  String get voiceRoomRemoveFromStage;

  /// Confirm dialog body
  ///
  /// In zh, this message translates to:
  /// **'将{name}移出舞台？他们将成为听众。'**
  String voiceRoomRemoveFromStageConfirm(String name);

  /// No description provided for @voiceRoomDemote.
  ///
  /// In zh, this message translates to:
  /// **'降级'**
  String get voiceRoomDemote;

  /// No description provided for @voiceRoomRemoveFromRoom.
  ///
  /// In zh, this message translates to:
  /// **'移出房间？'**
  String get voiceRoomRemoveFromRoom;

  /// Confirm dialog body
  ///
  /// In zh, this message translates to:
  /// **'将{name}移出房间？他们将被断开连接。'**
  String voiceRoomRemoveFromRoomConfirm(String name);

  /// No description provided for @voiceRoomRemove.
  ///
  /// In zh, this message translates to:
  /// **'移出'**
  String get voiceRoomRemove;

  /// No description provided for @voiceRoomPressBackToLeave.
  ///
  /// In zh, this message translates to:
  /// **'再按一次返回键退出'**
  String get voiceRoomPressBackToLeave;

  /// No description provided for @voiceRoomLeaveTitle.
  ///
  /// In zh, this message translates to:
  /// **'离开房间？'**
  String get voiceRoomLeaveTitle;

  /// No description provided for @voiceRoomLeaveBody.
  ///
  /// In zh, this message translates to:
  /// **'你目前在舞台上。确定要离开吗？'**
  String get voiceRoomLeaveBody;

  /// Auto-navigation message when room is closed
  ///
  /// In zh, this message translates to:
  /// **'正在返回房间列表...'**
  String get voiceRoomReturningToList;

  /// Banner shown briefly after reconnecting
  ///
  /// In zh, this message translates to:
  /// **'已连接！'**
  String get voiceRoomConnected;

  /// Error when stage game fails to initialize
  ///
  /// In zh, this message translates to:
  /// **'舞台加载失败'**
  String get voiceRoomStageFailedToLoad;

  /// Loading indicator while stage initializes
  ///
  /// In zh, this message translates to:
  /// **'正在准备舞台...'**
  String get voiceRoomPreparingStage;

  /// Tooltip for accepting a stage request
  ///
  /// In zh, this message translates to:
  /// **'接受{name}上台'**
  String voiceRoomAcceptToStage(Object name);

  /// Tooltip for rejecting a stage request
  ///
  /// In zh, this message translates to:
  /// **'拒绝{name}'**
  String voiceRoomRejectFromStage(Object name);

  /// Quick create templates section title
  ///
  /// In zh, this message translates to:
  /// **'快速创建'**
  String get voiceRoomQuickCreate;

  /// Room type selector label
  ///
  /// In zh, this message translates to:
  /// **'房间类型'**
  String get voiceRoomRoomType;

  /// Session duration selector label
  ///
  /// In zh, this message translates to:
  /// **'会话时长'**
  String get voiceRoomSessionDuration;

  /// Session duration helper text
  ///
  /// In zh, this message translates to:
  /// **'可选的会话计时器'**
  String get voiceRoomOptionalTimer;

  /// No duration limit option
  ///
  /// In zh, this message translates to:
  /// **'无限制'**
  String get voiceRoomDurationNone;

  /// 15 minute duration option
  ///
  /// In zh, this message translates to:
  /// **'15分钟'**
  String get voiceRoomDuration15;

  /// 30 minute duration option
  ///
  /// In zh, this message translates to:
  /// **'30分钟'**
  String get voiceRoomDuration30;

  /// 45 minute duration option
  ///
  /// In zh, this message translates to:
  /// **'45分钟'**
  String get voiceRoomDuration45;

  /// 60 minute duration option
  ///
  /// In zh, this message translates to:
  /// **'60分钟'**
  String get voiceRoomDuration60;

  /// Free talk room type label
  ///
  /// In zh, this message translates to:
  /// **'自由聊天'**
  String get voiceRoomTypeFreeTalk;

  /// Pronunciation practice room type label
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get voiceRoomTypePronunciation;

  /// Role play room type label
  ///
  /// In zh, this message translates to:
  /// **'角色扮演'**
  String get voiceRoomTypeRolePlay;

  /// Q&A room type label
  ///
  /// In zh, this message translates to:
  /// **'问答'**
  String get voiceRoomTypeQnA;

  /// Listening practice room type label
  ///
  /// In zh, this message translates to:
  /// **'听力练习'**
  String get voiceRoomTypeListening;

  /// Debate room type label
  ///
  /// In zh, this message translates to:
  /// **'辩论'**
  String get voiceRoomTypeDebate;

  /// Quick create template: free talk
  ///
  /// In zh, this message translates to:
  /// **'韩语自由聊天'**
  String get voiceRoomTemplateFreeTalk;

  /// Quick create template: pronunciation
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get voiceRoomTemplatePronunciation;

  /// Quick create template: daily Korean
  ///
  /// In zh, this message translates to:
  /// **'每日韩语'**
  String get voiceRoomTemplateDailyKorean;

  /// Quick create template: TOPIK speaking
  ///
  /// In zh, this message translates to:
  /// **'TOPIK口语'**
  String get voiceRoomTemplateTopikSpeaking;

  /// FAB tooltip for creating a voice room
  ///
  /// In zh, this message translates to:
  /// **'创建语音房间'**
  String get voiceRoomCreateTooltip;

  /// Semantic label for reaction button
  ///
  /// In zh, this message translates to:
  /// **'发送表情'**
  String get voiceRoomSendReaction;

  /// Semantic label for leave room button
  ///
  /// In zh, this message translates to:
  /// **'离开房间'**
  String get voiceRoomLeaveRoom;

  /// Semantic label for unmute button
  ///
  /// In zh, this message translates to:
  /// **'取消麦克风静音'**
  String get voiceRoomUnmuteMic;

  /// Semantic label for mute button
  ///
  /// In zh, this message translates to:
  /// **'麦克风静音'**
  String get voiceRoomMuteMic;

  /// Semantic label for cancelling hand raise
  ///
  /// In zh, this message translates to:
  /// **'取消举手'**
  String get voiceRoomCancelHandRaise;

  /// Semantic label for raising hand
  ///
  /// In zh, this message translates to:
  /// **'举手'**
  String get voiceRoomRaiseHandSemantic;

  /// Semantic label for gesture button
  ///
  /// In zh, this message translates to:
  /// **'发送动作'**
  String get voiceRoomSendGesture;

  /// Semantic label for leave stage button
  ///
  /// In zh, this message translates to:
  /// **'退出舞台'**
  String get voiceRoomLeaveStageAction;

  /// Semantic label for manage stage button
  ///
  /// In zh, this message translates to:
  /// **'管理舞台'**
  String get voiceRoomManageStage;

  /// Tooltip and semantic label for overflow menu
  ///
  /// In zh, this message translates to:
  /// **'更多选项'**
  String get voiceRoomMoreOptions;

  /// Label under overflow menu button
  ///
  /// In zh, this message translates to:
  /// **'更多'**
  String get voiceRoomMore;

  /// Semantic label for the stage area
  ///
  /// In zh, this message translates to:
  /// **'有发言人的语音房间舞台'**
  String get voiceRoomStageWithSpeakers;

  /// Semantic label for stage requests badge
  ///
  /// In zh, this message translates to:
  /// **'上台请求，{count}个待处理'**
  String voiceRoomStageRequestsPending(int count);

  /// Semantic label for speaker and listener count
  ///
  /// In zh, this message translates to:
  /// **'发言人 {speakers}/{maxSpeakers}，听众 {listeners}'**
  String voiceRoomSpeakerListenerCount(
      int speakers, int maxSpeakers, int listeners);

  /// Semantic label for chat input field
  ///
  /// In zh, this message translates to:
  /// **'聊天消息输入'**
  String get voiceRoomChatInput;

  /// Semantic label for send message button
  ///
  /// In zh, this message translates to:
  /// **'发送消息'**
  String get voiceRoomSendMessage;

  /// Semantic label for specific reaction button
  ///
  /// In zh, this message translates to:
  /// **'发送{name}表情'**
  String voiceRoomSendReactionNamed(Object name);

  /// Semantic label for closing reaction tray
  ///
  /// In zh, this message translates to:
  /// **'关闭表情面板'**
  String get voiceRoomCloseReactionTray;

  /// Semantic label for specific gesture button
  ///
  /// In zh, this message translates to:
  /// **'执行{name}动作'**
  String voiceRoomPerformGesture(Object name);

  /// Semantic label for closing gesture tray
  ///
  /// In zh, this message translates to:
  /// **'关闭动作面板'**
  String get voiceRoomCloseGestureTray;

  /// Wave gesture label
  ///
  /// In zh, this message translates to:
  /// **'挥手'**
  String get voiceRoomGestureWave;

  /// Bow gesture label
  ///
  /// In zh, this message translates to:
  /// **'鞠躬'**
  String get voiceRoomGestureBow;

  /// Dance gesture label
  ///
  /// In zh, this message translates to:
  /// **'跳舞'**
  String get voiceRoomGestureDance;

  /// Jump gesture label
  ///
  /// In zh, this message translates to:
  /// **'跳跃'**
  String get voiceRoomGestureJump;

  /// Clap gesture label
  ///
  /// In zh, this message translates to:
  /// **'鼓掌'**
  String get voiceRoomGestureClap;

  /// Label text displayed on the stage area
  ///
  /// In zh, this message translates to:
  /// **'舞台'**
  String get voiceRoomStageLabel;

  /// Label appended to own character name on stage
  ///
  /// In zh, this message translates to:
  /// **'（我）'**
  String get voiceRoomYouLabel;

  /// Semantic label for listener avatar when host can manage
  ///
  /// In zh, this message translates to:
  /// **'听众{name}，点击管理'**
  String voiceRoomListenerTapToManage(Object name);

  /// Semantic label for listener avatar
  ///
  /// In zh, this message translates to:
  /// **'听众{name}'**
  String voiceRoomListenerName(Object name);

  /// Detailed mic permission denied message for dialog
  ///
  /// In zh, this message translates to:
  /// **'麦克风访问被拒绝。要使用语音功能，请在设备设置中启用。'**
  String get voiceRoomMicPermissionDenied;

  /// Mic permission dialog title
  ///
  /// In zh, this message translates to:
  /// **'麦克风权限'**
  String get voiceRoomMicPermissionTitle;

  /// Button to open device settings for permissions
  ///
  /// In zh, this message translates to:
  /// **'打开设置'**
  String get voiceRoomOpenSettings;

  /// Snackbar message when mic denied while raising hand
  ///
  /// In zh, this message translates to:
  /// **'上台发言需要麦克风权限'**
  String get voiceRoomMicNeededForStage;

  /// Batchim description text
  ///
  /// In zh, this message translates to:
  /// **'韩语收音（받침）发音为7种音。\n多个收音发同一个音的现象叫做「收音代表音」。'**
  String get batchimDescriptionText;

  /// Syllable input field label
  ///
  /// In zh, this message translates to:
  /// **'输入音节'**
  String get syllableInputLabel;

  /// Syllable input hint
  ///
  /// In zh, this message translates to:
  /// **'例：한'**
  String get syllableInputHint;

  /// Total practiced count
  ///
  /// In zh, this message translates to:
  /// **'共练习了 {count} 个字'**
  String totalPracticedCount(int count);

  /// Audio load error message
  ///
  /// In zh, this message translates to:
  /// **'无法加载音频'**
  String get audioLoadError;

  /// Writing practice complete message
  ///
  /// In zh, this message translates to:
  /// **'书写练习完成！'**
  String get writingPracticeCompleteMessage;

  /// Seven representative sounds title
  ///
  /// In zh, this message translates to:
  /// **'7种代表音'**
  String get sevenRepresentativeSounds;

  /// No description provided for @myRoom.
  ///
  /// In zh, this message translates to:
  /// **'我的房间'**
  String get myRoom;

  /// No description provided for @characterEditor.
  ///
  /// In zh, this message translates to:
  /// **'角色编辑'**
  String get characterEditor;

  /// No description provided for @roomEditor.
  ///
  /// In zh, this message translates to:
  /// **'房间编辑'**
  String get roomEditor;

  /// No description provided for @shop.
  ///
  /// In zh, this message translates to:
  /// **'商店'**
  String get shop;

  /// No description provided for @character.
  ///
  /// In zh, this message translates to:
  /// **'角色'**
  String get character;

  /// No description provided for @room.
  ///
  /// In zh, this message translates to:
  /// **'房间'**
  String get room;

  /// No description provided for @hair.
  ///
  /// In zh, this message translates to:
  /// **'发型'**
  String get hair;

  /// No description provided for @eyes.
  ///
  /// In zh, this message translates to:
  /// **'眼睛'**
  String get eyes;

  /// No description provided for @brows.
  ///
  /// In zh, this message translates to:
  /// **'眉毛'**
  String get brows;

  /// No description provided for @nose.
  ///
  /// In zh, this message translates to:
  /// **'鼻子'**
  String get nose;

  /// No description provided for @mouth.
  ///
  /// In zh, this message translates to:
  /// **'嘴巴'**
  String get mouth;

  /// No description provided for @top.
  ///
  /// In zh, this message translates to:
  /// **'上衣'**
  String get top;

  /// No description provided for @bottom.
  ///
  /// In zh, this message translates to:
  /// **'下装'**
  String get bottom;

  /// No description provided for @hatItem.
  ///
  /// In zh, this message translates to:
  /// **'帽子'**
  String get hatItem;

  /// No description provided for @accessory.
  ///
  /// In zh, this message translates to:
  /// **'饰品'**
  String get accessory;

  /// No description provided for @wallpaper.
  ///
  /// In zh, this message translates to:
  /// **'壁纸'**
  String get wallpaper;

  /// No description provided for @floorItem.
  ///
  /// In zh, this message translates to:
  /// **'地板'**
  String get floorItem;

  /// No description provided for @petItem.
  ///
  /// In zh, this message translates to:
  /// **'宠物'**
  String get petItem;

  /// No description provided for @none.
  ///
  /// In zh, this message translates to:
  /// **'无'**
  String get none;

  /// No description provided for @noItemsYet.
  ///
  /// In zh, this message translates to:
  /// **'暂无物品'**
  String get noItemsYet;

  /// No description provided for @visitShopToGetItems.
  ///
  /// In zh, this message translates to:
  /// **'去商店获取物品！'**
  String get visitShopToGetItems;

  /// No description provided for @alreadyOwned.
  ///
  /// In zh, this message translates to:
  /// **'已拥有！'**
  String get alreadyOwned;

  /// No description provided for @buy.
  ///
  /// In zh, this message translates to:
  /// **'购买'**
  String get buy;

  /// Purchase success message
  ///
  /// In zh, this message translates to:
  /// **'已购买 {name}！'**
  String purchasedItem(String name);

  /// No description provided for @notEnoughLemons.
  ///
  /// In zh, this message translates to:
  /// **'柠檬不够！'**
  String get notEnoughLemons;

  /// No description provided for @owned.
  ///
  /// In zh, this message translates to:
  /// **'已拥有'**
  String get owned;

  /// No description provided for @free.
  ///
  /// In zh, this message translates to:
  /// **'免费'**
  String get free;

  /// No description provided for @comingSoon.
  ///
  /// In zh, this message translates to:
  /// **'即将推出！'**
  String get comingSoon;

  /// Lemon balance display
  ///
  /// In zh, this message translates to:
  /// **'余额: {count}个柠檬'**
  String balanceLemons(int count);

  /// No description provided for @furnitureItem.
  ///
  /// In zh, this message translates to:
  /// **'家具'**
  String get furnitureItem;

  /// No description provided for @hangulWelcome.
  ///
  /// In zh, this message translates to:
  /// **'欢迎来到韩文世界！'**
  String get hangulWelcome;

  /// No description provided for @hangulWelcomeDesc.
  ///
  /// In zh, this message translates to:
  /// **'逐一学习40个韩文字母'**
  String get hangulWelcomeDesc;

  /// No description provided for @hangulStartLearning.
  ///
  /// In zh, this message translates to:
  /// **'开始学习'**
  String get hangulStartLearning;

  /// No description provided for @hangulLearnNext.
  ///
  /// In zh, this message translates to:
  /// **'学习下一个'**
  String get hangulLearnNext;

  /// No description provided for @hangulLearnedCount.
  ///
  /// In zh, this message translates to:
  /// **'已学习{count}/40个字母！'**
  String hangulLearnedCount(int count);

  /// No description provided for @hangulReviewNeeded.
  ///
  /// In zh, this message translates to:
  /// **'今天有{count}个字母需要复习！'**
  String hangulReviewNeeded(int count);

  /// No description provided for @hangulReviewNow.
  ///
  /// In zh, this message translates to:
  /// **'立即复习'**
  String get hangulReviewNow;

  /// No description provided for @hangulPracticeSuggestion.
  ///
  /// In zh, this message translates to:
  /// **'快要完成了！通过活动巩固技能吧'**
  String get hangulPracticeSuggestion;

  /// No description provided for @hangulStartActivities.
  ///
  /// In zh, this message translates to:
  /// **'开始活动'**
  String get hangulStartActivities;

  /// No description provided for @hangulMastered.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！你已经掌握了韩文字母！'**
  String get hangulMastered;

  /// No description provided for @hangulGoToLevel1.
  ///
  /// In zh, this message translates to:
  /// **'进入第1级'**
  String get hangulGoToLevel1;

  /// No description provided for @completedLessonsLabel.
  ///
  /// In zh, this message translates to:
  /// **'已完成'**
  String get completedLessonsLabel;

  /// No description provided for @wordsLearnedLabel.
  ///
  /// In zh, this message translates to:
  /// **'已学单词'**
  String get wordsLearnedLabel;

  /// No description provided for @totalStudyTimeLabel.
  ///
  /// In zh, this message translates to:
  /// **'学习时间'**
  String get totalStudyTimeLabel;

  /// No description provided for @streakDetails.
  ///
  /// In zh, this message translates to:
  /// **'连续学习记录'**
  String get streakDetails;

  /// No description provided for @consecutiveDays.
  ///
  /// In zh, this message translates to:
  /// **'连续天数'**
  String get consecutiveDays;

  /// No description provided for @totalStudyDaysLabel.
  ///
  /// In zh, this message translates to:
  /// **'总学习天数'**
  String get totalStudyDaysLabel;

  /// No description provided for @studyRecord.
  ///
  /// In zh, this message translates to:
  /// **'学习记录'**
  String get studyRecord;

  /// No description provided for @noFriendsPrompt.
  ///
  /// In zh, this message translates to:
  /// **'找朋友一起学习吧！'**
  String get noFriendsPrompt;

  /// No description provided for @moreStats.
  ///
  /// In zh, this message translates to:
  /// **'查看全部'**
  String get moreStats;

  /// No description provided for @remainingLessons.
  ///
  /// In zh, this message translates to:
  /// **'再完成{count}个即可达成今日目标！'**
  String remainingLessons(int count);

  /// No description provided for @streakMotivation0.
  ///
  /// In zh, this message translates to:
  /// **'今天开始学习吧！'**
  String get streakMotivation0;

  /// No description provided for @streakMotivation1.
  ///
  /// In zh, this message translates to:
  /// **'好的开始！继续加油！'**
  String get streakMotivation1;

  /// No description provided for @streakMotivation7.
  ///
  /// In zh, this message translates to:
  /// **'连续学习超过一周！太棒了！'**
  String get streakMotivation7;

  /// No description provided for @streakMotivation14.
  ///
  /// In zh, this message translates to:
  /// **'坚持两周了！正在养成习惯！'**
  String get streakMotivation14;

  /// No description provided for @streakMotivation30.
  ///
  /// In zh, this message translates to:
  /// **'连续一个月以上！你是真正的学习者！'**
  String get streakMotivation30;

  /// No description provided for @minutesShort.
  ///
  /// In zh, this message translates to:
  /// **'{count}分钟'**
  String minutesShort(int count);

  /// No description provided for @hoursShort.
  ///
  /// In zh, this message translates to:
  /// **'{count}小时'**
  String hoursShort(int count);

  /// Speech practice step title
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get speechPractice;

  /// Tap to record instruction
  ///
  /// In zh, this message translates to:
  /// **'点击录音'**
  String get tapToRecord;

  /// Recording status
  ///
  /// In zh, this message translates to:
  /// **'录音中...'**
  String get recording;

  /// Analyzing status
  ///
  /// In zh, this message translates to:
  /// **'分析中...'**
  String get analyzing;

  /// Pronunciation score label
  ///
  /// In zh, this message translates to:
  /// **'发音分数'**
  String get pronunciationScore;

  /// Phoneme breakdown label
  ///
  /// In zh, this message translates to:
  /// **'音素分析'**
  String get phonemeBreakdown;

  /// Try again with attempt count
  ///
  /// In zh, this message translates to:
  /// **'重试 ({current}/{max})'**
  String tryAgainCount(String current, String max);

  /// Next character button
  ///
  /// In zh, this message translates to:
  /// **'下一个字'**
  String get nextCharacter;

  /// Excellent pronunciation feedback
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get excellentPronunciation;

  /// Good pronunciation feedback
  ///
  /// In zh, this message translates to:
  /// **'做得好！'**
  String get goodPronunciation;

  /// Fair pronunciation feedback
  ///
  /// In zh, this message translates to:
  /// **'继续加油！'**
  String get fairPronunciation;

  /// Needs more practice feedback
  ///
  /// In zh, this message translates to:
  /// **'继续练习！'**
  String get needsMorePractice;

  /// Download models button
  ///
  /// In zh, this message translates to:
  /// **'下载'**
  String get downloadModels;

  /// Model downloading status
  ///
  /// In zh, this message translates to:
  /// **'正在下载模型'**
  String get modelDownloading;

  /// Model ready status
  ///
  /// In zh, this message translates to:
  /// **'已就绪'**
  String get modelReady;

  /// Model not installed status
  ///
  /// In zh, this message translates to:
  /// **'未安装'**
  String get modelNotReady;

  /// Model size label
  ///
  /// In zh, this message translates to:
  /// **'模型大小'**
  String get modelSize;

  /// Speech recognition AI model title
  ///
  /// In zh, this message translates to:
  /// **'语音识别AI模型'**
  String get speechModelTitle;

  /// Skip speech practice button
  ///
  /// In zh, this message translates to:
  /// **'跳过'**
  String get skipSpeechPractice;

  /// Delete model button
  ///
  /// In zh, this message translates to:
  /// **'删除模型'**
  String get deleteModel;

  /// Overall score label
  ///
  /// In zh, this message translates to:
  /// **'综合分数'**
  String get overallScore;

  /// App tagline on login screen
  ///
  /// In zh, this message translates to:
  /// **'像柠檬一样清新，实力稳稳的！'**
  String get appTagline;

  /// Password field hint text
  ///
  /// In zh, this message translates to:
  /// **'请输入包含字母和数字的8位以上密码'**
  String get passwordHint;

  /// Find account link
  ///
  /// In zh, this message translates to:
  /// **'找回账号'**
  String get findAccount;

  /// Reset password link
  ///
  /// In zh, this message translates to:
  /// **'重置密码'**
  String get resetPassword;

  /// Register screen title
  ///
  /// In zh, this message translates to:
  /// **'清新的韩语之旅，现在出发！'**
  String get registerTitle;

  /// Register screen subtitle
  ///
  /// In zh, this message translates to:
  /// **'轻松起步也没关系！我会牢牢带着你'**
  String get registerSubtitle;

  /// Nickname field label
  ///
  /// In zh, this message translates to:
  /// **'昵称'**
  String get nickname;

  /// Nickname field hint text
  ///
  /// In zh, this message translates to:
  /// **'15个字符以内：字母、数字、下划线'**
  String get nicknameHint;

  /// Confirm password hint text
  ///
  /// In zh, this message translates to:
  /// **'请再次输入密码'**
  String get confirmPasswordHint;

  /// Account choice screen title
  ///
  /// In zh, this message translates to:
  /// **'欢迎！和莫尼一起\n建立学习习惯吧！'**
  String get accountChoiceTitle;

  /// Account choice screen subtitle
  ///
  /// In zh, this message translates to:
  /// **'清新出发，实力我来帮你守住！'**
  String get accountChoiceSubtitle;

  /// Start with email button
  ///
  /// In zh, this message translates to:
  /// **'使用邮箱开始'**
  String get startWithEmail;

  /// Delete message dialog title
  ///
  /// In zh, this message translates to:
  /// **'删除消息？'**
  String get deleteMessageTitle;

  /// Delete message dialog content
  ///
  /// In zh, this message translates to:
  /// **'此消息将对所有人删除。'**
  String get deleteMessageContent;

  /// Deleted message placeholder
  ///
  /// In zh, this message translates to:
  /// **'消息已删除'**
  String get messageDeleted;

  /// Empty state first post prompt
  ///
  /// In zh, this message translates to:
  /// **'来发第一条帖子吧！'**
  String get beFirstToPost;

  /// Tag input hint
  ///
  /// In zh, this message translates to:
  /// **'输入标签...'**
  String get typeTagHint;

  /// User info load failed error
  ///
  /// In zh, this message translates to:
  /// **'加载用户信息失败'**
  String get userInfoLoadFailed;

  /// Login error occurred
  ///
  /// In zh, this message translates to:
  /// **'登录过程中发生错误'**
  String get loginErrorOccurred;

  /// Register error occurred
  ///
  /// In zh, this message translates to:
  /// **'注册过程中发生错误'**
  String get registerErrorOccurred;

  /// Logout error occurred
  ///
  /// In zh, this message translates to:
  /// **'退出登录过程中发生错误'**
  String get logoutErrorOccurred;

  /// No description provided for @hangulStage0Title.
  ///
  /// In zh, this message translates to:
  /// **'第0阶段：理解韩文结构'**
  String get hangulStage0Title;

  /// No description provided for @hangulStage1Title.
  ///
  /// In zh, this message translates to:
  /// **'第1阶段：基本元音'**
  String get hangulStage1Title;

  /// No description provided for @hangulStage2Title.
  ///
  /// In zh, this message translates to:
  /// **'第2阶段：Y元音'**
  String get hangulStage2Title;

  /// No description provided for @hangulStage3Title.
  ///
  /// In zh, this message translates to:
  /// **'第3阶段：ㅐ/ㅔ元音'**
  String get hangulStage3Title;

  /// No description provided for @hangulStage4Title.
  ///
  /// In zh, this message translates to:
  /// **'第4阶段：基本辅音1'**
  String get hangulStage4Title;

  /// No description provided for @hangulStage5Title.
  ///
  /// In zh, this message translates to:
  /// **'第5阶段：基本辅音2'**
  String get hangulStage5Title;

  /// No description provided for @hangulStage6Title.
  ///
  /// In zh, this message translates to:
  /// **'第6阶段：音节组合训练'**
  String get hangulStage6Title;

  /// No description provided for @hangulStage7Title.
  ///
  /// In zh, this message translates to:
  /// **'第7阶段：紧音/送气音'**
  String get hangulStage7Title;

  /// No description provided for @hangulStage8Title.
  ///
  /// In zh, this message translates to:
  /// **'第8阶段：收音（终声）1'**
  String get hangulStage8Title;

  /// No description provided for @hangulStage9Title.
  ///
  /// In zh, this message translates to:
  /// **'第9阶段：收音扩展'**
  String get hangulStage9Title;

  /// No description provided for @hangulStage10Title.
  ///
  /// In zh, this message translates to:
  /// **'第10阶段：复合收音'**
  String get hangulStage10Title;

  /// No description provided for @hangulStage11Title.
  ///
  /// In zh, this message translates to:
  /// **'第11阶段：扩展词汇阅读'**
  String get hangulStage11Title;

  /// No description provided for @sortAlphabetical.
  ///
  /// In zh, this message translates to:
  /// **'字母顺序'**
  String get sortAlphabetical;

  /// No description provided for @sortByLevel.
  ///
  /// In zh, this message translates to:
  /// **'按级别'**
  String get sortByLevel;

  /// No description provided for @sortBySimilarity.
  ///
  /// In zh, this message translates to:
  /// **'按相似度'**
  String get sortBySimilarity;

  /// No description provided for @searchWordsKoreanMeaning.
  ///
  /// In zh, this message translates to:
  /// **'搜索单词（韩语/含义）'**
  String get searchWordsKoreanMeaning;

  /// No description provided for @groupedView.
  ///
  /// In zh, this message translates to:
  /// **'分组视图'**
  String get groupedView;

  /// No description provided for @matrixView.
  ///
  /// In zh, this message translates to:
  /// **'辅音×元音'**
  String get matrixView;

  /// No description provided for @reviewLessons.
  ///
  /// In zh, this message translates to:
  /// **'复习课程'**
  String get reviewLessons;

  /// No description provided for @stageDetailComingSoon.
  ///
  /// In zh, this message translates to:
  /// **'详细内容正在准备中。'**
  String get stageDetailComingSoon;

  /// No description provided for @bossQuizComingSoon.
  ///
  /// In zh, this message translates to:
  /// **'Boss测验正在准备中。'**
  String get bossQuizComingSoon;

  /// No description provided for @exitLessonDialogTitle.
  ///
  /// In zh, this message translates to:
  /// **'退出课程'**
  String get exitLessonDialogTitle;

  /// No description provided for @exitLessonDialogContent.
  ///
  /// In zh, this message translates to:
  /// **'要退出课程吗？\n当前步骤的进度将自动保存。'**
  String get exitLessonDialogContent;

  /// No description provided for @continueButton.
  ///
  /// In zh, this message translates to:
  /// **'继续'**
  String get continueButton;

  /// No description provided for @exitLessonButton.
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get exitLessonButton;

  /// No description provided for @noQuestions.
  ///
  /// In zh, this message translates to:
  /// **'没有可用的问题'**
  String get noQuestions;

  /// No description provided for @noCharactersDefined.
  ///
  /// In zh, this message translates to:
  /// **'未定义字符'**
  String get noCharactersDefined;

  /// No description provided for @recordingStartFailed.
  ///
  /// In zh, this message translates to:
  /// **'录音启动失败'**
  String get recordingStartFailed;

  /// No description provided for @consonant.
  ///
  /// In zh, this message translates to:
  /// **'辅音'**
  String get consonant;

  /// No description provided for @vowel.
  ///
  /// In zh, this message translates to:
  /// **'元音'**
  String get vowel;

  /// No description provided for @validationEmailRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入电子邮箱'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailTooLong.
  ///
  /// In zh, this message translates to:
  /// **'电子邮箱地址过长'**
  String get validationEmailTooLong;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In zh, this message translates to:
  /// **'请输入有效的电子邮箱地址'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入密码'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In zh, this message translates to:
  /// **'密码至少需要{minLength}个字符'**
  String validationPasswordMinLength(int minLength);

  /// No description provided for @validationPasswordNeedLetter.
  ///
  /// In zh, this message translates to:
  /// **'密码必须包含字母'**
  String get validationPasswordNeedLetter;

  /// No description provided for @validationPasswordNeedNumber.
  ///
  /// In zh, this message translates to:
  /// **'密码必须包含数字'**
  String get validationPasswordNeedNumber;

  /// No description provided for @validationPasswordNeedSpecial.
  ///
  /// In zh, this message translates to:
  /// **'密码必须包含特殊字符'**
  String get validationPasswordNeedSpecial;

  /// No description provided for @validationPasswordTooLong.
  ///
  /// In zh, this message translates to:
  /// **'密码过长'**
  String get validationPasswordTooLong;

  /// No description provided for @validationConfirmPasswordRequired.
  ///
  /// In zh, this message translates to:
  /// **'请再次输入密码'**
  String get validationConfirmPasswordRequired;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In zh, this message translates to:
  /// **'两次输入的密码不一致'**
  String get validationPasswordMismatch;

  /// No description provided for @validationUsernameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入用户名'**
  String get validationUsernameRequired;

  /// No description provided for @validationUsernameTooShort.
  ///
  /// In zh, this message translates to:
  /// **'用户名至少需要{minLength}个字符'**
  String validationUsernameTooShort(int minLength);

  /// No description provided for @validationUsernameTooLong.
  ///
  /// In zh, this message translates to:
  /// **'用户名不能超过{maxLength}个字符'**
  String validationUsernameTooLong(int maxLength);

  /// No description provided for @validationUsernameInvalidChars.
  ///
  /// In zh, this message translates to:
  /// **'用户名只能包含字母、数字和下划线'**
  String get validationUsernameInvalidChars;

  /// No description provided for @validationFieldRequired.
  ///
  /// In zh, this message translates to:
  /// **'请输入{fieldName}'**
  String validationFieldRequired(String fieldName);

  /// No description provided for @validationFieldMinLength.
  ///
  /// In zh, this message translates to:
  /// **'{fieldName}至少需要{minLength}个字符'**
  String validationFieldMinLength(String fieldName, int minLength);

  /// No description provided for @validationFieldMaxLength.
  ///
  /// In zh, this message translates to:
  /// **'{fieldName}不能超过{maxLength}个字符'**
  String validationFieldMaxLength(String fieldName, int maxLength);

  /// No description provided for @validationFieldNumeric.
  ///
  /// In zh, this message translates to:
  /// **'{fieldName}必须是数字'**
  String validationFieldNumeric(String fieldName);

  /// No description provided for @errorNetworkConnection.
  ///
  /// In zh, this message translates to:
  /// **'网络连接失败，请检查网络设置'**
  String get errorNetworkConnection;

  /// No description provided for @errorServer.
  ///
  /// In zh, this message translates to:
  /// **'服务器错误，请稍后重试'**
  String get errorServer;

  /// No description provided for @errorAuthFailed.
  ///
  /// In zh, this message translates to:
  /// **'认证失败，请重新登录'**
  String get errorAuthFailed;

  /// No description provided for @errorUnknown.
  ///
  /// In zh, this message translates to:
  /// **'未知错误，请稍后重试'**
  String get errorUnknown;

  /// No description provided for @errorTimeout.
  ///
  /// In zh, this message translates to:
  /// **'连接超时，请检查网络'**
  String get errorTimeout;

  /// No description provided for @errorRequestCancelled.
  ///
  /// In zh, this message translates to:
  /// **'请求已取消'**
  String get errorRequestCancelled;

  /// No description provided for @errorForbidden.
  ///
  /// In zh, this message translates to:
  /// **'没有访问权限'**
  String get errorForbidden;

  /// No description provided for @errorNotFound.
  ///
  /// In zh, this message translates to:
  /// **'请求的资源不存在'**
  String get errorNotFound;

  /// No description provided for @errorRequestParam.
  ///
  /// In zh, this message translates to:
  /// **'请求参数错误'**
  String get errorRequestParam;

  /// No description provided for @errorParseData.
  ///
  /// In zh, this message translates to:
  /// **'数据解析错误'**
  String get errorParseData;

  /// No description provided for @errorParseFormat.
  ///
  /// In zh, this message translates to:
  /// **'数据格式错误'**
  String get errorParseFormat;

  /// No description provided for @errorRateLimited.
  ///
  /// In zh, this message translates to:
  /// **'请求过多，请稍后重试'**
  String get errorRateLimited;

  /// No description provided for @successLogin.
  ///
  /// In zh, this message translates to:
  /// **'登录成功'**
  String get successLogin;

  /// No description provided for @successRegister.
  ///
  /// In zh, this message translates to:
  /// **'注册成功'**
  String get successRegister;

  /// No description provided for @successSync.
  ///
  /// In zh, this message translates to:
  /// **'同步成功'**
  String get successSync;

  /// No description provided for @successDownload.
  ///
  /// In zh, this message translates to:
  /// **'下载成功'**
  String get successDownload;

  /// No description provided for @failedToCreateComment.
  ///
  /// In zh, this message translates to:
  /// **'创建评论失败'**
  String get failedToCreateComment;

  /// No description provided for @failedToDeleteComment.
  ///
  /// In zh, this message translates to:
  /// **'删除评论失败'**
  String get failedToDeleteComment;

  /// No description provided for @failedToSubmitReport.
  ///
  /// In zh, this message translates to:
  /// **'提交举报失败'**
  String get failedToSubmitReport;

  /// No description provided for @failedToBlockUser.
  ///
  /// In zh, this message translates to:
  /// **'屏蔽用户失败'**
  String get failedToBlockUser;

  /// No description provided for @failedToUnblockUser.
  ///
  /// In zh, this message translates to:
  /// **'取消屏蔽用户失败'**
  String get failedToUnblockUser;

  /// No description provided for @failedToCreatePost.
  ///
  /// In zh, this message translates to:
  /// **'创建帖子失败'**
  String get failedToCreatePost;

  /// No description provided for @failedToDeletePost.
  ///
  /// In zh, this message translates to:
  /// **'删除帖子失败'**
  String get failedToDeletePost;

  /// No description provided for @noVocabularyForLevel.
  ///
  /// In zh, this message translates to:
  /// **'未找到{level}级词汇'**
  String noVocabularyForLevel(int level);

  /// No description provided for @uploadingImage.
  ///
  /// In zh, this message translates to:
  /// **'[图片上传中...]'**
  String get uploadingImage;

  /// No description provided for @uploadingVoice.
  ///
  /// In zh, this message translates to:
  /// **'[语音上传中...]'**
  String get uploadingVoice;

  /// No description provided for @imagePreview.
  ///
  /// In zh, this message translates to:
  /// **'[图片]'**
  String get imagePreview;

  /// No description provided for @voicePreview.
  ///
  /// In zh, this message translates to:
  /// **'[语音]'**
  String get voicePreview;

  /// No description provided for @voiceServerConnectFailed.
  ///
  /// In zh, this message translates to:
  /// **'无法连接语音服务器，请检查您的连接。'**
  String get voiceServerConnectFailed;

  /// No description provided for @connectionLostRetry.
  ///
  /// In zh, this message translates to:
  /// **'连接断开，点击重试。'**
  String get connectionLostRetry;

  /// No description provided for @noInternetConnection.
  ///
  /// In zh, this message translates to:
  /// **'无网络连接，请检查您的网络。'**
  String get noInternetConnection;

  /// No description provided for @couldNotLoadRooms.
  ///
  /// In zh, this message translates to:
  /// **'无法加载房间列表，请重试。'**
  String get couldNotLoadRooms;

  /// No description provided for @couldNotCreateRoom.
  ///
  /// In zh, this message translates to:
  /// **'无法创建房间，请重试。'**
  String get couldNotCreateRoom;

  /// No description provided for @couldNotJoinRoom.
  ///
  /// In zh, this message translates to:
  /// **'无法加入房间，请检查您的连接。'**
  String get couldNotJoinRoom;

  /// No description provided for @roomClosedByHost.
  ///
  /// In zh, this message translates to:
  /// **'主持人已关闭房间。'**
  String get roomClosedByHost;

  /// No description provided for @removedFromRoomByHost.
  ///
  /// In zh, this message translates to:
  /// **'您已被主持人移出房间。'**
  String get removedFromRoomByHost;

  /// No description provided for @connectionTimedOut.
  ///
  /// In zh, this message translates to:
  /// **'连接超时，请重试。'**
  String get connectionTimedOut;

  /// No description provided for @missingLiveKitCredentials.
  ///
  /// In zh, this message translates to:
  /// **'缺少语音连接凭据。'**
  String get missingLiveKitCredentials;

  /// No description provided for @microphoneEnableFailed.
  ///
  /// In zh, this message translates to:
  /// **'无法启用麦克风。请检查权限并尝试取消静音。'**
  String get microphoneEnableFailed;

  /// No description provided for @voiceRoomNewMessages.
  ///
  /// In zh, this message translates to:
  /// **'新消息'**
  String get voiceRoomNewMessages;

  /// No description provided for @voiceRoomChatRateLimited.
  ///
  /// In zh, this message translates to:
  /// **'消息发送过快，请稍候再试。'**
  String get voiceRoomChatRateLimited;

  /// No description provided for @voiceRoomMessageSendFailed.
  ///
  /// In zh, this message translates to:
  /// **'消息发送失败，请重试。'**
  String get voiceRoomMessageSendFailed;

  /// No description provided for @voiceRoomChatError.
  ///
  /// In zh, this message translates to:
  /// **'聊天出错。'**
  String get voiceRoomChatError;

  /// No description provided for @retryAttempt.
  ///
  /// In zh, this message translates to:
  /// **'重试 ({current}/{max})'**
  String retryAttempt(int current, int max);

  /// No description provided for @nextButton.
  ///
  /// In zh, this message translates to:
  /// **'下一步'**
  String get nextButton;

  /// No description provided for @completeButton.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get completeButton;

  /// No description provided for @startButton.
  ///
  /// In zh, this message translates to:
  /// **'开始'**
  String get startButton;

  /// No description provided for @doneButton.
  ///
  /// In zh, this message translates to:
  /// **'完成'**
  String get doneButton;

  /// No description provided for @goBackButton.
  ///
  /// In zh, this message translates to:
  /// **'返回'**
  String get goBackButton;

  /// No description provided for @tapToListen.
  ///
  /// In zh, this message translates to:
  /// **'点击听发音'**
  String get tapToListen;

  /// No description provided for @listenAllSoundsFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先听完所有发音'**
  String get listenAllSoundsFirst;

  /// No description provided for @nextCharButton.
  ///
  /// In zh, this message translates to:
  /// **'下一个字'**
  String get nextCharButton;

  /// No description provided for @listenAndChooseCorrect.
  ///
  /// In zh, this message translates to:
  /// **'听发音，选出正确的字'**
  String get listenAndChooseCorrect;

  /// No description provided for @lessonCompletedMsg.
  ///
  /// In zh, this message translates to:
  /// **'你完成了课程！'**
  String get lessonCompletedMsg;

  /// No description provided for @stageMasterLabel.
  ///
  /// In zh, this message translates to:
  /// **'第{stage}阶段大师'**
  String stageMasterLabel(int stage);

  /// No description provided for @hangulS0L0Title.
  ///
  /// In zh, this message translates to:
  /// **'韩文是怎么来的？'**
  String get hangulS0L0Title;

  /// No description provided for @hangulS0L0Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'简单了解韩文的诞生过程'**
  String get hangulS0L0Subtitle;

  /// No description provided for @hangulS0L0Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'很久以前，学习文字非常困难'**
  String get hangulS0L0Step0Title;

  /// No description provided for @hangulS0L0Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'古代朝鲜半岛主要借用汉字书写，\n许多百姓难以学习。'**
  String get hangulS0L0Step0Desc;

  /// No description provided for @hangulS0L0Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'汉字,困难,阅读,书写'**
  String get hangulS0L0Step0Highlights;

  /// No description provided for @hangulS0L0Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'世宗大王创造了新的文字'**
  String get hangulS0L0Step1Title;

  /// No description provided for @hangulS0L0Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'为了让百姓轻松学习，\n世宗大王亲自创制了训民正音。\n（1443年创制，1446年颁布）'**
  String get hangulS0L0Step1Desc;

  /// No description provided for @hangulS0L0Step1Highlights.
  ///
  /// In zh, this message translates to:
  /// **'世宗大王,训民正音,1443,1446'**
  String get hangulS0L0Step1Highlights;

  /// No description provided for @hangulS0L0Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'于是有了今天的韩文'**
  String get hangulS0L0Step2Title;

  /// No description provided for @hangulS0L0Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'韩文是为了方便记录声音而创造的文字。\n在下一课中，我们将学习辅音和元音的结构。'**
  String get hangulS0L0Step2Desc;

  /// No description provided for @hangulS0L0Step2Highlights.
  ///
  /// In zh, this message translates to:
  /// **'声音,简易文字,韩文'**
  String get hangulS0L0Step2Highlights;

  /// No description provided for @hangulS0L0SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'介绍课完成！'**
  String get hangulS0L0SummaryTitle;

  /// No description provided for @hangulS0L0SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n现在你知道韩文为什么被创造了。\n接下来学习辅音和元音的结构吧。'**
  String get hangulS0L0SummaryMsg;

  /// No description provided for @hangulS0L1Title.
  ///
  /// In zh, this message translates to:
  /// **'组装가字块'**
  String get hangulS0L1Title;

  /// No description provided for @hangulS0L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'通过拖拽体验拼字过程'**
  String get hangulS0L1Subtitle;

  /// No description provided for @hangulS0L1IntroTitle.
  ///
  /// In zh, this message translates to:
  /// **'韩文就像积木！'**
  String get hangulS0L1IntroTitle;

  /// No description provided for @hangulS0L1IntroDesc.
  ///
  /// In zh, this message translates to:
  /// **'韩文通过组合辅音和元音来构成文字。\n辅音（ㄱ）+ 元音（ㅏ）= 가\n\n更复杂的文字下面还会有收音（받침）。\n（以后再学！）'**
  String get hangulS0L1IntroDesc;

  /// No description provided for @hangulS0L1IntroHighlights.
  ///
  /// In zh, this message translates to:
  /// **'辅音,元音,文字'**
  String get hangulS0L1IntroHighlights;

  /// No description provided for @hangulS0L1DragGaTitle.
  ///
  /// In zh, this message translates to:
  /// **'组装가'**
  String get hangulS0L1DragGaTitle;

  /// No description provided for @hangulS0L1DragGaDesc.
  ///
  /// In zh, this message translates to:
  /// **'将ㄱ和ㅏ拖到空格中'**
  String get hangulS0L1DragGaDesc;

  /// No description provided for @hangulS0L1DragNaTitle.
  ///
  /// In zh, this message translates to:
  /// **'组装나'**
  String get hangulS0L1DragNaTitle;

  /// No description provided for @hangulS0L1DragNaDesc.
  ///
  /// In zh, this message translates to:
  /// **'试试使用新的辅音ㄴ'**
  String get hangulS0L1DragNaDesc;

  /// No description provided for @hangulS0L1DragDaTitle.
  ///
  /// In zh, this message translates to:
  /// **'组装다'**
  String get hangulS0L1DragDaTitle;

  /// No description provided for @hangulS0L1DragDaDesc.
  ///
  /// In zh, this message translates to:
  /// **'试试使用新的辅音ㄷ'**
  String get hangulS0L1DragDaDesc;

  /// No description provided for @hangulS0L1SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS0L1SummaryTitle;

  /// No description provided for @hangulS0L1SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'辅音 + 元音 = 文字块！\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다'**
  String get hangulS0L1SummaryMsg;

  /// No description provided for @hangulS0L2Title.
  ///
  /// In zh, this message translates to:
  /// **'声音探索'**
  String get hangulS0L2Title;

  /// No description provided for @hangulS0L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'通过声音感受辅音和元音'**
  String get hangulS0L2Subtitle;

  /// No description provided for @hangulS0L2IntroTitle.
  ///
  /// In zh, this message translates to:
  /// **'感受声音'**
  String get hangulS0L2IntroTitle;

  /// No description provided for @hangulS0L2IntroDesc.
  ///
  /// In zh, this message translates to:
  /// **'韩文的每个辅音和元音都有独特的声音。\n听一听，感受一下。'**
  String get hangulS0L2IntroDesc;

  /// No description provided for @hangulS0L2Sound1Title.
  ///
  /// In zh, this message translates to:
  /// **'辅音ㄱ、ㄴ、ㄷ的基本发音'**
  String get hangulS0L2Sound1Title;

  /// No description provided for @hangulS0L2Sound1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听辅音加上ㅏ后的发音（가、나、다）'**
  String get hangulS0L2Sound1Desc;

  /// No description provided for @hangulS0L2Sound2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ、ㅗ元音发音'**
  String get hangulS0L2Sound2Title;

  /// No description provided for @hangulS0L2Sound2Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听这两个元音的发音'**
  String get hangulS0L2Sound2Desc;

  /// No description provided for @hangulS0L2Sound3Title.
  ///
  /// In zh, this message translates to:
  /// **'听가、나、다的发音'**
  String get hangulS0L2Sound3Title;

  /// No description provided for @hangulS0L2Sound3Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听辅音和元音组合而成的文字发音'**
  String get hangulS0L2Sound3Desc;

  /// No description provided for @hangulS0L2SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS0L2SummaryTitle;

  /// No description provided for @hangulS0L2SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'每个辅音都有配上ㅏ的标准读音，比如가、나、다。\n现在你对元音的发音也有感觉了！'**
  String get hangulS0L2SummaryMsg;

  /// No description provided for @hangulS0L3Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS0L3Title;

  /// No description provided for @hangulS0L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'通过声音区分文字'**
  String get hangulS0L3Subtitle;

  /// No description provided for @hangulS0L3IntroTitle.
  ///
  /// In zh, this message translates to:
  /// **'这次用耳朵来分辨'**
  String get hangulS0L3IntroTitle;

  /// No description provided for @hangulS0L3IntroDesc.
  ///
  /// In zh, this message translates to:
  /// **'比起看屏幕，更要专注于声音。\n听音辨字，找出正确答案！'**
  String get hangulS0L3IntroDesc;

  /// No description provided for @hangulS0L3Sound1Title.
  ///
  /// In zh, this message translates to:
  /// **'确认가/나/다/고/노的发音'**
  String get hangulS0L3Sound1Title;

  /// No description provided for @hangulS0L3Sound1Desc.
  ///
  /// In zh, this message translates to:
  /// **'先充分听一下这5个发音'**
  String get hangulS0L3Sound1Desc;

  /// No description provided for @hangulS0L3Match1Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选择相同的文字'**
  String get hangulS0L3Match1Title;

  /// No description provided for @hangulS0L3Match1Desc.
  ///
  /// In zh, this message translates to:
  /// **'选择与播放的声音相匹配的文字'**
  String get hangulS0L3Match1Desc;

  /// No description provided for @hangulS0L3Match2Title.
  ///
  /// In zh, this message translates to:
  /// **'区分ㅏ / ㅗ的发音'**
  String get hangulS0L3Match2Title;

  /// No description provided for @hangulS0L3Match2Desc.
  ///
  /// In zh, this message translates to:
  /// **'辅音相同时，靠元音来区分发音'**
  String get hangulS0L3Match2Desc;

  /// No description provided for @hangulS0L3SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS0L3SummaryTitle;

  /// No description provided for @hangulS0L3SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n现在你可以同时用眼睛（组装）和耳朵（声音）\n来理解韩文的结构了。'**
  String get hangulS0L3SummaryMsg;

  /// No description provided for @hangulS0CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第0阶段完成！'**
  String get hangulS0CompleteTitle;

  /// No description provided for @hangulS0CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已经理解了韩文的结构！'**
  String get hangulS0CompleteMsg;

  /// No description provided for @hangulS1L1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ的形状与读音'**
  String get hangulS1L1Title;

  /// No description provided for @hangulS1L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'竖线右侧短横: ㅏ'**
  String get hangulS1L1Subtitle;

  /// No description provided for @hangulS1L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'学习第一个元音ㅏ'**
  String get hangulS1L1Step0Title;

  /// No description provided for @hangulS1L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ发出明亮的\"아\"音。\n让我们一起学习形状和读音。'**
  String get hangulS1L1Step0Desc;

  /// No description provided for @hangulS1L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ,아,基本元音'**
  String get hangulS1L1Step0Highlights;

  /// No description provided for @hangulS1L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅏ的读音'**
  String get hangulS1L1Step1Title;

  /// No description provided for @hangulS1L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听含有ㅏ的读音'**
  String get hangulS1L1Step1Desc;

  /// No description provided for @hangulS1L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L1Step2Title;

  /// No description provided for @hangulS1L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读这些文字'**
  String get hangulS1L1Step2Desc;

  /// No description provided for @hangulS1L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅏ的读音'**
  String get hangulS1L1Step3Title;

  /// No description provided for @hangulS1L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'听音后选择正确的文字'**
  String get hangulS1L1Step3Desc;

  /// No description provided for @hangulS1L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'形状测验'**
  String get hangulS1L1Step4Title;

  /// No description provided for @hangulS1L1Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确找出ㅏ'**
  String get hangulS1L1Step4Desc;

  /// No description provided for @hangulS1L1Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅏ？'**
  String get hangulS1L1Step4Q0;

  /// No description provided for @hangulS1L1Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个含有ㅏ？'**
  String get hangulS1L1Step4Q1;

  /// No description provided for @hangulS1L1Step4Q2.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅏ = ?'**
  String get hangulS1L1Step4Q2;

  /// No description provided for @hangulS1L1Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅏ组字'**
  String get hangulS1L1Step5Title;

  /// No description provided for @hangulS1L1Step5Desc.
  ///
  /// In zh, this message translates to:
  /// **'将辅音与ㅏ组合完成文字'**
  String get hangulS1L1Step5Desc;

  /// No description provided for @hangulS1L1Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'综合测验'**
  String get hangulS1L1Step6Title;

  /// No description provided for @hangulS1L1Step6Desc.
  ///
  /// In zh, this message translates to:
  /// **'整理本节课所学内容'**
  String get hangulS1L1Step6Desc;

  /// No description provided for @hangulS1L1Step6Q0.
  ///
  /// In zh, this message translates to:
  /// **'\"아\"的元音是什么？'**
  String get hangulS1L1Step6Q0;

  /// No description provided for @hangulS1L1Step6Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅏ = ?'**
  String get hangulS1L1Step6Q1;

  /// No description provided for @hangulS1L1Step6Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个字含有ㅏ？'**
  String get hangulS1L1Step6Q2;

  /// No description provided for @hangulS1L1Step6Q3.
  ///
  /// In zh, this message translates to:
  /// **'哪个音与ㅏ最不同？'**
  String get hangulS1L1Step6Q3;

  /// No description provided for @hangulS1L1Step7Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L1Step7Title;

  /// No description provided for @hangulS1L1Step7Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你学会了ㅏ的形状和读音。'**
  String get hangulS1L1Step7Msg;

  /// No description provided for @hangulS1L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅓ的形状与读音'**
  String get hangulS1L2Title;

  /// No description provided for @hangulS1L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'竖线左侧短横: ㅓ'**
  String get hangulS1L2Subtitle;

  /// No description provided for @hangulS1L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第二个元音ㅓ'**
  String get hangulS1L2Step0Title;

  /// No description provided for @hangulS1L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅓ发出\"어\"的音。\n注意笔画方向与ㅏ相反。'**
  String get hangulS1L2Step0Desc;

  /// No description provided for @hangulS1L2Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅓ,어,与ㅏ方向相反'**
  String get hangulS1L2Step0Highlights;

  /// No description provided for @hangulS1L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅓ的读音'**
  String get hangulS1L2Step1Title;

  /// No description provided for @hangulS1L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听含有ㅓ的读音'**
  String get hangulS1L2Step1Desc;

  /// No description provided for @hangulS1L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L2Step2Title;

  /// No description provided for @hangulS1L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读这些文字'**
  String get hangulS1L2Step2Desc;

  /// No description provided for @hangulS1L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅓ的读音'**
  String get hangulS1L2Step3Title;

  /// No description provided for @hangulS1L2Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'用耳朵区分ㅏ/ㅓ'**
  String get hangulS1L2Step3Desc;

  /// No description provided for @hangulS1L2Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'形状测验'**
  String get hangulS1L2Step4Title;

  /// No description provided for @hangulS1L2Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'找出ㅓ'**
  String get hangulS1L2Step4Desc;

  /// No description provided for @hangulS1L2Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅓ？'**
  String get hangulS1L2Step4Q0;

  /// No description provided for @hangulS1L2Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅓ = ?'**
  String get hangulS1L2Step4Q1;

  /// No description provided for @hangulS1L2Step4Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个字含有ㅓ？'**
  String get hangulS1L2Step4Q2;

  /// No description provided for @hangulS1L2Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅓ组字'**
  String get hangulS1L2Step5Title;

  /// No description provided for @hangulS1L2Step5Desc.
  ///
  /// In zh, this message translates to:
  /// **'将辅音与ㅓ组合'**
  String get hangulS1L2Step5Desc;

  /// No description provided for @hangulS1L2Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L2Step6Title;

  /// No description provided for @hangulS1L2Step6Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你学会了ㅓ(어)的读音。'**
  String get hangulS1L2Step6Msg;

  /// No description provided for @hangulS1L3Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ的形状与读音'**
  String get hangulS1L3Title;

  /// No description provided for @hangulS1L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'横线上方竖画: ㅗ'**
  String get hangulS1L3Subtitle;

  /// No description provided for @hangulS1L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第三个元音ㅗ'**
  String get hangulS1L3Step0Title;

  /// No description provided for @hangulS1L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ发出\"오\"的音。\n竖画向横线上方延伸。'**
  String get hangulS1L3Step0Desc;

  /// No description provided for @hangulS1L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ,오,横型元音'**
  String get hangulS1L3Step0Highlights;

  /// No description provided for @hangulS1L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅗ的读音'**
  String get hangulS1L3Step1Title;

  /// No description provided for @hangulS1L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听含有ㅗ的读音（오/고/노）'**
  String get hangulS1L3Step1Desc;

  /// No description provided for @hangulS1L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L3Step2Title;

  /// No description provided for @hangulS1L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读这些文字'**
  String get hangulS1L3Step2Desc;

  /// No description provided for @hangulS1L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅗ的读音'**
  String get hangulS1L3Step3Title;

  /// No description provided for @hangulS1L3Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分오/우的读音'**
  String get hangulS1L3Step3Desc;

  /// No description provided for @hangulS1L3Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅗ组字'**
  String get hangulS1L3Step4Title;

  /// No description provided for @hangulS1L3Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'将辅音与ㅗ组合'**
  String get hangulS1L3Step4Desc;

  /// No description provided for @hangulS1L3Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'形状与读音测验'**
  String get hangulS1L3Step5Title;

  /// No description provided for @hangulS1L3Step5Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确选出ㅗ'**
  String get hangulS1L3Step5Desc;

  /// No description provided for @hangulS1L3Step5Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅗ？'**
  String get hangulS1L3Step5Q0;

  /// No description provided for @hangulS1L3Step5Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅗ = ?'**
  String get hangulS1L3Step5Q1;

  /// No description provided for @hangulS1L3Step5Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个含有ㅗ？'**
  String get hangulS1L3Step5Q2;

  /// No description provided for @hangulS1L3Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L3Step6Title;

  /// No description provided for @hangulS1L3Step6Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你学会了ㅗ(오)的读音。'**
  String get hangulS1L3Step6Msg;

  /// No description provided for @hangulS1L4Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅜ的形状与读音'**
  String get hangulS1L4Title;

  /// No description provided for @hangulS1L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'横线下方竖画: ㅜ'**
  String get hangulS1L4Subtitle;

  /// No description provided for @hangulS1L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第四个元音ㅜ'**
  String get hangulS1L4Step0Title;

  /// No description provided for @hangulS1L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅜ发出\"우\"的音。\n竖画位置与ㅗ相反。'**
  String get hangulS1L4Step0Desc;

  /// No description provided for @hangulS1L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅜ,우,与ㅗ位置对比'**
  String get hangulS1L4Step0Highlights;

  /// No description provided for @hangulS1L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅜ的读音'**
  String get hangulS1L4Step1Title;

  /// No description provided for @hangulS1L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听우/구/누'**
  String get hangulS1L4Step1Desc;

  /// No description provided for @hangulS1L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L4Step2Title;

  /// No description provided for @hangulS1L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读这些文字'**
  String get hangulS1L4Step2Desc;

  /// No description provided for @hangulS1L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅜ的读音'**
  String get hangulS1L4Step3Title;

  /// No description provided for @hangulS1L4Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分ㅗ/ㅜ'**
  String get hangulS1L4Step3Desc;

  /// No description provided for @hangulS1L4Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅜ组字'**
  String get hangulS1L4Step4Title;

  /// No description provided for @hangulS1L4Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'将辅音与ㅜ组合'**
  String get hangulS1L4Step4Desc;

  /// No description provided for @hangulS1L4Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'形状与读音测验'**
  String get hangulS1L4Step5Title;

  /// No description provided for @hangulS1L4Step5Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确选出ㅜ'**
  String get hangulS1L4Step5Desc;

  /// No description provided for @hangulS1L4Step5Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅜ？'**
  String get hangulS1L4Step5Q0;

  /// No description provided for @hangulS1L4Step5Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅜ = ?'**
  String get hangulS1L4Step5Q1;

  /// No description provided for @hangulS1L4Step5Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个含有ㅜ？'**
  String get hangulS1L4Step5Q2;

  /// No description provided for @hangulS1L4Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L4Step6Title;

  /// No description provided for @hangulS1L4Step6Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你学会了ㅜ(우)的读音。'**
  String get hangulS1L4Step6Msg;

  /// No description provided for @hangulS1L5Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅡ的形状与读音'**
  String get hangulS1L5Title;

  /// No description provided for @hangulS1L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'单横线元音: ㅡ'**
  String get hangulS1L5Subtitle;

  /// No description provided for @hangulS1L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第五个元音ㅡ'**
  String get hangulS1L5Step0Title;

  /// No description provided for @hangulS1L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅡ是嘴巴横向拉伸发出的音。\n形状是一条横线。'**
  String get hangulS1L5Step0Desc;

  /// No description provided for @hangulS1L5Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅡ,으,单横线'**
  String get hangulS1L5Step0Highlights;

  /// No description provided for @hangulS1L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅡ的读音'**
  String get hangulS1L5Step1Title;

  /// No description provided for @hangulS1L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听으/그/느的读音'**
  String get hangulS1L5Step1Desc;

  /// No description provided for @hangulS1L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L5Step2Title;

  /// No description provided for @hangulS1L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读这些文字'**
  String get hangulS1L5Step2Desc;

  /// No description provided for @hangulS1L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅡ的读音'**
  String get hangulS1L5Step3Title;

  /// No description provided for @hangulS1L5Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分ㅡ和ㅜ的读音'**
  String get hangulS1L5Step3Desc;

  /// No description provided for @hangulS1L5Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅡ组字'**
  String get hangulS1L5Step4Title;

  /// No description provided for @hangulS1L5Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'将辅音与ㅡ组合'**
  String get hangulS1L5Step4Desc;

  /// No description provided for @hangulS1L5Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'形状与读音测验'**
  String get hangulS1L5Step5Title;

  /// No description provided for @hangulS1L5Step5Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确选出ㅡ'**
  String get hangulS1L5Step5Desc;

  /// No description provided for @hangulS1L5Step5Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅡ？'**
  String get hangulS1L5Step5Q0;

  /// No description provided for @hangulS1L5Step5Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅡ = ?'**
  String get hangulS1L5Step5Q1;

  /// No description provided for @hangulS1L5Step5Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个含有ㅡ？'**
  String get hangulS1L5Step5Q2;

  /// No description provided for @hangulS1L5Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L5Step6Title;

  /// No description provided for @hangulS1L5Step6Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你学会了ㅡ(으)的读音。'**
  String get hangulS1L5Step6Msg;

  /// No description provided for @hangulS1L6Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅣ的形状与读音'**
  String get hangulS1L6Title;

  /// No description provided for @hangulS1L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'单竖线元音: ㅣ'**
  String get hangulS1L6Subtitle;

  /// No description provided for @hangulS1L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第六个元音ㅣ'**
  String get hangulS1L6Step0Title;

  /// No description provided for @hangulS1L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅣ发出\"이\"的音。\n形状是一条竖线。'**
  String get hangulS1L6Step0Desc;

  /// No description provided for @hangulS1L6Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅣ,이,单竖线'**
  String get hangulS1L6Step0Highlights;

  /// No description provided for @hangulS1L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅣ的读音'**
  String get hangulS1L6Step1Title;

  /// No description provided for @hangulS1L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听이/기/니的读音'**
  String get hangulS1L6Step1Desc;

  /// No description provided for @hangulS1L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L6Step2Title;

  /// No description provided for @hangulS1L6Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读这些文字'**
  String get hangulS1L6Step2Desc;

  /// No description provided for @hangulS1L6Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅣ的读音'**
  String get hangulS1L6Step3Title;

  /// No description provided for @hangulS1L6Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分ㅣ和ㅡ的读音'**
  String get hangulS1L6Step3Desc;

  /// No description provided for @hangulS1L6Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅣ组字'**
  String get hangulS1L6Step4Title;

  /// No description provided for @hangulS1L6Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'将辅音与ㅣ组合'**
  String get hangulS1L6Step4Desc;

  /// No description provided for @hangulS1L6Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'形状与读音测验'**
  String get hangulS1L6Step5Title;

  /// No description provided for @hangulS1L6Step5Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确选出ㅣ'**
  String get hangulS1L6Step5Desc;

  /// No description provided for @hangulS1L6Step5Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅣ？'**
  String get hangulS1L6Step5Q0;

  /// No description provided for @hangulS1L6Step5Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅣ = ?'**
  String get hangulS1L6Step5Q1;

  /// No description provided for @hangulS1L6Step5Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个含有ㅣ？'**
  String get hangulS1L6Step5Q2;

  /// No description provided for @hangulS1L6Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L6Step6Title;

  /// No description provided for @hangulS1L6Step6Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你学会了ㅣ(이)的读音。'**
  String get hangulS1L6Step6Msg;

  /// No description provided for @hangulS1L7Title.
  ///
  /// In zh, this message translates to:
  /// **'竖向元音区分'**
  String get hangulS1L7Title;

  /// No description provided for @hangulS1L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'快速区分 ㅏ · ㅓ · ㅣ'**
  String get hangulS1L7Subtitle;

  /// No description provided for @hangulS1L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'竖向元音组复习'**
  String get hangulS1L7Step0Title;

  /// No description provided for @hangulS1L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ、ㅓ、ㅣ 是竖轴元音。\n一起区分笔画位置和发音。'**
  String get hangulS1L7Step0Desc;

  /// No description provided for @hangulS1L7Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ,ㅓ,ㅣ,竖向元音'**
  String get hangulS1L7Step0Highlights;

  /// No description provided for @hangulS1L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'再听一遍'**
  String get hangulS1L7Step1Title;

  /// No description provided for @hangulS1L7Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'确认 아/어/이 的发音'**
  String get hangulS1L7Step1Desc;

  /// No description provided for @hangulS1L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L7Step2Title;

  /// No description provided for @hangulS1L7Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读每个文字'**
  String get hangulS1L7Step2Desc;

  /// No description provided for @hangulS1L7Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'竖向元音听力测验'**
  String get hangulS1L7Step3Title;

  /// No description provided for @hangulS1L7Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'将声音与正确文字对应'**
  String get hangulS1L7Step3Desc;

  /// No description provided for @hangulS1L7Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'竖向元音形状测验'**
  String get hangulS1L7Step4Title;

  /// No description provided for @hangulS1L7Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'精确区分各自的形状'**
  String get hangulS1L7Step4Desc;

  /// No description provided for @hangulS1L7Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'右侧有短笔画的是？'**
  String get hangulS1L7Step4Q0;

  /// No description provided for @hangulS1L7Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'左侧有短笔画的是？'**
  String get hangulS1L7Step4Q1;

  /// No description provided for @hangulS1L7Step4Q2.
  ///
  /// In zh, this message translates to:
  /// **'单竖线是？'**
  String get hangulS1L7Step4Q2;

  /// No description provided for @hangulS1L7Step4Q3.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ + ㅓ = ?'**
  String get hangulS1L7Step4Q3;

  /// No description provided for @hangulS1L7Step4Q4.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅣ = ?'**
  String get hangulS1L7Step4Q4;

  /// No description provided for @hangulS1L7Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L7Step5Title;

  /// No description provided for @hangulS1L7Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n竖向元音（ㅏ/ㅓ/ㅣ）的区分已经稳固了。'**
  String get hangulS1L7Step5Msg;

  /// No description provided for @hangulS1L8Title.
  ///
  /// In zh, this message translates to:
  /// **'横向元音区分'**
  String get hangulS1L8Title;

  /// No description provided for @hangulS1L8Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'快速区分 ㅗ · ㅜ · ㅡ'**
  String get hangulS1L8Subtitle;

  /// No description provided for @hangulS1L8Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'横向元音组复习'**
  String get hangulS1L8Step0Title;

  /// No description provided for @hangulS1L8Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ、ㅜ、ㅡ 是以横轴为中心的元音。\n一起记住竖画位置和嘴型。'**
  String get hangulS1L8Step0Desc;

  /// No description provided for @hangulS1L8Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ,ㅜ,ㅡ,横向元音'**
  String get hangulS1L8Step0Highlights;

  /// No description provided for @hangulS1L8Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'再听一遍'**
  String get hangulS1L8Step1Title;

  /// No description provided for @hangulS1L8Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'确认 오/우/으 的发音'**
  String get hangulS1L8Step1Desc;

  /// No description provided for @hangulS1L8Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L8Step2Title;

  /// No description provided for @hangulS1L8Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读每个文字'**
  String get hangulS1L8Step2Desc;

  /// No description provided for @hangulS1L8Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'横向元音听力测验'**
  String get hangulS1L8Step3Title;

  /// No description provided for @hangulS1L8Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'将声音与正确文字对应'**
  String get hangulS1L8Step3Desc;

  /// No description provided for @hangulS1L8Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'横向元音形状测验'**
  String get hangulS1L8Step4Title;

  /// No description provided for @hangulS1L8Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'一起检查形状和发音'**
  String get hangulS1L8Step4Desc;

  /// No description provided for @hangulS1L8Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'竖画在横线上方的是？'**
  String get hangulS1L8Step4Q0;

  /// No description provided for @hangulS1L8Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'竖画在横线下方的是？'**
  String get hangulS1L8Step4Q1;

  /// No description provided for @hangulS1L8Step4Q2.
  ///
  /// In zh, this message translates to:
  /// **'单横线是？'**
  String get hangulS1L8Step4Q2;

  /// No description provided for @hangulS1L8Step4Q3.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅗ = ?'**
  String get hangulS1L8Step4Q3;

  /// No description provided for @hangulS1L8Step4Q4.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ + ㅜ = ?'**
  String get hangulS1L8Step4Q4;

  /// No description provided for @hangulS1L8Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS1L8Step5Title;

  /// No description provided for @hangulS1L8Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n横向元音（ㅗ/ㅜ/ㅡ）的区分已经稳固了。'**
  String get hangulS1L8Step5Msg;

  /// No description provided for @hangulS1L9Title.
  ///
  /// In zh, this message translates to:
  /// **'基本元音任务'**
  String get hangulS1L9Title;

  /// No description provided for @hangulS1L9Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'在时间限制内完成元音组合'**
  String get hangulS1L9Subtitle;

  /// No description provided for @hangulS1L9Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第1阶段最终任务'**
  String get hangulS1L9Step0Title;

  /// No description provided for @hangulS1L9Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'在限定时间内完成文字组合。\n以准确率和速度获得柠檬奖励！'**
  String get hangulS1L9Step0Desc;

  /// No description provided for @hangulS1L9Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'限时任务'**
  String get hangulS1L9Step1Title;

  /// No description provided for @hangulS1L9Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS1L9Step2Title;

  /// No description provided for @hangulS1L9Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'第1阶段完成！'**
  String get hangulS1L9Step3Title;

  /// No description provided for @hangulS1L9Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n第1阶段的基本元音全部完成了。'**
  String get hangulS1L9Step3Msg;

  /// No description provided for @hangulS1L10Title.
  ///
  /// In zh, this message translates to:
  /// **'第一批韩语单词！'**
  String get hangulS1L10Title;

  /// No description provided for @hangulS1L10Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'用学过的文字阅读真实单词'**
  String get hangulS1L10Subtitle;

  /// No description provided for @hangulS1L10Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'现在可以读单词了！'**
  String get hangulS1L10Step0Title;

  /// No description provided for @hangulS1L10Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'学会了元音和基本辅音，\n来读一读真实的韩语单词吧？'**
  String get hangulS1L10Step0Desc;

  /// No description provided for @hangulS1L10Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'真实单词,阅读挑战'**
  String get hangulS1L10Step0Highlights;

  /// No description provided for @hangulS1L10Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'阅读第一批单词'**
  String get hangulS1L10Step1Title;

  /// No description provided for @hangulS1L10Step1Descs.
  ///
  /// In zh, this message translates to:
  /// **'孩子,牛奶,黄瓜,这/牙齿,弟弟'**
  String get hangulS1L10Step1Descs;

  /// No description provided for @hangulS1L10Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS1L10Step2Title;

  /// No description provided for @hangulS1L10Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声朗读每个文字'**
  String get hangulS1L10Step2Desc;

  /// No description provided for @hangulS1L10Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听一听，选一选'**
  String get hangulS1L10Step3Title;

  /// No description provided for @hangulS1L10Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get hangulS1L10Step4Title;

  /// No description provided for @hangulS1L10Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'你读出了韩语单词！\n再学更多辅音，\n就能读更多单词了。'**
  String get hangulS1L10Step4Msg;

  /// No description provided for @hangulS1CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第1阶段完成！'**
  String get hangulS1CompleteTitle;

  /// No description provided for @hangulS1CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已掌握全部6个基本元音！'**
  String get hangulS1CompleteMsg;

  /// No description provided for @hangulS2L1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅑ的形状与发音'**
  String get hangulS2L1Title;

  /// No description provided for @hangulS2L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ加一笔: ㅑ'**
  String get hangulS2L1Subtitle;

  /// No description provided for @hangulS2L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ变成ㅑ'**
  String get hangulS2L1Step0Title;

  /// No description provided for @hangulS2L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'在ㅏ上加一笔就得到ㅑ。\n发音从\"啊\"变成更有弹性的\"呀\"。'**
  String get hangulS2L1Step0Desc;

  /// No description provided for @hangulS2L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ → ㅑ,야,Y元音'**
  String get hangulS2L1Step0Highlights;

  /// No description provided for @hangulS2L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅑ的发音'**
  String get hangulS2L1Step1Title;

  /// No description provided for @hangulS2L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听야/갸/냐的发音'**
  String get hangulS2L1Step1Desc;

  /// No description provided for @hangulS2L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS2L1Step2Title;

  /// No description provided for @hangulS2L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS2L1Step2Desc;

  /// No description provided for @hangulS2L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听辨ㅏ vs ㅑ'**
  String get hangulS2L1Step3Title;

  /// No description provided for @hangulS2L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分相似的发音'**
  String get hangulS2L1Step3Desc;

  /// No description provided for @hangulS2L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅑ组成音节'**
  String get hangulS2L1Step4Title;

  /// No description provided for @hangulS2L1Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'完成辅音 + ㅑ 的组合'**
  String get hangulS2L1Step4Desc;

  /// No description provided for @hangulS2L1Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'形状与发音测验'**
  String get hangulS2L1Step5Title;

  /// No description provided for @hangulS2L1Step5Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确选出ㅑ'**
  String get hangulS2L1Step5Desc;

  /// No description provided for @hangulS2L1Step5Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅑ？'**
  String get hangulS2L1Step5Q0;

  /// No description provided for @hangulS2L1Step5Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅑ = ?'**
  String get hangulS2L1Step5Q1;

  /// No description provided for @hangulS2L1Step5Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个含有ㅑ？'**
  String get hangulS2L1Step5Q2;

  /// No description provided for @hangulS2L1Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS2L1Step6Title;

  /// No description provided for @hangulS2L1Step6Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已掌握ㅑ（야）的发音。'**
  String get hangulS2L1Step6Msg;

  /// No description provided for @hangulS2L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅕ的形状与发音'**
  String get hangulS2L2Title;

  /// No description provided for @hangulS2L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅓ加一笔: ㅕ'**
  String get hangulS2L2Subtitle;

  /// No description provided for @hangulS2L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅓ变成ㅕ'**
  String get hangulS2L2Step0Title;

  /// No description provided for @hangulS2L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'在ㅓ上加一笔就得到ㅕ。\n发音从\"呃\"变成\"耶\"。'**
  String get hangulS2L2Step0Desc;

  /// No description provided for @hangulS2L2Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅓ → ㅕ,여,Y元音'**
  String get hangulS2L2Step0Highlights;

  /// No description provided for @hangulS2L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅕ的发音'**
  String get hangulS2L2Step1Title;

  /// No description provided for @hangulS2L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听여/겨/녀的发音'**
  String get hangulS2L2Step1Desc;

  /// No description provided for @hangulS2L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS2L2Step2Title;

  /// No description provided for @hangulS2L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS2L2Step2Desc;

  /// No description provided for @hangulS2L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听辨ㅓ vs ㅕ'**
  String get hangulS2L2Step3Title;

  /// No description provided for @hangulS2L2Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分어和여'**
  String get hangulS2L2Step3Desc;

  /// No description provided for @hangulS2L2Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅕ组成音节'**
  String get hangulS2L2Step4Title;

  /// No description provided for @hangulS2L2Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'完成辅音 + ㅕ 的组合'**
  String get hangulS2L2Step4Desc;

  /// No description provided for @hangulS2L2Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS2L2Step5Title;

  /// No description provided for @hangulS2L2Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已掌握ㅕ（여）的发音。'**
  String get hangulS2L2Step5Msg;

  /// No description provided for @hangulS2L3Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅛ的形状与发音'**
  String get hangulS2L3Title;

  /// No description provided for @hangulS2L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ加一笔: ㅛ'**
  String get hangulS2L3Subtitle;

  /// No description provided for @hangulS2L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ变成ㅛ'**
  String get hangulS2L3Step0Title;

  /// No description provided for @hangulS2L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'在ㅗ上加一笔就得到ㅛ。\n发音从\"哦\"变成\"哟\"。'**
  String get hangulS2L3Step0Desc;

  /// No description provided for @hangulS2L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅗ → ㅛ,요,Y元音'**
  String get hangulS2L3Step0Highlights;

  /// No description provided for @hangulS2L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅛ的发音'**
  String get hangulS2L3Step1Title;

  /// No description provided for @hangulS2L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听요/교/뇨的发音'**
  String get hangulS2L3Step1Desc;

  /// No description provided for @hangulS2L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS2L3Step2Title;

  /// No description provided for @hangulS2L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS2L3Step2Desc;

  /// No description provided for @hangulS2L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听辨ㅗ vs ㅛ'**
  String get hangulS2L3Step3Title;

  /// No description provided for @hangulS2L3Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分오和요'**
  String get hangulS2L3Step3Desc;

  /// No description provided for @hangulS2L3Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅛ组成音节'**
  String get hangulS2L3Step4Title;

  /// No description provided for @hangulS2L3Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'完成辅音 + ㅛ 的组合'**
  String get hangulS2L3Step4Desc;

  /// No description provided for @hangulS2L3Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS2L3Step5Title;

  /// No description provided for @hangulS2L3Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已掌握ㅛ（요）的发音。'**
  String get hangulS2L3Step5Msg;

  /// No description provided for @hangulS2L4Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅠ的形状与发音'**
  String get hangulS2L4Title;

  /// No description provided for @hangulS2L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅜ加一笔: ㅠ'**
  String get hangulS2L4Subtitle;

  /// No description provided for @hangulS2L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅜ变成ㅠ'**
  String get hangulS2L4Step0Title;

  /// No description provided for @hangulS2L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'在ㅜ上加一笔就得到ㅠ。\n发音从\"呜\"变成\"鱼\"。'**
  String get hangulS2L4Step0Desc;

  /// No description provided for @hangulS2L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅜ → ㅠ,유,Y元音'**
  String get hangulS2L4Step0Highlights;

  /// No description provided for @hangulS2L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅠ的发音'**
  String get hangulS2L4Step1Title;

  /// No description provided for @hangulS2L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听유/규/뉴的发音'**
  String get hangulS2L4Step1Desc;

  /// No description provided for @hangulS2L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS2L4Step2Title;

  /// No description provided for @hangulS2L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS2L4Step2Desc;

  /// No description provided for @hangulS2L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听辨ㅜ vs ㅠ'**
  String get hangulS2L4Step3Title;

  /// No description provided for @hangulS2L4Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分우和유'**
  String get hangulS2L4Step3Desc;

  /// No description provided for @hangulS2L4Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅠ组成音节'**
  String get hangulS2L4Step4Title;

  /// No description provided for @hangulS2L4Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'完成辅音 + ㅠ 的组合'**
  String get hangulS2L4Step4Desc;

  /// No description provided for @hangulS2L4Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS2L4Step5Title;

  /// No description provided for @hangulS2L4Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已掌握ㅠ（유）的发音。'**
  String get hangulS2L4Step5Msg;

  /// No description provided for @hangulS2L5Title.
  ///
  /// In zh, this message translates to:
  /// **'Y元音组合训练'**
  String get hangulS2L5Title;

  /// No description provided for @hangulS2L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅑ · ㅕ · ㅛ · ㅠ 强化训练'**
  String get hangulS2L5Subtitle;

  /// No description provided for @hangulS2L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'一次看清所有Y元音'**
  String get hangulS2L5Step0Title;

  /// No description provided for @hangulS2L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅑ/ㅕ/ㅛ/ㅠ是基础元音加一笔的元音。\n快速区分它们的形状和发音。'**
  String get hangulS2L5Step0Desc;

  /// No description provided for @hangulS2L5Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅑ,ㅕ,ㅛ,ㅠ'**
  String get hangulS2L5Step0Highlights;

  /// No description provided for @hangulS2L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'再听四个发音'**
  String get hangulS2L5Step1Title;

  /// No description provided for @hangulS2L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'复习야/여/요/유的发音'**
  String get hangulS2L5Step1Desc;

  /// No description provided for @hangulS2L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS2L5Step2Title;

  /// No description provided for @hangulS2L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS2L5Step2Desc;

  /// No description provided for @hangulS2L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'发音辨别测验'**
  String get hangulS2L5Step3Title;

  /// No description provided for @hangulS2L5Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分Y元音的发音'**
  String get hangulS2L5Step3Desc;

  /// No description provided for @hangulS2L5Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'形状辨别测验'**
  String get hangulS2L5Step4Title;

  /// No description provided for @hangulS2L5Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确区分形状'**
  String get hangulS2L5Step4Desc;

  /// No description provided for @hangulS2L5Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅑ？'**
  String get hangulS2L5Step4Q0;

  /// No description provided for @hangulS2L5Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅕ？'**
  String get hangulS2L5Step4Q1;

  /// No description provided for @hangulS2L5Step4Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅛ？'**
  String get hangulS2L5Step4Q2;

  /// No description provided for @hangulS2L5Step4Q3.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个是ㅠ？'**
  String get hangulS2L5Step4Q3;

  /// No description provided for @hangulS2L5Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS2L5Step5Title;

  /// No description provided for @hangulS2L5Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你对4个Y元音的区分越来越好了。'**
  String get hangulS2L5Step5Msg;

  /// No description provided for @hangulS2L6Title.
  ///
  /// In zh, this message translates to:
  /// **'基础元音 vs Y元音对比'**
  String get hangulS2L6Title;

  /// No description provided for @hangulS2L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ'**
  String get hangulS2L6Subtitle;

  /// No description provided for @hangulS2L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'整理容易混淆的配对'**
  String get hangulS2L6Step0Title;

  /// No description provided for @hangulS2L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'将基础元音和Y元音配对比较。'**
  String get hangulS2L6Step0Desc;

  /// No description provided for @hangulS2L6Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅏ/ㅑ,ㅓ/ㅕ,ㅗ/ㅛ,ㅜ/ㅠ'**
  String get hangulS2L6Step0Highlights;

  /// No description provided for @hangulS2L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'配对发音辨别'**
  String get hangulS2L6Step1Title;

  /// No description provided for @hangulS2L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'从相似的发音中选出正确答案'**
  String get hangulS2L6Step1Desc;

  /// No description provided for @hangulS2L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'配对形状辨别'**
  String get hangulS2L6Step2Title;

  /// No description provided for @hangulS2L6Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'判断是否有额外的一笔'**
  String get hangulS2L6Step2Desc;

  /// No description provided for @hangulS2L6Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个元音加了一笔？'**
  String get hangulS2L6Step2Q0;

  /// No description provided for @hangulS2L6Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个元音加了一笔？'**
  String get hangulS2L6Step2Q1;

  /// No description provided for @hangulS2L6Step2Q2.
  ///
  /// In zh, this message translates to:
  /// **'哪个元音加了一笔？'**
  String get hangulS2L6Step2Q2;

  /// No description provided for @hangulS2L6Step2Q3.
  ///
  /// In zh, this message translates to:
  /// **'哪个元音加了一笔？'**
  String get hangulS2L6Step2Q3;

  /// No description provided for @hangulS2L6Step2Q4.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅠ = ?'**
  String get hangulS2L6Step2Q4;

  /// No description provided for @hangulS2L6Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS2L6Step3Title;

  /// No description provided for @hangulS2L6Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n基础元音/Y元音对比已经稳定了。'**
  String get hangulS2L6Step3Msg;

  /// No description provided for @hangulS2L7Title.
  ///
  /// In zh, this message translates to:
  /// **'Y元音任务'**
  String get hangulS2L7Title;

  /// No description provided for @hangulS2L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'在限时内完成Y元音组合'**
  String get hangulS2L7Subtitle;

  /// No description provided for @hangulS2L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第2阶段最终任务'**
  String get hangulS2L7Step0Title;

  /// No description provided for @hangulS2L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'快速准确地完成Y元音组合。\n完成数和时间决定你的柠檬奖励。'**
  String get hangulS2L7Step0Desc;

  /// No description provided for @hangulS2L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'限时任务'**
  String get hangulS2L7Step1Title;

  /// No description provided for @hangulS2L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS2L7Step2Title;

  /// No description provided for @hangulS2L7Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'第2阶段完成！'**
  String get hangulS2L7Step3Title;

  /// No description provided for @hangulS2L7Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你已完成第2阶段所有Y元音。'**
  String get hangulS2L7Step3Msg;

  /// No description provided for @hangulS2CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第2阶段完成！'**
  String get hangulS2CompleteTitle;

  /// No description provided for @hangulS2CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已征服Y元音！'**
  String get hangulS2CompleteMsg;

  /// No description provided for @hangulS3L1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ的形状和发音'**
  String get hangulS3L1Title;

  /// No description provided for @hangulS3L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'感受ㅏ + ㅣ的组合感觉'**
  String get hangulS3L1Subtitle;

  /// No description provided for @hangulS3L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ是这个样子'**
  String get hangulS3L1Step0Title;

  /// No description provided for @hangulS3L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ是从ㅏ系列派生的元音。\n以\"애\"为代表音来记忆。'**
  String get hangulS3L1Step0Desc;

  /// No description provided for @hangulS3L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ,애,形状识别'**
  String get hangulS3L1Step0Highlights;

  /// No description provided for @hangulS3L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅐ的发音'**
  String get hangulS3L1Step1Title;

  /// No description provided for @hangulS3L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听애/개/내的发音'**
  String get hangulS3L1Step1Desc;

  /// No description provided for @hangulS3L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS3L1Step2Title;

  /// No description provided for @hangulS3L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请直接把文字发出声来'**
  String get hangulS3L1Step2Desc;

  /// No description provided for @hangulS3L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听辨ㅏ vs ㅐ'**
  String get hangulS3L1Step3Title;

  /// No description provided for @hangulS3L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分아/애'**
  String get hangulS3L1Step3Desc;

  /// No description provided for @hangulS3L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS3L1Step4Title;

  /// No description provided for @hangulS3L1Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n已掌握ㅐ(애)的形状和发音。'**
  String get hangulS3L1Step4Msg;

  /// No description provided for @hangulS3L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅔ的形状和发音'**
  String get hangulS3L2Title;

  /// No description provided for @hangulS3L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'感受ㅓ + ㅣ的组合感觉'**
  String get hangulS3L2Subtitle;

  /// No description provided for @hangulS3L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅔ是这个样子'**
  String get hangulS3L2Step0Title;

  /// No description provided for @hangulS3L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅔ是从ㅓ系列派生的元音。\n以\"에\"为代表音来记忆。'**
  String get hangulS3L2Step0Desc;

  /// No description provided for @hangulS3L2Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅔ,에,形状识别'**
  String get hangulS3L2Step0Highlights;

  /// No description provided for @hangulS3L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅔ的发音'**
  String get hangulS3L2Step1Title;

  /// No description provided for @hangulS3L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听에/게/네的发音'**
  String get hangulS3L2Step1Desc;

  /// No description provided for @hangulS3L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS3L2Step2Title;

  /// No description provided for @hangulS3L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请直接把文字发出声来'**
  String get hangulS3L2Step2Desc;

  /// No description provided for @hangulS3L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听辨ㅓ vs ㅔ'**
  String get hangulS3L2Step3Title;

  /// No description provided for @hangulS3L2Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分어/에'**
  String get hangulS3L2Step3Desc;

  /// No description provided for @hangulS3L2Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS3L2Step4Title;

  /// No description provided for @hangulS3L2Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n已掌握ㅔ(에)的形状和发音。'**
  String get hangulS3L2Step4Msg;

  /// No description provided for @hangulS3L3Title.
  ///
  /// In zh, this message translates to:
  /// **'区分ㅐ vs ㅔ'**
  String get hangulS3L3Title;

  /// No description provided for @hangulS3L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'以形状为中心的区分训练'**
  String get hangulS3L3Subtitle;

  /// No description provided for @hangulS3L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'关键在于区分形状'**
  String get hangulS3L3Step0Title;

  /// No description provided for @hangulS3L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'在初级阶段，ㅐ/ㅔ听起来可能很相似。\n所以先准确区分它们的形状。'**
  String get hangulS3L3Step0Desc;

  /// No description provided for @hangulS3L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ,ㅔ,形状区分'**
  String get hangulS3L3Step0Highlights;

  /// No description provided for @hangulS3L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'形状区分测验'**
  String get hangulS3L3Step1Title;

  /// No description provided for @hangulS3L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'准确选择ㅐ和ㅔ'**
  String get hangulS3L3Step1Desc;

  /// No description provided for @hangulS3L3Step1Q0.
  ///
  /// In zh, this message translates to:
  /// **'下列哪个是ㅐ？'**
  String get hangulS3L3Step1Q0;

  /// No description provided for @hangulS3L3Step1Q1.
  ///
  /// In zh, this message translates to:
  /// **'下列哪个是ㅔ？'**
  String get hangulS3L3Step1Q1;

  /// No description provided for @hangulS3L3Step1Q2.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅐ = ?'**
  String get hangulS3L3Step1Q2;

  /// No description provided for @hangulS3L3Step1Q3.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅔ = ?'**
  String get hangulS3L3Step1Q3;

  /// No description provided for @hangulS3L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS3L3Step2Title;

  /// No description provided for @hangulS3L3Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\nㅐ/ㅔ的区分更准确了。'**
  String get hangulS3L3Step2Msg;

  /// No description provided for @hangulS3L4Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅒ的形状和发音'**
  String get hangulS3L4Title;

  /// No description provided for @hangulS3L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'Y-ㅐ系列元音'**
  String get hangulS3L4Subtitle;

  /// No description provided for @hangulS3L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㅒ吧'**
  String get hangulS3L4Step0Title;

  /// No description provided for @hangulS3L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅒ是ㅐ系列的Y元音。\n代表音是\"얘\"。'**
  String get hangulS3L4Step0Desc;

  /// No description provided for @hangulS3L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅒ,얘'**
  String get hangulS3L4Step0Highlights;

  /// No description provided for @hangulS3L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅒ的发音'**
  String get hangulS3L4Step1Title;

  /// No description provided for @hangulS3L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听얘/걔/냬的发音'**
  String get hangulS3L4Step1Desc;

  /// No description provided for @hangulS3L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS3L4Step2Title;

  /// No description provided for @hangulS3L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请直接把文字发出声来'**
  String get hangulS3L4Step2Desc;

  /// No description provided for @hangulS3L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS3L4Step3Title;

  /// No description provided for @hangulS3L4Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n已掌握ㅒ(얘)的形状。'**
  String get hangulS3L4Step3Msg;

  /// No description provided for @hangulS3L5Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅖ的形状和发音'**
  String get hangulS3L5Title;

  /// No description provided for @hangulS3L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'Y-ㅔ系列元音'**
  String get hangulS3L5Subtitle;

  /// No description provided for @hangulS3L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㅖ吧'**
  String get hangulS3L5Step0Title;

  /// No description provided for @hangulS3L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅖ是ㅔ系列的Y元音。\n代表音是\"예\"。'**
  String get hangulS3L5Step0Desc;

  /// No description provided for @hangulS3L5Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅖ,예'**
  String get hangulS3L5Step0Highlights;

  /// No description provided for @hangulS3L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅖ的发音'**
  String get hangulS3L5Step1Title;

  /// No description provided for @hangulS3L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听예/계/녜的发音'**
  String get hangulS3L5Step1Desc;

  /// No description provided for @hangulS3L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS3L5Step2Title;

  /// No description provided for @hangulS3L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请直接把文字发出声来'**
  String get hangulS3L5Step2Desc;

  /// No description provided for @hangulS3L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS3L5Step3Title;

  /// No description provided for @hangulS3L5Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n已掌握ㅖ(예)的形状。'**
  String get hangulS3L5Step3Msg;

  /// No description provided for @hangulS3L6Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ/ㅔ系列综合复习'**
  String get hangulS3L6Title;

  /// No description provided for @hangulS3L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ ㅔ ㅒ ㅖ综合检验'**
  String get hangulS3L6Subtitle;

  /// No description provided for @hangulS3L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'一次性区分四种'**
  String get hangulS3L6Step0Title;

  /// No description provided for @hangulS3L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'同时用形状和发音来检验ㅐ/ㅔ/ㅒ/ㅖ。'**
  String get hangulS3L6Step0Desc;

  /// No description provided for @hangulS3L6Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅐ,ㅔ,ㅒ,ㅖ'**
  String get hangulS3L6Step0Highlights;

  /// No description provided for @hangulS3L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'声音区分'**
  String get hangulS3L6Step1Title;

  /// No description provided for @hangulS3L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'从相似的声音中选出正确答案'**
  String get hangulS3L6Step1Desc;

  /// No description provided for @hangulS3L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'形状区分'**
  String get hangulS3L6Step2Title;

  /// No description provided for @hangulS3L6Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'看形状，快速选择'**
  String get hangulS3L6Step2Desc;

  /// No description provided for @hangulS3L6Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'下列哪个属于Y-ㅐ系列？'**
  String get hangulS3L6Step2Q0;

  /// No description provided for @hangulS3L6Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'下列哪个属于Y-ㅔ系列？'**
  String get hangulS3L6Step2Q1;

  /// No description provided for @hangulS3L6Step2Q2.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅖ = ?'**
  String get hangulS3L6Step2Q2;

  /// No description provided for @hangulS3L6Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS3L6Step3Title;

  /// No description provided for @hangulS3L6Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n第3阶段核心元音的区分已经稳固了。'**
  String get hangulS3L6Step3Msg;

  /// No description provided for @hangulS3L7Title.
  ///
  /// In zh, this message translates to:
  /// **'第3阶段任务'**
  String get hangulS3L7Title;

  /// No description provided for @hangulS3L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'快速区分任务：ㅐ/ㅔ系列'**
  String get hangulS3L7Subtitle;

  /// No description provided for @hangulS3L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第3阶段最终任务'**
  String get hangulS3L7Step0Title;

  /// No description provided for @hangulS3L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'快速准确地完成ㅐ/ㅔ系列的组合。'**
  String get hangulS3L7Step0Desc;

  /// No description provided for @hangulS3L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'限时任务'**
  String get hangulS3L7Step1Title;

  /// No description provided for @hangulS3L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS3L7Step2Title;

  /// No description provided for @hangulS3L7Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'第3阶段完成！'**
  String get hangulS3L7Step3Title;

  /// No description provided for @hangulS3L7Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n已完成第3阶段全部ㅐ/ㅔ系列元音。'**
  String get hangulS3L7Step3Msg;

  /// No description provided for @hangulS3L7Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'第3阶段完成！'**
  String get hangulS3L7Step4Title;

  /// No description provided for @hangulS3L7Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'已学完所有元音！'**
  String get hangulS3L7Step4Msg;

  /// No description provided for @hangulS3CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第3阶段完成！'**
  String get hangulS3CompleteTitle;

  /// No description provided for @hangulS3CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'已学完所有元音！'**
  String get hangulS3CompleteMsg;

  /// No description provided for @hangulS4L1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ的形状与发音'**
  String get hangulS4L1Title;

  /// No description provided for @hangulS4L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'基本辅音的开始：ㄱ'**
  String get hangulS4L1Subtitle;

  /// No description provided for @hangulS4L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㄱ吧'**
  String get hangulS4L1Step0Title;

  /// No description provided for @hangulS4L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ是基本辅音的开始。\n与ㅏ组合发出「가」的音。'**
  String get hangulS4L1Step0Desc;

  /// No description provided for @hangulS4L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ,가,基本辅音'**
  String get hangulS4L1Step0Highlights;

  /// No description provided for @hangulS4L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㄱ的发音'**
  String get hangulS4L1Step1Title;

  /// No description provided for @hangulS4L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听가/고/구的发音'**
  String get hangulS4L1Step1Desc;

  /// No description provided for @hangulS4L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L1Step2Title;

  /// No description provided for @hangulS4L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L1Step2Desc;

  /// No description provided for @hangulS4L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㄱ的发音'**
  String get hangulS4L1Step3Title;

  /// No description provided for @hangulS4L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'听音选出正确的字'**
  String get hangulS4L1Step3Desc;

  /// No description provided for @hangulS4L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㄱ组合文字'**
  String get hangulS4L1Step4Title;

  /// No description provided for @hangulS4L1Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试ㄱ＋元音的组合'**
  String get hangulS4L1Step4Desc;

  /// No description provided for @hangulS4L1SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS4L1SummaryTitle;

  /// No description provided for @hangulS4L1SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很棒！\n你已经掌握了ㄱ的发音和形状。'**
  String get hangulS4L1SummaryMsg;

  /// No description provided for @hangulS4L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ的形状与发音'**
  String get hangulS4L2Title;

  /// No description provided for @hangulS4L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'第二个基本辅音：ㄴ'**
  String get hangulS4L2Subtitle;

  /// No description provided for @hangulS4L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㄴ吧'**
  String get hangulS4L2Step0Title;

  /// No description provided for @hangulS4L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ构成「나」系列发音。'**
  String get hangulS4L2Step0Desc;

  /// No description provided for @hangulS4L2Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ,나'**
  String get hangulS4L2Step0Highlights;

  /// No description provided for @hangulS4L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㄴ的发音'**
  String get hangulS4L2Step1Title;

  /// No description provided for @hangulS4L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听나/노/누的发音'**
  String get hangulS4L2Step1Desc;

  /// No description provided for @hangulS4L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L2Step2Title;

  /// No description provided for @hangulS4L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L2Step2Desc;

  /// No description provided for @hangulS4L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㄴ的发音'**
  String get hangulS4L2Step3Title;

  /// No description provided for @hangulS4L2Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分나/다'**
  String get hangulS4L2Step3Desc;

  /// No description provided for @hangulS4L2Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㄴ组合文字'**
  String get hangulS4L2Step4Title;

  /// No description provided for @hangulS4L2Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试ㄴ＋元音的组合'**
  String get hangulS4L2Step4Desc;

  /// No description provided for @hangulS4L2SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS4L2SummaryTitle;

  /// No description provided for @hangulS4L2SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很棒！\n你已经掌握了ㄴ的发音和形状。'**
  String get hangulS4L2SummaryMsg;

  /// No description provided for @hangulS4L3Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ的形状与发音'**
  String get hangulS4L3Title;

  /// No description provided for @hangulS4L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'第三个基本辅音：ㄷ'**
  String get hangulS4L3Subtitle;

  /// No description provided for @hangulS4L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㄷ吧'**
  String get hangulS4L3Step0Title;

  /// No description provided for @hangulS4L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ构成「다」系列发音。'**
  String get hangulS4L3Step0Desc;

  /// No description provided for @hangulS4L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ,다'**
  String get hangulS4L3Step0Highlights;

  /// No description provided for @hangulS4L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㄷ的发音'**
  String get hangulS4L3Step1Title;

  /// No description provided for @hangulS4L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听다/도/두的发音'**
  String get hangulS4L3Step1Desc;

  /// No description provided for @hangulS4L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L3Step2Title;

  /// No description provided for @hangulS4L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L3Step2Desc;

  /// No description provided for @hangulS4L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㄷ的发音'**
  String get hangulS4L3Step3Title;

  /// No description provided for @hangulS4L3Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分다/나'**
  String get hangulS4L3Step3Desc;

  /// No description provided for @hangulS4L3Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㄷ组合文字'**
  String get hangulS4L3Step4Title;

  /// No description provided for @hangulS4L3Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试ㄷ＋元音的组合'**
  String get hangulS4L3Step4Desc;

  /// No description provided for @hangulS4L3SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS4L3SummaryTitle;

  /// No description provided for @hangulS4L3SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很棒！\n你已经掌握了ㄷ的发音和形状。'**
  String get hangulS4L3SummaryMsg;

  /// No description provided for @hangulS4L4Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄹ的形状与发音'**
  String get hangulS4L4Title;

  /// No description provided for @hangulS4L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'第四个基本辅音：ㄹ'**
  String get hangulS4L4Subtitle;

  /// No description provided for @hangulS4L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㄹ吧'**
  String get hangulS4L4Step0Title;

  /// No description provided for @hangulS4L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㄹ构成「라」系列发音。'**
  String get hangulS4L4Step0Desc;

  /// No description provided for @hangulS4L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㄹ,라'**
  String get hangulS4L4Step0Highlights;

  /// No description provided for @hangulS4L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㄹ的发音'**
  String get hangulS4L4Step1Title;

  /// No description provided for @hangulS4L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听라/로/루的发音'**
  String get hangulS4L4Step1Desc;

  /// No description provided for @hangulS4L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L4Step2Title;

  /// No description provided for @hangulS4L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L4Step2Desc;

  /// No description provided for @hangulS4L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㄹ的发音'**
  String get hangulS4L4Step3Title;

  /// No description provided for @hangulS4L4Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分라/나'**
  String get hangulS4L4Step3Desc;

  /// No description provided for @hangulS4L4Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㄹ组合文字'**
  String get hangulS4L4Step4Title;

  /// No description provided for @hangulS4L4Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试ㄹ＋元音的组合'**
  String get hangulS4L4Step4Desc;

  /// No description provided for @hangulS4L4SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS4L4SummaryTitle;

  /// No description provided for @hangulS4L4SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很棒！\n你已经掌握了ㄹ的发音和形状。'**
  String get hangulS4L4SummaryMsg;

  /// No description provided for @hangulS4L5Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅁ的形状与发音'**
  String get hangulS4L5Title;

  /// No description provided for @hangulS4L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'第五个基本辅音：ㅁ'**
  String get hangulS4L5Subtitle;

  /// No description provided for @hangulS4L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㅁ吧'**
  String get hangulS4L5Step0Title;

  /// No description provided for @hangulS4L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅁ构成「마」系列发音。'**
  String get hangulS4L5Step0Desc;

  /// No description provided for @hangulS4L5Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅁ,마'**
  String get hangulS4L5Step0Highlights;

  /// No description provided for @hangulS4L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅁ的发音'**
  String get hangulS4L5Step1Title;

  /// No description provided for @hangulS4L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听마/모/무的发音'**
  String get hangulS4L5Step1Desc;

  /// No description provided for @hangulS4L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L5Step2Title;

  /// No description provided for @hangulS4L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L5Step2Desc;

  /// No description provided for @hangulS4L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅁ的发音'**
  String get hangulS4L5Step3Title;

  /// No description provided for @hangulS4L5Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分마/바'**
  String get hangulS4L5Step3Desc;

  /// No description provided for @hangulS4L5Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅁ组合文字'**
  String get hangulS4L5Step4Title;

  /// No description provided for @hangulS4L5Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试ㅁ＋元音的组合'**
  String get hangulS4L5Step4Desc;

  /// No description provided for @hangulS4L5SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS4L5SummaryTitle;

  /// No description provided for @hangulS4L5SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很棒！\n你已经掌握了ㅁ的发音和形状。'**
  String get hangulS4L5SummaryMsg;

  /// No description provided for @hangulS4L6Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅂ的形状与发音'**
  String get hangulS4L6Title;

  /// No description provided for @hangulS4L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'第六个基本辅音：ㅂ'**
  String get hangulS4L6Subtitle;

  /// No description provided for @hangulS4L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㅂ吧'**
  String get hangulS4L6Step0Title;

  /// No description provided for @hangulS4L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅂ构成「바」系列发音。'**
  String get hangulS4L6Step0Desc;

  /// No description provided for @hangulS4L6Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅂ,바'**
  String get hangulS4L6Step0Highlights;

  /// No description provided for @hangulS4L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅂ的发音'**
  String get hangulS4L6Step1Title;

  /// No description provided for @hangulS4L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听바/보/부的发音'**
  String get hangulS4L6Step1Desc;

  /// No description provided for @hangulS4L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L6Step2Title;

  /// No description provided for @hangulS4L6Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L6Step2Desc;

  /// No description provided for @hangulS4L6Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅂ的发音'**
  String get hangulS4L6Step3Title;

  /// No description provided for @hangulS4L6Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分바/마'**
  String get hangulS4L6Step3Desc;

  /// No description provided for @hangulS4L6Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅂ组合文字'**
  String get hangulS4L6Step4Title;

  /// No description provided for @hangulS4L6Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试ㅂ＋元音的组合'**
  String get hangulS4L6Step4Desc;

  /// No description provided for @hangulS4L6SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS4L6SummaryTitle;

  /// No description provided for @hangulS4L6SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很棒！\n你已经掌握了ㅂ的发音和形状。'**
  String get hangulS4L6SummaryMsg;

  /// No description provided for @hangulS4L7Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅅ的形状与发音'**
  String get hangulS4L7Title;

  /// No description provided for @hangulS4L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'第七个基本辅音：ㅅ'**
  String get hangulS4L7Subtitle;

  /// No description provided for @hangulS4L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'来学ㅅ吧'**
  String get hangulS4L7Step0Title;

  /// No description provided for @hangulS4L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅅ构成「사」系列发音。'**
  String get hangulS4L7Step0Desc;

  /// No description provided for @hangulS4L7Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅅ,사'**
  String get hangulS4L7Step0Highlights;

  /// No description provided for @hangulS4L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听ㅅ的发音'**
  String get hangulS4L7Step1Title;

  /// No description provided for @hangulS4L7Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听사/소/수的发音'**
  String get hangulS4L7Step1Desc;

  /// No description provided for @hangulS4L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L7Step2Title;

  /// No description provided for @hangulS4L7Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L7Step2Desc;

  /// No description provided for @hangulS4L7Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅅ的发音'**
  String get hangulS4L7Step3Title;

  /// No description provided for @hangulS4L7Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分사/자'**
  String get hangulS4L7Step3Desc;

  /// No description provided for @hangulS4L7Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅅ组合文字'**
  String get hangulS4L7Step4Title;

  /// No description provided for @hangulS4L7Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'尝试ㅅ＋元音的组合'**
  String get hangulS4L7Step4Desc;

  /// No description provided for @hangulS4L7SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'第4阶段完成！'**
  String get hangulS4L7SummaryTitle;

  /// No description provided for @hangulS4L7SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你完成了第4阶段基本辅音1（ㄱ~ㅅ）。'**
  String get hangulS4L7SummaryMsg;

  /// No description provided for @hangulS4L8Title.
  ///
  /// In zh, this message translates to:
  /// **'单词阅读挑战！'**
  String get hangulS4L8Title;

  /// No description provided for @hangulS4L8Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'用辅音和元音读单词'**
  String get hangulS4L8Subtitle;

  /// No description provided for @hangulS4L8Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'现在你能读更多单词了！'**
  String get hangulS4L8Step0Title;

  /// No description provided for @hangulS4L8Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'你已经学完了全部7个基本辅音和元音。\n来读读由这些字组成的真实单词吧？'**
  String get hangulS4L8Step0Desc;

  /// No description provided for @hangulS4L8Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'7个辅音,元音,真实单词'**
  String get hangulS4L8Step0Highlights;

  /// No description provided for @hangulS4L8Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'读单词'**
  String get hangulS4L8Step1Title;

  /// No description provided for @hangulS4L8Step1Descs.
  ///
  /// In zh, this message translates to:
  /// **'树,海,蝴蝶,帽子,家具,豆腐'**
  String get hangulS4L8Step1Descs;

  /// No description provided for @hangulS4L8Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS4L8Step2Title;

  /// No description provided for @hangulS4L8Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着大声读出这些字'**
  String get hangulS4L8Step2Desc;

  /// No description provided for @hangulS4L8Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听后选出'**
  String get hangulS4L8Step3Title;

  /// No description provided for @hangulS4L8Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'是什么意思？'**
  String get hangulS4L8Step4Title;

  /// No description provided for @hangulS4L8Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'\"나비\"的中文是？'**
  String get hangulS4L8Step4Q0;

  /// No description provided for @hangulS4L8Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'\"바다\"的中文是？'**
  String get hangulS4L8Step4Q1;

  /// No description provided for @hangulS4L8SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get hangulS4L8SummaryTitle;

  /// No description provided for @hangulS4L8SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'你读了6个韩文单词！\n继续学习更多辅音，就能读出更多单词。'**
  String get hangulS4L8SummaryMsg;

  /// No description provided for @hangulS4LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务：基本辅音组合！'**
  String get hangulS4LMTitle;

  /// No description provided for @hangulS4LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'在时间限制内组合音节'**
  String get hangulS4LMSubtitle;

  /// No description provided for @hangulS4LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'任务开始！'**
  String get hangulS4LMStep0Title;

  /// No description provided for @hangulS4LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'将基本辅音ㄱ~ㅅ与元音组合。\n在限定时间内达成目标！'**
  String get hangulS4LMStep0Desc;

  /// No description provided for @hangulS4LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'来组合音节吧！'**
  String get hangulS4LMStep1Title;

  /// No description provided for @hangulS4LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS4LMStep2Title;

  /// No description provided for @hangulS4LMSummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务完成！'**
  String get hangulS4LMSummaryTitle;

  /// No description provided for @hangulS4LMSummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'你可以自由组合全部7个基本辅音了！'**
  String get hangulS4LMSummaryMsg;

  /// No description provided for @hangulS4CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第4阶段完成！'**
  String get hangulS4CompleteTitle;

  /// No description provided for @hangulS4CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已掌握全部7个基本辅音！'**
  String get hangulS4CompleteMsg;

  /// No description provided for @hangulS5L1Title.
  ///
  /// In zh, this message translates to:
  /// **'理解ㅇ的位置'**
  String get hangulS5L1Title;

  /// No description provided for @hangulS5L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'学习初声ㅇ的读法'**
  String get hangulS5L1Subtitle;

  /// No description provided for @hangulS5L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ是特殊辅音'**
  String get hangulS5L1Step0Title;

  /// No description provided for @hangulS5L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'初声ㅇ几乎没有声音，\n与元音结合后读作아/오/우。'**
  String get hangulS5L1Step0Desc;

  /// No description provided for @hangulS5L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ,아,初声位置'**
  String get hangulS5L1Step0Highlights;

  /// No description provided for @hangulS5L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅇ的组合音'**
  String get hangulS5L1Step1Title;

  /// No description provided for @hangulS5L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听아/오/우的发音'**
  String get hangulS5L1Step1Desc;

  /// No description provided for @hangulS5L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS5L1Step2Title;

  /// No description provided for @hangulS5L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个文字'**
  String get hangulS5L1Step2Desc;

  /// No description provided for @hangulS5L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅇ组字'**
  String get hangulS5L1Step3Title;

  /// No description provided for @hangulS5L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'组合ㅇ + 元音'**
  String get hangulS5L1Step3Desc;

  /// No description provided for @hangulS5L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L1Step4Title;

  /// No description provided for @hangulS5L1Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经理解了ㅇ的用法。'**
  String get hangulS5L1Step4Msg;

  /// No description provided for @hangulS5L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ的形状与发音'**
  String get hangulS5L2Title;

  /// No description provided for @hangulS5L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ的基础读法'**
  String get hangulS5L2Subtitle;

  /// No description provided for @hangulS5L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'学习ㅈ'**
  String get hangulS5L2Step0Title;

  /// No description provided for @hangulS5L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ产生「자」系列的音。'**
  String get hangulS5L2Step0Desc;

  /// No description provided for @hangulS5L2Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ,자'**
  String get hangulS5L2Step0Highlights;

  /// No description provided for @hangulS5L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅈ的发音'**
  String get hangulS5L2Step1Title;

  /// No description provided for @hangulS5L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听자/조/주'**
  String get hangulS5L2Step1Desc;

  /// No description provided for @hangulS5L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS5L2Step2Title;

  /// No description provided for @hangulS5L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个文字'**
  String get hangulS5L2Step2Desc;

  /// No description provided for @hangulS5L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅈ的音'**
  String get hangulS5L2Step3Title;

  /// No description provided for @hangulS5L2Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分자和사'**
  String get hangulS5L2Step3Desc;

  /// No description provided for @hangulS5L2Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'用ㅈ组字'**
  String get hangulS5L2Step4Title;

  /// No description provided for @hangulS5L2Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'组合ㅈ + 元音'**
  String get hangulS5L2Step4Desc;

  /// No description provided for @hangulS5L2Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L2Step5Title;

  /// No description provided for @hangulS5L2Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经学会了ㅈ的发音和形状。'**
  String get hangulS5L2Step5Msg;

  /// No description provided for @hangulS5L3Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅊ的形状与发音'**
  String get hangulS5L3Title;

  /// No description provided for @hangulS5L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅊ的基础读法'**
  String get hangulS5L3Subtitle;

  /// No description provided for @hangulS5L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'学习ㅊ'**
  String get hangulS5L3Step0Title;

  /// No description provided for @hangulS5L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅊ产生「차」系列的音。'**
  String get hangulS5L3Step0Desc;

  /// No description provided for @hangulS5L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅊ,차'**
  String get hangulS5L3Step0Highlights;

  /// No description provided for @hangulS5L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅊ的发音'**
  String get hangulS5L3Step1Title;

  /// No description provided for @hangulS5L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听차/초/추'**
  String get hangulS5L3Step1Desc;

  /// No description provided for @hangulS5L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS5L3Step2Title;

  /// No description provided for @hangulS5L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个文字'**
  String get hangulS5L3Step2Desc;

  /// No description provided for @hangulS5L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅊ的音'**
  String get hangulS5L3Step3Title;

  /// No description provided for @hangulS5L3Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分차和자'**
  String get hangulS5L3Step3Desc;

  /// No description provided for @hangulS5L3Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L3Step4Title;

  /// No description provided for @hangulS5L3Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经学会了ㅊ的发音和形状。'**
  String get hangulS5L3Step4Msg;

  /// No description provided for @hangulS5L4Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅋ的形状与发音'**
  String get hangulS5L4Title;

  /// No description provided for @hangulS5L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅋ的基础读法'**
  String get hangulS5L4Subtitle;

  /// No description provided for @hangulS5L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'学习ㅋ'**
  String get hangulS5L4Step0Title;

  /// No description provided for @hangulS5L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅋ产生「카」系列的音。'**
  String get hangulS5L4Step0Desc;

  /// No description provided for @hangulS5L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅋ,카'**
  String get hangulS5L4Step0Highlights;

  /// No description provided for @hangulS5L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅋ的发音'**
  String get hangulS5L4Step1Title;

  /// No description provided for @hangulS5L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听카/코/쿠'**
  String get hangulS5L4Step1Desc;

  /// No description provided for @hangulS5L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS5L4Step2Title;

  /// No description provided for @hangulS5L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个文字'**
  String get hangulS5L4Step2Desc;

  /// No description provided for @hangulS5L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅋ的音'**
  String get hangulS5L4Step3Title;

  /// No description provided for @hangulS5L4Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分카和가'**
  String get hangulS5L4Step3Desc;

  /// No description provided for @hangulS5L4Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L4Step4Title;

  /// No description provided for @hangulS5L4Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经学会了ㅋ的发音和形状。'**
  String get hangulS5L4Step4Msg;

  /// No description provided for @hangulS5L5Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅌ的形状与发音'**
  String get hangulS5L5Title;

  /// No description provided for @hangulS5L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅌ的基础读法'**
  String get hangulS5L5Subtitle;

  /// No description provided for @hangulS5L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'学习ㅌ'**
  String get hangulS5L5Step0Title;

  /// No description provided for @hangulS5L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅌ产生「타」系列的音。'**
  String get hangulS5L5Step0Desc;

  /// No description provided for @hangulS5L5Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅌ,타'**
  String get hangulS5L5Step0Highlights;

  /// No description provided for @hangulS5L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅌ的发音'**
  String get hangulS5L5Step1Title;

  /// No description provided for @hangulS5L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听타/토/투'**
  String get hangulS5L5Step1Desc;

  /// No description provided for @hangulS5L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS5L5Step2Title;

  /// No description provided for @hangulS5L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个文字'**
  String get hangulS5L5Step2Desc;

  /// No description provided for @hangulS5L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅌ的音'**
  String get hangulS5L5Step3Title;

  /// No description provided for @hangulS5L5Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分타和다'**
  String get hangulS5L5Step3Desc;

  /// No description provided for @hangulS5L5Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L5Step4Title;

  /// No description provided for @hangulS5L5Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经学会了ㅌ的发音和形状。'**
  String get hangulS5L5Step4Msg;

  /// No description provided for @hangulS5L6Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅍ的形状与发音'**
  String get hangulS5L6Title;

  /// No description provided for @hangulS5L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅍ的基础读法'**
  String get hangulS5L6Subtitle;

  /// No description provided for @hangulS5L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'学习ㅍ'**
  String get hangulS5L6Step0Title;

  /// No description provided for @hangulS5L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅍ产生「파」系列的音。'**
  String get hangulS5L6Step0Desc;

  /// No description provided for @hangulS5L6Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅍ,파'**
  String get hangulS5L6Step0Highlights;

  /// No description provided for @hangulS5L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅍ的发音'**
  String get hangulS5L6Step1Title;

  /// No description provided for @hangulS5L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听파/포/푸'**
  String get hangulS5L6Step1Desc;

  /// No description provided for @hangulS5L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS5L6Step2Title;

  /// No description provided for @hangulS5L6Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个文字'**
  String get hangulS5L6Step2Desc;

  /// No description provided for @hangulS5L6Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅍ的音'**
  String get hangulS5L6Step3Title;

  /// No description provided for @hangulS5L6Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分파和바'**
  String get hangulS5L6Step3Desc;

  /// No description provided for @hangulS5L6Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L6Step4Title;

  /// No description provided for @hangulS5L6Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经学会了ㅍ的发音和形状。'**
  String get hangulS5L6Step4Msg;

  /// No description provided for @hangulS5L7Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅎ的形状与发音'**
  String get hangulS5L7Title;

  /// No description provided for @hangulS5L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㅎ的基础读法'**
  String get hangulS5L7Subtitle;

  /// No description provided for @hangulS5L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'学习ㅎ'**
  String get hangulS5L7Step0Title;

  /// No description provided for @hangulS5L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅎ产生「하」系列的音。'**
  String get hangulS5L7Step0Desc;

  /// No description provided for @hangulS5L7Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅎ,하'**
  String get hangulS5L7Step0Highlights;

  /// No description provided for @hangulS5L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅎ的发音'**
  String get hangulS5L7Step1Title;

  /// No description provided for @hangulS5L7Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听하/호/후'**
  String get hangulS5L7Step1Desc;

  /// No description provided for @hangulS5L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS5L7Step2Title;

  /// No description provided for @hangulS5L7Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个文字'**
  String get hangulS5L7Step2Desc;

  /// No description provided for @hangulS5L7Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅎ的音'**
  String get hangulS5L7Step3Title;

  /// No description provided for @hangulS5L7Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分하和아'**
  String get hangulS5L7Step3Desc;

  /// No description provided for @hangulS5L7Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L7Step4Title;

  /// No description provided for @hangulS5L7Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经学会了ㅎ的发音和形状。'**
  String get hangulS5L7Step4Msg;

  /// No description provided for @hangulS5L8Title.
  ///
  /// In zh, this message translates to:
  /// **'额外辅音随机朗读'**
  String get hangulS5L8Title;

  /// No description provided for @hangulS5L8Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'混合复习ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ'**
  String get hangulS5L8Subtitle;

  /// No description provided for @hangulS5L8Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'随机复习'**
  String get hangulS5L8Step0Title;

  /// No description provided for @hangulS5L8Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'把7个额外辅音混在一起读一读吧。'**
  String get hangulS5L8Step0Desc;

  /// No description provided for @hangulS5L8Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ'**
  String get hangulS5L8Step0Highlights;

  /// No description provided for @hangulS5L8Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'形状/发音测验'**
  String get hangulS5L8Step1Title;

  /// No description provided for @hangulS5L8Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'将发音与文字对应起来'**
  String get hangulS5L8Step1Desc;

  /// No description provided for @hangulS5L8Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L8Step2Title;

  /// No description provided for @hangulS5L8Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你随机复习了7个额外辅音。'**
  String get hangulS5L8Step2Msg;

  /// No description provided for @hangulS5L9Title.
  ///
  /// In zh, this message translates to:
  /// **'易混淆对的预习'**
  String get hangulS5L9Title;

  /// No description provided for @hangulS5L9Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'为下一阶段做准备的区分练习'**
  String get hangulS5L9Subtitle;

  /// No description provided for @hangulS5L9Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'先看看容易混淆的对'**
  String get hangulS5L9Step0Title;

  /// No description provided for @hangulS5L9Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'提前练习区分ㅈ/ㅊ、ㄱ/ㅋ、ㄷ/ㅌ、ㅂ/ㅍ。'**
  String get hangulS5L9Step0Desc;

  /// No description provided for @hangulS5L9Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ/ㅊ,ㄱ/ㅋ,ㄷ/ㅌ,ㅂ/ㅍ'**
  String get hangulS5L9Step0Highlights;

  /// No description provided for @hangulS5L9Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'对比听音'**
  String get hangulS5L9Step1Title;

  /// No description provided for @hangulS5L9Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'从两个选项中选出正确的音'**
  String get hangulS5L9Step1Desc;

  /// No description provided for @hangulS5L9Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS5L9Step2Title;

  /// No description provided for @hangulS5L9Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'太棒了！\n你已经为下一阶段做好准备了。'**
  String get hangulS5L9Step2Msg;

  /// No description provided for @hangulS5LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'第5阶段任务'**
  String get hangulS5LMTitle;

  /// No description provided for @hangulS5LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'基本辅音2 综合任务'**
  String get hangulS5LMSubtitle;

  /// No description provided for @hangulS5LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'任务开始！'**
  String get hangulS5LMStep0Title;

  /// No description provided for @hangulS5LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'将基本辅音2（ㅇ~ㅎ）与元音组合。\n在限定时间内达成目标！'**
  String get hangulS5LMStep0Desc;

  /// No description provided for @hangulS5LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'组合音节！'**
  String get hangulS5LMStep1Title;

  /// No description provided for @hangulS5LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS5LMStep2Title;

  /// No description provided for @hangulS5LMStep3Title.
  ///
  /// In zh, this message translates to:
  /// **'第5阶段完成！'**
  String get hangulS5LMStep3Title;

  /// No description provided for @hangulS5LMStep3Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你完成了第5阶段：基本辅音2（ㅇ~ㅎ）。'**
  String get hangulS5LMStep3Msg;

  /// No description provided for @hangulS5LMStep4Title.
  ///
  /// In zh, this message translates to:
  /// **'第5阶段完成！'**
  String get hangulS5LMStep4Title;

  /// No description provided for @hangulS5LMStep4Msg.
  ///
  /// In zh, this message translates to:
  /// **'你已经掌握了所有基本辅音！'**
  String get hangulS5LMStep4Msg;

  /// No description provided for @hangulS5CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第5阶段完成！'**
  String get hangulS5CompleteTitle;

  /// No description provided for @hangulS5CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已经掌握了所有基本辅音！'**
  String get hangulS5CompleteMsg;

  /// No description provided for @hangulS6L1Title.
  ///
  /// In zh, this message translates to:
  /// **'가~기 模式阅读'**
  String get hangulS6L1Title;

  /// No description provided for @hangulS6L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + 基本元音模式'**
  String get hangulS6L1Subtitle;

  /// No description provided for @hangulS6L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'开始用模式阅读'**
  String get hangulS6L1Step0Title;

  /// No description provided for @hangulS6L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着改变与ㄱ组合的元音\n你会找到阅读的节奏。'**
  String get hangulS6L1Step0Desc;

  /// No description provided for @hangulS6L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'가,거,고,구,그,기'**
  String get hangulS6L1Step0Highlights;

  /// No description provided for @hangulS6L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听模式发音'**
  String get hangulS6L1Step1Title;

  /// No description provided for @hangulS6L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'按顺序听一听 가/거/고/구/그/기'**
  String get hangulS6L1Step1Desc;

  /// No description provided for @hangulS6L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS6L1Step2Title;

  /// No description provided for @hangulS6L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个音节'**
  String get hangulS6L1Step2Desc;

  /// No description provided for @hangulS6L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'模式测验'**
  String get hangulS6L1Step3Title;

  /// No description provided for @hangulS6L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'配对相同的辅音模式'**
  String get hangulS6L1Step3Desc;

  /// No description provided for @hangulS6L1Step3Q0.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅏ = ?'**
  String get hangulS6L1Step3Q0;

  /// No description provided for @hangulS6L1Step3Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅓ = ?'**
  String get hangulS6L1Step3Q1;

  /// No description provided for @hangulS6L1Step3Q2.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅡ = ?'**
  String get hangulS6L1Step3Q2;

  /// No description provided for @hangulS6L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L1Step4Title;

  /// No description provided for @hangulS6L1Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经开始学习 가~기 模式了。'**
  String get hangulS6L1Step4Msg;

  /// No description provided for @hangulS6L2Title.
  ///
  /// In zh, this message translates to:
  /// **'扩展 나~니'**
  String get hangulS6L2Title;

  /// No description provided for @hangulS6L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ 模式阅读'**
  String get hangulS6L2Subtitle;

  /// No description provided for @hangulS6L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'扩展 ㄴ 模式'**
  String get hangulS6L2Step0Title;

  /// No description provided for @hangulS6L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'改变与ㄴ组合的元音来读 나~니。'**
  String get hangulS6L2Step0Desc;

  /// No description provided for @hangulS6L2Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'나,너,노,누,느,니'**
  String get hangulS6L2Step0Highlights;

  /// No description provided for @hangulS6L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听 나~니'**
  String get hangulS6L2Step1Title;

  /// No description provided for @hangulS6L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'请听听 ㄴ 模式的发音'**
  String get hangulS6L2Step1Desc;

  /// No description provided for @hangulS6L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS6L2Step2Title;

  /// No description provided for @hangulS6L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个音节'**
  String get hangulS6L2Step2Desc;

  /// No description provided for @hangulS6L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'组合 ㄴ'**
  String get hangulS6L2Step3Title;

  /// No description provided for @hangulS6L2Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'用 ㄴ + 元音组成音节'**
  String get hangulS6L2Step3Desc;

  /// No description provided for @hangulS6L2Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L2Step4Title;

  /// No description provided for @hangulS6L2Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经掌握了 나~니 模式。'**
  String get hangulS6L2Step4Msg;

  /// No description provided for @hangulS6L3Title.
  ///
  /// In zh, this message translates to:
  /// **'扩展 다~디 和 라~리'**
  String get hangulS6L3Title;

  /// No description provided for @hangulS6L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ/ㄹ 模式阅读'**
  String get hangulS6L3Subtitle;

  /// No description provided for @hangulS6L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'只换辅音来阅读'**
  String get hangulS6L3Step0Title;

  /// No description provided for @hangulS6L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'用相同元音只换辅音来读，\n阅读速度会越来越快。'**
  String get hangulS6L3Step0Desc;

  /// No description provided for @hangulS6L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'다/라,도/로,두/루,디/리'**
  String get hangulS6L3Step0Highlights;

  /// No description provided for @hangulS6L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听：区分 ㄷ/ㄹ'**
  String get hangulS6L3Step1Title;

  /// No description provided for @hangulS6L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听音选择正确的音节'**
  String get hangulS6L3Step1Desc;

  /// No description provided for @hangulS6L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'阅读测验'**
  String get hangulS6L3Step2Title;

  /// No description provided for @hangulS6L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'检查模式'**
  String get hangulS6L3Step2Desc;

  /// No description provided for @hangulS6L3Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ + ㅣ = ?'**
  String get hangulS6L3Step2Q0;

  /// No description provided for @hangulS6L3Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㄹ + ㅗ = ?'**
  String get hangulS6L3Step2Q1;

  /// No description provided for @hangulS6L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L3Step3Title;

  /// No description provided for @hangulS6L3Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经掌握了 ㄷ/ㄹ 模式。'**
  String get hangulS6L3Step3Msg;

  /// No description provided for @hangulS6L4Title.
  ///
  /// In zh, this message translates to:
  /// **'随机音节阅读 1'**
  String get hangulS6L4Title;

  /// No description provided for @hangulS6L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'混合基本模式'**
  String get hangulS6L4Subtitle;

  /// No description provided for @hangulS6L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'无序阅读'**
  String get hangulS6L4Step0Title;

  /// No description provided for @hangulS6L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'现在像随机抽卡一样来读吧。'**
  String get hangulS6L4Step0Desc;

  /// No description provided for @hangulS6L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'随机阅读'**
  String get hangulS6L4Step1Title;

  /// No description provided for @hangulS6L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'识别随机出现的音节'**
  String get hangulS6L4Step1Desc;

  /// No description provided for @hangulS6L4Step1Q0.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅗ = ?'**
  String get hangulS6L4Step1Q0;

  /// No description provided for @hangulS6L4Step1Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ + ㅜ = ?'**
  String get hangulS6L4Step1Q1;

  /// No description provided for @hangulS6L4Step1Q2.
  ///
  /// In zh, this message translates to:
  /// **'ㄹ + ㅏ = ?'**
  String get hangulS6L4Step1Q2;

  /// No description provided for @hangulS6L4Step1Q3.
  ///
  /// In zh, this message translates to:
  /// **'ㅁ + ㅣ = ?'**
  String get hangulS6L4Step1Q3;

  /// No description provided for @hangulS6L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L4Step2Title;

  /// No description provided for @hangulS6L4Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你完成了随机阅读 1。'**
  String get hangulS6L4Step2Msg;

  /// No description provided for @hangulS6L5Title.
  ///
  /// In zh, this message translates to:
  /// **'听音找音节'**
  String get hangulS6L5Title;

  /// No description provided for @hangulS6L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'强化听觉与文字的联系'**
  String get hangulS6L5Subtitle;

  /// No description provided for @hangulS6L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听音寻字练习'**
  String get hangulS6L5Step0Title;

  /// No description provided for @hangulS6L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听音选出对应音节，\n强化阅读联系。'**
  String get hangulS6L5Step0Desc;

  /// No description provided for @hangulS6L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'声音配对'**
  String get hangulS6L5Step1Title;

  /// No description provided for @hangulS6L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出正确的音节'**
  String get hangulS6L5Step1Desc;

  /// No description provided for @hangulS6L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L5Step2Title;

  /// No description provided for @hangulS6L5Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你完成了听音找字练习。'**
  String get hangulS6L5Step2Msg;

  /// No description provided for @hangulS6L6Title.
  ///
  /// In zh, this message translates to:
  /// **'复合元音组合 1'**
  String get hangulS6L6Title;

  /// No description provided for @hangulS6L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'阅读 ㅘ、ㅝ'**
  String get hangulS6L6Subtitle;

  /// No description provided for @hangulS6L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'开始学习复合元音'**
  String get hangulS6L6Step0Title;

  /// No description provided for @hangulS6L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'来读一读由 ㅘ 和 ㅝ 组成的音节。'**
  String get hangulS6L6Step0Desc;

  /// No description provided for @hangulS6L6Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅘ,ㅝ,와,워'**
  String get hangulS6L6Step0Highlights;

  /// No description provided for @hangulS6L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听 와/워'**
  String get hangulS6L6Step1Title;

  /// No description provided for @hangulS6L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'请听一听代表性音节的发音'**
  String get hangulS6L6Step1Desc;

  /// No description provided for @hangulS6L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS6L6Step2Title;

  /// No description provided for @hangulS6L6Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个音节'**
  String get hangulS6L6Step2Desc;

  /// No description provided for @hangulS6L6Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'复合元音测验'**
  String get hangulS6L6Step3Title;

  /// No description provided for @hangulS6L6Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分 ㅘ 和 ㅝ'**
  String get hangulS6L6Step3Desc;

  /// No description provided for @hangulS6L6Step3Q0.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅘ = ?'**
  String get hangulS6L6Step3Q0;

  /// No description provided for @hangulS6L6Step3Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅝ = ?'**
  String get hangulS6L6Step3Q1;

  /// No description provided for @hangulS6L6Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L6Step4Title;

  /// No description provided for @hangulS6L6Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经学会了 ㅘ/ㅝ 组合。'**
  String get hangulS6L6Step4Msg;

  /// No description provided for @hangulS6L7Title.
  ///
  /// In zh, this message translates to:
  /// **'复合元音组合 2'**
  String get hangulS6L7Title;

  /// No description provided for @hangulS6L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'阅读 ㅙ、ㅞ、ㅚ、ㅟ、ㅢ'**
  String get hangulS6L7Subtitle;

  /// No description provided for @hangulS6L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'扩展复合元音'**
  String get hangulS6L7Step0Title;

  /// No description provided for @hangulS6L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'简要学习复合元音，以阅读为中心推进。'**
  String get hangulS6L7Step0Desc;

  /// No description provided for @hangulS6L7Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'왜,웨,외,위,의'**
  String get hangulS6L7Step0Highlights;

  /// No description provided for @hangulS6L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅢ 的特殊发音'**
  String get hangulS6L7Step1Title;

  /// No description provided for @hangulS6L7Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅢ 是一个根据位置发音不同的特殊元音。\n\n• 词首：[의] → 의사、의자\n• 辅音后：[이] → 희망→[히망]\n• 助词「의」：[에] → 나의→[나에]'**
  String get hangulS6L7Step1Desc;

  /// No description provided for @hangulS6L7Step1Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅢ,의,이,에'**
  String get hangulS6L7Step1Highlights;

  /// No description provided for @hangulS6L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'选择复合元音'**
  String get hangulS6L7Step2Title;

  /// No description provided for @hangulS6L7Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出正确的音节'**
  String get hangulS6L7Step2Desc;

  /// No description provided for @hangulS6L7Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅙ = ?'**
  String get hangulS6L7Step2Q0;

  /// No description provided for @hangulS6L7Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅟ = ?'**
  String get hangulS6L7Step2Q1;

  /// No description provided for @hangulS6L7Step2Q2.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ + ㅢ = ?'**
  String get hangulS6L7Step2Q2;

  /// No description provided for @hangulS6L7Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L7Step3Title;

  /// No description provided for @hangulS6L7Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你完成了复合元音的扩展学习。'**
  String get hangulS6L7Step3Msg;

  /// No description provided for @hangulS6L8Title.
  ///
  /// In zh, this message translates to:
  /// **'随机音节阅读 2'**
  String get hangulS6L8Title;

  /// No description provided for @hangulS6L8Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'基本+复合元音综合'**
  String get hangulS6L8Subtitle;

  /// No description provided for @hangulS6L8Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'综合随机阅读'**
  String get hangulS6L8Step0Title;

  /// No description provided for @hangulS6L8Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'将基本元音和复合元音混合在一起阅读。'**
  String get hangulS6L8Step0Desc;

  /// No description provided for @hangulS6L8Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'综合测验'**
  String get hangulS6L8Step1Title;

  /// No description provided for @hangulS6L8Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'识别随机组合'**
  String get hangulS6L8Step1Desc;

  /// No description provided for @hangulS6L8Step1Q0.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ + ㅢ = ?'**
  String get hangulS6L8Step1Q0;

  /// No description provided for @hangulS6L8Step1Q1.
  ///
  /// In zh, this message translates to:
  /// **'ㅎ + ㅘ = ?'**
  String get hangulS6L8Step1Q1;

  /// No description provided for @hangulS6L8Step1Q2.
  ///
  /// In zh, this message translates to:
  /// **'ㅂ + ㅟ = ?'**
  String get hangulS6L8Step1Q2;

  /// No description provided for @hangulS6L8Step1Q3.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ + ㅝ = ?'**
  String get hangulS6L8Step1Q3;

  /// No description provided for @hangulS6L8Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS6L8Step2Title;

  /// No description provided for @hangulS6L8Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你完成了第6阶段综合阅读。'**
  String get hangulS6L8Step2Msg;

  /// No description provided for @hangulS6LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'第6阶段任务'**
  String get hangulS6LMTitle;

  /// No description provided for @hangulS6LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'组合阅读最终检验'**
  String get hangulS6LMSubtitle;

  /// No description provided for @hangulS6LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'任务开始！'**
  String get hangulS6LMStep0Title;

  /// No description provided for @hangulS6LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'这是音节组合训练的最终检验。\n在时限内达成目标吧！'**
  String get hangulS6LMStep0Desc;

  /// No description provided for @hangulS6LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'组合音节！'**
  String get hangulS6LMStep1Title;

  /// No description provided for @hangulS6LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS6LMStep2Title;

  /// No description provided for @hangulS6LMStep3Title.
  ///
  /// In zh, this message translates to:
  /// **'第6阶段完成！'**
  String get hangulS6LMStep3Title;

  /// No description provided for @hangulS6LMStep3Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你完成了第6阶段音节组合训练。'**
  String get hangulS6LMStep3Msg;

  /// No description provided for @hangulS6CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第6阶段完成！'**
  String get hangulS6CompleteTitle;

  /// No description provided for @hangulS6CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你现在可以自由组合音节了！'**
  String get hangulS6CompleteMsg;

  /// No description provided for @hangulS7L1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ / ㅋ / ㄲ 辅音对比'**
  String get hangulS7L1Title;

  /// No description provided for @hangulS7L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'가 · 카 · 까 的对比'**
  String get hangulS7L1Subtitle;

  /// No description provided for @hangulS7L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'分辨三种声音'**
  String get hangulS7L1Step0Title;

  /// No description provided for @hangulS7L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分ㄱ（平音）、ㅋ（送气音）、ㄲ（紧音）的感觉。'**
  String get hangulS7L1Step0Desc;

  /// No description provided for @hangulS7L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ,ㅋ,ㄲ,가,카,까'**
  String get hangulS7L1Step0Highlights;

  /// No description provided for @hangulS7L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'声音探索'**
  String get hangulS7L1Step1Title;

  /// No description provided for @hangulS7L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'反复听가/카/까'**
  String get hangulS7L1Step1Desc;

  /// No description provided for @hangulS7L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS7L1Step2Title;

  /// No description provided for @hangulS7L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着亲自发出每个字的声音'**
  String get hangulS7L1Step2Desc;

  /// No description provided for @hangulS7L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS7L1Step3Title;

  /// No description provided for @hangulS7L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'从三个选项中选出正确答案'**
  String get hangulS7L1Step3Desc;

  /// No description provided for @hangulS7L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'快速确认'**
  String get hangulS7L1Step4Title;

  /// No description provided for @hangulS7L1Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'同时确认形状和声音'**
  String get hangulS7L1Step4Desc;

  /// No description provided for @hangulS7L1Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个是送气音？'**
  String get hangulS7L1Step4Q0;

  /// No description provided for @hangulS7L1Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个是紧音？'**
  String get hangulS7L1Step4Q1;

  /// No description provided for @hangulS7L1Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS7L1Step5Title;

  /// No description provided for @hangulS7L1Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握区分ㄱ/ㅋ/ㄲ的方法。'**
  String get hangulS7L1Step5Msg;

  /// No description provided for @hangulS7L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ / ㅌ / ㄸ 辅音对比'**
  String get hangulS7L2Title;

  /// No description provided for @hangulS7L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'다 · 타 · 따 的对比'**
  String get hangulS7L2Subtitle;

  /// No description provided for @hangulS7L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第二组对比'**
  String get hangulS7L2Step0Title;

  /// No description provided for @hangulS7L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'比较ㄷ/ㅌ/ㄸ的声音。'**
  String get hangulS7L2Step0Desc;

  /// No description provided for @hangulS7L2Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ,ㅌ,ㄸ,다,타,따'**
  String get hangulS7L2Step0Highlights;

  /// No description provided for @hangulS7L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'声音探索'**
  String get hangulS7L2Step1Title;

  /// No description provided for @hangulS7L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'反复听다/타/따'**
  String get hangulS7L2Step1Desc;

  /// No description provided for @hangulS7L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS7L2Step2Title;

  /// No description provided for @hangulS7L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着亲自发出每个字的声音'**
  String get hangulS7L2Step2Desc;

  /// No description provided for @hangulS7L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS7L2Step3Title;

  /// No description provided for @hangulS7L2Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'从三个选项中选出正确答案'**
  String get hangulS7L2Step3Desc;

  /// No description provided for @hangulS7L2Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS7L2Step4Title;

  /// No description provided for @hangulS7L2Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握区分ㄷ/ㅌ/ㄸ的方法。'**
  String get hangulS7L2Step4Msg;

  /// No description provided for @hangulS7L3Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅂ / ㅍ / ㅃ 辅音对比'**
  String get hangulS7L3Title;

  /// No description provided for @hangulS7L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'바 · 파 · 빠 的对比'**
  String get hangulS7L3Subtitle;

  /// No description provided for @hangulS7L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'第三组对比'**
  String get hangulS7L3Step0Title;

  /// No description provided for @hangulS7L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'比较ㅂ/ㅍ/ㅃ的声音。'**
  String get hangulS7L3Step0Desc;

  /// No description provided for @hangulS7L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅂ,ㅍ,ㅃ,바,파,빠'**
  String get hangulS7L3Step0Highlights;

  /// No description provided for @hangulS7L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'声音探索'**
  String get hangulS7L3Step1Title;

  /// No description provided for @hangulS7L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'反复听바/파/빠'**
  String get hangulS7L3Step1Desc;

  /// No description provided for @hangulS7L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS7L3Step2Title;

  /// No description provided for @hangulS7L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着亲自发出每个字的声音'**
  String get hangulS7L3Step2Desc;

  /// No description provided for @hangulS7L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS7L3Step3Title;

  /// No description provided for @hangulS7L3Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'从三个选项中选出正确答案'**
  String get hangulS7L3Step3Desc;

  /// No description provided for @hangulS7L3Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS7L3Step4Title;

  /// No description provided for @hangulS7L3Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握区分ㅂ/ㅍ/ㅃ的方法。'**
  String get hangulS7L3Step4Msg;

  /// No description provided for @hangulS7L4Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅅ / ㅆ 辅音对比'**
  String get hangulS7L4Title;

  /// No description provided for @hangulS7L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'사 · 싸 的对比'**
  String get hangulS7L4Subtitle;

  /// No description provided for @hangulS7L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'两种声音的对比'**
  String get hangulS7L4Step0Title;

  /// No description provided for @hangulS7L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分ㅅ/ㅆ的声音。'**
  String get hangulS7L4Step0Desc;

  /// No description provided for @hangulS7L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅅ,ㅆ,사,싸'**
  String get hangulS7L4Step0Highlights;

  /// No description provided for @hangulS7L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'声音探索'**
  String get hangulS7L4Step1Title;

  /// No description provided for @hangulS7L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'反复听사/싸'**
  String get hangulS7L4Step1Desc;

  /// No description provided for @hangulS7L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS7L4Step2Title;

  /// No description provided for @hangulS7L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着亲自发出每个字的声音'**
  String get hangulS7L4Step2Desc;

  /// No description provided for @hangulS7L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS7L4Step3Title;

  /// No description provided for @hangulS7L4Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'从两个选项中选出正确答案'**
  String get hangulS7L4Step3Desc;

  /// No description provided for @hangulS7L4Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS7L4Step4Title;

  /// No description provided for @hangulS7L4Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握区分ㅅ/ㅆ的方法。'**
  String get hangulS7L4Step4Msg;

  /// No description provided for @hangulS7L5Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ / ㅊ / ㅉ 辅音对比'**
  String get hangulS7L5Title;

  /// No description provided for @hangulS7L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'자 · 차 · 짜 的对比'**
  String get hangulS7L5Subtitle;

  /// No description provided for @hangulS7L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'最后一组对比'**
  String get hangulS7L5Step0Title;

  /// No description provided for @hangulS7L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'比较ㅈ/ㅊ/ㅉ的声音。'**
  String get hangulS7L5Step0Desc;

  /// No description provided for @hangulS7L5Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'ㅈ,ㅊ,ㅉ,자,차,짜'**
  String get hangulS7L5Step0Highlights;

  /// No description provided for @hangulS7L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'声音探索'**
  String get hangulS7L5Step1Title;

  /// No description provided for @hangulS7L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'反复听자/차/짜'**
  String get hangulS7L5Step1Desc;

  /// No description provided for @hangulS7L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS7L5Step2Title;

  /// No description provided for @hangulS7L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'试着亲自发出每个字的声音'**
  String get hangulS7L5Step2Desc;

  /// No description provided for @hangulS7L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS7L5Step3Title;

  /// No description provided for @hangulS7L5Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'从三个选项中选出正确答案'**
  String get hangulS7L5Step3Desc;

  /// No description provided for @hangulS7L5Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'第7阶段完成！'**
  String get hangulS7L5Step4Title;

  /// No description provided for @hangulS7L5Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你已完成第7阶段的全部5组对比练习。'**
  String get hangulS7L5Step4Msg;

  /// No description provided for @hangulS7LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务：声音辨别挑战！'**
  String get hangulS7LMTitle;

  /// No description provided for @hangulS7LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'区分平音、送气音和紧音'**
  String get hangulS7LMSubtitle;

  /// No description provided for @hangulS7LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'声音辨别任务！'**
  String get hangulS7LMStep0Title;

  /// No description provided for @hangulS7LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'混合平音、送气音和紧音\n快速组合音节！'**
  String get hangulS7LMStep0Desc;

  /// No description provided for @hangulS7LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'组合音节！'**
  String get hangulS7LMStep1Title;

  /// No description provided for @hangulS7LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS7LMStep2Title;

  /// No description provided for @hangulS7LMStep3Title.
  ///
  /// In zh, this message translates to:
  /// **'任务完成！'**
  String get hangulS7LMStep3Title;

  /// No description provided for @hangulS7LMStep3Msg.
  ///
  /// In zh, this message translates to:
  /// **'你已能区分平音、送气音和紧音！'**
  String get hangulS7LMStep3Msg;

  /// No description provided for @hangulS7LMStep4Title.
  ///
  /// In zh, this message translates to:
  /// **'第7阶段完成！'**
  String get hangulS7LMStep4Title;

  /// No description provided for @hangulS7LMStep4Msg.
  ///
  /// In zh, this message translates to:
  /// **'你已能区分紧音和送气音！'**
  String get hangulS7LMStep4Msg;

  /// No description provided for @hangulS7CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第7阶段完成！'**
  String get hangulS7CompleteTitle;

  /// No description provided for @hangulS7CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已能区分紧音和送气音！'**
  String get hangulS7CompleteMsg;

  /// No description provided for @hangulS8L0Title.
  ///
  /// In zh, this message translates to:
  /// **'收音（받침）基础'**
  String get hangulS8L0Title;

  /// No description provided for @hangulS8L0Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'藏在音节块底部的音'**
  String get hangulS8L0Subtitle;

  /// No description provided for @hangulS8L0Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'收音在音节的下方'**
  String get hangulS8L0Step0Title;

  /// No description provided for @hangulS8L0Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'收音位于音节块的底部。\n例：가 + ㄴ = 간'**
  String get hangulS8L0Step0Desc;

  /// No description provided for @hangulS8L0Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'收音,간,말,집'**
  String get hangulS8L0Step0Highlights;

  /// No description provided for @hangulS8L0Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'收音的7个代表音'**
  String get hangulS8L0Step1Title;

  /// No description provided for @hangulS8L0Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'收音只有7个代表音。\n\nㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\n许多收音字母都归属于这7个音之一。\n例：ㅅ, ㅈ, ㅊ, ㅎ 作为收音 → 均发[ㄷ]音'**
  String get hangulS8L0Step1Desc;

  /// No description provided for @hangulS8L0Step1Highlights.
  ///
  /// In zh, this message translates to:
  /// **'7个音,ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ,代表音'**
  String get hangulS8L0Step1Highlights;

  /// No description provided for @hangulS8L0Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'找出收音'**
  String get hangulS8L0Step2Title;

  /// No description provided for @hangulS8L0Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'确认收音的位置'**
  String get hangulS8L0Step2Desc;

  /// No description provided for @hangulS8L0Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'간的收音是？'**
  String get hangulS8L0Step2Q0;

  /// No description provided for @hangulS8L0Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'말的收音是？'**
  String get hangulS8L0Step2Q1;

  /// No description provided for @hangulS8L0SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L0SummaryTitle;

  /// No description provided for @hangulS8L0SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已理解收音的概念。'**
  String get hangulS8L0SummaryMsg;

  /// No description provided for @hangulS8L1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄴ收音'**
  String get hangulS8L1Title;

  /// No description provided for @hangulS8L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'간 · 난 · 단'**
  String get hangulS8L1Subtitle;

  /// No description provided for @hangulS8L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㄴ收音'**
  String get hangulS8L1Step0Title;

  /// No description provided for @hangulS8L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听간/난/단'**
  String get hangulS8L1Step0Desc;

  /// No description provided for @hangulS8L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS8L1Step1Title;

  /// No description provided for @hangulS8L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS8L1Step1Desc;

  /// No description provided for @hangulS8L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS8L1Step2Title;

  /// No description provided for @hangulS8L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有ㄴ收音的音节'**
  String get hangulS8L1Step2Desc;

  /// No description provided for @hangulS8L1SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L1SummaryTitle;

  /// No description provided for @hangulS8L1SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你掌握了ㄴ收音。'**
  String get hangulS8L1SummaryMsg;

  /// No description provided for @hangulS8L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄹ收音'**
  String get hangulS8L2Title;

  /// No description provided for @hangulS8L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'말 · 갈 · 물'**
  String get hangulS8L2Subtitle;

  /// No description provided for @hangulS8L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㄹ收音'**
  String get hangulS8L2Step0Title;

  /// No description provided for @hangulS8L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听말/갈/물'**
  String get hangulS8L2Step0Desc;

  /// No description provided for @hangulS8L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS8L2Step1Title;

  /// No description provided for @hangulS8L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS8L2Step1Desc;

  /// No description provided for @hangulS8L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS8L2Step2Title;

  /// No description provided for @hangulS8L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有ㄹ收音的音节'**
  String get hangulS8L2Step2Desc;

  /// No description provided for @hangulS8L2SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L2SummaryTitle;

  /// No description provided for @hangulS8L2SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你掌握了ㄹ收音。'**
  String get hangulS8L2SummaryMsg;

  /// No description provided for @hangulS8L3Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅁ收音'**
  String get hangulS8L3Title;

  /// No description provided for @hangulS8L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'감 · 밤 · 숨'**
  String get hangulS8L3Subtitle;

  /// No description provided for @hangulS8L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅁ收音'**
  String get hangulS8L3Step0Title;

  /// No description provided for @hangulS8L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听감/밤/숨'**
  String get hangulS8L3Step0Desc;

  /// No description provided for @hangulS8L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS8L3Step1Title;

  /// No description provided for @hangulS8L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS8L3Step1Desc;

  /// No description provided for @hangulS8L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'辨别收音'**
  String get hangulS8L3Step2Title;

  /// No description provided for @hangulS8L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅁ收音的音节'**
  String get hangulS8L3Step2Desc;

  /// No description provided for @hangulS8L3Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㅁ收音？'**
  String get hangulS8L3Step2Q0;

  /// No description provided for @hangulS8L3Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㅁ收音？'**
  String get hangulS8L3Step2Q1;

  /// No description provided for @hangulS8L3SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L3SummaryTitle;

  /// No description provided for @hangulS8L3SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你掌握了ㅁ收音。'**
  String get hangulS8L3SummaryMsg;

  /// No description provided for @hangulS8L4Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ收音'**
  String get hangulS8L4Title;

  /// No description provided for @hangulS8L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'방 · 공 · 종'**
  String get hangulS8L4Subtitle;

  /// No description provided for @hangulS8L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ很特别！'**
  String get hangulS8L4Step0Title;

  /// No description provided for @hangulS8L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'ㅇ很特别！\n作为初声（上方）时无音（아, 오），\n作为收音（下方）时发\"ng\"音（방, 공）'**
  String get hangulS8L4Step0Desc;

  /// No description provided for @hangulS8L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'初声,收音,ng,방,공'**
  String get hangulS8L4Step0Highlights;

  /// No description provided for @hangulS8L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅇ收音'**
  String get hangulS8L4Step1Title;

  /// No description provided for @hangulS8L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听방/공/종'**
  String get hangulS8L4Step1Desc;

  /// No description provided for @hangulS8L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS8L4Step2Title;

  /// No description provided for @hangulS8L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS8L4Step2Desc;

  /// No description provided for @hangulS8L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS8L4Step3Title;

  /// No description provided for @hangulS8L4Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有ㅇ收音的音节'**
  String get hangulS8L4Step3Desc;

  /// No description provided for @hangulS8L4SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L4SummaryTitle;

  /// No description provided for @hangulS8L4SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你掌握了ㅇ收音。'**
  String get hangulS8L4SummaryMsg;

  /// No description provided for @hangulS8L5Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄱ收音'**
  String get hangulS8L5Title;

  /// No description provided for @hangulS8L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'박 · 각 · 국'**
  String get hangulS8L5Subtitle;

  /// No description provided for @hangulS8L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㄱ收音'**
  String get hangulS8L5Step0Title;

  /// No description provided for @hangulS8L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听박/각/국'**
  String get hangulS8L5Step0Desc;

  /// No description provided for @hangulS8L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS8L5Step1Title;

  /// No description provided for @hangulS8L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS8L5Step1Desc;

  /// No description provided for @hangulS8L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'辨别收音'**
  String get hangulS8L5Step2Title;

  /// No description provided for @hangulS8L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出ㄱ收音的音节'**
  String get hangulS8L5Step2Desc;

  /// No description provided for @hangulS8L5Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㄱ收音？'**
  String get hangulS8L5Step2Q0;

  /// No description provided for @hangulS8L5Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㄱ收音？'**
  String get hangulS8L5Step2Q1;

  /// No description provided for @hangulS8L5SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L5SummaryTitle;

  /// No description provided for @hangulS8L5SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你掌握了ㄱ收音。'**
  String get hangulS8L5SummaryMsg;

  /// No description provided for @hangulS8L6Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅂ收音'**
  String get hangulS8L6Title;

  /// No description provided for @hangulS8L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'밥 · 집 · 숲'**
  String get hangulS8L6Subtitle;

  /// No description provided for @hangulS8L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅂ收音'**
  String get hangulS8L6Step0Title;

  /// No description provided for @hangulS8L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听밥/집/숲'**
  String get hangulS8L6Step0Desc;

  /// No description provided for @hangulS8L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS8L6Step1Title;

  /// No description provided for @hangulS8L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS8L6Step1Desc;

  /// No description provided for @hangulS8L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS8L6Step2Title;

  /// No description provided for @hangulS8L6Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有ㅂ收音的音节'**
  String get hangulS8L6Step2Desc;

  /// No description provided for @hangulS8L6SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L6SummaryTitle;

  /// No description provided for @hangulS8L6SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你掌握了ㅂ收音。'**
  String get hangulS8L6SummaryMsg;

  /// No description provided for @hangulS8L7Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅅ收音'**
  String get hangulS8L7Title;

  /// No description provided for @hangulS8L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'옷 · 맛 · 빛'**
  String get hangulS8L7Subtitle;

  /// No description provided for @hangulS8L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'聆听ㅅ收音'**
  String get hangulS8L7Step0Title;

  /// No description provided for @hangulS8L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听옷/맛/빛'**
  String get hangulS8L7Step0Desc;

  /// No description provided for @hangulS8L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS8L7Step1Title;

  /// No description provided for @hangulS8L7Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声朗读每个字'**
  String get hangulS8L7Step1Desc;

  /// No description provided for @hangulS8L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'辨别收音'**
  String get hangulS8L7Step2Title;

  /// No description provided for @hangulS8L7Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出ㅅ收音的音节'**
  String get hangulS8L7Step2Desc;

  /// No description provided for @hangulS8L7Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㅅ收音？'**
  String get hangulS8L7Step2Q0;

  /// No description provided for @hangulS8L7Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㅅ收音？'**
  String get hangulS8L7Step2Q1;

  /// No description provided for @hangulS8L7SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L7SummaryTitle;

  /// No description provided for @hangulS8L7SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你掌握了ㅅ收音。'**
  String get hangulS8L7SummaryMsg;

  /// No description provided for @hangulS8L8Title.
  ///
  /// In zh, this message translates to:
  /// **'收音综合复习'**
  String get hangulS8L8Title;

  /// No description provided for @hangulS8L8Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'核心收音随机检测'**
  String get hangulS8L8Subtitle;

  /// No description provided for @hangulS8L8Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'全部混合练习'**
  String get hangulS8L8Step0Title;

  /// No description provided for @hangulS8L8Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'我们来综合复习ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ。'**
  String get hangulS8L8Step0Desc;

  /// No description provided for @hangulS8L8Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'随机测验'**
  String get hangulS8L8Step1Title;

  /// No description provided for @hangulS8L8Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'混合收音综合测试'**
  String get hangulS8L8Step1Desc;

  /// No description provided for @hangulS8L8Step1Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㄴ收音？'**
  String get hangulS8L8Step1Q0;

  /// No description provided for @hangulS8L8Step1Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㅇ收音？'**
  String get hangulS8L8Step1Q1;

  /// No description provided for @hangulS8L8Step1Q2.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㄹ收音？'**
  String get hangulS8L8Step1Q2;

  /// No description provided for @hangulS8L8Step1Q3.
  ///
  /// In zh, this message translates to:
  /// **'哪个有ㅂ收音？'**
  String get hangulS8L8Step1Q3;

  /// No description provided for @hangulS8L8SummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS8L8SummaryTitle;

  /// No description provided for @hangulS8L8SummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n完成了收音综合复习。'**
  String get hangulS8L8SummaryMsg;

  /// No description provided for @hangulS8LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务：收音挑战！'**
  String get hangulS8LMTitle;

  /// No description provided for @hangulS8LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'组合带收音的音节'**
  String get hangulS8LMSubtitle;

  /// No description provided for @hangulS8LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'收音任务！'**
  String get hangulS8LMStep0Title;

  /// No description provided for @hangulS8LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'读出带有基本收音的音节，\n快速作答！'**
  String get hangulS8LMStep0Desc;

  /// No description provided for @hangulS8LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'拼出音节！'**
  String get hangulS8LMStep1Title;

  /// No description provided for @hangulS8LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS8LMStep2Title;

  /// No description provided for @hangulS8LMSummaryTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务完成！'**
  String get hangulS8LMSummaryTitle;

  /// No description provided for @hangulS8LMSummaryMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已完全掌握收音基础！'**
  String get hangulS8LMSummaryMsg;

  /// No description provided for @hangulS8CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第8阶段完成！'**
  String get hangulS8CompleteTitle;

  /// No description provided for @hangulS8CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已打好收音的基础！'**
  String get hangulS8CompleteMsg;

  /// No description provided for @hangulS9L1Title.
  ///
  /// In zh, this message translates to:
  /// **'收音 ㄷ 扩展'**
  String get hangulS9L1Title;

  /// No description provided for @hangulS9L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'닫 · 곧 · 묻'**
  String get hangulS9L1Subtitle;

  /// No description provided for @hangulS9L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄷ 收音规律'**
  String get hangulS9L1Step0Title;

  /// No description provided for @hangulS9L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'读一读带有收音 ㄷ 的音节。'**
  String get hangulS9L1Step0Desc;

  /// No description provided for @hangulS9L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'닫,곧,묻'**
  String get hangulS9L1Step0Highlights;

  /// No description provided for @hangulS9L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听一听：收音 ㄷ'**
  String get hangulS9L1Step1Title;

  /// No description provided for @hangulS9L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听 닫/곧/묻 的发音'**
  String get hangulS9L1Step1Desc;

  /// No description provided for @hangulS9L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS9L1Step2Title;

  /// No description provided for @hangulS9L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'亲自大声念出每个字'**
  String get hangulS9L1Step2Desc;

  /// No description provided for @hangulS9L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'辨别收音'**
  String get hangulS9L1Step3Title;

  /// No description provided for @hangulS9L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有收音 ㄷ 的音节'**
  String get hangulS9L1Step3Desc;

  /// No description provided for @hangulS9L1Step3Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㄷ？'**
  String get hangulS9L1Step3Q0;

  /// No description provided for @hangulS9L1Step3Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㄷ？'**
  String get hangulS9L1Step3Q1;

  /// No description provided for @hangulS9L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS9L1Step4Title;

  /// No description provided for @hangulS9L1Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握收音 ㄷ。'**
  String get hangulS9L1Step4Msg;

  /// No description provided for @hangulS9L2Title.
  ///
  /// In zh, this message translates to:
  /// **'收音 ㅈ 扩展'**
  String get hangulS9L2Title;

  /// No description provided for @hangulS9L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'낮 · 잊 · 젖'**
  String get hangulS9L2Subtitle;

  /// No description provided for @hangulS9L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听一听：收音 ㅈ'**
  String get hangulS9L2Step0Title;

  /// No description provided for @hangulS9L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听 낮/잊/젖 的发音'**
  String get hangulS9L2Step0Desc;

  /// No description provided for @hangulS9L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS9L2Step1Title;

  /// No description provided for @hangulS9L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'亲自大声念出每个字'**
  String get hangulS9L2Step1Desc;

  /// No description provided for @hangulS9L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS9L2Step2Title;

  /// No description provided for @hangulS9L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有收音 ㅈ 的音节'**
  String get hangulS9L2Step2Desc;

  /// No description provided for @hangulS9L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS9L2Step3Title;

  /// No description provided for @hangulS9L2Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握收音 ㅈ。'**
  String get hangulS9L2Step3Msg;

  /// No description provided for @hangulS9L3Title.
  ///
  /// In zh, this message translates to:
  /// **'收音 ㅊ 扩展'**
  String get hangulS9L3Title;

  /// No description provided for @hangulS9L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'꽃 · 닻 · 빚'**
  String get hangulS9L3Subtitle;

  /// No description provided for @hangulS9L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听一听：收音 ㅊ'**
  String get hangulS9L3Step0Title;

  /// No description provided for @hangulS9L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听 꽃/닻/빚 的发音'**
  String get hangulS9L3Step0Desc;

  /// No description provided for @hangulS9L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS9L3Step1Title;

  /// No description provided for @hangulS9L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'亲自大声念出每个字'**
  String get hangulS9L3Step1Desc;

  /// No description provided for @hangulS9L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'辨别收音'**
  String get hangulS9L3Step2Title;

  /// No description provided for @hangulS9L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有收音 ㅊ 的音节'**
  String get hangulS9L3Step2Desc;

  /// No description provided for @hangulS9L3Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㅊ？'**
  String get hangulS9L3Step2Q0;

  /// No description provided for @hangulS9L3Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㅊ？'**
  String get hangulS9L3Step2Q1;

  /// No description provided for @hangulS9L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS9L3Step3Title;

  /// No description provided for @hangulS9L3Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握收音 ㅊ。'**
  String get hangulS9L3Step3Msg;

  /// No description provided for @hangulS9L4Title.
  ///
  /// In zh, this message translates to:
  /// **'收音 ㅋ / ㅌ / ㅍ'**
  String get hangulS9L4Title;

  /// No description provided for @hangulS9L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'부엌 · 밭 · 앞'**
  String get hangulS9L4Subtitle;

  /// No description provided for @hangulS9L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'三个收音合并学习'**
  String get hangulS9L4Step0Title;

  /// No description provided for @hangulS9L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'把 ㅋ、ㅌ、ㅍ 三个收音放在一起学。'**
  String get hangulS9L4Step0Desc;

  /// No description provided for @hangulS9L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'부엌,밭,앞'**
  String get hangulS9L4Step0Highlights;

  /// No description provided for @hangulS9L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听一听'**
  String get hangulS9L4Step1Title;

  /// No description provided for @hangulS9L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听 부엌/밭/앞 的发音'**
  String get hangulS9L4Step1Desc;

  /// No description provided for @hangulS9L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS9L4Step2Title;

  /// No description provided for @hangulS9L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'亲自大声念出每个字'**
  String get hangulS9L4Step2Desc;

  /// No description provided for @hangulS9L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'辨别收音'**
  String get hangulS9L4Step3Title;

  /// No description provided for @hangulS9L4Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分这三个收音'**
  String get hangulS9L4Step3Desc;

  /// No description provided for @hangulS9L4Step3Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㅌ？'**
  String get hangulS9L4Step3Q0;

  /// No description provided for @hangulS9L4Step3Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㅍ？'**
  String get hangulS9L4Step3Q1;

  /// No description provided for @hangulS9L4Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS9L4Step4Title;

  /// No description provided for @hangulS9L4Step4Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握收音 ㅋ/ㅌ/ㅍ。'**
  String get hangulS9L4Step4Msg;

  /// No description provided for @hangulS9L5Title.
  ///
  /// In zh, this message translates to:
  /// **'收音 ㅎ 扩展'**
  String get hangulS9L5Title;

  /// No description provided for @hangulS9L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'좋 · 놓 · 않'**
  String get hangulS9L5Subtitle;

  /// No description provided for @hangulS9L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听一听：收音 ㅎ'**
  String get hangulS9L5Step0Title;

  /// No description provided for @hangulS9L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听 좋/놓/않 的发音'**
  String get hangulS9L5Step0Desc;

  /// No description provided for @hangulS9L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS9L5Step1Title;

  /// No description provided for @hangulS9L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'亲自大声念出每个字'**
  String get hangulS9L5Step1Desc;

  /// No description provided for @hangulS9L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听音选字'**
  String get hangulS9L5Step2Title;

  /// No description provided for @hangulS9L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选出带有收音 ㅎ 的音节'**
  String get hangulS9L5Step2Desc;

  /// No description provided for @hangulS9L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS9L5Step3Title;

  /// No description provided for @hangulS9L5Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已掌握收音 ㅎ。'**
  String get hangulS9L5Step3Msg;

  /// No description provided for @hangulS9L6Title.
  ///
  /// In zh, this message translates to:
  /// **'扩展收音随机练习'**
  String get hangulS9L6Title;

  /// No description provided for @hangulS9L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'混合 ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ'**
  String get hangulS9L6Subtitle;

  /// No description provided for @hangulS9L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'混合扩展收音'**
  String get hangulS9L6Step0Title;

  /// No description provided for @hangulS9L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'随机复习所有扩展收音。'**
  String get hangulS9L6Step0Desc;

  /// No description provided for @hangulS9L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'随机测验'**
  String get hangulS9L6Step1Title;

  /// No description provided for @hangulS9L6Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'解题并区分各个收音'**
  String get hangulS9L6Step1Desc;

  /// No description provided for @hangulS9L6Step1Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㄷ？'**
  String get hangulS9L6Step1Q0;

  /// No description provided for @hangulS9L6Step1Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㅈ？'**
  String get hangulS9L6Step1Q1;

  /// No description provided for @hangulS9L6Step1Q2.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㅊ？'**
  String get hangulS9L6Step1Q2;

  /// No description provided for @hangulS9L6Step1Q3.
  ///
  /// In zh, this message translates to:
  /// **'哪个带有收音 ㅎ？'**
  String get hangulS9L6Step1Q3;

  /// No description provided for @hangulS9L6Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS9L6Step2Title;

  /// No description provided for @hangulS9L6Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n扩展收音随机复习完成。'**
  String get hangulS9L6Step2Msg;

  /// No description provided for @hangulS9L7Title.
  ///
  /// In zh, this message translates to:
  /// **'第9阶段综合'**
  String get hangulS9L7Title;

  /// No description provided for @hangulS9L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'扩展收音阅读收尾'**
  String get hangulS9L7Subtitle;

  /// No description provided for @hangulS9L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'最终确认'**
  String get hangulS9L7Step0Title;

  /// No description provided for @hangulS9L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'最终复习第9阶段的核心要点'**
  String get hangulS9L7Step0Desc;

  /// No description provided for @hangulS9L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'第9阶段完成！'**
  String get hangulS9L7Step1Title;

  /// No description provided for @hangulS9L7Step1Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你已完成第9阶段的扩展收音学习。'**
  String get hangulS9L7Step1Msg;

  /// No description provided for @hangulS9LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务：扩展收音挑战！'**
  String get hangulS9LMTitle;

  /// No description provided for @hangulS9LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'快速读出各种收音'**
  String get hangulS9LMSubtitle;

  /// No description provided for @hangulS9LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'扩展收音任务！'**
  String get hangulS9LMStep0Title;

  /// No description provided for @hangulS9LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'以最快速度组合含扩展收音的音节！'**
  String get hangulS9LMStep0Desc;

  /// No description provided for @hangulS9LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'组合音节！'**
  String get hangulS9LMStep1Title;

  /// No description provided for @hangulS9LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS9LMStep2Title;

  /// No description provided for @hangulS9LMStep3Title.
  ///
  /// In zh, this message translates to:
  /// **'任务完成！'**
  String get hangulS9LMStep3Title;

  /// No description provided for @hangulS9LMStep3Msg.
  ///
  /// In zh, this message translates to:
  /// **'你已征服扩展收音！'**
  String get hangulS9LMStep3Msg;

  /// No description provided for @hangulS9CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第9阶段完成！'**
  String get hangulS9CompleteTitle;

  /// No description provided for @hangulS9CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你已征服扩展收音！'**
  String get hangulS9CompleteMsg;

  /// No description provided for @hangulS10L1Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄳ 收音'**
  String get hangulS10L1Title;

  /// No description provided for @hangulS10L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'以 몫・넋 为中心阅读'**
  String get hangulS10L1Subtitle;

  /// No description provided for @hangulS10L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'双收音的发音规则'**
  String get hangulS10L1Step0Title;

  /// No description provided for @hangulS10L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'双收音是由两个辅音组合而成的收音。\n\n大多数读左边的辅音：\nㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\n少数读右边的辅音：\nㄺ→[ㄹ], ㄼ→[ㄹ]'**
  String get hangulS10L1Step0Desc;

  /// No description provided for @hangulS10L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'左边辅音,右边辅音,双收音'**
  String get hangulS10L1Step0Highlights;

  /// No description provided for @hangulS10L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'开始学习复合收音'**
  String get hangulS10L1Step1Title;

  /// No description provided for @hangulS10L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'来读含有 ㄳ 收音的单词吧。'**
  String get hangulS10L1Step1Desc;

  /// No description provided for @hangulS10L1Step1Highlights.
  ///
  /// In zh, this message translates to:
  /// **'몫,넋'**
  String get hangulS10L1Step1Highlights;

  /// No description provided for @hangulS10L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听发音'**
  String get hangulS10L1Step2Title;

  /// No description provided for @hangulS10L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听 몫/넋'**
  String get hangulS10L1Step2Desc;

  /// No description provided for @hangulS10L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS10L1Step3Title;

  /// No description provided for @hangulS10L1Step3Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个字'**
  String get hangulS10L1Step3Desc;

  /// No description provided for @hangulS10L1Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'阅读检测'**
  String get hangulS10L1Step4Title;

  /// No description provided for @hangulS10L1Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'看单词并选择正确答案'**
  String get hangulS10L1Step4Desc;

  /// No description provided for @hangulS10L1Step4Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个单词有 ㄳ 收音？'**
  String get hangulS10L1Step4Q0;

  /// No description provided for @hangulS10L1Step4Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个单词有 ㄳ 收音？'**
  String get hangulS10L1Step4Q1;

  /// No description provided for @hangulS10L1Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS10L1Step5Title;

  /// No description provided for @hangulS10L1Step5Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经掌握了 ㄳ 收音。'**
  String get hangulS10L1Step5Msg;

  /// No description provided for @hangulS10L2Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄵ / ㄶ 收音'**
  String get hangulS10L2Title;

  /// No description provided for @hangulS10L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'앉다・많다'**
  String get hangulS10L2Subtitle;

  /// No description provided for @hangulS10L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听发音'**
  String get hangulS10L2Step0Title;

  /// No description provided for @hangulS10L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听 앉다/많다'**
  String get hangulS10L2Step0Desc;

  /// No description provided for @hangulS10L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS10L2Step1Title;

  /// No description provided for @hangulS10L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个字'**
  String get hangulS10L2Step1Desc;

  /// No description provided for @hangulS10L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听后选择'**
  String get hangulS10L2Step2Title;

  /// No description provided for @hangulS10L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选择正确的单词'**
  String get hangulS10L2Step2Desc;

  /// No description provided for @hangulS10L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS10L2Step3Title;

  /// No description provided for @hangulS10L2Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经掌握了 ㄵ/ㄶ 收音。'**
  String get hangulS10L2Step3Msg;

  /// No description provided for @hangulS10L3Title.
  ///
  /// In zh, this message translates to:
  /// **'ㄺ / ㄻ 收音'**
  String get hangulS10L3Title;

  /// No description provided for @hangulS10L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'읽다・삶'**
  String get hangulS10L3Subtitle;

  /// No description provided for @hangulS10L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听发音'**
  String get hangulS10L3Step0Title;

  /// No description provided for @hangulS10L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听 읽다/삶'**
  String get hangulS10L3Step0Desc;

  /// No description provided for @hangulS10L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS10L3Step1Title;

  /// No description provided for @hangulS10L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个字'**
  String get hangulS10L3Step1Desc;

  /// No description provided for @hangulS10L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'阅读检测'**
  String get hangulS10L3Step2Title;

  /// No description provided for @hangulS10L3Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选择含复合收音的单词'**
  String get hangulS10L3Step2Desc;

  /// No description provided for @hangulS10L3Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个单词有 ㄺ 收音？'**
  String get hangulS10L3Step2Q0;

  /// No description provided for @hangulS10L3Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个单词有 ㄻ 收音？'**
  String get hangulS10L3Step2Q1;

  /// No description provided for @hangulS10L3Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS10L3Step3Title;

  /// No description provided for @hangulS10L3Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经掌握了 ㄺ/ㄻ 收音。'**
  String get hangulS10L3Step3Msg;

  /// No description provided for @hangulS10L4Title.
  ///
  /// In zh, this message translates to:
  /// **'高级组合 1'**
  String get hangulS10L4Title;

  /// No description provided for @hangulS10L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'ㄼ・ㄾ・ㄿ・ㅀ'**
  String get hangulS10L4Subtitle;

  /// No description provided for @hangulS10L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'高级组合介绍'**
  String get hangulS10L4Step0Title;

  /// No description provided for @hangulS10L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'通过常见例子简短地学习。'**
  String get hangulS10L4Step0Desc;

  /// No description provided for @hangulS10L4Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'넓다,핥다,읊다,싫다'**
  String get hangulS10L4Step0Highlights;

  /// No description provided for @hangulS10L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听单词发音'**
  String get hangulS10L4Step1Title;

  /// No description provided for @hangulS10L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听 넓다/핥다/읊다/싫다'**
  String get hangulS10L4Step1Desc;

  /// No description provided for @hangulS10L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS10L4Step2Title;

  /// No description provided for @hangulS10L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个字'**
  String get hangulS10L4Step2Desc;

  /// No description provided for @hangulS10L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS10L4Step3Title;

  /// No description provided for @hangulS10L4Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经掌握了高级组合 1。'**
  String get hangulS10L4Step3Msg;

  /// No description provided for @hangulS10L5Title.
  ///
  /// In zh, this message translates to:
  /// **'ㅄ 收音'**
  String get hangulS10L5Title;

  /// No description provided for @hangulS10L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'以 없다 为中心阅读'**
  String get hangulS10L5Subtitle;

  /// No description provided for @hangulS10L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听发音'**
  String get hangulS10L5Step0Title;

  /// No description provided for @hangulS10L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听一听 없다/없어'**
  String get hangulS10L5Step0Desc;

  /// No description provided for @hangulS10L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS10L5Step1Title;

  /// No description provided for @hangulS10L5Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'请大声读出每个字'**
  String get hangulS10L5Step1Desc;

  /// No description provided for @hangulS10L5Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听后选择'**
  String get hangulS10L5Step2Title;

  /// No description provided for @hangulS10L5Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选择正确的单词'**
  String get hangulS10L5Step2Desc;

  /// No description provided for @hangulS10L5Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS10L5Step3Title;

  /// No description provided for @hangulS10L5Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你已经掌握了 ㅄ 收音。'**
  String get hangulS10L5Step3Msg;

  /// No description provided for @hangulS10L6Title.
  ///
  /// In zh, this message translates to:
  /// **'第10阶段综合'**
  String get hangulS10L6Title;

  /// No description provided for @hangulS10L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'复合收音单词综合'**
  String get hangulS10L6Subtitle;

  /// No description provided for @hangulS10L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'综合检测'**
  String get hangulS10L6Step0Title;

  /// No description provided for @hangulS10L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'对复合收音单词进行最终检测'**
  String get hangulS10L6Step0Desc;

  /// No description provided for @hangulS10L6Step0Q0.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个单词有 ㄶ 收音？'**
  String get hangulS10L6Step0Q0;

  /// No description provided for @hangulS10L6Step0Q1.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个单词有 ㄺ 收音？'**
  String get hangulS10L6Step0Q1;

  /// No description provided for @hangulS10L6Step0Q2.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个单词有 ㅄ 收音？'**
  String get hangulS10L6Step0Q2;

  /// No description provided for @hangulS10L6Step0Q3.
  ///
  /// In zh, this message translates to:
  /// **'以下哪个单词有 ㄳ 收音？'**
  String get hangulS10L6Step0Q3;

  /// No description provided for @hangulS10L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'第10阶段完成！'**
  String get hangulS10L6Step1Title;

  /// No description provided for @hangulS10L6Step1Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你完成了第10阶段的复合收音。'**
  String get hangulS10L6Step1Msg;

  /// No description provided for @hangulS10LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务：双收音挑战！'**
  String get hangulS10LMTitle;

  /// No description provided for @hangulS10LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'快速阅读双收音单词'**
  String get hangulS10LMSubtitle;

  /// No description provided for @hangulS10LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'双收音任务！'**
  String get hangulS10LMStep0Title;

  /// No description provided for @hangulS10LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'快速组合包含双收音的音节！'**
  String get hangulS10LMStep0Desc;

  /// No description provided for @hangulS10LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'组合音节！'**
  String get hangulS10LMStep1Title;

  /// No description provided for @hangulS10LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS10LMStep2Title;

  /// No description provided for @hangulS10LMStep3Title.
  ///
  /// In zh, this message translates to:
  /// **'任务完成！'**
  String get hangulS10LMStep3Title;

  /// No description provided for @hangulS10LMStep3Msg.
  ///
  /// In zh, this message translates to:
  /// **'你连双收音都掌握了！'**
  String get hangulS10LMStep3Msg;

  /// No description provided for @hangulS10LMStep4Title.
  ///
  /// In zh, this message translates to:
  /// **'第10阶段完成！'**
  String get hangulS10LMStep4Title;

  /// No description provided for @hangulS10CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第10阶段完成！'**
  String get hangulS10CompleteTitle;

  /// No description provided for @hangulS10CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你连双收音都掌握了！'**
  String get hangulS10CompleteMsg;

  /// No description provided for @hangulS11L1Title.
  ///
  /// In zh, this message translates to:
  /// **'无收音的单词'**
  String get hangulS11L1Title;

  /// No description provided for @hangulS11L1Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'简单的2~3音节单词'**
  String get hangulS11L1Subtitle;

  /// No description provided for @hangulS11L1Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'开始读单词'**
  String get hangulS11L1Step0Title;

  /// No description provided for @hangulS11L1Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'先用没有收音的单词建立自信吧。'**
  String get hangulS11L1Step0Desc;

  /// No description provided for @hangulS11L1Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'바나나,나비,하마,모자'**
  String get hangulS11L1Step0Highlights;

  /// No description provided for @hangulS11L1Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'听单词'**
  String get hangulS11L1Step1Title;

  /// No description provided for @hangulS11L1Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听 바나나 / 나비 / 하마 / 모자'**
  String get hangulS11L1Step1Desc;

  /// No description provided for @hangulS11L1Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS11L1Step2Title;

  /// No description provided for @hangulS11L1Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声读出每个字'**
  String get hangulS11L1Step2Desc;

  /// No description provided for @hangulS11L1Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS11L1Step3Title;

  /// No description provided for @hangulS11L1Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你开始读没有收音的单词了。'**
  String get hangulS11L1Step3Msg;

  /// No description provided for @hangulS11L2Title.
  ///
  /// In zh, this message translates to:
  /// **'基本收音单词'**
  String get hangulS11L2Title;

  /// No description provided for @hangulS11L2Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'학교・친구・한국・공부'**
  String get hangulS11L2Subtitle;

  /// No description provided for @hangulS11L2Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听单词'**
  String get hangulS11L2Step0Title;

  /// No description provided for @hangulS11L2Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听听 학교 / 친구 / 한국 / 공부'**
  String get hangulS11L2Step0Desc;

  /// No description provided for @hangulS11L2Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS11L2Step1Title;

  /// No description provided for @hangulS11L2Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声读出每个字'**
  String get hangulS11L2Step1Desc;

  /// No description provided for @hangulS11L2Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'听后选择'**
  String get hangulS11L2Step2Title;

  /// No description provided for @hangulS11L2Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'选择你听到的单词'**
  String get hangulS11L2Step2Desc;

  /// No description provided for @hangulS11L2Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS11L2Step3Title;

  /// No description provided for @hangulS11L2Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你读了基本收音的单词。'**
  String get hangulS11L2Step3Msg;

  /// No description provided for @hangulS11L3Title.
  ///
  /// In zh, this message translates to:
  /// **'混合收音单词'**
  String get hangulS11L3Title;

  /// No description provided for @hangulS11L3Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'읽기・없다・많다・닭'**
  String get hangulS11L3Subtitle;

  /// No description provided for @hangulS11L3Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'提升难度'**
  String get hangulS11L3Step0Title;

  /// No description provided for @hangulS11L3Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'来读含基本和复合收音的混合单词吧。'**
  String get hangulS11L3Step0Desc;

  /// No description provided for @hangulS11L3Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'읽기,없다,많다,닭'**
  String get hangulS11L3Step0Highlights;

  /// No description provided for @hangulS11L3Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'区分单词'**
  String get hangulS11L3Step1Title;

  /// No description provided for @hangulS11L3Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'区分相似的单词'**
  String get hangulS11L3Step1Desc;

  /// No description provided for @hangulS11L3Step1Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个是复合收音的单词？'**
  String get hangulS11L3Step1Q0;

  /// No description provided for @hangulS11L3Step1Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个是复合收音的单词？'**
  String get hangulS11L3Step1Q1;

  /// No description provided for @hangulS11L3Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS11L3Step2Title;

  /// No description provided for @hangulS11L3Step2Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你读了混合收音的单词。'**
  String get hangulS11L3Step2Msg;

  /// No description provided for @hangulS11L4Title.
  ///
  /// In zh, this message translates to:
  /// **'分类单词包'**
  String get hangulS11L4Title;

  /// No description provided for @hangulS11L4Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'食物・地点・人物'**
  String get hangulS11L4Subtitle;

  /// No description provided for @hangulS11L4Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'听分类单词'**
  String get hangulS11L4Step0Title;

  /// No description provided for @hangulS11L4Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听食物 / 地点 / 人物的单词'**
  String get hangulS11L4Step0Desc;

  /// No description provided for @hangulS11L4Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS11L4Step1Title;

  /// No description provided for @hangulS11L4Step1Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声读出每个字'**
  String get hangulS11L4Step1Desc;

  /// No description provided for @hangulS11L4Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'按类别分类'**
  String get hangulS11L4Step2Title;

  /// No description provided for @hangulS11L4Step2Desc.
  ///
  /// In zh, this message translates to:
  /// **'看单词，选择它的类别'**
  String get hangulS11L4Step2Desc;

  /// No description provided for @hangulS11L4Step2Q0.
  ///
  /// In zh, this message translates to:
  /// **'「김치」是什么？'**
  String get hangulS11L4Step2Q0;

  /// No description provided for @hangulS11L4Step2Q1.
  ///
  /// In zh, this message translates to:
  /// **'「시장」是什么？'**
  String get hangulS11L4Step2Q1;

  /// No description provided for @hangulS11L4Step2Q2.
  ///
  /// In zh, this message translates to:
  /// **'「학생」是什么？'**
  String get hangulS11L4Step2Q2;

  /// No description provided for @hangulS11L4Step2CatFood.
  ///
  /// In zh, this message translates to:
  /// **'食物'**
  String get hangulS11L4Step2CatFood;

  /// No description provided for @hangulS11L4Step2CatPlace.
  ///
  /// In zh, this message translates to:
  /// **'地点'**
  String get hangulS11L4Step2CatPlace;

  /// No description provided for @hangulS11L4Step2CatPerson.
  ///
  /// In zh, this message translates to:
  /// **'人物'**
  String get hangulS11L4Step2CatPerson;

  /// No description provided for @hangulS11L4Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS11L4Step3Title;

  /// No description provided for @hangulS11L4Step3Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你学习了分类单词。'**
  String get hangulS11L4Step3Msg;

  /// No description provided for @hangulS11L5Title.
  ///
  /// In zh, this message translates to:
  /// **'听后选词'**
  String get hangulS11L5Title;

  /// No description provided for @hangulS11L5Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'加强听觉与阅读的联系'**
  String get hangulS11L5Subtitle;

  /// No description provided for @hangulS11L5Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'声音匹配'**
  String get hangulS11L5Step0Title;

  /// No description provided for @hangulS11L5Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'听后选出正确的单词'**
  String get hangulS11L5Step0Desc;

  /// No description provided for @hangulS11L5Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get hangulS11L5Step1Title;

  /// No description provided for @hangulS11L5Step1Msg.
  ///
  /// In zh, this message translates to:
  /// **'很好！\n你完成了听后选词训练。'**
  String get hangulS11L5Step1Msg;

  /// No description provided for @hangulS11L6Title.
  ///
  /// In zh, this message translates to:
  /// **'第11阶段综合复习'**
  String get hangulS11L6Title;

  /// No description provided for @hangulS11L6Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'单词阅读最终检验'**
  String get hangulS11L6Subtitle;

  /// No description provided for @hangulS11L6Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'综合测验'**
  String get hangulS11L6Step0Title;

  /// No description provided for @hangulS11L6Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'第11阶段单词综合检验'**
  String get hangulS11L6Step0Desc;

  /// No description provided for @hangulS11L6Step0Q0.
  ///
  /// In zh, this message translates to:
  /// **'哪个单词没有收音？'**
  String get hangulS11L6Step0Q0;

  /// No description provided for @hangulS11L6Step0Q1.
  ///
  /// In zh, this message translates to:
  /// **'哪个是基本收音的单词？'**
  String get hangulS11L6Step0Q1;

  /// No description provided for @hangulS11L6Step0Q2.
  ///
  /// In zh, this message translates to:
  /// **'哪个是复合收音的单词？'**
  String get hangulS11L6Step0Q2;

  /// No description provided for @hangulS11L6Step0Q3.
  ///
  /// In zh, this message translates to:
  /// **'哪个是地点单词？'**
  String get hangulS11L6Step0Q3;

  /// No description provided for @hangulS11L6Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'第11阶段完成！'**
  String get hangulS11L6Step1Title;

  /// No description provided for @hangulS11L6Step1Msg.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！\n你完成了第11阶段扩展单词阅读。'**
  String get hangulS11L6Step1Msg;

  /// No description provided for @hangulS11L7Title.
  ///
  /// In zh, this message translates to:
  /// **'在现实中读韩语'**
  String get hangulS11L7Title;

  /// No description provided for @hangulS11L7Subtitle.
  ///
  /// In zh, this message translates to:
  /// **'读咖啡菜单、地铁站名和问候语'**
  String get hangulS11L7Subtitle;

  /// No description provided for @hangulS11L7Step0Title.
  ///
  /// In zh, this message translates to:
  /// **'在韩国读韩文！'**
  String get hangulS11L7Step0Title;

  /// No description provided for @hangulS11L7Step0Desc.
  ///
  /// In zh, this message translates to:
  /// **'你已经学完了所有韩文！\n来读在韩国能看到的文字吧！'**
  String get hangulS11L7Step0Desc;

  /// No description provided for @hangulS11L7Step0Highlights.
  ///
  /// In zh, this message translates to:
  /// **'咖啡馆,地铁,问候语'**
  String get hangulS11L7Step0Highlights;

  /// No description provided for @hangulS11L7Step1Title.
  ///
  /// In zh, this message translates to:
  /// **'读咖啡菜单'**
  String get hangulS11L7Step1Title;

  /// No description provided for @hangulS11L7Step1Descs.
  ///
  /// In zh, this message translates to:
  /// **'美式咖啡,拿铁,绿茶,蛋糕'**
  String get hangulS11L7Step1Descs;

  /// No description provided for @hangulS11L7Step2Title.
  ///
  /// In zh, this message translates to:
  /// **'读地铁站名'**
  String get hangulS11L7Step2Title;

  /// No description provided for @hangulS11L7Step2Descs.
  ///
  /// In zh, this message translates to:
  /// **'首尔站,江南,弘大入口,明洞'**
  String get hangulS11L7Step2Descs;

  /// No description provided for @hangulS11L7Step3Title.
  ///
  /// In zh, this message translates to:
  /// **'读基本问候语'**
  String get hangulS11L7Step3Title;

  /// No description provided for @hangulS11L7Step3Descs.
  ///
  /// In zh, this message translates to:
  /// **'你好,谢谢,是,不是'**
  String get hangulS11L7Step3Descs;

  /// No description provided for @hangulS11L7Step4Title.
  ///
  /// In zh, this message translates to:
  /// **'发音练习'**
  String get hangulS11L7Step4Title;

  /// No description provided for @hangulS11L7Step4Desc.
  ///
  /// In zh, this message translates to:
  /// **'大声读出每个字'**
  String get hangulS11L7Step4Desc;

  /// No description provided for @hangulS11L7Step5Title.
  ///
  /// In zh, this message translates to:
  /// **'在哪里能看到？'**
  String get hangulS11L7Step5Title;

  /// No description provided for @hangulS11L7Step5Q0.
  ///
  /// In zh, this message translates to:
  /// **'「아메리카노」在哪里能看到？'**
  String get hangulS11L7Step5Q0;

  /// No description provided for @hangulS11L7Step5Q0Ans.
  ///
  /// In zh, this message translates to:
  /// **'咖啡馆'**
  String get hangulS11L7Step5Q0Ans;

  /// No description provided for @hangulS11L7Step5Q0C0.
  ///
  /// In zh, this message translates to:
  /// **'咖啡馆'**
  String get hangulS11L7Step5Q0C0;

  /// No description provided for @hangulS11L7Step5Q0C1.
  ///
  /// In zh, this message translates to:
  /// **'地铁'**
  String get hangulS11L7Step5Q0C1;

  /// No description provided for @hangulS11L7Step5Q0C2.
  ///
  /// In zh, this message translates to:
  /// **'学校'**
  String get hangulS11L7Step5Q0C2;

  /// No description provided for @hangulS11L7Step5Q1.
  ///
  /// In zh, this message translates to:
  /// **'「강남」是什么？'**
  String get hangulS11L7Step5Q1;

  /// No description provided for @hangulS11L7Step5Q1Ans.
  ///
  /// In zh, this message translates to:
  /// **'地铁站名'**
  String get hangulS11L7Step5Q1Ans;

  /// No description provided for @hangulS11L7Step5Q1C0.
  ///
  /// In zh, this message translates to:
  /// **'食物名称'**
  String get hangulS11L7Step5Q1C0;

  /// No description provided for @hangulS11L7Step5Q1C1.
  ///
  /// In zh, this message translates to:
  /// **'地铁站名'**
  String get hangulS11L7Step5Q1C1;

  /// No description provided for @hangulS11L7Step5Q1C2.
  ///
  /// In zh, this message translates to:
  /// **'问候语'**
  String get hangulS11L7Step5Q1C2;

  /// No description provided for @hangulS11L7Step5Q2.
  ///
  /// In zh, this message translates to:
  /// **'「감사합니다」用中文是？'**
  String get hangulS11L7Step5Q2;

  /// No description provided for @hangulS11L7Step5Q2Ans.
  ///
  /// In zh, this message translates to:
  /// **'谢谢'**
  String get hangulS11L7Step5Q2Ans;

  /// No description provided for @hangulS11L7Step5Q2C0.
  ///
  /// In zh, this message translates to:
  /// **'你好'**
  String get hangulS11L7Step5Q2C0;

  /// No description provided for @hangulS11L7Step5Q2C1.
  ///
  /// In zh, this message translates to:
  /// **'谢谢'**
  String get hangulS11L7Step5Q2C1;

  /// No description provided for @hangulS11L7Step5Q2C2.
  ///
  /// In zh, this message translates to:
  /// **'再见'**
  String get hangulS11L7Step5Q2C2;

  /// No description provided for @hangulS11L7Step6Title.
  ///
  /// In zh, this message translates to:
  /// **'恭喜！'**
  String get hangulS11L7Step6Title;

  /// No description provided for @hangulS11L7Step6Msg.
  ///
  /// In zh, this message translates to:
  /// **'你现在能读韩国的咖啡菜单、地铁站名和问候语了！\n离韩文大师只差一步！'**
  String get hangulS11L7Step6Msg;

  /// No description provided for @hangulS11LMTitle.
  ///
  /// In zh, this message translates to:
  /// **'任务：韩文速读！'**
  String get hangulS11LMTitle;

  /// No description provided for @hangulS11LMSubtitle.
  ///
  /// In zh, this message translates to:
  /// **'快速读出韩语单词'**
  String get hangulS11LMSubtitle;

  /// No description provided for @hangulS11LMStep0Title.
  ///
  /// In zh, this message translates to:
  /// **'韩文速读任务！'**
  String get hangulS11LMStep0Title;

  /// No description provided for @hangulS11LMStep0Desc.
  ///
  /// In zh, this message translates to:
  /// **'尽快读出并匹配韩语单词！\n是时候证明你的实力了！'**
  String get hangulS11LMStep0Desc;

  /// No description provided for @hangulS11LMStep1Title.
  ///
  /// In zh, this message translates to:
  /// **'组合音节！'**
  String get hangulS11LMStep1Title;

  /// No description provided for @hangulS11LMStep2Title.
  ///
  /// In zh, this message translates to:
  /// **'任务结果'**
  String get hangulS11LMStep2Title;

  /// No description provided for @hangulS11LMStep3Title.
  ///
  /// In zh, this message translates to:
  /// **'韩文大师！'**
  String get hangulS11LMStep3Title;

  /// No description provided for @hangulS11LMStep3Msg.
  ///
  /// In zh, this message translates to:
  /// **'你已经完全掌握韩文了！\n现在可以读韩语单词和句子了！'**
  String get hangulS11LMStep3Msg;

  /// No description provided for @hangulS11LMStep4Title.
  ///
  /// In zh, this message translates to:
  /// **'第11阶段完成！'**
  String get hangulS11LMStep4Title;

  /// No description provided for @hangulS11LMStep4Msg.
  ///
  /// In zh, this message translates to:
  /// **'你现在能完整地读韩文了！'**
  String get hangulS11LMStep4Msg;

  /// No description provided for @hangulS11CompleteTitle.
  ///
  /// In zh, this message translates to:
  /// **'第11阶段完成！'**
  String get hangulS11CompleteTitle;

  /// No description provided for @hangulS11CompleteMsg.
  ///
  /// In zh, this message translates to:
  /// **'你现在能完整地读韩文了！'**
  String get hangulS11CompleteMsg;

  /// No description provided for @stageRequestFailed.
  ///
  /// In zh, this message translates to:
  /// **'发送上台请求失败，请重试。'**
  String get stageRequestFailed;

  /// No description provided for @stageRequestRejected.
  ///
  /// In zh, this message translates to:
  /// **'主持人拒绝了你的上台请求。'**
  String get stageRequestRejected;

  /// No description provided for @inviteToStageFailed.
  ///
  /// In zh, this message translates to:
  /// **'邀请上台失败，舞台可能已满。'**
  String get inviteToStageFailed;

  /// No description provided for @demoteFailed.
  ///
  /// In zh, this message translates to:
  /// **'从舞台移除失败，请重试。'**
  String get demoteFailed;

  /// No description provided for @voiceRoomCloseRoomFailed.
  ///
  /// In zh, this message translates to:
  /// **'关闭房间失败，请重试。'**
  String get voiceRoomCloseRoomFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'ja', 'ko', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.countryCode) {
          case 'TW':
            return AppLocalizationsZhTw();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
