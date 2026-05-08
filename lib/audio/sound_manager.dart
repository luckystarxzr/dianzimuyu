import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SoundManager {
  SoundManager._();
  static final SoundManager _instance = SoundManager._();
  factory SoundManager() => _instance;

  bool _initialized = false;
  bool soundEnabled = true;
  bool bgmEnabled = true;
  int vibrationLevel = 2;

  final AudioPlayer _knockPlayer = AudioPlayer();
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _bgmPlayer = AudioPlayer();

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _knockPlayer.setSource(AssetSource('sounds/wood_knock.wav'));
      await _knockPlayer.setVolume(0.8);

      await _effectPlayer.setSource(AssetSource('sounds/wood_knock.wav'));
      await _effectPlayer.setVolume(0.8);

      await _bgmPlayer.setSource(AssetSource('sounds/muyu.mp3'));
      await _bgmPlayer.setVolume(0.4);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (_) {}
  }

  Future<void> startBGM() async {
    if (!bgmEnabled) return;
    try {
      await init();
      await _bgmPlayer.resume();
    } catch (_) {}
  }

  Future<void> pauseBGM() async {
    try {
      await _bgmPlayer.pause();
    } catch (_) {}
  }

  void playKnock() {
    if (!soundEnabled) return;
    try {
      _knockPlayer.stop();
      _knockPlayer.seek(const Duration(seconds: 0));
      _knockPlayer.resume();
    } catch (_) {}
  }

  void playDouble() {
    if (!soundEnabled) return;
    try {
      _effectPlayer.stop();
      _effectPlayer.seek(const Duration(seconds: 0));
      _effectPlayer.resume();
      Future.delayed(const Duration(milliseconds: 100), () {
        if (soundEnabled) {
          try {
            _effectPlayer.stop();
            _effectPlayer.seek(const Duration(seconds: 0));
            _effectPlayer.resume();
          } catch (_) {}
        }
      });
    } catch (_) {}
  }

  void playCombo() {
    if (!soundEnabled) return;
    try {
      _effectPlayer.stop();
      _effectPlayer.setVolume(0.5);
      _effectPlayer.seek(const Duration(seconds: 0));
      _effectPlayer.resume();
      Future.delayed(const Duration(milliseconds: 60), () {
        if (soundEnabled) {
          try {
            _effectPlayer.stop();
            _effectPlayer.seek(const Duration(seconds: 0));
            _effectPlayer.resume();
          } catch (_) {}
        }
      });
    } catch (_) {}
  }

  void vibrate() {
    switch (vibrationLevel) {
      case 0:
        break;
      case 1:
        HapticFeedback.lightImpact();
        break;
      case 2:
        HapticFeedback.mediumImpact();
        break;
      case 3:
        HapticFeedback.heavyImpact();
        break;
    }
  }

  void dispose() {
    _knockPlayer.dispose();
    _effectPlayer.dispose();
    _bgmPlayer.dispose();
  }
}
