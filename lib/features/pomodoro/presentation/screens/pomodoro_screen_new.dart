import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/gravity_service.dart';
import '../../../../core/services/burnin_protection_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../shared/widgets/display/animated_flip_clock_digit.dart';
import '../../../../shared/widgets/display/animated_seven_segment_digit.dart';
import '../../domain/pomodoro_model.dart';
import '../bloc/pomodoro_bloc.dart';
import '../bloc/pomodoro_event.dart';
import '../bloc/pomodoro_state.dart';
import 'pomodoro_settings_screen.dart';

/// Minimalist pomodoro screen
class PomodoroScreen extends StatefulWidget {
  final NeonTheme theme;
  final Function(NeonTheme) onThemeChanged;

  const PomodoroScreen({
    Key? key,
    required this.theme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final AudioService _audioService = AudioService();
  final GravityService _gravityService = GravityService();
  final BurninProtectionService _burninProtection = BurninProtectionService();
  final SettingsService _settingsService = SettingsService();

  // Burn-in protection offsets
  double _offsetX = 0.0;
  double _offsetY = 0.0;

  // Settings
  bool _autoStart = false;
  bool _vibration = true;
  bool _gravityEnabled = true;
  bool _isShowingCountdown = false;
  Ambience _currentAmbience = Ambience.none;
  bool _soundEffectsEnabled = true;

  // Track previous status to play sounds only on state transitions
  String _previousStatus = 'idle';
  
  // Track previous seconds for digit flip sound
  int _previousSeconds = -1;

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
    // Restore ambience state from AudioService
    _currentAmbience = _audioService.currentAmbienceEnum;
    // Load sound effects setting
    _soundEffectsEnabled = _settingsService.getSoundEffectsEnabled();
    _initializeGravity();
    _startBurninProtection();
  }

  Future<void> _initializeGravity() async {
    await _gravityService.initialize();
    _setupGravityListener();
  }

  void _startBurninProtection() {
    _burninProtection.addOffsetListener(_onBurninOffsetChanged);
    _burninProtection.start();
  }

  void _onBurninOffsetChanged(double x, double y) {
    if (mounted) {
      setState(() {
        _offsetX = x;
        _offsetY = y;
      });
    }
  }

  @override
  void dispose() {
    _gravityService.removeOrientationListener(_onOrientationChanged);
    _burninProtection.removeOffsetListener(_onBurninOffsetChanged);
    super.dispose();
  }

  void _setupGravityListener() {
    _gravityService.addOrientationListener(_onOrientationChanged);
  }

  void _onOrientationChanged(GravityOrientation orientation) {
    if (!_gravityEnabled || !mounted || _isShowingCountdown) return;

    final currentBloc = context.read<PomodoroBloc>();
    final currentState = currentBloc.state.pomodoro;
    final status = currentState.status.toString();

    if (orientation == GravityOrientation.faceDown) {
      // Screen face down → Start focus mode
      if (status.contains('idle')) {
        _showCountdownAndStart();
      }
    } else if (orientation == GravityOrientation.faceUp) {
      // Screen face up → Pause (only when running)
      if (status.contains('running')) {
        currentBloc.add(const PausePomodoro());
        if (_vibration) {
          HapticFeedback.mediumImpact();
        }
        _showPauseDialog();
      }
    }
  }

  void _showCountdownAndStart() {
    _isShowingCountdown = true;
    if (_vibration) {
      HapticFeedback.heavyImpact();
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: widget.theme.backgroundColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: widget.theme.glowColor, width: 2),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Starting in...',
              style: TextStyle(
                color: widget.theme.textColor,
                fontSize: 20,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 30),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 2, end: 0),
              duration: Duration(seconds: 2),
              builder: (context, value, child) {
                return Text(
                  value.ceil().toString(),
                  style: TextStyle(
                    fontSize: 96,
                    color: widget.theme.glowColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Orbitron',
                    shadows: [
                      Shadow(
                        color: widget.theme.glowColor.withOpacity(0.8),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    // Auto-start after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        context.read<PomodoroBloc>().add(const StartPomodoro());
        _isShowingCountdown = false;
      }
    });
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: widget.theme.backgroundColor.withOpacity(0.95),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: widget.theme.glowColor, width: 2),
        ),
        title: Text(
          'Paused',
          style: TextStyle(
            color: widget.theme.glowColor,
            fontFamily: 'Orbitron',
          ),
        ),
        content: Text(
          'Flip phone face down to resume',
          style: TextStyle(color: widget.theme.textColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'OK',
              style: TextStyle(color: widget.theme.glowColor),
            ),
          ),
        ],
      ),
    );
  }

  void _loadSettings() {
    setState(() {
      _soundEffectsEnabled = _settingsService.getSoundEffectsEnabled();
    });
  }

  void _showSettings(BuildContext blocContext) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PomodoroSettingsScreen(
        currentTheme: widget.theme,
        autoStart: _autoStart,
        vibration: _vibration,
        gravityEnabled: _gravityEnabled,
        onAutoStartToggle: (value) => setState(() => _autoStart = value),
        onVibrationToggle: (value) => setState(() => _vibration = value),
        onGravityToggle: (value) => setState(() => _gravityEnabled = value),
        onThemeChanged: widget.onThemeChanged,
        audioService: _audioService,
        currentAmbience: _currentAmbience,
        onAmbienceChanged: (ambience) => setState(() => _currentAmbience = ambience),
        onSettingsChanged: _loadSettings, // Reload settings immediately when changed
      ),
    ).then((_) {
      // Also reload when modal is closed
      _loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // Responsive font sizes based on screen dimensions
    // Landscape: 15% of screen width, Portrait: 38% of screen width
    final timerFontSize = isLandscape
        ? size.width * 0.15
        : size.width * 0.38;
    final iconSize = timerFontSize / 8; // 1/8 of timer font

    return BlocProvider(
      create: (context) => PomodoroBloc(),
      child: BlocListener<PomodoroBloc, PomodoroState>(
        listener: (context, state) {
          final currentStatus = state.pomodoro.status.toString();

          // Only play sounds when status changes
          if (currentStatus != _previousStatus) {
            if (currentStatus.contains('running') && !_previousStatus.contains('running')) {
              // Transitioning to running state - play start sound (always)
              _audioService.playEffect(AudioEffect.timerStart);
            } else if (currentStatus.contains('paused') && !_previousStatus.contains('paused')) {
              // Transitioning to paused state (always)
              _audioService.playEffect(AudioEffect.uiClick);
            } else if (currentStatus.contains('completed')) {
              // Completed state (always)
              _audioService.playEffect(AudioEffect.timerComplete);
              if (_vibration) {
                HapticFeedback.heavyImpact();
              }
            }

            _previousStatus = currentStatus;
          }
          
          // Play digit flip sound when seconds change (only if enabled)
          final currentSeconds = state.pomodoro.remainingSeconds % 60;
          if (state.pomodoro.status == PomodoroStatus.running && 
              currentSeconds != _previousSeconds && 
              _previousSeconds != -1 &&
              _soundEffectsEnabled) {
            _audioService.playEffect(AudioEffect.digitFlip);
          }
          _previousSeconds = currentSeconds;
        },
        child: BlocBuilder<PomodoroBloc, PomodoroState>(
          builder: (context, state) {
            final pomodoro = state.pomodoro;
            final minutes = pomodoro.remainingMinutes;
            final seconds = pomodoro.remainingSecondsDisplay;

            return Container(
              color: widget.theme.backgroundColor,
              child: Transform.translate(
                offset: Offset(_offsetX, _offsetY),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Timer display
                      isLandscape
                          ? _buildHorizontalTimer(minutes, seconds, timerFontSize)
                          : _buildVerticalTimer(minutes, seconds, timerFontSize),

                      SizedBox(height: isLandscape ? 40 : 60),

                      // Control icons
                      _buildControlIcons(context, pomodoro.status, iconSize),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVerticalTimer(int minutes, int seconds, double fontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(minutes.toString().padLeft(2, '0'), fontSize),
        SizedBox(height: fontSize * 0.08),
        _buildTimeDigit(seconds.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildHorizontalTimer(int minutes, int seconds, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(minutes.toString().padLeft(2, '0'), fontSize),
        SizedBox(width: fontSize * 0.3),
        _buildTimeDigit(seconds.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildTimeDigit(String text, double fontSize) {
    // Split the two-digit text into individual characters
    final chars = text.split('');
    
    // Check display style and render accordingly
    switch (widget.theme.displayStyle) {
      case DisplayStyle.flipClock:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedFlipClockDigit(
              digit: chars[0],
              size: fontSize,
              theme: widget.theme,
            ),
            SizedBox(width: fontSize * 0.12),  // Increased spacing for larger cards
            AnimatedFlipClockDigit(
              digit: chars[1],
              size: fontSize,
              theme: widget.theme,
            ),
          ],
        );
      
      case DisplayStyle.sevenSegment:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSevenSegmentDigit(
              digit: int.parse(chars[0]),
              size: fontSize,
              theme: widget.theme,
            ),
            SizedBox(width: fontSize * 0.08),
            AnimatedSevenSegmentDigit(
              digit: int.parse(chars[1]),
              size: fontSize,
              theme: widget.theme,
            ),
          ],
        );
      
      default:
        // Standard display style (Orbitron font)
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: fontSize * 0.72, // Fixed width per single digit
              child: Text(
                chars[0],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  shadows: [
                    Shadow(
                      color: widget.theme.glowColor.withOpacity(0.9),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: fontSize * 0.08), // Increased spacing to prevent digit contact
            SizedBox(
              width: fontSize * 0.72, // Fixed width per single digit
              child: Text(
                chars[1],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontFamily: 'Orbitron',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontFeatures: const [FontFeature.tabularFigures()],
                  shadows: [
                    Shadow(
                      color: widget.theme.glowColor.withOpacity(0.9),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildControlIcons(BuildContext context, dynamic status, double iconSize) {
    final isRunning = status.toString().contains('running');
    final isIdle = status.toString().contains('idle');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Settings icon
        _buildIconButton(
          icon: Icons.settings_outlined,
          size: iconSize,
          onTap: () => _showSettings(context),
        ),

        SizedBox(width: iconSize * 1.5),

        // Stop icon
        _buildIconButton(
          icon: Icons.stop_outlined,
          size: iconSize,
          onTap: () {
            context.read<PomodoroBloc>().add(const ResetPomodoro());
            _audioService.playEffect(AudioEffect.uiClick);
            HapticFeedback.mediumImpact();
          },
        ),

        SizedBox(width: iconSize * 1.5),

        // Start/Pause icon
        _buildIconButton(
          icon: isRunning ? Icons.pause_outlined : Icons.play_arrow_outlined,
          size: iconSize,
          onTap: () {
            if (isIdle) {
              context.read<PomodoroBloc>().add(const StartPomodoro());
            } else if (isRunning) {
              context.read<PomodoroBloc>().add(const PausePomodoro());
            } else {
              context.read<PomodoroBloc>().add(const ResumePomodoro());
            }
            HapticFeedback.mediumImpact();
          },
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required double size,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size * 0.3),
        decoration: BoxDecoration(
          color: widget.theme.primaryColor.withOpacity(0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.theme.primaryColor,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: size,
          color: widget.theme.primaryColor,
        ),
      ),
    );
  }
}
