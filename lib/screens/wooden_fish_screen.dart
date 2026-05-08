import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';
import '../audio/sound_manager.dart';
import '../models/particle.dart';
import '../effects/particle_system.dart';
import '../effects/ripple_painter.dart';
import '../widgets/floating_text.dart';

class WoodenFishScreen extends StatefulWidget {
  const WoodenFishScreen({super.key});

  @override
  State<WoodenFishScreen> createState() => _WoodenFishScreenState();
}

class _WoodenFishScreenState extends State<WoodenFishScreen>
    with TickerProviderStateMixin {
  final SoundManager _sound = SoundManager();
  final Random _rng = Random();

  late Ticker _ticker;
  late AnimationController _squishController;
  late AnimationController _malletController;
  late AnimationController _glowController;
  late Animation<double> _squishAnim;
  late Animation<double> _glowAnim;

  double _malletAngle = -0.45;
  int _merit = 0;
  int _combo = 0;
  int _bestCombo = 0;
  int _tapCount = 0;
  int _lastTapTime = 0;
  bool _showCombo = false;

  bool _isAutoKnocking = false;
  int _autoKnockSpeed = 500;
  Timer? _autoKnockTimer;
  bool _showSettings = false;

  final List<Particle> _particles = [];
  final List<Ripple> _ripples = [];
  final List<FloatingTextItem> _floatTexts = [];
  late ParticleSystem _particlePainter;
  late RipplePainter _ripplePainter;

  static const List<String> _phrases = [
    '功德+1',
    '福报+1',
    '心平气和',
    '烦恼归零',
    '一切随缘',
    '顺其自然',
    '放下执念',
    '阿弥陀佛',
    '慢下来',
    '深呼吸',
    '活在当下',
    '万事如意',
  ];

  static const List<String> _comboPhrases = [
    '🙏 心流状态',
    '✨ 禅定境界',
    '🔥 功德无量',
    '💫 天人合一',
  ];

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick)..start();

    _squishController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _squishAnim = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _squishController, curve: Curves.elasticOut),
    );

    _malletController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _malletController.addListener(() {
      setState(() {
        _malletAngle = -0.45 + _malletController.value * 0.55;
      });
    });

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _glowAnim = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _particlePainter = ParticleSystem(particles: _particles);
    _ripplePainter = RipplePainter(ripples: _ripples);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      for (int i = 0; i < 25; i++) {
        _particles.add(Particle.ambientGold(_rng, size.width, size.height));
      }
      _sound.init();
      _sound.startBGM();
    });
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed.inMicroseconds / 1000000.0).clamp(0.001, 0.05);
    final size = MediaQuery.of(context).size;

    _particlePainter.updateParticles(dt, size.width, size.height);
    _particlePainter.spawnAmbient(size.width, size.height);
    _ripplePainter.updateRipples(dt);
    _updateFloatTexts(dt);

    setState(() {});
  }

  void _updateFloatTexts(double dt) {
    for (final ft in _floatTexts) {
      ft.update(dt);
    }
    _floatTexts.removeWhere((ft) => ft.isDead);
  }

  void _onFishTap() {
    final now = DateTime.now().millisecondsSinceEpoch;

    if (now - _lastTapTime < 600) {
      _combo++;
      if (_combo > _bestCombo) _bestCombo = _combo;
    } else {
      _combo = 1;
    }
    _lastTapTime = now;
    _tapCount++;

    final gain = 1 + (_combo ~/ 5);
    _merit += gain;

    _sound.playKnock();
    _sound.vibrate();

    if (_combo >= 3) {
      setState(() => _showCombo = true);
      if (_combo >= 10) _sound.playCombo();
    }

    _squishController.forward(from: 0);
    _malletController.forward(from: 0);

    _ripples.add(Ripple(
      center: const Offset(70, 70),
      maxRadius: 100,
      radius: 10,
      opacity: 0.7,
    ));

    String phrase;
    if (_combo >= 15) {
      phrase = _comboPhrases[_rng.nextInt(_comboPhrases.length)];
    } else {
      phrase = _phrases[_rng.nextInt(_phrases.length)];
    }
    _floatTexts.add(FloatingTextItem(text: phrase));

    if (_tapCount % 50 == 0) {
      _particlePainter.spawnConfetti(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      );
      _sound.playDouble();
    }

    setState(() {});
  }

  void _toggleAutoKnock() {
    setState(() => _isAutoKnocking = !_isAutoKnocking);
    if (_isAutoKnocking) {
      _autoKnockTimer = Timer.periodic(
        Duration(milliseconds: _autoKnockSpeed),
        (_) => _onFishTap(),
      );
    } else {
      _autoKnockTimer?.cancel();
    }
  }

  void _setAutoKnockSpeed(int speed) {
    setState(() {
      _autoKnockSpeed = speed;
      if (_isAutoKnocking) {
        _autoKnockTimer?.cancel();
        _autoKnockTimer = Timer.periodic(
          Duration(milliseconds: speed),
          (_) => _onFishTap(),
        );
      }
    });
  }

  void _setVibrationLevel(int level) {
    setState(() => _sound.vibrationLevel = level);
  }

  @override
  void dispose() {
    _sound.pauseBGM();
    _autoKnockTimer?.cancel();
    _ticker.dispose();
    _squishController.dispose();
    _malletController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
        child: Stack(
          children: [
            _buildBackground(),
            _buildHeader(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 80),
                  _buildMeritDisplay(),
                  const SizedBox(height: 24),
                  _buildFishArea(),
                  const SizedBox(height: 12),
                  _buildComboIndicator(),
                  const SizedBox(height: 8),
                  const Text(
                    '轻敲木鱼 · 功德无量',
                    style: TextStyle(
                      color: Color(0x99D4A853),
                      fontSize: 13,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildQuickPhrases(),
                  const SizedBox(height: 20),
                  _buildAutoKnockControl(),
                ],
              ),
            ),
            _buildRippleOverlay(),
            ..._floatTexts.map((ft) => _buildFloatTextWidget(ft)),
            _buildSoundToggle(),
            if (_showSettings) _buildSettingsPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
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
          Positioned.fill(
            child: CustomPaint(painter: _particlePainter),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildBackButton(),
            const Spacer(),
            _buildTapCounter(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0x1ED4A853),
          border: Border.all(color: const Color(0x80D4A853)),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x20D4A853),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '←',
            style: TextStyle(
              color: AppTheme.goldLight,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x993A1A0A),
        border: Border.all(color: const Color(0x60D4A853)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20D4A853),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        '敲击 $_tapCount',
        style: const TextStyle(
          color: AppTheme.goldLight,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildMeritDisplay() {
    return AnimatedBuilder(
      animation: _glowAnim,
      builder: (context, child) {
        return Transform.scale(
          scale: _glowAnim.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0x803A1A0A),
              border: Border.all(color: const Color(0x80D4A853), width: 2),
              borderRadius: BorderRadius.circular(28),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x40D4A853),
                  blurRadius: 32,
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Color(0x30000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  '功德',
                  style: TextStyle(
                    color: Color(0xD0E6D4A8),
                    fontSize: 16,
                    letterSpacing: 4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$_merit',
                  style: AppTheme.meritStyle,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFishArea() {
    return GestureDetector(
      onTap: _onFishTap,
      onVerticalDragUpdate: (details) {
        if (details.delta.dy.abs() > 5) _onFishTap();
      },
      child: SizedBox(
        width: 200,
        height: 220,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildMallet(),
            _buildWoodenFish(),
          ],
        ),
      ),
    );
  }

  Widget _buildMallet() {
    return Positioned(
      top: 0,
      child: Transform.rotate(
        angle: _malletAngle,
        child: Container(
          width: 28,
          height: 70,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFd89b4a),
                Color(0xFF8b5a1a),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x60000000),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWoodenFish() {
    return AnimatedBuilder(
      animation: _squishController,
      builder: (context, child) {
        final scaleY = _squishAnim.value;
        final scaleX = scaleY < 1.0 ? 1.0 + (1.0 - scaleY) * 0.6 : 1.0;

        return Transform(
          transform: Matrix4.identity()
            ..scale(scaleX, scaleY),
          alignment: Alignment.center,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              gradient: AppTheme.fishGradient,
              shape: BoxShape.circle,
              boxShadow: AppTheme.fishShadow,
              border: Border.all(
                color: const Color(0xFF5a3510),
                width: 3,
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 18,
                  left: 24,
                  width: 50,
                  height: 42,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [
                          Color(0x60FFFFFF),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 36,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0x90000000),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Positioned(
                  top: 48,
                  left: 40,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: const Color(0x90000000),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 52,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 14,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2a1508),
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                          blurStyle: BlurStyle.inner,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildComboIndicator() {
    if (!_showCombo || _combo < 3) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0x60D4A853),
            Color(0x20D4A853),
          ],
        ),
        border: Border.all(color: const Color(0x90D4A853), width: 2),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x30D4A853),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '🔥 $_combo连击',
        style: const TextStyle(
          color: AppTheme.goldBright,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.5,
          shadows: [
            Shadow(
              color: Color(0x80D4A853),
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickPhrases() {
    final phrases = [
      '心平气和',
      '烦恼归零',
      '一切随缘',
      '慢下来',
      '深呼吸',
      '活在当下',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: phrases.map((phrase) {
        return GestureDetector(
          onTap: () {
            _onFishTap();
            if (_floatTexts.isNotEmpty) {
              _floatTexts.last = FloatingTextItem(text: phrase);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x25D4A853),
              border: Border.all(color: const Color(0x70D4A853)),
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x15D4A853),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              phrase,
              style: AppTheme.phraseStyle,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAutoKnockControl() {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0x803A1A0A),
        border: Border.all(color: const Color(0x60D4A853), width: 1.5),
        borderRadius: AppTheme.radiusXL,
        boxShadow: const [
          BoxShadow(
            color: Color(0x20D4A853),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildAutoKnockButton(),
              const Spacer(),
              _buildSettingsButton(),
            ],
          ),
          if (_isAutoKnocking) ...[
            const SizedBox(height: 16),
            Text(
              '敲击速度',
              style: AppTheme.labelStyle,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSpeedButton(1000, '慢'),
                _buildSpeedButton(500, '中'),
                _buildSpeedButton(300, '快'),
                _buildSpeedButton(150, '极速'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAutoKnockButton() {
    return GestureDetector(
      onTap: _toggleAutoKnock,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _isAutoKnocking
              ? const Color(0x70D4A853)
              : const Color(0x25D4A853),
          border: Border.all(
            color: _isAutoKnocking
                ? const Color(0xB0D4A853)
                : const Color(0x80D4A853),
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isAutoKnocking
              ? const [
                  BoxShadow(
                    color: Color(0x30D4A853),
                    blurRadius: 16,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          _isAutoKnocking ? '⏸ 自动敲击中' : '▶ 自动敲击',
          style: TextStyle(
            color: _isAutoKnocking ? AppTheme.goldBright : AppTheme.goldLight,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsButton() {
    return GestureDetector(
      onTap: () => setState(() => _showSettings = !_showSettings),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0x25D4A853),
          border: Border.all(color: const Color(0x80D4A853)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Text(
          '⚙️',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildSpeedButton(int speed, String label) {
    final isSelected = _autoKnockSpeed == speed;
    return GestureDetector(
      onTap: () => _setAutoKnockSpeed(speed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x70D4A853)
              : const Color(0x20D4A853),
          border: Border.all(
            color: isSelected
                ? const Color(0xB0D4A853)
                : const Color(0x60D4A853),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.goldBright : AppTheme.goldLight,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsPanel() {
    return GestureDetector(
      onTap: () => setState(() => _showSettings = false),
      child: Container(
        color: const Color(0xD0000000),
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: AppTheme.animNormal,
            curve: Curves.elasticOut,
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: _buildSettingsCard(),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsCard() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(32),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '设置',
            style: TextStyle(
              color: AppTheme.goldBright,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            '震动强度',
            style: TextStyle(
              color: const Color(0xD0E6D4A8),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildVibrationButton(0, '无'),
              _buildVibrationButton(1, '轻'),
              _buildVibrationButton(2, '中'),
              _buildVibrationButton(3, '强'),
            ],
          ),
          const SizedBox(height: 40),
          _buildConfirmButton(),
        ],
      ),
    );
  }

  Widget _buildVibrationButton(int level, String label) {
    final isSelected = _sound.vibrationLevel == level;
    return GestureDetector(
      onTap: () => _setVibrationLevel(level),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0x70D4A853)
              : const Color(0x20D4A853),
          border: Border.all(
            color: isSelected
                ? const Color(0xB0D4A853)
                : const Color(0x60D4A853),
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.goldBright : AppTheme.goldLight,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: () => setState(() => _showSettings = false),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: AppTheme.btnGold,
          borderRadius: AppTheme.radiusXL,
          border: Border.all(
            color: const Color(0x90F0D88A),
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x50D4A853),
              blurRadius: 28,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            '确定',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
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
    );
  }

  Widget _buildRippleOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        child: CustomPaint(painter: _ripplePainter),
      ),
    );
  }

  Widget _buildFloatTextWidget(FloatingTextItem ft) {
    return ft.build(context);
  }

  Widget _buildSoundToggle() {
    return SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 12, right: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBGMToggle(),
              const SizedBox(width: 10),
              _buildSoundEffectToggle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBGMToggle() {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _sound.bgmEnabled = !_sound.bgmEnabled;
              if (_sound.bgmEnabled) {
                _sound.startBGM();
              } else {
                _sound.pauseBGM();
              }
            });
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x1ED4A853),
              border: Border.all(color: const Color(0x80D4A853)),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                _sound.bgmEnabled ? '🎵' : '🎶',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSoundEffectToggle() {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        return GestureDetector(
          onTap: () {
            setState(() => _sound.soundEnabled = !_sound.soundEnabled);
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x1ED4A853),
              border: Border.all(color: const Color(0x80D4A853)),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                _sound.soundEnabled ? '🔊' : '🔇',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
    );
  }
}
