import 'package:flutter/material.dart';

class BackgroundTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gradient1 = RadialGradient(
      center: const Alignment(0.6, -0.4),
      radius: 0.55,
      colors: [
        const Color(0xFFd4a853).withAlpha(10),
        Colors.transparent,
      ],
    );

    final gradient2 = RadialGradient(
      center: const Alignment(-0.6, 0.6),
      radius: 0.45,
      colors: [
        const Color(0xFFd4a853).withAlpha(8),
        Colors.transparent,
      ],
    );

    final gradient3 = RadialGradient(
      center: const Alignment(0.8, 0.2),
      radius: 0.4,
      colors: [
        const Color(0xFF8b5e3c).withAlpha(10),
        Colors.transparent,
      ],
    );

    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()..shader = gradient1.createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient2.createShader(rect),
    );
    canvas.drawRect(
      rect,
      Paint()..shader = gradient3.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
