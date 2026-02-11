import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/character_item_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/character_provider.dart';
import '../../providers/gamification_provider.dart';
import '../../widgets/character_avatar_widget.dart';
import 'character_editor_screen.dart';
import 'room_editor_screen.dart';
import 'shop_screen.dart';

class MyRoomScreen extends StatefulWidget {
  const MyRoomScreen({super.key});

  @override
  State<MyRoomScreen> createState() => _MyRoomScreenState();
}

class _MyRoomScreenState extends State<MyRoomScreen>
    with SingleTickerProviderStateMixin {
  // Walking animation state
  late AnimationController _walkController;
  Offset _characterPosition = const Offset(0.5, 0.78); // normalized coords
  Offset _walkStart = Offset.zero;
  Offset _walkTarget = Offset.zero;
  CharacterDirection _walkDirection = CharacterDirection.front;
  bool _isWalking = false;

  // Constants
  static const double _characterSize = 300.0;
  static const double _walkSpeed = 250.0; // px/sec
  static const double _bobAmplitude = 6.0; // bounce height (px)
  static const double _bobFrequency = 8.0; // bounce cycles during walk
  static const double _floorTopFraction = 0.65;
  static const double _floorBottomFraction = 0.92;

  @override
  void initState() {
    super.initState();
    _walkController = AnimationController(vsync: this);
    _walkController.addListener(() => setState(() {}));
    _walkController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _isWalking = false;
        _characterPosition = _walkTarget;
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _walkController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final characterProvider = Provider.of<CharacterProvider>(context, listen: false);
    await characterProvider.loadFromStorage();

    // If no inventory, fetch shop items to get defaults
    if (characterProvider.inventory.isEmpty) {
      final items = await characterProvider.fetchShopItems(null);
      var defaults = items.where((i) => i.isDefault).toList();

      // Fallback to bundled defaults if fetch returned no default items
      if (defaults.isEmpty) {
        defaults = CharacterProvider.bundledDefaults.where((i) => i.isDefault).toList();
      }

      if (defaults.isNotEmpty) {
        await characterProvider.initializeDefaults(defaults);
      }
    }
  }

  List<CharacterItemModel> _getEquippedItems(CharacterProvider provider) {
    final items = <CharacterItemModel>[];
    final character = provider.character;

    for (final entry in character.equippedItems.entries) {
      final itemId = entry.value;
      if (itemId != null) {
        final item = provider.getItemById(itemId);
        if (item != null) {
          items.add(item);
        }
      }
    }

    return items;
  }

  void _onRoomTap(TapUpDetails details, Size roomSize) {
    final tapX = details.localPosition.dx / roomSize.width;
    final tapY = details.localPosition.dy / roomSize.height;

    // Ignore taps above the floor area
    if (tapY < _floorTopFraction - 0.05) return;

    // Clamp target within walkable floor area
    final halfCharW = (_characterSize * 0.5) / roomSize.width;
    final targetX = tapX.clamp(halfCharW, 1.0 - halfCharW);
    final targetY = tapY.clamp(_floorTopFraction, _floorBottomFraction);

    // Current position (if mid-walk, use interpolated position)
    final currentPos = _isWalking
        ? Offset(
            _lerpDouble(_walkStart.dx, _walkTarget.dx,
                Curves.easeInOut.transform(_walkController.value)),
            _lerpDouble(_walkStart.dy, _walkTarget.dy,
                Curves.easeInOut.transform(_walkController.value)),
          )
        : _characterPosition;

    // Determine 4-way direction based on dominant axis
    final dirDx = targetX - currentPos.dx;
    final dirDy = targetY - currentPos.dy;
    if (dirDx.abs() >= dirDy.abs()) {
      _walkDirection = dirDx < 0 ? CharacterDirection.left : CharacterDirection.right;
    } else {
      _walkDirection = dirDy < 0 ? CharacterDirection.back : CharacterDirection.front;
    }

    // Distance in pixels for duration calculation
    final distDx = dirDx * roomSize.width;
    final distDy = dirDy * roomSize.height;
    final distPx = sqrt(distDx * distDx + distDy * distDy);
    final durationMs = (distPx / _walkSpeed * 1000).clamp(200.0, 3000.0);

    _walkStart = currentPos;
    _walkTarget = Offset(targetX, targetY);
    _isWalking = true;

    _walkController.duration = Duration(milliseconds: durationMs.round());
    _walkController.forward(from: 0.0);
  }

  double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  Offset _getCurrentCharacterOffset(Size roomSize) {
    if (!_isWalking) {
      // Static position: center-bottom anchor
      final left =
          _characterPosition.dx * roomSize.width - _characterSize / 2;
      final top =
          _characterPosition.dy * roomSize.height - _characterSize;
      return Offset(left, top);
    }

    final t = Curves.easeInOut.transform(_walkController.value);
    final x = _lerpDouble(_walkStart.dx, _walkTarget.dx, t);
    final y = _lerpDouble(_walkStart.dy, _walkTarget.dy, t);

    // Bobbing: sin-based, abs ensures always upward, zero at start/end
    final bob =
        sin(t * _bobFrequency * 2 * pi).abs() * _bobAmplitude;

    final left = x * roomSize.width - _characterSize / 2;
    final top = y * roomSize.height - _characterSize - bob;
    return Offset(left, top);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CharacterProvider, GamificationProvider>(
      builder: (context, characterProvider, gamificationProvider, _) {
        final equippedItems = _getEquippedItems(characterProvider);
        final character = characterProvider.character;

        // Get wallpaper and floor items
        final wallpaperId = character.getEquippedItem('wallpaper');
        final floorId = character.getEquippedItem('floor');
        final wallpaperItem = wallpaperId != null ? characterProvider.getItemById(wallpaperId) : null;
        final floorItem = floorId != null ? characterProvider.getItemById(floorId) : null;

        // Character items only (not room items)
        final characterItems = equippedItems.where((i) => i.isCharacterPart).toList();

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Top bar with lemon balance
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium,
                    vertical: AppConstants.paddingSmall,
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.myRoom,
                        style: const TextStyle(
                          fontSize: AppConstants.fontSizeXLarge,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🍋', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 4),
                            Text(
                              '${gamificationProvider.totalLemons}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Room area
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final roomSize = Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      );
                      final charOffset =
                          _getCurrentCharacterOffset(roomSize);

                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTapUp: (details) =>
                            _onRoomTap(details, roomSize),
                        child: Stack(
                          clipBehavior: Clip.hardEdge,
                          children: [
                            // Wallpaper
                            if (wallpaperItem != null &&
                                wallpaperItem.isBundled)
                              Positioned.fill(
                                child: SvgPicture.asset(
                                  wallpaperItem.assetKey,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xFFD6EAF8),
                                        Color(0xFFEBF5FB),
                                      ],
                                      stops: [0.0, 0.65],
                                    ),
                                  ),
                                ),
                              ),

                            // Floor
                            if (floorItem != null && floorItem.isBundled)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: roomSize.height * 0.35,
                                child: SvgPicture.asset(
                                  floorItem.assetKey,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: roomSize.height * 0.35,
                                child: Container(
                                    color: const Color(0xFFDEB887)),
                              ),

                            // Room furniture
                            for (final furniture
                                in characterProvider.roomFurniture)
                              if (furniture['position_x'] != null)
                                Positioned(
                                  left:
                                      (furniture['position_x'] as double) *
                                          roomSize.width,
                                  top:
                                      (furniture['position_y'] as double) *
                                          roomSize.height,
                                  child: const SizedBox(
                                      width: 60, height: 60),
                                ),

                            // Character (positioned, walkable)
                            Positioned(
                              left: charOffset.dx,
                              top: charOffset.dy,
                              child: CharacterAvatarWidget(
                                equippedItems: characterItems,
                                size: _characterSize,
                                skinColor: character.skinColor,
                                direction: _walkDirection,
                              ),
                            ),

                            // Pet (bottom-right of character)
                            if (character.getEquippedItem('pet') != null)
                              Positioned(
                                bottom: 80,
                                right: roomSize.width * 0.2,
                                child:
                                    const SizedBox(width: 60, height: 60),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.face,
                          label: AppLocalizations.of(context)!.character,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CharacterEditorScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.weekend,
                          label: AppLocalizations.of(context)!.room,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RoomEditorScreen(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.shopping_bag,
                          label: AppLocalizations.of(context)!.shop,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ShopScreen(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppConstants.primaryColor.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppConstants.primaryColor),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
