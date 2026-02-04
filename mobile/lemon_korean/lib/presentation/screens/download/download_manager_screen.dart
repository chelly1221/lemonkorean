import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/lesson_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/download_provider.dart';
import '../../providers/settings_provider.dart';

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
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      provider.init(language: settingsProvider.contentLanguageCode);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.downloadManager,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.storage_outlined),
            onPressed: _showStorageInfo,
            tooltip: l10n.storageInfo,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_outlined),
            onPressed: _showDeleteAllDialog,
            tooltip: l10n.clearAllDownloads,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: l10n.downloadedTab,
              icon: const Icon(Icons.download_done),
            ),
            Tab(
              text: l10n.availableTab,
              icon: const Icon(Icons.cloud_download_outlined),
            ),
          ],
        ),
      ),
      body: Consumer<DownloadProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
          final language = settingsProvider.contentLanguageCode;

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
                      onDownload: (lesson) => provider.downloadLesson(lesson, language: language),
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
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.storageInfo),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(l10n.downloadedLessons, '${stats?.downloadedLessons ?? 0}'),
            _buildInfoRow(l10n.mediaFiles, '${stats?.mediaFileCount ?? 0}'),
            _buildInfoRow(
              l10n.usedStorage,
              '${stats?.mediaStorageMB.toStringAsFixed(1) ?? 0} MB',
            ),
            _buildInfoRow(
              l10n.cacheStorage,
              '${stats?.cacheStorageMB.toStringAsFixed(1) ?? 0} MB',
            ),
            _buildInfoRow(
              l10n.totalStorage,
              '${stats?.totalStorageMB.toStringAsFixed(1) ?? 0} MB',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.confirm),
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
    final l10n = AppLocalizations.of(context)!;

    if (provider.downloadedLessons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noDownloadedLessons)),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllDownloads),
        content: Text(l10n.confirmClearAllDownloads(provider.downloadedLessons.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await provider.deleteAllDownloads();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.allDownloadsCleared)),
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.errorColor,
            ),
            child: Text(l10n.confirm),
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
    final l10n = AppLocalizations.of(context)!;

    return Container(
      color: AppConstants.primaryColor.withValues(alpha: 0.1),
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
                  l10n.downloadingCount(activeDownloads.length),
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
          }),
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
    final l10n = AppLocalizations.of(context)!;
    final percentage = progress?.percentage ?? 0.0;
    final message = progress?.message ?? l10n.preparing;

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
                    l10n.lessonId(lessonId),
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
                  tooltip: l10n.cancel,
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
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<DownloadProvider>();
    final usedMB = stats?.mediaStorageMB ?? 0.0;
    final availableGB = provider.availableStorageBytes / (1024 * 1024 * 1024);
    final totalGB = provider.totalStorageBytes / (1024 * 1024 * 1024);
    final percentage = totalGB > 0 ? ((usedMB / 1024) / totalGB).clamp(0.0, 1.0) : 0.0;

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
          // Header
          Text(
            l10n.storageInfo,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: AppConstants.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Used storage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.usedStorage,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall - 1,
                  color: AppConstants.textSecondary,
                ),
              ),
              Text(
                '${usedMB.toStringAsFixed(1)} MB',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Available storage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.availableStorage,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall - 1,
                  color: AppConstants.textSecondary,
                ),
              ),
              Text(
                '${availableGB.toStringAsFixed(2)} GB',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Total storage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalStorage,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall - 1,
                  color: AppConstants.textSecondary,
                ),
              ),
              Text(
                '${totalGB.toStringAsFixed(2)} GB',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
    final l10n = AppLocalizations.of(context)!;

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
              l10n.noDownloadedLessons,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              l10n.goToAvailableTab,
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
        final settingsProvider = Provider.of<SettingsProvider>(
          context,
          listen: false,
        );
        await provider.loadData(language: settingsProvider.contentLanguageCode);
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
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteDownload),
        content: Text(l10n.confirmDeleteDownload(lesson.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete(lesson);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppConstants.errorColor,
            ),
            child: Text(l10n.delete),
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
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withValues(alpha: 0.2),
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
          lesson.title,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.check_circle, size: 14, color: Colors.green),
            const SizedBox(width: 4),
            Text(l10n.downloaded),
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
    final l10n = AppLocalizations.of(context)!;

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
              l10n.allLessonsDownloaded,
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
        final settingsProvider = Provider.of<SettingsProvider>(
          context,
          listen: false,
        );
        await provider.loadData(language: settingsProvider.contentLanguageCode);
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
    final l10n = AppLocalizations.of(context)!;

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
          lesson.title,
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
            Text(l10n.wordCount(lesson.vocabularyCount ?? 0)),
          ],
        ),
        trailing: ElevatedButton.icon(
          onPressed: onDownload,
          icon: const Icon(Icons.download, size: 18),
          label: Text(
            l10n.download,
            style: const TextStyle(fontSize: 12),
          ),
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
