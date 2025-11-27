import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
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

  // Settings
  bool _autoStart = false;
  bool _vibration = true;

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
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
        onAutoStartToggle: (value) => setState(() => _autoStart = value),
        onVibrationToggle: (value) => setState(() => _vibration = value),
        onThemeChanged: widget.onThemeChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // 2x font sizes (+2 for better visibility)
    final timerFontSize = isLandscape ? 122.0 : 162.0;
    final iconSize = timerFontSize / 8; // 1/8 of timer font

    return BlocProvider(
      create: (context) => PomodoroBloc(),
      child: BlocListener<PomodoroBloc, PomodoroState>(
        listener: (context, state) {
          final status = state.pomodoro.status;
          if (status.toString().contains('running')) {
            _audioService.playEffect(AudioEffect.timerStart);
          } else if (status.toString().contains('completed')) {
            _audioService.playEffect(AudioEffect.timerComplete);
            if (_vibration) {
              HapticFeedback.heavyImpact();
            }
          }
        },
        child: BlocBuilder<PomodoroBloc, PomodoroState>(
          builder: (context, state) {
            final pomodoro = state.pomodoro;
            final minutes = pomodoro.remainingMinutes;
            final seconds = pomodoro.remainingSecondsDisplay;

            return Container(
              color: widget.theme.backgroundColor,
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
        const SizedBox(height: 10),
        _buildTimeDigit(seconds.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildHorizontalTimer(int minutes, int seconds, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(minutes.toString().padLeft(2, '0'), fontSize),
        const SizedBox(width: 20),
        _buildTimeDigit(seconds.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildTimeDigit(String text, double fontSize) {
    return SizedBox(
      width: fontSize * 1.45, // Optimized width for Orbitron bold + shadow without overflow
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'Orbitron',
          fontWeight: FontWeight.bold,
          color: Colors.white,
          decoration: TextDecoration.none, // Ensure no underline
          fontFeatures: const [FontFeature.tabularFigures()], // Equal width for all digits
          shadows: [
            Shadow(
              color: widget.theme.glowColor.withOpacity(0.9),
              blurRadius: 20,
            ),
          ],
        ),
      ),
    );
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
