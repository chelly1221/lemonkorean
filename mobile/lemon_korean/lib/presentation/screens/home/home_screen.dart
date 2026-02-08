import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../../core/storage/local_storage.dart'
    if (dart.library.html) '../../../core/platform/web/stubs/local_storage_stub.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/progress_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bookmark_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/settings_provider.dart';
import '../download/download_manager_screen.dart';
import '../lesson/lesson_screen.dart';
import '../review/review_screen.dart';
import '../settings/settings_menu_screen.dart';
import '../stats/completed_lessons_screen.dart';
import '../stats/mastered_words_screen.dart';
import '../vocabulary_book/vocabulary_book_screen.dart';
import '../vocabulary_browser/vocabulary_browser_screen.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/continue_lesson_card.dart';
import 'widgets/hangul_path_view.dart';
import 'widgets/lesson_path_view.dart';
import 'widgets/level_selector.dart';
import '../../../core/constants/level_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: const [
            _HomeTab(),
            _ReviewTab(),
            _ProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context) {
          final l10n = AppLocalizations.of(context);
          return NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.school),
                selectedIcon: const Icon(Icons.school),
                label: l10n?.home ?? 'Home',
              ),
              NavigationDestination(
                icon: const Icon(Icons.replay),
                selectedIcon: const Icon(Icons.replay),
                label: l10n?.review ?? 'Review',
              ),
              NavigationDestination(
                icon: const Icon(Icons.account_circle),
                selectedIcon: const Icon(Icons.account_circle),
                label: l10n?.profile ?? 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}

// ================================================================
// HOME TAB
// ================================================================

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  List<LessonModel> _lessons = [];
  ProgressModel? _currentProgress;
  Map<int, double> _lessonProgress = {}; // lesson_id -> progress (0.0-1.0)
  int _selectedLevel = 1;
  Set<int> _levelsWithProgress = {};

  List<LessonModel> get _filteredLessons =>
      _lessons.where((l) => l.level == _selectedLevel).toList();

  @override
  void initState() {
    super.initState();
    _loadData();
  }


  Future<void> _loadData() async {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Step 1: Load cached data immediately for instant display
    _loadCachedData(lessonProvider);

    // Step 2: Fetch fresh data in background (parallel API calls)
    await _fetchFreshData(lessonProvider, progressProvider, authProvider);
  }

  /// Load cached lessons immediately for instant display
  void _loadCachedData(LessonProvider lessonProvider) {
    // First try from provider (may already have data from splash prefetch)
    if (lessonProvider.lessons.isNotEmpty) {
      setState(() {
        _lessons = lessonProvider.lessons
            .map((json) => LessonModel.fromJson(json))
            .toList();
      });
      return;
    }

    // Fallback to direct local storage read
    final cachedLessons = LocalStorage.getAllLessons();
    if (cachedLessons.isNotEmpty) {
      setState(() {
        _lessons = cachedLessons
            .map((json) => LessonModel.fromJson(json))
            .toList();
      });
    }
  }

  /// Fetch fresh data with parallel API calls
  Future<void> _fetchFreshData(
    LessonProvider lessonProvider,
    ProgressProvider progressProvider,
    AuthProvider authProvider,
  ) async {
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    final language = settingsProvider.contentLanguageCode;

    // Parallel fetch: lessons, progress, and stats at the same time
    if (authProvider.currentUser != null) {
      await Future.wait([
        lessonProvider.fetchLessons(language: language),
        progressProvider.fetchProgress(authProvider.currentUser!.id),
        progressProvider.fetchUserStats(authProvider.currentUser!.id),
      ]);

      // Update progress stats
      _updateProgressStats(progressProvider);
    } else {
      // No user logged in, just fetch lessons
      await lessonProvider.fetchLessons(language: language);
    }

    // Update lessons from provider
    _updateLessonsFromProvider(lessonProvider);
  }

  /// Update progress statistics from provider data
  void _updateProgressStats(ProgressProvider progressProvider) {
    final progressList = progressProvider.progressList;

    // Build lesson progress map
    final lessonProgressMap = <int, double>{};
    for (final progress in progressList) {
      final lessonId = progress['lesson_id'] as int;
      final status = progress['status'] as String?;
      final quizScore = progress['quiz_score'] as int?;

      if (status == 'completed') {
        lessonProgressMap[lessonId] = 1.0;
      } else if (status == 'in_progress') {
        if (quizScore != null) {
          lessonProgressMap[lessonId] = (quizScore / 100).clamp(0.0, 0.99);
        } else {
          lessonProgressMap[lessonId] = 0.5;
        }
      }
    }

    // Compute which levels have progress
    final progressLevels = <int>{};
    for (final lesson in _lessons) {
      if (lessonProgressMap.containsKey(lesson.id)) {
        progressLevels.add(lesson.level);
      }
    }

    setState(() {
      _lessonProgress = lessonProgressMap;
      _levelsWithProgress = progressLevels;
    });
  }

  /// Update lessons list from provider
  void _updateLessonsFromProvider(LessonProvider lessonProvider) {
    setState(() {
      _lessons = lessonProvider.lessons
          .map((json) => LessonModel.fromJson(json))
          .toList();

      // If no lessons from API, create mock data
      if (_lessons.isEmpty) {
        for (int i = 1; i <= 12; i++) {
          _lessons.add(
            LessonModel(
              id: i,
              level: (i - 1) ~/ 4 + 1,
              titleKo: '한국어 레슨 $i',
              title: 'Korean Lesson $i',
              description: 'Description for lesson $i',
              version: '1.0.0',
              status: 'published',
              estimatedMinutes: 30 + (i * 5),
              vocabularyCount: 10 + (i * 2),
              isDownloaded: i <= 3,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          );
        }
      }
    });
  }

  void _onLevelSelected(int level) {
    setState(() {
      _selectedLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLessons;

    return CustomScrollView(
      slivers: [
        // Level Selector
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: AppConstants.paddingSmall),
            child: LevelSelector(
              selectedLevel: _selectedLevel,
              levelsWithProgress: _levelsWithProgress,
              onLevelSelected: _onLevelSelected,
            ),
          ),
        ),

        // Continue Learning Section
        if (_currentProgress != null && _lessons.isNotEmpty)
          SliverToBoxAdapter(
            child: Builder(
              builder: (context) {
                final l10n = AppLocalizations.of(context);
                return Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n?.continueLearning ?? 'Continue Learning',
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
                      ContinueLessonCard(
                        lesson: _lessons.first,
                        progress: _currentProgress!,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonScreen(lesson: _lessons.first),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    );
              },
            ),
          ),

        // Hangul Path View for Level 0
        if (_selectedLevel == 0)
          const SliverToBoxAdapter(
            child: HangulPathView(),
          )
        // Lessons Grid or Empty State
        else if (filtered.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingXLarge,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Coming soon',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          SliverToBoxAdapter(
            child: LessonPathView(
              lessons: filtered,
              lessonProgress: _lessonProgress,
              levelColor: LevelConstants.getLevelColor(_selectedLevel),
              onLessonTap: (lesson) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LessonScreen(lesson: lesson),
                  ),
                );
              },
            ),
          ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: AppConstants.paddingLarge),
        ),
      ],
    );
  }
}

// ================================================================
// REVIEW TAB
// ================================================================

class _ReviewTab extends StatelessWidget {
  const _ReviewTab();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: Text(
            l10n?.reviewSchedule ?? 'Review Schedule',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Card(
              color: AppConstants.primaryColor.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  children: [
                    const Icon(
                      Icons.replay_circle_filled_outlined,
                      size: 60,
                      color: AppConstants.primaryColor,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      l10n?.todayReview ?? "Today's Review",
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    Text(
                      l10n?.wordsWaitingReview(15) ?? '15 words waiting for review',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReviewScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingLarge,
                          vertical: AppConstants.paddingMedium,
                        ),
                      ),
                      child: Text(l10n?.startReview ?? 'Start Review'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final days = [
                  l10n?.today ?? 'Today',
                  l10n?.tomorrow ?? 'Tomorrow',
                  l10n?.daysLater(2) ?? '2 days later',
                  l10n?.daysLater(3) ?? '3 days later',
                ];
                final counts = [15, 8, 12, 5];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: AppConstants.paddingMedium,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppConstants.primaryColor.withValues(alpha: 0.2),
                      child: Text(
                        '${counts[index]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(days[index]),
                    subtitle: Text(l10n?.wordsWaitingReview(counts[index]) ?? '${counts[index]} words'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                );
              },
              childCount: 4,
            ),
          ),
        ),
      ],
    );
  }
}

// ================================================================
// PROFILE TAB
// ================================================================

class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  int _streakDays = 0;
  double _todayProgress = 0.0;
  int _completedToday = 0;
  final int _targetLessons = 3;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  /// Calculate streak days from progress data
  int _calculateStreakDays(List<Map<String, dynamic>> progressList) {
    if (progressList.isEmpty) return 0;

    // Filter and sort completed lessons by completion date
    final completedProgress = progressList
        .where((p) => p['status'] == 'completed' && p['completed_at'] != null)
        .toList();

    if (completedProgress.isEmpty) return 0;

    // Sort by completion date (most recent first)
    completedProgress.sort((a, b) {
      final dateA = DateTime.parse(a['completed_at']);
      final dateB = DateTime.parse(b['completed_at']);
      return dateB.compareTo(dateA);
    });

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Check if there's activity today or yesterday
    final mostRecent = DateTime.parse(completedProgress[0]['completed_at']);
    final mostRecentDate = DateTime(mostRecent.year, mostRecent.month, mostRecent.day);

    final daysSinceLastActivity = today.difference(mostRecentDate).inDays;

    if (daysSinceLastActivity > 1) {
      // No activity today or yesterday - streak is broken
      return 0;
    }

    // Count consecutive days
    int streakDays = 1;

    // Get unique completion dates
    final uniqueDates = <DateTime>{};
    for (final p in completedProgress) {
      final date = DateTime.parse(p['completed_at']);
      final dayDate = DateTime(date.year, date.month, date.day);
      uniqueDates.add(dayDate);
    }

    final sortedDates = uniqueDates.toList()
      ..sort((a, b) => b.compareTo(a));

    // Count consecutive days
    for (int i = 1; i < sortedDates.length; i++) {
      final currentDay = sortedDates[i];
      final previousDay = sortedDates[i - 1];

      // Check if this is the previous day
      if (previousDay.difference(currentDay).inDays == 1) {
        streakDays++;
      } else {
        // Gap in streak - stop counting
        break;
      }
    }

    return streakDays;
  }

  /// Update daily statistics (streak and progress)
  void _updateDailyStats() {
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final progressList = progressProvider.progressList;
    final today = DateTime.now();

    final completedToday = progressList.where((p) {
      final completedAtStr = p['completed_at'];
      if (completedAtStr == null) return false;
      try {
        final completedAt = DateTime.parse(completedAtStr.toString());
        return completedAt.year == today.year &&
               completedAt.month == today.month &&
               completedAt.day == today.day;
      } catch (_) {
        return false;
      }
    }).length;

    setState(() {
      _streakDays = _calculateStreakDays(progressList);
      _completedToday = completedToday;
      _todayProgress = completedToday / _targetLessons;
    });
  }

  Future<void> _loadStats() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final bookmarkProvider = Provider.of<BookmarkProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await Future.wait([
        progressProvider.fetchUserStats(authProvider.currentUser!.id),
        bookmarkProvider.fetchBookmarks(silent: true),
      ]);
      _updateDailyStats();
    }
  }

  Widget _buildGreetingStreak(AuthProvider authProvider) {
    final l10n = AppLocalizations.of(context)!;
    final user = authProvider.currentUser;
    final hour = DateTime.now().hour;
    String greeting = hour < 12
        ? l10n.goodMorning
        : hour < 18
            ? l10n.goodAfternoon
            : l10n.goodEvening;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Greeting text (left side)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.username ?? l10n.user,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Streak badge (right side)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                border: Border.all(
                  color: Colors.orange.shade200,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$_streakDays',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      Text(
                        l10n.days,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final bookmarkProvider = Provider.of<BookmarkProvider>(context);
    final user = authProvider.currentUser;
    final l10n = AppLocalizations.of(context);

    return CustomScrollView(
      slivers: [
        // 톱니바퀴 설정 아이콘이 있는 SliverAppBar
        SliverAppBar(
          pinned: false,
          floating: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: Colors.black87,
              ),
              tooltip: l10n?.settings ?? 'Settings',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsMenuScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppConstants.primaryColor.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: AppConstants.primaryColor,
                  child: Text(
                    user?.username.isNotEmpty == true
                        ? user!.username[0].toUpperCase()
                        : '👤',
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Text(
                  user?.username ?? (l10n?.user ?? 'User'),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingSmall),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: user?.isPremium == true
                        ? AppConstants.primaryColor
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user?.isPremium == true
                        ? (l10n?.premiumMember ?? 'Premium Member')
                        : (l10n?.freeUser ?? 'Free User'),
                    style: TextStyle(
                      color: user?.isPremium == true
                          ? Colors.black87
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Greeting + Streak
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            child: _buildGreetingStreak(authProvider),
          ),
        ),

        // Daily Goal Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            child: DailyGoalCard(
              progress: _todayProgress,
              completedLessons: _completedToday,
              targetLessons: _targetLessons,
            ),
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSection(l10n?.learningStats ?? 'Learning Statistics'),
              _buildStatCard(
                label: l10n?.completedLessonsCount ?? 'Completed Lessons',
                value: '${progressProvider.completedLessons}',
                icon: Icons.check_circle_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompletedLessonsScreen(),
                    ),
                  );
                },
              ),
              _buildStatCard(
                label: l10n?.studyDays ?? 'Study Days',
                value: '${progressProvider.totalStudyDays}',
                icon: Icons.calendar_today_outlined,
              ),
              _buildStatCard(
                label: l10n?.masteredWordsCount ?? 'Mastered Words',
                value: '${progressProvider.masteredWords}',
                icon: Icons.translate,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MasteredWordsScreen(),
                    ),
                  );
                },
              ),
              _buildStatCard(
                label: l10n?.myVocabularyBook ?? 'My Vocabulary Book',
                value: '${bookmarkProvider.bookmarkCount}',
                icon: Icons.bookmark,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VocabularyBookScreen(),
                    ),
                  );
                },
              ),
              _buildStatCard(
                label: l10n?.vocabularyBrowser ?? 'Vocabulary Browser',
                value: 'Level 1-6',
                icon: Icons.library_books,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VocabularyBrowserScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSection(l10n?.storageManagement ?? 'Storage Management'),
              _buildMenuItem(
                icon: Icons.storage_outlined,
                label: l10n?.storageManagement ?? 'Storage Management',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DownloadManagerScreen(),
                    ),
                  );
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.paddingMedium,
        bottom: AppConstants.paddingSmall,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.bold,
          color: AppConstants.textSecondary,
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required IconData icon,
    String? value,
    VoidCallback? onTap,
  }) {
    final card = Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Icon(icon, color: AppConstants.primaryColor),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                ),
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: AppConstants.paddingSmall),
              const Icon(
                Icons.chevron_right,
                color: AppConstants.textSecondary,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: card,
      );
    }

    return card;
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}

