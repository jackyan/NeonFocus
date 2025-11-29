import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../shared/widgets/settings/theme_selector_widget.dart';
import '../../../../shared/widgets/settings/volume_control_widget.dart';
import '../../../../shared/widgets/settings/settings_toggle_widget.dart';

/// Clock settings bottom sheet (covers half screen) - with state management
class ClockSettingsScreen extends StatefulWidget {
  final NeonTheme currentTheme;
  final Function(NeonTheme) onThemeChanged;
  final AudioService audioService;
  final VoidCallback? onSettingsChanged;

  const ClockSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.audioService,
    this.onSettingsChanged,
  }) : super(key: key);

  @override
  State<ClockSettingsScreen> createState() => _ClockSettingsScreenState();
}

class _ClockSettingsScreenState extends State<ClockSettingsScreen> {
  late NeonTheme _selectedTheme;
  late double _effectVolume;
  final SettingsService _settingsService = SettingsService();
  
  // Clock-specific settings
  late bool _showDate;
  late bool _showWeekday;
  late bool _showBattery;
  late bool _secondFlipSound;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
    _effectVolume = widget.audioService.effectVolume;
    
    // Load clock settings
    _showDate = _settingsService.getShowDate();
    _showWeekday = _settingsService.getShowWeekday();
    _showBattery = _settingsService.getShowBattery();
    _secondFlipSound = _settingsService.getSecondFlipSound();
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
                    l10n.clockSettings,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedTheme.glowColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Clock Section
                  _buildSectionTitle(l10n.clock, _selectedTheme),
                  const SizedBox(height: 15),
                  
                  SettingsToggleWidget(
                    label: l10n.showDate,
                    value: _showDate,
                    onChanged: (value) {
                      setState(() => _showDate = value);
                      _settingsService.setShowDate(value);
                      widget.onSettingsChanged?.call();
                    },
                    theme: _selectedTheme,
                  ),
                  
                  SettingsToggleWidget(
                    label: l10n.showWeekday,
                    value: _showWeekday,
                    onChanged: (value) {
                      setState(() => _showWeekday = value);
                      _settingsService.setShowWeekday(value);
                      widget.onSettingsChanged?.call();
                    },
                    theme: _selectedTheme,
                  ),
                  
                  SettingsToggleWidget(
                    label: l10n.showBattery,
                    value: _showBattery,
                    onChanged: (value) {
                      setState(() => _showBattery = value);
                      _settingsService.setShowBattery(value);
                      widget.onSettingsChanged?.call();
                    },
                    theme: _selectedTheme,
                  ),

                  const SizedBox(height: 30),

                  // Sound Effects Section
                  _buildSectionTitle(l10n.soundEffects, _selectedTheme),
                  const SizedBox(height: 15),
                  
                  SettingsToggleWidget(
                    label: l10n.secondFlipSound,
                    value: _secondFlipSound,
                    onChanged: (value) {
                      setState(() => _secondFlipSound = value);
                      _settingsService.setSecondFlipSound(value);
                      widget.onSettingsChanged?.call();
                    },
                    theme: _selectedTheme,
                  ),
                  const SizedBox(height: 15),
                  VolumeControlWidget(
                    label: l10n.effectVolume,
                    value: _effectVolume,
                    enabled: _secondFlipSound,
                    onChanged: _secondFlipSound ? (value) {
                      setState(() => _effectVolume = value);
                      widget.audioService.setEffectVolume(value);
                      _settingsService.setEffectVolume(value);
                    } : null,
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
}
