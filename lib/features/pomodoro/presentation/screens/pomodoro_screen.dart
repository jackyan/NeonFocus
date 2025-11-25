import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/themes/glow_theme.dart';
import '../bloc/pomodoro_bloc.dart';
import '../bloc/pomodoro_event.dart';
import '../bloc/pomodoro_state.dart';
import '../widgets/virtual_knob.dart';

/// Pomodoro screen
class PomodoroScreen extends StatelessWidget {
  final NeonTheme theme;

  const PomodoroScreen({
    Key? key,
    required this.theme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PomodoroBloc(),
      child: BlocBuilder<PomodoroBloc, PomodoroState>(
        builder: (context, state) {
          final pomodoro = state.pomodoro;

          return Scaffold(
            backgroundColor: theme.backgroundColor,
            body: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Timer display
                  _buildTimerDisplay(pomodoro.remainingMinutes,
                      pomodoro.remainingSecondsDisplay),

                  const SizedBox(height: 60),

                  // Virtual knob
                  if (pomodoro.isIdle)
                    VirtualKnob(
                      initialValue: pomodoro.durationMinutes.toDouble(),
                      minValue: 15,
                      maxValue: 60,
                      step: 5,
                      knobColor: theme.primaryColor,
                      size: 150,
                      onChanged: (value) {
                        context.read<PomodoroBloc>().add(
                              ChangeDuration(value.toInt()),
                            );
                      },
                    ),

                  const SizedBox(height: 60),

                  // Control buttons
                  _buildControlButtons(context, pomodoro.status),

                  const SizedBox(height: 20),

                  // Completed sessions
                  _buildSessionInfo(pomodoro.completedSessions),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimerDisplay(int minutes, int seconds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeText(minutes.toString().padLeft(2, '0')),
        _buildTimeText(':'),
        _buildTimeText(seconds.toString().padLeft(2, '0')),
      ],
    );
  }

  Widget _buildTimeText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 80,
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: theme.glowColor.withOpacity(0.9),
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
          color: theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(35),
          border: Border.all(
            color: theme.primaryColor,
            width: 2,
          ),
        ),
        child: Icon(
          icon,
          size: 32,
          color: theme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildSessionInfo(int completed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Completed: $completed sessions',
        style: TextStyle(
          fontSize: 14,
          color: theme.textColor,
        ),
      ),
    );
  }
}
