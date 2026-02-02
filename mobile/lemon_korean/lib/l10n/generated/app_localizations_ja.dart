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
  String get lessonComplete => 'レッスン完了！';

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
  String get fillBlank => '穴埋め';

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
  String get correctAnswerIs => '正解：';

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
}
