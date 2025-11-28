import 'package:equatable/equatable.dart';

/// Stopwatch timer states
enum StopwatchStatus {
  idle,
  running,
  paused,
}

/// Lap entry
class Lap extends Equatable {
  final int lapNumber;
  final int elapsedSeconds; // Total elapsed time at this lap
  final int lapSeconds; // Time for this lap only

  const Lap({
    required this.lapNumber,
    required this.elapsedSeconds,
    required this.lapSeconds,
  });

  /// Create from JSON
  factory Lap.fromJson(Map<String, dynamic> json) {
    return Lap(
      lapNumber: json['lapNumber'] as int,
      elapsedSeconds: json['elapsedSeconds'] as int,
      lapSeconds: json['lapSeconds'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'lapNumber': lapNumber,
      'elapsedSeconds': elapsedSeconds,
      'lapSeconds': lapSeconds,
    };
  }

  @override
  List<Object?> get props => [lapNumber, elapsedSeconds, lapSeconds];
}

/// Stopwatch model
class Stopwatch extends Equatable {
  final int elapsedSeconds;
  final StopwatchStatus status;
  final List<Lap> laps;

  const Stopwatch({
    required this.elapsedSeconds,
    required this.status,
    required this.laps,
  });

  factory Stopwatch.initial() {
    return const Stopwatch(
      elapsedSeconds: 0,
      status: StopwatchStatus.idle,
      laps: [],
    );
  }

  Stopwatch copyWith({
    int? elapsedSeconds,
    StopwatchStatus? status,
    List<Lap>? laps,
  }) {
    return Stopwatch(
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      status: status ?? this.status,
      laps: laps ?? this.laps,
    );
  }

  // Getters
  bool get isRunning => status == StopwatchStatus.running;
  bool get isPaused => status == StopwatchStatus.paused;
  bool get isIdle => status == StopwatchStatus.idle;

  int get hours => (elapsedSeconds / 3600).floor();
  int get minutes => ((elapsedSeconds % 3600) / 60).floor();
  int get seconds => elapsedSeconds % 60;

  /// Create from JSON
  factory Stopwatch.fromJson(Map<String, dynamic> json) {
    return Stopwatch(
      elapsedSeconds: json['elapsedSeconds'] as int,
      status: StopwatchStatus.values[json['status'] as int],
      laps: (json['laps'] as List<dynamic>)
          .map((lap) => Lap.fromJson(lap as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'elapsedSeconds': elapsedSeconds,
      'status': status.index,
      'laps': laps.map((lap) => lap.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [
        elapsedSeconds,
        status,
        laps,
      ];
}
