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
  String get displayTip => '提示：课程内容将使用你选择的中文字体显示。';

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
      '即使没有网络连接，你也可以正常学习已下载的课程。进度会在本地保存，联网后自动同步。';

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
      '基于间隔重复算法（SRS），应用会在最佳时间提醒你复习已学课程。复习间隔：1天 → 3天 → 7天 → 14天 → 30天。';

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
  String get howToStartAnswer => '在主页面选择适合你水平的课程，从第1课开始。每节课包含7个学习阶段。';

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
  String get previous => '上一个';

  @override
  String get next => '下一个';

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
  String get translation => '翻译';

  @override
  String get wordOrder => '排序';

  @override
  String get excellent => '太棒了！';

  @override
  String get correctOrderIs => '正确顺序是：';

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
    return '用时：$time';
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
  String get onboardingWelcomeSubtitle => '在这里开启你的韩语之旅';

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
    return '$count个待复习';
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
    return '已学习：$count';
  }

  @override
  String get hangulPractice => '韩文字母练习';

  @override
  String charactersNeedReview(int count) {
    return '$count个字母需要复习';
  }

  @override
  String charactersAvailable(int count) {
    return '$count个字母可练习';
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
  String get correctAnswerLabel => '正确答案：';

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
  String get romanization => '罗马字：';

  @override
  String get pronunciationLabel => '发音：';

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
  String get lessonComplete => '课程完成！进度已保存';

  @override
  String loadingLesson(String title) {
    return '正在加载$title...';
  }

  @override
  String get cannotLoadContent => '无法加载课程内容';

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
  String get continueBtn => '继续';

  @override
  String get previousQuestion => '上一题';

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
  String get pronunciation => '发音';

  @override
  String grammarPattern(String pattern) {
    return '语法 · $pattern';
  }

  @override
  String get grammarExplanation => '语法解释';

  @override
  String get conjugationRule => '活用规则';

  @override
  String get comparisonWithChinese => '与中文对比';

  @override
  String get exampleSentences => '例句';

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
  String get fillBlank => '填空';

  @override
  String get checkAnswerBtn => '检查答案';

  @override
  String correctAnswerIs(String answer) {
    return '正确答案：$answer';
  }

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
  String get vocabLearned => '已学单词';

  @override
  String get grammarLearned => '已学语法';

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
  String get userNotFound => '找不到用户';

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
  String get stageSlots => '上台名额';

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
  String get leaveStage => '退出发言席';

  @override
  String get pendingRequests => '请求';

  @override
  String get typeAMessage => '输入消息...';

  @override
  String get stageRequests => '上台请求';

  @override
  String get noPendingRequests => '暂无待处理请求';

  @override
  String get onStage => '发言中';

  @override
  String get voiceRooms => '语音房间';

  @override
  String get noVoiceRooms => '暂无活跃语音房间';

  @override
  String get createVoiceRoomHint => '创建一个开始聊天吧！';

  @override
  String get createRoom => '创建房间';

  @override
  String get voiceRoomMicPermission => '语音房间需要麦克风权限';

  @override
  String get voiceRoomEnterTitle => '请输入房间标题';

  @override
  String get voiceRoomCreateFailed => '创建房间失败';

  @override
  String get voiceRoomNotAvailable => '房间不可用';

  @override
  String get voiceRoomGoBack => '返回';

  @override
  String get voiceRoomConnecting => '连接中...';

  @override
  String voiceRoomReconnecting(int attempts, int max) {
    return '重新连接中 ($attempts/$max)...';
  }

  @override
  String get voiceRoomDisconnected => '已断开连接';

  @override
  String get voiceRoomRetry => '重试';

  @override
  String get voiceRoomHostLabel => '（主持人）';

  @override
  String get voiceRoomDemoteToListener => '降为听众';

  @override
  String get voiceRoomKickFromRoom => '踢出房间';

  @override
  String get voiceRoomListeners => '听众';

  @override
  String get voiceRoomInviteToStage => '邀请上台';

  @override
  String voiceRoomInviteConfirm(String name) {
    return '邀请$name上台发言？';
  }

  @override
  String get voiceRoomInvite => '邀请';

  @override
  String get voiceRoomCloseConfirmTitle => '关闭房间？';

  @override
  String get voiceRoomCloseConfirmBody => '这将结束所有人的通话。';

  @override
  String get voiceRoomNoMessagesYet => '暂无消息';

  @override
  String get voiceRoomTypeMessage => '输入消息...';

  @override
  String get voiceRoomStageFull => '舞台已满';

  @override
  String voiceRoomListenerCount(int count) {
    return '$count位听众';
  }

  @override
  String get voiceRoomRemoveFromStage => '移出舞台？';

  @override
  String voiceRoomRemoveFromStageConfirm(String name) {
    return '将$name移出舞台？他们将成为听众。';
  }

  @override
  String get voiceRoomDemote => '降级';

  @override
  String get voiceRoomRemoveFromRoom => '移出房间？';

  @override
  String voiceRoomRemoveFromRoomConfirm(String name) {
    return '将$name移出房间？他们将被断开连接。';
  }

  @override
  String get voiceRoomRemove => '移出';

  @override
  String get voiceRoomPressBackToLeave => '再按一次返回键退出';

  @override
  String get voiceRoomLeaveTitle => '离开房间？';

  @override
  String get voiceRoomLeaveBody => '你目前在舞台上。确定要离开吗？';

  @override
  String get voiceRoomReturningToList => '正在返回房间列表...';

  @override
  String get voiceRoomConnected => '已连接！';

  @override
  String get voiceRoomStageFailedToLoad => '舞台加载失败';

  @override
  String get voiceRoomPreparingStage => '正在准备舞台...';

  @override
  String voiceRoomAcceptToStage(Object name) {
    return '接受$name上台';
  }

  @override
  String voiceRoomRejectFromStage(Object name) {
    return '拒绝$name';
  }

  @override
  String get voiceRoomQuickCreate => '快速创建';

  @override
  String get voiceRoomRoomType => '房间类型';

  @override
  String get voiceRoomSessionDuration => '会话时长';

  @override
  String get voiceRoomOptionalTimer => '可选的会话计时器';

  @override
  String get voiceRoomDurationNone => '无限制';

  @override
  String get voiceRoomDuration15 => '15分钟';

  @override
  String get voiceRoomDuration30 => '30分钟';

  @override
  String get voiceRoomDuration45 => '45分钟';

  @override
  String get voiceRoomDuration60 => '60分钟';

  @override
  String get voiceRoomTypeFreeTalk => '自由聊天';

  @override
  String get voiceRoomTypePronunciation => '发音练习';

  @override
  String get voiceRoomTypeRolePlay => '角色扮演';

  @override
  String get voiceRoomTypeQnA => '问答';

  @override
  String get voiceRoomTypeListening => '听力练习';

  @override
  String get voiceRoomTypeDebate => '辩论';

  @override
  String get voiceRoomTemplateFreeTalk => '韩语自由聊天';

  @override
  String get voiceRoomTemplatePronunciation => '发音练习';

  @override
  String get voiceRoomTemplateDailyKorean => '每日韩语';

  @override
  String get voiceRoomTemplateTopikSpeaking => 'TOPIK口语';

  @override
  String get voiceRoomCreateTooltip => '创建语音房间';

  @override
  String get voiceRoomSendReaction => '发送表情';

  @override
  String get voiceRoomLeaveRoom => '离开房间';

  @override
  String get voiceRoomUnmuteMic => '取消麦克风静音';

  @override
  String get voiceRoomMuteMic => '麦克风静音';

  @override
  String get voiceRoomCancelHandRaise => '取消举手';

  @override
  String get voiceRoomRaiseHandSemantic => '举手';

  @override
  String get voiceRoomSendGesture => '发送动作';

  @override
  String get voiceRoomLeaveStageAction => '退出舞台';

  @override
  String get voiceRoomManageStage => '管理舞台';

  @override
  String get voiceRoomMoreOptions => '更多选项';

  @override
  String get voiceRoomMore => '更多';

  @override
  String get voiceRoomStageWithSpeakers => '有发言人的语音房间舞台';

  @override
  String voiceRoomStageRequestsPending(int count) {
    return '上台请求，$count个待处理';
  }

  @override
  String voiceRoomSpeakerListenerCount(
      int speakers, int maxSpeakers, int listeners) {
    return '发言人 $speakers/$maxSpeakers，听众 $listeners';
  }

  @override
  String get voiceRoomChatInput => '聊天消息输入';

  @override
  String get voiceRoomSendMessage => '发送消息';

  @override
  String voiceRoomSendReactionNamed(Object name) {
    return '发送$name表情';
  }

  @override
  String get voiceRoomCloseReactionTray => '关闭表情面板';

  @override
  String voiceRoomPerformGesture(Object name) {
    return '执行$name动作';
  }

  @override
  String get voiceRoomCloseGestureTray => '关闭动作面板';

  @override
  String get voiceRoomGestureWave => '挥手';

  @override
  String get voiceRoomGestureBow => '鞠躬';

  @override
  String get voiceRoomGestureDance => '跳舞';

  @override
  String get voiceRoomGestureJump => '跳跃';

  @override
  String get voiceRoomGestureClap => '鼓掌';

  @override
  String get voiceRoomStageLabel => '舞台';

  @override
  String get voiceRoomYouLabel => '（我）';

  @override
  String voiceRoomListenerTapToManage(Object name) {
    return '听众$name，点击管理';
  }

  @override
  String voiceRoomListenerName(Object name) {
    return '听众$name';
  }

  @override
  String get voiceRoomMicPermissionDenied => '麦克风访问被拒绝。要使用语音功能，请在设备设置中启用。';

  @override
  String get voiceRoomMicPermissionTitle => '麦克风权限';

  @override
  String get voiceRoomOpenSettings => '打开设置';

  @override
  String get voiceRoomMicNeededForStage => '上台发言需要麦克风权限';

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

  @override
  String get completedLessonsLabel => '已完成';

  @override
  String get wordsLearnedLabel => '已学单词';

  @override
  String get totalStudyTimeLabel => '学习时间';

  @override
  String get streakDetails => '连续学习记录';

  @override
  String get consecutiveDays => '连续天数';

  @override
  String get totalStudyDaysLabel => '总学习天数';

  @override
  String get studyRecord => '学习记录';

  @override
  String get noFriendsPrompt => '找朋友一起学习吧！';

  @override
  String get moreStats => '查看全部';

  @override
  String remainingLessons(int count) {
    return '再完成$count个即可达成今日目标！';
  }

  @override
  String get streakMotivation0 => '今天开始学习吧！';

  @override
  String get streakMotivation1 => '好的开始！继续加油！';

  @override
  String get streakMotivation7 => '连续学习超过一周！太棒了！';

  @override
  String get streakMotivation14 => '坚持两周了！正在养成习惯！';

  @override
  String get streakMotivation30 => '连续一个月以上！你是真正的学习者！';

  @override
  String minutesShort(int count) {
    return '$count分钟';
  }

  @override
  String hoursShort(int count) {
    return '$count小时';
  }

  @override
  String get speechPractice => '发音练习';

  @override
  String get tapToRecord => '点击录音';

  @override
  String get recording => '录音中...';

  @override
  String get analyzing => '分析中...';

  @override
  String get pronunciationScore => '发音分数';

  @override
  String get phonemeBreakdown => '音素分析';

  @override
  String tryAgainCount(String current, String max) {
    return '重试 ($current/$max)';
  }

  @override
  String get nextCharacter => '下一个字';

  @override
  String get excellentPronunciation => '太棒了！';

  @override
  String get goodPronunciation => '做得好！';

  @override
  String get fairPronunciation => '继续加油！';

  @override
  String get needsMorePractice => '继续练习！';

  @override
  String get downloadModels => '下载';

  @override
  String get modelDownloading => '正在下载模型';

  @override
  String get modelReady => '已就绪';

  @override
  String get modelNotReady => '未安装';

  @override
  String get modelSize => '模型大小';

  @override
  String get speechModelTitle => '语音识别AI模型';

  @override
  String get skipSpeechPractice => '跳过';

  @override
  String get deleteModel => '删除模型';

  @override
  String get overallScore => '综合分数';

  @override
  String get appTagline => '像柠檬一样清新，实力稳稳的！';

  @override
  String get passwordHint => '请输入包含字母和数字的8位以上密码';

  @override
  String get findAccount => '找回账号';

  @override
  String get resetPassword => '重置密码';

  @override
  String get registerTitle => '清新的韩语之旅，现在出发！';

  @override
  String get registerSubtitle => '轻松起步也没关系！我会牢牢带着你';

  @override
  String get nickname => '昵称';

  @override
  String get nicknameHint => '15个字符以内：字母、数字、下划线';

  @override
  String get confirmPasswordHint => '请再次输入密码';

  @override
  String get accountChoiceTitle => '欢迎！和莫尼一起\n建立学习习惯吧！';

  @override
  String get accountChoiceSubtitle => '清新出发，实力我来帮你守住！';

  @override
  String get startWithEmail => '使用邮箱开始';

  @override
  String get deleteMessageTitle => '删除消息？';

  @override
  String get deleteMessageContent => '此消息将对所有人删除。';

  @override
  String get messageDeleted => '消息已删除';

  @override
  String get beFirstToPost => '来发第一条帖子吧！';

  @override
  String get typeTagHint => '输入标签...';

  @override
  String get userInfoLoadFailed => '加载用户信息失败';

  @override
  String get loginErrorOccurred => '登录过程中发生错误';

  @override
  String get registerErrorOccurred => '注册过程中发生错误';

  @override
  String get logoutErrorOccurred => '退出登录过程中发生错误';

  @override
  String get hangulStage0Title => '第0阶段：理解韩文结构';

  @override
  String get hangulStage1Title => '第1阶段：基本元音';

  @override
  String get hangulStage2Title => '第2阶段：Y元音';

  @override
  String get hangulStage3Title => '第3阶段：ㅐ/ㅔ元音';

  @override
  String get hangulStage4Title => '第4阶段：基本辅音1';

  @override
  String get hangulStage5Title => '第5阶段：基本辅音2';

  @override
  String get hangulStage6Title => '第6阶段：音节组合训练';

  @override
  String get hangulStage7Title => '第7阶段：紧音/送气音';

  @override
  String get hangulStage8Title => '第8阶段：收音（终声）1';

  @override
  String get hangulStage9Title => '第9阶段：收音扩展';

  @override
  String get hangulStage10Title => '第10阶段：复合收音';

  @override
  String get hangulStage11Title => '第11阶段：扩展词汇阅读';

  @override
  String get sortAlphabetical => '字母顺序';

  @override
  String get sortByLevel => '按级别';

  @override
  String get sortBySimilarity => '按相似度';

  @override
  String get searchWordsKoreanMeaning => '搜索单词（韩语/含义）';

  @override
  String get groupedView => '分组视图';

  @override
  String get matrixView => '辅音×元音';

  @override
  String get reviewLessons => '复习课程';

  @override
  String get stageDetailComingSoon => '详细内容正在准备中。';

  @override
  String get bossQuizComingSoon => 'Boss测验正在准备中。';

  @override
  String get exitLessonDialogTitle => '退出课程';

  @override
  String get exitLessonDialogContent => '要退出课程吗？\n当前步骤的进度将自动保存。';

  @override
  String get continueButton => '继续';

  @override
  String get exitLessonButton => '退出';

  @override
  String get noQuestions => '没有可用的问题';

  @override
  String get noCharactersDefined => '未定义字符';

  @override
  String get recordingStartFailed => '录音启动失败';

  @override
  String get consonant => '辅音';

  @override
  String get vowel => '元音';

  @override
  String get validationEmailRequired => '请输入电子邮箱';

  @override
  String get validationEmailTooLong => '电子邮箱地址过长';

  @override
  String get validationEmailInvalid => '请输入有效的电子邮箱地址';

  @override
  String get validationPasswordRequired => '请输入密码';

  @override
  String validationPasswordMinLength(int minLength) {
    return '密码至少需要$minLength个字符';
  }

  @override
  String get validationPasswordNeedLetter => '密码必须包含字母';

  @override
  String get validationPasswordNeedNumber => '密码必须包含数字';

  @override
  String get validationPasswordNeedSpecial => '密码必须包含特殊字符';

  @override
  String get validationPasswordTooLong => '密码过长';

  @override
  String get validationConfirmPasswordRequired => '请再次输入密码';

  @override
  String get validationPasswordMismatch => '两次输入的密码不一致';

  @override
  String get validationUsernameRequired => '请输入用户名';

  @override
  String validationUsernameTooShort(int minLength) {
    return '用户名至少需要$minLength个字符';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return '用户名不能超过$maxLength个字符';
  }

  @override
  String get validationUsernameInvalidChars => '用户名只能包含字母、数字和下划线';

  @override
  String validationFieldRequired(String fieldName) {
    return '请输入$fieldName';
  }

  @override
  String validationFieldMinLength(String fieldName, int minLength) {
    return '$fieldName至少需要$minLength个字符';
  }

  @override
  String validationFieldMaxLength(String fieldName, int maxLength) {
    return '$fieldName不能超过$maxLength个字符';
  }

  @override
  String validationFieldNumeric(String fieldName) {
    return '$fieldName必须是数字';
  }

  @override
  String get errorNetworkConnection => '网络连接失败，请检查网络设置';

  @override
  String get errorServer => '服务器错误，请稍后重试';

  @override
  String get errorAuthFailed => '认证失败，请重新登录';

  @override
  String get errorUnknown => '未知错误，请稍后重试';

  @override
  String get errorTimeout => '连接超时，请检查网络';

  @override
  String get errorRequestCancelled => '请求已取消';

  @override
  String get errorForbidden => '没有访问权限';

  @override
  String get errorNotFound => '请求的资源不存在';

  @override
  String get errorRequestParam => '请求参数错误';

  @override
  String get errorParseData => '数据解析错误';

  @override
  String get errorParseFormat => '数据格式错误';

  @override
  String get errorRateLimited => '请求过多，请稍后重试';

  @override
  String get successLogin => '登录成功';

  @override
  String get successRegister => '注册成功';

  @override
  String get successSync => '同步成功';

  @override
  String get successDownload => '下载成功';

  @override
  String get failedToCreateComment => '创建评论失败';

  @override
  String get failedToDeleteComment => '删除评论失败';

  @override
  String get failedToSubmitReport => '提交举报失败';

  @override
  String get failedToBlockUser => '屏蔽用户失败';

  @override
  String get failedToUnblockUser => '取消屏蔽用户失败';

  @override
  String get failedToCreatePost => '创建帖子失败';

  @override
  String get failedToDeletePost => '删除帖子失败';

  @override
  String noVocabularyForLevel(int level) {
    return '未找到$level级词汇';
  }

  @override
  String get uploadingImage => '[图片上传中...]';

  @override
  String get uploadingVoice => '[语音上传中...]';

  @override
  String get imagePreview => '[图片]';

  @override
  String get voicePreview => '[语音]';

  @override
  String get voiceServerConnectFailed => '无法连接语音服务器，请检查您的连接。';

  @override
  String get connectionLostRetry => '连接断开，点击重试。';

  @override
  String get noInternetConnection => '无网络连接，请检查您的网络。';

  @override
  String get couldNotLoadRooms => '无法加载房间列表，请重试。';

  @override
  String get couldNotCreateRoom => '无法创建房间，请重试。';

  @override
  String get couldNotJoinRoom => '无法加入房间，请检查您的连接。';

  @override
  String get roomClosedByHost => '主持人已关闭房间。';

  @override
  String get removedFromRoomByHost => '您已被主持人移出房间。';

  @override
  String get connectionTimedOut => '连接超时，请重试。';

  @override
  String get missingLiveKitCredentials => '缺少语音连接凭据。';

  @override
  String get microphoneEnableFailed => '无法启用麦克风。请检查权限并尝试取消静音。';

  @override
  String get voiceRoomNewMessages => '新消息';

  @override
  String get voiceRoomChatRateLimited => '消息发送过快，请稍候再试。';

  @override
  String get voiceRoomMessageSendFailed => '消息发送失败，请重试。';

  @override
  String get voiceRoomChatError => '聊天出错。';

  @override
  String retryAttempt(int current, int max) {
    return '重试 ($current/$max)';
  }

  @override
  String get nextButton => '下一步';

  @override
  String get completeButton => '完成';

  @override
  String get startButton => '开始';

  @override
  String get doneButton => '完成';

  @override
  String get goBackButton => '返回';

  @override
  String get tapToListen => '点击听发音';

  @override
  String get listenAllSoundsFirst => '请先听完所有发音';

  @override
  String get nextCharButton => '下一个字';

  @override
  String get listenAndChooseCorrect => '听发音，选出正确的字';

  @override
  String get lessonCompletedMsg => '你完成了课程！';

  @override
  String stageMasterLabel(int stage) {
    return '第$stage阶段大师';
  }

  @override
  String get hangulS0L0Title => '韩文是怎么来的？';

  @override
  String get hangulS0L0Subtitle => '简单了解韩文的诞生过程';

  @override
  String get hangulS0L0Step0Title => '很久以前，学习文字非常困难';

  @override
  String get hangulS0L0Step0Desc => '古代朝鲜半岛主要借用汉字书写，\n许多百姓难以学习。';

  @override
  String get hangulS0L0Step0Highlights => '汉字,困难,阅读,书写';

  @override
  String get hangulS0L0Step1Title => '世宗大王创造了新的文字';

  @override
  String get hangulS0L0Step1Desc =>
      '为了让百姓轻松学习，\n世宗大王亲自创制了训民正音。\n（1443年创制，1446年颁布）';

  @override
  String get hangulS0L0Step1Highlights => '世宗大王,训民正音,1443,1446';

  @override
  String get hangulS0L0Step2Title => '于是有了今天的韩文';

  @override
  String get hangulS0L0Step2Desc => '韩文是为了方便记录声音而创造的文字。\n在下一课中，我们将学习辅音和元音的结构。';

  @override
  String get hangulS0L0Step2Highlights => '声音,简易文字,韩文';

  @override
  String get hangulS0L0SummaryTitle => '介绍课完成！';

  @override
  String get hangulS0L0SummaryMsg => '太棒了！\n现在你知道韩文为什么被创造了。\n接下来学习辅音和元音的结构吧。';

  @override
  String get hangulS0L1Title => '组装가字块';

  @override
  String get hangulS0L1Subtitle => '通过拖拽体验拼字过程';

  @override
  String get hangulS0L1IntroTitle => '韩文就像积木！';

  @override
  String get hangulS0L1IntroDesc =>
      '韩文通过组合辅音和元音来构成文字。\n辅音（ㄱ）+ 元音（ㅏ）= 가\n\n更复杂的文字下面还会有收音（받침）。\n（以后再学！）';

  @override
  String get hangulS0L1IntroHighlights => '辅音,元音,文字';

  @override
  String get hangulS0L1DragGaTitle => '组装가';

  @override
  String get hangulS0L1DragGaDesc => '将ㄱ和ㅏ拖到空格中';

  @override
  String get hangulS0L1DragNaTitle => '组装나';

  @override
  String get hangulS0L1DragNaDesc => '试试使用新的辅音ㄴ';

  @override
  String get hangulS0L1DragDaTitle => '组装다';

  @override
  String get hangulS0L1DragDaDesc => '试试使用新的辅音ㄷ';

  @override
  String get hangulS0L1SummaryTitle => '课程完成！';

  @override
  String get hangulS0L1SummaryMsg => '辅音 + 元音 = 文字块！\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다';

  @override
  String get hangulS0L2Title => '声音探索';

  @override
  String get hangulS0L2Subtitle => '通过声音感受辅音和元音';

  @override
  String get hangulS0L2IntroTitle => '感受声音';

  @override
  String get hangulS0L2IntroDesc => '韩文的每个辅音和元音都有独特的声音。\n听一听，感受一下。';

  @override
  String get hangulS0L2Sound1Title => '辅音ㄱ、ㄴ、ㄷ的基本发音';

  @override
  String get hangulS0L2Sound1Desc => '听一听辅音加上ㅏ后的发音（가、나、다）';

  @override
  String get hangulS0L2Sound2Title => 'ㅏ、ㅗ元音发音';

  @override
  String get hangulS0L2Sound2Desc => '听一听这两个元音的发音';

  @override
  String get hangulS0L2Sound3Title => '听가、나、다的发音';

  @override
  String get hangulS0L2Sound3Desc => '听一听辅音和元音组合而成的文字发音';

  @override
  String get hangulS0L2SummaryTitle => '课程完成！';

  @override
  String get hangulS0L2SummaryMsg => '每个辅音都有配上ㅏ的标准读音，比如가、나、다。\n现在你对元音的发音也有感觉了！';

  @override
  String get hangulS0L3Title => '听音选字';

  @override
  String get hangulS0L3Subtitle => '通过声音区分文字';

  @override
  String get hangulS0L3IntroTitle => '这次用耳朵来分辨';

  @override
  String get hangulS0L3IntroDesc => '比起看屏幕，更要专注于声音。\n听音辨字，找出正确答案！';

  @override
  String get hangulS0L3Sound1Title => '确认가/나/다/고/노的发音';

  @override
  String get hangulS0L3Sound1Desc => '先充分听一下这5个发音';

  @override
  String get hangulS0L3Match1Title => '听音选择相同的文字';

  @override
  String get hangulS0L3Match1Desc => '选择与播放的声音相匹配的文字';

  @override
  String get hangulS0L3Match2Title => '区分ㅏ / ㅗ的发音';

  @override
  String get hangulS0L3Match2Desc => '辅音相同时，靠元音来区分发音';

  @override
  String get hangulS0L3SummaryTitle => '课程完成！';

  @override
  String get hangulS0L3SummaryMsg => '太棒了！\n现在你可以同时用眼睛（组装）和耳朵（声音）\n来理解韩文的结构了。';

  @override
  String get hangulS0CompleteTitle => '第0阶段完成！';

  @override
  String get hangulS0CompleteMsg => '你已经理解了韩文的结构！';

  @override
  String get hangulS1L1Title => 'ㅏ的形状与读音';

  @override
  String get hangulS1L1Subtitle => '竖线右侧短横: ㅏ';

  @override
  String get hangulS1L1Step0Title => '学习第一个元音ㅏ';

  @override
  String get hangulS1L1Step0Desc => 'ㅏ发出明亮的\"아\"音。\n让我们一起学习形状和读音。';

  @override
  String get hangulS1L1Step0Highlights => 'ㅏ,아,基本元音';

  @override
  String get hangulS1L1Step1Title => '听ㅏ的读音';

  @override
  String get hangulS1L1Step1Desc => '听听含有ㅏ的读音';

  @override
  String get hangulS1L1Step2Title => '发音练习';

  @override
  String get hangulS1L1Step2Desc => '请大声朗读这些文字';

  @override
  String get hangulS1L1Step3Title => '选出ㅏ的读音';

  @override
  String get hangulS1L1Step3Desc => '听音后选择正确的文字';

  @override
  String get hangulS1L1Step4Title => '形状测验';

  @override
  String get hangulS1L1Step4Desc => '准确找出ㅏ';

  @override
  String get hangulS1L1Step4Q0 => '以下哪个是ㅏ？';

  @override
  String get hangulS1L1Step4Q1 => '以下哪个含有ㅏ？';

  @override
  String get hangulS1L1Step4Q2 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step5Title => '用ㅏ组字';

  @override
  String get hangulS1L1Step5Desc => '将辅音与ㅏ组合完成文字';

  @override
  String get hangulS1L1Step6Title => '综合测验';

  @override
  String get hangulS1L1Step6Desc => '整理本节课所学内容';

  @override
  String get hangulS1L1Step6Q0 => '\"아\"的元音是什么？';

  @override
  String get hangulS1L1Step6Q1 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step6Q2 => '以下哪个字含有ㅏ？';

  @override
  String get hangulS1L1Step6Q3 => '哪个音与ㅏ最不同？';

  @override
  String get hangulS1L1Step7Title => '课程完成！';

  @override
  String get hangulS1L1Step7Msg => '很好！\n你学会了ㅏ的形状和读音。';

  @override
  String get hangulS1L2Title => 'ㅓ的形状与读音';

  @override
  String get hangulS1L2Subtitle => '竖线左侧短横: ㅓ';

  @override
  String get hangulS1L2Step0Title => '第二个元音ㅓ';

  @override
  String get hangulS1L2Step0Desc => 'ㅓ发出\"어\"的音。\n注意笔画方向与ㅏ相反。';

  @override
  String get hangulS1L2Step0Highlights => 'ㅓ,어,与ㅏ方向相反';

  @override
  String get hangulS1L2Step1Title => '听ㅓ的读音';

  @override
  String get hangulS1L2Step1Desc => '听听含有ㅓ的读音';

  @override
  String get hangulS1L2Step2Title => '发音练习';

  @override
  String get hangulS1L2Step2Desc => '请大声朗读这些文字';

  @override
  String get hangulS1L2Step3Title => '选出ㅓ的读音';

  @override
  String get hangulS1L2Step3Desc => '用耳朵区分ㅏ/ㅓ';

  @override
  String get hangulS1L2Step4Title => '形状测验';

  @override
  String get hangulS1L2Step4Desc => '找出ㅓ';

  @override
  String get hangulS1L2Step4Q0 => '以下哪个是ㅓ？';

  @override
  String get hangulS1L2Step4Q1 => 'ㅇ + ㅓ = ?';

  @override
  String get hangulS1L2Step4Q2 => '以下哪个字含有ㅓ？';

  @override
  String get hangulS1L2Step5Title => '用ㅓ组字';

  @override
  String get hangulS1L2Step5Desc => '将辅音与ㅓ组合';

  @override
  String get hangulS1L2Step6Title => '课程完成！';

  @override
  String get hangulS1L2Step6Msg => '太棒了！\n你学会了ㅓ(어)的读音。';

  @override
  String get hangulS1L3Title => 'ㅗ的形状与读音';

  @override
  String get hangulS1L3Subtitle => '横线上方竖画: ㅗ';

  @override
  String get hangulS1L3Step0Title => '第三个元音ㅗ';

  @override
  String get hangulS1L3Step0Desc => 'ㅗ发出\"오\"的音。\n竖画向横线上方延伸。';

  @override
  String get hangulS1L3Step0Highlights => 'ㅗ,오,横型元音';

  @override
  String get hangulS1L3Step1Title => '听ㅗ的读音';

  @override
  String get hangulS1L3Step1Desc => '听听含有ㅗ的读音（오/고/노）';

  @override
  String get hangulS1L3Step2Title => '发音练习';

  @override
  String get hangulS1L3Step2Desc => '请大声朗读这些文字';

  @override
  String get hangulS1L3Step3Title => '选出ㅗ的读音';

  @override
  String get hangulS1L3Step3Desc => '区分오/우的读音';

  @override
  String get hangulS1L3Step4Title => '用ㅗ组字';

  @override
  String get hangulS1L3Step4Desc => '将辅音与ㅗ组合';

  @override
  String get hangulS1L3Step5Title => '形状与读音测验';

  @override
  String get hangulS1L3Step5Desc => '准确选出ㅗ';

  @override
  String get hangulS1L3Step5Q0 => '以下哪个是ㅗ？';

  @override
  String get hangulS1L3Step5Q1 => 'ㅇ + ㅗ = ?';

  @override
  String get hangulS1L3Step5Q2 => '以下哪个含有ㅗ？';

  @override
  String get hangulS1L3Step6Title => '课程完成！';

  @override
  String get hangulS1L3Step6Msg => '很好！\n你学会了ㅗ(오)的读音。';

  @override
  String get hangulS1L4Title => 'ㅜ的形状与读音';

  @override
  String get hangulS1L4Subtitle => '横线下方竖画: ㅜ';

  @override
  String get hangulS1L4Step0Title => '第四个元音ㅜ';

  @override
  String get hangulS1L4Step0Desc => 'ㅜ发出\"우\"的音。\n竖画位置与ㅗ相反。';

  @override
  String get hangulS1L4Step0Highlights => 'ㅜ,우,与ㅗ位置对比';

  @override
  String get hangulS1L4Step1Title => '听ㅜ的读音';

  @override
  String get hangulS1L4Step1Desc => '听听우/구/누';

  @override
  String get hangulS1L4Step2Title => '发音练习';

  @override
  String get hangulS1L4Step2Desc => '请大声朗读这些文字';

  @override
  String get hangulS1L4Step3Title => '选出ㅜ的读音';

  @override
  String get hangulS1L4Step3Desc => '区分ㅗ/ㅜ';

  @override
  String get hangulS1L4Step4Title => '用ㅜ组字';

  @override
  String get hangulS1L4Step4Desc => '将辅音与ㅜ组合';

  @override
  String get hangulS1L4Step5Title => '形状与读音测验';

  @override
  String get hangulS1L4Step5Desc => '准确选出ㅜ';

  @override
  String get hangulS1L4Step5Q0 => '以下哪个是ㅜ？';

  @override
  String get hangulS1L4Step5Q1 => 'ㅇ + ㅜ = ?';

  @override
  String get hangulS1L4Step5Q2 => '以下哪个含有ㅜ？';

  @override
  String get hangulS1L4Step6Title => '课程完成！';

  @override
  String get hangulS1L4Step6Msg => '很好！\n你学会了ㅜ(우)的读音。';

  @override
  String get hangulS1L5Title => 'ㅡ的形状与读音';

  @override
  String get hangulS1L5Subtitle => '单横线元音: ㅡ';

  @override
  String get hangulS1L5Step0Title => '第五个元音ㅡ';

  @override
  String get hangulS1L5Step0Desc => 'ㅡ是嘴巴横向拉伸发出的音。\n形状是一条横线。';

  @override
  String get hangulS1L5Step0Highlights => 'ㅡ,으,单横线';

  @override
  String get hangulS1L5Step1Title => '听ㅡ的读音';

  @override
  String get hangulS1L5Step1Desc => '听听으/그/느的读音';

  @override
  String get hangulS1L5Step2Title => '发音练习';

  @override
  String get hangulS1L5Step2Desc => '请大声朗读这些文字';

  @override
  String get hangulS1L5Step3Title => '选出ㅡ的读音';

  @override
  String get hangulS1L5Step3Desc => '区分ㅡ和ㅜ的读音';

  @override
  String get hangulS1L5Step4Title => '用ㅡ组字';

  @override
  String get hangulS1L5Step4Desc => '将辅音与ㅡ组合';

  @override
  String get hangulS1L5Step5Title => '形状与读音测验';

  @override
  String get hangulS1L5Step5Desc => '准确选出ㅡ';

  @override
  String get hangulS1L5Step5Q0 => '以下哪个是ㅡ？';

  @override
  String get hangulS1L5Step5Q1 => 'ㅇ + ㅡ = ?';

  @override
  String get hangulS1L5Step5Q2 => '以下哪个含有ㅡ？';

  @override
  String get hangulS1L5Step6Title => '课程完成！';

  @override
  String get hangulS1L5Step6Msg => '很好！\n你学会了ㅡ(으)的读音。';

  @override
  String get hangulS1L6Title => 'ㅣ的形状与读音';

  @override
  String get hangulS1L6Subtitle => '单竖线元音: ㅣ';

  @override
  String get hangulS1L6Step0Title => '第六个元音ㅣ';

  @override
  String get hangulS1L6Step0Desc => 'ㅣ发出\"이\"的音。\n形状是一条竖线。';

  @override
  String get hangulS1L6Step0Highlights => 'ㅣ,이,单竖线';

  @override
  String get hangulS1L6Step1Title => '听ㅣ的读音';

  @override
  String get hangulS1L6Step1Desc => '听听이/기/니的读音';

  @override
  String get hangulS1L6Step2Title => '发音练习';

  @override
  String get hangulS1L6Step2Desc => '请大声朗读这些文字';

  @override
  String get hangulS1L6Step3Title => '选出ㅣ的读音';

  @override
  String get hangulS1L6Step3Desc => '区分ㅣ和ㅡ的读音';

  @override
  String get hangulS1L6Step4Title => '用ㅣ组字';

  @override
  String get hangulS1L6Step4Desc => '将辅音与ㅣ组合';

  @override
  String get hangulS1L6Step5Title => '形状与读音测验';

  @override
  String get hangulS1L6Step5Desc => '准确选出ㅣ';

  @override
  String get hangulS1L6Step5Q0 => '以下哪个是ㅣ？';

  @override
  String get hangulS1L6Step5Q1 => 'ㅇ + ㅣ = ?';

  @override
  String get hangulS1L6Step5Q2 => '以下哪个含有ㅣ？';

  @override
  String get hangulS1L6Step6Title => '课程完成！';

  @override
  String get hangulS1L6Step6Msg => '很好！\n你学会了ㅣ(이)的读音。';

  @override
  String get hangulS1L7Title => '竖向元音区分';

  @override
  String get hangulS1L7Subtitle => '快速区分 ㅏ · ㅓ · ㅣ';

  @override
  String get hangulS1L7Step0Title => '竖向元音组复习';

  @override
  String get hangulS1L7Step0Desc => 'ㅏ、ㅓ、ㅣ 是竖轴元音。\n一起区分笔画位置和发音。';

  @override
  String get hangulS1L7Step0Highlights => 'ㅏ,ㅓ,ㅣ,竖向元音';

  @override
  String get hangulS1L7Step1Title => '再听一遍';

  @override
  String get hangulS1L7Step1Desc => '确认 아/어/이 的发音';

  @override
  String get hangulS1L7Step2Title => '发音练习';

  @override
  String get hangulS1L7Step2Desc => '请大声朗读每个文字';

  @override
  String get hangulS1L7Step3Title => '竖向元音听力测验';

  @override
  String get hangulS1L7Step3Desc => '将声音与正确文字对应';

  @override
  String get hangulS1L7Step4Title => '竖向元音形状测验';

  @override
  String get hangulS1L7Step4Desc => '精确区分各自的形状';

  @override
  String get hangulS1L7Step4Q0 => '右侧有短笔画的是？';

  @override
  String get hangulS1L7Step4Q1 => '左侧有短笔画的是？';

  @override
  String get hangulS1L7Step4Q2 => '单竖线是？';

  @override
  String get hangulS1L7Step4Q3 => 'ㄴ + ㅓ = ?';

  @override
  String get hangulS1L7Step4Q4 => 'ㄱ + ㅣ = ?';

  @override
  String get hangulS1L7Step5Title => '课程完成！';

  @override
  String get hangulS1L7Step5Msg => '很好！\n竖向元音（ㅏ/ㅓ/ㅣ）的区分已经稳固了。';

  @override
  String get hangulS1L8Title => '横向元音区分';

  @override
  String get hangulS1L8Subtitle => '快速区分 ㅗ · ㅜ · ㅡ';

  @override
  String get hangulS1L8Step0Title => '横向元音组复习';

  @override
  String get hangulS1L8Step0Desc => 'ㅗ、ㅜ、ㅡ 是以横轴为中心的元音。\n一起记住竖画位置和嘴型。';

  @override
  String get hangulS1L8Step0Highlights => 'ㅗ,ㅜ,ㅡ,横向元音';

  @override
  String get hangulS1L8Step1Title => '再听一遍';

  @override
  String get hangulS1L8Step1Desc => '确认 오/우/으 的发音';

  @override
  String get hangulS1L8Step2Title => '发音练习';

  @override
  String get hangulS1L8Step2Desc => '请大声朗读每个文字';

  @override
  String get hangulS1L8Step3Title => '横向元音听力测验';

  @override
  String get hangulS1L8Step3Desc => '将声音与正确文字对应';

  @override
  String get hangulS1L8Step4Title => '横向元音形状测验';

  @override
  String get hangulS1L8Step4Desc => '一起检查形状和发音';

  @override
  String get hangulS1L8Step4Q0 => '竖画在横线上方的是？';

  @override
  String get hangulS1L8Step4Q1 => '竖画在横线下方的是？';

  @override
  String get hangulS1L8Step4Q2 => '单横线是？';

  @override
  String get hangulS1L8Step4Q3 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS1L8Step4Q4 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS1L8Step5Title => '课程完成！';

  @override
  String get hangulS1L8Step5Msg => '很好！\n横向元音（ㅗ/ㅜ/ㅡ）的区分已经稳固了。';

  @override
  String get hangulS1L9Title => '基本元音任务';

  @override
  String get hangulS1L9Subtitle => '在时间限制内完成元音组合';

  @override
  String get hangulS1L9Step0Title => '第1阶段最终任务';

  @override
  String get hangulS1L9Step0Desc => '在限定时间内完成文字组合。\n以准确率和速度获得柠檬奖励！';

  @override
  String get hangulS1L9Step1Title => '限时任务';

  @override
  String get hangulS1L9Step2Title => '任务结果';

  @override
  String get hangulS1L9Step3Title => '第1阶段完成！';

  @override
  String get hangulS1L9Step3Msg => '恭喜！\n第1阶段的基本元音全部完成了。';

  @override
  String get hangulS1L10Title => '第一批韩语单词！';

  @override
  String get hangulS1L10Subtitle => '用学过的文字阅读真实单词';

  @override
  String get hangulS1L10Step0Title => '现在可以读单词了！';

  @override
  String get hangulS1L10Step0Desc => '学会了元音和基本辅音，\n来读一读真实的韩语单词吧？';

  @override
  String get hangulS1L10Step0Highlights => '真实单词,阅读挑战';

  @override
  String get hangulS1L10Step1Title => '阅读第一批单词';

  @override
  String get hangulS1L10Step1Descs => '孩子,牛奶,黄瓜,这/牙齿,弟弟';

  @override
  String get hangulS1L10Step2Title => '发音练习';

  @override
  String get hangulS1L10Step2Desc => '请大声朗读每个文字';

  @override
  String get hangulS1L10Step3Title => '听一听，选一选';

  @override
  String get hangulS1L10Step4Title => '太棒了！';

  @override
  String get hangulS1L10Step4Msg => '你读出了韩语单词！\n再学更多辅音，\n就能读更多单词了。';

  @override
  String get hangulS1CompleteTitle => '第1阶段完成！';

  @override
  String get hangulS1CompleteMsg => '你已掌握全部6个基本元音！';

  @override
  String get hangulS2L1Title => 'ㅑ的形状与发音';

  @override
  String get hangulS2L1Subtitle => 'ㅏ加一笔: ㅑ';

  @override
  String get hangulS2L1Step0Title => 'ㅏ变成ㅑ';

  @override
  String get hangulS2L1Step0Desc => '在ㅏ上加一笔就得到ㅑ。\n发音从\"啊\"变成更有弹性的\"呀\"。';

  @override
  String get hangulS2L1Step0Highlights => 'ㅏ → ㅑ,야,Y元音';

  @override
  String get hangulS2L1Step1Title => '听ㅑ的发音';

  @override
  String get hangulS2L1Step1Desc => '听听야/갸/냐的发音';

  @override
  String get hangulS2L1Step2Title => '发音练习';

  @override
  String get hangulS2L1Step2Desc => '大声朗读每个字';

  @override
  String get hangulS2L1Step3Title => '听辨ㅏ vs ㅑ';

  @override
  String get hangulS2L1Step3Desc => '区分相似的发音';

  @override
  String get hangulS2L1Step4Title => '用ㅑ组成音节';

  @override
  String get hangulS2L1Step4Desc => '完成辅音 + ㅑ 的组合';

  @override
  String get hangulS2L1Step5Title => '形状与发音测验';

  @override
  String get hangulS2L1Step5Desc => '准确选出ㅑ';

  @override
  String get hangulS2L1Step5Q0 => '以下哪个是ㅑ？';

  @override
  String get hangulS2L1Step5Q1 => 'ㅇ + ㅑ = ?';

  @override
  String get hangulS2L1Step5Q2 => '以下哪个含有ㅑ？';

  @override
  String get hangulS2L1Step6Title => '课程完成！';

  @override
  String get hangulS2L1Step6Msg => '太棒了！\n你已掌握ㅑ（야）的发音。';

  @override
  String get hangulS2L2Title => 'ㅕ的形状与发音';

  @override
  String get hangulS2L2Subtitle => 'ㅓ加一笔: ㅕ';

  @override
  String get hangulS2L2Step0Title => 'ㅓ变成ㅕ';

  @override
  String get hangulS2L2Step0Desc => '在ㅓ上加一笔就得到ㅕ。\n发音从\"呃\"变成\"耶\"。';

  @override
  String get hangulS2L2Step0Highlights => 'ㅓ → ㅕ,여,Y元音';

  @override
  String get hangulS2L2Step1Title => '听ㅕ的发音';

  @override
  String get hangulS2L2Step1Desc => '听听여/겨/녀的发音';

  @override
  String get hangulS2L2Step2Title => '发音练习';

  @override
  String get hangulS2L2Step2Desc => '大声朗读每个字';

  @override
  String get hangulS2L2Step3Title => '听辨ㅓ vs ㅕ';

  @override
  String get hangulS2L2Step3Desc => '区分어和여';

  @override
  String get hangulS2L2Step4Title => '用ㅕ组成音节';

  @override
  String get hangulS2L2Step4Desc => '完成辅音 + ㅕ 的组合';

  @override
  String get hangulS2L2Step5Title => '课程完成！';

  @override
  String get hangulS2L2Step5Msg => '太棒了！\n你已掌握ㅕ（여）的发音。';

  @override
  String get hangulS2L3Title => 'ㅛ的形状与发音';

  @override
  String get hangulS2L3Subtitle => 'ㅗ加一笔: ㅛ';

  @override
  String get hangulS2L3Step0Title => 'ㅗ变成ㅛ';

  @override
  String get hangulS2L3Step0Desc => '在ㅗ上加一笔就得到ㅛ。\n发音从\"哦\"变成\"哟\"。';

  @override
  String get hangulS2L3Step0Highlights => 'ㅗ → ㅛ,요,Y元音';

  @override
  String get hangulS2L3Step1Title => '听ㅛ的发音';

  @override
  String get hangulS2L3Step1Desc => '听听요/교/뇨的发音';

  @override
  String get hangulS2L3Step2Title => '发音练习';

  @override
  String get hangulS2L3Step2Desc => '大声朗读每个字';

  @override
  String get hangulS2L3Step3Title => '听辨ㅗ vs ㅛ';

  @override
  String get hangulS2L3Step3Desc => '区分오和요';

  @override
  String get hangulS2L3Step4Title => '用ㅛ组成音节';

  @override
  String get hangulS2L3Step4Desc => '完成辅音 + ㅛ 的组合';

  @override
  String get hangulS2L3Step5Title => '课程完成！';

  @override
  String get hangulS2L3Step5Msg => '太棒了！\n你已掌握ㅛ（요）的发音。';

  @override
  String get hangulS2L4Title => 'ㅠ的形状与发音';

  @override
  String get hangulS2L4Subtitle => 'ㅜ加一笔: ㅠ';

  @override
  String get hangulS2L4Step0Title => 'ㅜ变成ㅠ';

  @override
  String get hangulS2L4Step0Desc => '在ㅜ上加一笔就得到ㅠ。\n发音从\"呜\"变成\"鱼\"。';

  @override
  String get hangulS2L4Step0Highlights => 'ㅜ → ㅠ,유,Y元音';

  @override
  String get hangulS2L4Step1Title => '听ㅠ的发音';

  @override
  String get hangulS2L4Step1Desc => '听听유/규/뉴的发音';

  @override
  String get hangulS2L4Step2Title => '发音练习';

  @override
  String get hangulS2L4Step2Desc => '大声朗读每个字';

  @override
  String get hangulS2L4Step3Title => '听辨ㅜ vs ㅠ';

  @override
  String get hangulS2L4Step3Desc => '区分우和유';

  @override
  String get hangulS2L4Step4Title => '用ㅠ组成音节';

  @override
  String get hangulS2L4Step4Desc => '完成辅音 + ㅠ 的组合';

  @override
  String get hangulS2L4Step5Title => '课程完成！';

  @override
  String get hangulS2L4Step5Msg => '太棒了！\n你已掌握ㅠ（유）的发音。';

  @override
  String get hangulS2L5Title => 'Y元音组合训练';

  @override
  String get hangulS2L5Subtitle => 'ㅑ · ㅕ · ㅛ · ㅠ 强化训练';

  @override
  String get hangulS2L5Step0Title => '一次看清所有Y元音';

  @override
  String get hangulS2L5Step0Desc => 'ㅑ/ㅕ/ㅛ/ㅠ是基础元音加一笔的元音。\n快速区分它们的形状和发音。';

  @override
  String get hangulS2L5Step0Highlights => 'ㅑ,ㅕ,ㅛ,ㅠ';

  @override
  String get hangulS2L5Step1Title => '再听四个发音';

  @override
  String get hangulS2L5Step1Desc => '复习야/여/요/유的发音';

  @override
  String get hangulS2L5Step2Title => '发音练习';

  @override
  String get hangulS2L5Step2Desc => '大声朗读每个字';

  @override
  String get hangulS2L5Step3Title => '发音辨别测验';

  @override
  String get hangulS2L5Step3Desc => '区分Y元音的发音';

  @override
  String get hangulS2L5Step4Title => '形状辨别测验';

  @override
  String get hangulS2L5Step4Desc => '准确区分形状';

  @override
  String get hangulS2L5Step4Q0 => '以下哪个是ㅑ？';

  @override
  String get hangulS2L5Step4Q1 => '以下哪个是ㅕ？';

  @override
  String get hangulS2L5Step4Q2 => '以下哪个是ㅛ？';

  @override
  String get hangulS2L5Step4Q3 => '以下哪个是ㅠ？';

  @override
  String get hangulS2L5Step5Title => '课程完成！';

  @override
  String get hangulS2L5Step5Msg => '太棒了！\n你对4个Y元音的区分越来越好了。';

  @override
  String get hangulS2L6Title => '基础元音 vs Y元音对比';

  @override
  String get hangulS2L6Subtitle => 'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ';

  @override
  String get hangulS2L6Step0Title => '整理容易混淆的配对';

  @override
  String get hangulS2L6Step0Desc => '将基础元音和Y元音配对比较。';

  @override
  String get hangulS2L6Step0Highlights => 'ㅏ/ㅑ,ㅓ/ㅕ,ㅗ/ㅛ,ㅜ/ㅠ';

  @override
  String get hangulS2L6Step1Title => '配对发音辨别';

  @override
  String get hangulS2L6Step1Desc => '从相似的发音中选出正确答案';

  @override
  String get hangulS2L6Step2Title => '配对形状辨别';

  @override
  String get hangulS2L6Step2Desc => '判断是否有额外的一笔';

  @override
  String get hangulS2L6Step2Q0 => '哪个元音加了一笔？';

  @override
  String get hangulS2L6Step2Q1 => '哪个元音加了一笔？';

  @override
  String get hangulS2L6Step2Q2 => '哪个元音加了一笔？';

  @override
  String get hangulS2L6Step2Q3 => '哪个元音加了一笔？';

  @override
  String get hangulS2L6Step2Q4 => 'ㅇ + ㅠ = ?';

  @override
  String get hangulS2L6Step3Title => '课程完成！';

  @override
  String get hangulS2L6Step3Msg => '太棒了！\n基础元音/Y元音对比已经稳定了。';

  @override
  String get hangulS2L7Title => 'Y元音任务';

  @override
  String get hangulS2L7Subtitle => '在限时内完成Y元音组合';

  @override
  String get hangulS2L7Step0Title => '第2阶段最终任务';

  @override
  String get hangulS2L7Step0Desc => '快速准确地完成Y元音组合。\n完成数和时间决定你的柠檬奖励。';

  @override
  String get hangulS2L7Step1Title => '限时任务';

  @override
  String get hangulS2L7Step2Title => '任务结果';

  @override
  String get hangulS2L7Step3Title => '第2阶段完成！';

  @override
  String get hangulS2L7Step3Msg => '恭喜！\n你已完成第2阶段所有Y元音。';

  @override
  String get hangulS2CompleteTitle => '第2阶段完成！';

  @override
  String get hangulS2CompleteMsg => '你已征服Y元音！';

  @override
  String get hangulS3L1Title => 'ㅐ的形状和发音';

  @override
  String get hangulS3L1Subtitle => '感受ㅏ + ㅣ的组合感觉';

  @override
  String get hangulS3L1Step0Title => 'ㅐ是这个样子';

  @override
  String get hangulS3L1Step0Desc => 'ㅐ是从ㅏ系列派生的元音。\n以\"애\"为代表音来记忆。';

  @override
  String get hangulS3L1Step0Highlights => 'ㅐ,애,形状识别';

  @override
  String get hangulS3L1Step1Title => '听ㅐ的发音';

  @override
  String get hangulS3L1Step1Desc => '听听애/개/내的发音';

  @override
  String get hangulS3L1Step2Title => '发音练习';

  @override
  String get hangulS3L1Step2Desc => '请直接把文字发出声来';

  @override
  String get hangulS3L1Step3Title => '听辨ㅏ vs ㅐ';

  @override
  String get hangulS3L1Step3Desc => '区分아/애';

  @override
  String get hangulS3L1Step4Title => '课程完成！';

  @override
  String get hangulS3L1Step4Msg => '很好！\n已掌握ㅐ(애)的形状和发音。';

  @override
  String get hangulS3L2Title => 'ㅔ的形状和发音';

  @override
  String get hangulS3L2Subtitle => '感受ㅓ + ㅣ的组合感觉';

  @override
  String get hangulS3L2Step0Title => 'ㅔ是这个样子';

  @override
  String get hangulS3L2Step0Desc => 'ㅔ是从ㅓ系列派生的元音。\n以\"에\"为代表音来记忆。';

  @override
  String get hangulS3L2Step0Highlights => 'ㅔ,에,形状识别';

  @override
  String get hangulS3L2Step1Title => '听ㅔ的发音';

  @override
  String get hangulS3L2Step1Desc => '听听에/게/네的发音';

  @override
  String get hangulS3L2Step2Title => '发音练习';

  @override
  String get hangulS3L2Step2Desc => '请直接把文字发出声来';

  @override
  String get hangulS3L2Step3Title => '听辨ㅓ vs ㅔ';

  @override
  String get hangulS3L2Step3Desc => '区分어/에';

  @override
  String get hangulS3L2Step4Title => '课程完成！';

  @override
  String get hangulS3L2Step4Msg => '很好！\n已掌握ㅔ(에)的形状和发音。';

  @override
  String get hangulS3L3Title => '区分ㅐ vs ㅔ';

  @override
  String get hangulS3L3Subtitle => '以形状为中心的区分训练';

  @override
  String get hangulS3L3Step0Title => '关键在于区分形状';

  @override
  String get hangulS3L3Step0Desc => '在初级阶段，ㅐ/ㅔ听起来可能很相似。\n所以先准确区分它们的形状。';

  @override
  String get hangulS3L3Step0Highlights => 'ㅐ,ㅔ,形状区分';

  @override
  String get hangulS3L3Step1Title => '形状区分测验';

  @override
  String get hangulS3L3Step1Desc => '准确选择ㅐ和ㅔ';

  @override
  String get hangulS3L3Step1Q0 => '下列哪个是ㅐ？';

  @override
  String get hangulS3L3Step1Q1 => '下列哪个是ㅔ？';

  @override
  String get hangulS3L3Step1Q2 => 'ㅇ + ㅐ = ?';

  @override
  String get hangulS3L3Step1Q3 => 'ㅇ + ㅔ = ?';

  @override
  String get hangulS3L3Step2Title => '课程完成！';

  @override
  String get hangulS3L3Step2Msg => '很好！\nㅐ/ㅔ的区分更准确了。';

  @override
  String get hangulS3L4Title => 'ㅒ的形状和发音';

  @override
  String get hangulS3L4Subtitle => 'Y-ㅐ系列元音';

  @override
  String get hangulS3L4Step0Title => '来学ㅒ吧';

  @override
  String get hangulS3L4Step0Desc => 'ㅒ是ㅐ系列的Y元音。\n代表音是\"얘\"。';

  @override
  String get hangulS3L4Step0Highlights => 'ㅒ,얘';

  @override
  String get hangulS3L4Step1Title => '听ㅒ的发音';

  @override
  String get hangulS3L4Step1Desc => '听听얘/걔/냬的发音';

  @override
  String get hangulS3L4Step2Title => '发音练习';

  @override
  String get hangulS3L4Step2Desc => '请直接把文字发出声来';

  @override
  String get hangulS3L4Step3Title => '课程完成！';

  @override
  String get hangulS3L4Step3Msg => '很好！\n已掌握ㅒ(얘)的形状。';

  @override
  String get hangulS3L5Title => 'ㅖ的形状和发音';

  @override
  String get hangulS3L5Subtitle => 'Y-ㅔ系列元音';

  @override
  String get hangulS3L5Step0Title => '来学ㅖ吧';

  @override
  String get hangulS3L5Step0Desc => 'ㅖ是ㅔ系列的Y元音。\n代表音是\"예\"。';

  @override
  String get hangulS3L5Step0Highlights => 'ㅖ,예';

  @override
  String get hangulS3L5Step1Title => '听ㅖ的发音';

  @override
  String get hangulS3L5Step1Desc => '听听예/계/녜的发音';

  @override
  String get hangulS3L5Step2Title => '发音练习';

  @override
  String get hangulS3L5Step2Desc => '请直接把文字发出声来';

  @override
  String get hangulS3L5Step3Title => '课程完成！';

  @override
  String get hangulS3L5Step3Msg => '很好！\n已掌握ㅖ(예)的形状。';

  @override
  String get hangulS3L6Title => 'ㅐ/ㅔ系列综合复习';

  @override
  String get hangulS3L6Subtitle => 'ㅐ ㅔ ㅒ ㅖ综合检验';

  @override
  String get hangulS3L6Step0Title => '一次性区分四种';

  @override
  String get hangulS3L6Step0Desc => '同时用形状和发音来检验ㅐ/ㅔ/ㅒ/ㅖ。';

  @override
  String get hangulS3L6Step0Highlights => 'ㅐ,ㅔ,ㅒ,ㅖ';

  @override
  String get hangulS3L6Step1Title => '声音区分';

  @override
  String get hangulS3L6Step1Desc => '从相似的声音中选出正确答案';

  @override
  String get hangulS3L6Step2Title => '形状区分';

  @override
  String get hangulS3L6Step2Desc => '看形状，快速选择';

  @override
  String get hangulS3L6Step2Q0 => '下列哪个属于Y-ㅐ系列？';

  @override
  String get hangulS3L6Step2Q1 => '下列哪个属于Y-ㅔ系列？';

  @override
  String get hangulS3L6Step2Q2 => 'ㅇ + ㅖ = ?';

  @override
  String get hangulS3L6Step3Title => '课程完成！';

  @override
  String get hangulS3L6Step3Msg => '很好！\n第3阶段核心元音的区分已经稳固了。';

  @override
  String get hangulS3L7Title => '第3阶段任务';

  @override
  String get hangulS3L7Subtitle => '快速区分任务：ㅐ/ㅔ系列';

  @override
  String get hangulS3L7Step0Title => '第3阶段最终任务';

  @override
  String get hangulS3L7Step0Desc => '快速准确地完成ㅐ/ㅔ系列的组合。';

  @override
  String get hangulS3L7Step1Title => '限时任务';

  @override
  String get hangulS3L7Step2Title => '任务结果';

  @override
  String get hangulS3L7Step3Title => '第3阶段完成！';

  @override
  String get hangulS3L7Step3Msg => '恭喜！\n已完成第3阶段全部ㅐ/ㅔ系列元音。';

  @override
  String get hangulS3L7Step4Title => '第3阶段完成！';

  @override
  String get hangulS3L7Step4Msg => '已学完所有元音！';

  @override
  String get hangulS3CompleteTitle => '第3阶段完成！';

  @override
  String get hangulS3CompleteMsg => '已学完所有元音！';

  @override
  String get hangulS4L1Title => 'ㄱ的形状与发音';

  @override
  String get hangulS4L1Subtitle => '基本辅音的开始：ㄱ';

  @override
  String get hangulS4L1Step0Title => '来学ㄱ吧';

  @override
  String get hangulS4L1Step0Desc => 'ㄱ是基本辅音的开始。\n与ㅏ组合发出「가」的音。';

  @override
  String get hangulS4L1Step0Highlights => 'ㄱ,가,基本辅音';

  @override
  String get hangulS4L1Step1Title => '听ㄱ的发音';

  @override
  String get hangulS4L1Step1Desc => '听听가/고/구的发音';

  @override
  String get hangulS4L1Step2Title => '发音练习';

  @override
  String get hangulS4L1Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L1Step3Title => '选出ㄱ的发音';

  @override
  String get hangulS4L1Step3Desc => '听音选出正确的字';

  @override
  String get hangulS4L1Step4Title => '用ㄱ组合文字';

  @override
  String get hangulS4L1Step4Desc => '尝试ㄱ＋元音的组合';

  @override
  String get hangulS4L1SummaryTitle => '课程完成！';

  @override
  String get hangulS4L1SummaryMsg => '很棒！\n你已经掌握了ㄱ的发音和形状。';

  @override
  String get hangulS4L2Title => 'ㄴ的形状与发音';

  @override
  String get hangulS4L2Subtitle => '第二个基本辅音：ㄴ';

  @override
  String get hangulS4L2Step0Title => '来学ㄴ吧';

  @override
  String get hangulS4L2Step0Desc => 'ㄴ构成「나」系列发音。';

  @override
  String get hangulS4L2Step0Highlights => 'ㄴ,나';

  @override
  String get hangulS4L2Step1Title => '听ㄴ的发音';

  @override
  String get hangulS4L2Step1Desc => '听听나/노/누的发音';

  @override
  String get hangulS4L2Step2Title => '发音练习';

  @override
  String get hangulS4L2Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L2Step3Title => '选出ㄴ的发音';

  @override
  String get hangulS4L2Step3Desc => '区分나/다';

  @override
  String get hangulS4L2Step4Title => '用ㄴ组合文字';

  @override
  String get hangulS4L2Step4Desc => '尝试ㄴ＋元音的组合';

  @override
  String get hangulS4L2SummaryTitle => '课程完成！';

  @override
  String get hangulS4L2SummaryMsg => '很棒！\n你已经掌握了ㄴ的发音和形状。';

  @override
  String get hangulS4L3Title => 'ㄷ的形状与发音';

  @override
  String get hangulS4L3Subtitle => '第三个基本辅音：ㄷ';

  @override
  String get hangulS4L3Step0Title => '来学ㄷ吧';

  @override
  String get hangulS4L3Step0Desc => 'ㄷ构成「다」系列发音。';

  @override
  String get hangulS4L3Step0Highlights => 'ㄷ,다';

  @override
  String get hangulS4L3Step1Title => '听ㄷ的发音';

  @override
  String get hangulS4L3Step1Desc => '听听다/도/두的发音';

  @override
  String get hangulS4L3Step2Title => '发音练习';

  @override
  String get hangulS4L3Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L3Step3Title => '选出ㄷ的发音';

  @override
  String get hangulS4L3Step3Desc => '区分다/나';

  @override
  String get hangulS4L3Step4Title => '用ㄷ组合文字';

  @override
  String get hangulS4L3Step4Desc => '尝试ㄷ＋元音的组合';

  @override
  String get hangulS4L3SummaryTitle => '课程完成！';

  @override
  String get hangulS4L3SummaryMsg => '很棒！\n你已经掌握了ㄷ的发音和形状。';

  @override
  String get hangulS4L4Title => 'ㄹ的形状与发音';

  @override
  String get hangulS4L4Subtitle => '第四个基本辅音：ㄹ';

  @override
  String get hangulS4L4Step0Title => '来学ㄹ吧';

  @override
  String get hangulS4L4Step0Desc => 'ㄹ构成「라」系列发音。';

  @override
  String get hangulS4L4Step0Highlights => 'ㄹ,라';

  @override
  String get hangulS4L4Step1Title => '听ㄹ的发音';

  @override
  String get hangulS4L4Step1Desc => '听听라/로/루的发音';

  @override
  String get hangulS4L4Step2Title => '发音练习';

  @override
  String get hangulS4L4Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L4Step3Title => '选出ㄹ的发音';

  @override
  String get hangulS4L4Step3Desc => '区分라/나';

  @override
  String get hangulS4L4Step4Title => '用ㄹ组合文字';

  @override
  String get hangulS4L4Step4Desc => '尝试ㄹ＋元音的组合';

  @override
  String get hangulS4L4SummaryTitle => '课程完成！';

  @override
  String get hangulS4L4SummaryMsg => '很棒！\n你已经掌握了ㄹ的发音和形状。';

  @override
  String get hangulS4L5Title => 'ㅁ的形状与发音';

  @override
  String get hangulS4L5Subtitle => '第五个基本辅音：ㅁ';

  @override
  String get hangulS4L5Step0Title => '来学ㅁ吧';

  @override
  String get hangulS4L5Step0Desc => 'ㅁ构成「마」系列发音。';

  @override
  String get hangulS4L5Step0Highlights => 'ㅁ,마';

  @override
  String get hangulS4L5Step1Title => '听ㅁ的发音';

  @override
  String get hangulS4L5Step1Desc => '听听마/모/무的发音';

  @override
  String get hangulS4L5Step2Title => '发音练习';

  @override
  String get hangulS4L5Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L5Step3Title => '选出ㅁ的发音';

  @override
  String get hangulS4L5Step3Desc => '区分마/바';

  @override
  String get hangulS4L5Step4Title => '用ㅁ组合文字';

  @override
  String get hangulS4L5Step4Desc => '尝试ㅁ＋元音的组合';

  @override
  String get hangulS4L5SummaryTitle => '课程完成！';

  @override
  String get hangulS4L5SummaryMsg => '很棒！\n你已经掌握了ㅁ的发音和形状。';

  @override
  String get hangulS4L6Title => 'ㅂ的形状与发音';

  @override
  String get hangulS4L6Subtitle => '第六个基本辅音：ㅂ';

  @override
  String get hangulS4L6Step0Title => '来学ㅂ吧';

  @override
  String get hangulS4L6Step0Desc => 'ㅂ构成「바」系列发音。';

  @override
  String get hangulS4L6Step0Highlights => 'ㅂ,바';

  @override
  String get hangulS4L6Step1Title => '听ㅂ的发音';

  @override
  String get hangulS4L6Step1Desc => '听听바/보/부的发音';

  @override
  String get hangulS4L6Step2Title => '发音练习';

  @override
  String get hangulS4L6Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L6Step3Title => '选出ㅂ的发音';

  @override
  String get hangulS4L6Step3Desc => '区分바/마';

  @override
  String get hangulS4L6Step4Title => '用ㅂ组合文字';

  @override
  String get hangulS4L6Step4Desc => '尝试ㅂ＋元音的组合';

  @override
  String get hangulS4L6SummaryTitle => '课程完成！';

  @override
  String get hangulS4L6SummaryMsg => '很棒！\n你已经掌握了ㅂ的发音和形状。';

  @override
  String get hangulS4L7Title => 'ㅅ的形状与发音';

  @override
  String get hangulS4L7Subtitle => '第七个基本辅音：ㅅ';

  @override
  String get hangulS4L7Step0Title => '来学ㅅ吧';

  @override
  String get hangulS4L7Step0Desc => 'ㅅ构成「사」系列发音。';

  @override
  String get hangulS4L7Step0Highlights => 'ㅅ,사';

  @override
  String get hangulS4L7Step1Title => '听ㅅ的发音';

  @override
  String get hangulS4L7Step1Desc => '听听사/소/수的发音';

  @override
  String get hangulS4L7Step2Title => '发音练习';

  @override
  String get hangulS4L7Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L7Step3Title => '选出ㅅ的发音';

  @override
  String get hangulS4L7Step3Desc => '区分사/자';

  @override
  String get hangulS4L7Step4Title => '用ㅅ组合文字';

  @override
  String get hangulS4L7Step4Desc => '尝试ㅅ＋元音的组合';

  @override
  String get hangulS4L7SummaryTitle => '第4阶段完成！';

  @override
  String get hangulS4L7SummaryMsg => '恭喜！\n你完成了第4阶段基本辅音1（ㄱ~ㅅ）。';

  @override
  String get hangulS4L8Title => '单词阅读挑战！';

  @override
  String get hangulS4L8Subtitle => '用辅音和元音读单词';

  @override
  String get hangulS4L8Step0Title => '现在你能读更多单词了！';

  @override
  String get hangulS4L8Step0Desc => '你已经学完了全部7个基本辅音和元音。\n来读读由这些字组成的真实单词吧？';

  @override
  String get hangulS4L8Step0Highlights => '7个辅音,元音,真实单词';

  @override
  String get hangulS4L8Step1Title => '读单词';

  @override
  String get hangulS4L8Step1Descs => '树,海,蝴蝶,帽子,家具,豆腐';

  @override
  String get hangulS4L8Step2Title => '发音练习';

  @override
  String get hangulS4L8Step2Desc => '试着大声读出这些字';

  @override
  String get hangulS4L8Step3Title => '听后选出';

  @override
  String get hangulS4L8Step4Title => '是什么意思？';

  @override
  String get hangulS4L8Step4Q0 => '\"나비\"的中文是？';

  @override
  String get hangulS4L8Step4Q1 => '\"바다\"的中文是？';

  @override
  String get hangulS4L8SummaryTitle => '太棒了！';

  @override
  String get hangulS4L8SummaryMsg => '你读了6个韩文单词！\n继续学习更多辅音，就能读出更多单词。';

  @override
  String get hangulS4LMTitle => '任务：基本辅音组合！';

  @override
  String get hangulS4LMSubtitle => '在时间限制内组合音节';

  @override
  String get hangulS4LMStep0Title => '任务开始！';

  @override
  String get hangulS4LMStep0Desc => '将基本辅音ㄱ~ㅅ与元音组合。\n在限定时间内达成目标！';

  @override
  String get hangulS4LMStep1Title => '来组合音节吧！';

  @override
  String get hangulS4LMStep2Title => '任务结果';

  @override
  String get hangulS4LMSummaryTitle => '任务完成！';

  @override
  String get hangulS4LMSummaryMsg => '你可以自由组合全部7个基本辅音了！';

  @override
  String get hangulS4CompleteTitle => '第4阶段完成！';

  @override
  String get hangulS4CompleteMsg => '你已掌握全部7个基本辅音！';

  @override
  String get hangulS5L1Title => '理解ㅇ的位置';

  @override
  String get hangulS5L1Subtitle => '学习初声ㅇ的读法';

  @override
  String get hangulS5L1Step0Title => 'ㅇ是特殊辅音';

  @override
  String get hangulS5L1Step0Desc => '初声ㅇ几乎没有声音，\n与元音结合后读作아/오/우。';

  @override
  String get hangulS5L1Step0Highlights => 'ㅇ,아,初声位置';

  @override
  String get hangulS5L1Step1Title => '聆听ㅇ的组合音';

  @override
  String get hangulS5L1Step1Desc => '听一听아/오/우的发音';

  @override
  String get hangulS5L1Step2Title => '发音练习';

  @override
  String get hangulS5L1Step2Desc => '大声朗读每个文字';

  @override
  String get hangulS5L1Step3Title => '用ㅇ组字';

  @override
  String get hangulS5L1Step3Desc => '组合ㅇ + 元音';

  @override
  String get hangulS5L1Step4Title => '课程完成！';

  @override
  String get hangulS5L1Step4Msg => '太棒了！\n你已经理解了ㅇ的用法。';

  @override
  String get hangulS5L2Title => 'ㅈ的形状与发音';

  @override
  String get hangulS5L2Subtitle => 'ㅈ的基础读法';

  @override
  String get hangulS5L2Step0Title => '学习ㅈ';

  @override
  String get hangulS5L2Step0Desc => 'ㅈ产生「자」系列的音。';

  @override
  String get hangulS5L2Step0Highlights => 'ㅈ,자';

  @override
  String get hangulS5L2Step1Title => '聆听ㅈ的发音';

  @override
  String get hangulS5L2Step1Desc => '听一听자/조/주';

  @override
  String get hangulS5L2Step2Title => '发音练习';

  @override
  String get hangulS5L2Step2Desc => '大声朗读每个文字';

  @override
  String get hangulS5L2Step3Title => '选出ㅈ的音';

  @override
  String get hangulS5L2Step3Desc => '区分자和사';

  @override
  String get hangulS5L2Step4Title => '用ㅈ组字';

  @override
  String get hangulS5L2Step4Desc => '组合ㅈ + 元音';

  @override
  String get hangulS5L2Step5Title => '课程完成！';

  @override
  String get hangulS5L2Step5Msg => '太棒了！\n你已经学会了ㅈ的发音和形状。';

  @override
  String get hangulS5L3Title => 'ㅊ的形状与发音';

  @override
  String get hangulS5L3Subtitle => 'ㅊ的基础读法';

  @override
  String get hangulS5L3Step0Title => '学习ㅊ';

  @override
  String get hangulS5L3Step0Desc => 'ㅊ产生「차」系列的音。';

  @override
  String get hangulS5L3Step0Highlights => 'ㅊ,차';

  @override
  String get hangulS5L3Step1Title => '聆听ㅊ的发音';

  @override
  String get hangulS5L3Step1Desc => '听一听차/초/추';

  @override
  String get hangulS5L3Step2Title => '发音练习';

  @override
  String get hangulS5L3Step2Desc => '大声朗读每个文字';

  @override
  String get hangulS5L3Step3Title => '选出ㅊ的音';

  @override
  String get hangulS5L3Step3Desc => '区分차和자';

  @override
  String get hangulS5L3Step4Title => '课程完成！';

  @override
  String get hangulS5L3Step4Msg => '太棒了！\n你已经学会了ㅊ的发音和形状。';

  @override
  String get hangulS5L4Title => 'ㅋ的形状与发音';

  @override
  String get hangulS5L4Subtitle => 'ㅋ的基础读法';

  @override
  String get hangulS5L4Step0Title => '学习ㅋ';

  @override
  String get hangulS5L4Step0Desc => 'ㅋ产生「카」系列的音。';

  @override
  String get hangulS5L4Step0Highlights => 'ㅋ,카';

  @override
  String get hangulS5L4Step1Title => '聆听ㅋ的发音';

  @override
  String get hangulS5L4Step1Desc => '听一听카/코/쿠';

  @override
  String get hangulS5L4Step2Title => '发音练习';

  @override
  String get hangulS5L4Step2Desc => '大声朗读每个文字';

  @override
  String get hangulS5L4Step3Title => '选出ㅋ的音';

  @override
  String get hangulS5L4Step3Desc => '区分카和가';

  @override
  String get hangulS5L4Step4Title => '课程完成！';

  @override
  String get hangulS5L4Step4Msg => '太棒了！\n你已经学会了ㅋ的发音和形状。';

  @override
  String get hangulS5L5Title => 'ㅌ的形状与发音';

  @override
  String get hangulS5L5Subtitle => 'ㅌ的基础读法';

  @override
  String get hangulS5L5Step0Title => '学习ㅌ';

  @override
  String get hangulS5L5Step0Desc => 'ㅌ产生「타」系列的音。';

  @override
  String get hangulS5L5Step0Highlights => 'ㅌ,타';

  @override
  String get hangulS5L5Step1Title => '聆听ㅌ的发音';

  @override
  String get hangulS5L5Step1Desc => '听一听타/토/투';

  @override
  String get hangulS5L5Step2Title => '发音练习';

  @override
  String get hangulS5L5Step2Desc => '大声朗读每个文字';

  @override
  String get hangulS5L5Step3Title => '选出ㅌ的音';

  @override
  String get hangulS5L5Step3Desc => '区分타和다';

  @override
  String get hangulS5L5Step4Title => '课程完成！';

  @override
  String get hangulS5L5Step4Msg => '太棒了！\n你已经学会了ㅌ的发音和形状。';

  @override
  String get hangulS5L6Title => 'ㅍ的形状与发音';

  @override
  String get hangulS5L6Subtitle => 'ㅍ的基础读法';

  @override
  String get hangulS5L6Step0Title => '学习ㅍ';

  @override
  String get hangulS5L6Step0Desc => 'ㅍ产生「파」系列的音。';

  @override
  String get hangulS5L6Step0Highlights => 'ㅍ,파';

  @override
  String get hangulS5L6Step1Title => '聆听ㅍ的发音';

  @override
  String get hangulS5L6Step1Desc => '听一听파/포/푸';

  @override
  String get hangulS5L6Step2Title => '发音练习';

  @override
  String get hangulS5L6Step2Desc => '大声朗读每个文字';

  @override
  String get hangulS5L6Step3Title => '选出ㅍ的音';

  @override
  String get hangulS5L6Step3Desc => '区分파和바';

  @override
  String get hangulS5L6Step4Title => '课程完成！';

  @override
  String get hangulS5L6Step4Msg => '太棒了！\n你已经学会了ㅍ的发音和形状。';

  @override
  String get hangulS5L7Title => 'ㅎ的形状与发音';

  @override
  String get hangulS5L7Subtitle => 'ㅎ的基础读法';

  @override
  String get hangulS5L7Step0Title => '学习ㅎ';

  @override
  String get hangulS5L7Step0Desc => 'ㅎ产生「하」系列的音。';

  @override
  String get hangulS5L7Step0Highlights => 'ㅎ,하';

  @override
  String get hangulS5L7Step1Title => '聆听ㅎ的发音';

  @override
  String get hangulS5L7Step1Desc => '听一听하/호/후';

  @override
  String get hangulS5L7Step2Title => '发音练习';

  @override
  String get hangulS5L7Step2Desc => '大声朗读每个文字';

  @override
  String get hangulS5L7Step3Title => '选出ㅎ的音';

  @override
  String get hangulS5L7Step3Desc => '区分하和아';

  @override
  String get hangulS5L7Step4Title => '课程完成！';

  @override
  String get hangulS5L7Step4Msg => '太棒了！\n你已经学会了ㅎ的发音和形状。';

  @override
  String get hangulS5L8Title => '额外辅音随机朗读';

  @override
  String get hangulS5L8Subtitle => '混合复习ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS5L8Step0Title => '随机复习';

  @override
  String get hangulS5L8Step0Desc => '把7个额外辅音混在一起读一读吧。';

  @override
  String get hangulS5L8Step0Highlights => 'ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ';

  @override
  String get hangulS5L8Step1Title => '形状/发音测验';

  @override
  String get hangulS5L8Step1Desc => '将发音与文字对应起来';

  @override
  String get hangulS5L8Step2Title => '课程完成！';

  @override
  String get hangulS5L8Step2Msg => '太棒了！\n你随机复习了7个额外辅音。';

  @override
  String get hangulS5L9Title => '易混淆对的预习';

  @override
  String get hangulS5L9Subtitle => '为下一阶段做准备的区分练习';

  @override
  String get hangulS5L9Step0Title => '先看看容易混淆的对';

  @override
  String get hangulS5L9Step0Desc => '提前练习区分ㅈ/ㅊ、ㄱ/ㅋ、ㄷ/ㅌ、ㅂ/ㅍ。';

  @override
  String get hangulS5L9Step0Highlights => 'ㅈ/ㅊ,ㄱ/ㅋ,ㄷ/ㅌ,ㅂ/ㅍ';

  @override
  String get hangulS5L9Step1Title => '对比听音';

  @override
  String get hangulS5L9Step1Desc => '从两个选项中选出正确的音';

  @override
  String get hangulS5L9Step2Title => '课程完成！';

  @override
  String get hangulS5L9Step2Msg => '太棒了！\n你已经为下一阶段做好准备了。';

  @override
  String get hangulS5LMTitle => '第5阶段任务';

  @override
  String get hangulS5LMSubtitle => '基本辅音2 综合任务';

  @override
  String get hangulS5LMStep0Title => '任务开始！';

  @override
  String get hangulS5LMStep0Desc => '将基本辅音2（ㅇ~ㅎ）与元音组合。\n在限定时间内达成目标！';

  @override
  String get hangulS5LMStep1Title => '组合音节！';

  @override
  String get hangulS5LMStep2Title => '任务结果';

  @override
  String get hangulS5LMStep3Title => '第5阶段完成！';

  @override
  String get hangulS5LMStep3Msg => '恭喜！\n你完成了第5阶段：基本辅音2（ㅇ~ㅎ）。';

  @override
  String get hangulS5LMStep4Title => '第5阶段完成！';

  @override
  String get hangulS5LMStep4Msg => '你已经掌握了所有基本辅音！';

  @override
  String get hangulS5CompleteTitle => '第5阶段完成！';

  @override
  String get hangulS5CompleteMsg => '你已经掌握了所有基本辅音！';

  @override
  String get hangulS6L1Title => '가~기 模式阅读';

  @override
  String get hangulS6L1Subtitle => 'ㄱ + 基本元音模式';

  @override
  String get hangulS6L1Step0Title => '开始用模式阅读';

  @override
  String get hangulS6L1Step0Desc => '试着改变与ㄱ组合的元音\n你会找到阅读的节奏。';

  @override
  String get hangulS6L1Step0Highlights => '가,거,고,구,그,기';

  @override
  String get hangulS6L1Step1Title => '聆听模式发音';

  @override
  String get hangulS6L1Step1Desc => '按顺序听一听 가/거/고/구/그/기';

  @override
  String get hangulS6L1Step2Title => '发音练习';

  @override
  String get hangulS6L1Step2Desc => '请大声读出每个音节';

  @override
  String get hangulS6L1Step3Title => '模式测验';

  @override
  String get hangulS6L1Step3Desc => '配对相同的辅音模式';

  @override
  String get hangulS6L1Step3Q0 => 'ㄱ + ㅏ = ?';

  @override
  String get hangulS6L1Step3Q1 => 'ㄱ + ㅓ = ?';

  @override
  String get hangulS6L1Step3Q2 => 'ㄱ + ㅡ = ?';

  @override
  String get hangulS6L1Step4Title => '课程完成！';

  @override
  String get hangulS6L1Step4Msg => '很好！\n你已经开始学习 가~기 模式了。';

  @override
  String get hangulS6L2Title => '扩展 나~니';

  @override
  String get hangulS6L2Subtitle => 'ㄴ 模式阅读';

  @override
  String get hangulS6L2Step0Title => '扩展 ㄴ 模式';

  @override
  String get hangulS6L2Step0Desc => '改变与ㄴ组合的元音来读 나~니。';

  @override
  String get hangulS6L2Step0Highlights => '나,너,노,누,느,니';

  @override
  String get hangulS6L2Step1Title => '聆听 나~니';

  @override
  String get hangulS6L2Step1Desc => '请听听 ㄴ 模式的发音';

  @override
  String get hangulS6L2Step2Title => '发音练习';

  @override
  String get hangulS6L2Step2Desc => '请大声读出每个音节';

  @override
  String get hangulS6L2Step3Title => '组合 ㄴ';

  @override
  String get hangulS6L2Step3Desc => '用 ㄴ + 元音组成音节';

  @override
  String get hangulS6L2Step4Title => '课程完成！';

  @override
  String get hangulS6L2Step4Msg => '很好！\n你已经掌握了 나~니 模式。';

  @override
  String get hangulS6L3Title => '扩展 다~디 和 라~리';

  @override
  String get hangulS6L3Subtitle => 'ㄷ/ㄹ 模式阅读';

  @override
  String get hangulS6L3Step0Title => '只换辅音来阅读';

  @override
  String get hangulS6L3Step0Desc => '用相同元音只换辅音来读，\n阅读速度会越来越快。';

  @override
  String get hangulS6L3Step0Highlights => '다/라,도/로,두/루,디/리';

  @override
  String get hangulS6L3Step1Title => '聆听：区分 ㄷ/ㄹ';

  @override
  String get hangulS6L3Step1Desc => '听音选择正确的音节';

  @override
  String get hangulS6L3Step2Title => '阅读测验';

  @override
  String get hangulS6L3Step2Desc => '检查模式';

  @override
  String get hangulS6L3Step2Q0 => 'ㄷ + ㅣ = ?';

  @override
  String get hangulS6L3Step2Q1 => 'ㄹ + ㅗ = ?';

  @override
  String get hangulS6L3Step3Title => '课程完成！';

  @override
  String get hangulS6L3Step3Msg => '很好！\n你已经掌握了 ㄷ/ㄹ 模式。';

  @override
  String get hangulS6L4Title => '随机音节阅读 1';

  @override
  String get hangulS6L4Subtitle => '混合基本模式';

  @override
  String get hangulS6L4Step0Title => '无序阅读';

  @override
  String get hangulS6L4Step0Desc => '现在像随机抽卡一样来读吧。';

  @override
  String get hangulS6L4Step1Title => '随机阅读';

  @override
  String get hangulS6L4Step1Desc => '识别随机出现的音节';

  @override
  String get hangulS6L4Step1Q0 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS6L4Step1Q1 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS6L4Step1Q2 => 'ㄹ + ㅏ = ?';

  @override
  String get hangulS6L4Step1Q3 => 'ㅁ + ㅣ = ?';

  @override
  String get hangulS6L4Step2Title => '课程完成！';

  @override
  String get hangulS6L4Step2Msg => '很好！\n你完成了随机阅读 1。';

  @override
  String get hangulS6L5Title => '听音找音节';

  @override
  String get hangulS6L5Subtitle => '强化听觉与文字的联系';

  @override
  String get hangulS6L5Step0Title => '听音寻字练习';

  @override
  String get hangulS6L5Step0Desc => '听音选出对应音节，\n强化阅读联系。';

  @override
  String get hangulS6L5Step1Title => '声音配对';

  @override
  String get hangulS6L5Step1Desc => '选出正确的音节';

  @override
  String get hangulS6L5Step2Title => '课程完成！';

  @override
  String get hangulS6L5Step2Msg => '很好！\n你完成了听音找字练习。';

  @override
  String get hangulS6L6Title => '复合元音组合 1';

  @override
  String get hangulS6L6Subtitle => '阅读 ㅘ、ㅝ';

  @override
  String get hangulS6L6Step0Title => '开始学习复合元音';

  @override
  String get hangulS6L6Step0Desc => '来读一读由 ㅘ 和 ㅝ 组成的音节。';

  @override
  String get hangulS6L6Step0Highlights => 'ㅘ,ㅝ,와,워';

  @override
  String get hangulS6L6Step1Title => '聆听 와/워';

  @override
  String get hangulS6L6Step1Desc => '请听一听代表性音节的发音';

  @override
  String get hangulS6L6Step2Title => '发音练习';

  @override
  String get hangulS6L6Step2Desc => '请大声读出每个音节';

  @override
  String get hangulS6L6Step3Title => '复合元音测验';

  @override
  String get hangulS6L6Step3Desc => '区分 ㅘ 和 ㅝ';

  @override
  String get hangulS6L6Step3Q0 => 'ㅇ + ㅘ = ?';

  @override
  String get hangulS6L6Step3Q1 => 'ㄱ + ㅝ = ?';

  @override
  String get hangulS6L6Step4Title => '课程完成！';

  @override
  String get hangulS6L6Step4Msg => '很好！\n你已经学会了 ㅘ/ㅝ 组合。';

  @override
  String get hangulS6L7Title => '复合元音组合 2';

  @override
  String get hangulS6L7Subtitle => '阅读 ㅙ、ㅞ、ㅚ、ㅟ、ㅢ';

  @override
  String get hangulS6L7Step0Title => '扩展复合元音';

  @override
  String get hangulS6L7Step0Desc => '简要学习复合元音，以阅读为中心推进。';

  @override
  String get hangulS6L7Step0Highlights => '왜,웨,외,위,의';

  @override
  String get hangulS6L7Step1Title => 'ㅢ 的特殊发音';

  @override
  String get hangulS6L7Step1Desc =>
      'ㅢ 是一个根据位置发音不同的特殊元音。\n\n• 词首：[의] → 의사、의자\n• 辅音后：[이] → 희망→[히망]\n• 助词「의」：[에] → 나의→[나에]';

  @override
  String get hangulS6L7Step1Highlights => 'ㅢ,의,이,에';

  @override
  String get hangulS6L7Step2Title => '选择复合元音';

  @override
  String get hangulS6L7Step2Desc => '选出正确的音节';

  @override
  String get hangulS6L7Step2Q0 => 'ㅇ + ㅙ = ?';

  @override
  String get hangulS6L7Step2Q1 => 'ㅇ + ㅟ = ?';

  @override
  String get hangulS6L7Step2Q2 => 'ㅇ + ㅢ = ?';

  @override
  String get hangulS6L7Step3Title => '课程完成！';

  @override
  String get hangulS6L7Step3Msg => '很好！\n你完成了复合元音的扩展学习。';

  @override
  String get hangulS6L8Title => '随机音节阅读 2';

  @override
  String get hangulS6L8Subtitle => '基本+复合元音综合';

  @override
  String get hangulS6L8Step0Title => '综合随机阅读';

  @override
  String get hangulS6L8Step0Desc => '将基本元音和复合元音混合在一起阅读。';

  @override
  String get hangulS6L8Step1Title => '综合测验';

  @override
  String get hangulS6L8Step1Desc => '识别随机组合';

  @override
  String get hangulS6L8Step1Q0 => 'ㄱ + ㅢ = ?';

  @override
  String get hangulS6L8Step1Q1 => 'ㅎ + ㅘ = ?';

  @override
  String get hangulS6L8Step1Q2 => 'ㅂ + ㅟ = ?';

  @override
  String get hangulS6L8Step1Q3 => 'ㅈ + ㅝ = ?';

  @override
  String get hangulS6L8Step2Title => '课程完成！';

  @override
  String get hangulS6L8Step2Msg => '很好！\n你完成了第6阶段综合阅读。';

  @override
  String get hangulS6LMTitle => '第6阶段任务';

  @override
  String get hangulS6LMSubtitle => '组合阅读最终检验';

  @override
  String get hangulS6LMStep0Title => '任务开始！';

  @override
  String get hangulS6LMStep0Desc => '这是音节组合训练的最终检验。\n在时限内达成目标吧！';

  @override
  String get hangulS6LMStep1Title => '组合音节！';

  @override
  String get hangulS6LMStep2Title => '任务结果';

  @override
  String get hangulS6LMStep3Title => '第6阶段完成！';

  @override
  String get hangulS6LMStep3Msg => '恭喜！\n你完成了第6阶段音节组合训练。';

  @override
  String get hangulS6CompleteTitle => '第6阶段完成！';

  @override
  String get hangulS6CompleteMsg => '你现在可以自由组合音节了！';

  @override
  String get hangulS7L1Title => 'ㄱ / ㅋ / ㄲ 辅音对比';

  @override
  String get hangulS7L1Subtitle => '가 · 카 · 까 的对比';

  @override
  String get hangulS7L1Step0Title => '分辨三种声音';

  @override
  String get hangulS7L1Step0Desc => '区分ㄱ（平音）、ㅋ（送气音）、ㄲ（紧音）的感觉。';

  @override
  String get hangulS7L1Step0Highlights => 'ㄱ,ㅋ,ㄲ,가,카,까';

  @override
  String get hangulS7L1Step1Title => '声音探索';

  @override
  String get hangulS7L1Step1Desc => '反复听가/카/까';

  @override
  String get hangulS7L1Step2Title => '发音练习';

  @override
  String get hangulS7L1Step2Desc => '试着亲自发出每个字的声音';

  @override
  String get hangulS7L1Step3Title => '听音选字';

  @override
  String get hangulS7L1Step3Desc => '从三个选项中选出正确答案';

  @override
  String get hangulS7L1Step4Title => '快速确认';

  @override
  String get hangulS7L1Step4Desc => '同时确认形状和声音';

  @override
  String get hangulS7L1Step4Q0 => '哪个是送气音？';

  @override
  String get hangulS7L1Step4Q1 => '哪个是紧音？';

  @override
  String get hangulS7L1Step5Title => '课程完成！';

  @override
  String get hangulS7L1Step5Msg => '很好！\n你已掌握区分ㄱ/ㅋ/ㄲ的方法。';

  @override
  String get hangulS7L2Title => 'ㄷ / ㅌ / ㄸ 辅音对比';

  @override
  String get hangulS7L2Subtitle => '다 · 타 · 따 的对比';

  @override
  String get hangulS7L2Step0Title => '第二组对比';

  @override
  String get hangulS7L2Step0Desc => '比较ㄷ/ㅌ/ㄸ的声音。';

  @override
  String get hangulS7L2Step0Highlights => 'ㄷ,ㅌ,ㄸ,다,타,따';

  @override
  String get hangulS7L2Step1Title => '声音探索';

  @override
  String get hangulS7L2Step1Desc => '反复听다/타/따';

  @override
  String get hangulS7L2Step2Title => '发音练习';

  @override
  String get hangulS7L2Step2Desc => '试着亲自发出每个字的声音';

  @override
  String get hangulS7L2Step3Title => '听音选字';

  @override
  String get hangulS7L2Step3Desc => '从三个选项中选出正确答案';

  @override
  String get hangulS7L2Step4Title => '课程完成！';

  @override
  String get hangulS7L2Step4Msg => '很好！\n你已掌握区分ㄷ/ㅌ/ㄸ的方法。';

  @override
  String get hangulS7L3Title => 'ㅂ / ㅍ / ㅃ 辅音对比';

  @override
  String get hangulS7L3Subtitle => '바 · 파 · 빠 的对比';

  @override
  String get hangulS7L3Step0Title => '第三组对比';

  @override
  String get hangulS7L3Step0Desc => '比较ㅂ/ㅍ/ㅃ的声音。';

  @override
  String get hangulS7L3Step0Highlights => 'ㅂ,ㅍ,ㅃ,바,파,빠';

  @override
  String get hangulS7L3Step1Title => '声音探索';

  @override
  String get hangulS7L3Step1Desc => '反复听바/파/빠';

  @override
  String get hangulS7L3Step2Title => '发音练习';

  @override
  String get hangulS7L3Step2Desc => '试着亲自发出每个字的声音';

  @override
  String get hangulS7L3Step3Title => '听音选字';

  @override
  String get hangulS7L3Step3Desc => '从三个选项中选出正确答案';

  @override
  String get hangulS7L3Step4Title => '课程完成！';

  @override
  String get hangulS7L3Step4Msg => '很好！\n你已掌握区分ㅂ/ㅍ/ㅃ的方法。';

  @override
  String get hangulS7L4Title => 'ㅅ / ㅆ 辅音对比';

  @override
  String get hangulS7L4Subtitle => '사 · 싸 的对比';

  @override
  String get hangulS7L4Step0Title => '两种声音的对比';

  @override
  String get hangulS7L4Step0Desc => '区分ㅅ/ㅆ的声音。';

  @override
  String get hangulS7L4Step0Highlights => 'ㅅ,ㅆ,사,싸';

  @override
  String get hangulS7L4Step1Title => '声音探索';

  @override
  String get hangulS7L4Step1Desc => '反复听사/싸';

  @override
  String get hangulS7L4Step2Title => '发音练习';

  @override
  String get hangulS7L4Step2Desc => '试着亲自发出每个字的声音';

  @override
  String get hangulS7L4Step3Title => '听音选字';

  @override
  String get hangulS7L4Step3Desc => '从两个选项中选出正确答案';

  @override
  String get hangulS7L4Step4Title => '课程完成！';

  @override
  String get hangulS7L4Step4Msg => '很好！\n你已掌握区分ㅅ/ㅆ的方法。';

  @override
  String get hangulS7L5Title => 'ㅈ / ㅊ / ㅉ 辅音对比';

  @override
  String get hangulS7L5Subtitle => '자 · 차 · 짜 的对比';

  @override
  String get hangulS7L5Step0Title => '最后一组对比';

  @override
  String get hangulS7L5Step0Desc => '比较ㅈ/ㅊ/ㅉ的声音。';

  @override
  String get hangulS7L5Step0Highlights => 'ㅈ,ㅊ,ㅉ,자,차,짜';

  @override
  String get hangulS7L5Step1Title => '声音探索';

  @override
  String get hangulS7L5Step1Desc => '反复听자/차/짜';

  @override
  String get hangulS7L5Step2Title => '发音练习';

  @override
  String get hangulS7L5Step2Desc => '试着亲自发出每个字的声音';

  @override
  String get hangulS7L5Step3Title => '听音选字';

  @override
  String get hangulS7L5Step3Desc => '从三个选项中选出正确答案';

  @override
  String get hangulS7L5Step4Title => '第7阶段完成！';

  @override
  String get hangulS7L5Step4Msg => '恭喜！\n你已完成第7阶段的全部5组对比练习。';

  @override
  String get hangulS7LMTitle => '任务：声音辨别挑战！';

  @override
  String get hangulS7LMSubtitle => '区分平音、送气音和紧音';

  @override
  String get hangulS7LMStep0Title => '声音辨别任务！';

  @override
  String get hangulS7LMStep0Desc => '混合平音、送气音和紧音\n快速组合音节！';

  @override
  String get hangulS7LMStep1Title => '组合音节！';

  @override
  String get hangulS7LMStep2Title => '任务结果';

  @override
  String get hangulS7LMStep3Title => '任务完成！';

  @override
  String get hangulS7LMStep3Msg => '你已能区分平音、送气音和紧音！';

  @override
  String get hangulS7LMStep4Title => '第7阶段完成！';

  @override
  String get hangulS7LMStep4Msg => '你已能区分紧音和送气音！';

  @override
  String get hangulS7CompleteTitle => '第7阶段完成！';

  @override
  String get hangulS7CompleteMsg => '你已能区分紧音和送气音！';

  @override
  String get hangulS8L0Title => '收音（받침）基础';

  @override
  String get hangulS8L0Subtitle => '藏在音节块底部的音';

  @override
  String get hangulS8L0Step0Title => '收音在音节的下方';

  @override
  String get hangulS8L0Step0Desc => '收音位于音节块的底部。\n例：가 + ㄴ = 간';

  @override
  String get hangulS8L0Step0Highlights => '收音,간,말,집';

  @override
  String get hangulS8L0Step1Title => '收音的7个代表音';

  @override
  String get hangulS8L0Step1Desc =>
      '收音只有7个代表音。\n\nㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\n许多收音字母都归属于这7个音之一。\n例：ㅅ, ㅈ, ㅊ, ㅎ 作为收音 → 均发[ㄷ]音';

  @override
  String get hangulS8L0Step1Highlights => '7个音,ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ,代表音';

  @override
  String get hangulS8L0Step2Title => '找出收音';

  @override
  String get hangulS8L0Step2Desc => '确认收音的位置';

  @override
  String get hangulS8L0Step2Q0 => '간的收音是？';

  @override
  String get hangulS8L0Step2Q1 => '말的收音是？';

  @override
  String get hangulS8L0SummaryTitle => '课程完成！';

  @override
  String get hangulS8L0SummaryMsg => '很好！\n你已理解收音的概念。';

  @override
  String get hangulS8L1Title => 'ㄴ收音';

  @override
  String get hangulS8L1Subtitle => '간 · 난 · 단';

  @override
  String get hangulS8L1Step0Title => '聆听ㄴ收音';

  @override
  String get hangulS8L1Step0Desc => '听一听간/난/단';

  @override
  String get hangulS8L1Step1Title => '发音练习';

  @override
  String get hangulS8L1Step1Desc => '大声朗读每个字';

  @override
  String get hangulS8L1Step2Title => '听音选字';

  @override
  String get hangulS8L1Step2Desc => '选出带有ㄴ收音的音节';

  @override
  String get hangulS8L1SummaryTitle => '课程完成！';

  @override
  String get hangulS8L1SummaryMsg => '很好！\n你掌握了ㄴ收音。';

  @override
  String get hangulS8L2Title => 'ㄹ收音';

  @override
  String get hangulS8L2Subtitle => '말 · 갈 · 물';

  @override
  String get hangulS8L2Step0Title => '聆听ㄹ收音';

  @override
  String get hangulS8L2Step0Desc => '听一听말/갈/물';

  @override
  String get hangulS8L2Step1Title => '发音练习';

  @override
  String get hangulS8L2Step1Desc => '大声朗读每个字';

  @override
  String get hangulS8L2Step2Title => '听音选字';

  @override
  String get hangulS8L2Step2Desc => '选出带有ㄹ收音的音节';

  @override
  String get hangulS8L2SummaryTitle => '课程完成！';

  @override
  String get hangulS8L2SummaryMsg => '很好！\n你掌握了ㄹ收音。';

  @override
  String get hangulS8L3Title => 'ㅁ收音';

  @override
  String get hangulS8L3Subtitle => '감 · 밤 · 숨';

  @override
  String get hangulS8L3Step0Title => '聆听ㅁ收音';

  @override
  String get hangulS8L3Step0Desc => '听一听감/밤/숨';

  @override
  String get hangulS8L3Step1Title => '发音练习';

  @override
  String get hangulS8L3Step1Desc => '大声朗读每个字';

  @override
  String get hangulS8L3Step2Title => '辨别收音';

  @override
  String get hangulS8L3Step2Desc => '选出ㅁ收音的音节';

  @override
  String get hangulS8L3Step2Q0 => '哪个有ㅁ收音？';

  @override
  String get hangulS8L3Step2Q1 => '哪个有ㅁ收音？';

  @override
  String get hangulS8L3SummaryTitle => '课程完成！';

  @override
  String get hangulS8L3SummaryMsg => '很好！\n你掌握了ㅁ收音。';

  @override
  String get hangulS8L4Title => 'ㅇ收音';

  @override
  String get hangulS8L4Subtitle => '방 · 공 · 종';

  @override
  String get hangulS8L4Step0Title => 'ㅇ很特别！';

  @override
  String get hangulS8L4Step0Desc =>
      'ㅇ很特别！\n作为初声（上方）时无音（아, 오），\n作为收音（下方）时发\"ng\"音（방, 공）';

  @override
  String get hangulS8L4Step0Highlights => '初声,收音,ng,방,공';

  @override
  String get hangulS8L4Step1Title => '聆听ㅇ收音';

  @override
  String get hangulS8L4Step1Desc => '听一听방/공/종';

  @override
  String get hangulS8L4Step2Title => '发音练习';

  @override
  String get hangulS8L4Step2Desc => '大声朗读每个字';

  @override
  String get hangulS8L4Step3Title => '听音选字';

  @override
  String get hangulS8L4Step3Desc => '选出带有ㅇ收音的音节';

  @override
  String get hangulS8L4SummaryTitle => '课程完成！';

  @override
  String get hangulS8L4SummaryMsg => '很好！\n你掌握了ㅇ收音。';

  @override
  String get hangulS8L5Title => 'ㄱ收音';

  @override
  String get hangulS8L5Subtitle => '박 · 각 · 국';

  @override
  String get hangulS8L5Step0Title => '聆听ㄱ收音';

  @override
  String get hangulS8L5Step0Desc => '听一听박/각/국';

  @override
  String get hangulS8L5Step1Title => '发音练习';

  @override
  String get hangulS8L5Step1Desc => '大声朗读每个字';

  @override
  String get hangulS8L5Step2Title => '辨别收音';

  @override
  String get hangulS8L5Step2Desc => '选出ㄱ收音的音节';

  @override
  String get hangulS8L5Step2Q0 => '哪个有ㄱ收音？';

  @override
  String get hangulS8L5Step2Q1 => '哪个有ㄱ收音？';

  @override
  String get hangulS8L5SummaryTitle => '课程完成！';

  @override
  String get hangulS8L5SummaryMsg => '很好！\n你掌握了ㄱ收音。';

  @override
  String get hangulS8L6Title => 'ㅂ收音';

  @override
  String get hangulS8L6Subtitle => '밥 · 집 · 숲';

  @override
  String get hangulS8L6Step0Title => '聆听ㅂ收音';

  @override
  String get hangulS8L6Step0Desc => '听一听밥/집/숲';

  @override
  String get hangulS8L6Step1Title => '发音练习';

  @override
  String get hangulS8L6Step1Desc => '大声朗读每个字';

  @override
  String get hangulS8L6Step2Title => '听音选字';

  @override
  String get hangulS8L6Step2Desc => '选出带有ㅂ收音的音节';

  @override
  String get hangulS8L6SummaryTitle => '课程完成！';

  @override
  String get hangulS8L6SummaryMsg => '很好！\n你掌握了ㅂ收音。';

  @override
  String get hangulS8L7Title => 'ㅅ收音';

  @override
  String get hangulS8L7Subtitle => '옷 · 맛 · 빛';

  @override
  String get hangulS8L7Step0Title => '聆听ㅅ收音';

  @override
  String get hangulS8L7Step0Desc => '听一听옷/맛/빛';

  @override
  String get hangulS8L7Step1Title => '发音练习';

  @override
  String get hangulS8L7Step1Desc => '大声朗读每个字';

  @override
  String get hangulS8L7Step2Title => '辨别收音';

  @override
  String get hangulS8L7Step2Desc => '选出ㅅ收音的音节';

  @override
  String get hangulS8L7Step2Q0 => '哪个有ㅅ收音？';

  @override
  String get hangulS8L7Step2Q1 => '哪个有ㅅ收音？';

  @override
  String get hangulS8L7SummaryTitle => '课程完成！';

  @override
  String get hangulS8L7SummaryMsg => '很好！\n你掌握了ㅅ收音。';

  @override
  String get hangulS8L8Title => '收音综合复习';

  @override
  String get hangulS8L8Subtitle => '核心收音随机检测';

  @override
  String get hangulS8L8Step0Title => '全部混合练习';

  @override
  String get hangulS8L8Step0Desc => '我们来综合复习ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ。';

  @override
  String get hangulS8L8Step1Title => '随机测验';

  @override
  String get hangulS8L8Step1Desc => '混合收音综合测试';

  @override
  String get hangulS8L8Step1Q0 => '哪个有ㄴ收音？';

  @override
  String get hangulS8L8Step1Q1 => '哪个有ㅇ收音？';

  @override
  String get hangulS8L8Step1Q2 => '哪个有ㄹ收音？';

  @override
  String get hangulS8L8Step1Q3 => '哪个有ㅂ收音？';

  @override
  String get hangulS8L8SummaryTitle => '课程完成！';

  @override
  String get hangulS8L8SummaryMsg => '很好！\n完成了收音综合复习。';

  @override
  String get hangulS8LMTitle => '任务：收音挑战！';

  @override
  String get hangulS8LMSubtitle => '组合带收音的音节';

  @override
  String get hangulS8LMStep0Title => '收音任务！';

  @override
  String get hangulS8LMStep0Desc => '读出带有基本收音的音节，\n快速作答！';

  @override
  String get hangulS8LMStep1Title => '拼出音节！';

  @override
  String get hangulS8LMStep2Title => '任务结果';

  @override
  String get hangulS8LMSummaryTitle => '任务完成！';

  @override
  String get hangulS8LMSummaryMsg => '你已完全掌握收音基础！';

  @override
  String get hangulS8CompleteTitle => '第8阶段完成！';

  @override
  String get hangulS8CompleteMsg => '你已打好收音的基础！';

  @override
  String get hangulS9L1Title => '收音 ㄷ 扩展';

  @override
  String get hangulS9L1Subtitle => '닫 · 곧 · 묻';

  @override
  String get hangulS9L1Step0Title => 'ㄷ 收音规律';

  @override
  String get hangulS9L1Step0Desc => '读一读带有收音 ㄷ 的音节。';

  @override
  String get hangulS9L1Step0Highlights => '닫,곧,묻';

  @override
  String get hangulS9L1Step1Title => '听一听：收音 ㄷ';

  @override
  String get hangulS9L1Step1Desc => '听 닫/곧/묻 的发音';

  @override
  String get hangulS9L1Step2Title => '发音练习';

  @override
  String get hangulS9L1Step2Desc => '亲自大声念出每个字';

  @override
  String get hangulS9L1Step3Title => '辨别收音';

  @override
  String get hangulS9L1Step3Desc => '选出带有收音 ㄷ 的音节';

  @override
  String get hangulS9L1Step3Q0 => '哪个带有收音 ㄷ？';

  @override
  String get hangulS9L1Step3Q1 => '哪个带有收音 ㄷ？';

  @override
  String get hangulS9L1Step4Title => '课程完成！';

  @override
  String get hangulS9L1Step4Msg => '很好！\n你已掌握收音 ㄷ。';

  @override
  String get hangulS9L2Title => '收音 ㅈ 扩展';

  @override
  String get hangulS9L2Subtitle => '낮 · 잊 · 젖';

  @override
  String get hangulS9L2Step0Title => '听一听：收音 ㅈ';

  @override
  String get hangulS9L2Step0Desc => '听 낮/잊/젖 的发音';

  @override
  String get hangulS9L2Step1Title => '发音练习';

  @override
  String get hangulS9L2Step1Desc => '亲自大声念出每个字';

  @override
  String get hangulS9L2Step2Title => '听音选字';

  @override
  String get hangulS9L2Step2Desc => '选出带有收音 ㅈ 的音节';

  @override
  String get hangulS9L2Step3Title => '课程完成！';

  @override
  String get hangulS9L2Step3Msg => '很好！\n你已掌握收音 ㅈ。';

  @override
  String get hangulS9L3Title => '收音 ㅊ 扩展';

  @override
  String get hangulS9L3Subtitle => '꽃 · 닻 · 빚';

  @override
  String get hangulS9L3Step0Title => '听一听：收音 ㅊ';

  @override
  String get hangulS9L3Step0Desc => '听 꽃/닻/빚 的发音';

  @override
  String get hangulS9L3Step1Title => '发音练习';

  @override
  String get hangulS9L3Step1Desc => '亲自大声念出每个字';

  @override
  String get hangulS9L3Step2Title => '辨别收音';

  @override
  String get hangulS9L3Step2Desc => '选出带有收音 ㅊ 的音节';

  @override
  String get hangulS9L3Step2Q0 => '哪个带有收音 ㅊ？';

  @override
  String get hangulS9L3Step2Q1 => '哪个带有收音 ㅊ？';

  @override
  String get hangulS9L3Step3Title => '课程完成！';

  @override
  String get hangulS9L3Step3Msg => '很好！\n你已掌握收音 ㅊ。';

  @override
  String get hangulS9L4Title => '收音 ㅋ / ㅌ / ㅍ';

  @override
  String get hangulS9L4Subtitle => '부엌 · 밭 · 앞';

  @override
  String get hangulS9L4Step0Title => '三个收音合并学习';

  @override
  String get hangulS9L4Step0Desc => '把 ㅋ、ㅌ、ㅍ 三个收音放在一起学。';

  @override
  String get hangulS9L4Step0Highlights => '부엌,밭,앞';

  @override
  String get hangulS9L4Step1Title => '听一听';

  @override
  String get hangulS9L4Step1Desc => '听 부엌/밭/앞 的发音';

  @override
  String get hangulS9L4Step2Title => '发音练习';

  @override
  String get hangulS9L4Step2Desc => '亲自大声念出每个字';

  @override
  String get hangulS9L4Step3Title => '辨别收音';

  @override
  String get hangulS9L4Step3Desc => '区分这三个收音';

  @override
  String get hangulS9L4Step3Q0 => '哪个带有收音 ㅌ？';

  @override
  String get hangulS9L4Step3Q1 => '哪个带有收音 ㅍ？';

  @override
  String get hangulS9L4Step4Title => '课程完成！';

  @override
  String get hangulS9L4Step4Msg => '很好！\n你已掌握收音 ㅋ/ㅌ/ㅍ。';

  @override
  String get hangulS9L5Title => '收音 ㅎ 扩展';

  @override
  String get hangulS9L5Subtitle => '좋 · 놓 · 않';

  @override
  String get hangulS9L5Step0Title => '听一听：收音 ㅎ';

  @override
  String get hangulS9L5Step0Desc => '听 좋/놓/않 的发音';

  @override
  String get hangulS9L5Step1Title => '发音练习';

  @override
  String get hangulS9L5Step1Desc => '亲自大声念出每个字';

  @override
  String get hangulS9L5Step2Title => '听音选字';

  @override
  String get hangulS9L5Step2Desc => '选出带有收音 ㅎ 的音节';

  @override
  String get hangulS9L5Step3Title => '课程完成！';

  @override
  String get hangulS9L5Step3Msg => '很好！\n你已掌握收音 ㅎ。';

  @override
  String get hangulS9L6Title => '扩展收音随机练习';

  @override
  String get hangulS9L6Subtitle => '混合 ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS9L6Step0Title => '混合扩展收音';

  @override
  String get hangulS9L6Step0Desc => '随机复习所有扩展收音。';

  @override
  String get hangulS9L6Step1Title => '随机测验';

  @override
  String get hangulS9L6Step1Desc => '解题并区分各个收音';

  @override
  String get hangulS9L6Step1Q0 => '哪个带有收音 ㄷ？';

  @override
  String get hangulS9L6Step1Q1 => '哪个带有收音 ㅈ？';

  @override
  String get hangulS9L6Step1Q2 => '哪个带有收音 ㅊ？';

  @override
  String get hangulS9L6Step1Q3 => '哪个带有收音 ㅎ？';

  @override
  String get hangulS9L6Step2Title => '课程完成！';

  @override
  String get hangulS9L6Step2Msg => '很好！\n扩展收音随机复习完成。';

  @override
  String get hangulS9L7Title => '第9阶段综合';

  @override
  String get hangulS9L7Subtitle => '扩展收音阅读收尾';

  @override
  String get hangulS9L7Step0Title => '最终确认';

  @override
  String get hangulS9L7Step0Desc => '最终复习第9阶段的核心要点';

  @override
  String get hangulS9L7Step1Title => '第9阶段完成！';

  @override
  String get hangulS9L7Step1Msg => '恭喜！\n你已完成第9阶段的扩展收音学习。';

  @override
  String get hangulS9LMTitle => '任务：扩展收音挑战！';

  @override
  String get hangulS9LMSubtitle => '快速读出各种收音';

  @override
  String get hangulS9LMStep0Title => '扩展收音任务！';

  @override
  String get hangulS9LMStep0Desc => '以最快速度组合含扩展收音的音节！';

  @override
  String get hangulS9LMStep1Title => '组合音节！';

  @override
  String get hangulS9LMStep2Title => '任务结果';

  @override
  String get hangulS9LMStep3Title => '任务完成！';

  @override
  String get hangulS9LMStep3Msg => '你已征服扩展收音！';

  @override
  String get hangulS9CompleteTitle => '第9阶段完成！';

  @override
  String get hangulS9CompleteMsg => '你已征服扩展收音！';

  @override
  String get hangulS10L1Title => 'ㄳ 收音';

  @override
  String get hangulS10L1Subtitle => '以 몫・넋 为中心阅读';

  @override
  String get hangulS10L1Step0Title => '双收音的发音规则';

  @override
  String get hangulS10L1Step0Desc =>
      '双收音是由两个辅音组合而成的收音。\n\n大多数读左边的辅音：\nㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\n少数读右边的辅音：\nㄺ→[ㄹ], ㄼ→[ㄹ]';

  @override
  String get hangulS10L1Step0Highlights => '左边辅音,右边辅音,双收音';

  @override
  String get hangulS10L1Step1Title => '开始学习复合收音';

  @override
  String get hangulS10L1Step1Desc => '来读含有 ㄳ 收音的单词吧。';

  @override
  String get hangulS10L1Step1Highlights => '몫,넋';

  @override
  String get hangulS10L1Step2Title => '听发音';

  @override
  String get hangulS10L1Step2Desc => '听一听 몫/넋';

  @override
  String get hangulS10L1Step3Title => '发音练习';

  @override
  String get hangulS10L1Step3Desc => '请大声读出每个字';

  @override
  String get hangulS10L1Step4Title => '阅读检测';

  @override
  String get hangulS10L1Step4Desc => '看单词并选择正确答案';

  @override
  String get hangulS10L1Step4Q0 => '哪个单词有 ㄳ 收音？';

  @override
  String get hangulS10L1Step4Q1 => '哪个单词有 ㄳ 收音？';

  @override
  String get hangulS10L1Step5Title => '课程完成！';

  @override
  String get hangulS10L1Step5Msg => '很好！\n你已经掌握了 ㄳ 收音。';

  @override
  String get hangulS10L2Title => 'ㄵ / ㄶ 收音';

  @override
  String get hangulS10L2Subtitle => '앉다・많다';

  @override
  String get hangulS10L2Step0Title => '听发音';

  @override
  String get hangulS10L2Step0Desc => '听一听 앉다/많다';

  @override
  String get hangulS10L2Step1Title => '发音练习';

  @override
  String get hangulS10L2Step1Desc => '请大声读出每个字';

  @override
  String get hangulS10L2Step2Title => '听后选择';

  @override
  String get hangulS10L2Step2Desc => '选择正确的单词';

  @override
  String get hangulS10L2Step3Title => '课程完成！';

  @override
  String get hangulS10L2Step3Msg => '很好！\n你已经掌握了 ㄵ/ㄶ 收音。';

  @override
  String get hangulS10L3Title => 'ㄺ / ㄻ 收音';

  @override
  String get hangulS10L3Subtitle => '읽다・삶';

  @override
  String get hangulS10L3Step0Title => '听发音';

  @override
  String get hangulS10L3Step0Desc => '听一听 읽다/삶';

  @override
  String get hangulS10L3Step1Title => '发音练习';

  @override
  String get hangulS10L3Step1Desc => '请大声读出每个字';

  @override
  String get hangulS10L3Step2Title => '阅读检测';

  @override
  String get hangulS10L3Step2Desc => '选择含复合收音的单词';

  @override
  String get hangulS10L3Step2Q0 => '哪个单词有 ㄺ 收音？';

  @override
  String get hangulS10L3Step2Q1 => '哪个单词有 ㄻ 收音？';

  @override
  String get hangulS10L3Step3Title => '课程完成！';

  @override
  String get hangulS10L3Step3Msg => '很好！\n你已经掌握了 ㄺ/ㄻ 收音。';

  @override
  String get hangulS10L4Title => '高级组合 1';

  @override
  String get hangulS10L4Subtitle => 'ㄼ・ㄾ・ㄿ・ㅀ';

  @override
  String get hangulS10L4Step0Title => '高级组合介绍';

  @override
  String get hangulS10L4Step0Desc => '通过常见例子简短地学习。';

  @override
  String get hangulS10L4Step0Highlights => '넓다,핥다,읊다,싫다';

  @override
  String get hangulS10L4Step1Title => '听单词发音';

  @override
  String get hangulS10L4Step1Desc => '听一听 넓다/핥다/읊다/싫다';

  @override
  String get hangulS10L4Step2Title => '发音练习';

  @override
  String get hangulS10L4Step2Desc => '请大声读出每个字';

  @override
  String get hangulS10L4Step3Title => '课程完成！';

  @override
  String get hangulS10L4Step3Msg => '很好！\n你已经掌握了高级组合 1。';

  @override
  String get hangulS10L5Title => 'ㅄ 收音';

  @override
  String get hangulS10L5Subtitle => '以 없다 为中心阅读';

  @override
  String get hangulS10L5Step0Title => '听发音';

  @override
  String get hangulS10L5Step0Desc => '听一听 없다/없어';

  @override
  String get hangulS10L5Step1Title => '发音练习';

  @override
  String get hangulS10L5Step1Desc => '请大声读出每个字';

  @override
  String get hangulS10L5Step2Title => '听后选择';

  @override
  String get hangulS10L5Step2Desc => '选择正确的单词';

  @override
  String get hangulS10L5Step3Title => '课程完成！';

  @override
  String get hangulS10L5Step3Msg => '很好！\n你已经掌握了 ㅄ 收音。';

  @override
  String get hangulS10L6Title => '第10阶段综合';

  @override
  String get hangulS10L6Subtitle => '复合收音单词综合';

  @override
  String get hangulS10L6Step0Title => '综合检测';

  @override
  String get hangulS10L6Step0Desc => '对复合收音单词进行最终检测';

  @override
  String get hangulS10L6Step0Q0 => '以下哪个单词有 ㄶ 收音？';

  @override
  String get hangulS10L6Step0Q1 => '以下哪个单词有 ㄺ 收音？';

  @override
  String get hangulS10L6Step0Q2 => '以下哪个单词有 ㅄ 收音？';

  @override
  String get hangulS10L6Step0Q3 => '以下哪个单词有 ㄳ 收音？';

  @override
  String get hangulS10L6Step1Title => '第10阶段完成！';

  @override
  String get hangulS10L6Step1Msg => '恭喜！\n你完成了第10阶段的复合收音。';

  @override
  String get hangulS10LMTitle => '任务：双收音挑战！';

  @override
  String get hangulS10LMSubtitle => '快速阅读双收音单词';

  @override
  String get hangulS10LMStep0Title => '双收音任务！';

  @override
  String get hangulS10LMStep0Desc => '快速组合包含双收音的音节！';

  @override
  String get hangulS10LMStep1Title => '组合音节！';

  @override
  String get hangulS10LMStep2Title => '任务结果';

  @override
  String get hangulS10LMStep3Title => '任务完成！';

  @override
  String get hangulS10LMStep3Msg => '你连双收音都掌握了！';

  @override
  String get hangulS10LMStep4Title => '第10阶段完成！';

  @override
  String get hangulS10CompleteTitle => '第10阶段完成！';

  @override
  String get hangulS10CompleteMsg => '你连双收音都掌握了！';

  @override
  String get hangulS11L1Title => '无收音的单词';

  @override
  String get hangulS11L1Subtitle => '简单的2~3音节单词';

  @override
  String get hangulS11L1Step0Title => '开始读单词';

  @override
  String get hangulS11L1Step0Desc => '先用没有收音的单词建立自信吧。';

  @override
  String get hangulS11L1Step0Highlights => '바나나,나비,하마,모자';

  @override
  String get hangulS11L1Step1Title => '听单词';

  @override
  String get hangulS11L1Step1Desc => '听听 바나나 / 나비 / 하마 / 모자';

  @override
  String get hangulS11L1Step2Title => '发音练习';

  @override
  String get hangulS11L1Step2Desc => '大声读出每个字';

  @override
  String get hangulS11L1Step3Title => '课程完成！';

  @override
  String get hangulS11L1Step3Msg => '很好！\n你开始读没有收音的单词了。';

  @override
  String get hangulS11L2Title => '基本收音单词';

  @override
  String get hangulS11L2Subtitle => '학교・친구・한국・공부';

  @override
  String get hangulS11L2Step0Title => '听单词';

  @override
  String get hangulS11L2Step0Desc => '听听 학교 / 친구 / 한국 / 공부';

  @override
  String get hangulS11L2Step1Title => '发音练习';

  @override
  String get hangulS11L2Step1Desc => '大声读出每个字';

  @override
  String get hangulS11L2Step2Title => '听后选择';

  @override
  String get hangulS11L2Step2Desc => '选择你听到的单词';

  @override
  String get hangulS11L2Step3Title => '课程完成！';

  @override
  String get hangulS11L2Step3Msg => '很好！\n你读了基本收音的单词。';

  @override
  String get hangulS11L3Title => '混合收音单词';

  @override
  String get hangulS11L3Subtitle => '읽기・없다・많다・닭';

  @override
  String get hangulS11L3Step0Title => '提升难度';

  @override
  String get hangulS11L3Step0Desc => '来读含基本和复合收音的混合单词吧。';

  @override
  String get hangulS11L3Step0Highlights => '읽기,없다,많다,닭';

  @override
  String get hangulS11L3Step1Title => '区分单词';

  @override
  String get hangulS11L3Step1Desc => '区分相似的单词';

  @override
  String get hangulS11L3Step1Q0 => '哪个是复合收音的单词？';

  @override
  String get hangulS11L3Step1Q1 => '哪个是复合收音的单词？';

  @override
  String get hangulS11L3Step2Title => '课程完成！';

  @override
  String get hangulS11L3Step2Msg => '很好！\n你读了混合收音的单词。';

  @override
  String get hangulS11L4Title => '分类单词包';

  @override
  String get hangulS11L4Subtitle => '食物・地点・人物';

  @override
  String get hangulS11L4Step0Title => '听分类单词';

  @override
  String get hangulS11L4Step0Desc => '听食物 / 地点 / 人物的单词';

  @override
  String get hangulS11L4Step1Title => '发音练习';

  @override
  String get hangulS11L4Step1Desc => '大声读出每个字';

  @override
  String get hangulS11L4Step2Title => '按类别分类';

  @override
  String get hangulS11L4Step2Desc => '看单词，选择它的类别';

  @override
  String get hangulS11L4Step2Q0 => '「김치」是什么？';

  @override
  String get hangulS11L4Step2Q1 => '「시장」是什么？';

  @override
  String get hangulS11L4Step2Q2 => '「학생」是什么？';

  @override
  String get hangulS11L4Step2CatFood => '食物';

  @override
  String get hangulS11L4Step2CatPlace => '地点';

  @override
  String get hangulS11L4Step2CatPerson => '人物';

  @override
  String get hangulS11L4Step3Title => '课程完成！';

  @override
  String get hangulS11L4Step3Msg => '很好！\n你学习了分类单词。';

  @override
  String get hangulS11L5Title => '听后选词';

  @override
  String get hangulS11L5Subtitle => '加强听觉与阅读的联系';

  @override
  String get hangulS11L5Step0Title => '声音匹配';

  @override
  String get hangulS11L5Step0Desc => '听后选出正确的单词';

  @override
  String get hangulS11L5Step1Title => '课程完成！';

  @override
  String get hangulS11L5Step1Msg => '很好！\n你完成了听后选词训练。';

  @override
  String get hangulS11L6Title => '第11阶段综合复习';

  @override
  String get hangulS11L6Subtitle => '单词阅读最终检验';

  @override
  String get hangulS11L6Step0Title => '综合测验';

  @override
  String get hangulS11L6Step0Desc => '第11阶段单词综合检验';

  @override
  String get hangulS11L6Step0Q0 => '哪个单词没有收音？';

  @override
  String get hangulS11L6Step0Q1 => '哪个是基本收音的单词？';

  @override
  String get hangulS11L6Step0Q2 => '哪个是复合收音的单词？';

  @override
  String get hangulS11L6Step0Q3 => '哪个是地点单词？';

  @override
  String get hangulS11L6Step1Title => '第11阶段完成！';

  @override
  String get hangulS11L6Step1Msg => '恭喜！\n你完成了第11阶段扩展单词阅读。';

  @override
  String get hangulS11L7Title => '在现实中读韩语';

  @override
  String get hangulS11L7Subtitle => '读咖啡菜单、地铁站名和问候语';

  @override
  String get hangulS11L7Step0Title => '在韩国读韩文！';

  @override
  String get hangulS11L7Step0Desc => '你已经学完了所有韩文！\n来读在韩国能看到的文字吧！';

  @override
  String get hangulS11L7Step0Highlights => '咖啡馆,地铁,问候语';

  @override
  String get hangulS11L7Step1Title => '读咖啡菜单';

  @override
  String get hangulS11L7Step1Descs => '美式咖啡,拿铁,绿茶,蛋糕';

  @override
  String get hangulS11L7Step2Title => '读地铁站名';

  @override
  String get hangulS11L7Step2Descs => '首尔站,江南,弘大入口,明洞';

  @override
  String get hangulS11L7Step3Title => '读基本问候语';

  @override
  String get hangulS11L7Step3Descs => '你好,谢谢,是,不是';

  @override
  String get hangulS11L7Step4Title => '发音练习';

  @override
  String get hangulS11L7Step4Desc => '大声读出每个字';

  @override
  String get hangulS11L7Step5Title => '在哪里能看到？';

  @override
  String get hangulS11L7Step5Q0 => '「아메리카노」在哪里能看到？';

  @override
  String get hangulS11L7Step5Q0Ans => '咖啡馆';

  @override
  String get hangulS11L7Step5Q0C0 => '咖啡馆';

  @override
  String get hangulS11L7Step5Q0C1 => '地铁';

  @override
  String get hangulS11L7Step5Q0C2 => '学校';

  @override
  String get hangulS11L7Step5Q1 => '「강남」是什么？';

  @override
  String get hangulS11L7Step5Q1Ans => '地铁站名';

  @override
  String get hangulS11L7Step5Q1C0 => '食物名称';

  @override
  String get hangulS11L7Step5Q1C1 => '地铁站名';

  @override
  String get hangulS11L7Step5Q1C2 => '问候语';

  @override
  String get hangulS11L7Step5Q2 => '「감사합니다」用中文是？';

  @override
  String get hangulS11L7Step5Q2Ans => '谢谢';

  @override
  String get hangulS11L7Step5Q2C0 => '你好';

  @override
  String get hangulS11L7Step5Q2C1 => '谢谢';

  @override
  String get hangulS11L7Step5Q2C2 => '再见';

  @override
  String get hangulS11L7Step6Title => '恭喜！';

  @override
  String get hangulS11L7Step6Msg => '你现在能读韩国的咖啡菜单、地铁站名和问候语了！\n离韩文大师只差一步！';

  @override
  String get hangulS11LMTitle => '任务：韩文速读！';

  @override
  String get hangulS11LMSubtitle => '快速读出韩语单词';

  @override
  String get hangulS11LMStep0Title => '韩文速读任务！';

  @override
  String get hangulS11LMStep0Desc => '尽快读出并匹配韩语单词！\n是时候证明你的实力了！';

  @override
  String get hangulS11LMStep1Title => '组合音节！';

  @override
  String get hangulS11LMStep2Title => '任务结果';

  @override
  String get hangulS11LMStep3Title => '韩文大师！';

  @override
  String get hangulS11LMStep3Msg => '你已经完全掌握韩文了！\n现在可以读韩语单词和句子了！';

  @override
  String get hangulS11LMStep4Title => '第11阶段完成！';

  @override
  String get hangulS11LMStep4Msg => '你现在能完整地读韩文了！';

  @override
  String get hangulS11CompleteTitle => '第11阶段完成！';

  @override
  String get hangulS11CompleteMsg => '你现在能完整地读韩文了！';

  @override
  String get stageRequestFailed => '发送上台请求失败，请重试。';

  @override
  String get stageRequestRejected => '主持人拒绝了你的上台请求。';

  @override
  String get inviteToStageFailed => '邀请上台失败，舞台可能已满。';

  @override
  String get demoteFailed => '从舞台移除失败，请重试。';

  @override
  String get voiceRoomCloseRoomFailed => '关闭房间失败，请重试。';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appName => '檸檬韓語';

  @override
  String get login => '登入';

  @override
  String get register => '註冊';

  @override
  String get email => 'Email';

  @override
  String get password => '密碼';

  @override
  String get confirmPassword => '確認密碼';

  @override
  String get username => '用戶名';

  @override
  String get enterEmail => '請輸入 Email 地址';

  @override
  String get enterPassword => '請輸入密碼';

  @override
  String get enterConfirmPassword => '請再次輸入密碼';

  @override
  String get enterUsername => '請輸入用戶名';

  @override
  String get createAccount => '建立帳號';

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
  String get haveAccount => '已有帳號？';

  @override
  String get noAccount => '沒有帳號？';

  @override
  String get loginNow => '立即登入';

  @override
  String get registerNow => '立即註冊';

  @override
  String get registerSuccess => '註冊成功';

  @override
  String get registerFailed => '註冊失敗';

  @override
  String get loginSuccess => '登入成功';

  @override
  String get loginFailed => '登入失敗';

  @override
  String get networkError => '網路連接失敗，請檢查網路設定';

  @override
  String get invalidCredentials => 'Email 或密碼錯誤';

  @override
  String get emailAlreadyExists => '此 Email 已被註冊';

  @override
  String get requestTimeout => '請求超時，請重試';

  @override
  String get operationFailed => '操作失敗，請稍後重試';

  @override
  String get settings => '設定';

  @override
  String get languageSettings => '語言設定';

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
  String get notificationSettings => '通知設定';

  @override
  String get enableNotifications => '啟用通知';

  @override
  String get enableNotificationsDesc => '開啟後可以接收學習提醒';

  @override
  String get permissionRequired => '請在系統設定中允許通知權限';

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
    return '提醒時間已設定為 $time';
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
  String get howToDownloadAnswer => '在課程列表中，點擊右側的下載圖示即可下載課程。下載後可以離線學習。';

  @override
  String get howToUseDownloaded => '如何使用已下載的課程？';

  @override
  String get howToUseDownloadedAnswer =>
      '即使沒有網路連接，您也可以正常學習已下載的課程。進度會在本地儲存，聯網後自動同步。';

  @override
  String get storageManagement => '儲存空間管理';

  @override
  String get howToCheckStorage => '如何查看儲存空間？';

  @override
  String get howToCheckStorageAnswer => '進入【設定 → 儲存空間管理】可以查看已使用和可用的儲存空間。';

  @override
  String get howToDeleteDownloaded => '如何刪除已下載的課程？';

  @override
  String get howToDeleteDownloadedAnswer => '在【儲存空間管理】頁面，點擊課程旁邊的刪除按鈕即可刪除。';

  @override
  String get notificationSection => '通知設定';

  @override
  String get howToEnableReminder => '如何開啟學習提醒？';

  @override
  String get howToEnableReminderAnswer =>
      '進入【設定 → 通知設定】，打開【啟用通知】開關。首次使用需要授予通知權限。';

  @override
  String get whatIsReviewReminder => '什麼是複習提醒？';

  @override
  String get whatIsReviewReminderAnswer =>
      '基於間隔重複算法（SRS），應用會在最佳時間提醒您複習已學課程。複習間隔：1天 → 3天 → 7天 → 14天 → 30天。';

  @override
  String get languageSection => '語言設定';

  @override
  String get howToSwitchChinese => '如何切換簡繁體中文？';

  @override
  String get howToSwitchChineseAnswer =>
      '進入【設定 → 語言設定】，選擇【簡體中文】或【繁體中文】。更改後立即生效。';

  @override
  String get faq => '常見問題';

  @override
  String get howToStart => '如何開始學習？';

  @override
  String get howToStartAnswer => '在主頁面選擇適合您水平的課程，從第1課開始。每節課包含7個學習階段。';

  @override
  String get progressNotSaved => '進度沒有儲存怎麼辦？';

  @override
  String get progressNotSavedAnswer => '進度會自動儲存到本地。如果聯網，會自動同步到伺服器。請檢查網路連接。';

  @override
  String get aboutApp => '關於應用';

  @override
  String get moreInfo => '更多資訊';

  @override
  String get versionInfo => '版本資訊';

  @override
  String get developer => '開發者';

  @override
  String get appIntro => '應用介紹';

  @override
  String get appIntroContent => '支援離線學習、智慧複習提醒等功能的韓語學習應用。';

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
  String get previous => '上一個';

  @override
  String get next => '下一個';

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
  String get listenAndChoose => '聽音訊，選擇正確的翻譯';

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
  String get translation => '翻譯';

  @override
  String get wordOrder => '排序';

  @override
  String get excellent => '太棒了！';

  @override
  String get correctOrderIs => '正確順序是:';

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
  String get playAudio => '播放音訊';

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
  String get logout => '登出';

  @override
  String get confirmLogout => '確定要登出嗎？';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定';

  @override
  String get delete => '刪除';

  @override
  String get save => '儲存';

  @override
  String get edit => '編輯';

  @override
  String get close => '關閉';

  @override
  String get retry => '重試';

  @override
  String get loading => '載入中...';

  @override
  String get noData => '暫無資料';

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
  String get onboardingFeature1Desc => '下載課程，無需網路即可學習';

  @override
  String get onboardingFeature2Title => '智慧複習系統';

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
      '• 複習提醒會在完成課程後自動安排\n• 部分手機需要在系統設定中關閉省電模式才能正常接收通知';

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
  String get storageInfo => '儲存空間資訊';

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
  String get cacheStorage => '快取';

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
  String get searchWords => '搜尋單詞...';

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
  String get searchWordsNotesChinese => '搜尋單詞、中文或筆記...';

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
  String get bookmarkHint => '在學習過程中點擊單詞卡片上的書籤圖示';

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
  String get loadAlphabetFirst => '請先載入字母表資料';

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
    return '載入失敗: $error';
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
  String get loadFailed => '載入失敗';

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
  String get exitLessonConfirm => '確定要退出當前課程嗎？進度將會儲存。';

  @override
  String get exitBtn => '退出';

  @override
  String get lessonComplete => '課程完成！進度已儲存';

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
  String get continueBtn => '繼續';

  @override
  String get previousQuestion => '上一題';

  @override
  String get playingAudio => '播放中...';

  @override
  String get playAll => '播放全部';

  @override
  String audioPlayFailed(String error) {
    return '音訊播放失敗: $error';
  }

  @override
  String get stopBtn => '停止';

  @override
  String get playAudioBtn => '播放音訊';

  @override
  String get playingAudioShort => '播放音訊...';

  @override
  String get pronunciation => '發音';

  @override
  String grammarPattern(String pattern) {
    return '語法 · $pattern';
  }

  @override
  String get grammarExplanation => '語法解釋';

  @override
  String get conjugationRule => '活用規則';

  @override
  String get comparisonWithChinese => '與中文對比';

  @override
  String get exampleSentences => '例句';

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
  String get fillBlank => '填空';

  @override
  String get checkAnswerBtn => '檢查答案';

  @override
  String correctAnswerIs(String answer) {
    return '正確答案: $answer';
  }

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
  String get chineseLanguage => '中文';

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
  String get userNotFound => '找不到使用者';

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
  String get voiceRoomMicPermission => '語音房間需要麥克風權限';

  @override
  String get voiceRoomEnterTitle => '請輸入房間標題';

  @override
  String get voiceRoomCreateFailed => '建立房間失敗';

  @override
  String get voiceRoomNotAvailable => '房間不可用';

  @override
  String get voiceRoomGoBack => '返回';

  @override
  String get voiceRoomConnecting => '連線中...';

  @override
  String voiceRoomReconnecting(int attempts, int max) {
    return '重新連線中 ($attempts/$max)...';
  }

  @override
  String get voiceRoomDisconnected => '已斷開連線';

  @override
  String get voiceRoomRetry => '重試';

  @override
  String get voiceRoomHostLabel => '（主持人）';

  @override
  String get voiceRoomDemoteToListener => '降為聽眾';

  @override
  String get voiceRoomKickFromRoom => '踢出房間';

  @override
  String get voiceRoomListeners => '聽眾';

  @override
  String get voiceRoomInviteToStage => '邀請上台';

  @override
  String voiceRoomInviteConfirm(String name) {
    return '邀請$name上台發言？';
  }

  @override
  String get voiceRoomInvite => '邀請';

  @override
  String get voiceRoomCloseConfirmTitle => '關閉房間？';

  @override
  String get voiceRoomCloseConfirmBody => '這將結束所有人的通話。';

  @override
  String get voiceRoomNoMessagesYet => '暫無訊息';

  @override
  String get voiceRoomTypeMessage => '輸入訊息...';

  @override
  String get voiceRoomStageFull => '舞台已滿';

  @override
  String voiceRoomListenerCount(int count) {
    return '$count位聽眾';
  }

  @override
  String get voiceRoomRemoveFromStage => '移出舞台？';

  @override
  String voiceRoomRemoveFromStageConfirm(String name) {
    return '將$name移出舞台？他們將成為聽眾。';
  }

  @override
  String get voiceRoomDemote => '降級';

  @override
  String get voiceRoomRemoveFromRoom => '移出房間？';

  @override
  String voiceRoomRemoveFromRoomConfirm(String name) {
    return '將$name移出房間？他們將被斷開連線。';
  }

  @override
  String get voiceRoomRemove => '移出';

  @override
  String get voiceRoomPressBackToLeave => '再按一次返回鍵離開';

  @override
  String get voiceRoomLeaveTitle => '離開房間？';

  @override
  String get voiceRoomLeaveBody => '你目前在舞台上。確定要離開嗎？';

  @override
  String get voiceRoomReturningToList => '正在返回房間列表...';

  @override
  String get voiceRoomConnected => '已連線！';

  @override
  String get voiceRoomStageFailedToLoad => '舞台載入失敗';

  @override
  String get voiceRoomPreparingStage => '正在準備舞台...';

  @override
  String voiceRoomAcceptToStage(Object name) {
    return '接受$name上台';
  }

  @override
  String voiceRoomRejectFromStage(Object name) {
    return '拒絕$name';
  }

  @override
  String get voiceRoomQuickCreate => '快速建立';

  @override
  String get voiceRoomRoomType => '房間類型';

  @override
  String get voiceRoomSessionDuration => '會話時長';

  @override
  String get voiceRoomOptionalTimer => '可選的會話計時器';

  @override
  String get voiceRoomDurationNone => '無限制';

  @override
  String get voiceRoomDuration15 => '15分鐘';

  @override
  String get voiceRoomDuration30 => '30分鐘';

  @override
  String get voiceRoomDuration45 => '45分鐘';

  @override
  String get voiceRoomDuration60 => '60分鐘';

  @override
  String get voiceRoomTypeFreeTalk => '自由聊天';

  @override
  String get voiceRoomTypePronunciation => '發音練習';

  @override
  String get voiceRoomTypeRolePlay => '角色扮演';

  @override
  String get voiceRoomTypeQnA => '問答';

  @override
  String get voiceRoomTypeListening => '聽力練習';

  @override
  String get voiceRoomTypeDebate => '辯論';

  @override
  String get voiceRoomTemplateFreeTalk => '韓語自由聊天';

  @override
  String get voiceRoomTemplatePronunciation => '發音練習';

  @override
  String get voiceRoomTemplateDailyKorean => '每日韓語';

  @override
  String get voiceRoomTemplateTopikSpeaking => 'TOPIK口說';

  @override
  String get voiceRoomCreateTooltip => '建立語音房間';

  @override
  String get voiceRoomSendReaction => '傳送表情';

  @override
  String get voiceRoomLeaveRoom => '離開房間';

  @override
  String get voiceRoomUnmuteMic => '取消麥克風靜音';

  @override
  String get voiceRoomMuteMic => '麥克風靜音';

  @override
  String get voiceRoomCancelHandRaise => '取消舉手';

  @override
  String get voiceRoomRaiseHandSemantic => '舉手';

  @override
  String get voiceRoomSendGesture => '傳送動作';

  @override
  String get voiceRoomLeaveStageAction => '離開舞台';

  @override
  String get voiceRoomManageStage => '管理舞台';

  @override
  String get voiceRoomMoreOptions => '更多選項';

  @override
  String get voiceRoomMore => '更多';

  @override
  String get voiceRoomStageWithSpeakers => '有發言人的語音房間舞台';

  @override
  String voiceRoomStageRequestsPending(int count) {
    return '上台請求，$count個待處理';
  }

  @override
  String voiceRoomSpeakerListenerCount(
      int speakers, int maxSpeakers, int listeners) {
    return '發言人 $speakers/$maxSpeakers，聽眾 $listeners';
  }

  @override
  String get voiceRoomChatInput => '聊天訊息輸入';

  @override
  String get voiceRoomSendMessage => '傳送訊息';

  @override
  String voiceRoomSendReactionNamed(Object name) {
    return '傳送$name表情';
  }

  @override
  String get voiceRoomCloseReactionTray => '關閉表情面板';

  @override
  String voiceRoomPerformGesture(Object name) {
    return '執行$name動作';
  }

  @override
  String get voiceRoomCloseGestureTray => '關閉動作面板';

  @override
  String get voiceRoomGestureWave => '揮手';

  @override
  String get voiceRoomGestureBow => '鞠躬';

  @override
  String get voiceRoomGestureDance => '跳舞';

  @override
  String get voiceRoomGestureJump => '跳躍';

  @override
  String get voiceRoomGestureClap => '鼓掌';

  @override
  String get voiceRoomStageLabel => '舞台';

  @override
  String get voiceRoomYouLabel => '（我）';

  @override
  String voiceRoomListenerTapToManage(Object name) {
    return '聽眾$name，點擊管理';
  }

  @override
  String voiceRoomListenerName(Object name) {
    return '聽眾$name';
  }

  @override
  String get voiceRoomMicPermissionDenied => '麥克風存取被拒絕。要使用語音功能，請在裝置設定中啟用。';

  @override
  String get voiceRoomMicPermissionTitle => '麥克風權限';

  @override
  String get voiceRoomOpenSettings => '開啟設定';

  @override
  String get voiceRoomMicNeededForStage => '上台發言需要麥克風權限';

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

  @override
  String get completedLessonsLabel => '已完成';

  @override
  String get wordsLearnedLabel => '已學單字';

  @override
  String get totalStudyTimeLabel => '學習時間';

  @override
  String get streakDetails => '連續學習記錄';

  @override
  String get consecutiveDays => '連續天數';

  @override
  String get totalStudyDaysLabel => '總學習天數';

  @override
  String get studyRecord => '學習記錄';

  @override
  String get noFriendsPrompt => '找朋友一起學習吧！';

  @override
  String get moreStats => '查看全部';

  @override
  String remainingLessons(int count) {
    return '再完成$count個即可達成今日目標！';
  }

  @override
  String get streakMotivation0 => '今天開始學習吧！';

  @override
  String get streakMotivation1 => '好的開始！繼續加油！';

  @override
  String get streakMotivation7 => '連續學習超過一週！太棒了！';

  @override
  String get streakMotivation14 => '堅持兩週了！正在養成習慣！';

  @override
  String get streakMotivation30 => '連續一個月以上！你是真正的學習者！';

  @override
  String minutesShort(int count) {
    return '$count分鐘';
  }

  @override
  String hoursShort(int count) {
    return '$count小時';
  }

  @override
  String get speechPractice => '發音練習';

  @override
  String get tapToRecord => '點擊錄音';

  @override
  String get recording => '錄音中...';

  @override
  String get analyzing => '分析中...';

  @override
  String get pronunciationScore => '發音分數';

  @override
  String get phonemeBreakdown => '音素分析';

  @override
  String tryAgainCount(String current, String max) {
    return '重試 ($current/$max)';
  }

  @override
  String get nextCharacter => '下一個字';

  @override
  String get excellentPronunciation => '太棒了！';

  @override
  String get goodPronunciation => '做得好！';

  @override
  String get fairPronunciation => '繼續加油！';

  @override
  String get needsMorePractice => '繼續練習！';

  @override
  String get downloadModels => '下載';

  @override
  String get modelDownloading => '正在下載模型';

  @override
  String get modelReady => '已就緒';

  @override
  String get modelNotReady => '未安裝';

  @override
  String get modelSize => '模型大小';

  @override
  String get speechModelTitle => '語音識別AI模型';

  @override
  String get skipSpeechPractice => '跳過';

  @override
  String get deleteModel => '刪除模型';

  @override
  String get overallScore => '綜合分數';

  @override
  String get appTagline => '像檸檬一樣清新，實力穩穩的！';

  @override
  String get passwordHint => '請輸入包含字母和數字的8位以上密碼';

  @override
  String get findAccount => '找回帳號';

  @override
  String get resetPassword => '重設密碼';

  @override
  String get registerTitle => '清新的韓語之旅，現在出發！';

  @override
  String get registerSubtitle => '輕鬆起步也沒關係！我會牢牢帶著你';

  @override
  String get nickname => '暱稱';

  @override
  String get nicknameHint => '15個字元以內：字母、數字、底線';

  @override
  String get confirmPasswordHint => '請再次輸入密碼';

  @override
  String get accountChoiceTitle => '歡迎！和莫尼一起\n建立學習習慣吧！';

  @override
  String get accountChoiceSubtitle => '清新出發，實力我來幫你守住！';

  @override
  String get startWithEmail => '使用電子郵件開始';

  @override
  String get deleteMessageTitle => '刪除訊息？';

  @override
  String get deleteMessageContent => '此訊息將對所有人刪除。';

  @override
  String get messageDeleted => '訊息已刪除';

  @override
  String get beFirstToPost => '來發第一則貼文吧！';

  @override
  String get typeTagHint => '輸入標籤...';

  @override
  String get userInfoLoadFailed => '載入使用者資訊失敗';

  @override
  String get loginErrorOccurred => '登入過程中發生錯誤';

  @override
  String get registerErrorOccurred => '註冊過程中發生錯誤';

  @override
  String get logoutErrorOccurred => '登出過程中發生錯誤';

  @override
  String get hangulStage0Title => '第0階段：理解韓文結構';

  @override
  String get hangulStage1Title => '第1階段：基本母音';

  @override
  String get hangulStage2Title => '第2階段：Y母音';

  @override
  String get hangulStage3Title => '第3階段：ㅐ/ㅔ母音';

  @override
  String get hangulStage4Title => '第4階段：基本子音1';

  @override
  String get hangulStage5Title => '第5階段：基本子音2';

  @override
  String get hangulStage6Title => '第6階段：音節組合訓練';

  @override
  String get hangulStage7Title => '第7階段：緊音/送氣音';

  @override
  String get hangulStage8Title => '第8階段：收音（終聲）1';

  @override
  String get hangulStage9Title => '第9階段：收音擴展';

  @override
  String get hangulStage10Title => '第10階段：複合收音';

  @override
  String get hangulStage11Title => '第11階段：擴展詞彙閱讀';

  @override
  String get sortAlphabetical => '字母順序';

  @override
  String get sortByLevel => '按級別';

  @override
  String get sortBySimilarity => '按相似度';

  @override
  String get searchWordsKoreanMeaning => '搜尋單詞（韓語/含義）';

  @override
  String get groupedView => '分組檢視';

  @override
  String get matrixView => '子音×母音';

  @override
  String get reviewLessons => '複習課程';

  @override
  String get stageDetailComingSoon => '詳細內容正在準備中。';

  @override
  String get bossQuizComingSoon => 'Boss測驗正在準備中。';

  @override
  String get exitLessonDialogTitle => '離開課程';

  @override
  String get exitLessonDialogContent => '要離開課程嗎？\n目前步驟的進度將自動儲存。';

  @override
  String get continueButton => '繼續';

  @override
  String get exitLessonButton => '離開';

  @override
  String get noQuestions => '沒有可用的問題';

  @override
  String get noCharactersDefined => '未定義字元';

  @override
  String get recordingStartFailed => '錄音啟動失敗';

  @override
  String get consonant => '子音';

  @override
  String get vowel => '母音';

  @override
  String get validationEmailRequired => '請輸入電子郵箱';

  @override
  String get validationEmailTooLong => '電子郵箱地址過長';

  @override
  String get validationEmailInvalid => '請輸入有效的電子郵箱地址';

  @override
  String get validationPasswordRequired => '請輸入密碼';

  @override
  String validationPasswordMinLength(int minLength) {
    return '密碼至少需要$minLength個字元';
  }

  @override
  String get validationPasswordNeedLetter => '密碼必須包含字母';

  @override
  String get validationPasswordNeedNumber => '密碼必須包含數字';

  @override
  String get validationPasswordNeedSpecial => '密碼必須包含特殊字元';

  @override
  String get validationPasswordTooLong => '密碼過長';

  @override
  String get validationConfirmPasswordRequired => '請再次輸入密碼';

  @override
  String get validationPasswordMismatch => '兩次輸入的密碼不一致';

  @override
  String get validationUsernameRequired => '請輸入使用者名稱';

  @override
  String validationUsernameTooShort(int minLength) {
    return '使用者名稱至少需要$minLength個字元';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return '使用者名稱不能超過$maxLength個字元';
  }

  @override
  String get validationUsernameInvalidChars => '使用者名稱只能包含字母、數字和底線';

  @override
  String validationFieldRequired(String fieldName) {
    return '請輸入$fieldName';
  }

  @override
  String validationFieldMinLength(String fieldName, int minLength) {
    return '$fieldName至少需要$minLength個字元';
  }

  @override
  String validationFieldMaxLength(String fieldName, int maxLength) {
    return '$fieldName不能超過$maxLength個字元';
  }

  @override
  String validationFieldNumeric(String fieldName) {
    return '$fieldName必須是數字';
  }

  @override
  String get errorNetworkConnection => '網路連線失敗，請檢查網路設定';

  @override
  String get errorServer => '伺服器錯誤，請稍後重試';

  @override
  String get errorAuthFailed => '驗證失敗，請重新登入';

  @override
  String get errorUnknown => '未知錯誤，請稍後重試';

  @override
  String get errorTimeout => '連線逾時，請檢查網路';

  @override
  String get errorRequestCancelled => '請求已取消';

  @override
  String get errorForbidden => '沒有存取權限';

  @override
  String get errorNotFound => '請求的資源不存在';

  @override
  String get errorRequestParam => '請求參數錯誤';

  @override
  String get errorParseData => '資料解析錯誤';

  @override
  String get errorParseFormat => '資料格式錯誤';

  @override
  String get errorRateLimited => '請求過多，請稍後重試';

  @override
  String get successLogin => '登入成功';

  @override
  String get successRegister => '註冊成功';

  @override
  String get successSync => '同步成功';

  @override
  String get successDownload => '下載成功';

  @override
  String get failedToCreateComment => '建立留言失敗';

  @override
  String get failedToDeleteComment => '刪除留言失敗';

  @override
  String get failedToSubmitReport => '提交檢舉失敗';

  @override
  String get failedToBlockUser => '封鎖使用者失敗';

  @override
  String get failedToUnblockUser => '解除封鎖使用者失敗';

  @override
  String get failedToCreatePost => '建立貼文失敗';

  @override
  String get failedToDeletePost => '刪除貼文失敗';

  @override
  String noVocabularyForLevel(int level) {
    return '未找到$level級詞彙';
  }

  @override
  String get uploadingImage => '[圖片上傳中...]';

  @override
  String get uploadingVoice => '[語音上傳中...]';

  @override
  String get imagePreview => '[圖片]';

  @override
  String get voicePreview => '[語音]';

  @override
  String get voiceServerConnectFailed => '無法連線語音伺服器，請檢查您的連線。';

  @override
  String get connectionLostRetry => '連線中斷，點擊重試。';

  @override
  String get noInternetConnection => '無網路連線，請檢查您的網路。';

  @override
  String get couldNotLoadRooms => '無法載入房間列表，請重試。';

  @override
  String get couldNotCreateRoom => '無法建立房間，請重試。';

  @override
  String get couldNotJoinRoom => '無法加入房間，請檢查您的連線。';

  @override
  String get roomClosedByHost => '主持人已關閉房間。';

  @override
  String get removedFromRoomByHost => '您已被主持人移出房間。';

  @override
  String get connectionTimedOut => '連線逾時，請重試。';

  @override
  String get missingLiveKitCredentials => '缺少語音連線憑證。';

  @override
  String get microphoneEnableFailed => '無法啟用麥克風。請檢查權限並嘗試取消靜音。';

  @override
  String get voiceRoomNewMessages => '新訊息';

  @override
  String get voiceRoomChatRateLimited => '訊息傳送過快，請稍候再試。';

  @override
  String get voiceRoomMessageSendFailed => '訊息傳送失敗，請重試。';

  @override
  String get voiceRoomChatError => '聊天發生錯誤。';

  @override
  String retryAttempt(int current, int max) {
    return '重試 ($current/$max)';
  }

  @override
  String get nextButton => '下一步';

  @override
  String get completeButton => '完成';

  @override
  String get startButton => '開始';

  @override
  String get doneButton => '完成';

  @override
  String get goBackButton => '返回';

  @override
  String get tapToListen => '點擊聽發音';

  @override
  String get listenAllSoundsFirst => '請先聽完所有發音';

  @override
  String get nextCharButton => '下一個字';

  @override
  String get listenAndChooseCorrect => '聽發音，選出正確的文字';

  @override
  String get lessonCompletedMsg => '你完成了課程！';

  @override
  String stageMasterLabel(int stage) {
    return '第$stage階段大師';
  }

  @override
  String get hangulS0L0Title => '韓文是怎麼來的？';

  @override
  String get hangulS0L0Subtitle => '簡單了解韓文的誕生過程';

  @override
  String get hangulS0L0Step0Title => '很久以前，學習文字非常困難';

  @override
  String get hangulS0L0Step0Desc => '古代朝鮮半島主要借用漢字書寫，\n但對一般百姓來說非常難以學習。';

  @override
  String get hangulS0L0Step0Highlights => '漢字,困難,閱讀,書寫';

  @override
  String get hangulS0L0Step1Title => '世宗大王創造了新的文字';

  @override
  String get hangulS0L0Step1Desc =>
      '為了讓百姓輕鬆學習，\n世宗大王親自創制了訓民正音。\n（1443年創制，1446年頒佈）';

  @override
  String get hangulS0L0Step1Highlights => '世宗大王,訓民正音,1443,1446';

  @override
  String get hangulS0L0Step2Title => '於是有了今天的韓文';

  @override
  String get hangulS0L0Step2Desc => '韓文是為了方便記錄聲音而創造的文字。\n在下一課中，我們將學習子音和母音的結構。';

  @override
  String get hangulS0L0Step2Highlights => '聲音,簡易文字,韓文';

  @override
  String get hangulS0L0SummaryTitle => '介紹課完成！';

  @override
  String get hangulS0L0SummaryMsg => '太棒了！\n現在你了解韓文的創造背景了。\n接下來學習子音和母音的結構吧！';

  @override
  String get hangulS0L1Title => '組裝가字塊';

  @override
  String get hangulS0L1Subtitle => '動手拖拉拼出韓文字';

  @override
  String get hangulS0L1IntroTitle => '韓文就像積木！';

  @override
  String get hangulS0L1IntroDesc =>
      '韓文透過組合子音和母音來構成文字。\n子音（ㄱ）+ 母音（ㅏ）= 가\n\n更複雜的文字下面還會有韻尾（받침）。\n（以後再學！）';

  @override
  String get hangulS0L1IntroHighlights => '子音,母音,文字';

  @override
  String get hangulS0L1DragGaTitle => '組裝가';

  @override
  String get hangulS0L1DragGaDesc => '將ㄱ和ㅏ拖到空格中';

  @override
  String get hangulS0L1DragNaTitle => '組裝나';

  @override
  String get hangulS0L1DragNaDesc => '試試使用新的子音ㄴ';

  @override
  String get hangulS0L1DragDaTitle => '組裝다';

  @override
  String get hangulS0L1DragDaDesc => '試試使用新的子音ㄷ';

  @override
  String get hangulS0L1SummaryTitle => '課程完成！';

  @override
  String get hangulS0L1SummaryMsg => '子音 + 母音 = 文字塊！\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다';

  @override
  String get hangulS0L2Title => '聲音探索';

  @override
  String get hangulS0L2Subtitle => '透過聲音感受子音和母音';

  @override
  String get hangulS0L2IntroTitle => '感受聲音';

  @override
  String get hangulS0L2IntroDesc => '韓文的每個子音和母音都有獨特的聲音。\n聽一聽，感受一下。';

  @override
  String get hangulS0L2Sound1Title => 'ㄱ、ㄴ、ㄷ的基本發音';

  @override
  String get hangulS0L2Sound1Desc => '聽一聽這些子音加上母音ㅏ的發音（가、나、다）';

  @override
  String get hangulS0L2Sound2Title => 'ㅏ、ㅗ母音發音';

  @override
  String get hangulS0L2Sound2Desc => '聽一聽這兩個母音的發音';

  @override
  String get hangulS0L2Sound3Title => '聽가、나、다的發音';

  @override
  String get hangulS0L2Sound3Desc => '聽一聽子音和母音組合而成的文字發音';

  @override
  String get hangulS0L2SummaryTitle => '課程完成！';

  @override
  String get hangulS0L2SummaryMsg =>
      '韓語子音通常配合母音ㅏ來練習發音（가、나、다），\n現在你對母音的發音也有感覺了！';

  @override
  String get hangulS0L3Title => '聽音選字';

  @override
  String get hangulS0L3Subtitle => '透過聲音區分文字';

  @override
  String get hangulS0L3IntroTitle => '這次用耳朵來分辨';

  @override
  String get hangulS0L3IntroDesc => '比起看螢幕，更要專注於聲音。\n聽音辨字，找出正確答案！';

  @override
  String get hangulS0L3Sound1Title => '確認가/나/다/고/노的發音';

  @override
  String get hangulS0L3Sound1Desc => '先好好聽一下這5個發音';

  @override
  String get hangulS0L3Match1Title => '聽音選擇相同的文字';

  @override
  String get hangulS0L3Match1Desc => '選出你聽到的是哪個字';

  @override
  String get hangulS0L3Match2Title => '區分ㅏ / ㅗ的發音';

  @override
  String get hangulS0L3Match2Desc => '子音相同時，靠母音來區分發音';

  @override
  String get hangulS0L3SummaryTitle => '課程完成！';

  @override
  String get hangulS0L3SummaryMsg => '太棒了！\n現在你可以同時用眼睛（組裝）和耳朵（聲音）\n來理解韓文的結構了。';

  @override
  String get hangulS0CompleteTitle => '第0階段完成！';

  @override
  String get hangulS0CompleteMsg => '你已經理解了韓文的結構！';

  @override
  String get hangulS1L1Title => 'ㅏ的形狀與讀音';

  @override
  String get hangulS1L1Subtitle => '豎線右側短橫: ㅏ';

  @override
  String get hangulS1L1Step0Title => '學習第一個母音ㅏ';

  @override
  String get hangulS1L1Step0Desc => 'ㅏ發出明亮的\"아\"音。\n讓我們一起學習形狀和讀音。';

  @override
  String get hangulS1L1Step0Highlights => 'ㅏ,아,基本母音';

  @override
  String get hangulS1L1Step1Title => '聽ㅏ的讀音';

  @override
  String get hangulS1L1Step1Desc => '聽聽含有ㅏ的讀音';

  @override
  String get hangulS1L1Step2Title => '發音練習';

  @override
  String get hangulS1L1Step2Desc => '請大聲朗讀這些文字';

  @override
  String get hangulS1L1Step3Title => '選出ㅏ的讀音';

  @override
  String get hangulS1L1Step3Desc => '聽音後選擇正確的文字';

  @override
  String get hangulS1L1Step4Title => '形狀測驗';

  @override
  String get hangulS1L1Step4Desc => '準確找出ㅏ';

  @override
  String get hangulS1L1Step4Q0 => '以下哪個是ㅏ？';

  @override
  String get hangulS1L1Step4Q1 => '以下哪個含有ㅏ？';

  @override
  String get hangulS1L1Step4Q2 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step5Title => '用ㅏ組字';

  @override
  String get hangulS1L1Step5Desc => '將子音與ㅏ組合完成文字';

  @override
  String get hangulS1L1Step6Title => '綜合測驗';

  @override
  String get hangulS1L1Step6Desc => '整理本節課所學內容';

  @override
  String get hangulS1L1Step6Q0 => '\"아\"的母音是什麼？';

  @override
  String get hangulS1L1Step6Q1 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step6Q2 => '以下哪個字含有ㅏ？';

  @override
  String get hangulS1L1Step6Q3 => '哪個音與ㅏ最不同？';

  @override
  String get hangulS1L1Step7Title => '課程完成！';

  @override
  String get hangulS1L1Step7Msg => '很好！\n你學會了ㅏ的形狀和讀音。';

  @override
  String get hangulS1L2Title => 'ㅓ的形狀與讀音';

  @override
  String get hangulS1L2Subtitle => '豎線左側短橫: ㅓ';

  @override
  String get hangulS1L2Step0Title => '第二個母音ㅓ';

  @override
  String get hangulS1L2Step0Desc => 'ㅓ發出\"어\"的音。\n注意筆畫方向與ㅏ相反。';

  @override
  String get hangulS1L2Step0Highlights => 'ㅓ,어,與ㅏ方向相反';

  @override
  String get hangulS1L2Step1Title => '聽ㅓ的讀音';

  @override
  String get hangulS1L2Step1Desc => '聽聽含有ㅓ的讀音';

  @override
  String get hangulS1L2Step2Title => '發音練習';

  @override
  String get hangulS1L2Step2Desc => '請大聲朗讀這些文字';

  @override
  String get hangulS1L2Step3Title => '選出ㅓ的讀音';

  @override
  String get hangulS1L2Step3Desc => '用耳朵區分ㅏ/ㅓ';

  @override
  String get hangulS1L2Step4Title => '形狀測驗';

  @override
  String get hangulS1L2Step4Desc => '找出ㅓ';

  @override
  String get hangulS1L2Step4Q0 => '以下哪個是ㅓ？';

  @override
  String get hangulS1L2Step4Q1 => 'ㅇ + ㅓ = ?';

  @override
  String get hangulS1L2Step4Q2 => '以下哪個字含有ㅓ？';

  @override
  String get hangulS1L2Step5Title => '用ㅓ組字';

  @override
  String get hangulS1L2Step5Desc => '將子音與ㅓ組合';

  @override
  String get hangulS1L2Step6Title => '課程完成！';

  @override
  String get hangulS1L2Step6Msg => '太棒了！\n你學會了ㅓ(어)的讀音。';

  @override
  String get hangulS1L3Title => 'ㅗ的形狀與讀音';

  @override
  String get hangulS1L3Subtitle => '橫線上方豎畫: ㅗ';

  @override
  String get hangulS1L3Step0Title => '第三個母音ㅗ';

  @override
  String get hangulS1L3Step0Desc => 'ㅗ發出\"오\"的音。\n豎畫向橫線上方延伸。';

  @override
  String get hangulS1L3Step0Highlights => 'ㅗ,오,橫型母音';

  @override
  String get hangulS1L3Step1Title => '聽ㅗ的讀音';

  @override
  String get hangulS1L3Step1Desc => '聽聽含有ㅗ的讀音（오/고/노）';

  @override
  String get hangulS1L3Step2Title => '發音練習';

  @override
  String get hangulS1L3Step2Desc => '請大聲朗讀這些文字';

  @override
  String get hangulS1L3Step3Title => '選出ㅗ的讀音';

  @override
  String get hangulS1L3Step3Desc => '區分오/우的讀音';

  @override
  String get hangulS1L3Step4Title => '用ㅗ組字';

  @override
  String get hangulS1L3Step4Desc => '將子音與ㅗ組合';

  @override
  String get hangulS1L3Step5Title => '形狀與讀音測驗';

  @override
  String get hangulS1L3Step5Desc => '準確選出ㅗ';

  @override
  String get hangulS1L3Step5Q0 => '以下哪個是ㅗ？';

  @override
  String get hangulS1L3Step5Q1 => 'ㅇ + ㅗ = ?';

  @override
  String get hangulS1L3Step5Q2 => '以下哪個含有ㅗ？';

  @override
  String get hangulS1L3Step6Title => '課程完成！';

  @override
  String get hangulS1L3Step6Msg => '很好！\n你學會了ㅗ(오)的讀音。';

  @override
  String get hangulS1L4Title => 'ㅜ的形狀與讀音';

  @override
  String get hangulS1L4Subtitle => '橫線下方豎畫: ㅜ';

  @override
  String get hangulS1L4Step0Title => '第四個母音ㅜ';

  @override
  String get hangulS1L4Step0Desc => 'ㅜ發出\"우\"的音。\n豎畫位置與ㅗ相反。';

  @override
  String get hangulS1L4Step0Highlights => 'ㅜ,우,與ㅗ位置對比';

  @override
  String get hangulS1L4Step1Title => '聽ㅜ的讀音';

  @override
  String get hangulS1L4Step1Desc => '聽聽우/구/누';

  @override
  String get hangulS1L4Step2Title => '發音練習';

  @override
  String get hangulS1L4Step2Desc => '請大聲朗讀這些文字';

  @override
  String get hangulS1L4Step3Title => '選出ㅜ的讀音';

  @override
  String get hangulS1L4Step3Desc => '區分ㅗ/ㅜ';

  @override
  String get hangulS1L4Step4Title => '用ㅜ組字';

  @override
  String get hangulS1L4Step4Desc => '將子音與ㅜ組合';

  @override
  String get hangulS1L4Step5Title => '形狀與讀音測驗';

  @override
  String get hangulS1L4Step5Desc => '準確選出ㅜ';

  @override
  String get hangulS1L4Step5Q0 => '以下哪個是ㅜ？';

  @override
  String get hangulS1L4Step5Q1 => 'ㅇ + ㅜ = ?';

  @override
  String get hangulS1L4Step5Q2 => '以下哪個含有ㅜ？';

  @override
  String get hangulS1L4Step6Title => '課程完成！';

  @override
  String get hangulS1L4Step6Msg => '很好！\n你學會了ㅜ(우)的讀音。';

  @override
  String get hangulS1L5Title => 'ㅡ的形狀與讀音';

  @override
  String get hangulS1L5Subtitle => '單橫線母音: ㅡ';

  @override
  String get hangulS1L5Step0Title => '第五個母音ㅡ';

  @override
  String get hangulS1L5Step0Desc => 'ㅡ是嘴巴橫向拉伸發出的音。\n形狀是一條橫線。';

  @override
  String get hangulS1L5Step0Highlights => 'ㅡ,으,單橫線';

  @override
  String get hangulS1L5Step1Title => '聽ㅡ的讀音';

  @override
  String get hangulS1L5Step1Desc => '聽聽으/그/느的讀音';

  @override
  String get hangulS1L5Step2Title => '發音練習';

  @override
  String get hangulS1L5Step2Desc => '請大聲朗讀這些文字';

  @override
  String get hangulS1L5Step3Title => '選出ㅡ的讀音';

  @override
  String get hangulS1L5Step3Desc => '區分ㅡ和ㅜ的讀音';

  @override
  String get hangulS1L5Step4Title => '用ㅡ組字';

  @override
  String get hangulS1L5Step4Desc => '將子音與ㅡ組合';

  @override
  String get hangulS1L5Step5Title => '形狀與讀音測驗';

  @override
  String get hangulS1L5Step5Desc => '準確選出ㅡ';

  @override
  String get hangulS1L5Step5Q0 => '以下哪個是ㅡ？';

  @override
  String get hangulS1L5Step5Q1 => 'ㅇ + ㅡ = ?';

  @override
  String get hangulS1L5Step5Q2 => '以下哪個含有ㅡ？';

  @override
  String get hangulS1L5Step6Title => '課程完成！';

  @override
  String get hangulS1L5Step6Msg => '很好！\n你學會了ㅡ(으)的讀音。';

  @override
  String get hangulS1L6Title => 'ㅣ的形狀與讀音';

  @override
  String get hangulS1L6Subtitle => '單豎線母音: ㅣ';

  @override
  String get hangulS1L6Step0Title => '第六個母音ㅣ';

  @override
  String get hangulS1L6Step0Desc => 'ㅣ發出\"이\"的音。\n形狀是一條豎線。';

  @override
  String get hangulS1L6Step0Highlights => 'ㅣ,이,單豎線';

  @override
  String get hangulS1L6Step1Title => '聽ㅣ的讀音';

  @override
  String get hangulS1L6Step1Desc => '聽聽이/기/니的讀音';

  @override
  String get hangulS1L6Step2Title => '發音練習';

  @override
  String get hangulS1L6Step2Desc => '請大聲朗讀這些文字';

  @override
  String get hangulS1L6Step3Title => '選出ㅣ的讀音';

  @override
  String get hangulS1L6Step3Desc => '區分ㅣ和ㅡ的讀音';

  @override
  String get hangulS1L6Step4Title => '用ㅣ組字';

  @override
  String get hangulS1L6Step4Desc => '將子音與ㅣ組合';

  @override
  String get hangulS1L6Step5Title => '形狀與讀音測驗';

  @override
  String get hangulS1L6Step5Desc => '準確選出ㅣ';

  @override
  String get hangulS1L6Step5Q0 => '以下哪個是ㅣ？';

  @override
  String get hangulS1L6Step5Q1 => 'ㅇ + ㅣ = ?';

  @override
  String get hangulS1L6Step5Q2 => '以下哪個含有ㅣ？';

  @override
  String get hangulS1L6Step6Title => '課程完成！';

  @override
  String get hangulS1L6Step6Msg => '很好！\n你學會了ㅣ(이)的讀音。';

  @override
  String get hangulS1L7Title => '縱向母音區分';

  @override
  String get hangulS1L7Subtitle => '快速區分 ㅏ · ㅓ · ㅣ';

  @override
  String get hangulS1L7Step0Title => '縱向母音組複習';

  @override
  String get hangulS1L7Step0Desc => 'ㅏ、ㅓ、ㅣ 是縱軸母音。\n一起區分筆畫位置和發音。';

  @override
  String get hangulS1L7Step0Highlights => 'ㅏ,ㅓ,ㅣ,縱向母音';

  @override
  String get hangulS1L7Step1Title => '再聽一遍';

  @override
  String get hangulS1L7Step1Desc => '確認 아/어/이 的發音';

  @override
  String get hangulS1L7Step2Title => '發音練習';

  @override
  String get hangulS1L7Step2Desc => '請大聲朗讀每個文字';

  @override
  String get hangulS1L7Step3Title => '縱向母音聽力測驗';

  @override
  String get hangulS1L7Step3Desc => '將聲音與正確文字對應';

  @override
  String get hangulS1L7Step4Title => '縱向母音形狀測驗';

  @override
  String get hangulS1L7Step4Desc => '精確區分各自的形狀';

  @override
  String get hangulS1L7Step4Q0 => '右側有短筆畫的是？';

  @override
  String get hangulS1L7Step4Q1 => '左側有短筆畫的是？';

  @override
  String get hangulS1L7Step4Q2 => '單縱線是？';

  @override
  String get hangulS1L7Step4Q3 => 'ㄴ + ㅓ = ?';

  @override
  String get hangulS1L7Step4Q4 => 'ㄱ + ㅣ = ?';

  @override
  String get hangulS1L7Step5Title => '課程完成！';

  @override
  String get hangulS1L7Step5Msg => '很好！\n縱向母音（ㅏ/ㅓ/ㅣ）的區分已經穩固了。';

  @override
  String get hangulS1L8Title => '橫向母音區分';

  @override
  String get hangulS1L8Subtitle => '快速區分 ㅗ · ㅜ · ㅡ';

  @override
  String get hangulS1L8Step0Title => '橫向母音組複習';

  @override
  String get hangulS1L8Step0Desc => 'ㅗ、ㅜ、ㅡ 是以橫軸為中心的母音。\n一起記住縱畫位置和嘴型。';

  @override
  String get hangulS1L8Step0Highlights => 'ㅗ,ㅜ,ㅡ,橫向母音';

  @override
  String get hangulS1L8Step1Title => '再聽一遍';

  @override
  String get hangulS1L8Step1Desc => '確認 오/우/으 的發音';

  @override
  String get hangulS1L8Step2Title => '發音練習';

  @override
  String get hangulS1L8Step2Desc => '請大聲朗讀每個文字';

  @override
  String get hangulS1L8Step3Title => '橫向母音聽力測驗';

  @override
  String get hangulS1L8Step3Desc => '將聲音與正確文字對應';

  @override
  String get hangulS1L8Step4Title => '橫向母音形狀測驗';

  @override
  String get hangulS1L8Step4Desc => '一起檢查形狀和發音';

  @override
  String get hangulS1L8Step4Q0 => '縱畫在橫線上方的是？';

  @override
  String get hangulS1L8Step4Q1 => '縱畫在橫線下方的是？';

  @override
  String get hangulS1L8Step4Q2 => '單橫線是？';

  @override
  String get hangulS1L8Step4Q3 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS1L8Step4Q4 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS1L8Step5Title => '課程完成！';

  @override
  String get hangulS1L8Step5Msg => '很好！\n橫向母音（ㅗ/ㅜ/ㅡ）的區分已經穩固了。';

  @override
  String get hangulS1L9Title => '基本母音任務';

  @override
  String get hangulS1L9Subtitle => '在時間限制內完成母音組合';

  @override
  String get hangulS1L9Step0Title => '第1階段最終任務';

  @override
  String get hangulS1L9Step0Desc => '在限定時間內完成文字組合。\n以準確率和速度獲得檸檬獎勵！';

  @override
  String get hangulS1L9Step1Title => '限時任務';

  @override
  String get hangulS1L9Step2Title => '任務結果';

  @override
  String get hangulS1L9Step3Title => '第1階段完成！';

  @override
  String get hangulS1L9Step3Msg => '恭喜！\n第1階段的基本母音全部完成了。';

  @override
  String get hangulS1L10Title => '第一批韓語單字！';

  @override
  String get hangulS1L10Subtitle => '用學過的文字閱讀真實單字';

  @override
  String get hangulS1L10Step0Title => '現在可以讀單字了！';

  @override
  String get hangulS1L10Step0Desc => '學會了母音和基本子音，\n來讀一讀真實的韓語單字吧？';

  @override
  String get hangulS1L10Step0Highlights => '真實單字,閱讀挑戰';

  @override
  String get hangulS1L10Step1Title => '閱讀第一批單字';

  @override
  String get hangulS1L10Step1Descs => '孩子,牛奶,小黃瓜,這/牙齒,弟弟';

  @override
  String get hangulS1L10Step2Title => '發音練習';

  @override
  String get hangulS1L10Step2Desc => '請大聲朗讀每個文字';

  @override
  String get hangulS1L10Step3Title => '聽一聽，選一選';

  @override
  String get hangulS1L10Step4Title => '太棒了！';

  @override
  String get hangulS1L10Step4Msg => '你讀出了韓語單字！\n再學更多子音，\n就能讀更多單字了。';

  @override
  String get hangulS1CompleteTitle => '第1階段完成！';

  @override
  String get hangulS1CompleteMsg => '你已掌握全部6個基本母音！';

  @override
  String get hangulS2L1Title => 'ㅑ的形狀與發音';

  @override
  String get hangulS2L1Subtitle => 'ㅏ加一筆: ㅑ';

  @override
  String get hangulS2L1Step0Title => 'ㅏ變成ㅑ';

  @override
  String get hangulS2L1Step0Desc => '在ㅏ上加一筆就得到ㅑ。\n發音從\"啊\"變成更有彈性的\"呀\"。';

  @override
  String get hangulS2L1Step0Highlights => 'ㅏ → ㅑ,야,Y母音';

  @override
  String get hangulS2L1Step1Title => '聽ㅑ的發音';

  @override
  String get hangulS2L1Step1Desc => '聽聽야/갸/냐的發音';

  @override
  String get hangulS2L1Step2Title => '發音練習';

  @override
  String get hangulS2L1Step2Desc => '大聲朗讀每個字';

  @override
  String get hangulS2L1Step3Title => '聽辨ㅏ vs ㅑ';

  @override
  String get hangulS2L1Step3Desc => '區分相似的發音';

  @override
  String get hangulS2L1Step4Title => '用ㅑ組成音節';

  @override
  String get hangulS2L1Step4Desc => '完成子音 + ㅑ 的組合';

  @override
  String get hangulS2L1Step5Title => '形狀與發音測驗';

  @override
  String get hangulS2L1Step5Desc => '準確選出ㅑ';

  @override
  String get hangulS2L1Step5Q0 => '以下哪個是ㅑ？';

  @override
  String get hangulS2L1Step5Q1 => 'ㅇ + ㅑ = ?';

  @override
  String get hangulS2L1Step5Q2 => '以下哪個含有ㅑ？';

  @override
  String get hangulS2L1Step6Title => '課程完成！';

  @override
  String get hangulS2L1Step6Msg => '太棒了！\n你已掌握ㅑ（야）的發音。';

  @override
  String get hangulS2L2Title => 'ㅕ的形狀與發音';

  @override
  String get hangulS2L2Subtitle => 'ㅓ加一筆: ㅕ';

  @override
  String get hangulS2L2Step0Title => 'ㅓ變成ㅕ';

  @override
  String get hangulS2L2Step0Desc => '在ㅓ上加一筆就得到ㅕ。\n發音從\"哦\"變成\"喲\"。';

  @override
  String get hangulS2L2Step0Highlights => 'ㅓ → ㅕ,여,Y母音';

  @override
  String get hangulS2L2Step1Title => '聽ㅕ的發音';

  @override
  String get hangulS2L2Step1Desc => '聽聽여/겨/녀的發音';

  @override
  String get hangulS2L2Step2Title => '發音練習';

  @override
  String get hangulS2L2Step2Desc => '大聲朗讀每個字';

  @override
  String get hangulS2L2Step3Title => '聽辨ㅓ vs ㅕ';

  @override
  String get hangulS2L2Step3Desc => '區分어和여';

  @override
  String get hangulS2L2Step4Title => '用ㅕ組成音節';

  @override
  String get hangulS2L2Step4Desc => '完成子音 + ㅕ 的組合';

  @override
  String get hangulS2L2Step5Title => '課程完成！';

  @override
  String get hangulS2L2Step5Msg => '太棒了！\n你已掌握ㅕ（여）的發音。';

  @override
  String get hangulS2L3Title => 'ㅛ的形狀與發音';

  @override
  String get hangulS2L3Subtitle => 'ㅗ加一筆: ㅛ';

  @override
  String get hangulS2L3Step0Title => 'ㅗ變成ㅛ';

  @override
  String get hangulS2L3Step0Desc => '在ㅗ上加一筆就得到ㅛ。\n發音從\"哦\"變成\"喲\"。';

  @override
  String get hangulS2L3Step0Highlights => 'ㅗ → ㅛ,요,Y母音';

  @override
  String get hangulS2L3Step1Title => '聽ㅛ的發音';

  @override
  String get hangulS2L3Step1Desc => '聽聽요/교/뇨的發音';

  @override
  String get hangulS2L3Step2Title => '發音練習';

  @override
  String get hangulS2L3Step2Desc => '大聲朗讀每個字';

  @override
  String get hangulS2L3Step3Title => '聽辨ㅗ vs ㅛ';

  @override
  String get hangulS2L3Step3Desc => '區分오和요';

  @override
  String get hangulS2L3Step4Title => '用ㅛ組成音節';

  @override
  String get hangulS2L3Step4Desc => '完成子音 + ㅛ 的組合';

  @override
  String get hangulS2L3Step5Title => '課程完成！';

  @override
  String get hangulS2L3Step5Msg => '太棒了！\n你已掌握ㅛ（요）的發音。';

  @override
  String get hangulS2L4Title => 'ㅠ的形狀與發音';

  @override
  String get hangulS2L4Subtitle => 'ㅜ加一筆: ㅠ';

  @override
  String get hangulS2L4Step0Title => 'ㅜ變成ㅠ';

  @override
  String get hangulS2L4Step0Desc => '在ㅜ上加一筆就得到ㅠ。\n發音從\"嗚\"變成\"魚\"。';

  @override
  String get hangulS2L4Step0Highlights => 'ㅜ → ㅠ,유,Y母音';

  @override
  String get hangulS2L4Step1Title => '聽ㅠ的發音';

  @override
  String get hangulS2L4Step1Desc => '聽聽유/규/뉴的發音';

  @override
  String get hangulS2L4Step2Title => '發音練習';

  @override
  String get hangulS2L4Step2Desc => '大聲朗讀每個字';

  @override
  String get hangulS2L4Step3Title => '聽辨ㅜ vs ㅠ';

  @override
  String get hangulS2L4Step3Desc => '區分우和유';

  @override
  String get hangulS2L4Step4Title => '用ㅠ組成音節';

  @override
  String get hangulS2L4Step4Desc => '完成子音 + ㅠ 的組合';

  @override
  String get hangulS2L4Step5Title => '課程完成！';

  @override
  String get hangulS2L4Step5Msg => '太棒了！\n你已掌握ㅠ（유）的發音。';

  @override
  String get hangulS2L5Title => 'Y母音組合訓練';

  @override
  String get hangulS2L5Subtitle => 'ㅑ · ㅕ · ㅛ · ㅠ 強化訓練';

  @override
  String get hangulS2L5Step0Title => '一次看清所有Y母音';

  @override
  String get hangulS2L5Step0Desc => 'ㅑ/ㅕ/ㅛ/ㅠ是基礎母音加一筆的母音。\n快速區分它們的形狀和發音。';

  @override
  String get hangulS2L5Step0Highlights => 'ㅑ,ㅕ,ㅛ,ㅠ';

  @override
  String get hangulS2L5Step1Title => '再聽四個發音';

  @override
  String get hangulS2L5Step1Desc => '複習야/여/요/유的發音';

  @override
  String get hangulS2L5Step2Title => '發音練習';

  @override
  String get hangulS2L5Step2Desc => '大聲朗讀每個字';

  @override
  String get hangulS2L5Step3Title => '發音辨別測驗';

  @override
  String get hangulS2L5Step3Desc => '區分Y母音的發音';

  @override
  String get hangulS2L5Step4Title => '形狀辨別測驗';

  @override
  String get hangulS2L5Step4Desc => '準確區分形狀';

  @override
  String get hangulS2L5Step4Q0 => '以下哪個是ㅑ？';

  @override
  String get hangulS2L5Step4Q1 => '以下哪個是ㅕ？';

  @override
  String get hangulS2L5Step4Q2 => '以下哪個是ㅛ？';

  @override
  String get hangulS2L5Step4Q3 => '以下哪個是ㅠ？';

  @override
  String get hangulS2L5Step5Title => '課程完成！';

  @override
  String get hangulS2L5Step5Msg => '太棒了！\n你對4個Y母音的區分越來越好了。';

  @override
  String get hangulS2L6Title => '基礎母音 vs Y母音對比';

  @override
  String get hangulS2L6Subtitle => 'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ';

  @override
  String get hangulS2L6Step0Title => '整理容易混淆的配對';

  @override
  String get hangulS2L6Step0Desc => '將基礎母音和Y母音配對比較。';

  @override
  String get hangulS2L6Step0Highlights => 'ㅏ/ㅑ,ㅓ/ㅕ,ㅗ/ㅛ,ㅜ/ㅠ';

  @override
  String get hangulS2L6Step1Title => '配對發音辨別';

  @override
  String get hangulS2L6Step1Desc => '從相似的發音中選出正確答案';

  @override
  String get hangulS2L6Step2Title => '配對形狀辨別';

  @override
  String get hangulS2L6Step2Desc => '判斷是否有額外的一筆';

  @override
  String get hangulS2L6Step2Q0 => '哪個母音加了一筆？';

  @override
  String get hangulS2L6Step2Q1 => '哪個母音加了一筆？';

  @override
  String get hangulS2L6Step2Q2 => '哪個母音加了一筆？';

  @override
  String get hangulS2L6Step2Q3 => '哪個母音加了一筆？';

  @override
  String get hangulS2L6Step2Q4 => 'ㅇ + ㅠ = ?';

  @override
  String get hangulS2L6Step3Title => '課程完成！';

  @override
  String get hangulS2L6Step3Msg => '太棒了！\n基礎母音/Y母音對比已經穩定了。';

  @override
  String get hangulS2L7Title => 'Y母音任務';

  @override
  String get hangulS2L7Subtitle => '在限時內完成Y母音組合';

  @override
  String get hangulS2L7Step0Title => '第2階段最終任務';

  @override
  String get hangulS2L7Step0Desc => '快速準確地完成Y母音組合。\n完成數和時間決定你的檸檬獎勵。';

  @override
  String get hangulS2L7Step1Title => '限時任務';

  @override
  String get hangulS2L7Step2Title => '任務結果';

  @override
  String get hangulS2L7Step3Title => '第2階段完成！';

  @override
  String get hangulS2L7Step3Msg => '恭喜！\n你已完成第2階段所有Y母音。';

  @override
  String get hangulS2CompleteTitle => '第2階段完成！';

  @override
  String get hangulS2CompleteMsg => '你已征服Y母音！';

  @override
  String get hangulS3L1Title => 'ㅐ的形狀和發音';

  @override
  String get hangulS3L1Subtitle => '感受ㅏ + ㅣ的組合感覺';

  @override
  String get hangulS3L1Step0Title => 'ㅐ是這個樣子';

  @override
  String get hangulS3L1Step0Desc => 'ㅐ是從ㅏ系列派生的母音。\n以\"애\"為代表音來記憶。';

  @override
  String get hangulS3L1Step0Highlights => 'ㅐ,애,形狀識別';

  @override
  String get hangulS3L1Step1Title => '聽ㅐ的發音';

  @override
  String get hangulS3L1Step1Desc => '聽聽애/개/내的發音';

  @override
  String get hangulS3L1Step2Title => '發音練習';

  @override
  String get hangulS3L1Step2Desc => '請直接把文字發出聲來';

  @override
  String get hangulS3L1Step3Title => '聽辨ㅏ vs ㅐ';

  @override
  String get hangulS3L1Step3Desc => '區分아/애';

  @override
  String get hangulS3L1Step4Title => '課程完成！';

  @override
  String get hangulS3L1Step4Msg => '很好！\n已掌握ㅐ(애)的形狀和發音。';

  @override
  String get hangulS3L2Title => 'ㅔ的形狀和發音';

  @override
  String get hangulS3L2Subtitle => '感受ㅓ + ㅣ的組合感覺';

  @override
  String get hangulS3L2Step0Title => 'ㅔ是這個樣子';

  @override
  String get hangulS3L2Step0Desc => 'ㅔ是從ㅓ系列派生的母音。\n以\"에\"為代表音來記憶。';

  @override
  String get hangulS3L2Step0Highlights => 'ㅔ,에,形狀識別';

  @override
  String get hangulS3L2Step1Title => '聽ㅔ的發音';

  @override
  String get hangulS3L2Step1Desc => '聽聽에/게/네的發音';

  @override
  String get hangulS3L2Step2Title => '發音練習';

  @override
  String get hangulS3L2Step2Desc => '請直接把文字發出聲來';

  @override
  String get hangulS3L2Step3Title => '聽辨ㅓ vs ㅔ';

  @override
  String get hangulS3L2Step3Desc => '區分어/에';

  @override
  String get hangulS3L2Step4Title => '課程完成！';

  @override
  String get hangulS3L2Step4Msg => '很好！\n已掌握ㅔ(에)的形狀和發音。';

  @override
  String get hangulS3L3Title => '區分ㅐ vs ㅔ';

  @override
  String get hangulS3L3Subtitle => '以形狀為中心的區分訓練';

  @override
  String get hangulS3L3Step0Title => '關鍵在於區分形狀';

  @override
  String get hangulS3L3Step0Desc => '在初級階段，ㅐ/ㅔ聽起來可能很相似。\n所以先準確區分它們的形狀。';

  @override
  String get hangulS3L3Step0Highlights => 'ㅐ,ㅔ,形狀區分';

  @override
  String get hangulS3L3Step1Title => '形狀區分測驗';

  @override
  String get hangulS3L3Step1Desc => '準確選擇ㅐ和ㅔ';

  @override
  String get hangulS3L3Step1Q0 => '下列哪個是ㅐ？';

  @override
  String get hangulS3L3Step1Q1 => '下列哪個是ㅔ？';

  @override
  String get hangulS3L3Step1Q2 => 'ㅇ + ㅐ = ?';

  @override
  String get hangulS3L3Step1Q3 => 'ㅇ + ㅔ = ?';

  @override
  String get hangulS3L3Step2Title => '課程完成！';

  @override
  String get hangulS3L3Step2Msg => '很好！\nㅐ/ㅔ的區分更準確了。';

  @override
  String get hangulS3L4Title => 'ㅒ的形狀和發音';

  @override
  String get hangulS3L4Subtitle => 'Y-ㅐ系列母音';

  @override
  String get hangulS3L4Step0Title => '來學ㅒ吧';

  @override
  String get hangulS3L4Step0Desc => 'ㅒ是ㅐ系列的Y母音。\n代表音是\"얘\"。';

  @override
  String get hangulS3L4Step0Highlights => 'ㅒ,얘';

  @override
  String get hangulS3L4Step1Title => '聽ㅒ的發音';

  @override
  String get hangulS3L4Step1Desc => '聽聽얘/걔/냬的發音';

  @override
  String get hangulS3L4Step2Title => '發音練習';

  @override
  String get hangulS3L4Step2Desc => '請直接把文字發出聲來';

  @override
  String get hangulS3L4Step3Title => '課程完成！';

  @override
  String get hangulS3L4Step3Msg => '很好！\n已掌握ㅒ(얘)的形狀。';

  @override
  String get hangulS3L5Title => 'ㅖ的形狀和發音';

  @override
  String get hangulS3L5Subtitle => 'Y-ㅔ系列母音';

  @override
  String get hangulS3L5Step0Title => '來學ㅖ吧';

  @override
  String get hangulS3L5Step0Desc => 'ㅖ是ㅔ系列的Y母音。\n代表音是\"예\"。';

  @override
  String get hangulS3L5Step0Highlights => 'ㅖ,예';

  @override
  String get hangulS3L5Step1Title => '聽ㅖ的發音';

  @override
  String get hangulS3L5Step1Desc => '聽聽예/계/녜的發音';

  @override
  String get hangulS3L5Step2Title => '發音練習';

  @override
  String get hangulS3L5Step2Desc => '請直接把文字發出聲來';

  @override
  String get hangulS3L5Step3Title => '課程完成！';

  @override
  String get hangulS3L5Step3Msg => '很好！\n已掌握ㅖ(예)的形狀。';

  @override
  String get hangulS3L6Title => 'ㅐ/ㅔ系列綜合複習';

  @override
  String get hangulS3L6Subtitle => 'ㅐ ㅔ ㅒ ㅖ綜合檢驗';

  @override
  String get hangulS3L6Step0Title => '一次性區分四種';

  @override
  String get hangulS3L6Step0Desc => '同時用形狀和發音來檢驗ㅐ/ㅔ/ㅒ/ㅖ。';

  @override
  String get hangulS3L6Step0Highlights => 'ㅐ,ㅔ,ㅒ,ㅖ';

  @override
  String get hangulS3L6Step1Title => '聲音區分';

  @override
  String get hangulS3L6Step1Desc => '從相似的聲音中選出正確答案';

  @override
  String get hangulS3L6Step2Title => '形狀區分';

  @override
  String get hangulS3L6Step2Desc => '看形狀，快速選擇';

  @override
  String get hangulS3L6Step2Q0 => '下列哪個屬於Y-ㅐ系列？';

  @override
  String get hangulS3L6Step2Q1 => '下列哪個屬於Y-ㅔ系列？';

  @override
  String get hangulS3L6Step2Q2 => 'ㅇ + ㅖ = ?';

  @override
  String get hangulS3L6Step3Title => '課程完成！';

  @override
  String get hangulS3L6Step3Msg => '很好！\n第3階段核心母音的區分已經穩固了。';

  @override
  String get hangulS3L7Title => '第3階段任務';

  @override
  String get hangulS3L7Subtitle => '快速區分任務：ㅐ/ㅔ系列';

  @override
  String get hangulS3L7Step0Title => '第3階段最終任務';

  @override
  String get hangulS3L7Step0Desc => '快速準確地完成ㅐ/ㅔ系列的組合。';

  @override
  String get hangulS3L7Step1Title => '限時任務';

  @override
  String get hangulS3L7Step2Title => '任務結果';

  @override
  String get hangulS3L7Step3Title => '第3階段完成！';

  @override
  String get hangulS3L7Step3Msg => '恭喜！\n已完成第3階段全部ㅐ/ㅔ系列母音。';

  @override
  String get hangulS3L7Step4Title => '第3階段完成！';

  @override
  String get hangulS3L7Step4Msg => '已學完所有母音！';

  @override
  String get hangulS3CompleteTitle => '第3階段完成！';

  @override
  String get hangulS3CompleteMsg => '已學完所有母音！';

  @override
  String get hangulS4L1Title => 'ㄱ的形狀與發音';

  @override
  String get hangulS4L1Subtitle => '基本子音的開始：ㄱ';

  @override
  String get hangulS4L1Step0Title => '來學ㄱ吧';

  @override
  String get hangulS4L1Step0Desc => 'ㄱ是基本子音的開始。\n與ㅏ組合發出「가」的音。';

  @override
  String get hangulS4L1Step0Highlights => 'ㄱ,가,基本子音';

  @override
  String get hangulS4L1Step1Title => '聽ㄱ的發音';

  @override
  String get hangulS4L1Step1Desc => '聽聽가/고/구的發音';

  @override
  String get hangulS4L1Step2Title => '發音練習';

  @override
  String get hangulS4L1Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L1Step3Title => '選出ㄱ的發音';

  @override
  String get hangulS4L1Step3Desc => '聽音選出正確的字';

  @override
  String get hangulS4L1Step4Title => '用ㄱ組合文字';

  @override
  String get hangulS4L1Step4Desc => '試試ㄱ＋母音的組合';

  @override
  String get hangulS4L1SummaryTitle => '課程完成！';

  @override
  String get hangulS4L1SummaryMsg => '很棒！\n你已經掌握了ㄱ的發音和形狀。';

  @override
  String get hangulS4L2Title => 'ㄴ的形狀與發音';

  @override
  String get hangulS4L2Subtitle => '第二個基本子音：ㄴ';

  @override
  String get hangulS4L2Step0Title => '來學ㄴ吧';

  @override
  String get hangulS4L2Step0Desc => 'ㄴ構成「나」系列發音。';

  @override
  String get hangulS4L2Step0Highlights => 'ㄴ,나';

  @override
  String get hangulS4L2Step1Title => '聽ㄴ的發音';

  @override
  String get hangulS4L2Step1Desc => '聽聽나/노/누的發音';

  @override
  String get hangulS4L2Step2Title => '發音練習';

  @override
  String get hangulS4L2Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L2Step3Title => '選出ㄴ的發音';

  @override
  String get hangulS4L2Step3Desc => '區分나/다';

  @override
  String get hangulS4L2Step4Title => '用ㄴ組合文字';

  @override
  String get hangulS4L2Step4Desc => '試試ㄴ＋母音的組合';

  @override
  String get hangulS4L2SummaryTitle => '課程完成！';

  @override
  String get hangulS4L2SummaryMsg => '很棒！\n你已經掌握了ㄴ的發音和形狀。';

  @override
  String get hangulS4L3Title => 'ㄷ的形狀與發音';

  @override
  String get hangulS4L3Subtitle => '第三個基本子音：ㄷ';

  @override
  String get hangulS4L3Step0Title => '來學ㄷ吧';

  @override
  String get hangulS4L3Step0Desc => 'ㄷ構成「다」系列發音。';

  @override
  String get hangulS4L3Step0Highlights => 'ㄷ,다';

  @override
  String get hangulS4L3Step1Title => '聽ㄷ的發音';

  @override
  String get hangulS4L3Step1Desc => '聽聽다/도/두的發音';

  @override
  String get hangulS4L3Step2Title => '發音練習';

  @override
  String get hangulS4L3Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L3Step3Title => '選出ㄷ的發音';

  @override
  String get hangulS4L3Step3Desc => '區分다/나';

  @override
  String get hangulS4L3Step4Title => '用ㄷ組合文字';

  @override
  String get hangulS4L3Step4Desc => '試試ㄷ＋母音的組合';

  @override
  String get hangulS4L3SummaryTitle => '課程完成！';

  @override
  String get hangulS4L3SummaryMsg => '很棒！\n你已經掌握了ㄷ的發音和形狀。';

  @override
  String get hangulS4L4Title => 'ㄹ的形狀與發音';

  @override
  String get hangulS4L4Subtitle => '第四個基本子音：ㄹ';

  @override
  String get hangulS4L4Step0Title => '來學ㄹ吧';

  @override
  String get hangulS4L4Step0Desc => 'ㄹ構成「라」系列發音。';

  @override
  String get hangulS4L4Step0Highlights => 'ㄹ,라';

  @override
  String get hangulS4L4Step1Title => '聽ㄹ的發音';

  @override
  String get hangulS4L4Step1Desc => '聽聽라/로/루的發音';

  @override
  String get hangulS4L4Step2Title => '發音練習';

  @override
  String get hangulS4L4Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L4Step3Title => '選出ㄹ的發音';

  @override
  String get hangulS4L4Step3Desc => '區分라/나';

  @override
  String get hangulS4L4Step4Title => '用ㄹ組合文字';

  @override
  String get hangulS4L4Step4Desc => '試試ㄹ＋母音的組合';

  @override
  String get hangulS4L4SummaryTitle => '課程完成！';

  @override
  String get hangulS4L4SummaryMsg => '很棒！\n你已經掌握了ㄹ的發音和形狀。';

  @override
  String get hangulS4L5Title => 'ㅁ的形狀與發音';

  @override
  String get hangulS4L5Subtitle => '第五個基本子音：ㅁ';

  @override
  String get hangulS4L5Step0Title => '來學ㅁ吧';

  @override
  String get hangulS4L5Step0Desc => 'ㅁ構成「마」系列發音。';

  @override
  String get hangulS4L5Step0Highlights => 'ㅁ,마';

  @override
  String get hangulS4L5Step1Title => '聽ㅁ的發音';

  @override
  String get hangulS4L5Step1Desc => '聽聽마/모/무的發音';

  @override
  String get hangulS4L5Step2Title => '發音練習';

  @override
  String get hangulS4L5Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L5Step3Title => '選出ㅁ的發音';

  @override
  String get hangulS4L5Step3Desc => '區分마/바';

  @override
  String get hangulS4L5Step4Title => '用ㅁ組合文字';

  @override
  String get hangulS4L5Step4Desc => '試試ㅁ＋母音的組合';

  @override
  String get hangulS4L5SummaryTitle => '課程完成！';

  @override
  String get hangulS4L5SummaryMsg => '很棒！\n你已經掌握了ㅁ的發音和形狀。';

  @override
  String get hangulS4L6Title => 'ㅂ的形狀與發音';

  @override
  String get hangulS4L6Subtitle => '第六個基本子音：ㅂ';

  @override
  String get hangulS4L6Step0Title => '來學ㅂ吧';

  @override
  String get hangulS4L6Step0Desc => 'ㅂ構成「바」系列發音。';

  @override
  String get hangulS4L6Step0Highlights => 'ㅂ,바';

  @override
  String get hangulS4L6Step1Title => '聽ㅂ的發音';

  @override
  String get hangulS4L6Step1Desc => '聽聽바/보/부的發音';

  @override
  String get hangulS4L6Step2Title => '發音練習';

  @override
  String get hangulS4L6Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L6Step3Title => '選出ㅂ的發音';

  @override
  String get hangulS4L6Step3Desc => '區分바/마';

  @override
  String get hangulS4L6Step4Title => '用ㅂ組合文字';

  @override
  String get hangulS4L6Step4Desc => '試試ㅂ＋母音的組合';

  @override
  String get hangulS4L6SummaryTitle => '課程完成！';

  @override
  String get hangulS4L6SummaryMsg => '很棒！\n你已經掌握了ㅂ的發音和形狀。';

  @override
  String get hangulS4L7Title => 'ㅅ的形狀與發音';

  @override
  String get hangulS4L7Subtitle => '第七個基本子音：ㅅ';

  @override
  String get hangulS4L7Step0Title => '來學ㅅ吧';

  @override
  String get hangulS4L7Step0Desc => 'ㅅ構成「사」系列發音。';

  @override
  String get hangulS4L7Step0Highlights => 'ㅅ,사';

  @override
  String get hangulS4L7Step1Title => '聽ㅅ的發音';

  @override
  String get hangulS4L7Step1Desc => '聽聽사/소/수的發音';

  @override
  String get hangulS4L7Step2Title => '發音練習';

  @override
  String get hangulS4L7Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L7Step3Title => '選出ㅅ的發音';

  @override
  String get hangulS4L7Step3Desc => '區分사/자';

  @override
  String get hangulS4L7Step4Title => '用ㅅ組合文字';

  @override
  String get hangulS4L7Step4Desc => '試試ㅅ＋母音的組合';

  @override
  String get hangulS4L7SummaryTitle => '第4階段完成！';

  @override
  String get hangulS4L7SummaryMsg => '恭喜！\n你完成了第4階段基本子音1（ㄱ~ㅅ）。';

  @override
  String get hangulS4L8Title => '單字閱讀挑戰！';

  @override
  String get hangulS4L8Subtitle => '用子音和母音讀單字';

  @override
  String get hangulS4L8Step0Title => '現在你能讀更多單字了！';

  @override
  String get hangulS4L8Step0Desc => '你已經學完了全部7個基本子音和母音。\n來讀讀由這些字組成的真實單字吧？';

  @override
  String get hangulS4L8Step0Highlights => '7個子音,母音,真實單字';

  @override
  String get hangulS4L8Step1Title => '讀單字';

  @override
  String get hangulS4L8Step1Descs => '樹,海,蝴蝶,帽子,家具,豆腐';

  @override
  String get hangulS4L8Step2Title => '發音練習';

  @override
  String get hangulS4L8Step2Desc => '試著大聲讀出這些字';

  @override
  String get hangulS4L8Step3Title => '聽後選出';

  @override
  String get hangulS4L8Step4Title => '是什麼意思？';

  @override
  String get hangulS4L8Step4Q0 => '\"나비\"的中文是？';

  @override
  String get hangulS4L8Step4Q1 => '\"바다\"的中文是？';

  @override
  String get hangulS4L8SummaryTitle => '太棒了！';

  @override
  String get hangulS4L8SummaryMsg => '你讀了6個韓文單字！\n繼續學習更多子音，就能讀出更多單字。';

  @override
  String get hangulS4LMTitle => '任務：基本子音組合！';

  @override
  String get hangulS4LMSubtitle => '在時間限制內組合音節';

  @override
  String get hangulS4LMStep0Title => '任務開始！';

  @override
  String get hangulS4LMStep0Desc => '將基本子音ㄱ~ㅅ與母音組合。\n在限定時間內達成目標！';

  @override
  String get hangulS4LMStep1Title => '來組合音節吧！';

  @override
  String get hangulS4LMStep2Title => '任務結果';

  @override
  String get hangulS4LMSummaryTitle => '任務完成！';

  @override
  String get hangulS4LMSummaryMsg => '你可以自由組合全部7個基本子音了！';

  @override
  String get hangulS4CompleteTitle => '第4階段完成！';

  @override
  String get hangulS4CompleteMsg => '你已掌握全部7個基本子音！';

  @override
  String get hangulS5L1Title => '理解ㅇ的位置';

  @override
  String get hangulS5L1Subtitle => '學習初聲ㅇ的讀法';

  @override
  String get hangulS5L1Step0Title => 'ㅇ是特殊子音';

  @override
  String get hangulS5L1Step0Desc => '初聲ㅇ幾乎沒有聲音，\n與母音結合後讀作아/오/우。';

  @override
  String get hangulS5L1Step0Highlights => 'ㅇ,아,初聲位置';

  @override
  String get hangulS5L1Step1Title => '聆聽ㅇ的組合音';

  @override
  String get hangulS5L1Step1Desc => '聽一聽아/오/우的發音';

  @override
  String get hangulS5L1Step2Title => '發音練習';

  @override
  String get hangulS5L1Step2Desc => '大聲朗讀每個文字';

  @override
  String get hangulS5L1Step3Title => '用ㅇ組字';

  @override
  String get hangulS5L1Step3Desc => '組合ㅇ + 母音';

  @override
  String get hangulS5L1Step4Title => '課程完成！';

  @override
  String get hangulS5L1Step4Msg => '太棒了！\n你已經理解了ㅇ的用法。';

  @override
  String get hangulS5L2Title => 'ㅈ的形狀與發音';

  @override
  String get hangulS5L2Subtitle => 'ㅈ的基礎讀法';

  @override
  String get hangulS5L2Step0Title => '學習ㅈ';

  @override
  String get hangulS5L2Step0Desc => 'ㅈ產生「자」系列的音。';

  @override
  String get hangulS5L2Step0Highlights => 'ㅈ,자';

  @override
  String get hangulS5L2Step1Title => '聆聽ㅈ的發音';

  @override
  String get hangulS5L2Step1Desc => '聽一聽자/조/주';

  @override
  String get hangulS5L2Step2Title => '發音練習';

  @override
  String get hangulS5L2Step2Desc => '大聲朗讀每個文字';

  @override
  String get hangulS5L2Step3Title => '選出ㅈ的音';

  @override
  String get hangulS5L2Step3Desc => '區分자和사';

  @override
  String get hangulS5L2Step4Title => '用ㅈ組字';

  @override
  String get hangulS5L2Step4Desc => '組合ㅈ + 母音';

  @override
  String get hangulS5L2Step5Title => '課程完成！';

  @override
  String get hangulS5L2Step5Msg => '太棒了！\n你已經學會了ㅈ的發音和形狀。';

  @override
  String get hangulS5L3Title => 'ㅊ的形狀與發音';

  @override
  String get hangulS5L3Subtitle => 'ㅊ的基礎讀法';

  @override
  String get hangulS5L3Step0Title => '學習ㅊ';

  @override
  String get hangulS5L3Step0Desc => 'ㅊ產生「차」系列的音。';

  @override
  String get hangulS5L3Step0Highlights => 'ㅊ,차';

  @override
  String get hangulS5L3Step1Title => '聆聽ㅊ的發音';

  @override
  String get hangulS5L3Step1Desc => '聽一聽차/초/추';

  @override
  String get hangulS5L3Step2Title => '發音練習';

  @override
  String get hangulS5L3Step2Desc => '大聲朗讀每個文字';

  @override
  String get hangulS5L3Step3Title => '選出ㅊ的音';

  @override
  String get hangulS5L3Step3Desc => '區分차和자';

  @override
  String get hangulS5L3Step4Title => '課程完成！';

  @override
  String get hangulS5L3Step4Msg => '太棒了！\n你已經學會了ㅊ的發音和形狀。';

  @override
  String get hangulS5L4Title => 'ㅋ的形狀與發音';

  @override
  String get hangulS5L4Subtitle => 'ㅋ的基礎讀法';

  @override
  String get hangulS5L4Step0Title => '學習ㅋ';

  @override
  String get hangulS5L4Step0Desc => 'ㅋ產生「카」系列的音。';

  @override
  String get hangulS5L4Step0Highlights => 'ㅋ,카';

  @override
  String get hangulS5L4Step1Title => '聆聽ㅋ的發音';

  @override
  String get hangulS5L4Step1Desc => '聽一聽카/코/쿠';

  @override
  String get hangulS5L4Step2Title => '發音練習';

  @override
  String get hangulS5L4Step2Desc => '大聲朗讀每個文字';

  @override
  String get hangulS5L4Step3Title => '選出ㅋ的音';

  @override
  String get hangulS5L4Step3Desc => '區分카和가';

  @override
  String get hangulS5L4Step4Title => '課程完成！';

  @override
  String get hangulS5L4Step4Msg => '太棒了！\n你已經學會了ㅋ的發音和形狀。';

  @override
  String get hangulS5L5Title => 'ㅌ的形狀與發音';

  @override
  String get hangulS5L5Subtitle => 'ㅌ的基礎讀法';

  @override
  String get hangulS5L5Step0Title => '學習ㅌ';

  @override
  String get hangulS5L5Step0Desc => 'ㅌ產生「타」系列的音。';

  @override
  String get hangulS5L5Step0Highlights => 'ㅌ,타';

  @override
  String get hangulS5L5Step1Title => '聆聽ㅌ的發音';

  @override
  String get hangulS5L5Step1Desc => '聽一聽타/토/투';

  @override
  String get hangulS5L5Step2Title => '發音練習';

  @override
  String get hangulS5L5Step2Desc => '大聲朗讀每個文字';

  @override
  String get hangulS5L5Step3Title => '選出ㅌ的音';

  @override
  String get hangulS5L5Step3Desc => '區分타和다';

  @override
  String get hangulS5L5Step4Title => '課程完成！';

  @override
  String get hangulS5L5Step4Msg => '太棒了！\n你已經學會了ㅌ的發音和形狀。';

  @override
  String get hangulS5L6Title => 'ㅍ的形狀與發音';

  @override
  String get hangulS5L6Subtitle => 'ㅍ的基礎讀法';

  @override
  String get hangulS5L6Step0Title => '學習ㅍ';

  @override
  String get hangulS5L6Step0Desc => 'ㅍ產生「파」系列的音。';

  @override
  String get hangulS5L6Step0Highlights => 'ㅍ,파';

  @override
  String get hangulS5L6Step1Title => '聆聽ㅍ的發音';

  @override
  String get hangulS5L6Step1Desc => '聽一聽파/포/푸';

  @override
  String get hangulS5L6Step2Title => '發音練習';

  @override
  String get hangulS5L6Step2Desc => '大聲朗讀每個文字';

  @override
  String get hangulS5L6Step3Title => '選出ㅍ的音';

  @override
  String get hangulS5L6Step3Desc => '區分파和바';

  @override
  String get hangulS5L6Step4Title => '課程完成！';

  @override
  String get hangulS5L6Step4Msg => '太棒了！\n你已經學會了ㅍ的發音和形狀。';

  @override
  String get hangulS5L7Title => 'ㅎ的形狀與發音';

  @override
  String get hangulS5L7Subtitle => 'ㅎ的基礎讀法';

  @override
  String get hangulS5L7Step0Title => '學習ㅎ';

  @override
  String get hangulS5L7Step0Desc => 'ㅎ產生「하」系列的音。';

  @override
  String get hangulS5L7Step0Highlights => 'ㅎ,하';

  @override
  String get hangulS5L7Step1Title => '聆聽ㅎ的發音';

  @override
  String get hangulS5L7Step1Desc => '聽一聽하/호/후';

  @override
  String get hangulS5L7Step2Title => '發音練習';

  @override
  String get hangulS5L7Step2Desc => '大聲朗讀每個文字';

  @override
  String get hangulS5L7Step3Title => '選出ㅎ的音';

  @override
  String get hangulS5L7Step3Desc => '區分하和아';

  @override
  String get hangulS5L7Step4Title => '課程完成！';

  @override
  String get hangulS5L7Step4Msg => '太棒了！\n你已經學會了ㅎ的發音和形狀。';

  @override
  String get hangulS5L8Title => '額外子音隨機朗讀';

  @override
  String get hangulS5L8Subtitle => '混合複習ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS5L8Step0Title => '隨機複習';

  @override
  String get hangulS5L8Step0Desc => '把7個額外子音混在一起讀一讀吧。';

  @override
  String get hangulS5L8Step0Highlights => 'ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ';

  @override
  String get hangulS5L8Step1Title => '形狀/發音測驗';

  @override
  String get hangulS5L8Step1Desc => '將發音與文字對應起來';

  @override
  String get hangulS5L8Step2Title => '課程完成！';

  @override
  String get hangulS5L8Step2Msg => '太棒了！\n你隨機複習了7個額外子音。';

  @override
  String get hangulS5L9Title => '易混淆對的預習';

  @override
  String get hangulS5L9Subtitle => '為下一階段做準備的區分練習';

  @override
  String get hangulS5L9Step0Title => '先看看容易混淆的對';

  @override
  String get hangulS5L9Step0Desc => '提前練習區分ㅈ/ㅊ、ㄱ/ㅋ、ㄷ/ㅌ、ㅂ/ㅍ。';

  @override
  String get hangulS5L9Step0Highlights => 'ㅈ/ㅊ,ㄱ/ㅋ,ㄷ/ㅌ,ㅂ/ㅍ';

  @override
  String get hangulS5L9Step1Title => '對比聽音';

  @override
  String get hangulS5L9Step1Desc => '從兩個選項中選出正確的音';

  @override
  String get hangulS5L9Step2Title => '課程完成！';

  @override
  String get hangulS5L9Step2Msg => '太棒了！\n你已經為下一階段做好準備了。';

  @override
  String get hangulS5LMTitle => '第5階段任務';

  @override
  String get hangulS5LMSubtitle => '基本子音2 綜合任務';

  @override
  String get hangulS5LMStep0Title => '任務開始！';

  @override
  String get hangulS5LMStep0Desc => '將基本子音2（ㅇ~ㅎ）與母音組合。\n在限定時間內達成目標！';

  @override
  String get hangulS5LMStep1Title => '組合音節！';

  @override
  String get hangulS5LMStep2Title => '任務結果';

  @override
  String get hangulS5LMStep3Title => '第5階段完成！';

  @override
  String get hangulS5LMStep3Msg => '恭喜！\n你完成了第5階段：基本子音2（ㅇ~ㅎ）。';

  @override
  String get hangulS5LMStep4Title => '第5階段完成！';

  @override
  String get hangulS5LMStep4Msg => '你已經掌握了所有基本子音！';

  @override
  String get hangulS5CompleteTitle => '第5階段完成！';

  @override
  String get hangulS5CompleteMsg => '你已經掌握了所有基本子音！';

  @override
  String get hangulS6L1Title => '가~기 模式閱讀';

  @override
  String get hangulS6L1Subtitle => 'ㄱ + 基本母音模式';

  @override
  String get hangulS6L1Step0Title => '開始用模式閱讀';

  @override
  String get hangulS6L1Step0Desc => '試著改變與ㄱ組合的母音\n你會找到閱讀的節奏。';

  @override
  String get hangulS6L1Step0Highlights => '가,거,고,구,그,기';

  @override
  String get hangulS6L1Step1Title => '聆聽模式發音';

  @override
  String get hangulS6L1Step1Desc => '按順序聽一聽 가/거/고/구/그/기';

  @override
  String get hangulS6L1Step2Title => '發音練習';

  @override
  String get hangulS6L1Step2Desc => '請大聲讀出每個音節';

  @override
  String get hangulS6L1Step3Title => '模式測驗';

  @override
  String get hangulS6L1Step3Desc => '配對相同的子音模式';

  @override
  String get hangulS6L1Step3Q0 => 'ㄱ + ㅏ = ?';

  @override
  String get hangulS6L1Step3Q1 => 'ㄱ + ㅓ = ?';

  @override
  String get hangulS6L1Step3Q2 => 'ㄱ + ㅡ = ?';

  @override
  String get hangulS6L1Step4Title => '課程完成！';

  @override
  String get hangulS6L1Step4Msg => '很好！\n你已經開始學習 가~기 模式了。';

  @override
  String get hangulS6L2Title => '擴展 나~니';

  @override
  String get hangulS6L2Subtitle => 'ㄴ 模式閱讀';

  @override
  String get hangulS6L2Step0Title => '擴展 ㄴ 模式';

  @override
  String get hangulS6L2Step0Desc => '改變與ㄴ組合的母音來讀 나~니。';

  @override
  String get hangulS6L2Step0Highlights => '나,너,노,누,느,니';

  @override
  String get hangulS6L2Step1Title => '聆聽 나~니';

  @override
  String get hangulS6L2Step1Desc => '請聽聽 ㄴ 模式的發音';

  @override
  String get hangulS6L2Step2Title => '發音練習';

  @override
  String get hangulS6L2Step2Desc => '請大聲讀出每個音節';

  @override
  String get hangulS6L2Step3Title => '組合 ㄴ';

  @override
  String get hangulS6L2Step3Desc => '用 ㄴ + 母音組成音節';

  @override
  String get hangulS6L2Step4Title => '課程完成！';

  @override
  String get hangulS6L2Step4Msg => '很好！\n你已經掌握了 나~니 模式。';

  @override
  String get hangulS6L3Title => '擴展 다~디 和 라~리';

  @override
  String get hangulS6L3Subtitle => 'ㄷ/ㄹ 模式閱讀';

  @override
  String get hangulS6L3Step0Title => '只換子音來閱讀';

  @override
  String get hangulS6L3Step0Desc => '用相同母音只換子音來讀，\n閱讀速度會越來越快。';

  @override
  String get hangulS6L3Step0Highlights => '다/라,도/로,두/루,디/리';

  @override
  String get hangulS6L3Step1Title => '聆聽：區分 ㄷ/ㄹ';

  @override
  String get hangulS6L3Step1Desc => '聽音選擇正確的音節';

  @override
  String get hangulS6L3Step2Title => '閱讀測驗';

  @override
  String get hangulS6L3Step2Desc => '檢查模式';

  @override
  String get hangulS6L3Step2Q0 => 'ㄷ + ㅣ = ?';

  @override
  String get hangulS6L3Step2Q1 => 'ㄹ + ㅗ = ?';

  @override
  String get hangulS6L3Step3Title => '課程完成！';

  @override
  String get hangulS6L3Step3Msg => '很好！\n你已經掌握了 ㄷ/ㄹ 模式。';

  @override
  String get hangulS6L4Title => '隨機音節閱讀 1';

  @override
  String get hangulS6L4Subtitle => '混合基本模式';

  @override
  String get hangulS6L4Step0Title => '無序閱讀';

  @override
  String get hangulS6L4Step0Desc => '現在像隨機抽卡一樣來讀吧。';

  @override
  String get hangulS6L4Step1Title => '隨機閱讀';

  @override
  String get hangulS6L4Step1Desc => '識別隨機出現的音節';

  @override
  String get hangulS6L4Step1Q0 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS6L4Step1Q1 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS6L4Step1Q2 => 'ㄹ + ㅏ = ?';

  @override
  String get hangulS6L4Step1Q3 => 'ㅁ + ㅣ = ?';

  @override
  String get hangulS6L4Step2Title => '課程完成！';

  @override
  String get hangulS6L4Step2Msg => '很好！\n你完成了隨機閱讀 1。';

  @override
  String get hangulS6L5Title => '聽音找音節';

  @override
  String get hangulS6L5Subtitle => '強化聽覺與文字的聯繫';

  @override
  String get hangulS6L5Step0Title => '聽音尋字練習';

  @override
  String get hangulS6L5Step0Desc => '聽音選出對應音節，\n強化閱讀聯繫。';

  @override
  String get hangulS6L5Step1Title => '聲音配對';

  @override
  String get hangulS6L5Step1Desc => '選出正確的音節';

  @override
  String get hangulS6L5Step2Title => '課程完成！';

  @override
  String get hangulS6L5Step2Msg => '很好！\n你完成了聽音找字練習。';

  @override
  String get hangulS6L6Title => '複合母音組合 1';

  @override
  String get hangulS6L6Subtitle => '閱讀 ㅘ、ㅝ';

  @override
  String get hangulS6L6Step0Title => '開始學習複合母音';

  @override
  String get hangulS6L6Step0Desc => '來讀一讀由 ㅘ 和 ㅝ 組成的音節。';

  @override
  String get hangulS6L6Step0Highlights => 'ㅘ,ㅝ,와,워';

  @override
  String get hangulS6L6Step1Title => '聆聽 와/워';

  @override
  String get hangulS6L6Step1Desc => '請聽一聽代表性音節的發音';

  @override
  String get hangulS6L6Step2Title => '發音練習';

  @override
  String get hangulS6L6Step2Desc => '請大聲讀出每個音節';

  @override
  String get hangulS6L6Step3Title => '複合母音測驗';

  @override
  String get hangulS6L6Step3Desc => '區分 ㅘ 和 ㅝ';

  @override
  String get hangulS6L6Step3Q0 => 'ㅇ + ㅘ = ?';

  @override
  String get hangulS6L6Step3Q1 => 'ㄱ + ㅝ = ?';

  @override
  String get hangulS6L6Step4Title => '課程完成！';

  @override
  String get hangulS6L6Step4Msg => '很好！\n你已經學會了 ㅘ/ㅝ 組合。';

  @override
  String get hangulS6L7Title => '複合母音組合 2';

  @override
  String get hangulS6L7Subtitle => '閱讀 ㅙ、ㅞ、ㅚ、ㅟ、ㅢ';

  @override
  String get hangulS6L7Step0Title => '擴展複合母音';

  @override
  String get hangulS6L7Step0Desc => '簡要學習複合母音，以閱讀為中心推進。';

  @override
  String get hangulS6L7Step0Highlights => '왜,웨,외,위,의';

  @override
  String get hangulS6L7Step1Title => 'ㅢ 的特殊發音';

  @override
  String get hangulS6L7Step1Desc =>
      'ㅢ 是一個根據位置發音不同的特殊母音。\n\n• 詞首：[의] → 의사、의자\n• 子音後：[이] → 희망→[히망]\n• 助詞「의」：[에] → 나의→[나에]';

  @override
  String get hangulS6L7Step1Highlights => 'ㅢ,의,이,에';

  @override
  String get hangulS6L7Step2Title => '選擇複合母音';

  @override
  String get hangulS6L7Step2Desc => '選出正確的音節';

  @override
  String get hangulS6L7Step2Q0 => 'ㅇ + ㅙ = ?';

  @override
  String get hangulS6L7Step2Q1 => 'ㅇ + ㅟ = ?';

  @override
  String get hangulS6L7Step2Q2 => 'ㅇ + ㅢ = ?';

  @override
  String get hangulS6L7Step3Title => '課程完成！';

  @override
  String get hangulS6L7Step3Msg => '很好！\n你完成了複合母音的擴展學習。';

  @override
  String get hangulS6L8Title => '隨機音節閱讀 2';

  @override
  String get hangulS6L8Subtitle => '基本+複合母音綜合';

  @override
  String get hangulS6L8Step0Title => '綜合隨機閱讀';

  @override
  String get hangulS6L8Step0Desc => '將基本母音和複合母音混合在一起閱讀。';

  @override
  String get hangulS6L8Step1Title => '綜合測驗';

  @override
  String get hangulS6L8Step1Desc => '識別隨機組合';

  @override
  String get hangulS6L8Step1Q0 => 'ㄱ + ㅢ = ?';

  @override
  String get hangulS6L8Step1Q1 => 'ㅎ + ㅘ = ?';

  @override
  String get hangulS6L8Step1Q2 => 'ㅂ + ㅟ = ?';

  @override
  String get hangulS6L8Step1Q3 => 'ㅈ + ㅝ = ?';

  @override
  String get hangulS6L8Step2Title => '課程完成！';

  @override
  String get hangulS6L8Step2Msg => '很好！\n你完成了第6階段綜合閱讀。';

  @override
  String get hangulS6LMTitle => '第6階段任務';

  @override
  String get hangulS6LMSubtitle => '組合閱讀最終檢驗';

  @override
  String get hangulS6LMStep0Title => '任務開始！';

  @override
  String get hangulS6LMStep0Desc => '這是音節組合訓練的最終檢驗。\n在時限內達成目標吧！';

  @override
  String get hangulS6LMStep1Title => '組合音節！';

  @override
  String get hangulS6LMStep2Title => '任務結果';

  @override
  String get hangulS6LMStep3Title => '第6階段完成！';

  @override
  String get hangulS6LMStep3Msg => '恭喜！\n你完成了第6階段音節組合訓練。';

  @override
  String get hangulS6CompleteTitle => '第6階段完成！';

  @override
  String get hangulS6CompleteMsg => '你現在可以自由組合音節了！';

  @override
  String get hangulS7L1Title => 'ㄱ / ㅋ / ㄲ 子音對比';

  @override
  String get hangulS7L1Subtitle => '가 · 카 · 까 的對比';

  @override
  String get hangulS7L1Step0Title => '分辨三種聲音';

  @override
  String get hangulS7L1Step0Desc => '區分ㄱ（平音）、ㅋ（送氣音）、ㄲ（緊音）的感覺。';

  @override
  String get hangulS7L1Step0Highlights => 'ㄱ,ㅋ,ㄲ,가,카,까';

  @override
  String get hangulS7L1Step1Title => '聲音探索';

  @override
  String get hangulS7L1Step1Desc => '反覆聽가/카/까';

  @override
  String get hangulS7L1Step2Title => '發音練習';

  @override
  String get hangulS7L1Step2Desc => '試著親自發出每個字的聲音';

  @override
  String get hangulS7L1Step3Title => '聽音選字';

  @override
  String get hangulS7L1Step3Desc => '從三個選項中選出正確答案';

  @override
  String get hangulS7L1Step4Title => '快速確認';

  @override
  String get hangulS7L1Step4Desc => '同時確認形狀和聲音';

  @override
  String get hangulS7L1Step4Q0 => '哪個是送氣音？';

  @override
  String get hangulS7L1Step4Q1 => '哪個是緊音？';

  @override
  String get hangulS7L1Step5Title => '課程完成！';

  @override
  String get hangulS7L1Step5Msg => '很好！\n你已掌握區分ㄱ/ㅋ/ㄲ的方法。';

  @override
  String get hangulS7L2Title => 'ㄷ / ㅌ / ㄸ 子音對比';

  @override
  String get hangulS7L2Subtitle => '다 · 타 · 따 的對比';

  @override
  String get hangulS7L2Step0Title => '第二組對比';

  @override
  String get hangulS7L2Step0Desc => '比較ㄷ/ㅌ/ㄸ的聲音。';

  @override
  String get hangulS7L2Step0Highlights => 'ㄷ,ㅌ,ㄸ,다,타,따';

  @override
  String get hangulS7L2Step1Title => '聲音探索';

  @override
  String get hangulS7L2Step1Desc => '反覆聽다/타/따';

  @override
  String get hangulS7L2Step2Title => '發音練習';

  @override
  String get hangulS7L2Step2Desc => '試著親自發出每個字的聲音';

  @override
  String get hangulS7L2Step3Title => '聽音選字';

  @override
  String get hangulS7L2Step3Desc => '從三個選項中選出正確答案';

  @override
  String get hangulS7L2Step4Title => '課程完成！';

  @override
  String get hangulS7L2Step4Msg => '很好！\n你已掌握區分ㄷ/ㅌ/ㄸ的方法。';

  @override
  String get hangulS7L3Title => 'ㅂ / ㅍ / ㅃ 子音對比';

  @override
  String get hangulS7L3Subtitle => '바 · 파 · 빠 的對比';

  @override
  String get hangulS7L3Step0Title => '第三組對比';

  @override
  String get hangulS7L3Step0Desc => '比較ㅂ/ㅍ/ㅃ的聲音。';

  @override
  String get hangulS7L3Step0Highlights => 'ㅂ,ㅍ,ㅃ,바,파,빠';

  @override
  String get hangulS7L3Step1Title => '聲音探索';

  @override
  String get hangulS7L3Step1Desc => '反覆聽바/파/빠';

  @override
  String get hangulS7L3Step2Title => '發音練習';

  @override
  String get hangulS7L3Step2Desc => '試著親自發出每個字的聲音';

  @override
  String get hangulS7L3Step3Title => '聽音選字';

  @override
  String get hangulS7L3Step3Desc => '從三個選項中選出正確答案';

  @override
  String get hangulS7L3Step4Title => '課程完成！';

  @override
  String get hangulS7L3Step4Msg => '很好！\n你已掌握區分ㅂ/ㅍ/ㅃ的方法。';

  @override
  String get hangulS7L4Title => 'ㅅ / ㅆ 子音對比';

  @override
  String get hangulS7L4Subtitle => '사 · 싸 的對比';

  @override
  String get hangulS7L4Step0Title => '兩種聲音的對比';

  @override
  String get hangulS7L4Step0Desc => '區分ㅅ/ㅆ的聲音。';

  @override
  String get hangulS7L4Step0Highlights => 'ㅅ,ㅆ,사,싸';

  @override
  String get hangulS7L4Step1Title => '聲音探索';

  @override
  String get hangulS7L4Step1Desc => '反覆聽사/싸';

  @override
  String get hangulS7L4Step2Title => '發音練習';

  @override
  String get hangulS7L4Step2Desc => '試著親自發出每個字的聲音';

  @override
  String get hangulS7L4Step3Title => '聽音選字';

  @override
  String get hangulS7L4Step3Desc => '從兩個選項中選出正確答案';

  @override
  String get hangulS7L4Step4Title => '課程完成！';

  @override
  String get hangulS7L4Step4Msg => '很好！\n你已掌握區分ㅅ/ㅆ的方法。';

  @override
  String get hangulS7L5Title => 'ㅈ / ㅊ / ㅉ 子音對比';

  @override
  String get hangulS7L5Subtitle => '자 · 차 · 짜 的對比';

  @override
  String get hangulS7L5Step0Title => '最後一組對比';

  @override
  String get hangulS7L5Step0Desc => '比較ㅈ/ㅊ/ㅉ的聲音。';

  @override
  String get hangulS7L5Step0Highlights => 'ㅈ,ㅊ,ㅉ,자,차,짜';

  @override
  String get hangulS7L5Step1Title => '聲音探索';

  @override
  String get hangulS7L5Step1Desc => '反覆聽자/차/짜';

  @override
  String get hangulS7L5Step2Title => '發音練習';

  @override
  String get hangulS7L5Step2Desc => '試著親自發出每個字的聲音';

  @override
  String get hangulS7L5Step3Title => '聽音選字';

  @override
  String get hangulS7L5Step3Desc => '從三個選項中選出正確答案';

  @override
  String get hangulS7L5Step4Title => '第7階段完成！';

  @override
  String get hangulS7L5Step4Msg => '恭喜！\n你已完成第7階段的全部5組對比練習。';

  @override
  String get hangulS7LMTitle => '任務：聲音辨別挑戰！';

  @override
  String get hangulS7LMSubtitle => '區分平音、送氣音和緊音';

  @override
  String get hangulS7LMStep0Title => '聲音辨別任務！';

  @override
  String get hangulS7LMStep0Desc => '混合平音、送氣音和緊音\n快速組合音節！';

  @override
  String get hangulS7LMStep1Title => '組合音節！';

  @override
  String get hangulS7LMStep2Title => '任務結果';

  @override
  String get hangulS7LMStep3Title => '任務完成！';

  @override
  String get hangulS7LMStep3Msg => '你已能區分平音、送氣音和緊音！';

  @override
  String get hangulS7LMStep4Title => '第7階段完成！';

  @override
  String get hangulS7LMStep4Msg => '你已能區分緊音和送氣音！';

  @override
  String get hangulS7CompleteTitle => '第7階段完成！';

  @override
  String get hangulS7CompleteMsg => '你已能區分緊音和送氣音！';

  @override
  String get hangulS8L0Title => '韻尾（받침）基礎';

  @override
  String get hangulS8L0Subtitle => '藏在音節塊底部的音';

  @override
  String get hangulS8L0Step0Title => '韻尾在音節的下方';

  @override
  String get hangulS8L0Step0Desc => '韻尾（받침）位於音節塊的底部。\n例：가 + ㄴ = 간';

  @override
  String get hangulS8L0Step0Highlights => '韻尾,간,말,집';

  @override
  String get hangulS8L0Step1Title => '韻尾的7個代表音';

  @override
  String get hangulS8L0Step1Desc =>
      '韻尾只有7個代表音。\n\nㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\n許多韻尾字母都歸屬於這7個音之一。\n例：ㅅ, ㅈ, ㅊ, ㅎ 作為韻尾 → 均發[ㄷ]音';

  @override
  String get hangulS8L0Step1Highlights => '7個音,ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ,代表音';

  @override
  String get hangulS8L0Step2Title => '找出韻尾';

  @override
  String get hangulS8L0Step2Desc => '確認韻尾的位置';

  @override
  String get hangulS8L0Step2Q0 => '간的韻尾是？';

  @override
  String get hangulS8L0Step2Q1 => '말的韻尾是？';

  @override
  String get hangulS8L0SummaryTitle => '課程完成！';

  @override
  String get hangulS8L0SummaryMsg => '很好！\n你已理解韻尾的概念。';

  @override
  String get hangulS8L1Title => 'ㄴ韻尾';

  @override
  String get hangulS8L1Subtitle => '간 · 난 · 단';

  @override
  String get hangulS8L1Step0Title => '聆聽ㄴ韻尾';

  @override
  String get hangulS8L1Step0Desc => '聽一聽간/난/단';

  @override
  String get hangulS8L1Step1Title => '發音練習';

  @override
  String get hangulS8L1Step1Desc => '大聲朗讀每個字';

  @override
  String get hangulS8L1Step2Title => '聽音選字';

  @override
  String get hangulS8L1Step2Desc => '選出帶有ㄴ韻尾的音節';

  @override
  String get hangulS8L1SummaryTitle => '課程完成！';

  @override
  String get hangulS8L1SummaryMsg => '很好！\n你掌握了ㄴ韻尾。';

  @override
  String get hangulS8L2Title => 'ㄹ韻尾';

  @override
  String get hangulS8L2Subtitle => '말 · 갈 · 물';

  @override
  String get hangulS8L2Step0Title => '聆聽ㄹ韻尾';

  @override
  String get hangulS8L2Step0Desc => '聽一聽말/갈/물';

  @override
  String get hangulS8L2Step1Title => '發音練習';

  @override
  String get hangulS8L2Step1Desc => '大聲朗讀每個字';

  @override
  String get hangulS8L2Step2Title => '聽音選字';

  @override
  String get hangulS8L2Step2Desc => '選出帶有ㄹ韻尾的音節';

  @override
  String get hangulS8L2SummaryTitle => '課程完成！';

  @override
  String get hangulS8L2SummaryMsg => '很好！\n你掌握了ㄹ韻尾。';

  @override
  String get hangulS8L3Title => 'ㅁ韻尾';

  @override
  String get hangulS8L3Subtitle => '감 · 밤 · 숨';

  @override
  String get hangulS8L3Step0Title => '聆聽ㅁ韻尾';

  @override
  String get hangulS8L3Step0Desc => '聽一聽감/밤/숨';

  @override
  String get hangulS8L3Step1Title => '發音練習';

  @override
  String get hangulS8L3Step1Desc => '大聲朗讀每個字';

  @override
  String get hangulS8L3Step2Title => '辨別韻尾';

  @override
  String get hangulS8L3Step2Desc => '選出ㅁ韻尾的音節';

  @override
  String get hangulS8L3Step2Q0 => '哪個有ㅁ韻尾？';

  @override
  String get hangulS8L3Step2Q1 => '哪個有ㅁ韻尾？';

  @override
  String get hangulS8L3SummaryTitle => '課程完成！';

  @override
  String get hangulS8L3SummaryMsg => '很好！\n你掌握了ㅁ韻尾。';

  @override
  String get hangulS8L4Title => 'ㅇ韻尾';

  @override
  String get hangulS8L4Subtitle => '방 · 공 · 종';

  @override
  String get hangulS8L4Step0Title => 'ㅇ很特別！';

  @override
  String get hangulS8L4Step0Desc =>
      'ㅇ很特別！\n作為初聲（上方）時無音（아, 오），\n作為韻尾（받침，下方）時發\"ng\"音（방, 공）';

  @override
  String get hangulS8L4Step0Highlights => '初聲,韻尾,ng,방,공';

  @override
  String get hangulS8L4Step1Title => '聆聽ㅇ韻尾';

  @override
  String get hangulS8L4Step1Desc => '聽一聽방/공/종';

  @override
  String get hangulS8L4Step2Title => '發音練習';

  @override
  String get hangulS8L4Step2Desc => '大聲朗讀每個字';

  @override
  String get hangulS8L4Step3Title => '聽音選字';

  @override
  String get hangulS8L4Step3Desc => '選出帶有ㅇ韻尾的音節';

  @override
  String get hangulS8L4SummaryTitle => '課程完成！';

  @override
  String get hangulS8L4SummaryMsg => '很好！\n你掌握了ㅇ韻尾。';

  @override
  String get hangulS8L5Title => 'ㄱ韻尾';

  @override
  String get hangulS8L5Subtitle => '박 · 각 · 국';

  @override
  String get hangulS8L5Step0Title => '聆聽ㄱ韻尾';

  @override
  String get hangulS8L5Step0Desc => '聽一聽박/각/국';

  @override
  String get hangulS8L5Step1Title => '發音練習';

  @override
  String get hangulS8L5Step1Desc => '大聲朗讀每個字';

  @override
  String get hangulS8L5Step2Title => '辨別韻尾';

  @override
  String get hangulS8L5Step2Desc => '選出ㄱ韻尾的音節';

  @override
  String get hangulS8L5Step2Q0 => '哪個有ㄱ韻尾？';

  @override
  String get hangulS8L5Step2Q1 => '哪個有ㄱ韻尾？';

  @override
  String get hangulS8L5SummaryTitle => '課程完成！';

  @override
  String get hangulS8L5SummaryMsg => '很好！\n你掌握了ㄱ韻尾。';

  @override
  String get hangulS8L6Title => 'ㅂ韻尾';

  @override
  String get hangulS8L6Subtitle => '밥 · 집 · 숲';

  @override
  String get hangulS8L6Step0Title => '聆聽ㅂ韻尾';

  @override
  String get hangulS8L6Step0Desc => '聽一聽밥/집/숲';

  @override
  String get hangulS8L6Step1Title => '發音練習';

  @override
  String get hangulS8L6Step1Desc => '大聲朗讀每個字';

  @override
  String get hangulS8L6Step2Title => '聽音選字';

  @override
  String get hangulS8L6Step2Desc => '選出帶有ㅂ韻尾的音節';

  @override
  String get hangulS8L6SummaryTitle => '課程完成！';

  @override
  String get hangulS8L6SummaryMsg => '很好！\n你掌握了ㅂ韻尾。';

  @override
  String get hangulS8L7Title => 'ㅅ韻尾';

  @override
  String get hangulS8L7Subtitle => '옷 · 맛 · 빛';

  @override
  String get hangulS8L7Step0Title => '聆聽ㅅ韻尾';

  @override
  String get hangulS8L7Step0Desc => '聽一聽옷/맛/빛';

  @override
  String get hangulS8L7Step1Title => '發音練習';

  @override
  String get hangulS8L7Step1Desc => '大聲朗讀每個字';

  @override
  String get hangulS8L7Step2Title => '辨別韻尾';

  @override
  String get hangulS8L7Step2Desc => '選出ㅅ韻尾的音節';

  @override
  String get hangulS8L7Step2Q0 => '哪個有ㅅ韻尾？';

  @override
  String get hangulS8L7Step2Q1 => '哪個有ㅅ韻尾？';

  @override
  String get hangulS8L7SummaryTitle => '課程完成！';

  @override
  String get hangulS8L7SummaryMsg => '很好！\n你掌握了ㅅ韻尾。';

  @override
  String get hangulS8L8Title => '韻尾綜合複習';

  @override
  String get hangulS8L8Subtitle => '核心韻尾隨機檢測';

  @override
  String get hangulS8L8Step0Title => '全部混合練習';

  @override
  String get hangulS8L8Step0Desc => '我們來綜合複習ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅ。';

  @override
  String get hangulS8L8Step1Title => '隨機測驗';

  @override
  String get hangulS8L8Step1Desc => '混合韻尾綜合測試';

  @override
  String get hangulS8L8Step1Q0 => '哪個有ㄴ韻尾？';

  @override
  String get hangulS8L8Step1Q1 => '哪個有ㅇ韻尾？';

  @override
  String get hangulS8L8Step1Q2 => '哪個有ㄹ韻尾？';

  @override
  String get hangulS8L8Step1Q3 => '哪個有ㅂ韻尾？';

  @override
  String get hangulS8L8SummaryTitle => '課程完成！';

  @override
  String get hangulS8L8SummaryMsg => '很好！\n完成了韻尾綜合複習。';

  @override
  String get hangulS8LMTitle => '任務：韻尾挑戰！';

  @override
  String get hangulS8LMSubtitle => '組合帶韻尾的音節';

  @override
  String get hangulS8LMStep0Title => '韻尾任務！';

  @override
  String get hangulS8LMStep0Desc => '讀出帶有基本韻尾的音節，\n快速作答！';

  @override
  String get hangulS8LMStep1Title => '拼出音節！';

  @override
  String get hangulS8LMStep2Title => '任務結果';

  @override
  String get hangulS8LMSummaryTitle => '任務完成！';

  @override
  String get hangulS8LMSummaryMsg => '你已完全掌握韻尾基礎！';

  @override
  String get hangulS8CompleteTitle => '第8階段完成！';

  @override
  String get hangulS8CompleteMsg => '你已打好韻尾的基礎！';

  @override
  String get hangulS9L1Title => '韻尾（받침） ㄷ 進階';

  @override
  String get hangulS9L1Subtitle => '닫 · 곧 · 묻';

  @override
  String get hangulS9L1Step0Title => 'ㄷ 韻尾規律';

  @override
  String get hangulS9L1Step0Desc => '讀讀看含有韻尾 ㄷ 的音節。';

  @override
  String get hangulS9L1Step0Highlights => '닫,곧,묻';

  @override
  String get hangulS9L1Step1Title => '聽聽看：韻尾 ㄷ';

  @override
  String get hangulS9L1Step1Desc => '聽 닫/곧/묻 的發音';

  @override
  String get hangulS9L1Step2Title => '發音練習';

  @override
  String get hangulS9L1Step2Desc => '親自大聲念出每個字';

  @override
  String get hangulS9L1Step3Title => '辨別韻尾';

  @override
  String get hangulS9L1Step3Desc => '選出帶有韻尾 ㄷ 的音節';

  @override
  String get hangulS9L1Step3Q0 => '哪個帶有韻尾 ㄷ？';

  @override
  String get hangulS9L1Step3Q1 => '哪個帶有韻尾 ㄷ？';

  @override
  String get hangulS9L1Step4Title => '課程完成！';

  @override
  String get hangulS9L1Step4Msg => '很好！\n你已掌握韻尾 ㄷ。';

  @override
  String get hangulS9L2Title => '韻尾（받침） ㅈ 進階';

  @override
  String get hangulS9L2Subtitle => '낮 · 잊 · 젖';

  @override
  String get hangulS9L2Step0Title => '聽聽看：韻尾 ㅈ';

  @override
  String get hangulS9L2Step0Desc => '聽 낮/잊/젖 的發音';

  @override
  String get hangulS9L2Step1Title => '發音練習';

  @override
  String get hangulS9L2Step1Desc => '親自大聲念出每個字';

  @override
  String get hangulS9L2Step2Title => '聽音選字';

  @override
  String get hangulS9L2Step2Desc => '選出帶有韻尾 ㅈ 的音節';

  @override
  String get hangulS9L2Step3Title => '課程完成！';

  @override
  String get hangulS9L2Step3Msg => '很好！\n你已掌握韻尾 ㅈ。';

  @override
  String get hangulS9L3Title => '韻尾（받침） ㅊ 進階';

  @override
  String get hangulS9L3Subtitle => '꽃 · 닻 · 빚';

  @override
  String get hangulS9L3Step0Title => '聽聽看：韻尾 ㅊ';

  @override
  String get hangulS9L3Step0Desc => '聽 꽃/닻/빚 的發音';

  @override
  String get hangulS9L3Step1Title => '發音練習';

  @override
  String get hangulS9L3Step1Desc => '親自大聲念出每個字';

  @override
  String get hangulS9L3Step2Title => '辨別韻尾';

  @override
  String get hangulS9L3Step2Desc => '選出帶有韻尾 ㅊ 的音節';

  @override
  String get hangulS9L3Step2Q0 => '哪個帶有韻尾 ㅊ？';

  @override
  String get hangulS9L3Step2Q1 => '哪個帶有韻尾 ㅊ？';

  @override
  String get hangulS9L3Step3Title => '課程完成！';

  @override
  String get hangulS9L3Step3Msg => '很好！\n你已掌握韻尾 ㅊ。';

  @override
  String get hangulS9L4Title => '韻尾（받침） ㅋ / ㅌ / ㅍ';

  @override
  String get hangulS9L4Subtitle => '부엌 · 밭 · 앞';

  @override
  String get hangulS9L4Step0Title => '三個韻尾一起學';

  @override
  String get hangulS9L4Step0Desc => '把 ㅋ、ㅌ、ㅍ 三個韻尾放在一起學。';

  @override
  String get hangulS9L4Step0Highlights => '부엌,밭,앞';

  @override
  String get hangulS9L4Step1Title => '聽聽看';

  @override
  String get hangulS9L4Step1Desc => '聽 부엌/밭/앞 的發音';

  @override
  String get hangulS9L4Step2Title => '發音練習';

  @override
  String get hangulS9L4Step2Desc => '親自大聲念出每個字';

  @override
  String get hangulS9L4Step3Title => '辨別韻尾';

  @override
  String get hangulS9L4Step3Desc => '區分這三個韻尾';

  @override
  String get hangulS9L4Step3Q0 => '哪個帶有韻尾 ㅌ？';

  @override
  String get hangulS9L4Step3Q1 => '哪個帶有韻尾 ㅍ？';

  @override
  String get hangulS9L4Step4Title => '課程完成！';

  @override
  String get hangulS9L4Step4Msg => '很好！\n你已掌握韻尾 ㅋ/ㅌ/ㅍ。';

  @override
  String get hangulS9L5Title => '韻尾（받침） ㅎ 進階';

  @override
  String get hangulS9L5Subtitle => '좋 · 놓 · 않';

  @override
  String get hangulS9L5Step0Title => '聽聽看：韻尾 ㅎ';

  @override
  String get hangulS9L5Step0Desc => '聽 좋/놓/않 的發音';

  @override
  String get hangulS9L5Step1Title => '發音練習';

  @override
  String get hangulS9L5Step1Desc => '親自大聲念出每個字';

  @override
  String get hangulS9L5Step2Title => '聽音選字';

  @override
  String get hangulS9L5Step2Desc => '選出帶有韻尾 ㅎ 的音節';

  @override
  String get hangulS9L5Step3Title => '課程完成！';

  @override
  String get hangulS9L5Step3Msg => '很好！\n你已掌握韻尾 ㅎ。';

  @override
  String get hangulS9L6Title => '進階韻尾隨機練習';

  @override
  String get hangulS9L6Subtitle => '混合 ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ';

  @override
  String get hangulS9L6Step0Title => '混合進階韻尾';

  @override
  String get hangulS9L6Step0Desc => '隨機複習所有進階韻尾。';

  @override
  String get hangulS9L6Step1Title => '隨機測驗';

  @override
  String get hangulS9L6Step1Desc => '解題並區分各個韻尾';

  @override
  String get hangulS9L6Step1Q0 => '哪個帶有韻尾 ㄷ？';

  @override
  String get hangulS9L6Step1Q1 => '哪個帶有韻尾 ㅈ？';

  @override
  String get hangulS9L6Step1Q2 => '哪個帶有韻尾 ㅊ？';

  @override
  String get hangulS9L6Step1Q3 => '哪個帶有韻尾 ㅎ？';

  @override
  String get hangulS9L6Step2Title => '課程完成！';

  @override
  String get hangulS9L6Step2Msg => '很好！\n進階韻尾隨機複習完成。';

  @override
  String get hangulS9L7Title => '第9階段綜合';

  @override
  String get hangulS9L7Subtitle => '進階韻尾閱讀收尾';

  @override
  String get hangulS9L7Step0Title => '最終確認';

  @override
  String get hangulS9L7Step0Desc => '最終複習第9階段的核心要點';

  @override
  String get hangulS9L7Step1Title => '第9階段完成！';

  @override
  String get hangulS9L7Step1Msg => '恭喜！\n你已完成第9階段的進階韻尾學習。';

  @override
  String get hangulS9LMTitle => '任務：進階韻尾挑戰！';

  @override
  String get hangulS9LMSubtitle => '快速讀出各種韻尾';

  @override
  String get hangulS9LMStep0Title => '進階韻尾任務！';

  @override
  String get hangulS9LMStep0Desc => '以最快速度組合含進階韻尾的音節！';

  @override
  String get hangulS9LMStep1Title => '組合音節！';

  @override
  String get hangulS9LMStep2Title => '任務結果';

  @override
  String get hangulS9LMStep3Title => '任務完成！';

  @override
  String get hangulS9LMStep3Msg => '你已征服進階韻尾！';

  @override
  String get hangulS9CompleteTitle => '第9階段完成！';

  @override
  String get hangulS9CompleteMsg => '你已征服進階韻尾！';

  @override
  String get hangulS10L1Title => 'ㄳ 韻尾';

  @override
  String get hangulS10L1Subtitle => '以 몫・넋 為中心閱讀';

  @override
  String get hangulS10L1Step0Title => '複合韻尾的發音規則';

  @override
  String get hangulS10L1Step0Desc =>
      '複合韻尾是由兩個子音組合而成的韻尾。\n\n大多數讀左邊的子音：\nㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\n少數讀右邊的子音：\nㄺ→[ㄹ], ㄼ→[ㄹ]';

  @override
  String get hangulS10L1Step0Highlights => '左邊子音,右邊子音,複合韻尾';

  @override
  String get hangulS10L1Step1Title => '開始學習複合韻尾';

  @override
  String get hangulS10L1Step1Desc => '來讀含有 ㄳ 韻尾的單字吧。';

  @override
  String get hangulS10L1Step1Highlights => '몫,넋';

  @override
  String get hangulS10L1Step2Title => '聽發音';

  @override
  String get hangulS10L1Step2Desc => '聽一聽 몫/넋';

  @override
  String get hangulS10L1Step3Title => '發音練習';

  @override
  String get hangulS10L1Step3Desc => '請大聲讀出每個字';

  @override
  String get hangulS10L1Step4Title => '閱讀確認';

  @override
  String get hangulS10L1Step4Desc => '看單字並選擇正確答案';

  @override
  String get hangulS10L1Step4Q0 => '哪個單字有 ㄳ 韻尾？';

  @override
  String get hangulS10L1Step4Q1 => '哪個單字有 ㄳ 韻尾？';

  @override
  String get hangulS10L1Step5Title => '課程完成！';

  @override
  String get hangulS10L1Step5Msg => '很好！\n你已經掌握了 ㄳ 韻尾。';

  @override
  String get hangulS10L2Title => 'ㄵ / ㄶ 韻尾';

  @override
  String get hangulS10L2Subtitle => '앉다・많다';

  @override
  String get hangulS10L2Step0Title => '聽發音';

  @override
  String get hangulS10L2Step0Desc => '聽一聽 앉다/많다';

  @override
  String get hangulS10L2Step1Title => '發音練習';

  @override
  String get hangulS10L2Step1Desc => '請大聲讀出每個字';

  @override
  String get hangulS10L2Step2Title => '聽後選擇';

  @override
  String get hangulS10L2Step2Desc => '選擇正確的單字';

  @override
  String get hangulS10L2Step3Title => '課程完成！';

  @override
  String get hangulS10L2Step3Msg => '很好！\n你已經掌握了 ㄵ/ㄶ 韻尾。';

  @override
  String get hangulS10L3Title => 'ㄺ / ㄻ 韻尾';

  @override
  String get hangulS10L3Subtitle => '읽다・삶';

  @override
  String get hangulS10L3Step0Title => '聽發音';

  @override
  String get hangulS10L3Step0Desc => '聽一聽 읽다/삶';

  @override
  String get hangulS10L3Step1Title => '發音練習';

  @override
  String get hangulS10L3Step1Desc => '請大聲讀出每個字';

  @override
  String get hangulS10L3Step2Title => '閱讀確認';

  @override
  String get hangulS10L3Step2Desc => '選擇含複合韻尾的單字';

  @override
  String get hangulS10L3Step2Q0 => '哪個單字有 ㄺ 韻尾？';

  @override
  String get hangulS10L3Step2Q1 => '哪個單字有 ㄻ 韻尾？';

  @override
  String get hangulS10L3Step3Title => '課程完成！';

  @override
  String get hangulS10L3Step3Msg => '很好！\n你已經掌握了 ㄺ/ㄻ 韻尾。';

  @override
  String get hangulS10L4Title => '進階組合 1';

  @override
  String get hangulS10L4Subtitle => 'ㄼ・ㄾ・ㄿ・ㅀ';

  @override
  String get hangulS10L4Step0Title => '進階組合介紹';

  @override
  String get hangulS10L4Step0Desc => '透過常見例子簡短地學習。';

  @override
  String get hangulS10L4Step0Highlights => '넓다,핥다,읊다,싫다';

  @override
  String get hangulS10L4Step1Title => '聽單字發音';

  @override
  String get hangulS10L4Step1Desc => '聽一聽 넓다/핥다/읊다/싫다';

  @override
  String get hangulS10L4Step2Title => '發音練習';

  @override
  String get hangulS10L4Step2Desc => '請大聲讀出每個字';

  @override
  String get hangulS10L4Step3Title => '課程完成！';

  @override
  String get hangulS10L4Step3Msg => '很好！\n你已經掌握了進階組合 1。';

  @override
  String get hangulS10L5Title => 'ㅄ 韻尾';

  @override
  String get hangulS10L5Subtitle => '以 없다 為中心閱讀';

  @override
  String get hangulS10L5Step0Title => '聽發音';

  @override
  String get hangulS10L5Step0Desc => '聽一聽 없다/없어';

  @override
  String get hangulS10L5Step1Title => '發音練習';

  @override
  String get hangulS10L5Step1Desc => '請大聲讀出每個字';

  @override
  String get hangulS10L5Step2Title => '聽後選擇';

  @override
  String get hangulS10L5Step2Desc => '選擇正確的單字';

  @override
  String get hangulS10L5Step3Title => '課程完成！';

  @override
  String get hangulS10L5Step3Msg => '很好！\n你已經掌握了 ㅄ 韻尾。';

  @override
  String get hangulS10L6Title => '第10階段綜合';

  @override
  String get hangulS10L6Subtitle => '複合韻尾單字綜合';

  @override
  String get hangulS10L6Step0Title => '綜合確認';

  @override
  String get hangulS10L6Step0Desc => '對複合韻尾單字進行最終確認';

  @override
  String get hangulS10L6Step0Q0 => '以下哪個單字有 ㄶ 韻尾？';

  @override
  String get hangulS10L6Step0Q1 => '以下哪個單字有 ㄺ 韻尾？';

  @override
  String get hangulS10L6Step0Q2 => '以下哪個單字有 ㅄ 韻尾？';

  @override
  String get hangulS10L6Step0Q3 => '以下哪個單字有 ㄳ 韻尾？';

  @override
  String get hangulS10L6Step1Title => '第10階段完成！';

  @override
  String get hangulS10L6Step1Msg => '恭喜！\n你完成了第10階段的複合韻尾。';

  @override
  String get hangulS10LMTitle => '任務：複合韻尾挑戰！';

  @override
  String get hangulS10LMSubtitle => '快速閱讀複合韻尾單字';

  @override
  String get hangulS10LMStep0Title => '複合韻尾任務！';

  @override
  String get hangulS10LMStep0Desc => '快速組合包含複合韻尾的音節！';

  @override
  String get hangulS10LMStep1Title => '組合音節！';

  @override
  String get hangulS10LMStep2Title => '任務結果';

  @override
  String get hangulS10LMStep3Title => '任務完成！';

  @override
  String get hangulS10LMStep3Msg => '你連複合韻尾都掌握了！';

  @override
  String get hangulS10LMStep4Title => '第10階段完成！';

  @override
  String get hangulS10CompleteTitle => '第10階段完成！';

  @override
  String get hangulS10CompleteMsg => '你連複合韻尾都掌握了！';

  @override
  String get hangulS11L1Title => '沒有收音的單字';

  @override
  String get hangulS11L1Subtitle => '簡單的2~3音節單字';

  @override
  String get hangulS11L1Step0Title => '開始讀單字';

  @override
  String get hangulS11L1Step0Desc => '先用沒有收音的單字建立自信吧。';

  @override
  String get hangulS11L1Step0Highlights => '바나나,나비,하마,모자';

  @override
  String get hangulS11L1Step1Title => '聽單字';

  @override
  String get hangulS11L1Step1Desc => '聽聽 바나나 / 나비 / 하마 / 모자';

  @override
  String get hangulS11L1Step2Title => '發音練習';

  @override
  String get hangulS11L1Step2Desc => '大聲讀出每個字';

  @override
  String get hangulS11L1Step3Title => '課程完成！';

  @override
  String get hangulS11L1Step3Msg => '很好！\n你開始讀沒有收音的單字了。';

  @override
  String get hangulS11L2Title => '基本收音單字';

  @override
  String get hangulS11L2Subtitle => '학교・친구・한국・공부';

  @override
  String get hangulS11L2Step0Title => '聽單字';

  @override
  String get hangulS11L2Step0Desc => '聽聽 학교 / 친구 / 한국 / 공부';

  @override
  String get hangulS11L2Step1Title => '發音練習';

  @override
  String get hangulS11L2Step1Desc => '大聲讀出每個字';

  @override
  String get hangulS11L2Step2Title => '聽後選擇';

  @override
  String get hangulS11L2Step2Desc => '選擇你聽到的單字';

  @override
  String get hangulS11L2Step3Title => '課程完成！';

  @override
  String get hangulS11L2Step3Msg => '很好！\n你讀了基本收音的單字。';

  @override
  String get hangulS11L3Title => '混合收音單字';

  @override
  String get hangulS11L3Subtitle => '읽기・없다・많다・닭';

  @override
  String get hangulS11L3Step0Title => '提升難度';

  @override
  String get hangulS11L3Step0Desc => '來讀含基本和複合收音的混合單字吧。';

  @override
  String get hangulS11L3Step0Highlights => '읽기,없다,많다,닭';

  @override
  String get hangulS11L3Step1Title => '區分單字';

  @override
  String get hangulS11L3Step1Desc => '區分相似的單字';

  @override
  String get hangulS11L3Step1Q0 => '哪個是複合收音的單字？';

  @override
  String get hangulS11L3Step1Q1 => '哪個是複合收音的單字？';

  @override
  String get hangulS11L3Step2Title => '課程完成！';

  @override
  String get hangulS11L3Step2Msg => '很好！\n你讀了混合收音的單字。';

  @override
  String get hangulS11L4Title => '分類單字包';

  @override
  String get hangulS11L4Subtitle => '食物・地點・人物';

  @override
  String get hangulS11L4Step0Title => '聽分類單字';

  @override
  String get hangulS11L4Step0Desc => '聽食物 / 地點 / 人物的單字';

  @override
  String get hangulS11L4Step1Title => '發音練習';

  @override
  String get hangulS11L4Step1Desc => '大聲讀出每個字';

  @override
  String get hangulS11L4Step2Title => '按類別分類';

  @override
  String get hangulS11L4Step2Desc => '看單字，選擇它的類別';

  @override
  String get hangulS11L4Step2Q0 => '「김치」是什麼？';

  @override
  String get hangulS11L4Step2Q1 => '「시장」是什麼？';

  @override
  String get hangulS11L4Step2Q2 => '「학생」是什麼？';

  @override
  String get hangulS11L4Step2CatFood => '食物';

  @override
  String get hangulS11L4Step2CatPlace => '地點';

  @override
  String get hangulS11L4Step2CatPerson => '人物';

  @override
  String get hangulS11L4Step3Title => '課程完成！';

  @override
  String get hangulS11L4Step3Msg => '很好！\n你學習了分類單字。';

  @override
  String get hangulS11L5Title => '聽後選詞';

  @override
  String get hangulS11L5Subtitle => '加強聽覺與閱讀的聯繫';

  @override
  String get hangulS11L5Step0Title => '聲音配對';

  @override
  String get hangulS11L5Step0Desc => '聽後選出正確的單字';

  @override
  String get hangulS11L5Step1Title => '課程完成！';

  @override
  String get hangulS11L5Step1Msg => '很好！\n你完成了聽後選詞訓練。';

  @override
  String get hangulS11L6Title => '第11階段綜合複習';

  @override
  String get hangulS11L6Subtitle => '單字閱讀最終檢驗';

  @override
  String get hangulS11L6Step0Title => '綜合測驗';

  @override
  String get hangulS11L6Step0Desc => '第11階段單字綜合檢驗';

  @override
  String get hangulS11L6Step0Q0 => '哪個單字沒有收音？';

  @override
  String get hangulS11L6Step0Q1 => '哪個是基本收音的單字？';

  @override
  String get hangulS11L6Step0Q2 => '哪個是複合收音的單字？';

  @override
  String get hangulS11L6Step0Q3 => '哪個是地點單字？';

  @override
  String get hangulS11L6Step1Title => '第11階段完成！';

  @override
  String get hangulS11L6Step1Msg => '恭喜！\n你完成了第11階段擴展單字閱讀。';

  @override
  String get hangulS11L7Title => '在現實中讀韓語';

  @override
  String get hangulS11L7Subtitle => '讀咖啡菜單、捷運站名和問候語';

  @override
  String get hangulS11L7Step0Title => '在韓國讀韓文！';

  @override
  String get hangulS11L7Step0Desc => '你已經學完了所有韓文！\n來讀在韓國能看到的文字吧！';

  @override
  String get hangulS11L7Step0Highlights => '咖啡廳,捷運,問候語';

  @override
  String get hangulS11L7Step1Title => '讀咖啡菜單';

  @override
  String get hangulS11L7Step1Descs => '美式咖啡,拿鐵,綠茶,蛋糕';

  @override
  String get hangulS11L7Step2Title => '讀捷運站名';

  @override
  String get hangulS11L7Step2Descs => '首爾站,江南,弘大入口,明洞';

  @override
  String get hangulS11L7Step3Title => '讀基本問候語';

  @override
  String get hangulS11L7Step3Descs => '你好,謝謝,是,不是';

  @override
  String get hangulS11L7Step4Title => '發音練習';

  @override
  String get hangulS11L7Step4Desc => '大聲讀出每個字';

  @override
  String get hangulS11L7Step5Title => '在哪裡能看到？';

  @override
  String get hangulS11L7Step5Q0 => '「아메리카노」在哪裡能看到？';

  @override
  String get hangulS11L7Step5Q0Ans => '咖啡廳';

  @override
  String get hangulS11L7Step5Q0C0 => '咖啡廳';

  @override
  String get hangulS11L7Step5Q0C1 => '捷運';

  @override
  String get hangulS11L7Step5Q0C2 => '學校';

  @override
  String get hangulS11L7Step5Q1 => '「강남」是什麼？';

  @override
  String get hangulS11L7Step5Q1Ans => '捷運站名';

  @override
  String get hangulS11L7Step5Q1C0 => '食物名稱';

  @override
  String get hangulS11L7Step5Q1C1 => '捷運站名';

  @override
  String get hangulS11L7Step5Q1C2 => '問候語';

  @override
  String get hangulS11L7Step5Q2 => '「감사합니다」用中文是？';

  @override
  String get hangulS11L7Step5Q2Ans => '謝謝';

  @override
  String get hangulS11L7Step5Q2C0 => '你好';

  @override
  String get hangulS11L7Step5Q2C1 => '謝謝';

  @override
  String get hangulS11L7Step5Q2C2 => '再見';

  @override
  String get hangulS11L7Step6Title => '恭喜！';

  @override
  String get hangulS11L7Step6Msg => '你現在能讀韓國的咖啡菜單、捷運站名和問候語了！\n離韓文大師只差一步！';

  @override
  String get hangulS11LMTitle => '任務：韓文速讀！';

  @override
  String get hangulS11LMSubtitle => '快速讀出韓語單字';

  @override
  String get hangulS11LMStep0Title => '韓文速讀任務！';

  @override
  String get hangulS11LMStep0Desc => '盡快讀出並配對韓語單字！\n是時候證明你的實力了！';

  @override
  String get hangulS11LMStep1Title => '組合音節！';

  @override
  String get hangulS11LMStep2Title => '任務結果';

  @override
  String get hangulS11LMStep3Title => '韓文大師！';

  @override
  String get hangulS11LMStep3Msg => '你已經完全掌握韓文了！\n現在可以讀韓語單字和句子了！';

  @override
  String get hangulS11LMStep4Title => '第11階段完成！';

  @override
  String get hangulS11LMStep4Msg => '你現在能完整地讀韓文了！';

  @override
  String get hangulS11CompleteTitle => '第11階段完成！';

  @override
  String get hangulS11CompleteMsg => '你現在能完整地讀韓文了！';

  @override
  String get stageRequestFailed => '傳送上台請求失敗，請重試。';

  @override
  String get stageRequestRejected => '主持人拒絕了你的上台請求。';

  @override
  String get inviteToStageFailed => '邀請上台失敗，舞台可能已滿。';

  @override
  String get demoteFailed => '從舞台移除失敗，請重試。';

  @override
  String get voiceRoomCloseRoomFailed => '關閉房間失敗，請重試。';
}
