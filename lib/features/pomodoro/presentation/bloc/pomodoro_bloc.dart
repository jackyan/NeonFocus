import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/pomodoro_model.dart';
import 'pomodoro_event.dart';
import 'pomodoro_state.dart';

/// Pomodoro BLoC with data persistence
class PomodoroBloc extends HydratedBloc<PomodoroEvent, PomodoroState> {
  Timer? _timer;
  final NotificationService _notificationService = NotificationService();

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

  void _onCompleteSession(CompleteSession event, Emitter<PomodoroState> emit) async {
    _timer?.cancel();

    final currentSessionType = state.pomodoro.sessionType;
    final currentCompletedSessions = state.pomodoro.completedSessions;

    // Determine next session type and duration
    SessionType nextSessionType;
    int nextDuration;
    int newCompletedSessions = currentCompletedSessions;

    if (currentSessionType == SessionType.work) {
      // Work session completed, increment counter
      newCompletedSessions = currentCompletedSessions + 1;

      // Determine if it's time for long break (every 4 work sessions)
      if (newCompletedSessions % PomodoroConfig.sessionsBeforeLongBreak == 0) {
        nextSessionType = SessionType.longBreak;
        nextDuration = PomodoroConfig.longBreakDuration;
      } else {
        nextSessionType = SessionType.shortBreak;
        nextDuration = PomodoroConfig.shortBreakDuration;
      }

      // Send work completion notification
      await _notificationService.showPomodoroComplete(
        sessionNumber: newCompletedSessions,
        sessionType: 'work',
        durationMinutes: state.pomodoro.durationMinutes,
      );
    } else {
      // Break session completed, go back to work
      nextSessionType = SessionType.work;
      nextDuration = PomodoroConfig.workDuration;

      // Send break completion notification
      await _notificationService.showPomodoroComplete(
        sessionNumber: currentCompletedSessions,
        sessionType: currentSessionType == SessionType.shortBreak ? 'short_break' : 'long_break',
        durationMinutes: state.pomodoro.durationMinutes,
      );
    }

    // Auto-switch to next session
    emit(state.copyWith(
      pomodoro: Pomodoro(
        durationMinutes: nextDuration,
        remainingSeconds: nextDuration * 60,
        status: PomodoroStatus.idle,
        sessionType: nextSessionType,
        completedSessions: newCompletedSessions,
      ),
    ));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  @override
  PomodoroState? fromJson(Map<String, dynamic> json) {
    try {
      return PomodoroState.fromJson(json);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(PomodoroState state) {
    try {
      return state.toJson();
    } catch (_) {
      return null;
    }
  }
}
