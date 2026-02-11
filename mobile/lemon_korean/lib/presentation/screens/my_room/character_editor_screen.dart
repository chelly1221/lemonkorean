import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/character_item_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/character_provider.dart';
import '../../widgets/character_avatar_widget.dart';

class CharacterEditorScreen extends StatefulWidget {
  const CharacterEditorScreen({super.key});

  @override
  State<CharacterEditorScreen> createState() => _CharacterEditorScreenState();
}

class _CharacterEditorScreenState extends State<CharacterEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _categoryKeys = [
    ('hair', Icons.content_cut),
    ('eyes', Icons.visibility),
    ('eyebrows', Icons.remove_red_eye_outlined),
    ('nose', Icons.face),
    ('mouth', Icons.sentiment_satisfied),
    ('top', Icons.checkroom),
    ('bottom', Icons.accessibility_new),
    ('hat', Icons.shopping_bag),
    ('accessory', Icons.watch),
  ];

  List<(String, String, IconData)> _getCategories(AppLocalizations l10n) {
    final labels = {
      'hair': l10n.hair,
      'eyes': l10n.eyes,
      'eyebrows': l10n.brows,
      'nose': l10n.nose,
      'mouth': l10n.mouth,
      'top': l10n.top,
      'bottom': l10n.bottom,
      'hat': l10n.hatItem,
      'accessory': l10n.accessory,
    };
    return _categoryKeys.map((c) => (c.$1, labels[c.$1] ?? c.$1, c.$2)).toList();
  }

  // Preview state (not yet saved)
  Map<String, int?> _previewEquipped = {};
  String _previewSkinColor = '#FFDBB4';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categoryKeys.length, vsync: this);

    // Initialize preview from current character
    final provider = Provider.of<CharacterProvider>(context, listen: false);
    _previewEquipped = Map.from(provider.character.equippedItems);
    _previewSkinColor = provider.character.skinColor;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<CharacterItemModel> _getPreviewItems(CharacterProvider provider) {
    final items = <CharacterItemModel>[];
    for (final entry in _previewEquipped.entries) {
      final itemId = entry.value;
      if (itemId != null) {
        final item = provider.getItemById(itemId);
        if (item != null && item.isCharacterPart) {
          items.add(item);
        }
      }
    }
    return items;
  }

  Future<void> _save() async {
    final provider = Provider.of<CharacterProvider>(context, listen: false);

    // Apply all changes
    for (final entry in _previewEquipped.entries) {
      if (entry.value != provider.character.getEquippedItem(entry.key)) {
        if (entry.value != null) {
          await provider.equipItem(entry.key, entry.value!);
        } else {
          await provider.unequipItem(entry.key);
        }
      }
    }

    if (_previewSkinColor != provider.character.skinColor) {
      await provider.updateSkinColor(_previewSkinColor);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CharacterProvider>(
      builder: (context, provider, _) {
        final previewItems = _getPreviewItems(provider);

        final l10n = AppLocalizations.of(context)!;
        final categories = _getCategories(l10n);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.characterEditor),
            actions: [
              TextButton(
                onPressed: _save,
                child: Text(
                  l10n.save,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              // Character preview
              Container(
                height: 260,
                width: double.infinity,
                color: Colors.grey.shade100,
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Expanded(
                      child: CharacterAvatarWidget(
                        equippedItems: previewItems,
                        size: 220,
                        skinColor: _previewSkinColor,
                      ),
                    ),
                    // Skin color selector
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (final color in [
                            '#FFDBB4', '#F5C5A3', '#E8B08C', '#C68642',
                            '#8D5524', '#5C3317',
                          ])
                            GestureDetector(
                              onTap: () => setState(() => _previewSkinColor = color),
                              child: Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: _parseColor(color),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: _previewSkinColor == color
                                        ? AppConstants.primaryColor
                                        : Colors.grey.shade300,
                                    width: _previewSkinColor == color ? 3 : 1,
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

              // Category tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: AppConstants.primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: categories.map((cat) {
                  return Tab(
                    icon: Icon(cat.$3, size: 20),
                    text: cat.$2,
                  );
                }).toList(),
              ),

              // Items grid
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: categories.map((cat) {
                    return _buildCategoryGrid(provider, cat.$1, l10n);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryGrid(CharacterProvider provider, String category, AppLocalizations l10n) {
    final items = provider.getInventoryByCategory(category);
    final selectedId = _previewEquipped[category];

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              l10n.noItemsYet,
              style: TextStyle(color: Colors.grey.shade500),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.visitShopToGetItems,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: items.length + 1, // +1 for "None" option
      itemBuilder: (context, index) {
        if (index == 0) {
          // None / unequip option
          final isSelected = selectedId == null;
          return GestureDetector(
            onTap: () => setState(() => _previewEquipped[category] = null),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                color: isSelected
                    ? AppConstants.primaryColor.withValues(alpha: 0.1)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.block, color: Colors.grey.shade400),
                  const SizedBox(height: 4),
                  Text(
                    l10n.none,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final item = items[index - 1];
        final isSelected = selectedId == item.id;

        return GestureDetector(
          onTap: () => setState(() => _previewEquipped[category] = item.id),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppConstants.primaryColor : Colors.grey.shade300,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
              color: isSelected
                  ? AppConstants.primaryColor.withValues(alpha: 0.1)
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: item.isBundled
                        ? Image.asset(
                            item.assetKey,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) =>
                                Icon(Icons.image, color: Colors.grey.shade300),
                          )
                        : Icon(Icons.image, color: Colors.grey.shade400),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 10),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
