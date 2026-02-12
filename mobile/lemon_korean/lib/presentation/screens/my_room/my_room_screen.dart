import 'dart:async';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/character_item_model.dart';
import '../../../game/core/game_bridge.dart';
import '../../../game/my_room/my_room_game.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/character_provider.dart';
import '../../providers/gamification_provider.dart';
import 'character_editor_screen.dart';
import 'room_editor_screen.dart';
import 'shop_screen.dart';

class MyRoomScreen extends StatefulWidget {
  const MyRoomScreen({super.key});

  @override
  State<MyRoomScreen> createState() => _MyRoomScreenState();
}

class _MyRoomScreenState extends State<MyRoomScreen> {
  MyRoomGame? _game;
  GameBridge? _bridge;
  StreamSubscription? _bridgeSub;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _bridgeSub?.cancel();
    _bridge?.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final characterProvider =
        Provider.of<CharacterProvider>(context, listen: false);
    await characterProvider.loadFromStorage();

    // If no inventory, fetch shop items to get defaults
    if (characterProvider.inventory.isEmpty) {
      final items = await characterProvider.fetchShopItems(null);
      var defaults = items.where((i) => i.isDefault).toList();

      // Fallback to bundled defaults if fetch returned no default items
      if (defaults.isEmpty) {
        defaults = CharacterProvider.bundledDefaults
            .where((i) => i.isDefault)
            .toList();
      }

      if (defaults.isNotEmpty) {
        await characterProvider.initializeDefaults(defaults);
      }
    }

    _initGame(characterProvider);
  }

  void _initGame(CharacterProvider provider) {
    final equippedItems = _getEquippedItems(provider);
    final character = provider.character;

    // Wallpaper / floor asset keys
    final wallpaperId = character.getEquippedItem('wallpaper');
    final floorId = character.getEquippedItem('floor');
    final wallpaperItem =
        wallpaperId != null ? provider.getItemById(wallpaperId) : null;
    final floorItem =
        floorId != null ? provider.getItemById(floorId) : null;

    // Pet asset key
    final petId = character.getEquippedItem('pet');
    final petItem = petId != null ? provider.getItemById(petId) : null;

    _bridge = GameBridge();
    _game = MyRoomGame(
      bridge: _bridge!,
      initialEquippedItems: equippedItems,
      initialSkinColor: character.skinColor,
      wallpaperAssetKey:
          wallpaperItem != null && wallpaperItem.isBundled
              ? wallpaperItem.assetKey
              : null,
      floorAssetKey:
          floorItem != null && floorItem.isBundled
              ? floorItem.assetKey
              : null,
      furnitureData: provider.roomFurniture,
      petAssetKey: petItem?.assetKey,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    return Consumer2<CharacterProvider, GamificationProvider>(
      builder: (context, characterProvider, gamificationProvider, _) {
        // Sync equipment changes to running game
        if (_game != null && !_isLoading) {
          final equippedItems = _getEquippedItems(characterProvider);
          final character = characterProvider.character;
          _game!.updateEquipment(equippedItems, character.skinColor);
        }

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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🍋',
                                style: TextStyle(fontSize: 18)),
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

                // Room area — Flame GameWidget
                Expanded(
                  child: _isLoading || _game == null
                      ? const Center(child: CircularProgressIndicator())
                      : ClipRect(
                          child: GameWidget(game: _game!),
                        ),
                ),

                // Action buttons
                Padding(
                  padding:
                      const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.face,
                          label:
                              AppLocalizations.of(context)!.character,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CharacterEditorScreen(),
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
                              builder: (_) =>
                                  const RoomEditorScreen(),
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
