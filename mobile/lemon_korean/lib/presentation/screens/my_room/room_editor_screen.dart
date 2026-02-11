import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/character_item_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/character_provider.dart';

class RoomEditorScreen extends StatefulWidget {
  const RoomEditorScreen({super.key});

  @override
  State<RoomEditorScreen> createState() => _RoomEditorScreenState();
}

class _RoomEditorScreenState extends State<RoomEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int? _selectedWallpaper;
  int? _selectedFloor;
  int? _selectedPet;

  static const _tabKeys = [
    ('wallpaper', Icons.wallpaper),
    ('floor', Icons.grid_on),
    ('pet', Icons.pets),
  ];

  List<(String, String, IconData)> _getTabs(AppLocalizations l10n) {
    final labels = {
      'wallpaper': l10n.wallpaper,
      'floor': l10n.floorItem,
      'pet': l10n.petItem,
    };
    return _tabKeys.map((t) => (t.$1, labels[t.$1] ?? t.$1, t.$2)).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabKeys.length, vsync: this);

    final provider = Provider.of<CharacterProvider>(context, listen: false);
    _selectedWallpaper = provider.character.getEquippedItem('wallpaper');
    _selectedFloor = provider.character.getEquippedItem('floor');
    _selectedPet = provider.character.getEquippedItem('pet');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final provider = Provider.of<CharacterProvider>(context, listen: false);

    if (_selectedWallpaper != null &&
        _selectedWallpaper != provider.character.getEquippedItem('wallpaper')) {
      await provider.equipItem('wallpaper', _selectedWallpaper!);
    }
    if (_selectedFloor != null &&
        _selectedFloor != provider.character.getEquippedItem('floor')) {
      await provider.equipItem('floor', _selectedFloor!);
    }
    if (_selectedPet != provider.character.getEquippedItem('pet')) {
      if (_selectedPet != null) {
        await provider.equipItem('pet', _selectedPet!);
      } else {
        await provider.unequipItem('pet');
      }
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tabs = _getTabs(l10n);

    return Consumer<CharacterProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.roomEditor),
            actions: [
              TextButton(
                onPressed: _save,
                child: Text(
                  l10n.save,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: tabs.map((tab) {
                return Tab(icon: Icon(tab.$3, size: 20), text: tab.$2);
              }).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildItemGrid(provider, 'wallpaper', _selectedWallpaper, (id) {
                setState(() => _selectedWallpaper = id);
              }, l10n),
              _buildItemGrid(provider, 'floor', _selectedFloor, (id) {
                setState(() => _selectedFloor = id);
              }, l10n),
              _buildItemGrid(provider, 'pet', _selectedPet, (id) {
                setState(() => _selectedPet = id);
              }, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItemGrid(
    CharacterProvider provider,
    String category,
    int? selectedId,
    ValueChanged<int?> onSelect,
    AppLocalizations l10n,
  ) {
    final items = provider.getInventoryByCategory(category);

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
      itemCount: items.length + 1, // +1 for "None"
      itemBuilder: (context, index) {
        if (index == 0) {
          final isSelected = selectedId == null;
          return _buildNoneOption(isSelected, () => onSelect(null));
        }

        final item = items[index - 1];
        final isSelected = selectedId == item.id;

        return GestureDetector(
          onTap: () => onSelect(item.id),
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

  Widget _buildNoneOption(bool isSelected, VoidCallback onTap) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
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
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
