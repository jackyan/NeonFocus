import 'dart:async';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

/// Charging mode service for battery-aware features
class ChargingService {
  // Singleton instance
  static final ChargingService _instance = ChargingService._internal();
  factory ChargingService() => _instance;
  ChargingService._internal();

  final Battery _battery = Battery();

  StreamSubscription<BatteryState>? _batteryStateSubscription;
  bool _isCharging = false;
  int _batteryLevel = 100;
  bool _isSimulator = false;
  bool _hasLoggedSimulatorWarning = false;

  // Callbacks
  final List<Function(bool isCharging)> _chargingListeners = [];
  final List<Function(int level)> _batteryLevelListeners = [];

  /// Get current charging status
  bool get isCharging => _isCharging;

  /// Get current battery level (0-100)
  int get batteryLevel => _batteryLevel;

  /// Check if it's night time (23:00-06:00)
  bool get isNightTime {
    final hour = DateTime.now().hour;
    return hour >= 23 || hour < 6;
  }

  /// Initialize charging detection
  Future<void> initialize() async {
    // Get initial battery level
    try {
      _batteryLevel = await _battery.batteryLevel;
    } catch (e) {
      // On simulator/emulator, battery API is not available
      // Use default value and continue normally
      _isSimulator = true;
      if (!_hasLoggedSimulatorWarning) {
        debugPrint('ℹ️ Running on simulator/emulator - using default battery values (100%)');
        _hasLoggedSimulatorWarning = true;
      }
      _batteryLevel = 100; // Default to full
    }

    // Get initial charging state
    try {
      final state = await _battery.batteryState;
      _isCharging = state == BatteryState.charging || state == BatteryState.full;
    } catch (e) {
      // On simulator/emulator, battery state is not available
      // Use default value and continue normally
      _isCharging = false;
    }

    // Listen to battery state changes (only on real devices)
    if (!_isSimulator) {
      _batteryStateSubscription = _battery.onBatteryStateChanged.listen((state) {
        final wasCharging = _isCharging;
        _isCharging = state == BatteryState.charging || state == BatteryState.full;

        if (wasCharging != _isCharging) {
          _notifyChargingListeners(_isCharging);
        }

        // Update battery level when state changes
        _updateBatteryLevel();
      }, onError: (error) {
        // Handle stream errors gracefully (common on simulators)
        if (!_hasLoggedSimulatorWarning) {
          debugPrint('ℹ️ Battery monitoring unavailable on simulator/emulator');
          _hasLoggedSimulatorWarning = true;
        }
      });

      // Periodic battery level updates (only on real devices)
      Timer.periodic(const Duration(minutes: 1), (_) {
        _updateBatteryLevel();
      });
    }
  }

  /// Update battery level
  Future<void> _updateBatteryLevel() async {
    // Skip updates on simulator
    if (_isSimulator) return;

    try {
      final level = await _battery.batteryLevel;
      if (level != _batteryLevel) {
        _batteryLevel = level;
        _notifyBatteryLevelListeners(level);
      }
    } catch (e) {
      // Silently fail on simulators/emulators where battery API is unavailable
      // This is expected behavior on iOS Simulator and Android Emulator
      // The app will use default values (100%) and continue working normally
    }
  }

  /// Add charging status listener
  void addChargingListener(Function(bool isCharging) callback) {
    if (!_chargingListeners.contains(callback)) {
      _chargingListeners.add(callback);
    }
  }

  /// Remove charging status listener
  void removeChargingListener(Function(bool isCharging) callback) {
    _chargingListeners.remove(callback);
  }

  /// Add battery level listener
  void addBatteryLevelListener(Function(int level) callback) {
    if (!_batteryLevelListeners.contains(callback)) {
      _batteryLevelListeners.add(callback);
    }
  }

  /// Remove battery level listener
  void removeBatteryLevelListener(Function(int level) callback) {
    _batteryLevelListeners.remove(callback);
  }

  /// Notify charging listeners
  void _notifyChargingListeners(bool isCharging) {
    for (var listener in _chargingListeners) {
      try {
        listener(isCharging);
      } catch (e) {
        print('Error notifying charging listener: $e');
      }
    }
  }

  /// Notify battery level listeners
  void _notifyBatteryLevelListeners(int level) {
    for (var listener in _batteryLevelListeners) {
      try {
        listener(level);
      } catch (e) {
        print('Error notifying battery level listener: $e');
      }
    }
  }

  /// Get estimated time to full charge (in minutes)
  /// This is a simple estimation based on current battery level
  int getEstimatedTimeToFull() {
    if (!_isCharging) return 0;
    if (_batteryLevel >= 100) return 0;

    // Rough estimation: 1% per minute (adjustable based on device)
    final remainingPercent = 100 - _batteryLevel;
    return remainingPercent; // Returns minutes
  }

  /// Format time remaining
  String getFormattedTimeRemaining() {
    final minutes = getEstimatedTimeToFull();
    if (minutes == 0) return 'Full';

    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = (minutes / 60).floor();
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hr';
      }
      return '$hours hr $remainingMinutes min';
    }
  }

  /// Get recommended brightness for charging mode
  double getRecommendedBrightness() {
    if (!_isCharging) return 1.0;
    if (isNightTime) return 0.1; // Very dim at night
    return 0.3; // Dimmed during day
  }

  /// Dispose resources
  void dispose() {
    _batteryStateSubscription?.cancel();
    _chargingListeners.clear();
    _batteryLevelListeners.clear();
  }
}
