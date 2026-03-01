import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

const int size = 220;
final bg = img.ColorRgb8(255, 255, 255);
final guide = img.ColorRgb8(210, 210, 210);
final stroke = img.ColorRgb8(34, 34, 34);

img.Image canvas() {
  final c = img.Image(width: size, height: size);
  img.fill(c, color: bg);
  return c;
}

bool isBackground(img.Pixel p) => p.r == 255 && p.g == 255 && p.b == 255;

({int minX, int minY, int maxX, int maxY})? contentBounds(img.Image c) {
  int minX = c.width;
  int minY = c.height;
  int maxX = -1;
  int maxY = -1;

  for (int y = 0; y < c.height; y++) {
    for (int x = 0; x < c.width; x++) {
      final p = c.getPixel(x, y);
      if (isBackground(p)) continue;
      if (x < minX) minX = x;
      if (y < minY) minY = y;
      if (x > maxX) maxX = x;
      if (y > maxY) maxY = y;
    }
  }

  if (maxX < 0 || maxY < 0) return null;
  return (minX: minX, minY: minY, maxX: maxX, maxY: maxY);
}

img.Image shiftImage(img.Image source, int dx, int dy) {
  final out = canvas();
  for (int y = 0; y < source.height; y++) {
    for (int x = 0; x < source.width; x++) {
      final p = source.getPixel(x, y);
      if (isBackground(p)) continue;
      final nx = x + dx;
      final ny = y + dy;
      if (nx < 0 || nx >= out.width || ny < 0 || ny >= out.height) continue;
      out.setPixel(nx, ny, p);
    }
  }
  return out;
}

List<img.Image> centerFramesByFinalBounds(List<img.Image> frames) {
  if (frames.isEmpty) return frames;
  final bounds = contentBounds(frames.last);
  if (bounds == null) return frames;

  final width = bounds.maxX - bounds.minX + 1;
  final height = bounds.maxY - bounds.minY + 1;
  final targetMinX = ((size - width) / 2).round();
  final targetMinY = ((size - height) / 2).round();
  final dx = targetMinX - bounds.minX;
  final dy = targetMinY - bounds.minY;

  if (dx == 0 && dy == 0) return frames;
  return frames.map((f) => shiftImage(f, dx, dy)).toList();
}

void fillRect(
  img.Image c,
  int left,
  int top,
  int right,
  int bottom,
  img.Color color,
) {
  img.fillRect(c, x1: left, y1: top, x2: right, y2: bottom, color: color);
}

enum RectStrokeDirection {
  leftToRight,
  rightToLeft,
  topToBottom,
  bottomToTop,
}

class RectStrokeAnim {
  final int left;
  final int top;
  final int right;
  final int bottom;
  final RectStrokeDirection direction;
  final int frames;

  const RectStrokeAnim({
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
    required this.direction,
    this.frames = 9,
  });
}

void drawPartialRectStroke(
    img.Image c, RectStrokeAnim s, double p, img.Color color) {
  final clamped = p.clamp(0.0, 1.0);
  switch (s.direction) {
    case RectStrokeDirection.leftToRight:
      final x = (s.left + (s.right - s.left) * clamped).round();
      fillRect(c, s.left, s.top, x, s.bottom, color);
      break;
    case RectStrokeDirection.rightToLeft:
      final x = (s.right + (s.left - s.right) * clamped).round();
      fillRect(c, x, s.top, s.right, s.bottom, color);
      break;
    case RectStrokeDirection.topToBottom:
      final y = (s.top + (s.bottom - s.top) * clamped).round();
      fillRect(c, s.left, s.top, s.right, y, color);
      break;
    case RectStrokeDirection.bottomToTop:
      final y = (s.bottom + (s.top - s.bottom) * clamped).round();
      fillRect(c, s.left, y, s.right, s.bottom, color);
      break;
  }
}

List<img.Image> buildRectGlyphFrames(List<RectStrokeAnim> strokes) {
  final frames = <img.Image>[];
  for (int si = 0; si < strokes.length; si++) {
    final s = strokes[si];
    final start = si == 0 ? 0 : 1;
    for (int i = start; i <= s.frames; i++) {
      final p = i / s.frames;
      final c = canvas();

      for (final g in strokes) {
        fillRect(c, g.left, g.top, g.right, g.bottom, guide);
      }
      for (int prev = 0; prev < si; prev++) {
        final done = strokes[prev];
        fillRect(c, done.left, done.top, done.right, done.bottom, stroke);
      }
      drawPartialRectStroke(c, s, p, stroke);
      frames.add(c);
    }
  }
  return frames;
}

void fillRingSegment(
  img.Image c, {
  required int cx,
  required int cy,
  required int outerR,
  required int innerR,
  required double sweep,
  required img.Color color,
}) {
  final normalizedSweep = sweep.clamp(0.0, math.pi * 2);
  const start = -math.pi / 2;
  final end = start + normalizedSweep;
  final minX = cx - outerR;
  final maxX = cx + outerR;
  final minY = cy - outerR;
  final maxY = cy + outerR;
  final outer2 = outerR * outerR;
  final inner2 = innerR * innerR;

  for (int y = minY; y <= maxY; y++) {
    if (y < 0 || y >= c.height) continue;
    for (int x = minX; x <= maxX; x++) {
      if (x < 0 || x >= c.width) continue;

      final dx = x - cx;
      final dy = y - cy;
      final d2 = dx * dx + dy * dy;
      if (d2 > outer2 || d2 < inner2) continue;

      var a = math.atan2(dy.toDouble(), dx.toDouble());
      if (a < start) a += math.pi * 2;
      if (a <= end) {
        c.setPixel(x, y, color);
      }
    }
  }
}

void fillEllipseRingSegment(
  img.Image c, {
  required int cx,
  required int cy,
  required int outerRx,
  required int outerRy,
  required int innerRx,
  required int innerRy,
  required double sweep,
  required img.Color color,
}) {
  final normalizedSweep = sweep.clamp(0.0, math.pi * 2);
  const start = -math.pi / 2;
  final end = start + normalizedSweep;
  final minX = cx - outerRx;
  final maxX = cx + outerRx;
  final minY = cy - outerRy;
  final maxY = cy + outerRy;

  for (int y = minY; y <= maxY; y++) {
    if (y < 0 || y >= c.height) continue;
    for (int x = minX; x <= maxX; x++) {
      if (x < 0 || x >= c.width) continue;

      final dx = (x - cx).toDouble();
      final dy = (y - cy).toDouble();

      final outerNorm =
          (dx * dx) / (outerRx * outerRx) + (dy * dy) / (outerRy * outerRy);
      final innerNorm =
          (dx * dx) / (innerRx * innerRx) + (dy * dy) / (innerRy * innerRy);
      if (outerNorm > 1.0 || innerNorm < 1.0) continue;

      var a = math.atan2(dy / outerRy, dx / outerRx);
      if (a < start) a += math.pi * 2;
      if (a <= end) {
        c.setPixel(x, y, color);
      }
    }
  }
}

void guideGiyeok(img.Image c) {
  fillRect(c, 52, 52, 168, 69, guide);
  fillRect(c, 151, 52, 168, 158, guide);
}

void guideNieun(img.Image c) {
  fillRect(c, 58, 50, 75, 168, guide);
  fillRect(c, 58, 151, 168, 168, guide);
}

void guideDigeut(img.Image c) {
  fillRect(c, 52, 52, 168, 69, guide);
  fillRect(c, 52, 52, 69, 172, guide);
  fillRect(c, 52, 155, 168, 172, guide);
}

void guideRieul(img.Image c) {
  fillRect(c, 52, 52, 168, 69, guide);
  fillRect(c, 151, 52, 168, 121, guide);
  fillRect(c, 52, 104, 168, 121, guide);
  fillRect(c, 52, 104, 69, 172, guide);
  fillRect(c, 52, 155, 168, 172, guide);
}

void guideMieum(img.Image c) {
  fillRect(c, 52, 52, 69, 172, guide);
  fillRect(c, 52, 52, 168, 69, guide);
  fillRect(c, 151, 52, 168, 172, guide);
  fillRect(c, 52, 155, 168, 172, guide);
}

void guideBieup(img.Image c) {
  fillRect(c, 52, 52, 69, 172, guide);
  fillRect(c, 151, 52, 168, 172, guide);
  fillRect(c, 52, 104, 168, 121, guide);
  fillRect(c, 52, 155, 168, 172, guide);
}

void guideSiot(img.Image c) {
  img.drawLine(
    c,
    x1: 110,
    y1: 62,
    x2: 60,
    y2: 134,
    color: guide,
    thickness: 18.0,
  );
  img.drawLine(
    c,
    x1: 110,
    y1: 62,
    x2: 160,
    y2: 134,
    color: guide,
    thickness: 18.0,
  );
}

void guideIeung(img.Image c) {
  fillRingSegment(
    c,
    cx: 110,
    cy: 112,
    outerR: 60,
    innerR: 42,
    sweep: math.pi * 2,
    color: guide,
  );
}

void guideJieut(img.Image c) {
  // ㅈ: top horizontal + two diagonal strokes
  fillRect(c, 56, 62, 164, 79, guide);
  img.drawLine(
    c,
    x1: 110,
    y1: 79,
    x2: 64,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  img.drawLine(
    c,
    x1: 110,
    y1: 79,
    x2: 156,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
}

void guideChieut(img.Image c) {
  // ㅊ: short top vertical, horizontal, two diagonals
  fillRect(c, 101, 42, 119, 70, guide);
  fillRect(c, 56, 70, 164, 87, guide);
  img.drawLine(
    c,
    x1: 110,
    y1: 87,
    x2: 64,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  img.drawLine(
    c,
    x1: 110,
    y1: 87,
    x2: 156,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
}

void guideKieuk(img.Image c) {
  // ㅋ: top horizontal, right vertical, middle horizontal
  fillRect(c, 56, 48, 164, 65, guide);
  fillRect(c, 147, 48, 164, 172, guide);
  fillRect(c, 56, 100, 146, 117, guide);
}

void guideTieut(img.Image c) {
  // ㅌ: top horizontal, left vertical, bottom horizontal, middle horizontal
  fillRect(c, 56, 44, 164, 61, guide);
  fillRect(c, 56, 44, 73, 172, guide);
  fillRect(c, 56, 155, 164, 172, guide);
  fillRect(c, 56, 100, 164, 117, guide);
}

void guidePieup(img.Image c) {
  // ㅍ: top horizontal, left inner vertical, right inner vertical, bottom horizontal
  fillRect(c, 56, 44, 164, 61, guide);
  fillRect(c, 78, 44, 95, 172, guide);
  fillRect(c, 126, 44, 143, 172, guide);
  fillRect(c, 56, 155, 164, 172, guide);
}

void guideHieut(img.Image c) {
  // ㅎ: short top horizontal, long horizontal, circle
  fillRect(c, 78, 54, 142, 71, guide);
  fillRect(c, 56, 78, 164, 95, guide);
  fillEllipseRingSegment(
    c,
    cx: 110,
    cy: 136,
    outerRx: 40,
    outerRy: 34,
    innerRx: 24,
    innerRy: 20,
    sweep: math.pi * 2,
    color: guide,
  );
}

List<img.Image> framesGiyeok() {
  const stroke1Frames = 14;
  const stroke2Frames = 14;
  final frames = <img.Image>[];
  for (int i = 0; i <= stroke1Frames; i++) {
    final s1 = i / stroke1Frames;
    final c = canvas();
    guideGiyeok(c);
    if (s1 > 0) {
      final right = (52 + (168 - 52) * s1).round();
      fillRect(c, 52, 52, right, 69, stroke);
    }
    frames.add(c);
  }
  for (int i = 1; i <= stroke2Frames; i++) {
    final s2 = i / stroke2Frames;
    final c = canvas();
    guideGiyeok(c);
    fillRect(c, 52, 52, 168, 69, stroke);
    final bottom = (52 + (158 - 52) * s2).round();
    fillRect(c, 151, 52, 168, bottom, stroke);
    frames.add(c);
  }
  return frames;
}

List<img.Image> framesNieun() {
  const stroke1Frames = 14;
  const stroke2Frames = 14;
  final frames = <img.Image>[];
  for (int i = 0; i <= stroke1Frames; i++) {
    final s1 = i / stroke1Frames;
    final c = canvas();
    guideNieun(c);
    if (s1 > 0) {
      final bottom = (50 + (168 - 50) * s1).round();
      fillRect(c, 58, 50, 75, bottom, stroke);
    }
    frames.add(c);
  }
  for (int i = 1; i <= stroke2Frames; i++) {
    final s2 = i / stroke2Frames;
    final c = canvas();
    guideNieun(c);
    fillRect(c, 58, 50, 75, 168, stroke);
    final right = (58 + (168 - 58) * s2).round();
    fillRect(c, 58, 151, right, 168, stroke);
    frames.add(c);
  }
  return frames;
}

List<img.Image> framesDigeut() {
  const stroke1Frames = 10;
  const stroke2Frames = 10;
  const stroke3Frames = 10;
  final frames = <img.Image>[];

  for (int i = 0; i <= stroke1Frames; i++) {
    final s1 = i / stroke1Frames;
    final c = canvas();
    guideDigeut(c);
    if (s1 > 0) {
      final right = (52 + (168 - 52) * s1).round();
      fillRect(c, 52, 52, right, 69, stroke);
    }
    frames.add(c);
  }

  for (int i = 1; i <= stroke2Frames; i++) {
    final s2 = i / stroke2Frames;
    final c = canvas();
    guideDigeut(c);
    fillRect(c, 52, 52, 168, 69, stroke);
    final bottom = (52 + (172 - 52) * s2).round();
    fillRect(c, 52, 52, 69, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= stroke3Frames; i++) {
    final s3 = i / stroke3Frames;
    final c = canvas();
    guideDigeut(c);
    fillRect(c, 52, 52, 168, 69, stroke);
    fillRect(c, 52, 52, 69, 172, stroke);
    final right = (52 + (168 - 52) * s3).round();
    fillRect(c, 52, 155, right, 172, stroke);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesRieul() {
  const f1 = 7;
  const f2 = 7;
  const f3 = 7;
  const f4 = 7;
  const f5 = 7;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideRieul(c);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 52, right, 69, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideRieul(c);
    fillRect(c, 52, 52, 168, 69, stroke);
    final bottom = (52 + (121 - 52) * p).round();
    fillRect(c, 151, 52, 168, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideRieul(c);
    fillRect(c, 52, 52, 168, 69, stroke);
    fillRect(c, 151, 52, 168, 121, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 104, right, 121, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guideRieul(c);
    fillRect(c, 52, 52, 168, 69, stroke);
    fillRect(c, 151, 52, 168, 121, stroke);
    fillRect(c, 52, 104, 168, 121, stroke);
    final bottom = (104 + (172 - 104) * p).round();
    fillRect(c, 52, 104, 69, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f5; i++) {
    final p = i / f5;
    final c = canvas();
    guideRieul(c);
    fillRect(c, 52, 52, 168, 69, stroke);
    fillRect(c, 151, 52, 168, 121, stroke);
    fillRect(c, 52, 104, 168, 121, stroke);
    fillRect(c, 52, 104, 69, 172, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 155, right, 172, stroke);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesMieum() {
  const f1 = 8;
  const f2 = 8;
  const f3 = 8;
  const f4 = 8;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideMieum(c);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 52, 52, 69, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideMieum(c);
    fillRect(c, 52, 52, 69, 172, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 52, right, 69, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideMieum(c);
    fillRect(c, 52, 52, 69, 172, stroke);
    fillRect(c, 52, 52, 168, 69, stroke);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 151, 52, 168, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guideMieum(c);
    fillRect(c, 52, 52, 69, 172, stroke);
    fillRect(c, 52, 52, 168, 69, stroke);
    fillRect(c, 151, 52, 168, 172, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 155, right, 172, stroke);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesBieup() {
  const f1 = 8;
  const f2 = 8;
  const f3 = 8;
  const f4 = 8;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideBieup(c);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 52, 52, 69, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideBieup(c);
    fillRect(c, 52, 52, 69, 172, stroke);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 151, 52, 168, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideBieup(c);
    fillRect(c, 52, 52, 69, 172, stroke);
    fillRect(c, 151, 52, 168, 172, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 104, right, 121, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guideBieup(c);
    fillRect(c, 52, 52, 69, 172, stroke);
    fillRect(c, 151, 52, 168, 172, stroke);
    fillRect(c, 52, 104, 168, 121, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 155, right, 172, stroke);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesSiot() {
  const f1 = 12;
  const f2 = 12;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideSiot(c);
    final x = (110 + (60 - 110) * p).round();
    final y = (62 + (134 - 62) * p).round();
    img.drawLine(c,
        x1: 110, y1: 62, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }

  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideSiot(c);
    img.drawLine(c,
        x1: 110, y1: 62, x2: 60, y2: 134, color: stroke, thickness: 18.0);
    final x = (110 + (160 - 110) * p).round();
    final y = (62 + (134 - 62) * p).round();
    img.drawLine(c,
        x1: 110, y1: 62, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesIeung() {
  const f1 = 28;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideIeung(c);
    fillRingSegment(
      c,
      cx: 110,
      cy: 112,
      outerR: 60,
      innerR: 42,
      sweep: math.pi * 2 * p,
      color: stroke,
    );
    frames.add(c);
  }
  return frames;
}

List<img.Image> framesJieut() {
  const f1 = 10;
  const f2 = 10;
  const f3 = 10;
  final frames = <img.Image>[];

  // 1st stroke: top horizontal
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideJieut(c);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 62, right, 79, stroke);
    frames.add(c);
  }

  // 2nd stroke: left diagonal
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideJieut(c);
    fillRect(c, 56, 62, 164, 79, stroke);
    final x = (110 + (64 - 110) * p).round();
    final y = (79 + (154 - 79) * p).round();
    img.drawLine(
      c,
      x1: 110,
      y1: 79,
      x2: x,
      y2: y,
      color: stroke,
      thickness: 18.0,
    );
    frames.add(c);
  }

  // 3rd stroke: right diagonal
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideJieut(c);
    fillRect(c, 56, 62, 164, 79, stroke);
    img.drawLine(
      c,
      x1: 110,
      y1: 79,
      x2: 64,
      y2: 154,
      color: stroke,
      thickness: 18.0,
    );
    final x = (110 + (156 - 110) * p).round();
    final y = (79 + (154 - 79) * p).round();
    img.drawLine(
      c,
      x1: 110,
      y1: 79,
      x2: x,
      y2: y,
      color: stroke,
      thickness: 18.0,
    );
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesChieut() {
  const f1 = 8;
  const f2 = 8;
  const f3 = 10;
  const f4 = 10;
  final frames = <img.Image>[];

  // 1st stroke: short top vertical
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideChieut(c);
    final bottom = (42 + (70 - 42) * p).round();
    fillRect(c, 101, 42, 119, bottom, stroke);
    frames.add(c);
  }

  // 2nd stroke: horizontal
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideChieut(c);
    fillRect(c, 101, 42, 119, 70, stroke);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 70, right, 87, stroke);
    frames.add(c);
  }

  // 3rd stroke: left diagonal
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideChieut(c);
    fillRect(c, 101, 42, 119, 70, stroke);
    fillRect(c, 56, 70, 164, 87, stroke);
    final x = (110 + (64 - 110) * p).round();
    final y = (87 + (154 - 87) * p).round();
    img.drawLine(
      c,
      x1: 110,
      y1: 87,
      x2: x,
      y2: y,
      color: stroke,
      thickness: 18.0,
    );
    frames.add(c);
  }

  // 4th stroke: right diagonal
  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guideChieut(c);
    fillRect(c, 101, 42, 119, 70, stroke);
    fillRect(c, 56, 70, 164, 87, stroke);
    img.drawLine(
      c,
      x1: 110,
      y1: 87,
      x2: 64,
      y2: 154,
      color: stroke,
      thickness: 18.0,
    );
    final x = (110 + (156 - 110) * p).round();
    final y = (87 + (154 - 87) * p).round();
    img.drawLine(
      c,
      x1: 110,
      y1: 87,
      x2: x,
      y2: y,
      color: stroke,
      thickness: 18.0,
    );
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesKieuk() {
  const f1 = 10;
  const f2 = 10;
  const f3 = 10;
  final frames = <img.Image>[];

  // 1st stroke: top horizontal
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideKieuk(c);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 48, right, 65, stroke);
    frames.add(c);
  }

  // 2nd stroke: right vertical
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideKieuk(c);
    fillRect(c, 56, 48, 164, 65, stroke);
    final bottom = (48 + (172 - 48) * p).round();
    fillRect(c, 147, 48, 164, bottom, stroke);
    frames.add(c);
  }

  // 3rd stroke: middle horizontal
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideKieuk(c);
    fillRect(c, 56, 48, 164, 65, stroke);
    fillRect(c, 147, 48, 164, 172, stroke);
    final right = (56 + (146 - 56) * p).round();
    fillRect(c, 56, 100, right, 117, stroke);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesTieut() {
  const f1 = 8, f2 = 8, f3 = 8, f4 = 8;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideTieut(c);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 44, right, 61, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideTieut(c);
    fillRect(c, 56, 44, 164, 61, stroke);
    final bottom = (44 + (172 - 44) * p).round();
    fillRect(c, 56, 44, 73, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideTieut(c);
    fillRect(c, 56, 44, 164, 61, stroke);
    fillRect(c, 56, 44, 73, 172, stroke);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 155, right, 172, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guideTieut(c);
    fillRect(c, 56, 44, 164, 61, stroke);
    fillRect(c, 56, 44, 73, 172, stroke);
    fillRect(c, 56, 155, 164, 172, stroke);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 100, right, 117, stroke);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesPieup() {
  const f1 = 8, f2 = 8, f3 = 8, f4 = 8;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guidePieup(c);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 44, right, 61, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guidePieup(c);
    fillRect(c, 56, 44, 164, 61, stroke);
    final bottom = (44 + (172 - 44) * p).round();
    fillRect(c, 78, 44, 95, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guidePieup(c);
    fillRect(c, 56, 44, 164, 61, stroke);
    fillRect(c, 78, 44, 95, 172, stroke);
    final bottom = (44 + (172 - 44) * p).round();
    fillRect(c, 126, 44, 143, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guidePieup(c);
    fillRect(c, 56, 44, 164, 61, stroke);
    fillRect(c, 78, 44, 95, 172, stroke);
    fillRect(c, 126, 44, 143, 172, stroke);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 155, right, 172, stroke);
    frames.add(c);
  }

  return frames;
}

List<img.Image> framesHieut() {
  const f1 = 8, f2 = 10, f3 = 18;
  final frames = <img.Image>[];

  // 1st stroke: short top horizontal
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideHieut(c);
    final right = (78 + (142 - 78) * p).round();
    fillRect(c, 78, 54, right, 71, stroke);
    frames.add(c);
  }

  // 2nd stroke: long horizontal
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideHieut(c);
    fillRect(c, 78, 54, 142, 71, stroke);
    final right = (56 + (164 - 56) * p).round();
    fillRect(c, 56, 78, right, 95, stroke);
    frames.add(c);
  }

  // 3rd stroke: circle
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideHieut(c);
    fillRect(c, 78, 54, 142, 71, stroke);
    fillRect(c, 56, 78, 164, 95, stroke);
    fillEllipseRingSegment(
      c,
      cx: 110,
      cy: 136,
      outerRx: 40,
      outerRy: 34,
      innerRx: 24,
      innerRy: 20,
      sweep: math.pi * 2 * p,
      color: stroke,
    );
    frames.add(c);
  }

  return frames;
}

void guideA(img.Image c) {
  // ㅏ: vertical, middle-right horizontal
  fillRect(c, 96, 48, 113, 172, guide);
  fillRect(c, 96, 102, 156, 119, guide);
}

List<img.Image> framesA() {
  const f1 = 10, f2 = 10;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideA(c);
    final bottom = (48 + (172 - 48) * p).round();
    fillRect(c, 96, 48, 113, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideA(c);
    fillRect(c, 96, 48, 113, 172, stroke);
    final right = (96 + (156 - 96) * p).round();
    fillRect(c, 96, 102, right, 119, stroke);
    frames.add(c);
  }
  return frames;
}

void guideYa(img.Image c) {
  // ㅑ: vertical, upper-right horizontal, lower-right horizontal
  fillRect(c, 96, 48, 113, 172, guide);
  fillRect(c, 96, 78, 156, 95, guide);
  fillRect(c, 96, 126, 156, 143, guide);
}

List<img.Image> framesYa() {
  const f1 = 9, f2 = 9, f3 = 9;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideYa(c);
    final bottom = (48 + (172 - 48) * p).round();
    fillRect(c, 96, 48, 113, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideYa(c);
    fillRect(c, 96, 48, 113, 172, stroke);
    final right = (96 + (156 - 96) * p).round();
    fillRect(c, 96, 78, right, 95, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideYa(c);
    fillRect(c, 96, 48, 113, 172, stroke);
    fillRect(c, 96, 78, 156, 95, stroke);
    final right = (96 + (156 - 96) * p).round();
    fillRect(c, 96, 126, right, 143, stroke);
    frames.add(c);
  }
  return frames;
}

void guideEo(img.Image c) {
  // ㅓ: middle-left horizontal, vertical
  fillRect(c, 64, 102, 124, 119, guide);
  fillRect(c, 107, 48, 124, 172, guide);
}

List<img.Image> framesEo() {
  const f1 = 10, f2 = 10;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideEo(c);
    final right = (64 + (124 - 64) * p).round();
    fillRect(c, 64, 102, right, 119, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideEo(c);
    fillRect(c, 64, 102, 124, 119, stroke);
    final bottom = (48 + (172 - 48) * p).round();
    fillRect(c, 107, 48, 124, bottom, stroke);
    frames.add(c);
  }
  return frames;
}

void guideYeo(img.Image c) {
  // ㅕ: upper-left horizontal, lower-left horizontal, vertical
  fillRect(c, 64, 78, 124, 95, guide);
  fillRect(c, 64, 126, 124, 143, guide);
  fillRect(c, 107, 48, 124, 172, guide);
}

List<img.Image> framesYeo() {
  const f1 = 9, f2 = 9, f3 = 9;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideYeo(c);
    final right = (64 + (124 - 64) * p).round();
    fillRect(c, 64, 78, right, 95, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideYeo(c);
    fillRect(c, 64, 78, 124, 95, stroke);
    final right = (64 + (124 - 64) * p).round();
    fillRect(c, 64, 126, right, 143, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideYeo(c);
    fillRect(c, 64, 78, 124, 95, stroke);
    fillRect(c, 64, 126, 124, 143, stroke);
    final bottom = (48 + (172 - 48) * p).round();
    fillRect(c, 107, 48, 124, bottom, stroke);
    frames.add(c);
  }
  return frames;
}

void guideO(img.Image c) {
  // ㅗ: horizontal, upward vertical
  fillRect(c, 52, 110, 168, 127, guide);
  fillRect(c, 102, 52, 119, 127, guide);
}

List<img.Image> framesO() {
  const f1 = 10, f2 = 10;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideO(c);
    final bottom = (52 + (127 - 52) * p).round();
    fillRect(c, 102, 52, 119, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideO(c);
    fillRect(c, 102, 52, 119, 127, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 110, right, 127, stroke);
    frames.add(c);
  }
  return frames;
}

void guideYo(img.Image c) {
  // ㅛ: horizontal, two upward verticals
  fillRect(c, 52, 110, 168, 127, guide);
  fillRect(c, 78, 52, 95, 127, guide);
  fillRect(c, 124, 52, 141, 127, guide);
}

List<img.Image> framesYo() {
  const f1 = 8, f2 = 8, f3 = 8;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideYo(c);
    final bottom = (52 + (127 - 52) * p).round();
    fillRect(c, 78, 52, 95, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideYo(c);
    fillRect(c, 78, 52, 95, 127, stroke);
    final bottom = (52 + (127 - 52) * p).round();
    fillRect(c, 124, 52, 141, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideYo(c);
    fillRect(c, 78, 52, 95, 127, stroke);
    fillRect(c, 124, 52, 141, 127, stroke);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 110, right, 127, stroke);
    frames.add(c);
  }
  return frames;
}

void guideU(img.Image c) {
  // ㅜ: horizontal, downward vertical
  fillRect(c, 52, 92, 168, 109, guide);
  fillRect(c, 102, 92, 119, 172, guide);
}

List<img.Image> framesU() {
  const f1 = 10, f2 = 10;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideU(c);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 92, right, 109, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideU(c);
    fillRect(c, 52, 92, 168, 109, stroke);
    final bottom = (92 + (172 - 92) * p).round();
    fillRect(c, 102, 92, 119, bottom, stroke);
    frames.add(c);
  }
  return frames;
}

void guideYu(img.Image c) {
  // ㅠ: horizontal, two downward verticals
  fillRect(c, 52, 92, 168, 109, guide);
  fillRect(c, 78, 92, 95, 172, guide);
  fillRect(c, 124, 92, 141, 172, guide);
}

List<img.Image> framesYu() {
  const f1 = 8, f2 = 8, f3 = 8;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideYu(c);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 92, right, 109, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideYu(c);
    fillRect(c, 52, 92, 168, 109, stroke);
    final bottom = (92 + (172 - 92) * p).round();
    fillRect(c, 78, 92, 95, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideYu(c);
    fillRect(c, 52, 92, 168, 109, stroke);
    fillRect(c, 78, 92, 95, 172, stroke);
    final bottom = (92 + (172 - 92) * p).round();
    fillRect(c, 124, 92, 141, bottom, stroke);
    frames.add(c);
  }
  return frames;
}

void guideEu(img.Image c) {
  // ㅡ: horizontal
  fillRect(c, 52, 102, 168, 119, guide);
}

List<img.Image> framesEu() {
  const f1 = 12;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideEu(c);
    final right = (52 + (168 - 52) * p).round();
    fillRect(c, 52, 102, right, 119, stroke);
    frames.add(c);
  }
  return frames;
}

void guideI(img.Image c) {
  // ㅣ: vertical
  fillRect(c, 102, 48, 119, 172, guide);
}

List<img.Image> framesI() {
  const f1 = 12;
  final frames = <img.Image>[];
  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideI(c);
    final bottom = (48 + (172 - 48) * p).round();
    fillRect(c, 102, 48, 119, bottom, stroke);
    frames.add(c);
  }
  return frames;
}

List<img.Image> framesAe() => buildRectGlyphFrames(const [
      // ㅐ: ㅏ + right vertical
      RectStrokeAnim(
        left: 96,
        top: 48,
        right: 113,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 96,
        top: 102,
        right: 156,
        bottom: 119,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 142,
        top: 48,
        right: 159,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesYae() => buildRectGlyphFrames(const [
      // ㅒ: ㅑ + right vertical
      RectStrokeAnim(
        left: 96,
        top: 48,
        right: 113,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 96,
        top: 78,
        right: 156,
        bottom: 95,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 96,
        top: 126,
        right: 156,
        bottom: 143,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 142,
        top: 48,
        right: 159,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesE() => buildRectGlyphFrames(const [
      // ㅔ: ㅓ + right vertical
      RectStrokeAnim(
        left: 74,
        top: 102,
        right: 124,
        bottom: 119,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 107,
        top: 48,
        right: 124,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 142,
        top: 48,
        right: 159,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesYe() => buildRectGlyphFrames(const [
      // ㅖ: ㅕ + right vertical
      RectStrokeAnim(
        left: 74,
        top: 78,
        right: 124,
        bottom: 95,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 74,
        top: 126,
        right: 124,
        bottom: 143,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 107,
        top: 48,
        right: 124,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 142,
        top: 48,
        right: 159,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesWa() => buildRectGlyphFrames(const [
      // ㅘ: ㅗ + ㅏ
      RectStrokeAnim(
        left: 62,
        top: 66,
        right: 79,
        bottom: 141,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 22,
        top: 124,
        right: 104,
        bottom: 141,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 102,
        top: 48,
        right: 119,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 102,
        top: 102,
        right: 156,
        bottom: 119,
        direction: RectStrokeDirection.leftToRight,
      ),
    ]);

List<img.Image> framesWae() => buildRectGlyphFrames(const [
      // ㅙ: ㅘ + right vertical
      RectStrokeAnim(
        left: 58,
        top: 66,
        right: 75,
        bottom: 141,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 18,
        top: 124,
        right: 100,
        bottom: 141,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 98,
        top: 48,
        right: 115,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 98,
        top: 102,
        right: 148,
        bottom: 119,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 142,
        top: 48,
        right: 159,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesOe() => buildRectGlyphFrames(const [
      // ㅚ: ㅗ + ㅣ
      RectStrokeAnim(
        left: 68,
        top: 66,
        right: 85,
        bottom: 141,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 28,
        top: 124,
        right: 110,
        bottom: 141,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 108,
        top: 48,
        right: 125,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesWo() => buildRectGlyphFrames(const [
      // ㅝ: ㅜ + ㅓ
      RectStrokeAnim(
        left: 26,
        top: 92,
        right: 108,
        bottom: 109,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 60,
        top: 92,
        right: 77,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 84,
        top: 122,
        right: 144,
        bottom: 139,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 127,
        top: 48,
        right: 144,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesWe() => buildRectGlyphFrames(const [
      // ㅞ: ㅜ + ㅔ
      RectStrokeAnim(
        left: 18,
        top: 92,
        right: 96,
        bottom: 109,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 48,
        top: 92,
        right: 65,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 72,
        top: 122,
        right: 128,
        bottom: 139,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 111,
        top: 48,
        right: 128,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 138,
        top: 48,
        right: 155,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesWi() => buildRectGlyphFrames(const [
      // ㅟ: ㅜ + ㅣ
      RectStrokeAnim(
        left: 30,
        top: 92,
        right: 112,
        bottom: 109,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 64,
        top: 92,
        right: 81,
        bottom: 154,
        direction: RectStrokeDirection.topToBottom,
      ),
      RectStrokeAnim(
        left: 116,
        top: 48,
        right: 133,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

List<img.Image> framesUi() => buildRectGlyphFrames(const [
      // ㅢ: ㅡ + ㅣ
      RectStrokeAnim(
        left: 46,
        top: 120,
        right: 142,
        bottom: 137,
        direction: RectStrokeDirection.leftToRight,
      ),
      RectStrokeAnim(
        left: 126,
        top: 48,
        right: 143,
        bottom: 172,
        direction: RectStrokeDirection.topToBottom,
      ),
    ]);

void guideSsangGiyeok(img.Image c) {
  // Left ㄱ (almost touching)
  fillRect(c, 38, 52, 108, 69, guide);
  fillRect(c, 91, 52, 108, 158, guide);
  // Right ㄱ
  fillRect(c, 112, 52, 182, 69, guide);
  fillRect(c, 165, 52, 182, 158, guide);
}

List<img.Image> framesSsangGiyeok() {
  const f1 = 10, f2 = 10, f3 = 10, f4 = 10;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideSsangGiyeok(c);
    final right = (38 + (108 - 38) * p).round();
    fillRect(c, 38, 52, right, 69, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideSsangGiyeok(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    final bottom = (52 + (158 - 52) * p).round();
    fillRect(c, 91, 52, 108, bottom, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideSsangGiyeok(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    fillRect(c, 91, 52, 108, 158, stroke);
    final right = (112 + (182 - 112) * p).round();
    fillRect(c, 112, 52, right, 69, stroke);
    frames.add(c);
  }

  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guideSsangGiyeok(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    fillRect(c, 91, 52, 108, 158, stroke);
    fillRect(c, 112, 52, 182, 69, stroke);
    final bottom = (52 + (158 - 52) * p).round();
    fillRect(c, 165, 52, 182, bottom, stroke);
    frames.add(c);
  }

  return frames;
}

void guideSsangDigeut(img.Image c) {
  // Left ㄷ
  fillRect(c, 38, 52, 108, 69, guide);
  fillRect(c, 38, 52, 55, 172, guide);
  fillRect(c, 38, 155, 108, 172, guide);
  // Right ㄷ
  fillRect(c, 112, 52, 182, 69, guide);
  fillRect(c, 112, 52, 129, 172, guide);
  fillRect(c, 112, 155, 182, 172, guide);
}

List<img.Image> framesSsangDigeut() {
  const f1 = 8, f2 = 8, f3 = 8, f4 = 8, f5 = 8, f6 = 8;
  final frames = <img.Image>[];

  for (int i = 0; i <= f1; i++) {
    final p = i / f1;
    final c = canvas();
    guideSsangDigeut(c);
    final right = (38 + (108 - 38) * p).round();
    fillRect(c, 38, 52, right, 69, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f2; i++) {
    final p = i / f2;
    final c = canvas();
    guideSsangDigeut(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 38, 52, 55, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f3; i++) {
    final p = i / f3;
    final c = canvas();
    guideSsangDigeut(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    fillRect(c, 38, 52, 55, 172, stroke);
    final right = (38 + (108 - 38) * p).round();
    fillRect(c, 38, 155, right, 172, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f4; i++) {
    final p = i / f4;
    final c = canvas();
    guideSsangDigeut(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    fillRect(c, 38, 52, 55, 172, stroke);
    fillRect(c, 38, 155, 108, 172, stroke);
    final right = (112 + (182 - 112) * p).round();
    fillRect(c, 112, 52, right, 69, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f5; i++) {
    final p = i / f5;
    final c = canvas();
    guideSsangDigeut(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    fillRect(c, 38, 52, 55, 172, stroke);
    fillRect(c, 38, 155, 108, 172, stroke);
    fillRect(c, 112, 52, 182, 69, stroke);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 112, 52, 129, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f6; i++) {
    final p = i / f6;
    final c = canvas();
    guideSsangDigeut(c);
    fillRect(c, 38, 52, 108, 69, stroke);
    fillRect(c, 38, 52, 55, 172, stroke);
    fillRect(c, 38, 155, 108, 172, stroke);
    fillRect(c, 112, 52, 182, 69, stroke);
    fillRect(c, 112, 52, 129, 172, stroke);
    final right = (112 + (182 - 112) * p).round();
    fillRect(c, 112, 155, right, 172, stroke);
    frames.add(c);
  }
  return frames;
}

void guideSsangBieup(img.Image c) {
  // Left ㅂ (slight gap only for ㅃ)
  fillRect(c, 32, 52, 49, 172, guide);
  fillRect(c, 85, 52, 102, 172, guide);
  fillRect(c, 32, 104, 102, 121, guide);
  fillRect(c, 32, 155, 102, 172, guide);
  // Right ㅂ
  fillRect(c, 110, 52, 127, 172, guide);
  fillRect(c, 163, 52, 180, 172, guide);
  fillRect(c, 110, 104, 180, 121, guide);
  fillRect(c, 110, 155, 180, 172, guide);
}

List<img.Image> framesSsangBieup() {
  const f = 7;
  final frames = <img.Image>[];

  for (int i = 0; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 32, 52, 49, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    fillRect(c, 32, 52, 49, 172, stroke);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 85, 52, 102, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    fillRect(c, 32, 52, 49, 172, stroke);
    fillRect(c, 85, 52, 102, 172, stroke);
    final right = (32 + (102 - 32) * p).round();
    fillRect(c, 32, 104, right, 121, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    fillRect(c, 32, 52, 49, 172, stroke);
    fillRect(c, 85, 52, 102, 172, stroke);
    fillRect(c, 32, 104, 102, 121, stroke);
    final right = (32 + (102 - 32) * p).round();
    fillRect(c, 32, 155, right, 172, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    fillRect(c, 32, 52, 49, 172, stroke);
    fillRect(c, 85, 52, 102, 172, stroke);
    fillRect(c, 32, 104, 102, 121, stroke);
    fillRect(c, 32, 155, 102, 172, stroke);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 110, 52, 127, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    fillRect(c, 32, 52, 49, 172, stroke);
    fillRect(c, 85, 52, 102, 172, stroke);
    fillRect(c, 32, 104, 102, 121, stroke);
    fillRect(c, 32, 155, 102, 172, stroke);
    fillRect(c, 110, 52, 127, 172, stroke);
    final bottom = (52 + (172 - 52) * p).round();
    fillRect(c, 163, 52, 180, bottom, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    fillRect(c, 32, 52, 49, 172, stroke);
    fillRect(c, 85, 52, 102, 172, stroke);
    fillRect(c, 32, 104, 102, 121, stroke);
    fillRect(c, 32, 155, 102, 172, stroke);
    fillRect(c, 110, 52, 127, 172, stroke);
    fillRect(c, 163, 52, 180, 172, stroke);
    final right = (110 + (180 - 110) * p).round();
    fillRect(c, 110, 104, right, 121, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangBieup(c);
    fillRect(c, 32, 52, 49, 172, stroke);
    fillRect(c, 85, 52, 102, 172, stroke);
    fillRect(c, 32, 104, 102, 121, stroke);
    fillRect(c, 32, 155, 102, 172, stroke);
    fillRect(c, 110, 52, 127, 172, stroke);
    fillRect(c, 163, 52, 180, 172, stroke);
    fillRect(c, 110, 104, 180, 121, stroke);
    final right = (110 + (180 - 110) * p).round();
    fillRect(c, 110, 155, right, 172, stroke);
    frames.add(c);
  }
  return frames;
}

void guideSsangSiot(img.Image c) {
  // Left ㅅ
  img.drawLine(
    c,
    x1: 74,
    y1: 70,
    x2: 38,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  img.drawLine(
    c,
    x1: 74,
    y1: 70,
    x2: 110,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  // Right ㅅ
  img.drawLine(
    c,
    x1: 150,
    y1: 70,
    x2: 114,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  img.drawLine(
    c,
    x1: 150,
    y1: 70,
    x2: 186,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
}

List<img.Image> framesSsangSiot() {
  const f = 10;
  final frames = <img.Image>[];

  for (int i = 0; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangSiot(c);
    final x = (74 + (38 - 74) * p).round();
    final y = (70 + (154 - 70) * p).round();
    img.drawLine(c,
        x1: 74, y1: 70, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangSiot(c);
    img.drawLine(c,
        x1: 74, y1: 70, x2: 38, y2: 154, color: stroke, thickness: 18.0);
    final x = (74 + (110 - 74) * p).round();
    final y = (70 + (154 - 70) * p).round();
    img.drawLine(c,
        x1: 74, y1: 70, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangSiot(c);
    img.drawLine(c,
        x1: 74, y1: 70, x2: 38, y2: 154, color: stroke, thickness: 18.0);
    img.drawLine(c,
        x1: 74, y1: 70, x2: 110, y2: 154, color: stroke, thickness: 18.0);
    final x = (150 + (114 - 150) * p).round();
    final y = (70 + (154 - 70) * p).round();
    img.drawLine(c,
        x1: 150, y1: 70, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangSiot(c);
    img.drawLine(c,
        x1: 74, y1: 70, x2: 38, y2: 154, color: stroke, thickness: 18.0);
    img.drawLine(c,
        x1: 74, y1: 70, x2: 110, y2: 154, color: stroke, thickness: 18.0);
    img.drawLine(c,
        x1: 150, y1: 70, x2: 114, y2: 154, color: stroke, thickness: 18.0);
    final x = (150 + (186 - 150) * p).round();
    final y = (70 + (154 - 70) * p).round();
    img.drawLine(c,
        x1: 150, y1: 70, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  return frames;
}

void guideSsangJieut(img.Image c) {
  // Left ㅈ
  fillRect(c, 38, 62, 110, 79, guide);
  img.drawLine(
    c,
    x1: 74,
    y1: 79,
    x2: 38,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  img.drawLine(
    c,
    x1: 74,
    y1: 79,
    x2: 110,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  // Right ㅈ
  fillRect(c, 114, 62, 186, 79, guide);
  img.drawLine(
    c,
    x1: 150,
    y1: 79,
    x2: 114,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
  img.drawLine(
    c,
    x1: 150,
    y1: 79,
    x2: 186,
    y2: 154,
    color: guide,
    thickness: 18.0,
  );
}

List<img.Image> framesSsangJieut() {
  const f = 9;
  final frames = <img.Image>[];

  for (int i = 0; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangJieut(c);
    final right = (38 + (110 - 38) * p).round();
    fillRect(c, 38, 62, right, 79, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangJieut(c);
    fillRect(c, 38, 62, 110, 79, stroke);
    final x = (74 + (38 - 74) * p).round();
    final y = (79 + (154 - 79) * p).round();
    img.drawLine(c,
        x1: 74, y1: 79, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangJieut(c);
    fillRect(c, 38, 62, 110, 79, stroke);
    img.drawLine(c,
        x1: 74, y1: 79, x2: 38, y2: 154, color: stroke, thickness: 18.0);
    final x = (74 + (110 - 74) * p).round();
    final y = (79 + (154 - 79) * p).round();
    img.drawLine(c,
        x1: 74, y1: 79, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangJieut(c);
    fillRect(c, 38, 62, 110, 79, stroke);
    img.drawLine(c,
        x1: 74, y1: 79, x2: 38, y2: 154, color: stroke, thickness: 18.0);
    img.drawLine(c,
        x1: 74, y1: 79, x2: 110, y2: 154, color: stroke, thickness: 18.0);
    final right = (114 + (186 - 114) * p).round();
    fillRect(c, 114, 62, right, 79, stroke);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangJieut(c);
    fillRect(c, 38, 62, 110, 79, stroke);
    img.drawLine(c,
        x1: 74, y1: 79, x2: 38, y2: 154, color: stroke, thickness: 18.0);
    img.drawLine(c,
        x1: 74, y1: 79, x2: 110, y2: 154, color: stroke, thickness: 18.0);
    fillRect(c, 114, 62, 186, 79, stroke);
    final x = (150 + (114 - 150) * p).round();
    final y = (79 + (154 - 79) * p).round();
    img.drawLine(c,
        x1: 150, y1: 79, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  for (int i = 1; i <= f; i++) {
    final p = i / f;
    final c = canvas();
    guideSsangJieut(c);
    fillRect(c, 38, 62, 110, 79, stroke);
    img.drawLine(c,
        x1: 74, y1: 79, x2: 38, y2: 154, color: stroke, thickness: 18.0);
    img.drawLine(c,
        x1: 74, y1: 79, x2: 110, y2: 154, color: stroke, thickness: 18.0);
    fillRect(c, 114, 62, 186, 79, stroke);
    img.drawLine(c,
        x1: 150, y1: 79, x2: 114, y2: 154, color: stroke, thickness: 18.0);
    final x = (150 + (186 - 150) * p).round();
    final y = (79 + (154 - 79) * p).round();
    img.drawLine(c,
        x1: 150, y1: 79, x2: x, y2: y, color: stroke, thickness: 18.0);
    frames.add(c);
  }
  return frames;
}

void writeGif(String path, List<img.Image> frames) {
  final centeredFrames = centerFramesByFinalBounds(frames);
  final enc = img.GifEncoder(repeat: 0);
  for (final f in centeredFrames) {
    enc.addFrame(f, duration: 5);
  }
  final bytes = enc.finish();
  File(path)
    ..createSync(recursive: true)
    ..writeAsBytesSync(bytes!);
}

void main() {
  final out = Directory('assets/hangul/stroke_order');
  out.createSync(recursive: true);

  writeGif('${out.path}/u3131.gif', framesGiyeok());
  writeGif('${out.path}/u3132.gif', framesSsangGiyeok());
  writeGif('${out.path}/u3134.gif', framesNieun());
  writeGif('${out.path}/u3137.gif', framesDigeut());
  writeGif('${out.path}/u3138.gif', framesSsangDigeut());
  writeGif('${out.path}/u3139.gif', framesRieul());
  writeGif('${out.path}/u3141.gif', framesMieum());
  writeGif('${out.path}/u3142.gif', framesBieup());
  writeGif('${out.path}/u3143.gif', framesSsangBieup());
  writeGif('${out.path}/u3145.gif', framesSiot());
  writeGif('${out.path}/u3146.gif', framesSsangSiot());
  writeGif('${out.path}/u3147.gif', framesIeung());
  writeGif('${out.path}/u3148.gif', framesJieut());
  writeGif('${out.path}/u3149.gif', framesSsangJieut());
  writeGif('${out.path}/u314a.gif', framesChieut());
  writeGif('${out.path}/u314b.gif', framesKieuk());
  writeGif('${out.path}/u314c.gif', framesTieut());
  writeGif('${out.path}/u314d.gif', framesPieup());
  writeGif('${out.path}/u314e.gif', framesHieut());
  writeGif('${out.path}/u314f.gif', framesA());
  writeGif('${out.path}/u3150.gif', framesAe());
  writeGif('${out.path}/u3151.gif', framesYa());
  writeGif('${out.path}/u3152.gif', framesYae());
  writeGif('${out.path}/u3153.gif', framesEo());
  writeGif('${out.path}/u3154.gif', framesE());
  writeGif('${out.path}/u3155.gif', framesYeo());
  writeGif('${out.path}/u3156.gif', framesYe());
  writeGif('${out.path}/u3157.gif', framesO());
  writeGif('${out.path}/u3158.gif', framesWa());
  writeGif('${out.path}/u3159.gif', framesWae());
  writeGif('${out.path}/u315a.gif', framesOe());
  writeGif('${out.path}/u315b.gif', framesYo());
  writeGif('${out.path}/u315c.gif', framesU());
  writeGif('${out.path}/u315d.gif', framesWo());
  writeGif('${out.path}/u315e.gif', framesWe());
  writeGif('${out.path}/u315f.gif', framesWi());
  writeGif('${out.path}/u3160.gif', framesYu());
  writeGif('${out.path}/u3161.gif', framesEu());
  writeGif('${out.path}/u3162.gif', framesUi());
  writeGif('${out.path}/u3163.gif', framesI());

  stdout.writeln('generated ${out.path}/u3131.gif');
  stdout.writeln('generated ${out.path}/u3132.gif');
  stdout.writeln('generated ${out.path}/u3134.gif');
  stdout.writeln('generated ${out.path}/u3137.gif');
  stdout.writeln('generated ${out.path}/u3138.gif');
  stdout.writeln('generated ${out.path}/u3139.gif');
  stdout.writeln('generated ${out.path}/u3141.gif');
  stdout.writeln('generated ${out.path}/u3142.gif');
  stdout.writeln('generated ${out.path}/u3143.gif');
  stdout.writeln('generated ${out.path}/u3145.gif');
  stdout.writeln('generated ${out.path}/u3146.gif');
  stdout.writeln('generated ${out.path}/u3147.gif');
  stdout.writeln('generated ${out.path}/u3148.gif');
  stdout.writeln('generated ${out.path}/u3149.gif');
  stdout.writeln('generated ${out.path}/u314a.gif');
  stdout.writeln('generated ${out.path}/u314b.gif');
  stdout.writeln('generated ${out.path}/u314c.gif');
  stdout.writeln('generated ${out.path}/u314d.gif');
  stdout.writeln('generated ${out.path}/u314e.gif');
  stdout.writeln('generated ${out.path}/u314f.gif');
  stdout.writeln('generated ${out.path}/u3150.gif');
  stdout.writeln('generated ${out.path}/u3151.gif');
  stdout.writeln('generated ${out.path}/u3152.gif');
  stdout.writeln('generated ${out.path}/u3153.gif');
  stdout.writeln('generated ${out.path}/u3154.gif');
  stdout.writeln('generated ${out.path}/u3155.gif');
  stdout.writeln('generated ${out.path}/u3156.gif');
  stdout.writeln('generated ${out.path}/u3157.gif');
  stdout.writeln('generated ${out.path}/u3158.gif');
  stdout.writeln('generated ${out.path}/u3159.gif');
  stdout.writeln('generated ${out.path}/u315a.gif');
  stdout.writeln('generated ${out.path}/u315b.gif');
  stdout.writeln('generated ${out.path}/u315c.gif');
  stdout.writeln('generated ${out.path}/u315d.gif');
  stdout.writeln('generated ${out.path}/u315e.gif');
  stdout.writeln('generated ${out.path}/u315f.gif');
  stdout.writeln('generated ${out.path}/u3160.gif');
  stdout.writeln('generated ${out.path}/u3161.gif');
  stdout.writeln('generated ${out.path}/u3162.gif');
  stdout.writeln('generated ${out.path}/u3163.gif');
}
