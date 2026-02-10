import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/dm_provider.dart';
import '../../providers/feed_provider.dart';
import '../create_post/create_post_screen.dart';
import '../dm/conversations_screen.dart';
import '../friend_search/friend_search_screen.dart';
import '../voice_rooms/voice_rooms_list_screen.dart';
import 'widgets/category_filter_chips.dart';
import 'widgets/post_card.dart';

/// Main community screen with Following and Discover tabs
/// Displays a feed of posts with pull-to-refresh and infinite scroll
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.loadFeed(refresh: true);
      feedProvider.loadDiscover(refresh: true);

      // Load DM unread count for badge
      Provider.of<DmProvider>(context, listen: false).refreshUnreadCount();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n?.community ?? 'Community',
          style: const TextStyle(
            fontSize: AppConstants.fontSizeXLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: AppConstants.textPrimary,
        elevation: 0,
        actions: [
          // DM messages icon with unread badge
          Consumer<DmProvider>(
            builder: (context, dmProvider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.mail_outline),
                    tooltip: l10n?.messages ?? 'Messages',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConversationsScreen(),
                        ),
                      );
                    },
                  ),
                  if (dmProvider.totalUnreadCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(minWidth: 16),
                        child: Text(
                          dmProvider.totalUnreadCount > 99
                              ? '99+'
                              : '${dmProvider.totalUnreadCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          // Voice rooms
          IconButton(
            icon: const Icon(Icons.mic_outlined),
            tooltip: l10n?.voiceRooms ?? 'Voice Rooms',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VoiceRoomsListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.person_search_outlined),
            tooltip: l10n?.findFriends ?? 'Find Friends',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FriendSearchScreen(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppConstants.textPrimary,
          unselectedLabelColor: AppConstants.textSecondary,
          indicatorColor: AppConstants.primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
          ),
          tabs: [
            Tab(text: l10n?.following ?? 'Following'),
            Tab(text: l10n?.discover ?? 'Discover'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _FollowingTab(),
          _DiscoverTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
          if (result == true && mounted) {
            final feedProvider =
                Provider.of<FeedProvider>(context, listen: false);
            feedProvider.loadFeed(refresh: true);
            feedProvider.loadDiscover(refresh: true);
          }
        },
        backgroundColor: AppConstants.primaryColor,
        child: const Icon(Icons.edit, color: Colors.black87),
      ).animate().scale(
            delay: 300.ms,
            duration: 300.ms,
            curve: Curves.elasticOut,
          ),
    );
  }
}

// ================================================================
// FOLLOWING TAB
// ================================================================

class _FollowingTab extends StatefulWidget {
  const _FollowingTab();

  @override
  State<_FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<_FollowingTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.loadMoreFeed();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);

    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        final posts = feedProvider.feedPosts;

        if (feedProvider.isLoadingFeed && posts.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppConstants.primaryColor,
              ),
            ),
          );
        }

        if (posts.isEmpty) {
          return _buildEmptyState(
            l10n,
            icon: Icons.people_outline,
            message: l10n?.noFollowingPosts ??
                'Follow other learners to see their posts here',
          );
        }

        return RefreshIndicator(
          color: AppConstants.primaryColor,
          onRefresh: () => feedProvider.loadFeed(refresh: true),
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(
              top: AppConstants.paddingSmall,
              bottom: 80,
            ),
            itemCount: posts.length + (feedProvider.hasMoreFeed ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= posts.length) {
                return const Padding(
                  padding: EdgeInsets.all(AppConstants.paddingMedium),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppConstants.primaryColor,
                      ),
                      strokeWidth: 2,
                    ),
                  ),
                );
              }
              return PostCard(post: posts[index], index: index);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(
    AppLocalizations? l10n, {
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: AppConstants.paddingMedium),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeNormal,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: AppConstants.paddingLarge),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FriendSearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add_outlined),
              label: Text(l10n?.findFriends ?? 'Find Friends'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppConstants.textPrimary,
                side: const BorderSide(color: AppConstants.primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingLarge,
                  vertical: AppConstants.paddingSmall,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ================================================================
// DISCOVER TAB
// ================================================================

class _DiscoverTab extends StatefulWidget {
  const _DiscoverTab();

  @override
  State<_DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<_DiscoverTab>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'all';

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final feedProvider = Provider.of<FeedProvider>(context, listen: false);
      feedProvider.loadMoreDiscover();
    }
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
    });
    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    feedProvider.loadDiscover(
      refresh: true,
      category: category == 'all' ? null : category,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context);

    return Consumer<FeedProvider>(
      builder: (context, feedProvider, child) {
        final posts = feedProvider.discoverPosts;

        return Column(
          children: [
            // Category filter chips
            CategoryFilterChips(
              selectedCategory: _selectedCategory,
              onCategoryChanged: _onCategoryChanged,
            ),

            // Posts list
            Expanded(
              child: feedProvider.isLoadingDiscover && posts.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppConstants.primaryColor,
                        ),
                      ),
                    )
                  : posts.isEmpty
                      ? Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(AppConstants.paddingXLarge),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.explore_outlined,
                                  size: 64,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(
                                    height: AppConstants.paddingMedium),
                                Text(
                                  l10n?.noPostsYet ?? 'No posts yet',
                                  style: TextStyle(
                                    fontSize: AppConstants.fontSizeNormal,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms)
                      : RefreshIndicator(
                          color: AppConstants.primaryColor,
                          onRefresh: () => feedProvider.loadDiscover(
                            refresh: true,
                            category: _selectedCategory == 'all'
                                ? null
                                : _selectedCategory,
                          ),
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.only(
                              top: AppConstants.paddingSmall,
                              bottom: 80,
                            ),
                            itemCount: posts.length +
                                (feedProvider.hasMoreDiscover ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index >= posts.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(
                                      AppConstants.paddingMedium),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(
                                        AppConstants.primaryColor,
                                      ),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              }
                              return PostCard(
                                  post: posts[index], index: index);
                            },
                          ),
                        ),
            ),
          ],
        );
      },
    );
  }
}
