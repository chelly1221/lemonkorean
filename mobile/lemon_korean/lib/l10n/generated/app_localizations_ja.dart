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
  String get operationFailed => '操作に失敗しました。しばらくしてからもう一度お試しください。';

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
      '中国語話者向けに設計された韓国語学習アプリです。オフライン学習、スマート復習リマインダーなどの機能をサポートしています。';

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
  String get lessonComplete => 'レッスン完了！進捗が保存されました';

  @override
  String get learningComplete => '学習完了';

  @override
  String experiencePoints(int points) {
    return '経験値 +$points';
  }

  @override
  String get keepLearning => '学習のモチベーションを維持しましょう';

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
  String get grammarExplanation => '文法説明';

  @override
  String get exampleSentences => '例文';

  @override
  String get previous => '前へ';

  @override
  String get next => '次へ';

  @override
  String get continueBtn => '続ける';

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
  String get fillBlank => '空欄を埋める';

  @override
  String get translation => '翻訳';

  @override
  String get wordOrder => '語順';

  @override
  String get pronunciation => '発音';

  @override
  String get excellent => '素晴らしい！';

  @override
  String get correctOrderIs => '正しい順序：';

  @override
  String correctAnswerIs(String answer) {
    return '正解: $answer';
  }

  @override
  String get previousQuestion => '前の問題';

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
  String get vocabularyBrowser => '単語ブラウザ';

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
  String get onboardingLanguageTitle => 'レモン韓国語';

  @override
  String get onboardingLanguagePrompt => '使用言語を選択してください';

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
  String get levelBeginnerDesc => '大丈夫！ハングルから始めよう';

  @override
  String get levelElementary => '初級';

  @override
  String get levelElementaryDesc => '基礎会話から練習しよう！';

  @override
  String get levelIntermediate => '中級';

  @override
  String get levelIntermediateDesc => 'より自然に話そう！';

  @override
  String get levelAdvanced => '上級';

  @override
  String get levelAdvancedDesc => '細かい表現まで極めよう！';

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
  String get onboardingFeature2Desc => 'AI駆動の間隔反復で記憶力向上';

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
  String get goalRegular => 'レギュラー';

  @override
  String get goalRegularDesc => '週3-4レッスン';

  @override
  String get goalRegularTime => '~週30-40分';

  @override
  String get goalRegularHelper => 'プレッシャーなく着実に進歩';

  @override
  String get goalSerious => 'シリアス';

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
  String get sortByChinese => '中国語順';

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
  String get sortChinese => '中国語順';

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
  String get searchWordsNotesChinese => '単語、中国語、メモを検索...';

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
  String get alphabetTable => '五十音表';

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
  String get loadAlphabetFirst => 'まず五十音表データを読み込んでください';

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
  String get dailyLearningReminderBody => '今日の韓国語学習を完了しましょう～';

  @override
  String get reviewReminderTitle => '復習の時間です！';

  @override
  String reviewReminderBody(String title) {
    return '「$title」を復習する時間です～';
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
  String grammarPattern(String pattern) {
    return '文法 · $pattern';
  }

  @override
  String get conjugationRule => '活用ルール';

  @override
  String get comparisonWithChinese => '中国語との比較';

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
  String get checkAnswerBtn => '答え合わせ';

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
  String get statusFailed => '不合格';

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
  String get notificationStudyReminder => '今日の韓国語学習を完了しましょう〜';

  @override
  String get notificationReviewTime => '復習の時間です！';

  @override
  String get notificationReviewReminder => '以前学んだ内容を復習しましょう〜';

  @override
  String notificationReviewLesson(String lessonTitle) {
    return '「$lessonTitle」を復習しましょう〜';
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
  String get similarityWithChinese => '中国語との類似度';

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
  String get incorrectFeedback => 'もう一度考えてみてください';

  @override
  String get allStagesPassed => '7段階すべてクリア';

  @override
  String get continueToLearnMore => 'もっと学習を続ける';

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
  String get slowSpeed => '遅い';

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
}
