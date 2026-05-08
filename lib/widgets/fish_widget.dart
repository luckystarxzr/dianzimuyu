import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FishWidget extends StatelessWidget {
  final double squishScale;
  final void Function() onTap;
  final void Function()? onLongPress;
  final void Function(double delta)? onSwipe;

  const FishWidget({
    super.key,
    this.squishScale = 1.0,
    required this.onTap,
    this.onLongPress,
    this.onSwipe,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onVerticalDragUpdate: onSwipe != null
          ? (details) => onSwipe!(details.delta.dy)
          : null,
      child: Transform.scale(
        scaleX: 1 / squishScale,
        scaleY: squishScale,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            gradient: const RadialGradient(
              center: Alignment(0.45, 0.3),
              radius: 0.65,
              colors: [
                Color(0xFFc9953a),
                Color(0xFF8b6914),
                Color(0xFF6b4c20),
                Color(0xFF4a2a10),
                Color(0xFF302010),
              ],
              stops: [0.0, 0.3, 0.55, 0.85, 1.0],
            ),
            borderRadius: BorderRadius.circular(70),
            boxShadow: AppTheme.fishShadow,
            border: Border.all(color: const Color(0xFF5a3a18), width: 3),
          ),
          child: Stack(
            children: [
              // Highlight
              Positioned(
                top: 15,
                left: 20,
                width: 42,
                height: 35,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withAlpha(35),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              // Fish eye / face detail
              Positioned(
                top: 42,
                right: 30,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(100),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFd4a853).withAlpha(30),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
