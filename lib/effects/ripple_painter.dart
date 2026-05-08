import 'package:flutter/material.dart';

class Ripple {
  final Offset center;
  double radius;
  double opacity;
  final double maxRadius;

  Ripple({
    required this.center,
    required this.maxRadius,
    this.radius = 0,
    this.opacity = 0.6,
  });

  bool get isDead => opacity <= 0;
}

class RipplePainter extends CustomPainter {
  final List<Ripple> ripples;

  RipplePainter({required this.ripples});

  @override
  void paint(Canvas canvas, Size size) {
    for (final r in ripples) {
      final paint = Paint()
        ..color = const Color(0xFFd4a853).withAlpha((0.6 * r.opacity * 255).round())
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0 * r.opacity.clamp(0.3, 1.0);

      canvas.drawCircle(r.center, r.radius, paint);
    }
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) => true;

  void updateRipples(double dt) {
    for (final r in ripples) {
      r.radius += 120 * dt;
      r.opacity -= 1.2 * dt;
    }
    ripples.removeWhere((r) => r.isDead);
  }

  void addRipple(Offset center, {double maxRadius = 80}) {
    ripples.add(Ripple(center: center, maxRadius: maxRadius));
  }
}
