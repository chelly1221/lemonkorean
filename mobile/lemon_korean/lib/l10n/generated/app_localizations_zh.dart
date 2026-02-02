// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '柠檬韩语';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get username => '用户名';

  @override
  String get enterEmail => '请输入邮箱地址';

  @override
  String get enterPassword => '请输入密码';

  @override
  String get enterConfirmPassword => '请再次输入密码';

  @override
  String get enterUsername => '请输入用户名';

  @override
  String get createAccount => '创建账号';

  @override
  String get startJourney => '开始你的韩语学习之旅';

  @override
  String get interfaceLanguage => '界面语言';

  @override
  String get simplifiedChinese => '简体中文';

  @override
  String get traditionalChinese => '繁体中文';

  @override
  String get passwordRequirements => '密码要求';

  @override
  String minCharacters(int count) {
    return '至少$count个字符';
  }

  @override
  String get containLettersNumbers => '包含字母和数字';

  @override
  String get haveAccount => '已有账号？';

  @override
  String get noAccount => '没有账号？';

  @override
  String get loginNow => '立即登录';

  @override
  String get registerNow => '立即注册';

  @override
  String get registerSuccess => '注册成功';

  @override
  String get registerFailed => '注册失败';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get loginFailed => '登录失败';

  @override
  String get networkError => '网络连接失败，请检查网络设置';

  @override
  String get invalidCredentials => '邮箱或密码错误';

  @override
  String get emailAlreadyExists => '邮箱已被注册';

  @override
  String get requestTimeout => '请求超时，请重试';

  @override
  String get operationFailed => '操作失败，请稍后重试';

  @override
  String get settings => '设置';

  @override
  String get languageSettings => '语言设置';

  @override
  String get chineseDisplay => '中文显示';

  @override
  String get chineseDisplayDesc => '选择中文文字显示方式。更改后将立即应用到所有界面。';

  @override
  String get switchedToSimplified => '已切换到简体中文';

  @override
  String get switchedToTraditional => '已切换到繁体中文';

  @override
  String get displayTip => '提示：课程内容将使用您选择的中文字体显示。';

  @override
  String get notificationSettings => '通知设置';

  @override
  String get enableNotifications => '启用通知';

  @override
  String get enableNotificationsDesc => '开启后可以接收学习提醒';

  @override
  String get permissionRequired => '请在系统设置中允许通知权限';

  @override
  String get dailyLearningReminder => '每日学习提醒';

  @override
  String get dailyReminder => '每日提醒';

  @override
  String get dailyReminderDesc => '每天固定时间提醒学习';

  @override
  String get reminderTime => '提醒时间';

  @override
  String reminderTimeSet(String time) {
    return '提醒时间已设置为 $time';
  }

  @override
  String get reviewReminder => '复习提醒';

  @override
  String get reviewReminderDesc => '根据记忆曲线提醒复习';

  @override
  String get notificationTip => '提示：';

  @override
  String get helpCenter => '帮助中心';

  @override
  String get offlineLearning => '离线学习';

  @override
  String get howToDownload => '如何下载课程？';

  @override
  String get howToDownloadAnswer => '在课程列表中，点击右侧的下载图标即可下载课程。下载后可以离线学习。';

  @override
  String get howToUseDownloaded => '如何使用已下载的课程？';

  @override
  String get howToUseDownloadedAnswer =>
      '即使没有网络连接，您也可以正常学习已下载的课程。进度会在本地保存，联网后自动同步。';

  @override
  String get storageManagement => '存储管理';

  @override
  String get howToCheckStorage => '如何查看存储空间？';

  @override
  String get howToCheckStorageAnswer => '进入【设置 → 存储管理】可以查看已使用和可用的存储空间。';

  @override
  String get howToDeleteDownloaded => '如何删除已下载的课程？';

  @override
  String get howToDeleteDownloadedAnswer => '在【存储管理】页面，点击课程旁边的删除按钮即可删除。';

  @override
  String get notificationSection => '通知设置';

  @override
  String get howToEnableReminder => '如何开启学习提醒？';

  @override
  String get howToEnableReminderAnswer =>
      '进入【设置 → 通知设置】，打开【启用通知】开关。首次使用需要授予通知权限。';

  @override
  String get whatIsReviewReminder => '什么是复习提醒？';

  @override
  String get whatIsReviewReminderAnswer =>
      '基于间隔重复算法（SRS），应用会在最佳时间提醒您复习已学课程。复习间隔：1天 → 3天 → 7天 → 14天 → 30天。';

  @override
  String get languageSection => '语言设置';

  @override
  String get howToSwitchChinese => '如何切换简繁体中文？';

  @override
  String get howToSwitchChineseAnswer =>
      '进入【设置 → 语言设置】，选择【简体中文】或【繁体中文】。更改后立即生效。';

  @override
  String get faq => '常见问题';

  @override
  String get howToStart => '如何开始学习？';

  @override
  String get howToStartAnswer => '在主页面选择适合您水平的课程，从第1课开始。每节课包含7个学习阶段。';

  @override
  String get progressNotSaved => '进度没有保存怎么办？';

  @override
  String get progressNotSavedAnswer => '进度会自动保存到本地。如果联网，会自动同步到服务器。请检查网络连接。';

  @override
  String get aboutApp => '关于应用';

  @override
  String get moreInfo => '更多信息';

  @override
  String get versionInfo => '版本信息';

  @override
  String get developer => '开发者';

  @override
  String get appIntro => '应用介绍';

  @override
  String get appIntroContent => '专为中文使用者设计的韩语学习应用，支持离线学习、智能复习提醒等功能。';

  @override
  String get termsOfService => '服务条款';

  @override
  String get termsComingSoon => '服务条款页面开发中...';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyComingSoon => '隐私政策页面开发中...';

  @override
  String get openSourceLicenses => '开源许可';

  @override
  String get notStarted => '未开始';

  @override
  String get inProgress => '进行中';

  @override
  String get completed => '已完成';

  @override
  String get notPassed => '未通过';

  @override
  String get timeToReview => '该复习了';

  @override
  String get today => '今天';

  @override
  String get tomorrow => '明天';

  @override
  String daysLater(int count) {
    return '$count天后';
  }

  @override
  String get noun => '名词';

  @override
  String get verb => '动词';

  @override
  String get adjective => '形容词';

  @override
  String get adverb => '副词';

  @override
  String get particle => '助词';

  @override
  String get pronoun => '代词';

  @override
  String get highSimilarity => '高相似度';

  @override
  String get mediumSimilarity => '中等相似度';

  @override
  String get lowSimilarity => '低相似度';

  @override
  String get lessonComplete => '课程完成！';

  @override
  String get learningComplete => '学习完成';

  @override
  String experiencePoints(int points) {
    return '经验值 +$points';
  }

  @override
  String get keepLearning => '继续保持学习热情';

  @override
  String get streakDays => '学习连续天数 +1';

  @override
  String streakDaysCount(int days) {
    return '已连续学习 $days 天';
  }

  @override
  String get lessonContent => '本课学习内容';

  @override
  String get words => '单词';

  @override
  String get grammarPoints => '语法点';

  @override
  String get dialogues => '对话';

  @override
  String get grammarExplanation => '语法讲解';

  @override
  String get exampleSentences => '例句';

  @override
  String get previous => '上一个';

  @override
  String get next => '下一个';

  @override
  String get continueBtn => '继续';

  @override
  String get topicParticle => '主题助词';

  @override
  String get honorificEnding => '敬语结尾';

  @override
  String get questionWord => '什么';

  @override
  String get hello => '你好';

  @override
  String get thankYou => '谢谢';

  @override
  String get goodbye => '再见';

  @override
  String get sorry => '对不起';

  @override
  String get imStudent => '我是学生';

  @override
  String get bookInteresting => '书很有趣';

  @override
  String get isStudent => '是学生';

  @override
  String get isTeacher => '是老师';

  @override
  String get whatIsThis => '这是什么？';

  @override
  String get whatDoingPolite => '在做什么？';

  @override
  String get listenAndChoose => '听音频，选择正确的翻译';

  @override
  String get fillInBlank => '填入正确的助词';

  @override
  String get chooseTranslation => '选择正确的翻译';

  @override
  String get arrangeWords => '按正确顺序排列单词';

  @override
  String get choosePronunciation => '选择正确的发音';

  @override
  String get consonantEnding => '当名词以辅音结尾时，应该使用哪个主题助词？';

  @override
  String get correctSentence => '选择正确的句子';

  @override
  String get allCorrect => '以上都对';

  @override
  String get howAreYou => '你好吗？';

  @override
  String get whatIsYourName => '你叫什么名字？';

  @override
  String get whoAreYou => '你是谁？';

  @override
  String get whereAreYou => '你在哪里？';

  @override
  String get niceToMeetYou => '很高兴认识你';

  @override
  String get areYouStudent => '你是学生';

  @override
  String get areYouStudentQuestion => '你是学生吗？';

  @override
  String get amIStudent => '我是学生吗？';

  @override
  String get listening => '听力';

  @override
  String get fillBlank => '填空';

  @override
  String get translation => '翻译';

  @override
  String get wordOrder => '排序';

  @override
  String get pronunciation => '发音';

  @override
  String get excellent => '太棒了！';

  @override
  String get correctOrderIs => '正确顺序是:';

  @override
  String get correctAnswerIs => '正确答案是:';

  @override
  String get previousQuestion => '上一题';

  @override
  String get nextQuestion => '下一题';

  @override
  String get finish => '完成';

  @override
  String get quizComplete => '测验完成！';

  @override
  String get greatJob => '太棒了！';

  @override
  String get keepPracticing => '继续加油！';

  @override
  String score(int correct, int total) {
    return '得分：$correct / $total';
  }

  @override
  String get masteredContent => '你已经很好地掌握了本课内容！';

  @override
  String get reviewSuggestion => '建议复习一下课程内容，再来挑战吧！';

  @override
  String timeUsed(String time) {
    return '用时: $time';
  }

  @override
  String get playAudio => '播放音频';

  @override
  String get replayAudio => '重新播放';

  @override
  String get vowelEnding => '以元音结尾，使用';

  @override
  String lessonNumber(int number) {
    return '第$number课';
  }

  @override
  String get stageIntro => '课程介绍';

  @override
  String get stageVocabulary => '词汇学习';

  @override
  String get stageGrammar => '语法讲解';

  @override
  String get stagePractice => '练习';

  @override
  String get stageDialogue => '对话练习';

  @override
  String get stageQuiz => '测验';

  @override
  String get stageSummary => '总结';

  @override
  String get downloadLesson => '下载课程';

  @override
  String get downloading => '下载中...';

  @override
  String get downloaded => '已下载';

  @override
  String get downloadFailed => '下载失败';

  @override
  String get home => '首页';

  @override
  String get lessons => '课程';

  @override
  String get review => '复习';

  @override
  String get profile => '我的';

  @override
  String get continueLearning => '继续学习';

  @override
  String get dailyGoal => '每日目标';

  @override
  String lessonsCompleted(int count) {
    return '已完成 $count 课';
  }

  @override
  String minutesLearned(int minutes) {
    return '已学习 $minutes 分钟';
  }

  @override
  String get welcome => '欢迎回来';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get logout => '退出登录';

  @override
  String get confirmLogout => '确定要退出登录吗？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get delete => '删除';

  @override
  String get save => '保存';

  @override
  String get edit => '编辑';

  @override
  String get close => '关闭';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中...';

  @override
  String get noData => '暂无数据';

  @override
  String get error => '出错了';

  @override
  String get success => '成功';

  @override
  String get filter => '筛选';

  @override
  String get reviewSchedule => '复习计划';

  @override
  String get todayReview => '今日复习';

  @override
  String get startReview => '开始复习';

  @override
  String get learningStats => '学习统计';

  @override
  String get completedLessonsCount => '已完成课程';

  @override
  String get studyDays => '学习天数';

  @override
  String get masteredWordsCount => '掌握单词';

  @override
  String get myVocabularyBook => '我的单词本';

  @override
  String get vocabularyBrowser => '单词浏览器';

  @override
  String get about => '关于';

  @override
  String get premiumMember => '高级会员';

  @override
  String get freeUser => '免费用户';

  @override
  String wordsWaitingReview(int count) {
    return '$count个单词等待复习';
  }

  @override
  String get user => '用户';

  @override
  String get onboardingSkip => '跳过';

  @override
  String get onboardingLanguageTitle => '柠檬韩语';

  @override
  String get onboardingLanguagePrompt => '请选择您的首选语言';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingWelcome => '你好！我是柠檬韩语的柠檬 🍋\n我们一起学韩语吧？';

  @override
  String get onboardingLevelQuestion => '你现在的韩语水平是？';

  @override
  String get onboardingStart => '开始学习';

  @override
  String get onboardingStartWithoutLevel => '跳过并开始';

  @override
  String get levelBeginner => '入门';

  @override
  String get levelBeginnerDesc => '没关系！从韩文字母开始';

  @override
  String get levelElementary => '初级';

  @override
  String get levelElementaryDesc => '从基础会话开始练习！';

  @override
  String get levelIntermediate => '中级';

  @override
  String get levelIntermediateDesc => '说得更自然！';

  @override
  String get levelAdvanced => '高级';

  @override
  String get levelAdvancedDesc => '掌握细节表达！';

  @override
  String get onboardingWelcomeTitle => '欢迎来到柠檬韩语！';

  @override
  String get onboardingWelcomeSubtitle => '你的流利之旅从这里开始';

  @override
  String get onboardingFeature1Title => '随时随地离线学习';

  @override
  String get onboardingFeature1Desc => '下载课程，无需网络即可学习';

  @override
  String get onboardingFeature2Title => '智能复习系统';

  @override
  String get onboardingFeature2Desc => 'AI驱动的间隔重复，提升记忆效果';

  @override
  String get onboardingFeature3Title => '7阶段学习路径';

  @override
  String get onboardingFeature3Desc => '从入门到高级的结构化课程';

  @override
  String get onboardingLevelTitle => '你的韩语水平如何？';

  @override
  String get onboardingLevelSubtitle => '我们将为你定制学习体验';

  @override
  String get onboardingGoalTitle => '设定你的每周目标';

  @override
  String get onboardingGoalSubtitle => '你能投入多少时间？';

  @override
  String get goalCasual => '休闲';

  @override
  String get goalCasualDesc => '每周1-2课';

  @override
  String get goalCasualTime => '~每周10-20分钟';

  @override
  String get goalCasualHelper => '适合忙碌的日程';

  @override
  String get goalRegular => '规律';

  @override
  String get goalRegularDesc => '每周3-4课';

  @override
  String get goalRegularTime => '~每周30-40分钟';

  @override
  String get goalRegularHelper => '稳定进步，无压力';

  @override
  String get goalSerious => '认真';

  @override
  String get goalSeriousDesc => '每周5-6课';

  @override
  String get goalSeriousTime => '~每周50-60分钟';

  @override
  String get goalSeriousHelper => '致力于快速提升';

  @override
  String get goalIntensive => '强化';

  @override
  String get goalIntensiveDesc => '每日练习';

  @override
  String get goalIntensiveTime => '每周60分钟以上';

  @override
  String get goalIntensiveHelper => '最快学习速度';

  @override
  String get onboardingCompleteTitle => '一切就绪！';

  @override
  String get onboardingCompleteSubtitle => '开始你的学习之旅';

  @override
  String get onboardingSummaryLanguage => '界面语言';

  @override
  String get onboardingSummaryLevel => '韩语水平';

  @override
  String get onboardingSummaryGoal => '每周目标';

  @override
  String get onboardingStartLearning => '开始学习';

  @override
  String get onboardingBack => '返回';

  @override
  String levelTopik(String level) {
    return 'TOPIK $level';
  }

  @override
  String get appLanguage => '应用语言';

  @override
  String get appLanguageDesc => '选择应用界面使用的语言。';

  @override
  String languageSelected(String language) {
    return '已选择 $language';
  }

  @override
  String get sort => '排序';

  @override
  String get notificationTipContent =>
      '• 复习提醒会在完成课程后自动安排\n• 部分手机需要在系统设置中关闭省电模式才能正常接收通知';

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get downloadManager => '下载管理';

  @override
  String get storageInfo => '存储信息';

  @override
  String get clearAllDownloads => '清空下载';

  @override
  String get downloadedTab => '已下载';

  @override
  String get availableTab => '可下载';

  @override
  String get downloadedLessons => '已下载课程';

  @override
  String get mediaFiles => '媒体文件';

  @override
  String get usedStorage => '使用中';

  @override
  String get cacheStorage => '缓存';

  @override
  String get totalStorage => '总计';

  @override
  String get allDownloadsCleared => '已清空所有下载';

  @override
  String get availableStorage => '可用';

  @override
  String get noDownloadedLessons => '暂无已下载课程';

  @override
  String get goToAvailableTab => '切换到\"可下载\"标签开始下载';

  @override
  String get allLessonsDownloaded => '所有课程已下载';

  @override
  String get deleteDownload => '删除下载';

  @override
  String confirmDeleteDownload(String title) {
    return '确定要删除\"$title\"吗？';
  }

  @override
  String confirmClearAllDownloads(int count) {
    return '确定要删除所有 $count 个已下载课程吗？';
  }

  @override
  String downloadingCount(int count) {
    return '下载中 ($count)';
  }

  @override
  String get preparing => '准备中...';

  @override
  String lessonId(int id) {
    return '课程 $id';
  }

  @override
  String get searchWords => '搜索单词...';

  @override
  String wordCount(int count) {
    return '$count个单词';
  }

  @override
  String get sortByLesson => '按课程';

  @override
  String get sortByKorean => '按韩语';

  @override
  String get sortByChinese => '按中文';

  @override
  String get noWordsFound => '未找到相关单词';

  @override
  String get noMasteredWords => '暂无掌握的单词';

  @override
  String get hanja => '汉字';

  @override
  String get exampleSentence => '例句';

  @override
  String get mastered => '已掌握';

  @override
  String get completedLessons => '已完成课程';

  @override
  String get noCompletedLessons => '暂无完成的课程';

  @override
  String get startFirstLesson => '开始学习第一课吧！';

  @override
  String get masteredWords => '已掌握单词';

  @override
  String get download => '下载';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appName => '檸檬韓語';

  @override
  String get login => '登錄';

  @override
  String get register => '註冊';

  @override
  String get email => '郵箱';

  @override
  String get password => '密碼';

  @override
  String get confirmPassword => '確認密碼';

  @override
  String get username => '用戶名';

  @override
  String get enterEmail => '請輸入郵箱地址';

  @override
  String get enterPassword => '請輸入密碼';

  @override
  String get enterConfirmPassword => '請再次輸入密碼';

  @override
  String get enterUsername => '請輸入用戶名';

  @override
  String get createAccount => '創建賬號';

  @override
  String get startJourney => '開始你的韓語學習之旅';

  @override
  String get interfaceLanguage => '界面語言';

  @override
  String get simplifiedChinese => '簡體中文';

  @override
  String get traditionalChinese => '繁體中文';

  @override
  String get passwordRequirements => '密碼要求';

  @override
  String minCharacters(int count) {
    return '至少$count個字符';
  }

  @override
  String get containLettersNumbers => '包含字母和數字';

  @override
  String get haveAccount => '已有賬號？';

  @override
  String get noAccount => '沒有賬號？';

  @override
  String get loginNow => '立即登錄';

  @override
  String get registerNow => '立即註冊';

  @override
  String get registerSuccess => '註冊成功';

  @override
  String get registerFailed => '註冊失敗';

  @override
  String get loginSuccess => '登錄成功';

  @override
  String get loginFailed => '登錄失敗';

  @override
  String get networkError => '網絡連接失敗，請檢查網絡設置';

  @override
  String get invalidCredentials => '郵箱或密碼錯誤';

  @override
  String get emailAlreadyExists => '郵箱已被註冊';

  @override
  String get requestTimeout => '請求超時，請重試';

  @override
  String get operationFailed => '操作失敗，請稍後重試';

  @override
  String get settings => '設置';

  @override
  String get languageSettings => '語言設置';

  @override
  String get chineseDisplay => '中文顯示';

  @override
  String get chineseDisplayDesc => '選擇中文文字顯示方式。更改後將立即應用到所有界面。';

  @override
  String get switchedToSimplified => '已切換到簡體中文';

  @override
  String get switchedToTraditional => '已切換到繁體中文';

  @override
  String get displayTip => '提示：課程內容將使用您選擇的中文字體顯示。';

  @override
  String get notificationSettings => '通知設置';

  @override
  String get enableNotifications => '啟用通知';

  @override
  String get enableNotificationsDesc => '開啟後可以接收學習提醒';

  @override
  String get permissionRequired => '請在系統設置中允許通知權限';

  @override
  String get dailyLearningReminder => '每日學習提醒';

  @override
  String get dailyReminder => '每日提醒';

  @override
  String get dailyReminderDesc => '每天固定時間提醒學習';

  @override
  String get reminderTime => '提醒時間';

  @override
  String reminderTimeSet(String time) {
    return '提醒時間已設置為 $time';
  }

  @override
  String get reviewReminder => '複習提醒';

  @override
  String get reviewReminderDesc => '根據記憶曲線提醒複習';

  @override
  String get notificationTip => '提示：';

  @override
  String get helpCenter => '幫助中心';

  @override
  String get offlineLearning => '離線學習';

  @override
  String get howToDownload => '如何下載課程？';

  @override
  String get howToDownloadAnswer => '在課程列表中，點擊右側的下載圖標即可下載課程。下載後可以離線學習。';

  @override
  String get howToUseDownloaded => '如何使用已下載的課程？';

  @override
  String get howToUseDownloadedAnswer =>
      '即使沒有網絡連接，您也可以正常學習已下載的課程。進度會在本地保存，聯網後自動同步。';

  @override
  String get storageManagement => '存儲管理';

  @override
  String get howToCheckStorage => '如何查看存儲空間？';

  @override
  String get howToCheckStorageAnswer => '進入【設置 → 存儲管理】可以查看已使用和可用的存儲空間。';

  @override
  String get howToDeleteDownloaded => '如何刪除已下載的課程？';

  @override
  String get howToDeleteDownloadedAnswer => '在【存儲管理】頁面，點擊課程旁邊的刪除按鈕即可刪除。';

  @override
  String get notificationSection => '通知設置';

  @override
  String get howToEnableReminder => '如何開啟學習提醒？';

  @override
  String get howToEnableReminderAnswer =>
      '進入【設置 → 通知設置】，打開【啟用通知】開關。首次使用需要授予通知權限。';

  @override
  String get whatIsReviewReminder => '什麼是複習提醒？';

  @override
  String get whatIsReviewReminderAnswer =>
      '基於間隔重複算法（SRS），應用會在最佳時間提醒您複習已學課程。複習間隔：1天 → 3天 → 7天 → 14天 → 30天。';

  @override
  String get languageSection => '語言設置';

  @override
  String get howToSwitchChinese => '如何切換簡繁體中文？';

  @override
  String get howToSwitchChineseAnswer =>
      '進入【設置 → 語言設置】，選擇【簡體中文】或【繁體中文】。更改後立即生效。';

  @override
  String get faq => '常見問題';

  @override
  String get howToStart => '如何開始學習？';

  @override
  String get howToStartAnswer => '在主頁面選擇適合您水平的課程，從第1課開始。每節課包含7個學習階段。';

  @override
  String get progressNotSaved => '進度沒有保存怎麼辦？';

  @override
  String get progressNotSavedAnswer => '進度會自動保存到本地。如果聯網，會自動同步到服務器。請檢查網絡連接。';

  @override
  String get aboutApp => '關於應用';

  @override
  String get moreInfo => '更多信息';

  @override
  String get versionInfo => '版本信息';

  @override
  String get developer => '開發者';

  @override
  String get appIntro => '應用介紹';

  @override
  String get appIntroContent => '專為中文使用者設計的韓語學習應用，支持離線學習、智能複習提醒等功能。';

  @override
  String get termsOfService => '服務條款';

  @override
  String get termsComingSoon => '服務條款頁面開發中...';

  @override
  String get privacyPolicy => '隱私政策';

  @override
  String get privacyComingSoon => '隱私政策頁面開發中...';

  @override
  String get openSourceLicenses => '開源許可';

  @override
  String get notStarted => '未開始';

  @override
  String get inProgress => '進行中';

  @override
  String get completed => '已完成';

  @override
  String get notPassed => '未通過';

  @override
  String get timeToReview => '該複習了';

  @override
  String get today => '今天';

  @override
  String get tomorrow => '明天';

  @override
  String daysLater(int count) {
    return '$count天後';
  }

  @override
  String get noun => '名詞';

  @override
  String get verb => '動詞';

  @override
  String get adjective => '形容詞';

  @override
  String get adverb => '副詞';

  @override
  String get particle => '助詞';

  @override
  String get pronoun => '代詞';

  @override
  String get highSimilarity => '高相似度';

  @override
  String get mediumSimilarity => '中等相似度';

  @override
  String get lowSimilarity => '低相似度';

  @override
  String get lessonComplete => '課程完成！';

  @override
  String get learningComplete => '學習完成';

  @override
  String experiencePoints(int points) {
    return '經驗值 +$points';
  }

  @override
  String get keepLearning => '繼續保持學習熱情';

  @override
  String get streakDays => '學習連續天數 +1';

  @override
  String streakDaysCount(int days) {
    return '已連續學習 $days 天';
  }

  @override
  String get lessonContent => '本課學習內容';

  @override
  String get words => '單詞';

  @override
  String get grammarPoints => '語法點';

  @override
  String get dialogues => '對話';

  @override
  String get grammarExplanation => '語法講解';

  @override
  String get exampleSentences => '例句';

  @override
  String get previous => '上一個';

  @override
  String get next => '下一個';

  @override
  String get continueBtn => '繼續';

  @override
  String get topicParticle => '主題助詞';

  @override
  String get honorificEnding => '敬語結尾';

  @override
  String get questionWord => '什麼';

  @override
  String get hello => '你好';

  @override
  String get thankYou => '謝謝';

  @override
  String get goodbye => '再見';

  @override
  String get sorry => '對不起';

  @override
  String get imStudent => '我是學生';

  @override
  String get bookInteresting => '書很有趣';

  @override
  String get isStudent => '是學生';

  @override
  String get isTeacher => '是老師';

  @override
  String get whatIsThis => '這是什麼？';

  @override
  String get whatDoingPolite => '在做什麼？';

  @override
  String get listenAndChoose => '聽音頻，選擇正確的翻譯';

  @override
  String get fillInBlank => '填入正確的助詞';

  @override
  String get chooseTranslation => '選擇正確的翻譯';

  @override
  String get arrangeWords => '按正確順序排列單詞';

  @override
  String get choosePronunciation => '選擇正確的發音';

  @override
  String get consonantEnding => '當名詞以輔音結尾時，應該使用哪個主題助詞？';

  @override
  String get correctSentence => '選擇正確的句子';

  @override
  String get allCorrect => '以上都對';

  @override
  String get howAreYou => '你好嗎？';

  @override
  String get whatIsYourName => '你叫什麼名字？';

  @override
  String get whoAreYou => '你是誰？';

  @override
  String get whereAreYou => '你在哪裡？';

  @override
  String get niceToMeetYou => '很高興認識你';

  @override
  String get areYouStudent => '你是學生';

  @override
  String get areYouStudentQuestion => '你是學生嗎？';

  @override
  String get amIStudent => '我是學生嗎？';

  @override
  String get listening => '聽力';

  @override
  String get fillBlank => '填空';

  @override
  String get translation => '翻譯';

  @override
  String get wordOrder => '排序';

  @override
  String get pronunciation => '發音';

  @override
  String get excellent => '太棒了！';

  @override
  String get correctOrderIs => '正確順序是:';

  @override
  String get correctAnswerIs => '正確答案是:';

  @override
  String get previousQuestion => '上一題';

  @override
  String get nextQuestion => '下一題';

  @override
  String get finish => '完成';

  @override
  String get quizComplete => '測驗完成！';

  @override
  String get greatJob => '太棒了！';

  @override
  String get keepPracticing => '繼續加油！';

  @override
  String score(int correct, int total) {
    return '得分：$correct / $total';
  }

  @override
  String get masteredContent => '你已經很好地掌握了本課內容！';

  @override
  String get reviewSuggestion => '建議複習一下課程內容，再來挑戰吧！';

  @override
  String timeUsed(String time) {
    return '用時: $time';
  }

  @override
  String get playAudio => '播放音頻';

  @override
  String get replayAudio => '重新播放';

  @override
  String get vowelEnding => '以元音結尾，使用';

  @override
  String lessonNumber(int number) {
    return '第$number課';
  }

  @override
  String get stageIntro => '課程介紹';

  @override
  String get stageVocabulary => '詞彙學習';

  @override
  String get stageGrammar => '語法講解';

  @override
  String get stagePractice => '練習';

  @override
  String get stageDialogue => '對話練習';

  @override
  String get stageQuiz => '測驗';

  @override
  String get stageSummary => '總結';

  @override
  String get downloadLesson => '下載課程';

  @override
  String get downloading => '下載中...';

  @override
  String get downloaded => '已下載';

  @override
  String get downloadFailed => '下載失敗';

  @override
  String get home => '首頁';

  @override
  String get lessons => '課程';

  @override
  String get review => '複習';

  @override
  String get profile => '我的';

  @override
  String get continueLearning => '繼續學習';

  @override
  String get dailyGoal => '每日目標';

  @override
  String lessonsCompleted(int count) {
    return '已完成 $count 課';
  }

  @override
  String minutesLearned(int minutes) {
    return '已學習 $minutes 分鐘';
  }

  @override
  String get welcome => '歡迎回來';

  @override
  String get goodMorning => '早上好';

  @override
  String get goodAfternoon => '下午好';

  @override
  String get goodEvening => '晚上好';

  @override
  String get logout => '退出登錄';

  @override
  String get confirmLogout => '確定要退出登錄嗎？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定';

  @override
  String get delete => '刪除';

  @override
  String get save => '保存';

  @override
  String get edit => '編輯';

  @override
  String get close => '關閉';

  @override
  String get retry => '重試';

  @override
  String get loading => '加載中...';

  @override
  String get noData => '暫無數據';

  @override
  String get error => '出錯了';

  @override
  String get success => '成功';

  @override
  String get filter => '篩選';

  @override
  String get reviewSchedule => '複習計劃';

  @override
  String get todayReview => '今日複習';

  @override
  String get startReview => '開始複習';

  @override
  String get learningStats => '學習統計';

  @override
  String get completedLessonsCount => '已完成課程';

  @override
  String get studyDays => '學習天數';

  @override
  String get masteredWordsCount => '掌握單詞';

  @override
  String get myVocabularyBook => '我的單詞本';

  @override
  String get vocabularyBrowser => '單詞瀏覽器';

  @override
  String get about => '關於';

  @override
  String get premiumMember => '高級會員';

  @override
  String get freeUser => '免費用戶';

  @override
  String wordsWaitingReview(int count) {
    return '$count個單詞等待複習';
  }

  @override
  String get user => '用戶';

  @override
  String get onboardingSkip => '跳過';

  @override
  String get onboardingLanguageTitle => '檸檬韓語';

  @override
  String get onboardingLanguagePrompt => '請選擇您的首選語言';

  @override
  String get onboardingNext => '下一步';

  @override
  String get onboardingWelcome => '你好！我是檸檬韓語的檸檬 🍋\n我們一起學韓語吧？';

  @override
  String get onboardingLevelQuestion => '你現在的韓語水平是？';

  @override
  String get onboardingStart => '開始學習';

  @override
  String get onboardingStartWithoutLevel => '跳過並開始';

  @override
  String get levelBeginner => '入門';

  @override
  String get levelBeginnerDesc => '沒關係！從韓文字母開始';

  @override
  String get levelElementary => '初級';

  @override
  String get levelElementaryDesc => '從基礎會話開始練習！';

  @override
  String get levelIntermediate => '中級';

  @override
  String get levelIntermediateDesc => '說得更自然！';

  @override
  String get levelAdvanced => '高級';

  @override
  String get levelAdvancedDesc => '掌握細節表達！';

  @override
  String get onboardingWelcomeTitle => '歡迎來到檸檬韓語！';

  @override
  String get onboardingWelcomeSubtitle => '你的流利之旅從這裡開始';

  @override
  String get onboardingFeature1Title => '隨時隨地離線學習';

  @override
  String get onboardingFeature1Desc => '下載課程，無需網絡即可學習';

  @override
  String get onboardingFeature2Title => '智能複習系統';

  @override
  String get onboardingFeature2Desc => 'AI驅動的間隔重複，提升記憶效果';

  @override
  String get onboardingFeature3Title => '7階段學習路徑';

  @override
  String get onboardingFeature3Desc => '從入門到高級的結構化課程';

  @override
  String get onboardingLevelTitle => '你的韓語水平如何？';

  @override
  String get onboardingLevelSubtitle => '我們將為你定製學習體驗';

  @override
  String get onboardingGoalTitle => '設定你的每週目標';

  @override
  String get onboardingGoalSubtitle => '你能投入多少時間？';

  @override
  String get goalCasual => '休閒';

  @override
  String get goalCasualDesc => '每週1-2課';

  @override
  String get goalCasualTime => '~每週10-20分鐘';

  @override
  String get goalCasualHelper => '適合忙碌的日程';

  @override
  String get goalRegular => '規律';

  @override
  String get goalRegularDesc => '每週3-4課';

  @override
  String get goalRegularTime => '~每週30-40分鐘';

  @override
  String get goalRegularHelper => '穩定進步，無壓力';

  @override
  String get goalSerious => '認真';

  @override
  String get goalSeriousDesc => '每週5-6課';

  @override
  String get goalSeriousTime => '~每週50-60分鐘';

  @override
  String get goalSeriousHelper => '致力於快速提升';

  @override
  String get goalIntensive => '強化';

  @override
  String get goalIntensiveDesc => '每日練習';

  @override
  String get goalIntensiveTime => '每週60分鐘以上';

  @override
  String get goalIntensiveHelper => '最快學習速度';

  @override
  String get onboardingCompleteTitle => '一切就緒！';

  @override
  String get onboardingCompleteSubtitle => '開始你的學習之旅';

  @override
  String get onboardingSummaryLanguage => '界面語言';

  @override
  String get onboardingSummaryLevel => '韓語水平';

  @override
  String get onboardingSummaryGoal => '每週目標';

  @override
  String get onboardingStartLearning => '開始學習';

  @override
  String get onboardingBack => '返回';

  @override
  String levelTopik(String level) {
    return 'TOPIK $level';
  }

  @override
  String get appLanguage => '應用語言';

  @override
  String get appLanguageDesc => '選擇應用界面使用的語言。';

  @override
  String languageSelected(String language) {
    return '已選擇 $language';
  }

  @override
  String get sort => '排序';

  @override
  String get notificationTipContent =>
      '• 複習提醒會在完成課程後自動安排\n• 部分手機需要在系統設置中關閉省電模式才能正常接收通知';

  @override
  String get yesterday => '昨天';

  @override
  String daysAgo(int count) {
    return '$count天前';
  }

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get downloadManager => '下載管理';

  @override
  String get storageInfo => '存儲信息';

  @override
  String get clearAllDownloads => '清空下載';

  @override
  String get downloadedTab => '已下載';

  @override
  String get availableTab => '可下載';

  @override
  String get downloadedLessons => '已下載課程';

  @override
  String get mediaFiles => '媒體文件';

  @override
  String get usedStorage => '使用中';

  @override
  String get cacheStorage => '緩存';

  @override
  String get totalStorage => '總計';

  @override
  String get allDownloadsCleared => '已清空所有下載';

  @override
  String get availableStorage => '可用';

  @override
  String get noDownloadedLessons => '暫無已下載課程';

  @override
  String get goToAvailableTab => '切換到\"可下載\"標籤開始下載';

  @override
  String get allLessonsDownloaded => '所有課程已下載';

  @override
  String get deleteDownload => '刪除下載';

  @override
  String confirmDeleteDownload(String title) {
    return '確定要刪除\"$title\"嗎？';
  }

  @override
  String confirmClearAllDownloads(int count) {
    return '確定要刪除所有 $count 個已下載課程嗎？';
  }

  @override
  String downloadingCount(int count) {
    return '下載中 ($count)';
  }

  @override
  String get preparing => '準備中...';

  @override
  String lessonId(int id) {
    return '課程 $id';
  }

  @override
  String get searchWords => '搜索單詞...';

  @override
  String wordCount(int count) {
    return '$count個單詞';
  }

  @override
  String get sortByLesson => '按課程';

  @override
  String get sortByKorean => '按韓語';

  @override
  String get sortByChinese => '按中文';

  @override
  String get noWordsFound => '未找到相關單詞';

  @override
  String get noMasteredWords => '暫無掌握的單詞';

  @override
  String get hanja => '漢字';

  @override
  String get exampleSentence => '例句';

  @override
  String get mastered => '已掌握';

  @override
  String get completedLessons => '已完成課程';

  @override
  String get noCompletedLessons => '暫無完成的課程';

  @override
  String get startFirstLesson => '開始學習第一課吧！';

  @override
  String get masteredWords => '已掌握單詞';

  @override
  String get download => '下載';
}
