import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../models/game_state.dart';
import 'wooden_fish_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _buttonController;
  late Animation<double> _breatheAnim;
  late Animation<double> _shimmerAnim;
  late Animation<double> _buttonScaleAnim;
  DailyFortune? _todayFortune;
  bool _hasDrawnFortune = false;
  bool _showFortuneCard = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _buttonController = AnimationController(
      vsync: this,
      duration: AppTheme.animNormal,
    );

    _breatheAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: const SineCurve()),
    );

    _shimmerAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _buttonScaleAnim = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _checkTodayFortune();
  }

  Future<void> _checkTodayFortune() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final savedDate = prefs.getString('lastFortuneDate');
    final savedIndex = prefs.getInt('fortuneIndex');

    if (savedDate == today && savedIndex != null) {
      setState(() {
        _todayFortune = FortuneDatabase.getFortune(savedIndex);
        _hasDrawnFortune = true;
      });
    }
  }

  Future<void> _drawFortune() async {
    if (_hasDrawnFortune || _isLoading) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));

    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final index = DateTime.now().millisecondsSinceEpoch % 100 + Random().nextInt(100);

    setState(() {
      _todayFortune = FortuneDatabase.getFortune(index);
      _hasDrawnFortune = true;
      _showFortuneCard = true;
      _isLoading = false;
    });

    await prefs.setString('lastFortuneDate', today);
    await prefs.setInt('fortuneIndex', index);
  }

  @override
  void dispose() {
    _controller.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _navigateToFish() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const WoodenFishScreen(),
        transitionsBuilder: (_, anim, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: anim,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Stack(
          children: [
            _buildBackgroundGlow(),
            _buildDecorativeParticles(),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spaceXl,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 32),
                      _buildHeaderIcon(),
                      const SizedBox(height: 20),
                      _buildTitle(),
                      const SizedBox(height: 40),
                      _buildFortuneSection(),
                      const SizedBox(height: 40),
                      _buildMainButton(),
                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),
            ),
            _buildFortuneModal(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundGlow() {
    return IgnorePointer(
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(gradient: AppTheme.bgGlow),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecorativeParticles() {
    return Positioned.fill(
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: _ParticlePainter(_controller.value),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeaderIcon() {
    return AnimatedBuilder(
      animation: _breatheAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _breatheAnim.value,
          child: Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Color(0x50D4A853),
                  Color(0x203A1A0A),
                  Colors.transparent,
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Center(
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: AppTheme.glowShadow,
                  gradient: const RadialGradient(
                    colors: [
                      Color(0x40D4A853),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              const Color(0xFF3A1A0A),
                              const Color(0xFF240E06),
                            ],
                          ),
                          border: Border.all(
                            color: const Color(0x60D4A853),
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const Center(
                      child: Text(
                        '🙏',
                        style: TextStyle(
                          fontSize: 48,
                          shadows: [
                            Shadow(
                              color: Color(0x80D4A853),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle() {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                AppTheme.goldPale,
                AppTheme.goldLight,
                AppTheme.goldBright,
                AppTheme.goldLight,
                AppTheme.goldPale,
              ],
              stops: [
                0.0,
                _shimmerAnim.value * 0.3,
                _shimmerAnim.value * 0.5,
                _shimmerAnim.value * 0.7,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: const Text(
            '电子祈福',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Widget _buildFortuneSection() {
    return AnimatedContainer(
      duration: AppTheme.animNormal,
      curve: Curves.easeOutCubic,
      child: Column(
        children: [
          if (_todayFortune != null)
            _buildFortuneCard()
          else
            _buildDrawFortuneButton(),
        ],
      ),
    );
  }

  Widget _buildDrawFortuneButton() {
    return GestureDetector(
      onTap: _drawFortune,
      child: Container(
        width: 260,
        height: 180,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.9, -1.0),
            end: const Alignment(0.9, 1.0),
            colors: const [
              Color(0xD03A1A0A),
              Color(0x99240E06),
            ],
          ),
          border: Border.all(
            color: const Color(0x80D4A853),
            width: 2,
          ),
          borderRadius: AppTheme.radiusXXL,
          boxShadow: const [
            BoxShadow(
              color: Color(0x40D4A853),
              blurRadius: 32,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Color(0x60000000),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: _isLoading
            ? const Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                    strokeWidth: 3,
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '🎐',
                    style: TextStyle(fontSize: 44),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '今日求签',
                    style: TextStyle(
                      color: AppTheme.goldLight,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '开启一天的好运',
                    style: TextStyle(
                      color: Color(0xB0D4A853),
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildFortuneCard() {
    final fortune = _todayFortune!;

    return Container(
      width: 320,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.9, -1.0),
          end: const Alignment(0.9, 1.0),
          colors: const [
            Color(0xDD3A1A0A),
            Color(0xBB240E06),
          ],
        ),
        border: Border.all(
          color: const Color(0x90D4A853),
          width: 2,
        ),
        borderRadius: AppTheme.radiusXXL,
        boxShadow: const [
          BoxShadow(
            color: Color(0x40D4A853),
            blurRadius: 36,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color(0x60000000),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            fortune.title,
            style: TextStyle(
              color: _getFortuneColor(fortune.level),
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 100,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getFortuneColor(fortune.level).withAlpha(0),
                  _getFortuneColor(fortune.level),
                  _getFortuneColor(fortune.level).withAlpha(0),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            fortune.content,
            style: const TextStyle(
              color: Color(0xE6E6D4A8),
              fontSize: 17,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMainButton() {
    return AnimatedBuilder(
      animation: _buttonScaleAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _buttonScaleAnim.value,
          child: child,
        );
      },
      child: Container(
        width: 280,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: AppTheme.radiusXXL,
          boxShadow: const [
            BoxShadow(
              color: Color(0x50D4A853),
              blurRadius: 40,
              offset: Offset(0, 0),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Color(0x60000000),
              blurRadius: 32,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: GestureDetector(
          onTapDown: (_) => _buttonController.forward(),
          onTapUp: (_) {
            _buttonController.reverse();
            _navigateToFish();
          },
          onTapCancel: () => _buttonController.reverse(),
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.btnGold,
              borderRadius: AppTheme.radiusXXL,
              border: Border.all(
                color: const Color(0x80F0D88A),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                const Positioned.fill(
                  child: Center(
                    child: Text(
                      '敲 木 鱼',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 5,
                        shadows: [
                          Shadow(
                            color: Color(0x40000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x50FFFFFF),
                          Colors.transparent,
                          Colors.transparent,
                          Color(0x30000000),
                        ],
                        stops: [0.0, 0.25, 0.65, 1.0],
                      ),
                      borderRadius: AppTheme.radiusXXL,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFortuneModal() {
    if (!_showFortuneCard) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => setState(() => _showFortuneCard = false),
      child: AnimatedContainer(
        duration: AppTheme.animNormal,
        curve: Curves.easeOut,
        color: const Color(0xCC000000),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: AppTheme.animSlow,
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: _buildFortuneCardModal(),
          ),
        ),
      ),
    );
  }

  Widget _buildFortuneCardModal() {
    final fortune = _todayFortune!;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(-0.9, -1.0),
          end: const Alignment(0.9, 1.0),
          colors: const [
            Color(0xFF3A1A0A),
            Color(0xFF240E06),
          ],
        ),
        border: Border.all(
          color: const Color(0xB0D4A853),
          width: 3,
        ),
        borderRadius: AppTheme.radiusXXL,
        boxShadow: const [
          BoxShadow(
            color: Color(0x60D4A853),
            blurRadius: 72,
            spreadRadius: 6,
          ),
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 48,
            offset: Offset(0, 24),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎋',
            style: TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 16),
          Text(
            fortune.title,
            style: TextStyle(
              color: _getFortuneColor(fortune.level),
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 140,
            height: 4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _getFortuneColor(fortune.level).withAlpha(0),
                  _getFortuneColor(fortune.level),
                  _getFortuneColor(fortune.level).withAlpha(0),
                ],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            fortune.content,
            style: const TextStyle(
              color: Color(0xF5E6D4A8),
              fontSize: 19,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          GestureDetector(
            onTap: () => setState(() => _showFortuneCard = false),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 48,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                gradient: AppTheme.btnGold,
                borderRadius: AppTheme.radiusXL,
                border: Border.all(
                  color: const Color(0x80F0D88A),
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x50D4A853),
                    blurRadius: 28,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: const Text(
                '收下好运',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getFortuneColor(String level) {
    switch (level) {
      case 'great':
        return const Color(0xFFffd700);
      case 'good':
        return const Color(0xFFffb347);
      case 'normal':
        return const Color(0xFFb8e186);
      case 'ordinary':
        return const Color(0xFF87ceeb);
      case 'bad':
        return const Color(0xFFa0a0a0);
      default:
        return AppTheme.gold;
    }
  }
}

class SineCurve extends Curve {
  const SineCurve();
  @override
  double transformInternal(double t) => sin(t * 3.14159 * 2) * 0.5 + 0.5;
}

class _ParticlePainter extends CustomPainter {
  final double animation;

  _ParticlePainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final particles = [
      (offset: Offset(size.width * 0.1, size.height * 0.2), size: 4.0),
      (offset: Offset(size.width * 0.9, size.height * 0.15), size: 3.0),
      (offset: Offset(size.width * 0.15, size.height * 0.8), size: 5.0),
      (offset: Offset(size.width * 0.85, size.height * 0.75), size: 3.5),
      (offset: Offset(size.width * 0.5, size.height * 0.1), size: 4.5),
      (offset: Offset(size.width * 0.3, size.height * 0.9), size: 3.0),
      (offset: Offset(size.width * 0.7, size.height * 0.85), size: 4.0),
    ];

    final paint = Paint()
      ..color = const Color(0x60D4A853)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    for (var i = 0; i < particles.length; i++) {
      final particle = particles[i];
      final phase = (animation + i * 0.2) % 1.0;
      final scale = 0.6 + sin(phase * pi * 2) * 0.4;
      final opacity = 0.3 + sin(phase * pi * 2) * 0.3;

      canvas.drawCircle(
        particle.offset,
        particle.size * scale,
        paint..color = const Color(0x60D4A853).withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
