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

  /// Create state from JSON
  factory PomodoroState.fromJson(Map<String, dynamic> json) {
    return PomodoroState(
      pomodoro: Pomodoro.fromJson(json['pomodoro'] as Map<String, dynamic>),
    );
  }

  /// Convert state to JSON
  Map<String, dynamic> toJson() {
    return {
      'pomodoro': pomodoro.toJson(),
    };
  }

  @override
  List<Object?> get props => [pomodoro];
}
