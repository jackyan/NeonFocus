import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/themes/glow_theme.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../shared/widgets/settings/theme_selector_widget.dart';
import '../../../../shared/widgets/settings/volume_control_widget.dart';

/// Stopwatch settings bottom sheet (covers half screen) - with state management
class StopwatchSettingsScreen extends StatefulWidget {
  final NeonTheme currentTheme;
  final Function(NeonTheme) onThemeChanged;
  final AudioService audioService;

  const StopwatchSettingsScreen({
    Key? key,
    required this.currentTheme,
    required this.onThemeChanged,
    required this.audioService,
  }) : super(key: key);

  @override
  State<StopwatchSettingsScreen> createState() => _StopwatchSettingsScreenState();
}

class _StopwatchSettingsScreenState extends State<StopwatchSettingsScreen> {
  late NeonTheme _selectedTheme;
  late double _effectVolume;
  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
    _effectVolume = widget.audioService.effectVolume;
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
                    l10n.stopwatchSettings,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedTheme.glowColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Sound Effects Section
                  _buildSectionTitle(l10n.soundEffects, _selectedTheme),
                  const SizedBox(height: 15),
                  
                  VolumeControlWidget(
                    label: l10n.effectVolume,
                    value: _effectVolume,
                    onChanged: (value) {
                      setState(() => _effectVolume = value);
                      widget.audioService.setEffectVolume(value);
                      _settingsService.setEffectVolume(value);
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
}
