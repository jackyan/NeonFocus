import 'package:equatable/equatable.dart';
import '../../domain/stopwatch_model.dart';

/// Stopwatch state
class StopwatchState extends Equatable {
  final Stopwatch stopwatch;

  const StopwatchState({
    required this.stopwatch,
  });

  factory StopwatchState.initial() {
    return StopwatchState(
      stopwatch: Stopwatch.initial(),
    );
  }

  StopwatchState copyWith({
    Stopwatch? stopwatch,
  }) {
    return StopwatchState(
      stopwatch: stopwatch ?? this.stopwatch,
    );
  }

  /// Create state from JSON
  factory StopwatchState.fromJson(Map<String, dynamic> json) {
    return StopwatchState(
      stopwatch: Stopwatch.fromJson(json['stopwatch'] as Map<String, dynamic>),
    );
  }

  /// Convert state to JSON
  Map<String, dynamic> toJson() {
    return {
      'stopwatch': stopwatch.toJson(),
    };
  }

  @override
  List<Object?> get props => [stopwatch];
}
