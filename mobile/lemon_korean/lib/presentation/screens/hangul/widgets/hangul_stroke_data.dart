// Hangul stroke order data using region-based clip/reveal approach.
// Each stroke is defined as a normalized rectangle (0.0–1.0) plus a wipe
// direction. The animation reveals the actual font-rendered character by
// progressively unmasking each region in stroke order.

enum WipeDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
  topLeftToBottomRight,
  topRightToBottomLeft,
  radial,
}

class StrokeRegion {
  final double left, top, right, bottom;
  final WipeDirection direction;

  const StrokeRegion(
      this.left, this.top, this.right, this.bottom, this.direction);

  /// Remap X coordinates from [0..1] into [minX..maxX].
  StrokeRegion scaleX(double minX, double maxX) {
    final range = maxX - minX;
    return StrokeRegion(
      minX + left * range,
      top,
      minX + right * range,
      bottom,
      direction,
    );
  }
}

class HangulStrokeData {
  HangulStrokeData._();

  // ───────────────────────── Public API ─────────────────────────

  static String normalizeCharacter(String character) {
    final trimmed = character.trim();
    if (trimmed.isEmpty) return trimmed;

    // Normalize modern Jamo blocks (U+1100/U+1160) to compatibility jamo
    // used by this stroke table (e.g. ᄀ -> ㄱ, ᅡ -> ㅏ).
    const compatMap = <String, String>{
      // Consonants (choseong)
      'ᄀ': 'ㄱ',
      'ᄁ': 'ㄲ',
      'ᄂ': 'ㄴ',
      'ᄃ': 'ㄷ',
      'ᄄ': 'ㄸ',
      'ᄅ': 'ㄹ',
      'ᄆ': 'ㅁ',
      'ᄇ': 'ㅂ',
      'ᄈ': 'ㅃ',
      'ᄉ': 'ㅅ',
      'ᄊ': 'ㅆ',
      'ᄋ': 'ㅇ',
      'ᄌ': 'ㅈ',
      'ᄍ': 'ㅉ',
      'ᄎ': 'ㅊ',
      'ᄏ': 'ㅋ',
      'ᄐ': 'ㅌ',
      'ᄑ': 'ㅍ',
      'ᄒ': 'ㅎ',
      // Vowels (jungseong)
      'ᅡ': 'ㅏ',
      'ᅢ': 'ㅐ',
      'ᅣ': 'ㅑ',
      'ᅤ': 'ㅒ',
      'ᅥ': 'ㅓ',
      'ᅦ': 'ㅔ',
      'ᅧ': 'ㅕ',
      'ᅨ': 'ㅖ',
      'ᅩ': 'ㅗ',
      'ᅪ': 'ㅘ',
      'ᅫ': 'ㅙ',
      'ᅬ': 'ㅚ',
      'ᅭ': 'ㅛ',
      'ᅮ': 'ㅜ',
      'ᅯ': 'ㅝ',
      'ᅰ': 'ㅞ',
      'ᅱ': 'ㅟ',
      'ᅲ': 'ㅠ',
      'ᅳ': 'ㅡ',
      'ᅴ': 'ㅢ',
      'ᅵ': 'ㅣ',
    };

    return compatMap[trimmed] ?? trimmed;
  }

  static bool hasData(String character) =>
      _regionData.containsKey(normalizeCharacter(character));

  static int getStrokeCount(String character) =>
      _regionData[normalizeCharacter(character)]?.length ?? 0;

  static List<StrokeRegion> getRegions(String character) =>
      _regionData[normalizeCharacter(character)] ?? [];

  // ───────────── Double-consonant helper ─────────────────

  static List<StrokeRegion> _double(List<StrokeRegion> base) {
    final left = base.map((r) => r.scaleX(0.0, 0.47)).toList();
    final right = base.map((r) => r.scaleX(0.53, 1.0)).toList();
    return [...left, ...right];
  }

  // ═══════════════════════════════════════════════════════════
  //  REGION DATA  (normalised 0.0 – 1.0)
  // ═══════════════════════════════════════════════════════════

  // Shorthand aliases for readability
  static const _lr = WipeDirection.leftToRight;
  static const _rl = WipeDirection.rightToLeft;
  static const _tb = WipeDirection.topToBottom;
  static const _bt = WipeDirection.bottomToTop;
  static const _tlbr = WipeDirection.topLeftToBottomRight;
  static const _trbl = WipeDirection.topRightToBottomLeft;
  static const _rad = WipeDirection.radial;

  static final Map<String, List<StrokeRegion>> _regionData = {
    // ─────────── Basic Consonants (14) ───────────

    // ㄱ (2): horizontal top, vertical right
    'ㄱ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.45, _lr),
      StrokeRegion(0.55, 0.0, 1.0, 1.0, _tb),
    ],

    // ㄴ (2): vertical left, horizontal bottom
    'ㄴ': const [
      StrokeRegion(0.06, 0.02, 0.42, 1.0, _tb),
      StrokeRegion(0.0, 0.62, 1.0, 0.96, _lr),
    ],

    // ㄷ (3): horizontal top, vertical left, horizontal bottom
    'ㄷ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.4, _lr),
      StrokeRegion(0.0, 0.0, 0.45, 1.0, _tb),
      StrokeRegion(0.0, 0.6, 1.0, 1.0, _lr),
    ],

    // ㄹ (5): h→v→h(RL)→v→h
    'ㄹ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.25, _lr),
      StrokeRegion(0.55, 0.0, 1.0, 0.45, _tb),
      StrokeRegion(0.0, 0.25, 1.0, 0.5, _rl),
      StrokeRegion(0.0, 0.35, 0.45, 0.7, _tb),
      StrokeRegion(0.0, 0.5, 1.0, 0.75, _lr),
    ],

    // ㅁ (4): left-v, top-h, right-v, bottom-h
    'ㅁ': const [
      StrokeRegion(0.0, 0.0, 0.4, 1.0, _tb),
      StrokeRegion(0.0, 0.0, 1.0, 0.4, _lr),
      StrokeRegion(0.6, 0.0, 1.0, 1.0, _tb),
      StrokeRegion(0.0, 0.6, 1.0, 1.0, _lr),
    ],

    // ㅂ (4): left-v, right-v, mid-h, bottom-h
    'ㅂ': const [
      StrokeRegion(0.0, 0.0, 0.4, 1.0, _tb),
      StrokeRegion(0.6, 0.0, 1.0, 1.0, _tb),
      StrokeRegion(0.0, 0.35, 1.0, 0.65, _lr),
      StrokeRegion(0.0, 0.65, 1.0, 1.0, _lr),
    ],

    // ㅅ (2): left-diag, right-diag
    'ㅅ': const [
      StrokeRegion(0.0, 0.0, 0.55, 1.0, _tlbr),
      StrokeRegion(0.45, 0.0, 1.0, 1.0, _trbl),
    ],

    // ㅇ (1): circle
    'ㅇ': const [
      StrokeRegion(0.0, 0.0, 1.0, 1.0, _rad),
    ],

    // ㅈ (3): top-h, left-diag, right-diag
    'ㅈ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.35, _lr),
      StrokeRegion(0.0, 0.2, 0.55, 1.0, _tlbr),
      StrokeRegion(0.45, 0.2, 1.0, 1.0, _trbl),
    ],

    // ㅊ (4): short top tick, horizontal, left-diag, right-diag
    'ㅊ': const [
      StrokeRegion(0.35, 0.0, 0.65, 0.25, _tb),
      StrokeRegion(0.0, 0.15, 1.0, 0.4, _lr),
      StrokeRegion(0.0, 0.3, 0.55, 1.0, _tlbr),
      StrokeRegion(0.45, 0.3, 1.0, 1.0, _trbl),
    ],

    // ㅋ (3): horizontal top, vertical right, mid horizontal
    'ㅋ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.4, _lr),
      StrokeRegion(0.55, 0.0, 1.0, 1.0, _tb),
      StrokeRegion(0.0, 0.35, 0.75, 0.65, _lr),
    ],

    // ㅌ (4): top-h, left-v, bottom-h, mid-h
    'ㅌ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.35, _lr),
      StrokeRegion(0.0, 0.0, 0.4, 1.0, _tb),
      StrokeRegion(0.0, 0.65, 1.0, 1.0, _lr),
      StrokeRegion(0.0, 0.35, 1.0, 0.65, _lr),
    ],

    // ㅍ (4): top-h, left-v-inner, right-v-inner, bottom-h
    'ㅍ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.35, _lr),
      StrokeRegion(0.2, 0.0, 0.5, 1.0, _tb),
      StrokeRegion(0.5, 0.0, 0.8, 1.0, _tb),
      StrokeRegion(0.0, 0.65, 1.0, 1.0, _lr),
    ],

    // ㅎ (3): top horizontal, circle, bottom horizontal
    'ㅎ': const [
      StrokeRegion(0.15, 0.0, 0.85, 0.25, _lr),
      StrokeRegion(0.15, 0.2, 0.85, 0.7, _rad),
      StrokeRegion(0.0, 0.7, 1.0, 1.0, _lr),
    ],

    // ─────────── Basic Vowels (10) ───────────

    // ㅏ (2): vertical, horizontal right
    'ㅏ': const [
      StrokeRegion(0.0, 0.0, 0.5, 1.0, _tb),
      StrokeRegion(0.3, 0.25, 1.0, 0.75, _lr),
    ],

    // ㅑ (3): vertical, two horizontals right
    'ㅑ': const [
      StrokeRegion(0.0, 0.0, 0.45, 1.0, _tb),
      StrokeRegion(0.25, 0.15, 1.0, 0.5, _lr),
      StrokeRegion(0.25, 0.5, 1.0, 0.85, _lr),
    ],

    // ㅓ (2): horizontal left, vertical
    'ㅓ': const [
      StrokeRegion(0.0, 0.25, 0.7, 0.75, _rl),
      StrokeRegion(0.5, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅕ (3): two horizontals left, vertical
    'ㅕ': const [
      StrokeRegion(0.0, 0.15, 0.75, 0.5, _rl),
      StrokeRegion(0.0, 0.5, 0.75, 0.85, _rl),
      StrokeRegion(0.55, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅗ (2): upward vertical, horizontal
    'ㅗ': const [
      StrokeRegion(0.3, 0.15, 0.7, 0.75, _bt),
      StrokeRegion(0.0, 0.55, 1.0, 1.0, _lr),
    ],

    // ㅛ (3): two upward verticals, horizontal
    'ㅛ': const [
      StrokeRegion(0.15, 0.15, 0.5, 0.75, _bt),
      StrokeRegion(0.5, 0.15, 0.85, 0.75, _bt),
      StrokeRegion(0.0, 0.55, 1.0, 1.0, _lr),
    ],

    // ㅜ (2): horizontal, downward vertical
    'ㅜ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.45, _lr),
      StrokeRegion(0.3, 0.25, 0.7, 1.0, _tb),
    ],

    // ㅠ (3): horizontal, two downward verticals
    'ㅠ': const [
      StrokeRegion(0.0, 0.0, 1.0, 0.45, _lr),
      StrokeRegion(0.15, 0.25, 0.5, 1.0, _tb),
      StrokeRegion(0.5, 0.25, 0.85, 1.0, _tb),
    ],

    // ㅡ (1): horizontal
    'ㅡ': const [
      StrokeRegion(0.0, 0.25, 1.0, 0.75, _lr),
    ],

    // ㅣ (1): vertical
    'ㅣ': const [
      StrokeRegion(0.25, 0.0, 0.75, 1.0, _tb),
    ],

    // ─────────── Compound Vowels (11) ───────────

    // ㅐ (3): ㅏ + ㅣ
    'ㅐ': const [
      StrokeRegion(0.0, 0.0, 0.38, 1.0, _tb),
      StrokeRegion(0.2, 0.25, 0.65, 0.75, _lr),
      StrokeRegion(0.6, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅒ (4): ㅑ + ㅣ
    'ㅒ': const [
      StrokeRegion(0.0, 0.0, 0.35, 1.0, _tb),
      StrokeRegion(0.18, 0.15, 0.6, 0.5, _lr),
      StrokeRegion(0.18, 0.5, 0.6, 0.85, _lr),
      StrokeRegion(0.6, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅔ (3): ㅓ + ㅣ
    'ㅔ': const [
      StrokeRegion(0.0, 0.25, 0.55, 0.75, _rl),
      StrokeRegion(0.2, 0.0, 0.6, 1.0, _tb),
      StrokeRegion(0.6, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅖ (4): ㅕ + ㅣ
    'ㅖ': const [
      StrokeRegion(0.0, 0.15, 0.55, 0.5, _rl),
      StrokeRegion(0.0, 0.5, 0.55, 0.85, _rl),
      StrokeRegion(0.2, 0.0, 0.6, 1.0, _tb),
      StrokeRegion(0.6, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅘ (4): ㅗ + ㅏ
    'ㅘ': const [
      StrokeRegion(0.15, 0.15, 0.5, 0.65, _bt),
      StrokeRegion(0.0, 0.5, 0.6, 0.75, _lr),
      StrokeRegion(0.55, 0.0, 0.85, 1.0, _tb),
      StrokeRegion(0.6, 0.3, 1.0, 0.7, _lr),
    ],

    // ㅙ (5): ㅗ + ㅐ
    'ㅙ': const [
      StrokeRegion(0.1, 0.15, 0.4, 0.65, _bt),
      StrokeRegion(0.0, 0.5, 0.55, 0.75, _lr),
      StrokeRegion(0.45, 0.0, 0.7, 1.0, _tb),
      StrokeRegion(0.5, 0.3, 0.82, 0.7, _lr),
      StrokeRegion(0.75, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅚ (3): ㅗ + ㅣ
    'ㅚ': const [
      StrokeRegion(0.15, 0.15, 0.55, 0.65, _bt),
      StrokeRegion(0.0, 0.5, 0.65, 0.75, _lr),
      StrokeRegion(0.6, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅝ (4): ㅜ + ㅓ
    'ㅝ': const [
      StrokeRegion(0.0, 0.25, 0.6, 0.5, _lr),
      StrokeRegion(0.15, 0.3, 0.5, 0.85, _tb),
      StrokeRegion(0.2, 0.3, 0.7, 0.7, _rl),
      StrokeRegion(0.55, 0.0, 0.85, 1.0, _tb),
    ],

    // ㅞ (5): ㅜ + ㅔ
    'ㅞ': const [
      StrokeRegion(0.0, 0.25, 0.55, 0.5, _lr),
      StrokeRegion(0.12, 0.3, 0.4, 0.85, _tb),
      StrokeRegion(0.15, 0.3, 0.6, 0.7, _rl),
      StrokeRegion(0.4, 0.0, 0.7, 1.0, _tb),
      StrokeRegion(0.7, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅟ (3): ㅜ + ㅣ
    'ㅟ': const [
      StrokeRegion(0.0, 0.25, 0.7, 0.5, _lr),
      StrokeRegion(0.2, 0.3, 0.55, 0.85, _tb),
      StrokeRegion(0.65, 0.0, 1.0, 1.0, _tb),
    ],

    // ㅢ (2): ㅡ + ㅣ
    'ㅢ': const [
      StrokeRegion(0.0, 0.25, 0.75, 0.75, _lr),
      StrokeRegion(0.65, 0.0, 1.0, 1.0, _tb),
    ],

    // ─────────── Double Consonants (5) — auto-generated ───────────
    // Populated in the static initializer below.
  };

  static final bool _initialized = _initDoubles();
  static bool _initDoubles() {
    _regionData['ㄲ'] = _double(_regionData['ㄱ']!);
    _regionData['ㄸ'] = _double(_regionData['ㄷ']!);
    _regionData['ㅃ'] = _double(_regionData['ㅂ']!);
    _regionData['ㅆ'] = _double(_regionData['ㅅ']!);
    _regionData['ㅉ'] = _double(_regionData['ㅈ']!);
    return true;
  }

  static void ensureInitialized() {
    _initialized;
  }
}
