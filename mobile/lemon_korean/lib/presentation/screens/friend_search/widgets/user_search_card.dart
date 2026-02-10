import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/sns_user_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/social_provider.dart';
import '../../user_profile/user_profile_screen.dart';

/// User search result card with avatar, name, bio preview, and follow button
class UserSearchCard extends StatelessWidget {
  final SnsUserModel user;

  const UserSearchCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall / 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      elevation: 0.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileScreen(userId: user.id),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
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
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )
                    : null,
              ),

              const SizedBox(width: AppConstants.paddingMedium),

              // Name + bio
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                        color: AppConstants.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (user.hasBio) ...[
                      const SizedBox(height: 2),
                      Text(
                        user.bio!,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          color: AppConstants.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '${user.followerCount} ${l10n?.followers ?? 'followers'}',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textHint,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppConstants.paddingSmall),

              // Follow button
              _buildFollowButton(context, l10n),
            ],
          ),
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
          width: 96,
          height: 34,
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
              padding: EdgeInsets.zero,
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
                    width: 16,
                    height: 16,
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
                      fontSize: AppConstants.fontSizeSmall,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
