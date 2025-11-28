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

  @override
  List<Object?> get props => [stopwatch];
}
