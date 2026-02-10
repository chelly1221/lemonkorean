import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/ad_service.dart';
import '../../../../core/services/adsense_service.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../providers/gamification_provider.dart';

// Conditional import for AdMob (mobile only, web gets stub with typedef)
import '../../../../core/services/admob_service.dart'
    if (dart.library.html) '../../../../core/services/admob_service_web.dart';

/// Lemon tree widget displayed on the profile tab.
/// Shows a tree with lemons that can be harvested by watching ads.
class LemonTreeWidget extends StatefulWidget {
  const LemonTreeWidget({super.key});

  @override
  State<LemonTreeWidget> createState() => _LemonTreeWidgetState();
}

class _LemonTreeWidgetState extends State<LemonTreeWidget> {
  AdService? _adService;
  bool _isHarvesting = false;

  // Predefined lemon positions on the tree (relative to tree area)
  // Arranged bottom to top, left to right
  static const List<Offset> _lemonPositions = [
    Offset(0.25, 0.75), // bottom left
    Offset(0.75, 0.75), // bottom right
    Offset(0.50, 0.65), // bottom center
    Offset(0.20, 0.55), // mid-left
    Offset(0.80, 0.55), // mid-right
    Offset(0.40, 0.45), // mid-center-left
    Offset(0.60, 0.45), // mid-center-right
    Offset(0.30, 0.35), // upper-left
    Offset(0.70, 0.35), // upper-right
    Offset(0.50, 0.25), // top
  ];

  @override
  void initState() {
    super.initState();
    _initAdService();
  }

  Future<void> _initAdService() async {
    try {
      final gamification = Provider.of<GamificationProvider>(context, listen: false);
      if (kIsWeb) {
        _adService = AdSenseService();
      } else {
        // AdMobService via conditional import (resolves to AdSenseService on web)
        final service = AdMobService();
        if (gamification.admobRewardedAdId.isNotEmpty) {
          service.setAdUnitId(gamification.admobRewardedAdId);
        }
        _adService = service;
      }
      await _adService!.initialize();
    } catch (e) {
      debugPrint('[LemonTree] Ad service init failed: $e');
    }
  }

  Future<void> _harvestLemon(int index) async {
    if (_isHarvesting) return;

    final l10n = AppLocalizations.of(context)!;
    final gamification = Provider.of<GamificationProvider>(context, listen: false);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.harvestLemon),
        content: Text(l10n.watchAdToHarvest),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.black87,
            ),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isHarvesting = true;
    });

    // Show ad
    bool rewarded = false;
    if (_adService != null) {
      rewarded = await _adService!.showRewardedAd();
    } else {
      // Fallback: grant reward without ad (dev mode)
      rewarded = true;
    }

    if (rewarded && mounted) {
      final success = await gamification.harvestLemon();
      if (success) {
        // Show success feedback
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('🍋 ${l10n.lemonHarvested} +1'),
              backgroundColor: AppConstants.successColor,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _isHarvesting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Consumer<GamificationProvider>(
      builder: (context, gamification, child) {
        final maxSlots = gamification.maxTreeLemons.clamp(1, _lemonPositions.length);
        final available = gamification.treeLemonsAvailable.clamp(0, maxSlots);
        final total = gamification.totalLemons;

        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    const Text('🌳', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.myLemonTree,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🍋', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 4),
                          Text(
                            '$total',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tree visualization
                SizedBox(
                  height: 240,
                  child: CustomPaint(
                    painter: _TreePainter(),
                    child: Stack(
                      children: [
                        // Lemon positions (limited by server maxTreeLemons)
                        for (int i = 0; i < maxSlots; i++)
                          _buildLemonSlot(i, available, gamification),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Info text
                Center(
                  child: Text(
                    available > 0
                        ? '${l10n.lemonsAvailable}: $available'
                        : l10n.completeMoreLessons,
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLemonSlot(int index, int available, GamificationProvider gamification) {
    final pos = _lemonPositions[index];
    final hasLemon = index < available;

    return Positioned(
      left: pos.dx * 200 - 12 + 60, // offset for tree trunk centering
      top: pos.dy * 200 - 12,
      child: GestureDetector(
        onTap: hasLemon && !_isHarvesting ? () => _harvestLemon(index) : null,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: hasLemon
              ? Container(
                  key: ValueKey('lemon_$index'),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppConstants.primaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppConstants.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🍋', style: TextStyle(fontSize: 16)),
                  ),
                )
                    .animate(
                      onPlay: (c) => c.repeat(reverse: true),
                    )
                    .shimmer(
                      duration: 2000.ms,
                      delay: (index * 300).ms,
                      color: Colors.yellow.withValues(alpha: 0.3),
                    )
              : Container(
                  key: ValueKey('empty_$index'),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.shade100,
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 14,
                    color: Colors.green.shade300,
                  ),
                ),
        ),
      ),
    );
  }
}

/// Paints a simple tree trunk and canopy
class _TreePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;

    // Trunk
    final trunkPaint = Paint()
      ..color = const Color(0xFF8B6914)
      ..style = PaintingStyle.fill;

    final trunkRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(centerX - 12, size.height * 0.65, 24, size.height * 0.35),
      const Radius.circular(4),
    );
    canvas.drawRRect(trunkRect, trunkPaint);

    // Branches
    final branchPaint = Paint()
      ..color = const Color(0xFF8B6914)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Left branch
    canvas.drawLine(
      Offset(centerX, size.height * 0.55),
      Offset(centerX - 40, size.height * 0.40),
      branchPaint,
    );

    // Right branch
    canvas.drawLine(
      Offset(centerX, size.height * 0.50),
      Offset(centerX + 45, size.height * 0.35),
      branchPaint,
    );

    // Canopy (multiple overlapping circles for natural look)
    final canopyPaint = Paint()
      ..color = const Color(0xFF4CAF50).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final canopyPositions = [
      Offset(centerX - 30, size.height * 0.35),
      Offset(centerX + 30, size.height * 0.35),
      Offset(centerX, size.height * 0.25),
      Offset(centerX - 20, size.height * 0.20),
      Offset(centerX + 20, size.height * 0.20),
      Offset(centerX, size.height * 0.40),
      Offset(centerX - 45, size.height * 0.45),
      Offset(centerX + 45, size.height * 0.45),
    ];

    for (final pos in canopyPositions) {
      canvas.drawCircle(pos, 35, canopyPaint);
    }

    // Darker canopy overlay
    final darkCanopyPaint = Paint()
      ..color = const Color(0xFF388E3C).withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, size.height * 0.30), 40, darkCanopyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
