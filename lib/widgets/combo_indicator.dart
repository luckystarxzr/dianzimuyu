import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ComboIndicator extends StatelessWidget {
  final int combo;
  final bool visible;

  const ComboIndicator({super.key, required this.combo, this.visible = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: visible ? 1.0 : 0.0,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 200),
        style: TextStyle(
          fontSize: combo >= 10 ? 18 : 14,
          fontWeight: FontWeight.w700,
          color: AppTheme.gold,
          letterSpacing: 1,
        ),
        child: Text(combo >= 10 ? '🔥 $combo 连击!' : '🔥 $combo 连击'),
      ),
    );
  }
}
