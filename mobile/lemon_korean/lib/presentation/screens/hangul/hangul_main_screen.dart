import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hangul_provider.dart';
import 'hangul_table_screen.dart';
import 'hangul_lesson_screen.dart';
import 'hangul_practice_screen.dart';
import 'hangul_discrimination_screen.dart';
import 'hangul_syllable_screen.dart';
import 'hangul_batchim_screen.dart';
import 'hangul_shadowing_screen.dart';
import 'widgets/writing_canvas.dart';

/// Hangul Main Screen
/// Entry point for Korean alphabet learning with tabs for Table/Learn/Practice/Activities
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
      length: 4,
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
          isScrollable: true,
          tabAlignment: TabAlignment.start,
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
            Tab(
              icon: const Icon(Icons.sports_esports),
              text: l10n.activities,
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
            children: [
              const HangulTableScreen(),
              const HangulLessonScreen(),
              const HangulPracticeScreen(),
              _buildActivitiesTab(),
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

  void _navigateToFeature(String feature) {
    switch (feature) {
      case 'discrimination':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HangulDiscriminationScreen(),
          ),
        );
        break;
      case 'syllable':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HangulSyllableScreen(),
          ),
        );
        break;
      case 'batchim':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HangulBatchimScreen(),
          ),
        );
        break;
      case 'writing':
        // Show character selection dialog with smart state handling
        _showWritingCharacterDialog();
        break;
      case 'shadowing':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HangulShadowingScreen(),
          ),
        );
        break;
    }
  }

  void _showWritingCharacterDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Consumer<HangulProvider>(
        builder: (context, provider, child) {
          // Determine dialog content based on loading state
          Widget dialogContent;
          List<Widget> dialogActions;

          if (provider.isLoading) {
            // Loading state
            dialogContent = SizedBox(
              width: double.maxFinite,
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      l10n.loading,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
            dialogActions = [];
          } else if (provider.loadingState == HangulLoadingState.error) {
            // Error state
            dialogContent = SizedBox(
              width: double.maxFinite,
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      provider.errorMessage ?? l10n.errorOccurred,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
            dialogActions = [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  await provider.loadAlphabetTable();
                },
                child: Text(l10n.retry),
              ),
            ];
          } else if (provider.allCharacters.isEmpty) {
            // Empty state
            dialogContent = SizedBox(
              width: double.maxFinite,
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.folder_open,
                      size: 48,
                      color: AppConstants.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noCharactersAvailable,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
            dialogActions = [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  await provider.loadAlphabetTable();
                },
                child: Text(l10n.reload),
              ),
            ];
          } else {
            // Loaded state - show character grid
            final characters = provider.allCharacters;
            dialogContent = SizedBox(
              width: double.maxFinite,
              height: 300,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final char = characters[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(dialogContext);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HangulWritingScreen(
                            character: char.character,
                            guideImageUrl: char.strokeOrderUrl,
                          ),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text(
                          char.character,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
            dialogActions = [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(l10n.cancel),
              ),
            ];
          }

          return AlertDialog(
            title: Text(l10n.writingPractice),
            content: dialogContent,
            actions: dialogActions,
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

  Widget _buildActivitiesTab() {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section: Listening & Speaking
          _buildSectionHeader(
            icon: Icons.hearing,
            title: l10n.listeningAndSpeaking,
            color: Colors.blue,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.hearing,
                  title: l10n.soundDiscrimination,
                  subtitle: l10n.soundDiscriminationDesc,
                  color: Colors.blue,
                  onTap: () => _navigateToFeature('discrimination'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.record_voice_over,
                  title: l10n.shadowingMode,
                  subtitle: kIsWeb ? l10n.webNotSupported : l10n.shadowingDesc,
                  color: kIsWeb ? Colors.grey : Colors.purple,
                  onTap: kIsWeb ? null : () => _navigateToFeature('shadowing'),
                  disabled: kIsWeb,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Section: Reading & Writing
          _buildSectionHeader(
            icon: Icons.edit_note,
            title: l10n.readingAndWriting,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.extension,
                  title: l10n.syllableCombination,
                  subtitle: l10n.syllableCombinationDesc,
                  color: Colors.green,
                  onTap: () => _navigateToFeature('syllable'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActivityCard(
                  icon: Icons.abc,
                  title: l10n.batchimPractice,
                  subtitle: l10n.batchimPracticeDesc,
                  color: Colors.teal,
                  onTap: () => _navigateToFeature('batchim'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildActivityCard(
            icon: Icons.edit,
            title: l10n.writingPractice,
            subtitle: l10n.writingPracticeDesc,
            color: Colors.orange,
            onTap: () => _navigateToFeature('writing'),
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
    bool fullWidth = false,
    bool disabled = false,
  }) {
    return Card(
      elevation: disabled ? 0 : 2,
      color: disabled ? Colors.grey.shade100 : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            minHeight: fullWidth ? 80 : 140,
          ),
          child: fullWidth
              ? Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: disabled ? Colors.grey : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: disabled
                                  ? Colors.grey
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: disabled ? Colors.grey.shade300 : Colors.grey,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(icon, color: color, size: 24),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: disabled ? Colors.grey : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              disabled ? Colors.grey : Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
