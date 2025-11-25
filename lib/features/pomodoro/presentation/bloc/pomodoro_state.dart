import 'package:equatable/equatable.dart';
import '../../domain/pomodoro_model.dart';

/// Pomodoro state
class PomodoroState extends Equatable {
  final Pomodoro pomodoro;

  const PomodoroState({
    required this.pomodoro,
  });

  factory PomodoroState.initial() {
    return PomodoroState(
      pomodoro: Pomodoro.initial(),
    );
  }

  PomodoroState copyWith({
    Pomodoro? pomodoro,
  }) {
    return PomodoroState(
      pomodoro: pomodoro ?? this.pomodoro,
    );
  }

  @override
  List<Object?> get props => [pomodoro];
}
