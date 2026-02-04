import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/bookmark_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/bookmark_provider.dart';
import '../../widgets/convertible_text.dart';
import 'vocabulary_book_review_screen.dart';

/// Vocabulary Book Screen
/// Display and manage all bookmarked vocabulary words
class VocabularyBookScreen extends StatefulWidget {
  const VocabularyBookScreen({super.key});

  @override
  State<VocabularyBookScreen> createState() => _VocabularyBookScreenState();
}

class _VocabularyBookScreenState extends State<VocabularyBookScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  BookmarkSortType _sortType = BookmarkSortType.dateNewest;
  int? _filterMastery;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final provider = context.read<BookmarkProvider>();
    await provider.fetchBookmarks();
    await provider.loadVocabularyData();
  }

  Future<void> _refreshBookmarks() async {
    await context.read<BookmarkProvider>().syncWithServer();
  }

  void _showEditNotesDialog(BookmarkModel bookmark) {
    final controller = TextEditingController(text: bookmark.notes ?? '');
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.editNotes),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.notes,
            hintText: l10n.notesHint,
            border: const OutlineInputBorder(),
          ),
          maxLines: 3,
          maxLength: 200,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BookmarkProvider>().updateNotes(
                    bookmark.id,
                    controller.text.trim(),
                  );
              Navigator.pop(context);
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _showSortOptions() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.sortBy),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(),
            _buildSortOption(
              l10n.sortNewest,
              BookmarkSortType.dateNewest,
              Icons.access_time,
            ),
            _buildSortOption(
              l10n.sortOldest,
              BookmarkSortType.dateOldest,
              Icons.history,
            ),
            _buildSortOption(
              l10n.sortKorean,
              BookmarkSortType.korean,
              Icons.sort_by_alpha,
            ),
            _buildSortOption(
              l10n.sortChinese,
              BookmarkSortType.chinese,
              Icons.translate,
            ),
            _buildSortOption(
              l10n.sortMastery,
              BookmarkSortType.mastery,
              Icons.bar_chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, BookmarkSortType type, IconData icon) {
    final isSelected = _sortType == type;

    return ListTile(
      leading: Icon(icon, color: isSelected ? AppConstants.primaryColor : null),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppConstants.primaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: AppConstants.primaryColor) : null,
      onTap: () {
        setState(() => _sortType = type);
        Navigator.pop(context);
      },
    );
  }

  void _showFilterOptions() {
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.filter),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const Divider(),
            _buildFilterOption(l10n.filterAll, null),
            _buildFilterOption(l10n.filterNew, 0),
            _buildFilterOption(l10n.filterBeginner, 1),
            _buildFilterOption(l10n.filterIntermediate, 2),
            _buildFilterOption(l10n.filterAdvanced, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String label, int? mastery) {
    final isSelected = _filterMastery == mastery;

    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppConstants.primaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : null,
        ),
      ),
      trailing: isSelected ? const Icon(Icons.check, color: AppConstants.primaryColor) : null,
      onTap: () {
        setState(() => _filterMastery = mastery);
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.myVocabularyBook),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterOptions,
            tooltip: l10n.filter,
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: l10n.sort,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchWordsNotesChinese,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Bookmark List
          Expanded(
            child: Consumer<BookmarkProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.errorMessage != null && provider.bookmarks.isEmpty) {
                  return _buildErrorState(provider.errorMessage!);
                }

                // Apply search and filter
                var bookmarks = provider.bookmarks;
                if (_searchQuery.isNotEmpty) {
                  bookmarks = provider.searchBookmarks(_searchQuery);
                }
                if (_filterMastery != null) {
                  bookmarks = bookmarks
                      .where((b) => (b.masteryLevel ?? 0) >= _filterMastery!)
                      .toList();
                }

                // Apply sort
                bookmarks = provider.getSortedBookmarks(_sortType);

                if (bookmarks.isEmpty) {
                  return _searchQuery.isNotEmpty || _filterMastery != null
                      ? _buildNoResultsState()
                      : _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: _refreshBookmarks,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingMedium,
                    ),
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      return _buildBookmarkCard(bookmarks[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Floating Action Button - Start Review
      floatingActionButton: Consumer<BookmarkProvider>(
        builder: (context, provider, child) {
          final dueCount = provider.getDueForReview().length;

          if (dueCount == 0) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VocabularyBookReviewScreen(),
                ),
              ).then((_) {
                // Refresh bookmarks after review session
                provider.fetchBookmarks();
              });
            },
            icon: const Icon(Icons.school),
            label: Text(AppLocalizations.of(context)!.startReviewCount(dueCount)),
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.black87,
          );
        },
      ),
    );
  }

  Widget _buildBookmarkCard(BookmarkModel bookmark) {
    final vocabulary = bookmark.vocabulary;
    if (vocabulary == null) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      elevation: 2,
      child: InkWell(
        onTap: () => _showEditNotesDialog(bookmark),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Word Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Korean
                        Text(
                          vocabulary.korean,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Translation + Pronunciation
                        Row(
                          children: [
                            ConvertibleText(
                              vocabulary.translation,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppConstants.textSecondary,
                              ),
                            ),
                            if (vocabulary.pronunciation != null) ...[
                              const SizedBox(width: 8),
                              Text(
                                vocabulary.pronunciation!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppConstants.textHint,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Mastery Badge
                  if (bookmark.masteryLevel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getMasteryColor(bookmark.masteryLevel!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Lv${bookmark.masteryLevel}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),

              // Notes
              if (bookmark.hasNotes) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.note,
                        size: 16,
                        color: Colors.amber[800],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ConvertibleText(
                          bookmark.notes!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Actions Row
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Text(
                    _formatDate(bookmark.createdAt),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.textHint,
                    ),
                  ),

                  // Actions
                  Row(
                    children: [
                      // Edit Notes
                      TextButton.icon(
                        onPressed: () => _showEditNotesDialog(bookmark),
                        icon: const Icon(Icons.edit, size: 16),
                        label: Text(
                          AppLocalizations.of(context)!.edit,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),

                      // Remove
                      TextButton.icon(
                        onPressed: () async {
                          final bookmarkProvider = context.read<BookmarkProvider>();
                          final confirm = await _showRemoveConfirmation(vocabulary.korean);
                          if (confirm == true && mounted) {
                            bookmarkProvider.removeBookmark(bookmark.id);
                          }
                        },
                        icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                        label: Text(
                          AppLocalizations.of(context)!.remove,
                          style: const TextStyle(fontSize: 12, color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMasteryColor(int level) {
    if (level >= 4) return Colors.green;
    if (level >= 2) return Colors.blue;
    if (level >= 1) return Colors.orange;
    return Colors.grey;
  }

  String _formatDate(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return l10n.today;
    if (diff.inDays == 1) return l10n.yesterday;
    if (diff.inDays < 7) return l10n.daysAgo(diff.inDays);
    if (diff.inDays < 30) return l10n.weeksAgo((diff.inDays / 7).floor());
    return l10n.dateFormat(date.month, date.day);
  }

  Future<bool?> _showRemoveConfirmation(String korean) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmRemove),
        content: Text(l10n.confirmRemoveWord(korean)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.remove),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noBookmarkedWords,
            style: const TextStyle(
              fontSize: 18,
              color: AppConstants.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.bookmarkHint,
            style: const TextStyle(
              fontSize: 14,
              color: AppConstants.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noMatchingWords,
            style: const TextStyle(
              fontSize: 18,
              color: AppConstants.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          ConvertibleText(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppConstants.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadBookmarks,
            child: Text(AppLocalizations.of(context)!.retry),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
