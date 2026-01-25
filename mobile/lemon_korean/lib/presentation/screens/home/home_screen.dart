import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../../../data/models/progress_model.dart';
import '../../../data/models/user_model.dart';
import '../../providers/auth_provider.dart';
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.download_outlined),
            selectedIcon: Icon(Icons.download),
            label: '下载',
          ),
          NavigationDestination(
            icon: Icon(Icons.replay_outlined),
            selectedIcon: Icon(Icons.replay),
            label: '复习',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: '我的',
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
  // Mock data - TODO: Replace with real data from providers
  final List<LessonModel> _lessons = [];
  ProgressModel? _currentProgress;
  int _streakDays = 7;
  double _todayProgress = 0.65;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // TODO: Load real data
    setState(() {
      // Create mock lessons
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
              completedLessons: 2,
              targetLessons: 3,
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
                  const Text(
                    '继续学习',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  ContinueLessonCard(
                    lesson: _lessons.first,
                    progress: _currentProgress!,
                    onTap: () {
                      // Navigate to lesson
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
                const Text(
                  '所有课程',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Show filter
                  },
                  icon: const Icon(Icons.filter_list, size: 20),
                  label: const Text('筛选'),
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
                return LessonGridItem(
                  lesson: lesson,
                  progress: index < 3 ? 0.3 * (index + 1) : null,
                  onTap: () {
                    // Navigate to lesson detail
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
          title: const Text(
            '已下载课程',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.storage_outlined),
              onPressed: () {
                // Show storage info
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
                    title: Text('韩语课程 ${index + 1}'),
                    subtitle: Text('已下载 • 45 MB'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        // Delete download
                      },
                    ),
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
        SliverAppBar(
          pinned: true,
          title: const Text(
            '复习计划',
            style: TextStyle(
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
                    const Text(
                      '今日复习',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingSmall),
                    const Text(
                      '15个单词等待复习',
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    ElevatedButton(
                      onPressed: () {
                        // Start review
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.primaryColor,
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingLarge,
                          vertical: AppConstants.paddingMedium,
                        ),
                      ),
                      child: const Text('开始复习'),
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
                  child: Text(
                    user?.isPremium == true ? '高级会员' : '免费用户',
                    style: TextStyle(
                      color: user?.isPremium == true
                          ? Colors.black87
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
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
              _buildSection('学习统计'),
              _buildStatCard('已完成课程', '12', Icons.check_circle_outline),
              _buildStatCard('学习天数', '45', Icons.calendar_today_outlined),
              _buildStatCard('掌握单词', '230', Icons.translate),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSection('设置'),
              _buildMenuItem(
                icon: Icons.notifications_outlined,
                title: '通知设置',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.language,
                title: '语言设置',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.storage_outlined,
                title: '存储管理',
                onTap: () {},
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              _buildSection('关于'),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: '帮助中心',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: '关于应用',
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
                  title: const Text(
                    '退出登录',
                    style: TextStyle(
                      color: AppConstants.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
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
                      // Navigate to login
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

  Widget _buildStatCard(String label, String value, IconData icon) {
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
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                ),
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
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingSmall),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
