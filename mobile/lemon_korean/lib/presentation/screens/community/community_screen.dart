import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/dm_provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/social_provider.dart';
import '../../providers/voice_room_provider.dart';
import '../create_post/create_post_screen.dart';
import '../friend_search/friend_search_screen.dart';
import '../voice_rooms/voice_rooms_list_screen.dart';
import 'widgets/category_filter_chips.dart';
import 'widgets/post_card.dart';

/// Main community screen with Following and Discover tabs.
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  _CommunitySection _selectedSection = _CommunitySection.posts;

  // FAB visibility state
  bool _isFabVisible = true;
  final ValueNotifier<bool> _fabVisibleNotifier = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    // Default to Discover tab (index 1) for new users; we switch to Following
    // only if there are followed posts already loaded.
    _tabController = TabController(length: 2, initialIndex: 1, vsync: this);

    _fabVisibleNotifier.addListener(() {
      if (_isFabVisible != _fabVisibleNotifier.value) {
        setState(() => _isFabVisible = _fabVisibleNotifier.value);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final feedProvider = context.read<FeedProvider>();
      feedProvider.loadFeed(refresh: true).then((_) {
        if (!mounted) return;
        // If user has following posts, switch to Following tab
        if (feedProvider.feedPosts.isNotEmpty) {
          _tabController.animateTo(0);
        }
      });
      feedProvider.loadDiscover(refresh: true);
      context.read<DmProvider>().refreshUnreadCount();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabVisibleNotifier.dispose();
    super.dispose();
  }

  Future<void> _openCreatePost() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );
    if (result != true || !mounted) return;
    final feedProvider = context.read<FeedProvider>();
    feedProvider.loadFeed(refresh: true);
    feedProvider.loadDiscover(refresh: true);
  }

  void _openVoiceRooms() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VoiceRoomsListScreen(),
      ),
    );
  }

  Widget _buildPostsSection(AppLocalizations? l10n) {
    return Column(
      children: [
        Consumer<FeedProvider>(
          builder: (context, _, __) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: IntrinsicWidth(
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 3),
                  indicator: BoxDecoration(
                    color: const Color(0xFFF3F5F8),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFE4E8EE)),
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: AppConstants.textPrimary,
                  unselectedLabelColor: AppConstants.textSecondary,
                  labelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  splashBorderRadius: BorderRadius.circular(999),
                  tabs: [
                    _TabLabel(text: l10n?.following ?? 'Following'),
                    _TabLabel(text: l10n?.discover ?? 'Discover'),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _FollowingTab(fabVisibleNotifier: _fabVisibleNotifier),
              _DiscoverTab(fabVisibleNotifier: _fabVisibleNotifier),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: _CommunitySectionPills(
                selectedSection: _selectedSection,
                onChanged: (section) =>
                    setState(() => _selectedSection = section),
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: switch (_selectedSection) {
                  _CommunitySection.posts => KeyedSubtree(
                      key: const ValueKey('posts'),
                      child: _buildPostsSection(l10n),
                    ),
                  _CommunitySection.voiceRooms => _VoiceRoomsSection(
                      key: const ValueKey('voice'),
                      onOpenVoiceRooms: _openVoiceRooms,
                    ),
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _selectedSection == _CommunitySection.posts
          ? AnimatedSlide(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              offset: _isFabVisible ? Offset.zero : const Offset(0, 2),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                scale: _isFabVisible ? 1.0 : 0.0,
                child: FloatingActionButton.extended(
                  onPressed: _openCreatePost,
                  backgroundColor: AppConstants.primaryColor,
                  icon:
                      const Icon(Icons.edit_outlined, color: Colors.black87),
                  label: Text(
                    l10n?.writePost ?? 'Write',
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _TabLabel extends StatelessWidget {
  final String text;

  const _TabLabel({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Tab(
      height: 34,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(text)],
      ),
    );
  }
}

enum _CommunitySection { posts, voiceRooms }

class _CommunitySectionPills extends StatelessWidget {
  final _CommunitySection selectedSection;
  final ValueChanged<_CommunitySection> onChanged;

  const _CommunitySectionPills({
    required this.selectedSection,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = <(_CommunitySection, IconData, String)>[
      (
        _CommunitySection.posts,
        Icons.article_outlined,
        l10n?.posts ?? 'Posts',
      ),
      (
        _CommunitySection.voiceRooms,
        Icons.mic_none_rounded,
        l10n?.voiceRooms ?? 'Voice Rooms',
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: items.map((item) {
          final section = item.$1;
          final icon = item.$2;
          final label = item.$3;
          final selected = section == selectedSection;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(section),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: selected
                      ? const [
                          BoxShadow(
                            color: Color(0x10000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: selected
                          ? AppConstants.textPrimary
                          : AppConstants.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w600,
                        color: selected
                            ? AppConstants.textPrimary
                            : AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _VoiceRoomsSection extends StatelessWidget {
  final VoidCallback onOpenVoiceRooms;

  const _VoiceRoomsSection({
    required this.onOpenVoiceRooms,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        _SectionInfoCard(
          icon: Icons.mic_none_rounded,
          title: l10n?.voiceRooms ?? 'Voice Rooms',
          subtitle: l10n?.voiceRooms ?? 'Practice speaking with real-time voice conversations and group chats.',
          actionLabel: l10n?.voiceRooms ?? 'Voice Rooms',
          onAction: onOpenVoiceRooms,
        ),
      ],
    ).animate().fadeIn(duration: 180.ms);
  }
}

class _SectionInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAction;
  const _SectionInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EBF0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppConstants.textPrimary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.tonal(
            onPressed: onAction,
            style: FilledButton.styleFrom(
              backgroundColor:
                  AppConstants.primaryColor.withValues(alpha: 0.35),
              foregroundColor: AppConstants.textPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              actionLabel,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Voice Room Live Banner
// ---------------------------------------------------------------------------

class _VoiceRoomLiveBanner extends StatefulWidget {
  const _VoiceRoomLiveBanner();

  @override
  State<_VoiceRoomLiveBanner> createState() => _VoiceRoomLiveBannerState();
}

class _VoiceRoomLiveBannerState extends State<_VoiceRoomLiveBanner> {
  bool _dismissed = false;

  @override
  Widget build(BuildContext context) {
    if (_dismissed) return const SizedBox.shrink();

    return Consumer<VoiceRoomProvider>(
      builder: (context, voiceProvider, _) {
        final rooms = voiceProvider.rooms;
        if (rooms.isEmpty) return const SizedBox.shrink();

        // Count total participants across all rooms
        int totalParticipants = 0;
        for (final room in rooms) {
          totalParticipants += room.totalParticipants;
        }

        return Container(
          margin: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.mic,
                  color: Color(0xFF2E7D32),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$totalParticipants people practicing now',
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const VoiceRoomsListScreen(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2E7D32),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Join',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 2),
              GestureDetector(
                onTap: () => setState(() => _dismissed = true),
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: Color(0xFF6B7684),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton Post Card (shimmer-style loading placeholder)
// ---------------------------------------------------------------------------

class _SkeletonPostCard extends StatefulWidget {
  const _SkeletonPostCard();

  @override
  State<_SkeletonPostCard> createState() => _SkeletonPostCardState();
}

class _SkeletonPostCardState extends State<_SkeletonPostCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFECEFF4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + name row
            Row(
              children: [
                // Avatar circle
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name placeholder
                    Container(
                      width: 100,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Timestamp placeholder
                    Container(
                      width: 60,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Content placeholder
            Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 12),
            // Action row placeholder
            Container(
              width: double.infinity,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// End-of-feed indicator
// ---------------------------------------------------------------------------

class _EndOfFeedIndicator extends StatelessWidget {
  const _EndOfFeedIndicator();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      child: Column(
        children: [
          Divider(color: Color(0xFFECEFF4)),
          SizedBox(height: 12),
          Text(
            "You're all caught up",
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Following Tab
// ---------------------------------------------------------------------------

class _FollowingTab extends StatefulWidget {
  final ValueNotifier<bool> fabVisibleNotifier;

  const _FollowingTab({required this.fabVisibleNotifier});

  @override
  State<_FollowingTab> createState() => _FollowingTabState();
}

class _FollowingTabState extends State<_FollowingTab>
    with AutomaticKeepAliveClientMixin {
  late final ScrollController _scrollController;
  double _previousOffset = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollDirection);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollDirection);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollDirection() {
    final offset = _scrollController.offset;
    if (offset <= 0) {
      widget.fabVisibleNotifier.value = true;
    } else if (offset > _previousOffset + 5) {
      // Scrolling down
      widget.fabVisibleNotifier.value = false;
    } else if (offset < _previousOffset - 5) {
      // Scrolling up
      widget.fabVisibleNotifier.value = true;
    }
    _previousOffset = offset;
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 240) {
      context.read<FeedProvider>().loadMoreFeed();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<FeedProvider>(
      builder: (context, feedProvider, _) {
        final posts = feedProvider.feedPosts;

        // Skeleton loading
        if (feedProvider.isLoadingFeed && posts.isEmpty) {
          return ListView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 10),
            children: const [
              _SkeletonPostCard(),
              _SkeletonPostCard(),
              _SkeletonPostCard(),
            ],
          );
        }

        // Error state with retry
        if (feedProvider.errorMessage != null && posts.isEmpty) {
          return _FeedErrorView(
            message: feedProvider.errorMessage!,
            onRetry: () => feedProvider.loadFeed(refresh: true),
          );
        }

        // Empty state with suggested users
        if (posts.isEmpty) {
          return _FollowingEmptyState(
            onFindFriends: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FriendSearchScreen(),
                ),
              );
            },
          );
        }

        return RefreshIndicator(
          color: AppConstants.primaryColor,
          onRefresh: () => feedProvider.loadFeed(refresh: true),
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: ListView.separated(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 4, bottom: 96),
              itemCount: posts.length +
                  1 + // Voice room banner slot
                  (feedProvider.hasMoreFeed
                      ? 1
                      : 1), // pagination loader or end-of-feed
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                // First item: voice room live banner
                if (index == 0) {
                  return const _VoiceRoomLiveBanner();
                }

                final postIndex = index - 1;

                if (postIndex >= posts.length) {
                  // Load more indicator or end-of-feed
                  if (feedProvider.hasMoreFeed) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppConstants.primaryColor),
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  } else {
                    return const _EndOfFeedIndicator();
                  }
                }
                return PostCard(post: posts[postIndex], index: postIndex);
              },
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Following Empty State with suggested users
// ---------------------------------------------------------------------------

class _FollowingEmptyState extends StatefulWidget {
  final VoidCallback onFindFriends;

  const _FollowingEmptyState({required this.onFindFriends});

  @override
  State<_FollowingEmptyState> createState() => _FollowingEmptyStateState();
}

class _FollowingEmptyStateState extends State<_FollowingEmptyState> {
  @override
  void initState() {
    super.initState();
    // Load suggested users for the inline list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SocialProvider>().loadSuggestedUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppConstants.paddingXLarge),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(Icons.people_outline, size: 56, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Text(
            l10n?.following ?? 'Following',
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n?.noFollowingPosts ??
                'Follow other learners to see their posts here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeNormal,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Share your Korean learning journey with others',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.textHint,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: widget.onFindFriends,
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: Text(l10n?.findFriends ?? 'Find Friends'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.textPrimary,
              side: const BorderSide(color: AppConstants.primaryColor),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Suggested users inline list
          Consumer<SocialProvider>(
            builder: (context, socialProvider, _) {
              final suggested = socialProvider.suggestedUsers;
              if (suggested.isEmpty) return const SizedBox.shrink();

              final displayUsers = suggested.take(3).toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFFECEFF4)),
                  const SizedBox(height: 12),
                  const Text(
                    'Suggested learners',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...displayUsers.map((user) => _SuggestedUserTile(user: user)),
                ],
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(duration: 220.ms);
  }
}

class _SuggestedUserTile extends StatelessWidget {
  final dynamic user; // SnsUserModel

  const _SuggestedUserTile({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: user.hasProfileImage
                ? NetworkImage(user.profileImageUrl!)
                : null,
            child: user.hasProfileImage
                ? null
                : Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppConstants.textSecondary,
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (user.hasBio)
                  Text(
                    user.bio!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: AppConstants.textHint,
                    ),
                  ),
              ],
            ),
          ),
          Consumer<SocialProvider>(
            builder: (context, socialProvider, _) {
              final isFollowing = socialProvider.isFollowing(user.id) ?? false;
              final isToggling = socialProvider.isToggling(user.id);
              return SizedBox(
                height: 30,
                child: OutlinedButton(
                  onPressed: isToggling
                      ? null
                      : () => socialProvider.toggleFollow(user.id),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isFollowing
                        ? AppConstants.textSecondary
                        : AppConstants.textPrimary,
                    side: BorderSide(
                      color: isFollowing
                          ? Colors.grey.shade300
                          : AppConstants.primaryColor,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    isFollowing ? 'Following' : 'Follow',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Discover Tab
// ---------------------------------------------------------------------------

class _DiscoverTab extends StatefulWidget {
  final ValueNotifier<bool> fabVisibleNotifier;

  const _DiscoverTab({required this.fabVisibleNotifier});

  @override
  State<_DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<_DiscoverTab>
    with AutomaticKeepAliveClientMixin {
  String _selectedCategory = 'all';
  late final ScrollController _scrollController;
  double _previousOffset = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollDirection);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollDirection);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollDirection() {
    final offset = _scrollController.offset;
    if (offset <= 0) {
      widget.fabVisibleNotifier.value = true;
    } else if (offset > _previousOffset + 5) {
      widget.fabVisibleNotifier.value = false;
    } else if (offset < _previousOffset - 5) {
      widget.fabVisibleNotifier.value = true;
    }
    _previousOffset = offset;
  }

  void _onCategoryChanged(String category) {
    setState(() => _selectedCategory = category);
    context.read<FeedProvider>().loadDiscover(
          refresh: true,
          category: category == 'all' ? null : category,
        );
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.pixels >=
        notification.metrics.maxScrollExtent - 240) {
      context.read<FeedProvider>().loadMoreDiscover();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Consumer<FeedProvider>(
      builder: (context, feedProvider, _) {
        final posts = feedProvider.discoverPosts;

        return RefreshIndicator(
          color: AppConstants.primaryColor,
          onRefresh: () => feedProvider.loadDiscover(
            refresh: true,
            category: _selectedCategory == 'all' ? null : _selectedCategory,
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScroll,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _CategoryHeaderDelegate(
                    child: Container(
                      color: Colors.white,
                      alignment: Alignment.centerLeft,
                      child: CategoryFilterChips(
                        selectedCategory: _selectedCategory,
                        onCategoryChanged: _onCategoryChanged,
                      ),
                    ),
                  ),
                ),
                // Skeleton loading
                if (feedProvider.isLoadingDiscover && posts.isEmpty)
                  SliverList.list(
                    children: const [
                      _SkeletonPostCard(),
                      _SkeletonPostCard(),
                      _SkeletonPostCard(),
                    ],
                  )
                // Error state with retry
                else if (feedProvider.errorMessage != null && posts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _FeedErrorView(
                      message: feedProvider.errorMessage!,
                      onRetry: () => feedProvider.loadDiscover(
                        refresh: true,
                        category: _selectedCategory == 'all'
                            ? null
                            : _selectedCategory,
                      ),
                    ),
                  )
                // Discover empty state
                else if (posts.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _DiscoverEmptyState(
                      onCreatePost: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CreatePostScreen(),
                          ),
                        ).then((result) {
                          if (result == true && mounted) {
                            feedProvider.loadDiscover(refresh: true);
                            feedProvider.loadFeed(refresh: true);
                          }
                        });
                      },
                    ),
                  )
                else ...[
                  // Voice room live banner as first item in sliver
                  const SliverToBoxAdapter(child: _VoiceRoomLiveBanner()),
                  SliverList.builder(
                    itemCount: posts.length +
                        (feedProvider.hasMoreDiscover
                            ? 1
                            : 1), // pagination or end
                    itemBuilder: (context, index) {
                      if (index >= posts.length) {
                        if (feedProvider.hasMoreDiscover) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppConstants.primaryColor,
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        } else {
                          return const _EndOfFeedIndicator();
                        }
                      }
                      return PostCard(post: posts[index], index: index);
                    },
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 96)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Discover Empty State
// ---------------------------------------------------------------------------

class _DiscoverEmptyState extends StatelessWidget {
  final VoidCallback onCreatePost;

  const _DiscoverEmptyState({required this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_outlined, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              l10n?.discover ?? 'Discover',
              style: const TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n?.noPostsYet ?? 'No posts yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeNormal,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Start the conversation and inspire others!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textHint,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: onCreatePost,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(l10n?.beFirstToPost ?? 'Be the first to post!'),
              style: FilledButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 220.ms);
  }
}

// ---------------------------------------------------------------------------
// Feed Error View (with retry)
// ---------------------------------------------------------------------------

class _FeedErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _FeedErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, size: 56, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppConstants.fontSizeNormal,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text(l10n?.retry ?? 'Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Category Header Delegate
// ---------------------------------------------------------------------------

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _CategoryHeaderDelegate({required this.child});

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color:
                overlapsContent ? const Color(0xFFECEFF4) : Colors.transparent,
          ),
        ),
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

