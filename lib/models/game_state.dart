class GameState {
  int merit = 0;
  int combo = 0;
  int bestCombo = 0;
  int tapCount = 0;
  int lastTapTime = 0;
  int totalMerit = 0;

  static const int comboWindow = 600;
  static const int confettiInterval = 50;

  void reset() {
    merit = 0;
    combo = 0;
    bestCombo = 0;
    tapCount = 0;
    lastTapTime = 0;
  }

  int tap(int now) {
    tapCount++;

    if (now - lastTapTime < comboWindow) {
      combo++;
      if (combo > bestCombo) bestCombo = combo;
    } else {
      combo = 1;
    }
    lastTapTime = now;

    final gain = 1 + (combo ~/ 5);
    merit += gain;
    totalMerit += gain;
    return gain;
  }

  int heavyTap(int now) {
    final gain = tap(now) + 3;
    merit += 3;
    totalMerit += 3;
    return gain;
  }

  bool isMilestone() => tapCount % confettiInterval == 0;
}

class DailyFortune {
  final String title;
  final String content;
  final String level;

  DailyFortune({
    required this.title,
    required this.content,
    required this.level,
  });
}

class FortuneDatabase {
  static final List<DailyFortune> fortunes = [
    DailyFortune(
      title: '上上签',
      content: '今日运势极佳，所求皆可得。学业事业双丰收，贵人相助好运来。',
      level: 'great',
    ),
    DailyFortune(
      title: '上签',
      content: '今日运势颇佳，努力必有回报。保持积极心态，好事自然来。',
      level: 'good',
    ),
    DailyFortune(
      title: '中签',
      content: '今日运势平稳，稳步前行即可。不急不躁，水到渠成。',
      level: 'normal',
    ),
    DailyFortune(
      title: '平签',
      content: '今日运势平淡，平常心对待。养精蓄锐，为明日准备。',
      level: 'ordinary',
    ),
    DailyFortune(
      title: '下签',
      content: '今日宜静不宜动，守旧为佳。小不忍则乱大谋，退一步海阔天空。',
      level: 'bad',
    ),
    DailyFortune(
      title: '学业上上签',
      content: '文曲星高照，学业大进。考试必过，论文必中！',
      level: 'great',
    ),
    DailyFortune(
      title: '事业亨通',
      content: '职场得意，步步高升。KPI超额完成，奖金拿到手软！',
      level: 'great',
    ),
    DailyFortune(
      title: '桃花运来',
      content: '今日桃花朵朵开，缘分挡不住。主动出击，必有收获！',
      level: 'good',
    ),
    DailyFortune(
      title: '身体健康',
      content: '身强体健，精神百倍。运动健身，效果翻倍！',
      level: 'good',
    ),
    DailyFortune(
      title: '财运亨通',
      content: '今日财运不错，理财顺利。买买买也不会心疼~',
      level: 'normal',
    ),
  ];

  static DailyFortune getFortune(int seed) {
    final index = seed % fortunes.length;
    return fortunes[index];
  }
}
