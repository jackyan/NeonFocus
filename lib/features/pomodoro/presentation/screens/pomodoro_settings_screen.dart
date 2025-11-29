import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../shared/widgets/settings/theme_selector_widget.dart';
import '../../../../shared/widgets/settings/volume_control_widget.dart';
import '../../../../shared/widgets/settings/settings_toggle_widget.dart';

/// Pomodoro settings bottom sheet (covers half screen) - with state management
class PomodoroSettingsScreen extends StatefulWidget {
  final NeonTheme currentTheme;
  final bool autoStart;
  final bool vibration;
  final bool gravityEnabled;
  final Function(bool) onAutoStartToggle;
  final Function(bool) onVibrationToggle;
  final Function(bool) onGravityToggle;
  final Function(NeonTheme) onThemeChanged;
  final AudioService audioService;
  final Ambience currentAmbience;
  final Function(Ambience) onAmbienceChanged;
  final VoidCallback? onSettingsChanged;

  const PomodoroSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.autoStart,
    required this.vibration,
    required this.gravityEnabled,
    required this.onAutoStartToggle,
    required this.onVibrationToggle,
    required this.onGravityToggle,
    required this.onThemeChanged,
    required this.audioService,
    required this.currentAmbience,
    required this.onAmbienceChanged,
    this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<PomodoroSettingsScreen> createState() => _PomodoroSettingsScreenState();
}

class _PomodoroSettingsScreenState extends State<PomodoroSettingsScreen> {
  late bool _autoStart;
  late bool _vibration;
  late bool _gravityEnabled;
  late NeonTheme _selectedTheme;
  late double _effectVolume;
  late double _ambienceVolume;
  late Ambience _selectedAmbience;
  final SettingsService _settingsService = SettingsService();
  
  // Sound effects toggle
  late bool _soundEffectsEnabled;

  @override
  void initState() {
    super.initState();
    _autoStart = widget.autoStart;
    _vibration = widget.vibration;
    _gravityEnabled = widget.gravityEnabled;
    _selectedTheme = widget.currentTheme;
    _effectVolume = widget.audioService.effectVolume;
    _ambienceVolume = widget.audioService.ambienceVolume;
    _selectedAmbience = widget.currentAmbience;
    
    // Load sound effects setting
    _soundEffectsEnabled = _settingsService.getSoundEffectsEnabled();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.5, // Half screen
      decoration: BoxDecoration(
        color: const Color(0xFF0A0E27),
        borderRadius: BorderRadius.circular(20), // All corners rounded
        border: Border.all(
          color: _selectedTheme.glowColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    l10n.timerSettings,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedTheme.glowColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Pomodoro Section
                  _buildSectionTitle(l10n.pomodoro, _selectedTheme),
                  const SizedBox(height: 15),
                  SettingsToggleWidget(
                    label: l10n.autoStart,
                    value: _autoStart,
                    onChanged: (value) {
                      setState(() => _autoStart = value);
                      widget.onAutoStartToggle(value);
                      _settingsService.setAutoStart(value);
                    },
                    theme: _selectedTheme,
                  ),
                  SettingsToggleWidget(
                    label: l10n.vibrationAlert,
                    value: _vibration,
                    onChanged: (value) {
                      setState(() => _vibration = value);
                      widget.onVibrationToggle(value);
                      _settingsService.setVibration(value);
                    },
                    theme: _selectedTheme,
                  ),
                  SettingsToggleWidget(
                    label: l10n.gravityInteraction,
                    subtitle: l10n.gravityInteractionSubtitle,
                    value: _gravityEnabled,
                    onChanged: (value) {
                      setState(() => _gravityEnabled = value);
                      widget.onGravityToggle(value);
                      _settingsService.setGravityEnabled(value);
                    },
                    theme: _selectedTheme,
                  ),

                  const SizedBox(height: 30),

                  // Sound Effects Section
                  _buildSectionTitle(l10n.soundEffects, _selectedTheme),
                  const SizedBox(height: 15),
                  SettingsToggleWidget(
                    label: l10n.secondFlipSound,
                    value: _soundEffectsEnabled,
                    onChanged: (value) {
                      setState(() => _soundEffectsEnabled = value);
                      _settingsService.setSoundEffectsEnabled(value);
                      widget.onSettingsChanged?.call();
                    },
                    theme: _selectedTheme,
                  ),
                  const SizedBox(height: 15),
                  VolumeControlWidget(
                    label: l10n.effectVolume,
                    value: _effectVolume,
                    enabled: _soundEffectsEnabled,
                    onChanged: _soundEffectsEnabled ? (value) {
                      setState(() => _effectVolume = value);
                      widget.audioService.setEffectVolume(value);
                      _settingsService.setEffectVolume(value);
                    } : null,
                    theme: _selectedTheme,
                  ),

                  const SizedBox(height: 30),

                  // Ambient Sound Section
                  _buildSectionTitle(l10n.ambientSound, _selectedTheme),
                  const SizedBox(height: 15),
                  _buildAmbienceSelector(),
                  const SizedBox(height: 15),
                  if (_selectedAmbience != Ambience.none)
                    VolumeControlWidget(
                      label: l10n.ambienceVolume,
                      value: _ambienceVolume,
                      onChanged: (value) {
                        setState(() => _ambienceVolume = value);
                        widget.audioService.setAmbienceVolume(value);
                        _settingsService.setAmbienceVolume(value);
                      },
                      theme: _selectedTheme,
                    ),

                  const SizedBox(height: 30),

                  // Theme Section
                  _buildSectionTitle(l10n.theme, _selectedTheme),
                  const SizedBox(height: 15),
                  ThemeSelectorWidget(
                    currentTheme: _selectedTheme,
                    onThemeChanged: (theme) {
                      setState(() => _selectedTheme = theme);
                      widget.onThemeChanged(theme);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, NeonTheme theme) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: theme.glowColor.withOpacity(0.7),
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildAmbienceSelector() {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: Ambience.values.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final l10n = AppLocalizations.of(context)!;
          final ambience = Ambience.values[index];
          final isSelected = ambience == _selectedAmbience;
          final isPremium = ambience.isPremium;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedAmbience = ambience);
              widget.onAmbienceChanged(ambience);
              if (ambience != Ambience.none) {
                widget.audioService.startAmbience(ambience);
              } else {
                widget.audioService.stopAmbience();
              }
            },
            child: Container(
              width: 90,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _selectedTheme.backgroundColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? _selectedTheme.glowColor
                      : _selectedTheme.glowColor.withOpacity(0.3),
                  width: isSelected ? 3 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: _selectedTheme.glowColor.withOpacity(0.5),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getAmbienceIcon(ambience),
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAmbienceName(ambience, l10n),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isPremium)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRO',
                        style: TextStyle(
                          fontSize: 8,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getAmbienceName(Ambience ambience, AppLocalizations l10n) {
    switch (ambience) {
      case Ambience.none:
        return l10n.none;
      case Ambience.rain:
        return l10n.rain;
      case Ambience.cafe:
        return l10n.cafe;
      case Ambience.whiteNoise:
        return l10n.whiteNoise;
      case Ambience.forest:
        return l10n.forest;
      case Ambience.ocean:
        return l10n.ocean;
      case Ambience.lofi:
        return l10n.lofi;
    }
  }

  IconData _getAmbienceIcon(Ambience ambience) {
    switch (ambience) {
      case Ambience.none:
        return Icons.volume_off_outlined;
      case Ambience.rain:
        return Icons.water_drop_outlined;
      case Ambience.cafe:
        return Icons.local_cafe_outlined;
      case Ambience.whiteNoise:
        return Icons.graphic_eq_outlined;
      case Ambience.forest:
        return Icons.park_outlined;
      case Ambience.ocean:
        return Icons.waves_outlined;
      case Ambience.lofi:
        return Icons.music_note_outlined;
    }
  }
}
