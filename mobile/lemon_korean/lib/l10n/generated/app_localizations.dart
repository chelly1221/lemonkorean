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
  /// **'提示：课程内容将使用您选择的中文字体显示。'**
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
  /// **'即使没有网络连接，您也可以正常学习已下载的课程。进度会在本地保存，联网后自动同步。'**
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
  /// **'基于间隔重复算法（SRS），应用会在最佳时间提醒您复习已学课程。复习间隔：1天 → 3天 → 7天 → 14天 → 30天。'**
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
  /// **'在主页面选择适合您水平的课程，从第1课开始。每节课包含7个学习阶段。'**
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

  /// Lesson complete message
  ///
  /// In zh, this message translates to:
  /// **'课程完成！'**
  String get lessonComplete;

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

  /// Grammar explanation title
  ///
  /// In zh, this message translates to:
  /// **'语法讲解'**
  String get grammarExplanation;

  /// Example sentences label
  ///
  /// In zh, this message translates to:
  /// **'例句'**
  String get exampleSentences;

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

  /// Continue button
  ///
  /// In zh, this message translates to:
  /// **'继续'**
  String get continueBtn;

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

  /// Fill in blank question type
  ///
  /// In zh, this message translates to:
  /// **'填空'**
  String get fillBlank;

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

  /// Pronunciation question type
  ///
  /// In zh, this message translates to:
  /// **'发音'**
  String get pronunciation;

  /// Excellent feedback
  ///
  /// In zh, this message translates to:
  /// **'太棒了！'**
  String get excellent;

  /// Correct order is prefix
  ///
  /// In zh, this message translates to:
  /// **'正确顺序是:'**
  String get correctOrderIs;

  /// Correct answer is prefix
  ///
  /// In zh, this message translates to:
  /// **'正确答案是:'**
  String get correctAnswerIs;

  /// Previous question button
  ///
  /// In zh, this message translates to:
  /// **'上一题'**
  String get previousQuestion;

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
  /// **'用时: {time}'**
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
  /// **'柠檬韩语'**
  String get onboardingLanguageTitle;

  /// Onboarding language selection prompt
  ///
  /// In zh, this message translates to:
  /// **'请选择您的首选语言'**
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
  /// **'你的流利之旅从这里开始'**
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
