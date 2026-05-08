import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FloatingTextItem {
  final String text;
  double progress = 0.0;
  double opacity = 0.0;

  FloatingTextItem({required this.text});

  bool get isDead => opacity <= 0;

  void update(double dt) {
    progress += dt * 0.7;
    opacity = progress < 0.15
        ? progress / 0.15
        : 1.0 - (progress - 0.15) / 0.85;
  }

  Widget build(BuildContext context) {
    return Positioned(
      top: 120 - progress * 100,
      left: 60 + (progress * 30),
      child: Opacity(
        opacity: opacity.clamp(0.0, 1.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: AppTheme.goldLight,
            shadows: [
              Shadow(
                color: Color(0x60d4a853),
                blurRadius: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
