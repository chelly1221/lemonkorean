import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Category filter chips for the Discover tab
/// Allows users to filter posts by category: All, Learning, General
class CategoryFilterChips extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const CategoryFilterChips({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final categories = <String, String>{
      'all': l10n?.all ?? 'All',
      'learning': l10n?.learning ?? 'Learning',
      'general': l10n?.general ?? 'General',
    };

    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        itemCount: categories.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppConstants.paddingSmall),
        itemBuilder: (context, index) {
          final entry = categories.entries.elementAt(index);
          final isSelected = selectedCategory == entry.key;

          return FilterChip(
            label: Text(
              entry.value,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black87 : AppConstants.textSecondary,
              ),
            ),
            selected: isSelected,
            onSelected: (_) => onCategoryChanged(entry.key),
            selectedColor: AppConstants.primaryColor.withValues(alpha: 0.3),
            backgroundColor: Colors.grey.shade100,
            checkmarkColor: Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
            ),
            side: BorderSide(
              color: isSelected
                  ? AppConstants.primaryColor
                  : Colors.grey.shade300,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingSmall,
            ),
          );
        },
      ),
    );
  }
}
