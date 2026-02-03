import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/hangul_character_model.dart';
import '../../../../data/models/hangul_progress_model.dart';
import '../../../widgets/convertible_text.dart';

/// Hangul Character Card Widget
/// Displays a single hangul character with mastery indicator
class CharacterCard extends StatelessWidget {
  final HangulCharacterModel character;
  final HangulProgressModel? progress;
  final VoidCallback? onTap;
  final bool showDetails;
  final bool isSelected;

  const CharacterCard({
    required this.character,
    this.progress,
    this.onTap,
    this.showDetails = false,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final masteryLevel = progress?.masteryLevel ?? 0;
    final masteryColor = _getMasteryColor(masteryLevel);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor.withValues(alpha: 0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          border: Border.all(
            color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Character
                  Text(
                    character.character,
                    style: TextStyle(
                      fontSize: showDetails ? 36 : 28,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.textPrimary,
                    ),
                  ),

                  if (showDetails) ...[
                    const SizedBox(height: 4),
                    // Romanization
                    Text(
                      character.romanization,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    // Chinese pronunciation
                    ConvertibleText(
                      character.pronunciationZh,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Mastery indicator
            if (progress != null && masteryLevel > 0)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: masteryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Lv$masteryLevel',
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // New badge for unlearned characters
            if (progress == null || progress!.isNew)
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.infoColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getMasteryColor(int level) {
    if (level >= 5) return Colors.purple;
    if (level >= 4) return Colors.green;
    if (level >= 3) return Colors.blue;
    if (level >= 2) return Colors.orange;
    if (level >= 1) return Colors.amber;
    return Colors.grey;
  }
}

/// Compact character card for alphabet table
class CompactCharacterCard extends StatelessWidget {
  final HangulCharacterModel character;
  final HangulProgressModel? progress;
  final VoidCallback? onTap;

  const CompactCharacterCard({
    required this.character,
    this.progress,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final masteryLevel = progress?.masteryLevel ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _getBackgroundColor(masteryLevel),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Center(
          child: Text(
            character.character,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(int level) {
    if (level >= 5) return Colors.purple.shade50;
    if (level >= 4) return Colors.green.shade50;
    if (level >= 3) return Colors.blue.shade50;
    if (level >= 2) return Colors.orange.shade50;
    if (level >= 1) return Colors.amber.shade50;
    return Colors.white;
  }
}
