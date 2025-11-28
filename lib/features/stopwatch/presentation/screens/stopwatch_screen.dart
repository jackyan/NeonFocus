import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
import '../../domain/stopwatch_model.dart';
import '../bloc/stopwatch_bloc.dart';
import '../bloc/stopwatch_event.dart';
import '../bloc/stopwatch_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // Responsive font size
    final timerFontSize = isLandscape
        ? size.width * 0.12
        : size.width * 0.28;
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
        if (stopwatch.laps.isNotEmpty)
          Expanded(
            flex: 1,
            child: _buildLapsList(stopwatch.laps),
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
        if (stopwatch.laps.isNotEmpty)
          Expanded(
            flex: 1,
            child: _buildLapsList(stopwatch.laps),
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

  Widget _buildControlIcons(BuildContext context, StopwatchStatus status, double iconSize) {
    final isRunning = status == StopwatchStatus.running;
    final isIdle = status == StopwatchStatus.idle;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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

  Widget _buildLapsList(List<Lap> laps) {
    // Reverse to show latest lap first
    final reversedLaps = laps.reversed.toList();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: widget.theme.glowColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reversedLaps.length,
        itemBuilder: (context, index) {
          final lap = reversedLaps[index];
          return _buildLapItem(lap);
        },
      ),
    );
  }

  Widget _buildLapItem(Lap lap) {
    final lapMinutes = (lap.lapSeconds / 60).floor();
    final lapSeconds = lap.lapSeconds % 60;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Lap ${lap.lapNumber}',
            style: TextStyle(
              color: widget.theme.textColor.withOpacity(0.8),
              fontSize: 14,
              fontFamily: 'Orbitron',
            ),
          ),
          Text(
            '${lapMinutes.toString().padLeft(2, '0')}:${lapSeconds.toString().padLeft(2, '0')}',
            style: TextStyle(
              color: widget.theme.glowColor,
              fontSize: 16,
              fontFamily: 'Orbitron',
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: widget.theme.glowColor.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
