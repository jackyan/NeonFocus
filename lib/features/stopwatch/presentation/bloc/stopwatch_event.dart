import 'package:equatable/equatable.dart';

/// Stopwatch events
abstract class StopwatchEvent extends Equatable {
  const StopwatchEvent();

  @override
  List<Object?> get props => [];
}

/// Start the stopwatch timer
class StartStopwatch extends StopwatchEvent {
  const StartStopwatch();
}

/// Pause the stopwatch timer
class PauseStopwatch extends StopwatchEvent {
  const PauseStopwatch();
}

/// Resume the stopwatch timer
class ResumeStopwatch extends StopwatchEvent {
  const ResumeStopwatch();
}

/// Reset the stopwatch timer
class ResetStopwatch extends StopwatchEvent {
  const ResetStopwatch();
}

/// Tick event (every second)
class TickStopwatch extends StopwatchEvent {
  const TickStopwatch();
}

/// Record lap
class RecordLap extends StopwatchEvent {
  const RecordLap();
}
