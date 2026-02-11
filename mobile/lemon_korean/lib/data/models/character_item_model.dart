/// Character item data from the catalog (shop/inventory).
class CharacterItemModel {
  final int id;
  final String category;
  final String name;
  final String? description;
  final String assetKey;
  final String assetType; // svg, png
  final bool isBundled;
  final int renderOrder;
  final int price;
  final String rarity; // common, rare, epic, legendary
  final bool isDefault;
  final Map<String, dynamic> metadata;

  CharacterItemModel({
    required this.id,
    required this.category,
    required this.name,
    this.description,
    required this.assetKey,
    this.assetType = 'svg',
    this.isBundled = false,
    this.renderOrder = 0,
    this.price = 0,
    this.rarity = 'common',
    this.isDefault = false,
    this.metadata = const {},
  });

  factory CharacterItemModel.fromJson(Map<String, dynamic> json) {
    return CharacterItemModel(
      id: json['id'] as int,
      category: json['category'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      assetKey: json['asset_key'] as String,
      assetType: json['asset_type'] as String? ?? 'svg',
      isBundled: json['is_bundled'] as bool? ?? false,
      renderOrder: json['render_order'] as int? ?? 0,
      price: json['price'] as int? ?? 0,
      rarity: json['rarity'] as String? ?? 'common',
      isDefault: json['is_default'] as bool? ?? false,
      metadata: json['metadata'] is Map
          ? Map<String, dynamic>.from(json['metadata'] as Map)
          : {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'name': name,
      'description': description,
      'asset_key': assetKey,
      'asset_type': assetType,
      'is_bundled': isBundled,
      'render_order': renderOrder,
      'price': price,
      'rarity': rarity,
      'is_default': isDefault,
      'metadata': metadata,
    };
  }

  /// Whether this is a character part (vs room/pet item)
  bool get isCharacterPart => const [
        'body', 'hair', 'eyes', 'eyebrows', 'nose', 'mouth',
        'top', 'bottom', 'shoes', 'hat', 'accessory',
      ].contains(category);

  /// Whether this is a room decoration item
  bool get isRoomItem => const ['wallpaper', 'floor', 'furniture'].contains(category);
}
