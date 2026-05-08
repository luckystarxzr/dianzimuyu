import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Primary Colors - 更丰富的配色系统
  static const Color bg0 = Color(0xFF0d0703);
  static const Color bg1 = Color(0xFF1a0f06);
  static const Color bg2 = Color(0xFF241008);
  static const Color bg3 = Color(0xFF0a0502);

  // Gold & Accents - 更精致的金色系
  static const Color gold = Color(0xFFd4a853);
  static const Color goldLight = Color(0xFFf0d88a);
  static const Color goldDark = Color(0xFFb87f28);
  static const Color goldPale = Color(0xFFe6d4a8);
  static const Color goldBright = Color(0xFFffe499);

  // Wood Tones - 更自然的木色
  static const Color wood = Color(0xFF8b5e3c);
  static const Color woodDark = Color(0xFF5a3a1e);
  static const Color woodLight = Color(0xFFa87a52);
  static const Color woodDeep = Color(0xFF3a1a0a);

  // Secondary Colors
  static const Color jade = Color(0xFF6b8e6e);
  static const Color red = Color(0xFFc0392b);
  static const Color paper = Color(0xFFf7ecd9);

  // Neutral
  static const Color textPrimary = Color(0xFFf5e6d0);
  static const Color textSecondary = Color(0xFFd4c4a8);

  // Background Gradients - 更有层次感的背景
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment(0.0, -1.0),
    end: Alignment(0.0, 1.0),
    colors: [
      Color(0xFF0d0703),
      Color(0xFF1a0f06),
      Color(0xFF241008),
      Color(0xFF0a0502),
    ],
    stops: [0.0, 0.25, 0.65, 1.0],
  );

  static const RadialGradient bgGlow = RadialGradient(
    center: Alignment(0.0, -0.5),
    radius: 0.9,
    colors: [
      Color(0x33d4a853),
      Color(0x1a3a1a0a),
      Colors.transparent,
    ],
    stops: [0.0, 0.5, 1.0],
  );

  // Button Gradients - 更精致的按钮
  static const LinearGradient btnGold = LinearGradient(
    begin: Alignment(-0.9, -1.0),
    end: Alignment(0.9, 1.0),
    colors: [
      Color(0xFFf0d88a),
      Color(0xFFd4a853),
      Color(0xFFb87f28),
      Color(0xFF8b5a1a),
    ],
    stops: [0.0, 0.25, 0.65, 1.0],
  );

  static const LinearGradient btnGoldPale = LinearGradient(
    begin: Alignment(-0.8, -1.0),
    end: Alignment(0.8, 1.0),
    colors: [
      Color(0xFFf0d88a),
      Color(0xFFc9953a),
    ],
    stops: [0.0, 1.0],
  );

  // Card Gradients - 更精致的卡片
  static const BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(28)),
    boxShadow: [
      BoxShadow(
        color: Color(0x80000000),
        blurRadius: 32,
        offset: Offset(0, 12),
        spreadRadius: 3,
      ),
      BoxShadow(
        color: Color(0x40d4a853),
        blurRadius: 16,
        offset: Offset(0, 0),
        spreadRadius: 0,
      ),
    ],
  );

  static const BoxDecoration cardLight = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(24)),
    boxShadow: [
      BoxShadow(
        color: Color(0x60000000),
        blurRadius: 20,
        offset: Offset(0, 6),
        spreadRadius: 1,
      ),
    ],
  );

  // Fish Gradients - 更真实的木鱼渐变
  static const RadialGradient fishGradient = RadialGradient(
    center: Alignment(0.4, -0.3),
    radius: 1.0,
    colors: [
      Color(0xFFe6c78a),
      Color(0xFFd4a853),
      Color(0xFFa87a52),
      Color(0xFF6b3f24),
      Color(0xFF3a1a0a),
    ],
    stops: [0.0, 0.25, 0.55, 0.85, 1.0],
  );

  // Shadows - 更有质感的阴影
  static List<BoxShadow> get fishShadow => const [
    BoxShadow(
      color: Color(0x8a000000),
      blurRadius: 48,
      offset: Offset(0, 16),
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Color(0x40d4a853),
      blurRadius: 24,
      offset: Offset(0, 0),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x40ffffff),
      blurRadius: 0,
      offset: Offset(0, 2),
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(
      color: Color(0x60000000),
      blurRadius: 16,
      offset: Offset(0, -6),
      blurStyle: BlurStyle.inner,
    ),
  ];

  static List<BoxShadow> get softShadow => const [
    BoxShadow(
      color: Color(0x50000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static List<BoxShadow> get glowShadow => const [
    BoxShadow(
      color: Color(0x50d4a853),
      blurRadius: 32,
      offset: Offset(0, 0),
      spreadRadius: 2,
    ),
    BoxShadow(
      color: Color(0x60000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  // Text Styles - 更精致的文字样式
  static TextStyle get titleStyle => const TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    color: goldLight,
    letterSpacing: 4,
    height: 1.1,
  );

  static TextStyle get meritStyle => TextStyle(
    fontSize: 52,
    fontWeight: FontWeight.w900,
    color: goldBright,
    letterSpacing: 2,
    shadows: [
      Shadow(
        color: Color(0x80d4a853),
        blurRadius: 48,
        offset: const Offset(0, 2),
      ),
      Shadow(
        color: Color(0x60d4a853),
        blurRadius: 24,
      ),
    ],
  );

  static TextStyle get phraseStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: goldPale.withAlpha(240),
    letterSpacing: 0.8,
    height: 1.3,
  );

  static TextStyle get labelStyle => TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: gold.withAlpha(180),
    letterSpacing: 1.5,
  );

  // Animation Durations
  static const Duration animFast = Duration(milliseconds: 120);
  static const Duration animNormal = Duration(milliseconds: 250);
  static const Duration animSlow = Duration(milliseconds: 450);
  static const Duration animVerySlow = Duration(milliseconds: 700);

  // Border Radius
  static BorderRadius get radiusSmall => BorderRadius.circular(12);
  static BorderRadius get radiusMedium => BorderRadius.circular(18);
  static BorderRadius get radiusLarge => BorderRadius.circular(24);
  static BorderRadius get radiusXL => BorderRadius.circular(32);
  static BorderRadius get radiusXXL => BorderRadius.circular(40);

  // Spacing
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double spaceXxl = 32;
  static const double space3xl = 48;

  // Opacity Levels
  static const double opacityLow = 0.25;
  static const double opacityMedium = 0.5;
  static const double opacityHigh = 0.75;
}
