import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

void main() {
  const size = 1024;
  final canvas = img.Image(width: size, height: size);

  // Background radial gradient (ink -> aqua)
  const bg1 = 0xFF0B0D14; // ink
  const bg2 = 0xFF11202A; // darker ink
  for (int y = 0; y < size; y++) {
    for (int x = 0; x < size; x++) {
      final dx = x - size / 2;
      final dy = y - size / 2;
      final r = math.sqrt(dx * dx + dy * dy) / (size / 2);
      final t = r.clamp(0.0, 1.0);
      final c = _lerpColor(bg1, bg2, t.toDouble());
      final rr = (c >> 16) & 0xFF, gg = (c >> 8) & 0xFF, bb = c & 0xFF;
      canvas.setPixelRgba(x, y, rr, gg, bb, 255);
    }
  }

  // Neon circle badge
  final badge = img.Image(width: 780, height: 780);
  for (int y = 0; y < badge.height; y++) {
    for (int x = 0; x < badge.width; x++) {
      final dx = x - badge.width / 2;
      final dy = y - badge.height / 2;
      final r = math.sqrt(dx * dx + dy * dy) / (badge.width / 2);
      if (r <= 1.0) {
        final c = _lerpColor(0xFF00E5FF, 0xFFFF2FB9, y / badge.height);
        final rr = (c >> 16) & 0xFF, gg = (c >> 8) & 0xFF, bb = c & 0xFF;
        badge.setPixelRgba(x, y, rr, gg, bb, 255);
      } else {
        badge.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }
  img.compositeImage(canvas, badge, dstX: (size - badge.width) ~/ 2, dstY: (size - badge.height) ~/ 2, dstW: badge.width, dstH: badge.height);

  // White equalizer bars
  const barCount = 7;
  const barWidth = 50;
  const gap = 30;
  const totalWidth = barCount * barWidth + (barCount - 1) * gap;
  int startX = (size - totalWidth) ~/ 2;
  const centerY = size ~/ 2;
  final heights = [0.25, 0.45, 0.7, 0.85, 0.7, 0.45, 0.25];
  for (int i = 0; i < barCount; i++) {
    final h = (heights[i] * 380).toInt();
    img.fillRect(
      canvas,
      x1: startX,
      y1: centerY - h ~/ 2,
      x2: startX + barWidth,
      y2: centerY + h ~/ 2,
      color: img.ColorRgba8(255, 255, 255, 255),
    );
    startX += barWidth + gap;
  }

  final out = File('assets/vibequest_icon.png');
  out.createSync(recursive: true);
  out.writeAsBytesSync(img.encodePng(canvas));
  stdout.writeln('Generated assets/vibequest_icon.png');
}

int _lerpColor(int a, int b, double t) {
  final ar = (a >> 16) & 0xFF, ag = (a >> 8) & 0xFF, ab = a & 0xFF;
  final br = (b >> 16) & 0xFF, bg = (b >> 8) & 0xFF, bb = b & 0xFF;
  final rr = ar + ((br - ar) * t).round();
  final rg = ag + ((bg - ag) * t).round();
  final rb = ab + ((bb - ab) * t).round();
  return 0xFF000000 | (rr << 16) | (rg << 8) | rb;
}

