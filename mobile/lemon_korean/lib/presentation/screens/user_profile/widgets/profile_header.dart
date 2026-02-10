import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/sns_user_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/dm_provider.dart';
import '../../../providers/social_provider.dart';
import '../../dm/chat_screen.dart';

/// Profile header widget displaying user avatar, name, bio, stats, and follow button
class ProfileHeader extends StatelessWidget {
  final SnsUserModel user;
  final bool isOwnProfile;

  const ProfileHeader({
    super.key,
    required this.user,
    this.isOwnProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppConstants.primaryColor.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 40,
            backgroundColor:
                AppConstants.primaryColor.withValues(alpha: 0.3),
            backgroundImage: user.hasProfileImage
                ? NetworkImage(
                    '${AppConstants.mediaUrl}/images/${user.profileImageUrl}',
                  )
                : null,
            child: !user.hasProfileImage
                ? Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                : null,
          ),

          const SizedBox(height: AppConstants.paddingMedium),

          // Name
          Text(
            user.name,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeXLarge,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimary,
            ),
          ),

          // Bio
          if (user.hasBio) ...[
            const SizedBox(height: AppConstants.paddingSmall),
            Text(
              user.bio!,
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: AppConstants.textSecondary,
                height: 1.4,
              ),
            ),
          ],

          const SizedBox(height: AppConstants.paddingMedium),

          // Stats row
          _buildStatsRow(l10n),

          // Follow + Message buttons (only for other users)
          if (!isOwnProfile) ...[
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildFollowButton(context, l10n),
                const SizedBox(width: 12),
                _buildMessageButton(context, l10n),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(
          begin: -0.1,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        );
  }

  Widget _buildStatsRow(AppLocalizations? l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem(
          value: '${user.postCount}',
          label: l10n?.posts ?? 'Posts',
        ),
        Container(
          width: 1,
          height: 30,
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
          ),
          color: Colors.grey.shade300,
        ),
        _buildStatItem(
          value: '${user.followerCount}',
          label: l10n?.followers ?? 'Followers',
        ),
        Container(
          width: 1,
          height: 30,
          margin: const EdgeInsets.symmetric(
            horizontal: AppConstants.paddingLarge,
          ),
          color: Colors.grey.shade300,
        ),
        _buildStatItem(
          value: '${user.followingCount}',
          label: l10n?.following ?? 'Following',
        ),
      ],
    );
  }

  Widget _buildStatItem({required String value, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
            color: AppConstants.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: AppConstants.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildMessageButton(BuildContext context, AppLocalizations? l10n) {
    return OutlinedButton.icon(
      onPressed: () async {
        final dmProvider = Provider.of<DmProvider>(context, listen: false);
        final conversationId = await dmProvider.openConversation(user.id);
        if (conversationId != null && context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                conversationId: conversationId,
                otherUserName: user.name,
                otherUserAvatar: user.profileImageUrl,
                otherUserId: user.id,
              ),
            ),
          );
        }
      },
      icon: const Icon(Icons.mail_outline, size: 18),
      label: Text(l10n?.message ?? 'Message'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppConstants.textPrimary,
        side: BorderSide(color: Colors.grey.shade400),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        ),
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context, AppLocalizations? l10n) {
    return Consumer<SocialProvider>(
      builder: (context, socialProvider, child) {
        final isFollowing =
            socialProvider.isFollowing(user.id) ?? user.isFollowing;
        final isLoading = socialProvider.isToggling(user.id);

        return SizedBox(
          width: 130,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    socialProvider.toggleFollow(user.id);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: isFollowing
                  ? Colors.grey.shade200
                  : AppConstants.primaryColor,
              foregroundColor:
                  isFollowing ? AppConstants.textPrimary : Colors.black87,
              elevation: 0,
              padding: const EdgeInsets.symmetric(
                vertical: AppConstants.paddingSmall,
              ),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.radiusLarge),
                side: BorderSide(
                  color: isFollowing
                      ? Colors.grey.shade400
                      : AppConstants.primaryColor,
                ),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppConstants.textSecondary,
                      ),
                    ),
                  )
                : Text(
                    isFollowing
                        ? (l10n?.unfollow ?? 'Unfollow')
                        : (l10n?.follow ?? 'Follow'),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppConstants.fontSizeMedium,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
