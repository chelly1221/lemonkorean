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

  /// Lesson completion message
  ///
  /// In zh, this message translates to:
  /// **'课程完成！进度已保存'**
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

  /// Grammar explanation section
  ///
  /// In zh, this message translates to:
  /// **'语法解释'**
  String get grammarExplanation;

  /// Example sentences section
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

  /// Fill in the blank
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

  /// Pronunciation label
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

  /// Correct answer display
  ///
  /// In zh, this message translates to:
  /// **'正确答案: {answer}'**
  String correctAnswerIs(String answer);

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
  /// **'{count} 个待复习'**
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
  /// **'已学习: {count}'**
  String learnedCount(int count);

  /// Hangul practice title
  ///
  /// In zh, this message translates to:
  /// **'韩文字母练习'**
  String get hangulPractice;

  /// Characters need review
  ///
  /// In zh, this message translates to:
  /// **'{count} 个字母需要复习'**
  String charactersNeedReview(int count);

  /// Characters available for practice
  ///
  /// In zh, this message translates to:
  /// **'{count} 个字母可练习'**
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
  /// **'正确答案: '**
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
  /// **'罗马字: '**
  String get romanization;

  /// Pronunciation label
  ///
  /// In zh, this message translates to:
  /// **'发音: '**
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

  /// Loading lesson message
  ///
  /// In zh, this message translates to:
  /// **'{title} 불러오는 중...'**
  String loadingLesson(String title);

  /// Cannot load lesson content error
  ///
  /// In zh, this message translates to:
  /// **'레슨 콘텐츠를 불러올 수 없습니다'**
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

  /// Grammar pattern title
  ///
  /// In zh, this message translates to:
  /// **'语法 · {pattern}'**
  String grammarPattern(String pattern);

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

  /// Check answer button
  ///
  /// In zh, this message translates to:
  /// **'检查答案'**
  String get checkAnswerBtn;

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
  /// **'学习单词'**
  String get vocabLearned;

  /// Grammar learned label
  ///
  /// In zh, this message translates to:
  /// **'学习语法'**
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

  /// No description provided for @likesCount.
  ///
  /// In zh, this message translates to:
  /// **'{count}个赞'**
  String likesCount(int count);

  /// No description provided for @commentsCount.
  ///
  /// In zh, this message translates to:
  /// **'{count}条评论'**
  String commentsCount(int count);

  /// No description provided for @followersCount.
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

  /// No description provided for @maxPhotos.
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
  /// **'用户不存在'**
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
  /// **'发言席位'**
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
  /// **'离开舞台'**
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
  /// **'舞台上'**
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
