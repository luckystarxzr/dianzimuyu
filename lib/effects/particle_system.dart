import 'dart:math';
import 'package:flutter/material.dart';
import '../models/particle.dart';

class ParticleSystem extends CustomPainter {
  final List<Particle> particles;
  final Random _r = Random();

  ParticleSystem({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = p.color.withAlpha(((p.color.a * 255).round() * p.alpha).round())
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rotation);

      if (p.size > 2.5) {
        final rect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size * 1.5, height: p.size),
          const Radius.circular(1),
        );
        canvas.drawRRect(rect, paint);
      } else {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ParticleSystem oldDelegate) => true;

  void updateParticles(double dt, double w, double h) {
    for (final p in particles) {
      p.update(dt);
    }
    particles.removeWhere((p) => p.isDead);
  }

  void spawnAmbient(double w, double h) {
    if (particles.length < 40) {
      particles.add(Particle.ambientGold(_r, w, h));
    }
  }

  void spawnConfetti(double w, double h) {
    for (int i = 0; i < 20; i++) {
      particles.add(Particle.confetti(_r, w, h));
    }
  }
}
