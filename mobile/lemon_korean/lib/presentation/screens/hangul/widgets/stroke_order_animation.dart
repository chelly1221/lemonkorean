import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:math' as math;

import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/hangul_character_model.dart';
import '../../../../l10n/generated/app_localizations.dart';
import 'hangul_stroke_data.dart';

/// Stroke Order Animation Widget
/// Asset-only mode: plays bundled stroke-order animation when available.
class StrokeOrderAnimation extends StatefulWidget {
  final HangulCharacterModel character;
  final bool showCard;
  final bool showHeader;
  final bool showCanvasFrame;
  final bool showGrid;
  final bool showGuideCharacter;
  final double canvasSize;

  // Kept for compatibility with existing call sites.
  final int strokeDurationMs;
  final int fallbackDurationMs;

  const StrokeOrderAnimation({
    required this.character,
    this.showCard = true,
    this.showHeader = true,
    this.showCanvasFrame = true,
    this.showGrid = true,
    this.showGuideCharacter = true,
    this.canvasSize = 180,
    this.strokeDurationMs = 1200,
    this.fallbackDurationMs = 2600,
    super.key,
  });

  @override
  State<StrokeOrderAnimation> createState() => _StrokeOrderAnimationState();
}

class _StrokeOrderAnimationState extends State<StrokeOrderAnimation> {
  late String _characterKey;
  String? _bundledAssetPath;

  @override
  void initState() {
    super.initState();
    HangulStrokeData.ensureInitialized();
    _characterKey =
        HangulStrokeData.normalizeCharacter(widget.character.character);
    _resolveBundledAsset();
  }

  @override
  void didUpdateWidget(StrokeOrderAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.character.character != widget.character.character ||
        oldWidget.character.strokeOrderUrl != widget.character.strokeOrderUrl) {
      _characterKey =
          HangulStrokeData.normalizeCharacter(widget.character.character);
      _resolveBundledAsset();
    }
  }

  Future<void> _resolveBundledAsset() async {
    final resolved = await _StrokeAssetResolver.resolve(_characterKey);
    if (!mounted) return;
    if (resolved != _bundledAssetPath) {
      setState(() {
        _bundledAssetPath = resolved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final content = Column(
      children: [
        if (widget.showHeader) ...[
          Row(
            children: [
              Icon(
                Icons.edit,
                color: Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.strokeOrder,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                l10n.strokesCount(widget.character.strokeCount),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
        _buildAnimationSurface(),
      ],
    );

    if (!widget.showCard) {
      return content;
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: content,
    );
  }

  Widget _buildAnimationSurface() {
    if (_bundledAssetPath != null) {
      return _buildBundledAsset();
    }
    return _buildMissingAsset();
  }

  Widget _buildBundledAsset() {
    final image = Image.asset(
      _bundledAssetPath!,
      width: widget.canvasSize,
      height: widget.canvasSize,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
      gaplessPlayback: false,
      errorBuilder: (context, error, stackTrace) => _buildMissingAsset(),
    );
    final content = Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(child: image),
        if (widget.showGrid)
          IgnorePointer(
            child: CustomPaint(
              painter: _EightWayGuidePainter(
                color: Colors.grey.shade400.withValues(alpha: 0.45),
              ),
            ),
          ),
      ],
    );

    if (!widget.showCanvasFrame) {
      return SizedBox(
        width: widget.canvasSize,
        height: widget.canvasSize,
        child: content,
      );
    }

    return Container(
      width: widget.canvasSize,
      height: widget.canvasSize,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: content,
      ),
    );
  }

  Widget _buildMissingAsset() {
    final content = Stack(
      fit: StackFit.expand,
      children: [
        if (widget.showGrid)
          CustomPaint(
            painter: _EightWayGuidePainter(
              color: Colors.grey.shade500.withValues(alpha: 0.9),
            ),
          ),
        Center(
          child: Text(
            widget.character.character,
            style: TextStyle(
              fontSize: widget.canvasSize * 0.52,
              height: 1,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2A2A2A),
            ),
          ),
        ),
      ],
    );

    if (!widget.showCanvasFrame) {
      return SizedBox(
        width: widget.canvasSize,
        height: widget.canvasSize,
        child: content,
      );
    }

    return Container(
      width: widget.canvasSize,
      height: widget.canvasSize,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: content,
    );
  }
}

class _EightWayGuidePainter extends CustomPainter {
  final Color color;

  const _EightWayGuidePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;
    _drawDashedLine(canvas, Offset(0, cy), Offset(size.width, cy), paint);
    _drawDashedLine(canvas, Offset(cx, 0), Offset(cx, size.height), paint);
    _drawDashedLine(
        canvas, const Offset(0, 0), Offset(size.width, size.height), paint);
    _drawDashedLine(
        canvas, Offset(size.width, 0), Offset(0, size.height), paint);
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset start,
    Offset end,
    Paint paint,
  ) {
    const dash = 5.0;
    const gap = 3.0;
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    if (distance <= 0) return;

    final ux = dx / distance;
    final uy = dy / distance;
    double progress = 0;

    while (progress < distance) {
      final segStart =
          Offset(start.dx + ux * progress, start.dy + uy * progress);
      final segEndDist = math.min(progress + dash, distance);
      final segEnd =
          Offset(start.dx + ux * segEndDist, start.dy + uy * segEndDist);
      canvas.drawLine(segStart, segEnd, paint);
      progress += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _EightWayGuidePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _StrokeAssetResolver {
  static const String _basePath = 'assets/hangul/stroke_order';

  static Future<String?> resolve(String character) async {
    final code = character.runes.isNotEmpty
        ? character.runes.first.toRadixString(16).padLeft(4, '0')
        : '';
    if (code.isEmpty) return null;

    final candidates = <String>[
      '$_basePath/u$code.webp',
    ];

    for (final path in candidates) {
      try {
        await rootBundle.load(path);
        return path;
      } catch (_) {
        // Try next candidate.
      }
    }
    return null;
  }
}
