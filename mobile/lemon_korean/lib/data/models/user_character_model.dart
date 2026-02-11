/// User's equipped character items and skin color.
class UserCharacterModel {
  final Map<String, int?> equippedItems; // category -> item_id
  final String skinColor;

  UserCharacterModel({
    Map<String, int?>? equippedItems,
    this.skinColor = '#FFDBB4',
  }) : equippedItems = equippedItems ?? {};

  factory UserCharacterModel.fromJson(Map<String, dynamic> json) {
    final equipped = json['equipped'] as Map<String, dynamic>? ?? {};
    final map = <String, int?>{};
    for (final entry in equipped.entries) {
      map[entry.key] = entry.value as int?;
    }

    return UserCharacterModel(
      equippedItems: map,
      skinColor: json['skin_color'] as String? ?? '#FFDBB4',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipped': equippedItems,
      'skin_color': skinColor,
    };
  }

  int? getEquippedItem(String category) => equippedItems[category];

  UserCharacterModel copyWithEquipped(String category, int? itemId) {
    final newMap = Map<String, int?>.from(equippedItems);
    newMap[category] = itemId;
    return UserCharacterModel(
      equippedItems: newMap,
      skinColor: skinColor,
    );
  }

  UserCharacterModel copyWithSkinColor(String newColor) {
    return UserCharacterModel(
      equippedItems: Map<String, int?>.from(equippedItems),
      skinColor: newColor,
    );
  }
}
