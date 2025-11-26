import 'dart:async';
import 'dart:math' as math;

/// Burn-in protection service for OLED displays
/// Shifts content slightly to prevent static images
class BurninProtectionService {
  // Singleton instance
  static final BurninProtectionService _instance =
      BurninProtectionService._internal();
  factory BurninProtectionService() => _instance;
  BurninProtectionService._internal();

  Timer? _shiftTimer;
  bool _isActive = false;
  double _offsetX = 0.0;
  double _offsetY = 0.0;

  // Configuration
  static const Duration _shiftInterval = Duration(minutes: 5);
  static const double _maxOffset = 10.0; // Maximum pixel shift

  // Callbacks
  final List<Function(double x, double y)> _offsetListeners = [];

  /// Get current X offset
  double get offsetX => _offsetX;

  /// Get current Y offset
  double get offsetY => _offsetY;

  /// Check if burn-in protection is active
  bool get isActive => _isActive;

  /// Start burn-in protection
  void start() {
    if (_isActive) return;

    _isActive = true;
    _shiftTimer = Timer.periodic(_shiftInterval, (_) {
      _shiftContent();
    });

    print('Burn-in protection started');
  }

  /// Stop burn-in protection
  void stop() {
    if (!_isActive) return;

    _isActive = false;
    _shiftTimer?.cancel();
    _shiftTimer = null;

    // Reset to center position
    _updateOffset(0.0, 0.0);

    print('Burn-in protection stopped');
  }

  /// Shift content by random offset
  void _shiftContent() {
    final random = math.Random();

    // Generate random offset within range
    final newX = (random.nextDouble() * 2 - 1) * _maxOffset;
    final newY = (random.nextDouble() * 2 - 1) * _maxOffset;

    _updateOffset(newX, newY);
  }

  /// Update offset and notify listeners
  void _updateOffset(double x, double y) {
    _offsetX = x;
    _offsetY = y;
    _notifyListeners(x, y);
  }

  /// Add offset change listener
  void addOffsetListener(Function(double x, double y) callback) {
    if (!_offsetListeners.contains(callback)) {
      _offsetListeners.add(callback);
    }
  }

  /// Remove offset change listener
  void removeOffsetListener(Function(double x, double y) callback) {
    _offsetListeners.remove(callback);
  }

  /// Notify all listeners of offset change
  void _notifyListeners(double x, double y) {
    for (var listener in _offsetListeners) {
      try {
        listener(x, y);
      } catch (e) {
        print('Error notifying offset listener: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    stop();
    _offsetListeners.clear();
  }
}
