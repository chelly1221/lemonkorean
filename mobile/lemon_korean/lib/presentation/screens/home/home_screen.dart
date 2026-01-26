import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/progress_model.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/lesson_provider.dart';
import '../../providers/progress_provider.dart';
import '../../widgets/bilingual_text.dart';
import '../auth/login_screen.dart';
import '../download/download_manager_screen.dart';
import '../lesson/lesson_screen.dart';
import '../review/review_screen.dart';
import 'widgets/user_header.dart';
import 'widgets/daily_goal_card.dart';
import 'widgets/continue_lesson_card.dart';
import 'widgets/lesson_grid_item.dart';

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
            _DownloadsTab(),
            _ReviewTab(),
            _ProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: '首页',
            tooltip: '홈',
          ),
          NavigationDestination(
            icon: const Icon(Icons.download_outlined),
            selectedIcon: const Icon(Icons.download),
            label: '下载',
            tooltip: '다운로드',
          ),
          NavigationDestination(
            icon: const Icon(Icons.replay_outlined),
            selectedIcon: const Icon(Icons.replay),
            label: '复习',
            tooltip: '복습',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: const Icon(Icons.person),
            label: '我的',
            tooltip: '내 정보',
          ),
        ],
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
  int _streakDays = 0;
  double _todayProgress = 0.0;
  int _completedToday = 0;
  int _targetLessons = 3;

  @override
  void initState() {
    super.initState();
    _loadData();
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
    DateTime previousDate = mostRecentDate;

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

  Future<void> _loadData() async {
    final lessonProvider = Provider.of<LessonProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Fetch lessons
    await lessonProvider.fetchLessons();

    // Fetch progress if user is logged in
    if (authProvider.currentUser != null) {
      await progressProvider.fetchProgress(authProvider.currentUser!.id);

      // Calculate stats
      final progressList = progressProvider.progressList;
      final today = DateTime.now();
      final todayProgress = progressList.where((p) {
        final completedAt = DateTime.parse(p['completed_at'] ?? '');
        return completedAt.year == today.year &&
               completedAt.month == today.month &&
               completedAt.day == today.day;
      }).length;

      // Build lesson progress map
      final lessonProgressMap = <int, double>{};
      for (final progress in progressList) {
        final lessonId = progress['lesson_id'] as int;
        final status = progress['status'] as String?;
        final quizScore = progress['quiz_score'] as int?;

        if (status == 'completed') {
          lessonProgressMap[lessonId] = 1.0;
        } else if (status == 'in_progress') {
          // If quiz score exists, use it as progress indicator (0-100 -> 0.0-1.0)
          if (quizScore != null) {
            lessonProgressMap[lessonId] = (quizScore / 100).clamp(0.0, 0.99);
          } else {
            lessonProgressMap[lessonId] = 0.5; // Default for in-progress
          }
        }
      }

      setState(() {
        _completedToday = todayProgress;
        _todayProgress = todayProgress / _targetLessons;
        _lessonProgress = lessonProgressMap;
        _streakDays = _calculateStreakDays(progressList);
      });
    }

    // Get lessons from provider
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
              titleZh: '韩语课程 $i',
              description: '这是第 $i 课的描述',
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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return CustomScrollView(
      slivers: [
        // User Header
        SliverToBoxAdapter(
          child: UserHeader(
            user: user,
            streakDays: _streakDays,
          ).animate().fadeIn(duration: 400.ms).slideY(
                begin: -0.2,
                end: 0,
                duration: 400.ms,
                curve: Curves.easeOut,
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
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),
          ),
        ),

        // Continue Learning Section
        if (_currentProgress != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BilingualText(
                    chinese: '继续学习',
                    korean: '계속 학습하기',
                    chineseStyle: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
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
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(
                  begin: 0.2,
                  end: 0,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                ),
          ),

        // All Lessons Section
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BilingualText(
                  chinese: '所有课程',
                  korean: '모든 수업',
                  chineseStyle: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
                TextButton.icon(
                  onPressed: () {
                    // Show filter
                  },
                  icon: const Icon(Icons.filter_list, size: 20),
                  label: const InlineBilingualText(
                    chinese: '筛选',
                    korean: '필터',
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
        ),

        // Lessons Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingMedium,
          ),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: AppConstants.paddingMedium,
              mainAxisSpacing: AppConstants.paddingMedium,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lesson = _lessons[index];
                final progress = _lessonProgress[lesson.id];
                return LessonGridItem(
                  lesson: lesson,
                  progress: progress,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LessonScreen(lesson: lesson),
                      ),
                    );
                  },
                )
                    .animate(delay: Duration(milliseconds: 400 + index * 50))
                    .fadeIn(duration: 400.ms)
                    .scale(
                      begin: const Offset(0.8, 0.8),
                      end: const Offset(1, 1),
                      duration: 400.ms,
                      curve: Curves.easeOut,
                    );
              },
              childCount: _lessons.length,
            ),
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
// DOWNLOADS TAB
// ================================================================

class _DownloadsTab extends StatelessWidget {
  const _DownloadsTab();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          title: const BilingualText(
            chinese: '已下载课程',
            korean: '다운로드한 수업',
            chineseStyle: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.storage_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DownloadManagerScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: const EdgeInsets.only(
                    bottom: AppConstants.paddingMedium,
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusSmall,
                        ),
                      ),
                      child: const Icon(Icons.download_done),
                    ),
                    title: BilingualText(
                      chinese: '韩语课程 ${index + 1}',
                      korean: '한국어 수업 ${index + 1}',
                      textAlign: TextAlign.left,
                    ),
                    subtitle: const BilingualText(
                      chinese: '已下载 • 45 MB',
                      korean: '다운로드 완료',
                      textAlign: TextAlign.left,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('删除下载'),
                            content: Text('确定要删除课程 ${index + 1} 吗？'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('取消'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('删除功能开发中'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: AppConstants.errorColor,
                                ),
                                child: const Text('删除'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('从下载中打开课程功能开发中'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                );
              },
              childCount: 3,
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_download_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: AppConstants.paddingMedium),
                Text(
                  '暂无更多下载',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
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
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          pinned: true,
          title: BilingualText(
            chinese: '复习计划',
            korean: '복습 계획',
            chineseStyle: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Card(
              color: AppConstants.primaryColor.withOpacity(0.1),
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
                    const BilingualText(
                      chinese: '今日复习',
                      korean: '오늘의 복습',
                      chineseStyle: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    const BilingualText(
                      chinese: '15个单词等待复习',
                      korean: '15개 단어 복습 대기중',
                      chineseStyle: TextStyle(
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
                      child: const InlineBilingualText(
                        chinese: '开始复习',
                        korean: '복습 시작',
                      ),
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
                final days = ['今天', '明天', '2天后', '3天后'];
                final counts = [15, 8, 12, 5];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: AppConstants.paddingMedium,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppConstants.primaryColor.withOpacity(0.2),
                      child: Text(
                        '${counts[index]}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(days[index]),
                    subtitle: Text('${counts[index]}个单词'),
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

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppConstants.primaryColor.withOpacity(0.3),
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
                  user?.username ?? '用户',
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
                  child: InlineBilingualText(
                    chinese: user?.isPremium == true ? '高级会员' : '免费用户',
                    korean: user?.isPremium == true ? '프리미엄 회원' : '무료 사용자',
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
        SliverPadding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _buildSection('学习统计', '학습 통계'),
              _buildStatCard('已完成课程', '완료한 수업', '12', Icons.check_circle_outline),
              _buildStatCard('学习天数', '학습 일수', '45', Icons.calendar_today_outlined),
              _buildStatCard('掌握单词', '습득 단어', '230', Icons.translate),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSection('设置', '설정'),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                chinese: '通知设置',
                korean: '알림 설정',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.language,
                chinese: '语言设置',
                korean: '언어 설정',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.storage_outlined,
                chinese: '存储管理',
                korean: '저장공간 관리',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DownloadManagerScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSection('关于', '정보'),
              _buildMenuItem(
                icon: Icons.help_outline,
                chinese: '帮助中心',
                korean: '도움말 센터',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                chinese: '关于应用',
                korean: '앱 정보',
                onTap: () {},
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Card(
                color: AppConstants.errorColor.withOpacity(0.1),
                child: ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: AppConstants.errorColor,
                  ),
                  title: const BilingualText(
                    chinese: '退出登录',
                    korean: '로그아웃',
                    chineseStyle: TextStyle(
                      color: AppConstants.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('确认退出'),
                        content: const Text('确定要退出登录吗？'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('取消'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: TextButton.styleFrom(
                              foregroundColor: AppConstants.errorColor,
                            ),
                            child: const Text('确定'),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true && context.mounted) {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  },
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String chinese, String korean) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppConstants.paddingMedium,
        bottom: AppConstants.paddingSmall,
      ),
      child: BilingualText(
        chinese: chinese,
        korean: korean,
        chineseStyle: const TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          fontWeight: FontWeight.bold,
          color: AppConstants.textSecondary,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildStatCard(String chinese, String korean, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              ),
              child: Icon(icon, color: AppConstants.primaryColor),
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: BilingualText(
                chinese: chinese,
                korean: korean,
                chineseStyle: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeXLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String chinese,
    required String korean,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: ListTile(
        leading: Icon(icon),
        title: BilingualText(
          chinese: chinese,
          korean: korean,
          textAlign: TextAlign.left,
        ),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
