import 'package:audioplayers/audioplayers.dart';

/// Audio effect types
enum AudioEffect {
  uiClick('ui_click.mp3'),
  uiSwipe('ui_swipe.mp3'),
  timerStart('timer_start.mp3'),
  timerComplete('timer_complete.mp3'),
  digitFlip('digit_flip.mp3');

  final String filename;
  const AudioEffect(this.filename);
}

/// Ambience (soundscape) types
enum Ambience {
  none('none', 'None', '无'),
  rain('rain', 'Rain', '雨声'),
  cafe('cafe', 'Cafe', '咖啡馆'),
  whiteNoise('white_noise', 'White Noise', '白噪音'),
  forest('forest', 'Forest', '森林'), // Premium
  ocean('ocean', 'Ocean', '海浪'), // Premium
  lofi('lofi', 'Lo-Fi', 'Lo-Fi音乐'); // Premium

  final String id;
  final String nameEn;
  final String nameZh;

  const Ambience(this.id, this.nameEn, this.nameZh);

  bool get isPremium => [forest, ocean, lofi].contains(this);
  bool get isFree => !isPremium && this != none;
}

/// Audio service for managing sound effects and ambient soundscapes
class AudioService {
  // Singleton instance
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  // Audio players
  final AudioPlayer _effectPlayer = AudioPlayer();
  final AudioPlayer _ambiencePlayer = AudioPlayer();

  // State
  String? _currentAmbience;
  double _effectVolume = 0.5;
  double _ambienceVolume = 0.7;
  bool _isInitialized = false;

  // Getters
  String? get currentAmbience => _currentAmbience;
  double get effectVolume => _effectVolume;
  double get ambienceVolume => _ambienceVolume;
  bool get isAmbiencePlaying => _ambiencePlayer.state == PlayerState.playing;

  /// Get current ambience as enum
  Ambience get currentAmbienceEnum {
    if (_currentAmbience == null) return Ambience.none;
    return Ambience.values.firstWhere(
      (a) => a.id == _currentAmbience,
      orElse: () => Ambience.none,
    );
  }

  /// Initialize audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure ambience player for loop mode
      await _ambiencePlayer.setReleaseMode(ReleaseMode.loop);

      // Set initial volumes
      await _effectPlayer.setVolume(_effectVolume);
      await _ambiencePlayer.setVolume(_ambienceVolume);

      _isInitialized = true;
      print('AudioService initialized successfully');
    } catch (e) {
      print('Error initializing AudioService: $e');
    }
  }

  /// Play UI sound effect
  Future<void> playEffect(AudioEffect effect) async {
    if (!_isInitialized) await initialize();

    try {
      // Stop any currently playing effect first
      await _effectPlayer.stop();

      // Set to play once only (not loop)
      await _effectPlayer.setReleaseMode(ReleaseMode.stop);
      await _effectPlayer.setVolume(_effectVolume);
      await _effectPlayer.play(
        AssetSource('sounds/effects/${effect.filename}'),
      );
    } catch (e) {
      print('Error playing effect ${effect.filename}: $e');
      // Fail silently - app should continue working without sound
    }
  }

  /// Start playing ambient soundscape
  Future<void> startAmbience(Ambience ambience) async {
    if (ambience == Ambience.none) {
      await stopAmbience();
      return;
    }

    if (_currentAmbience == ambience.id &&
        _ambiencePlayer.state == PlayerState.playing) {
      return; // Already playing this ambience
    }

    if (!_isInitialized) await initialize();

    try {
      _currentAmbience = ambience.id;

      await _ambiencePlayer.setVolume(_ambienceVolume);
      await _ambiencePlayer.play(
        AssetSource('sounds/ambience/${ambience.id}.mp3'),
      );

      print('Started ambience: ${ambience.nameEn}');
    } catch (e) {
      print('Error playing ambience ${ambience.id}: $e');
      _currentAmbience = null;
    }
  }

  /// Stop ambient soundscape
  Future<void> stopAmbience() async {
    try {
      await _ambiencePlayer.stop();
      _currentAmbience = null;
      print('Stopped ambience');
    } catch (e) {
      print('Error stopping ambience: $e');
    }
  }

  /// Pause ambient soundscape
  Future<void> pauseAmbience() async {
    try {
      await _ambiencePlayer.pause();
      print('Paused ambience');
    } catch (e) {
      print('Error pausing ambience: $e');
    }
  }

  /// Resume ambient soundscape
  Future<void> resumeAmbience() async {
    try {
      await _ambiencePlayer.resume();
      print('Resumed ambience');
    } catch (e) {
      print('Error resuming ambience: $e');
    }
  }

  /// Set effect volume (0.0 to 1.0)
  Future<void> setEffectVolume(double volume) async {
    _effectVolume = volume.clamp(0.0, 1.0);
    await _effectPlayer.setVolume(_effectVolume);
  }

  /// Set ambience volume (0.0 to 1.0)
  Future<void> setAmbienceVolume(double volume) async {
    _ambienceVolume = volume.clamp(0.0, 1.0);
    await _ambiencePlayer.setVolume(_ambienceVolume);
  }

  /// Fade ambience volume
  Future<void> fadeAmbienceVolume({
    required double targetVolume,
    Duration duration = const Duration(seconds: 2),
  }) async {
    final startVolume = _ambienceVolume;
    final steps = 20;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final volumeStep = (targetVolume - startVolume) / steps;

    for (int i = 0; i < steps; i++) {
      await Future.delayed(Duration(milliseconds: stepDuration));
      final newVolume = startVolume + (volumeStep * (i + 1));
      await setAmbienceVolume(newVolume);
    }
  }

  /// Mute/unmute effects
  Future<void> toggleEffectMute() async {
    if (_effectVolume > 0) {
      await setEffectVolume(0);
    } else {
      await setEffectVolume(0.5);
    }
  }

  /// Mute/unmute ambience
  Future<void> toggleAmbienceMute() async {
    if (_ambienceVolume > 0) {
      await setAmbienceVolume(0);
    } else {
      await setAmbienceVolume(0.7);
    }
  }

  /// Dispose resources
  void dispose() {
    _effectPlayer.dispose();
    _ambiencePlayer.dispose();
  }
}
