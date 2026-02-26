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
import '../../providers/gamification_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/progress_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/social_provider.dart';
import '../lesson/lesson_screen.dart';
import '../settings/settings_menu_screen.dart';
import '../vocabulary_book/vocabulary_book_screen.dart';
import '../community/community_screen.dart';
import '../my_room/my_room_screen.dart';
import '../dm/conversations_screen.dart';
import '../friend_search/friend_search_screen.dart';
import '../user_profile/user_profile_screen.dart';
import '../hangul/hangul_batchim_screen.dart';
import '../hangul/hangul_discrimination_screen.dart';
import '../hangul/hangul_syllable_screen.dart';
import '../hangul/hangul_table_screen.dart';
import '../profile/widgets/lemon_tree_widget.dart';
import '../profile/widgets/profile_stats_grid.dart';
import '../profile/widgets/streak_detail_sheet.dart';
import 'review_lessons_list_screen.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/continue_lesson_card.dart';
import 'widgets/hangul_dashboard_view.dart';
import 'widgets/lesson_path_view.dart';
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
            CommunityScreen(),
            ConversationsScreen(embedded: true),
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
                icon: const Icon(Icons.people_alt_outlined),
                selectedIcon: const Icon(Icons.people_alt),
                label: l10n?.community ?? 'Community',
              ),
              NavigationDestination(
                icon: const Icon(Icons.chat_bubble_outline),
                selectedIcon: const Icon(Icons.chat_bubble),
                label: l10n?.messages ?? 'Messages',
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
  Map<int, int> _lessonLemons = {}; // lesson_id -> 0-3 lemons earned
  int _selectedLevel = 1;
  Set<int> _levelsWithProgress = {};

  List<LessonModel> get _filteredLessons =>
      _lessons.where((l) => l.level == _selectedLevel).toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
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
      if (!mounted) return;
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
      if (!mounted) return;
      setState(() {
        _lessons =
            cachedLessons.map((json) => LessonModel.fromJson(json)).toList();
      });
    }
  }

  /// Fetch fresh data with parallel API calls
  Future<void> _fetchFreshData(
    LessonProvider lessonProvider,
    ProgressProvider progressProvider,
    AuthProvider authProvider,
  ) async {
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    final gamificationProvider =
        Provider.of<GamificationProvider>(context, listen: false);
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

    // Load gamification data (lemons)
    try {
      await gamificationProvider.loadFromStorage();
      _updateLemonData(gamificationProvider);
    } catch (e) {
      debugPrint('[HomeTab] Failed to load gamification data: $e');
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

    if (!mounted) return;
    setState(() {
      _lessonProgress = lessonProgressMap;
      _levelsWithProgress = progressLevels;
    });
  }

  /// Update lemon data from gamification provider
  void _updateLemonData(GamificationProvider gamificationProvider) {
    final lemonMap = <int, int>{};
    for (final lesson in _lessons) {
      final lemons = gamificationProvider.getLemonsForLesson(lesson.id);
      if (lemons > 0) {
        lemonMap[lesson.id] = lemons;
      }
    }
    if (!mounted) return;
    setState(() {
      _lessonLemons = lemonMap;
    });
  }

  /// Update lessons list from provider
  void _updateLessonsFromProvider(LessonProvider lessonProvider) {
    if (!mounted) return;
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

  String _levelLabel(int level) {
    if (level == 0) return '한글';
    return 'Lv$level';
  }

  Widget _buildHangulQuickActionButton({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(icon, size: 18, color: Colors.grey.shade700),
        ),
      ),
    );
  }

  Widget _buildReviewQuickAction(BuildContext context) {
    final reviewCount = _lessons
        .where((lesson) => _lessonProgress.containsKey(lesson.id))
        .length;
    final badgeText = reviewCount > 99 ? '99+' : '$reviewCount';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildHangulQuickActionButton(
          context: context,
          icon: Icons.replay,
          tooltip: '복습',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReviewLessonsListScreen(
                  lessons: _lessons,
                  lessonProgress: _lessonProgress,
                ),
              ),
            );
          },
        ),
        if (reviewCount > 0)
          Positioned(
            right: -5,
            top: -5,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
              decoration: BoxDecoration(
                color: Colors.red.shade500,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Text(
                badgeText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildVocabularyQuickAction(BuildContext context) {
    return _buildHangulQuickActionButton(
      context: context,
      icon: Icons.bookmark_outline,
      tooltip: '나의 단어장',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VocabularyBookScreen(),
          ),
        );
      },
    );
  }

  Widget _buildFixedHangulAction({
    required BuildContext context,
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return _buildHangulQuickActionButton(
      context: context,
      icon: icon,
      tooltip: tooltip,
      onTap: onTap,
    );
  }

  Widget _buildFixedHangulActions(BuildContext context) {
    return Positioned(
      right: 8,
      bottom: 8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFixedHangulAction(
            context: context,
            icon: Icons.grid_view_rounded,
            tooltip: '자모표',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulTableScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildFixedHangulAction(
            context: context,
            icon: Icons.widgets_outlined,
            tooltip: '음절조합',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulSyllableScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildFixedHangulAction(
            context: context,
            icon: Icons.layers_outlined,
            tooltip: '받침연습',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulBatchimScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          _buildFixedHangulAction(
            context: context,
            icon: Icons.hearing_outlined,
            tooltip: '소리구분훈련',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HangulDiscriminationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFixedTopActions(BuildContext context) {
    return Positioned(
      top: AppConstants.paddingSmall,
      left: AppConstants.paddingMedium,
      right: AppConstants.paddingMedium,
      child: Row(
        children: [
          PopupMenuButton<int>(
            onSelected: _onLevelSelected,
            itemBuilder: (context) => List.generate(
              LevelConstants.levelCount,
              (level) => PopupMenuItem<int>(
                value: level,
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: LevelConstants.getLevelColor(level),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_levelLabel(level))),
                    if (_levelsWithProgress.contains(level))
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppConstants.successColor,
                      ),
                  ],
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: LevelConstants.getLevelColor(_selectedLevel),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _levelLabel(_selectedLevel),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.expand_more, size: 18),
                ],
              ),
            ),
          ),
          const Spacer(),
          _buildVocabularyQuickAction(context),
          const SizedBox(width: 6),
          _buildReviewQuickAction(context),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredLessons;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Top fixed action bar spacer
            const SliverToBoxAdapter(
              child: SizedBox(height: 72),
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
                                  builder: (context) =>
                                      LessonScreen(lesson: _lessons.first),
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

            // Hangul Dashboard for Level 0
            if (_selectedLevel == 0)
              const SliverToBoxAdapter(
                child: HangulDashboardView(),
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
                  lessonLemons: _lessonLemons,
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
        ),
        _buildFixedTopActions(context),
        if (_selectedLevel == 0) _buildFixedHangulActions(context),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadStats();
    });
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
    final mostRecentDate =
        DateTime(mostRecent.year, mostRecent.month, mostRecent.day);

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

    final sortedDates = uniqueDates.toList()..sort((a, b) => b.compareTo(a));

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
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
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
    final progressProvider =
        Provider.of<ProgressProvider>(context, listen: false);
    final bookmarkProvider =
        Provider.of<BookmarkProvider>(context, listen: false);
    final socialProvider = Provider.of<SocialProvider>(context, listen: false);

    if (authProvider.currentUser != null) {
      await Future.wait([
        progressProvider.fetchUserStats(authProvider.currentUser!.id),
        bookmarkProvider.fetchBookmarks(silent: true),
        socialProvider.loadFollowing(authProvider.currentUser!.id),
      ]);
      _updateDailyStats();
    }
  }

  Widget _buildFriendsSection() {
    final l10n = AppLocalizations.of(context);
    return Consumer<SocialProvider>(
      builder: (context, socialProvider, _) {
        final following = socialProvider.following;
        return Card(
          margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_outline, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      l10n?.findFriends ?? 'Friends',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.person_add_outlined, size: 20),
                      tooltip: l10n?.findFriends ?? 'Find Friends',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FriendSearchScreen(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, size: 20),
                      tooltip: l10n?.messages ?? 'Messages',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ConversationsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (following.isEmpty)
                  // Improved empty state with CTA
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.paddingMedium,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 40,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n?.noFriendsPrompt ?? 'Find friends to study together!',
                            style: const TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: AppConstants.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.person_add, size: 16),
                            label: Text(l10n?.findFriends ?? 'Find Friends'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppConstants.textPrimary,
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const FriendSearchScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: following.length > 10 ? 10 : following.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final friend = following[index];
                        return InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserProfileScreen(userId: friend.id),
                              ),
                            );
                          },
                          child: SizedBox(
                            width: 60,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: AppConstants.primaryColor
                                      .withValues(alpha: 0.25),
                                  backgroundImage: friend.hasProfileImage
                                      ? NetworkImage(
                                          '${AppConstants.mediaUrl}/images/${friend.profileImageUrl}',
                                        )
                                      : null,
                                  child: friend.hasProfileImage
                                      ? null
                                      : Text(
                                          friend.name.isNotEmpty
                                              ? friend.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  friend.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: AppConstants.fontSizeSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    final user = authProvider.currentUser;
    final l10n = AppLocalizations.of(context);

    return RefreshIndicator(
      color: AppConstants.accentColor,
      onRefresh: _loadStats,
      child: CustomScrollView(
        slivers: [
          // AppBar with My Room + Settings
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            scrolledUnderElevation: 0.5,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              TextButton.icon(
                icon: const Icon(Icons.bedroom_child_outlined, size: 20),
                label: Text(l10n?.myRoom ?? 'My Room'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black87,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyRoomScreen(),
                    ),
                  );
                },
              ),
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

          // Profile Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingLarge),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppConstants.primaryColor.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: AppConstants.primaryColor,
                    child: Text(
                      user?.username.isNotEmpty == true
                          ? user!.username[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Username
                  Text(
                    user?.username ?? (l10n?.user ?? 'User'),
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeXLarge,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  // Streak Badge - NOW TAPPABLE
                  GestureDetector(
                    onTap: () {
                      showStreakDetailSheet(
                        context: context,
                        currentStreak: _streakDays,
                        totalStudyDays: progressProvider.totalStudyDays,
                        progressList: progressProvider.progressList,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(20),
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
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n?.streakDaysCount(_streakDays) ?? '$_streakDays day streak',
                            style: TextStyle(
                              fontSize: AppConstants.fontSizeSmall,
                              color: Colors.orange.shade700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: Colors.orange.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),
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

          // Learning Statistics - 2x2 Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(l10n?.learningStats ?? 'Learning Statistics'),
                  const SizedBox(height: AppConstants.paddingSmall),
                  ProfileStatsGrid(
                    studyDays: progressProvider.totalStudyDays,
                    completedLessons: progressProvider.completedLessons,
                    masteredWords: progressProvider.masteredWords,
                    totalTimeMinutes: progressProvider.totalTimeMinutes,
                  ),
                ],
              ),
            ),
          ),

          // Lemon Tree (compact)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: AppConstants.paddingSmall,
              ),
              child: LemonTreeWidget(),
            ),
          ),

          // Friends Section
          SliverPadding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(l10n?.findFriends ?? 'Friends'),
                _buildFriendsSection(),
                const SizedBox(height: AppConstants.paddingLarge),
              ]),
            ),
          ),
        ],
      ),
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

}
