import 'dart:math';
import 'dart:ui';

class Particle {
  double x;
  double y;
  double vx;
  double vy;
  double size;
  double life;
  double maxLife;
  Color color;
  double rotation;
  double rotationSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.size,
    required this.life,
    required this.maxLife,
    required this.color,
    this.rotation = 0,
    this.rotationSpeed = 0,
  });

  bool get isDead => life <= 0;

  double get alpha => (life / maxLife).clamp(0.0, 1.0);

  void update(double dt) {
    x += vx * dt;
    y += vy * dt;
    life -= dt;
    rotation += rotationSpeed * dt;
  }

  static Particle ambientGold(Random r, double w, double h) {
    return Particle(
      x: r.nextDouble() * w,
      y: h + r.nextDouble() * 20,
      vx: (r.nextDouble() - 0.5) * 4,
      vy: -(10 + r.nextDouble() * 15),
      size: 1.0 + r.nextDouble() * 2.5,
      life: 4 + r.nextDouble() * 4,
      maxLife: 8,
      color: Color.fromRGBO(
        212,
        168 + r.nextInt(40).toInt(),
        83 + r.nextInt(30).toInt(),
        r.nextDouble() * 0.5 + 0.2,
      ),
      rotation: r.nextDouble() * 6.28,
      rotationSpeed: (r.nextDouble() - 0.5) * 2,
    );
  }

  static Particle confetti(Random r, double w, double h) {
    const colors = [
      Color(0xFFd4a853),
      Color(0xFFe8c97a),
      Color(0xFFb8862d),
      Color(0xFFc0392b),
      Color(0xFF8a9b68),
      Color(0xFFa0724a),
    ];
    return Particle(
      x: r.nextDouble() * w * 0.9 + w * 0.05,
      y: -r.nextDouble() * h * 0.1,
      vx: (r.nextDouble() - 0.5) * 30,
      vy: 80 + r.nextDouble() * 60,
      size: 3 + r.nextDouble() * 4,
      life: 1.5 + r.nextDouble() * 1.5,
      maxLife: 3,
      color: colors[r.nextInt(colors.length)],
      rotation: r.nextDouble() * 6.28,
      rotationSpeed: (r.nextDouble() - 0.5) * 8,
    );
  }
}
