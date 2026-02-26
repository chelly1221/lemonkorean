import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';

/// Shows the streak detail bottom sheet modal.
///
/// Displays the current streak count with a fire animation, a 30-day calendar
/// heatmap of study activity, total study days, and a motivational message.
void showStreakDetailSheet({
  required BuildContext context,
  required int currentStreak,
  required int totalStudyDays,
  required List<Map<String, dynamic>> progressList,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _StreakDetailSheet(
      currentStreak: currentStreak,
      totalStudyDays: totalStudyDays,
      progressList: progressList,
    ),
  );
}

class _StreakDetailSheet extends StatelessWidget {
  const _StreakDetailSheet({
    required this.currentStreak,
    required this.totalStudyDays,
    required this.progressList,
  });

  final int currentStreak;
  final int totalStudyDays;
  final List<Map<String, dynamic>> progressList;

  /// Parses progressList to build a set of date strings (yyyy-MM-dd) that have
  /// at least one completed lesson entry.
  Set<String> _buildStudiedDates() {
    final studied = <String>{};
    for (final item in progressList) {
      final raw = item['completed_at'];
      if (raw == null) continue;
      try {
        final dt = DateTime.parse(raw as String).toLocal();
        studied.add('${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}');
      } catch (_) {
        // Skip unparseable entries
      }
    }
    return studied;
  }

  String _motivationalMessage() {
    if (currentStreak == 0) return '오늘부터 시작해보세요!';
    if (currentStreak < 7) return '좋은 시작이에요! 계속 이어가세요!';
    if (currentStreak < 14) return '일주일 넘게 연속 학습 중! 대단해요!';
    if (currentStreak < 30) return '2주 넘게 꾸준히! 습관이 되고 있어요!';
    return '한 달 이상 연속 학습! 당신은 진정한 학습자입니다!';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final studiedDates = _buildStudiedDates();
    final today = DateTime.now().toLocal();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.45,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusXLarge),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppConstants.textHint.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingLarge,
                  ),
                  children: [
                    const SizedBox(height: AppConstants.paddingSmall),

                    // Fire + streak count hero section
                    _StreakHero(currentStreak: currentStreak),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Calendar heatmap card
                    _CalendarCard(
                      studiedDates: studiedDates,
                      todayStr: todayStr,
                      today: today,
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 200.ms)
                        .slideY(begin: 0.12, end: 0, duration: 400.ms, delay: 200.ms),

                    const SizedBox(height: AppConstants.paddingMedium),

                    // Total study days
                    _TotalStudyDaysRow(totalStudyDays: totalStudyDays),

                    const SizedBox(height: AppConstants.paddingLarge),

                    // Motivational message
                    _MotivationalMessage(message: _motivationalMessage()),

                    const SizedBox(height: AppConstants.paddingLarge),
                  ],
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
// Fire + streak count hero
// ---------------------------------------------------------------------------

class _StreakHero extends StatelessWidget {
  const _StreakHero({required this.currentStreak});

  final int currentStreak;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        // Animated fire emoji
        const Text('🔥', style: TextStyle(fontSize: 56))
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(
              begin: 1.0,
              end: 1.12,
              duration: 900.ms,
              curve: Curves.easeInOut,
            )
            .animate()
            .fadeIn(duration: 350.ms),

        const SizedBox(height: AppConstants.paddingSmall),

        // Streak count
        Text(
          '$currentStreak',
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            height: 1.0,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: -0.2, end: 0, duration: 400.ms, delay: 100.ms),

        const SizedBox(height: 4),

        // Label "일 연속 학습!"
        const Text(
          '일 연속 학습!',
          style: TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.w600,
            color: AppConstants.accentColor,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 180.ms),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar heatmap card
// ---------------------------------------------------------------------------

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.studiedDates,
    required this.todayStr,
    required this.today,
  });

  final Set<String> studiedDates;
  final String todayStr;
  final DateTime today;

  /// Returns the list of [DateTime] days to display.
  ///
  /// We show from the Monday of the week that was 4 full weeks ago up through
  /// today, padded at the end to complete the last week row.
  List<DateTime?> _buildDaySlots() {
    // Find the Monday on or before 29 days ago (so we always show ~5 rows).
    final earliest = today.subtract(const Duration(days: 29));
    // weekday: Mon=1 … Sun=7
    final daysFromMonday = (earliest.weekday - 1) % 7;
    final gridStart = earliest.subtract(Duration(days: daysFromMonday));

    final slots = <DateTime?>[];
    var cursor = gridStart;
    while (!cursor.isAfter(today)) {
      slots.add(cursor);
      cursor = cursor.add(const Duration(days: 1));
    }
    // Pad to complete the last row (fill up to multiple of 7)
    while (slots.length % 7 != 0) {
      slots.add(null);
    }
    return slots;
  }

  String _dateStr(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final slots = _buildDaySlots();

    // Day-of-week headers: Mon … Sun
    const dayHeaders = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            '이번 달 학습 기록',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ), // colorScheme is runtime — cannot be const
          const SizedBox(height: AppConstants.paddingSmall),

          // Day-of-week headers row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: dayHeaders
                .map(
                  (h) => SizedBox(
                    width: 32,
                    child: Center(
                      child: Text(
                        h,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeSmall,
                          fontWeight: FontWeight.w600,
                          color: AppConstants.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 6),

          // Day dot grid
          ...List.generate(slots.length ~/ 7, (rowIndex) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (colIndex) {
                  final day = slots[rowIndex * 7 + colIndex];
                  if (day == null) {
                    return const SizedBox(width: 32, height: 32);
                  }
                  final ds = _dateStr(day);
                  final isToday = ds == todayStr;
                  final studied = studiedDates.contains(ds);
                  final isFuture = day.isAfter(today);
                  return _DayDot(
                    isToday: isToday,
                    studied: studied,
                    isFuture: isFuture,
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Individual day dot
// ---------------------------------------------------------------------------

class _DayDot extends StatelessWidget {
  const _DayDot({
    required this.isToday,
    required this.studied,
    required this.isFuture,
  });

  final bool isToday;
  final bool studied;
  final bool isFuture;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isToday) {
      // Outlined ring — today
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: studied
              ? AppConstants.secondaryColor.withValues(alpha: 0.2)
              : Colors.transparent,
          border: Border.all(
            color: AppConstants.accentColor,
            width: 2.5,
          ),
        ),
        child: studied
            ? null
            : Center(
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.accentColor,
                  ),
                ),
              ),
      );
    }

    if (isFuture) {
      // Invisible placeholder (keeps grid alignment)
      return const SizedBox(width: 28, height: 28);
    }

    if (studied) {
      // Filled green circle
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppConstants.secondaryColor,
          boxShadow: [
            BoxShadow(
              color: AppConstants.secondaryColor.withValues(alpha: 0.35),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      );
    }

    // Empty grey circle
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.outlineVariant.withValues(alpha: 0.35),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Total study days row
// ---------------------------------------------------------------------------

class _TotalStudyDaysRow extends StatelessWidget {
  const _TotalStudyDaysRow({required this.totalStudyDays});

  final int totalStudyDays;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.infoColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: AppConstants.infoColor,
          ),
        ),
        const SizedBox(width: AppConstants.paddingSmall),
        const Text(
          '총 학습일: ',
          style: TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            color: AppConstants.textSecondary,
          ),
        ),
        Text(
          '$totalStudyDays일',
          style: TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 320.ms)
        .slideX(begin: -0.08, end: 0, duration: 400.ms, delay: 320.ms);
  }
}

// ---------------------------------------------------------------------------
// Motivational message
// ---------------------------------------------------------------------------

class _MotivationalMessage extends StatelessWidget {
  const _MotivationalMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingMedium,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.primaryColor.withValues(alpha: 0.25),
            AppConstants.primaryColor.withValues(alpha: 0.10),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(
          color: AppConstants.primaryColor.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Text('💪', style: TextStyle(fontSize: 20)),
          const SizedBox(width: AppConstants.paddingSmall),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w500,
                color: AppConstants.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 400.ms);
  }
}
