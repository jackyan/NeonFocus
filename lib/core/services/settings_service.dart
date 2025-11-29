import 'package:shared_preferences/shared_preferences.dart';

/// Settings persistence service using SharedPreferences
class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  SharedPreferences? _prefs;

  /// Initialize the service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('SettingsService not initialized. Call initialize() first.');
    }
    return _prefs!;
  }

  // ==================== Clock Settings ====================
  
  bool getShowDate() => prefs.getBool('clock_show_date') ?? false;
  Future<void> setShowDate(bool value) => prefs.setBool('clock_show_date', value);

  bool getShowWeekday() => prefs.getBool('clock_show_weekday') ?? false;
  Future<void> setShowWeekday(bool value) => prefs.setBool('clock_show_weekday', value);

  bool getShowBattery() => prefs.getBool('clock_show_battery') ?? false;
  Future<void> setShowBattery(bool value) => prefs.setBool('clock_show_battery', value);

  bool getSecondFlipSound() => prefs.getBool('clock_second_flip_sound') ?? false;
  Future<void> setSecondFlipSound(bool value) => prefs.setBool('clock_second_flip_sound', value);

  // ==================== Pomodoro Settings ====================
  
  bool getAutoStart() => prefs.getBool('pomodoro_auto_start') ?? false;
  Future<void> setAutoStart(bool value) => prefs.setBool('pomodoro_auto_start', value);

  bool getVibration() => prefs.getBool('pomodoro_vibration') ?? true;
  Future<void> setVibration(bool value) => prefs.setBool('pomodoro_vibration', value);

  bool getGravityEnabled() => prefs.getBool('pomodoro_gravity_enabled') ?? true;
  Future<void> setGravityEnabled(bool value) => prefs.setBool('pomodoro_gravity_enabled', value);

  bool getSoundEffectsEnabled() => prefs.getBool('pomodoro_sound_effects_enabled') ?? true;
  Future<void> setSoundEffectsEnabled(bool value) => prefs.setBool('pomodoro_sound_effects_enabled', value);

  String getCurrentAmbience() => prefs.getString('pomodoro_current_ambience') ?? 'none';
  Future<void> setCurrentAmbience(String value) => prefs.setString('pomodoro_current_ambience', value);

  // ==================== Common Settings ====================
  
  String getCurrentTheme() => prefs.getString('current_theme') ?? 'cyber_blue';
  Future<void> setCurrentTheme(String themeId) => prefs.setString('current_theme', themeId);

  double getEffectVolume() => prefs.getDouble('effect_volume') ?? 0.5;
  Future<void> setEffectVolume(double value) => prefs.setDouble('effect_volume', value);

  double getAmbienceVolume() => prefs.getDouble('ambience_volume') ?? 0.7;
  Future<void> setAmbienceVolume(double value) => prefs.setDouble('ambience_volume', value);

  // ==================== Stopwatch Settings ====================
  
  // Currently no specific stopwatch settings, but can be added here

  // ==================== Utility Methods ====================
  
  /// Clear all settings (for testing or reset)
  Future<void> clearAll() => prefs.clear();

  /// Check if this is first launch
  bool isFirstLaunch() => prefs.getBool('first_launch') ?? true;
  Future<void> setFirstLaunch(bool value) => prefs.setBool('first_launch', value);
}
