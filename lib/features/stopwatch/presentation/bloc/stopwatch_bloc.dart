import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../domain/stopwatch_model.dart';
import 'stopwatch_event.dart';
import 'stopwatch_state.dart';

/// Stopwatch BLoC with data persistence
class StopwatchBloc extends HydratedBloc<StopwatchEvent, StopwatchState> {
  Timer? _timer;

  StopwatchBloc() : super(StopwatchState.initial()) {
    on<StartStopwatch>(_onStart);
    on<PauseStopwatch>(_onPause);
    on<ResumeStopwatch>(_onResume);
    on<ResetStopwatch>(_onReset);
    on<TickStopwatch>(_onTick);
    on<RecordLap>(_onRecordLap);
  }

  void _onStart(StartStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickStopwatch());
    });

    emit(state.copyWith(
      stopwatch: state.stopwatch.copyWith(
        status: StopwatchStatus.running,
      ),
    ));
  }

  void _onPause(PauseStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      stopwatch: state.stopwatch.copyWith(
        status: StopwatchStatus.paused,
      ),
    ));
  }

  void _onResume(ResumeStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickStopwatch());
    });

    emit(state.copyWith(
      stopwatch: state.stopwatch.copyWith(
        status: StopwatchStatus.running,
      ),
    ));
  }

  void _onReset(ResetStopwatch event, Emitter<StopwatchState> emit) {
    _timer?.cancel();
    emit(StopwatchState(
      stopwatch: Stopwatch.initial(),
    ));
  }

  void _onTick(TickStopwatch event, Emitter<StopwatchState> emit) {
    emit(state.copyWith(
      stopwatch: state.stopwatch.copyWith(
        elapsedSeconds: state.stopwatch.elapsedSeconds + 1,
      ),
    ));
  }

  void _onRecordLap(RecordLap event, Emitter<StopwatchState> emit) {
    final currentLaps = state.stopwatch.laps;
    final lapNumber = currentLaps.length + 1;
    final currentElapsed = state.stopwatch.elapsedSeconds;

    // Calculate lap time (time since last lap, or total time if first lap)
    final lapTime = currentLaps.isEmpty
        ? currentElapsed
        : currentElapsed - currentLaps.last.elapsedSeconds;

    final newLap = Lap(
      lapNumber: lapNumber,
      elapsedSeconds: currentElapsed,
      lapSeconds: lapTime,
    );

    emit(state.copyWith(
      stopwatch: state.stopwatch.copyWith(
        laps: [...currentLaps, newLap],
      ),
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  StopwatchState? fromJson(Map<String, dynamic> json) {
    try {
      return StopwatchState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(StopwatchState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
