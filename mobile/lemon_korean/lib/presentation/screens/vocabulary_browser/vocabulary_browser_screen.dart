import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/vocabulary_browser_provider.dart';
import '../../widgets/vocabulary_card.dart';

class VocabularyBrowserScreen extends StatefulWidget {
  const VocabularyBrowserScreen({Key? key}) : super(key: key);

  @override
  State<VocabularyBrowserScreen> createState() => _VocabularyBrowserScreenState();
}

class _VocabularyBrowserScreenState extends State<VocabularyBrowserScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Load initial level
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VocabularyBrowserProvider>(context, listen: false);
      provider.loadVocabularyForLevel(1);
    });
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final level = _tabController.index + 1;
      final provider = Provider.of<VocabularyBrowserProvider>(context, listen: false);
      provider.loadVocabularyForLevel(level);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('단어 브라우저'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: List.generate(6, (index) {
            final level = index + 1;
            return Tab(text: 'Level $level');
          }),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),

          // Sort button
          _buildSortButton(),

          // Word list
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(6, (index) {
                final level = index + 1;
                return _buildWordList(level);
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: '단어 검색 (한국어/뜻)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    Provider.of<VocabularyBrowserProvider>(context, listen: false)
                        .clearSearch();
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onChanged: (query) {
          Provider.of<VocabularyBrowserProvider>(context, listen: false)
              .setSearchQuery(query);
        },
      ),
    );
  }

  Widget _buildSortButton() {
    return Consumer<VocabularyBrowserProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${provider.currentWordCount} 단어',
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextButton.icon(
                icon: const Icon(Icons.sort),
                label: Text(_getSortLabel(provider.sortType)),
                onPressed: () => _showSortModal(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWordList(int level) {
    return Consumer<VocabularyBrowserProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(provider.errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => provider.refreshCurrentLevel(),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          );
        }

        final words = provider.currentVocabulary;
        if (words.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  provider.searchQuery.isEmpty
                      ? '이 레벨에 단어가 없습니다'
                      : '일치하는 단어가 없습니다',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => provider.refreshCurrentLevel(),
          child: ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              return VocabularyCard(
                vocabulary: word,
                onTap: () {
                  // Optional: Navigate to word detail screen
                },
              );
            },
          ),
        );
      },
    );
  }

  String _getSortLabel(VocabSortType type) {
    switch (type) {
      case VocabSortType.level:
        return '레벨순';
      case VocabSortType.alphabetical:
        return '알파벳순';
      case VocabSortType.similarity:
        return '유사도순';
    }
  }

  void _showSortModal(BuildContext context) {
    final provider = Provider.of<VocabularyBrowserProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.sort_by_alpha),
                title: const Text('알파벳순'),
                trailing: provider.sortType == VocabSortType.alphabetical
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  provider.setSortType(VocabSortType.alphabetical);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.filter_list),
                title: const Text('레벨순'),
                trailing: provider.sortType == VocabSortType.level
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  provider.setSortType(VocabSortType.level);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.star),
                title: const Text('유사도순'),
                trailing: provider.sortType == VocabSortType.similarity
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  provider.setSortType(VocabSortType.similarity);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
