import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/user_model.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// User Header Widget
/// Displays user greeting and streak information
class UserHeader extends StatelessWidget {
  final UserModel? user;
  final int streakDays;

  const UserHeader({
    super.key,
    this.user,
    this.streakDays = 0,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hour = DateTime.now().hour;
    String greeting;

    if (hour < 12) {
      greeting = l10n.goodMorning;
    } else if (hour < 18) {
      greeting = l10n.goodAfternoon;
    } else {
      greeting = l10n.goodEvening;
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingLarge),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor.withOpacity(0.2),
            AppConstants.primaryColor.withOpacity(0.05),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: AppConstants.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.username ?? l10n.user,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeXLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Streak Days
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
              vertical: AppConstants.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.orange,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$streakDays',
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      l10n.days,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: AppConstants.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
