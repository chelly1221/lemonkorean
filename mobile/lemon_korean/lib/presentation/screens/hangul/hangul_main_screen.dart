import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hangul_provider.dart';
import 'hangul_table_screen.dart';
import 'hangul_lesson_screen.dart';
import 'hangul_practice_screen.dart';

/// Hangul Main Screen
/// Entry point for Korean alphabet learning with tabs for Table/Learn/Practice
class HangulMainScreen extends StatefulWidget {
  final int initialTabIndex;

  const HangulMainScreen({
    this.initialTabIndex = 0,
    super.key,
  });

  @override
  State<HangulMainScreen> createState() => _HangulMainScreenState();
}

class _HangulMainScreenState extends State<HangulMainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );

    // Load data on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final hangulProvider = Provider.of<HangulProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Load alphabet table
    await hangulProvider.loadAlphabetTable();

    // Load user progress if logged in
    if (authProvider.currentUser != null) {
      await hangulProvider.loadProgress(authProvider.currentUser!.id);
    }
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('한글 ', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(l10n.hangulAlphabet),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: const Icon(Icons.grid_view),
              text: l10n.alphabetTable,
            ),
            Tab(
              icon: const Icon(Icons.school),
              text: l10n.learn,
            ),
            Tab(
              icon: const Icon(Icons.quiz),
              text: l10n.practice,
            ),
          ],
          labelColor: AppConstants.textPrimary,
          unselectedLabelColor: AppConstants.textSecondary,
          indicatorColor: AppConstants.primaryColor,
          indicatorWeight: 3,
        ),
        actions: [
          // Progress overview button
          Consumer<HangulProvider>(
            builder: (context, provider, child) {
              final progress = provider.overallProgress;
              return IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.analytics),
                    if (progress > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${(progress * 100).toInt()}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () => _showProgressDialog(),
                tooltip: l10n.learningProgress,
              );
            },
          ),
        ],
      ),
      body: Consumer<HangulProvider>(
        builder: (context, provider, child) {
          return TabBarView(
            controller: _tabController,
            children: const [
              HangulTableScreen(),
              HangulLessonScreen(),
              HangulPracticeScreen(),
            ],
          );
        },
      ),
      // FAB for review if items are due
      floatingActionButton: Consumer<HangulProvider>(
        builder: (context, provider, child) {
          final dueCount = provider.dueForReviewCount;

          if (dueCount == 0 || _tabController.index == 2) {
            return const SizedBox.shrink();
          }

          return FloatingActionButton.extended(
            onPressed: () {
              _tabController.animateTo(2); // Go to practice tab
            },
            icon: const Icon(Icons.notifications_active),
            label: Text(l10n.dueForReviewCount(dueCount)),
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          );
        },
      ),
    );
  }

  void _showProgressDialog() {
    final provider = Provider.of<HangulProvider>(context, listen: false);
    final stats = provider.stats;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.learningProgress),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Progress circle
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: provider.overallProgress,
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppConstants.primaryColor,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${(provider.overallProgress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        l10n.completion,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  l10n.totalCharacters,
                  '${stats?.totalCharacters ?? 40}',
                  Colors.grey,
                ),
                _buildStatColumn(
                  l10n.learned,
                  '${stats?.charactersLearned ?? 0}',
                  Colors.blue,
                ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  l10n.mastered,
                  '${stats?.charactersMastered ?? 0}',
                  Colors.green,
                ),
                _buildStatColumn(
                  l10n.dueForReview,
                  '${stats?.dueForReview ?? 0}',
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Accuracy
            if (stats != null && (stats.totalCorrect + stats.totalWrong) > 0)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.trending_up, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      l10n.overallAccuracy(stats.accuracyPercent.toStringAsFixed(1)),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
