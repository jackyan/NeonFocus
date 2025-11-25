import 'package:equatable/equatable.dart';

/// Pomodoro timer states
enum PomodoroStatus {
  idle,
  running,
  paused,
  completed,
}

/// Pomodoro session types
enum SessionType {
  work,
  shortBreak,
  longBreak,
}

/// Pomodoro model
class Pomodoro extends Equatable {
  final int durationMinutes;
  final int remainingSeconds;
  final PomodoroStatus status;
  final SessionType sessionType;
  final int completedSessions;

  const Pomodoro({
    required this.durationMinutes,
    required this.remainingSeconds,
    required this.status,
    this.sessionType = SessionType.work,
    this.completedSessions = 0,
  });

  factory Pomodoro.initial({int durationMinutes = 25}) {
    return Pomodoro(
      durationMinutes: durationMinutes,
      remainingSeconds: durationMinutes * 60,
      status: PomodoroStatus.idle,
      sessionType: SessionType.work,
      completedSessions: 0,
    );
  }

  Pomodoro copyWith({
    int? durationMinutes,
    int? remainingSeconds,
    PomodoroStatus? status,
    SessionType? sessionType,
    int? completedSessions,
  }) {
    return Pomodoro(
      durationMinutes: durationMinutes ?? this.durationMinutes,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      status: status ?? this.status,
      sessionType: sessionType ?? this.sessionType,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }

  // Getters
  bool get isRunning => status == PomodoroStatus.running;
  bool get isPaused => status == PomodoroStatus.paused;
  bool get isIdle => status == PomodoroStatus.idle;
  bool get isCompleted => status == PomodoroStatus.completed;

  int get remainingMinutes => (remainingSeconds / 60).floor();
  int get remainingSecondsDisplay => remainingSeconds % 60;

  double get progress =>
      1.0 - (remainingSeconds / (durationMinutes * 60));

  @override
  List<Object?> get props => [
        durationMinutes,
        remainingSeconds,
        status,
        sessionType,
        completedSessions,
      ];
}

/// Pomodoro configuration
class PomodoroConfig {
  static const int workDuration = 25; // minutes
  static const int shortBreakDuration = 5; // minutes
  static const int longBreakDuration = 15; // minutes
  static const int sessionsBeforeLongBreak = 4;

  static int getDuration(SessionType type) {
    switch (type) {
      case SessionType.work:
        return workDuration;
      case SessionType.shortBreak:
        return shortBreakDuration;
      case SessionType.longBreak:
        return longBreakDuration;
    }
  }
}
