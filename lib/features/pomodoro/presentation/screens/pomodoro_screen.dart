import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
import '../bloc/pomodoro_bloc.dart';
import '../bloc/pomodoro_event.dart';
import '../bloc/pomodoro_state.dart';
import '../widgets/virtual_knob.dart';
import '../widgets/ambience_selector.dart';
import '../widgets/volume_control.dart';

/// Pomodoro screen with audio integration
class PomodoroScreen extends StatefulWidget {
  final NeonTheme theme;

  const PomodoroScreen({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  final AudioService _audioService = AudioService();
  Ambience _currentAmbience = Ambience.none;
  bool _showVolumeControl = false;

  @override
  void initState() {
    super.initState();
    _audioService.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    // Responsive sizing
    final topPadding = isLandscape ? 80.0 : 70.0; // Extra space for page indicator
    final timerFontSize = isLandscape ? 60.0 : 80.0;
    final knobSize = isLandscape ? 120.0 : 150.0;
    final verticalSpacing = isLandscape ? 20.0 : 40.0;
    final compactControlTop = isLandscape ? 10.0 : 10.0;

    return BlocProvider(
      create: (context) => PomodoroBloc(),
      child: BlocListener<PomodoroBloc, PomodoroState>(
        listener: (context, state) {
          // Play sound effects on state changes
          final status = state.pomodoro.status;
          if (status.toString().contains('running')) {
            _audioService.playEffect(AudioEffect.timerStart);
          } else if (status.toString().contains('completed')) {
            _audioService.playEffect(AudioEffect.timerComplete);
          }
        },
        child: BlocBuilder<PomodoroBloc, PomodoroState>(
          builder: (context, state) {
            final pomodoro = state.pomodoro;

            return Scaffold(
              backgroundColor: widget.theme.backgroundColor,
              body: SafeArea(
                child: Stack(
                  children: [
                    // Main content
                    SingleChildScrollView(
                      padding: EdgeInsets.only(
                        top: topPadding,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Timer display
                          _buildTimerDisplay(
                            pomodoro.remainingMinutes,
                            pomodoro.remainingSecondsDisplay,
                            fontSize: timerFontSize,
                          ),

                          SizedBox(height: verticalSpacing),

                          // Virtual knob
                          if (pomodoro.isIdle)
                            VirtualKnob(
                              initialValue: pomodoro.durationMinutes.toDouble(),
                              minValue: 15,
                              maxValue: 60,
                              step: 5,
                              knobColor: widget.theme.primaryColor,
                              size: knobSize,
                              onChanged: (value) {
                                context.read<PomodoroBloc>().add(
                                      ChangeDuration(value.toInt()),
                                    );
                              },
                            ),

                          SizedBox(height: verticalSpacing),

                          // Control buttons
                          _buildControlButtons(context, pomodoro.status),

                          SizedBox(height: isLandscape ? 20 : 30),

                          // Ambience selector
                          AmbienceSelector(
                            currentAmbience: _currentAmbience,
                            glowColor: widget.theme.glowColor,
                            isPremiumUser: false, // TODO: Get from user settings
                            onAmbienceChanged: (ambience) {
                              setState(() => _currentAmbience = ambience);
                            },
                          ),

                          const SizedBox(height: 20),

                          // Volume control toggle button
                          _buildVolumeToggle(),

                          // Volume control (expandable)
                          if (_showVolumeControl) ...[
                            const SizedBox(height: 20),
                            VolumeControl(
                              glowColor: widget.theme.glowColor,
                              showEffectVolume: true,
                              showAmbienceVolume: true,
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Completed sessions
                          _buildSessionInfo(pomodoro.completedSessions),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),

                    // Compact volume control (top right) - positioned below page indicator
                    Positioned(
                      top: compactControlTop,
                      right: 10,
                      child: SafeArea(
                        child: CompactVolumeControl(
                          glowColor: widget.theme.glowColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildVolumeToggle() {
    return GestureDetector(
      onTap: () {
        setState(() => _showVolumeControl = !_showVolumeControl);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: widget.theme.glowColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _showVolumeControl ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 16,
              color: widget.theme.glowColor.withOpacity(0.7),
            ),
            const SizedBox(width: 4),
            Text(
              _showVolumeControl ? 'HIDE VOLUME' : 'SHOW VOLUME',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: widget.theme.glowColor.withOpacity(0.7),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(int minutes, int seconds, {double fontSize = 80.0}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeText(minutes.toString().padLeft(2, '0'), fontSize: fontSize),
        _buildTimeText(':', fontSize: fontSize),
        _buildTimeText(seconds.toString().padLeft(2, '0'), fontSize: fontSize),
      ],
    );
  }

  Widget _buildTimeText(String text, {double fontSize = 80.0}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: widget.theme.glowColor.withOpacity(0.9),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons(BuildContext context, status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (status.toString().contains('idle'))
          _buildButton(
            icon: Icons.play_arrow,
            onTap: () => context.read<PomodoroBloc>().add(const StartPomodoro()),
          ),
        if (status.toString().contains('running'))
          _buildButton(
            icon: Icons.pause,
            onTap: () => context.read<PomodoroBloc>().add(const PausePomodoro()),
          ),
        if (status.toString().contains('paused'))
          _buildButton(
            icon: Icons.play_arrow,
            onTap: () => context.read<PomodoroBloc>().add(const ResumePomodoro()),
          ),
        const SizedBox(width: 20),
        _buildButton(
          icon: Icons.refresh,
          onTap: () => context.read<PomodoroBloc>().add(const ResetPomodoro()),
        ),
      ],
    );
  }

  Widget _buildButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: widget.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: widget.theme.primaryColor,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: 32,
          color: widget.theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSessionInfo(int completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: widget.theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Completed: $completed sessions',
        style: TextStyle(
          fontSize: 14,
          color: widget.theme.textColor,
        ),
      ),
    );
  }
}
