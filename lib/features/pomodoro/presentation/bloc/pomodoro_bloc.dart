import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/pomodoro_model.dart';
import 'pomodoro_event.dart';
import 'pomodoro_state.dart';

/// Pomodoro BLoC
class PomodoroBloc extends Bloc<PomodoroEvent, PomodoroState> {
  Timer? _timer;

  PomodoroBloc() : super(PomodoroState.initial()) {
    on<StartPomodoro>(_onStart);
    on<PausePomodoro>(_onPause);
    on<ResumePomodoro>(_onResume);
    on<ResetPomodoro>(_onReset);
    on<TickPomodoro>(_onTick);
    on<ChangeDuration>(_onChangeDuration);
    on<CompleteSession>(_onCompleteSession);
  }

  void _onStart(StartPomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickPomodoro());
    });

    emit(state.copyWith(
      pomodoro: state.pomodoro.copyWith(
        status: PomodoroStatus.running,
      ),
    ));
  }

  void _onPause(PausePomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      pomodoro: state.pomodoro.copyWith(
        status: PomodoroStatus.paused,
      ),
    ));
  }

  void _onResume(ResumePomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const TickPomodoro());
    });

    emit(state.copyWith(
      pomodoro: state.pomodoro.copyWith(
        status: PomodoroStatus.running,
      ),
    ));
  }

  void _onReset(ResetPomodoro event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(PomodoroState(
      pomodoro: Pomodoro.initial(
        durationMinutes: state.pomodoro.durationMinutes,
      ),
    ));
  }

  void _onTick(TickPomodoro event, Emitter<PomodoroState> emit) {
    if (state.pomodoro.remainingSeconds > 0) {
      emit(state.copyWith(
        pomodoro: state.pomodoro.copyWith(
          remainingSeconds: state.pomodoro.remainingSeconds - 1,
        ),
      ));
    } else {
      _timer?.cancel();
      add(const CompleteSession());
    }
  }

  void _onChangeDuration(ChangeDuration event, Emitter<PomodoroState> emit) {
    emit(state.copyWith(
      pomodoro: Pomodoro.initial(durationMinutes: event.durationMinutes),
    ));
  }

  void _onCompleteSession(CompleteSession event, Emitter<PomodoroState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      pomodoro: state.pomodoro.copyWith(
        status: PomodoroStatus.completed,
        completedSessions: state.pomodoro.completedSessions + 1,
      ),
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
