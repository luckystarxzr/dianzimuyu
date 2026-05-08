import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MeritDisplay extends StatelessWidget {
  final int merit;
  final int combo;

  const MeritDisplay({super.key, required this.merit, this.combo = 0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '累计功德',
          style: TextStyle(
            color: AppTheme.gold.withAlpha(180),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: TextStyle(
            fontSize: 42.0 + (combo > 5 ? min(combo * 0.5, 12.0) : 0),
            fontWeight: FontWeight.w900,
            color: AppTheme.goldLight,
            shadows: [
              Shadow(
                color: AppTheme.gold.withAlpha(
                  (80 + (combo > 3 ? min(combo * 15, 120) : 0)).round(),
                ),
                blurRadius: 20 + (combo > 5 ? min(combo * 2, 20) : 0),
              ),
            ],
          ),
          child: Text('$merit'),
        ),
      ],
    );
  }

  double min(double a, double b) => a < b ? a : b;
}
