import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../shared/widgets/display/animated_flip_clock_digit.dart';
import '../../../../shared/widgets/display/animated_seven_segment_digit.dart';
import '../../domain/stopwatch_model.dart';
import '../bloc/stopwatch_bloc.dart';
import '../bloc/stopwatch_event.dart';
import '../bloc/stopwatch_state.dart';
import 'stopwatch_settings_screen.dart';
import 'lap_history_screen.dart';

/// Minimalist stopwatch screen
class StopwatchScreen extends StatefulWidget {
  final NeonTheme theme;
  final Function(NeonTheme) onThemeChanged;

  const StopwatchScreen({
    Key? key,
    required this.theme,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  final AudioService _audioService = AudioService();

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
      builder: (context) => StopwatchSettingsScreen(
        currentTheme: widget.theme,
        onThemeChanged: widget.onThemeChanged,
        audioService: _audioService,
      ),
    );
  }

  void _showLapHistory(List<Lap> laps) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LapHistoryScreen(
        laps: laps,
        theme: widget.theme,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // Responsive font size - match clock page sizing
    final timerFontSize = isLandscape
        ? size.width * 0.15  // Match clock page (was 0.12)
        : size.width * 0.38;  // Match clock page (was 0.28)
    final iconSize = timerFontSize / 8;

    return BlocProvider(
      create: (context) => StopwatchBloc(),
      child: BlocListener<StopwatchBloc, StopwatchState>(
        listener: (context, state) {
          final status = state.stopwatch.status;
          if (status == StopwatchStatus.running) {
            _audioService.playEffect(AudioEffect.timerStart);
          }
        },
        child: BlocBuilder<StopwatchBloc, StopwatchState>(
          builder: (context, state) {
            final stopwatch = state.stopwatch;
            final hours = stopwatch.hours;
            final minutes = stopwatch.minutes;
            final seconds = stopwatch.seconds;

            return Container(
              color: widget.theme.backgroundColor,
              child: isLandscape
                  ? _buildLandscapeLayout(context, stopwatch, hours, minutes, seconds, timerFontSize, iconSize)
                  : _buildPortraitLayout(context, stopwatch, hours, minutes, seconds, timerFontSize, iconSize),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
    BuildContext context,
    Stopwatch stopwatch,
    int hours,
    int minutes,
    int seconds,
    double timerFontSize,
    double iconSize,
  ) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildVerticalTimer(hours, minutes, seconds, timerFontSize),
                SizedBox(height: 60),
                _buildControlIcons(context, stopwatch.status, iconSize),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
    BuildContext context,
    Stopwatch stopwatch,
    int hours,
    int minutes,
    int seconds,
    double timerFontSize,
    double iconSize,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHorizontalTimer(hours, minutes, seconds, timerFontSize),
                SizedBox(height: 40),
                _buildControlIcons(context, stopwatch.status, iconSize),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalTimer(int hours, int minutes, int seconds, double fontSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(hours.toString().padLeft(2, '0'), fontSize),
        SizedBox(height: fontSize * 0.08),
        _buildTimeDigit(minutes.toString().padLeft(2, '0'), fontSize),
        SizedBox(height: fontSize * 0.08),
        _buildTimeDigit(seconds.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildHorizontalTimer(int hours, int minutes, int seconds, double fontSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeDigit(hours.toString().padLeft(2, '0'), fontSize),
        SizedBox(width: fontSize * 0.15),
        Text(
          ':',
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.5),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: fontSize * 0.15),
        _buildTimeDigit(minutes.toString().padLeft(2, '0'), fontSize),
        SizedBox(width: fontSize * 0.15),
        Text(
          ':',
          style: TextStyle(
            fontSize: fontSize,
            fontFamily: 'Orbitron',
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.5),
            decoration: TextDecoration.none,
          ),
        ),
        SizedBox(width: fontSize * 0.15),
        _buildTimeDigit(seconds.toString().padLeft(2, '0'), fontSize),
      ],
    );
  }

  Widget _buildTimeDigit(String text, double fontSize) {
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
              width: fontSize * 0.72,
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
            SizedBox(width: fontSize * 0.08),
            SizedBox(
              width: fontSize * 0.72,
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

  Widget _buildControlIcons(BuildContext context, StopwatchStatus status, double iconSize) {
    final isRunning = status == StopwatchStatus.running;
    final isIdle = status == StopwatchStatus.idle;
    final stopwatch = context.read<StopwatchBloc>().state.stopwatch;
    final hasLaps = stopwatch.laps.isNotEmpty;

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

        // Reset icon
        _buildIconButton(
          icon: Icons.stop_outlined,
          size: iconSize,
          onTap: () {
            context.read<StopwatchBloc>().add(const ResetStopwatch());
            HapticFeedback.mediumImpact();
          },
        ),

        SizedBox(width: iconSize * 1.5),

        // Play/Pause icon
        _buildIconButton(
          icon: isRunning ? Icons.pause_outlined : Icons.play_arrow_outlined,
          size: iconSize * 1.4,
          onTap: () {
            if (isIdle) {
              context.read<StopwatchBloc>().add(const StartStopwatch());
            } else if (isRunning) {
              context.read<StopwatchBloc>().add(const PauseStopwatch());
            } else {
              context.read<StopwatchBloc>().add(const ResumeStopwatch());
            }
            HapticFeedback.mediumImpact();
          },
        ),

        SizedBox(width: iconSize * 1.5),

        // Lap icon (only enabled when running)
        _buildIconButton(
          icon: Icons.flag_outlined,
          size: iconSize,
          onTap: isRunning
              ? () {
                  context.read<StopwatchBloc>().add(const RecordLap());
                  HapticFeedback.lightImpact();
                }
              : null,
        ),

        SizedBox(width: iconSize * 1.5),

        // History icon (always visible, disabled when no laps)
        _buildIconButton(
          icon: Icons.history,
          size: iconSize,
          onTap: hasLaps ? () => _showLapHistory(stopwatch.laps) : null,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required double size,
    VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(size * 0.6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isEnabled
                ? widget.theme.glowColor.withOpacity(0.6)
                : widget.theme.glowColor.withOpacity(0.2),
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: size,
          color: isEnabled
              ? widget.theme.glowColor
              : widget.theme.glowColor.withOpacity(0.3),
        ),
      ),
    );
  }

}
