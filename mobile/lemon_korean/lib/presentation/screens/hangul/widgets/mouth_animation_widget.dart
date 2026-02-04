import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Mouth position types for pronunciation visualization
enum MouthPosition {
  closed,
  slightlyOpen,
  open,
  rounded,
  spread,
}

/// Tongue position types for pronunciation visualization
enum TonguePosition {
  tipFront,
  tipBack,
  backRaised,
  flat,
}

/// Air flow types for pronunciation visualization
enum AirFlowType {
  nasal,
  plosive,
  aspirated,
}

/// Pronunciation guide data for a character
class PronunciationGuide {
  final MouthPosition mouthPosition;
  final TonguePosition tonguePosition;
  final AirFlowType? airFlowType;
  final String? mouthShapeUrl;
  final String? tonguePositionUrl;
  final Map<String, String>? nativeComparisons;

  const PronunciationGuide({
    required this.mouthPosition,
    required this.tonguePosition,
    this.airFlowType,
    this.mouthShapeUrl,
    this.tonguePositionUrl,
    this.nativeComparisons,
  });

  /// Get default guides for Korean consonants
  static PronunciationGuide? forConsonant(String character) {
    return _consonantGuides[character];
  }

  /// Get default guides for Korean vowels
  static PronunciationGuide? forVowel(String character) {
    return _vowelGuides[character];
  }

  static const Map<String, PronunciationGuide> _consonantGuides = {
    'ㄱ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.backRaised,
      airFlowType: AirFlowType.plosive,
    ),
    'ㄴ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
      airFlowType: AirFlowType.nasal,
    ),
    'ㄷ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
      airFlowType: AirFlowType.plosive,
    ),
    'ㄹ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipBack,
    ),
    'ㅁ': PronunciationGuide(
      mouthPosition: MouthPosition.closed,
      tonguePosition: TonguePosition.flat,
      airFlowType: AirFlowType.nasal,
    ),
    'ㅂ': PronunciationGuide(
      mouthPosition: MouthPosition.closed,
      tonguePosition: TonguePosition.flat,
      airFlowType: AirFlowType.plosive,
    ),
    'ㅅ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
    ),
    'ㅇ': PronunciationGuide(
      mouthPosition: MouthPosition.open,
      tonguePosition: TonguePosition.flat,
      airFlowType: AirFlowType.nasal,
    ),
    'ㅈ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
      airFlowType: AirFlowType.plosive,
    ),
    'ㅊ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
      airFlowType: AirFlowType.aspirated,
    ),
    'ㅋ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.backRaised,
      airFlowType: AirFlowType.aspirated,
    ),
    'ㅌ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
      airFlowType: AirFlowType.aspirated,
    ),
    'ㅍ': PronunciationGuide(
      mouthPosition: MouthPosition.closed,
      tonguePosition: TonguePosition.flat,
      airFlowType: AirFlowType.aspirated,
    ),
    'ㅎ': PronunciationGuide(
      mouthPosition: MouthPosition.open,
      tonguePosition: TonguePosition.flat,
      airFlowType: AirFlowType.aspirated,
    ),
    // Double consonants
    'ㄲ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.backRaised,
      airFlowType: AirFlowType.plosive,
    ),
    'ㄸ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
      airFlowType: AirFlowType.plosive,
    ),
    'ㅃ': PronunciationGuide(
      mouthPosition: MouthPosition.closed,
      tonguePosition: TonguePosition.flat,
      airFlowType: AirFlowType.plosive,
    ),
    'ㅆ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
    ),
    'ㅉ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.tipFront,
      airFlowType: AirFlowType.plosive,
    ),
  };

  static const Map<String, PronunciationGuide> _vowelGuides = {
    'ㅏ': PronunciationGuide(
      mouthPosition: MouthPosition.open,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅑ': PronunciationGuide(
      mouthPosition: MouthPosition.open,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅓ': PronunciationGuide(
      mouthPosition: MouthPosition.open,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅕ': PronunciationGuide(
      mouthPosition: MouthPosition.open,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅗ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.backRaised,
    ),
    'ㅛ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.backRaised,
    ),
    'ㅜ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.backRaised,
    ),
    'ㅠ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.backRaised,
    ),
    'ㅡ': PronunciationGuide(
      mouthPosition: MouthPosition.spread,
      tonguePosition: TonguePosition.backRaised,
    ),
    'ㅣ': PronunciationGuide(
      mouthPosition: MouthPosition.spread,
      tonguePosition: TonguePosition.tipFront,
    ),
    // Compound vowels
    'ㅐ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅒ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅔ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅖ': PronunciationGuide(
      mouthPosition: MouthPosition.slightlyOpen,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅘ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅙ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅚ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅝ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅞ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.flat,
    ),
    'ㅟ': PronunciationGuide(
      mouthPosition: MouthPosition.rounded,
      tonguePosition: TonguePosition.tipFront,
    ),
    'ㅢ': PronunciationGuide(
      mouthPosition: MouthPosition.spread,
      tonguePosition: TonguePosition.tipFront,
    ),
  };
}

/// Widget for visualizing mouth shape during pronunciation
class MouthAnimationWidget extends StatelessWidget {
  final String character;
  final PronunciationGuide? guide;
  final bool showLabels;

  const MouthAnimationWidget({
    required this.character,
    this.guide,
    this.showLabels = true,
    super.key,
  });

  PronunciationGuide? get _guide =>
      guide ??
      PronunciationGuide.forConsonant(character) ??
      PronunciationGuide.forVowel(character);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final guideData = _guide;

    if (guideData == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.face,
                color: Colors.blue.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.mouthShape,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Visual representation
          Row(
            children: [
              // Mouth diagram
              Expanded(
                child: _buildMouthDiagram(guideData.mouthPosition),
              ),
              const SizedBox(width: 16),
              // Tongue diagram
              Expanded(
                child: _buildTongueDiagram(context, guideData.tonguePosition),
              ),
            ],
          ),

          // Air flow indicator
          if (guideData.airFlowType != null) ...[
            const SizedBox(height: 12),
            _buildAirFlowIndicator(context, guideData.airFlowType!),
          ],

          // Labels
          if (showLabels) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildLabel(
                  _getMouthPositionLabel(context, guideData.mouthPosition),
                  Colors.blue,
                ),
                _buildLabel(
                  _getTonguePositionLabel(context, guideData.tonguePosition),
                  Colors.green,
                ),
                if (guideData.airFlowType != null)
                  _buildLabel(
                    _getAirFlowLabel(context, guideData.airFlowType!),
                    Colors.orange,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMouthDiagram(MouthPosition position) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: CustomPaint(
        painter: _MouthPainter(position),
      ),
    );
  }

  Widget _buildTongueDiagram(BuildContext context, TonguePosition position) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Stack(
        children: [
          CustomPaint(
            size: Size.infinite,
            painter: _TonguePainter(position),
          ),
          Positioned(
            bottom: 4,
            left: 0,
            right: 0,
            child: Text(
              l10n.tonguePosition,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAirFlowIndicator(BuildContext context, AirFlowType type) {
    final l10n = AppLocalizations.of(context)!;
    IconData icon;
    Color color;
    String label;

    switch (type) {
      case AirFlowType.nasal:
        icon = Icons.air;
        color = Colors.purple;
        label = l10n.airFlow;
        break;
      case AirFlowType.plosive:
        icon = Icons.flash_on;
        color = Colors.orange;
        label = l10n.airFlow;
        break;
      case AirFlowType.aspirated:
        icon = Icons.wind_power;
        color = Colors.teal;
        label = l10n.airFlow;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            '$label: ${_getAirFlowLabel(context, type)}',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getMouthPositionLabel(BuildContext context, MouthPosition position) {
    switch (position) {
      case MouthPosition.closed:
        return '입 다문 상태';
      case MouthPosition.slightlyOpen:
        return '살짝 벌림';
      case MouthPosition.open:
        return '크게 벌림';
      case MouthPosition.rounded:
        return '둥글게 (O 모양)';
      case MouthPosition.spread:
        return '양옆으로 벌림';
    }
  }

  String _getTonguePositionLabel(
      BuildContext context, TonguePosition position) {
    switch (position) {
      case TonguePosition.tipFront:
        return '혀끝이 앞에';
      case TonguePosition.tipBack:
        return '혀끝이 뒤에';
      case TonguePosition.backRaised:
        return '혀뒤가 올라감';
      case TonguePosition.flat:
        return '혀가 평평함';
    }
  }

  String _getAirFlowLabel(BuildContext context, AirFlowType type) {
    switch (type) {
      case AirFlowType.nasal:
        return '비음 (코로 나감)';
      case AirFlowType.plosive:
        return '파열음';
      case AirFlowType.aspirated:
        return '기식음 (숨이 나감)';
    }
  }
}

class _MouthPainter extends CustomPainter {
  final MouthPosition position;

  _MouthPainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pink.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = Colors.pink.shade100
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    switch (position) {
      case MouthPosition.closed:
        // Draw closed mouth (line)
        canvas.drawLine(
          Offset(center.dx - 20, center.dy),
          Offset(center.dx + 20, center.dy),
          paint,
        );
        break;

      case MouthPosition.slightlyOpen:
        // Draw slightly open mouth (oval)
        final rect = Rect.fromCenter(center: center, width: 40, height: 15);
        canvas.drawOval(rect, fillPaint);
        canvas.drawOval(rect, paint);
        break;

      case MouthPosition.open:
        // Draw open mouth (large oval)
        final rect = Rect.fromCenter(center: center, width: 40, height: 30);
        canvas.drawOval(rect, fillPaint);
        canvas.drawOval(rect, paint);
        break;

      case MouthPosition.rounded:
        // Draw rounded mouth (circle)
        canvas.drawCircle(center, 18, fillPaint);
        canvas.drawCircle(center, 18, paint);
        break;

      case MouthPosition.spread:
        // Draw spread mouth (wide oval)
        final rect = Rect.fromCenter(center: center, width: 50, height: 12);
        canvas.drawOval(rect, fillPaint);
        canvas.drawOval(rect, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TonguePainter extends CustomPainter {
  final TonguePosition position;

  _TonguePainter(this.position);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.shade400
      ..style = PaintingStyle.fill;

    final outlinePaint = Paint()
      ..color = Colors.red.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Draw mouth cavity outline
    final cavityPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(10, size.height - 20);
    path.quadraticBezierTo(size.width / 2, 10, size.width - 10, size.height - 20);
    canvas.drawPath(path, cavityPaint);

    // Draw tongue based on position
    final tonguePath = Path();
    final baseY = size.height - 25;

    switch (position) {
      case TonguePosition.tipFront:
        tonguePath.moveTo(20, baseY);
        tonguePath.quadraticBezierTo(40, baseY - 20, 60, baseY - 25);
        tonguePath.quadraticBezierTo(70, baseY - 15, size.width - 30, baseY);
        tonguePath.close();
        break;

      case TonguePosition.tipBack:
        tonguePath.moveTo(20, baseY);
        tonguePath.quadraticBezierTo(50, baseY - 10, 70, baseY - 20);
        tonguePath.quadraticBezierTo(85, baseY - 25, size.width - 30, baseY);
        tonguePath.close();
        break;

      case TonguePosition.backRaised:
        tonguePath.moveTo(20, baseY);
        tonguePath.quadraticBezierTo(40, baseY - 5, 60, baseY - 10);
        tonguePath.quadraticBezierTo(80, baseY - 25, size.width - 30, baseY);
        tonguePath.close();
        break;

      case TonguePosition.flat:
        tonguePath.moveTo(20, baseY);
        tonguePath.quadraticBezierTo(size.width / 2, baseY - 5, size.width - 30, baseY);
        tonguePath.close();
        break;
    }

    canvas.drawPath(tonguePath, paint);
    canvas.drawPath(tonguePath, outlinePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
