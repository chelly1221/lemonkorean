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
  String get lessonComplete => '课程完成！进度已保存';

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
  String get grammarExplanation => '语法解释';

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
  String correctAnswerIs(String answer) {
    return '正确答案: $answer';
  }

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
  String get errorOccurred => '出错了';

  @override
  String get reload => '重新加载';

  @override
  String get noCharactersAvailable => '暂无可用字符';

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
  String get onboardingLanguageTitle => '你好！我是莫妮';

  @override
  String get onboardingLanguagePrompt => '从哪种语言开始一起学习呢？';

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
  String get onboardingAccountTitle => '准备好了吗？';

  @override
  String get onboardingAccountSubtitle => '登录或创建账户以保存学习进度';

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

  @override
  String get hangulLearning => '韩文字母学习';

  @override
  String get hangulLearningSubtitle => '学习韩文字母表 40个字母';

  @override
  String get editNotes => '编辑笔记';

  @override
  String get notes => '笔记';

  @override
  String get notesHint => '为什么要收藏这个单词？';

  @override
  String get sortBy => '排序方式';

  @override
  String get sortNewest => '最新收藏';

  @override
  String get sortOldest => '最早收藏';

  @override
  String get sortKorean => '韩文排序';

  @override
  String get sortChinese => '中文排序';

  @override
  String get sortMastery => '掌握程度';

  @override
  String get filterAll => '全部';

  @override
  String get filterNew => '新学 (0级)';

  @override
  String get filterBeginner => '初级 (1级)';

  @override
  String get filterIntermediate => '中级 (2-3级)';

  @override
  String get filterAdvanced => '高级 (4-5级)';

  @override
  String get searchWordsNotesChinese => '搜索单词、中文或笔记...';

  @override
  String startReviewCount(int count) {
    return '开始复习 ($count)';
  }

  @override
  String get remove => '移除';

  @override
  String get confirmRemove => '确认移除';

  @override
  String confirmRemoveWord(String word) {
    return '确定要从单词本移除「$word」吗？';
  }

  @override
  String get noBookmarkedWords => '还没有收藏的单词';

  @override
  String get bookmarkHint => '在学习过程中点击单词卡片上的书签图标';

  @override
  String get noMatchingWords => '没有找到匹配的单词';

  @override
  String weeksAgo(int count) {
    return '$count周前';
  }

  @override
  String get reviewComplete => '复习完成！';

  @override
  String reviewCompleteCount(int count) {
    return '已完成 $count 个单词的复习';
  }

  @override
  String get correct => '正确';

  @override
  String get wrong => '错误';

  @override
  String get accuracy => '准确率';

  @override
  String get vocabularyBookReview => '单词本复习';

  @override
  String get noWordsToReview => '暂无需要复习的单词';

  @override
  String get bookmarkWordsToReview => '在学习过程中收藏单词后开始复习';

  @override
  String get returnToVocabularyBook => '返回单词本';

  @override
  String get exit => '退出';

  @override
  String get showAnswer => '显示答案';

  @override
  String get didYouRemember => '你记住了吗？';

  @override
  String get forgot => '忘记了';

  @override
  String get hard => '困难';

  @override
  String get remembered => '记得';

  @override
  String get easy => '简单';

  @override
  String get addedToVocabularyBook => '已添加到单词本';

  @override
  String get addFailed => '添加失败';

  @override
  String get removedFromVocabularyBook => '已从单词本移除';

  @override
  String get removeFailed => '移除失败';

  @override
  String get addToVocabularyBook => '添加到单词本';

  @override
  String get notesOptional => '笔记（可选）';

  @override
  String get add => '添加';

  @override
  String get bookmarked => '已收藏';

  @override
  String get bookmark => '收藏';

  @override
  String get removeFromVocabularyBook => '从单词本移除';

  @override
  String similarityPercent(int percent) {
    return '相似度: $percent%';
  }

  @override
  String addedOrRemoved(String added) {
    String _temp0 = intl.Intl.selectLogic(
      added,
      {
        'true': '已添加到单词本',
        'other': '已取消收藏',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => '天';

  @override
  String lessonsCompletedCount(int count) {
    return '$count 课完成';
  }

  @override
  String get dailyGoalComplete => '太棒了！今日目标已完成！';

  @override
  String get hangulAlphabet => '韩文字母';

  @override
  String get alphabetTable => '字母表';

  @override
  String get learn => '学习';

  @override
  String get practice => '练习';

  @override
  String get learningProgress => '学习进度';

  @override
  String dueForReviewCount(int count) {
    return '$count 个待复习';
  }

  @override
  String get completion => '完成度';

  @override
  String get totalCharacters => '总字母';

  @override
  String get learned => '已学习';

  @override
  String get dueForReview => '待复习';

  @override
  String overallAccuracy(String percent) {
    return '整体准确率: $percent%';
  }

  @override
  String charactersCount(int count) {
    return '$count个字母';
  }

  @override
  String get lesson1Title => '第1课：基本辅音 (上)';

  @override
  String get lesson1Desc => '学习韩语最常用的7个辅音字母';

  @override
  String get lesson2Title => '第2课：基本辅音 (下)';

  @override
  String get lesson2Desc => '继续学习剩余的7个基本辅音';

  @override
  String get lesson3Title => '第3课：基本元音 (上)';

  @override
  String get lesson3Desc => '学习韩语的5个基本元音';

  @override
  String get lesson4Title => '第4课：基本元音 (下)';

  @override
  String get lesson4Desc => '学习剩余的5个基本元音';

  @override
  String get lesson5Title => '第5课：双辅音';

  @override
  String get lesson5Desc => '学习5个双辅音 - 紧音字母';

  @override
  String get lesson6Title => '第6课：复合元音 (上)';

  @override
  String get lesson6Desc => '学习前6个复合元音';

  @override
  String get lesson7Title => '第7课：复合元音 (下)';

  @override
  String get lesson7Desc => '学习剩余的复合元音';

  @override
  String get loadAlphabetFirst => '请先加载字母表数据';

  @override
  String get noContentForLesson => '本课无内容';

  @override
  String get exampleWords => '例词';

  @override
  String get thisLessonCharacters => '本课字母';

  @override
  String congratsLessonComplete(String title) {
    return '恭喜你完成了 $title！';
  }

  @override
  String get continuePractice => '继续练习';

  @override
  String get nextLesson => '下一课';

  @override
  String get basicConsonants => '基本辅音';

  @override
  String get doubleConsonants => '双辅音';

  @override
  String get basicVowels => '基本元音';

  @override
  String get compoundVowels => '复合元音';

  @override
  String get dailyLearningReminderTitle => '每日学习提醒';

  @override
  String get dailyLearningReminderBody => '今天的韩语学习还没完成哦~';

  @override
  String get reviewReminderTitle => '复习时间到了！';

  @override
  String reviewReminderBody(String title) {
    return '该复习「$title」了~';
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
  String get strokeOrder => '笔画顺序';

  @override
  String get reset => '重置';

  @override
  String get pronunciationGuide => '发音指南';

  @override
  String get play => '播放';

  @override
  String get pause => '暂停';

  @override
  String loadingFailed(String error) {
    return '加载失败: $error';
  }

  @override
  String learnedCount(int count) {
    return '已学习: $count';
  }

  @override
  String get hangulPractice => '韩文字母练习';

  @override
  String charactersNeedReview(int count) {
    return '$count 个字母需要复习';
  }

  @override
  String charactersAvailable(int count) {
    return '$count 个字母可练习';
  }

  @override
  String get selectPracticeMode => '选择练习模式';

  @override
  String get characterRecognition => '字母识别';

  @override
  String get characterRecognitionDesc => '看到字母选择正确的发音';

  @override
  String get pronunciationPractice => '发音练习';

  @override
  String get pronunciationPracticeDesc => '看到发音选择正确的字母';

  @override
  String get startPractice => '开始练习';

  @override
  String get learnSomeCharactersFirst => '请先在字母表中学习一些字母';

  @override
  String get practiceComplete => '练习完成！';

  @override
  String get back => '返回';

  @override
  String get tryAgain => '再来一次';

  @override
  String get howToReadThis => '这个字母怎么读？';

  @override
  String get selectCorrectCharacter => '选择正确的字母';

  @override
  String get correctExclamation => '正确！';

  @override
  String get incorrectExclamation => '错误';

  @override
  String get correctAnswerLabel => '正确答案: ';

  @override
  String get nextQuestionBtn => '下一题';

  @override
  String get viewResults => '查看结果';

  @override
  String get share => '分享';

  @override
  String get mnemonics => '记忆技巧';

  @override
  String nextReviewLabel(String date) {
    return '下次复习: $date';
  }

  @override
  String get expired => '已到期';

  @override
  String get practiceFunctionDeveloping => '练习功能开发中';

  @override
  String get romanization => '罗马字: ';

  @override
  String get pronunciationLabel => '发音: ';

  @override
  String get playPronunciation => '播放发音';

  @override
  String strokesCount(int count) {
    return '$count画';
  }

  @override
  String get perfectCount => '完美';

  @override
  String get loadFailed => '加载失败';

  @override
  String countUnit(int count) {
    return '$count个';
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
  String get exitLesson => '退出学习';

  @override
  String get exitLessonConfirm => '确定要退出当前课程吗？进度将会保存。';

  @override
  String get exitBtn => '退出';

  @override
  String loadingLesson(String title) {
    return '$title 불러오는 중...';
  }

  @override
  String get cannotLoadContent => '레슨 콘텐츠를 불러올 수 없습니다';

  @override
  String get noLessonContent => '此课程暂无内容';

  @override
  String stageProgress(int current, int total) {
    return '第 $current 阶段 / $total';
  }

  @override
  String unknownStageType(String type) {
    return '未知阶段类型: $type';
  }

  @override
  String wordsCount(int count) {
    return '$count 个单词';
  }

  @override
  String get startLearning => '开始学习';

  @override
  String get vocabularyLearning => '词汇学习';

  @override
  String get noImage => '暂无图片';

  @override
  String get previousItem => '上一个';

  @override
  String get nextItem => '下一个';

  @override
  String get playingAudio => '播放中...';

  @override
  String get playAll => '播放全部';

  @override
  String audioPlayFailed(String error) {
    return '音频播放失败: $error';
  }

  @override
  String get stopBtn => '停止';

  @override
  String get playAudioBtn => '播放音频';

  @override
  String get playingAudioShort => '播放音频...';

  @override
  String grammarPattern(String pattern) {
    return '语法 · $pattern';
  }

  @override
  String get conjugationRule => '活用规则';

  @override
  String get comparisonWithChinese => '与中文对比';

  @override
  String get dialogueTitle => '对话练习';

  @override
  String get dialogueExplanation => '对话解析';

  @override
  String speaker(String name) {
    return '发言人 $name';
  }

  @override
  String get practiceTitle => '练习';

  @override
  String get practiceInstructions => '请完成以下练习题';

  @override
  String get checkAnswerBtn => '检查答案';

  @override
  String get quizTitle => '测验';

  @override
  String get quizResult => '测验结果';

  @override
  String quizScoreDisplay(int correct, int total) {
    return '$correct/$total';
  }

  @override
  String quizAccuracy(int percent) {
    return '准确率: $percent%';
  }

  @override
  String get summaryTitle => '课程总结';

  @override
  String get vocabLearned => '学习单词';

  @override
  String get grammarLearned => '学习语法';

  @override
  String get finishLesson => '完成课程';

  @override
  String get reviewVocab => '复习单词';

  @override
  String similarity(int percent) {
    return '相似度: $percent%';
  }

  @override
  String get partOfSpeechNoun => '名词';

  @override
  String get partOfSpeechVerb => '动词';

  @override
  String get partOfSpeechAdjective => '形容词';

  @override
  String get partOfSpeechAdverb => '副词';

  @override
  String get partOfSpeechPronoun => '代词';

  @override
  String get partOfSpeechParticle => '助词';

  @override
  String get partOfSpeechConjunction => '连词';

  @override
  String get partOfSpeechInterjection => '感叹词';

  @override
  String get noVocabulary => '暂无单词数据';

  @override
  String get noGrammar => '暂无语法数据';

  @override
  String get noPractice => '暂无练习题';

  @override
  String get noDialogue => '暂无对话内容';

  @override
  String get noQuiz => '暂无测验题目';

  @override
  String get tapToFlip => '点击翻转';

  @override
  String get listeningQuestion => '听力';

  @override
  String get submit => '提交';

  @override
  String timeStudied(String time) {
    return '已学习 $time';
  }

  @override
  String get statusNotStarted => '未开始';

  @override
  String get statusInProgress => '进行中';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusFailed => '未通过';

  @override
  String get masteryNew => '新';

  @override
  String get masteryLearning => '学习中';

  @override
  String get masteryFamiliar => '熟悉';

  @override
  String get masteryMastered => '掌握';

  @override
  String get masteryExpert => '精通';

  @override
  String get masteryPerfect => '完美';

  @override
  String get masteryUnknown => '未知';

  @override
  String get dueForReviewNow => '该复习了';

  @override
  String get similarityHigh => '高相似度';

  @override
  String get similarityMedium => '中等相似度';

  @override
  String get similarityLow => '低相似度';

  @override
  String get typeBasicConsonant => '基本辅音';

  @override
  String get typeDoubleConsonant => '双辅音';

  @override
  String get typeBasicVowel => '基本元音';

  @override
  String get typeCompoundVowel => '复合元音';

  @override
  String get typeFinalConsonant => '收音';

  @override
  String get dailyReminderChannel => '每日学习提醒';

  @override
  String get dailyReminderChannelDesc => '每天固定时间提醒你学习韩语';

  @override
  String get reviewReminderChannel => '复习提醒';

  @override
  String get reviewReminderChannelDesc => '基于间隔重复算法的复习提醒';

  @override
  String get notificationStudyTime => '学习时间到了！';

  @override
  String get notificationStudyReminder => '今天的韩语学习还没完成哦~';

  @override
  String get notificationReviewTime => '该复习了！';

  @override
  String get notificationReviewReminder => '复习一下之前学过的内容吧~';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return '该复习「$lessonTitle」了~';
  }

  @override
  String get keepGoing => '继续加油！';

  @override
  String scoreDisplay(int correct, int total) {
    return '得分：$correct / $total';
  }

  @override
  String loadDataError(String error) {
    return '加载数据失败: $error';
  }

  @override
  String downloadError(String error) {
    return '下载错误: $error';
  }

  @override
  String deleteError(String error) {
    return '删除失败: $error';
  }

  @override
  String clearAllError(String error) {
    return '清空失败: $error';
  }

  @override
  String cleanupError(String error) {
    return '清理失败: $error';
  }

  @override
  String downloadLessonFailed(String title) {
    return '下载失败: $title';
  }

  @override
  String get comprehensive => '综合';

  @override
  String answeredCount(int answered, int total) {
    return '已答 $answered/$total';
  }

  @override
  String get hanjaWord => '汉字词';

  @override
  String get tapToFlipBack => '点击返回';

  @override
  String get similarityWithChinese => '与中文相似度';

  @override
  String get hanjaWordSimilarPronunciation => '汉字词，发音相似';

  @override
  String get sameEtymologyEasyToRemember => '词源相同，便于记忆';

  @override
  String get someConnection => '有一定联系';

  @override
  String get nativeWordNeedsMemorization => '固有词，需要记忆';

  @override
  String get rules => '规则';

  @override
  String get koreanLanguage => '🇰🇷 韩语';

  @override
  String get chineseLanguage => '🇨🇳 中文';

  @override
  String exampleNumber(int number) {
    return '例 $number';
  }

  @override
  String get fillInBlankPrompt => '填空：';

  @override
  String get correctFeedback => '太棒了！答对了！';

  @override
  String get incorrectFeedback => '不对哦，再想想看';

  @override
  String get allStagesPassed => '7个阶段全部通过';

  @override
  String get continueToLearnMore => '继续学习更多内容';

  @override
  String timeFormatHMS(int hours, int minutes, int seconds) {
    return '$hours时$minutes分$seconds秒';
  }

  @override
  String timeFormatMS(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String timeFormatS(int seconds) {
    return '$seconds秒';
  }

  @override
  String get repeatEnabled => '已开启重复';

  @override
  String get repeatDisabled => '已关闭重复';

  @override
  String get stop => '停止';

  @override
  String get playbackSpeed => '播放速度';

  @override
  String get slowSpeed => '慢速';

  @override
  String get normalSpeed => '正常';

  @override
  String get mouthShape => '口型';

  @override
  String get tonguePosition => '舌位';

  @override
  String get airFlow => '气流';

  @override
  String get nativeComparison => '母语对比';

  @override
  String get similarSounds => '相似音';

  @override
  String get soundDiscrimination => '辨音练习';

  @override
  String get listenAndSelect => '听音选择正确的字母';

  @override
  String get similarSoundGroups => '相似音组';

  @override
  String get plainSound => '平音';

  @override
  String get aspiratedSound => '送气音';

  @override
  String get tenseSound => '紧音';

  @override
  String get writingPractice => '书写练习';

  @override
  String get watchAnimation => '观看动画';

  @override
  String get traceWithGuide => '描摹练习';

  @override
  String get freehandWriting => '自由书写';

  @override
  String get clearCanvas => '清除';

  @override
  String get showGuide => '显示引导';

  @override
  String get hideGuide => '隐藏引导';

  @override
  String get writingAccuracy => '准确度';

  @override
  String get tryAgainWriting => '再试一次';

  @override
  String get nextStep => '下一步';

  @override
  String strokeOrderStep(int current, int total) {
    return '第 $current/$total 步';
  }

  @override
  String get syllableCombination => '音节组合';

  @override
  String get selectConsonant => '选择辅音';

  @override
  String get selectVowel => '选择元音';

  @override
  String get selectFinalConsonant => '选择收音（可选）';

  @override
  String get noFinalConsonant => '无收音';

  @override
  String get combinedSyllable => '组合音节';

  @override
  String get playSyllable => '播放音节';

  @override
  String get decomposeSyllable => '分解音节';

  @override
  String get batchimPractice => '收音练习';

  @override
  String get batchimExplanation => '收音说明';

  @override
  String get recordPronunciation => '录音练习';

  @override
  String get startRecording => '开始录音';

  @override
  String get stopRecording => '停止录音';

  @override
  String get playRecording => '播放录音';

  @override
  String get compareWithNative => '与原音对比';

  @override
  String get shadowingMode => '跟读模式';

  @override
  String get listenThenRepeat => '先听后说';

  @override
  String get selfEvaluation => '自我评价';

  @override
  String get accurate => '准确';

  @override
  String get almostCorrect => '接近';

  @override
  String get needsPractice => '需要练习';

  @override
  String get recordingNotSupported => '此平台不支持录音功能';

  @override
  String get showMeaning => '显示释义';

  @override
  String get hideMeaning => '隐藏释义';

  @override
  String get exampleWord => '示例单词';

  @override
  String get meaningToggle => '释义显示设置';

  @override
  String get microphonePermissionRequired => '录音需要麦克风权限';

  @override
  String get activities => '活动';

  @override
  String get listeningAndSpeaking => '听力 & 口语';

  @override
  String get readingAndWriting => '阅读 & 写作';

  @override
  String get soundDiscriminationDesc => '训练耳朵区分相似的声音';

  @override
  String get shadowingDesc => '跟读原生发音';

  @override
  String get syllableCombinationDesc => '学习辅音和元音如何组合';

  @override
  String get batchimPracticeDesc => '练习收音发音';

  @override
  String get writingPracticeDesc => '练习书写韩文字母';

  @override
  String get webNotSupported => '网页版不支持';

  @override
  String get chapter => '章节';

  @override
  String get bossQuiz => 'Boss测验';

  @override
  String get bossQuizCleared => 'Boss测验通过！';

  @override
  String get bossQuizBonus => '奖励柠檬';

  @override
  String get lemonsScoreHint95 => '95%以上获得3个柠檬';

  @override
  String get lemonsScoreHint80 => '80%以上获得2个柠檬';

  @override
  String get myLemonTree => '我的柠檬树';

  @override
  String get harvestLemon => '收获柠檬';

  @override
  String get watchAdToHarvest => '观看广告来收获这个柠檬？';

  @override
  String get lemonHarvested => '柠檬已收获！';

  @override
  String get lemonsAvailable => '个柠檬可收获';

  @override
  String get completeMoreLessons => '完成更多课程来种植柠檬';

  @override
  String get totalLemons => '柠檬总数';

  @override
  String get community => '社区';

  @override
  String get following => '关注';

  @override
  String get discover => '发现';

  @override
  String get createPost => '发帖';

  @override
  String get writePost => '分享你的想法...';

  @override
  String get postCategory => '分类';

  @override
  String get categoryLearning => '学习';

  @override
  String get categoryGeneral => '日常';

  @override
  String get categoryAll => '全部';

  @override
  String get post => '发布';

  @override
  String get like => '点赞';

  @override
  String get comment => '评论';

  @override
  String get writeComment => '写评论...';

  @override
  String replyingTo(String name) {
    return '回复 $name';
  }

  @override
  String get reply => '回复';

  @override
  String get deletePost => '删除帖子';

  @override
  String get deletePostConfirm => '确定要删除这条帖子吗？';

  @override
  String get deleteComment => '删除评论';

  @override
  String get postDeleted => '帖子已删除';

  @override
  String get commentDeleted => '评论已删除';

  @override
  String get noPostsYet => '还没有帖子';

  @override
  String get followToSeePosts => '关注用户后可以在这里看到他们的帖子';

  @override
  String get discoverPosts => '发现社区中的精彩帖子';

  @override
  String get seeMore => '查看更多';

  @override
  String get followers => '粉丝';

  @override
  String get followingLabel => '关注';

  @override
  String get posts => '帖子';

  @override
  String get follow => '关注';

  @override
  String get unfollow => '取消关注';

  @override
  String get editProfile => '编辑资料';

  @override
  String get bio => '个人简介';

  @override
  String get bioHint => '介绍一下自己...';

  @override
  String get searchUsers => '搜索用户...';

  @override
  String get suggestedUsers => '推荐用户';

  @override
  String get noUsersFound => '未找到用户';

  @override
  String get report => '举报';

  @override
  String get reportContent => '举报内容';

  @override
  String get reportReason => '请输入举报原因';

  @override
  String get reportSubmitted => '举报已提交';

  @override
  String get blockUser => '屏蔽用户';

  @override
  String get unblockUser => '取消屏蔽';

  @override
  String get userBlocked => '已屏蔽该用户';

  @override
  String get userUnblocked => '已取消屏蔽';

  @override
  String get postCreated => '发布成功！';

  @override
  String likesCount(int count) {
    return '$count个赞';
  }

  @override
  String commentsCount(int count) {
    return '$count条评论';
  }

  @override
  String followersCount(int count) {
    return '$count位粉丝';
  }

  @override
  String followingCount(int count) {
    return '关注$count人';
  }

  @override
  String get findFriends => '找朋友';

  @override
  String get addPhotos => '添加照片';

  @override
  String maxPhotos(int count) {
    return '最多$count张照片';
  }

  @override
  String get visibility => '可见范围';

  @override
  String get visibilityPublic => '公开';

  @override
  String get visibilityFollowers => '仅粉丝可见';

  @override
  String get noFollowingPosts => '关注的用户还没有发帖';

  @override
  String get all => '全部';

  @override
  String get learning => '学习';

  @override
  String get general => '日常';

  @override
  String get linkCopied => '链接已复制';

  @override
  String get postFailed => '发布失败';

  @override
  String get newPost => '新帖子';

  @override
  String get category => '分类';

  @override
  String get writeYourThoughts => '分享你的想法...';

  @override
  String get photos => '照片';

  @override
  String get addPhoto => '添加照片';

  @override
  String get imageUrlHint => '输入图片链接';

  @override
  String get noSuggestions => '暂无推荐，试试搜索用户吧！';

  @override
  String get noResults => '未找到用户';

  @override
  String get postDetail => '帖子详情';

  @override
  String get comments => '评论';

  @override
  String get noComments => '还没有评论，来抢沙发吧！';

  @override
  String get deleteCommentConfirm => '确定要删除这条评论吗？';

  @override
  String get failedToLoadProfile => '加载资料失败';

  @override
  String get userNotFound => '用户不存在';

  @override
  String get message => '私信';

  @override
  String get messages => '私信';

  @override
  String get noMessages => '还没有消息';

  @override
  String get startConversation => '和别人开始聊天吧！';

  @override
  String get noMessagesYet => '还没有消息，打个招呼吧！';

  @override
  String get typing => '正在输入...';

  @override
  String get typeMessage => '输入消息...';

  @override
  String get createVoiceRoom => '创建语音房间';

  @override
  String get roomTitle => '房间标题';

  @override
  String get roomTitleHint => '例如：韩语会话练习';

  @override
  String get topic => '主题';

  @override
  String get topicHint => '你想聊什么？';

  @override
  String get languageLevel => '语言水平';

  @override
  String get allLevels => '所有水平';

  @override
  String get beginner => '初级';

  @override
  String get intermediate => '中级';

  @override
  String get advanced => '高级';

  @override
  String get stageSlots => '发言席位';

  @override
  String get anyoneCanListen => '任何人都可以加入聆听';

  @override
  String get createAndJoin => '创建并加入';

  @override
  String get unmute => '取消静音';

  @override
  String get mute => '静音';

  @override
  String get leave => '离开';

  @override
  String get closeRoom => '关闭房间';

  @override
  String get emojiReaction => '表情';

  @override
  String get gesture => '动作';

  @override
  String get raiseHand => '举手';

  @override
  String get cancelRequest => '取消';

  @override
  String get leaveStage => '离开舞台';

  @override
  String get pendingRequests => '请求';

  @override
  String get typeAMessage => '输入消息...';

  @override
  String get stageRequests => '上台请求';

  @override
  String get noPendingRequests => '暂无待处理请求';

  @override
  String get onStage => '舞台上';

  @override
  String get voiceRooms => '语音房间';

  @override
  String get noVoiceRooms => '暂无活跃语音房间';

  @override
  String get createVoiceRoomHint => '创建一个开始聊天吧！';

  @override
  String get createRoom => '创建房间';

  @override
  String get batchimDescriptionText =>
      '韩语收音（받침）发音为7种音。\n多个收音发同一个音的现象叫做「收音代表音」。';

  @override
  String get syllableInputLabel => '输入音节';

  @override
  String get syllableInputHint => '例：한';

  @override
  String totalPracticedCount(int count) {
    return '共练习了 $count 个字';
  }

  @override
  String get audioLoadError => '无法加载音频';

  @override
  String get writingPracticeCompleteMessage => '书写练习完成！';

  @override
  String get sevenRepresentativeSounds => '7种代表音';

  @override
  String get myRoom => '我的房间';

  @override
  String get characterEditor => '角色编辑';

  @override
  String get roomEditor => '房间编辑';

  @override
  String get shop => '商店';

  @override
  String get character => '角色';

  @override
  String get room => '房间';

  @override
  String get hair => '发型';

  @override
  String get eyes => '眼睛';

  @override
  String get brows => '眉毛';

  @override
  String get nose => '鼻子';

  @override
  String get mouth => '嘴巴';

  @override
  String get top => '上衣';

  @override
  String get bottom => '下装';

  @override
  String get hatItem => '帽子';

  @override
  String get accessory => '饰品';

  @override
  String get wallpaper => '壁纸';

  @override
  String get floorItem => '地板';

  @override
  String get petItem => '宠物';

  @override
  String get none => '无';

  @override
  String get noItemsYet => '暂无物品';

  @override
  String get visitShopToGetItems => '去商店获取物品！';

  @override
  String get alreadyOwned => '已拥有！';

  @override
  String get buy => '购买';

  @override
  String purchasedItem(String name) {
    return '已购买 $name！';
  }

  @override
  String get notEnoughLemons => '柠檬不够！';

  @override
  String get owned => '已拥有';

  @override
  String get free => '免费';

  @override
  String get comingSoon => '即将推出！';

  @override
  String balanceLemons(int count) {
    return '余额: $count个柠檬';
  }

  @override
  String get furnitureItem => '家具';

  @override
  String get hangulWelcome => '欢迎来到韩文世界！';

  @override
  String get hangulWelcomeDesc => '逐一学习40个韩文字母';

  @override
  String get hangulStartLearning => '开始学习';

  @override
  String get hangulLearnNext => '学习下一个';

  @override
  String hangulLearnedCount(int count) {
    return '已学习$count/40个字母！';
  }

  @override
  String hangulReviewNeeded(int count) {
    return '今天有$count个字母需要复习！';
  }

  @override
  String get hangulReviewNow => '立即复习';

  @override
  String get hangulPracticeSuggestion => '快要完成了！通过活动巩固技能吧';

  @override
  String get hangulStartActivities => '开始活动';

  @override
  String get hangulMastered => '恭喜！你已经掌握了韩文字母！';

  @override
  String get hangulGoToLevel1 => '进入第1级';
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
  String get lessonComplete => '課程完成！進度已保存';

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
  String get grammarExplanation => '語法解釋';

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
  String correctAnswerIs(String answer) {
    return '正確答案: $answer';
  }

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
  String get errorOccurred => '出錯了';

  @override
  String get reload => '重新載入';

  @override
  String get noCharactersAvailable => '暫無可用字符';

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
  String get onboardingLanguageTitle => '你好！我是莫妮';

  @override
  String get onboardingLanguagePrompt => '從哪種語言開始一起學習呢？';

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
  String get onboardingAccountTitle => '準備好了嗎？';

  @override
  String get onboardingAccountSubtitle => '登入或建立帳號以儲存學習進度';

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

  @override
  String get hangulLearning => '韓文字母學習';

  @override
  String get hangulLearningSubtitle => '學習韓文字母表 40個字母';

  @override
  String get editNotes => '編輯筆記';

  @override
  String get notes => '筆記';

  @override
  String get notesHint => '為什麼要收藏這個單詞？';

  @override
  String get sortBy => '排序方式';

  @override
  String get sortNewest => '最新收藏';

  @override
  String get sortOldest => '最早收藏';

  @override
  String get sortKorean => '韓文排序';

  @override
  String get sortChinese => '中文排序';

  @override
  String get sortMastery => '掌握程度';

  @override
  String get filterAll => '全部';

  @override
  String get filterNew => '新學 (0級)';

  @override
  String get filterBeginner => '初級 (1級)';

  @override
  String get filterIntermediate => '中級 (2-3級)';

  @override
  String get filterAdvanced => '高級 (4-5級)';

  @override
  String get searchWordsNotesChinese => '搜索單詞、中文或筆記...';

  @override
  String startReviewCount(int count) {
    return '開始複習 ($count)';
  }

  @override
  String get remove => '移除';

  @override
  String get confirmRemove => '確認移除';

  @override
  String confirmRemoveWord(String word) {
    return '確定要從單詞本移除「$word」嗎？';
  }

  @override
  String get noBookmarkedWords => '還沒有收藏的單詞';

  @override
  String get bookmarkHint => '在學習過程中點擊單詞卡片上的書籤圖標';

  @override
  String get noMatchingWords => '沒有找到匹配的單詞';

  @override
  String weeksAgo(int count) {
    return '$count週前';
  }

  @override
  String get reviewComplete => '複習完成！';

  @override
  String reviewCompleteCount(int count) {
    return '已完成 $count 個單詞的複習';
  }

  @override
  String get correct => '正確';

  @override
  String get wrong => '錯誤';

  @override
  String get accuracy => '準確率';

  @override
  String get vocabularyBookReview => '單詞本複習';

  @override
  String get noWordsToReview => '暫無需要複習的單詞';

  @override
  String get bookmarkWordsToReview => '在學習過程中收藏單詞後開始複習';

  @override
  String get returnToVocabularyBook => '返回單詞本';

  @override
  String get exit => '退出';

  @override
  String get showAnswer => '顯示答案';

  @override
  String get didYouRemember => '你記住了嗎？';

  @override
  String get forgot => '忘記了';

  @override
  String get hard => '困難';

  @override
  String get remembered => '記得';

  @override
  String get easy => '簡單';

  @override
  String get addedToVocabularyBook => '已添加到單詞本';

  @override
  String get addFailed => '添加失敗';

  @override
  String get removedFromVocabularyBook => '已從單詞本移除';

  @override
  String get removeFailed => '移除失敗';

  @override
  String get addToVocabularyBook => '添加到單詞本';

  @override
  String get notesOptional => '筆記（可選）';

  @override
  String get add => '添加';

  @override
  String get bookmarked => '已收藏';

  @override
  String get bookmark => '收藏';

  @override
  String get removeFromVocabularyBook => '從單詞本移除';

  @override
  String similarityPercent(int percent) {
    return '相似度: $percent%';
  }

  @override
  String addedOrRemoved(String added) {
    String _temp0 = intl.Intl.selectLogic(
      added,
      {
        'true': '已添加到單詞本',
        'other': '已取消收藏',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => '天';

  @override
  String lessonsCompletedCount(int count) {
    return '$count 課完成';
  }

  @override
  String get dailyGoalComplete => '太棒了！今日目標已完成！';

  @override
  String get hangulAlphabet => '韓文字母';

  @override
  String get alphabetTable => '字母表';

  @override
  String get learn => '學習';

  @override
  String get practice => '練習';

  @override
  String get learningProgress => '學習進度';

  @override
  String dueForReviewCount(int count) {
    return '$count 個待複習';
  }

  @override
  String get completion => '完成度';

  @override
  String get totalCharacters => '總字母';

  @override
  String get learned => '已學習';

  @override
  String get dueForReview => '待複習';

  @override
  String overallAccuracy(String percent) {
    return '整體準確率: $percent%';
  }

  @override
  String charactersCount(int count) {
    return '$count個字母';
  }

  @override
  String get lesson1Title => '第1課：基本輔音 (上)';

  @override
  String get lesson1Desc => '學習韓語最常用的7個輔音字母';

  @override
  String get lesson2Title => '第2課：基本輔音 (下)';

  @override
  String get lesson2Desc => '繼續學習剩餘的7個基本輔音';

  @override
  String get lesson3Title => '第3課：基本元音 (上)';

  @override
  String get lesson3Desc => '學習韓語的5個基本元音';

  @override
  String get lesson4Title => '第4課：基本元音 (下)';

  @override
  String get lesson4Desc => '學習剩餘的5個基本元音';

  @override
  String get lesson5Title => '第5課：雙輔音';

  @override
  String get lesson5Desc => '學習5個雙輔音 - 緊音字母';

  @override
  String get lesson6Title => '第6課：複合元音 (上)';

  @override
  String get lesson6Desc => '學習前6個複合元音';

  @override
  String get lesson7Title => '第7課：複合元音 (下)';

  @override
  String get lesson7Desc => '學習剩餘的複合元音';

  @override
  String get loadAlphabetFirst => '請先加載字母表數據';

  @override
  String get noContentForLesson => '本課無內容';

  @override
  String get exampleWords => '例詞';

  @override
  String get thisLessonCharacters => '本課字母';

  @override
  String congratsLessonComplete(String title) {
    return '恭喜你完成了 $title！';
  }

  @override
  String get continuePractice => '繼續練習';

  @override
  String get nextLesson => '下一課';

  @override
  String get basicConsonants => '基本輔音';

  @override
  String get doubleConsonants => '雙輔音';

  @override
  String get basicVowels => '基本元音';

  @override
  String get compoundVowels => '複合元音';

  @override
  String get dailyLearningReminderTitle => '每日學習提醒';

  @override
  String get dailyLearningReminderBody => '今天的韓語學習還沒完成哦~';

  @override
  String get reviewReminderTitle => '複習時間到了！';

  @override
  String reviewReminderBody(String title) {
    return '該複習「$title」了~';
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
  String get strokeOrder => '筆畫順序';

  @override
  String get reset => '重置';

  @override
  String get pronunciationGuide => '發音指南';

  @override
  String get play => '播放';

  @override
  String get pause => '暫停';

  @override
  String loadingFailed(String error) {
    return '加載失敗: $error';
  }

  @override
  String learnedCount(int count) {
    return '已學習: $count';
  }

  @override
  String get hangulPractice => '韓文字母練習';

  @override
  String charactersNeedReview(int count) {
    return '$count 個字母需要複習';
  }

  @override
  String charactersAvailable(int count) {
    return '$count 個字母可練習';
  }

  @override
  String get selectPracticeMode => '選擇練習模式';

  @override
  String get characterRecognition => '字母識別';

  @override
  String get characterRecognitionDesc => '看到字母選擇正確的發音';

  @override
  String get pronunciationPractice => '發音練習';

  @override
  String get pronunciationPracticeDesc => '看到發音選擇正確的字母';

  @override
  String get startPractice => '開始練習';

  @override
  String get learnSomeCharactersFirst => '請先在字母表中學習一些字母';

  @override
  String get practiceComplete => '練習完成！';

  @override
  String get back => '返回';

  @override
  String get tryAgain => '再來一次';

  @override
  String get howToReadThis => '這個字母怎麼讀？';

  @override
  String get selectCorrectCharacter => '選擇正確的字母';

  @override
  String get correctExclamation => '正確！';

  @override
  String get incorrectExclamation => '錯誤';

  @override
  String get correctAnswerLabel => '正確答案: ';

  @override
  String get nextQuestionBtn => '下一題';

  @override
  String get viewResults => '查看結果';

  @override
  String get share => '分享';

  @override
  String get mnemonics => '記憶技巧';

  @override
  String nextReviewLabel(String date) {
    return '下次複習: $date';
  }

  @override
  String get expired => '已到期';

  @override
  String get practiceFunctionDeveloping => '練習功能開發中';

  @override
  String get romanization => '羅馬字: ';

  @override
  String get pronunciationLabel => '發音: ';

  @override
  String get playPronunciation => '播放發音';

  @override
  String strokesCount(int count) {
    return '$count畫';
  }

  @override
  String get perfectCount => '完美';

  @override
  String get loadFailed => '加載失敗';

  @override
  String countUnit(int count) {
    return '$count個';
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
  String get exitLesson => '退出學習';

  @override
  String get exitLessonConfirm => '確定要退出當前課程嗎？進度將會保存。';

  @override
  String get exitBtn => '退出';

  @override
  String loadingLesson(String title) {
    return '$title 載入中...';
  }

  @override
  String get cannotLoadContent => '無法載入課程內容';

  @override
  String get noLessonContent => '此課程暫無內容';

  @override
  String stageProgress(int current, int total) {
    return '第 $current 階段 / $total';
  }

  @override
  String unknownStageType(String type) {
    return '未知階段類型: $type';
  }

  @override
  String wordsCount(int count) {
    return '$count 個單詞';
  }

  @override
  String get startLearning => '開始學習';

  @override
  String get vocabularyLearning => '詞彙學習';

  @override
  String get noImage => '暫無圖片';

  @override
  String get previousItem => '上一個';

  @override
  String get nextItem => '下一個';

  @override
  String get playingAudio => '播放中...';

  @override
  String get playAll => '播放全部';

  @override
  String audioPlayFailed(String error) {
    return '音頻播放失敗: $error';
  }

  @override
  String get stopBtn => '停止';

  @override
  String get playAudioBtn => '播放音頻';

  @override
  String get playingAudioShort => '播放音頻...';

  @override
  String grammarPattern(String pattern) {
    return '語法 · $pattern';
  }

  @override
  String get conjugationRule => '活用規則';

  @override
  String get comparisonWithChinese => '與中文對比';

  @override
  String get dialogueTitle => '對話練習';

  @override
  String get dialogueExplanation => '對話解析';

  @override
  String speaker(String name) {
    return '發言人 $name';
  }

  @override
  String get practiceTitle => '練習';

  @override
  String get practiceInstructions => '請完成以下練習題';

  @override
  String get checkAnswerBtn => '檢查答案';

  @override
  String get quizTitle => '測驗';

  @override
  String get quizResult => '測驗結果';

  @override
  String quizScoreDisplay(int correct, int total) {
    return '$correct/$total';
  }

  @override
  String quizAccuracy(int percent) {
    return '準確率: $percent%';
  }

  @override
  String get summaryTitle => '課程總結';

  @override
  String get vocabLearned => '學習單詞';

  @override
  String get grammarLearned => '學習語法';

  @override
  String get finishLesson => '完成課程';

  @override
  String get reviewVocab => '複習單詞';

  @override
  String similarity(int percent) {
    return '相似度: $percent%';
  }

  @override
  String get partOfSpeechNoun => '名詞';

  @override
  String get partOfSpeechVerb => '動詞';

  @override
  String get partOfSpeechAdjective => '形容詞';

  @override
  String get partOfSpeechAdverb => '副詞';

  @override
  String get partOfSpeechPronoun => '代詞';

  @override
  String get partOfSpeechParticle => '助詞';

  @override
  String get partOfSpeechConjunction => '連詞';

  @override
  String get partOfSpeechInterjection => '感嘆詞';

  @override
  String get noVocabulary => '暫無單詞資料';

  @override
  String get noGrammar => '暫無語法資料';

  @override
  String get noPractice => '暫無練習題';

  @override
  String get noDialogue => '暫無對話內容';

  @override
  String get noQuiz => '暫無測驗題目';

  @override
  String get tapToFlip => '點擊翻轉';

  @override
  String get listeningQuestion => '聽力';

  @override
  String get submit => '提交';

  @override
  String timeStudied(String time) {
    return '已學習 $time';
  }

  @override
  String get statusNotStarted => '未開始';

  @override
  String get statusInProgress => '進行中';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusFailed => '未通過';

  @override
  String get masteryNew => '新';

  @override
  String get masteryLearning => '學習中';

  @override
  String get masteryFamiliar => '熟悉';

  @override
  String get masteryMastered => '掌握';

  @override
  String get masteryExpert => '精通';

  @override
  String get masteryPerfect => '完美';

  @override
  String get masteryUnknown => '未知';

  @override
  String get dueForReviewNow => '該複習了';

  @override
  String get similarityHigh => '高相似度';

  @override
  String get similarityMedium => '中等相似度';

  @override
  String get similarityLow => '低相似度';

  @override
  String get typeBasicConsonant => '基本輔音';

  @override
  String get typeDoubleConsonant => '雙輔音';

  @override
  String get typeBasicVowel => '基本元音';

  @override
  String get typeCompoundVowel => '複合元音';

  @override
  String get typeFinalConsonant => '收音';

  @override
  String get dailyReminderChannel => '每日學習提醒';

  @override
  String get dailyReminderChannelDesc => '每天固定時間提醒你學習韓語';

  @override
  String get reviewReminderChannel => '複習提醒';

  @override
  String get reviewReminderChannelDesc => '基於間隔重複演算法的複習提醒';

  @override
  String get notificationStudyTime => '學習時間到了！';

  @override
  String get notificationStudyReminder => '今天的韓語學習還沒完成哦~';

  @override
  String get notificationReviewTime => '該複習了！';

  @override
  String get notificationReviewReminder => '複習一下之前學過的內容吧~';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return '該複習「$lessonTitle」了~';
  }

  @override
  String get keepGoing => '繼續加油！';

  @override
  String scoreDisplay(int correct, int total) {
    return '得分：$correct / $total';
  }

  @override
  String loadDataError(String error) {
    return '載入資料失敗: $error';
  }

  @override
  String downloadError(String error) {
    return '下載錯誤: $error';
  }

  @override
  String deleteError(String error) {
    return '刪除失敗: $error';
  }

  @override
  String clearAllError(String error) {
    return '清空失敗: $error';
  }

  @override
  String cleanupError(String error) {
    return '清理失敗: $error';
  }

  @override
  String downloadLessonFailed(String title) {
    return '下載失敗: $title';
  }

  @override
  String get comprehensive => '綜合';

  @override
  String answeredCount(int answered, int total) {
    return '已答 $answered/$total';
  }

  @override
  String get hanjaWord => '漢字詞';

  @override
  String get tapToFlipBack => '點擊返回';

  @override
  String get similarityWithChinese => '與中文相似度';

  @override
  String get hanjaWordSimilarPronunciation => '漢字詞，發音相似';

  @override
  String get sameEtymologyEasyToRemember => '詞源相同，便於記憶';

  @override
  String get someConnection => '有一定聯繫';

  @override
  String get nativeWordNeedsMemorization => '固有詞，需要記憶';

  @override
  String get rules => '規則';

  @override
  String get koreanLanguage => '🇰🇷 韓語';

  @override
  String get chineseLanguage => '🇨🇳 中文';

  @override
  String exampleNumber(int number) {
    return '例 $number';
  }

  @override
  String get fillInBlankPrompt => '填空：';

  @override
  String get correctFeedback => '太棒了！答對了！';

  @override
  String get incorrectFeedback => '不對哦，再想想看';

  @override
  String get allStagesPassed => '7個階段全部通過';

  @override
  String get continueToLearnMore => '繼續學習更多內容';

  @override
  String timeFormatHMS(int hours, int minutes, int seconds) {
    return '$hours時$minutes分$seconds秒';
  }

  @override
  String timeFormatMS(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String timeFormatS(int seconds) {
    return '$seconds秒';
  }

  @override
  String get repeatEnabled => '已開啟重複';

  @override
  String get repeatDisabled => '已關閉重複';

  @override
  String get stop => '停止';

  @override
  String get playbackSpeed => '播放速度';

  @override
  String get slowSpeed => '慢速';

  @override
  String get normalSpeed => '正常';

  @override
  String get mouthShape => '口型';

  @override
  String get tonguePosition => '舌位';

  @override
  String get airFlow => '氣流';

  @override
  String get nativeComparison => '母語對比';

  @override
  String get similarSounds => '相似音';

  @override
  String get soundDiscrimination => '辨音練習';

  @override
  String get listenAndSelect => '聽音選擇正確的字母';

  @override
  String get similarSoundGroups => '相似音組';

  @override
  String get plainSound => '平音';

  @override
  String get aspiratedSound => '送氣音';

  @override
  String get tenseSound => '緊音';

  @override
  String get writingPractice => '書寫練習';

  @override
  String get watchAnimation => '觀看動畫';

  @override
  String get traceWithGuide => '描摹練習';

  @override
  String get freehandWriting => '自由書寫';

  @override
  String get clearCanvas => '清除';

  @override
  String get showGuide => '顯示引導';

  @override
  String get hideGuide => '隱藏引導';

  @override
  String get writingAccuracy => '準確度';

  @override
  String get tryAgainWriting => '再試一次';

  @override
  String get nextStep => '下一步';

  @override
  String strokeOrderStep(int current, int total) {
    return '第 $current/$total 步';
  }

  @override
  String get syllableCombination => '音節組合';

  @override
  String get selectConsonant => '選擇輔音';

  @override
  String get selectVowel => '選擇元音';

  @override
  String get selectFinalConsonant => '選擇收音（可選）';

  @override
  String get noFinalConsonant => '無收音';

  @override
  String get combinedSyllable => '組合音節';

  @override
  String get playSyllable => '播放音節';

  @override
  String get decomposeSyllable => '分解音節';

  @override
  String get batchimPractice => '收音練習';

  @override
  String get batchimExplanation => '收音說明';

  @override
  String get recordPronunciation => '錄音練習';

  @override
  String get startRecording => '開始錄音';

  @override
  String get stopRecording => '停止錄音';

  @override
  String get playRecording => '播放錄音';

  @override
  String get compareWithNative => '與原音對比';

  @override
  String get shadowingMode => '跟讀模式';

  @override
  String get listenThenRepeat => '先聽後說';

  @override
  String get selfEvaluation => '自我評價';

  @override
  String get accurate => '準確';

  @override
  String get almostCorrect => '接近';

  @override
  String get needsPractice => '需要練習';

  @override
  String get recordingNotSupported => '此平台不支援錄音功能';

  @override
  String get showMeaning => '顯示釋義';

  @override
  String get hideMeaning => '隱藏釋義';

  @override
  String get exampleWord => '示例單詞';

  @override
  String get meaningToggle => '釋義顯示設定';

  @override
  String get microphonePermissionRequired => '錄音需要麥克風權限';

  @override
  String get activities => '活動';

  @override
  String get listeningAndSpeaking => '聽力 & 口說';

  @override
  String get readingAndWriting => '閱讀 & 寫作';

  @override
  String get soundDiscriminationDesc => '訓練耳朵區分相似的聲音';

  @override
  String get shadowingDesc => '跟讀原生發音';

  @override
  String get syllableCombinationDesc => '學習子音和母音如何組合';

  @override
  String get batchimPracticeDesc => '練習收音發音';

  @override
  String get writingPracticeDesc => '練習書寫韓文字母';

  @override
  String get webNotSupported => '網頁版不支援';

  @override
  String get chapter => '章節';

  @override
  String get bossQuiz => 'Boss測驗';

  @override
  String get bossQuizCleared => 'Boss測驗通過！';

  @override
  String get bossQuizBonus => '獎勵檸檬';

  @override
  String get lemonsScoreHint95 => '95%以上獲得3個檸檬';

  @override
  String get lemonsScoreHint80 => '80%以上獲得2個檸檬';

  @override
  String get myLemonTree => '我的檸檬樹';

  @override
  String get harvestLemon => '收穫檸檬';

  @override
  String get watchAdToHarvest => '觀看廣告來收穫這個檸檬？';

  @override
  String get lemonHarvested => '檸檬已收穫！';

  @override
  String get lemonsAvailable => '個檸檬可收穫';

  @override
  String get completeMoreLessons => '完成更多課程來種植檸檬';

  @override
  String get totalLemons => '檸檬總數';

  @override
  String get community => '社群';

  @override
  String get following => '追蹤中';

  @override
  String get discover => '探索';

  @override
  String get createPost => '發文';

  @override
  String get writePost => '分享你的想法...';

  @override
  String get postCategory => '分類';

  @override
  String get categoryLearning => '學習';

  @override
  String get categoryGeneral => '日常';

  @override
  String get categoryAll => '全部';

  @override
  String get post => '發布';

  @override
  String get like => '按讚';

  @override
  String get comment => '留言';

  @override
  String get writeComment => '寫留言...';

  @override
  String replyingTo(String name) {
    return '回覆 $name';
  }

  @override
  String get reply => '回覆';

  @override
  String get deletePost => '刪除貼文';

  @override
  String get deletePostConfirm => '確定要刪除這則貼文嗎？';

  @override
  String get deleteComment => '刪除留言';

  @override
  String get postDeleted => '貼文已刪除';

  @override
  String get commentDeleted => '留言已刪除';

  @override
  String get noPostsYet => '還沒有貼文';

  @override
  String get followToSeePosts => '追蹤用戶後可以在這裡看到他們的貼文';

  @override
  String get discoverPosts => '探索社群中的精彩貼文';

  @override
  String get seeMore => '查看更多';

  @override
  String get followers => '粉絲';

  @override
  String get followingLabel => '追蹤中';

  @override
  String get posts => '貼文';

  @override
  String get follow => '追蹤';

  @override
  String get unfollow => '取消追蹤';

  @override
  String get editProfile => '編輯個人資料';

  @override
  String get bio => '個人簡介';

  @override
  String get bioHint => '介紹一下自己...';

  @override
  String get searchUsers => '搜尋用戶...';

  @override
  String get suggestedUsers => '推薦用戶';

  @override
  String get noUsersFound => '找不到用戶';

  @override
  String get report => '檢舉';

  @override
  String get reportContent => '檢舉內容';

  @override
  String get reportReason => '請輸入檢舉原因';

  @override
  String get reportSubmitted => '檢舉已提交';

  @override
  String get blockUser => '封鎖用戶';

  @override
  String get unblockUser => '解除封鎖';

  @override
  String get userBlocked => '已封鎖該用戶';

  @override
  String get userUnblocked => '已解除封鎖';

  @override
  String get postCreated => '發布成功！';

  @override
  String likesCount(int count) {
    return '$count個讚';
  }

  @override
  String commentsCount(int count) {
    return '$count則留言';
  }

  @override
  String followersCount(int count) {
    return '$count位粉絲';
  }

  @override
  String followingCount(int count) {
    return '追蹤$count人';
  }

  @override
  String get findFriends => '找朋友';

  @override
  String get addPhotos => '新增照片';

  @override
  String maxPhotos(int count) {
    return '最多$count張照片';
  }

  @override
  String get visibility => '可見範圍';

  @override
  String get visibilityPublic => '公開';

  @override
  String get visibilityFollowers => '僅粉絲可見';

  @override
  String get noFollowingPosts => '追蹤的用戶還沒有發文';

  @override
  String get all => '全部';

  @override
  String get learning => '學習';

  @override
  String get general => '日常';

  @override
  String get linkCopied => '連結已複製';

  @override
  String get postFailed => '發布失敗';

  @override
  String get newPost => '新貼文';

  @override
  String get category => '分類';

  @override
  String get writeYourThoughts => '分享你的想法...';

  @override
  String get photos => '照片';

  @override
  String get addPhoto => '新增照片';

  @override
  String get imageUrlHint => '輸入圖片連結';

  @override
  String get noSuggestions => '暫無推薦，試試搜尋用戶吧！';

  @override
  String get noResults => '找不到用戶';

  @override
  String get postDetail => '貼文詳情';

  @override
  String get comments => '留言';

  @override
  String get noComments => '還沒有留言，來搶沙發吧！';

  @override
  String get deleteCommentConfirm => '確定要刪除這則留言嗎？';

  @override
  String get failedToLoadProfile => '載入資料失敗';

  @override
  String get userNotFound => '用戶不存在';

  @override
  String get message => '私訊';

  @override
  String get messages => '私訊';

  @override
  String get noMessages => '還沒有訊息';

  @override
  String get startConversation => '和別人開始聊天吧！';

  @override
  String get noMessagesYet => '還沒有訊息，打個招呼吧！';

  @override
  String get typing => '正在輸入...';

  @override
  String get typeMessage => '輸入訊息...';

  @override
  String get createVoiceRoom => '建立語音房間';

  @override
  String get roomTitle => '房間標題';

  @override
  String get roomTitleHint => '例如：韓語會話練習';

  @override
  String get topic => '主題';

  @override
  String get topicHint => '你想聊什麼？';

  @override
  String get languageLevel => '語言程度';

  @override
  String get allLevels => '所有程度';

  @override
  String get beginner => '初級';

  @override
  String get intermediate => '中級';

  @override
  String get advanced => '高級';

  @override
  String get stageSlots => '發言席位';

  @override
  String get anyoneCanListen => '任何人都可以加入聆聽';

  @override
  String get createAndJoin => '建立並加入';

  @override
  String get unmute => '取消靜音';

  @override
  String get mute => '靜音';

  @override
  String get leave => '離開';

  @override
  String get closeRoom => '關閉房間';

  @override
  String get emojiReaction => '表情';

  @override
  String get gesture => '動作';

  @override
  String get raiseHand => '舉手';

  @override
  String get cancelRequest => '取消';

  @override
  String get leaveStage => '離開舞台';

  @override
  String get pendingRequests => '請求';

  @override
  String get typeAMessage => '輸入訊息...';

  @override
  String get stageRequests => '上台請求';

  @override
  String get noPendingRequests => '暫無待處理請求';

  @override
  String get onStage => '舞台上';

  @override
  String get voiceRooms => '語音房間';

  @override
  String get noVoiceRooms => '目前沒有語音房間';

  @override
  String get createVoiceRoomHint => '建立一個開始聊天吧！';

  @override
  String get createRoom => '建立房間';

  @override
  String get batchimDescriptionText =>
      '韓語收音（받침）發音為7種音。\n多個收音發同一個音的現象叫做「收音代表音」。';

  @override
  String get syllableInputLabel => '輸入音節';

  @override
  String get syllableInputHint => '例：한';

  @override
  String totalPracticedCount(int count) {
    return '共練習了 $count 個字';
  }

  @override
  String get audioLoadError => '無法載入音訊';

  @override
  String get writingPracticeCompleteMessage => '書寫練習完成！';

  @override
  String get sevenRepresentativeSounds => '7種代表音';

  @override
  String get myRoom => '我的房間';

  @override
  String get characterEditor => '角色編輯';

  @override
  String get roomEditor => '房間編輯';

  @override
  String get shop => '商店';

  @override
  String get character => '角色';

  @override
  String get room => '房間';

  @override
  String get hair => '髮型';

  @override
  String get eyes => '眼睛';

  @override
  String get brows => '眉毛';

  @override
  String get nose => '鼻子';

  @override
  String get mouth => '嘴巴';

  @override
  String get top => '上衣';

  @override
  String get bottom => '下裝';

  @override
  String get hatItem => '帽子';

  @override
  String get accessory => '飾品';

  @override
  String get wallpaper => '壁紙';

  @override
  String get floorItem => '地板';

  @override
  String get petItem => '寵物';

  @override
  String get none => '無';

  @override
  String get noItemsYet => '暫無物品';

  @override
  String get visitShopToGetItems => '去商店獲取物品！';

  @override
  String get alreadyOwned => '已擁有！';

  @override
  String get buy => '購買';

  @override
  String purchasedItem(String name) {
    return '已購買 $name！';
  }

  @override
  String get notEnoughLemons => '檸檬不夠！';

  @override
  String get owned => '已擁有';

  @override
  String get free => '免費';

  @override
  String get comingSoon => '即將推出！';

  @override
  String balanceLemons(int count) {
    return '餘額: $count個檸檬';
  }

  @override
  String get furnitureItem => '家具';

  @override
  String get hangulWelcome => '歡迎來到韓文世界！';

  @override
  String get hangulWelcomeDesc => '逐一學習40個韓文字母';

  @override
  String get hangulStartLearning => '開始學習';

  @override
  String get hangulLearnNext => '學習下一個';

  @override
  String hangulLearnedCount(int count) {
    return '已學習$count/40個字母！';
  }

  @override
  String hangulReviewNeeded(int count) {
    return '今天有$count個字母需要複習！';
  }

  @override
  String get hangulReviewNow => '立即複習';

  @override
  String get hangulPracticeSuggestion => '快要完成了！通過活動鞏固技能吧';

  @override
  String get hangulStartActivities => '開始活動';

  @override
  String get hangulMastered => '恭喜！你已經掌握了韓文字母！';

  @override
  String get hangulGoToLevel1 => '進入第1級';
}
