import 'package:flutter/foundation.dart';

import '../../core/network/api_client.dart';
import '../../core/storage/local_storage.dart'
    if (dart.library.html) '../../core/platform/web/stubs/local_storage_stub.dart';
import '../../data/models/character_item_model.dart';
import '../../data/models/user_character_model.dart';

/// Manages character customization state: equipped items, inventory, shop, and room.
class CharacterProvider with ChangeNotifier {
  static const String _characterBox = 'character_data';
  static const String _inventoryBox = 'character_inventory';
  static const String _shopCacheBox = 'character_items_cache';

  /// Hardcoded defaults matching the DB seed data in 013_add_character_system.sql.
  /// Used as offline fallback when server is unreachable and local cache is empty.
  static const _defaultSpriteMeta = {
    'frameWidth': 32,
    'frameHeight': 48,
    'frameColumns': 5,
    'frameRows': 4,
  };

  static Map<String, dynamic> _spriteMeta(String spritesheetKey) => {
    ..._defaultSpriteMeta,
    'spritesheet_key': spritesheetKey,
  };

  static final List<CharacterItemModel> bundledDefaults = [
    CharacterItemModel(id: 1, category: 'body', name: 'Default Body', assetKey: 'assets/sprites/character/body/body_default.png', assetType: 'spritesheet', isBundled: true, renderOrder: 0, isDefault: true, metadata: _spriteMeta('assets/sprites/character/body/body_default.png')),
    CharacterItemModel(id: 2, category: 'hair', name: 'Short Hair', assetKey: 'assets/sprites/character/hair/hair_short.png', assetType: 'spritesheet', isBundled: true, renderOrder: 40, isDefault: true, metadata: _spriteMeta('assets/sprites/character/hair/hair_short.png')),
    CharacterItemModel(id: 3, category: 'hair', name: 'Long Hair', assetKey: 'assets/character/hair/hair_long.svg', isBundled: true, renderOrder: 40),
    CharacterItemModel(id: 4, category: 'hair', name: 'Curly Hair', assetKey: 'assets/character/hair/hair_curly.svg', isBundled: true, renderOrder: 40),
    CharacterItemModel(id: 5, category: 'eyes', name: 'Round Eyes', assetKey: 'assets/sprites/character/eyes/eyes_round.png', assetType: 'spritesheet', isBundled: true, renderOrder: 20, isDefault: true, metadata: _spriteMeta('assets/sprites/character/eyes/eyes_round.png')),
    CharacterItemModel(id: 6, category: 'eyes', name: 'Almond Eyes', assetKey: 'assets/character/eyes/eyes_almond.svg', isBundled: true, renderOrder: 20),
    CharacterItemModel(id: 7, category: 'eyes', name: 'Happy Eyes', assetKey: 'assets/character/eyes/eyes_happy.svg', isBundled: true, renderOrder: 20),
    CharacterItemModel(id: 8, category: 'eyebrows', name: 'Natural Brows', assetKey: 'assets/sprites/character/eyebrows/eyebrows_natural.png', assetType: 'spritesheet', isBundled: true, renderOrder: 25, isDefault: true, metadata: _spriteMeta('assets/sprites/character/eyebrows/eyebrows_natural.png')),
    CharacterItemModel(id: 9, category: 'eyebrows', name: 'Thick Brows', assetKey: 'assets/character/eyebrows/eyebrows_thick.svg', isBundled: true, renderOrder: 25),
    CharacterItemModel(id: 10, category: 'nose', name: 'Button Nose', assetKey: 'assets/sprites/character/nose/nose_button.png', assetType: 'spritesheet', isBundled: true, renderOrder: 30, isDefault: true, metadata: _spriteMeta('assets/sprites/character/nose/nose_button.png')),
    CharacterItemModel(id: 11, category: 'nose', name: 'Small Nose', assetKey: 'assets/character/nose/nose_small.svg', isBundled: true, renderOrder: 30),
    CharacterItemModel(id: 12, category: 'mouth', name: 'Smile', assetKey: 'assets/sprites/character/mouth/mouth_smile.png', assetType: 'spritesheet', isBundled: true, renderOrder: 35, isDefault: true, metadata: _spriteMeta('assets/sprites/character/mouth/mouth_smile.png')),
    CharacterItemModel(id: 13, category: 'mouth', name: 'Grin', assetKey: 'assets/character/mouth/mouth_grin.svg', isBundled: true, renderOrder: 35),
    CharacterItemModel(id: 14, category: 'top', name: 'Basic T-Shirt', assetKey: 'assets/sprites/character/top/top_tshirt.png', assetType: 'spritesheet', isBundled: true, renderOrder: 50, isDefault: true, metadata: _spriteMeta('assets/sprites/character/top/top_tshirt.png')),
    CharacterItemModel(id: 15, category: 'top', name: 'Hoodie', assetKey: 'assets/character/top/top_hoodie.svg', isBundled: true, renderOrder: 50, price: 10),
    CharacterItemModel(id: 16, category: 'bottom', name: 'Jeans', assetKey: 'assets/character/bottom/bottom_jeans.svg', isBundled: true, renderOrder: 55, isDefault: true),
    CharacterItemModel(id: 17, category: 'bottom', name: 'Shorts', assetKey: 'assets/character/bottom/bottom_shorts.svg', isBundled: true, renderOrder: 55, price: 10),
    CharacterItemModel(id: 18, category: 'wallpaper', name: 'Light Blue Wall', assetKey: 'assets/character/wallpaper/wall_light_blue.svg', isBundled: true, renderOrder: 0, isDefault: true),
    CharacterItemModel(id: 19, category: 'wallpaper', name: 'Warm Yellow Wall', assetKey: 'assets/character/wallpaper/wall_warm_yellow.svg', isBundled: true, renderOrder: 0, price: 15),
    CharacterItemModel(id: 20, category: 'floor', name: 'Wooden Floor', assetKey: 'assets/character/floor/floor_wood.svg', isBundled: true, renderOrder: 0, isDefault: true),
    CharacterItemModel(id: 21, category: 'floor', name: 'Tile Floor', assetKey: 'assets/character/floor/floor_tile.svg', isBundled: true, renderOrder: 0, price: 15),
  ];

  // Current character state
  UserCharacterModel _character = UserCharacterModel();

  // Inventory (owned items)
  final List<CharacterItemModel> _inventory = [];

  // Shop items cache (category -> items)
  final Map<String, List<CharacterItemModel>> _shopItems = {};

  // Item catalog cache (id -> item)
  final Map<int, CharacterItemModel> _itemsById = {};

  // Room furniture
  final List<Map<String, dynamic>> _roomFurniture = [];

  bool _isLoading = false;

  // Getters
  UserCharacterModel get character => _character;
  List<CharacterItemModel> get inventory => List.unmodifiable(_inventory);
  List<Map<String, dynamic>> get roomFurniture => List.unmodifiable(_roomFurniture);
  bool get isLoading => _isLoading;

  CharacterItemModel? getItemById(int id) => _itemsById[id];

  List<CharacterItemModel> getInventoryByCategory(String category) {
    return _inventory.where((item) => item.category == category).toList();
  }

  List<CharacterItemModel> getShopItemsByCategory(String category) {
    return _shopItems[category] ?? [];
  }

  bool ownsItem(int itemId) {
    return _inventory.any((item) => item.id == itemId);
  }

  /// Load character data from local storage and sync with server
  Future<void> loadFromStorage() async {
    // Load character from local storage
    final charData = LocalStorage.getFromBox<Map>(_characterBox, 'equipped');
    if (charData != null) {
      _character = UserCharacterModel.fromJson(Map<String, dynamic>.from(charData));
    }

    // Load inventory from local storage
    final invItems = LocalStorage.getAllFromBox<Map>(_inventoryBox);
    _inventory.clear();
    for (final raw in invItems) {
      try {
        final item = CharacterItemModel.fromJson(Map<String, dynamic>.from(raw));
        _inventory.add(item);
        _itemsById[item.id] = item;
      } catch (e) {
        debugPrint('[Character] Failed to parse inventory item: $e');
      }
    }

    // Fetch from server (best-effort)
    await _fetchFromServer();

    notifyListeners();
  }

  /// Fetch character and inventory from server
  Future<void> _fetchFromServer() async {
    final userId = LocalStorage.getUserId();
    if (userId == null) return;

    try {
      await ApiClient.instance.ensureInitialized();
      final dio = ApiClient.instance.dio;

      await Future.wait([
        _fetchCharacterFromServer(dio, userId),
        _fetchInventoryFromServer(dio, userId),
      ]);
    } catch (e) {
      debugPrint('[Character] Failed to fetch from server: $e');
    }
  }

  Future<void> _fetchCharacterFromServer(dynamic dio, int userId) async {
    try {
      final response = await dio.get('/progress/character/$userId');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        _character = UserCharacterModel.fromJson(data);
        await LocalStorage.saveToBox(_characterBox, 'equipped', _character.toJson());
      }
    } catch (e) {
      debugPrint('[Character] Failed to fetch character: $e');
    }
  }

  Future<void> _fetchInventoryFromServer(dynamic dio, int userId) async {
    try {
      final response = await dio.get('/progress/inventory/$userId');
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final items = (data['items'] as List)
            .map((json) => CharacterItemModel.fromJson(json as Map<String, dynamic>))
            .toList();

        _inventory.clear();
        for (final item in items) {
          _inventory.add(item);
          _itemsById[item.id] = item;
          await LocalStorage.saveToBox(_inventoryBox, 'item_${item.id}', item.toJson());
        }
      }
    } catch (e) {
      debugPrint('[Character] Failed to fetch inventory: $e');
    }
  }

  /// Equip an item on the character
  Future<void> equipItem(String category, int itemId) async {
    // Update local state
    _character = _character.copyWithEquipped(category, itemId);

    // Save to local storage
    await LocalStorage.saveToBox(_characterBox, 'equipped', _character.toJson());

    // Add to sync queue
    await LocalStorage.addToSyncQueue({
      'type': 'character_equip',
      'data': {
        'category': category,
        'item_id': itemId,
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
  }

  /// Unequip an item from a category
  Future<void> unequipItem(String category) async {
    _character = _character.copyWithEquipped(category, null);

    await LocalStorage.saveToBox(_characterBox, 'equipped', _character.toJson());

    await LocalStorage.addToSyncQueue({
      'type': 'character_equip',
      'data': {
        'category': category,
        'item_id': null,
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
  }

  /// Change skin color
  Future<void> updateSkinColor(String hexColor) async {
    _character = _character.copyWithSkinColor(hexColor);

    await LocalStorage.saveToBox(_characterBox, 'equipped', _character.toJson());

    await LocalStorage.addToSyncQueue({
      'type': 'character_equip',
      'data': {
        'skin_color': hexColor,
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
  }

  /// Purchase an item (called after GamificationProvider.spendLemons succeeds)
  Future<bool> purchaseItem(CharacterItemModel item) async {
    if (ownsItem(item.id)) return false;

    // Add to local inventory
    _inventory.add(item);
    _itemsById[item.id] = item;

    // Save to local storage
    await LocalStorage.saveToBox(_inventoryBox, 'item_${item.id}', item.toJson());

    // Add to sync queue
    await LocalStorage.addToSyncQueue({
      'type': 'character_purchase',
      'data': {
        'item_id': item.id,
        'price': item.price,
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
    return true;
  }

  /// Fetch shop items by category
  Future<List<CharacterItemModel>> fetchShopItems(String? category) async {
    if (category != null && _shopItems.containsKey(category)) {
      return _shopItems[category]!;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await ApiClient.instance.ensureInitialized();
      final dio = ApiClient.instance.dio;
      final queryParams = <String, dynamic>{};
      if (category != null) queryParams['category'] = category;

      final response = await dio.get(
        '/progress/shop/items',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final itemsList = (data['items'] as List)
            .map((json) => CharacterItemModel.fromJson(json as Map<String, dynamic>))
            .toList();

        // Cache by category
        if (category != null) {
          _shopItems[category] = itemsList;
        } else {
          // Group by category
          for (final item in itemsList) {
            _shopItems.putIfAbsent(item.category, () => []).add(item);
            _itemsById[item.id] = item;
          }
        }

        // Save to local cache
        for (final item in itemsList) {
          await LocalStorage.saveToBox(_shopCacheBox, 'item_${item.id}', item.toJson());
          _itemsById[item.id] = item;
        }

        return itemsList;
      }
    } catch (e) {
      debugPrint('[Character] Failed to fetch shop items: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Fall back to local cache
    final cached = LocalStorage.getAllFromBox<Map>(_shopCacheBox);
    if (cached.isNotEmpty) {
      final items = <CharacterItemModel>[];
      for (final raw in cached) {
        try {
          final item = CharacterItemModel.fromJson(Map<String, dynamic>.from(raw));
          if (category == null || item.category == category) {
            items.add(item);
          }
          _itemsById[item.id] = item;
        } catch (_) {}
      }
      if (items.isNotEmpty) return items;
    }

    // Final fallback: bundled defaults (offline-first)
    for (final item in bundledDefaults) {
      _itemsById[item.id] = item;
    }
    if (category != null) {
      return bundledDefaults.where((i) => i.category == category).toList();
    }
    return List.of(bundledDefaults);
  }

  /// Update room furniture layout
  Future<void> updateRoomFurniture(List<Map<String, dynamic>> furniture) async {
    _roomFurniture.clear();
    _roomFurniture.addAll(furniture);

    await LocalStorage.saveToBox(_characterBox, 'room_furniture', {
      'furniture': furniture,
    });

    await LocalStorage.addToSyncQueue({
      'type': 'room_update',
      'data': {
        'furniture': furniture,
      },
      'created_at': DateTime.now().toIso8601String(),
    });

    notifyListeners();
  }

  /// Initialize with default items for new user
  Future<void> initializeDefaults(List<CharacterItemModel> defaultItems) async {
    for (final item in defaultItems) {
      if (!ownsItem(item.id)) {
        _inventory.add(item);
        _itemsById[item.id] = item;
        await LocalStorage.saveToBox(_inventoryBox, 'item_${item.id}', item.toJson());
      }

      if (item.isDefault) {
        _character = _character.copyWithEquipped(item.category, item.id);
      }
    }

    await LocalStorage.saveToBox(_characterBox, 'equipped', _character.toJson());
    notifyListeners();
  }
}
