import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_constants.dart';
import '../../../data/models/character_item_model.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/character_provider.dart';
import '../../providers/gamification_provider.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabKeys = [
    'hair', 'eyes', 'mouth', 'top', 'bottom',
    'hat', 'accessory', 'pet', 'wallpaper', 'floor', 'furniture',
  ];

  List<(String, String)> _getTabs(AppLocalizations l10n) {
    final labels = {
      'hair': l10n.hair,
      'eyes': l10n.eyes,
      'mouth': l10n.mouth,
      'top': l10n.top,
      'bottom': l10n.bottom,
      'hat': l10n.hatItem,
      'accessory': l10n.accessory,
      'pet': l10n.petItem,
      'wallpaper': l10n.wallpaper,
      'floor': l10n.floorItem,
      'furniture': l10n.furnitureItem,
    };
    return _tabKeys.map((k) => (k, labels[k] ?? k)).toList();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabKeys.length, vsync: this);
    _loadShopItems();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadShopItems() async {
    final provider = Provider.of<CharacterProvider>(context, listen: false);
    await provider.fetchShopItems(null);
  }

  Future<void> _showPurchaseDialog(CharacterItemModel item) async {
    final gamification = Provider.of<GamificationProvider>(context, listen: false);
    final character = Provider.of<CharacterProvider>(context, listen: false);

    final l10n = AppLocalizations.of(context)!;

    if (character.ownsItem(item.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.alreadyOwned)),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Item preview
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: item.isBundled
                  ? Image.asset(
                      item.assetKey,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Icon(Icons.image, size: 40, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 16),
            _buildRarityBadge(item.rarity),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🍋', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 4),
                Text(
                  '${item.price}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.balanceLemons(gamification.totalLemons),
              style: TextStyle(
                color: gamification.totalLemons >= item.price
                    ? Colors.grey
                    : Colors.red,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: gamification.totalLemons >= item.price
                ? () => Navigator.pop(context, true)
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.black87,
            ),
            child: Text(l10n.buy),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final success = await gamification.spendLemons(item.price);
      if (success) {
        await character.purchaseItem(item);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.purchasedItem(item.name))),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.notEnoughLemons)),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<CharacterProvider, GamificationProvider>(
      builder: (context, characterProvider, gamificationProvider, _) {
        final l10n = AppLocalizations.of(context)!;
        final tabs = _getTabs(l10n);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.shop),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: AppConstants.paddingMedium),
                child: Row(
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
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppConstants.primaryColor,
              unselectedLabelColor: Colors.grey,
              tabs: tabs.map((tab) => Tab(text: tab.$2)).toList(),
            ),
          ),
          body: characterProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: tabs.map((tab) {
                    return _buildShopGrid(characterProvider, tab.$1, l10n);
                  }).toList(),
                ),
        );
      },
    );
  }

  Widget _buildShopGrid(CharacterProvider provider, String category, AppLocalizations l10n) {
    final items = provider.getShopItemsByCategory(category);

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.store_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 8),
            Text(
              l10n.comingSoon,
              style: TextStyle(color: Colors.grey.shade500),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final owned = provider.ownsItem(item.id);

        return GestureDetector(
          onTap: owned ? null : () => _showPurchaseDialog(item),
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Preview
                Expanded(
                  child: Container(
                    color: Colors.grey.shade50,
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: item.isBundled
                                ? Image.asset(
                                    item.assetKey,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => Icon(
                                      Icons.image,
                                      size: 40,
                                      color: Colors.grey.shade300,
                                    ),
                                  )
                                : Icon(Icons.image, size: 40, color: Colors.grey.shade400),
                          ),
                        ),
                        // Rarity badge
                        Positioned(
                          top: 6,
                          right: 6,
                          child: _buildRarityBadge(item.rarity),
                        ),
                        // Owned badge
                        if (owned)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                l10n.owned,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Name and price
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      if (owned)
                        Text(
                          l10n.owned,
                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      else if (item.price == 0)
                        Text(
                          l10n.free,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      else
                        Row(
                          children: [
                            const Text('🍋', style: TextStyle(fontSize: 14)),
                            const SizedBox(width: 2),
                            Text(
                              '${item.price}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
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

  Widget _buildRarityBadge(String rarity) {
    final colors = {
      'common': Colors.grey,
      'rare': Colors.blue,
      'epic': Colors.purple,
      'legendary': Colors.orange,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: (colors[rarity] ?? Colors.grey).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: (colors[rarity] ?? Colors.grey).withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        rarity[0].toUpperCase() + rarity.substring(1),
        style: TextStyle(
          color: colors[rarity] ?? Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
