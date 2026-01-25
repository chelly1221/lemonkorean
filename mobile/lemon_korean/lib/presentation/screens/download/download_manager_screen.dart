import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../../providers/download_provider.dart';

class DownloadManagerScreen extends StatefulWidget {
  const DownloadManagerScreen({super.key});

  @override
  State<DownloadManagerScreen> createState() => _DownloadManagerScreenState();
}

class _DownloadManagerScreenState extends State<DownloadManagerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize download provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DownloadProvider>(context, listen: false);
      provider.init();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '下载管理',
          style: TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_outlined),
            onPressed: _showStorageInfo,
            tooltip: '存储信息',
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _showDeleteAllDialog,
            tooltip: '清空下载',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '已下载', icon: Icon(Icons.download_done)),
            Tab(text: '可下载', icon: Icon(Icons.cloud_download_outlined)),
          ],
        ),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Active Downloads Section
              if (provider.activeDownloads.isNotEmpty)
                _ActiveDownloadsSection(
                  activeDownloads: provider.activeDownloads,
                  onCancel: provider.cancelDownload,
                ),

              // Storage Info Bar
              _StorageInfoBar(stats: provider.storageStats),

              // Tab Views
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _DownloadedTab(
                      lessons: provider.downloadedLessons,
                      onDelete: provider.deleteLesson,
                    ),
                    _AvailableTab(
                      lessons: provider.availableLessons,
                      onDownload: provider.downloadLesson,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showStorageInfo() {
    final provider = Provider.of<DownloadProvider>(context, listen: false);
    final stats = provider.storageStats;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('存储信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('已下载课程', '${stats?.downloadedLessons ?? 0}'),
            _buildInfoRow('媒体文件数', '${stats?.mediaFileCount ?? 0}'),
            _buildInfoRow(
              '使用空间',
              '${stats?.mediaStorageMB.toStringAsFixed(1) ?? 0} MB',
            ),
            _buildInfoRow(
              '缓存空间',
              '${stats?.cacheStorageMB.toStringAsFixed(1) ?? 0} MB',
            ),
            _buildInfoRow(
              '总计',
              '${stats?.totalStorageMB.toStringAsFixed(1) ?? 0} MB',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog() {
    final provider = Provider.of<DownloadProvider>(context, listen: false);

    if (provider.downloadedLessons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('暂无已下载课程')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清空下载'),
        content: Text('确定要删除所有 ${provider.downloadedLessons.length} 个已下载课程吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.deleteAllDownloads();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('已清空所有下载')),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.errorColor,
            ),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// ACTIVE DOWNLOADS SECTION
// ================================================================

class _ActiveDownloadsSection extends StatelessWidget {
  final Map<int, dynamic> activeDownloads;
  final Function(int) onCancel;

  const _ActiveDownloadsSection({
    required this.activeDownloads,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.primaryColor.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Row(
              children: [
                const Icon(
                  Icons.downloading,
                  color: AppConstants.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '下载中 (${activeDownloads.length})',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...activeDownloads.entries.map((entry) {
            final lessonId = entry.key;
            final progress = entry.value;

            return _DownloadingItem(
              lessonId: lessonId,
              progress: progress,
              onCancel: () => onCancel(lessonId),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class _DownloadingItem extends StatelessWidget {
  final int lessonId;
  final dynamic progress;
  final VoidCallback onCancel;

  const _DownloadingItem({
    required this.lessonId,
    required this.progress,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = progress?.percentage ?? 0.0;
    final message = progress?.message ?? '准备中...';

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '课程 $lessonId',
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onCancel,
                  tooltip: '取消',
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: AppConstants.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// STORAGE INFO BAR
// ================================================================

class _StorageInfoBar extends StatelessWidget {
  final dynamic stats;

  const _StorageInfoBar({this.stats});

  @override
  Widget build(BuildContext context) {
    final usedMB = stats?.mediaStorageMB ?? 0.0;
    final totalMB = 500.0; // Max storage
    final percentage = (usedMB / totalMB).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '存储空间',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: AppConstants.textSecondary,
                ),
              ),
              Text(
                '${usedMB.toStringAsFixed(1)} / ${totalMB.toStringAsFixed(0)} MB',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 0.8 ? Colors.red : AppConstants.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// DOWNLOADED TAB
// ================================================================

class _DownloadedTab extends StatelessWidget {
  final List<LessonModel> lessons;
  final Function(LessonModel) onDelete;

  const _DownloadedTab({
    required this.lessons,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return Center(
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
              '暂无已下载课程',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              '切换到"可下载"标签开始下载',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final provider = Provider.of<DownloadProvider>(
          context,
          listen: false,
        );
        await provider.loadData();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return _DownloadedLessonCard(
            lesson: lesson,
            onDelete: () => _showDeleteDialog(context, lesson),
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, LessonModel lesson) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('删除下载'),
        content: Text('确定要删除"${lesson.titleZh}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(lesson);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.errorColor,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }
}

class _DownloadedLessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onDelete;

  const _DownloadedLessonCard({
    required this.lesson,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Center(
            child: Text(
              '${lesson.level}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
          ),
        ),
        title: Text(
          lesson.titleZh,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.check_circle, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            const Text('已下载'),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 14),
            const SizedBox(width: 4),
            Text(lesson.estimatedTime),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: AppConstants.errorColor,
          ),
          onPressed: onDelete,
        ),
        onTap: () {
          // Navigate to lesson
        },
      ),
    );
  }
}

// ================================================================
// AVAILABLE TAB
// ================================================================

class _AvailableTab extends StatelessWidget {
  final List<LessonModel> lessons;
  final Function(LessonModel) onDownload;

  const _AvailableTab({
    required this.lessons,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download_done_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              '所有课程已下载',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final provider = Provider.of<DownloadProvider>(
          context,
          listen: false,
        );
        await provider.loadData();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return _AvailableLessonCard(
            lesson: lesson,
            onDownload: () => onDownload(lesson),
          );
        },
      ),
    );
  }
}

class _AvailableLessonCard extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback onDownload;

  const _AvailableLessonCard({
    required this.lesson,
    required this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
          ),
          child: Center(
            child: Text(
              '${lesson.level}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
        title: Text(
          lesson.titleZh,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 14),
            const SizedBox(width: 4),
            Text(lesson.estimatedTime),
            const SizedBox(width: 16),
            const Icon(Icons.translate, size: 14),
            const SizedBox(width: 4),
            Text('${lesson.vocabularyCount} 词'),
          ],
        ),
        trailing: ElevatedButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download, size: 18),
          label: const Text('下载'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
          ),
        ),
      ),
    );
  }
}
