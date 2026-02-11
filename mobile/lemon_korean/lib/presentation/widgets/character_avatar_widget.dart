import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../data/models/character_item_model.dart';

/// Direction the character is facing.
enum CharacterDirection { front, back, left, right }

/// Renders a character avatar by stacking SVG layers in render order.
///
/// Each equipped item is an SVG on the same 300x400 canvas, layered by
/// render_order (body=0, eyes=20, eyebrows=25, nose=30, mouth=35, hair=40,
/// top=50, bottom=55, shoes=60, hat=70, accessory=80).
class CharacterAvatarWidget extends StatelessWidget {
  final List<CharacterItemModel> equippedItems;
  final double size;
  final String skinColor;
  final CharacterDirection direction;

  /// Categories hidden when facing back (rear view).
  static const _faceCategories = {'eyes', 'eyebrows', 'nose', 'mouth'};

  const CharacterAvatarWidget({
    super.key,
    required this.equippedItems,
    this.size = 200,
    this.skinColor = '#FFDBB4',
    this.direction = CharacterDirection.front,
  });

  @override
  Widget build(BuildContext context) {
    // Sort by render order
    var sorted = List<CharacterItemModel>.from(equippedItems)
      ..sort((a, b) => a.renderOrder.compareTo(b.renderOrder));

    // Back view: hide face layers
    if (direction == CharacterDirection.back) {
      sorted = sorted.where((i) => !_faceCategories.contains(i.category)).toList();
    }

    final aspectRatio = 300.0 / 400.0;
    final width = size * aspectRatio;
    final height = size.toDouble();

    Widget child = SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: sorted.map((item) {
          return Positioned.fill(
            child: _buildItemLayer(item),
          );
        }).toList(),
      ),
    );

    // Left view: mirror horizontally
    if (direction == CharacterDirection.left) {
      child = Transform(
        alignment: Alignment.center,
        transform: Matrix4.diagonal3Values(-1, 1, 1),
        child: child,
      );
    }

    return child;
  }

  Widget _buildItemLayer(CharacterItemModel item) {
    if (item.isBundled) {
      // Load from bundled assets
      return SvgPicture.asset(
        item.assetKey,
        fit: BoxFit.contain,
        // Apply skin color tint for body parts
        colorFilter: item.category == 'body'
            ? ColorFilter.mode(
                _parseColor(skinColor),
                BlendMode.srcIn,
              )
            : null,
      );
    } else {
      // Load from network (MinIO via media service)
      final url = 'https://lemon.3chan.kr/media/${item.assetKey}';
      if (item.assetType == 'svg') {
        return SvgPicture.network(
          url,
          fit: BoxFit.contain,
          placeholderBuilder: (_) => const SizedBox.shrink(),
        );
      } else {
        return Image.network(
          url,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
        );
      }
    }
  }

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
