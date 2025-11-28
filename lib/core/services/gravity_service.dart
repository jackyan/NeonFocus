import 'dart:async';
import 'dart:math' as math;
import 'package:sensors_plus/sensors_plus.dart';

/// Device orientation detected by gravity sensor
enum GravityOrientation {
  faceUp,
  faceDown,
  portrait,
  landscape,
  unknown,
}

/// Gravity sensor service for detecting device orientation
class GravityService {
  // Singleton instance
  static final GravityService _instance = GravityService._internal();
  factory GravityService() => _instance;
  GravityService._internal();

  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  GravityOrientation _currentOrientation = GravityOrientation.unknown;
  bool _isInitialized = false;

  // Callbacks
  final List<Function(GravityOrientation)> _orientationListeners = [];

  // Thresholds for orientation detection
  static const double _faceUpThreshold = 9.0; // m/s² (near gravity)
  static const double _faceDownThreshold = -9.0;
  static const double _tiltThreshold = 5.0; // Minimum tilt to detect orientation change

  /// Get current device orientation
  GravityOrientation get currentOrientation => _currentOrientation;

  /// Check if device is face up (on table)
  bool get isFaceUp => _currentOrientation == GravityOrientation.faceUp;

  /// Check if device is face down
  bool get isFaceDown => _currentOrientation == GravityOrientation.faceDown;

  /// Check if device is in portrait orientation
  bool get isPortrait => _currentOrientation == GravityOrientation.portrait;

  /// Check if device is in landscape orientation
  bool get isLandscape => _currentOrientation == GravityOrientation.landscape;

  /// Initialize gravity sensor
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _accelerometerSubscription = accelerometerEventStream().listen(
        _handleAccelerometerEvent,
        onError: (error) {
          print('Error reading accelerometer: $error');
        },
      );

      _isInitialized = true;
      print('GravityService initialized successfully');
    } catch (e) {
      print('Error initializing GravityService: $e');
    }
  }

  /// Handle accelerometer event and detect orientation
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    final x = event.x;
    final y = event.y;
    final z = event.z;

    // Calculate magnitude of acceleration
    final magnitude = math.sqrt(x * x + y * y + z * z);

    // Detect orientation based on gravity direction
    GravityOrientation newOrientation = GravityOrientation.unknown;

    // Check if device is face up (Z-axis pointing up)
    if (z > _faceUpThreshold && magnitude > 8.0 && magnitude < 12.0) {
      newOrientation = GravityOrientation.faceUp;
    }
    // Check if device is face down (Z-axis pointing down)
    else if (z < _faceDownThreshold && magnitude > 8.0 && magnitude < 12.0) {
      newOrientation = GravityOrientation.faceDown;
    }
    // Check if device is in portrait (Y-axis dominant)
    else if (y.abs() > _tiltThreshold && y.abs() > x.abs()) {
      newOrientation = GravityOrientation.portrait;
    }
    // Check if device is in landscape (X-axis dominant)
    else if (x.abs() > _tiltThreshold && x.abs() > y.abs()) {
      newOrientation = GravityOrientation.landscape;
    }

    // Only notify if orientation changed
    if (newOrientation != _currentOrientation &&
        newOrientation != GravityOrientation.unknown) {
      _currentOrientation = newOrientation;
      _notifyListeners(newOrientation);
    }
  }

  /// Add orientation change listener
  void addOrientationListener(Function(GravityOrientation) callback) {
    if (!_orientationListeners.contains(callback)) {
      _orientationListeners.add(callback);
    }
  }

  /// Remove orientation change listener
  void removeOrientationListener(Function(GravityOrientation) callback) {
    _orientationListeners.remove(callback);
  }

  /// Notify all listeners of orientation change
  void _notifyListeners(GravityOrientation orientation) {
    for (var listener in _orientationListeners) {
      try {
        listener(orientation);
      } catch (e) {
        print('Error notifying orientation listener: $e');
      }
    }
  }

  /// Dispose resources
  void dispose() {
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
    _orientationListeners.clear();
    _isInitialized = false;
  }
}
