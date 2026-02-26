import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// A 2x2 grid of learning-stat cards shown on the profile tab.
///
/// Displays Study Days, Completed Lessons, Words Learned, and Total Study Time.
/// Each card animates in with a staggered fade + slide entrance.
class ProfileStatsGrid extends StatelessWidget {
  const ProfileStatsGrid({
    required this.studyDays,
    required this.completedLessons,
    required this.masteredWords,
    required this.totalTimeMinutes,
    super.key,
  });

  final int studyDays;
  final int completedLessons;
  final int masteredWords;

  /// Total study time in minutes. Displayed as hours (e.g. "2.5h") when >= 60,
  /// otherwise as minutes (e.g. "45m").
  final int totalTimeMinutes;

  // --------------------------------------------------------------------------
  // Helpers
  // --------------------------------------------------------------------------

  String _formatTime() {
    if (totalTimeMinutes >= 60) {
      final hours = totalTimeMinutes / 60.0;
      // Show one decimal place only when there is a non-zero fractional part.
      final formatted =
          hours == hours.truncateToDouble() ? '${hours.toInt()}h' : '${hours.toStringAsFixed(1)}h';
      return formatted;
    }
    return '${totalTimeMinutes}m';
  }

  // --------------------------------------------------------------------------
  // Build
  // --------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final stats = <_StatData>[
      _StatData(
        icon: Icons.calendar_today_rounded,
        iconColor: AppConstants.accentColor,
        value: '$studyDays',
        label: l10n?.studyDays ?? 'Study Days',
      ),
      _StatData(
        icon: Icons.menu_book_rounded,
        iconColor: AppConstants.infoColor,
        value: '$completedLessons',
        label: l10n?.completedLessons ?? 'Completed Lessons',
      ),
      _StatData(
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: AppConstants.secondaryColor,
        value: '$masteredWords',
        label: l10n?.masteredWords ?? 'Words Learned',
      ),
      _StatData(
        icon: Icons.timer_outlined,
        iconColor: AppConstants.primaryColor.withValues(alpha: 0.85),
        value: _formatTime(),
        // No dedicated l10n key exists for this stat yet; use inline fallback.
        label: 'Total Study Time',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppConstants.paddingSmall,
        crossAxisSpacing: AppConstants.paddingSmall,
        childAspectRatio: 1.35,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        return _StatCard(data: stats[index])
            .animate(delay: (index * 100).ms)
            .fadeIn(duration: 400.ms)
            .slideY(
              begin: 0.1,
              end: 0,
              curve: Curves.easeOutCubic,
              duration: 400.ms,
            );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Internal data class
// ---------------------------------------------------------------------------

class _StatData {
  const _StatData({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
}

// ---------------------------------------------------------------------------
// Single stat card
// ---------------------------------------------------------------------------

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark
        ? AppConstants.backgroundDark.withValues(alpha: 0.8)
        : AppConstants.cardBackground;

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.07);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingSmall + 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon circle
          _IconCircle(color: data.iconColor, icon: data.icon),

          // Value + label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.label,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: AppConstants.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Icon inside a translucent colored circle
// ---------------------------------------------------------------------------

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
      ),
      child: Center(
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
