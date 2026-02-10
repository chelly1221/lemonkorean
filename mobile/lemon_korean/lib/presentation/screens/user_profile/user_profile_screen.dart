import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/post_model.dart';
import '../../../data/models/sns_user_model.dart';
import '../../../data/repositories/sns_repository.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/social_provider.dart';
import '../community/widgets/post_card.dart';
import 'widgets/profile_header.dart';

/// Other user's profile screen showing their profile info and posts
class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final SnsRepository _snsRepository = SnsRepository();

  SnsUserModel? _user;
  List<PostModel> _userPosts = [];
  bool _isLoading = true;
  bool _isLoadingPosts = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final socialProvider =
          Provider.of<SocialProvider>(context, listen: false);

      // Load profile and posts in parallel
      final results = await Future.wait([
        socialProvider.getUserProfile(widget.userId),
        _snsRepository.getPostsByUser(widget.userId),
      ]);

      if (mounted) {
        final user = results[0] as SnsUserModel?;
        final postsResult = results[1]
            as ({List<PostModel> posts, String? nextCursor});

        setState(() {
          _user = user;
          _userPosts = postsResult.posts;
          _isLoading = false;
          _isLoadingPosts = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
          _isLoadingPosts = false;
        });
      }
    }
  }

  Future<void> _refresh() async {
    await _loadUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_user?.name ?? (l10n?.profile ?? 'Profile')),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(l10n),
    );
  }

  Widget _buildBody(AppLocalizations? l10n) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            AppConstants.primaryColor,
          ),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingXLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade400,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              Text(
                l10n?.failedToLoadProfile ?? 'Failed to load profile',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeNormal,
                  color: AppConstants.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.paddingMedium),
              ElevatedButton.icon(
                onPressed: _loadUserProfile,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(l10n?.retry ?? 'Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_user == null) {
      return Center(
        child: Text(
          l10n?.userNotFound ?? 'User not found',
          style: const TextStyle(
            fontSize: AppConstants.fontSizeNormal,
            color: AppConstants.textSecondary,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppConstants.primaryColor,
      onRefresh: _refresh,
      child: CustomScrollView(
        slivers: [
          // Profile header
          SliverToBoxAdapter(
            child: ProfileHeader(user: _user!),
          ),

          // Divider
          const SliverToBoxAdapter(
            child: Divider(height: 1),
          ),

          // Posts section header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Text(
                l10n?.posts ?? 'Posts',
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.textSecondary,
                ),
              ),
            ),
          ),

          // User's posts
          if (_isLoadingPosts)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.paddingLarge),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppConstants.primaryColor,
                    ),
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else if (_userPosts.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingXLarge),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.article_outlined,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: AppConstants.paddingSmall),
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
              ).animate().fadeIn(duration: 300.ms),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return PostCard(
                    post: _userPosts[index],
                    index: index,
                  );
                },
                childCount: _userPosts.length,
              ),
            ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppConstants.paddingLarge),
          ),
        ],
      ),
    );
  }
}
