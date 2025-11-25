import 'package:equatable/equatable.dart';

/// Pomodoro events
abstract class PomodoroEvent extends Equatable {
  const PomodoroEvent();

  @override
  List<Object?> get props => [];
}

/// Start the pomodoro timer
class StartPomodoro extends PomodoroEvent {
  const StartPomodoro();
}

/// Pause the pomodoro timer
class PausePomodoro extends PomodoroEvent {
  const PausePomodoro();
}

/// Resume the pomodoro timer
class ResumePomodoro extends PomodoroEvent {
  const ResumePomodoro();
}

/// Reset the pomodoro timer
class ResetPomodoro extends PomodoroEvent {
  const ResetPomodoro();
}

/// Tick event (every second)
class TickPomodoro extends PomodoroEvent {
  const TickPomodoro();
}

/// Change duration
class ChangeDuration extends PomodoroEvent {
  final int durationMinutes;

  const ChangeDuration(this.durationMinutes);

  @override
  List<Object?> get props => [durationMinutes];
}

/// Complete session
class CompleteSession extends PomodoroEvent {
  const CompleteSession();
}
