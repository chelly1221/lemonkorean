// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appName => 'レモン韓国語';

  @override
  String get login => 'ログイン';

  @override
  String get register => '新規登録';

  @override
  String get email => 'メールアドレス';

  @override
  String get password => 'パスワード';

  @override
  String get confirmPassword => 'パスワード確認';

  @override
  String get username => 'ユーザー名';

  @override
  String get enterEmail => 'メールアドレスを入力してください';

  @override
  String get enterPassword => 'パスワードを入力してください';

  @override
  String get enterConfirmPassword => 'パスワードを再入力してください';

  @override
  String get enterUsername => 'ユーザー名を入力してください';

  @override
  String get createAccount => 'アカウント作成';

  @override
  String get startJourney => '韓国語学習を始めましょう';

  @override
  String get interfaceLanguage => '表示言語';

  @override
  String get simplifiedChinese => '中国語（簡体字）';

  @override
  String get traditionalChinese => '中国語（繁体字）';

  @override
  String get passwordRequirements => 'パスワード要件';

  @override
  String minCharacters(int count) {
    return '$count文字以上';
  }

  @override
  String get containLettersNumbers => '英字と数字を含む';

  @override
  String get haveAccount => 'すでにアカウントをお持ちですか？';

  @override
  String get noAccount => 'アカウントをお持ちでないですか？';

  @override
  String get loginNow => 'ログインする';

  @override
  String get registerNow => '新規登録する';

  @override
  String get registerSuccess => '登録完了';

  @override
  String get registerFailed => '登録に失敗しました';

  @override
  String get loginSuccess => 'ログイン成功';

  @override
  String get loginFailed => 'ログインに失敗しました';

  @override
  String get networkError => 'ネットワーク接続に失敗しました。ネットワーク設定をご確認ください。';

  @override
  String get invalidCredentials => 'メールアドレスまたはパスワードが正しくありません';

  @override
  String get emailAlreadyExists => 'このメールアドレスは既に登録されています';

  @override
  String get requestTimeout => 'リクエストがタイムアウトしました。もう一度お試しください。';

  @override
  String get operationFailed => 'エラーが発生しました。しばらくしてからもう一度お試しください。';

  @override
  String get settings => '設定';

  @override
  String get languageSettings => '言語設定';

  @override
  String get chineseDisplay => '中国語表示';

  @override
  String get chineseDisplayDesc => '中国語の表示方法を選択してください。変更後すぐにすべての画面に適用されます。';

  @override
  String get switchedToSimplified => '簡体字に切り替えました';

  @override
  String get switchedToTraditional => '繁体字に切り替えました';

  @override
  String get displayTip => 'ヒント：レッスンの内容は選択した中国語フォントで表示されます。';

  @override
  String get notificationSettings => '通知設定';

  @override
  String get enableNotifications => '通知を有効にする';

  @override
  String get enableNotificationsDesc => 'オンにすると学習リマインダーを受け取れます';

  @override
  String get permissionRequired => 'システム設定で通知の許可を有効にしてください';

  @override
  String get dailyLearningReminder => '毎日の学習リマインダー';

  @override
  String get dailyReminder => '毎日のリマインダー';

  @override
  String get dailyReminderDesc => '毎日決まった時間に学習リマインダーを送信します';

  @override
  String get reminderTime => 'リマインダー時刻';

  @override
  String reminderTimeSet(String time) {
    return 'リマインダー時刻を$timeに設定しました';
  }

  @override
  String get reviewReminder => '復習リマインダー';

  @override
  String get reviewReminderDesc => '記憶曲線に基づいて復習リマインダーを送信します';

  @override
  String get notificationTip => 'ヒント：';

  @override
  String get helpCenter => 'ヘルプセンター';

  @override
  String get offlineLearning => 'オフライン学習';

  @override
  String get howToDownload => 'レッスンをダウンロードするには？';

  @override
  String get howToDownloadAnswer =>
      'レッスン一覧で右側のダウンロードアイコンをタップするとレッスンをダウンロードできます。ダウンロード後はオフラインで学習できます。';

  @override
  String get howToUseDownloaded => 'ダウンロードしたレッスンを使うには？';

  @override
  String get howToUseDownloadedAnswer =>
      'ネットワーク接続がなくても、ダウンロードしたレッスンは通常通り学習できます。進捗はローカルに保存され、ネットワーク接続時に自動的に同期されます。';

  @override
  String get storageManagement => 'ストレージ管理';

  @override
  String get howToCheckStorage => 'ストレージ容量を確認するには？';

  @override
  String get howToCheckStorageAnswer =>
      '【設定 → ストレージ管理】で使用中と利用可能なストレージ容量を確認できます。';

  @override
  String get howToDeleteDownloaded => 'ダウンロードしたレッスンを削除するには？';

  @override
  String get howToDeleteDownloadedAnswer =>
      '【ストレージ管理】でレッスンの横にある削除ボタンをタップすると削除できます。';

  @override
  String get notificationSection => '通知設定';

  @override
  String get howToEnableReminder => '学習リマインダーを有効にするには？';

  @override
  String get howToEnableReminderAnswer =>
      '【設定 → 通知設定】で【通知を有効にする】スイッチをオンにしてください。初回使用時は通知の許可が必要です。';

  @override
  String get whatIsReviewReminder => '復習リマインダーとは？';

  @override
  String get whatIsReviewReminderAnswer =>
      '間隔反復アルゴリズム（SRS）に基づき、学習したレッスンを最適なタイミングで復習するようリマインドします。復習間隔：1日 → 3日 → 7日 → 14日 → 30日。';

  @override
  String get languageSection => '言語設定';

  @override
  String get howToSwitchChinese => '簡体字と繁体字を切り替えるには？';

  @override
  String get howToSwitchChineseAnswer =>
      '【設定 → 言語設定】で【簡体字】または【繁体字】を選択してください。変更後すぐに反映されます。';

  @override
  String get faq => 'よくある質問';

  @override
  String get howToStart => '学習を始めるには？';

  @override
  String get howToStartAnswer =>
      'メイン画面で自分のレベルに合ったレッスンを選び、レッスン1から始めてください。各レッスンは7つのステージで構成されています。';

  @override
  String get progressNotSaved => '進捗が保存されない場合は？';

  @override
  String get progressNotSavedAnswer =>
      '進捗は自動的にローカルに保存されます。オンライン時にサーバーに自動同期されます。ネットワーク接続をご確認ください。';

  @override
  String get aboutApp => 'アプリについて';

  @override
  String get moreInfo => '詳細情報';

  @override
  String get versionInfo => 'バージョン情報';

  @override
  String get developer => '開発者';

  @override
  String get appIntro => 'アプリ紹介';

  @override
  String get appIntroContent =>
      '多言語対応の韓国語学習アプリです。オフライン学習、スマート復習リマインダーなどの機能をサポートしています。';

  @override
  String get termsOfService => '利用規約';

  @override
  String get termsComingSoon => '利用規約ページは準備中です...';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privacyComingSoon => 'プライバシーポリシーページは準備中です...';

  @override
  String get openSourceLicenses => 'オープンソースライセンス';

  @override
  String get notStarted => '未開始';

  @override
  String get inProgress => '学習中';

  @override
  String get completed => '完了';

  @override
  String get notPassed => '不合格';

  @override
  String get timeToReview => '復習の時間です';

  @override
  String get today => '今日';

  @override
  String get tomorrow => '明日';

  @override
  String daysLater(int count) {
    return '$count日後';
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
  String get pronoun => '代名詞';

  @override
  String get highSimilarity => '高い類似度';

  @override
  String get mediumSimilarity => '中程度の類似度';

  @override
  String get lowSimilarity => '低い類似度';

  @override
  String get learningComplete => '学習完了';

  @override
  String experiencePoints(int points) {
    return '経験値 +$points';
  }

  @override
  String get keepLearning => 'この調子で学習を続けましょう！';

  @override
  String get streakDays => '連続学習 +1日';

  @override
  String streakDaysCount(int days) {
    return '連続$days日学習中';
  }

  @override
  String get lessonContent => 'このレッスンの学習内容';

  @override
  String get words => '単語';

  @override
  String get grammarPoints => '文法ポイント';

  @override
  String get dialogues => '会話';

  @override
  String get previous => '前へ';

  @override
  String get next => '次へ';

  @override
  String get topicParticle => '主題助詞';

  @override
  String get honorificEnding => '敬語語尾';

  @override
  String get questionWord => '何';

  @override
  String get hello => 'こんにちは';

  @override
  String get thankYou => 'ありがとうございます';

  @override
  String get goodbye => 'さようなら';

  @override
  String get sorry => 'すみません';

  @override
  String get imStudent => '私は学生です';

  @override
  String get bookInteresting => '本が面白いです';

  @override
  String get isStudent => '学生です';

  @override
  String get isTeacher => '先生です';

  @override
  String get whatIsThis => 'これは何ですか？';

  @override
  String get whatDoingPolite => '何をしていますか？';

  @override
  String get listenAndChoose => '聞いて正しい訳を選んでください';

  @override
  String get fillInBlank => '正しい助詞を入れてください';

  @override
  String get chooseTranslation => '正しい訳を選んでください';

  @override
  String get arrangeWords => '正しい順序に単語を並べてください';

  @override
  String get choosePronunciation => '正しい発音を選んでください';

  @override
  String get consonantEnding => '名詞が子音で終わる場合、どの主題助詞を使いますか？';

  @override
  String get correctSentence => '正しい文を選んでください';

  @override
  String get allCorrect => 'すべて正解';

  @override
  String get howAreYou => 'お元気ですか？';

  @override
  String get whatIsYourName => 'お名前は何ですか？';

  @override
  String get whoAreYou => 'どなたですか？';

  @override
  String get whereAreYou => 'どこにいますか？';

  @override
  String get niceToMeetYou => 'はじめまして';

  @override
  String get areYouStudent => 'あなたは学生です';

  @override
  String get areYouStudentQuestion => '学生ですか？';

  @override
  String get amIStudent => '私は学生ですか？';

  @override
  String get listening => 'リスニング';

  @override
  String get translation => '翻訳';

  @override
  String get wordOrder => '語順';

  @override
  String get excellent => '素晴らしい！';

  @override
  String get correctOrderIs => '正しい順序：';

  @override
  String get nextQuestion => '次の問題';

  @override
  String get finish => '完了';

  @override
  String get quizComplete => 'クイズ完了！';

  @override
  String get greatJob => 'よくできました！';

  @override
  String get keepPracticing => '頑張って！';

  @override
  String score(int correct, int total) {
    return 'スコア：$correct / $total';
  }

  @override
  String get masteredContent => 'このレッスンの内容をマスターしました！';

  @override
  String get reviewSuggestion => 'レッスン内容を復習してから再挑戦してみましょう！';

  @override
  String timeUsed(String time) {
    return '所要時間：$time';
  }

  @override
  String get playAudio => '音声を再生';

  @override
  String get replayAudio => 'もう一度再生';

  @override
  String get vowelEnding => '母音で終わる場合は：';

  @override
  String lessonNumber(int number) {
    return 'レッスン$number';
  }

  @override
  String get stageIntro => 'レッスン紹介';

  @override
  String get stageVocabulary => '語彙学習';

  @override
  String get stageGrammar => '文法説明';

  @override
  String get stagePractice => '練習';

  @override
  String get stageDialogue => '会話練習';

  @override
  String get stageQuiz => 'クイズ';

  @override
  String get stageSummary => 'まとめ';

  @override
  String get downloadLesson => 'レッスンをダウンロード';

  @override
  String get downloading => 'ダウンロード中...';

  @override
  String get downloaded => 'ダウンロード済み';

  @override
  String get downloadFailed => 'ダウンロード失敗';

  @override
  String get home => 'ホーム';

  @override
  String get lessons => 'レッスン';

  @override
  String get review => '復習';

  @override
  String get profile => 'マイページ';

  @override
  String get continueLearning => '学習を続ける';

  @override
  String get dailyGoal => '毎日の目標';

  @override
  String lessonsCompleted(int count) {
    return '$countレッスン完了';
  }

  @override
  String minutesLearned(int minutes) {
    return '$minutes分学習';
  }

  @override
  String get welcome => 'おかえりなさい';

  @override
  String get goodMorning => 'おはようございます';

  @override
  String get goodAfternoon => 'こんにちは';

  @override
  String get goodEvening => 'こんばんは';

  @override
  String get logout => 'ログアウト';

  @override
  String get confirmLogout => 'ログアウトしてもよろしいですか？';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get edit => '編集';

  @override
  String get close => '閉じる';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get noData => 'データがありません';

  @override
  String get error => 'エラーが発生しました';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get reload => '再読み込み';

  @override
  String get noCharactersAvailable => '文字がありません';

  @override
  String get success => '成功';

  @override
  String get filter => 'フィルター';

  @override
  String get reviewSchedule => '復習スケジュール';

  @override
  String get todayReview => '今日の復習';

  @override
  String get startReview => '復習を始める';

  @override
  String get learningStats => '学習統計';

  @override
  String get completedLessonsCount => '完了したレッスン';

  @override
  String get studyDays => '学習日数';

  @override
  String get masteredWordsCount => '習得した単語';

  @override
  String get myVocabularyBook => 'マイ単語帳';

  @override
  String get vocabularyBrowser => '単語一覧';

  @override
  String get about => '情報';

  @override
  String get premiumMember => 'プレミアム会員';

  @override
  String get freeUser => '無料ユーザー';

  @override
  String wordsWaitingReview(int count) {
    return '$count個の単語が復習待ち';
  }

  @override
  String get user => 'ユーザー';

  @override
  String get onboardingSkip => 'スキップ';

  @override
  String get onboardingLanguageTitle => 'はじめまして！モニです';

  @override
  String get onboardingLanguagePrompt => 'どの言語から一緒に学びますか？';

  @override
  String get onboardingNext => '次へ';

  @override
  String get onboardingWelcome => 'こんにちは！レモン韓国語のレモンです 🍋\n一緒に韓国語を勉強しませんか？';

  @override
  String get onboardingLevelQuestion => '現在の韓国語レベルは？';

  @override
  String get onboardingStart => '始める';

  @override
  String get onboardingStartWithoutLevel => 'スキップして始める';

  @override
  String get levelBeginner => '入門';

  @override
  String get levelBeginnerDesc => '大丈夫です！ハングルから始めましょう';

  @override
  String get levelElementary => '初級';

  @override
  String get levelElementaryDesc => '基礎会話から練習しましょう！';

  @override
  String get levelIntermediate => '中級';

  @override
  String get levelIntermediateDesc => 'より自然に話しましょう！';

  @override
  String get levelAdvanced => '上級';

  @override
  String get levelAdvancedDesc => '細かい表現まで極めましょう！';

  @override
  String get onboardingWelcomeTitle => 'レモン韓国語へようこそ！';

  @override
  String get onboardingWelcomeSubtitle => '流暢さへの旅がここから始まります';

  @override
  String get onboardingFeature1Title => 'いつでもオフライン学習';

  @override
  String get onboardingFeature1Desc => 'レッスンをダウンロードしてインターネットなしで学習';

  @override
  String get onboardingFeature2Title => 'スマート復習システム';

  @override
  String get onboardingFeature2Desc => 'AIを活用した間隔反復学習で記憶力アップ';

  @override
  String get onboardingFeature3Title => '7ステージ学習パス';

  @override
  String get onboardingFeature3Desc => '初心者から上級者まで体系的なカリキュラム';

  @override
  String get onboardingLevelTitle => 'あなたの韓国語レベルは？';

  @override
  String get onboardingLevelSubtitle => 'あなたに合わせた体験を提供します';

  @override
  String get onboardingGoalTitle => '週間目標を設定';

  @override
  String get onboardingGoalSubtitle => 'どのくらいの時間を確保できますか？';

  @override
  String get goalCasual => 'カジュアル';

  @override
  String get goalCasualDesc => '週1-2レッスン';

  @override
  String get goalCasualTime => '~週10-20分';

  @override
  String get goalCasualHelper => '忙しいスケジュールに最適';

  @override
  String get goalRegular => 'コツコツ';

  @override
  String get goalRegularDesc => '週3-4レッスン';

  @override
  String get goalRegularTime => '~週30-40分';

  @override
  String get goalRegularHelper => 'プレッシャーなく着実に進歩';

  @override
  String get goalSerious => '本格派';

  @override
  String get goalSeriousDesc => '週5-6レッスン';

  @override
  String get goalSeriousTime => '~週50-60分';

  @override
  String get goalSeriousHelper => '速い上達を目指す';

  @override
  String get goalIntensive => '集中';

  @override
  String get goalIntensiveDesc => '毎日練習';

  @override
  String get goalIntensiveTime => '週60分以上';

  @override
  String get goalIntensiveHelper => '最速の学習スピード';

  @override
  String get onboardingCompleteTitle => '準備完了！';

  @override
  String get onboardingCompleteSubtitle => '学習の旅を始めましょう';

  @override
  String get onboardingSummaryLanguage => '表示言語';

  @override
  String get onboardingSummaryLevel => '韓国語レベル';

  @override
  String get onboardingSummaryGoal => '週間目標';

  @override
  String get onboardingStartLearning => '学習を始める';

  @override
  String get onboardingBack => '戻る';

  @override
  String get onboardingAccountTitle => '準備はできましたか？';

  @override
  String get onboardingAccountSubtitle => 'ログインまたはアカウントを作成して学習進捗を保存しましょう';

  @override
  String levelTopik(String level) {
    return 'TOPIK $level';
  }

  @override
  String get appLanguage => 'アプリ言語';

  @override
  String get appLanguageDesc => 'アプリインターフェースで使用する言語を選択してください。';

  @override
  String languageSelected(String language) {
    return '$language を選択しました';
  }

  @override
  String get sort => '並べ替え';

  @override
  String get notificationTipContent =>
      '• 復習リマインダーはレッスン完了後に自動的に予約されます\n• 一部のデバイスでは、通知を正常に受信するためにシステム設定でバッテリーセーバーを無効にする必要があります';

  @override
  String get yesterday => '昨日';

  @override
  String daysAgo(int count) {
    return '$count日前';
  }

  @override
  String dateFormat(int month, int day) {
    return '$month月$day日';
  }

  @override
  String get downloadManager => 'ダウンロード管理';

  @override
  String get storageInfo => 'ストレージ情報';

  @override
  String get clearAllDownloads => 'すべて削除';

  @override
  String get downloadedTab => 'ダウンロード済み';

  @override
  String get availableTab => 'ダウンロード可能';

  @override
  String get downloadedLessons => 'ダウンロード済みレッスン';

  @override
  String get mediaFiles => 'メディアファイル';

  @override
  String get usedStorage => '使用中';

  @override
  String get cacheStorage => 'キャッシュ';

  @override
  String get totalStorage => '合計';

  @override
  String get allDownloadsCleared => 'すべてのダウンロードを削除しました';

  @override
  String get availableStorage => '利用可能';

  @override
  String get noDownloadedLessons => 'ダウンロード済みのレッスンはありません';

  @override
  String get goToAvailableTab => '「ダウンロード可能」タブでレッスンをダウンロード';

  @override
  String get allLessonsDownloaded => 'すべてのレッスンがダウンロード済みです';

  @override
  String get deleteDownload => 'ダウンロードを削除';

  @override
  String confirmDeleteDownload(String title) {
    return '「$title」を削除してもよろしいですか？';
  }

  @override
  String confirmClearAllDownloads(int count) {
    return '$count件のダウンロードをすべて削除してもよろしいですか？';
  }

  @override
  String downloadingCount(int count) {
    return 'ダウンロード中 ($count)';
  }

  @override
  String get preparing => '準備中...';

  @override
  String lessonId(int id) {
    return 'レッスン $id';
  }

  @override
  String get searchWords => '単語を検索...';

  @override
  String wordCount(int count) {
    return '$count個の単語';
  }

  @override
  String get sortByLesson => 'レッスン順';

  @override
  String get sortByKorean => '韓国語順';

  @override
  String get sortByChinese => '日本語順';

  @override
  String get noWordsFound => '単語が見つかりません';

  @override
  String get noMasteredWords => '習得した単語はまだありません';

  @override
  String get hanja => '漢字';

  @override
  String get exampleSentence => '例文';

  @override
  String get mastered => '習得済み';

  @override
  String get completedLessons => '完了したレッスン';

  @override
  String get noCompletedLessons => '完了したレッスンはありません';

  @override
  String get startFirstLesson => '最初のレッスンを始めましょう！';

  @override
  String get masteredWords => '習得した単語';

  @override
  String get download => 'ダウンロード';

  @override
  String get hangulLearning => 'ハングル学習';

  @override
  String get hangulLearningSubtitle => 'ハングル40文字を学ぶ';

  @override
  String get editNotes => 'メモを編集';

  @override
  String get notes => 'メモ';

  @override
  String get notesHint => 'なぜこの単語を保存するのですか？';

  @override
  String get sortBy => '並び替え';

  @override
  String get sortNewest => '最新順';

  @override
  String get sortOldest => '古い順';

  @override
  String get sortKorean => '韓国語順';

  @override
  String get sortChinese => '日本語';

  @override
  String get sortMastery => '習熟度順';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterNew => '新しい単語 (レベル0)';

  @override
  String get filterBeginner => '初級 (レベル1)';

  @override
  String get filterIntermediate => '中級 (レベル2-3)';

  @override
  String get filterAdvanced => '上級 (レベル4-5)';

  @override
  String get searchWordsNotesChinese => '単語、日本語訳、メモを検索...';

  @override
  String startReviewCount(int count) {
    return '復習を始める ($count)';
  }

  @override
  String get remove => '削除';

  @override
  String get confirmRemove => '削除の確認';

  @override
  String confirmRemoveWord(String word) {
    return '単語帳から「$word」を削除しますか？';
  }

  @override
  String get noBookmarkedWords => '保存した単語がありません';

  @override
  String get bookmarkHint => '学習中に単語カードのブックマークアイコンをタップしてください';

  @override
  String get noMatchingWords => '一致する単語がありません';

  @override
  String weeksAgo(int count) {
    return '$count週間前';
  }

  @override
  String get reviewComplete => '復習完了！';

  @override
  String reviewCompleteCount(int count) {
    return '$count個の単語を復習しました';
  }

  @override
  String get correct => '正解';

  @override
  String get wrong => '不正解';

  @override
  String get accuracy => '正確率';

  @override
  String get vocabularyBookReview => '単語帳復習';

  @override
  String get noWordsToReview => '復習する単語がありません';

  @override
  String get bookmarkWordsToReview => '単語を保存して復習を開始してください';

  @override
  String get returnToVocabularyBook => '単語帳に戻る';

  @override
  String get exit => '終了';

  @override
  String get showAnswer => '答えを見る';

  @override
  String get didYouRemember => '覚えていましたか？';

  @override
  String get forgot => '忘れた';

  @override
  String get hard => '難しい';

  @override
  String get remembered => '覚えていた';

  @override
  String get easy => '簡単';

  @override
  String get addedToVocabularyBook => '単語帳に追加しました';

  @override
  String get addFailed => '追加に失敗しました';

  @override
  String get removedFromVocabularyBook => '単語帳から削除しました';

  @override
  String get removeFailed => '削除に失敗しました';

  @override
  String get addToVocabularyBook => '単語帳に追加';

  @override
  String get notesOptional => 'メモ（任意）';

  @override
  String get add => '追加';

  @override
  String get bookmarked => '保存済み';

  @override
  String get bookmark => '保存';

  @override
  String get removeFromVocabularyBook => '単語帳から削除';

  @override
  String similarityPercent(int percent) {
    return '類似度: $percent%';
  }

  @override
  String addedOrRemoved(String added) {
    String _temp0 = intl.Intl.selectLogic(
      added,
      {
        'true': '単語帳に追加しました',
        'other': 'ブックマークを解除しました',
      },
    );
    return '$_temp0';
  }

  @override
  String get days => '日';

  @override
  String lessonsCompletedCount(int count) {
    return '$count個完了';
  }

  @override
  String get dailyGoalComplete => '今日の目標達成！';

  @override
  String get hangulAlphabet => 'ハングル';

  @override
  String get alphabetTable => '一覧表';

  @override
  String get learn => '学習';

  @override
  String get practice => '練習';

  @override
  String get learningProgress => '学習進度';

  @override
  String dueForReviewCount(int count) {
    return '$count個復習待ち';
  }

  @override
  String get completion => '完成度';

  @override
  String get totalCharacters => '全文字';

  @override
  String get learned => '学習済み';

  @override
  String get dueForReview => '復習待ち';

  @override
  String overallAccuracy(String percent) {
    return '全体正確率: $percent%';
  }

  @override
  String charactersCount(int count) {
    return '$count文字';
  }

  @override
  String get lesson1Title => '第1課：基本子音（上）';

  @override
  String get lesson1Desc => 'よく使われる子音7つを学ぶ';

  @override
  String get lesson2Title => '第2課：基本子音（下）';

  @override
  String get lesson2Desc => '残りの基本子音7つを学ぶ';

  @override
  String get lesson3Title => '第3課：基本母音（上）';

  @override
  String get lesson3Desc => '基本母音5つを学ぶ';

  @override
  String get lesson4Title => '第4課：基本母音（下）';

  @override
  String get lesson4Desc => '残りの基本母音5つを学ぶ';

  @override
  String get lesson5Title => '第5課：濃音';

  @override
  String get lesson5Desc => '濃音5つを学ぶ - 強い音';

  @override
  String get lesson6Title => '第6課：合成母音（上）';

  @override
  String get lesson6Desc => '合成母音6つを学ぶ';

  @override
  String get lesson7Title => '第7課：合成母音（下）';

  @override
  String get lesson7Desc => '残りの合成母音を学ぶ';

  @override
  String get loadAlphabetFirst => 'まずハングル一覧データを読み込んでください';

  @override
  String get noContentForLesson => 'この課には内容がありません';

  @override
  String get exampleWords => '例単語';

  @override
  String get thisLessonCharacters => 'この課の文字';

  @override
  String congratsLessonComplete(String title) {
    return '$titleを完了しました！';
  }

  @override
  String get continuePractice => '練習を続ける';

  @override
  String get nextLesson => '次の課';

  @override
  String get basicConsonants => '基本子音';

  @override
  String get doubleConsonants => '濃音';

  @override
  String get basicVowels => '基本母音';

  @override
  String get compoundVowels => '合成母音';

  @override
  String get dailyLearningReminderTitle => '毎日の学習リマインダー';

  @override
  String get dailyLearningReminderBody => '今日の韓国語学習を完了しましょう！';

  @override
  String get reviewReminderTitle => '復習の時間です！';

  @override
  String reviewReminderBody(String title) {
    return '「$title」を復習する時間です！';
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
  String get strokeOrder => '書き順';

  @override
  String get reset => 'リセット';

  @override
  String get pronunciationGuide => '発音ガイド';

  @override
  String get play => '再生';

  @override
  String get pause => '一時停止';

  @override
  String loadingFailed(String error) {
    return '読み込み失敗: $error';
  }

  @override
  String learnedCount(int count) {
    return '学習済み: $count';
  }

  @override
  String get hangulPractice => 'ハングル練習';

  @override
  String charactersNeedReview(int count) {
    return '$count文字復習が必要';
  }

  @override
  String charactersAvailable(int count) {
    return '$count文字練習可能';
  }

  @override
  String get selectPracticeMode => '練習モードを選択';

  @override
  String get characterRecognition => '文字認識';

  @override
  String get characterRecognitionDesc => '文字を見て正しい発音を選択';

  @override
  String get pronunciationPractice => '発音練習';

  @override
  String get pronunciationPracticeDesc => '発音を見て正しい文字を選択';

  @override
  String get startPractice => '練習開始';

  @override
  String get learnSomeCharactersFirst => '先に字母表で文字を学んでください';

  @override
  String get practiceComplete => '練習完了！';

  @override
  String get back => '戻る';

  @override
  String get tryAgain => 'もう一度';

  @override
  String get howToReadThis => 'この文字の読み方は？';

  @override
  String get selectCorrectCharacter => '正しい文字を選択してください';

  @override
  String get correctExclamation => '正解！';

  @override
  String get incorrectExclamation => '不正解';

  @override
  String get correctAnswerLabel => '正解: ';

  @override
  String get nextQuestionBtn => '次の問題';

  @override
  String get viewResults => '結果を見る';

  @override
  String get share => '共有';

  @override
  String get mnemonics => '記憶のコツ';

  @override
  String nextReviewLabel(String date) {
    return '次の復習: $date';
  }

  @override
  String get expired => '期限切れ';

  @override
  String get practiceFunctionDeveloping => '練習機能開発中';

  @override
  String get romanization => 'ローマ字: ';

  @override
  String get pronunciationLabel => '発音: ';

  @override
  String get playPronunciation => '発音を再生';

  @override
  String strokesCount(int count) {
    return '$count画';
  }

  @override
  String get perfectCount => '完璧';

  @override
  String get loadFailed => '読み込み失敗';

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
  String get exitLesson => '学習終了';

  @override
  String get exitLessonConfirm => '本当に終了しますか？進捗は保存されます。';

  @override
  String get exitBtn => '終了';

  @override
  String get lessonComplete => 'レッスン完了！進捗が保存されました';

  @override
  String loadingLesson(String title) {
    return '$title を読み込み中...';
  }

  @override
  String get cannotLoadContent => 'レッスンコンテンツを読み込めません';

  @override
  String get noLessonContent => 'このレッスンにはコンテンツがありません';

  @override
  String stageProgress(int current, int total) {
    return 'ステージ $current / $total';
  }

  @override
  String unknownStageType(String type) {
    return '不明なステージタイプ: $type';
  }

  @override
  String wordsCount(int count) {
    return '$count 単語';
  }

  @override
  String get startLearning => '学習を始める';

  @override
  String get vocabularyLearning => '語彙学習';

  @override
  String get noImage => '画像なし';

  @override
  String get previousItem => '前へ';

  @override
  String get nextItem => '次へ';

  @override
  String get continueBtn => '続ける';

  @override
  String get previousQuestion => '前の問題';

  @override
  String get playingAudio => '再生中...';

  @override
  String get playAll => '全て再生';

  @override
  String audioPlayFailed(String error) {
    return 'オーディオ再生失敗: $error';
  }

  @override
  String get stopBtn => '停止';

  @override
  String get playAudioBtn => 'オーディオ再生';

  @override
  String get playingAudioShort => 'オーディオ再生中...';

  @override
  String get pronunciation => '発音';

  @override
  String grammarPattern(String pattern) {
    return '文法 · $pattern';
  }

  @override
  String get grammarExplanation => '文法説明';

  @override
  String get conjugationRule => '活用ルール';

  @override
  String get comparisonWithChinese => '日本語との比較';

  @override
  String get exampleSentences => '例文';

  @override
  String get dialogueTitle => '会話練習';

  @override
  String get dialogueExplanation => '会話解説';

  @override
  String speaker(String name) {
    return '話者 $name';
  }

  @override
  String get practiceTitle => '練習';

  @override
  String get practiceInstructions => '以下の練習問題を完成させてください';

  @override
  String get fillBlank => '空欄を埋める';

  @override
  String get checkAnswerBtn => '答え合わせ';

  @override
  String correctAnswerIs(String answer) {
    return '正解: $answer';
  }

  @override
  String get quizTitle => 'クイズ';

  @override
  String get quizResult => 'クイズ結果';

  @override
  String quizScoreDisplay(int correct, int total) {
    return '$correct/$total';
  }

  @override
  String quizAccuracy(int percent) {
    return '正答率: $percent%';
  }

  @override
  String get summaryTitle => 'レッスンまとめ';

  @override
  String get vocabLearned => '学習した単語';

  @override
  String get grammarLearned => '学習した文法';

  @override
  String get finishLesson => 'レッスン完了';

  @override
  String get reviewVocab => '単語を復習';

  @override
  String similarity(int percent) {
    return '類似度: $percent%';
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
  String get partOfSpeechPronoun => '代名詞';

  @override
  String get partOfSpeechParticle => '助詞';

  @override
  String get partOfSpeechConjunction => '接続詞';

  @override
  String get partOfSpeechInterjection => '感嘆詞';

  @override
  String get noVocabulary => '語彙データがありません';

  @override
  String get noGrammar => '文法データがありません';

  @override
  String get noPractice => '練習問題がありません';

  @override
  String get noDialogue => '会話コンテンツがありません';

  @override
  String get noQuiz => 'クイズ問題がありません';

  @override
  String get tapToFlip => 'タップで裏返す';

  @override
  String get listeningQuestion => 'リスニング';

  @override
  String get submit => '提出';

  @override
  String timeStudied(String time) {
    return '学習時間 $time';
  }

  @override
  String get statusNotStarted => '未開始';

  @override
  String get statusInProgress => '進行中';

  @override
  String get statusCompleted => '完了';

  @override
  String get statusFailed => '未合格';

  @override
  String get masteryNew => '新規';

  @override
  String get masteryLearning => '学習中';

  @override
  String get masteryFamiliar => '習得中';

  @override
  String get masteryMastered => '習得済み';

  @override
  String get masteryExpert => '熟練';

  @override
  String get masteryPerfect => '完璧';

  @override
  String get masteryUnknown => '不明';

  @override
  String get dueForReviewNow => '復習が必要';

  @override
  String get similarityHigh => '高い類似度';

  @override
  String get similarityMedium => '中程度の類似度';

  @override
  String get similarityLow => '低い類似度';

  @override
  String get typeBasicConsonant => '基本子音';

  @override
  String get typeDoubleConsonant => '濃音';

  @override
  String get typeBasicVowel => '基本母音';

  @override
  String get typeCompoundVowel => '複合母音';

  @override
  String get typeFinalConsonant => 'パッチム';

  @override
  String get dailyReminderChannel => '毎日の学習リマインダー';

  @override
  String get dailyReminderChannelDesc => '毎日決まった時間に韓国語学習をお知らせします';

  @override
  String get reviewReminderChannel => '復習リマインダー';

  @override
  String get reviewReminderChannelDesc => '間隔反復アルゴリズムに基づく復習通知';

  @override
  String get notificationStudyTime => '学習の時間です！';

  @override
  String get notificationStudyReminder => '今日の韓国語学習を完了しましょう！';

  @override
  String get notificationReviewTime => '復習の時間です！';

  @override
  String get notificationReviewReminder => '以前学んだ内容を復習しましょう！';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return '「$lessonTitle」を復習しましょう！';
  }

  @override
  String get keepGoing => '頑張って！';

  @override
  String scoreDisplay(int correct, int total) {
    return 'スコア：$correct / $total';
  }

  @override
  String loadDataError(String error) {
    return 'データの読み込みに失敗しました: $error';
  }

  @override
  String downloadError(String error) {
    return 'ダウンロードエラー: $error';
  }

  @override
  String deleteError(String error) {
    return '削除に失敗しました: $error';
  }

  @override
  String clearAllError(String error) {
    return '全削除に失敗しました: $error';
  }

  @override
  String cleanupError(String error) {
    return 'クリーンアップに失敗しました: $error';
  }

  @override
  String downloadLessonFailed(String title) {
    return 'ダウンロード失敗: $title';
  }

  @override
  String get comprehensive => '総合';

  @override
  String answeredCount(int answered, int total) {
    return '回答 $answered/$total';
  }

  @override
  String get hanjaWord => '漢字語';

  @override
  String get tapToFlipBack => 'タップして裏返す';

  @override
  String get similarityWithChinese => '日本語との類似度';

  @override
  String get hanjaWordSimilarPronunciation => '漢字語、発音が似ている';

  @override
  String get sameEtymologyEasyToRemember => '語源が同じで覚えやすい';

  @override
  String get someConnection => 'ある程度の関連性あり';

  @override
  String get nativeWordNeedsMemorization => '固有語、暗記が必要';

  @override
  String get rules => 'ルール';

  @override
  String get koreanLanguage => '🇰🇷 韓国語';

  @override
  String get chineseLanguage => '🇨🇳 中国語';

  @override
  String exampleNumber(int number) {
    return '例 $number';
  }

  @override
  String get fillInBlankPrompt => '空欄を埋める：';

  @override
  String get correctFeedback => '素晴らしい！正解！';

  @override
  String get incorrectFeedback => '惜しいです！もう一度挑戦してみましょう';

  @override
  String get allStagesPassed => '7段階すべてクリア';

  @override
  String get continueToLearnMore => 'もっと学習を続けましょう';

  @override
  String timeFormatHMS(int hours, int minutes, int seconds) {
    return '$hours時間$minutes分$seconds秒';
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
  String get repeatEnabled => 'リピート有効';

  @override
  String get repeatDisabled => 'リピート無効';

  @override
  String get stop => '停止';

  @override
  String get playbackSpeed => '再生速度';

  @override
  String get slowSpeed => 'ゆっくり';

  @override
  String get normalSpeed => '通常';

  @override
  String get mouthShape => '口の形';

  @override
  String get tonguePosition => '舌の位置';

  @override
  String get airFlow => '気流';

  @override
  String get nativeComparison => '母語との比較';

  @override
  String get similarSounds => '似た音';

  @override
  String get soundDiscrimination => '音の聞き分け練習';

  @override
  String get listenAndSelect => '聞いて正しい文字を選んでください';

  @override
  String get similarSoundGroups => '似た音のグループ';

  @override
  String get plainSound => '平音';

  @override
  String get aspiratedSound => '激音';

  @override
  String get tenseSound => '濃音';

  @override
  String get writingPractice => '書き取り練習';

  @override
  String get watchAnimation => 'アニメーションを見る';

  @override
  String get traceWithGuide => 'ガイドに沿って書く';

  @override
  String get freehandWriting => '自由に書く';

  @override
  String get clearCanvas => 'クリア';

  @override
  String get showGuide => 'ガイド表示';

  @override
  String get hideGuide => 'ガイド非表示';

  @override
  String get writingAccuracy => '正確度';

  @override
  String get tryAgainWriting => 'もう一度';

  @override
  String get nextStep => '次のステップ';

  @override
  String strokeOrderStep(int current, int total) {
    return 'ステップ $current/$total';
  }

  @override
  String get syllableCombination => '音節の組み合わせ';

  @override
  String get selectConsonant => '子音を選択';

  @override
  String get selectVowel => '母音を選択';

  @override
  String get selectFinalConsonant => 'パッチムを選択（任意）';

  @override
  String get noFinalConsonant => 'パッチムなし';

  @override
  String get combinedSyllable => '組み合わせた音節';

  @override
  String get playSyllable => '音節を再生';

  @override
  String get decomposeSyllable => '音節を分解';

  @override
  String get batchimPractice => 'パッチム練習';

  @override
  String get batchimExplanation => 'パッチムの説明';

  @override
  String get recordPronunciation => '録音練習';

  @override
  String get startRecording => '録音開始';

  @override
  String get stopRecording => '録音停止';

  @override
  String get playRecording => '録音を再生';

  @override
  String get compareWithNative => 'ネイティブと比較';

  @override
  String get shadowingMode => 'シャドーイングモード';

  @override
  String get listenThenRepeat => '聞いてから繰り返す';

  @override
  String get selfEvaluation => '自己評価';

  @override
  String get accurate => '正確';

  @override
  String get almostCorrect => 'ほぼ正確';

  @override
  String get needsPractice => '練習が必要';

  @override
  String get recordingNotSupported => 'このプラットフォームでは録音がサポートされていません';

  @override
  String get showMeaning => '意味を表示';

  @override
  String get hideMeaning => '意味を隠す';

  @override
  String get exampleWord => '例単語';

  @override
  String get meaningToggle => '意味表示設定';

  @override
  String get microphonePermissionRequired => '録音にはマイクの許可が必要です';

  @override
  String get activities => 'アクティビティ';

  @override
  String get listeningAndSpeaking => 'リスニング＆スピーキング';

  @override
  String get readingAndWriting => 'リーディング＆ライティング';

  @override
  String get soundDiscriminationDesc => '似た音を聞き分ける練習';

  @override
  String get shadowingDesc => 'ネイティブの発音をまねる';

  @override
  String get syllableCombinationDesc => '子音と母音の組み合わせを学ぶ';

  @override
  String get batchimPracticeDesc => 'パッチム（終声）の練習';

  @override
  String get writingPracticeDesc => 'ハングル文字の書き練習';

  @override
  String get webNotSupported => 'ウェブでは利用不可';

  @override
  String get chapter => 'チャプター';

  @override
  String get bossQuiz => 'ボスクイズ';

  @override
  String get bossQuizCleared => 'ボスクイズクリア！';

  @override
  String get bossQuizBonus => 'ボーナスレモン';

  @override
  String get lemonsScoreHint95 => '95%以上で3つのレモン';

  @override
  String get lemonsScoreHint80 => '80%以上で2つのレモン';

  @override
  String get myLemonTree => '私のレモンの木';

  @override
  String get harvestLemon => 'レモンを収穫';

  @override
  String get watchAdToHarvest => '広告を見てレモンを収穫しますか？';

  @override
  String get lemonHarvested => 'レモンを収穫しました！';

  @override
  String get lemonsAvailable => '個のレモンが収穫可能';

  @override
  String get completeMoreLessons => 'レッスンを完了してレモンを育てましょう';

  @override
  String get totalLemons => 'レモン合計';

  @override
  String get community => 'コミュニティ';

  @override
  String get following => 'フォロー中';

  @override
  String get discover => '発見';

  @override
  String get createPost => '投稿作成';

  @override
  String get writePost => '何か書いてみましょう...';

  @override
  String get postCategory => 'カテゴリー';

  @override
  String get categoryLearning => '学習';

  @override
  String get categoryGeneral => '一般';

  @override
  String get categoryAll => 'すべて';

  @override
  String get post => '投稿';

  @override
  String get like => 'いいね';

  @override
  String get comment => 'コメント';

  @override
  String get writeComment => 'コメントを書く...';

  @override
  String replyingTo(String name) {
    return '$nameさんに返信';
  }

  @override
  String get reply => '返信';

  @override
  String get deletePost => '投稿を削除';

  @override
  String get deletePostConfirm => 'この投稿を削除しますか？';

  @override
  String get deleteComment => 'コメントを削除';

  @override
  String get postDeleted => '投稿が削除されました';

  @override
  String get commentDeleted => 'コメントが削除されました';

  @override
  String get noPostsYet => 'まだ投稿がありません';

  @override
  String get followToSeePosts => 'ユーザーをフォローすると投稿がここに表示されます';

  @override
  String get discoverPosts => 'コミュニティの投稿を探してみましょう';

  @override
  String get seeMore => 'もっと見る';

  @override
  String get followers => 'フォロワー';

  @override
  String get followingLabel => 'フォロー中';

  @override
  String get posts => '投稿';

  @override
  String get follow => 'フォロー';

  @override
  String get unfollow => 'フォロー解除';

  @override
  String get editProfile => 'プロフィール編集';

  @override
  String get bio => '自己紹介';

  @override
  String get bioHint => '自己紹介を入力...';

  @override
  String get searchUsers => 'ユーザー検索...';

  @override
  String get suggestedUsers => 'おすすめユーザー';

  @override
  String get noUsersFound => 'ユーザーが見つかりません';

  @override
  String get report => '報告';

  @override
  String get reportContent => 'コンテンツを報告';

  @override
  String get reportReason => '報告理由を入力してください';

  @override
  String get reportSubmitted => '報告が送信されました';

  @override
  String get blockUser => 'ユーザーをブロック';

  @override
  String get unblockUser => 'ブロック解除';

  @override
  String get userBlocked => 'ユーザーをブロックしました';

  @override
  String get userUnblocked => 'ブロックを解除しました';

  @override
  String get postCreated => '投稿しました！';

  @override
  String likesCount(int count) {
    return '$countいいね';
  }

  @override
  String commentsCount(int count) {
    return '$countコメント';
  }

  @override
  String followersCount(int count) {
    return '$countフォロワー';
  }

  @override
  String followingCount(int count) {
    return '$countフォロー中';
  }

  @override
  String get findFriends => '友達を探す';

  @override
  String get addPhotos => '写真を追加';

  @override
  String maxPhotos(int count) {
    return '最大$count枚まで';
  }

  @override
  String get visibility => '公開範囲';

  @override
  String get visibilityPublic => '公開';

  @override
  String get visibilityFollowers => 'フォロワーのみ';

  @override
  String get noFollowingPosts => 'フォロー中のユーザーの投稿はまだありません';

  @override
  String get all => 'すべて';

  @override
  String get learning => '学習';

  @override
  String get general => '一般';

  @override
  String get linkCopied => 'リンクをコピーしました';

  @override
  String get postFailed => '投稿に失敗しました';

  @override
  String get newPost => '新しい投稿';

  @override
  String get category => 'カテゴリー';

  @override
  String get writeYourThoughts => '思ったことを書いてみましょう...';

  @override
  String get photos => '写真';

  @override
  String get addPhoto => '写真を追加';

  @override
  String get imageUrlHint => '画像URLを入力';

  @override
  String get noSuggestions => 'おすすめがありません。ユーザーを検索してみましょう！';

  @override
  String get noResults => 'ユーザーが見つかりません';

  @override
  String get postDetail => '投稿';

  @override
  String get comments => 'コメント';

  @override
  String get noComments => 'まだコメントがありません。最初のコメントを書いてみましょう！';

  @override
  String get deleteCommentConfirm => 'このコメントを削除しますか？';

  @override
  String get failedToLoadProfile => 'プロフィールの読み込みに失敗しました';

  @override
  String get userNotFound => 'ユーザーが見つかりません';

  @override
  String get message => 'メッセージ';

  @override
  String get messages => 'メッセージ';

  @override
  String get noMessages => 'メッセージはまだありません';

  @override
  String get startConversation => '誰かと会話を始めましょう！';

  @override
  String get noMessagesYet => 'メッセージはまだありません。挨拶しましょう！';

  @override
  String get typing => '入力中...';

  @override
  String get typeMessage => 'メッセージを入力...';

  @override
  String get createVoiceRoom => 'ボイスルーム作成';

  @override
  String get roomTitle => 'ルーム名';

  @override
  String get roomTitleHint => '例：韓国語会話練習';

  @override
  String get topic => 'トピック';

  @override
  String get topicHint => '何について話しますか？';

  @override
  String get languageLevel => '言語レベル';

  @override
  String get allLevels => '全レベル';

  @override
  String get beginner => '初級';

  @override
  String get intermediate => '中級';

  @override
  String get advanced => '上級';

  @override
  String get stageSlots => 'スピーカー枠';

  @override
  String get anyoneCanListen => '誰でもリスナーとして参加できます';

  @override
  String get createAndJoin => '作成して参加';

  @override
  String get unmute => 'ミュート解除';

  @override
  String get mute => 'ミュート';

  @override
  String get leave => '退出';

  @override
  String get closeRoom => 'ルームを閉じる';

  @override
  String get emojiReaction => 'リアクション';

  @override
  String get gesture => 'ジェスチャー';

  @override
  String get raiseHand => '挙手';

  @override
  String get cancelRequest => 'キャンセル';

  @override
  String get leaveStage => 'ステージを降りる';

  @override
  String get pendingRequests => 'リクエスト';

  @override
  String get typeAMessage => 'メッセージを入力...';

  @override
  String get stageRequests => 'ステージリクエスト';

  @override
  String get noPendingRequests => 'リクエストはありません';

  @override
  String get onStage => 'ステージ上';

  @override
  String get voiceRooms => 'ボイスルーム';

  @override
  String get noVoiceRooms => 'アクティブなボイスルームはありません';

  @override
  String get createVoiceRoomHint => 'ルームを作成して会話を始めましょう！';

  @override
  String get createRoom => 'ルーム作成';

  @override
  String get voiceRoomMicPermission => 'ボイスルームにはマイクの許可が必要です';

  @override
  String get voiceRoomEnterTitle => 'ルーム名を入力してください';

  @override
  String get voiceRoomCreateFailed => 'ルームの作成に失敗しました';

  @override
  String get voiceRoomNotAvailable => 'ルームは利用できません';

  @override
  String get voiceRoomGoBack => '戻る';

  @override
  String get voiceRoomConnecting => '接続中...';

  @override
  String voiceRoomReconnecting(int attempts, int max) {
    return '再接続中 ($attempts/$max)...';
  }

  @override
  String get voiceRoomDisconnected => '切断されました';

  @override
  String get voiceRoomRetry => '再試行';

  @override
  String get voiceRoomHostLabel => '(ホスト)';

  @override
  String get voiceRoomDemoteToListener => 'リスナーに降格';

  @override
  String get voiceRoomKickFromRoom => 'ルームから退出させる';

  @override
  String get voiceRoomListeners => 'リスナー';

  @override
  String get voiceRoomInviteToStage => 'ステージに招待';

  @override
  String voiceRoomInviteConfirm(String name) {
    return '$nameさんをステージに招待しますか？';
  }

  @override
  String get voiceRoomInvite => '招待';

  @override
  String get voiceRoomCloseConfirmTitle => 'ルームを閉じますか？';

  @override
  String get voiceRoomCloseConfirmBody => '全員の通話が終了します。';

  @override
  String get voiceRoomNoMessagesYet => 'まだメッセージがありません';

  @override
  String get voiceRoomTypeMessage => 'メッセージを入力...';

  @override
  String get voiceRoomStageFull => 'ステージ満席';

  @override
  String voiceRoomListenerCount(int count) {
    return 'リスナー $count人';
  }

  @override
  String get voiceRoomRemoveFromStage => 'ステージから降ろしますか？';

  @override
  String voiceRoomRemoveFromStageConfirm(String name) {
    return '$nameさんをステージから降ろしますか？リスナーになります。';
  }

  @override
  String get voiceRoomDemote => '降格';

  @override
  String get voiceRoomRemoveFromRoom => 'ルームから退出させますか？';

  @override
  String voiceRoomRemoveFromRoomConfirm(String name) {
    return '$nameさんをルームから退出させますか？接続が切断されます。';
  }

  @override
  String get voiceRoomRemove => '退出させる';

  @override
  String get voiceRoomPressBackToLeave => 'もう一度押すと退出します';

  @override
  String get voiceRoomLeaveTitle => 'ルームを退出しますか？';

  @override
  String get voiceRoomLeaveBody => '現在ステージ上にいます。本当に退出しますか？';

  @override
  String get voiceRoomReturningToList => 'ルーム一覧に戻ります...';

  @override
  String get voiceRoomConnected => '接続しました！';

  @override
  String get voiceRoomStageFailedToLoad => 'ステージの読み込みに失敗しました';

  @override
  String get voiceRoomPreparingStage => 'ステージを準備中...';

  @override
  String voiceRoomAcceptToStage(Object name) {
    return '$nameさんをステージに承認';
  }

  @override
  String voiceRoomRejectFromStage(Object name) {
    return '$nameさんを拒否';
  }

  @override
  String get voiceRoomQuickCreate => 'クイック作成';

  @override
  String get voiceRoomRoomType => 'ルームタイプ';

  @override
  String get voiceRoomSessionDuration => 'セッション時間';

  @override
  String get voiceRoomOptionalTimer => 'セッションのタイマー（任意）';

  @override
  String get voiceRoomDurationNone => 'なし';

  @override
  String get voiceRoomDuration15 => '15分';

  @override
  String get voiceRoomDuration30 => '30分';

  @override
  String get voiceRoomDuration45 => '45分';

  @override
  String get voiceRoomDuration60 => '60分';

  @override
  String get voiceRoomTypeFreeTalk => 'フリートーク';

  @override
  String get voiceRoomTypePronunciation => '発音練習';

  @override
  String get voiceRoomTypeRolePlay => 'ロールプレイ';

  @override
  String get voiceRoomTypeQnA => '質問＆回答';

  @override
  String get voiceRoomTypeListening => 'リスニング';

  @override
  String get voiceRoomTypeDebate => 'ディベート';

  @override
  String get voiceRoomTemplateFreeTalk => '韓国語フリートーク';

  @override
  String get voiceRoomTemplatePronunciation => '発音練習';

  @override
  String get voiceRoomTemplateDailyKorean => 'デイリー韓国語';

  @override
  String get voiceRoomTemplateTopikSpeaking => 'TOPIKスピーキング';

  @override
  String get voiceRoomCreateTooltip => 'ボイスルームを作成';

  @override
  String get voiceRoomSendReaction => 'リアクションを送る';

  @override
  String get voiceRoomLeaveRoom => 'ルームを退出';

  @override
  String get voiceRoomUnmuteMic => 'マイクのミュートを解除';

  @override
  String get voiceRoomMuteMic => 'マイクをミュート';

  @override
  String get voiceRoomCancelHandRaise => '挙手をキャンセル';

  @override
  String get voiceRoomRaiseHandSemantic => '挙手する';

  @override
  String get voiceRoomSendGesture => 'ジェスチャーを送る';

  @override
  String get voiceRoomLeaveStageAction => 'ステージを降りる';

  @override
  String get voiceRoomManageStage => 'ステージを管理';

  @override
  String get voiceRoomMoreOptions => 'その他のオプション';

  @override
  String get voiceRoomMore => 'その他';

  @override
  String get voiceRoomStageWithSpeakers => 'スピーカーのいるボイスルームステージ';

  @override
  String voiceRoomStageRequestsPending(int count) {
    return 'ステージリクエスト、$count件待ち';
  }

  @override
  String voiceRoomSpeakerListenerCount(
      int speakers, int maxSpeakers, int listeners) {
    return 'スピーカー $speakers/$maxSpeakers人、リスナー $listeners人';
  }

  @override
  String get voiceRoomChatInput => 'チャットメッセージ入力';

  @override
  String get voiceRoomSendMessage => 'メッセージを送信';

  @override
  String voiceRoomSendReactionNamed(Object name) {
    return '$nameリアクションを送る';
  }

  @override
  String get voiceRoomCloseReactionTray => 'リアクショントレイを閉じる';

  @override
  String voiceRoomPerformGesture(Object name) {
    return '$nameジェスチャーを実行';
  }

  @override
  String get voiceRoomCloseGestureTray => 'ジェスチャートレイを閉じる';

  @override
  String get voiceRoomGestureWave => '手を振る';

  @override
  String get voiceRoomGestureBow => 'お辞儀';

  @override
  String get voiceRoomGestureDance => 'ダンス';

  @override
  String get voiceRoomGestureJump => 'ジャンプ';

  @override
  String get voiceRoomGestureClap => '拍手';

  @override
  String get voiceRoomStageLabel => 'ステージ';

  @override
  String get voiceRoomYouLabel => '（自分）';

  @override
  String voiceRoomListenerTapToManage(Object name) {
    return 'リスナー $name、タップして管理';
  }

  @override
  String voiceRoomListenerName(Object name) {
    return 'リスナー $name';
  }

  @override
  String get voiceRoomMicPermissionDenied =>
      'マイクへのアクセスが拒否されました。音声機能を使用するには、デバイスの設定で有効にしてください。';

  @override
  String get voiceRoomMicPermissionTitle => 'マイクの許可';

  @override
  String get voiceRoomOpenSettings => '設定を開く';

  @override
  String get voiceRoomMicNeededForStage => 'ステージで話すにはマイクの許可が必要です';

  @override
  String get batchimDescriptionText =>
      '韓国語のパッチム（받침）は7つの音で発音されます。\n複数のパッチムが同じ音で発音されることを「パッチム代表音」と言います。';

  @override
  String get syllableInputLabel => '音節入力';

  @override
  String get syllableInputHint => '例：한';

  @override
  String totalPracticedCount(int count) {
    return '合計 $count 文字練習完了';
  }

  @override
  String get audioLoadError => '音声を読み込めませんでした';

  @override
  String get writingPracticeCompleteMessage => '書き取り練習完了！';

  @override
  String get sevenRepresentativeSounds => '7つの代表音';

  @override
  String get myRoom => 'マイルーム';

  @override
  String get characterEditor => 'キャラクター編集';

  @override
  String get roomEditor => 'ルーム編集';

  @override
  String get shop => 'ショップ';

  @override
  String get character => 'キャラクター';

  @override
  String get room => 'ルーム';

  @override
  String get hair => 'ヘアー';

  @override
  String get eyes => '目';

  @override
  String get brows => '眉';

  @override
  String get nose => '鼻';

  @override
  String get mouth => '口';

  @override
  String get top => 'トップス';

  @override
  String get bottom => 'ボトムス';

  @override
  String get hatItem => '帽子';

  @override
  String get accessory => 'アクセ';

  @override
  String get wallpaper => '壁紙';

  @override
  String get floorItem => '床';

  @override
  String get petItem => 'ペット';

  @override
  String get none => 'なし';

  @override
  String get noItemsYet => 'アイテムなし';

  @override
  String get visitShopToGetItems => 'ショップでアイテムを手に入れましょう！';

  @override
  String get alreadyOwned => '所持済み！';

  @override
  String get buy => '購入';

  @override
  String purchasedItem(String name) {
    return '$nameを購入！';
  }

  @override
  String get notEnoughLemons => 'レモンが足りません！';

  @override
  String get owned => '所持';

  @override
  String get free => '無料';

  @override
  String get comingSoon => '近日公開！';

  @override
  String balanceLemons(int count) {
    return '残高: $countレモン';
  }

  @override
  String get furnitureItem => '家具';

  @override
  String get hangulWelcome => 'ハングルの世界へようこそ！';

  @override
  String get hangulWelcomeDesc => 'ハングル40文字を一つずつ学びましょう';

  @override
  String get hangulStartLearning => '学習を始める';

  @override
  String get hangulLearnNext => '次の文字を学ぶ';

  @override
  String hangulLearnedCount(int count) {
    return '$count/40文字を学びました！';
  }

  @override
  String hangulReviewNeeded(int count) {
    return '今日復習する文字が$count個あります！';
  }

  @override
  String get hangulReviewNow => '今すぐ復習';

  @override
  String get hangulPracticeSuggestion => 'もう少し！アクティビティで実力を固めましょう';

  @override
  String get hangulStartActivities => 'アクティビティ開始';

  @override
  String get hangulMastered => 'おめでとうございます！ハングルをマスターしました！';

  @override
  String get hangulGoToLevel1 => 'Level 1を始める';

  @override
  String get completedLessonsLabel => '完了レッスン';

  @override
  String get wordsLearnedLabel => '習得単語';

  @override
  String get totalStudyTimeLabel => '学習時間';

  @override
  String get streakDetails => '連続学習記録';

  @override
  String get consecutiveDays => '連続学習日数';

  @override
  String get totalStudyDaysLabel => '総学習日数';

  @override
  String get studyRecord => '学習記録';

  @override
  String get noFriendsPrompt => '一緒に勉強する友達を探しましょう！';

  @override
  String get moreStats => 'すべて表示';

  @override
  String remainingLessons(int count) {
    return 'あと$countつで今日の目標達成！';
  }

  @override
  String get streakMotivation0 => '今日から始めましょう！';

  @override
  String get streakMotivation1 => 'いいスタート！続けましょう！';

  @override
  String get streakMotivation7 => '1週間以上連続！すごいです！';

  @override
  String get streakMotivation14 => '2週間以上！習慣になってきています！';

  @override
  String get streakMotivation30 => '1ヶ月以上連続！真の学習者です！';

  @override
  String minutesShort(int count) {
    return '$count分';
  }

  @override
  String hoursShort(int count) {
    return '$count時間';
  }

  @override
  String get speechPractice => '発音練習';

  @override
  String get tapToRecord => 'タップして録音';

  @override
  String get recording => '録音中...';

  @override
  String get analyzing => '分析中...';

  @override
  String get pronunciationScore => '発音スコア';

  @override
  String get phonemeBreakdown => '音素別分析';

  @override
  String tryAgainCount(String current, String max) {
    return 'もう一度 ($current/$max)';
  }

  @override
  String get nextCharacter => '次の文字';

  @override
  String get excellentPronunciation => '素晴らしい！';

  @override
  String get goodPronunciation => 'よくできました！';

  @override
  String get fairPronunciation => 'もう少し！';

  @override
  String get needsMorePractice => '練習を続けよう！';

  @override
  String get downloadModels => 'ダウンロード';

  @override
  String get modelDownloading => 'モデルダウンロード中';

  @override
  String get modelReady => '準備完了';

  @override
  String get modelNotReady => '未インストール';

  @override
  String get modelSize => 'モデルサイズ';

  @override
  String get speechModelTitle => '音声認識AIモデル';

  @override
  String get skipSpeechPractice => 'スキップ';

  @override
  String get deleteModel => 'モデルを削除';

  @override
  String get overallScore => '総合スコア';

  @override
  String get appTagline => 'レモンのように爽やかに、実力はしっかりと！';

  @override
  String get passwordHint => '英数字を含む8文字以上を入力してください';

  @override
  String get findAccount => 'アカウント検索';

  @override
  String get resetPassword => 'パスワード再設定';

  @override
  String get registerTitle => '爽やかな韓国語の旅、今すぐ出発！';

  @override
  String get registerSubtitle => '気軽に始めてOK！しっかりサポートするよ';

  @override
  String get nickname => 'ニックネーム';

  @override
  String get nicknameHint => '15文字以内：英数字、アンダースコア';

  @override
  String get confirmPasswordHint => 'パスワードをもう一度入力してください';

  @override
  String get accountChoiceTitle => 'ようこそ！モニと一緒に\n勉強の習慣を作りましょう！';

  @override
  String get accountChoiceSubtitle => '爽やかにスタート、実力は私がしっかり守るよ！';

  @override
  String get startWithEmail => 'メールで始める';

  @override
  String get deleteMessageTitle => 'メッセージを削除しますか？';

  @override
  String get deleteMessageContent => 'このメッセージは全員から削除されます。';

  @override
  String get messageDeleted => 'メッセージが削除されました';

  @override
  String get beFirstToPost => '最初の投稿をしてみましょう！';

  @override
  String get typeTagHint => 'タグを入力...';

  @override
  String get userInfoLoadFailed => 'ユーザー情報の読み込みに失敗しました';

  @override
  String get loginErrorOccurred => 'ログイン中にエラーが発生しました';

  @override
  String get registerErrorOccurred => '登録中にエラーが発生しました';

  @override
  String get logoutErrorOccurred => 'ログアウト中にエラーが発生しました';

  @override
  String get hangulStage0Title => 'ステージ0：ハングルの構造理解';

  @override
  String get hangulStage1Title => 'ステージ1：基本母音';

  @override
  String get hangulStage2Title => 'ステージ2：Y母音';

  @override
  String get hangulStage3Title => 'ステージ3：ㅐ/ㅔ母音';

  @override
  String get hangulStage4Title => 'ステージ4：基本子音1';

  @override
  String get hangulStage5Title => 'ステージ5：基本子音2';

  @override
  String get hangulStage6Title => 'ステージ6：音節組み合わせ訓練';

  @override
  String get hangulStage7Title => 'ステージ7：濃音/激音';

  @override
  String get hangulStage8Title => 'ステージ8：パッチム（終声）1';

  @override
  String get hangulStage9Title => 'ステージ9：パッチム拡張';

  @override
  String get hangulStage10Title => 'ステージ10：複合パッチム';

  @override
  String get hangulStage11Title => 'ステージ11：単語読み拡張';

  @override
  String get sortAlphabetical => 'アルファベット順';

  @override
  String get sortByLevel => 'レベル順';

  @override
  String get sortBySimilarity => '類似度順';

  @override
  String get searchWordsKoreanMeaning => '単語検索（韓国語/意味）';

  @override
  String get groupedView => 'グループ表示';

  @override
  String get matrixView => '子音×母音';

  @override
  String get reviewLessons => '復習レッスン';

  @override
  String get stageDetailComingSoon => '詳細は準備中です。';

  @override
  String get bossQuizComingSoon => 'ボスクイズは準備中です。';

  @override
  String get exitLessonDialogTitle => 'レッスンを終了';

  @override
  String get exitLessonDialogContent => 'レッスンを終了しますか？\n現在のステップまで自動保存されます。';

  @override
  String get continueButton => '続ける';

  @override
  String get exitLessonButton => '終了する';

  @override
  String get noQuestions => '問題がありません';

  @override
  String get noCharactersDefined => '文字が定義されていません';

  @override
  String get recordingStartFailed => '録音の開始に失敗しました';

  @override
  String get consonant => '子音';

  @override
  String get vowel => '母音';

  @override
  String get validationEmailRequired => 'メールアドレスを入力してください';

  @override
  String get validationEmailTooLong => 'メールアドレスが長すぎます';

  @override
  String get validationEmailInvalid => '有効なメールアドレスを入力してください';

  @override
  String get validationPasswordRequired => 'パスワードを入力してください';

  @override
  String validationPasswordMinLength(int minLength) {
    return 'パスワードは$minLength文字以上必要です';
  }

  @override
  String get validationPasswordNeedLetter => 'パスワードに文字を含める必要があります';

  @override
  String get validationPasswordNeedNumber => 'パスワードに数字を含める必要があります';

  @override
  String get validationPasswordNeedSpecial => 'パスワードに特殊文字を含める必要があります';

  @override
  String get validationPasswordTooLong => 'パスワードが長すぎます';

  @override
  String get validationConfirmPasswordRequired => 'パスワードをもう一度入力してください';

  @override
  String get validationPasswordMismatch => 'パスワードが一致しません';

  @override
  String get validationUsernameRequired => 'ユーザー名を入力してください';

  @override
  String validationUsernameTooShort(int minLength) {
    return 'ユーザー名は$minLength文字以上必要です';
  }

  @override
  String validationUsernameTooLong(int maxLength) {
    return 'ユーザー名は$maxLength文字以内にしてください';
  }

  @override
  String get validationUsernameInvalidChars => 'ユーザー名には文字、数字、アンダースコアのみ使用できます';

  @override
  String validationFieldRequired(String fieldName) {
    return '$fieldNameを入力してください';
  }

  @override
  String validationFieldMinLength(String fieldName, int minLength) {
    return '$fieldNameは$minLength文字以上必要です';
  }

  @override
  String validationFieldMaxLength(String fieldName, int maxLength) {
    return '$fieldNameは$maxLength文字以内にしてください';
  }

  @override
  String validationFieldNumeric(String fieldName) {
    return '$fieldNameは数字である必要があります';
  }

  @override
  String get errorNetworkConnection => 'ネットワーク接続に失敗しました。ネットワーク設定を確認してください';

  @override
  String get errorServer => 'サーバーエラーです。後でもう一度お試しください';

  @override
  String get errorAuthFailed => '認証に失敗しました。もう一度ログインしてください';

  @override
  String get errorUnknown => '不明なエラーです。後でもう一度お試しください';

  @override
  String get errorTimeout => '接続がタイムアウトしました。ネットワークを確認してください';

  @override
  String get errorRequestCancelled => 'リクエストがキャンセルされました';

  @override
  String get errorForbidden => 'アクセスが拒否されました';

  @override
  String get errorNotFound => 'リクエストされたリソースが見つかりません';

  @override
  String get errorRequestParam => 'リクエストパラメータエラー';

  @override
  String get errorParseData => 'データ解析エラー';

  @override
  String get errorParseFormat => 'データ形式エラー';

  @override
  String get errorRateLimited => 'リクエストが多すぎます。後でもう一度お試しください';

  @override
  String get successLogin => 'ログイン成功';

  @override
  String get successRegister => '登録成功';

  @override
  String get successSync => '同期成功';

  @override
  String get successDownload => 'ダウンロード成功';

  @override
  String get failedToCreateComment => 'コメントの作成に失敗しました';

  @override
  String get failedToDeleteComment => 'コメントの削除に失敗しました';

  @override
  String get failedToSubmitReport => '報告の送信に失敗しました';

  @override
  String get failedToBlockUser => 'ユーザーのブロックに失敗しました';

  @override
  String get failedToUnblockUser => 'ユーザーのブロック解除に失敗しました';

  @override
  String get failedToCreatePost => '投稿の作成に失敗しました';

  @override
  String get failedToDeletePost => '投稿の削除に失敗しました';

  @override
  String noVocabularyForLevel(int level) {
    return 'レベル$levelの単語が見つかりません';
  }

  @override
  String get uploadingImage => '[画像アップロード中...]';

  @override
  String get uploadingVoice => '[音声アップロード中...]';

  @override
  String get imagePreview => '[画像]';

  @override
  String get voicePreview => '[音声]';

  @override
  String get voiceServerConnectFailed => '音声サーバーに接続できません。接続を確認してください。';

  @override
  String get connectionLostRetry => '接続が切れました。タップして再試行してください。';

  @override
  String get noInternetConnection => 'インターネットに接続されていません。ネットワークを確認してください。';

  @override
  String get couldNotLoadRooms => 'ルームを読み込めませんでした。もう一度お試しください。';

  @override
  String get couldNotCreateRoom => 'ルームを作成できませんでした。もう一度お試しください。';

  @override
  String get couldNotJoinRoom => 'ルームに参加できませんでした。接続を確認してください。';

  @override
  String get roomClosedByHost => 'ホストがルームを閉じました。';

  @override
  String get removedFromRoomByHost => 'ホストによりルームから退出させられました。';

  @override
  String get connectionTimedOut => '接続がタイムアウトしました。もう一度お試しください。';

  @override
  String get missingLiveKitCredentials => '音声接続の認証情報がありません。';

  @override
  String get microphoneEnableFailed => 'マイクを有効にできませんでした。権限を確認してミュート解除をお試しください。';

  @override
  String get voiceRoomNewMessages => '新しいメッセージ';

  @override
  String get voiceRoomChatRateLimited => 'メッセージの送信が速すぎます。しばらくお待ちください。';

  @override
  String get voiceRoomMessageSendFailed => 'メッセージの送信に失敗しました。もう一度お試しください。';

  @override
  String get voiceRoomChatError => 'チャットエラーが発生しました。';

  @override
  String retryAttempt(int current, int max) {
    return '再試行 ($current/$max)';
  }

  @override
  String get nextButton => '次へ';

  @override
  String get completeButton => '完了';

  @override
  String get startButton => 'はじめる';

  @override
  String get doneButton => '完了';

  @override
  String get goBackButton => '戻る';

  @override
  String get tapToListen => 'タップして音を聞く';

  @override
  String get listenAllSoundsFirst => 'まずすべての音を聞いてみてください';

  @override
  String get nextCharButton => '次の文字';

  @override
  String get listenAndChooseCorrect => '音を聞いて正しい文字を選んでください';

  @override
  String get lessonCompletedMsg => 'レッスンを完了しました！';

  @override
  String stageMasterLabel(int stage) {
    return 'ステージ$stageマスター';
  }

  @override
  String get hangulS0L0Title => 'ハングルってどんな文字？';

  @override
  String get hangulS0L0Subtitle => 'ハングルが作られた経緯を簡単に学びましょう';

  @override
  String get hangulS0L0Step0Title => '昔は文字を学ぶのが大変でした';

  @override
  String get hangulS0L0Step0Desc => '昔は漢字を中心に文章を書いていたため、\n多くの人が読み書きに苦労していました。';

  @override
  String get hangulS0L0Step0Highlights => '漢字,困難,読み,書き';

  @override
  String get hangulS0L0Step1Title => '世宗大王が新しい文字を作りました';

  @override
  String get hangulS0L0Step1Desc =>
      '民が簡単に学べるように、\n世宗大王が直接、訓民正音を作りました。\n（1443年創製、1446年公布）';

  @override
  String get hangulS0L0Step1Highlights => '世宗大王,訓民正音,1443,1446';

  @override
  String get hangulS0L0Step2Title => 'そして今日のハングルになりました';

  @override
  String get hangulS0L0Step2Desc =>
      'ハングルは音を簡単に表記できるように作られた文字です。\n次のレッスンでは子音と母音の構造を学びましょう。';

  @override
  String get hangulS0L0Step2Highlights => '音,簡単な文字,ハングル';

  @override
  String get hangulS0L0SummaryTitle => '紹介レッスン完了！';

  @override
  String get hangulS0L0SummaryMsg =>
      'よくできました！\nハングルがなぜ作られたか分かりましたね。\n次は子音と母音の構造を学びましょう。';

  @override
  String get hangulS0L1Title => '가ブロックを組み立てよう';

  @override
  String get hangulS0L1Subtitle => '見ながら組み立てる（視覚中心）';

  @override
  String get hangulS0L1IntroTitle => 'ハングルはブロックです！';

  @override
  String get hangulS0L1IntroDesc =>
      'ハングルは子音と母音を組み合わせて文字を作ります。\n子音（ㄱ）+ 母音（ㅏ）= 가\n\nもっと複雑な文字には下にパッチム（末音）が入ることもあります。\n（後で学びます！）';

  @override
  String get hangulS0L1IntroHighlights => '子音,母音,文字';

  @override
  String get hangulS0L1DragGaTitle => '가を組み立てる';

  @override
  String get hangulS0L1DragGaDesc => 'ㄱとㅏを空欄にドラッグしてください';

  @override
  String get hangulS0L1DragNaTitle => '나を組み立てる';

  @override
  String get hangulS0L1DragNaDesc => '新しい子音ㄴを使ってみましょう';

  @override
  String get hangulS0L1DragDaTitle => '다を組み立てる';

  @override
  String get hangulS0L1DragDaDesc => '新しい子音ㄷを使ってみましょう';

  @override
  String get hangulS0L1SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS0L1SummaryMsg => '子音 + 母音 = 文字ブロック！\nㄱ+ㅏ=가, ㄴ+ㅏ=나, ㄷ+ㅏ=다';

  @override
  String get hangulS0L2Title => '音の探索';

  @override
  String get hangulS0L2Subtitle => '音で子音と母音を感じよう';

  @override
  String get hangulS0L2IntroTitle => '音を感じてみましょう';

  @override
  String get hangulS0L2IntroDesc =>
      'ハングルの子音と母音にはそれぞれ固有の音があります。\n音を聞いて感じてみましょう。';

  @override
  String get hangulS0L2Sound1Title => 'ㄱ、ㄴ、ㄷの基本的な読み方';

  @override
  String get hangulS0L2Sound1Desc => '子音にㅏを付けた発音（가、나、다）を聞いてみましょう';

  @override
  String get hangulS0L2Sound2Title => 'ㅏ、ㅗの母音の音';

  @override
  String get hangulS0L2Sound2Desc => '2つの母音の音を聞いてみましょう';

  @override
  String get hangulS0L2Sound3Title => '가、나、다の音を聞く';

  @override
  String get hangulS0L2Sound3Desc => '子音と母音が組み合わさった文字の音を聞いてみましょう';

  @override
  String get hangulS0L2SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS0L2SummaryMsg =>
      '子音はㅏを付けた発音（가、나、다）として覚え、\n母音はそのままの音を感じられるようになりました！';

  @override
  String get hangulS0L3Title => '聞いて選ぼう';

  @override
  String get hangulS0L3Subtitle => '音で文字を区別しよう';

  @override
  String get hangulS0L3IntroTitle => '今回は耳で区別しよう';

  @override
  String get hangulS0L3IntroDesc => '画面よりも音に集中して、\n聞こえた音がどの文字か当ててみましょう。';

  @override
  String get hangulS0L3Sound1Title => '가/나/다/고/노の音を確認';

  @override
  String get hangulS0L3Sound1Desc => 'まず5つの音をしっかり聞いてみましょう';

  @override
  String get hangulS0L3Match1Title => '聞いて同じ文字を選ぼう';

  @override
  String get hangulS0L3Match1Desc => '再生された音と同じ文字を選んでください';

  @override
  String get hangulS0L3Match2Title => 'ㅏ / ㅗの音を区別';

  @override
  String get hangulS0L3Match2Desc => '同じ子音で、母音の違いを聞き分けてみましょう';

  @override
  String get hangulS0L3SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS0L3SummaryMsg =>
      'よくできました！\n目（組み立て）と耳（音）を使って、\nハングルの構造を理解できるようになりました。';

  @override
  String get hangulS0CompleteTitle => 'ステージ0完了！';

  @override
  String get hangulS0CompleteMsg => 'ハングルの構造を理解しました！';

  @override
  String get hangulS1L1Title => 'ㅏの形と音';

  @override
  String get hangulS1L1Subtitle => '縦線の右側に短い画: ㅏ';

  @override
  String get hangulS1L1Step0Title => '最初の母音ㅏを学ぼう';

  @override
  String get hangulS1L1Step0Desc => 'ㅏは明るい音「아」を作ります。\n形と音を一緒に覚えましょう。';

  @override
  String get hangulS1L1Step0Highlights => 'ㅏ,아,基本母音';

  @override
  String get hangulS1L1Step1Title => 'ㅏの音を聴こう';

  @override
  String get hangulS1L1Step1Desc => 'ㅏが含まれる音を聴いてください';

  @override
  String get hangulS1L1Step2Title => '発音練習';

  @override
  String get hangulS1L1Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS1L1Step3Title => 'ㅏの音を選ぼう';

  @override
  String get hangulS1L1Step3Desc => '音を聴いて正しい文字を選んでください';

  @override
  String get hangulS1L1Step4Title => '形クイズ';

  @override
  String get hangulS1L1Step4Desc => 'ㅏを正確に見つけましょう';

  @override
  String get hangulS1L1Step4Q0 => '次のうちㅏは？';

  @override
  String get hangulS1L1Step4Q1 => '次のうちㅏが含まれるものは？';

  @override
  String get hangulS1L1Step4Q2 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step5Title => 'ㅏで文字を作ろう';

  @override
  String get hangulS1L1Step5Desc => '子音とㅏを組み合わせて文字を完成させましょう';

  @override
  String get hangulS1L1Step6Title => '総合クイズ';

  @override
  String get hangulS1L1Step6Desc => 'このレッスンの内容をまとめましょう';

  @override
  String get hangulS1L1Step6Q0 => '「아」の母音は？';

  @override
  String get hangulS1L1Step6Q1 => 'ㅇ + ㅏ = ?';

  @override
  String get hangulS1L1Step6Q2 => '次のうちㅏが含まれる文字は？';

  @override
  String get hangulS1L1Step6Q3 => 'ㅏと最も異なる音は？';

  @override
  String get hangulS1L1Step7Title => 'レッスン完了！';

  @override
  String get hangulS1L1Step7Msg => 'よくできました！\nㅏの形と音を覚えました。';

  @override
  String get hangulS1L2Title => 'ㅓの形と音';

  @override
  String get hangulS1L2Subtitle => '縦線の左側に短い画: ㅓ';

  @override
  String get hangulS1L2Step0Title => '2番目の母音ㅓ';

  @override
  String get hangulS1L2Step0Desc => 'ㅓは「어」の音を作ります。\nㅏと画の向きが反対なのが重要です。';

  @override
  String get hangulS1L2Step0Highlights => 'ㅓ,어,ㅏと反対方向';

  @override
  String get hangulS1L2Step1Title => 'ㅓの音を聴こう';

  @override
  String get hangulS1L2Step1Desc => 'ㅓが含まれる音を聴いてください';

  @override
  String get hangulS1L2Step2Title => '発音練習';

  @override
  String get hangulS1L2Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS1L2Step3Title => 'ㅓの音を選ぼう';

  @override
  String get hangulS1L2Step3Desc => 'ㅏ/ㅓを耳で聞き分けましょう';

  @override
  String get hangulS1L2Step4Title => '形クイズ';

  @override
  String get hangulS1L2Step4Desc => 'ㅓを見つけましょう';

  @override
  String get hangulS1L2Step4Q0 => '次のうちㅓは？';

  @override
  String get hangulS1L2Step4Q1 => 'ㅇ + ㅓ = ?';

  @override
  String get hangulS1L2Step4Q2 => '次のうちㅓが含まれる文字は？';

  @override
  String get hangulS1L2Step5Title => 'ㅓで文字を作ろう';

  @override
  String get hangulS1L2Step5Desc => '子音とㅓを組み合わせてみましょう';

  @override
  String get hangulS1L2Step6Title => 'レッスン完了！';

  @override
  String get hangulS1L2Step6Msg => '素晴らしい！\nㅓ(어)の音を覚えました。';

  @override
  String get hangulS1L3Title => 'ㅗの形と音';

  @override
  String get hangulS1L3Subtitle => '横線の上に縦画: ㅗ';

  @override
  String get hangulS1L3Step0Title => '3番目の母音ㅗ';

  @override
  String get hangulS1L3Step0Desc => 'ㅗは「오」の音を作ります。\n横線の上に縦画が上がります。';

  @override
  String get hangulS1L3Step0Highlights => 'ㅗ,오,横型母音';

  @override
  String get hangulS1L3Step1Title => 'ㅗの音を聴こう';

  @override
  String get hangulS1L3Step1Desc => 'ㅗが含まれる音(오/고/노)を聴いてください';

  @override
  String get hangulS1L3Step2Title => '発音練習';

  @override
  String get hangulS1L3Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS1L3Step3Title => 'ㅗの音を選ぼう';

  @override
  String get hangulS1L3Step3Desc => '오/우の音を聞き分けましょう';

  @override
  String get hangulS1L3Step4Title => 'ㅗで文字を作ろう';

  @override
  String get hangulS1L3Step4Desc => '子音とㅗを組み合わせてみましょう';

  @override
  String get hangulS1L3Step5Title => '形・音クイズ';

  @override
  String get hangulS1L3Step5Desc => 'ㅗを正確に選びましょう';

  @override
  String get hangulS1L3Step5Q0 => '次のうちㅗは？';

  @override
  String get hangulS1L3Step5Q1 => 'ㅇ + ㅗ = ?';

  @override
  String get hangulS1L3Step5Q2 => '次のうちㅗが含まれるものは？';

  @override
  String get hangulS1L3Step6Title => 'レッスン完了！';

  @override
  String get hangulS1L3Step6Msg => 'よくできました！\nㅗ(오)の音を覚えました。';

  @override
  String get hangulS1L4Title => 'ㅜの形と音';

  @override
  String get hangulS1L4Subtitle => '横線の下に縦画: ㅜ';

  @override
  String get hangulS1L4Step0Title => '4番目の母音ㅜ';

  @override
  String get hangulS1L4Step0Desc => 'ㅜは「우」の音を作ります。\nㅗとは縦画の位置が反対です。';

  @override
  String get hangulS1L4Step0Highlights => 'ㅜ,우,ㅗと位置を比較';

  @override
  String get hangulS1L4Step1Title => 'ㅜの音を聴こう';

  @override
  String get hangulS1L4Step1Desc => '우/구/누を聴いてください';

  @override
  String get hangulS1L4Step2Title => '発音練習';

  @override
  String get hangulS1L4Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS1L4Step3Title => 'ㅜの音を選ぼう';

  @override
  String get hangulS1L4Step3Desc => 'ㅗ/ㅜを聞き分けましょう';

  @override
  String get hangulS1L4Step4Title => 'ㅜで文字を作ろう';

  @override
  String get hangulS1L4Step4Desc => '子音とㅜを組み合わせてみましょう';

  @override
  String get hangulS1L4Step5Title => '形・音クイズ';

  @override
  String get hangulS1L4Step5Desc => 'ㅜを正確に選びましょう';

  @override
  String get hangulS1L4Step5Q0 => '次のうちㅜは？';

  @override
  String get hangulS1L4Step5Q1 => 'ㅇ + ㅜ = ?';

  @override
  String get hangulS1L4Step5Q2 => '次のうちㅜが含まれるものは？';

  @override
  String get hangulS1L4Step6Title => 'レッスン完了！';

  @override
  String get hangulS1L4Step6Msg => 'よくできました！\nㅜ(우)の音を覚えました。';

  @override
  String get hangulS1L5Title => 'ㅡの形と音';

  @override
  String get hangulS1L5Subtitle => '一本の横線母音: ㅡ';

  @override
  String get hangulS1L5Step0Title => '5番目の母音ㅡ';

  @override
  String get hangulS1L5Step0Desc => 'ㅡは口を横に引いて出す音です。\n形は一本の横線です。';

  @override
  String get hangulS1L5Step0Highlights => 'ㅡ,으,一本の横線';

  @override
  String get hangulS1L5Step1Title => 'ㅡの音を聴こう';

  @override
  String get hangulS1L5Step1Desc => '으/그/느の音を聴いてください';

  @override
  String get hangulS1L5Step2Title => '発音練習';

  @override
  String get hangulS1L5Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS1L5Step3Title => 'ㅡの音を選ぼう';

  @override
  String get hangulS1L5Step3Desc => 'ㅡとㅜの音を聞き分けましょう';

  @override
  String get hangulS1L5Step4Title => 'ㅡで文字を作ろう';

  @override
  String get hangulS1L5Step4Desc => '子音とㅡを組み合わせてみましょう';

  @override
  String get hangulS1L5Step5Title => '形・音クイズ';

  @override
  String get hangulS1L5Step5Desc => 'ㅡを正確に選びましょう';

  @override
  String get hangulS1L5Step5Q0 => '次のうちㅡは？';

  @override
  String get hangulS1L5Step5Q1 => 'ㅇ + ㅡ = ?';

  @override
  String get hangulS1L5Step5Q2 => '次のうちㅡが含まれるものは？';

  @override
  String get hangulS1L5Step6Title => 'レッスン完了！';

  @override
  String get hangulS1L5Step6Msg => 'よくできました！\nㅡ(으)の音を覚えました。';

  @override
  String get hangulS1L6Title => 'ㅣの形と音';

  @override
  String get hangulS1L6Subtitle => '一本の縦線母音: ㅣ';

  @override
  String get hangulS1L6Step0Title => '6番目の母音ㅣ';

  @override
  String get hangulS1L6Step0Desc => 'ㅣは「이」の音を作ります。\n形は一本の縦線です。';

  @override
  String get hangulS1L6Step0Highlights => 'ㅣ,이,一本の縦線';

  @override
  String get hangulS1L6Step1Title => 'ㅣの音を聴こう';

  @override
  String get hangulS1L6Step1Desc => '이/기/니の音を聴いてください';

  @override
  String get hangulS1L6Step2Title => '発音練習';

  @override
  String get hangulS1L6Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS1L6Step3Title => 'ㅣの音を選ぼう';

  @override
  String get hangulS1L6Step3Desc => 'ㅣとㅡの音を聞き分けましょう';

  @override
  String get hangulS1L6Step4Title => 'ㅣで文字を作ろう';

  @override
  String get hangulS1L6Step4Desc => '子音とㅣを組み合わせてみましょう';

  @override
  String get hangulS1L6Step5Title => '形・音クイズ';

  @override
  String get hangulS1L6Step5Desc => 'ㅣを正確に選びましょう';

  @override
  String get hangulS1L6Step5Q0 => '次のうちㅣは？';

  @override
  String get hangulS1L6Step5Q1 => 'ㅇ + ㅣ = ?';

  @override
  String get hangulS1L6Step5Q2 => '次のうちㅣが含まれるものは？';

  @override
  String get hangulS1L6Step6Title => 'レッスン完了！';

  @override
  String get hangulS1L6Step6Msg => 'よくできました！\nㅣ(이)の音を覚えました。';

  @override
  String get hangulS1L7Title => '縦母音の区別';

  @override
  String get hangulS1L7Subtitle => 'ㅏ · ㅓ · ㅣ をすばやく区別する';

  @override
  String get hangulS1L7Step0Title => '縦母音グループの復習';

  @override
  String get hangulS1L7Step0Desc => 'ㅏ、ㅓ、ㅣは縦軸の母音です。\n画の位置と音を一緒に区別しましょう。';

  @override
  String get hangulS1L7Step0Highlights => 'ㅏ,ㅓ,ㅣ,縦母音';

  @override
  String get hangulS1L7Step1Title => 'もう一度聴いてみよう';

  @override
  String get hangulS1L7Step1Desc => '아/어/이の音を確認しましょう';

  @override
  String get hangulS1L7Step2Title => '発音練習';

  @override
  String get hangulS1L7Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS1L7Step3Title => '縦母音のリスニングクイズ';

  @override
  String get hangulS1L7Step3Desc => '音と文字を結び付けましょう';

  @override
  String get hangulS1L7Step4Title => '縦母音の形クイズ';

  @override
  String get hangulS1L7Step4Desc => '形を正確に区別しましょう';

  @override
  String get hangulS1L7Step4Q0 => '右に短い画があるのは？';

  @override
  String get hangulS1L7Step4Q1 => '左に短い画があるのは？';

  @override
  String get hangulS1L7Step4Q2 => '縦一本線は？';

  @override
  String get hangulS1L7Step4Q3 => 'ㄴ + ㅓ = ?';

  @override
  String get hangulS1L7Step4Q4 => 'ㄱ + ㅣ = ?';

  @override
  String get hangulS1L7Step5Title => 'レッスン完了！';

  @override
  String get hangulS1L7Step5Msg => 'よくできました！\n縦母音（ㅏ/ㅓ/ㅣ）の区別が身につきました。';

  @override
  String get hangulS1L8Title => '横母音の区別';

  @override
  String get hangulS1L8Subtitle => 'ㅗ · ㅜ · ㅡ をすばやく区別する';

  @override
  String get hangulS1L8Step0Title => '横母音グループの復習';

  @override
  String get hangulS1L8Step0Desc => 'ㅗ、ㅜ、ㅡは横軸中心の母音です。\n縦画の位置と口の形を一緒に覚えましょう。';

  @override
  String get hangulS1L8Step0Highlights => 'ㅗ,ㅜ,ㅡ,横母音';

  @override
  String get hangulS1L8Step1Title => 'もう一度聴いてみよう';

  @override
  String get hangulS1L8Step1Desc => '오/우/으の音を確認しましょう';

  @override
  String get hangulS1L8Step2Title => '発音練習';

  @override
  String get hangulS1L8Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS1L8Step3Title => '横母音のリスニングクイズ';

  @override
  String get hangulS1L8Step3Desc => '音と文字を結び付けましょう';

  @override
  String get hangulS1L8Step4Title => '横母音の形クイズ';

  @override
  String get hangulS1L8Step4Desc => '形と音を一緒に確認しましょう';

  @override
  String get hangulS1L8Step4Q0 => '横線の上に縦画があるのは？';

  @override
  String get hangulS1L8Step4Q1 => '横線の下に縦画があるのは？';

  @override
  String get hangulS1L8Step4Q2 => '横一本線は？';

  @override
  String get hangulS1L8Step4Q3 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS1L8Step4Q4 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS1L8Step5Title => 'レッスン完了！';

  @override
  String get hangulS1L8Step5Msg => 'よくできました！\n横母音（ㅗ/ㅜ/ㅡ）の区別が身につきました。';

  @override
  String get hangulS1L9Title => '基本母音ミッション';

  @override
  String get hangulS1L9Subtitle => '制限時間内に母音の組み合わせを完成させよう';

  @override
  String get hangulS1L9Step0Title => 'ステージ1最終ミッション';

  @override
  String get hangulS1L9Step0Desc =>
      '制限時間内に文字の組み合わせを完成させましょう。\n正確さとスピードでレモン報酬をゲット！';

  @override
  String get hangulS1L9Step1Title => 'タイムミッション';

  @override
  String get hangulS1L9Step2Title => 'ミッション結果';

  @override
  String get hangulS1L9Step3Title => 'ステージ1クリア！';

  @override
  String get hangulS1L9Step3Msg => 'おめでとう！\nステージ1の基本母音をすべて終えました。';

  @override
  String get hangulS1L10Title => '初めての韓国語の単語！';

  @override
  String get hangulS1L10Subtitle => '覚えた文字で本物の単語を読んでみよう';

  @override
  String get hangulS1L10Step0Title => 'これで単語が読めます！';

  @override
  String get hangulS1L10Step0Desc => '母音と基本子音を学んだので\n本物の韓国語の単語を読んでみましょう。';

  @override
  String get hangulS1L10Step0Highlights => '本物の単語,読み挑戦';

  @override
  String get hangulS1L10Step1Title => '最初の単語を読む';

  @override
  String get hangulS1L10Step1Descs => '子ども,牛乳,キュウリ,これ/歯,弟';

  @override
  String get hangulS1L10Step2Title => '発音練習';

  @override
  String get hangulS1L10Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS1L10Step3Title => '聴いて選ぼう';

  @override
  String get hangulS1L10Step4Title => 'すごいです！';

  @override
  String get hangulS1L10Step4Msg =>
      '韓国語の単語が読めました！\n子音をさらに学べば\nもっとたくさんの単語が読めます。';

  @override
  String get hangulS1CompleteTitle => 'ステージ1クリア！';

  @override
  String get hangulS1CompleteMsg => '基本母音6文字をマスターしました！';

  @override
  String get hangulS2L1Title => 'ㅑの形と発音';

  @override
  String get hangulS2L1Subtitle => 'ㅏに一画追加: ㅑ';

  @override
  String get hangulS2L1Step0Title => 'ㅏがㅑに変わります';

  @override
  String get hangulS2L1Step0Desc => 'ㅏに一画加えるとㅑになります。\n「ア」より弾む「ヤ」の音になります。';

  @override
  String get hangulS2L1Step0Highlights => 'ㅏ → ㅑ,야,Y母音';

  @override
  String get hangulS2L1Step1Title => 'ㅑの音を聴く';

  @override
  String get hangulS2L1Step1Desc => '야/갸/냐の音を聴いてみましょう';

  @override
  String get hangulS2L1Step2Title => '発音練習';

  @override
  String get hangulS2L1Step2Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS2L1Step3Title => 'ㅏ vs ㅑ リスニング';

  @override
  String get hangulS2L1Step3Desc => '似た音を聴き分けましょう';

  @override
  String get hangulS2L1Step4Title => 'ㅑで音節を作る';

  @override
  String get hangulS2L1Step4Desc => '子音 + ㅑ の組み合わせを完成させましょう';

  @override
  String get hangulS2L1Step5Title => '形・音クイズ';

  @override
  String get hangulS2L1Step5Desc => 'ㅑを正確に選びましょう';

  @override
  String get hangulS2L1Step5Q0 => '次のうちㅑは？';

  @override
  String get hangulS2L1Step5Q1 => 'ㅇ + ㅑ = ?';

  @override
  String get hangulS2L1Step5Q2 => '次のうちㅑが入るものは？';

  @override
  String get hangulS2L1Step6Title => 'レッスン完了！';

  @override
  String get hangulS2L1Step6Msg => 'よくできました！\nㅑ（야）の音を覚えました。';

  @override
  String get hangulS2L2Title => 'ㅕの形と発音';

  @override
  String get hangulS2L2Subtitle => 'ㅓに一画追加: ㅕ';

  @override
  String get hangulS2L2Step0Title => 'ㅓがㅕに変わります';

  @override
  String get hangulS2L2Step0Desc => 'ㅓに一画加えるとㅕになります。\n「オ」が「ヨ」の音に変わります。';

  @override
  String get hangulS2L2Step0Highlights => 'ㅓ → ㅕ,여,Y母音';

  @override
  String get hangulS2L2Step1Title => 'ㅕの音を聴く';

  @override
  String get hangulS2L2Step1Desc => '여/겨/녀の音を聴いてみましょう';

  @override
  String get hangulS2L2Step2Title => '発音練習';

  @override
  String get hangulS2L2Step2Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS2L2Step3Title => 'ㅓ vs ㅕ リスニング';

  @override
  String get hangulS2L2Step3Desc => '어と여を聴き分けましょう';

  @override
  String get hangulS2L2Step4Title => 'ㅕで音節を作る';

  @override
  String get hangulS2L2Step4Desc => '子音 + ㅕ の組み合わせを完成させましょう';

  @override
  String get hangulS2L2Step5Title => 'レッスン完了！';

  @override
  String get hangulS2L2Step5Msg => 'よくできました！\nㅕ（여）の音を覚えました。';

  @override
  String get hangulS2L3Title => 'ㅛの形と発音';

  @override
  String get hangulS2L3Subtitle => 'ㅗに一画追加: ㅛ';

  @override
  String get hangulS2L3Step0Title => 'ㅗがㅛに変わります';

  @override
  String get hangulS2L3Step0Desc => 'ㅗに一画加えるとㅛになります。\n「オ」が「ヨ」の音に変わります。';

  @override
  String get hangulS2L3Step0Highlights => 'ㅗ → ㅛ,요,Y母音';

  @override
  String get hangulS2L3Step1Title => 'ㅛの音を聴く';

  @override
  String get hangulS2L3Step1Desc => '요/교/뇨の音を聴いてみましょう';

  @override
  String get hangulS2L3Step2Title => '発音練習';

  @override
  String get hangulS2L3Step2Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS2L3Step3Title => 'ㅗ vs ㅛ リスニング';

  @override
  String get hangulS2L3Step3Desc => '오と요を聴き分けましょう';

  @override
  String get hangulS2L3Step4Title => 'ㅛで音節を作る';

  @override
  String get hangulS2L3Step4Desc => '子音 + ㅛ の組み合わせを完成させましょう';

  @override
  String get hangulS2L3Step5Title => 'レッスン完了！';

  @override
  String get hangulS2L3Step5Msg => 'よくできました！\nㅛ（요）の音を覚えました。';

  @override
  String get hangulS2L4Title => 'ㅠの形と発音';

  @override
  String get hangulS2L4Subtitle => 'ㅜに一画追加: ㅠ';

  @override
  String get hangulS2L4Step0Title => 'ㅜがㅠに変わります';

  @override
  String get hangulS2L4Step0Desc => 'ㅜに一画加えるとㅠになります。\n「ウ」が「ユ」の音に変わります。';

  @override
  String get hangulS2L4Step0Highlights => 'ㅜ → ㅠ,유,Y母音';

  @override
  String get hangulS2L4Step1Title => 'ㅠの音を聴く';

  @override
  String get hangulS2L4Step1Desc => '유/규/뉴の音を聴いてみましょう';

  @override
  String get hangulS2L4Step2Title => '発音練習';

  @override
  String get hangulS2L4Step2Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS2L4Step3Title => 'ㅜ vs ㅠ リスニング';

  @override
  String get hangulS2L4Step3Desc => '우と유を聴き分けましょう';

  @override
  String get hangulS2L4Step4Title => 'ㅠで音節を作る';

  @override
  String get hangulS2L4Step4Desc => '子音 + ㅠ の組み合わせを完成させましょう';

  @override
  String get hangulS2L4Step5Title => 'レッスン完了！';

  @override
  String get hangulS2L4Step5Msg => 'よくできました！\nㅠ（유）の音を覚えました。';

  @override
  String get hangulS2L5Title => 'Y母音グループ特訓';

  @override
  String get hangulS2L5Subtitle => 'ㅑ · ㅕ · ㅛ · ㅠ 集中トレーニング';

  @override
  String get hangulS2L5Step0Title => 'Y母音を一度に見る';

  @override
  String get hangulS2L5Step0Desc => 'ㅑ/ㅕ/ㅛ/ㅠは基本母音に一画加えた母音です。\n音と形を素早く区別しましょう。';

  @override
  String get hangulS2L5Step0Highlights => 'ㅑ,ㅕ,ㅛ,ㅠ';

  @override
  String get hangulS2L5Step1Title => '4つの音を再確認';

  @override
  String get hangulS2L5Step1Desc => '야/여/요/유を確認しましょう';

  @override
  String get hangulS2L5Step2Title => '発音練習';

  @override
  String get hangulS2L5Step2Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS2L5Step3Title => '音の識別クイズ';

  @override
  String get hangulS2L5Step3Desc => 'Y母音の音を聴き分けましょう';

  @override
  String get hangulS2L5Step4Title => '形の識別クイズ';

  @override
  String get hangulS2L5Step4Desc => '形を正確に区別しましょう';

  @override
  String get hangulS2L5Step4Q0 => '次のうちㅑは？';

  @override
  String get hangulS2L5Step4Q1 => '次のうちㅕは？';

  @override
  String get hangulS2L5Step4Q2 => '次のうちㅛは？';

  @override
  String get hangulS2L5Step4Q3 => '次のうちㅠは？';

  @override
  String get hangulS2L5Step5Title => 'レッスン完了！';

  @override
  String get hangulS2L5Step5Msg => 'よくできました！\n4つのY母音の区別が上手になりました。';

  @override
  String get hangulS2L6Title => '基本母音 vs Y母音 比較';

  @override
  String get hangulS2L6Subtitle => 'ㅏ/ㅑ · ㅓ/ㅕ · ㅗ/ㅛ · ㅜ/ㅠ';

  @override
  String get hangulS2L6Step0Title => '紛らわしいペアを整理する';

  @override
  String get hangulS2L6Step0Desc => '基本母音とY母音をペアで比較しましょう。';

  @override
  String get hangulS2L6Step0Highlights => 'ㅏ/ㅑ,ㅓ/ㅕ,ㅗ/ㅛ,ㅜ/ㅠ';

  @override
  String get hangulS2L6Step1Title => 'ペアの音の区別';

  @override
  String get hangulS2L6Step1Desc => '似た音の中から正解を選びましょう';

  @override
  String get hangulS2L6Step2Title => 'ペアの形の区別';

  @override
  String get hangulS2L6Step2Desc => '画の有無を確認しましょう';

  @override
  String get hangulS2L6Step2Q0 => '画が追加された母音は？';

  @override
  String get hangulS2L6Step2Q1 => '画が追加された母音は？';

  @override
  String get hangulS2L6Step2Q2 => '画が追加された母音は？';

  @override
  String get hangulS2L6Step2Q3 => '画が追加された母音は？';

  @override
  String get hangulS2L6Step2Q4 => 'ㅇ + ㅠ = ?';

  @override
  String get hangulS2L6Step3Title => 'レッスン完了！';

  @override
  String get hangulS2L6Step3Msg => 'よくできました！\n基本／Y母音の比較が安定しました。';

  @override
  String get hangulS2L7Title => 'Y母音ミッション';

  @override
  String get hangulS2L7Subtitle => '時間内にY母音の組み合わせを完成させよう';

  @override
  String get hangulS2L7Step0Title => 'ステージ2 最終ミッション';

  @override
  String get hangulS2L7Step0Desc =>
      'Y母音の組み合わせを速く正確に当てましょう。\n完成数と時間でレモン報酬が決まります。';

  @override
  String get hangulS2L7Step1Title => 'タイムミッション';

  @override
  String get hangulS2L7Step2Title => 'ミッション結果';

  @override
  String get hangulS2L7Step3Title => 'ステージ2 完了！';

  @override
  String get hangulS2L7Step3Msg => 'おめでとうございます！\nステージ2のY母音をすべて終えました。';

  @override
  String get hangulS2CompleteTitle => 'ステージ2 完了！';

  @override
  String get hangulS2CompleteMsg => 'Y母音をマスターしました！';

  @override
  String get hangulS3L1Title => 'ㅐの形と音';

  @override
  String get hangulS3L1Subtitle => 'ㅏ + ㅣの組み合わせを感じよう';

  @override
  String get hangulS3L1Step0Title => 'ㅐはこんな形です';

  @override
  String get hangulS3L1Step0Desc => 'ㅐはㅏ系列から派生した母音です。\n代表音は「애」として覚えましょう。';

  @override
  String get hangulS3L1Step0Highlights => 'ㅐ,애,形の認識';

  @override
  String get hangulS3L1Step1Title => 'ㅐの音を聞こう';

  @override
  String get hangulS3L1Step1Desc => '애/개/내の音を聞いてみましょう';

  @override
  String get hangulS3L1Step2Title => '発音練習';

  @override
  String get hangulS3L1Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS3L1Step3Title => 'ㅏ vs ㅐを聞き分けよう';

  @override
  String get hangulS3L1Step3Desc => '아/애を聞き分けましょう';

  @override
  String get hangulS3L1Step4Title => 'レッスン完了！';

  @override
  String get hangulS3L1Step4Msg => 'いいですね！\nㅐ（애）の形と音を覚えました。';

  @override
  String get hangulS3L2Title => 'ㅔの形と音';

  @override
  String get hangulS3L2Subtitle => 'ㅓ + ㅣの組み合わせを感じよう';

  @override
  String get hangulS3L2Step0Title => 'ㅔはこんな形です';

  @override
  String get hangulS3L2Step0Desc => 'ㅔはㅓ系列から派生した母音です。\n代表音は「에」として覚えましょう。';

  @override
  String get hangulS3L2Step0Highlights => 'ㅔ,에,形の認識';

  @override
  String get hangulS3L2Step1Title => 'ㅔの音を聞こう';

  @override
  String get hangulS3L2Step1Desc => '에/게/네の音を聞いてみましょう';

  @override
  String get hangulS3L2Step2Title => '発音練習';

  @override
  String get hangulS3L2Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS3L2Step3Title => 'ㅓ vs ㅔを聞き分けよう';

  @override
  String get hangulS3L2Step3Desc => '어/에を聞き分けましょう';

  @override
  String get hangulS3L2Step4Title => 'レッスン完了！';

  @override
  String get hangulS3L2Step4Msg => 'いいですね！\nㅔ（에）の形と音を覚えました。';

  @override
  String get hangulS3L3Title => 'ㅐ vs ㅔの区別';

  @override
  String get hangulS3L3Subtitle => '形を中心にした区別トレーニング';

  @override
  String get hangulS3L3Step0Title => 'ポイントは形の区別です';

  @override
  String get hangulS3L3Step0Desc =>
      '初級では、ㅐ/ㅔの音は似て聞こえることがあります。\nまず形の区別を正確にしましょう。';

  @override
  String get hangulS3L3Step0Highlights => 'ㅐ,ㅔ,形の区別';

  @override
  String get hangulS3L3Step1Title => '形の区別クイズ';

  @override
  String get hangulS3L3Step1Desc => 'ㅐとㅔを正確に選びましょう';

  @override
  String get hangulS3L3Step1Q0 => '次のうちㅐはどれ？';

  @override
  String get hangulS3L3Step1Q1 => '次のうちㅔはどれ？';

  @override
  String get hangulS3L3Step1Q2 => 'ㅇ + ㅐ = ?';

  @override
  String get hangulS3L3Step1Q3 => 'ㅇ + ㅔ = ?';

  @override
  String get hangulS3L3Step2Title => 'レッスン完了！';

  @override
  String get hangulS3L3Step2Msg => 'いいですね！\nㅐ/ㅔの区別がより正確になりました。';

  @override
  String get hangulS3L4Title => 'ㅒの形と音';

  @override
  String get hangulS3L4Subtitle => 'Y-ㅐ系列の母音';

  @override
  String get hangulS3L4Step0Title => 'ㅒを覚えよう';

  @override
  String get hangulS3L4Step0Desc => 'ㅒはㅐ系列のY母音です。\n代表音は「얘」です。';

  @override
  String get hangulS3L4Step0Highlights => 'ㅒ,얘';

  @override
  String get hangulS3L4Step1Title => 'ㅒの音を聞こう';

  @override
  String get hangulS3L4Step1Desc => '얘/걔/냬の音を聞いてみましょう';

  @override
  String get hangulS3L4Step2Title => '発音練習';

  @override
  String get hangulS3L4Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS3L4Step3Title => 'レッスン完了！';

  @override
  String get hangulS3L4Step3Msg => 'いいですね！\nㅒ（얘）の形を覚えました。';

  @override
  String get hangulS3L5Title => 'ㅖの形と音';

  @override
  String get hangulS3L5Subtitle => 'Y-ㅔ系列の母音';

  @override
  String get hangulS3L5Step0Title => 'ㅖを覚えよう';

  @override
  String get hangulS3L5Step0Desc => 'ㅖはㅔ系列のY母音です。\n代表音は「예」です。';

  @override
  String get hangulS3L5Step0Highlights => 'ㅖ,예';

  @override
  String get hangulS3L5Step1Title => 'ㅖの音を聞こう';

  @override
  String get hangulS3L5Step1Desc => '예/계/녜の音を聞いてみましょう';

  @override
  String get hangulS3L5Step2Title => '発音練習';

  @override
  String get hangulS3L5Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS3L5Step3Title => 'レッスン完了！';

  @override
  String get hangulS3L5Step3Msg => 'いいですね！\nㅖ（예）の形を覚えました。';

  @override
  String get hangulS3L6Title => 'ㅐ/ㅔ系列の総まとめ';

  @override
  String get hangulS3L6Subtitle => 'ㅐ ㅔ ㅒ ㅖ統合チェック';

  @override
  String get hangulS3L6Step0Title => '四つを一気に区別しましょう';

  @override
  String get hangulS3L6Step0Desc => 'ㅐ/ㅔ/ㅒ/ㅖを形と音で一緒に確認しましょう。';

  @override
  String get hangulS3L6Step0Highlights => 'ㅐ,ㅔ,ㅒ,ㅖ';

  @override
  String get hangulS3L6Step1Title => '音の区別';

  @override
  String get hangulS3L6Step1Desc => '似た音の中から正解を選びましょう';

  @override
  String get hangulS3L6Step2Title => '形の区別';

  @override
  String get hangulS3L6Step2Desc => '形を見てすばやく選びましょう';

  @override
  String get hangulS3L6Step2Q0 => '次のうちY-ㅐ系列はどれ？';

  @override
  String get hangulS3L6Step2Q1 => '次のうちY-ㅔ系列はどれ？';

  @override
  String get hangulS3L6Step2Q2 => 'ㅇ + ㅖ = ?';

  @override
  String get hangulS3L6Step3Title => 'レッスン完了！';

  @override
  String get hangulS3L6Step3Msg => 'いいですね！\nステージ3の重要母音の区別が安定しました。';

  @override
  String get hangulS3L7Title => 'ステージ3ミッション';

  @override
  String get hangulS3L7Subtitle => 'ㅐ/ㅔ系列の素早い区別ミッション';

  @override
  String get hangulS3L7Step0Title => 'ステージ3最終ミッション';

  @override
  String get hangulS3L7Step0Desc => 'ㅐ/ㅔ系列の組み合わせを素早く正確に合わせましょう。';

  @override
  String get hangulS3L7Step1Title => 'タイムミッション';

  @override
  String get hangulS3L7Step2Title => 'ミッション結果';

  @override
  String get hangulS3L7Step3Title => 'ステージ3完了！';

  @override
  String get hangulS3L7Step3Msg => 'おめでとうございます！\nステージ3のㅐ/ㅔ系列母音をすべて終えました。';

  @override
  String get hangulS3L7Step4Title => 'ステージ3完了！';

  @override
  String get hangulS3L7Step4Msg => 'すべての母音を学びました！';

  @override
  String get hangulS3CompleteTitle => 'ステージ3完了！';

  @override
  String get hangulS3CompleteMsg => 'すべての母音を学びました！';

  @override
  String get hangulS4L1Title => 'ㄱの形と音';

  @override
  String get hangulS4L1Subtitle => '基本子音の始まり：ㄱ';

  @override
  String get hangulS4L1Step0Title => 'ㄱを学ぼう';

  @override
  String get hangulS4L1Step0Desc => 'ㄱは基本子音の始まりです。\nㅏと合わせると「가」の音になります。';

  @override
  String get hangulS4L1Step0Highlights => 'ㄱ,가,基本子音';

  @override
  String get hangulS4L1Step1Title => 'ㄱの音を聞く';

  @override
  String get hangulS4L1Step1Desc => '가/고/구の音を聞いてみましょう';

  @override
  String get hangulS4L1Step2Title => '発音練習';

  @override
  String get hangulS4L1Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L1Step3Title => 'ㄱの音を選ぼう';

  @override
  String get hangulS4L1Step3Desc => '音を聞いて正しい文字を選んでください';

  @override
  String get hangulS4L1Step4Title => 'ㄱで文字を作ろう';

  @override
  String get hangulS4L1Step4Desc => 'ㄱ＋母音を組み合わせてみましょう';

  @override
  String get hangulS4L1SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS4L1SummaryMsg => 'いいですね！\nㄱの音と形を覚えました。';

  @override
  String get hangulS4L2Title => 'ㄴの形と音';

  @override
  String get hangulS4L2Subtitle => '第2の基本子音：ㄴ';

  @override
  String get hangulS4L2Step0Title => 'ㄴを学ぼう';

  @override
  String get hangulS4L2Step0Desc => 'ㄴは「나」の音系列を作ります。';

  @override
  String get hangulS4L2Step0Highlights => 'ㄴ,나';

  @override
  String get hangulS4L2Step1Title => 'ㄴの音を聞く';

  @override
  String get hangulS4L2Step1Desc => '나/노/누の音を聞いてみましょう';

  @override
  String get hangulS4L2Step2Title => '発音練習';

  @override
  String get hangulS4L2Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L2Step3Title => 'ㄴの音を選ぼう';

  @override
  String get hangulS4L2Step3Desc => '나/다を区別しましょう';

  @override
  String get hangulS4L2Step4Title => 'ㄴで文字を作ろう';

  @override
  String get hangulS4L2Step4Desc => 'ㄴ＋母音を組み合わせてみましょう';

  @override
  String get hangulS4L2SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS4L2SummaryMsg => 'いいですね！\nㄴの音と形を覚えました。';

  @override
  String get hangulS4L3Title => 'ㄷの形と音';

  @override
  String get hangulS4L3Subtitle => '第3の基本子音：ㄷ';

  @override
  String get hangulS4L3Step0Title => 'ㄷを学ぼう';

  @override
  String get hangulS4L3Step0Desc => 'ㄷは「다」の音系列を作ります。';

  @override
  String get hangulS4L3Step0Highlights => 'ㄷ,다';

  @override
  String get hangulS4L3Step1Title => 'ㄷの音を聞く';

  @override
  String get hangulS4L3Step1Desc => '다/도/두の音を聞いてみましょう';

  @override
  String get hangulS4L3Step2Title => '発音練習';

  @override
  String get hangulS4L3Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L3Step3Title => 'ㄷの音を選ぼう';

  @override
  String get hangulS4L3Step3Desc => '다/나を区別しましょう';

  @override
  String get hangulS4L3Step4Title => 'ㄷで文字を作ろう';

  @override
  String get hangulS4L3Step4Desc => 'ㄷ＋母音を組み合わせてみましょう';

  @override
  String get hangulS4L3SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS4L3SummaryMsg => 'いいですね！\nㄷの音と形を覚えました。';

  @override
  String get hangulS4L4Title => 'ㄹの形と音';

  @override
  String get hangulS4L4Subtitle => '第4の基本子音：ㄹ';

  @override
  String get hangulS4L4Step0Title => 'ㄹを学ぼう';

  @override
  String get hangulS4L4Step0Desc => 'ㄹは「라」の音系列を作ります。';

  @override
  String get hangulS4L4Step0Highlights => 'ㄹ,라';

  @override
  String get hangulS4L4Step1Title => 'ㄹの音を聞く';

  @override
  String get hangulS4L4Step1Desc => '라/로/루の音を聞いてみましょう';

  @override
  String get hangulS4L4Step2Title => '発音練習';

  @override
  String get hangulS4L4Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L4Step3Title => 'ㄹの音を選ぼう';

  @override
  String get hangulS4L4Step3Desc => '라/나を区別しましょう';

  @override
  String get hangulS4L4Step4Title => 'ㄹで文字を作ろう';

  @override
  String get hangulS4L4Step4Desc => 'ㄹ＋母音を組み合わせてみましょう';

  @override
  String get hangulS4L4SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS4L4SummaryMsg => 'いいですね！\nㄹの音と形を覚えました。';

  @override
  String get hangulS4L5Title => 'ㅁの形と音';

  @override
  String get hangulS4L5Subtitle => '第5の基本子音：ㅁ';

  @override
  String get hangulS4L5Step0Title => 'ㅁを学ぼう';

  @override
  String get hangulS4L5Step0Desc => 'ㅁは「마」の音系列を作ります。';

  @override
  String get hangulS4L5Step0Highlights => 'ㅁ,마';

  @override
  String get hangulS4L5Step1Title => 'ㅁの音を聞く';

  @override
  String get hangulS4L5Step1Desc => '마/모/무の音を聞いてみましょう';

  @override
  String get hangulS4L5Step2Title => '発音練習';

  @override
  String get hangulS4L5Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L5Step3Title => 'ㅁの音を選ぼう';

  @override
  String get hangulS4L5Step3Desc => '마/바を区別しましょう';

  @override
  String get hangulS4L5Step4Title => 'ㅁで文字を作ろう';

  @override
  String get hangulS4L5Step4Desc => 'ㅁ＋母音を組み合わせてみましょう';

  @override
  String get hangulS4L5SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS4L5SummaryMsg => 'いいですね！\nㅁの音と形を覚えました。';

  @override
  String get hangulS4L6Title => 'ㅂの形と音';

  @override
  String get hangulS4L6Subtitle => '第6の基本子音：ㅂ';

  @override
  String get hangulS4L6Step0Title => 'ㅂを学ぼう';

  @override
  String get hangulS4L6Step0Desc => 'ㅂは「바」の音系列を作ります。';

  @override
  String get hangulS4L6Step0Highlights => 'ㅂ,바';

  @override
  String get hangulS4L6Step1Title => 'ㅂの音を聞く';

  @override
  String get hangulS4L6Step1Desc => '바/보/부の音を聞いてみましょう';

  @override
  String get hangulS4L6Step2Title => '発音練習';

  @override
  String get hangulS4L6Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L6Step3Title => 'ㅂの音を選ぼう';

  @override
  String get hangulS4L6Step3Desc => '바/마を区別しましょう';

  @override
  String get hangulS4L6Step4Title => 'ㅂで文字を作ろう';

  @override
  String get hangulS4L6Step4Desc => 'ㅂ＋母音を組み合わせてみましょう';

  @override
  String get hangulS4L6SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS4L6SummaryMsg => 'いいですね！\nㅂの音と形を覚えました。';

  @override
  String get hangulS4L7Title => 'ㅅの形と音';

  @override
  String get hangulS4L7Subtitle => '第7の基本子音：ㅅ';

  @override
  String get hangulS4L7Step0Title => 'ㅅを学ぼう';

  @override
  String get hangulS4L7Step0Desc => 'ㅅは「사」の音系列を作ります。';

  @override
  String get hangulS4L7Step0Highlights => 'ㅅ,사';

  @override
  String get hangulS4L7Step1Title => 'ㅅの音を聞く';

  @override
  String get hangulS4L7Step1Desc => '사/소/수の音を聞いてみましょう';

  @override
  String get hangulS4L7Step2Title => '発音練習';

  @override
  String get hangulS4L7Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L7Step3Title => 'ㅅの音を選ぼう';

  @override
  String get hangulS4L7Step3Desc => '사/자を区別しましょう';

  @override
  String get hangulS4L7Step4Title => 'ㅅで文字を作ろう';

  @override
  String get hangulS4L7Step4Desc => 'ㅅ＋母音を組み合わせてみましょう';

  @override
  String get hangulS4L7SummaryTitle => 'ステージ4完了！';

  @override
  String get hangulS4L7SummaryMsg => 'おめでとうございます！\nステージ4の基本子音1（ㄱ〜ㅅ）を完了しました。';

  @override
  String get hangulS4L8Title => '単語読みチャレンジ！';

  @override
  String get hangulS4L8Subtitle => '子音と母音を使って単語を読んでみよう';

  @override
  String get hangulS4L8Step0Title => 'もっとたくさんの単語が読めるようになりました！';

  @override
  String get hangulS4L8Step0Desc =>
      '基本子音7つと母音をすべて学びました。\nこれらの文字で作られた本物の単語を読んでみましょう！';

  @override
  String get hangulS4L8Step0Highlights => '子音7つ,母音,本物の単語';

  @override
  String get hangulS4L8Step1Title => '単語を読む';

  @override
  String get hangulS4L8Step1Descs => '木,海,蝶,帽子,家具,豆腐';

  @override
  String get hangulS4L8Step2Title => '発音練習';

  @override
  String get hangulS4L8Step2Desc => '文字を声に出してみましょう';

  @override
  String get hangulS4L8Step3Title => '聞いて選ぼう';

  @override
  String get hangulS4L8Step4Title => 'どういう意味でしょう？';

  @override
  String get hangulS4L8Step4Q0 => '「나비」を日本語で言うと？';

  @override
  String get hangulS4L8Step4Q1 => '「바다」を日本語で言うと？';

  @override
  String get hangulS4L8SummaryTitle => '素晴らしい！';

  @override
  String get hangulS4L8SummaryMsg =>
      '韓国語の単語を6つ読みました！\nもっと子音を学べば、さらに多くの単語が読めるようになります。';

  @override
  String get hangulS4LMTitle => 'ミッション：基本子音の組み合わせ！';

  @override
  String get hangulS4LMSubtitle => '制限時間内に音節を作ろう';

  @override
  String get hangulS4LMStep0Title => 'ミッション開始！';

  @override
  String get hangulS4LMStep0Desc => '基本子音ㄱ〜ㅅと母音を組み合わせましょう。\n制限時間内に目標を達成してください！';

  @override
  String get hangulS4LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS4LMStep2Title => 'ミッション結果';

  @override
  String get hangulS4LMSummaryTitle => 'ミッション完了！';

  @override
  String get hangulS4LMSummaryMsg => '基本子音7つを自由に組み合わせられます！';

  @override
  String get hangulS4CompleteTitle => 'ステージ4完了！';

  @override
  String get hangulS4CompleteMsg => '基本子音7つをマスターしました！';

  @override
  String get hangulS5L1Title => 'ㅇの位置を理解しよう';

  @override
  String get hangulS5L1Subtitle => '初声ㅇの読み方';

  @override
  String get hangulS5L1Step0Title => 'ㅇは特別な子音です';

  @override
  String get hangulS5L1Step0Desc => '初声のㅇはほぼ無音で、\n母音と組み合わさると아/오/우のように読みます。';

  @override
  String get hangulS5L1Step0Highlights => 'ㅇ,아,初声の位置';

  @override
  String get hangulS5L1Step1Title => 'ㅇの組み合わせを聴こう';

  @override
  String get hangulS5L1Step1Desc => '아/오/우の音を聴いてみましょう';

  @override
  String get hangulS5L1Step2Title => '発音練習';

  @override
  String get hangulS5L1Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS5L1Step3Title => 'ㅇで文字を作ろう';

  @override
  String get hangulS5L1Step3Desc => 'ㅇ + 母音を組み合わせてみましょう';

  @override
  String get hangulS5L1Step4Title => 'レッスン完了！';

  @override
  String get hangulS5L1Step4Msg => 'よくできました！\nㅇの位置が理解できましたね。';

  @override
  String get hangulS5L2Title => 'ㅈの形と音';

  @override
  String get hangulS5L2Subtitle => 'ㅈの基本的な読み方';

  @override
  String get hangulS5L2Step0Title => 'ㅈを学ぼう';

  @override
  String get hangulS5L2Step0Desc => 'ㅈは「자」系の音を作ります。';

  @override
  String get hangulS5L2Step0Highlights => 'ㅈ,자';

  @override
  String get hangulS5L2Step1Title => 'ㅈの音を聴こう';

  @override
  String get hangulS5L2Step1Desc => '자/조/주を聴いてみましょう';

  @override
  String get hangulS5L2Step2Title => '発音練習';

  @override
  String get hangulS5L2Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS5L2Step3Title => 'ㅈの音を選ぼう';

  @override
  String get hangulS5L2Step3Desc => '자と사を聞き分けましょう';

  @override
  String get hangulS5L2Step4Title => 'ㅈで文字を作ろう';

  @override
  String get hangulS5L2Step4Desc => 'ㅈ + 母音を組み合わせてみましょう';

  @override
  String get hangulS5L2Step5Title => 'レッスン完了！';

  @override
  String get hangulS5L2Step5Msg => 'よくできました！\nㅈの音と形を覚えましたね。';

  @override
  String get hangulS5L3Title => 'ㅊの形と音';

  @override
  String get hangulS5L3Subtitle => 'ㅊの基本的な読み方';

  @override
  String get hangulS5L3Step0Title => 'ㅊを学ぼう';

  @override
  String get hangulS5L3Step0Desc => 'ㅊは「차」系の音を作ります。';

  @override
  String get hangulS5L3Step0Highlights => 'ㅊ,차';

  @override
  String get hangulS5L3Step1Title => 'ㅊの音を聴こう';

  @override
  String get hangulS5L3Step1Desc => '차/초/추を聴いてみましょう';

  @override
  String get hangulS5L3Step2Title => '発音練習';

  @override
  String get hangulS5L3Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS5L3Step3Title => 'ㅊの音を選ぼう';

  @override
  String get hangulS5L3Step3Desc => '차と자を聞き分けましょう';

  @override
  String get hangulS5L3Step4Title => 'レッスン完了！';

  @override
  String get hangulS5L3Step4Msg => 'よくできました！\nㅊの音と形を覚えましたね。';

  @override
  String get hangulS5L4Title => 'ㅋの形と音';

  @override
  String get hangulS5L4Subtitle => 'ㅋの基本的な読み方';

  @override
  String get hangulS5L4Step0Title => 'ㅋを学ぼう';

  @override
  String get hangulS5L4Step0Desc => 'ㅋは「카」系の音を作ります。';

  @override
  String get hangulS5L4Step0Highlights => 'ㅋ,카';

  @override
  String get hangulS5L4Step1Title => 'ㅋの音を聴こう';

  @override
  String get hangulS5L4Step1Desc => '카/코/쿠を聴いてみましょう';

  @override
  String get hangulS5L4Step2Title => '発音練習';

  @override
  String get hangulS5L4Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS5L4Step3Title => 'ㅋの音を選ぼう';

  @override
  String get hangulS5L4Step3Desc => '카と가を聞き分けましょう';

  @override
  String get hangulS5L4Step4Title => 'レッスン完了！';

  @override
  String get hangulS5L4Step4Msg => 'よくできました！\nㅋの音と形を覚えましたね。';

  @override
  String get hangulS5L5Title => 'ㅌの形と音';

  @override
  String get hangulS5L5Subtitle => 'ㅌの基本的な読み方';

  @override
  String get hangulS5L5Step0Title => 'ㅌを学ぼう';

  @override
  String get hangulS5L5Step0Desc => 'ㅌは「타」系の音を作ります。';

  @override
  String get hangulS5L5Step0Highlights => 'ㅌ,타';

  @override
  String get hangulS5L5Step1Title => 'ㅌの音を聴こう';

  @override
  String get hangulS5L5Step1Desc => '타/토/투を聴いてみましょう';

  @override
  String get hangulS5L5Step2Title => '発音練習';

  @override
  String get hangulS5L5Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS5L5Step3Title => 'ㅌの音を選ぼう';

  @override
  String get hangulS5L5Step3Desc => '타と다を聞き分けましょう';

  @override
  String get hangulS5L5Step4Title => 'レッスン完了！';

  @override
  String get hangulS5L5Step4Msg => 'よくできました！\nㅌの音と形を覚えましたね。';

  @override
  String get hangulS5L6Title => 'ㅍの形と音';

  @override
  String get hangulS5L6Subtitle => 'ㅍの基本的な読み方';

  @override
  String get hangulS5L6Step0Title => 'ㅍを学ぼう';

  @override
  String get hangulS5L6Step0Desc => 'ㅍは「파」系の音を作ります。';

  @override
  String get hangulS5L6Step0Highlights => 'ㅍ,파';

  @override
  String get hangulS5L6Step1Title => 'ㅍの音を聴こう';

  @override
  String get hangulS5L6Step1Desc => '파/포/푸を聴いてみましょう';

  @override
  String get hangulS5L6Step2Title => '発音練習';

  @override
  String get hangulS5L6Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS5L6Step3Title => 'ㅍの音を選ぼう';

  @override
  String get hangulS5L6Step3Desc => '파と바を聞き分けましょう';

  @override
  String get hangulS5L6Step4Title => 'レッスン完了！';

  @override
  String get hangulS5L6Step4Msg => 'よくできました！\nㅍの音と形を覚えましたね。';

  @override
  String get hangulS5L7Title => 'ㅎの形と音';

  @override
  String get hangulS5L7Subtitle => 'ㅎの基本的な読み方';

  @override
  String get hangulS5L7Step0Title => 'ㅎを学ぼう';

  @override
  String get hangulS5L7Step0Desc => 'ㅎは「하」系の音を作ります。';

  @override
  String get hangulS5L7Step0Highlights => 'ㅎ,하';

  @override
  String get hangulS5L7Step1Title => 'ㅎの音を聴こう';

  @override
  String get hangulS5L7Step1Desc => '하/호/후を聴いてみましょう';

  @override
  String get hangulS5L7Step2Title => '発音練習';

  @override
  String get hangulS5L7Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS5L7Step3Title => 'ㅎの音を選ぼう';

  @override
  String get hangulS5L7Step3Desc => '하と아を聞き分けましょう';

  @override
  String get hangulS5L7Step4Title => 'レッスン完了！';

  @override
  String get hangulS5L7Step4Msg => 'よくできました！\nㅎの音と形を覚えましたね。';

  @override
  String get hangulS5L8Title => '追加子音のランダム読み';

  @override
  String get hangulS5L8Subtitle => 'ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ を混ぜて確認';

  @override
  String get hangulS5L8Step0Title => 'ランダムで確認しよう';

  @override
  String get hangulS5L8Step0Desc => '追加子音7つを混ぜて読んでみましょう。';

  @override
  String get hangulS5L8Step0Highlights => 'ㅇ,ㅈ,ㅊ,ㅋ,ㅌ,ㅍ,ㅎ';

  @override
  String get hangulS5L8Step1Title => '形・音クイズ';

  @override
  String get hangulS5L8Step1Desc => '音と文字を結びつけましょう';

  @override
  String get hangulS5L8Step2Title => 'レッスン完了！';

  @override
  String get hangulS5L8Step2Msg => 'よくできました！\n追加子音7つをランダムで確認しました。';

  @override
  String get hangulS5L9Title => '混同しやすいペアのプレビュー';

  @override
  String get hangulS5L9Subtitle => '次のステージに備えた区別練習';

  @override
  String get hangulS5L9Step0Title => '紛らわしいペアを先に見ておこう';

  @override
  String get hangulS5L9Step0Desc => 'ㅈ/ㅊ、ㄱ/ㅋ、ㄷ/ㅌ、ㅂ/ㅍを先に練習しましょう。';

  @override
  String get hangulS5L9Step0Highlights => 'ㅈ/ㅊ,ㄱ/ㅋ,ㄷ/ㅌ,ㅂ/ㅍ';

  @override
  String get hangulS5L9Step1Title => '対比リスニング';

  @override
  String get hangulS5L9Step1Desc => '2つの音のうち正しいものを選んでください';

  @override
  String get hangulS5L9Step2Title => 'レッスン完了！';

  @override
  String get hangulS5L9Step2Msg => 'よくできました！\n次のステージの準備ができました。';

  @override
  String get hangulS5LMTitle => 'ステージ5ミッション';

  @override
  String get hangulS5LMSubtitle => '基本子音2 総合ミッション';

  @override
  String get hangulS5LMStep0Title => 'ミッション開始！';

  @override
  String get hangulS5LMStep0Desc =>
      '基本子音2（ㅇ~ㅎ）と母音を組み合わせましょう。\n制限時間内に目標を達成してください！';

  @override
  String get hangulS5LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS5LMStep2Title => 'ミッション結果';

  @override
  String get hangulS5LMStep3Title => 'ステージ5完了！';

  @override
  String get hangulS5LMStep3Msg => 'おめでとうございます！\nステージ5：基本子音2（ㅇ~ㅎ）を完了しました。';

  @override
  String get hangulS5LMStep4Title => 'ステージ5 完了！';

  @override
  String get hangulS5LMStep4Msg => 'すべての基本子音をマスターしました！';

  @override
  String get hangulS5CompleteTitle => 'ステージ5完了！';

  @override
  String get hangulS5CompleteMsg => 'すべての基本子音をマスターしました！';

  @override
  String get hangulS6L1Title => '가~기 パターン読み';

  @override
  String get hangulS6L1Subtitle => 'ㄱ + 基本母音パターン';

  @override
  String get hangulS6L1Step0Title => 'パターンで読み始めよう';

  @override
  String get hangulS6L1Step0Desc => 'ㄱに母音を変えてつけながら読むと\n読みのリズムができます。';

  @override
  String get hangulS6L1Step0Highlights => '가,거,고,구,그,기';

  @override
  String get hangulS6L1Step1Title => 'パターンの音を聴く';

  @override
  String get hangulS6L1Step1Desc => '가/거/고/구/그/기 を順番に聴いてみましょう';

  @override
  String get hangulS6L1Step2Title => '発音練習';

  @override
  String get hangulS6L1Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS6L1Step3Title => 'パターンクイズ';

  @override
  String get hangulS6L1Step3Desc => '同じ子音パターンを選びましょう';

  @override
  String get hangulS6L1Step3Q0 => 'ㄱ + ㅏ = ?';

  @override
  String get hangulS6L1Step3Q1 => 'ㄱ + ㅓ = ?';

  @override
  String get hangulS6L1Step3Q2 => 'ㄱ + ㅡ = ?';

  @override
  String get hangulS6L1Step4Title => 'レッスン完了！';

  @override
  String get hangulS6L1Step4Msg => 'いいですね！\n가~기 パターン読みを始めましたよ。';

  @override
  String get hangulS6L2Title => '나~니 への拡張';

  @override
  String get hangulS6L2Subtitle => 'ㄴ パターン読み';

  @override
  String get hangulS6L2Step0Title => 'ㄴ パターンの拡張';

  @override
  String get hangulS6L2Step0Desc => 'ㄴ に母音を変えてつけて 나~니 を読みましょう。';

  @override
  String get hangulS6L2Step0Highlights => '나,너,노,누,느,니';

  @override
  String get hangulS6L2Step1Title => '나~니 を聴く';

  @override
  String get hangulS6L2Step1Desc => 'ㄴ パターンの音を聴いてみましょう';

  @override
  String get hangulS6L2Step2Title => '発音練習';

  @override
  String get hangulS6L2Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS6L2Step3Title => 'ㄴ の組み合わせを作る';

  @override
  String get hangulS6L2Step3Desc => 'ㄴ + 母音で文字を作りましょう';

  @override
  String get hangulS6L2Step4Title => 'レッスン完了！';

  @override
  String get hangulS6L2Step4Msg => 'いいですね！\n나~니 パターンを身につけましたよ。';

  @override
  String get hangulS6L3Title => '다~디・라~리 への拡張';

  @override
  String get hangulS6L3Subtitle => 'ㄷ/ㄹ パターン読み';

  @override
  String get hangulS6L3Step0Title => '子音だけ変えて読む';

  @override
  String get hangulS6L3Step0Desc => '同じ母音で子音だけ変えて読むと\n読みのスピードが上がります。';

  @override
  String get hangulS6L3Step0Highlights => '다/라,도/로,두/루,디/리';

  @override
  String get hangulS6L3Step1Title => 'ㄷ/ㄹ の聴き分け';

  @override
  String get hangulS6L3Step1Desc => '音を聴いて正しい文字を選んでください';

  @override
  String get hangulS6L3Step2Title => '読みクイズ';

  @override
  String get hangulS6L3Step2Desc => 'パターンを確認しましょう';

  @override
  String get hangulS6L3Step2Q0 => 'ㄷ + ㅣ = ?';

  @override
  String get hangulS6L3Step2Q1 => 'ㄹ + ㅗ = ?';

  @override
  String get hangulS6L3Step3Title => 'レッスン完了！';

  @override
  String get hangulS6L3Step3Msg => 'いいですね！\nㄷ/ㄹ パターンを身につけましたよ。';

  @override
  String get hangulS6L4Title => 'ランダム音節読み 1';

  @override
  String get hangulS6L4Subtitle => '基本パターンのミックス';

  @override
  String get hangulS6L4Step0Title => '順序なしで読む';

  @override
  String get hangulS6L4Step0Desc => 'ランダムなカードのように読んでみましょう。';

  @override
  String get hangulS6L4Step1Title => 'ランダム読み';

  @override
  String get hangulS6L4Step1Desc => 'ランダムに出された音節を答えましょう';

  @override
  String get hangulS6L4Step1Q0 => 'ㄱ + ㅗ = ?';

  @override
  String get hangulS6L4Step1Q1 => 'ㄴ + ㅜ = ?';

  @override
  String get hangulS6L4Step1Q2 => 'ㄹ + ㅏ = ?';

  @override
  String get hangulS6L4Step1Q3 => 'ㅁ + ㅣ = ?';

  @override
  String get hangulS6L4Step2Title => 'レッスン完了！';

  @override
  String get hangulS6L4Step2Msg => 'いいですね！\nランダム読み1を完了しましたよ。';

  @override
  String get hangulS6L5Title => '音を聴いて音節を探す';

  @override
  String get hangulS6L5Subtitle => '聴覚と文字のつながりを強化';

  @override
  String get hangulS6L5Step0Title => '聴いて探す練習';

  @override
  String get hangulS6L5Step0Desc => '音を聴いて対応する音節を選び\n読みとのつながりを強化しましょう。';

  @override
  String get hangulS6L5Step1Title => '音マッチング';

  @override
  String get hangulS6L5Step1Desc => '正しい音節を選んでください';

  @override
  String get hangulS6L5Step2Title => 'レッスン完了！';

  @override
  String get hangulS6L5Step2Msg => 'いいですね！\n聴いて探す練習を完了しましたよ。';

  @override
  String get hangulS6L6Title => '複合母音の組み合わせ 1';

  @override
  String get hangulS6L6Subtitle => 'ㅘ, ㅝ の読み';

  @override
  String get hangulS6L6Step0Title => '複合母音を始めよう';

  @override
  String get hangulS6L6Step0Desc => 'ㅘ、ㅝ を組み合わせて読んでみましょう。';

  @override
  String get hangulS6L6Step0Highlights => 'ㅘ,ㅝ,와,워';

  @override
  String get hangulS6L6Step1Title => '와/워 を聴く';

  @override
  String get hangulS6L6Step1Desc => '代表的な音節の音を聴いてみましょう';

  @override
  String get hangulS6L6Step2Title => '発音練習';

  @override
  String get hangulS6L6Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS6L6Step3Title => '複合母音クイズ';

  @override
  String get hangulS6L6Step3Desc => 'ㅘ/ㅝ を区別しましょう';

  @override
  String get hangulS6L6Step3Q0 => 'ㅇ + ㅘ = ?';

  @override
  String get hangulS6L6Step3Q1 => 'ㄱ + ㅝ = ?';

  @override
  String get hangulS6L6Step4Title => 'レッスン完了！';

  @override
  String get hangulS6L6Step4Msg => 'いいですね！\nㅘ/ㅝ の組み合わせを身につけましたよ。';

  @override
  String get hangulS6L7Title => '複合母音の組み合わせ 2';

  @override
  String get hangulS6L7Subtitle => 'ㅙ, ㅞ, ㅚ, ㅟ, ㅢ の読み';

  @override
  String get hangulS6L7Step0Title => '複合母音の拡張';

  @override
  String get hangulS6L7Step0Desc => '複合母音を短く学び、読み中心に進めます。';

  @override
  String get hangulS6L7Step0Highlights => '왜,웨,외,위,의';

  @override
  String get hangulS6L7Step1Title => 'ㅢ の特別な発音';

  @override
  String get hangulS6L7Step1Desc =>
      'ㅢ は位置によって音が変わる特別な母音です。\n\n• 語頭: [의] → 의사, 의자\n• 子音の後: [이] → 희망→[히망]\n• 助詞「의」: [에] → 나의→[나에]';

  @override
  String get hangulS6L7Step1Highlights => 'ㅢ,의,이,에';

  @override
  String get hangulS6L7Step2Title => '複合母音を選ぶ';

  @override
  String get hangulS6L7Step2Desc => '正しい音節を選んでください';

  @override
  String get hangulS6L7Step2Q0 => 'ㅇ + ㅙ = ?';

  @override
  String get hangulS6L7Step2Q1 => 'ㅇ + ㅟ = ?';

  @override
  String get hangulS6L7Step2Q2 => 'ㅇ + ㅢ = ?';

  @override
  String get hangulS6L7Step3Title => 'レッスン完了！';

  @override
  String get hangulS6L7Step3Msg => 'いいですね！\n複合母音の拡張を完了しましたよ。';

  @override
  String get hangulS6L8Title => 'ランダム音節読み 2';

  @override
  String get hangulS6L8Subtitle => '基本・複合母音の総まとめ';

  @override
  String get hangulS6L8Step0Title => '総合ランダム読み';

  @override
  String get hangulS6L8Step0Desc => '基本・複合母音を混ぜて一緒に読みましょう。';

  @override
  String get hangulS6L8Step1Title => '総合クイズ';

  @override
  String get hangulS6L8Step1Desc => 'ランダムな組み合わせを答えましょう';

  @override
  String get hangulS6L8Step1Q0 => 'ㄱ + ㅢ = ?';

  @override
  String get hangulS6L8Step1Q1 => 'ㅎ + ㅘ = ?';

  @override
  String get hangulS6L8Step1Q2 => 'ㅂ + ㅟ = ?';

  @override
  String get hangulS6L8Step1Q3 => 'ㅈ + ㅝ = ?';

  @override
  String get hangulS6L8Step2Title => 'レッスン完了！';

  @override
  String get hangulS6L8Step2Msg => 'いいですね！\nステージ6の総合読みを完了しましたよ。';

  @override
  String get hangulS6LMTitle => 'ステージ6ミッション';

  @override
  String get hangulS6LMSubtitle => '組み合わせ読みの最終チェック';

  @override
  String get hangulS6LMStep0Title => 'ミッションスタート！';

  @override
  String get hangulS6LMStep0Desc => '本格的な組み合わせ訓練の最終チェックです。\n制限時間内に目標を達成しましょう！';

  @override
  String get hangulS6LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS6LMStep2Title => 'ミッション結果';

  @override
  String get hangulS6LMStep3Title => 'ステージ6完了！';

  @override
  String get hangulS6LMStep3Msg => 'おめでとうございます！\nステージ6の本格的な組み合わせ訓練を完了しましたよ。';

  @override
  String get hangulS6CompleteTitle => 'ステージ6 完了！';

  @override
  String get hangulS6CompleteMsg => '自由に音節を組み合わせられるようになりましたよ！';

  @override
  String get hangulS7L1Title => 'ㄱ / ㅋ / ㄲ の区別';

  @override
  String get hangulS7L1Subtitle => '가 · 카 · 까 の比較';

  @override
  String get hangulS7L1Step0Title => '3つの音を聴き分けよう';

  @override
  String get hangulS7L1Step0Desc => 'ㄱ（平音）、ㅋ（激音）、ㄲ（濃音）の違いを区別しましょう。';

  @override
  String get hangulS7L1Step0Highlights => 'ㄱ,ㅋ,ㄲ,가,카,까';

  @override
  String get hangulS7L1Step1Title => '音の探索';

  @override
  String get hangulS7L1Step1Desc => '가/카/까 を繰り返し聴いてみましょう';

  @override
  String get hangulS7L1Step2Title => '発音練習';

  @override
  String get hangulS7L1Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS7L1Step3Title => '聴いて選ぼう';

  @override
  String get hangulS7L1Step3Desc => '3つの選択肢から正解を選びましょう';

  @override
  String get hangulS7L1Step4Title => 'クイック確認';

  @override
  String get hangulS7L1Step4Desc => '形と音を一緒に確認しましょう';

  @override
  String get hangulS7L1Step4Q0 => '激音はどれ？';

  @override
  String get hangulS7L1Step4Q1 => '濃音はどれ？';

  @override
  String get hangulS7L1Step5Title => 'レッスン完了！';

  @override
  String get hangulS7L1Step5Msg => 'よくできました！\nㄱ/ㅋ/ㄲ の区別を習得しました。';

  @override
  String get hangulS7L2Title => 'ㄷ / ㅌ / ㄸ の区別';

  @override
  String get hangulS7L2Subtitle => '다 · 타 · 따 の比較';

  @override
  String get hangulS7L2Step0Title => '2番目の対比グループ';

  @override
  String get hangulS7L2Step0Desc => 'ㄷ/ㅌ/ㄸ の音を比べましょう。';

  @override
  String get hangulS7L2Step0Highlights => 'ㄷ,ㅌ,ㄸ,다,타,따';

  @override
  String get hangulS7L2Step1Title => '音の探索';

  @override
  String get hangulS7L2Step1Desc => '다/타/따 を繰り返し聴いてみましょう';

  @override
  String get hangulS7L2Step2Title => '発音練習';

  @override
  String get hangulS7L2Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS7L2Step3Title => '聴いて選ぼう';

  @override
  String get hangulS7L2Step3Desc => '3つの選択肢から正解を選びましょう';

  @override
  String get hangulS7L2Step4Title => 'レッスン完了！';

  @override
  String get hangulS7L2Step4Msg => 'よくできました！\nㄷ/ㅌ/ㄸ の区別を習得しました。';

  @override
  String get hangulS7L3Title => 'ㅂ / ㅍ / ㅃ の区別';

  @override
  String get hangulS7L3Subtitle => '바 · 파 · 빠 の比較';

  @override
  String get hangulS7L3Step0Title => '3番目の対比グループ';

  @override
  String get hangulS7L3Step0Desc => 'ㅂ/ㅍ/ㅃ の音を比べましょう。';

  @override
  String get hangulS7L3Step0Highlights => 'ㅂ,ㅍ,ㅃ,바,파,빠';

  @override
  String get hangulS7L3Step1Title => '音の探索';

  @override
  String get hangulS7L3Step1Desc => '바/파/빠 を繰り返し聴いてみましょう';

  @override
  String get hangulS7L3Step2Title => '発音練習';

  @override
  String get hangulS7L3Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS7L3Step3Title => '聴いて選ぼう';

  @override
  String get hangulS7L3Step3Desc => '3つの選択肢から正解を選びましょう';

  @override
  String get hangulS7L3Step4Title => 'レッスン完了！';

  @override
  String get hangulS7L3Step4Msg => 'よくできました！\nㅂ/ㅍ/ㅃ の区別を習得しました。';

  @override
  String get hangulS7L4Title => 'ㅅ / ㅆ の区別';

  @override
  String get hangulS7L4Subtitle => '사 · 싸 の比較';

  @override
  String get hangulS7L4Step0Title => '2つの音の対比';

  @override
  String get hangulS7L4Step0Desc => 'ㅅ/ㅆ の音を区別しましょう。';

  @override
  String get hangulS7L4Step0Highlights => 'ㅅ,ㅆ,사,싸';

  @override
  String get hangulS7L4Step1Title => '音の探索';

  @override
  String get hangulS7L4Step1Desc => '사/싸 を繰り返し聴いてみましょう';

  @override
  String get hangulS7L4Step2Title => '発音練習';

  @override
  String get hangulS7L4Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS7L4Step3Title => '聴いて選ぼう';

  @override
  String get hangulS7L4Step3Desc => '2つの選択肢から正解を選びましょう';

  @override
  String get hangulS7L4Step4Title => 'レッスン完了！';

  @override
  String get hangulS7L4Step4Msg => 'よくできました！\nㅅ/ㅆ の区別を習得しました。';

  @override
  String get hangulS7L5Title => 'ㅈ / ㅊ / ㅉ の区別';

  @override
  String get hangulS7L5Subtitle => '자 · 차 · 짜 の比較';

  @override
  String get hangulS7L5Step0Title => '最後の対比グループ';

  @override
  String get hangulS7L5Step0Desc => 'ㅈ/ㅊ/ㅉ の音を比べましょう。';

  @override
  String get hangulS7L5Step0Highlights => 'ㅈ,ㅊ,ㅉ,자,차,짜';

  @override
  String get hangulS7L5Step1Title => '音の探索';

  @override
  String get hangulS7L5Step1Desc => '자/차/짜 を繰り返し聴いてみましょう';

  @override
  String get hangulS7L5Step2Title => '発音練習';

  @override
  String get hangulS7L5Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS7L5Step3Title => '聴いて選ぼう';

  @override
  String get hangulS7L5Step3Desc => '3つの選択肢から正解を選びましょう';

  @override
  String get hangulS7L5Step4Title => 'ステージ7完了！';

  @override
  String get hangulS7L5Step4Msg => 'おめでとうございます！\nステージ7の5つの対比グループをすべて完了しました。';

  @override
  String get hangulS7LMTitle => 'ミッション：音の区別チャレンジ！';

  @override
  String get hangulS7LMSubtitle => '平音、激音、濃音を区別しよう';

  @override
  String get hangulS7LMStep0Title => '音の区別ミッション！';

  @override
  String get hangulS7LMStep0Desc => '平音、激音、濃音を混ぜて\n素早く音節を組み合わせましょう！';

  @override
  String get hangulS7LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS7LMStep2Title => 'ミッション結果';

  @override
  String get hangulS7LMStep3Title => 'ミッション完了！';

  @override
  String get hangulS7LMStep3Msg => '平音、激音、濃音を区別できるようになりました！';

  @override
  String get hangulS7LMStep4Title => 'ステージ7完了！';

  @override
  String get hangulS7LMStep4Msg => '濃音と激音を区別できるようになりました！';

  @override
  String get hangulS7CompleteTitle => 'ステージ7完了！';

  @override
  String get hangulS7CompleteMsg => '濃音と激音を区別できるようになりました！';

  @override
  String get hangulS8L0Title => 'パッチムの基本';

  @override
  String get hangulS8L0Subtitle => '音節ブロックの下に入る音';

  @override
  String get hangulS8L0Step0Title => 'パッチムは下にある';

  @override
  String get hangulS8L0Step0Desc => 'パッチム（終声子音）は音節ブロックの下に入ります。\n例：가 + ㄴ = 간';

  @override
  String get hangulS8L0Step0Highlights => 'パッチム,간,말,집';

  @override
  String get hangulS8L0Step1Title => 'パッチムの7つの代表音';

  @override
  String get hangulS8L0Step1Desc =>
      'パッチムには7つの代表音しかありません。\n\nㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅇ\n\n多くのパッチム文字はこの7音のいずれかで発音されます。\n例：ㅅ, ㅈ, ㅊ, ㅎのパッチム → すべて[ㄷ]音';

  @override
  String get hangulS8L0Step1Highlights => '7音,ㄱ ㄴ ㄷ ㄹ ㅁ ㅂ ㅇ,代表音';

  @override
  String get hangulS8L0Step2Title => 'パッチムを見つけよう';

  @override
  String get hangulS8L0Step2Desc => 'パッチムの位置を確認しましょう';

  @override
  String get hangulS8L0Step2Q0 => '간のパッチムは？';

  @override
  String get hangulS8L0Step2Q1 => '말のパッチムは？';

  @override
  String get hangulS8L0SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L0SummaryMsg => 'すごい！\nパッチムの概念を理解しました。';

  @override
  String get hangulS8L1Title => 'ㄴパッチム';

  @override
  String get hangulS8L1Subtitle => '간 · 난 · 단';

  @override
  String get hangulS8L1Step0Title => 'ㄴパッチムを聴こう';

  @override
  String get hangulS8L1Step0Desc => '간/난/단を聴いてみましょう';

  @override
  String get hangulS8L1Step1Title => '発音練習';

  @override
  String get hangulS8L1Step1Desc => '各文字を声に出してみましょう';

  @override
  String get hangulS8L1Step2Title => '聴いて選ぼう';

  @override
  String get hangulS8L1Step2Desc => 'ㄴパッチムの音節を選んでください';

  @override
  String get hangulS8L1SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L1SummaryMsg => 'すごい！\nㄴパッチムを習得しました。';

  @override
  String get hangulS8L2Title => 'ㄹパッチム';

  @override
  String get hangulS8L2Subtitle => '말 · 갈 · 물';

  @override
  String get hangulS8L2Step0Title => 'ㄹパッチムを聴こう';

  @override
  String get hangulS8L2Step0Desc => '말/갈/물を聴いてみましょう';

  @override
  String get hangulS8L2Step1Title => '発音練習';

  @override
  String get hangulS8L2Step1Desc => '各文字を声に出してみましょう';

  @override
  String get hangulS8L2Step2Title => '聴いて選ぼう';

  @override
  String get hangulS8L2Step2Desc => 'ㄹパッチムの音節を選んでください';

  @override
  String get hangulS8L2SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L2SummaryMsg => 'すごい！\nㄹパッチムを習得しました。';

  @override
  String get hangulS8L3Title => 'ㅁパッチム';

  @override
  String get hangulS8L3Subtitle => '감 · 밤 · 숨';

  @override
  String get hangulS8L3Step0Title => 'ㅁパッチムを聴こう';

  @override
  String get hangulS8L3Step0Desc => '감/밤/숨を聴いてみましょう';

  @override
  String get hangulS8L3Step1Title => '発音練習';

  @override
  String get hangulS8L3Step1Desc => '各文字を声に出してみましょう';

  @override
  String get hangulS8L3Step2Title => 'パッチムを見分けよう';

  @override
  String get hangulS8L3Step2Desc => 'ㅁパッチムの音節を選びましょう';

  @override
  String get hangulS8L3Step2Q0 => 'ㅁパッチムはどれ？';

  @override
  String get hangulS8L3Step2Q1 => 'ㅁパッチムはどれ？';

  @override
  String get hangulS8L3SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L3SummaryMsg => 'すごい！\nㅁパッチムを習得しました。';

  @override
  String get hangulS8L4Title => 'ㅇパッチム';

  @override
  String get hangulS8L4Subtitle => '방 · 공 · 종';

  @override
  String get hangulS8L4Step0Title => 'ㅇは特別です！';

  @override
  String get hangulS8L4Step0Desc =>
      'ㅇは特別です！\n初声（上）では無音ですが（아, 오）、\nパッチム（下）では「ng」の音になります（방, 공）';

  @override
  String get hangulS8L4Step0Highlights => '初声,パッチム,ng,방,공';

  @override
  String get hangulS8L4Step1Title => 'ㅇパッチムを聴こう';

  @override
  String get hangulS8L4Step1Desc => '방/공/종を聴いてみましょう';

  @override
  String get hangulS8L4Step2Title => '発音練習';

  @override
  String get hangulS8L4Step2Desc => '各文字を声に出してみましょう';

  @override
  String get hangulS8L4Step3Title => '聴いて選ぼう';

  @override
  String get hangulS8L4Step3Desc => 'ㅇパッチムの音節を選んでください';

  @override
  String get hangulS8L4SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L4SummaryMsg => 'すごい！\nㅇパッチムを習得しました。';

  @override
  String get hangulS8L5Title => 'ㄱパッチム';

  @override
  String get hangulS8L5Subtitle => '박 · 각 · 국';

  @override
  String get hangulS8L5Step0Title => 'ㄱパッチムを聴こう';

  @override
  String get hangulS8L5Step0Desc => '박/각/국を聴いてみましょう';

  @override
  String get hangulS8L5Step1Title => '発音練習';

  @override
  String get hangulS8L5Step1Desc => '各文字を声に出してみましょう';

  @override
  String get hangulS8L5Step2Title => 'パッチムを見分けよう';

  @override
  String get hangulS8L5Step2Desc => 'ㄱパッチムの音節を選びましょう';

  @override
  String get hangulS8L5Step2Q0 => 'ㄱパッチムはどれ？';

  @override
  String get hangulS8L5Step2Q1 => 'ㄱパッチムはどれ？';

  @override
  String get hangulS8L5SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L5SummaryMsg => 'すごい！\nㄱパッチムを習得しました。';

  @override
  String get hangulS8L6Title => 'ㅂパッチム';

  @override
  String get hangulS8L6Subtitle => '밥 · 집 · 숲';

  @override
  String get hangulS8L6Step0Title => 'ㅂパッチムを聴こう';

  @override
  String get hangulS8L6Step0Desc => '밥/집/숲を聴いてみましょう';

  @override
  String get hangulS8L6Step1Title => '発音練習';

  @override
  String get hangulS8L6Step1Desc => '各文字を声に出してみましょう';

  @override
  String get hangulS8L6Step2Title => '聴いて選ぼう';

  @override
  String get hangulS8L6Step2Desc => 'ㅂパッチムの音節を選んでください';

  @override
  String get hangulS8L6SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L6SummaryMsg => 'すごい！\nㅂパッチムを習得しました。';

  @override
  String get hangulS8L7Title => 'ㅅパッチム';

  @override
  String get hangulS8L7Subtitle => '옷 · 맛 · 빛';

  @override
  String get hangulS8L7Step0Title => 'ㅅパッチムを聴こう';

  @override
  String get hangulS8L7Step0Desc => '옷/맛/빛を聴いてみましょう';

  @override
  String get hangulS8L7Step1Title => '発音練習';

  @override
  String get hangulS8L7Step1Desc => '各文字を声に出してみましょう';

  @override
  String get hangulS8L7Step2Title => 'パッチムを見分けよう';

  @override
  String get hangulS8L7Step2Desc => 'ㅅパッチムの音節を選びましょう';

  @override
  String get hangulS8L7Step2Q0 => 'ㅅパッチムはどれ？';

  @override
  String get hangulS8L7Step2Q1 => 'ㅅパッチムはどれ？';

  @override
  String get hangulS8L7SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L7SummaryMsg => 'すごい！\nㅅパッチムを習得しました。';

  @override
  String get hangulS8L8Title => 'パッチム総合復習';

  @override
  String get hangulS8L8Subtitle => '重要パッチムのランダム確認';

  @override
  String get hangulS8L8Step0Title => '全部まとめて確認';

  @override
  String get hangulS8L8Step0Desc => 'ㄴ ㄹ ㅁ ㅇ ㄱ ㅂ ㅅをまとめて確認しましょう。';

  @override
  String get hangulS8L8Step1Title => 'ランダムクイズ';

  @override
  String get hangulS8L8Step1Desc => '混合パッチムでテストしましょう';

  @override
  String get hangulS8L8Step1Q0 => 'ㄴパッチムはどれ？';

  @override
  String get hangulS8L8Step1Q1 => 'ㅇパッチムはどれ？';

  @override
  String get hangulS8L8Step1Q2 => 'ㄹパッチムはどれ？';

  @override
  String get hangulS8L8Step1Q3 => 'ㅂパッチムはどれ？';

  @override
  String get hangulS8L8SummaryTitle => 'レッスン完了！';

  @override
  String get hangulS8L8SummaryMsg => 'すごい！\nパッチム総合復習を完了しました。';

  @override
  String get hangulS8LMTitle => 'ミッション：パッチムチャレンジ！';

  @override
  String get hangulS8LMSubtitle => 'パッチム付きの音節を組み合わせよう';

  @override
  String get hangulS8LMStep0Title => 'パッチムミッション！';

  @override
  String get hangulS8LMStep0Desc => '基本的なパッチムのある音節を読んで\n素早く答えましょう！';

  @override
  String get hangulS8LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS8LMStep2Title => 'ミッション結果';

  @override
  String get hangulS8LMSummaryTitle => 'ミッション完了！';

  @override
  String get hangulS8LMSummaryMsg => 'パッチムの基礎を完全にマスターしました！';

  @override
  String get hangulS8CompleteTitle => 'ステージ8完了！';

  @override
  String get hangulS8CompleteMsg => 'パッチムの基礎をしっかり固めました！';

  @override
  String get hangulS9L1Title => 'パッチム ㄷ 拡張';

  @override
  String get hangulS9L1Subtitle => '닫 · 곧 · 묻';

  @override
  String get hangulS9L1Step0Title => 'ㄷ パッチムのパターン';

  @override
  String get hangulS9L1Step0Desc => 'パッチム ㄷ が入る音節を読みましょう。';

  @override
  String get hangulS9L1Step0Highlights => '닫,곧,묻';

  @override
  String get hangulS9L1Step1Title => '聴いてみよう：パッチム ㄷ';

  @override
  String get hangulS9L1Step1Desc => '닫/곧/묻を聴いてみましょう';

  @override
  String get hangulS9L1Step2Title => '発音練習';

  @override
  String get hangulS9L1Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS9L1Step3Title => 'パッチムを見分けよう';

  @override
  String get hangulS9L1Step3Desc => 'ㄷ パッチムを選んでください';

  @override
  String get hangulS9L1Step3Q0 => 'ㄷ パッチムはどれ？';

  @override
  String get hangulS9L1Step3Q1 => 'ㄷ パッチムはどれ？';

  @override
  String get hangulS9L1Step4Title => 'レッスン完了！';

  @override
  String get hangulS9L1Step4Msg => 'よくできました！\nㄷ パッチムを覚えました。';

  @override
  String get hangulS9L2Title => 'パッチム ㅈ 拡張';

  @override
  String get hangulS9L2Subtitle => '낮 · 잊 · 젖';

  @override
  String get hangulS9L2Step0Title => '聴いてみよう：パッチム ㅈ';

  @override
  String get hangulS9L2Step0Desc => '낮/잊/젖を聴いてみましょう';

  @override
  String get hangulS9L2Step1Title => '発音練習';

  @override
  String get hangulS9L2Step1Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS9L2Step2Title => '聴いて選ぼう';

  @override
  String get hangulS9L2Step2Desc => 'ㅈ パッチムの音節を選んでください';

  @override
  String get hangulS9L2Step3Title => 'レッスン完了！';

  @override
  String get hangulS9L2Step3Msg => 'よくできました！\nㅈ パッチムを覚えました。';

  @override
  String get hangulS9L3Title => 'パッチム ㅊ 拡張';

  @override
  String get hangulS9L3Subtitle => '꽃 · 닻 · 빚';

  @override
  String get hangulS9L3Step0Title => '聴いてみよう：パッチム ㅊ';

  @override
  String get hangulS9L3Step0Desc => '꽃/닻/빚を聴いてみましょう';

  @override
  String get hangulS9L3Step1Title => '発音練習';

  @override
  String get hangulS9L3Step1Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS9L3Step2Title => 'パッチムを見分けよう';

  @override
  String get hangulS9L3Step2Desc => 'ㅊ パッチムを選んでください';

  @override
  String get hangulS9L3Step2Q0 => 'ㅊ パッチムはどれ？';

  @override
  String get hangulS9L3Step2Q1 => 'ㅊ パッチムはどれ？';

  @override
  String get hangulS9L3Step3Title => 'レッスン完了！';

  @override
  String get hangulS9L3Step3Msg => 'よくできました！\nㅊ パッチムを覚えました。';

  @override
  String get hangulS9L4Title => 'パッチム ㅋ / ㅌ / ㅍ';

  @override
  String get hangulS9L4Subtitle => '부엌 · 밭 · 앞';

  @override
  String get hangulS9L4Step0Title => '3つのパッチムをまとめて';

  @override
  String get hangulS9L4Step0Desc => 'ㅋ・ㅌ・ㅍ のパッチムをまとめて覚えましょう。';

  @override
  String get hangulS9L4Step0Highlights => '부엌,밭,앞';

  @override
  String get hangulS9L4Step1Title => '音を聴いてみよう';

  @override
  String get hangulS9L4Step1Desc => '부엌/밭/앞を聴いてみましょう';

  @override
  String get hangulS9L4Step2Title => '発音練習';

  @override
  String get hangulS9L4Step2Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS9L4Step3Title => 'パッチムを見分けよう';

  @override
  String get hangulS9L4Step3Desc => '3つのパッチムを区別してみましょう';

  @override
  String get hangulS9L4Step3Q0 => 'ㅌ パッチムはどれ？';

  @override
  String get hangulS9L4Step3Q1 => 'ㅍ パッチムはどれ？';

  @override
  String get hangulS9L4Step4Title => 'レッスン完了！';

  @override
  String get hangulS9L4Step4Msg => 'よくできました！\nㅋ/ㅌ/ㅍ パッチムを覚えました。';

  @override
  String get hangulS9L5Title => 'パッチム ㅎ 拡張';

  @override
  String get hangulS9L5Subtitle => '좋 · 놓 · 않';

  @override
  String get hangulS9L5Step0Title => '聴いてみよう：パッチム ㅎ';

  @override
  String get hangulS9L5Step0Desc => '좋/놓/않を聴いてみましょう';

  @override
  String get hangulS9L5Step1Title => '発音練習';

  @override
  String get hangulS9L5Step1Desc => '文字を実際に声に出してみましょう';

  @override
  String get hangulS9L5Step2Title => '聴いて選ぼう';

  @override
  String get hangulS9L5Step2Desc => 'ㅎ パッチムの音節を選んでください';

  @override
  String get hangulS9L5Step3Title => 'レッスン完了！';

  @override
  String get hangulS9L5Step3Msg => 'よくできました！\nㅎ パッチムを覚えました。';

  @override
  String get hangulS9L6Title => '拡張パッチム ランダム';

  @override
  String get hangulS9L6Subtitle => 'ㄷ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ を混ぜよう';

  @override
  String get hangulS9L6Step0Title => '拡張パッチムをシャッフル';

  @override
  String get hangulS9L6Step0Desc => '拡張パッチムをランダムに総復習しましょう。';

  @override
  String get hangulS9L6Step1Title => 'ランダムクイズ';

  @override
  String get hangulS9L6Step1Desc => '問題を解いて区別しましょう';

  @override
  String get hangulS9L6Step1Q0 => 'ㄷ パッチムはどれ？';

  @override
  String get hangulS9L6Step1Q1 => 'ㅈ パッチムはどれ？';

  @override
  String get hangulS9L6Step1Q2 => 'ㅊ パッチムはどれ？';

  @override
  String get hangulS9L6Step1Q3 => 'ㅎ パッチムはどれ？';

  @override
  String get hangulS9L6Step2Title => 'レッスン完了！';

  @override
  String get hangulS9L6Step2Msg => 'よくできました！\n拡張パッチムのランダム復習が完了しました。';

  @override
  String get hangulS9L7Title => 'ステージ9 総まとめ';

  @override
  String get hangulS9L7Subtitle => '拡張パッチム読みの仕上げ';

  @override
  String get hangulS9L7Step0Title => '最終確認';

  @override
  String get hangulS9L7Step0Desc => 'ステージ9の重要ポイントを最終チェックします';

  @override
  String get hangulS9L7Step1Title => 'ステージ9 完了！';

  @override
  String get hangulS9L7Step1Msg => 'おめでとうございます！\nステージ9の拡張パッチムを完了しました。';

  @override
  String get hangulS9LMTitle => 'ミッション：拡張パッチムチャレンジ！';

  @override
  String get hangulS9LMSubtitle => 'さまざまなパッチムを素早く読もう';

  @override
  String get hangulS9LMStep0Title => '拡張パッチム ミッション！';

  @override
  String get hangulS9LMStep0Desc => '拡張パッチムを含む音節を\n素早く組み合わせましょう！';

  @override
  String get hangulS9LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS9LMStep2Title => 'ミッション結果';

  @override
  String get hangulS9LMStep3Title => 'ミッション完了！';

  @override
  String get hangulS9LMStep3Msg => '拡張パッチムまで制覇しました！';

  @override
  String get hangulS9CompleteTitle => 'ステージ9 完了！';

  @override
  String get hangulS9CompleteMsg => '拡張パッチムまで制覇しました！';

  @override
  String get hangulS10L1Title => 'ㄳ パッチム';

  @override
  String get hangulS10L1Subtitle => '몫・넋 中心の読み方';

  @override
  String get hangulS10L1Step0Title => '二重パッチムの発音ルール';

  @override
  String get hangulS10L1Step0Desc =>
      '二重パッチムとは、2つの子音が組み合わさった終声です。\n\nほとんどは左側の子音で発音されます：\nㄳ→[ㄱ], ㄵ→[ㄴ], ㄶ→[ㄴ], ㄻ→[ㅁ], ㅄ→[ㅂ]\n\n一部は右側の子音で発音されます：\nㄺ→[ㄹ], ㄼ→[ㄹ]';

  @override
  String get hangulS10L1Step0Highlights => '左の子音,右の子音,二重パッチム';

  @override
  String get hangulS10L1Step1Title => '複合パッチムのスタート';

  @override
  String get hangulS10L1Step1Desc => 'ㄳ パッチムが入った単語を読んでみましょう。';

  @override
  String get hangulS10L1Step1Highlights => '몫,넋';

  @override
  String get hangulS10L1Step2Title => '音を聞く';

  @override
  String get hangulS10L1Step2Desc => '몫/넋 を聞いてみましょう';

  @override
  String get hangulS10L1Step3Title => '発音練習';

  @override
  String get hangulS10L1Step3Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS10L1Step4Title => '読み確認';

  @override
  String get hangulS10L1Step4Desc => '単語を見て選んでください';

  @override
  String get hangulS10L1Step4Q0 => 'ㄳ パッチムの単語は？';

  @override
  String get hangulS10L1Step4Q1 => 'ㄳ パッチムの単語は？';

  @override
  String get hangulS10L1Step5Title => 'レッスン完了！';

  @override
  String get hangulS10L1Step5Msg => 'よくできました！\nㄳ パッチムをマスターしました。';

  @override
  String get hangulS10L2Title => 'ㄵ / ㄶ パッチム';

  @override
  String get hangulS10L2Subtitle => '앉다・많다';

  @override
  String get hangulS10L2Step0Title => '音を聞く';

  @override
  String get hangulS10L2Step0Desc => '앉다/많다 を聞いてみましょう';

  @override
  String get hangulS10L2Step1Title => '発音練習';

  @override
  String get hangulS10L2Step1Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS10L2Step2Title => '聞いて選ぶ';

  @override
  String get hangulS10L2Step2Desc => '正しい単語を選んでください';

  @override
  String get hangulS10L2Step3Title => 'レッスン完了！';

  @override
  String get hangulS10L2Step3Msg => 'よくできました！\nㄵ/ㄶ パッチムをマスターしました。';

  @override
  String get hangulS10L3Title => 'ㄺ / ㄻ パッチム';

  @override
  String get hangulS10L3Subtitle => '읽다・삶';

  @override
  String get hangulS10L3Step0Title => '音を聞く';

  @override
  String get hangulS10L3Step0Desc => '읽다/삶 を聞いてみましょう';

  @override
  String get hangulS10L3Step1Title => '発音練習';

  @override
  String get hangulS10L3Step1Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS10L3Step2Title => '読み確認';

  @override
  String get hangulS10L3Step2Desc => '複合パッチムの単語を選んでください';

  @override
  String get hangulS10L3Step2Q0 => 'ㄺ パッチムの単語は？';

  @override
  String get hangulS10L3Step2Q1 => 'ㄻ パッチムの単語は？';

  @override
  String get hangulS10L3Step3Title => 'レッスン完了！';

  @override
  String get hangulS10L3Step3Msg => 'よくできました！\nㄺ/ㄻ パッチムをマスターしました。';

  @override
  String get hangulS10L4Title => '上級グループ 1';

  @override
  String get hangulS10L4Subtitle => 'ㄼ・ㄾ・ㄿ・ㅀ';

  @override
  String get hangulS10L4Step0Title => '上級グループの紹介';

  @override
  String get hangulS10L4Step0Desc => 'よく見る例を中心に短く学びましょう。';

  @override
  String get hangulS10L4Step0Highlights => '넓다,핥다,읊다,싫다';

  @override
  String get hangulS10L4Step1Title => '単語の音を聞く';

  @override
  String get hangulS10L4Step1Desc => '넓다/핥다/읊다/싫다 を聞いてみましょう';

  @override
  String get hangulS10L4Step2Title => '発音練習';

  @override
  String get hangulS10L4Step2Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS10L4Step3Title => 'レッスン完了！';

  @override
  String get hangulS10L4Step3Msg => 'よくできました！\n上級グループ 1 をマスターしました。';

  @override
  String get hangulS10L5Title => 'ㅄ パッチム';

  @override
  String get hangulS10L5Subtitle => '없다 中心の読み方';

  @override
  String get hangulS10L5Step0Title => '音を聞く';

  @override
  String get hangulS10L5Step0Desc => '없다/없어 を聞いてみましょう';

  @override
  String get hangulS10L5Step1Title => '発音練習';

  @override
  String get hangulS10L5Step1Desc => '文字を声に出して読んでみましょう';

  @override
  String get hangulS10L5Step2Title => '聞いて選ぶ';

  @override
  String get hangulS10L5Step2Desc => '正しい単語を選んでください';

  @override
  String get hangulS10L5Step3Title => 'レッスン完了！';

  @override
  String get hangulS10L5Step3Msg => 'よくできました！\nㅄ パッチムをマスターしました。';

  @override
  String get hangulS10L6Title => 'ステージ10 総合';

  @override
  String get hangulS10L6Subtitle => '複合パッチム単語の統合';

  @override
  String get hangulS10L6Step0Title => '総合チェック';

  @override
  String get hangulS10L6Step0Desc => '複合パッチム単語の最終チェックをしましょう';

  @override
  String get hangulS10L6Step0Q0 => '次のうち ㄶ パッチムの単語は？';

  @override
  String get hangulS10L6Step0Q1 => '次のうち ㄺ パッチムの単語は？';

  @override
  String get hangulS10L6Step0Q2 => '次のうち ㅄ パッチムの単語は？';

  @override
  String get hangulS10L6Step0Q3 => '次のうち ㄳ パッチムの単語は？';

  @override
  String get hangulS10L6Step1Title => 'ステージ10 完了！';

  @override
  String get hangulS10L6Step1Msg => 'おめでとうございます！\nステージ10の複合パッチムを完了しました。';

  @override
  String get hangulS10LMTitle => 'ミッション：二重パッチムチャレンジ！';

  @override
  String get hangulS10LMSubtitle => '二重パッチムの単語を素早く読む';

  @override
  String get hangulS10LMStep0Title => '二重パッチムミッション！';

  @override
  String get hangulS10LMStep0Desc => '二重パッチムが含まれた音節を\n素早く組み合わせましょう！';

  @override
  String get hangulS10LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS10LMStep2Title => 'ミッション結果';

  @override
  String get hangulS10LMStep3Title => 'ミッション完了！';

  @override
  String get hangulS10LMStep3Msg => '二重パッチムまでマスターしました！';

  @override
  String get hangulS10LMStep4Title => 'ステージ10 完了！';

  @override
  String get hangulS10CompleteTitle => 'ステージ10 完了！';

  @override
  String get hangulS10CompleteMsg => '二重パッチムまでマスターしました！';

  @override
  String get hangulS11L1Title => 'パッチムなしの単語';

  @override
  String get hangulS11L1Subtitle => '簡単な2〜3音節の単語';

  @override
  String get hangulS11L1Step0Title => '単語読みのスタート';

  @override
  String get hangulS11L1Step0Desc => 'まずはパッチムなしの単語で自信をつけましょう。';

  @override
  String get hangulS11L1Step0Highlights => '바나나,나비,하마,모자';

  @override
  String get hangulS11L1Step1Title => '単語を聴いてみよう';

  @override
  String get hangulS11L1Step1Desc => '바나나 / 나비 / 하마 / 모자を聴いてみましょう';

  @override
  String get hangulS11L1Step2Title => '発音練習';

  @override
  String get hangulS11L1Step2Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS11L1Step3Title => 'レッスン完了！';

  @override
  String get hangulS11L1Step3Msg => 'よくできました！\nパッチムなしの単語読みを始めました。';

  @override
  String get hangulS11L2Title => '基本パッチムの単語';

  @override
  String get hangulS11L2Subtitle => '학교・친구・한국・공부';

  @override
  String get hangulS11L2Step0Title => '単語を聴いてみよう';

  @override
  String get hangulS11L2Step0Desc => '학교 / 친구 / 한국 / 공부を聴いてみましょう';

  @override
  String get hangulS11L2Step1Title => '発音練習';

  @override
  String get hangulS11L2Step1Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS11L2Step2Title => '聴いて選ぼう';

  @override
  String get hangulS11L2Step2Desc => '聴こえた単語を選んでください';

  @override
  String get hangulS11L2Step3Title => 'レッスン完了！';

  @override
  String get hangulS11L2Step3Msg => 'よくできました！\n基本パッチムの単語を読みました。';

  @override
  String get hangulS11L3Title => '混合パッチムの単語';

  @override
  String get hangulS11L3Subtitle => '읽기・없다・많다・닭';

  @override
  String get hangulS11L3Step0Title => '難易度アップ';

  @override
  String get hangulS11L3Step0Desc => '基本と複合パッチムが混ざった単語を読みましょう。';

  @override
  String get hangulS11L3Step0Highlights => '읽기,없다,많다,닭';

  @override
  String get hangulS11L3Step1Title => '単語の区別';

  @override
  String get hangulS11L3Step1Desc => '似た単語を区別しましょう';

  @override
  String get hangulS11L3Step1Q0 => '複合パッチムの単語はどれですか？';

  @override
  String get hangulS11L3Step1Q1 => '複合パッチムの単語はどれですか？';

  @override
  String get hangulS11L3Step2Title => 'レッスン完了！';

  @override
  String get hangulS11L3Step2Msg => 'よくできました！\n混合パッチムの単語を読みました。';

  @override
  String get hangulS11L4Title => 'カテゴリー単語パック';

  @override
  String get hangulS11L4Subtitle => '食べ物・場所・人';

  @override
  String get hangulS11L4Step0Title => 'カテゴリー単語を聴こう';

  @override
  String get hangulS11L4Step0Desc => '食べ物・場所・人の単語を聴きましょう';

  @override
  String get hangulS11L4Step1Title => '発音練習';

  @override
  String get hangulS11L4Step1Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS11L4Step2Title => 'カテゴリー分類';

  @override
  String get hangulS11L4Step2Desc => '単語を見てカテゴリーを選んでください';

  @override
  String get hangulS11L4Step2Q0 => '「김치」は何ですか？';

  @override
  String get hangulS11L4Step2Q1 => '「시장」は何ですか？';

  @override
  String get hangulS11L4Step2Q2 => '「학생」は何ですか？';

  @override
  String get hangulS11L4Step2CatFood => '食べ物';

  @override
  String get hangulS11L4Step2CatPlace => '場所';

  @override
  String get hangulS11L4Step2CatPerson => '人';

  @override
  String get hangulS11L4Step3Title => 'レッスン完了！';

  @override
  String get hangulS11L4Step3Msg => 'よくできました！\nカテゴリー単語を学びました。';

  @override
  String get hangulS11L5Title => '聴いて選ぶ単語';

  @override
  String get hangulS11L5Subtitle => '聴覚と読みの連結を強化';

  @override
  String get hangulS11L5Step0Title => '音のマッチング';

  @override
  String get hangulS11L5Step0Desc => '音を聴いて正しい単語を選んでください';

  @override
  String get hangulS11L5Step1Title => 'レッスン完了！';

  @override
  String get hangulS11L5Step1Msg => 'よくできました！\n聴いて選ぶ単語トレーニングを終えました。';

  @override
  String get hangulS11L6Title => 'ステージ11 総まとめ';

  @override
  String get hangulS11L6Subtitle => '単語読みの最終確認';

  @override
  String get hangulS11L6Step0Title => '総合クイズ';

  @override
  String get hangulS11L6Step0Desc => 'ステージ11の単語を総合確認します';

  @override
  String get hangulS11L6Step0Q0 => 'パッチムなしの単語はどれですか？';

  @override
  String get hangulS11L6Step0Q1 => '基本パッチムの単語はどれですか？';

  @override
  String get hangulS11L6Step0Q2 => '複合パッチムの単語はどれですか？';

  @override
  String get hangulS11L6Step0Q3 => '場所の単語はどれですか？';

  @override
  String get hangulS11L6Step1Title => 'ステージ11 完了！';

  @override
  String get hangulS11L6Step1Msg => 'おめでとうございます！\nステージ11の単語読み拡張を完了しました。';

  @override
  String get hangulS11L7Title => '日常でのハングル読み';

  @override
  String get hangulS11L7Subtitle => 'カフェメニュー・地下鉄・挨拶を読もう';

  @override
  String get hangulS11L7Step0Title => '韓国でハングルを読もう！';

  @override
  String get hangulS11L7Step0Desc => 'ハングルをすべて学びました！\n実際の韓国で見かける文字を読んでみましょう！';

  @override
  String get hangulS11L7Step0Highlights => 'カフェ,地下鉄,挨拶';

  @override
  String get hangulS11L7Step1Title => 'カフェメニューを読もう';

  @override
  String get hangulS11L7Step1Descs => 'アメリカーノ,カフェラテ,緑茶,ケーキ';

  @override
  String get hangulS11L7Step2Title => '地下鉄駅名を読もう';

  @override
  String get hangulS11L7Step2Descs => 'ソウル駅,江南,弘大入口,明洞';

  @override
  String get hangulS11L7Step3Title => '基本的な挨拶を読もう';

  @override
  String get hangulS11L7Step3Descs => 'こんにちは,ありがとうございます,はい,いいえ';

  @override
  String get hangulS11L7Step4Title => '発音練習';

  @override
  String get hangulS11L7Step4Desc => '文字を声に出して読みましょう';

  @override
  String get hangulS11L7Step5Title => 'どこで見られる？';

  @override
  String get hangulS11L7Step5Q0 => '「아메리카노」はどこで見られますか？';

  @override
  String get hangulS11L7Step5Q0Ans => 'カフェ';

  @override
  String get hangulS11L7Step5Q0C0 => 'カフェ';

  @override
  String get hangulS11L7Step5Q0C1 => '地下鉄';

  @override
  String get hangulS11L7Step5Q0C2 => '学校';

  @override
  String get hangulS11L7Step5Q1 => '「강남」は何ですか？';

  @override
  String get hangulS11L7Step5Q1Ans => '地下鉄駅の名前';

  @override
  String get hangulS11L7Step5Q1C0 => '食べ物の名前';

  @override
  String get hangulS11L7Step5Q1C1 => '地下鉄駅の名前';

  @override
  String get hangulS11L7Step5Q1C2 => '挨拶';

  @override
  String get hangulS11L7Step5Q2 => '「감사합니다」は日本語で？';

  @override
  String get hangulS11L7Step5Q2Ans => 'ありがとうございます';

  @override
  String get hangulS11L7Step5Q2C0 => 'こんにちは';

  @override
  String get hangulS11L7Step5Q2C1 => 'ありがとうございます';

  @override
  String get hangulS11L7Step5Q2C2 => 'さようなら';

  @override
  String get hangulS11L7Step6Title => 'おめでとうございます！';

  @override
  String get hangulS11L7Step6Msg =>
      '韓国でカフェメニュー、地下鉄の駅名、挨拶が読めるようになりました！\nハングルマスターまであと少し！';

  @override
  String get hangulS11LMTitle => 'ミッション：ハングル速読！';

  @override
  String get hangulS11LMSubtitle => '韓国語の単語を素早く読もう';

  @override
  String get hangulS11LMStep0Title => 'ハングル速読ミッション！';

  @override
  String get hangulS11LMStep0Desc => '韓国語の単語をできるだけ素早く読んで答えましょう！\n実力を証明する時です！';

  @override
  String get hangulS11LMStep1Title => '音節を組み合わせよう！';

  @override
  String get hangulS11LMStep2Title => 'ミッション結果';

  @override
  String get hangulS11LMStep3Title => 'ハングルマスター！';

  @override
  String get hangulS11LMStep3Msg => 'ハングルを完全にマスターしました！\nこれで韓国語の単語と文が読めます！';

  @override
  String get hangulS11LMStep4Title => 'ステージ11 完了！';

  @override
  String get hangulS11LMStep4Msg => 'ハングルを完全に読めるようになりました！';

  @override
  String get hangulS11CompleteTitle => 'ステージ11 完了！';

  @override
  String get hangulS11CompleteMsg => 'ハングルを完全に読めるようになりました！';

  @override
  String get stageRequestFailed => 'ステージリクエストの送信に失敗しました。もう一度お試しください。';

  @override
  String get stageRequestRejected => 'ホストにステージリクエストが拒否されました。';

  @override
  String get inviteToStageFailed => 'ステージへの招待に失敗しました。ステージがいっぱいの可能性があります。';

  @override
  String get demoteFailed => 'ステージからの降格に失敗しました。もう一度お試しください。';

  @override
  String get voiceRoomCloseRoomFailed => 'ルームを閉じることができませんでした。もう一度お試しください。';
}
